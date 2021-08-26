using System;
using System.Collections.Generic;
//using System.Linq;
//using System.Text;
using Game.Base.Packets;
using Game.Server.GameObjects;
using Bussiness;
using SqlDataProvider.Data;

namespace Game.Server.Packets.Client
{
    [PacketHandler((byte)ePackageType.GET_PLAYER_CARD, "场景用户离开")]
    public class CardInfoHandler : IPacketHandler
    {
        public int HandlePacket(GameClient client, GSPacketIn packet)
        {
            int user_id = packet.ReadInt();            
            GamePlayer player = Managers.WorldMgr.GetPlayerById(user_id);
            PlayerInfo info;
            List<UsersCardInfo> cardSlots;
            if (player != null)
            {
                info = player.PlayerCharacter;
                cardSlots = player.CardBag.GetItems(0, 5);
                          
            }
            else
            {
                using (PlayerBussiness pb = new PlayerBussiness())
                {
                    info = pb.GetUserSingleByUserID(user_id);
                    cardSlots = pb.GetUserCardEuqip(user_id);
                    
                }
            }

            if (cardSlots != null)// && cards!=null)
            {                
                client.Player.Out.SendPlayerCardSlot(info, cardSlots);
                
            }
            return 0;
        }
    }
}
