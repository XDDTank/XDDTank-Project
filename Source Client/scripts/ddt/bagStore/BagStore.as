package ddt.bagStore
{
   import bagAndInfo.BagAndInfoManager;
   import com.pickgliss.events.UIModuleEvent;
   import com.pickgliss.loader.UIModuleLoader;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.UIModuleTypes;
   import ddt.view.UIModuleSmallLoading;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import store.StoreController;
   import store.StoreMainView;
   
   public class BagStore extends EventDispatcher
   {
      
      public static var OPEN_BAGSTORE:String = "openBagStore";
      
      public static var CLOSE_BAGSTORE:String = "closeBagStore";
      
      public static const GENERAL:String = "general";
      
      public static const CONSORTIA:String = "consortia";
      
      public static const BAG_STORE:String = "bag_store";
      
      private static var _instance:BagStore;
       
      
      private var _tipPanelNumber:int = 0;
      
      private var _passwordOpen:Boolean = true;
      
      private var _controllerInstance:StoreController;
      
      private var _storeOpenAble:Boolean = false;
      
      private var _isFromBagFrame:Boolean = false;
      
      private var _isFromShop:Boolean = false;
      
      public function BagStore(param1:IEventDispatcher = null)
      {
         super();
         this._controllerInstance = StoreController.instance;
      }
      
      public static function get instance() : BagStore
      {
         if(_instance == null)
         {
            _instance = new BagStore();
         }
         return _instance;
      }
      
      public function show(param1:int = 0) : void
      {
         var type:int = param1;
         try
         {
            this.createStoreFrame(type);
         }
         catch(e:Error)
         {
            UIModuleSmallLoading.Instance.progress = 0;
            UIModuleSmallLoading.Instance.show();
            UIModuleSmallLoading.Instance.addEventListener(Event.CLOSE,__onClose);
            UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_COMPLETE,_UIComplete);
            UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_PROGRESS,__progressShow);
            UIModuleLoader.Instance.addUIModuleImp(UIModuleTypes.DDTSTORE);
         }
      }
      
      private function __onClose(param1:Event) : void
      {
         UIModuleSmallLoading.Instance.hide();
         UIModuleSmallLoading.Instance.removeEventListener(Event.CLOSE,this.__onClose);
         UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this._UIComplete);
         UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.__progressShow);
      }
      
      private function createStoreFrame(param1:int) : void
      {
         var _loc2_:BagStoreFrame = ComponentFactory.Instance.creatComponentByStylename("ddtstore.BagStoreFrame");
         this._controllerInstance.Model.loadBagData();
         _loc2_.controller = this._controllerInstance;
         _loc2_.show(param1);
         this.storeOpenAble = true;
         dispatchEvent(new Event(OPEN_BAGSTORE));
      }
      
      private function __progressShow(param1:UIModuleEvent) : void
      {
         if(param1.module == UIModuleTypes.DDTSTORE)
         {
            UIModuleSmallLoading.Instance.progress = param1.loader.progress * 100;
         }
      }
      
      private function _UIComplete(param1:UIModuleEvent) : void
      {
         if(param1.module == UIModuleTypes.DDTSTORE)
         {
            UIModuleSmallLoading.Instance.hide();
            UIModuleSmallLoading.Instance.removeEventListener(Event.CLOSE,this.__onClose);
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this._UIComplete);
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.__progressShow);
            this.createStoreFrame(StoreMainView.STRENGTH);
         }
      }
      
      public function closed() : void
      {
         if(this._isFromBagFrame)
         {
            BagAndInfoManager.Instance.showBagAndInfo();
            dispatchEvent(new Event(CLOSE_BAGSTORE));
            this._isFromBagFrame = false;
         }
      }
      
      public function get tipPanelNumber() : int
      {
         return this._tipPanelNumber;
      }
      
      public function set tipPanelNumber(param1:int) : void
      {
         this._tipPanelNumber = param1;
      }
      
      public function reduceTipPanelNumber() : void
      {
         --this._tipPanelNumber;
      }
      
      public function get passwordOpen() : Boolean
      {
         return this._passwordOpen;
      }
      
      public function set passwordOpen(param1:Boolean) : void
      {
         this._passwordOpen = param1;
      }
      
      public function set storeOpenAble(param1:Boolean) : void
      {
         this._storeOpenAble = param1;
      }
      
      public function get storeOpenAble() : Boolean
      {
         return this._storeOpenAble;
      }
      
      public function set isFromBagFrame(param1:Boolean) : void
      {
         this._isFromBagFrame = param1;
         if(this._isFromBagFrame)
         {
            BagAndInfoManager.Instance.hideBagAndInfo();
         }
      }
      
      public function get isFromBagFrame() : Boolean
      {
         return this._isFromBagFrame;
      }
      
      public function set isFromShop(param1:Boolean) : void
      {
         this._isFromShop = param1;
      }
      
      public function get isFromShop() : Boolean
      {
         return this._isFromShop;
      }
      
      public function get controllerInstance() : StoreController
      {
         return this._controllerInstance;
      }
      
      public function dispose() : void
      {
         if(this._controllerInstance)
         {
            ObjectUtils.disposeObject(this._controllerInstance);
         }
         this._controllerInstance = null;
      }
   }
}
