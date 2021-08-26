using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Game.Server.GameObjects;
using Game.Base.Packets;
using Bussiness.Managers;
using SqlDataProvider.Data;
using Game.Server.GameUtils;
using Bussiness;
using Game.Server.Statics;

namespace Game.Server.Packets.Client
{
    [PacketHandler((byte)ePackageType.CADDY_SELL_ALL_GOODS, "打开物品")]
    public class CaddyClearAllHandler : IPacketHandler
    {


        public int HandlePacket(GameClient client, GSPacketIn packet)
        {           
            //PlayerInventory arkBag = client.Player.CaddyBag;
            ////PlayerInventory propBag = client.Player.PropBag;
            //var count = 1;
            //int m_gold = 0;
            //int m_ddtMoney = 0;
            //string msg = "";
            //for (int i = 0; i < arkBag.Capalility; i++)
            //{
            //    ItemInfo item = arkBag.GetItemAt(i);
            //    if (item != null)
            //    {
            //        //count = item.Count;
            //        if (item.Template.ReclaimType == 1)
            //        {
            //            m_gold += count * item.Template.ReclaimValue;
            //            msg += LanguageMgr.GetTranslation("ItemReclaimHandler.Success2", m_gold);
            //        }
            //        if (item.Template.ReclaimType == 2)
            //        {
            //            m_ddtMoney += count * item.Template.ReclaimValue;
            //            msg += LanguageMgr.GetTranslation("ItemReclaimHandler.Success1", m_ddtMoney);
            //        }
            //        arkBag.RemoveItem(item);
            //    }

            //}
            
            //client.Player.BeginChanges();
            //client.Player.AddGold(m_gold);
            //client.Player.AddGiftToken(m_ddtMoney);
            //client.Player.CommitChanges();
            //client.Out.SendMessage(eMessageType.Normal, msg);
            return 1;
        }

    }
}
