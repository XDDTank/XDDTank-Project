using System;
using System.Collections.Generic;
using System.Text;

namespace SqlDataProvider.Data
{
    public class UsersPetinfo : DataObject
    {
        
        public List<string> GetSkill()
        {
            List<string> skills = new List<string>();
            string[] skillArray = _skill.Split('|');
            for (int i = 0; i < skillArray.Length; i++)
            {                
                skills.Add(skillArray[i]);
            }
            return skills;
        }
        public List<string> GetSkillEquip()
        {
            List<string> skills = new List<string>();
            string[] skillArray = _skillEquip.Split('|');
            for (int i = 0; i < skillArray.Length; i++)
            {
                skills.Add(skillArray[i]);
            }
            return skills;
        }
        private string _skillEquip;
        public string SkillEquip
        {
            get
            {
                return _skillEquip;
            }
            set
            {
                _skillEquip = value;
                _isDirty = true;
            }
        }

        private string _skill;
        public string Skill
        {
            get
            {
                return _skill;
            }
            set
            {
                _skill = value;
                _isDirty = true;
            }
        }
        private int _ID;
        public int ID
        {
            get
            {
                return _ID;
            }
            set
            {
                _ID = value;
                _isDirty = true;
            }
        }
        private int _templateID;
        public int TemplateID
        {
            get
            {
                return _templateID;
            }
            set
            {
                _templateID = value;
                _isDirty = true;
            }
        }

        private string _name;
        public string Name
        {
            get
            {
                return _name;
            }
            set
            {
                _name = value;
                _isDirty = true;
            }
        }

        private int _userID;
        public int UserID
        {
            get
            {
                return _userID;
            }
            set
            {
                _userID = value;
                _isDirty = true;
            }
        }

        private int _attack;
        public int Attack
        {
            get
            {
                return _attack;
            }
            set
            {
                _attack = value;
                _isDirty = true;
            }
        }

        private int _defence;
        public int Defence
        {
            get
            {
                return _defence;
            }
            set
            {
                _defence = value;
                _isDirty = true;
            }
        }

        private int _luck;
        public int Luck
        {
            get
            {
                return _luck;
            }
            set
            {
                _luck = value;
                _isDirty = true;
            }
        }

        private int _agility;
        public int Agility
        {
            get
            {
                return _agility;
            }
            set
            {
                _agility = value;
                _isDirty = true;
            }
        }

        private int _blood;
        public int Blood
        {
            get
            {
                return _blood;
            }
            set
            {
                _blood = value;
                _isDirty = true;
            }
        }

        private int _damage;
        public int Damage
        {
            get
            {
                return _damage;
            }
            set
            {
                _damage = value;
                _isDirty = true;
            }
        }

        private int _guard;
        public int Guard
        {
            get
            {
                return _guard;
            }
            set
            {
                _guard = value;
                _isDirty = true;
            }
        }

        private int _attackGrow;
        public int AttackGrow
        {
            get
            {
                return _attackGrow;
            }
            set
            {
                _attackGrow = value;
                _isDirty = true;
            }
        }

        private int _defenceGrow;
        public int DefenceGrow
        {
            get
            {
                return _defenceGrow;
            }
            set
            {
                _defenceGrow = value;
                _isDirty = true;
            }
        }

        private int _luckGrow;
        public int LuckGrow
        {
            get
            {
                return _luckGrow;
            }
            set
            {
                _luckGrow = value;
                _isDirty = true;
            }
        }

        private int _agilityGrow;
        public int AgilityGrow
        {
            get
            {
                return _agilityGrow;
            }
            set
            {
                _agilityGrow = value;
                _isDirty = true;
            }
        }

        private int _bloodGrow;
        public int BloodGrow
        {
            get
            {
                return _bloodGrow;
            }
            set
            {
                _bloodGrow = value;
                _isDirty = true;
            }
        }

        private int _damageGrow;
        public int DamageGrow
        {
            get
            {
                return _damageGrow;
            }
            set
            {
                _damageGrow = value;
                _isDirty = true;
            }
        }

        private int _guardGrow;
        public int GuardGrow
        {
            get
            {
                return _guardGrow;
            }
            set
            {
                _guardGrow = value;
                _isDirty = true;
            }
        }

        private int _level;
        public int Level
        {
            get
            {
                return _level;
            }
            set
            {
                _level = value;
                _isDirty = true;
            }
        }

        private int _gp;
        public int GP
        {
            get
            {
                return _gp;
            }
            set
            {
                _gp = value;
                _isDirty = true;
            }
        }

        private int _maxGP;
        public int MaxGP
        {
            get
            {
                return _maxGP;
            }
            set
            {
                _maxGP = value;
                _isDirty = true;
            }
        }

        private int _hunger;
        public int Hunger
        {
            get
            {
                return _hunger;
            }
            set
            {
                _hunger = value;
                _isDirty = true;
            }
        }

        private int _petHappyStar;
        public int PetHappyStar
        {
            get
            {
                return _petHappyStar;
            }
            set
            {
                _petHappyStar = value;
                _isDirty = true;
            }
        }

        private int _mp;
        public int MP
        {
            get
            {
                return _mp;
            }
            set
            {
                _mp = value;
                _isDirty = true;
            }
        }

        private bool _isEquip;
        public bool IsEquip
        {
            get
            {
                return _isEquip;
            }
            set
            {
                _isEquip = value;
                _isDirty = true;
            }
        }

        private int _place;
        public int Place
        {
            get
            {
                return _place;
            }
            set
            {
                _place = value;
                _isDirty = true;
            }
        }

        private bool _isExit;
        public bool IsExit
        {
            get
            {
                return _isExit;
            }
            set
            {
                _isExit = value;
                _isDirty = true;
            }
        }
        
    }
}
