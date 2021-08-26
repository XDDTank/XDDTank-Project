using System;
using System.Collections.Generic;


namespace SqlDataProvider.Data
{
    public class ItemInfo : DataObject
    {
        private ItemTemplateInfo _template;
        
        public ItemInfo(ItemTemplateInfo temp)
        {
            _template = temp;
        }

        public ItemTemplateInfo Template
        {
            get
            {
                return _template;
            }
        }        
        private int _itemID;
        public int ItemID
        {
            set
            {
                _itemID = value;
                _isDirty = true;
            }
            get
            {
                return _itemID;
            }
        }

        private int _userID;
        public int UserID
        {
            set
            {
                _userID = value;
                _isDirty = true;
            }
            get
            {
                return _userID;
            }
        }

        private int _bagType;
        public int BagType
        {
            set { _bagType = value; _isDirty = true; }
            get { return _bagType; }
        }

        private int _templateId;
        public int TemplateID
        {
            set { _templateId = value; _isDirty = true; }
            get { return _templateId; }
        }        
        private int _place;
        public int Place
        {
            set { _place = value; _isDirty = true; }
            get { return _place; }
        }

        private int _count;
        public int Count
        {
            set { _count = value; _isDirty = true; }
            get { return _count; }
        }

        private bool _isJudage;
        public bool IsJudge
        {
            set { _isJudage = value; _isDirty = true; }
            get { return _isJudage; }
        }

        private string _color;
        public string Color
        {
            set { _color = value; _isDirty = true; }
            get { return _color; }
        }

        private bool _isExist;
        public bool IsExist
        {
            set { _isExist = value; _isDirty = true; }
            get { return _isExist; }
        }

        private int _strengthenLevel;
        public int StrengthenLevel
        {
            set { _strengthenLevel = value; _isDirty = true; }
            get { return _strengthenLevel; }
        }
        private int _strengthenExp;
        public int StrengthenExp
        {
            set { _strengthenExp = value; _isDirty = true; }
            get { return _strengthenExp; }
        }
        private int _attackCompose;
        public int AttackCompose
        {
            set { _attackCompose = value; _isDirty = true; }
            get { return _attackCompose; }
        }

        private int _defendCompose;
        public int DefendCompose
        {
            set { _defendCompose = value; _isDirty = true; }
            get { return _defendCompose; }
        }

        private int _luckCompose;
        public int LuckCompose
        {
            set { _luckCompose = value; _isDirty = true; }
            get { return _luckCompose; }
        }

        private int _agilityCompose;
        public int AgilityCompose
        {
            set { _agilityCompose = value; _isDirty = true; }
            get { return _agilityCompose; }
        }

        private bool _isBinds;
        public bool IsBinds
        {
            set
            {
                //if (value && !_isBinds)
                //    _beginDate = DateTime.Now;
                _isBinds = value;
                _isDirty = true;
            }
            get { return _isBinds; }
        }

        private bool _isUsed;
        public bool IsUsed
        {
            set
            {
                if (_isUsed != value)
                {
                    _isUsed = value;
                    _isDirty = true;
                }
            }
            get { return _isUsed; }
        }

        private string _skin;
        public string Skin
        {
            set { _skin = value; _isDirty = true; }
            get { return _skin; }
        }

        private DateTime _beginDate;
        public DateTime BeginDate
        {
            set { _beginDate = value; _isDirty = true; }
            get { return _beginDate; }
        }

        private int _validDate;
        public int ValidDate
        {
            set { _validDate = value; _isDirty = true; }
            get { return _validDate; }
        }

        private DateTime _removeDate;
        public DateTime RemoveDate
        {
            set { _removeDate = value; _isDirty = true; }
            get { return _removeDate; }
        }

        private int _removeType;
        public int RemoveType
        {
            set { _removeType = value; _removeDate = DateTime.Now; _isDirty = true; }
            get { return _removeType; }
        }

        private int _hole1;
        public int Hole1
        {
            get { return _hole1; }
            set { _hole1 = value; _isDirty = true; }
        }

        private int _hole2;
        public int Hole2
        {
            get { return _hole2; }
            set { _hole2 = value; _isDirty = true; }
        }

        private int _hole3;
        public int Hole3
        {
            get { return _hole3; }
            set { _hole3 = value; _isDirty = true; }
        }

