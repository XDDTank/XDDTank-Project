// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//consortion.ConosrtionTimerManager

package consortion
{
    import flash.events.EventDispatcher;
    import __AS3__.vec.Vector;
    import ddt.data.goods.ShopItemInfo;
    import flash.utils.Timer;
    import flash.events.TimerEvent;
    import ddt.manager.SocketManager;
    import ddt.events.CrazyTankSocketEvent;
    import ddt.manager.ShopManager;
    import consortion.event.ConsortionEvent;
    import __AS3__.vec.*;

    [Event(name="change", type="flash.events.Event")]
    public class ConosrtionTimerManager extends EventDispatcher 
    {

        public static const TIMER_COUNT:int = 3600;
        private static var _instance:ConosrtionTimerManager;

        private var _nextRefreshTimer:uint;
        private var _ConsotionShopGoods:Vector.<ShopItemInfo>;
        private var _count:int;
        private var _timer:Timer;


        public static function get Instance():ConosrtionTimerManager
        {
            if (_instance == null)
            {
                _instance = new (ConosrtionTimerManager)();
            };
            return (_instance);
        }


        public function setup():void
        {
            this.initEvent();
        }

        public function startimer(_arg_1:int):void
        {
            this.count = _arg_1;
            this._timer = new Timer(1000, this.count);
            this._timer.addEventListener(TimerEvent.TIMER, this.__timer);
            this._timer.addEventListener(TimerEvent.TIMER_COMPLETE, this.__completeHandler);
            this._timer.start();
        }

        private function __timer(_arg_1:TimerEvent):void
        {
            this._count = (this._count - 1);
        }

        private function __completeHandler(_arg_1:TimerEvent):void
        {
            this._timer.removeEventListener(TimerEvent.TIMER, this.__timer);
            this._timer.removeEventListener(TimerEvent.TIMER_COMPLETE, this.__completeHandler);
            this._timer.stop();
            this._timer = null;
            this._count = 0;
        }

        private function initEvent():void
        {
            SocketManager.Instance.addEventListener(CrazyTankSocketEvent.SHOP_REFRESH_GOOD, this.__refresh);
        }

        public function set count(_arg_1:int):void
        {
            this._count = _arg_1;
        }

        public function get count():int
        {
            return (this._count);
        }

        private function __refresh(_arg_1:CrazyTankSocketEvent):void
        {
            var _local_9:int;
            var _local_10:ShopItemInfo;
            var _local_11:int;
            this._ConsotionShopGoods = new Vector.<ShopItemInfo>();
            var _local_2:String = _arg_1.pkg.readUTF();
            var _local_3:Date = _arg_1.pkg.readDate();
            var _local_4:Array = _local_2.split("&");
            var _local_5:String = _local_4[0];
            var _local_6:Array = _local_5.split(",");
            var _local_7:String = _local_4[1];
            var _local_8:Array = _local_7.split(",");
            while (_local_9 < _local_6.length)
            {
                _local_10 = ShopManager.Instance.getShopItemByGoodsID(_local_6[_local_9]);
                if (_local_8)
                {
                    _local_11 = 0;
                    while (_local_11 < _local_8.length)
                    {
                        if (_local_8.length == 0)
                        {
                            _local_10.isBuy = false;
                            return;
                        };
                        if (int(_local_6[_local_9]) == int(_local_8[_local_11]))
                        {
                            _local_10.isBuy = true;
                        };
                        _local_11++;
                    };
                };
                this.ConsotionShopGoods.push(_local_10);
                _local_9++;
            };
            this.NextTimer = _local_3.getTime();
            ConsortionModelControl.Instance.dispatchEvent(new ConsortionEvent(ConsortionEvent.REFRESH_GOOD));
        }

        public function set NextTimer(_arg_1:uint):void
        {
            this._nextRefreshTimer = _arg_1;
        }

        public function get NextTimer():uint
        {
            return (this._nextRefreshTimer);
        }

        public function set ConsotionShopGoods(_arg_1:Vector.<ShopItemInfo>):void
        {
            this._ConsotionShopGoods = _arg_1;
        }

        public function get ConsotionShopGoods():Vector.<ShopItemInfo>
        {
            return (this._ConsotionShopGoods);
        }


    }
}//package consortion

