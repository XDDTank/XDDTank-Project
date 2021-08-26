using System;
//using System.Collections.Generic;
//using System.Linq;
//using System.Text;
using Game.Base.Packets;
using Bussiness;
using SqlDataProvider.Data;
//using System.Configuration;
//using Game.Server.Managers;
//using Game.Server.Statics;
using Game.Server.GameObjects;
//using Game.Server.GameUtils;
//using Game.Logic;

namespace Game.Server.Packets.Client
{
    [PacketHandler((byte)ePackageType.TEXP, "场景用户离开")]
    public class TexpHandler : IPacketHandler
    {
        public int HandlePacket(GameClient client, GSPacketIn packet)
        {

            int selectIndex = packet.ReadInt();//selectIndex    
            int TemplateID = packet.ReadInt();//_loc_2.TemplateID
            int Count = packet.ReadInt();//_loc_2.Count 
            int Place = packet.ReadInt();//_loc_2.Place 
            //Console.WriteLine("--Count: " + Count + ", Place:" + Place + ", selectIndex:" + selectIndex);
            ItemInfo item = client.Player.StoreBag.GetItemAt(Place);
            TexpInfo info = client.Player.PlayerCharacter.Texp;
            
            if (info.texpCount <= client.Player.PlayerCharacter.Grade)
            {
                if ((Count + info.texpCount) >= client.Player.PlayerCharacter.Grade)
                {
                    Count = client.Player.PlayerCharacter.Grade - info.texpCount;
                }
                switch (selectIndex)
                {
                    case 0: //hp
                        info.hpTexpExp += item.Template.Property2 * Count;
                        break;
                    case 1: //att
                        info.attTexpExp += item.Template.Property2 * Count;
                        break;
                    case 2: //def
                        info.defTexpExp += item.Template.Property2 * Count;
                        break;
                    case 3: //agi
                        info.spdTexpExp += item.Template.Property2 * Count;
                        break;
                    case 4: //luck
                        info.lukTexpExp += item.Template.Property2 * Count;
                        break;

                }
                info.texpCount += Count;
                info.texpTaskCount++;
                info.texpTaskDate = DateTime.Now;
                using (PlayerBussiness db = new PlayerBussiness())
                {
                    db.UpdateUserTexpInfo(info);
                }
                client.Player.PlayerCharacter.Texp = info;
                //client.Player.StoreBag2.RemoveItem(item);
                client.Player.StoreBag.RemoveTemplate(TemplateID, Count);
                client.Player.MainBag.UpdatePlayerProperties();
            }
            else
            {
                client.Out.SendMessage(eMessageType.Normal, LanguageMgr.GetTranslation("texpSystem.texpCountToplimit"));
            }
            return 0;
        }
    }
}
