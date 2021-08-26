using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using log4net;
using System.Reflection;
using log4net.Util;
//using Game.Server.GameObjects;
using System.Threading;
using Bussiness;
using SqlDataProvider.Data;

namespace Game.Logic
{
    public class ExerciseMgr
    {
        private static readonly ILog log = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);

        private static Dictionary<int, ExerciseInfo> _exercises;

        private static System.Threading.ReaderWriterLock m_lock;

        private static ThreadSafeRandom rand;

        //private static int MaxLevel = 65;

        public static bool Init()
        {
            try
            {
                m_lock = new System.Threading.ReaderWriterLock();
                _exercises = new Dictionary<int, ExerciseInfo>();               
                rand = new ThreadSafeRandom();
                return LoadExercise(_exercises);
            }
            catch (Exception e)
            {
                if (log.IsErrorEnabled)
                    log.Error("ExercisesMgr", e);
                return false;
            }

        }
        public static bool ReLoad()
        {
            try
            {
                Dictionary<int, ExerciseInfo> tempExercises = new Dictionary<int, ExerciseInfo>();
                if (LoadExercise(tempExercises))
                {
                    m_lock.AcquireWriterLock(Timeout.Infinite);
                    try
                    {
                        _exercises = tempExercises;                       
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
                    log.Error("ExerciseMgr", e);
            }

            return false;
        }

        private static bool LoadExercise(Dictionary<int, ExerciseInfo> Exercise)
        {
            using (PlayerBussiness db = new PlayerBussiness())
            {
                ExerciseInfo[] infos = db.GetAllExercise();
                //MaxLevel = infos.Count();
                foreach (ExerciseInfo info in infos)
                {
                    if (!Exercise.ContainsKey(info.Grage))
                    {
                        Exercise.Add(info.Grage, info);
                    }
                }
                
            }

            return true;
        }

        public static ExerciseInfo FindExercise(int Grage)
        {
            if (Grage == 0)
                Grage = 1;
            m_lock.AcquireReaderLock(Timeout.Infinite);
            try
            {
                if (_exercises.ContainsKey(Grage))
                    return _exercises[Grage];
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
            if (_exercises == null)
                Init();
            return _exercises.Values.Count;
        }
        public static int GetExercise(int GP, string type)
        {
            for (int i = 1; i <= GetMaxLevel(); i++)
            {
                if (GP < FindExercise(i).GP && GP >= 50)
                    switch (type)
                    {
                        case "A":
                            return FindExercise(i - 1).ExerciseA;
                        case "AG":
                            return FindExercise(i - 1).ExerciseAG;
                        case "D":
                            return FindExercise(i - 1).ExerciseD;
                        case "H":
                            return FindExercise(i - 1).ExerciseH;
                        case "L":
                            return FindExercise(i - 1).ExerciseL;
                    }
            }

            return 0;
        } 

    }
}
