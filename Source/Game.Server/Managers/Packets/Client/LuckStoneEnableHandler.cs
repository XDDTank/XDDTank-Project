using System;
//using System.Collections.Generic;
//using System.Linq;
//using System.Text;
using Game.Base.Packets;
//using Game.Server.Managers;
using Game.Server.GameObjects;
//using Game.Server.GameUtils;
//using Game.Server.Rooms;

namespace Game.Server.Packets.Client
{
    [PacketHandler((byte)ePackageType.LUCKSTONE_CONFIG, "场景用户离开")]
    public class LuckStoneEnableHandler : IPacketHandler
    {
        public int HandlePacket(GameClient client, GSPacketIn packet)
        {
            //GSPacketIn pkg = packet.Clone();
            //pkg.ClearContext();
            GSPacketIn pkg = new GSPacketIn((byte)ePackageType.LUCKSTONE_CONFIG, client.Player.PlayerCharacter.ID);
            pkg.WriteDateTime(DateTime.Now);//startDate = _loc_2.readDate();
            pkg.WriteDateTime(DateTime.Now.AddDays(7));//endDate = _loc_2.readDate();
            pkg.WriteBoolean(true);//isActiv = _loc_2.readBoolean();
            client.Out.SendTCP(pkg);
            return 0;
        }
    }
}
