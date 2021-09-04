package consortion
{
   import consortion.event.ConsortionEvent;
   import ddt.data.goods.ShopItemInfo;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.manager.ShopManager;
   import ddt.manager.SocketManager;
   import flash.events.EventDispatcher;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   
   [Event(name="change",type="flash.events.Event")]
   public class ConosrtionTimerManager extends EventDispatcher
   {
      
      public static const TIMER_COUNT:int = 3600;
      
      private static var _instance:ConosrtionTimerManager;
       
      
      private var _nextRefreshTimer:uint;
      
      private var _ConsotionShopGoods:Vector.<ShopItemInfo>;
      
      private var _count:int;
      
      private var _timer:Timer;
      
      public function ConosrtionTimerManager()
      {
         super();
      }
      
      public static function get Instance() : ConosrtionTimerManager
      {
         if(_instance == null)
         {
            _instance = new ConosrtionTimerManager();
         }
         return _instance;
      }
      
      public function setup() : void
      {
         this.initEvent();
      }
      
      public function startimer(param1:int) : void
      {
         this.count = param1;
         this._timer = new Timer(1000,this.count);
         this._timer.addEventListener(TimerEvent.TIMER,this.__timer);
         this._timer.addEventListener(TimerEvent.TIMER_COMPLETE,this.__completeHandler);
         this._timer.start();
      }
      
      private function __timer(param1:TimerEvent) : void
      {
         this._count -= 1;
      }
      
      private function __completeHandler(param1:TimerEvent) : void
      {
         this._timer.removeEventListener(TimerEvent.TIMER,this.__timer);
         this._timer.removeEventListener(TimerEvent.TIMER_COMPLETE,this.__completeHandler);
         this._timer.stop();
         this._timer = null;
         this._count = 0;
      }
      
      private function initEvent() : void
      {
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.SHOP_REFRESH_GOOD,this.__refresh);
      }
      
      public function set count(param1:int) : void
      {
         this._count = param1;
      }
      
      public function get count() : int
      {
         return this._count;
      }
      
      private function __refresh(param1:CrazyTankSocketEvent) : void
      {
         var _loc9_:int = 0;
         var _loc10_:ShopItemInfo = null;
         var _loc11_:int = 0;
         this._ConsotionShopGoods = new Vector.<ShopItemInfo>();
         var _loc2_:String = param1.pkg.readUTF();
         var _loc3_:Date = param1.pkg.readDate();
         var _loc4_:Array = _loc2_.split("&");
         var _loc5_:String = _loc4_[0];
         var _loc6_:Array = _loc5_.split(",");
         var _loc7_:String = _loc4_[1];
         var _loc8_:Array = _loc7_.split(",");
         while(_loc9_ < _loc6_.length)
         {
            _loc10_ = ShopManager.Instance.getShopItemByGoodsID(_loc6_[_loc9_]);
            if(_loc8_)
            {
               _loc11_ = 0;
               while(_loc11_ < _loc8_.length)
               {
                  if(_loc8_.length == 0)
                  {
                     _loc10_.isBuy = false;
                     return;
                  }
                  if(int(_loc6_[_loc9_]) == int(_loc8_[_loc11_]))
                  {
                     _loc10_.isBuy = true;
                  }
                  _loc11_++;
               }
            }
            this.ConsotionShopGoods.push(_loc10_);
            _loc9_++;
         }
         this.NextTimer = _loc3_.getTime();
         ConsortionModelControl.Instance.dispatchEvent(new ConsortionEvent(ConsortionEvent.REFRESH_GOOD));
      }
      
      public function set NextTimer(param1:uint) : void
      {
         this._nextRefreshTimer = param1;
      }
      
      public function get NextTimer() : uint
      {
         return this._nextRefreshTimer;
      }
      
      public function set ConsotionShopGoods(param1:Vector.<ShopItemInfo>) : void
      {
         this._ConsotionShopGoods = param1;
      }
      
      public function get ConsotionShopGoods() : Vector.<ShopItemInfo>
      {
         return this._ConsotionShopGoods;
      }
   }
}
