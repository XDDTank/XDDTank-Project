package tofflist
{
   import com.pickgliss.events.UIModuleEvent;
   import com.pickgliss.loader.UIModuleLoader;
   import ddt.view.UIModuleSmallLoading;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   
   public class TofflistManager extends EventDispatcher
   {
      
      private static var _instance:TofflistManager;
       
      
      private var _loadedCallBack:Function;
      
      private var _loadingModuleType:String;
      
      public function TofflistManager()
      {
         super();
      }
      
      public static function get Instance() : TofflistManager
      {
         if(_instance == null)
         {
            _instance = new TofflistManager();
         }
         return _instance;
      }
      
      public function showToffilist(param1:Function, param2:String) : void
      {
         if(UIModuleLoader.Instance.checkIsLoaded(param2))
         {
            if(param1 != null)
            {
               param1();
            }
         }
         else
         {
            this._loadingModuleType = param2;
            this._loadedCallBack = param1;
            UIModuleSmallLoading.Instance.progress = 0;
            UIModuleSmallLoading.Instance.show();
            UIModuleSmallLoading.Instance.addEventListener(Event.CLOSE,this.__onClose);
            UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.__tofflistComplete);
            UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.__tofflistProgress);
            UIModuleLoader.Instance.addUIModuleImp(param2);
         }
      }
      
      private function __onClose(param1:Event) : void
      {
         this._loadedCallBack = null;
         UIModuleSmallLoading.Instance.hide();
         UIModuleSmallLoading.Instance.removeEventListener(Event.CLOSE,this.__onClose);
         UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.__tofflistComplete);
         UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.__tofflistProgress);
      }
      
      protected function __tofflistComplete(param1:UIModuleEvent) : void
      {
         UIModuleSmallLoading.Instance.hide();
         UIModuleSmallLoading.Instance.removeEventListener(Event.CLOSE,this.__onClose);
         UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.__tofflistComplete);
         UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.__tofflistProgress);
         this.showToffilist(this._loadedCallBack,this._loadingModuleType);
      }
      
      protected function __tofflistProgress(param1:UIModuleEvent) : void
      {
         if(param1.module == this._loadingModuleType)
         {
            UIModuleSmallLoading.Instance.progress = param1.loader.progress * 100;
         }
      }
   }
}
