// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//im.AddFriendFrame

package im
{
    import com.pickgliss.ui.controls.alert.BaseAlerFrame;
    import com.pickgliss.ui.core.Disposeable;
    import com.pickgliss.ui.text.FilterFrameText;
    import com.pickgliss.ui.vo.AlertInfo;
    import ddt.manager.LanguageMgr;
    import com.pickgliss.ui.ComponentFactory;
    import com.pickgliss.ui.image.Scale9CornerImage;
    import flash.events.Event;
    import com.pickgliss.events.FrameEvent;
    import flash.events.KeyboardEvent;
    import ddt.manager.ChatManager;
    import ddt.view.chat.ChatEvent;
    import flash.ui.Keyboard;
    import ddt.manager.SoundManager;
    import ddt.manager.MessageTipManager;

    public class AddFriendFrame extends BaseAlerFrame implements Disposeable 
    {

        public static const MAX_CHAES:int = 14;

        protected var _inputText:FilterFrameText;
        protected var _explainText:FilterFrameText;
        protected var _hintText:FilterFrameText;
        protected var _alertInfo:AlertInfo;
        protected var _name:String;

        public function AddFriendFrame()
        {
            this.initContainer();
            this.initEvent();
        }

        protected function initContainer():void
        {
            submitButtonStyle = "core.simplebt";
            this._alertInfo = new AlertInfo();
            this._alertInfo.title = LanguageMgr.GetTranslation("tank.view.im.AddFriendFrame.add");
            this._alertInfo.enterEnable = true;
            this._alertInfo.escEnable = true;
            this._alertInfo.submitEnabled = false;
            info = this._alertInfo;
            var _local_1:Scale9CornerImage = ComponentFactory.Instance.creatComponentByStylename("im.addFriendInputBG");
            addToContent(_local_1);
            this._inputText = ComponentFactory.Instance.creat("textinput");
            this._inputText.maxChars = MAX_CHAES;
            addToContent(this._inputText);
            this._explainText = ComponentFactory.Instance.creat("IM.TextStyle");
            this._explainText.text = LanguageMgr.GetTranslation("tank.view.im.AddFriendFrame.name");
            addToContent(this._explainText);
            this._hintText = ComponentFactory.Instance.creat("IM.TextStyleII");
            this._hintText.text = LanguageMgr.GetTranslation("tank.view.im.AddBlackListFrame.chat");
            addToContent(this._hintText);
            this._name = "";
        }

        private function initEvent():void
        {
            addEventListener(Event.ADDED_TO_STAGE, this.__setFocus);
            addEventListener(FrameEvent.RESPONSE, this.__frameEvent);
            this._inputText.addEventListener(KeyboardEvent.KEY_DOWN, this.__fieldKeyDown);
            this._inputText.addEventListener(Event.CHANGE, this.__inputTextChange);
            ChatManager.Instance.output.contentField.addEventListener(ChatEvent.NICKNAME_CLICK_TO_OUTSIDE, this.__onNameClick);
        }

        private function __inputTextChange(_arg_1:Event=null):void
        {
            if (this._inputText.text != "")
            {
                submitButtonEnable = true;
            }
            else
            {
                submitButtonEnable = false;
            };
            this._name = this._inputText.text;
        }

        private function __onNameClick(_arg_1:ChatEvent):void
        {
            this._inputText.text = String(_arg_1.data);
            this.__inputTextChange(null);
        }

        protected function __fieldKeyDown(_arg_1:KeyboardEvent):void
        {
            if (_arg_1.keyCode == Keyboard.ENTER)
            {
                if (((this._name == "") || (this._name == null)))
                {
                    return;
                };
                this.submit();
                SoundManager.instance.play("008");
            }
            else
            {
                if (_arg_1.keyCode == Keyboard.ESCAPE)
                {
                    this.hide();
                    SoundManager.instance.play("008");
                };
            };
            _arg_1.stopImmediatePropagation();
            _arg_1.stopPropagation();
        }

        private function __frameEvent(_arg_1:FrameEvent):void
        {
            switch (_arg_1.responseCode)
            {
                case FrameEvent.CANCEL_CLICK:
                case FrameEvent.CLOSE_CLICK:
                    this.hide();
                    SoundManager.instance.play("008");
                    return;
                case FrameEvent.SUBMIT_CLICK:
                case FrameEvent.ENTER_CLICK:
                    SoundManager.instance.play("008");
                    this.submit();
                    return;
            };
        }

        protected function submit():void
        {
            if (((this._name == "") || (this._name == null)))
            {
                MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("IMControl.addNullFriend"));
                return;
            };
            this.hide();
            IMController.Instance.addFriend(this._name);
        }

        protected function hide():void
        {
            this.dispose();
        }

        private function __setFocus(_arg_1:Event):void
        {
            IMView.IS_SHOW_SUB = true;
            this._inputText.setFocus();
        }

        override public function dispose():void
        {
            if (this._inputText)
            {
                this._inputText.removeEventListener(KeyboardEvent.KEY_DOWN, this.__fieldKeyDown);
            };
            ChatManager.Instance.output.contentField.removeEventListener(ChatEvent.NICKNAME_CLICK_TO_OUTSIDE, this.__onNameClick);
            super.dispose();
            removeEventListener(Event.ADDED_TO_STAGE, this.__setFocus);
            removeEventListener(FrameEvent.RESPONSE, this.__frameEvent);
            if (this._inputText)
            {
                this._inputText.dispose();
                this._inputText = null;
            };
            if (this._explainText)
            {
                this._explainText.dispose();
                this._explainText = null;
            };
            if (this._hintText)
            {
                this._hintText.dispose();
                this._hintText = null;
            };
            this._alertInfo = null;
            IMView.IS_SHOW_SUB = false;
        }


    }
}//package im