        private int _hole4;
        public int Hole4
        {
            get { return _hole4; }
            set { _hole4 = value; _isDirty = true; }
        }

        private int _hole5;
        public int Hole5
        {
            get { return _hole5; }
            set { _hole5 = value; _isDirty = true; }
        }

        private int _hole6;
        public int Hole6
        {
            get { return _hole6; }
            set { _hole6 = value; _isDirty = true; }
        }
        
        private int _strengthenTimes;
        public int StrengthenTimes
        {
            get { return _strengthenTimes; }
            set { _strengthenTimes = value; _isDirty = true; }
        }
        private int _hole5Level;
        public int Hole5Level
        {
            get { return _hole5Level; }
            set { _hole5Level = value; _isDirty = true; }
        }
        private int _hole6Level;
        public int Hole6Level
        {
            get { return _hole6Level; }
            set { _hole6Level = value; _isDirty = true; }
        }
        private int _hole5Exp;
        public int Hole5Exp
        {
            get { return _hole5Exp; }
            set { _hole5Exp = value; _isDirty = true; }
        }
        private int _hole6Exp;
        public int Hole6Exp
        {
            get { return _hole6Exp; }
            set { _hole6Exp = value; _isDirty = true; }
        }
        private bool _isGold;
        public bool IsGold
        {
            get { return _isGold; }
            set { _isGold = value; _isDirty = true; }
        }
        private int _goldValidDate;
        public int goldValidDate
        {
            
            get { return _goldValidDate; }
            set { _goldValidDate = value; _isDirty = true; }
        }
        private DateTime _goldBeginTime;
        public DateTime goldBeginTime
        {    
            //set { _removeType = value; _removeDate = DateTime.Now; _isDirty = true; }
            set { _goldBeginTime = value; _isDirty = true; }
            get { return _goldBeginTime; }
        }
        private string _latentEnergyCurStr;
        public string latentEnergyCurStr
        {

            get { return _latentEnergyCurStr; }
            set { _latentEnergyCurStr = value; _isDirty = true; }
        }
        private string _latentEnergyNewStr;
        public string latentEnergyNewStr
        {

            get { return _latentEnergyNewStr; }
            set { _latentEnergyNewStr = value; _isDirty = true; }
        }
        private DateTime _latentEnergyEndTime;
        public DateTime latentEnergyEndTime
        {
            //set { _removeType = value; _removeDate = DateTime.Now; _isDirty = true; }
            set { _latentEnergyEndTime = value; _isDirty = true; }
            get { return _latentEnergyEndTime; }
        }
        public int Attack
        {
            get
            {
                //return (100 + _attackCompose) * _template.Attack / 100;
                return _attackCompose + _template.Attack;
            }
        }

        public int Defence
        {
            get
            {
                //return (100 + _defendCompose) * _template.Defence / 100;
                return _defendCompose + _template.Defence;
            }
        }

        public int Agility
        {
            get
            {
                //return (100 + _agilityCompose) * _template.Agility / 100;
                return _agilityCompose + _template.Agility;
            }
        }

        public int Luck
        {
            get
            {
                //return (100 + _luckCompose) * _template.Luck / 100;
                return _luckCompose + _template.Luck;
            }
        }
        private int _beadExp;
        public int beadExp
        {
            get { return _beadExp; }
            set { _beadExp = value; _isDirty = true; }
        }
        private int _beadLevel;
        public int beadLevel
        {
            get { return _beadLevel; }
            set { _beadLevel = value; _isDirty = true; }
        }
        private bool _beadIsLock;
        public bool beadIsLock
        {
            get { return _beadIsLock; }
            set { _beadIsLock = value; _isDirty = true; }
        }
        private bool _isShowBind;
        public bool isShowBind
        {
            get { return _isShowBind; }
            set { _isShowBind = value; _isDirty = true; }
        }

        private int _Damage;
        public int Damage
        {
            get { return _Damage; }
            set { _Damage = value; _isDirty = true; }
        }
        private int _Guard;
        public int Guard
        {
            get { return _Guard; }
            set { _Guard = value; _isDirty = true; }
        }
        private int _Blood;
        public int Blood
        {
            get { return _Blood; }
            set { _Blood = value; _isDirty = true; }
        }

