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
    public class FightSpiritTemplateMgr
    {
        private static readonly ILog log = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);

        private static Dictionary<int, FightSpiritTemplateInfo> _fightSpiritTemplate;

        private static System.Threading.ReaderWriterLock m_lock;

        private static ThreadSafeRandom rand;

        public static bool ReLoad()
        {
            try
            {
                Dictionary<int, FightSpiritTemplateInfo> tempConsortiaLevel = new Dictionary<int, FightSpiritTemplateInfo>();

                if (Load(tempConsortiaLevel))
                {
                    m_lock.AcquireWriterLock(Timeout.Infinite);
                    try
                    {
                        _fightSpiritTemplate = tempConsortiaLevel;
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
                _fightSpiritTemplate = new Dictionary<int, FightSpiritTemplateInfo>();
                rand = new ThreadSafeRandom();
                return Load(_fightSpiritTemplate);
            }
            catch (Exception e)
            {
                if (log.IsErrorEnabled)
                    log.Error("ConsortiaLevelMgr", e);
                return false;
            }

        }

        private static bool Load(Dictionary<int, FightSpiritTemplateInfo> consortiaLevel)
        {
            using (PlayerBussiness db = new PlayerBussiness())
            {
                FightSpiritTemplateInfo[] infos = db.GetAllFightSpiritTemplate();
                foreach (FightSpiritTemplateInfo info in infos)
                {
                    if (!consortiaLevel.ContainsKey(info.ID))
                    {
                        consortiaLevel.Add(info.ID, info);
                    }
                }
            }

            return true;
        }

        public static FightSpiritTemplateInfo FindFightSpiritTemplateInfo(int FigSpiritId, int lv)
        {            
            m_lock.AcquireReaderLock(Timeout.Infinite);
            try
            {
                //if (_fightSpiritTemplate.ContainsKey(ID))
                //    return _fightSpiritTemplate[ID];
                foreach (FightSpiritTemplateInfo fs in _fightSpiritTemplate.Values)
                {
                    if (fs.FightSpiritID == FigSpiritId && fs.Level == lv)
                    {
                        return fs;
                    }

                }
            }
            catch
            { }
            finally
            {
                m_lock.ReleaseReaderLock();
            }
            return null;
        }

        public static int getProp(int FigSpiritId, int lv, int place)
        {
             FightSpiritTemplateInfo temp = FindFightSpiritTemplateInfo(FigSpiritId, lv);
            switch (place)
            {
                case 2:
                    return temp.Attack;
                case 5:
                    return temp.Agility;
                case 11:
                    return temp.Defence;
                case 3:
                    return temp.Lucky;
                case 13:
                    return temp.Blood;
            }
            return 0;
        }
    }
}
