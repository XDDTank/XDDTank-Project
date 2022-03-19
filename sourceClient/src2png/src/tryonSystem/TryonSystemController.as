// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//tryonSystem.TryonSystemController

package tryonSystem
{
    import com.pickgliss.ui.controls.Frame;
    import ddt.data.EquipType;
    import ddt.data.goods.InventoryItemInfo;
    import com.pickgliss.ui.ComponentFactory;
    import com.pickgliss.events.FrameEvent;
    import flash.events.Event;
    import com.pickgliss.ui.LayerManager;
    import ddt.manager.SoundManager;
    import ddt.manager.MessageTipManager;
    import ddt.manager.LanguageMgr;

    public class TryonSystemController 
    {

        private static var _instance:TryonSystemController;

        private var _view:Frame;
        private var _model:TryonModel;
        private var _sumbmitFun:Function;
        private var _cancelFun:Function;


        public static function get Instance():TryonSystemController
        {
            if (_instance == null)
            {
                _instance = new (TryonSystemController)();
            };
            return (_instance);
        }


        public function get model():TryonModel
        {
            return (this._model);
        }

        public function get view():Frame
        {
            return (this._view);
        }

        public function show(_arg_1:Array, _arg_2:Function=null, _arg_3:Function=null):void
        {
            this._model = new TryonModel(_arg_1);
            this._sumbmitFun = _arg_2;
            this._cancelFun = _arg_3;
            if (EquipType.isAvatar(InventoryItemInfo(_arg_1[0]).CategoryID))
            {
                this._view = (ComponentFactory.Instance.creatComponentByStylename("tryonSystem.tryonFrame") as TryonPanelFrame);
                TryonPanelFrame(this._view).controller = this;
            }
            else
            {
                this._view = (ComponentFactory.Instance.creatComponentByStylename("tryonSystem.ChoosePanelFrame") as ChooseFrame);
                ChooseFrame(this._view).controller = this;
            };
            this._view.addEventListener(FrameEvent.RESPONSE, this.__onResponse);
            this._view.addEventListener(Event.REMOVED_FROM_STAGE, this.__onRemoved);
            LayerManager.Instance.addToLayer(this._view, LayerManager.GAME_DYNAMIC_LAYER, true, LayerManager.BLCAK_BLOCKGOUND, true);
        }

        private function __onRemoved(_arg_1:Event):void
        {
            if (this._view)
            {
                this._view.removeEventListener(FrameEvent.RESPONSE, this.__onResponse);
            };
            if (this._view)
            {
                this._view.removeEventListener(Event.REMOVED_FROM_STAGE, this.__onRemoved);
            };
            this._view = null;
            if (this._model)
            {
                this._model.dispose();
            };
            this._model = null;
            this._cancelFun = null;
            this._sumbmitFun = null;
        }

        private function __onResponse(_arg_1:FrameEvent):void
        {
            SoundManager.instance.play("008");
            switch (_arg_1.responseCode)
            {
                case FrameEvent.CANCEL_CLICK:
                case FrameEvent.CLOSE_CLICK:
                case FrameEvent.ESC_CLICK:
                    if (this._cancelFun != null)
                    {
                        this._cancelFun();
                    };
                    break;
                case FrameEvent.ENTER_CLICK:
                case FrameEvent.SUBMIT_CLICK:
                    if ((!(this._model.selectedItem)))
                    {
                        MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.tryonSystem.tryon"));
                        return;
                    };
                    if (this._sumbmitFun != null)
                    {
                        this._sumbmitFun(this._model.selectedItem);
                    };
                    break;
            };
            if (this._view)
            {
                this._view.removeEventListener(FrameEvent.RESPONSE, this.__onResponse);
            };
            if (this._view)
            {
                this._view.removeEventListener(Event.REMOVED_FROM_STAGE, this.__onRemoved);
            };
            if (this._view)
            {
                this._view.dispose();
            };
            this._view = null;
            if (this._model)
            {
                this._model.dispose();
            };
            this._model = null;
            this._cancelFun = null;
            this._sumbmitFun = null;
        }


    }
}//package tryonSystem

