// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//ddt.view.common.church.ChurchDialogueUnmarried

package ddt.view.common.church
{
    import com.pickgliss.ui.controls.alert.BaseAlerFrame;
    import flash.display.Bitmap;
    import com.pickgliss.ui.vo.AlertInfo;
    import ddt.manager.LanguageMgr;
    import com.pickgliss.ui.ComponentFactory;
    import com.pickgliss.events.FrameEvent;
    import ddt.manager.SoundManager;
    import com.pickgliss.ui.LayerManager;
    import flash.events.Event;

    public class ChurchDialogueUnmarried extends BaseAlerFrame 
    {

        private var _bg:Bitmap;
        private var _alertInfo:AlertInfo;

        public function ChurchDialogueUnmarried()
        {
            this.initialize();
        }

        protected function initialize():void
        {
            this._alertInfo = new AlertInfo();
            this._alertInfo.showSubmit = false;
            this._alertInfo.cancelLabel = LanguageMgr.GetTranslation("close");
            this._alertInfo.moveEnable = false;
            info = this._alertInfo;
            this.escEnable = true;
            this._bg = ComponentFactory.Instance.creatBitmap("asset.church.UnmarriedAsset");
            addToContent(this._bg);
            addEventListener(FrameEvent.RESPONSE, this.onFrameResponse);
        }

        private function onFrameResponse(_arg_1:FrameEvent):void
        {
            switch (_arg_1.responseCode)
            {
                case FrameEvent.CANCEL_CLICK:
                case FrameEvent.CLOSE_CLICK:
                case FrameEvent.ESC_CLICK:
                case FrameEvent.ENTER_CLICK:
                case FrameEvent.SUBMIT_CLICK:
                    SoundManager.instance.play("008");
                    this.dispose();
                    return;
            };
        }

        public function show():void
        {
            LayerManager.Instance.addToLayer(this, LayerManager.GAME_UI_LAYER, true, LayerManager.BLCAK_BLOCKGOUND);
        }

        override public function dispose():void
        {
            super.dispose();
            removeEventListener(FrameEvent.RESPONSE, this.onFrameResponse);
            if (this._bg)
            {
                if (this._bg.parent)
                {
                    this._bg.parent.removeChild(this._bg);
                };
                this._bg.bitmapData.dispose();
                this._bg.bitmapData = null;
            };
            this._bg = null;
            if (parent)
            {
                parent.removeChild(this);
            };
            dispatchEvent(new Event(Event.CLOSE));
        }


    }
}//package ddt.view.common.church

