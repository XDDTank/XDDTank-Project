using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Game.Base.Packets;
using SqlDataProvider.Data;
using Bussiness;

namespace Game.Server.Packets.Client
{
    [PacketHandler((int)ePackageType.LINKREQUEST_GOODS, "物品比较")]
    public class ItemCompareHandler : IPacketHandler
    {
      
        public int HandlePacket(GameClient client, GSPacketIn packet)
        {

            int Type = packet.ReadInt();
            int ItemID = int.Parse(packet.ReadString());

            using (PlayerBussiness db = new PlayerBussiness())
            {
                ItemInfo Item = db.GetUserItemSingle(ItemID);
                if (Item != null)
                {
                    GSPacketIn pkg = new GSPacketIn((byte)ePackageType.LINKREQUEST_GOODS, client.Player.PlayerCharacter.ID);
                    pkg.WriteInt(Type);//var _loc_4:* = _loc_3.readInt();                        
                    if (Type == 4)
                    {
                        pkg.WriteString(client.Player.PlayerCharacter.NickName);
                        pkg.WriteInt(Item.TemplateID);//_loc_6.CardId = _loc_3.readInt();
                        pkg.WriteInt(Item.TemplateID);//_loc_6.Place = _loc_3.readInt();
                        pkg.WriteInt(Item.TemplateID);//_loc_6.Type = _loc_3.readInt();
                        pkg.WriteInt(Item.TemplateID);//_loc_6.Level = _loc_3.readInt();
                        pkg.WriteInt(Item.TemplateID);//_loc_6.GP = _loc_3.readInt();
                    }
                    if (Type == 5)
                    {
                        pkg.WriteString(client.Player.PlayerCharacter.NickName);
                        pkg.WriteInt(Item.TemplateID);//_loc_8.TemplateID = _loc_3.readInt();
                        pkg.WriteInt(Item.TemplateID);//_loc_8.CardType = _loc_3.readInt();
                        pkg.WriteInt(Item.TemplateID);//_loc_8.Attack = _loc_3.readInt();
                        pkg.WriteInt(Item.TemplateID);//_loc_8.Defence = _loc_3.readInt();
                        pkg.WriteInt(Item.TemplateID);//_loc_8.Agility = _loc_3.readInt();
                        pkg.WriteInt(Item.TemplateID);//_loc_8.Luck = _loc_3.readInt();
                        pkg.WriteInt(Item.TemplateID);//_loc_8.Damage = _loc_3.readInt();
                        pkg.WriteInt(Item.TemplateID);//_loc_8.Guard = _loc_3.readInt();
                    }
                    pkg.WriteString(client.Player.PlayerCharacter.NickName);//var _loc_5:* = _loc_3.readUTF();
                    pkg.WriteInt(Item.TemplateID);
                    pkg.WriteInt(Item.ItemID);
                    pkg.WriteInt(Item.StrengthenLevel);
                    pkg.WriteInt(Item.AttackCompose);
                    pkg.WriteInt(Item.AgilityCompose);
                    pkg.WriteInt(Item.LuckCompose);
                    pkg.WriteInt(Item.DefendCompose);
                    pkg.WriteInt(Item.ValidDate);
                    pkg.WriteBoolean(Item.IsBinds);
                    pkg.WriteBoolean(Item.IsJudge);
                    pkg.WriteBoolean(Item.IsUsed);
                    if (Item.IsUsed)
                    {
                        pkg.WriteString(Item.BeginDate.ToString());
                    }
                    pkg.WriteInt(Item.Hole1);
                    pkg.WriteInt(Item.Hole2);
                    pkg.WriteInt(Item.Hole3);
                    pkg.WriteInt(Item.Hole4);
                    pkg.WriteInt(Item.Hole5);
                    pkg.WriteInt(Item.Hole6);
                    pkg.WriteString(Item.Template.Hole);
                    pkg.WriteString(Item.Template.Pic);
                    pkg.WriteInt(Item.Template.RefineryLevel);
                    pkg.WriteDateTime(DateTime.Now);
                    pkg.WriteByte((byte)Item.Hole5Level);
                    pkg.WriteInt(Item.Hole5Exp);
                    pkg.WriteByte((byte)Item.Hole6Level);
                    pkg.WriteInt(Item.Hole6Exp);
                    if (Item.IsGold)
                    {
                        pkg.WriteBoolean(Item.IsGold);//_loc_8.isGold = _loc_2.readBoolean();
                        pkg.WriteInt(Item.goldValidDate);//_loc_8.goldValidDate = _loc_2.readInt();
                        pkg.WriteDateTime(Item.goldBeginTime);//_loc_8.goldBeginTime = _loc_2.readDateString();
                    }
                    else { pkg.WriteBoolean(false); }
                    client.Out.SendTCP(pkg);
                }
                return 1;
            }           
            return 0;
        }
    }
}
