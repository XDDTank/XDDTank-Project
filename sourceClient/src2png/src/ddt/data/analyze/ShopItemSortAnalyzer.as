// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//ddt.data.analyze.ShopItemSortAnalyzer

package ddt.data.analyze
{
    import com.pickgliss.loader.DataAnalyzer;
    import flash.utils.Dictionary;
    import flash.utils.Timer;
    import flash.events.TimerEvent;
    import ddt.data.goods.ShopItemInfo;
    import com.pickgliss.ui.controls.alert.BaseAlerFrame;
    import ddt.manager.ShopManager;
    import com.pickgliss.ui.AlertManager;
    import ddt.manager.LanguageMgr;
    import com.pickgliss.events.FrameEvent;
    import __AS3__.vec.Vector;
    import __AS3__.vec.*;

    public class ShopItemSortAnalyzer extends DataAnalyzer 
    {

        private var _xml:XML;
        private var _shoplist:XMLList;
        public var shopSortedGoods:Dictionary;
        private var index:int = -1;
        private var _timer:Timer;

        public function ShopItemSortAnalyzer(_arg_1:Function)
        {
            super(_arg_1);
            this.shopSortedGoods = new Dictionary();
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
            var _local_3:int;
            var _local_4:int;
            var _local_5:ShopItemInfo;
            var _local_6:BaseAlerFrame;
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
                    _local_3 = int(this._shoplist[this.index].@Type);
                    _local_4 = int(this._shoplist[this.index].@ShopId);
                    _local_5 = ShopManager.Instance.getShopItemByGoodsID(_local_4);
                    if (_local_5 != null)
                    {
                        this.addToList(_local_3, _local_5);
                    }
                    else
                    {
                        _local_6 = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"), (LanguageMgr.GetTranslation("shop.DataError.NoGood") + _local_4));
                        _local_6.addEventListener(FrameEvent.RESPONSE, this.__onResponse);
                    };
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

        private function __onResponse(_arg_1:FrameEvent):void
        {
            var _local_2:BaseAlerFrame = BaseAlerFrame(_arg_1.target);
            _local_2.removeEventListener(FrameEvent.RESPONSE, this.__onResponse);
            _local_2.dispose();
        }

        private function addToList(_arg_1:int, _arg_2:ShopItemInfo):void
        {
            var _local_3:Vector.<ShopItemInfo> = this.shopSortedGoods[_arg_1];
            if (_local_3 == null)
            {
                _local_3 = new Vector.<ShopItemInfo>();
                this.shopSortedGoods[_arg_1] = _local_3;
            };
            _local_3.push(_arg_2);
        }


    }
}//package ddt.data.analyze

