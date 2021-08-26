using System;
using Game.Base.Packets;
using Game.Server.GameObjects;

namespace Game.Server.Packets.Client
{
    [PacketHandler((byte)ePackageType.MINING_DUGEON, "MINING_DUGEON")]
    public class MiningDugeonHandler : IPacketHandler
    {
        public int HandlePacket(GameClient client, GSPacketIn packet)
        {
            int type = packet.ReadInt();
            switch (type)
            {
                case (int)MiningDegeonPackageType.CD_COOLING_TIME:
                    client.Out.SendMessage(eMessageType.Normal,"Chức năng đang xây dựng");
                    Console.WriteLine("MINING_DUNGEON : CD_COOLING_TIME");
                    break;
                default:
                    Console.WriteLine("MINING_DUNGEON : DEFAULT_CASE");
                    break;
            }
            return 0;
        }
    }
}
