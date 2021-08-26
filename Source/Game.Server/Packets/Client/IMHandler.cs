using System;
//using System.Collections.Generic;
//using System.Linq;
//using System.Text;
using Game.Server.GameObjects;
using Game.Base.Packets;
using SqlDataProvider.Data;
using Bussiness;
using Game.Server.Managers;

namespace Game.Server.Packets.Client
{
    [PacketHandler((byte)ePackageType.IM_CMD, "添加好友")]
    public class IMHandler : IPacketHandler
    {
        //0友好，1黑名单
        public int HandlePacket(GameClient client, GSPacketIn packet)
        {
            var im_cmd = packet.ReadByte();            
            switch (im_cmd)
            {
                case (byte)IMPackageType.FRIEND_ADD:
                    {
                        string nickName = packet.ReadString();//_loc_5.writeUTF(param1);
                        int relation = packet.ReadInt();//_loc_5.writeInt(param2);
                        //_loc_5.writeBoolean(param3);
                        //_loc_5.writeBoolean(param4);
                        if (relation < 0 || relation > 1)
                            return 1;
                        using (PlayerBussiness db = new PlayerBussiness())
                        {
                            PlayerInfo user = null;
                            GamePlayer player = Managers.WorldMgr.GetClientByPlayerNickName(nickName);
                            if (player != null)
                                user = player.PlayerCharacter;
                            else
                                user = db.GetUserSingleByNickName(nickName);
                            if (!string.IsNullOrEmpty(nickName) && user != null)
                            {
                                if (!client.Player.Friends.ContainsKey(user.ID) || client.Player.Friends[user.ID] != relation)
                                {
                                    FriendInfo friend = new FriendInfo();
                                    friend.FriendID = user.ID;
                                    friend.IsExist = true;
                                    friend.Remark = "";
                                    friend.UserID = client.Player.PlayerCharacter.ID;
                                    friend.Relation = relation;
                                    if (db.AddFriends(friend))
                                    {
                                        client.Player.FriendsAdd(user.ID, relation);                                        
                                        if (relation != 1 && user.State != 0)
                                        {
                                            GSPacketIn response = new GSPacketIn((byte)ePackageType.IM_CMD, client.Player.PlayerCharacter.ID);
                                            response.WriteByte((byte)IMPackageType.FRIEND_RESPONSE);
                                            response.WriteInt(user.ID);
                                            response.WriteString(client.Player.PlayerCharacter.NickName);
                                            response.WriteBoolean(false);//_loc_5:* = event.pkg.readBoolean();
                                            if (player != null)
                                                player.Out.SendTCP(response);
                                            else
                                                GameServer.Instance.LoginServer.SendPacket(response);
                                        }
                                        client.Out.SendAddFriend(user, relation, true);
                                    }
                                }
                                else
                                {
                                    client.Out.SendMessage(eMessageType.Normal, LanguageMgr.GetTranslation("FriendAddHandler.Falied"));
                                }
                            }
                            else
                            {
                                client.Out.SendMessage(eMessageType.ERROR, LanguageMgr.GetTranslation("FriendAddHandler.Success"));
                            }

                        }
                    }
                    break;
                case (byte)IMPackageType.FRIEND_REMOVE:
                    {
                        //Console.WriteLine("//FRIEND_REMOVE ");
                        int id = packet.ReadInt();
                        using (PlayerBussiness db = new PlayerBussiness())
                        {
                            if (db.DeleteFriends(client.Player.PlayerCharacter.ID, id))
                            {
                                client.Player.FriendsRemove(id);
                                client.Out.SendFriendRemove(id);
                            }
                        }
                    }
                    break;
                case (byte)IMPackageType.FRIEND_UPDATE:
                    Console.WriteLine("//FRIEND_UPDATE ");
                    break;
                case (byte)IMPackageType.FRIEND_STATE:
                    {
                        //Console.WriteLine("//FRIEND_STATE ");
                        packet.ClientID = client.Player.PlayerCharacter.ID;
                        int state = packet.ReadInt();
                        GameServer.Instance.LoginServer.SendPacket(packet);
                        WorldMgr.ChangePlayerState(packet.ClientID, state, client.Player.PlayerCharacter.ConsortiaID);
                    }

                    break;
                case (byte)IMPackageType.ONS_EQUIP:
                    {
                        /*/Console.WriteLine("//ONS_EQUIP ");
                        PlayerInfo player = client.Player.PlayerCharacter;
                        GSPacketIn onsEquip = new GSPacketIn((byte)ePackageType.IM_CMD, player.ID);
                        onsEquip.WriteByte((byte)IMPackageType.ONS_EQUIP);
                        onsEquip.WriteInt(player.ID);
                        onsEquip.WriteString(player.NickName);
                        onsEquip.WriteInt(player.Agility);
                        onsEquip.WriteInt(player.Attack);
                        onsEquip.WriteString(player.Colors);
                        onsEquip.WriteString(player.Skin);
                        onsEquip.WriteInt(player.Defence);
                        onsEquip.WriteInt(player.GP);
                        onsEquip.WriteInt(player.Grade);
                        onsEquip.WriteInt(player.Luck);
                        onsEquip.WriteInt(player.Hide);
                        onsEquip.WriteInt(player.Repute);
                        onsEquip.WriteBoolean(player.Sex);
                        onsEquip.WriteString(player.Style);
                        onsEquip.WriteInt(player.Offer);
                        onsEquip.WriteByte(player.typeVIP);
                        onsEquip.WriteInt(player.VIPLevel);
                        onsEquip.WriteInt(player.Win);
                        onsEquip.WriteInt(player.Total);
                        onsEquip.WriteInt(player.Escape);
                        onsEquip.WriteInt(player.ConsortiaID);
                        onsEquip.WriteString(player.ConsortiaName);
                        onsEquip.WriteInt(player.RichesOffer);
                        onsEquip.WriteInt(player.RichesRob);
                        onsEquip.WriteBoolean(player.IsMarried);
                        onsEquip.WriteInt(player.SpouseID);
                        onsEquip.WriteString(player.SpouseName);
                        onsEquip.WriteString(player.DutyName);
                        onsEquip.WriteInt(player.Nimbus);
                        onsEquip.WriteInt(player.FightPower);
                        onsEquip.WriteInt(0);//apprenticeshipState = _loc_2.readInt();
                        onsEquip.WriteInt(0);//masterID = _loc_2.readInt();
                        onsEquip.WriteString("");//setMasterOrApprentices(_loc_2.readUTF());
                        onsEquip.WriteInt(0);//graduatesCount = _loc_2.readInt();
                        onsEquip.WriteString("");//honourOfMaster = _loc_2.readUTF();
                        onsEquip.WriteInt(player.AchievementPoint);//
                        onsEquip.WriteString("");//honor = _loc_2.readUTF();
                        onsEquip.WriteDateTime(player.LastDate);// _loc_5.LastLoginDate = _loc_2.readDate();
                        client.Player.Out.SendTCP(onsEquip);*/
                    }
                    break;
                case (byte)IMPackageType.FRIEND_RESPONSE:
                    Console.WriteLine("//FRIEND_RESPONSE ");
                    break;
                case (byte)IMPackageType.SAME_CITY_FRIEND:
                    Console.WriteLine("//SAME_CITY_FRIEND ");
                    break;
                case (byte)IMPackageType.ADD_CUSTOM_FRIENDS:
                    Console.WriteLine("//ADD_CUSTOM_FRIENDS ");
                    break;
                case (byte)IMPackageType.ONE_ON_ONE_TALK:
                    {
                        int receiverID = packet.ReadInt();//_loc_4.writeInt(param1);_info.ID
                        string msg = packet.ReadString();//_loc_4.writeUTF(param2);msg
                        bool isAutoReply = packet.ReadBoolean();//_loc_4.writeBoolean(param3);AutoReply
                        
                        GamePlayer player = Managers.WorldMgr.GetPlayerById(receiverID);
                        if (player != null)
                        {
                            client.Player.Out.sendOneOnOneTalk(receiverID, false, client.Player.PlayerCharacter.NickName, msg, client.Player.PlayerCharacter.ID);
                            player.Out.sendOneOnOneTalk(client.Player.PlayerCharacter.ID, false, client.Player.PlayerCharacter.NickName, msg, receiverID);
                        }
                        else
                        {
                            client.Player.Out.SendMessage(eMessageType.Normal, "Người chơi không online!");
                        }
                    }
                    break;
            }
            return 1;
        }
        
    }
}
