using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Game.Server.GameObjects;
using Game.Base.Packets;
using Bussiness;
using Bussiness.Managers;
using SqlDataProvider.Data;
using Game.Server.Managers;
using Game.Server.GameUtils;
using System.Configuration;
using Game.Server.Statics;


namespace Game.Server.Packets.Client
{
    
    [PacketHandler((byte)ePackageType.ITEM_FUSION, "熔化")]
    public class ItemFusionHandler : IPacketHandler
    {       
           
        public int HandlePacket(GameClient client, GSPacketIn packet)
        {
            if (client.Player.PlayerCharacter.HasBagPassword && client.Player.PlayerCharacter.IsLocked)
            {
                client.Out.SendMessage(eMessageType.Normal, LanguageMgr.GetTranslation("Bag.Locked"));
                return 0;
            }
            
            int RequestType = packet.ReadByte();

            bool isBind = false;
            int mustGold = 0;
            bool result = false;
            ItemTemplateInfo rewardItem = null;

            StringBuilder str = new StringBuilder();
            int MinValid = int.MaxValue;
            List<ItemInfo> items = new List<ItemInfo>();
            List<ItemInfo> appendItems = new List<ItemInfo>();
            PlayerInventory storeBag = client.Player.StoreBag;
            ItemInfo tempitem = null;
            string beginProperty = null;
            string AddItem = "";
            /////////////
            int maxVali = 0;
            for (int i = 1; i < 5; i++)
            {
                
                ItemInfo info = storeBag.GetItemAt(i);
                if (info != null)
                {
                    if (items.Contains(info))
                    {
                        client.Out.SendMessage(eMessageType.Normal, "Bad Input 1");
                        return 1;
                    }
                    str.Append(string.Concat(info.ItemID, ":", info.TemplateID, ","));
                    items.Add(info);
                    if (info.ValidDate != 0)
                    {
                        if (info.ValidDate >= maxVali)
                        {
                            MinValid = info.ValidDate;
                        }
                    }
                    maxVali = info.ValidDate;
                }
            }

            //--------------------------------------
            switch (RequestType)
            {
                case 0://preview
                    {
                        isBind = false;
                        Dictionary<int, double> previewItemList = null;
                        previewItemList = FusionMgr.FusionPreview(items, appendItems, ref isBind);
                        if ((previewItemList != null) && (previewItemList.Count > 0))
                        {
                            if (previewItemList.Count != 0)
                            {
                                client.Out.SendFusionPreview(client.Player, previewItemList, isBind, MinValid);
                            }
                        }
                        else
                        {
                            client.Out.SendMessage(eMessageType.Normal, LanguageMgr.GetTranslation("ItemFusionHandler.ItemNotEnough"));
                        }
                        return 0;
                    }
                    //break;
                case 1://fusion
                    {                        
                        mustGold = 1600;
                        if (client.Player.PlayerCharacter.Gold < mustGold)
                        {
                            client.Out.SendMessage(eMessageType.ERROR, LanguageMgr.GetTranslation("ItemFusionHandler.NoMoney"));
                            return 0;
                        }
                        isBind = false;
                        result = false;
                        rewardItem = FusionMgr.Fusion(items, appendItems, ref isBind, ref result);
                    }
                    break;
            }
            int mainBag = client.Player.MainBag.FindFirstEmptySlot();
            int propBag = client.Player.PropBag.FindFirstEmptySlot();
            if ((mainBag == -1 && rewardItem.BagType == eBageType.MainBag) || (propBag == -1 && rewardItem.BagType == eBageType.PropBag))
            {
                client.Out.SendMessage(eMessageType.Normal, LanguageMgr.GetTranslation("UserChangeItemPlaceHandler.full"));
                return 0;
            }
            //----------------------------------------------
            if (rewardItem != null)
            {
                client.Player.RemoveGold(mustGold);
                for (int i = 1; i < 5; i++)
                {
                    ItemInfo stone = storeBag.GetItemAt(i);
                    if (stone.Count > 1)
                    {
                        stone.Count--;
                        storeBag.UpdateItem(stone);
                    }
                    else
                    {
                        storeBag.RemoveItem(stone);
                    }
                }
               
                if (result)
                {
                    str.Append(rewardItem.TemplateID + ",");
                    ItemInfo item = ItemInfo.CreateFromTemplate(rewardItem, 1, 105);
                    if (item == null)
                    {
                        return 0;
                    }
                    tempitem = item;
                    item.IsBinds = isBind;
                    item.ValidDate = MinValid;
                    client.Player.OnItemFusion(item.Template.FusionType);
                    client.Out.SendFusionResult(client.Player, result);
                    client.Out.SendMessage(eMessageType.Normal, LanguageMgr.GetTranslation("ItemFusionHandler.Succeed1") +" "+ item.Template.Name);
                    /*
                    if ((item.TemplateID >= 8300 && item.TemplateID <= 8999) || 
                        (item.TemplateID >= 9300 && item.TemplateID <= 9999) || 
                        (item.TemplateID >= 14300 && item.TemplateID <= 14999) || 
                        (item.TemplateID >= 7024 && item.TemplateID <= 7028) || 
                        (item.TemplateID >= 14006 && item.TemplateID <= 14010) || 
                        (item.TemplateID >= 17000 && item.TemplateID <= 17010))
                    {
                        string msg = LanguageMgr.GetTranslation("ItemFusionHandler.Notice", client.Player.PlayerCharacter.NickName, item.Template.Name);
                        GSPacketIn pkg1 = new GSPacketIn((byte)ePackageType.SYS_NOTICE);
                        pkg1.WriteInt(1);
                        pkg1.WriteString(msg);
                        GameServer.Instance.LoginServer.SendPacket(pkg1);
                        GamePlayer[] players = WorldMgr.GetAllPlayers();
                        foreach (GamePlayer p in players)
                        {
                            p.Out.SendTCP(pkg1);
                        }
                    }
                    */
                    if (!storeBag.AddItemTo(item, 0))
                    {                        
                        str.Append("NoPlace");
                        client.Out.SendMessage(eMessageType.Normal, LanguageMgr.GetTranslation(item.GetBagName()) + LanguageMgr.GetTranslation("ItemFusionHandler.NoPlace"));
                    }
                }
                else
                {
                    str.Append("false");
                    client.Out.SendFusionResult(client.Player, result);
                    client.Out.SendMessage(eMessageType.Normal, LanguageMgr.GetTranslation("ItemFusionHandler.Failed"));
                }
                LogMgr.LogItemAdd(client.Player.PlayerCharacter.ID, LogItemType.Fusion, beginProperty, tempitem, AddItem, Convert.ToInt32(result));
                //client.Player.SaveIntoDatabase();
            }
            else
            {
                client.Out.SendMessage(eMessageType.Normal, LanguageMgr.GetTranslation("ItemFusionHandler.NoCondition"));
            }
            return 0;
        }
    
    }
}
