// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//ddt.view.enthrall.ValidateFrame

package ddt.view.enthrall
{
    import com.pickgliss.ui.controls.Frame;
    import flash.display.Bitmap;
    import com.pickgliss.ui.text.FilterFrameText;
    import com.pickgliss.ui.controls.TextButton;
    import com.pickgliss.events.FrameEvent;
    import flash.events.FocusEvent;
    import com.pickgliss.ui.ComponentFactory;
    import ddt.manager.LanguageMgr;
    import flash.events.MouseEvent;
    import ddt.manager.SoundManager;
    import road7th.utils.StringHelper;
    import ddt.manager.SocketManager;

    public class ValidateFrame extends Frame 
    {

        private var _bg:Bitmap;
        private var _nameInput:FilterFrameText;
        private var _idInput:FilterFrameText;
        private var _errorText:FilterFrameText;
        private var _okBtn:TextButton;
        private var _cancelBtn:TextButton;

        public function ValidateFrame()
        {
            this.addEvent();
        }

        private function addEvent():void
        {
            addEventListener(FrameEvent.RESPONSE, this.__frameEventHandler);
            addEventListener(FocusEvent.FOCUS_IN, this.__focusIn);
        }

        private function removeEvent():void
        {
            removeEventListener(FrameEvent.RESPONSE, this.__frameEventHandler);
            removeEventListener(FocusEvent.FOCUS_IN, this.__focusIn);
        }

        private function __focusIn(_arg_1:FocusEvent):void
        {
        }

        override protected function init():void
        {
            super.init();
            this._bg = ComponentFactory.Instance.creat("asset.core.view.enthrall.ValidateFrameBG");
            addToContent(this._bg);
            this._nameInput = ComponentFactory.Instance.creat("core.view.enthrall.ValidateNameInput");
            this._nameInput.maxChars = 14;
            addToContent(this._nameInput);
            this._idInput = ComponentFactory.Instance.creat("core.view.enthrall.ValidateIDInput");
            this._idInput.restrict = "0-9 xX";
            this._idInput.maxChars = 18;
            addToContent(this._idInput);
            this._errorText = ComponentFactory.Instance.creat("core.view.enthrall.ValidateErrorText");
            addToContent(this._errorText);
            this._okBtn = ComponentFactory.Instance.creatComponentByStylename("core.simplebt");
            this._okBtn.y = 130;
            this._okBtn.x = 182;
            this._okBtn.text = LanguageMgr.GetTranslation("tank.view.enthrallCheckFrame.checkBtn");
            this._okBtn.addEventListener(MouseEvent.CLICK, this.__check);
            addToContent(this._okBtn);
            this._cancelBtn = ComponentFactory.Instance.creatComponentByStylename("core.Cancelbt");
            this._cancelBtn.x = 314;
            this._cancelBtn.y = 130;
            this._cancelBtn.text = LanguageMgr.GetTranslation("tank.view.enthrallCheckFrame.canelBtn");
            this._cancelBtn.addEventListener(MouseEvent.CLICK, this.__cancel);
            addToContent(this._cancelBtn);
            this._errorText.text = "";
        }

        private function __check(_arg_1:MouseEvent):void
        {
            SoundManager.instance.play("008");
            if (((this._nameInput.text == null) || (this._nameInput.text == "")))
            {
                this._errorText.text = LanguageMgr.GetTranslation("ddt.enthrall.emptyName");
            }
            else
            {
                if (StringHelper.cidCheck(this._idInput.text))
                {
                    SocketManager.Instance.out.sendCIDInfo(this._nameInput.text, this._idInput.text.toUpperCase());
                    this.clear();
                }
                else
                {
                    this._errorText.text = LanguageMgr.GetTranslation("ddt.enthrall.invalidID");
                };
            };
        }

        private function __cancel(_arg_1:MouseEvent):void
        {
            SoundManager.instance.play("008");
            this.dispose();
        }

        private function clear():void
        {
            this._nameInput.text = "";
            this._idInput.text = "";
            this._errorText.text = "";
        }

        private function __frameEventHandler(_arg_1:FrameEvent):void
        {
            switch (_arg_1.responseCode)
            {
                case FrameEvent.ESC_CLICK:
                case FrameEvent.CLOSE_CLICK:
                    SoundManager.instance.play("008");
                    this.hide();
                    return;
            };
        }

        public function hide():void
        {
            this.clear();
            if (parent)
            {
                parent.removeChild(this);
            };
        }

        override public function dispose():void
        {
            this.hide();
            this.removeEvent();
            super.dispose();
        }


    }
}//package ddt.view.enthrall

