using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using log4net;
using System.Reflection;
using log4net.Util;
using Game.Server.GameObjects;
using System.Threading;
using Bussiness;
using Bussiness.Managers;
using SqlDataProvider.Data;


namespace Game.Server.Packets.Client
{
    [PacketHandler((byte)ePackageType.DAILY_AWARD, "场景用户离开")]
    public class DailyAwardHandler : IPacketHandler
    {
        #region IPacketHandler Members
        public int HandlePacket(GameClient client, Game.Base.Packets.GSPacketIn packet)
        {
            int type_award = packet.ReadInt();
            //0:nhận mổi ngày
            //1:isDailyGotten
            //2:mở trứng
            //3:Vip
            //5:điểm danh
            //Console.WriteLine("type_award: " + type_award);
            int money = 0;
            int gold = 0;
            int giftToken = 0;
            int medal = 0;
            int[] bags = new int[3];
            StringBuilder msg = new StringBuilder();
            List<ItemInfo> infos = new List<ItemInfo>();
            ItemTemplateInfo itemTemplateInfo;
            string full = "";
            switch (type_award)
            {
                case 0:
                    {
                        if (Managers.AwardMgr.AddDailyAward(client.Player))
                        {
                            using (PlayerBussiness db = new PlayerBussiness())
                            {
                                if (db.UpdatePlayerLastAward(client.Player.PlayerCharacter.ID, type_award))
                                {
                                    msg.Append(LanguageMgr.GetTranslation("Nhận được Thẻ x2 kinh nghiệm 60 phút"));
                                }
                                else
                                {
                                    msg.Append(LanguageMgr.GetTranslation("GameUserDailyAward.Fail"));
                                }
                            }

                        }
                        else
                        {
                            msg.Append(LanguageMgr.GetTranslation("GameUserDailyAward.Fail1"));
                        }
                    }
                    break;
                case 1:
                    {
                    }
                    break;
                case 2://112059
                    {
                        if (DateTime.Now.Date == client.Player.PlayerCharacter.LastGetEgg.Date)
                        {
                            msg.Append("Bạn đã nhận 1 lần hôm nay!");
                        }
                        else
                        {
                            using (PlayerBussiness db = new PlayerBussiness())
                            {
                                db.UpdatePlayerLastAward(client.Player.PlayerCharacter.ID, type_award);
                            }
                            itemTemplateInfo = ItemMgr.FindItemTemplate(112059);
                            OpenUpItem(itemTemplateInfo.Data, bags, infos, ref gold, ref money, ref giftToken, ref medal);
                        }
                    }
                    break;
                case 3:
                    {
                        int viplv = client.Player.PlayerCharacter.VIPLevel;
                        client.Player.LastVIPPackTime();
                        itemTemplateInfo = ItemMgr.FindItemTemplate(ItemMgr.FindItemBoxTypeAndLv(2, viplv).TemplateID);
                        OpenUpItem(itemTemplateInfo.Data, bags, infos, ref gold, ref money, ref giftToken, ref medal);

                        using (PlayerBussiness db = new PlayerBussiness())
                        {
                            db.UpdateLastVIPPackTime(client.Player.PlayerCharacter.ID);
                        }
                    }
                    break;
                case 5:
                    {
                        DailyLogListInfo DailyLogInfo;
                        using (ProduceBussiness db = new ProduceBussiness())
                        {
                            DailyLogInfo = db.GetDailyLogListSingle(client.Player.PlayerCharacter.ID);
                            string dayLog = DailyLogInfo.DayLog;
                            int countday = dayLog.Split(',').Length;
                            if (string.IsNullOrEmpty(dayLog))
                            {
                                dayLog = "True";
                                DailyLogInfo.UserAwardLog = 0;
                            }
                            else
                            {
                                dayLog += ",True";
                            }
                            DailyLogInfo.DayLog = dayLog;
                            DailyLogInfo.UserAwardLog++;
                            db.UpdateDailyLogList(DailyLogInfo);
                        }
                        msg.Append("Điểm danh thành công!");
                    }
                    break;
            }
            if (money != 0)
            {
                msg.Append(money + LanguageMgr.GetTranslation("OpenUpArkHandler.Money"));
                client.Player.AddMoney(money);                
            }
            if (gold != 0)
            {
                msg.Append(gold + LanguageMgr.GetTranslation("OpenUpArkHandler.Gold"));
                client.Player.AddGold(gold);
            }
            if (giftToken != 0)
            {
                msg.Append(giftToken + LanguageMgr.GetTranslation("OpenUpArkHandler.GiftToken"));
                client.Player.AddGiftToken(giftToken);
            }
            if (medal != 0) //trminhpc
            {
                msg.Append(medal + LanguageMgr.GetTranslation("OpenUpArkHandler.Medal"));
                client.Player.AddMedal(medal);
            }

            StringBuilder msga = new StringBuilder();
            foreach (ItemInfo info in infos)
            {
                msga.Append(info.Template.Name + "x" + info.Count.ToString() + ",");

                if (!client.Player.AddTemplate(info, info.Template.BagType, info.Count))
                {
                    using (PlayerBussiness db = new PlayerBussiness())
                    {
                        info.UserID = 0;
                        db.AddGoods(info);

                        MailInfo message = new MailInfo();
                        message.Annex1 = info.ItemID.ToString();
                        message.Content = LanguageMgr.GetTranslation("OpenUpArkHandler.Content1") + info.Template.Name + LanguageMgr.GetTranslation("OpenUpArkHandler.Content2");
                        message.Gold = 0;
                        message.Money = 0;
                        message.Receiver = client.Player.PlayerCharacter.NickName;
                        message.ReceiverID = client.Player.PlayerCharacter.ID;
                        message.Sender = message.Receiver;
                        message.SenderID = message.ReceiverID;
                        message.Title = LanguageMgr.GetTranslation("OpenUpArkHandler.Title") + info.Template.Name + "]";
                        message.Type = (int)eMailType.OpenUpArk;
                        db.SendMail(message);
                        full = LanguageMgr.GetTranslation("OpenUpArkHandler.Mail");
                    }
                }
            }
            if (msga.Length > 0)
            {
                msga.Remove(msga.Length - 1, 1);
                string[] msgstr = msga.ToString().Split(',');
                for (int i = 0; i < msgstr.Length; i++)
                {
                    int counts = 1;  //统计重复数量

                    //先统计重复数量
                    for (int j = i + 1; j < msgstr.Length; j++)
                    {
                        //重复，则更变字符串;
                        if (msgstr[i].Contains(msgstr[j]) && msgstr[j].Length == msgstr[i].Length)
                        {
                            counts++;
                            msgstr[j] = j.ToString();
                        }
                    }

                    //重复数字入串
                    if (counts > 1)
                    {
                        msgstr[i] = msgstr[i].Remove(msgstr[i].Length - 1, 1);
                        msgstr[i] = msgstr[i] + counts.ToString();
                    }

                    //判断是否留字符串
                    if (msgstr[i] != i.ToString())
                    {
                        msgstr[i] = msgstr[i] + ",";
                        msg.Append(msgstr[i]);
                    }

                }
            }
            if (msg.Length - 1 > 0)
            {
                msg.Remove(msg.Length - 1, 1);
                msg.Append(".");
            }
            client.Out.SendMessage(eMessageType.Normal, full + msg.ToString());

            if (!string.IsNullOrEmpty(full))
            {                
                client.Out.SendMailResponse(client.Player.PlayerCharacter.ID, eMailRespose.Receiver);
            }
            return 2;
        }

        #endregion
        public void OpenUpItem(string data, int[] bag, List<ItemInfo> infos, ref int gold, ref int money, ref int giftToken, ref int medal) //trminhpc
        {

            if (!string.IsNullOrEmpty(data))
            {
                ItemBoxMgr.CreateItemBox(Convert.ToInt32(data), infos, ref gold, ref money, ref giftToken, ref medal); //trminhpc
                return;
            }
        }
    }

}
