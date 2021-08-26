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
    [PacketHandler((byte)ePackageType.BATTLE_GROUND, "场景用户离开")]
    public class BattleGroundHandler : IPacketHandler
    {
        public int HandlePacket(GameClient client, GSPacketIn packet)
        {
            var cmd = packet.ReadByte();
             Console.WriteLine("BattleGoundPackageType: " + cmd.ToString());
            return 0;
        }
    }
}
