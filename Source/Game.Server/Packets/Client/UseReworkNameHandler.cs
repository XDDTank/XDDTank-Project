using System;
//using System.Collections.Generic;
//using System.Linq;
//using System.Text;
using Game.Base.Packets;
//using Game.Server.Managers;
using Game.Server.GameObjects;
using Game.Server.GameUtils;
using Bussiness;

namespace Game.Server.Packets.Client
{
    [PacketHandler((byte)ePackageType.USE_REWORK_NAME, "场景用户离开")]
    public class UseReworkNameHandler : IPacketHandler
    {
        public int HandlePacket(GameClient client, GSPacketIn packet)
        {
            byte bag = packet.ReadByte();
            int place = packet.ReadInt();
            string newNickname = packet.ReadString();
            string msg = "";
            PlayerInventory inventory = client.Player.GetInventory((eBageType)bag);
            inventory.RemoveItemAt(place);
            using (PlayerBussiness pb = new PlayerBussiness())
            {
                pb.RenameNick(client.Player.PlayerCharacter.UserName, client.Player.PlayerCharacter.NickName, newNickname, ref msg);
            }
            if (msg != "")
            {
                client.Player.SendMessage(msg);
            }
            return 0;
        }
    }
}
