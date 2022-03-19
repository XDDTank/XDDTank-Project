// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//baglocked.BagLockedGetFrame

package baglocked
{
    import com.pickgliss.ui.controls.Frame;
    import com.pickgliss.ui.controls.TextButton;
    import com.pickgliss.ui.text.FilterFrameText;
    import com.pickgliss.ui.controls.TextInput;
    import flash.ui.Keyboard;
    import ddt.manager.SoundManager;
    import flash.events.KeyboardEvent;
    import com.pickgliss.utils.ObjectUtils;
    import com.pickgliss.ui.LayerManager;
    import flash.utils.setTimeout;
    import flash.events.Event;
    import ddt.manager.LanguageMgr;
    import com.pickgliss.ui.ComponentFactory;
    import flash.events.MouseEvent;
    import ddt.events.BagEvent;
    import com.pickgliss.events.FrameEvent;
    import ddt.manager.PlayerManager;

    public class BagLockedGetFrame extends Frame 
    {

        private var _bagLockedController:BagLockedController;
        private var _certainBtn:TextButton;
        private var _deselectBtn:TextButton;
        private var _text4_0:FilterFrameText;
        private var _text4_1:FilterFrameText;
        private var _textInput4:TextInput;


        public function __onTextEnter(_arg_1:KeyboardEvent):void
        {
            _arg_1.stopImmediatePropagation();
            if (_arg_1.keyCode == 13)
            {
                if (this._certainBtn.enable)
                {
                    this.__certainBtnClick(null);
                };
            }
            else
            {
                if (_arg_1.keyCode == Keyboard.ESCAPE)
                {
                    SoundManager.instance.play("008");
                    this._bagLockedController.closeBagLockedGetFrame();
                    BagLockedController.Instance.dispatchEvent(new SetPassEvent(SetPassEvent.CANCELBTN));
                };
            };
        }

        public function set bagLockedController(_arg_1:BagLockedController):void
        {
            this._bagLockedController = _arg_1;
        }

        override public function dispose():void
        {
            this.remvoeEvent();
            this._bagLockedController = null;
            ObjectUtils.disposeObject(this._text4_0);
            this._text4_0 = null;
            ObjectUtils.disposeObject(this._text4_1);
            this._text4_1 = null;
            ObjectUtils.disposeObject(this._textInput4);
            this._textInput4 = null;
            ObjectUtils.disposeObject(this._certainBtn);
            this._certainBtn = null;
            ObjectUtils.disposeObject(this._deselectBtn);
            this._deselectBtn = null;
            super.dispose();
        }

        public function show():void
        {
            LayerManager.Instance.addToLayer(this, LayerManager.STAGE_DYANMIC_LAYER, true, LayerManager.BLCAK_BLOCKGOUND);
            addEventListener(KeyboardEvent.KEY_DOWN, this.__getFocus);
        }

        override protected function __onAddToStage(_arg_1:Event):void
        {
            super.__onAddToStage(_arg_1);
            this._textInput4.setFocus();
            setTimeout(this.getFocus, 100);
        }

        private function getFocus():void
        {
            if (this._textInput4)
            {
                this._textInput4.setFocus();
            };
        }

        private function __getFocus(_arg_1:KeyboardEvent):void
        {
            _arg_1.stopImmediatePropagation();
            if (((parent) && (this)))
            {
                this._textInput4.setFocus();
            };
        }

        override protected function init():void
        {
            super.init();
            this.titleText = LanguageMgr.GetTranslation("tank.view.bagII.baglocked.unlock");
            this._text4_0 = ComponentFactory.Instance.creat("baglocked.text4_0");
            this._text4_0.text = LanguageMgr.GetTranslation("baglocked.BagLockedGetFrame.Text4");
            addToContent(this._text4_0);
            this._text4_1 = ComponentFactory.Instance.creat("baglocked.text4_1");
            this._text4_1.text = LanguageMgr.GetTranslation("baglocked.SetPassFrame1.inputTextInfo1");
            addToContent(this._text4_1);
            this._textInput4 = ComponentFactory.Instance.creat("baglocked.textInput4");
            addToContent(this._textInput4);
            this._certainBtn = ComponentFactory.Instance.creat("baglocked.certainBtn");
            this._certainBtn.text = LanguageMgr.GetTranslation("tank.room.RoomIIView2.affirm");
            addToContent(this._certainBtn);
            this._deselectBtn = ComponentFactory.Instance.creat("baglocked.deselectBtn");
            this._deselectBtn.text = LanguageMgr.GetTranslation("tank.view.DefyAfficheView.cancel");
            addToContent(this._deselectBtn);
            this._textInput4.textField.tabIndex = 0;
            this._certainBtn.enable = false;
            this.addEvent();
        }

        private function __certainBtnClick(_arg_1:MouseEvent):void
        {
            SoundManager.instance.play("008");
            removeEventListener(KeyboardEvent.KEY_DOWN, this.__getFocus);
            this._bagLockedController.bagLockedInfo.psw = this._textInput4.text;
            this._bagLockedController.BagLockedGetFrameController();
        }

        private function __deselectBtnClick(_arg_1:MouseEvent):void
        {
            SoundManager.instance.play("008");
            this._bagLockedController.closeBagLockedGetFrame();
            BagLockedController.Instance.dispatchEvent(new SetPassEvent(SetPassEvent.CANCELBTN));
        }

        private function __clearSuccessHandler(_arg_1:BagEvent):void
        {
            this._bagLockedController.closeBagLockedGetFrame();
        }

        private function __frameEventHandler(_arg_1:FrameEvent):void
        {
            switch (_arg_1.responseCode)
            {
                case FrameEvent.ESC_CLICK:
                case FrameEvent.CLOSE_CLICK:
                    SoundManager.instance.play("008");
                    this._bagLockedController.closeBagLockedGetFrame();
                    BagLockedController.Instance.dispatchEvent(new SetPassEvent(SetPassEvent.CANCELBTN));
                    return;
            };
        }

        private function __textChange(_arg_1:Event):void
        {
            if (this._textInput4.text != "")
            {
                this._certainBtn.enable = true;
            }
            else
            {
                this._certainBtn.enable = false;
            };
        }

        private function addEvent():void
        {
            addEventListener(FrameEvent.RESPONSE, this.__frameEventHandler);
            this._textInput4.textField.addEventListener(Event.CHANGE, this.__textChange);
            this._textInput4.textField.addEventListener(KeyboardEvent.KEY_DOWN, this.__onTextEnter, false, 1000);
            this._certainBtn.addEventListener(MouseEvent.CLICK, this.__certainBtnClick);
            this._deselectBtn.addEventListener(MouseEvent.CLICK, this.__deselectBtnClick);
            PlayerManager.Instance.Self.addEventListener(BagEvent.CLEAR, this.__clearSuccessHandler);
        }

        private function remvoeEvent():void
        {
            removeEventListener(FrameEvent.RESPONSE, this.__frameEventHandler);
            this._textInput4.textField.removeEventListener(Event.CHANGE, this.__textChange);
            this._textInput4.textField.removeEventListener(KeyboardEvent.KEY_DOWN, this.__onTextEnter);
            this._certainBtn.addEventListener(MouseEvent.CLICK, this.__certainBtnClick);
            this._deselectBtn.removeEventListener(MouseEvent.CLICK, this.__deselectBtnClick);
            PlayerManager.Instance.Self.removeEventListener(BagEvent.CLEAR, this.__clearSuccessHandler);
        }


    }
}//package baglocked

