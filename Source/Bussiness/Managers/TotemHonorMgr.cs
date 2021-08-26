using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using log4net;
using System.Reflection;
using System.Threading;
using SqlDataProvider.Data;
using Bussiness;


namespace Game.Server.Managers
{
    public class TotemHonorMgr
    {
        private static readonly ILog log = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);

        private static Dictionary<int, TotemHonorTemplateInfo> _consortiaLevel;

        private static System.Threading.ReaderWriterLock m_lock;

        private static ThreadSafeRandom rand;

        public static bool ReLoad()
        {
            try
            {
                Dictionary<int, TotemHonorTemplateInfo> tempConsortiaLevel = new Dictionary<int, TotemHonorTemplateInfo>();

                if (Load(tempConsortiaLevel))
                {
                    m_lock.AcquireWriterLock(Timeout.Infinite);
                    try
                    {
                        _consortiaLevel = tempConsortiaLevel;
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
                    log.Error("ConsortiaLevelMgr", e);
            }

            return false;
        }

        /// <summary>
        /// Initializes the StrengthenMgr. 
        /// </summary>
        /// <returns></returns>
        public static bool Init()
        {
            try
            {
                m_lock = new System.Threading.ReaderWriterLock();
                _consortiaLevel = new Dictionary<int, TotemHonorTemplateInfo>();
                rand = new ThreadSafeRandom();
                return Load(_consortiaLevel);
            }
            catch (Exception e)
            {
                if (log.IsErrorEnabled)
                    log.Error("ConsortiaLevelMgr", e);
                return false;
            }

        }

        private static bool Load(Dictionary<int, TotemHonorTemplateInfo> consortiaLevel)
        {
            using (PlayerBussiness db = new PlayerBussiness())
            {
                TotemHonorTemplateInfo[] infos = db.GetAllTotemHonorTemplate();
                foreach (TotemHonorTemplateInfo info in infos)
                {
                    if (!consortiaLevel.ContainsKey(info.ID))
                    {
                        consortiaLevel.Add(info.ID, info);
                    }
                }
            }

            return true;
        }

        public static TotemHonorTemplateInfo FindTotemHonorTemplateInfo(int ID)
        {
            m_lock.AcquireReaderLock(Timeout.Infinite);
            try
            {
                if (_consortiaLevel.ContainsKey(ID))
                    return _consortiaLevel[ID];
            }
            catch
            { }
            finally
            {
                m_lock.ReleaseReaderLock();
            }
            return null;
        }


    }
}
