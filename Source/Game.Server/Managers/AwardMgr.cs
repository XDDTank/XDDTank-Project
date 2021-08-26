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
using Game.Server.Statics;
using Game.Server.Packets;
using Game.Server.Buffer;
using Game.Base.Packets;

namespace Game.Server.Managers
{
    public class AwardMgr
    {
        private static readonly ILog log = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);

        private static Dictionary<int, DailyAwardInfo> _dailyAward;

        private static bool _dailyAwardState;

        private static System.Threading.ReaderWriterLock m_lock;

        public static bool ReLoad()
        {
            try
            {
                Dictionary<int, DailyAwardInfo> tempDaily = new Dictionary<int, DailyAwardInfo>();

                if (LoadDailyAward(tempDaily))
                {
                    m_lock.AcquireWriterLock(Timeout.Infinite);
                    try
                    {
                        _dailyAward = tempDaily;
                        return true;
                    }
                    catch
                    { }
                    finally
                    {
                        m_lock.ReleaseWriterLock();
                    }

                }
            }
            catch (Exception e)
            {
                if (log.IsErrorEnabled)
                    log.Error("AwardMgr", e);
            }

            return false;
        }

        /// <summary>
        /// Initializes the BallMgr. 
        /// </summary>
        /// <returns></returns>
        public static bool Init()
        {
            try
            {
                m_lock = new System.Threading.ReaderWriterLock();
                _dailyAward = new Dictionary<int, DailyAwardInfo>();
                _dailyAwardState = false;
                return LoadDailyAward(_dailyAward);
            }
            catch (Exception e)
            {
                if (log.IsErrorEnabled)
                    log.Error("AwardMgr", e);
                return false;
            }

        }

        #region DailyAward

        public static bool DailyAwardState
        {
            set
            {
                _dailyAwardState = value;
            }
            get
            {
                return _dailyAwardState;
            }
        }

        private static bool LoadDailyAward(Dictionary<int, DailyAwardInfo> awards)
        {
            using (ProduceBussiness db = new ProduceBussiness())
            {
                DailyAwardInfo[] infos = db.GetAllDailyAward();
                foreach (DailyAwardInfo info in infos)
                {
                    if(!awards.ContainsKey(info.ID))
                    {
                        awards.Add(info.ID, info);
                    }
                }
            }

            return true;
        }

        public static DailyAwardInfo[] GetAllAwardInfo()
        {
            DailyAwardInfo[] infos = null;
            m_lock.AcquireReaderLock(Timeout.Infinite);
            try
            {
                infos = _dailyAward.Values.ToArray();
            }
            catch
            { }
            finally
            {
                m_lock.ReleaseReaderLock();
            }
            return infos == null ? new DailyAwardInfo[0] : infos;
        }
        public static bool AddDailyAward(GamePlayer player)
        {
            if (DateTime.Now.Date == player.PlayerCharacter.LastAward.Date)
            {
                return false;
            }
            player.PlayerCharacter.DayLoginCount++;
            player.PlayerCharacter.LastAward = DateTime.Now;
            DailyAwardInfo[] infos = GetAllAwardInfo();
            foreach (DailyAwardInfo info in infos)
            {
                if (info.Type == 0)
                {
                    ItemTemplateInfo template = Bussiness.Managers.ItemMgr.FindItemTemplate(info.TemplateID);
                    if (template != null)
                    {
                        AbstractBuffer buffer = BufferList.CreateBufferHour(template, info.ValidDate);
                        buffer.Start(player);
                        return true;
                    }

                }
            }
            return false;            
        }
        //0表示男女，1男2女
        //type 1表示物品，2表示金币，3表示点券，4表示经验，5表示功勋，6表示BUFF
        public static bool AddSignAwards(GamePlayer player, int DailyLog)
        {            
            DailyAwardInfo[] infos = GetAllAwardInfo();            
            StringBuilder msg = new StringBuilder();            
            string full = string.Empty;
            bool has = false;
            int templateID = 0;
            int count = 1;
            int validDate = 0;
            bool isBinds = true;
            bool result = false;
            foreach (DailyAwardInfo award in infos)
            {                
                has = true;
                switch (DailyLog)
                {
                    case 3:
                        if (award.Type == DailyLog)
                        {                            
                            count = award.Count;
                            player.AddGiftToken(count);
                            result = true;
                        }
                        break;
                    case 9:
                        if (award.Type == DailyLog)
                        {
                            templateID = award.TemplateID;
                            count = award.Count;
                            validDate = award.ValidDate;
                            isBinds = award.IsBinds;
                            result = true;
                        }        
                        break;
                    case 17:
                        if (award.Type == DailyLog)
                        {
                            templateID = award.TemplateID;
                            count = award.Count;
                            validDate = award.ValidDate;
                            isBinds = award.IsBinds;
                            result = true;
                        }              
                        break;
                    case 26:
                        if (award.Type == DailyLog)
                        {
                            templateID = award.TemplateID;
                            count = award.Count;
                            validDate = award.ValidDate;
                            isBinds = award.IsBinds;
                            result = true;
                        }
                        break;
                    
                }
            }
            ItemTemplateInfo itemTemplateInfo = ItemMgr.FindItemTemplate(templateID);
            if (itemTemplateInfo != null)
            {
                int itemCount = count;
                for (int len = 0; len < itemCount; len += itemTemplateInfo.MaxCount)
                {
                    int counts = len + itemTemplateInfo.MaxCount > itemCount ? itemCount - len : itemTemplateInfo.MaxCount;
                    ItemInfo item = ItemInfo.CreateFromTemplate(itemTemplateInfo, counts, (int)ItemAddType.DailyAward);
                    item.ValidDate = validDate;
                    item.IsBinds = isBinds;
                    if (!player.AddTemplate(item, item.Template.BagType, item.Count))
                    {
                        has = true;
                        using (PlayerBussiness db = new PlayerBussiness())
                        {
                            item.UserID = 0;
                            db.AddGoods(item);
                            MailInfo message = new MailInfo();
                            message.Annex1 = item.ItemID.ToString();
                            message.Content = LanguageMgr.GetTranslation("AwardMgr.AddDailyAward.Content", item.Template.Name);
                            message.Gold = 0;
                            message.Money = 0;
                            message.Receiver = player.PlayerCharacter.NickName;
                            message.ReceiverID = player.PlayerCharacter.ID;
                            message.Sender = message.Receiver;
                            message.SenderID = message.ReceiverID;
                            message.Title = LanguageMgr.GetTranslation("AwardMgr.AddDailyAward.Title", item.Template.Name);
                            message.Type = (int)eMailType.DailyAward;
                            db.SendMail(message);

                            full = LanguageMgr.GetTranslation("AwardMgr.AddDailyAward.Mail");
                        }
                    }
                }
            }

            if (has)
            {    
                if (!string.IsNullOrEmpty(full))
                {
                    player.Out.SendMailResponse(player.PlayerCharacter.ID, eMailRespose.Receiver);
                }
            }

            return result;
        }

        #endregion
    }
}
