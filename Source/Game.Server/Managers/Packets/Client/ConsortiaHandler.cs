using System;
using System.Collections.Generic;
//using System.Linq;
//using System.Text;
using Game.Base.Packets;
using Bussiness;
using SqlDataProvider.Data;
using Game.Server.GameObjects;
using Game.Server.Managers;

namespace Game.Server.Packets.Client
{
    [PacketHandler((int)ePackageType.CONSORTIA_CMD, "公会聊天")]
    public class ConsortiaHandler : IPacketHandler
    {
        public int HandlePacket(GameClient client, GSPacketIn packet)
        {
            var consortia_cmd = packet.ReadInt();
            //Console.WriteLine("ConsortiaPackageType: " + consortia_cmd.ToString());

            bool result = false;
            string msg = "Packet Error!";
            ConsortiaLevelInfo levelInfo = null;
            GamePlayer[] players = WorldMgr.GetAllPlayers();

            switch (consortia_cmd)
            {
                case (int)ConsortiaPackageType.CONSORTIA_TRYIN:
                    {
                        if (client.Player.PlayerCharacter.ConsortiaID != 0)
                            return 0;

                        int ConsortiaId = packet.ReadInt();
                        //bool result = false;
                        msg = "ConsortiaApplyLoginHandler.ADD_Failed";
                        using (ConsortiaBussiness db = new ConsortiaBussiness())
                        {
                            ConsortiaApplyUserInfo info = new ConsortiaApplyUserInfo();
                            info.ApplyDate = DateTime.Now;
                            info.ConsortiaID = ConsortiaId;
                            info.ConsortiaName = "";
                            info.IsExist = true;
                            info.Remark = "";
                            info.UserID = client.Player.PlayerCharacter.ID;
                            info.UserName = client.Player.PlayerCharacter.NickName;
                            if (db.AddConsortiaApplyUsers(info, ref msg))
                            {
                                msg = ConsortiaId != 0 ? "ConsortiaApplyLoginHandler.ADD_Success" : "ConsortiaApplyLoginHandler.DELETE_Success";
                                result = true;
                            }
                            else
                            {
                                client.Player.SendMessage("db.AddConsortia Error ");
                            }
                        }
                        client.Out.sendConsortiaTryIn(ConsortiaId, result, LanguageMgr.GetTranslation(msg), client.Player.PlayerCharacter.ID);
                    }
                    break;
                case (int)ConsortiaPackageType.CONSORTIA_CREATE:
                    {
                        if (client.Player.PlayerCharacter.ConsortiaID != 0)
                            return 0;
                        levelInfo = ConsortiaLevelMgr.FindConsortiaLevelInfo(1);
                        string name = packet.ReadString();
                        //if (string.IsNullOrEmpty(name) || System.Text.Encoding.Default.GetByteCount(name) > 12)
                        //{
                        //    client.Out.SendMessage(eMessageType.Normal, LanguageMgr.GetTranslation("ConsortiaCreateHandler.Long"));
                        //    return 1;
                        //}                    
                        //result = false;
                        int id = 0;
                        int mustGold = levelInfo.NeedGold;
                        int mustLevel = 5;
                        msg = "ConsortiaCreateHandler.Failed";
                        ConsortiaDutyInfo dutyInfo = new ConsortiaDutyInfo();

                        if (!string.IsNullOrEmpty(name) && client.Player.PlayerCharacter.Gold >= mustGold && client.Player.PlayerCharacter.Grade >= mustLevel)
                        {
                            using (ConsortiaBussiness db = new ConsortiaBussiness())
                            {
                                ConsortiaInfo info = new ConsortiaInfo();
                                info.BuildDate = DateTime.Now;
                                info.CelebCount = 0;
                                info.ChairmanID = client.Player.PlayerCharacter.ID;
                                info.ChairmanName = client.Player.PlayerCharacter.NickName;
                                info.ConsortiaName = name;
                                info.CreatorID = info.ChairmanID;
                                info.CreatorName = info.ChairmanName;
                                info.Description = "";
                                info.Honor = 0;
                                info.IP = "";
                                info.IsExist = true;
                                info.Level = levelInfo.Level;
                                info.MaxCount = levelInfo.Count;
                                info.Riches = levelInfo.Riches;
                                info.Placard = "";
                                info.Port = 0;
                                info.Repute = 0;
                                info.Count = 1;

                                if (db.AddConsortia(info, ref msg, ref dutyInfo))
                                {
                                    client.Player.PlayerCharacter.ConsortiaID = info.ConsortiaID;
                                    client.Player.PlayerCharacter.ConsortiaName = info.ConsortiaName;
                                    client.Player.PlayerCharacter.DutyLevel = dutyInfo.Level;
                                    client.Player.PlayerCharacter.DutyName = dutyInfo.DutyName;
                                    client.Player.PlayerCharacter.Right = dutyInfo.Right;
                                    client.Player.PlayerCharacter.ConsortiaLevel = levelInfo.Level;
                                    client.Player.RemoveGold(mustGold);
                                    msg = "ConsortiaCreateHandler.Success";
                                    result = true;
                                    id = info.ConsortiaID;
                                    GameServer.Instance.LoginServer.SendConsortiaCreate(id, client.Player.PlayerCharacter.Offer, info.ConsortiaName);
                                }
                                else
                                {
                                    client.Player.SendMessage("db.AddConsortia Error ");
                                }
                            }

                        }

                        client.Out.SendConsortiaCreate(name, result, id, name, LanguageMgr.GetTranslation(msg), dutyInfo.Level, dutyInfo.DutyName, dutyInfo.Right, client.Player.PlayerCharacter.ID);
                    } 
                    break;
                case (int)ConsortiaPackageType.CONSORTIA_DISBAND:

                    break;
                case (int)ConsortiaPackageType.CONSORTIA_RENEGADE:
                    {
                        if (client.Player.PlayerCharacter.ConsortiaID == 0)
                            return 0;

                        int _id = packet.ReadInt();
                        //bool result = false;
                        string nickName = "";
                        msg = _id == client.Player.PlayerCharacter.ID ? "ConsortiaUserDeleteHandler.ExitFailed" : "ConsortiaUserDeleteHandler.KickFailed";
                        using (ConsortiaBussiness db = new ConsortiaBussiness())
                        {
                            if (db.DeleteConsortiaUser(client.Player.PlayerCharacter.ID, _id, client.Player.PlayerCharacter.ConsortiaID, ref msg, ref nickName))
                            {
                                msg = _id == client.Player.PlayerCharacter.ID ? "ConsortiaUserDeleteHandler.ExitSuccess" : "ConsortiaUserDeleteHandler.KickSuccess";
                                int consortiaID = client.Player.PlayerCharacter.ConsortiaID;
                                if (_id == client.Player.PlayerCharacter.ID)
                                {
                                    client.Player.ClearConsortia();
                                    client.Out.SendMailResponse(client.Player.PlayerCharacter.ID, eMailRespose.Receiver);
                                }

                                // client.Player.StoreBag.SendStoreToMail();
                                GameServer.Instance.LoginServer.SendConsortiaUserDelete(_id, consortiaID, _id != client.Player.PlayerCharacter.ID, nickName, client.Player.PlayerCharacter.NickName);
                                result = true;
                            }
                        }
                        client.Out.sendConsortiaOut(_id, result, LanguageMgr.GetTranslation(msg), client.Player.PlayerCharacter.ID);
                    }
                    break;
                case (int)ConsortiaPackageType.CONSORTIA_TRYIN_PASS:
                    {
                        if (client.Player.PlayerCharacter.ConsortiaID == 0)
                            return 0;

                        int applyId = packet.ReadInt();
                        //bool result = false;
                        msg = "ConsortiaApplyLoginPassHandler.Failed";
                        using (ConsortiaBussiness db = new ConsortiaBussiness())
                        {
                            int consortiaRepute = 0;
                            ConsortiaUserInfo info = new ConsortiaUserInfo();
                            if (db.PassConsortiaApplyUsers(applyId, client.Player.PlayerCharacter.ID, client.Player.PlayerCharacter.NickName, client.Player.PlayerCharacter.ConsortiaID, ref msg, info, ref consortiaRepute))
                            {
                                msg = "ConsortiaApplyLoginPassHandler.Success";
                                result = true;
                                if (info.UserID != 0)
                                {
                                    info.ConsortiaID = client.Player.PlayerCharacter.ConsortiaID;
                                    info.ConsortiaName = client.Player.PlayerCharacter.ConsortiaName;
                                    GameServer.Instance.LoginServer.SendConsortiaUserPass(client.Player.PlayerCharacter.ID, client.Player.PlayerCharacter.NickName, info, false, consortiaRepute, info.LoginName,
                                        client.Player.PlayerCharacter.FightPower, client.Player.PlayerCharacter.Offer);
                                }
                            }
                        }
                        client.Out.sendConsortiaTryInPass(applyId, result, LanguageMgr.GetTranslation(msg), client.Player.PlayerCharacter.ID);
                    }
                    break;
                case (int)ConsortiaPackageType.CONSORTIA_TRYIN_DEL:
                    {
                        int delId = packet.ReadInt();
                        //bool result = false;
                        msg = "ConsortiaApplyAllyDeleteHandler.Failed";
                        using (ConsortiaBussiness db = new ConsortiaBussiness())
                        {
                            if (db.DeleteConsortiaApplyUsers(delId, client.Player.PlayerCharacter.ID, client.Player.PlayerCharacter.ConsortiaID, ref msg))
                            {
                                msg = client.Player.PlayerCharacter.ID == 0 ? "ConsortiaApplyAllyDeleteHandler.Success" : "ConsortiaApplyAllyDeleteHandler.Success2";
                                result = true;
                            }
                        }
                        client.Out.sendConsortiaTryInDel(delId, result, LanguageMgr.GetTranslation(msg), client.Player.PlayerCharacter.ID);
                    }
                    break;
                case (int)ConsortiaPackageType.CONSORTIA_RICHES_OFFER:
                    {
                        if (client.Player.PlayerCharacter.ConsortiaID == 0)
                            return 0;

                        int money = packet.ReadInt();
                        if (client.Player.PlayerCharacter.HasBagPassword && client.Player.PlayerCharacter.IsLocked)
                        {

                            client.Out.SendMessage(eMessageType.Normal, LanguageMgr.GetTranslation("Bag.Locked"));
                            return 1;
                        }

                        if (money < 1 || client.Player.PlayerCharacter.Money < money)
                        {
                            client.Out.SendMessage(eMessageType.Normal, LanguageMgr.GetTranslation("ConsortiaRichesOfferHandler.NoMoney"));
                            return 1;
                        }
                        //result = false;
                        msg = "ConsortiaRichesOfferHandler.Failed";
                        using (ConsortiaBussiness db = new ConsortiaBussiness())
                        {
                            int riches = money / 2;
                            if (db.ConsortiaRichAdd(client.Player.PlayerCharacter.ConsortiaID, ref riches, 5, client.Player.PlayerCharacter.NickName))
                            {
                                result = true;
                                client.Player.PlayerCharacter.RichesOffer += riches;
                                client.Player.RemoveMoney(money);
                                //LogMgr.LogMoneyAdd(LogMoneyType.Consortia, LogMoneyType.Consortia_Rich, client.Player.PlayerCharacter.ID, money, client.Player.PlayerCharacter.Money, 0, 0, (int)eSubConsumerType.Consortia_Riches_Offer,0, "", "", "");                    
                                msg = "ConsortiaRichesOfferHandler.Successed";
                                GameServer.Instance.LoginServer.SendConsortiaRichesOffer(client.Player.PlayerCharacter.ConsortiaID, client.Player.PlayerCharacter.ID, client.Player.PlayerCharacter.NickName, riches);
                            }
                        }
                        client.Out.SendConsortiaRichesOffer(money, result, LanguageMgr.GetTranslation(msg), client.Player.PlayerCharacter.ID);
                    }
                    break;
                case (int)ConsortiaPackageType.CONSORTIA_APPLY_STATE:
                    {
                        if (client.Player.PlayerCharacter.ConsortiaID == 0)
                            return 1;

                        bool state = packet.ReadBoolean();
                        //bool result = false;
                        msg = "CONSORTIA_APPLY_STATE.Failed";
                        using (ConsortiaBussiness db = new ConsortiaBussiness())
                        {
                            if (db.UpdateConsotiaApplyState(client.Player.PlayerCharacter.ConsortiaID, client.Player.PlayerCharacter.ID, state, ref msg))
                            {
                                msg = "CONSORTIA_APPLY_STATE.Success";
                                result = true;
                            }
                        }
                        client.Out.sendConsortiaApplyStatusOut(state, result, client.Player.PlayerCharacter.ID);
                    }
                    break;
                case (int)ConsortiaPackageType.CONSORTIA_DUTY_DELETE:
                    {
                        if (client.Player.PlayerCharacter.ConsortiaID == 0)
                            return 0;

                        int DutyId = packet.ReadInt();
                        //bool result = false;
                        msg = "ConsortiaDutyDeleteHandler.Failed";
                        using (ConsortiaBussiness db = new ConsortiaBussiness())
                        {
                            if (db.DeleteConsortiaDuty(DutyId, client.Player.PlayerCharacter.ID, client.Player.PlayerCharacter.ConsortiaID, ref msg))
                            {
                                msg = "ConsortiaDutyDeleteHandler.Success";
                                result = true;
                            }
                        }
                    }
                    break;
                case (int)ConsortiaPackageType.CONSORTIA_DUTY_UPDATE:
                    {
                        if (client.Player.PlayerCharacter.ConsortiaID == 0)
                            return 0;

                        int dutyID = packet.ReadInt();
                        int updateType = packet.ReadByte();
                        msg = "ConsortiaDutyUpdateHandler.Failed";

                        using (ConsortiaBussiness db = new ConsortiaBussiness())
                        {
                            ConsortiaDutyInfo info = new ConsortiaDutyInfo();
                            info.ConsortiaID = client.Player.PlayerCharacter.ConsortiaID;
                            info.DutyID = dutyID;
                            info.IsExist = true;
                            info.DutyName = "";
                            switch (updateType)
                            {
                                case 1:
                                    return 1;
                                case 2:
                                    info.DutyName = packet.ReadString();
                                    if (string.IsNullOrEmpty(info.DutyName) || System.Text.Encoding.Default.GetByteCount(info.DutyName) > 10)
                                    {
                                        client.Out.SendMessage(eMessageType.Normal, LanguageMgr.GetTranslation("ConsortiaDutyUpdateHandler.Long"));
                                        return 1;
                                    }
                                    info.Right = packet.ReadInt();
                                    break;
                                case 3:
                                    break;
                                case 4:
                                    break;
                            }

                            if (db.UpdateConsortiaDuty(info, client.Player.PlayerCharacter.ID, updateType, ref msg))
                            {
                                dutyID = info.DutyID;
                                msg = "ConsortiaDutyUpdateHandler.Success";
                                result = true;
                                GameServer.Instance.LoginServer.SendConsortiaDuty(info, updateType, client.Player.PlayerCharacter.ConsortiaID);
                            }
                        }
                    }
                    break;
                case (int)ConsortiaPackageType.CONSORTIA_INVITE:
                    {
                        if (client.Player.PlayerCharacter.ConsortiaID == 0)
                            return 0;
                        //int id = packet.ReadInt();
                        string UserName = packet.ReadString();
                        //bool result = false;
                        msg = "ConsortiaInviteAddHandler.Failed";
                        if (string.IsNullOrEmpty(UserName))
                            return 0;
                        using (ConsortiaBussiness db = new ConsortiaBussiness())
                        {
                            ConsortiaInviteUserInfo info = new ConsortiaInviteUserInfo();
                            info.ConsortiaID = client.Player.PlayerCharacter.ConsortiaID;
                            info.ConsortiaName = client.Player.PlayerCharacter.ConsortiaName;
                            info.InviteDate = DateTime.Now;
                            info.InviteID = client.Player.PlayerCharacter.ID;
                            info.InviteName = client.Player.PlayerCharacter.NickName;
                            info.IsExist = true;
                            info.Remark = "";
                            info.UserID = 0;
                            info.UserName = UserName;
                            if (db.AddConsortiaInviteUsers(info, ref msg))
                            {
                                msg = "ConsortiaInviteAddHandler.Success";
                                result = true;
                                GameServer.Instance.LoginServer.SendConsortiaInvite(info.ID, info.UserID, info.UserName, info.InviteID, info.InviteName, info.ConsortiaName, info.ConsortiaID);
                            }
                        }

                        client.Out.SendConsortiaInvite(UserName, result, LanguageMgr.GetTranslation(msg), client.Player.PlayerCharacter.ID);
                    }
                    break;
                case (int)ConsortiaPackageType.CONSORTIA_INVITE_PASS:
                    {
                        if (client.Player.PlayerCharacter.ConsortiaID != 0)
                            return 0;

                        int IdInvitePass = packet.ReadInt();
                        //bool result = false;
                        int consortia_ID = 0;
                        string consortiaName = "";
                        msg = "ConsortiaInvitePassHandler.Failed";
                        int tempID = 0;
                        string tempName = "";
                        using (ConsortiaBussiness db = new ConsortiaBussiness())
                        {
                            int consortiaRepute = 0;
                            ConsortiaUserInfo info = new ConsortiaUserInfo();
                            if (db.PassConsortiaInviteUsers(IdInvitePass, client.Player.PlayerCharacter.ID, client.Player.PlayerCharacter.NickName, ref consortia_ID, ref consortiaName, ref msg, info, ref tempID, ref tempName, ref consortiaRepute))
                            {
                                client.Player.PlayerCharacter.ConsortiaID = consortia_ID;
                                client.Player.PlayerCharacter.ConsortiaName = consortiaName;
                                client.Player.PlayerCharacter.DutyLevel = info.Level;
                                client.Player.PlayerCharacter.DutyName = info.DutyName;
                                client.Player.PlayerCharacter.Right = info.Right;
                                ConsortiaInfo consotia = ConsortiaMgr.FindConsortiaInfo(consortia_ID);
                                if (consotia != null)
                                    client.Player.PlayerCharacter.ConsortiaLevel = consotia.Level;
                                msg = "ConsortiaInvitePassHandler.Success";
                                result = true;

                                info.UserID = client.Player.PlayerCharacter.ID;
                                info.UserName = client.Player.PlayerCharacter.NickName;
                                info.Grade = client.Player.PlayerCharacter.Grade;
                                info.Offer = client.Player.PlayerCharacter.Offer;
                                info.RichesOffer = client.Player.PlayerCharacter.RichesOffer;
                                info.RichesRob = client.Player.PlayerCharacter.RichesRob;
                                info.Win = client.Player.PlayerCharacter.Win;
                                info.Total = client.Player.PlayerCharacter.Total;
                                info.Escape = client.Player.PlayerCharacter.Escape;
                                info.ConsortiaID = consortia_ID;
                                info.ConsortiaName = consortiaName;

                                GameServer.Instance.LoginServer.SendConsortiaUserPass(tempID, tempName, info, true, consortiaRepute,
                                    client.Player.PlayerCharacter.UserName, client.Player.PlayerCharacter.FightPower, client.Player.PlayerCharacter.Offer);
                            }
                        }
                        client.Out.sendConsortiaInvitePass(IdInvitePass, result, consortia_ID, consortiaName, LanguageMgr.GetTranslation(msg), client.Player.PlayerCharacter.ID);
                    }
                    break;
                case (int)ConsortiaPackageType.CONSORTIA_INVITE_DELETE:
                    {
                        int delIdInvite = packet.ReadInt();
                        //bool result = false;
                        msg = "ConsortiaInviteDeleteHandler.Failed";
                        using (ConsortiaBussiness db = new ConsortiaBussiness())
                        {
                            if (db.DeleteConsortiaInviteUsers(delIdInvite, client.Player.PlayerCharacter.ID))
                            {
                                msg = "ConsortiaInviteDeleteHandler.Success";
                                result = true;
                            }
                        }
                        client.Out.sendConsortiaInviteDel(delIdInvite, result, LanguageMgr.GetTranslation(msg), client.Player.PlayerCharacter.ID);
                    }
                    break;
                case (int)ConsortiaPackageType.CONSORTIA_DESCRIPTION_UPDATE:
                    {
                        string description = packet.ReadString();
                        if (System.Text.Encoding.Default.GetByteCount(description) > 300)
                        {
                            client.Out.SendMessage(eMessageType.Normal, LanguageMgr.GetTranslation("ConsortiaDescriptionUpdateHandler.Long"));
                            return 1;
                        }
                        //bool result = false;
                        msg = "ConsortiaDescriptionUpdateHandler.Failed";
                        using (ConsortiaBussiness db = new ConsortiaBussiness())
                        {
                            if (db.UpdateConsortiaDescription(client.Player.PlayerCharacter.ConsortiaID, client.Player.PlayerCharacter.ID, description, ref msg))
                            {
                                msg = "ConsortiaDescriptionUpdateHandler.Success";
                                result = true;
                            }
                        }
                        client.Out.sendConsortiaUpdateDescription(description, result, LanguageMgr.GetTranslation(msg), client.Player.PlayerCharacter.ID);
                    }
                    break;
                case (int)ConsortiaPackageType.CONSORTIA_PLACARD_UPDATE:
                    {
                        string placard = packet.ReadString();
                        if (System.Text.Encoding.Default.GetByteCount(placard) > 300)
                        {
                            client.Out.SendMessage(eMessageType.Normal, LanguageMgr.GetTranslation("ConsortiaPlacardUpdateHandler.Long"));
                            return 1;
                        }
                        //bool result = false;
                        msg = "ConsortiaPlacardUpdateHandler.Failed";
                        using (ConsortiaBussiness db = new ConsortiaBussiness())
                        {
                            if (db.UpdateConsortiaPlacard(client.Player.PlayerCharacter.ConsortiaID, client.Player.PlayerCharacter.ID, placard, ref msg))
                            {
                                msg = "ConsortiaPlacardUpdateHandler.Success";
                                result = true;
                            }
                        }
                        client.Out.sendConsortiaUpdatePlacard(placard, result, LanguageMgr.GetTranslation(msg), client.Player.PlayerCharacter.ID);
                    }
                    break;
                case (int)ConsortiaPackageType.CONSORTIA_BANCHAT_UPDATE:

                    break;
                case (int)ConsortiaPackageType.CONSORTIA_USER_REMARK_UPDATE:

                    break;
                case (int)ConsortiaPackageType.CONSORTIA_USER_GRADE_UPDATE:
                    {
                        if (client.Player.PlayerCharacter.ConsortiaID == 0)
                            return 0;

                        int userid = packet.ReadInt();
                        bool upGrade = packet.ReadBoolean();
                        //bool result = false;
                        msg = "ConsortiaUserGradeUpdateHandler.Failed";
                        using (ConsortiaBussiness db = new ConsortiaBussiness())
                        {
                            string tempUserName = "";
                            ConsortiaDutyInfo info = new ConsortiaDutyInfo();
                            if (db.UpdateConsortiaUserGrade(userid, client.Player.PlayerCharacter.ConsortiaID, client.Player.PlayerCharacter.ID, upGrade, ref msg, ref info, ref tempUserName))
                            {
                                msg = "ConsortiaUserGradeUpdateHandler.Success";
                                result = true;
                                GameServer.Instance.LoginServer.SendConsortiaDuty(info, upGrade ? 6 : 7, client.Player.PlayerCharacter.ConsortiaID, userid, tempUserName, client.Player.PlayerCharacter.ID, client.Player.PlayerCharacter.NickName);
                            }
                        }
                        client.Out.SendConsortiaMemberGrade(userid, upGrade, result, LanguageMgr.GetTranslation(msg), client.Player.PlayerCharacter.ID);
                    }
                    break;
                case (int)ConsortiaPackageType.CONSORTIA_CHAIRMAN_CHAHGE:
                    {
                        if (client.Player.PlayerCharacter.ConsortiaID == 0)
                            return 0;

                        string nick_Name = packet.ReadString();
                        //bool result = false;
                        msg = "ConsortiaChangeChairmanHandler.Failed";

                        if (string.IsNullOrEmpty(nick_Name))
                        {
                            msg = "ConsortiaChangeChairmanHandler.NoName";
                        }
                        else if (nick_Name == client.Player.PlayerCharacter.NickName)
                        {
                            msg = "ConsortiaChangeChairmanHandler.Self";
                        }
                        else
                        {
                            using (ConsortiaBussiness db = new ConsortiaBussiness())
                            {
                                string tempUserName = "";
                                int tempUserID = 0;
                                ConsortiaDutyInfo info = new ConsortiaDutyInfo();
                                if (db.UpdateConsortiaChairman(nick_Name, client.Player.PlayerCharacter.ConsortiaID, client.Player.PlayerCharacter.ID, ref msg, ref info, ref tempUserID, ref tempUserName))
                                {
                                    ConsortiaDutyInfo orderInfo = new ConsortiaDutyInfo();
                                    orderInfo.Level = client.Player.PlayerCharacter.DutyLevel;
                                    orderInfo.DutyName = client.Player.PlayerCharacter.DutyName;
                                    orderInfo.Right = client.Player.PlayerCharacter.Right;
                                    msg = "ConsortiaChangeChairmanHandler.Success1";
                                    result = true;
                                    GameServer.Instance.LoginServer.SendConsortiaDuty(orderInfo, 9, client.Player.PlayerCharacter.ConsortiaID, tempUserID, tempUserName, 0, "");
                                    GameServer.Instance.LoginServer.SendConsortiaDuty(info, 8, client.Player.PlayerCharacter.ConsortiaID, client.Player.PlayerCharacter.ID, client.Player.PlayerCharacter.NickName, 0, "");
                                }
                            }
                        }
                        string temp = LanguageMgr.GetTranslation(msg);
                        if (msg == "ConsortiaChangeChairmanHandler.Success1")
                        {
                            temp += nick_Name + LanguageMgr.GetTranslation("ConsortiaChangeChairmanHandler.Success2");
                        }
                        client.Out.sendConsortiaChangeChairman(nick_Name, result, LanguageMgr.GetTranslation(msg), client.Player.PlayerCharacter.ID);
                    }
                    break;
                case (int)ConsortiaPackageType.CONSORTIA_CHAT:
                    {
                        if (client.Player.PlayerCharacter.ConsortiaID == 0)
                            return 0;

                        if (client.Player.PlayerCharacter.IsBanChat)
                        {
                            client.Out.SendMessage(eMessageType.ChatERROR, LanguageMgr.GetTranslation("ConsortiaChatHandler.IsBanChat"));
                            return 1;
                        }

                        else
                        {
                            packet.ClientID = client.Player.PlayerCharacter.ID;
                            packet.ReadByte();
                            packet.ReadString();
                            packet.ReadString();
                            packet.WriteInt(client.Player.PlayerCharacter.ConsortiaID);
                            foreach (GamePlayer p in WorldMgr.GetAllPlayers())
                            {
                                if (p.PlayerCharacter.ConsortiaID == client.Player.PlayerCharacter.ConsortiaID)
                                    p.Out.SendTCP(packet);
                            }
                            GameServer.Instance.LoginServer.SendPacket(packet);
                            //return 0;
                        }
                    }
                    break;
                case (int)ConsortiaPackageType.CONSORTIA_LEVEL_UP:
                    {
                        if (client.Player.PlayerCharacter.ConsortiaID == 0)
                            return 0;
                        byte TypeUpdate = packet.ReadByte();
                        //bool result = false;
                        byte level = 0;
                        if (TypeUpdate == 1)
                        {
                            msg = "ConsortiaUpGradeHandler.Failed";
                            using (ConsortiaBussiness db = new ConsortiaBussiness())
                            {
                                ConsortiaInfo info = db.GetConsortiaSingle(client.Player.PlayerCharacter.ConsortiaID);
                                if (info == null)
                                {
                                    msg = "ConsortiaUpGradeHandler.NoConsortia";
                                }
                                else
                                {
                                    levelInfo = ConsortiaLevelMgr.FindConsortiaLevelInfo(info.Level + 1);

                                    if (levelInfo == null)
                                    {
                                        msg = "ConsortiaUpGradeHandler.NoUpGrade";
                                    }

                                    else if (levelInfo.NeedGold > client.Player.PlayerCharacter.Gold)
                                    {
                                        msg = "ConsortiaUpGradeHandler.NoGold";
                                    }
                                    else
                                    {
                                        using (ConsortiaBussiness cb = new ConsortiaBussiness())
                                        {
                                            if (cb.UpGradeConsortia(client.Player.PlayerCharacter.ConsortiaID, client.Player.PlayerCharacter.ID, ref msg))
                                            {
                                                info.Level++;
                                                client.Player.RemoveGold(levelInfo.NeedGold);
                                                GameServer.Instance.LoginServer.SendConsortiaUpGrade(info);
                                                msg = "ConsortiaUpGradeHandler.Success";
                                                result = true;
                                                level = (byte)info.Level;
                                            }
                                        }
                                    }
                                }
                                /*
                                if (info.Level >= 5)
                                {
                                    string Notice = LanguageMgr.GetTranslation("ConsortiaUpGradeHandler.Notice", info.ConsortiaName, info.Level);

                                    GSPacketIn pkg = new GSPacketIn((byte)ePackageType.SYS_NOTICE);
                                    pkg.WriteInt(2);
                                    pkg.WriteString(Notice);
                                    //GameServer.Instance.LoginServer.SendPacket(pkg);
                                    //GamePlayer[] players = Game.Server.Managers.WorldMgr.GetAllPlayers();
                                    foreach (GamePlayer p in players)
                                    {
                                        if (p != client.Player && p.PlayerCharacter.ConsortiaID != client.Player.PlayerCharacter.ConsortiaID)
                                            p.Out.SendTCP(pkg);
                                    }
                                }*/
                            }
                        }
                        //StoreLevel
                        else if (TypeUpdate == 2)
                        {
                            msg = "ConsortiaStoreUpGradeHandler.Failed";
                            ConsortiaInfo info = Managers.ConsortiaMgr.FindConsortiaInfo(client.Player.PlayerCharacter.ConsortiaID);
                            if (info == null)
                            {
                                msg = "ConsortiaStoreUpGradeHandler.NoConsortia";
                            }
                            else
                            {
                                using (ConsortiaBussiness cb = new ConsortiaBussiness())
                                {
                                    if (cb.UpGradeStoreConsortia(client.Player.PlayerCharacter.ConsortiaID, client.Player.PlayerCharacter.ID, ref msg))
                                    {
                                        info.StoreLevel++;
                                        GameServer.Instance.LoginServer.SendConsortiaStoreUpGrade(info);
                                        msg = "ConsortiaStoreUpGradeHandler.Success";
                                        result = true;
                                        level = (byte)info.StoreLevel;
                                    }
                                }
                            }
                        }
                        //ShopLevel
                        else if (TypeUpdate == 3)
                        {
                            msg = "ConsortiaShopUpGradeHandler.Failed";
                            ConsortiaInfo info = Managers.ConsortiaMgr.FindConsortiaInfo(client.Player.PlayerCharacter.ConsortiaID);
                            if (info == null)
                            {
                                msg = "ConsortiaShopUpGradeHandler.NoConsortia";
                            }
                            else
                            {
                                using (ConsortiaBussiness cb = new ConsortiaBussiness())
                                {
                                    if (cb.UpGradeShopConsortia(client.Player.PlayerCharacter.ConsortiaID, client.Player.PlayerCharacter.ID, ref msg))
                                    {
                                        info.ShopLevel++;
                                        GameServer.Instance.LoginServer.SendConsortiaShopUpGrade(info);
                                        msg = "ConsortiaShopUpGradeHandler.Success";
                                        result = true;
                                        level = (byte)info.ShopLevel;
                                    }
                                }
                            }
                            /*
                            if (info.ShopLevel >= 2)
                            {
                                string Notice = LanguageMgr.GetTranslation("ConsortiaShopUpGradeHandler.Notice", client.Player.PlayerCharacter.ConsortiaName, info.ShopLevel);

                                GSPacketIn pkg = new GSPacketIn((byte)ePackageType.SYS_NOTICE);
                                pkg.WriteInt(2);
                                pkg.WriteString(Notice);
                                //GameServer.Instance.LoginServer.SendPacket(pkg);
                                //GamePlayer[] players = Game.Server.Managers.WorldMgr.GetAllPlayers();
                                foreach (GamePlayer p in players)
                                {
                                    if (p != client.Player)
                                        p.Out.SendTCP(pkg);
                                }
                            }*/
                        }
                        //SmithLevel
                        else if (TypeUpdate == 4)
                        {
                            msg = "ConsortiaSmithUpGradeHandler.Failed";
                            ConsortiaInfo info = Managers.ConsortiaMgr.FindConsortiaInfo(client.Player.PlayerCharacter.ConsortiaID);
                            if (info == null)
                            {
                                msg = "ConsortiaSmithUpGradeHandler.NoConsortia";
                            }
                            else
                            {
                                using (ConsortiaBussiness cb = new ConsortiaBussiness())
                                {
                                    if (cb.UpGradeSmithConsortia(client.Player.PlayerCharacter.ConsortiaID, client.Player.PlayerCharacter.ID, ref msg))
                                    {
                                        info.SmithLevel++;
                                        GameServer.Instance.LoginServer.SendConsortiaSmithUpGrade(info);
                                        msg = "ConsortiaSmithUpGradeHandler.Success";
                                        result = true;
                                        level = (byte)info.SmithLevel;
                                    }
                                }
                            }
                            /*
                            if (info.SmithLevel >= 3)
                            {
                                string Notice = LanguageMgr.GetTranslation("ConsortiaSmithUpGradeHandler.Notice", client.Player.PlayerCharacter.ConsortiaName, info.SmithLevel);

                                GSPacketIn pkg = new GSPacketIn((byte)ePackageType.SYS_NOTICE);
                                pkg.WriteInt(2);
                                pkg.WriteString(Notice);
                                //GameServer.Instance.LoginServer.SendPacket(pkg);
                                //GamePlayer[] players = Game.Server.Managers.WorldMgr.GetAllPlayers();
                                foreach (GamePlayer p in players)
                                {
                                    if (p != client.Player)
                                        p.Out.SendTCP(pkg);
                                }
                            }*/
                        }
                        //BufferLevel
                        else if (TypeUpdate == 5)
                        {
                            msg = "ConsortiaBufferUpGradeHandler.Failed";
                            ConsortiaInfo info = Managers.ConsortiaMgr.FindConsortiaInfo(client.Player.PlayerCharacter.ConsortiaID);
                            if (info == null)
                            {
                                msg = "ConsortiaUpGradeHandler.NoConsortia";
                            }
                            else
                            {
                                using (ConsortiaBussiness cb = new ConsortiaBussiness())
                                {
                                    if (cb.UpGradeSkillConsortia(client.Player.PlayerCharacter.ConsortiaID, client.Player.PlayerCharacter.ID, ref msg))
                                    {
                                        info.SkillLevel++;
                                        GameServer.Instance.LoginServer.SendConsortiaKillUpGrade(info);
                                        msg = "ConsortiaBufferUpGradeHandler.Success";
                                        result = true;
                                        level = (byte)info.SkillLevel;
                                    }
                                }
                            }
                        }
                        client.Out.SendConsortiaLevelUp(TypeUpdate, level, result, LanguageMgr.GetTranslation(msg), client.Player.PlayerCharacter.ID);
                    }
                    break;
                case (int)ConsortiaPackageType.CONSORTIA_TASK_RELEASE:

                    break;
                case (int)ConsortiaPackageType.DONATE:

                    break;
                case (int)ConsortiaPackageType.CONSORTIA_EQUIP_CONTROL:
                    {
                        if (client.Player.PlayerCharacter.ConsortiaID == 0)
                            return 0;
                        //bool result = false;
                        int Rich1 = 0; int Rich2 = 0;
                        int Rich3 = 0; int Rich4 = 0;
                        int Rich5 = 0; int Rich6 = 0;
                        int Rich7 = 0;
                        msg = "ConsortiaEquipControlHandler.Fail";
                        ConsortiaEquipControlInfo EquipControlInfo = new ConsortiaEquipControlInfo();
                        EquipControlInfo.ConsortiaID = client.Player.PlayerCharacter.ConsortiaID;
                        using (ConsortiaBussiness db = new ConsortiaBussiness())
                        {
                            for (int i = 0; i < 5; i++)
                            {
                                EquipControlInfo.Riches = packet.ReadInt();
                                EquipControlInfo.Type = 1;
                                EquipControlInfo.Level = i + 1;
                                db.AddAndUpdateConsortiaEuqipControl(EquipControlInfo, client.Player.PlayerCharacter.ID, ref msg);
                                switch (i + 1)
                                {
                                    case 1:
                                        Rich1 = EquipControlInfo.Riches;
                                        break;
                                    case 2:
                                        Rich2 = EquipControlInfo.Riches;
                                        break;
                                    case 3:
                                        Rich3 = EquipControlInfo.Riches;
                                        break;
                                    case 4:
                                        Rich4 = EquipControlInfo.Riches;
                                        break;
                                    case 5:
                                        Rich5 = EquipControlInfo.Riches;
                                        break;
                                }
                            }
                            //smith
                            EquipControlInfo.Riches = packet.ReadInt();
                            EquipControlInfo.Type = 2;
                            EquipControlInfo.Level = 0;
                            Rich6 = EquipControlInfo.Riches;
                            db.AddAndUpdateConsortiaEuqipControl(EquipControlInfo, client.Player.PlayerCharacter.ID, ref msg);
                            //skill
                            EquipControlInfo.Riches = packet.ReadInt();
                            EquipControlInfo.Type = 3;
                            EquipControlInfo.Level = 0;
                            Rich7 = EquipControlInfo.Riches;
                            db.AddAndUpdateConsortiaEuqipControl(EquipControlInfo, client.Player.PlayerCharacter.ID, ref msg);
                            msg = "ConsortiaEquipControlHandler.Success";
                            result = true;
                        }
                        List<int> Riches = new List<int> { Rich1, Rich2, Rich3, Rich4, Rich5, Rich6, Rich7 };
                        client.Out.sendConsortiaEquipConstrol(result, Riches, client.Player.PlayerCharacter.ID);
                    }
                    break;
                case (int)ConsortiaPackageType.POLL_CANDIDATE:

                    break;
                case (int)ConsortiaPackageType.SKILL_SOCKET:

                    break;
                case (int)ConsortiaPackageType.CONSORTION_MAIL:
                    {
                        string title = packet.ReadString();
                        string content = packet.ReadString();
                        msg = "ConsortiaRichiUpdateHandler.Failed";
                        ConsortiaInfo ConsortiaInfo = Managers.ConsortiaMgr.FindConsortiaInfo(client.Player.PlayerCharacter.ConsortiaID);
                        
                        using (PlayerBussiness db = new PlayerBussiness())
                        {
                            ConsortiaUserInfo[] AllMembers = db.GetAllMemberByConsortia(client.Player.PlayerCharacter.ConsortiaID);
                            MailInfo message = new MailInfo();
                            foreach (ConsortiaUserInfo info in AllMembers)
                            {
                                message.SenderID = client.Player.PlayerCharacter.ID;
                                message.Sender = "Chủ Guild " + ConsortiaInfo.ConsortiaName;
                                message.ReceiverID = info.UserID;
                                message.Receiver = info.UserName;
                                message.Title = title;
                                message.Content = content;
                                message.Type = (int)eMailType.ConsortionEmail;
                                if (info.UserID != client.Player.PlayerCharacter.ID)
                                {
                                    if (db.SendMail(message))
                                    {                                        
                                        msg = "ConsortiaRichiUpdateHandler.Success";
                                        result = true;
                                        if (info.State != 0)
                                        {
                                            client.Player.Out.SendMailResponse(info.UserID, eMailRespose.Receiver);
                                        }
                                        client.Player.Out.SendMailResponse(client.Player.PlayerCharacter.ID, eMailRespose.Send);
                                    }
                                }
                                if (!result)
                                {
                                    client.Player.SendMessage("SendMail Error!");
                                    break;
                                }
                            }
                        }
                        //int _riches = c_info.Riches;
                        if (result)
                        {
                            using (ConsortiaBussiness db = new ConsortiaBussiness())
                            {
                                db.UpdateConsortiaRiches(client.Player.PlayerCharacter.ConsortiaID, client.Player.PlayerCharacter.ID, 1000, ref msg);
                            }
                        }
                        client.Out.SendConsortiaMail(result, client.Player.PlayerCharacter.ID);
                    }
                    break;
                case (int)ConsortiaPackageType.BUY_BADGE:

                    int BadgeID = packet.ReadInt();
                    msg = "BuyBadgeHandler.Fail";
                    int ValidDate = 30;
                    string BadgeBuyTime = DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss");
                    ConsortiaInfo _info = Managers.ConsortiaMgr.FindConsortiaInfo(client.Player.PlayerCharacter.ConsortiaID);
                    using (ConsortiaBussiness cb = new ConsortiaBussiness())
                    {
                        _info.BadgeID = BadgeID;
                        _info.ValidDate = ValidDate;
                        _info.BadgeBuyTime = BadgeBuyTime;

                        if (cb.BuyBadge(client.Player.PlayerCharacter.ConsortiaID, client.Player.PlayerCharacter.ID, _info, ref msg))
                        {
                            msg = "BuyBadgeHandler.Success";
                            result = true;                            
                        }
                        
                    }
                    if (result)
                    {
                        using (PlayerBussiness db = new PlayerBussiness())
                        {
                            ConsortiaUserInfo[] AllMembers = db.GetAllMemberByConsortia(client.Player.PlayerCharacter.ConsortiaID);

                            foreach (ConsortiaUserInfo info in AllMembers)
                            {
                                GamePlayer player = WorldMgr.GetPlayerById(info.UserID);
                                if (player != null)
                                {
                                    if (player.PlayerId != client.Player.PlayerCharacter.ID)
                                    {
                                        player.UpdateBadgeId(BadgeID);
                                        player.SendMessage("Guild của bạn đã thay đổi huy hiệu mới!");
                                        player.UpdateProperties();
                                    }
                                }
                            }
                        }
                    }
                    client.Player.SendMessage(msg);                        
                    client.Out.sendBuyBadge(BadgeID, ValidDate, result, BadgeBuyTime, client.Player.PlayerCharacter.ID);
                    client.Player.UpdateBadgeId(BadgeID);
                    client.Player.UpdateProperties();
                    break;
            }

            return 0;
        }
        
    }
}
