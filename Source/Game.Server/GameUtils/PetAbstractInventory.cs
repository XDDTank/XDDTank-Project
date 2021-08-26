using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using SqlDataProvider.Data;
using Game.Server.Statics;
using System.Threading;
using log4net;
using System.Reflection;
using Game.Logic;

namespace Game.Server.GameUtils
{
    /// <summary>
    /// 抽象的背包容器
    /// </summary>
    public abstract class PetAbstractInventory
    {
        private static readonly ILog log = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);

        protected object m_lock = new object();
        
        private int m_capalility;

        private int m_aCapalility;

        private int m_beginSlot;
        
        protected UsersPetinfo[] m_pets;

        protected UsersPetinfo[] m_adoptPets;

        protected ItemInfo[] m_adoptItems;

        public int BeginSlot
        {
            get { return m_beginSlot; }
        }

        public int Capalility
        {            
            get
            {
                return m_capalility;
            }
            set
            {
                m_capalility = (value < 0) ? 0 : ((value > m_pets.Length) ? m_pets.Length : value);
            }

        }
        public int ACapalility
        {
            get
            {
                return m_capalility;
            }
            set
            {
                m_capalility = (value < 0) ? 0 : ((value > m_adoptPets.Length) ? m_adoptPets.Length : value);
            }

        }       
        public bool IsEmpty(int slot)
        {
            if ((slot >= 0) && (slot < m_capalility))
            {
                return (m_pets[slot] == null);
            }
            return true;
        }
        

        public PetAbstractInventory(int capability,int aCapability, int beginSlot)
        {          
            m_capalility = capability;
            m_aCapalility = aCapability;
            m_beginSlot = beginSlot;
            m_pets = new UsersPetinfo[capability];
            m_adoptPets = new UsersPetinfo[aCapability];
        }

        public virtual UsersPetinfo GetPetIsEquip()
        {
            for (int i = 0; i < m_capalility; i++)
            {
                if (m_pets[i] != null)
                {
                    if (m_pets[i].IsEquip)
                    {
                        return m_pets[i];
                    }
                }
            }
            return null;
        }

        #region Add/Remove

        public virtual bool AddAdoptPetTo(UsersPetinfo pet, int place)
        {
            if (pet == null || place >= m_aCapalility || place < 0) return false;

            lock (m_lock)
            {
                if (m_adoptPets[place] != null)
                    place = -1;
                else
                {
                    m_adoptPets[place] = pet;
                    pet.Place = place;
                }
            }
            //if (place != -1)
            //    OnPlaceChanged(place);

            return place != -1;
        }


        public virtual bool RemoveAdoptPet(UsersPetinfo pet)
        {
            if (pet == null) return false;
            int place = -1;
            lock (m_lock)
            {
                for (int i = 0; i < m_aCapalility; i++)
                {
                    if (m_adoptPets[i] == pet)
                    {
                        place = i;
                        m_adoptPets[i] = null;

                        break;
                    }
                }
                //if (place != -1)
                //{                   
                //    pet.Place = -1;
                //}
            }

            return place != -1;
        }


        public bool AddPet(UsersPetinfo pet)
        {
            return AddPet(pet, m_beginSlot);
        }

        public bool AddPet(UsersPetinfo pet, int minSlot)
        {
            if (pet == null) return false;

            int place = FindFirstEmptySlot(minSlot);

            return AddPetTo(pet, place);
        }

        public virtual bool AddPetTo(UsersPetinfo pet, int place)
        {
            if (pet == null || place >= m_capalility || place < 0) return false;

            lock (m_lock)
            {
                if (m_pets[place] == null)
                {
                    m_pets[place] = pet;
                    pet.Place = place;
                    //Console.WriteLine("pet null!");                    
                }
                else
                {
                    place = -1;
                    //Console.WriteLine("Is exit!");
                }
            }
            if (place != -1)
                OnPlaceChanged(place);

            return place != -1;
        }

        
        public virtual bool RemovePet(UsersPetinfo pet)
        {
            if (pet == null) return false;
            int place = -1;
            lock (m_lock)
            {
                for (int i = 0; i < m_capalility; i++)
                {
                    if (m_pets[i] == pet)
                    {
                        place = i;
                        m_pets[i] = null;

                        break;
                    }
                }
            }
            if (place != -1)
            {
                OnPlaceChanged(place);
                pet.Place = -1;

            }
            return place != -1;
        }

