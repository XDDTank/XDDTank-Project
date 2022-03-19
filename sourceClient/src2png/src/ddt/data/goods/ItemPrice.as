// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//ddt.data.goods.ItemPrice

package ddt.data.goods
{
    import flash.utils.Dictionary;
    import ddt.manager.ItemManager;

    public class ItemPrice 
    {

        private var _prices:Dictionary;
        private var _pricesArr:Array;

        public function ItemPrice(_arg_1:Price, _arg_2:Price, _arg_3:Price)
        {
            this._pricesArr = [];
            this._prices = new Dictionary();
            this.addPrice(_arg_1);
            this.addPrice(_arg_2);
            this.addPrice(_arg_3);
        }

        public function addPrice(_arg_1:Price):void
        {
            if (_arg_1 == null)
            {
                return;
            };
            this._pricesArr.push(_arg_1);
            if (this._prices[_arg_1.UnitToString] == null)
            {
                this._prices[_arg_1.UnitToString] = _arg_1.Value;
            }
            else
            {
                this._prices[_arg_1.UnitToString] = (this._prices[_arg_1.UnitToString] + _arg_1.Value);
            };
        }

        public function addItemPrice(_arg_1:ItemPrice):void
        {
            var _local_2:Price;
            for each (_local_2 in _arg_1.pricesArr)
            {
                this.addPrice(_local_2);
            };
        }

        public function multiply(_arg_1:int):ItemPrice
        {
            if (_arg_1 <= 0)
            {
                throw (new Error("Multiply Invalide value!"));
            };
            var _local_2:ItemPrice = this.clone();
            var _local_3:int;
            while (_local_3 < (_arg_1 - 1))
            {
                _local_2.addItemPrice(_local_2.clone());
                _local_3++;
            };
            return (_local_2);
        }

        public function clone():ItemPrice
        {
            return (new ItemPrice(this._pricesArr[0], this._pricesArr[1], this._pricesArr[2]));
        }

        public function get pricesArr():Array
        {
            return (this._pricesArr);
        }

        public function get moneyValue():int
        {
            if (this._prices[Price.MONEYTOSTRING] == null)
            {
                return (0);
            };
            return (this._prices[Price.MONEYTOSTRING]);
        }

        public function get offValue():int
        {
            if (this._prices[Price.CONSORTIONOFF] == null)
            {
                return (0);
            };
            return (this._prices[Price.CONSORTIONOFF]);
        }

        public function get ddtMoneyValue():int
        {
            if (this._prices[Price.DDTMONEYTOSTRING] == null)
            {
                return (0);
            };
            return (this._prices[Price.DDTMONEYTOSTRING]);
        }

        public function get goldValue():int
        {
            if (this._prices[Price.GOLDTOSTRING] == null)
            {
                return (0);
            };
            return (this._prices[Price.GOLDTOSTRING]);
        }

        public function get exploitValue():int
        {
            if (this._prices[Price.ARMY_EXPLOITTOSTRING] == null)
            {
                return (0);
            };
            return (this._prices[Price.ARMY_EXPLOITTOSTRING]);
        }

        public function getPrice(_arg_1:int):Price
        {
            return (this._pricesArr[_arg_1]);
        }

        public function getOtherValue(_arg_1:int):int
        {
            var _local_2:String = ItemManager.Instance.getTemplateById(_arg_1).Name;
            if (this._prices[_local_2] == null)
            {
                return (0);
            };
            return (this._prices[_local_2]);
        }

        public function get IsValid():Boolean
        {
            return (this._pricesArr.length > 0);
        }

        public function get IsMixed():Boolean
        {
            var _local_2:String;
            var _local_1:int;
            for (_local_2 in this._prices)
            {
                if (this._prices[_local_2] > 0)
                {
                    _local_1++;
                };
            };
            return (_local_1 > 1);
        }

        public function get PriceType():int
        {
            if ((!(this.IsMixed)))
            {
                if (this.moneyValue > 0)
                {
                    return (Price.MONEY);
                };
                if (this.goldValue > 0)
                {
                    return (Price.GOLD);
                };
                if (this.exploitValue > 0)
                {
                    return (Price.ARMY_EXPLOIT);
                };
                if (this.ddtMoneyValue > 0)
                {
                    return (Price.DDT_MONEY);
                };
                if (this.offValue > 0)
                {
                    return (Price.OFFER);
                };
                return (-5);
            };
            return (0);
        }

        public function get IsMoneyType():Boolean
        {
            return ((!(this.IsMixed)) && (this.moneyValue > 0));
        }

        public function get IsDDTMoneyType():Boolean
        {
            return ((!(this.IsMixed)) && (this.ddtMoneyValue > 0));
        }

        public function get IsGoldType():Boolean
        {
            return ((!(this.IsMixed)) && (this.goldValue > 0));
        }

        public function toString():String
        {
            var _local_2:String;
            var _local_1:String = "";
            if (this.moneyValue > 0)
            {
                _local_1 = (_local_1 + (this.moneyValue.toString() + Price.MONEYTOSTRING));
            };
            if (this.goldValue > 0)
            {
                _local_1 = (_local_1 + (this.goldValue.toString() + Price.GOLDTOSTRING));
            };
            if (this.ddtMoneyValue > 0)
            {
                _local_1 = (_local_1 + (this.ddtMoneyValue.toString() + Price.DDTMONEYTOSTRING));
            };
            for (_local_2 in this._prices)
            {
                if ((((!(_local_2 == Price.MONEYTOSTRING)) && (!(_local_2 == Price.GOLDTOSTRING))) && (!(_local_2 == Price.DDTMONEYTOSTRING))))
                {
                    _local_1 = (_local_1 + (this._prices[_local_2].toString() + _local_2));
                };
            };
            return (_local_1);
        }

        public function toStringI():String
        {
            var _local_2:String;
            var _local_1:String = "";
            if (this.moneyValue > 0)
            {
                _local_1 = (_local_1 + ((this.moneyValue.toString() + " ") + Price.MONEYTOSTRING));
            };
            if (this.goldValue > 0)
            {
                _local_1 = (_local_1 + ((this.goldValue.toString() + " ") + Price.GOLDTOSTRING));
            };
            for (_local_2 in this._prices)
            {
                if (((!(_local_2 == Price.MONEYTOSTRING)) && (!(_local_2 == Price.GOLDTOSTRING))))
                {
                    _local_1 = (_local_1 + (this._prices[_local_2].toString() + _local_2));
                };
            };
            return (_local_1);
        }


    }
}//package ddt.data.goods

