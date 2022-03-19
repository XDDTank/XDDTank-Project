﻿// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//baglocked.SetPassFrame1

package baglocked
{
    import com.pickgliss.ui.controls.Frame;
    import com.pickgliss.ui.text.FilterFrameText;
    import com.pickgliss.ui.controls.TextButton;
    import com.pickgliss.ui.controls.TextInput;
    import flash.events.KeyboardEvent;
    import com.pickgliss.utils.ObjectUtils;
    import com.pickgliss.ui.LayerManager;
    import flash.utils.setTimeout;
    import ddt.manager.LanguageMgr;
    import com.pickgliss.ui.ComponentFactory;
    import ddt.manager.SoundManager;
    import com.pickgliss.events.FrameEvent;
    import baglocked.data.BagLockedInfo;
    import ddt.manager.MessageTipManager;
    import flash.events.MouseEvent;
    import flash.events.Event;

    public class SetPassFrame1 extends Frame 
    {

        private var _bagLockedController:BagLockedController;
        private var _inputTextInfo1_1:FilterFrameText;
        private var _inputTextInfo1_2:FilterFrameText;
        private var _inputTextInfo1_3:FilterFrameText;
        private var _inputTextInfo1_4:FilterFrameText;
        private var _inputTextInfo1_5:FilterFrameText;
        private var _nextBtn1:TextButton;
        private var _textinput1:TextInput;
        private var _textinput2:TextInput;


        public function __onTextEnter(_arg_1:KeyboardEvent):void
        {
            if (_arg_1.keyCode == 13)
            {
                if (this._nextBtn1.enable)
                {
                    this.__nextBtn1Click(null);
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
            ObjectUtils.disposeObject(this._inputTextInfo1_1);
            this._inputTextInfo1_1 = null;
            ObjectUtils.disposeObject(this._inputTextInfo1_2);
            this._inputTextInfo1_2 = null;
            ObjectUtils.disposeObject(this._textinput1);
            this._textinput1 = null;
            ObjectUtils.disposeObject(this._inputTextInfo1_3);
            this._inputTextInfo1_3 = null;
            ObjectUtils.disposeObject(this._inputTextInfo1_4);
            this._inputTextInfo1_4 = null;
            ObjectUtils.disposeObject(this._textinput2);
            this._textinput2 = null;
            ObjectUtils.disposeObject(this._inputTextInfo1_5);
            this._inputTextInfo1_5 = null;
            ObjectUtils.disposeObject(this._nextBtn1);
            this._nextBtn1 = null;
            super.dispose();
        }

        public function show():void
        {
            LayerManager.Instance.addToLayer(this, LayerManager.GAME_DYNAMIC_LAYER, true, LayerManager.BLCAK_BLOCKGOUND);
            if (this._bagLockedController.bagLockedInfo.psw.length > 0)
            {
                this._textinput1.text = (this._textinput2.text = this._bagLockedController.bagLockedInfo.psw);
                this._nextBtn1.enable = true;
            };
            setTimeout(this._textinput1.setFocus, 100);
        }

        override protected function init():void
        {
            super.init();
            this.titleText = LanguageMgr.GetTranslation("tank.view.bagII.baglocked.guide");
            this._inputTextInfo1_1 = ComponentFactory.Instance.creat("baglocked.text1_1");
            this._inputTextInfo1_1.text = LanguageMgr.GetTranslation("baglocked.SetPassFrame1.inputTextInfo1");
            addToContent(this._inputTextInfo1_1);
            this._inputTextInfo1_2 = ComponentFactory.Instance.creat("baglocked.text1_2");
            this._inputTextInfo1_2.text = LanguageMgr.GetTranslation("baglocked.SetPassFrame1.inputTextInfo2");
            addToContent(this._inputTextInfo1_2);
            this._inputTextInfo1_3 = ComponentFactory.Instance.creat("baglocked.text1_3");
            this._inputTextInfo1_3.text = LanguageMgr.GetTranslation("baglocked.SetPassFrame1.inputTextInfo3");
            addToContent(this._inputTextInfo1_3);
            this._inputTextInfo1_4 = ComponentFactory.Instance.creat("baglocked.text1_4");
            this._inputTextInfo1_4.text = LanguageMgr.GetTranslation("baglocked.SetPassFrame1.inputTextInfo2");
            addToContent(this._inputTextInfo1_4);
            this._inputTextInfo1_5 = ComponentFactory.Instance.creat("baglocked.text1_5");
            this._inputTextInfo1_5.text = LanguageMgr.GetTranslation("baglocked.SetPassFrame1.inputTextInfo4");
            addToContent(this._inputTextInfo1_5);
            this._textinput1 = ComponentFactory.Instance.creat("baglocked.textInput1");
            this._textinput1.textField.tabIndex = 0;
            addToContent(this._textinput1);
            this._textinput2 = ComponentFactory.Instance.creat("baglocked.textInput2");
            this._textinput2.textField.tabIndex = 1;
            addToContent(this._textinput2);
            this._nextBtn1 = ComponentFactory.Instance.creat("baglocked.nextBtn1");
            this._nextBtn1.text = LanguageMgr.GetTranslation("tank.view.bagII.baglocked.next");
            this._nextBtn1.enable = false;
            addToContent(this._nextBtn1);
            this.addEvent();
        }

        private function __frameEventHandler(_arg_1:FrameEvent):void
        {
            switch (_arg_1.responseCode)
            {
                case FrameEvent.ESC_CLICK:
                case FrameEvent.CLOSE_CLICK:
                    SoundManager.instance.play("008");
                    this._bagLockedController.bagLockedInfo = null;
                    this._bagLockedController.close();
                    return;
            };
        }

        private function __nextBtn1Click(_arg_1:MouseEvent):void
        {
            var _local_2:BagLockedInfo;
            SoundManager.instance.play("008");
            if (this._textinput1.text == this._textinput2.text)
            {
                _local_2 = new BagLockedInfo();
                this._bagLockedController.bagLockedInfo.psw = this._textinput1.text;
                this._bagLockedController.openSetPassFrame2();
                this._bagLockedController.closeSetPassFrame1();
            }
            else
            {
                MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.view.bagII.baglocked.diffrent"));
            };
        }

        private function __textChange(_arg_1:Event):void
        {
            if (((this._textinput1.textField.length >= 6) && (this._textinput2.textField.length >= 6)))
            {
                this._nextBtn1.enable = true;
            }
            else
            {
                this._nextBtn1.enable = false;
            };
        }

        private function addEvent():void
        {
            addEventListener(FrameEvent.RESPONSE, this.__frameEventHandler);
            this._textinput1.textField.addEventListener(Event.CHANGE, this.__textChange);
            this._textinput2.textField.addEventListener(Event.CHANGE, this.__textChange);
            this._textinput1.textField.addEventListener(KeyboardEvent.KEY_DOWN, this.__onTextEnter);
            this._textinput2.textField.addEventListener(KeyboardEvent.KEY_DOWN, this.__onTextEnter);
            this._nextBtn1.addEventListener(MouseEvent.CLICK, this.__nextBtn1Click);
        }

        private function remvoeEvent():void
        {
            removeEventListener(FrameEvent.RESPONSE, this.__frameEventHandler);
            this._textinput1.textField.removeEventListener(Event.CHANGE, this.__textChange);
            this._textinput2.textField.removeEventListener(Event.CHANGE, this.__textChange);
            this._textinput1.textField.removeEventListener(KeyboardEvent.KEY_DOWN, this.__onTextEnter);
            this._textinput2.textField.removeEventListener(KeyboardEvent.KEY_DOWN, this.__onTextEnter);
            this._nextBtn1.removeEventListener(MouseEvent.CLICK, this.__nextBtn1Click);
        }


    }
}//package baglocked