        private int _Bless;
        public int Bless
        {
            get { return _Bless; }
            set { _Bless = value; _isDirty = true; }
        }
        //--------------------------------------------------------
        public ItemInfo Clone()
        {
            ItemInfo c = new ItemInfo(_template);
            c._userID = _userID;
            c._validDate = _validDate;
            c._templateId = _templateId;
            c._strengthenLevel = _strengthenLevel;
            c._strengthenExp = _strengthenExp;
            c._luckCompose = _luckCompose;
            c._itemID = 0;
            c._isJudage = _isJudage;
            c._isExist = _isExist;
            c._isBinds = _isBinds;
            c._isUsed = _isUsed;
            c._defendCompose = _defendCompose;
            c._count = _count;
            c._color = _color;
            c.Skin = _skin;
            c._beginDate = _beginDate;
            c._attackCompose = _attackCompose;
            c._agilityCompose = _agilityCompose;
            c._bagType = _bagType;
            c._isDirty = true;
            c._removeDate = _removeDate;
            c._removeType = _removeType;
            c._hole1 = _hole1;
            c._hole2 = _hole2;
            c._hole3 = _hole3;
            c._hole4 = _hole4;
            c._hole5 = _hole5;
            c._hole6 = _hole6;
            c._hole5Exp = _hole5Exp;
            c._hole5Level = _hole5Level;
            c._hole6Exp = _hole6Exp;
            c._hole6Level = _hole6Level;
            c._isGold = _isGold;
            c._goldBeginTime = _goldBeginTime;
            c._goldValidDate = _goldValidDate;
            c._strengthenExp = _strengthenExp;
            c._latentEnergyCurStr = _latentEnergyCurStr;
            c._latentEnergyNewStr = _latentEnergyNewStr;
            c._latentEnergyEndTime = _latentEnergyEndTime;
            c._beadExp = _beadExp;
            c._beadLevel = _beadLevel;
            c._beadIsLock = _beadIsLock;
            c._isShowBind = _isShowBind;
            c._Damage = _Damage;
            c._Guard = _Guard;
            c._Bless = _Bless;
            c._Blood = _Blood;
            return c;
        }

        public bool IsValidItem()
        {
            if (_validDate != 0 && _isUsed)
            {
                return DateTime.Compare(_beginDate.AddDays(_validDate), DateTime.Now) > 0;
            }
            return true;
        }
        public bool IsValidGoldItem()
        {
            if (_goldBeginTime.Date < DateTime.Now.Date && _strengthenLevel == 13)
            {
                return true;
            }
            return false;
        }
        public bool CanStackedTo(ItemInfo to)
        {
            if (_templateId == to.TemplateID && Template.MaxCount > 1 && _isBinds == to.IsBinds && _isUsed == to._isUsed )
            {
                if (ValidDate == 0 || (BeginDate.Date == to.BeginDate.Date && ValidDate == ValidDate))
                {
                    return true;
                }
            }
            return false;
        }

        public int GetBagType()
        {
            switch (_template.CategoryID)
            {
                case 10:
                case 11:
                    return 1;
                case 12:
                    return 2;
                default:
                    return 0;
            }
        }

        public bool CanEquip()
        {
            if (_template.CategoryID < 10 || (_template.CategoryID >= 13 && _template.CategoryID <= 16))
                return true;

            return false;
        }

        public string GetBagName()
        {
            switch (_template.CategoryID)
            {
                case 10:
                case 11:
                    //return "道具";
                    return "Game.Server.GameObjects.Prop";
                case 12:
                    //return "任务";
                    return "Game.Server.GameObjects.Task";
                default:
                    //return "装备";
                    return "Game.Server.GameObjects.Equip";
            }
        }