        public bool RemovePetAt(int place)
        {
            return RemovePet(GetPetAt(place));
        }
        
        #endregion        
        
        #region Find Pets

        public virtual UsersPetinfo GetAdoptPetAt(int slot)
        {
            if (slot < 0 || slot >= m_aCapalility) return null;

            return m_adoptPets[slot];
        }

        public virtual UsersPetinfo GetPetAt(int slot)
        {
            if (slot < 0 || slot >= m_capalility) return null;

            return m_pets[slot];
        }
        public virtual UsersPetinfo[] GetAdoptPet()
        {
            List<UsersPetinfo> lists = new List<UsersPetinfo>();
            for (int i = 0; i < m_aCapalility; i++)
            {
                if (m_adoptPets[i] != null)
                {
                    if (m_adoptPets[i].IsExit)
                    {
                        lists.Add(m_adoptPets[i]);
                    }
                }
            }
            return lists.ToArray();
        }
        public int FindFirstEmptySlot()
        {
            return FindFirstEmptySlot(m_beginSlot);
        }

        /// <summary>
        /// 查找从Start开始的第一个空位
        /// </summary>
        /// <param name="start"></param>
        /// <returns></returns>
        public int FindFirstEmptySlot(int minSlot)
        {
            if (minSlot >= m_capalility) return -1;

            lock (m_lock)
            {
                for (int i = minSlot; i < m_capalility; i++)
                {
                    if (m_pets[i] == null)
                    {
                        return i;
                    }
                }
                return -1;
            }
        }

        /// <summary>
        /// 查找最后一个空位
        /// </summary>
        /// <returns></returns>
        public int FindLastEmptySlot()
        {
            lock (m_lock)
            {
                for (int i = m_capalility - 1; i >= 0; i--)
                {
                    if (m_pets[i] == null)
                    {
                        return i;
                    }
                }
                return -1;
            }
        }

        /// <summary>
        /// 清除所有物品
        /// </summary>
        public virtual void Clear()
        {
            lock (m_lock)
            {
                for (int i = 0; i < m_capalility; i++)
                {
                    m_pets[i] = null;
                }
            }
        }        

        public virtual UsersPetinfo GetPetByTemplateID(int minSlot, int templateId)
        {
            lock (m_lock)
            {
                for (int i = minSlot; i < m_capalility; i++)
                {
                    if (m_pets[i] != null && m_pets[i].TemplateID == templateId)
                    {
                        return m_pets[i];
                    }
                }
                return null;
            }
        }
        
        public virtual UsersPetinfo[] GetPets()
        {
            return m_pets;// GetPets(0, m_capalility).ToArray();
        }        

        public int GetEmptyCount()
        {
            return GetEmptyCount(m_beginSlot);
        }

        public virtual int GetEmptyCount(int minSlot)
        {
            if (minSlot < 0 || minSlot > m_capalility - 1) return 0;

            int count = 0;
            lock (m_lock)
            {
                for (int i = minSlot; i < m_capalility; i++)
                {
                    if (m_pets[i] == null)
                    {
                        count++;
                    }
                }
            }
            return count;
        }
        
        #endregion

        #region BeginChanges/CommiteChanges/UpdateChanges

        protected List<int> m_changedPlaces = new List<int>();
        private int m_changeCount;

