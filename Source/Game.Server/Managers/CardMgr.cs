using System;
using System.Collections.Generic;
using log4net;
using System.Linq;
using System.Reflection;
using System.Threading;
using Bussiness;
using SqlDataProvider.Data;


namespace Game.Server.Managers
{
    public class CardMgr
    {
        /// <summary>
        /// Defines a logger for this class.
        /// </summary>
        private static readonly ILog log = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);

        private static CardGrooveUpdateInfo[] m_grooveUpdate;
        private static Dictionary<int, List<CardGrooveUpdateInfo>> m_grooveUpdates;

        private static CardTemplateInfo[] m_cardBox;
        private static Dictionary<int, List<CardTemplateInfo>> m_cardBoxs;
        private static ThreadSafeRandom random = new ThreadSafeRandom();

        public static bool ReLoad()
        {
            try
            {
                CardGrooveUpdateInfo[] tempGrooveUpdate = LoadGrooveUpdateDb();
                Dictionary<int, List<CardGrooveUpdateInfo>> tempGrooveUpdates = LoadGrooveUpdates(tempGrooveUpdate);
                if (tempGrooveUpdate != null)
                {
                    Interlocked.Exchange(ref m_grooveUpdate, tempGrooveUpdate);
                    Interlocked.Exchange(ref m_grooveUpdates, tempGrooveUpdates);
                }

                CardTemplateInfo[] tempCardBox = LoadCardBoxDb();
                Dictionary<int, List<CardTemplateInfo>> tempCardBoxs = LoadCardBoxs(tempCardBox);
                if (tempCardBox != null)
                {
                    Interlocked.Exchange(ref m_cardBox, tempCardBox);
                    Interlocked.Exchange(ref m_cardBoxs, tempCardBoxs);
                }
            }
            catch (Exception e)
            {
                if (log.IsErrorEnabled)
                    log.Error("ReLoad", e);
                return false;
            }
            return true;
        }
        /// <summary>
        /// Initializes the CardBoxMgr. 
        /// </summary>
        /// <returns></returns>
        public static bool Init()
        {
            return ReLoad();
        }

        public static CardGrooveUpdateInfo[] LoadGrooveUpdateDb()
        {
            //Dictionary<int, CardGrooveUpdateInfo> list = new Dictionary<int, CardGrooveUpdateInfo>();
            using (PlayerBussiness db = new PlayerBussiness())
            {
                CardGrooveUpdateInfo[] infos = db.GetAllCardGrooveUpdate();
                return infos;
            }
            //return null;
        }
        public static Dictionary<int, List<CardGrooveUpdateInfo>> LoadGrooveUpdates(CardGrooveUpdateInfo[] GrooveUpdates)
        {
            Dictionary<int, List<CardGrooveUpdateInfo>> infos = new Dictionary<int, List<CardGrooveUpdateInfo>>();
            foreach (CardGrooveUpdateInfo info in GrooveUpdates)
            {
                if (!infos.Keys.Contains(info.Type))
                {
                    IEnumerable<CardGrooveUpdateInfo> temp = GrooveUpdates.Where(s => s.Type == info.Type);
                    infos.Add(info.Type, temp.ToList());
                }
            }
            return infos;
        }
        /// <summary>
        /// 从数据库中加载箱子物品
        /// </summary>
        /// <returns></returns>
        public static CardTemplateInfo[] LoadCardBoxDb()
        {
            //Dictionary<int, CardTemplateInfo> list = new Dictionary<int, CardTemplateInfo>();
            using (PlayerBussiness db = new PlayerBussiness())
            {
                CardTemplateInfo[] infos = db.GetAllCardTemplate();
                return infos;
            }
            //return null;
        }

        
        public static Dictionary<int, List<CardTemplateInfo>> LoadCardBoxs(CardTemplateInfo[] CardBoxs)
        {
            Dictionary<int, List<CardTemplateInfo>> infos = new Dictionary<int, List<CardTemplateInfo>>();
            foreach (CardTemplateInfo info in CardBoxs)
            {
                if (!infos.Keys.Contains(info.CardID))
                {
                    IEnumerable<CardTemplateInfo> temp = CardBoxs.Where(s => s.CardID == info.CardID);
                    infos.Add(info.CardID, temp.ToList());
                }
            }
            return infos;
        }

