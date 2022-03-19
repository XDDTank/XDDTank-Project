// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//roomList.PassInputFrame

package roomList
{
    import com.pickgliss.ui.controls.alert.BaseAlerFrame;
    import com.pickgliss.ui.core.Disposeable;
    import com.pickgliss.ui.controls.TextInput;
    import com.pickgliss.ui.text.FilterFrameText;
    import com.pickgliss.ui.vo.AlertInfo;
    import ddt.manager.LanguageMgr;
    import com.pickgliss.ui.ComponentFactory;
    import com.pickgliss.events.FrameEvent;
    import flash.events.Event;
    import flash.events.KeyboardEvent;
    import flash.ui.Keyboard;
    import ddt.manager.SoundManager;
    import ddt.manager.MessageTipManager;
    import ddt.manager.StateManager;
    import ddt.states.StateType;
    import ddt.manager.SocketManager;

    public class PassInputFrame extends BaseAlerFrame implements Disposeable 
    {

        private var _passInputText:TextInput;
        private var _explainText:FilterFrameText;
        private var _ID:int;

        public function PassInputFrame()
        {
            this.initContainer();
            this.initEvent();
        }

        private function initContainer():void
        {
            var _local_1:AlertInfo = new AlertInfo();
            _local_1.title = LanguageMgr.GetTranslation("AlertDialog.Info");
            info = _local_1;
            this._passInputText = ComponentFactory.Instance.creat("asset.ddtroomlist.passinputFrame.input");
            this._passInputText.text = "";
            this._passInputText.textField.restrict = "0-9A-Za-z";
            addToContent(this._passInputText);
            this._explainText = ComponentFactory.Instance.creatComponentByStylename("asset.ddtroomlist.passinputFrame.explain");
            this._explainText.text = LanguageMgr.GetTranslation("baglocked.SetPassFrame1.inputTextInfo1");
            addToContent(this._explainText);
        }

        private function initEvent():void
        {
            addEventListener(FrameEvent.RESPONSE, this.__frameEvent);
            addEventListener(Event.ADDED_TO_STAGE, this.__addStage);
            this._passInputText.addEventListener(Event.CHANGE, this.__input);
            this._passInputText.addEventListener(KeyboardEvent.KEY_DOWN, this.__KeyDown);
        }

        private function __KeyDown(_arg_1:KeyboardEvent):void
        {
            if (_arg_1.keyCode == Keyboard.ENTER)
            {
                this.submit();
            };
        }

        private function __addStage(_arg_1:Event):void
        {
            if (this._passInputText)
            {
                submitButtonEnable = false;
                this._passInputText.setFocus();
            };
        }

        private function __frameEvent(_arg_1:FrameEvent):void
        {
            switch (_arg_1.responseCode)
            {
                case FrameEvent.CANCEL_CLICK:
                case FrameEvent.CLOSE_CLICK:
                case FrameEvent.ESC_CLICK:
                    SoundManager.instance.play("008");
                    this.hide();
                    return;
                case FrameEvent.SUBMIT_CLICK:
                case FrameEvent.ENTER_CLICK:
                    this.submit();
                    return;
            };
        }

        private function submit():void
        {
            SoundManager.instance.play("008");
            if (this._passInputText.text == "")
            {
                MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.roomlist.RoomListIIPassInput.write"));
                return;
            };
            if (StateManager.currentStateType == StateType.ROOM_LIST)
            {
                SocketManager.Instance.out.sendGameLogin(1, -1, this._ID, this._passInputText.text);
            }
            else
            {
                if (StateManager.currentStateType == StateType.DUNGEON_LIST)
                {
                    SocketManager.Instance.out.sendGameLogin(2, -1, this._ID, this._passInputText.text);
                }
                else
                {
                    SocketManager.Instance.out.sendGameLogin(4, -1, this._ID, this._passInputText.text);
                };
            };
            this.hide();
        }

        public function get ID():int
        {
            return (this._ID);
        }

        public function set ID(_arg_1:int):void
        {
            this._ID = _arg_1;
        }

        private function hide():void
        {
            this.dispose();
        }

        private function __input(_arg_1:Event):void
        {
            if (this._passInputText.text != "")
            {
                submitButtonEnable = true;
            }
            else
            {
                submitButtonEnable = false;
            };
        }

        override public function dispose():void
        {
            super.dispose();
            this._passInputText.dispose();
            if (this.parent)
            {
                this.parent.removeChild(this);
            };
        }


    }
}//package roomList

