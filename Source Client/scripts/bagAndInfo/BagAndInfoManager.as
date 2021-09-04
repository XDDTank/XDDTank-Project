package bagAndInfo
{
   import bagAndInfo.bag.BagEquipListView;
   import com.pickgliss.events.UIModuleEvent;
   import com.pickgliss.loader.UIModuleLoader;
   import com.pickgliss.ui.ComponentFactory;
   import ddt.data.BagInfo;
   import ddt.data.UIModuleTypes;
   import ddt.manager.PlayerManager;
   import ddt.view.UIModuleSmallLoading;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.utils.getTimer;
   
   public class BagAndInfoManager extends EventDispatcher
   {
      
      public static var _firstShowBag:Boolean = true;
      
      private static var _instance:BagAndInfoManager;
       
      
      private var _bagAndGiftFrame:BagAndGiftFrame;
      
      private var _type:int = 0;
      
      private var _bagInfo:BagInfo;
      
      private var _isClose:Boolean = true;
      
      private var _bagListView:BagEquipListView;
      
      private var _bagListViewTwo:BagEquipListView;
      
      private var _bagListViewThree:BagEquipListView;
      
      public function BagAndInfoManager(param1:SingletonForce)
      {
         super();
      }
      
      public static function get Instance() : BagAndInfoManager
      {
         if(_instance == null)
         {
            _instance = new BagAndInfoManager(new SingletonForce());
         }
         return _instance;
      }
      
      public function get isShown() : Boolean
      {
         if(!this._bagAndGiftFrame)
         {
            return false;
         }
         return true;
      }
      
      public function setup() : void
      {
         this._bagListView = new BagEquipListView(0);
         this._bagListViewTwo = new BagEquipListView(0,79,127);
         this._bagListViewThree = new BagEquipListView(0,127,175);
      }
      
      private function __createBag(param1:UIModuleEvent) : void
      {
         if(param1.module == UIModuleTypes.NEWBAGANDINFO)
         {
            UIModuleSmallLoading.Instance.hide();
            UIModuleSmallLoading.Instance.removeEventListener(Event.CLOSE,this.__onSmallLoadingClose);
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.__createBag);
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.__onUIProgress);
            _firstShowBag = false;
            this.showBagAndInfo(this._type);
         }
      }
      
      public function set bagInfo(param1:BagInfo) : void
      {
         this._bagInfo = param1;
      }
      
      public function get bagInfo() : BagInfo
      {
         return this._bagInfo;
      }
      
      public function showBagAndInfo(param1:int = 0, param2:String = "") : void
      {
         var _loc3_:uint = getTimer();
         this._type = param1;
         if(this._bagAndGiftFrame == null)
         {
            if(_firstShowBag)
            {
               UIModuleSmallLoading.Instance.progress = 0;
               UIModuleSmallLoading.Instance.show();
               UIModuleSmallLoading.Instance.addEventListener(Event.CLOSE,this.__onSmallLoadingClose);
               UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.__createBag);
               UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.__onUIProgress);
               UIModuleLoader.Instance.addUIModuleImp(UIModuleTypes.NEWBAGANDINFO);
            }
            else
            {
               this.bagInfo = PlayerManager.Instance.Self.Bag;
               this._bagAndGiftFrame = ComponentFactory.Instance.creatComponentByStylename("bagAndGiftFrame");
               this._bagAndGiftFrame.show(param1,param2);
               dispatchEvent(new Event(Event.OPEN));
               this.IsClose = false;
            }
         }
         else
         {
            this._bagAndGiftFrame.show(param1);
            dispatchEvent(new Event(Event.OPEN));
            this.IsClose = false;
         }
      }
      
      private function __onUIProgress(param1:UIModuleEvent) : void
      {
         if(param1.module == UIModuleTypes.NEWBAGANDINFO)
         {
            UIModuleSmallLoading.Instance.progress = param1.loader.progress * 100;
         }
      }
      
      private function __onSmallLoadingClose(param1:Event) : void
      {
         UIModuleSmallLoading.Instance.hide();
         UIModuleSmallLoading.Instance.removeEventListener(Event.CLOSE,this.__onSmallLoadingClose);
         UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.__createBag);
         UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.__onUIProgress);
      }
      
      public function hideBagAndInfo() : void
      {
         if(this._bagAndGiftFrame)
         {
            this._bagAndGiftFrame.dispose();
            this._bagAndGiftFrame = null;
            dispatchEvent(new Event(Event.CLOSE));
         }
      }
      
      public function clearReference() : void
      {
         this._bagAndGiftFrame = null;
         dispatchEvent(new Event(Event.CLOSE));
      }
      
      public function set IsClose(param1:Boolean) : void
      {
         this._isClose = param1;
      }
      
      public function get IsClose() : Boolean
      {
         return this._isClose;
      }
      
      public function get bagListView() : BagEquipListView
      {
         return this._bagListView;
      }
      
      public function get bagListViewTwo() : BagEquipListView
      {
         return this._bagListViewTwo;
      }
      
      public function get bagListViewThree() : BagEquipListView
      {
         return this._bagListViewThree;
      }
   }
}

class SingletonForce
{
    
   
   function SingletonForce()
   {
      super();
   }
}
