using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Game.Logic.Phy.Object
{
    public class TurnedLiving : Living
    {
        
        public TurnedLiving(int id, BaseGame game, int team, string name, string modelId, int maxBlood, int immunity, int direction)
            : base(id, game, team, name, modelId, maxBlood, immunity, direction) { }

        public override void Reset()
        {
            base.Reset();
            if (this is Player)
            {
                m_delay = 1600 - 1200 * ((Player)this).PlayerDetail.PlayerCharacter.Agility / (((Player)this).PlayerDetail.PlayerCharacter.Agility + 1200) + ((Player)this).PlayerDetail.PlayerCharacter.Attack / 10;//(int)(Agility);
            }
            else
            {
                m_delay = (int)(Agility);
            }
        }

        #region Delay/AddDelay

        protected int m_delay;

        public int Delay
        {
            get { return m_delay; }
            set { m_delay = value; }
        }

        public void AddDelay(int value)
        {
            m_delay += value;
        }
        public int DefaultDelay;

        public override void PrepareSelfTurn()
        {
            
            DefaultDelay = m_delay;
            if (IsFrost)
            {
                if (this is Player)
                {
                    AddDelay(1600 - 1200 * ((Player)this).PlayerDetail.PlayerCharacter.Agility / (((Player)this).PlayerDetail.PlayerCharacter.Agility + 1200) + ((Player)this).PlayerDetail.PlayerCharacter.Attack / 10);
                }
                else
                {
                    AddDelay((this as SimpleBoss).NpcInfo.Delay);
                }
            }
            base.PrepareSelfTurn();
        }
        #endregion

        #region

        private int m_dander;
        private int m_psychic = 20;
        private int m_petMaxMP = 100;
        private int m_petMP = 10;
        public int psychic
        {
            get { return m_psychic; }
            set { m_psychic = value; }
        }
        public int PetMaxMP
        {
            get { return m_petMaxMP; }
            set { m_petMaxMP = value; }
        }
        public int PetMP
        {
            get { return m_petMP; }
            set { m_petMP = value; }
        }

        public int Dander
        {
            get { return m_dander; }
            set { m_dander = value; }
        }
        public void AddPetMP()
        {
            //if (value > 0)
            //{
            if (IsLiving && PetMP < PetMaxMP)
            {
                m_petMP += 10;
            }
            else { m_petMP = PetMaxMP; }
            //}
        }
        
        public void AddDander(int value)
        {
            if (value > 0)
            {
                if (IsLiving)
                {
                    SetDander(m_dander + value);
                }
            }
        }

        public void SetDander(int value)
        {
            m_dander = Math.Min(value, 200);
            if (SyncAtTime)
            {
                m_game.SendGameUpdateDander(this);
            }
        }

        #endregion



        #region StartGame/BeginNewTurn/StartAttacking/StopAttacking

        public virtual void StartGame() { }

        public virtual void Skip(int spendTime)
        {
            if (IsAttacking)
            {
                StopAttacking();

                m_game.CheckState(0);
            }
        }

        #endregion

        #region Events



        #endregion
    }

    public delegate void TurnedLivingEventHandle(TurnedLiving living);
}
