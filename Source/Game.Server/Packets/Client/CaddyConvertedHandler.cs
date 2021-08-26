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
    [PacketHandler((byte)ePackageType.CADDY_CONVERTED_ALL, "场景用户离开")]
    public class CaddyConvertedHandler : IPacketHandler
    {
        public int HandlePacket(GameClient client, GSPacketIn packet)
        {
            bool request = packet.ReadBoolean();
            int null1 = packet.ReadInt();
            int nuul2 = packet.ReadInt();
            return 0;
        }
    }
}
