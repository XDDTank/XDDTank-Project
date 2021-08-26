using System;
using System.Collections.Generic;
using log4net;
using System.Reflection;
using System.Threading;
using Bussiness;
using SqlDataProvider.Data;


namespace Game.Server.Managers
{
    public class PetMgr
    {
        /// <summary>
        /// Defines a logger for this class.
        /// </summary>
        private static readonly ILog log = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);
        private static Dictionary<string, PetConfig> _configs;
        private static Dictionary<int, PetLevel> _levels;
        private static Dictionary<int, PetSkillElementInfo> _skillElements;
        private static Dictionary<int, PetSkillInfo> _skills;
        private static Dictionary<int, PetSkillTemplateInfo> _skillTemplates;
        private static Dictionary<int, PetTemplateInfo> _petTemplates;
        private static Dictionary<int, PetTemplateInfo> _templateIds;
        private static PetSkillElementInfo[] GameNeedPetSkillInfo;
        private static System.Threading.ReaderWriterLock m_lock;
        private static int MaxStar = 4;
        private static int PetTemplateCount = 91;
        private static int SkillTemplateCount = 90;

        private static ThreadSafeRandom rand;

        public static bool Init()
        {
            try
            {
                _configs = new Dictionary<string, PetConfig>();
                _levels = new Dictionary<int, PetLevel>();
                _skillElements = new Dictionary<int, PetSkillElementInfo>();
                _skills = new Dictionary<int, PetSkillInfo>();
                _skillTemplates = new Dictionary<int, PetSkillTemplateInfo>();
                _petTemplates = new Dictionary<int, PetTemplateInfo>();
                _templateIds = new Dictionary<int, PetTemplateInfo>();
                m_lock = new System.Threading.ReaderWriterLock();               
                rand = new ThreadSafeRandom();
                return LoadPetMgr(_configs, _levels, _skillElements, _skills, _skillTemplates, _petTemplates, _templateIds);
                
            }
            catch (Exception e)
            {
                if (log.IsErrorEnabled)
                    log.Error("PetInfoMgr", e);
                return false;
            }

        }
        public static bool ReLoad()
        {
            try
            {                
                Dictionary<string, PetConfig> tempConfigs = new Dictionary<string, PetConfig>();
                Dictionary<int, PetLevel> tempLevels = new Dictionary<int, PetLevel>();
                Dictionary<int, PetSkillElementInfo> tempSkillElements = new Dictionary<int, PetSkillElementInfo>();
                Dictionary<int, PetSkillInfo> tempSkills = new Dictionary<int, PetSkillInfo>();
                Dictionary<int, PetSkillTemplateInfo> tempSkillTemplates = new Dictionary<int, PetSkillTemplateInfo>();
                Dictionary<int, PetTemplateInfo> tempPetTemplates = new Dictionary<int, PetTemplateInfo>();
                Dictionary<int, PetTemplateInfo> tempTemplateIds = new Dictionary<int, PetTemplateInfo>();
                if (LoadPetMgr(tempConfigs, tempLevels, tempSkillElements, tempSkills, tempSkillTemplates, tempPetTemplates, tempTemplateIds))
                {
                    m_lock.AcquireWriterLock(Timeout.Infinite);
                    try
                    {
                        _configs = tempConfigs;
                        _levels = tempLevels;
                        _skillElements = tempSkillElements;
                        _skills = tempSkills;
                        _skillTemplates = tempSkillTemplates;
                        _petTemplates = tempPetTemplates;
                        _templateIds = tempTemplateIds;
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
                    log.Error("PetMgr", e);
            }

            return false;
        }
        private static bool LoadPetMgr(Dictionary<string, PetConfig> Config, Dictionary<int, PetLevel> Level, Dictionary<int, PetSkillElementInfo> SkillElement, Dictionary<int, PetSkillInfo> Skill,
             Dictionary<int, PetSkillTemplateInfo> SkillTemplate, Dictionary<int, PetTemplateInfo> PetTemplate, Dictionary<int, PetTemplateInfo> TemplateId)
        {
            using (PlayerBussiness db = new PlayerBussiness())
            {
                PetConfig[] ConfigInfos = db.GetAllPetConfig();
                PetLevel[] LevelInfos = db.GetAllPetLevel();
                PetSkillElementInfo[] SkillElementInfos = db.GetAllPetSkillElementInfo();
                PetSkillInfo[] SkillInfos = db.GetAllPetSkillInfo();
                PetSkillTemplateInfo[] SkillTemplateInfos = db.GetAllPetSkillTemplateInfo();
                PetTemplateInfo[] PetTemplateInfos = db.GetAllPetTemplateInfo();
                //PetTemplateInfo[] TemplateInfos = db.GetAllPetTemplateInfo();
                GameNeedPetSkillInfo = SkillElementInfos;

                foreach (PetConfig info in ConfigInfos)
                {
                    if (!Config.ContainsKey(info.Name)) { Config.Add(info.Name, info); }
                }
                foreach (PetLevel info in LevelInfos)
                {
                    if (!Level.ContainsKey(info.Level)) { Level.Add(info.Level, info); }
                }
                foreach (PetSkillElementInfo info in SkillElementInfos)
                {
                    if (!SkillElement.ContainsKey(info.ID)) { SkillElement.Add(info.ID, info); }
                }

                SkillTemplateCount = SkillTemplateInfos.Length;
                foreach (PetSkillTemplateInfo info in SkillTemplateInfos)
                {
                    if (!SkillTemplate.ContainsKey(info.ID)) { SkillTemplate.Add(info.ID, info); }
                }

                PetTemplateCount = PetTemplateInfos.Length;
                foreach (PetTemplateInfo info in PetTemplateInfos)
                {
                    //if (!PetTemplate.ContainsKey(info.TemplateID)) { PetTemplate.Add(info.TemplateID, info); }
                    if (!TemplateId.ContainsKey(info.ID) && !TemplateId.ContainsKey(info.TemplateID))
                    {
                        TemplateId.Add(info.ID, info);
                        PetTemplate.Add(info.TemplateID, info);
                        
                    }
                    
                }
                foreach (PetSkillInfo info in SkillInfos)
                {
                    if (!Skill.ContainsKey(info.ID)) { Skill.Add(info.ID, info); }
                }

            }

            return true;
        }
        public static PetConfig FindConfig(string key)
        {
            if (_configs == null)
                Init();
            m_lock.AcquireReaderLock(Timeout.Infinite);
            try
            {
                if (_configs.ContainsKey(key))
                    return _configs[key];
            }
            catch
            { }
            finally
            {
                m_lock.ReleaseReaderLock();
            }
            return null;
        }
        /*
        public static PetConfig FindPetConfig(int ID)
        {
            if (_configs == null)
                Init();
            m_lock.AcquireReaderLock(Timeout.Infinite);
            try
            {
                if (_configs.ContainsKey(ID))
                    return _configs[ID];
            }
            catch
            { }
            finally
            {
                m_lock.ReleaseReaderLock();
            }
            return null;
        }
         
        public static string FindConfigByKey(string key)
        {
            string value = null;
            string tempKeys = "";
            for (int index = 0; index < _configs.Count; index++)
            {
                if (_configs[index].Name == key)
                {
                    value = tempKeys;
                    break;
                }
            }
            return value;
        }
         
         */ 

        public static PetLevel FindPetLevel(int level)
        {
            if (_levels == null)
                Init();
            m_lock.AcquireReaderLock(Timeout.Infinite);
            try
            {
                if (_levels.ContainsKey(level))
                    return _levels[level];
            }
            catch
            { }
            finally
            {
                m_lock.ReleaseReaderLock();
            }
            return null;
        }
        public static PetSkillElementInfo FindPetSkillElement(int SkillID)
        {
            if (_skillElements == null)
                Init();
            m_lock.AcquireReaderLock(Timeout.Infinite);
            try
            {
                if (_skillElements.ContainsKey(SkillID))
                    return _skillElements[SkillID];
            }
            catch
            { }
            finally
            {
                m_lock.ReleaseReaderLock();
            }
            return null;
        }
        //GameNeedPetSkillInfo 
        public static List<PetSkillElementInfo> GameNeedPetSkill()
        {
            if (_skillElements == null)
                Init();
            List<PetSkillElementInfo> listskillEle = new List<PetSkillElementInfo>();
            foreach (PetSkillElementInfo info in GameNeedPetSkillInfo)
            {
                if (info.EffectPic != "" || info.EffectPic != null) 
                {
                    listskillEle.Add(info); 
                }
            }
            return listskillEle;//.ToArray();
        }
        public static PetSkillInfo FindPetSkill(int SkillID)
        {
            if (_skills == null)
                Init();
            m_lock.AcquireReaderLock(Timeout.Infinite);
            try
            {
                if (_skills.ContainsKey(SkillID))
                    return _skills[SkillID];
            }
            catch
            { }
            finally
            {
                m_lock.ReleaseReaderLock();
            }
            return null;
        }
        public static PetSkillTemplateInfo GetPetSkillTemplate(int ID)
        {
            if (_skillTemplates == null)
                Init();
            m_lock.AcquireReaderLock(Timeout.Infinite);
            try
            {
                if (_skillTemplates.ContainsKey(ID))
                    return _skillTemplates[ID];
            }
            catch
            { }
            finally
            {
                m_lock.ReleaseReaderLock();
            }
            return null;
        }
        public static PetTemplateInfo FindPetTemplate(int TemplateID)
        {
            if (_petTemplates == null)
                Init();
            m_lock.AcquireReaderLock(Timeout.Infinite);
            try
            {
                if (_petTemplates.ContainsKey(TemplateID))
                    return _petTemplates[TemplateID];
            }
            catch
            { }
            finally
            {
                m_lock.ReleaseReaderLock();
            }
            return null;
        }
        public static PetTemplateInfo FindPetTemplateById(int ID)
        {
            if (_petTemplates == null)
                Init();
            m_lock.AcquireReaderLock(Timeout.Infinite);
            try
            {
                if (_templateIds.ContainsKey(ID))
                    return _templateIds[ID];
            }
            catch
            { }
            finally
            {
                m_lock.ReleaseReaderLock();
            }
            return null;
        }
        public static List<int> GetPetTemplateByStar(int star)
        {
            List<int> infos = new List<int>();
            int chekID = 0;// FindPetTemplateById(1).TemplateID;
            for (int index = 1; index <= PetTemplateCount; index++)
            {
                PetTemplateInfo _info = FindPetTemplateById(index);
                if (_info.StarLevel <= star)
                {                   
                    int _tempId = _info.TemplateID - chekID;
                    if (_tempId == 1 || _tempId == -1 || _tempId == 2 || _tempId == -2)
                    {
                    }
                    else
                    {
                        infos.Add(_info.TemplateID);
                    }
                    chekID = _info.TemplateID;
                }                
            }
            return infos;
        }
        public static List<int> GetPetSkillByKindID(int KindID, int lv)
        {
            int MaxLevel = Convert.ToInt32(FindConfig("MaxLevel").Value);
            List<int> infos = new List<int>();
            List<string> DeleteSkillIDs = new List<string>();
            PetSkillTemplateInfo[] skillInfos = GetPetSkillByKindID(KindID);
            int _level = lv > MaxLevel ? MaxLevel : lv;
            for (int index = 1; index <= _level; index++)
            {
                foreach (PetSkillTemplateInfo s in skillInfos)
                {
                    if (s.MinLevel == index)
                    {
                        string[] delS = s.DeleteSkillIDs.Split(',');
                        foreach (string i in delS)
                        {
                            DeleteSkillIDs.Add(i);
                        }
                        infos.Add(s.SkillID);                        
                    }
                    
                }
            }
            foreach (string i in DeleteSkillIDs)
            {
                if (i != null && i != "")
                {
                    //Console.WriteLine("id: " + i);
                    int del = int.Parse(i);
                    infos.Remove(del);
                }
                
                
            }
            infos.Sort();

            return infos;
        }
        public static PetSkillTemplateInfo[] GetPetSkillByKindID(int KindID)
        {

            List<PetSkillTemplateInfo> infos = new List<PetSkillTemplateInfo>();
            for (int index = 1; index <= SkillTemplateCount; index++)
            {
                PetSkillTemplateInfo _info = GetPetSkillTemplate(index);
                if (_info.KindID == KindID)
                {                    
                    infos.Add(_info);
                }
            }
            return infos.ToArray();
        }
        //UsersPetinfo[]
        public static void CreateAdoptList(int userID)
        {
            int AdoptCount = Convert.ToInt32(FindConfig("AdoptCount").Value);          
            List<int> idpet = GetPetTemplateByStar(MaxStar);          
            //List<UsersPetinfo> infos = new List<UsersPetinfo>();
            using (PlayerBussiness db = new PlayerBussiness())
            {
                db.RemoveUserAdoptPet(userID);
                for (int index = 0; index < AdoptCount; index++)
                {
                    int id = rand.Next(idpet.Count);
                    PetTemplateInfo TempInfo = FindPetTemplate(idpet[id]);
                    UsersPetinfo info = CreatePet(TempInfo, userID, index);
                    db.AddUserAdoptPet(info);
                    //infos.Add(info);
                }
            }
            //return infos.ToArray();
        }
        //UsersPetinfo[]
        public static void CreateFirstAdoptList(int userID)
        {           
            List<int> idpet = new List<int> { 100601, 110601, 120601, 130601 };            
            //List<UsersPetinfo> infos = new List<UsersPetinfo>();
            using (PlayerBussiness db = new PlayerBussiness())
            {
                db.RemoveUserAdoptPet(userID);
                for (int index = 0; index < idpet.Count; index++)
                {
                    PetTemplateInfo TempInfo = FindPetTemplate(idpet[index]);
                    UsersPetinfo info = CreatePet(TempInfo, userID, index);
                    db.AddUserAdoptPet(info);
                    //infos.Add(info);
                }
            }
            //return infos.ToArray();
        }
        //---------------------------------------
        public static int GetPetID(int userid, int index)
        {
            int petID = 0;
            int _tempID = rand.Next(9999);
            string _userid = Convert.ToString(userid);
            _userid += _tempID;
            _userid += index;
            petID = int.Parse(_userid);
            return petID;
        }
        public static UsersKillPetInfo[] ActiveEquipSkill(int Level, int ID, int UserID, int vipLevel)
        {
            List<UsersKillPetInfo> skillPet = new List<UsersKillPetInfo>();            
            int total = 1;
            if (Level >= 20 && Level < 30) { total += 1; }
            if (Level >= 30 && Level < 50) { total += 2; }
            if (Level >= 50) { total += 4; }
            //if (vipLevel >= 11 && Level > 50) {  total += 4; }
            for (int i = 0; i < total; i++)
            {
                UsersKillPetInfo _tempEquipSkill = new UsersKillPetInfo();
                _tempEquipSkill.PetKill = 0;
                _tempEquipSkill.PetID = ID;
                _tempEquipSkill.UserID = UserID;
                _tempEquipSkill.Place = -1;
                _tempEquipSkill.IsExit = false;
                _tempEquipSkill.KillIndex = i;
                _tempEquipSkill.IsEquip = true;
                if (_tempEquipSkill!=null)
                skillPet.Add(_tempEquipSkill);
            }
            return skillPet.ToArray();
        }
        public static int UpdateEvolution(int TemplateID, int lv)
        {
            int realId = TemplateID;
            int EvolutionLevel1 = Convert.ToInt32(PetMgr.FindConfig("EvolutionLevel1").Value);
            int EvolutionLevel2 = Convert.ToInt32(PetMgr.FindConfig("EvolutionLevel2").Value);
            PetTemplateInfo info = FindPetTemplate(realId);
            PetTemplateInfo nextinfo = FindPetTemplate(realId + 1);
            PetTemplateInfo finaltinfo = FindPetTemplate(realId + 2);
            if (finaltinfo != null)
            {
                if (lv >= EvolutionLevel1 && lv < EvolutionLevel2 && nextinfo.EvolutionID != 0)
                {                    
                    realId = info.EvolutionID;
                }
                else if (lv >= EvolutionLevel2)
                {                    
                    realId = nextinfo.EvolutionID;
                }
            }
            else
            {
                if (nextinfo != null)
                {
                    if (lv >= EvolutionLevel2)
                    {                        
                        realId = info.EvolutionID;
                    }
                }
            }
            return realId;
        }
        public static int TemplateReset(int TemplateID)
        {
            int realId = TemplateID;
            PetTemplateInfo EvolutionLevel1 = FindPetTemplate(realId - 1);
            PetTemplateInfo EvolutionLevel2 = FindPetTemplate(realId - 2);
            if (EvolutionLevel1 != null)
            {
                realId = EvolutionLevel1.TemplateID;
            }
            else if (EvolutionLevel2 != null)
            {
                realId = EvolutionLevel2.TemplateID;
            }
            return realId;
        }
        public static UsersKillPetInfo[] UpdateSkillPet(int Level, int ID, int UserID, int TemplateID)
        {
           PetTemplateInfo info = FindPetTemplate(TemplateID);
           List<UsersKillPetInfo> skillPet = new List<UsersKillPetInfo>();
           List<int> listSkillId = GetPetSkillByKindID(info.KindID, Level);
           for (int i = 0; i < listSkillId.Count; i++)
            {
                int _skill = listSkillId[i];
               UsersKillPetInfo _tempSkill = new UsersKillPetInfo();
               _tempSkill.PetKill = _skill;
               _tempSkill.PetID = ID;
               _tempSkill.UserID = UserID;
               _tempSkill.Place = i;
               _tempSkill.IsExit = true;
               _tempSkill.KillIndex = -1;
               _tempSkill.IsEquip = false;
               skillPet.Add(_tempSkill);               
           }
           return skillPet.ToArray();
        }
        public static int GetLevel(int GP)
        {
            int MaxLevel = Convert.ToInt32(PetMgr.FindConfig("MaxLevel").Value);
            if (GP >= FindPetLevel(MaxLevel).GP)
            {
                return MaxLevel;
            }
            else
            {
                for (int i = 1; i <= MaxLevel; i++)
                {
                    if (GP < FindPetLevel(i).GP)
                        return (i - 1) == 0 ? 1 : (i - 1);
                }

            }
            return 1;
        }
        public static int GetGP(int level)
        {
            int MaxLevel = Convert.ToInt32(PetMgr.FindConfig("MaxLevel").Value);
            for (int i = 1; i <= MaxLevel; i++)
            {
                if (level == FindPetLevel(i).Level)
                {
                    return FindPetLevel(i).GP;
                }
            }

            return 0;
        }
        public static void PlusPetProp(UsersPetinfo pet, int min, int max, ref int blood, ref int attack, ref int defence, ref int agility, ref  int lucky)
        {
            double growB = pet.BloodGrow / 10 * 0.1;
            double growA = pet.AttackGrow / 10 * 0.1;
            double growD = pet.DefenceGrow / 10 * 0.1;
            double growAg = pet.AgilityGrow / 10 * 0.1;
            double growL = pet.LuckGrow / 10 * 0.1;
            double plitLv = 0;
            double plusblood = pet.Blood;
            double plusAtt = pet.Attack;
            double plusDef = pet.Defence;
            double plusAgi = pet.Agility;
            double plusLuck = pet.Luck;  
            for (int s = (min + 1); s <= max; s++)
            {
                plitLv += min / 100;
                double powAll = 0.5;
                plusblood += growB + Math.Pow(powAll, s);
                plusAtt += growA + Math.Pow(powAll, s);
                plusDef += growD + Math.Pow(powAll, s);
                plusAgi += growAg + Math.Pow(powAll, s);
                plusLuck += growL + Math.Pow(powAll, s);
            }
            blood = (int)(growB * (plusblood / (growB + plitLv)));
            attack = (int)(growA * (plusAtt / (growA + plitLv)));
            defence = (int)(growD * (plusDef / (growD + plitLv)));
            agility = (int)(growAg * (plusAgi / (growAg + plitLv)));
            lucky = (int)(growL * (plusLuck / (growL + plitLv)));
        }
        public static UsersKillPetInfo[] RemoveSkillPet(UsersKillPetInfo[] skills, int TemplateID, int type)
        {
            PetTemplateInfo info = FindPetTemplate(TemplateID);
            List<int> listSkillId = GetPetSkillByKindID(info.KindID, 1);
            UsersKillPetInfo[] Skill = skills;
            for (int i = 0; i < Skill.Length; i++)
            {
                if (Skill[i].PetKill != listSkillId[0])
                {
                    if (type == 0)
                    {
                        Skill[i].IsExit = false;
                    }
                    else
                    {
                        Skill[i].IsEquip = false;
                    }
                }
            }
            
            return Skill;
        }
        public static UsersKillPetInfo[] CreateSkillPet(int TemplateID, int userID, int petId, int type)
        {
            PetTemplateInfo info = FindPetTemplate(TemplateID);
            List<int> listSkillId = GetPetSkillByKindID(info.KindID, 1);
            UsersKillPetInfo[] Skill = new UsersKillPetInfo[1];
            UsersKillPetInfo _tempSkill = new UsersKillPetInfo();
            _tempSkill.PetKill = listSkillId[0];
            _tempSkill.PetID = petId;
            _tempSkill.UserID = userID;
            if (type == 0)
            {
                _tempSkill.Place = 0;
                _tempSkill.IsExit = true;
                _tempSkill.KillIndex = -1;
                _tempSkill.IsEquip = false;
            }
            else
            {
                _tempSkill.Place = -1;
                _tempSkill.IsExit = false;
                _tempSkill.KillIndex = 0;
                _tempSkill.IsEquip = true;
            }
            Skill[0] = _tempSkill;
            return Skill; 
        }
        public static UsersPetinfo CreatePet(PetTemplateInfo info, int userID, int place)
        {
            UsersPetinfo newPet = new UsersPetinfo();
            int star = info.StarLevel;
            int startP = 200 + (100 * star);
            int endP = 350 + (100 * star);
            int startB = 1700 + (1000 * star);
            int endB = 2200 + (2500 * star);
            newPet.BloodGrow = rand.Next(startB, endB);
            newPet.AttackGrow = rand.Next(startP, endP);
            newPet.DefenceGrow = rand.Next(startP, endP);
            newPet.AgilityGrow = rand.Next(startP, endP);
            newPet.LuckGrow = rand.Next(startP, endP);
            newPet.DamageGrow = 0;
            newPet.GuardGrow = 0;
            double plusB = (rand.Next(54, 61) * 0.1);
            double plusP = (rand.Next(9, 13) * 0.1);
            newPet.Blood = (int)((rand.Next(startB, endB) / 10 * 0.1) * plusB);
            newPet.Attack = (int)((rand.Next(startP, endP) / 10 * 0.1) * plusP);
            newPet.Defence = (int)((rand.Next(startP, endP) / 10 * 0.1) * plusP);
            newPet.Agility = (int)((rand.Next(startP, endP) / 10 * 0.1) * plusP);
            newPet.Luck = (int)((rand.Next(startP, endP) / 10 * 0.1) * plusP);
            newPet.Damage = 0;
            newPet.Guard = 0;
            newPet.TemplateID = info.TemplateID;
            newPet.Name = info.Name;
            newPet.UserID = userID;
            newPet.Place = place;
            return newPet;
        }
        
    }
}
