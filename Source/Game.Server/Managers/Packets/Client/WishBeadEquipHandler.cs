using System;
//using System.Collections.Generic;
//using System.Linq;
//using System.Text;
using Game.Base.Packets;
using Bussiness;
using SqlDataProvider.Data;
using Game.Server.GameUtils;
using Game.Server.Managers;
using Game.Server.Statics;
using Game.Server.GameObjects;
using Bussiness.Managers;

namespace Game.Server.Packets.Client
{
    [PacketHandler((byte)ePackageType.WISHBEADEQUIP, "场景用户离开")]
    public class WishBeadEquipHandler : IPacketHandler
    {
        public int HandlePacket(GameClient client, GSPacketIn packet)
        {

            int Place = packet.ReadInt();//param1.itemInfo.Place          
            int BagType = packet.ReadInt();//param1.itemInfo.BagType
            int TemplateID = packet.ReadInt();//param1.info.TemplateID

            int PlaceBead = packet.ReadInt();//_loc_3.Place           
            int BagTypeBead = packet.ReadInt();//_loc_3.BagType
            int BeadId = packet.ReadInt();//_loc_3.TemplateID

            //Console.WriteLine("--Item: " + TemplateID + "| Bead: " + BeadId);
            PlayerInventory inventory = client.Player.GetInventory((eBageType)BagType);
            ItemInfo Item = inventory.GetItemAt(Place);
            ItemInfo Bead = client.Player.GetItemAt((eBageType)BagTypeBead, PlaceBead);
            double probability = 5.0;
            ThreadSafeRandom random = new ThreadSafeRandom();

            GoldEquipTemplateLoadInfo goldEquip = GoldEquipMgr.FindGoldEquipTemplate(TemplateID);

            //GSPacketIn pkg = packet.Clone();
            //pkg.ClearContext();
            GSPacketIn pkg = new GSPacketIn((byte)ePackageType.WISHBEADEQUIP, client.Player.PlayerCharacter.ID);

            if (goldEquip == null && Item.Template.CategoryID == 7)
            {
                pkg.WriteInt(5);
            }
            else if (!Item.IsGold)
            {
                if (probability > random.Next(100))
                {
                    
                    Item.StrengthenLevel++;
                    Item.IsGold = true;
                    Item.goldBeginTime = DateTime.Now;
                    Item.goldValidDate = 30;
                    Item.IsBinds = true;

                    if (goldEquip != null && Item.Template.CategoryID == 7)
                    {
                        ItemTemplateInfo Temp = ItemMgr.FindItemTemplate(goldEquip.NewTemplateId);
                        if (Temp != null)
                        {
                            ItemInfo newItem = ItemInfo.CreateFromTemplate(Temp, 1, (int)ItemAddType.Strengthen);
                            newItem.StrengthenLevel = Item.StrengthenLevel;                            
                            newItem.IsGold = Item.IsGold;
                            newItem.goldBeginTime = Item.goldBeginTime;
                            newItem.goldValidDate = Item.goldValidDate;
                            newItem.IsBinds = Item.IsBinds;
                            ItemInfo.OpenHole(ref newItem);
                            StrengthenMgr.InheritProperty(Item, ref newItem);
                            inventory.RemoveItemAt(Place);
                            inventory.AddItemTo(newItem, Place);
                            Item = newItem;
                            
                        }
                    }
                    inventory.UpdateItem(Item);
                    pkg.WriteInt(0);
                    inventory.SaveToDatabase();//保存到数据库
                    
                }
                else
                {
                    pkg.WriteInt(1);
                }
                
                client.Player.RemoveTemplate(BeadId, 1);
                //client.Player.UpdateItem(Bead);                
            }
            else
            {
                pkg.WriteInt(6);
            }
            client.Out.SendTCP(pkg);
            //client.Player.BeginChanges();
            //client.Player.CommitChanges();
            return 0;
        }
    }
}
