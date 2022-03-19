// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//ddt.manager.ShopManager

package ddt.manager
{
    import flash.events.EventDispatcher;
    import road7th.data.DictionaryData;
    import flash.utils.Dictionary;
    import ddt.events.CrazyTankSocketEvent;
    import ddt.data.analyze.ShopItemAnalyzer;
    import ddt.data.analyze.ShopItemSortAnalyzer;
    import __AS3__.vec.Vector;
    import ddt.data.goods.ShopItemInfo;
    import ddt.data.goods.ShopCarItemInfo;
    import ddt.data.player.SelfInfo;
    import ddt.data.goods.ItemPrice;
    import road7th.comm.PackageIn;
    import ddt.states.StateType;
    import ddt.data.ShopType;
    import ddt.data.EquipType;
    import __AS3__.vec.*;

    public class ShopManager extends EventDispatcher 
    {

        private static var _instance:ShopManager;

        public var initialized:Boolean = false;
        private var _shopGoods:DictionaryData;
        private var _shopSortList:Dictionary;
        private var _shopRealTimesDisCountGoods:Dictionary;

        public function ShopManager(_arg_1:SingletonEnfocer)
        {
        }

        public static function get Instance():ShopManager
        {
            if (_instance == null)
            {
                _instance = new ShopManager(new SingletonEnfocer());
            };
            return (_instance);
        }


        public function setup(_arg_1:ShopItemAnalyzer):void
        {
            this._shopGoods = _arg_1.shopinfolist;
            this.initialized = true;
            SocketManager.Instance.addEventListener(CrazyTankSocketEvent.GOODS_COUNT, this.__updateGoodsCount);
        }

        public function updateShopGoods(_arg_1:ShopItemAnalyzer):void
        {
            this._shopGoods = _arg_1.shopinfolist;
        }

        public function sortShopItems(_arg_1:ShopItemSortAnalyzer):void
        {
            this._shopSortList = _arg_1.shopSortedGoods;
        }

        public function getResultPages(_arg_1:int, _arg_2:int=12):int
        {
            var _local_3:Vector.<ShopItemInfo> = this.getValidGoodByType(_arg_1);
            return (int(Math.ceil((_local_3.length / _arg_2))));
        }

        public function getConsortionResultPages(_arg_1:int, _arg_2:int=12):int
        {
            var _local_3:Vector.<ShopItemInfo> = this.consortiaShopIdTemplates(_arg_1);
            return (int(Math.ceil((_local_3.length / _arg_2))));
        }

        public function buyIt(_arg_1:Array):Array
        {
            var _local_7:ShopCarItemInfo;
            var _local_2:SelfInfo = PlayerManager.Instance.Self;
            var _local_3:Array = [];
            var _local_4:int = _local_2.Gold;
            var _local_5:int = _local_2.Money;
            var _local_6:int = _local_2.totalMoney;
            for each (_local_7 in _arg_1)
            {
                if (((_local_4 >= _local_7.getItemPrice(_local_7.currentBuyType).goldValue) && (_local_6 >= _local_7.getItemPrice(_local_7.currentBuyType).moneyValue)))
                {
                    _local_4 = (_local_4 - _local_7.getItemPrice(_local_7.currentBuyType).goldValue);
                };
            };
            return (_local_3);
        }

        public function giveGift(_arg_1:Array, _arg_2:SelfInfo):Array
        {
            var _local_5:ItemPrice;
            var _local_6:ShopCarItemInfo;
            var _local_7:int;
            var _local_3:Array = [];
            var _local_4:int = _arg_2.Money;
            for each (_local_6 in _arg_1)
            {
                _local_5 = _local_6.getItemPrice(_local_6.currentBuyType);
                _local_7 = (_local_5.moneyValue - PlayerManager.Instance.Self.DDTMoney);
                if (((_local_4 >= _local_7) && (_local_5.goldValue == 0)))
                {
                    _local_3.push(_local_6);
                };
            };
            return (_local_3);
        }

        private function __updateGoodsCount(_arg_1:CrazyTankSocketEvent):void
        {
            var _local_10:int;
            var _local_11:int;
            var _local_12:ShopItemInfo;
            var _local_13:int;
            var _local_14:int;
            var _local_15:ShopItemInfo;
            var _local_2:PackageIn = _arg_1.pkg;
            var _local_3:int = ((StateManager.currentStateType == StateType.CONSORTIA) ? 2 : 1);
            var _local_4:int = _local_2.readInt();
            var _local_5:int;
            while (_local_5 < _local_4)
            {
                _local_10 = _local_2.readInt();
                _local_11 = _local_2.readInt();
                _local_12 = this.getShopItemByGoodsID(_local_10);
                if (((_local_12) && (_local_3 == 1)))
                {
                    _local_12.LimitCount = _local_11;
                };
                _local_5++;
            };
            var _local_6:int = _local_2.readInt();
            var _local_7:int = _local_2.readInt();
            var _local_8:int;
            while (_local_8 < _local_7)
            {
                _local_13 = _local_2.readInt();
                _local_14 = _local_2.readInt();
                _local_15 = this.getShopItemByGoodsID(_local_13);
                if ((((_local_15) && (_local_3 == 2)) && (_local_6 == PlayerManager.Instance.Self.ConsortiaID)))
                {
                    _local_15.LimitCount = _local_14;
                };
                _local_8++;
            };
            var _local_9:int = _local_2.readInt();
        }

        public function getShopItemByGoodsID(_arg_1:int):ShopItemInfo
        {
            var _local_3:DictionaryData;
            var _local_4:ShopItemInfo;
            var _local_2:ShopItemInfo = this._shopGoods[_arg_1];
            if (_local_2 != null)
            {
                return (_local_2);
            };
            for each (_local_3 in this._shopRealTimesDisCountGoods)
            {
                _local_4 = _local_3[_arg_1];
                if (((!(_local_4 == null)) && (_local_4.isValid)))
                {
                    return (_local_4);
                };
            };
            return (null);
        }

        public function getValidSortedGoodsByType(_arg_1:int, _arg_2:int, _arg_3:int=12):Vector.<ShopItemInfo>
        {
            var _local_7:int;
            var _local_8:int;
            var _local_9:int;
            var _local_4:Vector.<ShopItemInfo> = new Vector.<ShopItemInfo>();
            var _local_5:Vector.<ShopItemInfo> = this.getValidGoodByType(_arg_1);
            var _local_6:int = int(Math.ceil((_local_5.length / _arg_3)));
            if (((_arg_2 > 0) && (_arg_2 <= _local_6)))
            {
                _local_7 = (0 + (_arg_3 * (_arg_2 - 1)));
                _local_8 = Math.min((_local_5.length - _local_7), _arg_3);
                _local_9 = 0;
                while (_local_9 < _local_8)
                {
                    _local_4.push(_local_5[(_local_7 + _local_9)]);
                    _local_9++;
                };
            };
            return (_local_4);
        }

        public function getConsortionSortedGoodsByType(_arg_1:int, _arg_2:int, _arg_3:int=12):Vector.<ShopItemInfo>
        {
            var _local_7:int;
            var _local_8:int;
            var _local_9:int;
            var _local_4:Vector.<ShopItemInfo> = new Vector.<ShopItemInfo>();
            var _local_5:Vector.<ShopItemInfo> = this.consortiaShopIdTemplates(_arg_1);
            var _local_6:int = int(Math.ceil((_local_5.length / _arg_3)));
            if (((_arg_2 > 0) && (_arg_2 <= _local_6)))
            {
                _local_7 = (0 + (_arg_3 * (_arg_2 - 1)));
                _local_8 = Math.min((_local_5.length - _local_7), _arg_3);
                _local_9 = 0;
                while (_local_9 < _local_8)
                {
                    _local_4.push(_local_5[(_local_7 + _local_9)]);
                    _local_9++;
                };
            };
            return (_local_4);
        }

        public function getGoodsByType(_arg_1:int):Vector.<ShopItemInfo>
        {
            return (this._shopSortList[_arg_1] as Vector.<ShopItemInfo>);
        }

        public function getValidGoodByType(_arg_1:int):Vector.<ShopItemInfo>
        {
            var _local_4:ShopItemInfo;
            var _local_2:Vector.<ShopItemInfo> = new Vector.<ShopItemInfo>();
            var _local_3:Vector.<ShopItemInfo> = this._shopSortList[_arg_1];
            for each (_local_4 in _local_3)
            {
                if (_local_4.isValid)
                {
                    _local_2.push(_local_4);
                };
            };
            return (_local_2);
        }

        public function consortiaShopIdTemplates(_arg_1:int):Vector.<ShopItemInfo>
        {
            var _local_3:ShopItemInfo;
            var _local_2:Vector.<ShopItemInfo> = new Vector.<ShopItemInfo>();
            for each (_local_3 in this._shopGoods)
            {
                if (_local_3.ShopID == _arg_1)
                {
                    _local_2.push(_local_3);
                };
            };
            return (_local_2);
        }

        public function canAddPrice(_arg_1:int):Boolean
        {
            if (((!(this.getGoodsByTemplateID(_arg_1))) || (!(this.getGoodsByTemplateID(_arg_1).IsContinue))))
            {
                return (false);
            };
            if (this.getShopRechargeItemByTemplateId(_arg_1).length <= 0)
            {
                return (false);
            };
            return (true);
        }

        public function getShopRechargeItemByTemplateId(_arg_1:int):Array
        {
            var _local_3:ShopItemInfo;
            var _local_4:ShopItemInfo;
            var _local_2:Array = [];
            for each (_local_3 in this._shopGoods)
            {
                if ((((_local_3.TemplateID == _arg_1) && (_local_3.getItemPrice(1).moneyValue > 0)) && (_local_3.IsContinue)))
                {
                    _local_2.push(_local_3);
                };
            };
            for each (_local_4 in this._shopGoods)
            {
                if (((_local_4.TemplateID == _arg_1) && (_local_4.IsContinue)))
                {
                    _local_2.push(_local_4);
                };
            };
            return (_local_2);
        }

        public function getMoneyShopItemByTemplateID(_arg_1:int, _arg_2:Boolean=false):ShopItemInfo
        {
            var _local_3:Array;
            var _local_4:int;
            var _local_5:Vector.<ShopItemInfo>;
            var _local_6:ShopItemInfo;
            var _local_7:ShopItemInfo;
            if (_arg_2)
            {
                _local_3 = this.getType(ShopType.MALE_MONEY_TYPE).concat(this.getType(ShopType.FEMALE_MONEY_TYPE));
                for each (_local_4 in _local_3)
                {
                    _local_5 = this.getValidGoodByType(_local_4);
                    for each (_local_6 in _local_5)
                    {
                        if (((_local_6.TemplateID == _arg_1) && (_local_6.getItemPrice(1).moneyValue > 0)))
                        {
                            return (_local_6);
                        };
                    };
                };
            }
            else
            {
                for each (_local_7 in this._shopGoods)
                {
                    if (((_local_7.TemplateID == _arg_1) && (_local_7.getItemPrice(1).moneyValue > 0)))
                    {
                        if (((_local_7.isValid) || (_local_7.TemplateID == EquipType.BOGU_COIN)))
                        {
                            return (_local_7);
                        };
                    };
                };
            };
            return (null);
        }

        public function getGoodsByTemplateID(_arg_1:int):ShopItemInfo
        {
            var _local_2:ShopItemInfo;
            for each (_local_2 in this._shopGoods)
            {
                if (_local_2.TemplateID == _arg_1)
                {
                    return (_local_2);
                };
            };
            return (null);
        }

        private function getType(_arg_1:*):Array
        {
            var _local_3:*;
            var _local_2:Array = [];
            if ((_arg_1 is Array))
            {
                for each (_local_3 in _arg_1)
                {
                    _local_2 = _local_2.concat(this.getType(_local_3));
                };
            }
            else
            {
                _local_2.push(_arg_1);
            };
            return (_local_2);
        }

        public function getGoldShopItemByTemplateID(_arg_1:int):ShopItemInfo
        {
            var _local_2:ShopItemInfo;
            for each (_local_2 in this._shopSortList[ShopType.ROOM_PROP])
            {
                if (_local_2.TemplateID == _arg_1)
                {
                    if (_local_2.isValid)
                    {
                        return (_local_2);
                    };
                };
            };
            return (null);
        }

        public function moneyGoods(_arg_1:Array, _arg_2:SelfInfo):Array
        {
            var _local_4:ItemPrice;
            var _local_5:ShopCarItemInfo;
            var _local_3:Array = [];
            for each (_local_5 in _arg_1)
            {
                _local_4 = _local_5.getItemPrice(_local_5.currentBuyType);
                if (_local_4.moneyValue > 0)
                {
                    _local_3.push(_local_5);
                };
            };
            return (_local_3);
        }

        public function buyLeastGood(_arg_1:Array, _arg_2:SelfInfo):Boolean
        {
            var _local_3:ShopCarItemInfo;
            for each (_local_3 in _arg_1)
            {
                if (((_arg_2.Gold >= _local_3.getItemPrice(_local_3.currentBuyType).goldValue) && (_arg_2.Money >= _local_3.getItemPrice(_local_3.currentBuyType).moneyValue)))
                {
                    return (true);
                };
            };
            return (false);
        }

        public function getDesignatedAllShopItem():Vector.<ShopItemInfo>
        {
            var _local_3:int;
            var _local_1:Vector.<ShopItemInfo> = new Vector.<ShopItemInfo>();
            var _local_2:int;
            while (_local_2 < ShopType.CAN_SHOW_IN_SHOP.length)
            {
                _local_3 = ShopType.CAN_SHOW_IN_SHOP[_local_2];
                if (this._shopSortList[_local_3])
                {
                    _local_1 = _local_1.concat(this._shopSortList[_local_3]);
                };
                _local_2++;
            };
            return (_local_1);
        }

        public function fuzzySearch(_arg_1:Vector.<ShopItemInfo>, _arg_2:String):Vector.<ShopItemInfo>
        {
            var _local_4:ShopItemInfo;
            var _local_5:int;
            var _local_6:Boolean;
            var _local_7:ShopItemInfo;
            var _local_3:Vector.<ShopItemInfo> = new Vector.<ShopItemInfo>();
            for each (_local_4 in _arg_1)
            {
                if (((_local_4.isValid) && (_local_4.TemplateInfo)))
                {
                    _local_5 = _local_4.TemplateInfo.Name.indexOf(_arg_2);
                    if (_local_5 > -1)
                    {
                        _local_6 = true;
                        for each (_local_7 in _local_3)
                        {
                            if (_local_7.GoodsID == _local_4.GoodsID)
                            {
                                _local_6 = false;
                            };
                        };
                        if (_local_6)
                        {
                            _local_3.push(_local_4);
                        };
                    };
                };
            };
            return (_local_3);
        }


    }
}//package ddt.manager

class SingletonEnfocer 
{


}


