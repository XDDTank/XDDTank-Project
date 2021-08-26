using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Game.Server.GameObjects;
using SqlDataProvider.Data;
using Bussiness;
using Game.Server.Packets;

namespace Game.Server.GameUtils
{
    public class PetInventory : PetAbstractInventory
    {
        protected GamePlayer m_player;
        public GamePlayer Player
        {
            get
            {
                return m_player;
            }
        } 

        private bool m_saveToDb;

        private List<UsersPetinfo> m_removedList = new List<UsersPetinfo>();

        private List<UsersPetinfo> m_removedAdoptPetList = new List<UsersPetinfo>();

        public PetInventory(GamePlayer player, bool saveTodb, int capibility,int aCapability, int beginSlot)
            : base(capibility, aCapability, beginSlot)
        {
            m_player = player;
            m_saveToDb = saveTodb;
        }

        public virtual void LoadFromDatabase()
        {
            if (m_saveToDb)
            {
                using (PlayerBussiness pb = new PlayerBussiness())
                {
                    UsersPetinfo[] PetLists = pb.GetUserPetSingles(m_player.PlayerCharacter.ID);
                    UsersPetinfo[] PetAdoptLists = pb.GetUserAdoptPetSingles(m_player.PlayerCharacter.ID);
                    BeginChanges();
                    try
                    {
                        foreach (UsersPetinfo pet in PetLists)
                        {
                            AddPetTo(pet, pet.Place);
                        }
                        foreach (UsersPetinfo adoptPet in PetAdoptLists)
                        {
                            AddAdoptPetTo(adoptPet, adoptPet.Place);
                        }
                       
                    }
                    finally
                    {
                        CommitChanges();
                    }
                }
            }
        }
        
        public virtual void SaveToDatabase()
        {
            if (m_saveToDb)
            {
                using (PlayerBussiness pb = new PlayerBussiness())
                {
                    lock (m_lock)
                    {
                        for (int i = 0; i < m_pets.Length; i++)
                        {
                            UsersPetinfo pet = m_pets[i];
                            if (pet != null && pet.IsDirty)
                            {                                
                              pb.SaveUserPet(pet);                                    
                            }
                        }
                    }
                    lock (m_removedList)
                    {
                        foreach (UsersPetinfo pet in m_removedList)
                        {                          
                           pb.RemovePetSingle(pet.ID);
                            
                        }
                        m_removedList.Clear();
                    }
                    lock (m_removedAdoptPetList)
                    {
                        foreach (UsersPetinfo pet in m_removedAdoptPetList)
                        {                            
                            pb.RemoveUserAdoptPet(pet.ID);
                        }
                        m_removedAdoptPetList.Clear();
                    }
                }
            }
        }

        public override bool AddPetTo(UsersPetinfo pet, int place)
        {
            if (base.AddPetTo(pet, place))
            {
                pet.UserID = m_player.PlayerCharacter.ID;
                pet.IsExit = true;
                return true;
            }
            else
            {
                return false;
            }
        }
        
        public override bool RemovePet(UsersPetinfo pet)
        {
            if (base.RemovePet(pet))            
            {
                
                if (m_saveToDb)
                {
                    lock (m_removedList)
                    {
                        pet.IsExit = false;
                        m_removedList.Add(pet);
                    }
                }
                return true;
            }
            else
            {
                return false;
            }
        }
        public override bool AddAdoptPetTo(UsersPetinfo pet, int place)
        {
            if (base.AddAdoptPetTo(pet, place))
            {
                pet.UserID = m_player.PlayerCharacter.ID;
                pet.IsExit = true;
                return true;
            }
            else
            {
                return false;
            }
        }

        public override bool RemoveAdoptPet(UsersPetinfo pet)
        {
            if (base.RemoveAdoptPet(pet))
            {

                if (m_saveToDb)
                {
                    lock (m_removedAdoptPetList)
                    {                        
                        m_removedAdoptPetList.Add(pet);
                    }
                }
                return true;
            }
            else
            {
                return false;
            }
        }
        public override void UpdateChangedPlaces()
        {            
            int[] changedPlaces = m_changedPlaces.ToArray();
            m_player.Out.SendUpdateUserPet(this, changedPlaces);
            base.UpdateChangedPlaces();

        }
        /// <summary>
        /// 使用物品
        /// </summary>
        /// <param name="item"></param>
        
        public virtual void ClearAdoptPets()
        {
            lock (m_lock)
            {
                for (int i = 0; i < ACapalility; i++)
                {
                    if (m_adoptPets[i] != null)
                    {                        
                        m_adoptPets[i].IsExit = false;
                        m_removedAdoptPetList.Add(m_adoptPets[i]);
                    }
                    m_adoptPets[i] = null;
                }
            }
        }
        
        
        //-------------

    }
}
