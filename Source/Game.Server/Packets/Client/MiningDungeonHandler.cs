﻿using System;
using Game.Base.Packets;
using Game.Server.GameObjects;

namespace Game.Server.Packets.Client
{
    [PacketHandler((byte)ePackageType.MINING_DUNGEON, "MINING_DUNGEON")]
    public class MiningDungeonHandler : IPacketHandler
    {
        public int HandlePacket(GameClient client, GSPacketIn packet)
        {
            int type = packet.ReadInt();
            switch (type)
            {
                case (int)MiningDungeonPackageType.CD_COOLING_TIME:
                    client.Out.SendMessage(eMessageType.Normal,"Chức năng đang xây dựng");
                    Console.WriteLine("MINING_DUNGEON : CD_COOLING_TIME");
                    break;
                case (int)MiningDungeonPackageType.FREE_ENTER:
                    Console.WriteLine("MINING_DUNGEON : FREE_ENTWE");
                    break;
                case (int)MiningDungeonPackageType.MONEY_ENTER:
                    Console.WriteLine("MINING_DUNGEON : MONEY_ENTWE");
                    break;
                default:
                    Console.WriteLine("MINING_DUNGEON : DEFAULT_CASE");
                    break;
            }
            return 0;
        }
    }
}