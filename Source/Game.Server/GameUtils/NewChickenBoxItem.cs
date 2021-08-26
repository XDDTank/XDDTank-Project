using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Game.Server.GameObjects;
using SqlDataProvider.Data;
using Bussiness;
using Game.Server.Managers;
using Bussiness.Managers;
using Game.Server.Packets;

namespace Game.Server.GameUtils
{
    public class NewChickenBoxItem
    {
        private int m_itemid;
        private int m_count;
        private int m_strength;
        private int m_validate;
        private int m_attack;
        private int m_defence;
        private int m_agility;
        private int m_luck;
        public int ItemID
        {
            get { return m_itemid; }
            set { m_itemid = value; }
        }
        public int Count
        {
            get { return m_itemid; }
            set { m_itemid = value; }
        }
        public int StrengthLevel
        {
            get { return m_strength; }
            set { m_strength = value; }
        }
        public int IsValidate
        {
            get { return m_validate; }
            set { m_validate = value; }
        }
        public int AttackCompose
        {
            get { return m_attack; }
            set { m_attack = value; }
        }
        public int DefenceCompose
        {
            get { return m_defence; }
            set { m_defence = value; }
        }
        public int AgilityCompose
        {
            get { return m_agility; }
            set { m_agility = value; }
        }
        public int LuckyCompose
        {
            get { return m_luck; }
            set { m_luck = value; }
        }
    }
}
