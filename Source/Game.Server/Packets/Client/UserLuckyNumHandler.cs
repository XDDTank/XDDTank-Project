using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Game.Base.Packets;
using Game.Server.Managers;
using Game.Server.GameObjects;
using Game.Server.GameUtils;
using Game.Server.Rooms;

namespace Game.Server.Packets.Client
{
    [PacketHandler((byte)ePackageType.USER_LUCKYNUM, "场景用户离开")]
    public class UserLuckyNumHandler : IPacketHandler
    {
        public int HandlePacket(GameClient client, GSPacketIn packet)
        {
            bool responseLuckyNum = packet.ReadBoolean();
            int LuckyNum = packet.ReadInt();
            Console.WriteLine("LuckyNum: " + LuckyNum);
            //GSPacketIn pkg = packet.Clone();
            //pkg.WriteInt(2);
            //pkg.WriteString("False,False,True,True");
            //client.SendTCP(pkg);
            return 1;
        }
    }
}
