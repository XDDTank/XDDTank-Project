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
    [PacketHandler((byte)ePackageType.MATE_ONLINE_TIME, "场景用户离开")]
    public class MateTimeHandler : IPacketHandler
    {
        public int HandlePacket(GameClient client, GSPacketIn packet)
        {
            int user_id = packet.ReadInt();
            GamePlayer player = Managers.WorldMgr.GetPlayerById(user_id);
            PlayerInfo info;
            if (player != null)
            {
                info = player.PlayerCharacter;               
            }
            else
            {
                using (PlayerBussiness pb = new PlayerBussiness())
                {
                    info = pb.GetUserSingleByUserID(user_id);                  
                   
                }
            }
            //GSPacketIn pkg = packet.Clone();
            GSPacketIn pkg = new GSPacketIn((byte)ePackageType.MATE_ONLINE_TIME, client.Player.PlayerCharacter.ID);
            pkg.WriteDateTime(info.LastDate);
            client.SendTCP(pkg);
            return 0;
        }
    }
}
