using System;
using System.Collections.Generic;
//using System.Linq;
//using System.Text;
using Game.Base.Packets;
using Game.Server.Managers;
using Game.Server.GameObjects;
//using Game.Server.GameUtils;
using Bussiness;
using SqlDataProvider.Data;

namespace Game.Server.Packets.Client
{
    [PacketHandler((byte)ePackageType.CARDS_SLOT, "场景用户离开")]
    public class CardSlotHandler : IPacketHandler
    {
        public int HandlePacket(GameClient client, GSPacketIn packet)
        {
            int type = packet.ReadInt();//_loc_2.writeInt(0);UpdateSLOT            
                                        //_loc_2.writeInt(1);ResetCardSoul
            int place = packet.ReadInt();// _loc_2.writeInt(param1); Place
            int soulPoint = packet.ReadInt();// _loc_2.writeInt(param1); soulPoint
            //Console.WriteLine("--place:" + place + "soulPoint: " + soulPoint);
            string msg = "";// LanguageMgr.GetTranslation("UpdateSLOT.Fail");
            List<UsersCardInfo> cardSlots = client.Player.CardBag.GetItems(0, 5);
            switch (type)
            {
                case 0://UpdateSLOT      
                    {
                        //if (soulPoint >= 50)
                        //{
                            int s_type = cardSlots[place].Type;
                            int totalGp = cardSlots[place].CardGP + soulPoint;
                            int lv = CardMgr.GetLevel(totalGp, s_type);
                            int needGp = CardMgr.GetGP(lv, s_type) - cardSlots[place].CardGP;
                            if (lv == 40)
                            {
                                soulPoint = needGp;
                            }
                            client.Player.CardBag.UpGraceSlot(soulPoint, lv, place);
                            client.Player.RemoveCardSoul(soulPoint);
                            client.Player.Out.SendPlayerCardSlot(client.Player.PlayerCharacter, cardSlots[place]);
                            client.Player.MainBag.UpdatePlayerProperties();
                        //}
                        //else
                        //{
                        //    client.Out.SendMessage(eMessageType.Normal, msg);
                        //}
                        break;
                    }
                case 1://ResetCardSoul
                    {
                        if (client.Player.PlayerCharacter.Money >= 300)
                        {
                            int totalPoint = 0;
                            for (int index = 0; index < cardSlots.Count; index++)
                            {
                                totalPoint += cardSlots[index].CardGP;
                            }
                            client.Player.CardBag.ResetCardSoul();
                            client.Player.AddCardSoul(totalPoint);
                            msg = LanguageMgr.GetTranslation("UpdateSLOT.ResetComplete", totalPoint);
                            client.Player.RemoveMoney(300);
                            client.Player.Out.SendPlayerCardSlot(client.Player.PlayerCharacter, cardSlots);
                            client.Player.MainBag.UpdatePlayerProperties();
                        }
                        else
                        {
                            msg = ("Xu không đủ!");
                        }
                        //client.Out.SendMessage(eMessageType.Normal, msg);
                        break;
                    }
            }
            if (msg != "")
            {
                client.Out.SendMessage(eMessageType.Normal, msg);
            }
            return 0;
        }
    }
}
