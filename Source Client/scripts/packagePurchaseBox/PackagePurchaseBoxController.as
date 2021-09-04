package packagePurchaseBox
{
   import com.pickgliss.events.UIModuleEvent;
   import com.pickgliss.loader.UIModuleLoader;
   import com.pickgliss.ui.ComponentFactory;
   import ddt.data.UIModuleTypes;
   import ddt.data.goods.ShopItemInfo;
   import ddt.view.UIModuleSmallLoading;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import packagePurchaseBox.view.PackagePurchaseBoxFrame;
   
   public class PackagePurchaseBoxController extends EventDispatcher
   {
      
      private static var _instance:PackagePurchaseBoxController;
       
      
      private var _frame:PackagePurchaseBoxFrame;
      
      private var _model:PackagePurchaseBoxModel;
      
      private var _useFirst:Boolean = true;
      
      private var _loadComplete:Boolean = false;
      
      public function PackagePurchaseBoxController()
      {
         super();
         this._model = new PackagePurchaseBoxModel();
      }
      
      public static function get instance() : PackagePurchaseBoxController
      {
         if(!_instance)
         {
            _instance = new PackagePurchaseBoxController();
         }
         return _instance;
      }
      
      public function show() : void
      {
         if(this._loadComplete)
         {
            this.showFrame();
         }
         else if(this._useFirst)
         {
            UIModuleSmallLoading.Instance.progress = 0;
            UIModuleSmallLoading.Instance.show();
            UIModuleSmallLoading.Instance.addEventListener(Event.CLOSE,this.__onClose);
            UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.__progressShow);
            UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.__complainShow);
            UIModuleLoader.Instance.addUIModuleImp(UIModuleTypes.DDTSHOP);
         }
      }
      
      private function showFrame() : void
      {
         this._frame = ComponentFactory.Instance.creatComponentByStylename("packagePurchaseBoxFrame");
         this._frame.show();
      }
      
      public function measureList(param1:Vector.<ShopItemInfo>) : Vector.<ShopItemInfo>
      {
         var _loc2_:Vector.<ShopItemInfo> = null;
         _loc2_ = new Vector.<ShopItemInfo>();
         if(!param1)
         {
            return _loc2_;
         }
         var _loc3_:int = 0;
         while(_loc3_ < param1.length)
         {
            if(param1[_loc3_].isValid)
            {
               _loc2_[_loc3_] = param1[_loc3_];
            }
            _loc3_++;
         }
         return _loc2_;
      }
      
      public function hide() : void
      {
         if(this._frame != null)
         {
            this._frame.dispose();
         }
         this._frame = null;
      }
      
      private function __progressShow(param1:UIModuleEvent) : void
      {
         if(param1.module == UIModuleTypes.DDTSHOP)
         {
            UIModuleSmallLoading.Instance.progress = param1.loader.progress * 100;
         }
      }
      
      private function __onClose(param1:Event) : void
      {
         UIModuleSmallLoading.Instance.hide();
         UIModuleSmallLoading.Instance.removeEventListener(Event.CLOSE,this.__onClose);
         UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.__progressShow);
         UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.__complainShow);
      }
      
      private function __complainShow(param1:UIModuleEvent) : void
      {
         if(param1.module == UIModuleTypes.DDTSHOP)
         {
            UIModuleSmallLoading.Instance.removeEventListener(Event.CLOSE,this.__onClose);
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.__progressShow);
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.__complainShow);
            UIModuleSmallLoading.Instance.hide();
            this._loadComplete = true;
            this._useFirst = false;
            this.show();
         }
      }
   }
}
