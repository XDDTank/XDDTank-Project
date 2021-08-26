using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Game.Server.GameObjects;
using Game.Base.Packets;
using Bussiness.Managers;
using SqlDataProvider.Data;
using Game.Server.GameUtils;
using Bussiness;
using Game.Server.Statics;

namespace Game.Server.Packets.Client
{
    [PacketHandler((byte)ePackageType.LOTTERY_FINISH, "打开物品")]
    public class LotteryFinishBoxHandler : IPacketHandler
    {


        public int HandlePacket(GameClient client, GSPacketIn packet)
        {
            client.Player.ClearCaddyBag();
            client.Lottery = -1;
            return 1;
        }
    }
}
