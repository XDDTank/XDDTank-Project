using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Game.Base.Packets;
using SqlDataProvider.Data;
using Bussiness;
using Game.Server.Statics;

namespace Game.Server.Packets.Client
{
    [PacketHandler((byte)ePackageType.ITEM_INLAY, "物品镶嵌")]
    public class ItemInlayHandle : IPacketHandler
    {
        public int HandlePacket(GameClient client, GSPacketIn packet)
        {
            client.Player.SendMessage("Tính năng đang xây dựng");
            return 0;
        }
    }
}
