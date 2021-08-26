using System;
using System.Collections.Generic;
using System.Text;

namespace SqlDataProvider.Data
{
    public class TexpInfo : DataObject
    {
        public int ID { get; set; }//[ID]
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
        }//,[UserID]
        private int _spdTexpExp;
        public int spdTexpExp
        {
            get
            {
                return _spdTexpExp;
            }
            set
            {
                _spdTexpExp = value;
                _isDirty = true;
            }
        }//,[spdTexpExp]
        private int _attTexpExp;
        public int attTexpExp
        {
            get
            {
                return _attTexpExp;
            }
            set
            {
                _attTexpExp = value;
                _isDirty = true;
            }
        }//,[attTexpExp]
        private int _defTexpExp;
        public int defTexpExp
        {
            get
            {
                return _defTexpExp;
            }
            set
            {
                _defTexpExp = value;
                _isDirty = true;
            }
        }//,[defTexpExp]
        private int _hpTexpExp;
        public int hpTexpExp
        {
            get
            {
                return _hpTexpExp;
            }
            set
            {
                _hpTexpExp = value;
                _isDirty = true;
            }
        }//,[hpTexpExp]
        private int _lukTexpExp;
        public int lukTexpExp
        {
            get
            {
                return _lukTexpExp;
            }
            set
            {
                _lukTexpExp = value;
                _isDirty = true;
            }
        }//,[lukTexpExp]
        private int _texpTaskCount;
        public int texpTaskCount
        {
            get
            {
                return _texpTaskCount;
            }
            set
            {
                _texpTaskCount = value;
                _isDirty = true;
            }
        }//,[texpTaskCount]
        private int _texpCount;
        public int texpCount
        {
            get
            {
                return _texpCount;
            }
            set
            {
                _texpCount = value;
                _isDirty = true;
            }
        }//,[texpCount]
        private DateTime _texpTaskDate;
        public DateTime texpTaskDate
        {
            get
            {
                return _texpTaskDate;
            }
            set
            {
                _texpTaskDate = value;
                _isDirty = true;
            }
        }//,[texpTaskDate]
    }
}
