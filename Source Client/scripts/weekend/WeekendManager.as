package weekend
{
   import com.pickgliss.events.UIModuleEvent;
   import com.pickgliss.loader.UIModuleLoader;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.UIModuleTypes;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.manager.PlayerManager;
   import ddt.manager.ServerConfigManager;
   import ddt.manager.SocketManager;
   import ddt.view.UIModuleSmallLoading;
   import flash.events.Event;
   import road7th.comm.PackageIn;
   
   public class WeekendManager
   {
      
      private static var _instance:WeekendManager;
       
      
      private var _frame:WeekendFrame;
      
      private var _loadComplete:Boolean;
      
      public function WeekendManager()
      {
         super();
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.ENERGY_RETURN,this.__returnEnergy);
      }
      
      public static function get instance() : WeekendManager
      {
         if(!_instance)
         {
            _instance = new WeekendManager();
         }
         return _instance;
      }
      
      public function setup() : void
      {
      }
      
      public function getNormalEnergy() : int
      {
         var _loc1_:Number = PlayerManager.Instance.Self.returnEnergy * this.getNormalPercent();
         _loc1_ = Math.max(_loc1_,1);
         return int(_loc1_);
      }
      
      public function getMoneyEnergy() : int
      {
         var _loc1_:Number = PlayerManager.Instance.Self.returnEnergy * this.getNormalPercent() * this.getMoneyPercent();
         _loc1_ = Math.max(_loc1_,1);
         return int(_loc1_);
      }
      
      public function getNormalPercent() : Number
      {
         var _loc1_:String = ServerConfigManager.instance.getReturnEnergyInfo();
         var _loc2_:Array = _loc1_.split("|");
         return Number(_loc2_[0]) / 100;
      }
      
      public function getMoneyPercent() : Number
      {
         var _loc1_:String = ServerConfigManager.instance.getReturnEnergyInfo();
         var _loc2_:Array = _loc1_.split("|");
         return Number(_loc2_[1]) / 100;
      }
      
      public function getNeedMoney() : Number
      {
         var _loc1_:String = ServerConfigManager.instance.getReturnEnergyInfo();
         var _loc2_:Array = _loc1_.split("|");
         return Number(_loc2_[2]) / 100;
      }
      
      public function sendSocket(param1:Boolean) : void
      {
         SocketManager.Instance.out.sendReturnEnergyRequest(param1);
      }
      
      public function show() : void
      {
         if(this._loadComplete)
         {
            this.initFrame();
         }
         else
         {
            this.load();
         }
      }
      
      public function hide() : void
      {
         ObjectUtils.disposeObject(this._frame);
         this._frame;
      }
      
      private function __returnEnergy(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:PackageIn = param1.pkg;
         PlayerManager.Instance.Self.returnEnergy = _loc2_.readInt();
      }
      
      private function load() : void
      {
         UIModuleSmallLoading.Instance.progress = 0;
         UIModuleSmallLoading.Instance.show();
         UIModuleSmallLoading.Instance.addEventListener(Event.CLOSE,this.__onClose);
         UIModuleLoader.Instance.addUIModuleImp(UIModuleTypes.WEEKEND);
         UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.__loadComplete);
         UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.__activeProgress);
      }
      
      private function __loadComplete(param1:UIModuleEvent) : void
      {
         UIModuleSmallLoading.Instance.hide();
         UIModuleSmallLoading.Instance.removeEventListener(Event.CLOSE,this.__onClose);
         UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.__loadComplete);
         UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.__activeProgress);
         this._loadComplete = true;
         this.initFrame();
      }
      
      private function __onClose(param1:Event) : void
      {
         UIModuleSmallLoading.Instance.hide();
         UIModuleSmallLoading.Instance.removeEventListener(Event.CLOSE,this.__onClose);
         UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.__loadComplete);
         UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.__activeProgress);
      }
      
      private function __activeProgress(param1:UIModuleEvent) : void
      {
         UIModuleSmallLoading.Instance.progress = param1.loader.progress * 100;
      }
      
      private function initFrame() : void
      {
         this._frame = ComponentFactory.Instance.creatCustomObject("weekend.WeekendFrame");
         LayerManager.Instance.addToLayer(this._frame,LayerManager.GAME_TOP_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
      }
   }
}
