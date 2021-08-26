using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using SqlDataProvider.Data;
using Game.Server.Statics;
using System.Threading;
using log4net;
using System.Reflection;
namespace Game.Server.GameUtils
{
    /// <summary>
    /// 抽象的背包容器
    /// </summary>
    public abstract class CardAbstractInventory
    {
        private static readonly ILog log = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);

        protected object m_lock = new object();

        private int m_capalility;

        private int m_beginSlot;
        
        protected UsersCardInfo[] m_cards;

        protected UsersCardInfo temp_card;

        public int BeginSlot
        {
            get { return m_beginSlot; }
        }

        public int Capalility
        {            
            get
            {
                return m_capalility;
            }
            set
            {
                m_capalility = (value < 0) ? 0 : ((value > m_cards.Length) ? m_cards.Length : value);
            }

        }      

        public bool IsEmpty(int slot)
        {
            if ((slot >= 0) && (slot < m_capalility))
            {
                return (m_cards[slot] == null);
            }
            return true;
        }


        public CardAbstractInventory(int capability, int beginSlot)
        {
            m_capalility = capability;
            m_beginSlot = beginSlot;
            m_cards = new UsersCardInfo[capability];
            temp_card = new UsersCardInfo();
        }

        #region Add/Remove/AddTemp/RemoveTemp/Update
        public virtual void UpdateTempCard(UsersCardInfo card)
        {
            lock (m_lock)
            {
                temp_card = card;
            }
        }
        public virtual void UpdateCard()//int templateID)
        {
            int place = temp_card.Place;
            int templateid = temp_card.TemplateID;
            int tem_place = -1;
            if (place < 5)
            {
                ReplaceCardTo(temp_card, place);

                tem_place = FindPlaceByTamplateId(5, templateid); 
                MoveItem(place, tem_place);
            }
            else
            {
                ReplaceCardTo(temp_card, place);

                tem_place = FindPlaceByTamplateId(0, 5, templateid);
                if (GetItemAt(tem_place) != null)
                {
                    if (GetItemAt(tem_place).TemplateID == templateid)
                    {
                        MoveItem(place, tem_place);
                    }
                }
            }
        }
        public bool RemoveCardAt(int place)
        {
            return RemoveCard(GetItemAt(place));
        }
        public virtual bool RemoveCard(UsersCardInfo item)
        {
            if (item == null) return false;
            int place = -1;
            lock (m_lock)
            {
                for (int i = 0; i < m_capalility; i++)
                {
                    if (m_cards[i] == item)
                    {
                        place = i;
                        m_cards[i] = null;

                        break;
                    }
                }
            }

            if (place != -1)
            {
                OnPlaceChanged(place);
                item.Place = -1;

            }
            return place != -1;
        }

        public bool AddCard(UsersCardInfo card)
        {
            return AddCard(card, m_beginSlot);
        }

        public bool AddCard(UsersCardInfo card, int minSlot)
        {
            if (card== null) return false;

            int place = FindFirstEmptySlot(minSlot);

            return AddCardTo(card, place);
        }

        public virtual bool AddCardTo(UsersCardInfo card, int place)
        {
            if (card == null || place >= m_capalility || place < 0) return false;

            lock (m_lock)
            {
                if (m_cards[place] != null)
                    place = -1;
                else
                {
                    m_cards[place] = card;
                    card.Place = place;                    
                }
            }
            if (place != -1)
                OnPlaceChanged(place);

            return place != -1;
        }
        public virtual bool ReplaceCardTo(UsersCardInfo card, int place)
        {
            if (card == null || place >= m_capalility || place < 0) return false;
            lock (m_lock)
            {
                m_cards[place] = card;
                card.Place = place;
                OnPlaceChanged(place);
            }
            return true;
        }      

        public virtual bool MoveItem(int fromSlot, int toSlot)
        {
            if (fromSlot < 0 || toSlot < 0 || fromSlot >= m_capalility || toSlot >= m_capalility) return false;

            bool result = false;
            lock (m_lock)
            {                
                    result = ExchangeCards(fromSlot, toSlot);
            }

            if (result)
            {
                BeginChanges();
                try
                {
                    //OnPlaceChanged(fromSlot);
                    OnPlaceChanged(toSlot);
                }
                finally
                {
                    CommitChanges();
                }
            }

            return result;
        }
        public bool IsSolt(int slot)
        {
            return slot >= 0 && slot < m_capalility;
        }        

        #endregion

        #region Combine/Exchange/Stack Items       

        protected virtual bool ExchangeCards(int fromSlot, int toSlot)
        {
            UsersCardInfo toItem = m_cards[fromSlot];
            //m_cards[toSlot] = toItem;
            if (fromSlot != toSlot)
            {                
                //if (toItem != null)
                //m_cards[toSlot].Place = toSlot;
                m_cards[toSlot].TemplateID = toItem.TemplateID;
                m_cards[toSlot].Attack = toItem.Attack;
                m_cards[toSlot].Defence = toItem.Defence;
                m_cards[toSlot].Agility = toItem.Agility;
                m_cards[toSlot].Luck = toItem.Luck;
                m_cards[toSlot].Damage = toItem.Damage;
                m_cards[toSlot].Guard = toItem.Guard;
            }
            else
            {
                m_cards[toSlot].TemplateID = 0;
                m_cards[toSlot].Attack = 0;
                m_cards[toSlot].Defence = 0;
                m_cards[toSlot].Agility = 0;
                m_cards[toSlot].Luck = 0;
                m_cards[toSlot].Damage = 0;
                m_cards[toSlot].Guard = 0;
            }

            return true;
        }

        #endregion Combine/Exchange/Stack Items

        #region Find Items

