// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//ddt.view.chat.ChatPrivateFrame

package ddt.view.chat
{
    import com.pickgliss.ui.controls.alert.BaseAlerFrame;
    import com.pickgliss.ui.controls.ComboBox;
    import com.pickgliss.ui.controls.TextInput;
    import com.pickgliss.ui.text.FilterFrameText;
    import ddt.data.player.FriendListPlayer;
    import com.pickgliss.ui.ComponentFactory;
    import flash.events.Event;
    import ddt.manager.LanguageMgr;
    import com.pickgliss.ui.controls.list.VectorListModel;
    import ddt.manager.PlayerManager;
    import flash.events.MouseEvent;
    import com.pickgliss.events.InteractiveEvent;
    import flash.events.KeyboardEvent;
    import com.pickgliss.toplevel.StageReferance;
    import ddt.manager.SoundManager;
    import flash.ui.Keyboard;
    import com.pickgliss.events.FrameEvent;
    import ddt.manager.ChatManager;

    public class ChatPrivateFrame extends BaseAlerFrame 
    {

        private var _friendList:Array;
        private var _comBox:ComboBox;
        private var _textInput:TextInput;
        private var _textField:FilterFrameText;


        override protected function init():void
        {
            var _local_4:FriendListPlayer;
            super.init();
            this._comBox = ComponentFactory.Instance.creat("chat.FriendListCombo");
            this._comBox.addEventListener(Event.ADDED_TO_STAGE, this.__setFocus);
            this._textInput = ComponentFactory.Instance.creatComponentByStylename("chat.PrivateFrameComboTextInput");
            this._textField = ComponentFactory.Instance.creatComponentByStylename("chat.PrivateFrameComboText");
            var _local_1:FilterFrameText = ComponentFactory.Instance.creatComponentByStylename("chat.PrivateFrameText");
            _local_1.text = LanguageMgr.GetTranslation("tank.view.scenechatII.PrivateChatIIView.nick");
            var _local_2:VectorListModel = this._comBox.listPanel.vectorListModel;
            this._friendList = PlayerManager.Instance.onlineFriendList;
            this._comBox.snapItemHeight = (this._friendList.length < 4);
            this._comBox.selctedPropName = "text";
            this._comBox.beginChanges();
            var _local_3:uint;
            while (_local_3 < this._friendList.length)
            {
                _local_4 = (this._friendList[_local_3] as FriendListPlayer);
                _local_2.append(_local_4.NickName);
                _local_3++;
            };
            this._comBox.listPanel.list.updateListView();
            this._comBox.commitChanges();
            this._comBox.textField = this._textField;
            this._textField.maxChars = 15;
            this._comBox.button.addEventListener(MouseEvent.CLICK, this.__playSound);
            this._comBox.addEventListener(InteractiveEvent.STATE_CHANGED, this.__comChange);
            addToContent(_local_1);
            addToContent(this._comBox);
            addToContent(this._textInput);
            this._textInput.addEventListener(KeyboardEvent.KEY_DOWN, this.__keyDownHandler);
        }

        private function __setFocus(_arg_1:Event):void
        {
            this._comBox.removeEventListener(Event.ADDED_TO_STAGE, this.__setFocus);
            StageReferance.stage.focus = this._textInput;
        }

        private function __comChange(_arg_1:InteractiveEvent):void
        {
            SoundManager.instance.play("008");
            this._textInput.text = this._textField.text;
        }

        private function __keyDownHandler(_arg_1:KeyboardEvent):void
        {
            _arg_1.stopImmediatePropagation();
            if (_arg_1.keyCode == Keyboard.ENTER)
            {
                dispatchEvent(new FrameEvent(FrameEvent.ENTER_CLICK));
            };
        }

        private function __playSound(_arg_1:MouseEvent):void
        {
            SoundManager.instance.play("008");
        }

        override protected function addChildren():void
        {
            super.addChildren();
            setChildIndex(_container, (numChildren - 1));
        }

        public function get currentFriend():String
        {
            return (this._textInput.text);
        }

        override public function dispose():void
        {
            this._comBox.removeEventListener(Event.ADDED_TO_STAGE, this.__setFocus);
            if (ChatManager.Instance.input.inputField.privateChatName == "")
            {
                ChatManager.Instance.inputChannel = ChatInputView.CURRENT;
            };
            this._friendList = null;
            this._textInput.removeEventListener(KeyboardEvent.KEY_DOWN, this.__keyDownHandler);
            this._comBox.button.removeEventListener(MouseEvent.CLICK, this.__playSound);
            this._comBox.removeEventListener(InteractiveEvent.STATE_CHANGED, this.__comChange);
            this._comBox.dispose();
            this._comBox = null;
            this._textField = null;
            this._textInput = null;
            if (parent)
            {
                parent.removeChild(this);
            };
            super.dispose();
        }


    }
}//package ddt.view.chat

