using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Game.Base.Packets;
using Bussiness;
using SqlDataProvider.Data;
using Game.Server.GameUtils;
using Game.Server.Managers;
using log4net;
using System.Reflection;

namespace Game.Server.Packets.Client
{
    [PacketHandler((byte)ePackageType.CHANGE_PLACE_GOODS, "改变物品位置")]
    public class UserChangeItemPlaceHandler : IPacketHandler
    {
        public int HandlePacket(GameClient client, GSPacketIn packet)
        {
            eBageType bagType = (eBageType)packet.ReadByte();//_loc_2.BagType
            int place = packet.ReadInt();//_loc_2.Place
            eBageType toBagType = (eBageType)packet.ReadByte();//BagInfo.STOREBAG
            int toPlace = packet.ReadInt();//_loc_3.index
            int count = packet.ReadInt();//
            bool isCount = packet.ReadBoolean();//_loc_7.writeBoolean(param6);

            PlayerInventory bag = client.Player.GetInventory(bagType);
            PlayerInventory toBag = client.Player.GetInventory(toBagType);
            ItemInfo item = bag.GetItemAt(place);
            if (count == -1)
            {
                return 0;
            }
            bag.BeginChanges();
            toBag.BeginChanges();
            try
            {


                if (toBagType == eBageType.Consortia)
                {
                    ConsortiaInfo info = ConsortiaMgr.FindConsortiaInfo(client.Player.PlayerCharacter.ConsortiaID);
                    if (info != null)
                    {
                        toBag.Capalility = info.StoreLevel * 10;
                    }
                }

                if (toPlace == -1)
                {
                    bool isFull = false;
                    if (bagType == toBagType && toBagType == eBageType.MainBag)
                    {
                        Console.WriteLine("UserChangeItemHandler : TakeOutItemEquip from place {0} to place {1}",place,toPlace);
                        toPlace = toBag.FindFirstEmptySlot();
                        if (!bag.MoveItem(place, toPlace, count))
                            isFull = true;

                    }
                    else
                    {
                        if (toBag.StackItemToAnother(item) || toBag.AddItem(item))
                        {
                            bag.TakeOutItem(item);
                            Console.WriteLine("UserChangeItemHandle : TakeOutItem with ID : {0} !",item.TemplateID);
                        }
                        else { isFull = true; }
                    }
                    if (isFull)
                    {
                        client.Out.SendMessage(eMessageType.ERROR, LanguageMgr.GetTranslation("UserChangeItemPlaceHandler.full"));                        
                    }
                }
                else if (bagType == toBagType)
                {
                    Console.WriteLine("UserChangeItemHandle : Move same Bag from place {0} to place {1} !",place,toPlace);
                    bag.MoveItem(place, toPlace, count);
                    //bag.MoveItem(place, 5, 1);
                    //client.Player.OnNewGearEvent(item.Template.CategoryID);
                    client.Out.SendMessage(eMessageType.Normal, "Chức năng đang xây dựng");

                }
                else if (bagType == eBageType.Store)
                {
                    MoveFromStore(client, bag, item, toPlace, toBag, count);
                    Console.WriteLine("UserChangeItemHandle : Move ItemID {0} from Store to place {1} to BageType {2} !",item.TemplateID,place,bagType);
                }
                else if (bagType == eBageType.Consortia)
                {
                    MoveFromBank(client, place, toPlace, bag, toBag, item);
                    Console.WriteLine("UserChangeItemHandle : Move from Bank!");
                }
                else if (bagType == eBageType.CaddyBag)
                {
                    Console.WriteLine("UserChangeItemHandle : Move from CaddyBag!");
                }
                else if (toBagType == eBageType.Store)
                {                    
                    MoveToStore(client, bag, item, toPlace, toBag, count);
                    Console.WriteLine("UserChangeItemHandle : Move ItemID {0} to Store!",item.TemplateID);
                }
                else if (toBagType == eBageType.Consortia)
                {
                    MoveToBank(place, toPlace, bag, toBag, item);
                    Console.WriteLine("UserChangeItemHandle : Move to Bank!");
                }
                else if (toBag.AddItemTo(item, toPlace))
                {
                    bag.TakeOutItem(item);
                    Console.WriteLine("UserChangeItemHandle : AddItemTo: " + toBag.BagType);
                }
            }
            finally
            {
                bag.CommitChanges();
                toBag.CommitChanges();
            }

            return 0;
        }

        //extend function

