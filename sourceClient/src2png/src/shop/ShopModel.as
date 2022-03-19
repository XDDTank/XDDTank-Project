// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//shop.ShopModel

package shop
{
    import flash.events.EventDispatcher;
    import road7th.data.DictionaryData;
    import ddt.data.player.PlayerInfo;
    import ddt.data.player.SelfInfo;
    import ddt.manager.PlayerManager;
    import ddt.events.PlayerPropertyEvent;
    import ddt.events.BagEvent;
    import ddt.data.goods.ShopCarItemInfo;
    import flash.events.Event;
    import ddt.manager.ShopManager;
    import ddt.data.ShopType;
    import __AS3__.vec.Vector;
    import ddt.data.goods.ShopItemInfo;
    import ddt.manager.MessageTipManager;
    import ddt.manager.LanguageMgr;
    import ddt.data.goods.ItemPrice;
    import ddt.data.EquipType;
    import ddt.data.goods.InventoryItemInfo;
    import flash.utils.Dictionary;
    import com.pickgliss.utils.ObjectUtils;

    public class ShopModel extends EventDispatcher 
    {

        private static var DEFAULT_MAN_STYLE:String = "5101,2101,3101,4101,1101,6101,400105,13101,15001";
        private static var DEFAULT_WOMAN_STYLE:String = "5201,2201,3201,4201,1201,6201,400105,13201,15001";
        public static const SHOP_CART_MAX_LENGTH:uint = 20;

        public var leftCarList:Array = [];
        public var leftManList:Array = [];
        public var leftWomanList:Array = [];
        private var _bodyThings:DictionaryData;
        private var _carList:Array;
        private var _currentGift:int;
        private var _currentGold:int;
        private var _currentMedal:int;
        private var _currentMoney:int;
        private var _totalGold:int;
        private var _totalMedal:int;
        private var _totalMoney:int;
        private var _defaultModel:int;
        private var _manMemoryList:Array;
        private var _manModel:PlayerInfo;
        private var _manTempList:Array;
        private var _womanMemoryList:Array;
        private var _womanModel:PlayerInfo;
        private var _womanTempList:Array;
        private var _manHistoryList:Array;
        private var _womanHistoryList:Array;
        private var _self:SelfInfo;
        private var _sex:Boolean;
        private var _totalGift:int;
        private var maleCollocation:Array;
        private var femaleCollocation:Array;

        public function ShopModel()
        {
            this._self = PlayerManager.Instance.Self;
            this._womanModel = new PlayerInfo();
            this._manModel = new PlayerInfo();
            this._womanTempList = [];
            this._manTempList = [];
            this._carList = [];
            this._manMemoryList = [];
            this._womanMemoryList = [];
            this._manHistoryList = [];
            this._womanHistoryList = [];
            this._totalGold = 0;
            this._totalMoney = 0;
            this._totalGift = 0;
            this._totalMedal = 0;
            this._defaultModel = 1;
            this.init();
            this.fittingSex = this._self.Sex;
            this._self.addEventListener(PlayerPropertyEvent.PROPERTY_CHANGE, this.__styleChange);
            this._self.Bag.addEventListener(BagEvent.UPDATE, this.__bagChange);
            this.initRandom();
        }

        public function removeLatestItem():void
        {
            var _local_4:Array;
            var _local_5:ShopCarItemInfo;
            var _local_6:Array;
            var _local_7:ShopCarItemInfo;
            var _local_8:int;
            var _local_1:Array = ((this._sex) ? this._manTempList : this._womanTempList);
            if (this.currentHistoryList.length > 0)
            {
                _local_4 = this.currentHistoryList.pop();
                for each (_local_5 in _local_4)
                {
                    this.removeTempEquip(_local_5);
                };
            };
            var _local_2:Array = [];
            var _local_3:int = (this.currentHistoryList.length - 1);
            while (_local_3 > -1)
            {
                _local_6 = this.currentHistoryList[_local_3];
                for each (_local_7 in _local_6)
                {
                    _local_8 = this.currentTempListHasItem(_local_7.TemplateInfo.CategoryID);
                    if (_local_8 <= -1)
                    {
                        this.currentTempList.push(_local_7);
                        dispatchEvent(new ShopEvent(ShopEvent.ADD_TEMP_EQUIP, _local_7));
                        _local_7.addEventListener(Event.CHANGE, this.__onItemChange);
                    };
                };
                _local_3--;
            };
            this.updateCost();
        }

        private function currentTempListHasItem(_arg_1:int):int
        {
            var _local_3:ShopCarItemInfo;
            var _local_2:Array = this.currentTempList;
            for each (_local_3 in _local_2)
            {
                if (_local_3.TemplateInfo.CategoryID == _arg_1)
                {
                    return (_local_2.indexOf(_local_3));
                };
            };
            return (-1);
        }

        public function get currentHistoryList():Array
        {
            return ((this._sex) ? this._manHistoryList : this._womanHistoryList);
        }

        private function initRandom():void
        {
            this.maleCollocation = [];
            this.femaleCollocation = [];
            this.maleCollocation.push(ShopManager.Instance.getValidGoodByType(ShopType.M_CLOTH));
            this.maleCollocation.push(ShopManager.Instance.getValidGoodByType(ShopType.M_HAT));
            this.maleCollocation.push(ShopManager.Instance.getValidGoodByType(ShopType.M_GLASS));
            this.maleCollocation.push(ShopManager.Instance.getValidGoodByType(ShopType.M_HAIR));
            this.maleCollocation.push(ShopManager.Instance.getValidGoodByType(ShopType.M_EYES));
            this.maleCollocation.push(ShopManager.Instance.getValidGoodByType(ShopType.M_LIANSHI));
            this.femaleCollocation.push(ShopManager.Instance.getValidGoodByType(ShopType.F_CLOTH));
            this.femaleCollocation.push(ShopManager.Instance.getValidGoodByType(ShopType.F_HAT));
            this.femaleCollocation.push(ShopManager.Instance.getValidGoodByType(ShopType.F_GLASS));
            this.femaleCollocation.push(ShopManager.Instance.getValidGoodByType(ShopType.F_HAIR));
            this.femaleCollocation.push(ShopManager.Instance.getValidGoodByType(ShopType.F_EYES));
            this.femaleCollocation.push(ShopManager.Instance.getValidGoodByType(ShopType.F_LIANSHI));
        }

        public function random():void
        {
            var _local_3:Vector.<ShopItemInfo>;
            var _local_4:int;
            var _local_1:Array = ((this._sex) ? this.maleCollocation : this.femaleCollocation);
            var _local_2:Array = [];
            for each (_local_3 in _local_1)
            {
                _local_4 = Math.floor((Math.random() * _local_3.length));
                _local_2.push(this.fillToShopCarInfo(_local_3[_local_4]));
            };
            this.addTempEquip(_local_2);
            this.updateCost();
        }

        public function get Self():SelfInfo
        {
            return (this._self);
        }

        public function isCarListMax():Boolean
        {
            return (((this._carList.length + this._manTempList.length) + this._womanTempList.length) >= SHOP_CART_MAX_LENGTH);
        }

        public function addTempEquip(_arg_1:*):Boolean
        {
            var _local_3:Array;
            var _local_4:Array;
            var _local_5:ShopItemInfo;
            var _local_6:int;
            var _local_7:ShopCarItemInfo;
            var _local_8:int;
            var _local_9:ShopCarItemInfo;
            var _local_2:Boolean = this.isCarListMax();
            if (_local_2)
            {
                MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("shop.ShopIIModel.car"));
                return (_local_2);
            };
            if ((_arg_1 is Array))
            {
                _local_3 = (_arg_1 as Array);
                _local_4 = [];
                for each (_local_5 in _local_3)
                {
                    _local_6 = this.currentTempListHasItem(_local_5.TemplateInfo.CategoryID);
                    if (_local_6 > -1)
                    {
                        this.currentTempList.splice(_local_6, 1);
                    };
                    _local_7 = this.fillToShopCarInfo(_local_5);
                    _local_7.dressing = true;
                    _local_7.ModelSex = this.currentModel.Sex;
                    this.currentTempList.push(_local_7);
                    dispatchEvent(new ShopEvent(ShopEvent.ADD_TEMP_EQUIP, _local_7));
                    this.updateCost();
                    _local_7.addEventListener(Event.CHANGE, this.__onItemChange);
                    _local_4.push(_local_7);
                };
                this.currentHistoryList.push(_local_4);
            }
            else
            {
                _local_8 = this.currentTempListHasItem(_arg_1.TemplateInfo.CategoryID);
                if (_local_8 > -1)
                {
                    this.currentTempList.splice(_local_8, 1);
                };
                _local_9 = this.fillToShopCarInfo(_arg_1);
                _local_9.dressing = true;
                _local_9.ModelSex = this.currentModel.Sex;
                this.currentTempList.push(_local_9);
                dispatchEvent(new ShopEvent(ShopEvent.ADD_TEMP_EQUIP, _local_9));
                this.updateCost();
                _local_9.addEventListener(Event.CHANGE, this.__onItemChange);
                this.currentHistoryList.push([_local_9]);
            };
            return (!(_local_2));
        }

        public function addToShoppingCar(_arg_1:ShopCarItemInfo):void
        {
            if (this.isCarListMax())
            {
                MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("shop.ShopIIModel.car"));
                return;
            };
            if (this.isOverCount(_arg_1))
            {
                MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("shop.ShopIIModel.GoodsNumberLimit"));
                return;
            };
            this._carList.push(_arg_1);
            this.updateCost();
            _arg_1.addEventListener(Event.CHANGE, this.__onItemChange);
            dispatchEvent(new ShopEvent(ShopEvent.ADD_CAR_EQUIP, _arg_1));
        }

        private function __onItemChange(_arg_1:Event):void
        {
            this.updateCost();
        }

        public function isOverCount(_arg_1:ShopItemInfo):Boolean
        {
            var _local_5:ShopCarItemInfo;
            var _local_2:uint;
            var _local_3:Array = this.allItems;
            var _local_4:int;
            while (_local_4 < _local_3.length)
            {
                _local_5 = (_local_3[_local_4] as ShopCarItemInfo);
                if (_arg_1.TemplateID == _local_5.TemplateID)
                {
                    _local_2++;
                };
                _local_4++;
            };
            return (((_local_2 >= _arg_1.LimitCount) && (!(_arg_1.LimitCount == -1))) ? true : false);
        }

        public function get allItems():Array
        {
            return (this._carList.concat(this._manTempList).concat(this._womanTempList));
        }

        public function get allItemsCount():int
        {
            return ((this._carList.length + this._manTempList.length) + this._womanTempList.length);
        }

        public function calcPrices(_arg_1:Array):Array
        {
            var _local_2:ItemPrice = new ItemPrice(null, null, null);
            var _local_3:int;
            var _local_4:int;
            var _local_5:int;
            var _local_6:int;
            while (_local_6 < _arg_1.length)
            {
                _local_2.addItemPrice(_arg_1[_local_6].getCurrentPrice());
                _local_6++;
            };
            _local_3 = _local_2.moneyValue;
            _local_4 = _local_2.ddtMoneyValue;
            return ([_local_3, _local_4, _local_5]);
        }

        public function canBuyLeastOneGood(_arg_1:Array):Boolean
        {
            return (ShopManager.Instance.buyLeastGood(_arg_1, this._self));
        }

        public function canChangSkin():Boolean
        {
            var _local_1:Array = this.currentTempList;
            var _local_2:int;
            while (_local_2 < _local_1.length)
            {
                if (_local_1[_local_2].CategoryID == EquipType.FACE)
                {
                    return (true);
                };
                _local_2++;
            };
            return (false);
        }

        public function clearAllitems():void
        {
            this._carList = [];
            this._defaultModel = 1;
            this._manTempList = [];
            this._womanTempList = [];
            this.updateCost();
            dispatchEvent(new ShopEvent(ShopEvent.UPDATE_CAR));
            this.init();
        }

        public function clearCurrentTempList(_arg_1:int=0):void
        {
            var _local_2:Array;
            if (_arg_1 == 0)
            {
                _local_2 = ((this._sex) ? this._manTempList : this._womanTempList);
                _local_2.splice(0, _local_2.length);
            }
            else
            {
                if (_arg_1 == 1)
                {
                    this._manTempList.splice(0, this._manTempList.length);
                }
                else
                {
                    if (_arg_1 == 2)
                    {
                        this._womanTempList.splice(0, this._womanTempList.length);
                    };
                };
            };
            this.updateCost();
            dispatchEvent(new ShopEvent(ShopEvent.UPDATE_CAR));
            this.init();
        }

        public function clearLeftList():void
        {
            this.leftCarList = [];
            this.leftManList = [];
            this.leftWomanList = [];
        }

        public function get currentGift():int
        {
            var _local_1:Array = this.calcPrices(this.currentTempList);
            this._currentGift = _local_1[2];
            return (this._currentGift);
        }

        public function get currentGold():int
        {
            var _local_1:Array = this.calcPrices(this.currentTempList);
            this._currentGold = _local_1[0];
            return (this._currentGold);
        }

        public function get currentLeftList():Array
        {
            return ((this._sex) ? this.leftManList : this.leftWomanList);
        }

        public function get currentMedal():int
        {
            var _local_1:Array = this.calcPrices(this.currentTempList);
            this._currentMedal = _local_1[3];
            return (this._currentMedal);
        }

        public function get currentMemoryList():Array
        {
            return ((this.currentModel.Sex) ? this._manMemoryList : this._womanMemoryList);
        }

        public function get currentModel():PlayerInfo
        {
            return ((this._sex) ? this._manModel : this._womanModel);
        }

        public function get currentMoney():int
        {
            var _local_1:Array = this.calcPrices(this.currentTempList);
            this._currentMoney = _local_1[1];
            return (this._currentMoney);
        }

        public function get currentSkin():String
        {
            var _local_1:Array = this.currentTempList;
            var _local_2:int;
            while (_local_2 < _local_1.length)
            {
                if (_local_1[_local_2].CategoryID == EquipType.FACE)
                {
                    return (_local_1[_local_2].skin);
                };
                _local_2++;
            };
            return ("");
        }

        public function get currentTempList():Array
        {
            return ((this._sex) ? this._manTempList : this._womanTempList);
        }

        public function dispose():void
        {
            this._self.removeEventListener(PlayerPropertyEvent.PROPERTY_CHANGE, this.__styleChange);
            this._self.Bag.removeEventListener(BagEvent.UPDATE, this.__bagChange);
            this._womanModel = null;
            this._manModel = null;
            this._carList = null;
            this.leftCarList = null;
            this.leftManList = null;
            this.leftWomanList = null;
            this.maleCollocation = null;
            this.femaleCollocation = null;
        }

        public function get fittingSex():Boolean
        {
            return (this._sex);
        }

        public function set fittingSex(_arg_1:Boolean):void
        {
            var _local_2:ShopEvent;
            if (this._sex != _arg_1)
            {
                this._sex = _arg_1;
                _local_2 = new ShopEvent(ShopEvent.FITTINGMODEL_CHANGE, "sexChange");
                dispatchEvent(_local_2);
            };
        }

        public function get isSelfModel():Boolean
        {
            return (this._sex == this._self.Sex);
        }

        public function get manModelInfo():PlayerInfo
        {
            return (this._manModel);
        }

        public function removeFromShoppingCar(_arg_1:ShopCarItemInfo):void
        {
            this.removeTempEquip(_arg_1);
            var _local_2:int = this._carList.indexOf(_arg_1);
            if (_local_2 != -1)
            {
                this._carList.splice(_local_2, 1);
                this.updateCost();
                _arg_1.removeEventListener(Event.CHANGE, this.__onItemChange);
                dispatchEvent(new ShopEvent(ShopEvent.REMOVE_CAR_EQUIP, _arg_1));
            };
        }

        public function removeItem(_arg_1:ShopCarItemInfo):void
        {
            var _local_2:Array;
            var _local_3:Array;
            if (this._carList.indexOf(_arg_1) != -1)
            {
                this._carList.splice(this._carList.indexOf(_arg_1), 1);
                return;
            };
            for each (_local_2 in this._manTempList)
            {
                if (_local_2.indexOf(_arg_1) > -1)
                {
                    if (_local_2.length > 1)
                    {
                        _local_2.splice(_local_2.indexOf(_arg_1), 1);
                    }
                    else
                    {
                        this._manTempList.splice(this._manTempList.indexOf(_local_2), 1);
                    };
                };
            };
            for each (_local_3 in this._womanTempList)
            {
                if (_local_3.indexOf(_arg_1) > -1)
                {
                    if (_local_3.length > 1)
                    {
                        _local_3.splice(_local_3.indexOf(_arg_1), 1);
                    }
                    else
                    {
                        this._womanTempList.splice(this._womanTempList.indexOf(_local_3), 1);
                    };
                };
            };
        }

        public function removeTempEquip(_arg_1:ShopCarItemInfo):void
        {
            var _local_3:PlayerInfo;
            var _local_4:InventoryItemInfo;
            var _local_2:int = this._manTempList.indexOf(_arg_1);
            if (_local_2 != -1)
            {
                this._manTempList.splice(_local_2, 1);
                _local_3 = this._manModel;
            }
            else
            {
                _local_2 = this._womanTempList.indexOf(_arg_1);
                if (_local_2 != -1)
                {
                    this._womanTempList.splice(_local_2, 1);
                    _local_3 = this._womanModel;
                };
            };
            if (_local_3)
            {
                _local_4 = _local_3.Bag.items[_arg_1.place];
                if (_local_4)
                {
                    if (((((_local_4.CategoryID >= 1) && (_local_4.CategoryID <= 6)) || (_arg_1.CategoryID == EquipType.SUITS)) || (_arg_1.CategoryID == EquipType.WING)))
                    {
                        _local_3.setPartStyle(_arg_1.TemplateInfo, _arg_1.TemplateInfo.NeedSex, _local_4.TemplateID, _local_4.Color);
                    };
                    if (_arg_1.CategoryID == EquipType.FACE)
                    {
                        _local_3.Skin = this._self.Skin;
                    };
                }
                else
                {
                    if (EquipType.dressAble(_arg_1.TemplateInfo))
                    {
                        _local_3.setPartStyle(_arg_1.TemplateInfo, _arg_1.TemplateInfo.NeedSex);
                        if (_arg_1.CategoryID == EquipType.FACE)
                        {
                            _local_3.Skin = "";
                        };
                    };
                };
                dispatchEvent(new ShopEvent(ShopEvent.REMOVE_TEMP_EQUIP, _arg_1, _local_3));
            };
            this.updateCost();
            _arg_1.removeEventListener(Event.CHANGE, this.__onItemChange);
            if (this.currentTempList.length > 0)
            {
                this.setSelectedEquip(this.currentTempList[(this.currentTempList.length - 1)]);
            };
        }

        public function restoreAllItemsOnBody():void
        {
            var _local_1:Array;
            if ((((this.currentModel.Sex == this._self.Sex) && (this.currentTempList.length > 0)) || (!(this.currentModel.Bag.items == this._bodyThings))))
            {
                _local_1 = ((this._sex) ? this._manTempList : this._womanTempList);
                _local_1.splice(0, _local_1.length);
                this.init();
                dispatchEvent(new ShopEvent(ShopEvent.FITTINGMODEL_CHANGE));
                this.updateCost();
                dispatchEvent(new ShopEvent(ShopEvent.UPDATE_CAR));
            };
        }

        public function revertToDefalt():void
        {
            this.clearAllItemsOnBody();
            dispatchEvent(new ShopEvent(ShopEvent.FITTINGMODEL_CHANGE));
            this.updateCost();
            dispatchEvent(new ShopEvent(ShopEvent.UPDATE_CAR));
        }

        public function setSelectedEquip(_arg_1:ShopCarItemInfo):void
        {
            var _local_2:Array;
            if ((_arg_1 is ShopCarItemInfo))
            {
                _local_2 = this.currentTempList;
                if (_local_2.indexOf(_arg_1) > -1)
                {
                    _local_2.splice(_local_2.indexOf(_arg_1), 1);
                    _local_2.push(_arg_1);
                };
                dispatchEvent(new ShopEvent(ShopEvent.SELECTEDEQUIP_CHANGE, _arg_1));
            };
        }

        public function get totalGift():int
        {
            return (this._totalGift);
        }

        public function get totalGold():int
        {
            return (this._totalGold);
        }

        public function get totalMedal():int
        {
            return (this._totalMedal);
        }

        public function get totalMoney():int
        {
            return (this._totalMoney);
        }

        public function updateCost():void
        {
            this._totalGold = 0;
            this._totalMoney = 0;
            this._totalGift = 0;
            this._totalMedal = 0;
            var _local_1:Array = this.calcPrices(this._carList);
            this._totalGold = (this._totalGold + _local_1[0]);
            this._totalMoney = (this._totalMoney + _local_1[1]);
            this._totalGift = (this._totalGift + _local_1[2]);
            this._totalMedal = (this._totalMedal + _local_1[3]);
            _local_1 = this.calcPrices(this._womanTempList);
            this._totalGold = (this._totalGold + _local_1[0]);
            this._totalMoney = (this._totalMoney + _local_1[1]);
            this._totalGift = (this._totalGift + _local_1[2]);
            this._totalMedal = (this._totalMedal + _local_1[3]);
            _local_1 = this.calcPrices(this._manTempList);
            this._totalGold = (this._totalGold + _local_1[0]);
            this._totalMoney = (this._totalMoney + _local_1[1]);
            this._totalGift = (this._totalGift + _local_1[2]);
            this._totalMedal = (this._totalMedal + _local_1[3]);
            dispatchEvent(new ShopEvent(ShopEvent.COST_UPDATE));
        }

        public function get womanModelInfo():PlayerInfo
        {
            return (this._womanModel);
        }

        private function __bagChange(_arg_1:BagEvent):void
        {
            var _local_4:InventoryItemInfo;
            var _local_2:Boolean;
            var _local_3:Dictionary = _arg_1.changedSlots;
            for each (_local_4 in _local_3)
            {
                if (_local_4.Place <= 30)
                {
                    _local_2 = true;
                    break;
                };
            };
            if ((!(_local_2)))
            {
                return;
            };
            var _local_5:PlayerInfo = ((this._self.Sex) ? this._manModel : this._womanModel);
            if (this._self.Sex)
            {
                this._manModel.Bag.items = this._self.Bag.items;
            }
            else
            {
                this._womanModel.Bag.items = this._self.Bag.items;
            };
            dispatchEvent(new ShopEvent(ShopEvent.FITTINGMODEL_CHANGE));
        }

        private function __styleChange(_arg_1:PlayerPropertyEvent):void
        {
            if (((this.currentModel) && (_arg_1.changedProperties[PlayerInfo.STYLE])))
            {
                this._defaultModel = 1;
                if (this._self.Sex)
                {
                    this._manModel.updateStyle(this._self.Sex, this._self.Hide, this._self.getPrivateStyle(), this._self.Colors, this._self.getSkinColor());
                    this._womanModel.updateStyle(false, 2222222222, DEFAULT_WOMAN_STYLE, ",,,,,,", "");
                    this._manModel.Bag.items = this._self.Bag.items;
                }
                else
                {
                    this._manModel.updateStyle(true, 2222222222, DEFAULT_MAN_STYLE, ",,,,,,", "");
                    this._womanModel.updateStyle(this._self.Sex, this._self.Hide, this._self.getPrivateStyle(), this._self.Colors, this._self.getSkinColor());
                    this._womanModel.Bag.items = this._self.Bag.items;
                };
                dispatchEvent(new ShopEvent(ShopEvent.FITTINGMODEL_CHANGE));
            };
        }

        private function clearAllItemsOnBody():void
        {
            this.saveTriedList();
            this.currentModel.Bag.items = new DictionaryData();
            var _local_1:Array = ((this._sex) ? this._manTempList : this._womanTempList);
            _local_1.splice(0, _local_1.length);
            if (this.currentModel.Sex)
            {
                this.currentModel.updateStyle(true, 2222222222, DEFAULT_MAN_STYLE, ",,,,,,", "");
            }
            else
            {
                this.currentModel.updateStyle(false, 2222222222, DEFAULT_WOMAN_STYLE, ",,,,,,", "");
            };
        }

        private function fillToShopCarInfo(_arg_1:ShopItemInfo):ShopCarItemInfo
        {
            var _local_2:ShopCarItemInfo = new ShopCarItemInfo(_arg_1.GoodsID, _arg_1.TemplateID);
            ObjectUtils.copyProperties(_local_2, _arg_1);
            return (_local_2);
        }

        private function findEquip(_arg_1:Number, _arg_2:Array):int
        {
            var _local_3:int;
            while (_local_3 < _arg_2.length)
            {
                if (_arg_2[_local_3].TemplateID == _arg_1)
                {
                    return (_local_3);
                };
                _local_3++;
            };
            return (-1);
        }

        private function init():void
        {
            this.initBodyThing();
            if (this._self.Sex)
            {
                if (this._defaultModel == 1)
                {
                    this._manModel.updateStyle(this._self.Sex, this._self.Hide, this._self.getPrivateStyle(), this._self.Colors, this._self.getSkinColor());
                    this._manModel.Bag.items = this._bodyThings;
                }
                else
                {
                    this._manModel.updateStyle(true, 2222222222, DEFAULT_MAN_STYLE, ",,,,,,", "");
                    this._manModel.Bag.items = new DictionaryData();
                };
                this._womanModel.updateStyle(false, 2222222222, DEFAULT_WOMAN_STYLE, ",,,,,,", "");
            }
            else
            {
                this._manModel.updateStyle(true, 2222222222, DEFAULT_MAN_STYLE, ",,,,,,", "");
                if (this._defaultModel == 1)
                {
                    this._womanModel.updateStyle(this._self.Sex, this._self.Hide, this._self.getPrivateStyle(), this._self.Colors, this._self.getSkinColor());
                    this._womanModel.Bag.items = this._bodyThings;
                }
                else
                {
                    this._womanModel.updateStyle(false, 2222222222, DEFAULT_WOMAN_STYLE, ",,,,,,", "");
                    this._womanModel.Bag.items = new DictionaryData();
                };
            };
            dispatchEvent(new ShopEvent(ShopEvent.FITTINGMODEL_CHANGE));
        }

        private function initBodyThing():void
        {
            var _local_1:InventoryItemInfo;
            this._bodyThings = new DictionaryData();
            for each (_local_1 in this._self.Bag.items)
            {
                if (_local_1.Place <= 30)
                {
                    this._bodyThings.add(_local_1.Place, _local_1);
                };
            };
        }

        private function saveTriedList():void
        {
            if (this.currentModel.Sex)
            {
                this._manMemoryList = this.currentTempList.concat();
            }
            else
            {
                this._womanMemoryList = this.currentTempList.concat();
            };
        }

        public function getBagItems(_arg_1:int, _arg_2:Boolean=false):int
        {
            var _local_3:Array = [2, 4, 0, 5, 8, 3, 1, 7];
            if ((!(_arg_2)))
            {
                return ((!(_local_3[_arg_1] == null)) ? _local_3[_arg_1] : -1);
            };
            return (_local_3.indexOf(_arg_1));
        }


    }
}//package shop

