// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//consortion.view.selfConsortia.UpGradeLackRichesFrame

package consortion.view.selfConsortia
{
    import com.pickgliss.ui.controls.Frame;
    import com.pickgliss.ui.image.MutipleImage;
    import com.pickgliss.ui.controls.TextButton;
    import ddt.manager.LanguageMgr;
    import com.pickgliss.ui.ComponentFactory;
    import com.pickgliss.events.FrameEvent;
    import flash.events.MouseEvent;
    import ddt.manager.SoundManager;
    import consortion.ConsortionModelControl;

    public class UpGradeLackRichesFrame extends Frame 
    {

        private var _bg:MutipleImage;
        private var _ok:TextButton;
        private var _cancel:TextButton;

        public function UpGradeLackRichesFrame()
        {
            this.initView();
            this.initEvent();
        }

        private function initView():void
        {
            escEnable = true;
            disposeChildren = true;
            titleText = LanguageMgr.GetTranslation("AlertDialog.Info");
            this._bg = ComponentFactory.Instance.creatComponentByStylename("consortion.upGradeLackRichesFrame.bg");
            this._ok = ComponentFactory.Instance.creatComponentByStylename("consortion.upGradeLackRichesFrame.ok");
            this._cancel = ComponentFactory.Instance.creatComponentByStylename("consortion.upGradeLackRichesFrame.cancel");
            addToContent(this._bg);
            addToContent(this._ok);
            addToContent(this._cancel);
            this._ok.text = LanguageMgr.GetTranslation("ok");
            this._cancel.text = LanguageMgr.GetTranslation("cancel");
        }

        private function initEvent():void
        {
            addEventListener(FrameEvent.RESPONSE, this.__responseHandler);
            this._ok.addEventListener(MouseEvent.CLICK, this.__okHandler);
            this._cancel.addEventListener(MouseEvent.CLICK, this.__cancelHandler);
        }

        private function removeEvent():void
        {
            removeEventListener(FrameEvent.RESPONSE, this.__responseHandler);
            this._ok.removeEventListener(MouseEvent.CLICK, this.__okHandler);
            this._cancel.removeEventListener(MouseEvent.CLICK, this.__cancelHandler);
        }

        private function __responseHandler(_arg_1:FrameEvent):void
        {
            if (((_arg_1.responseCode == FrameEvent.CLOSE_CLICK) || (_arg_1.responseCode == FrameEvent.ESC_CLICK)))
            {
                SoundManager.instance.play("008");
                this.dispose();
            };
        }

        private function __okHandler(_arg_1:MouseEvent):void
        {
            SoundManager.instance.play("008");
            ConsortionModelControl.Instance.alertTaxFrame();
            this.dispose();
        }

        private function __cancelHandler(_arg_1:MouseEvent):void
        {
            SoundManager.instance.play("008");
            this.dispose();
        }

        override public function dispose():void
        {
            this.removeEvent();
            super.dispose();
            this._bg = null;
            this._ok = null;
            this._cancel = null;
            if (this.parent)
            {
                this.parent.removeChild(this);
            };
        }


    }
}//package consortion.view.selfConsortia