        public static CardTemplateInfo GetCard(int cardId)
        {
            CardTemplateInfo card = new CardTemplateInfo();
            List<CardTemplateInfo> unFiltInfos = FindCardBox(cardId);
            int dropItemCount = 1;
            int maxRound = 0;
            foreach (CardTemplateInfo info in unFiltInfos)
            {
                if (maxRound >= info.probability)
                {
                    maxRound = info.probability;
                }
            }
            maxRound = random.Next(maxRound);
            List<CardTemplateInfo> RoundInfos = unFiltInfos.Where(s => s.probability >= maxRound).ToList();
            int maxItems = RoundInfos.Count();
            if (maxItems > 0)
            {
                dropItemCount = dropItemCount > maxItems ? maxItems : dropItemCount;
                int[] randomArray = GetRandomUnrepeatArray(0, maxItems - 1, dropItemCount);
                foreach (int i in randomArray)
                {
                    card = RoundInfos[i];
                }
            }
            if (card.CardType == 0)
            {
                return null;
            }
            return card;
        }
        public static int[] GetRandomUnrepeatArray(int minValue, int maxValue, int count)
        {
            int j;
            int[] resultRound = new int[count];
            for (j = 0; j < count; j++)
            {
                int i = random.Next(minValue, maxValue + 1);
                int num = 0;
                for (int k = 0; k < j; k++)
                {
                    if (resultRound[k] == i)
                    {
                        num = num + 1;
                    }
                }
                if (num == 0)
                {
                    resultRound[j] = i;
                }
                else
                {
                    j = j - 1;
                }
            }
            return resultRound;
        }
        /// <summary>
        /// 查找一条箱子物品
        /// </summary>
        /// <param name="DataId"></param>
        /// <returns></returns>
        public static List<CardTemplateInfo> FindCardBox(int cardId)
        {
            if(m_cardBoxs == null)
                Init();
            if (m_cardBoxs.ContainsKey(cardId))
            {
                List<CardTemplateInfo> items = m_cardBoxs[cardId];
                return items;
            }
            return null;
        }

        public static CardTemplateInfo GetSingleCard(int id)
        {

            List<CardTemplateInfo> lists = GetAllCard();
            foreach (CardTemplateInfo info in lists)
            {
                if (info.ID == id)
                {
                    return info;
                }

            }
            return null;
        }

        public static List<CardTemplateInfo> GetAllCard()
        {
            if (m_cardBox == null)
                Init();
            List<CardTemplateInfo> lists = new List<CardTemplateInfo>();
            Dictionary<int, CardTemplateInfo> infos = new Dictionary<int, CardTemplateInfo>();
            foreach (CardTemplateInfo info in m_cardBox)
            {
                if (!infos.Keys.Contains(info.CardID))
                {
                    if (info.CardID != 314150)
                    {
                        lists.Add(info);
                    }
                    infos.Add(info.CardID, info);
                }
                   
            }
            return lists;
        }

        public static List<CardGrooveUpdateInfo> FindCardGrooveUpdate(int type)
        {
            if (m_grooveUpdates == null)
                Init();
            if (m_grooveUpdates.ContainsKey(type))
            {
                List<CardGrooveUpdateInfo> items = m_grooveUpdates[type];
                return items;
            }
            return null;
        }

        public static int CardCount()
        {
            return m_cardBox.Count();
        }
        public static int MaxLv(int type)
        {
            return FindCardGrooveUpdate(type).Count - 1;            
        }
        //---------------------------------------
        public static int GetLevel(int GP, int type)
        {
            if (GP >= FindCardGrooveUpdate(type)[MaxLv(type)].Exp)
            {
                return FindCardGrooveUpdate(type)[MaxLv(type)].Level;
            }
            
            else
            {
                for (int i = 1; i <= MaxLv(type); i++)
                {
                    if (GP < FindCardGrooveUpdate(type)[i].Exp)
                    {
                        int lv = (i - 1) == -1 ? 0 : (i - 1);
                        return FindCardGrooveUpdate(type)[lv].Level;
                    }
                }

            }
            return 0;
        }

        public static int GetProp(UsersCardInfo slot, int type)
        {
            int prop = 0;
            for (int i = 0; i < slot.Level; i++)
            {
                prop += GetGrooveSlot(slot.Type, i, type);
            }
            if (slot.CardID != 0)
            {
                prop += GetPropCard(slot.CardType, slot.CardID, type);
            }
            return prop;
        }

        public static int GetGrooveSlot(int type, int lv, int typeProp)
        {           
            try
            {
                foreach (CardGrooveUpdateInfo p in m_grooveUpdate)
                {
                    if (p.Type == type && p.Level == lv)
                    {
                        switch (typeProp)
                        {
                            case 0:
                                return p.Attack;
                            case 1:
                                return p.Defend;
                            case 2:
                                return p.Agility;
                            case 3:
                                return p.Lucky;
                            case 4:
                                return p.Damage;
                            case 5:
                                return p.Guard;
                        }
                    }
                }
            }
            finally
            {
                //do something
            }
            return 0;
        }
        public static int GetPropCard(int cardtype, int cardID, int type)
        {            
            try
            {
                foreach (CardTemplateInfo p in m_cardBox)
                {
                    if (p.CardType == cardtype && p.CardID == cardID)
                    {
                        switch (type)
                        {
                            case 0:
                                return p.AddAttack;
                            case 1:
                                return p.AddDefend;
                            case 2:
                                return p.AddAgility;
                            case 3:
                                return p.AddLucky;
                            case 4:
                                return p.AddDamage;
                            case 5:
                                return p.AddGuard;
                        }
                    }
                }
            }
            finally
            {
                // do some thing
            }
            return 0;
        }
        public static int GetGP(int level, int type)
        {
            for (int i = 1; i <= MaxLv(type); i++)
            {
                if (level == FindCardGrooveUpdate(type)[i].Level)
                {                   
                    return FindCardGrooveUpdate(type)[i].Exp;
                }
            }

            return 0;
        }
    }
}
