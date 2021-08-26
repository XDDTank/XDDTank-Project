using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Game.Base.Packets;
using Game.Server.Managers;
using Game.Server.GameObjects;
using Game.Server.GameUtils;
using Game.Server.Rooms;
using SqlDataProvider.Data;
using Game.Server.ChatServer;

namespace Game.Server.Packets.Client
{
    [PacketHandler((byte)ePackageType.DRAGON_BOAT, "DragonBoat")]
    public class DragonBoatHandler : IPacketHandler
    {
        public int HandlePacket(GameClient client, GSPacketIn packet)
        {
            int cmd = packet.ReadInt();
            switch (cmd)
            {
                case (byte)DragonBoatPackageType.START_OR_CLOSE:
                    Console.WriteLine("DragonBoatSystem : START_OR_CLOSE");
                    break;
                case (byte)DragonBoatPackageType.BUILD_DECORATE:
                    Console.WriteLine("DragonBoatSystem : BUILD_DECORATE");
                    break;
                case (byte)DragonBoatPackageType.REFRESH_BOAT_STATUS:
                    Console.WriteLine("DragonBoatSystem : REFRESH_BOAT_STATUS");
                    break;
                case (byte)DragonBoatPackageType.REFRESH_RANK:
                    Console.WriteLine("DragonBoatSystem : REFRESH_RANK");
                    break;
                case (byte)DragonBoatPackageType.REFRESH_RANK_OTHER:
                    Console.WriteLine("DragonBoatSystem : REFRESH_RANK_OTHER");
                    break;
                case (byte)DragonBoatPackageType.EXCHANGE:
                    Console.WriteLine("DragonBoatSystem : EXCHANGE");
                    break;
                default:
                    Console.WriteLine("DragonBoatSystem : DEFAULT_CASE");
                    break;
            }
            return 0;
        }
    }
}
