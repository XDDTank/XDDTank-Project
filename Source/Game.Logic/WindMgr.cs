using System;
using System.Collections.Generic;
using log4net;
using System.Reflection;
using System.Threading;
using Bussiness;
using SqlDataProvider.Data;
////using System.IO;
////using Game.Logic.Phy.Maps;
//// Game.Logic.Phy.Object;

namespace Game.Logic
{
    public class WindMgr
    {
        /// <summary>
        /// Defines a logger for this class.
        /// </summary>
        private static readonly ILog log = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);

        private static Dictionary<int, VaneInfo> _vanes;

        private static System.Threading.ReaderWriterLock m_lock;

        private static ThreadSafeRandom rand;

        public static bool Init()
        {
            try
            {
                m_lock = new System.Threading.ReaderWriterLock();
                _vanes = new Dictionary<int, VaneInfo>();
                rand = new ThreadSafeRandom();
                return LoadVane(_vanes);
            }
            catch (Exception e)
            {
                if (log.IsErrorEnabled)
                    log.Error("VaneInfoMgr", e);
                return false;
            }

        }
        public static bool ReLoad()
        {
            try
            {
                Dictionary<int, VaneInfo> tempVanes = new Dictionary<int, VaneInfo>();
                if (LoadVane(tempVanes))
                {
                    m_lock.AcquireWriterLock(Timeout.Infinite);
                    try
                    {
                        _vanes = tempVanes;
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
                    log.Error("VaneMgr", e);
            }

            return false;
        }

        private static bool LoadVane(Dictionary<int, VaneInfo> Vane)
        {
            using (ProduceBussiness db = new ProduceBussiness())
            {
                VaneInfo[] infos = db.GetAllVane();

                foreach (VaneInfo info in infos)
                {
                    if (!Vane.ContainsKey(info.ID))
                    {
                        Vane.Add(info.ID, info);
                    }
                }

            }

            return true;
        }

        public static VaneInfo FindVane(int ID)
        {
            m_lock.AcquireReaderLock(Timeout.Infinite);
            try
            {
                if (_vanes.ContainsKey(ID))
                    return _vanes[ID];
            }
            catch
            { }
            finally
            {
                m_lock.ReleaseReaderLock();
            }
            return null;
        }


        //---------------------------------------


    }
}
