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
    public class TotemMgr
    {
        private static readonly ILog log = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);

        private static Dictionary<int, TotemInfo> _consortiaLevel;

        private static System.Threading.ReaderWriterLock m_lock;

        private static ThreadSafeRandom rand;

        public static bool ReLoad()
        {
            try
            {
                Dictionary<int, TotemInfo> tempConsortiaLevel = new Dictionary<int, TotemInfo>();

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
                _consortiaLevel = new Dictionary<int, TotemInfo>();
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

        private static bool Load(Dictionary<int, TotemInfo> consortiaLevel)
        {
            using (PlayerBussiness db = new PlayerBussiness())
            {
                TotemInfo[] infos = db.GetAllTotem();
                foreach (TotemInfo info in infos)
                {
                    if (!consortiaLevel.ContainsKey(info.ID))
                    {
                        consortiaLevel.Add(info.ID, info);
                    }
                }
            }

            return true;
        }

        public static TotemInfo FindTotemInfo(int ID)
        {
            if (ID < 10000)
                ID = 10001;
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
        public static int getProp(int id, string typeOf)
        {           
            int totalProp = 0;
            for (int i = 10001; i <= id; i++)
            {
                TotemInfo temp = FindTotemInfo(i);
                switch (typeOf)
                {
                    case "att":
                        totalProp += temp.AddAttack;
                        break;
                    case "agi":
                        totalProp += temp.AddAgility;
                        break;
                    case "def":
                        totalProp += temp.AddDefence;
                        break;
                    case "luc":
                        totalProp += temp.AddLuck;
                        break;
                    case "blo":
                        totalProp += temp.AddBlood;
                        break;
                    case "dam":
                        totalProp += temp.AddDamage;
                        break;
                    case "gua":
                        totalProp += temp.AddGuard;
                        break;
                }
            }
            return totalProp;
        }
    }
}
