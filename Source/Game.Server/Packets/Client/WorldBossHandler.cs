using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Game.Base.Packets;
using log4net;
using Game.Server.Rooms;

namespace Game.Server.Packets.Client
{
    [PacketHandler((int)ePackageType.WORLDBOSS_CMD,"WorldBoss")]
    public class WorldBossHandler : IPacketHandler
    {

        public int HandlePacket(GameClient client, GSPacketIn packet)
        {
            int worldboss_cmd = packet.ReadByte();

            BaseWorldBossRoom worldbossroom = new BaseWorldBossRoom();
            switch (worldboss_cmd)
            {
                case (byte)WorldBossGamePackageType.ENTER_WORLDBOSSROOM:
                    GSPacketIn gsp = new GSPacketIn((byte)ePackageType.WORLDBOSS_CMD);
                    gsp.WriteByte((byte)WorldBossPackageType.CANENTER);
                    gsp.WriteBoolean(true);
                    gsp.WriteBoolean(false);
                    gsp.WriteInt(0);
                    gsp.WriteInt(0);
                    client.Out.SendTCP(gsp);
                    Console.WriteLine("WORLDBOSS_CMD : ENTER_WORLDBOSSROOM");
                    break;
                case (byte)WorldBossGamePackageType.ADPLAYERS:
                    worldbossroom.AddPlayer(client.Player);
                    worldbossroom.UpdatePlayer(client.Player);
                    Console.WriteLine("WORLDBOSS_CMD : ADDPLAYERS");
                    break;
                case (byte)WorldBossGamePackageType.LEAVE_ROOM:
                    worldbossroom.RemovePlayer(client.Player);
                    Console.WriteLine("WORLDBOSS_CMD : LEAVE_ROOM");
                    break;
                case (byte)WorldBossGamePackageType.BUFF_BUY:
                    Console.WriteLine("WORLDBOSS_CMD : BUFF_BUY");
                    break;
                case (byte)WorldBossGamePackageType.MOVE:
                    Console.WriteLine("WORLDBOSS_CMD : MOVE");
                    break;
                case (byte)WorldBossGamePackageType.REQUEST_REVIVE:
                    Console.WriteLine("WORLDBOSS_CMD : REQUEST_REVIVE");
                    break;
                default:
                    Console.WriteLine("WORLDBOSS_CMD : DEFAULT_CASE");
                    break;
            }
            return 0;
        }
    }
}
