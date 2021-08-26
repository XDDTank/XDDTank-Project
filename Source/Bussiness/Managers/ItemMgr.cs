using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using SqlDataProvider.Data;
using log4net;
using System.Reflection;
using log4net.Util;
using System.Threading;

namespace Bussiness.Managers
{
    public class ItemMgr
    {
        /// <summary>
        /// Defines a logger for this class.
        /// </summary>
        private static readonly ILog log = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);

        private static Dictionary<int, ItemTemplateInfo> _items;

        private static Dictionary<int, LoadUserBoxInfo> _timeBoxs;

        private static System.Threading.ReaderWriterLock m_lock;

        public static bool ReLoad()
        {
            try
            {
                Dictionary<int, ItemTemplateInfo> tempItems = new Dictionary<int, ItemTemplateInfo>();
                Dictionary<int, LoadUserBoxInfo> tempTimeBoxsItems = new Dictionary<int, LoadUserBoxInfo>();
                if (LoadItem(tempItems, tempTimeBoxsItems))
                {
                    m_lock.AcquireWriterLock(Timeout.Infinite);
                    try
                    {
                        _items = tempItems;
                        _timeBoxs = tempTimeBoxsItems;
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
                    log.Error("ReLoad", e);
            }

            return false;
        }

        /// <summary>
        /// Initializes the ItemMgr. 
        /// </summary>
        /// <returns></returns>
        public static bool Init()
        {
            try
            {
                m_lock = new System.Threading.ReaderWriterLock();
                _items = new Dictionary<int, ItemTemplateInfo>();
                _timeBoxs = new Dictionary<int, LoadUserBoxInfo>();
                return LoadItem(_items, _timeBoxs);
            }
            catch (Exception e)
            {
                if (log.IsErrorEnabled)
                    log.Error("Init", e);
                return false;
            }
        }

        public static bool LoadItem(Dictionary<int, ItemTemplateInfo> infos, Dictionary<int, LoadUserBoxInfo> userBoxs)
        {
            using (ProduceBussiness db = new ProduceBussiness())
            {
                ItemTemplateInfo[] items = db.GetAllGoods();
                foreach (ItemTemplateInfo item in items)
                {
                   
                    if (!infos.Keys.Contains(item.TemplateID))
                    {
                        infos.Add(item.TemplateID, item);
                    }
                }
                LoadUserBoxInfo[] userBoxItems = db.GetAllTimeBoxAward();
                foreach (LoadUserBoxInfo box in userBoxItems)
                {

                    if (!infos.Keys.Contains(box.ID))
                    {
                        userBoxs.Add(box.ID, box);
                    }
                }
            }
            return true;
        }
        public static LoadUserBoxInfo FindItemBoxTypeAndLv(int type, int lv)
        {
            if (_timeBoxs == null)
                Init();

            m_lock.AcquireReaderLock(Timeout.Infinite);
            try
            {
                foreach (LoadUserBoxInfo p in _timeBoxs.Values)
                {
                    if (p.Type == type && p.Level == lv)
                    {
                        return p;
                    }
                }
            }
            finally
            {
                m_lock.ReleaseReaderLock();
            }
            return null;
        }
        public static LoadUserBoxInfo FindItemBoxTemplate(int Id)
        {
            if (_timeBoxs == null)
                Init();

            m_lock.AcquireReaderLock(Timeout.Infinite);
            try
            {
                if (_timeBoxs.Keys.Contains(Id))
                {
                    return _timeBoxs[Id];
                }
            }
            finally
            {
                m_lock.ReleaseReaderLock();
            }
            return null;
        }
        public static List<ItemTemplateInfo> FindRecycleItemTemplate(int qmin, int qmax)
        {            
            if (_items == null)
                Init();

            List<ItemTemplateInfo> Lists = new List<ItemTemplateInfo>();
            m_lock.AcquireReaderLock(Timeout.Infinite);
            try
            {
                foreach (ItemTemplateInfo p in _items.Values)
                {
                    if (p.Quality > qmin && p.Quality <= qmax  && p.TemplateID > 0 && p.TemplateID != 11107)
                    {
                        switch (p.CategoryID)
                        {
                            case 1:
                            case 2:
                            case 3:
                            case 4:
                            case 5:
                            case 6:
                            case 7:
                            case 8:
                            case 9:
                            case 11:
                            case 13:
                            case 14:
                            case 15:
                            case 16:
                            case 17:
                            case 18:
                                {
                                    Lists.Add(p);
                                }
                                break;
                        }
                    }
                }
            }
            finally
            {
                m_lock.ReleaseReaderLock();
            }
            return Lists;
        }

        public static ItemTemplateInfo FindItemTemplate(int templateId)
        {
            if (_items == null)
                Init();

            m_lock.AcquireReaderLock(Timeout.Infinite);
            try
            {
                if (_items.Keys.Contains(templateId))
                {
                    return _items[templateId];
                }
            }
            finally
            {
                m_lock.ReleaseReaderLock();
            }
            return null;
        }

  
        public static ItemTemplateInfo GetGoodsbyFusionTypeandQuality(int fusionType, int quality)
        {
            if (_items == null)
                Init();

            m_lock.AcquireReaderLock(Timeout.Infinite);
            try
            {
                foreach(ItemTemplateInfo p in _items.Values)
                {
                    if(p.FusionType == fusionType && p.Quality == quality)
                    {
                        return p;
                    }
                }
            }
            finally
            {
                m_lock.ReleaseReaderLock();
            }

            return null;
        }

        public static ItemTemplateInfo GetGoodsbyFusionTypeandLevel(int fusionType, int level)
        {
            if (_items == null)
                Init();
            m_lock.AcquireReaderLock(Timeout.Infinite);
            try
            {
                foreach (ItemTemplateInfo p in _items.Values)
                {
                    if (p.FusionType == fusionType && p.Level == level)
                    {
                        return p;
                    }
                }
            }
            finally
            {
                m_lock.ReleaseReaderLock();
            }
            return null;
        }
    }
}
