// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//tofflist.TofflistManager

package tofflist
{
    import flash.events.EventDispatcher;
    import com.pickgliss.loader.UIModuleLoader;
    import ddt.view.UIModuleSmallLoading;
    import flash.events.Event;
    import com.pickgliss.events.UIModuleEvent;

    public class TofflistManager extends EventDispatcher 
    {

        private static var _instance:TofflistManager;

        private var _loadedCallBack:Function;
        private var _loadingModuleType:String;


        public static function get Instance():TofflistManager
        {
            if (_instance == null)
            {
                _instance = new (TofflistManager)();
            };
            return (_instance);
        }


        public function showToffilist(_arg_1:Function, _arg_2:String):void
        {
            if (UIModuleLoader.Instance.checkIsLoaded(_arg_2))
            {
                if (_arg_1 != null)
                {
                    (_arg_1());
                };
            }
            else
            {
                this._loadingModuleType = _arg_2;
                this._loadedCallBack = _arg_1;
                UIModuleSmallLoading.Instance.progress = 0;
                UIModuleSmallLoading.Instance.show();
                UIModuleSmallLoading.Instance.addEventListener(Event.CLOSE, this.__onClose);
                UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_COMPLETE, this.__tofflistComplete);
                UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_PROGRESS, this.__tofflistProgress);
                UIModuleLoader.Instance.addUIModuleImp(_arg_2);
            };
        }

        private function __onClose(_arg_1:Event):void
        {
            this._loadedCallBack = null;
            UIModuleSmallLoading.Instance.hide();
            UIModuleSmallLoading.Instance.removeEventListener(Event.CLOSE, this.__onClose);
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE, this.__tofflistComplete);
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_PROGRESS, this.__tofflistProgress);
        }

        protected function __tofflistComplete(_arg_1:UIModuleEvent):void
        {
            UIModuleSmallLoading.Instance.hide();
            UIModuleSmallLoading.Instance.removeEventListener(Event.CLOSE, this.__onClose);
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE, this.__tofflistComplete);
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_PROGRESS, this.__tofflistProgress);
            this.showToffilist(this._loadedCallBack, this._loadingModuleType);
        }

        protected function __tofflistProgress(_arg_1:UIModuleEvent):void
        {
            if (_arg_1.module == this._loadingModuleType)
            {
                UIModuleSmallLoading.Instance.progress = (_arg_1.loader.progress * 100);
            };
        }


    }
}//package tofflist

