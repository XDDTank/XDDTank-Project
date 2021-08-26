using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Game.Server.GameObjects;
using Game.Base.Packets;
using SqlDataProvider.Data;
using Bussiness.Managers;
using Game.Server.GameUtils;

namespace Game.Server.Packets.Client
{
    [PacketHandler((int)ePackageType.ROOM_SAVE_OBJECT, "Vòng quay may mắn")]
    public class NewChickenBoxHandler : IPacketHandler
    {
        public int HandlePacket(GameClient client, GSPacketIn packet)
        {
            return 0;
        }
    }
}
