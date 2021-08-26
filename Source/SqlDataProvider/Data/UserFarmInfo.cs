using System;
using System.Collections.Generic;
using System.Text;

namespace SqlDataProvider.Data
{
    public class UserFarmInfo : DataObject
    {
        private UserFieldInfo _field;
        public UserFieldInfo Field
        {
            get
            {
                return _field;
            }
            set
            {
                _field = value;
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
        private int _farmID;
        public int FarmID
        {
            get
            {
                return _farmID;
            }
            set
            {
                _farmID = value;
                _isDirty = true;
            }
        }       

        private string _payFieldMoney;
        public string PayFieldMoney
        {
            get
            {
                return _payFieldMoney;
            }
            set
            {
                _payFieldMoney = value;
                _isDirty = true;
            }
        }

        private string _payAutoMoney;
        public string PayAutoMoney
        {
            get
            {
                return _payAutoMoney;
            }
            set
            {
                _payAutoMoney = value;
                _isDirty = true;
            }
        }

        private DateTime _autoPayTime;
        public DateTime AutoPayTime
        {
            get
            {
                return _autoPayTime;
            }
            set
            {
                _autoPayTime = value;
                _isDirty = true;
            }
        }

        private int _autoValidDate;
        public int AutoValidDate
        {
            get
            {
                return _autoValidDate;
            }
            set
            {
                _autoValidDate = value;
                _isDirty = true;
            }
        }

        private int _vipLimitLevel;
        public int VipLimitLevel
        {
            get
            {
                return _vipLimitLevel;
            }
            set
            {
                _vipLimitLevel = value;
                _isDirty = true;
            }
        }

        private string _farmerName;
        public string FarmerName
        {
            get
            {
                return _farmerName;
            }
            set
            {
                _farmerName = value;
                _isDirty = true;
            }
        }

        private int _gainFieldId;
        public int GainFieldId
        {
            get
            {
                return _gainFieldId;
            }
            set
            {
                _gainFieldId = value;
                _isDirty = true;
            }
        }

        private int _matureId;
        public int MatureId
        {
            get
            {
                return _matureId;
            }
            set
            {
                _matureId = value;
                _isDirty = true;
            }
        }

        private int _killCropId;
        public int KillCropId
        {
            get
            {
                return _killCropId;
            }
            set
            {
                _killCropId = value;
                _isDirty = true;
            }
        }

        private int _isAutoId;
        public int isAutoId
        {
            get
            {
                return _isAutoId;
            }
            set
            {
                _isAutoId = value;
                _isDirty = true;
            }
        }

        private bool _isFarmHelper;
        public bool isFarmHelper
        {
            get
            {
                return _isFarmHelper;
            }
            set
            {
                _isFarmHelper = value;
                _isDirty = true;
            }
        } 
        //startdate        
        //autoTime
        //needSeed
        //getSeed
    }
}
