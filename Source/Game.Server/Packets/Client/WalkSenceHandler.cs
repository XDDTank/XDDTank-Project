using System;
using Game.Base.Packets;
using Game.Server.GameObjects;
using Game.Server.Managers;

namespace Game.Server.Packets.Client
{
    [PacketHandler((byte)ePackageType.WALKSENCE_CMD, "场景用户离开")]
    public class WalkSenceHandler : IPacketHandler
    {
        public int HandlePacket(GameClient client, GSPacketIn packet)
        {
            int packetType = packet.ReadInt();

            client.Player.SendMessage("WalkSencePackageType : " + packetType);
            switch (packetType)
            {
                case (int)WalkSencePackageType.UPDATE_DUNGEONMODE_INFO:
                    Console.WriteLine("WalkSenceHandler : UPDATE_DUNGEONMODE_INFO");
                    break;
                case (int)WalkSencePackageType.REMOVE_CD:
                    Console.WriteLine("WalkSenceHandler : REMOVE_CD");
                    break;
                case (int)WalkSencePackageType.PLAYER_EXIT:
                    Console.WriteLine("WalkSenceHandler : PLAYER_EXIT");
                    break;
                case (int)WalkSencePackageType.OBJECT_CLICK:
                    Console.WriteLine("WalkSenceHandler : OBJECT_CLICK");
                    break;
                case (int)WalkSencePackageType.PLAYER_MOVE:
                    Console.WriteLine("WalkSenceHandler : PLAYER_MOVE");
                    break;
                case (int)WalkSencePackageType.ENTER_SENCE:
                    Console.WriteLine("WalkSenceHandler : ENTER_SENCE");
                    break;
            }
            return 0;
        }
    }
}
