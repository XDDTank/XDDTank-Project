using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using SqlDataProvider.Data;
using Game.Server.Statics;
using System.Threading;
using log4net;
using System.Reflection;
//using Game.Server.Managers;
using Game.Logic;
using Bussiness;
using Bussiness.Managers;
namespace Game.Server.GameUtils
{
    /// <summary>
    /// 抽象的背包容器
    /// </summary>
    public abstract class PlayerFarmInventory
    {
        private static readonly ILog log = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);

        protected object m_lock = new object();

        private int m_capalility;

        private int m_beginSlot;
        
        protected UserFarmInfo m_farm;

        protected UserFieldInfo[] m_fields;

        protected int m_farmstatus;

        public int Status
        {
            get { return m_farmstatus; }
        }
        
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
                m_capalility = (value < 0) ? 0 : ((value > m_fields.Length) ? m_fields.Length : value);
            }

        }
        
        public bool IsEmpty(int slot)
        {
            if ((slot >= 0) && (slot < m_capalility))
            {
                return (m_fields[slot] == null);
            }
            return true;
        }


        public PlayerFarmInventory(int capability, int beginSlot)
        {
            m_capalility = capability;
            m_beginSlot = beginSlot;
            m_fields = new UserFieldInfo[capability];
            m_farm = new UserFarmInfo();            
            m_farmstatus = 0;
        }
        
        #region Add/Remove/AddTemp/RemoveTemp

        public bool AddField(UserFieldInfo item)
        {
            return AddField(item, m_beginSlot);
        }

        public bool AddField(UserFieldInfo item, int minSlot)
        {
            if (item == null) return false;

            int place = FindFirstEmptySlot(minSlot);

            return AddFieldTo(item, place);
        }

        public virtual bool AddFieldTo(UserFieldInfo item, int place)
        {
            if (item == null || place >= m_capalility || place < 0) return false;

            lock (m_lock)
            {
               m_fields[place] = item;
               if (m_fields[place] != null)
                   place = -1;
               else
               {
                   m_fields[place] = item;
                   item.FieldID = place;
               }
            }
            
            return place != -1;
        }        

        public virtual bool RemoveItem(UserFieldInfo item)
        {
            if (item == null) return false;
            int place = -1;
            lock (m_lock)
            {
                for (int i = 0; i < m_capalility; i++)
                {
                    if (m_fields[i] == item)
                    {
                        place = i;
                        m_fields[i] = null;

                        break;
                    }
                }
            }          

            return place != -1;
        }

        public bool RemoveItemAt(int place)
        {
            return RemoveItem(GetItemAt(place));
        }  
        
        

        #endregion
        
        #region Find Items

        public virtual UserFieldInfo GetItemAt(int slot)
        {
            if (slot < 0 || slot >= m_capalility) return null;

            return m_fields[slot];
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
                    if (m_fields[i] == null)
                    {
                        return i;
                    }
                }
                return -1;
            }
        }
        public void ClearFields()
        {
           
            lock (m_lock)
            {
                for (int i = m_beginSlot; i < m_capalility; i++)
                {
                    if (m_fields[i] != null)
                    {
                        RemoveItem(m_fields[i]);
                    }
                }
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
                    if (m_fields[i] == null)
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
        public virtual void ClearFarm()
        {
            lock (m_lock)
            {
                m_farm = null;
            }
        }
        public virtual void UpdateGainCount(int fieldId, int count)
        {
            lock (m_lock)
            {
                m_fields[fieldId].GainCount = count;
            }
        }
        public virtual void loadFarm(UserFarmInfo farm)
        {            
            lock (m_lock)
            {
                m_farm = farm;

            }
           
        }
        public virtual bool GrowField(int fieldId, int templateID)
        {
            ItemTemplateInfo Temp = ItemMgr.FindItemTemplate(templateID);
            lock (m_lock)
            {
                m_fields[fieldId].SeedID = Temp.TemplateID;
                m_fields[fieldId].PlantTime = DateTime.Now;
                m_fields[fieldId].GainCount = Temp.Property2;
                m_fields[fieldId].FieldValidDate = Temp.Property3;
                
            }
            return true;
        }
        //killCropField
        public virtual bool killCropField(int fieldId)
        {
            lock (m_lock)
            {
                if (m_fields[fieldId] != null)
                {
                    m_fields[fieldId].SeedID = 0;
                    m_fields[fieldId].FieldValidDate = 1;
                    m_fields[fieldId].AccelerateTime = 0;
                    m_fields[fieldId].GainCount = 0;
                }
            }
            return true;
        }
        
        public virtual void CreateFarm(int ID, string name )
        {
            string PayFieldMoney = PetMgr.FindConfig("PayFieldMoney").Value;
            string PayAutoMoney = PetMgr.FindConfig("PayAutoMoney").Value;
            UserFarmInfo farm = new UserFarmInfo();
            farm.FarmID = ID;
            farm.FarmerName = name;
            farm.isFarmHelper = false;
            farm.isAutoId = 0;
            farm.AutoPayTime = DateTime.Now;
            farm.AutoValidDate = 1;
            farm.GainFieldId = 0;
            farm.KillCropId = 0;
            farm.PayAutoMoney = PayAutoMoney;
            farm.PayFieldMoney = PayFieldMoney;

            lock (m_lock)
            {
                m_farm = farm;                
            }
            CreateNewField(ID, 0, 8);

        }
        public virtual bool HelperSwitchFields(bool isHelper, int seedID, int seedTime, int haveCount, int getCount)
        {
            if (isHelper)
            {
                for (int i = 0; i < m_fields.Length; i++)
                {
                    lock (m_lock)
                    {
                        if (m_fields[i] != null)
                        {
                            m_fields[i].SeedID = 0;
                            m_fields[i].FieldValidDate = 1;
                            m_fields[i].AccelerateTime = 0;
                            m_fields[i].GainCount = 0;
                        }
                    }
                }
            }
            lock (m_lock)
            {
                m_farm.isFarmHelper = isHelper;
                m_farm.isAutoId = seedID;
                m_farm.AutoPayTime = DateTime.Now;
                m_farm.AutoValidDate = seedTime;
                m_farm.GainFieldId = (getCount / 10); // -haveCount;
                m_farm.KillCropId = getCount;
            }
            
            return true;
        }
        public virtual void CreateNewField(int ID, int minslot, int maxslot)
        {
            for (int i = minslot; i < maxslot; i++)
            {
                UserFieldInfo field = new UserFieldInfo();
                field.FarmID = ID;
                field.FieldID = i;
                field.SeedID = 0;
                field.PayTime = DateTime.Now.AddYears(100);
                field.payFieldTime = 876000;
                field.PlantTime = DateTime.Now;
                field.GainCount = 0;
                field.FieldValidDate = 1;
                field.AccelerateTime = 0;
                field.AutomaticTime = DateTime.Now;

                AddFieldTo(field, i);
            }
        }
        public virtual bool CreateField(int ID, List<int> fieldIds, int payFieldTime)
        {
            for (int i = 0; i < fieldIds.Count; i++)
            {
                int place = fieldIds[i];
                if (m_fields[place] == null)
                {                    
                    UserFieldInfo field = new UserFieldInfo();
                    field.FarmID = ID;
                    field.FieldID = place;
                    field.SeedID = 0;
                    field.PayTime = DateTime.Now.AddDays((payFieldTime / 24));
                    field.payFieldTime = payFieldTime;
                    field.PlantTime = DateTime.Now;
                    field.GainCount = 0;
                    field.FieldValidDate = 1;
                    field.AccelerateTime = 0;
                    field.AutomaticTime = DateTime.Now;
                    field.IsExit = true;
                    AddFieldTo(field, place);
                }
                else
                {
                    m_fields[place].PayTime = DateTime.Now.AddDays((payFieldTime / 24));
                    m_fields[place].payFieldTime = payFieldTime;
                }
            }
            return true;
        }
        public virtual int AccelerateTimeFields(DateTime PlantTime, int FieldValidDate)
        {
            DateTime _now = DateTime.Now;
            int validH = _now.Hour - PlantTime.Hour;
            int validM = _now.Minute - PlantTime.Minute;
            int AccelerateTime = 0;

            if (validH < 0)
            {
                validH = 24 + validH;
            }
            if (validM < 0)
            {
                validM = 60 + validM;
            }
            AccelerateTime = (validH * 60) + validM;
            if (AccelerateTime >= FieldValidDate)
            {
                AccelerateTime = FieldValidDate;
            }

            return AccelerateTime;
        }
        public virtual bool AccelerateTimeFields()
        {
            lock (m_lock)
            {
                for (int i = 0; i < m_capalility; i++)
                {
                    if (m_fields[i] != null)
                    {
                        if (m_fields[i].SeedID > 0)
                        {
                            DateTime PlantTime = m_fields[i].PlantTime;
                            int FieldValidDate = m_fields[i].FieldValidDate;
                            m_fields[i].AccelerateTime = AccelerateTimeFields(PlantTime, FieldValidDate);
                        }
                    }
                }
            }
            return true;
        }
        
        public virtual UserFarmInfo GetFarm()
        {            
            return m_farm;
        }
        public virtual UserFieldInfo[] GetFields()
        {
            List<UserFieldInfo> list = new List<UserFieldInfo>();
            lock (m_lock)
            {
                for (int i = 0; i < m_capalility; i++)
                {
                    if (m_fields[i] != null)
                    {
                        TimeSpan thisTime = m_fields[i].PayTime - DateTime.Now;
                        if (thisTime.Days > 0)
                        {
                            list.Add(m_fields[i]);
                        }
                    }
                }
            }
            return list.ToArray();
        }
        public virtual UserFieldInfo GetFieldAt(int slot)
        {
            if (slot < 0 || slot >= m_capalility) return null;

            return m_fields[slot];
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
                    if (m_fields[i] == null)
                    {
                        count++;
                    }
                }
            }
            return count;
        }

        public virtual int payFieldMoneyToWeek()
        {
            return int.Parse(m_farm.PayFieldMoney.Split('|')[0].Split(',')[1]);
        }
        public virtual int payFieldTimeToWeek()
        {
            return int.Parse(m_farm.PayFieldMoney.Split('|')[0].Split(',')[0]);
        }
        public virtual int payFieldMoneyToMonth()
        {
            return int.Parse(m_farm.PayFieldMoney.Split('|')[1].Split(',')[1]);
        }
        public virtual int payFieldTimeToMonth()
        {
            return int.Parse(m_farm.PayFieldMoney.Split('|')[1].Split(',')[0]);
        }
        //
        public virtual UserFarmInfo CreateFarmForNulll(int ID)
        {            
            UserFarmInfo farm = new UserFarmInfo();
            farm.FarmID = ID;
            farm.FarmerName = "Null";
            farm.isFarmHelper = false;
            farm.isAutoId = 0;
            farm.AutoPayTime = DateTime.Now;
            farm.AutoValidDate = 1;
            farm.GainFieldId = 0;
            farm.KillCropId = 0;
            return farm;
        }
        public virtual UserFieldInfo[] CreateFieldsForNull(int ID)
        {
            List<UserFieldInfo> CreateFields = new List<UserFieldInfo>();
            for (int i = 0; i < 8; i++)
            {
                UserFieldInfo field = new UserFieldInfo();
                field.FarmID = ID;
                field.FieldID = i;
                field.SeedID = 0;
                field.PayTime = DateTime.Now;
                field.payFieldTime = 365000;
                field.PlantTime = DateTime.Now;
                field.GainCount = 0;
                field.FieldValidDate = 1;
                field.AccelerateTime = 0;
                field.AutomaticTime = DateTime.Now;

                CreateFields.Add(field);
            }
            return CreateFields.ToArray();
        }
        //
        #endregion
        
    }
}
