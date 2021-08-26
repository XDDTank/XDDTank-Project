using Bussiness;
using Bussiness.Managers;
using Game.Base.Packets;
using Game.Server;
using Game.Server.GameUtils;
using SqlDataProvider.Data;
using System;
using System.Collections.Generic;

namespace Game.Server.Packets.Client
{
    [PacketHandler((byte)ePackageType.EQUIP_RECYCLE_ITEM, "场景用户离开")]
    public class EquipRetrieveHandler : IPacketHandler
    {      
        public int HandlePacket(GameClient client, GSPacketIn packet)
        {            
            PlayerInventory inventory = client.Player.GetInventory(eBageType.Store);
            PlayerInventory propBag = client.Player.PropBag;
            int qmin = 1;
            int qmax = 2;
            int temp = 0;
            bool isBlind = false;
            for (int i = 1; i < 5; i++)
            {
                ItemInfo item = inventory.GetItemAt(i);
                if (item != null)
                {
                    inventory.RemoveItemAt(i);
                }
                if (item.IsBinds)
                {
                    isBlind = true;
                }
                
                temp += item.Template.Quality;

            }

            if (temp >= 9 && temp < 12)
                    qmax =  3;
            if (temp >= 12)// && temp < 15)
                    qmax =  4;
            //if (temp >= 15)
            //{
                //qmin = 2;
                //qmax = 5;
            //}
            //Console.WriteLine("quality: " + quality);
            List<ItemTemplateInfo> ItemTemplates = ItemMgr.FindRecycleItemTemplate(qmin, qmax);
            int ItemRandom = ThreadSafeRandom.NextStatic(ItemTemplates.Count);
            int templateID = ItemTemplates[ItemRandom].TemplateID;
            ItemInfo RecycleItem = ItemInfo.CreateFromTemplate(ItemMgr.FindItemTemplate(templateID), 1, 105);
            RecycleItem.IsBinds = isBlind;
            RecycleItem.BeginDate = DateTime.Now;
            if (RecycleItem.Template.CategoryID != 11)
            {
                RecycleItem.ValidDate = 30;
            }
            RecycleItem.RemoveDate = DateTime.Now.AddDays(30);

            inventory.AddItemTo(RecycleItem, 0);

            return 1;
        }
        
    }
}
