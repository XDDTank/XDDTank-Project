using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Game.Server.GameObjects;
using Game.Base.Packets;

namespace Game.Server.Packets.Client
{
    [PacketHandler((int)ePackageType.ACTIVE_LOG, "FIGHTING_VIP")]
    public class ActiveLogHandler : IPacketHandler
    {
        public int HandlePacket(GameClient client, GSPacketIn packet)
        {
            string param1 = packet.ReadString();//_loc_4.writeUTF(param1);
            int param2 = packet.ReadInt();//_loc_4.writeInt(param2);
            int param3 = packet.ReadInt();//_loc_4.writeInt(param3);
            return 0;
        }
    }
}
