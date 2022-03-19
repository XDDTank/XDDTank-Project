// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//consortion.view.selfConsortia.ConsortionDisbandFrame

package consortion.view.selfConsortia
{
    import com.pickgliss.ui.controls.Frame;
    import com.pickgliss.ui.controls.TextButton;
    import com.pickgliss.ui.image.Image;
    import com.pickgliss.ui.text.FilterFrameText;
    import ddt.manager.LanguageMgr;
    import com.pickgliss.ui.ComponentFactory;
    import com.pickgliss.events.FrameEvent;
    import flash.events.MouseEvent;
    import flash.events.KeyboardEvent;
    import ddt.manager.SoundManager;
    import ddt.manager.SocketManager;
    import ddt.manager.MessageTipManager;
    import flash.ui.Keyboard;
    import com.pickgliss.ui.LayerManager;
    import com.pickgliss.utils.ObjectUtils;

    public class ConsortionDisbandFrame extends Frame 
    {

        private var _confirmBtn:TextButton;
        private var _cancelBtn:TextButton;
        private var _inputTxtBg:Image;
        private var _tip:FilterFrameText;
        private var _tip2:FilterFrameText;
        private var _inputTxt:FilterFrameText;
        private var _isYes:Boolean = false;

        public function ConsortionDisbandFrame()
        {
            this.initView();
            this.initEvent();
        }

        private function initView():void
        {
            titleText = LanguageMgr.GetTranslation("AlertDialog.Info");
            this._confirmBtn = ComponentFactory.Instance.creatComponentByStylename("ddtconsortion.combineConfirm.confirmBtn");
            this._confirmBtn.text = LanguageMgr.GetTranslation("ok");
            this._cancelBtn = ComponentFactory.Instance.creatComponentByStylename("ddtconsortion.combineConfirm.cancelBtn");
            this._cancelBtn.text = LanguageMgr.GetTranslation("cancel");
            this._inputTxtBg = ComponentFactory.Instance.creatComponentByStylename("asset.consortion.conmbineConfirm.inputTxtBg");
            this._tip = ComponentFactory.Instance.creatComponentByStylename("ddtconsortion.combineConfirm.tipTxt");
            this._tip2 = ComponentFactory.Instance.creatComponentByStylename("ddtconsortion.combineConfirm.tip2Txt");
            this._tip.text = LanguageMgr.GetTranslation("ddtconsortion.combineConfirm.tip");
            this._tip2.htmlText = LanguageMgr.GetTranslation("ddtconsortion.combineConfirm.tip1");
            this._inputTxt = ComponentFactory.Instance.creatComponentByStylename("ddtconsortion.combineConfirm.inputTxt");
            addToContent(this._confirmBtn);
            addToContent(this._cancelBtn);
            addToContent(this._inputTxtBg);
            addToContent(this._tip);
            addToContent(this._tip2);
            addToContent(this._inputTxt);
        }

        private function initEvent():void
        {
            addEventListener(FrameEvent.RESPONSE, this.__response);
            this._confirmBtn.addEventListener(MouseEvent.CLICK, this.__confirmHandler);
            this._cancelBtn.addEventListener(MouseEvent.CLICK, this.__cancelHandler);
            this._inputTxt.addEventListener(KeyboardEvent.KEY_DOWN, this.__keyDownHandler);
        }

        private function __confirmHandler(_arg_1:MouseEvent):void
        {
            SoundManager.instance.play("008");
            var _local_2:String = this._inputTxt.text;
            if (_local_2.toLocaleLowerCase() == "yes")
            {
                SocketManager.Instance.out.sendConsortiaDismiss();
                this.dispose();
            }
            else
            {
                if (_local_2 == "")
                {
                    MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("beadSystem.bead.combineConfirm.inputError.tip"));
                    return;
                };
                MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("beadSystem.bead.combineConfirm.inputError.tip2"));
                return;
            };
        }

        private function __cancelHandler(_arg_1:MouseEvent):void
        {
            SoundManager.instance.play("008");
            this.dispose();
        }

        private function __keyDownHandler(_arg_1:KeyboardEvent):void
        {
            if (_arg_1.keyCode == Keyboard.ENTER)
            {
                this.__confirmHandler(null);
            };
        }

        private function __response(_arg_1:FrameEvent):void
        {
            if (((_arg_1.responseCode == FrameEvent.ESC_CLICK) || (_arg_1.responseCode == FrameEvent.CLOSE_CLICK)))
            {
                SoundManager.instance.play("008");
                this.dispose();
            };
        }

        public function show():void
        {
            LayerManager.Instance.addToLayer(this, LayerManager.GAME_DYNAMIC_LAYER, true, LayerManager.BLCAK_BLOCKGOUND);
            this._inputTxt.setFocus();
        }

        public function setInputTxtFocus():void
        {
            if (this._inputTxt)
            {
                this._inputTxt.setFocus();
            };
        }

        private function removeEvent():void
        {
            removeEventListener(FrameEvent.RESPONSE, this.__response);
            this._confirmBtn.removeEventListener(MouseEvent.CLICK, this.__confirmHandler);
            this._cancelBtn.removeEventListener(MouseEvent.CLICK, this.__cancelHandler);
            this._inputTxt.removeEventListener(KeyboardEvent.KEY_DOWN, this.__keyDownHandler);
        }

        override public function dispose():void
        {
            this.removeEvent();
            super.dispose();
            if (this._confirmBtn)
            {
                ObjectUtils.disposeObject(this._confirmBtn);
            };
            if (this._cancelBtn)
            {
                ObjectUtils.disposeObject(this._cancelBtn);
            };
            if (this._inputTxtBg)
            {
                ObjectUtils.disposeObject(this._inputTxtBg);
            };
            if (this._tip)
            {
                ObjectUtils.disposeObject(this._tip);
            };
            if (this._tip2)
            {
                ObjectUtils.disposeObject(this._tip2);
            };
            if (this._inputTxt)
            {
                ObjectUtils.disposeObject(this._inputTxt);
            };
            this._confirmBtn = null;
            this._cancelBtn = null;
            this._inputTxtBg = null;
            this._tip = null;
            this._tip2 = null;
            this._inputTxt = null;
            if (this.parent)
            {
                this.parent.removeChild(this);
            };
        }


    }
}//package consortion.view.selfConsortia