        public static ItemInfo CreateFromTemplate(ItemTemplateInfo goods, int count, int type)
        {
            if (goods == null)
            {
                return null;
            }

            return new ItemInfo(goods)
            {
                AgilityCompose = 0,
                AttackCompose = 0,
                BeginDate = DateTime.Now,
                Color = "",
                Skin = "",
                DefendCompose = 0,
                IsUsed = false,
                IsDirty = false,
                IsExist = true,
                IsJudge = true,
                LuckCompose = 0,
                StrengthenLevel = 0,
                TemplateID = goods.TemplateID,
                ValidDate = 0,
                Count = count,
                IsBinds = (goods.BindType == 1) ? true : false,
                _removeDate = DateTime.Now,
                _removeType = type,
                Hole1 = -1,
                Hole2 = -1,
                Hole3 = -1,
                Hole4 = -1,
                Hole5 = -1,
                Hole6 = -1,
                Hole5Exp = 0,
                Hole5Level = 0,
                Hole6Exp = 0,
                Hole6Level = 0,
                IsGold = false,
                goldValidDate = 0,
                goldBeginTime = DateTime.Now,
                StrengthenExp = 0,
                latentEnergyCurStr = "0,0,0,0",
                latentEnergyNewStr = "0,0,0,0",
                latentEnergyEndTime = DateTime.Now,
                beadExp = 0,
                beadLevel = 0,
                beadIsLock = false,
                isShowBind = false,
                Damage = 0,
                Guard = 0,
                Bless = 0,
                Blood = 0,
            };
            //return userGoods;
        }
        
        public static ItemInfo CreateWeapon(ItemTemplateInfo goods, ItemInfo item, int type)
        {
            if (goods == null)
                return null;

            ItemInfo userGoods = new ItemInfo(goods);
            userGoods.AgilityCompose = item.AgilityCompose;
            userGoods.AttackCompose = item.AttackCompose;
            userGoods.BeginDate = DateTime.Now;
            userGoods.Color = "";
            userGoods.Skin = "";
            userGoods.DefendCompose = item.DefendCompose;
            userGoods.IsBinds = item.IsBinds;
            userGoods.Place = item.Place;
            userGoods.IsUsed = false;
            userGoods.IsDirty = false;
            userGoods.IsExist = true;
            userGoods.IsJudge = true;
            userGoods.LuckCompose = item.LuckCompose;
            userGoods.StrengthenExp = item.StrengthenExp;
            userGoods.StrengthenLevel = item.StrengthenLevel;
            userGoods.TemplateID = goods.TemplateID;
            userGoods.ValidDate = item.ValidDate;
            userGoods._template = goods;
            userGoods.Count = 1;
            userGoods._removeDate = DateTime.Now;
            userGoods._removeType = type;
            userGoods.Hole1 = item.Hole1;
            userGoods.Hole2 = item.Hole2;
            userGoods.Hole3 = item.Hole3;
            userGoods.Hole4 = item.Hole4;
            userGoods.Hole5 = item.Hole5;
            userGoods.Hole6 = item.Hole6;
            userGoods.Hole5Level = item.Hole5Level;
            userGoods.Hole5Exp = item.Hole5Exp;
            userGoods.Hole6Level = item.Hole6Level;
            userGoods.Hole6Exp = item.Hole6Exp;
            userGoods.IsGold = item.IsGold;
            userGoods.goldBeginTime = item.goldBeginTime;
            userGoods.goldValidDate = item.goldValidDate;
            userGoods.latentEnergyCurStr = "0,0,0,0";
            userGoods.latentEnergyNewStr = "0,0,0,0";
            OpenHole(ref userGoods);
            return userGoods;
        }

        public static void FindSpecialItemInfo(ItemInfo info, ref int gold, ref int money, ref int giftToken, ref int medal) //trminhpc
        {            
            switch (info.TemplateID)
            {
                case -100:
                    gold += info.Count;
                    info=null;
                    break;
                case -200:
                    money += info.Count;
                    info=null;
                    break;
                case -1100:
                    giftToken += info.Count;
                    info = null;
                    break;
                case 11408:
                    medal += info.Count;
                    info = null;
                    break;
                default:    ///11107                
                    break;
            }
        }


