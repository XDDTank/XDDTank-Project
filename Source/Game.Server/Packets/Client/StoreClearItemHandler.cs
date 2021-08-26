using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Game.Base.Packets;
using Bussiness;
using SqlDataProvider.Data;
using System.Configuration;
using Game.Server.Managers;
using Game.Server.Statics;
using Game.Server.GameObjects;
using Game.Server.GameUtils;

namespace Game.Server.Packets.Client
{
    [PacketHandler((int)ePackageType.CLEAR_STORE_BAG, "物品强化")]
    public class StoreClearItemHandler : IPacketHandler
    {
        public int HandlePacket(GameClient client, GSPacketIn packet)
        {          
            client.Player.ClearStoreBag();
            return 0;
        }
    }
}
