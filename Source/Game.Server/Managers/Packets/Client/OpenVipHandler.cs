using System;
//using System.Collections.Generic;
//using System.Linq;
//using System.Text;
using Game.Base.Packets;
//using Game.Server.Managers;
using Game.Server.GameObjects;
//using Game.Server.GameUtils;
//using Game.Server.Rooms;
using Bussiness;
using SqlDataProvider.Data;

namespace Game.Server.Packets.Client
{
    [PacketHandler((byte)ePackageType.VIP_RENEWAL, "场景用户离开")]
    public class OpenVipHandler : IPacketHandler
    {
        public int HandlePacket(GameClient client, GSPacketIn packet)
        {

            string NickName = packet.ReadString();
            int reneval_days = packet.ReadInt();
            int money = 569;
            int ONE_MONTH_PAY = 569;
            int THREE_MONTH_PAY = 1707;
            int HALF_YEAR_PAY = 3000;
            string msg = "Parabéns <Jogador> aumentou seu vip para um nível";
            string msg1 = "Parabéns <Jogador> aumentou seu vip para um nív";

            switch (reneval_days)
            {
                case 30:
                    money = ONE_MONTH_PAY;
                        break;
                case 90:
                        money = THREE_MONTH_PAY;
                        break;
                case 180:
                        money = HALF_YEAR_PAY;
                    break;
            }

           
            GamePlayer player = Managers.WorldMgr.GetClientByPlayerNickName(NickName);
            if (money <= client.Player.PlayerCharacter.Money)
            {
                DateTime ExpireDayOut = DateTime.Now;
                using (PlayerBussiness db = new PlayerBussiness())
                {
                    db.VIPRenewal(NickName, reneval_days, ref ExpireDayOut);

                    if (player == null)
                    {
                        msg = "Próxima VIP grátis " + NickName + " além mês!";                       
                    }
                    else
                    {
                        if (client.Player.PlayerCharacter.NickName == NickName)
                        {
                            if (client.Player.PlayerCharacter.typeVIP == 0)
                            {
                                client.Player.OpenVIP(ExpireDayOut);
                            }
                            else
                            {
                                client.Player.ContinousVIP(ExpireDayOut);
                                msg = "Vip renovado com Sucesso!";
                            }
                            client.Out.SendOpenVIP(client.Player.PlayerCharacter);
                        }
                        else
                        {
                            if (player.PlayerCharacter.typeVIP == 0)
                            {
                                player.OpenVIP(ExpireDayOut);
                                msg = "Ativar VIP " + NickName + " além mês!";
                                msg1 = client.Player.PlayerCharacter.NickName + ", tiếp phí VIP cho bạn thàng công!";
                            }
                            else
                            {
                                player.ContinousVIP(ExpireDayOut);
                                msg = "Gia hạn VIP cho " + NickName + " thàng công!";
                                msg1 = client.Player.PlayerCharacter.NickName + ", gia hạn VIP cho bạn thàng công!";
                            }
                            player.Out.SendOpenVIP(player.PlayerCharacter);
                            player.Out.SendMessage(eMessageType.Normal, msg1);
                        }                        

                    }
                    client.Player.AddExpVip(money);
                    client.Player.RemoveMoney(money);
                    client.Out.SendMessage(eMessageType.Normal, msg);
                }
            }
            else
            {
                client.Out.SendMessage(eMessageType.Normal, LanguageMgr.GetTranslation("UserBuyItemHandler.Money"));
            }
            return 0;
        }
    }
}
