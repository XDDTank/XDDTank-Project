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
    public class CardInventory : CardAbstractInventory
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

        private List<UsersCardInfo> m_removedList = new List<UsersCardInfo>();

        public CardInventory(GamePlayer player, bool saveTodb, int capibility, int beginSlot)
            : base(capibility, beginSlot)
        {
            m_player = player;
            m_saveToDb = saveTodb;
        }

        public virtual void LoadFromDatabase()
        {
            //m_cards = pb.GetUserCardSingles(m_character.ID);
            //m_cardslots = pb.GetUserCardEuqip(m_character.ID);
            if (m_saveToDb)
            {
                using (PlayerBussiness pb = new PlayerBussiness())
                {
                    UsersCardInfo[] list = pb.GetUserCardSingles(m_player.PlayerCharacter.ID);
                    BeginChanges();

                    try
                    {
                        foreach (UsersCardInfo card in list)
                        {                           
                          AddCardTo(card, card.Place);
                          
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
                        for (int i = 0; i < m_cards.Length; i++)
                        {
                            UsersCardInfo card = m_cards[i];
                            if (card != null && card.IsDirty)
                            {
                                if (card.CardID > 0)
                                {
                                    pb.UpdateCards(card);
                                    
                                }
                                else
                                {
                                    pb.AddCards(card);
                                }
                            }
                        }
                    }

                    lock (m_removedList)
                    {
                        foreach (UsersCardInfo card in m_removedList)
                        {
                            if (card.CardID > 0)
                            {
                                pb.UpdateCards(card);                                
                            }
                        }
                        m_removedList.Clear();
                    }
                }
            }
        }
        
        public override bool AddCardTo(UsersCardInfo item, int place)
        {
            if (base.AddCardTo(item, place))
            {
                item.UserID = m_player.PlayerCharacter.ID;
                item.IsExit = true;
                return true;
            }
            else
            {
                return false;
            }
        } 
        public override void UpdateChangedPlaces()
        {
            //Console.WriteLine(m_changedPlaces.ToArray().ToString());
            int[] changedPlaces = m_changedPlaces.ToArray();
            m_player.Out.SendPlayerCardInfo(this, changedPlaces);
            base.UpdateChangedPlaces();

        }        

    }
}