        public virtual bool ResetCardSoul()
        {
            lock (m_lock)
            {
                for (int i = 0; i < 5; i++)
                {
                    m_cards[i].Level = 0;
                    m_cards[i].CardGP = 0;
                }
            }
            return true;
        }
        public virtual bool UpGraceSlot(int soulPoint, int lv, int place)
        {
            lock (m_lock)
            {
                m_cards[place].CardGP += soulPoint;
                m_cards[place].Level = lv;
            }
            return true;
        }
        public virtual UsersCardInfo GetItemAt(int slot)
        {
            if (slot < 0 || slot >= m_capalility) return null;

            return m_cards[slot];
        }
        public int FindFirstEmptySlot()
        {
            return FindFirstEmptySlot(m_beginSlot);
        }
        
        /// <summary>
        /// 查找从Start开始的第一个空位
        /// </summary>
        /// <param name="start"></param>
        /// <returns></returns>
        public int FindFirstEmptySlot(int minSlot)
        {
            if (minSlot >= m_capalility) return -1;

            lock (m_lock)
            {
                for (int i = minSlot; i < m_capalility; i++)
                {
                    if (m_cards[i] == null)
                    {
                        return i;
                    }
                }
                return -1;
            }
        }
        public int FindPlaceByTamplateId(int minSlot, int templateId)
        {
            if (minSlot >= m_capalility) return -1;

            lock (m_lock)
            {
                for (int i = minSlot; i < m_capalility; i++)
                {
                    if (m_cards[i] == null)
                    {
                        return -1;
                    }
                    else
                    {
                        if (m_cards[i].TemplateID == templateId)
                        {
                            return m_cards[i].Place;
                        }
                    }
                }
                return -1;
            }
        }
        public bool FindEquipCard(int templateId)
        {
            lock (m_lock)
            {
                for (int i = 0; i < 5; i++)
                {
                    if (m_cards[i].TemplateID == templateId)
                    {
                        return true;
                    }
                }
                return false;
            }
        }
        public int FindPlaceByTamplateId(int minSlot, int maxSlot, int templateId)
        {
            if (minSlot >= m_capalility) return -1;

            lock (m_lock)
            {
                for (int i = minSlot; i < maxSlot; i++)
                {
                    if (m_cards[i].TemplateID == templateId)
                    {
                        return m_cards[i].Place;
                    }
                }
                return -1;
            }
        }
        /// <summary>
        /// 查找最后一个空位
        /// </summary>
        /// <returns></returns>
        public int FindLastEmptySlot()
        {
            lock (m_lock)
            {
                for (int i = m_capalility - 1; i >= 0; i--)
                {
                    if (m_cards[i] == null)
                    {
                        return i;
                    }
                }
                return -1;
            }
        }

        /// <summary>
        /// 清除所有物品
        /// </summary>
        public virtual void Clear()
        {
            lock (m_lock)
            {
                for (int i = 0; i < m_capalility; i++)
                {
                    m_cards[i] = null;
                }
            }
        }

        

        public virtual UsersCardInfo GetItemByTemplateID(int minSlot, int templateId)
        {
            lock (m_lock)
            {
                for (int i = minSlot; i < m_capalility; i++)
                {
                    if (m_cards[i] != null && m_cards[i].TemplateID == templateId)
                    {
                        return m_cards[i];
                    }
                }
                return null;
            }
        }
        public virtual UsersCardInfo GetItemByPlace(int minSlot, int place)
        {
            lock (m_lock)
            {
                for (int i = minSlot; i < m_capalility; i++)
                {
                    if (m_cards[i] != null && m_cards[i].Place == place)
                    {
                        return m_cards[i];
                    }
                }
                return null;
            }
        }
        public virtual List<UsersCardInfo> GetItems()
        {
            return GetItems(0, m_capalility);
        }

        public virtual List<UsersCardInfo> GetItems(int minSlot, int maxSlot)
        {
            List<UsersCardInfo> list = new List<UsersCardInfo>();
            lock (m_lock)
            {
                for (int i = minSlot; i < maxSlot; i++)
                {
                    if (m_cards[i] != null)
                    {
                        list.Add(m_cards[i]);
                    }
                }
            }
            return list;
        }

        public int GetEmptyCount()
        {
            return GetEmptyCount(m_beginSlot);
        }

        public virtual int GetEmptyCount(int minSlot)
        {
            if (minSlot < 0 || minSlot > m_capalility - 1) return 0;

            int count = 0;
            lock (m_lock)
            {
                for (int i = minSlot; i < m_capalility; i++)
                {
                    if (m_cards[i] == null)
                    {
                        count++;
                    }
                }
            }
            return count;
        }

       
        #endregion

        #region BeginChanges/CommiteChanges/UpdateChanges

        protected List<int> m_changedPlaces = new List<int>();
        private int m_changeCount;

        protected void OnPlaceChanged(int place)
        {
            if (m_changedPlaces.Contains(place) == false)
                m_changedPlaces.Add(place);

            if (m_changeCount <= 0 && m_changedPlaces.Count > 0)
            {
                UpdateChangedPlaces();
            }
        }

        public void BeginChanges()
        {
            Interlocked.Increment(ref m_changeCount);
        }

        public void CommitChanges()
        {
            int changes = Interlocked.Decrement(ref m_changeCount);
            if (changes < 0)
            {
                if (log.IsErrorEnabled)
                    log.Error("Inventory changes counter is bellow zero (forgot to use BeginChanges?)!\n\n" + Environment.StackTrace);
                Thread.VolatileWrite(ref m_changeCount, 0);
            }
            if (changes <= 0 && m_changedPlaces.Count > 0)
            {
                UpdateChangedPlaces();
            }
        }

        public virtual void UpdateChangedPlaces()
        {
            m_changedPlaces.Clear();
        }
        
       #endregion
    }
}
