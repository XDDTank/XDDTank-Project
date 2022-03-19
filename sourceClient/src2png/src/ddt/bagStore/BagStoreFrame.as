// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//ddt.bagStore.BagStoreFrame

package ddt.bagStore
{
    import com.pickgliss.ui.controls.Frame;
    import com.pickgliss.ui.controls.BaseButton;
    import store.states.BaseStoreView;
    import store.StoreController;
    import flash.display.Bitmap;
    import com.pickgliss.ui.ComponentFactory;
    import flash.events.MouseEvent;
    import ddt.manager.SoundManager;
    import com.pickgliss.events.FrameEvent;
    import com.pickgliss.ui.LayerManager;
    import store.events.StoreIIEvent;
    import ddt.manager.SavePointManager;
    import ddt.manager.TaskManager;
    import trainer.view.NewHandContainer;
    import trainer.data.ArrowType;
    import ddt.manager.DialogManager;
    import flash.events.Event;
    import com.pickgliss.utils.ObjectUtils;

    public class BagStoreFrame extends Frame 
    {

        private var _helpBtn:BaseButton;
        private var _view:BaseStoreView;
        private var _controller:StoreController;
        private var _titleBmp:Bitmap;

        public function BagStoreFrame()
        {
            this.initEvent();
        }

        override protected function init():void
        {
            super.init();
            this._helpBtn = ComponentFactory.Instance.creat("baseHelpBtn");
            this._titleBmp = ComponentFactory.Instance.creatBitmap("asset.store.title");
            addToContent(this._titleBmp);
        }

        private function initEvent():void
        {
            this._helpBtn.addEventListener(MouseEvent.CLICK, this.__helpClick);
        }

        private function removeEvent():void
        {
            this._helpBtn.removeEventListener(MouseEvent.CLICK, this.__helpClick);
        }

        protected function __helpClick(_arg_1:MouseEvent):void
        {
            SoundManager.instance.playButtonSound();
            if (this._controller)
            {
                this._view.openHelp();
            };
        }

        override protected function addChildren():void
        {
            super.addChildren();
            if (this._helpBtn)
            {
                this._helpBtn.x = (_closeButton.x - this._helpBtn.width);
                this._helpBtn.y = _closeButton.y;
                addChild(this._helpBtn);
            };
        }

        public function set controller(_arg_1:StoreController):void
        {
            this._controller = _arg_1;
        }

        public function show(_arg_1:int):void
        {
            this._view = this._controller.getView(_arg_1);
            addToContent(this._view);
            addEventListener(FrameEvent.RESPONSE, this._response);
            LayerManager.Instance.addToLayer(this, LayerManager.GAME_DYNAMIC_LAYER, false, LayerManager.BLCAK_BLOCKGOUND);
        }

        private function _response(_arg_1:FrameEvent):void
        {
            SoundManager.instance.play("008");
            this._controller.Model.dispatchEvent(new StoreIIEvent(StoreIIEvent.STRENGTH_DONE));
            if (((_arg_1.responseCode == FrameEvent.CLOSE_CLICK) || (_arg_1.responseCode == FrameEvent.ESC_CLICK)))
            {
                this._controller.Model.weaponReady = false;
                this.dispose();
            };
            if (SavePointManager.Instance.isInSavePoint(39))
            {
                this.showDialog(23);
            };
            if ((((((SavePointManager.Instance.isInSavePoint(16)) && (TaskManager.instance.isNewHandTaskCompleted(12))) || ((SavePointManager.Instance.isInSavePoint(26)) && (TaskManager.instance.isNewHandTaskCompleted(23)))) || ((SavePointManager.Instance.isInSavePoint(67)) && (TaskManager.instance.isNewHandTaskCompleted(28)))) || (((SavePointManager.Instance.savePoints[35]) && (!(SavePointManager.Instance.savePoints[9]))) && (TaskManager.instance.isNewHandTaskCompleted(7)))))
            {
                NewHandContainer.Instance.clearArrowByID(ArrowType.HALL_BUILD);
            };
        }

        private function showDialog(_arg_1:uint):void
        {
            LayerManager.Instance.addToLayer(DialogManager.Instance.DialogBox, LayerManager.STAGE_TOP_LAYER);
            DialogManager.Instance.addEventListener(Event.COMPLETE, this.__dialogEndCallBack);
            DialogManager.Instance.showDialog(_arg_1);
        }

        private function __dialogEndCallBack(_arg_1:Event):void
        {
            DialogManager.Instance.removeEventListener(Event.COMPLETE, this.__dialogEndCallBack);
            if (SavePointManager.Instance.isInSavePoint(39))
            {
                SavePointManager.Instance.setSavePoint(39);
            };
        }

        override public function dispose():void
        {
            super.dispose();
            this.removeEvent();
            if (this._titleBmp)
            {
                ObjectUtils.disposeObject(this._titleBmp);
            };
            this._titleBmp = null;
            ObjectUtils.disposeObject(this._helpBtn);
            this._helpBtn = null;
            this._controller.shutdownEvent();
            removeEventListener(FrameEvent.RESPONSE, this._response);
            this._view = null;
            this._controller = null;
            BagStore.instance.storeOpenAble = false;
            BagStore.instance.closed();
            if (parent)
            {
                parent.removeChild(this);
            };
        }


    }
}//package ddt.bagStore

