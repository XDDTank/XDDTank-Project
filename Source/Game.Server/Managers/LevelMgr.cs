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

        //private static int MaxLevel = 60;

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
                //MaxLevel = infos.Count();
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

        public static LevelInfo FindLevel(int Grade)
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

        public static int GetMaxLevel()
        {
            if (_levels == null)
                Init();
            return _levels.Values.Count;
        }
        
        //static int[] levels = new int[] { 0, 37, 162, 505, 1283, 2801, 5462, 9771, 16341, 25899, 39291, 57489, 81594, 112847, 152630, 202472, 264058, 339232, 430003, 538554, 667242, 818609, 995383, 1200490, 1437053, 1753103, 
        //   2112735, 2519637, 2977665, 3490849, 4145185, 4873978, 5684269, 6583537, 7579710, 8681174, 9896788, 11235892, 12708322, 14324419, 16263735, 18590915, 21383531, 24734669, 28756036, 33581676, 39372443, 46321365, 
        //    54660070, 63832646, 73922480, 85021297, 97229996, 110659565, 125432090, 140943242, 157229951, 174330996, 192287093, 211140995, int.MaxValue };
        
        public static int GetLevel(int GP)
        {
            if (GP >= FindLevel(GetMaxLevel()).GP)
            {
                return GetMaxLevel();
            }
            else
            {
                //for (int i = 0; i < levels.Length; i++)
                for (int i = 1; i <= GetMaxLevel(); i++)
                {
                    //if (GP < levels[i])
                    if (GP < FindLevel(i).GP)
                        return (i - 1) == 0 ? 1 : (i - 1);
                }

            }
            return 1;
        }

        public static int GetGP(int level)
        {
            //if (levels.Length > level && level > 0)
            if (GetMaxLevel() > level && level > 0)
            {
                //return levels[level - 1];
                return FindLevel(level - 1).GP;
            }
            return 0;
        }

        public static int ReduceGP(int level, int totalGP)
        {
            //if (levels.Length > level && level > 0)
            if (GetMaxLevel() > level && level > 0)
            {
                //totalGP = totalGP - levels[level - 1];
                totalGP = totalGP - FindLevel(level - 1).GP;
                if (totalGP < level * 12)
                {
                    return totalGP < 0 ? 0 : totalGP;
                }
                return level * 12;
            }
            return 0;
        }

        public static int IncreaseGP(int level, int totalGP)
        {
            if (GetMaxLevel() > level && level > 0)
            {
                //totalGP = totalGP + levels[level - 1];
                //if (totalGP < level * 12)
                //{
                //    return totalGP < 0 ? 0 : totalGP;
                //}
                return level * 12;
            }
            return 0;
        }
    }
}