        protected void OnPlaceChanged(int place)
        {
            if (m_changedPlaces.Contains(place) == false)
                m_changedPlaces.Add(place);

            if (m_changeCount <= 0 && m_changedPlaces.Count > 0)
            {
                UpdateChangedPlaces();
            }
        }

        public void BeginChanges()
        {
            Interlocked.Increment(ref m_changeCount);
        }

        public void CommitChanges()
        {
            int changes = Interlocked.Decrement(ref m_changeCount);
            if (changes < 0)
            {
                if (log.IsErrorEnabled)
                    log.Error("Inventory changes counter is bellow zero (forgot to use BeginChanges?)!\n\n" + Environment.StackTrace);
                Thread.VolatileWrite(ref m_changeCount, 0);
            }
            if (changes <= 0 && m_changedPlaces.Count > 0)
            {
                UpdateChangedPlaces();
            }
        }
        
        public virtual void UpdateChangedPlaces()
        {
            m_changedPlaces.Clear();
        }
        
       #endregion
        //
        public virtual bool RenamePet(int place, string name)
        {
            lock (m_lock)
            {
                m_pets[place].Name = name;
                return true;
            }            
        }
        public bool IsEquipSkill(int slot, string kill)
        {
            List<string> skillEquip =  m_pets[slot].GetSkillEquip();
            for (int s = 0; s < skillEquip.Count; s++)
            {
                if (skillEquip[s].Split(',')[0] == kill)
                {
                    return false;
                }
            }
            return true;
        }

        public virtual bool EquipSkillPet(int place, int killId, int killindex)
        {
            string skill = killId + "," + killindex;
            UsersPetinfo pet = m_pets[place];
            lock (m_lock)
            {
                if (killId == 0)
                {
                    m_pets[place].SkillEquip = SetSkillEquip(pet, killindex, skill);
                    return true;
                }
                else
                {
                    if (IsEquipSkill(place, killId.ToString()))
                    {
                        m_pets[place].SkillEquip = SetSkillEquip(pet, killindex, skill);
                        return true;
                    }
                }
                
            }
            return false;
        }
        public string SetSkillEquip(UsersPetinfo pet, int place, string skill)
        {
            List<string> list = pet.GetSkillEquip();
            list[place] = skill;
            string skills = list[0];
            for (int s = 1; s < list.Count; s++)
            {
                skills += "|" + list[s];
                
            }            
            return skills;
        }
        public virtual bool SetIsEquip(int place, bool isEquip)
        {
            lock (m_lock)
            {
                for (int index = 0; index < m_pets.Length; index++)
                {
                    if (m_pets[index] != null)
                    {
                        if (m_pets[index].Place == place)
                        {
                            m_pets[index].IsEquip = isEquip;
                        }
                        else
                        {
                            m_pets[index].IsEquip = false;
                        }
                    }
                }
            }

            return true;
        }
        public virtual bool UpGracePet(UsersPetinfo pet, int place, bool isUpdateProp, int min, int max, ref string msg)
        {
            UsersPetinfo r_pet = pet;
            if (isUpdateProp)
            {
                int blood = 0; int attack = 0; int defence = 0; int agility = 0; int lucky = 0;
                PetMgr.PlusPetProp(r_pet, min, max, ref blood, ref attack, ref defence, ref agility, ref lucky);
                r_pet.Blood = blood;
                r_pet.Attack = attack;
                r_pet.Defence = defence;
                r_pet.Agility = agility;
                r_pet.Luck = lucky;
                r_pet.TemplateID = PetMgr.UpdateEvolution(r_pet.TemplateID, max);
                r_pet.Skill = PetMgr.UpdateSkillPet(max, r_pet.TemplateID);
                r_pet.SkillEquip = PetMgr.ActiveEquipSkill(max);
                if (max > min)
                    msg = (r_pet.Name + " Parabéns <Jogador> teve seu animal de estimação promovido ao nível " + max);
            }
            lock (m_lock)
            {
                m_pets[place] = r_pet;
            }
            return true;
        }
        //
    }
}