        /// <summary>
        /// 获取物品花费的金钱
        /// </summary>
        /// <param name="shop">商店物品</param>
        /// <param name="type">购买类型：以时间范围或以数量多少为单位</param>
        /// <param name="gold">花费金币</param>
        /// <param name="money">花费点券</param>
        /// <param name="offer">花费功勋</param>
        /// <param name="gifttoken">花费礼券</param>
        /// <param name="?">兑换物品（物品编号+数量）</param>
        /// <returns>返回</returns> List<int>
        public static bool SetItemType(ShopItemInfo shop, int type, ref int gold, ref int money, ref int offer, ref int gifttoken, ref int medal)
        {
            
            if (type == 1)
            {
                GetItemPrice(shop.APrice1, shop.AValue1, shop.Beat, ref gold, ref money, ref offer, ref gifttoken, ref medal);//, ref iTemplateID, ref iCount);
                
                GetItemPrice(shop.APrice2, shop.AValue2, shop.Beat, ref gold, ref money, ref offer, ref gifttoken, ref medal);//, ref iTemplateID, ref iCount);
                
                GetItemPrice(shop.APrice3, shop.AValue3, shop.Beat, ref gold, ref money, ref offer, ref gifttoken, ref medal);//, ref iTemplateID, ref iCount);
                                
            }
            if (type == 2)
            {
                GetItemPrice(shop.BPrice1, shop.BValue1, shop.Beat, ref gold, ref money, ref offer, ref gifttoken, ref medal);//, ref iTemplateID, ref iCount);
                
                GetItemPrice(shop.BPrice2, shop.BValue2, shop.Beat, ref gold, ref money, ref offer, ref gifttoken, ref medal);//, ref iTemplateID, ref iCount);
                
                GetItemPrice(shop.BPrice3, shop.BValue3, shop.Beat, ref gold, ref money, ref offer, ref gifttoken, ref medal);//, ref iTemplateID, ref iCount);

               
            }
            if (type == 3)
            {
                GetItemPrice(shop.CPrice1, shop.CValue1, shop.Beat, ref gold, ref money, ref offer, ref gifttoken, ref medal);//, ref iTemplateID, ref iCount);

                GetItemPrice(shop.CPrice2, shop.CValue2, shop.Beat, ref gold, ref money, ref offer, ref gifttoken, ref medal);//, ref iTemplateID, ref iCount);

                GetItemPrice(shop.CPrice3, shop.CValue3, shop.Beat, ref gold, ref money, ref offer, ref gifttoken, ref medal);//, ref iTemplateID, ref iCount);

            }
            return true; //itemsInfo;
        }

        public static void GetItemPrice(int Prices, int Values, decimal beat, ref int gold, ref int money, ref int offer, ref int gifttoken, ref int medal)//, ref int iTemplateID, ref int iCount)
        {
            //iTemplateID = 0;
            //iCount = 0;
            switch (Prices)
            {
                case -1:  //-1表示点券
                    money += (int)(Values * beat);
                    break;
                case -2:  //-2表示金币
                    gifttoken += (int)(Values * beat);
                    break;                
                case -3:  //-4表示礼劵
                    gold += (int)(Values * beat);                    
                    break;
                case -4:  //-3表示功勋
                    offer += (int)(Values * beat);
                    break;
                case 11408:  //-4表示礼劵
                    medal += (int)(Values * beat);
                    break;
                default:
                    //if (Prices > 0)
                    //{
                    //    iTemplateID = Prices;
                    //    iCount = Values;
                    //}
                    break;
            }
        }

        /// <summary>
        /// 设置开孔个数
        /// </summary>
        /// <param name="item"></param>
        public static void OpenHole(ref ItemInfo item)
        {
            string[] Hole = item.Template.Hole.Split('|');
            for (int i = 0; i < Hole.Length; i++)
            {
                string[] NeedLevel = Hole[i].Split(',');
                if (item.StrengthenLevel >= Convert.ToInt32(NeedLevel[0]) && Convert.ToInt32(NeedLevel[1]) != -1)
                {
                    switch (i)
                    {
                        case 0:
                            if (item.Hole1 < 0)
                                item.Hole1 = 0;
                            break;
                        case 1:
                            if (item.Hole2 < 0)
                                item.Hole2 = 0;
                            break;
                        case 2:
                            if (item.Hole3 < 0)
                                item.Hole3 = 0;
                            break;
                        case 3:
                            if (item.Hole4 < 0)
                                item.Hole4 = 0;
                            break;
                        case 4:
                            if (item.Hole5 < 0)
                                item.Hole5 = 0;
                            break;
                        case 5:
                            if (item.Hole6 < 0)
                                item.Hole6 = 0;
                            break;


                    }
                }

            }
        }
    }
}
