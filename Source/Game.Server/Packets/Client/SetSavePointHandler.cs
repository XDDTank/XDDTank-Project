using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Game.Server.GameObjects;
using Game.Base.Packets;

namespace Game.Server.Packets.Client
{
    [PacketHandler((int)ePackageType.SET_SAVE_POINT, "SET_SAVE_POINT")]
    public class SetSavePointHandler : IPacketHandler
    {
        public int HandlePacket(GameClient client, GSPacketIn packet)
        {
            int savePoint = packet.ReadInt();
            //client.Out.SendMessage(eMessageType.Normal, "Set Point chưa được dev");
            return 0;
        }
    }
}