        public void MoveFromStore(GameClient client, PlayerInventory storeBag, ItemInfo item, int toSlot, PlayerInventory bag, int count)
        {
            if ((((client.Player != null && item != null) && storeBag != null) && bag != null)
                && ((int)item.Template.BagType == bag.BagType))
            {
                if ((toSlot < bag.BeginSlot) || (toSlot > bag.Capalility))
                {
                    if (bag.StackItemToAnother(item))
                    {
                        storeBag.RemoveItem(item, eItemRemoveType.Stack);
                        return;
                    }
                    string key = string.Format("temp_place_{0}", item.ItemID);
                    if (client.Player.TempProperties.ContainsKey(key))
                    {
                        toSlot = (int)storeBag.Player.TempProperties[key];
                        storeBag.Player.TempProperties.Remove(key);
                    }
                    else
                    {
                        toSlot = bag.FindFirstEmptySlot();
                    }
                }
                if (bag.StackItemToAnother(item) || bag.AddItemTo(item, toSlot))
                {
                    storeBag.TakeOutItem(item);
                }
                else
                {
                    storeBag.SaveToDatabase();
                    client.Player.SendItemToMail(item, LanguageMgr.GetTranslation("UserChangeItemPlaceHandler.full"), LanguageMgr.GetTranslation("UserChangeItemPlaceHandler.full"), eMailType.ItemOverdue);
                    client.Player.Out.SendMailResponse(client.Player.PlayerCharacter.ID, eMailRespose.Receiver);
                }
            }
        }
        //
        public void MoveToStore(GameClient client, PlayerInventory bag, ItemInfo item, int toSlot, PlayerInventory storeBag, int count)
        {
            if (((client.Player != null && bag != null) && item != null) 
                && storeBag != null)
            {
                string key;
                int oldplace = item.Place;
                ItemInfo toItem = storeBag.GetItemAt(toSlot);
                if (toItem != null)
                {
                    if (toItem.CanStackedTo(item))
                    {
                        return;
                    }
                    if (item.Count == 1 && item.BagType == toItem.BagType)
                    {
                        bag.TakeOutItem(item);
                        storeBag.TakeOutItem(toItem);
                        bag.AddItemTo(toItem, oldplace);
                        storeBag.AddItemTo(item, toSlot);
                        return;
                    }
                    key = string.Format("temp_place_{0}", toItem.ItemID);
                    PlayerInventory tb = client.Player.GetItemInventory(toItem.Template);
                    if (client.Player.TempProperties.ContainsKey(key) && (tb.BagType == 0))
                    {
                        int tempSlot = (int)client.Player.TempProperties[key];
                        client.Player.TempProperties.Remove(key);
                        if (tb.AddItemTo(toItem, tempSlot))
                        {
                            storeBag.TakeOutItem(toItem);
                        }
                    }
                    else if (tb.StackItemToAnother(toItem))
                    {
                        storeBag.RemoveItem(toItem, eItemRemoveType.Stack);
                    }
                    else if (tb.AddItem(toItem))
                    {
                        storeBag.TakeOutItem(toItem);
                    }
                    else
                    {
                        client.Player.Out.SendMessage(eMessageType.ERROR, LanguageMgr.GetTranslation("UserChangeItemPlaceHandler.full"));
                    }
                }
                if (storeBag.IsEmpty(toSlot))
                {
                    if (item.Count == 1)
                    {
                        if (storeBag.AddItemTo(item, toSlot))
                        {
                            bag.TakeOutItem(item);
                            if (item.Template.BagType == eBageType.MainBag && oldplace < 31)
                            {
                                key = string.Format("temp_place_{0}", item.ItemID);
                                if (client.Player.TempProperties.ContainsKey(key))
                                {
                                    client.Player.TempProperties[key] = oldplace;
                                }
                                else
                                {
                                    client.Player.TempProperties.Add(key, oldplace);
                                }
                            }
                        }
                    }
                    else
                    {
                        ItemInfo newItem = item.Clone();
                        newItem.Count = count;
                        if (bag.RemoveCountFromStack(item, count, eItemRemoveType.Stack) && !storeBag.AddItemTo(newItem, toSlot))
                        {
                            bag.AddCountToStack(item, count);
                        }
                    }
                }
            }
        }
        private static void MoveToBank(int place, int toplace, PlayerInventory bag, PlayerInventory bank, ItemInfo item)
        {
            if ((bag != null && item != null) && bag != null)
            {
                ItemInfo toItem = bank.GetItemAt(toplace);
                if (toItem != null)
                {
                    if (item.CanStackedTo(toItem) && ((item.Count + toItem.Count) <= item.Template.MaxCount))
                    {
                        if (bank.AddCountToStack(toItem, item.Count))
                        {
                            bag.RemoveItem(item, eItemRemoveType.Stack);
                        }
                    }
                    else if ((int)toItem.Template.BagType == bag.BagType)
                    {
                        bag.TakeOutItem(item);
                        bank.TakeOutItem(toItem);
                        bag.AddItemTo(toItem, place);
                        bank.AddItemTo(item, toplace);
                    }
                }
                else if (bank.AddItemTo(item, toplace))
                {
                    bag.TakeOutItem(item);
                }
            }
        }
        private static void MoveFromBank(GameClient client, int place, int toplace, PlayerInventory bag, PlayerInventory tobag, ItemInfo item)
        {
            if (item != null)
            {
                PlayerInventory tb = client.Player.GetItemInventory(item.Template);
                if (tb == tobag)
                {
                    ItemInfo toitem = tb.GetItemAt(toplace);
                    if (toitem == null)
                    {
                        if (tb.AddItemTo(item, toplace))
                        {
                            bag.TakeOutItem(item);
                        }
                    }
                    else if (item.CanStackedTo(toitem) && ((item.Count + toitem.Count) <= item.Template.MaxCount))
                    {
                        if (tb.AddCountToStack(toitem, item.Count))
                        {
                            bag.RemoveItem(item, eItemRemoveType.Stack);
                        }
                    }
                    else
                    {
                        tb.TakeOutItem(toitem);
                        bag.TakeOutItem(item);
                        tb.AddItemTo(item, toplace);
                        bag.AddItemTo(toitem, place);
                    }
                }
                else if (tb.AddItem(item))
                {
                    bag.TakeOutItem(item);
                }
            }
        }

        //end extend function

    }

}


