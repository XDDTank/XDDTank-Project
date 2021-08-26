using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using SqlDataProvider.Data;
using log4net;
using System.Reflection;
using System.Threading;

namespace Bussiness.Managers
{
    public class GoldEquipMgr
    {
        private static readonly ILog log = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);

        private static Dictionary<int, GoldEquipTemplateLoadInfo> _items;

        private static System.Threading.ReaderWriterLock m_lock;

        public static bool ReLoad()
        {
            try
            {
                Dictionary<int, GoldEquipTemplateLoadInfo> tempItems = new Dictionary<int, GoldEquipTemplateLoadInfo>();

                if (LoadItem(tempItems))
                {
                    m_lock.AcquireWriterLock(Timeout.Infinite);
                    try
                    {
                        _items = tempItems;
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
                _items = new Dictionary<int, GoldEquipTemplateLoadInfo>();
                return LoadItem(_items);
            }
            catch (Exception e)
            {
                if (log.IsErrorEnabled)
                    log.Error("Init", e);
                return false;
            }
        }

        public static bool LoadItem(Dictionary<int, GoldEquipTemplateLoadInfo> infos)
        {
            using (ProduceBussiness db = new ProduceBussiness())
            {
                GoldEquipTemplateLoadInfo[] items = db.GetAllGoldEquipTemplateLoad();
                foreach (GoldEquipTemplateLoadInfo item in items)
                {

                    if (!infos.Keys.Contains(item.ID))
                    {
                        infos.Add(item.ID, item);
                    }
                }
            }
            return true;
        }
        public static GoldEquipTemplateLoadInfo FindGoldEquipCategoryID(int CategoryID)
        {
            if (_items == null)
                Init();

            m_lock.AcquireReaderLock(Timeout.Infinite);
            try
            {
                foreach (GoldEquipTemplateLoadInfo info in _items.Values)
                {
                    if (info.CategoryID == CategoryID)// || info.NewTemplateId == TemplateId)
                    {
                        return info;

                    }
                }
            }
            finally
            {
                m_lock.ReleaseReaderLock();
            }
            return null;
        }       
        public static GoldEquipTemplateLoadInfo FindGoldEquipTemplate(int TemplateId)
        {
            if (_items == null)
                Init();

            m_lock.AcquireReaderLock(Timeout.Infinite);
            try
            {
                foreach (GoldEquipTemplateLoadInfo info in _items.Values)
                {
                    if (info.OldTemplateId == TemplateId || info.NewTemplateId == TemplateId)
                    {
                        return info;

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
