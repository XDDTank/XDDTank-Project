// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//ddt.data.analyze.ShopItemDisCountAnalyzer

package ddt.data.analyze
{
    import com.pickgliss.loader.DataAnalyzer;
    import flash.utils.Dictionary;
    import flash.utils.Timer;
    import flash.events.TimerEvent;
    import ddt.data.goods.ShopItemInfo;
    import ddt.manager.ShopManager;
    import com.pickgliss.utils.ObjectUtils;
    import road7th.data.DictionaryData;

    public class ShopItemDisCountAnalyzer extends DataAnalyzer 
    {

        private var _xml:XML;
        private var _shoplist:XMLList;
        public var shopDisCountGoods:Dictionary;
        private var index:int = -1;
        private var _timer:Timer;

        public function ShopItemDisCountAnalyzer(_arg_1:Function)
        {
            super(_arg_1);
            this.shopDisCountGoods = new Dictionary();
        }

        override public function analyze(_arg_1:*):void
        {
            this._xml = new XML(_arg_1);
            if (this._xml.@value == "true")
            {
                this._shoplist = this._xml..Item;
                this.parseShop();
            }
            else
            {
                message = this._xml.@message;
                onAnalyzeError();
            };
        }

        private function parseShop():void
        {
            this._timer = new Timer(30);
            this._timer.addEventListener(TimerEvent.TIMER, this.__partexceute);
            this._timer.start();
        }

        private function __partexceute(_arg_1:TimerEvent):void
        {
            var _local_3:ShopItemInfo;
            if ((!(ShopManager.Instance.initialized)))
            {
                return;
            };
            var _local_2:int;
            while (_local_2 < 40)
            {
                this.index++;
                if (this.index < this._shoplist.length())
                {
                    _local_3 = new ShopItemInfo(int(this._shoplist[this.index].@ID), int(this._shoplist[this.index].@TemplateID));
                    ObjectUtils.copyPorpertiesByXML(_local_3, this._shoplist[this.index]);
                    _local_3.Label = int(this._shoplist[this.index].@LableType);
                    _local_3.AUnit = int(this._shoplist[this.index].@AUnit);
                    _local_3.APrice1 = int(this._shoplist[this.index].@APrice);
                    _local_3.AValue1 = int(this._shoplist[this.index].@AValue);
                    _local_3.BUnit = int(this._shoplist[this.index].@BUnit);
                    _local_3.BPrice1 = int(this._shoplist[this.index].@BPrice);
                    _local_3.BValue1 = int(this._shoplist[this.index].@BValue);
                    _local_3.CUnit = int(this._shoplist[this.index].@CUnit);
                    _local_3.CPrice1 = int(this._shoplist[this.index].@CPrice);
                    _local_3.CValue1 = int(this._shoplist[this.index].@CValue);
                    _local_3.isDiscount = 2;
                    _local_3.APrice2 = (_local_3.APrice3 = _local_3.APrice1);
                    _local_3.BPrice2 = (_local_3.BPrice3 = _local_3.BPrice1);
                    _local_3.CPrice2 = (_local_3.CPrice3 = _local_3.CPrice1);
                    this.addList(Math.abs(_local_3.APrice1), _local_3);
                }
                else
                {
                    this._timer.removeEventListener(TimerEvent.TIMER, this.__partexceute);
                    this._timer.stop();
                    this._timer = null;
                    onAnalyzeComplete();
                    return;
                };
                _local_2++;
            };
        }

        private function converMoneyType(_arg_1:ShopItemInfo):void
        {
            switch (Math.abs(_arg_1.APrice1))
            {
                case 3:
                    _arg_1.APrice1 = -1;
                    break;
                case 4:
                    _arg_1.APrice1 = -2;
                    break;
            };
            switch (Math.abs(_arg_1.BPrice1))
            {
                case 3:
                    _arg_1.BPrice1 = -1;
                    break;
                case 4:
                    _arg_1.BPrice1 = -2;
                    break;
                default:
                    _arg_1.BPrice1 = _arg_1.APrice1;
            };
            switch (Math.abs(_arg_1.CPrice1))
            {
                case 3:
                    _arg_1.CPrice1 = -1;
                    break;
                case 4:
                    _arg_1.CPrice1 = -2;
                    break;
                default:
                    _arg_1.CPrice1 = _arg_1.APrice1;
            };
            _arg_1.APrice2 = (_arg_1.APrice3 = _arg_1.APrice1);
            _arg_1.BPrice2 = (_arg_1.BPrice3 = _arg_1.BPrice1);
            _arg_1.CPrice2 = (_arg_1.CPrice3 = _arg_1.CPrice1);
        }

        private function addList(_arg_1:int, _arg_2:ShopItemInfo):void
        {
            var _local_3:DictionaryData = this.shopDisCountGoods[_arg_1];
            if ((!(_local_3)))
            {
                _local_3 = new DictionaryData();
                this.shopDisCountGoods[_arg_1] = _local_3;
            };
            _local_3.add(_arg_2.GoodsID, _arg_2);
        }


    }
}//package ddt.data.analyze

