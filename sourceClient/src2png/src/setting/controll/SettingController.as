// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//setting.controll.SettingController

package setting.controll
{
    import setting.view.SettingView;
    import ddt.view.UIModuleSmallLoading;
    import flash.events.Event;
    import com.pickgliss.loader.UIModuleLoader;
    import com.pickgliss.events.UIModuleEvent;
    import ddt.data.UIModuleTypes;
    import ddt.manager.SharedManager;
    import com.pickgliss.events.FrameEvent;
    import com.pickgliss.ui.ComponentFactory;
    import com.pickgliss.ui.LayerManager;

    public class SettingController 
    {

        private static var _instance:SettingController;

        private var _settingView:SettingView;
        private var _moduleComplete:Boolean = false;


        public static function get Instance():SettingController
        {
            if ((!(_instance)))
            {
                _instance = new (SettingController)();
            };
            return (_instance);
        }


        public function switchVisible():void
        {
            if (((this._settingView) && (this._settingView.parent)))
            {
                this.hide();
            }
            else
            {
                if (this._moduleComplete)
                {
                    this.show();
                }
                else
                {
                    UIModuleSmallLoading.Instance.progress = 0;
                    UIModuleSmallLoading.Instance.show();
                    UIModuleSmallLoading.Instance.addEventListener(Event.CLOSE, this.__onClose);
                    UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_COMPLETE, this.__onUIModuleComplete);
                    UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_PROGRESS, this.__onProgress);
                    UIModuleLoader.Instance.addUIModuleImp(UIModuleTypes.DDT_SETTING);
                };
            };
        }

        public function showSetingView():void
        {
            if ((!(SharedManager.Instance.isSetingMovieClip)))
            {
                return;
            };
            UIModuleSmallLoading.Instance.progress = 0;
            UIModuleSmallLoading.Instance.show();
            UIModuleSmallLoading.Instance.addEventListener(Event.CLOSE, this.__onClose);
            UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_COMPLETE, this.__onComplete);
            UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_PROGRESS, this.__onProgress);
            UIModuleLoader.Instance.addUIModuleImp(UIModuleTypes.DDT_SETTING);
        }

        private function __onProgress(_arg_1:UIModuleEvent):void
        {
            if (_arg_1.module == UIModuleTypes.DDT_SETTING)
            {
                UIModuleSmallLoading.Instance.progress = (_arg_1.loader.progress * 100);
            };
        }

        private function __onClose(_arg_1:Event):void
        {
            this._moduleComplete = false;
            UIModuleSmallLoading.Instance.hide();
            UIModuleSmallLoading.Instance.removeEventListener(Event.CLOSE, this.__onClose);
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE, this.__onUIModuleComplete);
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_PROGRESS, this.__onProgress);
        }

        public function dispose():void
        {
            this._settingView.removeEventListener(FrameEvent.RESPONSE, this.__responseHandler);
            this._settingView = null;
        }

        public function show():void
        {
            if ((!(this._settingView)))
            {
                this._settingView = ComponentFactory.Instance.creatComponentByStylename("ddtsetting.MainFrame");
                this._settingView.addEventListener(FrameEvent.RESPONSE, this.__responseHandler);
            };
            LayerManager.Instance.addToLayer(this._settingView, LayerManager.GAME_DYNAMIC_LAYER, false, LayerManager.ALPHA_BLOCKGOUND);
        }

        public function hide():void
        {
            if (this._settingView)
            {
                this._settingView.dispose();
            };
            this._settingView = null;
        }

        private function __onUIModuleComplete(_arg_1:UIModuleEvent):void
        {
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE, this.__onUIModuleComplete);
            UIModuleSmallLoading.Instance.removeEventListener(Event.CLOSE, this.__onClose);
            if (_arg_1.module == UIModuleTypes.DDT_SETTING)
            {
                this._moduleComplete = true;
                UIModuleSmallLoading.Instance.hide();
                this.show();
            };
        }

        private function __onComplete(_arg_1:UIModuleEvent):void
        {
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE, this.__onComplete);
            UIModuleSmallLoading.Instance.removeEventListener(Event.CLOSE, this.__onClose);
            if (_arg_1.module == UIModuleTypes.DDT_SETTING)
            {
                UIModuleSmallLoading.Instance.hide();
                if ((!(this._settingView)))
                {
                    this._settingView = ComponentFactory.Instance.creat("ddtsetting.MainFrame");
                    this._settingView.setShowSettingMovie();
                    this._settingView.addEventListener(FrameEvent.RESPONSE, this.__responseHandler);
                    SharedManager.Instance.isSetingMovieClip = false;
                    SharedManager.Instance.save();
                };
                LayerManager.Instance.addToLayer(this._settingView, LayerManager.GAME_DYNAMIC_LAYER, false, LayerManager.ALPHA_BLOCKGOUND);
            };
        }

        private function __responseHandler(_arg_1:FrameEvent):void
        {
            switch (_arg_1.responseCode)
            {
                case FrameEvent.CANCEL_CLICK:
                case FrameEvent.CLOSE_CLICK:
                case FrameEvent.ESC_CLICK:
                    this._settingView.doCancel();
                    this.hide();
                    return;
                case FrameEvent.SUBMIT_CLICK:
                case FrameEvent.ENTER_CLICK:
                    this._settingView.doConfirm();
                    this.hide();
                    return;
            };
        }

        public function get isShow():Boolean
        {
            if ((!(this._settingView)))
            {
                return (false);
            };
            return (true);
        }


    }
}//package setting.controll

