// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//gotopage.view.GotoPageController

package gotopage.view
{
    import ddt.view.UIModuleSmallLoading;
    import flash.events.Event;
    import com.pickgliss.loader.UIModuleLoader;
    import com.pickgliss.events.UIModuleEvent;
    import ddt.data.UIModuleTypes;
    import com.pickgliss.events.FrameEvent;
    import com.pickgliss.ui.ComponentFactory;
    import com.pickgliss.ui.LayerManager;
    import com.pickgliss.toplevel.StageReferance;
    import ddt.manager.SoundManager;

    public class GotoPageController 
    {

        private static var _instance:GotoPageController;

        public var _gotoPageView:GotoPageView;
        public var isShow:Boolean;


        public static function get Instance():GotoPageController
        {
            if (_instance == null)
            {
                _instance = new (GotoPageController)();
            };
            return (_instance);
        }


        public function switchVisible():void
        {
            UIModuleSmallLoading.Instance.progress = 0;
            UIModuleSmallLoading.Instance.show();
            UIModuleSmallLoading.Instance.addEventListener(Event.CLOSE, this.__onClose);
            UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_COMPLETE, this.__onUIModuleComplete);
            UIModuleLoader.Instance.addUIModuleImp(UIModuleTypes.GOTOPAGE);
        }

        private function __onUIModuleComplete(_arg_1:UIModuleEvent):void
        {
            UIModuleSmallLoading.Instance.hide();
            UIModuleSmallLoading.Instance.removeEventListener(Event.CLOSE, this.__onClose);
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE, this.__onUIModuleComplete);
            if (_arg_1.module == UIModuleTypes.GOTOPAGE)
            {
                UIModuleSmallLoading.Instance.hide();
                if (this.isShow)
                {
                    this.hide();
                }
                else
                {
                    this.show();
                };
            };
        }

        private function __onClose(_arg_1:Event):void
        {
            UIModuleSmallLoading.Instance.hide();
            UIModuleSmallLoading.Instance.removeEventListener(Event.CLOSE, this.__onClose);
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE, this.__onUIModuleComplete);
        }

        public function hide():void
        {
            this.isShow = false;
            if (this._gotoPageView)
            {
                this._gotoPageView.removeEventListener(FrameEvent.RESPONSE, this.__responseHandler);
                this._gotoPageView.dispose();
            };
            this._gotoPageView = null;
        }

        private function show():void
        {
            this.isShow = true;
            if (this._gotoPageView == null)
            {
                this._gotoPageView = ComponentFactory.Instance.creatComponentByStylename("gotopage.mainFrame");
                this._gotoPageView.addEventListener(FrameEvent.RESPONSE, this.__responseHandler);
            };
            LayerManager.Instance.addToLayer(this._gotoPageView, LayerManager.GAME_DYNAMIC_LAYER, false, LayerManager.ALPHA_BLOCKGOUND);
            StageReferance.stage.focus = this._gotoPageView;
        }

        private function __responseHandler(_arg_1:FrameEvent):void
        {
            SoundManager.instance.play("008");
            switch (_arg_1.responseCode)
            {
                case FrameEvent.CANCEL_CLICK:
                case FrameEvent.CLOSE_CLICK:
                case FrameEvent.ESC_CLICK:
                    this.hide();
                    return;
            };
        }


    }
}//package gotopage.view

