using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace SqlDataProvider.Data
{
    public class UserDragonBoat : DataObject
    {
        private int _userID;
        public int UserID
        {
            get { return _userID; }
            set { _userID = value; _isDirty = true; }
        }

        private string _nickname;
        public string NickName
        {
            get { return _nickname; }
            set { _nickname = value; _isDirty = true; }
        }

        private int _exp;
        public int Exp
        {
            get { return _exp; }
            set { _exp = value; _isDirty = true; }
        }

        private int _point;
        public int Point
        {
            get { return _point; }
            set { _point = value; _isDirty = true; }
        }

        private int _totalPoint;
        public int TotalPoint
        {
            get { return _totalPoint; }
            set { _totalPoint = value; _isDirty = true; }
        }
        private int _rankUser;
        public int Rank
        {
            get { return _rankUser; }
            set { _rankUser = value; }
        }
        private int _lessPoint;
        public int LessPoint
        {
            get { return _lessPoint; }
            set { _lessPoint = value; }
        }
    }
}
