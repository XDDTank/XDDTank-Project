using System;
using System.Collections.Generic;
using System.Text;

namespace SqlDataProvider.Data
{
    public class UsersCardInfo: DataObject
    {
        private int _cardID;
        public int CardID
        {
            get
            {
                return _cardID;
            }
            set
            {
                _cardID = value;
                _isDirty = true;
            }
        }

        private int _cardType;
        public int CardType
        {
            get
            {
                return _cardType;
            }
            set
            {
                _cardType = value;
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
        private int _type;
        public int Type
        {
            get
            {
                return _type;
            }
            set
            {
                _type = value;
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

        private bool _isFirstGet;
        public bool isFirstGet
        {
            get
            {
                return _isFirstGet;
            }
            set
            {
                _isFirstGet = value;
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

        private int _cardGp;
        public int CardGP
        {
            get
            {
                return _cardGp;
            }
            set
            {
                _cardGp = value;
                _isDirty = true;
            }
        }
                
    }
}
