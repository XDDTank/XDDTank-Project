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
using SqlDataProvider.Data;

namespace Game.Server.Managers
{
    public class LevelMgr
    {
        private static readonly ILog log = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);

        private static Dictionary<int, LevelInfo> _levels;

        private static System.Threading.ReaderWriterLock m_lock;

        private static ThreadSafeRandom rand;

        private static int MaxLevel = 60;

        public static bool Init()
        {
            try
            {
                m_lock = new System.Threading.ReaderWriterLock();
                _levels = new Dictionary<int, LevelInfo>();
                rand = new ThreadSafeRandom();
                return LoadLevel(_levels);
            }
            catch (Exception e)
            {
                if (log.IsErrorEnabled)
                    log.Error("LevelMgr", e);
                return false;
            }

        }
        public static bool ReLoad()
        {
            try
            {
                Dictionary<int, LevelInfo> tempLevels = new Dictionary<int, LevelInfo>();
                if (LoadLevel(tempLevels))
                {
                    m_lock.AcquireWriterLock(Timeout.Infinite);
                    try
                    {
                        _levels = tempLevels;
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
                    log.Error("LevelMgr", e);
            }

            return false;
        }

        private static bool LoadLevel(Dictionary<int, LevelInfo> Level)
        {
            using (PlayerBussiness db = new PlayerBussiness())
            {
                LevelInfo[] infos = db.GetAllLevel();
                MaxLevel = infos.Count();
                foreach (LevelInfo info in infos)
                {
                    if (!Level.ContainsKey(info.Grade))
                    {
                        Level.Add(info.Grade, info);
                    }
                    
                }

            }

            return true;
        }

        public static LevelInfo FindLevelByGrade(int Grade)
        {
            m_lock.AcquireReaderLock(Timeout.Infinite);
            try
            {
                if (_levels.ContainsKey(Grade))
                    return _levels[Grade];
            }
            catch
            { }
            finally
            {
                m_lock.ReleaseReaderLock();
            }
            return null;
        }

        public static int FindLevelByGP(int GP)
        {
            
            int _level = 1;
            for (int i = 1; i <= MaxLevel; i++)
            {
                if (GP > FindLevelByGrade(MaxLevel).GP)
                {
                    _level = MaxLevel;
                    break;
                }
                else if (GP < FindLevelByGrade(i).GP)
                {
                    _level = i;
                    break;
                }
               
            }
            return _level;
        }
        
        public static int GetMaxLevel()
        {
            return  MaxLevel;
        }
        
        public static int ReduceGP(int level, int totalGP)
        {
            if (MaxLevel > level && level > 0)
            {

                totalGP -= FindLevelByGrade(level).GP;
                if (totalGP < level)
                {
                    return totalGP < 0 ? 0 : totalGP;
                }
                return level;
            }
            return 0;
        }

        
    }
}
