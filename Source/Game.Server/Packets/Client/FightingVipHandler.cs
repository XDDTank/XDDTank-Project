using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Game.Server.GameObjects;
using Game.Base.Packets;

namespace Game.Server.Packets.Client
{
    [PacketHandler((int)ePackageType.FIGHTING_VIP, "FIGHTING_VIP")]
    public class FightingVipHandler : IPacketHandler
    {
        public int HandlePacket(GameClient client, GSPacketIn packet)
        {
            int _loc_4 = packet.ReadInt();//_loc_4.writeInt(param1);
            return 0;
        }
    }
}
