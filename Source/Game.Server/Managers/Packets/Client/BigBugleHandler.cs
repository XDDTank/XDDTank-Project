using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Game.Server.GameObjects;
using Game.Base.Packets;
using SqlDataProvider.Data;
using Game.Server.Managers;
using Bussiness;

namespace Game.Server.Packets.Client
{
    [PacketHandler((int)ePackageType.B_BUGLE,"大喇叭")]
    public class BigBugleHandler:IPacketHandler
    {
        public int HandlePacket(GameClient client,GSPacketIn packet )
        {
            int bugleId = packet.ReadInt();
            //ItemInfo item = client.Player.PropBag.GetItemByCategoryID(0,11, 5);
            ItemInfo item = client.Player.PropBag.GetItemByTemplateID(0, bugleId);
            if (DateTime.Compare(client.Player.LastChatTime.AddSeconds(15.0), DateTime.Now) > 0)
            {
                client.Out.SendMessage(eMessageType.ChatERROR, LanguageMgr.GetTranslation("Thao tác quá nhanh!"));
                return 1;
            }
            GSPacketIn pkg = new GSPacketIn((byte)ePackageType.B_BUGLE, client.Player.PlayerCharacter.ID);
            if (item != null)
            {
                int senderID = packet.ReadInt();
                string senderName = packet.ReadString();
                string msg = packet.ReadString();

                client.Player.PropBag.RemoveCountFromStack(item, 1);
                //GSPacketIn pkg = packet.Clone();
                //pkg.ClearContext();
                //pkg.ClientID = (client.Player.PlayerCharacter.ID);
                //GSPacketIn pkg = new GSPacketIn((byte)ePackageType.B_BUGLE, client.Player.PlayerCharacter.ID);
                pkg.WriteInt(item.Template.Property2);//_loc_3.bigBuggleType = _loc_2.readInt();
                pkg.WriteInt(client.Player.PlayerCharacter.ID);
                pkg.WriteString(client.Player.PlayerCharacter.NickName);
                pkg.WriteString(msg);
                GameServer.Instance.LoginServer.SendPacket(pkg);
                client.Player.LastChatTime = DateTime.Now;
                foreach (GamePlayer p in WorldMgr.GetAllPlayers())
                    p.Out.SendTCP(pkg);
            }
            else
            {
               
                string senderName = packet.ReadString();
                string msg = packet.ReadString();
                ItemInfo c_item = client.Player.PropBag.GetItemByCategoryID(0, 11, 4);
                client.Player.PropBag.RemoveCountFromStack(c_item, 1);                
                //GSPacketIn pkg = packet.Clone();
                //pkg.ClearContext();
                //pkg.ClientID = (client.Player.PlayerCharacter.ID);
                //GSPacketIn pkg = new GSPacketIn((byte)ePackageType.B_BUGLE, client.Player.PlayerCharacter.ID);
                pkg.WriteInt(4);
                pkg.WriteInt(client.Player.PlayerCharacter.ID);
                pkg.WriteString(client.Player.PlayerCharacter.NickName);
                pkg.WriteString(msg);
                pkg.WriteString("gunnyII");//_loc_3.zoneName = _loc_2.readUTF();
                GameServer.Instance.LoginServer.SendPacket(pkg);
                client.Player.LastChatTime = DateTime.Now;
                foreach (GamePlayer p in WorldMgr.GetAllPlayers())
                    p.Out.SendTCP(pkg);
            }
            return 0;
        }
    }
}
