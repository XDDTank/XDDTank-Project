using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Game.Server.GameObjects;
using Game.Base.Packets;

namespace Game.Server.Packets.Client
{
    [PacketHandler((int)ePackageType.DAILY_QUEST, "DAILY_QUEST")]
    public class DailyQuestHandler : IPacketHandler
    {

        public int HandlePacket(GameClient client, GSPacketIn packet)
        {
            int type = packet.ReadInt();
            client.Out.SendMessage(eMessageType.Normal, "Chức năng đang xây dựng");
            switch (type)
            {
                case (int)DailyQuestPackageType.ONE_KEY:
                    Console.Write("DAILY_QUEST : ONE_KEY");
                    break;
                case (int)DailyQuestPackageType.RANDOM_PVE:
                    Console.Write("DAILY_QUEST : ONE_KEY");
                    break;
                case (int)DailyQuestPackageType.RANDOM_SCENE:
                    Console.Write("DAILY_QUEST : RANDOM_SCENE");
                    break;
                case (int)DailyQuestPackageType.REWARD:
                    Console.Write("DAILY_QUEST : REWARD");
                    break;
                case (int)DailyQuestPackageType.UPDATE:
                    Console.Write("DAILY_QUEST : UPDATE");
                    break;
                default:
                    Console.WriteLine("DAILY_QUEST : DEFAULT_CASE");
                    break;
            }
            return 0;
        }
    }
}
