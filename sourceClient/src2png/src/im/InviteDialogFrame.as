// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//im.InviteDialogFrame

package im
{
    import com.pickgliss.ui.image.Scale9CornerImage;
    import com.pickgliss.ui.vo.AlertInfo;
    import ddt.manager.LanguageMgr;
    import com.pickgliss.ui.ComponentFactory;
    import ddt.manager.ServerManager;
    import flash.events.Event;
    import flash.ui.Keyboard;
    import ddt.manager.SoundManager;
    import flash.events.KeyboardEvent;
    import flash.net.URLRequest;
    import flash.net.URLVariables;
    import flash.net.URLLoader;
    import road7th.utils.StringHelper;
    import ddt.manager.PathManager;
    import ddt.utils.FilterWordManager;
    import ddt.manager.PlayerManager;
    import ddt.manager.MessageTipManager;
    import flash.events.IOErrorEvent;
    import com.pickgliss.ui.LayerManager;

    public class InviteDialogFrame extends AddFriendFrame 
    {

        private var _userName:String;
        private var _inviteCaption:String;
        private var _inputBG:Scale9CornerImage;
        private var _text:String;
        private var _initText:String;


        override protected function initContainer():void
        {
            _alertInfo = new AlertInfo();
            _alertInfo.title = LanguageMgr.GetTranslation("im.InviteDialogFrame.name");
            _alertInfo.showCancel = false;
            _alertInfo.submitLabel = LanguageMgr.GetTranslation("im.InviteDialogFrame.send");
            info = _alertInfo;
            this._inputBG = ComponentFactory.Instance.creatComponentByStylename("im.InviteDialogFrame.inputBg");
            addToContent(this._inputBG);
            _inputText = ComponentFactory.Instance.creat("IM.InviteDialogFrame.Textinput");
            _inputText.wordWrap = true;
            _inputText.maxChars = 50;
            this.setText(LanguageMgr.GetTranslation("IM.InviteDialogFrame.info", ServerManager.Instance.zoneName));
            _inputText.setSelection(_inputText.text.length, _inputText.text.length);
            addToContent(_inputText);
            _inputText.addEventListener(Event.CHANGE, this.__inputChange);
        }

        protected function __inputChange(_arg_1:Event):void
        {
            if (_inputText.text.length > 0)
            {
                this._text = _inputText.text;
            }
            else
            {
                this._text = this._initText;
            };
        }

        public function setInfo(_arg_1:String):void
        {
            this._userName = _arg_1;
        }

        public function setText(_arg_1:String=""):void
        {
            _inputText.text = _arg_1;
            this._initText = (this._text = _arg_1);
            _inputText.setSelection(_inputText.text.length, _inputText.text.length);
        }

        override protected function __fieldKeyDown(_arg_1:KeyboardEvent):void
        {
            if (_arg_1.keyCode == Keyboard.ENTER)
            {
                this.submit();
                SoundManager.instance.play("008");
            }
            else
            {
                if (_arg_1.keyCode == Keyboard.ESCAPE)
                {
                    hide();
                    SoundManager.instance.play("008");
                };
            };
            _arg_1.stopImmediatePropagation();
            _arg_1.stopPropagation();
        }

        override protected function submit():void
        {
            var _local_1:URLRequest;
            var _local_2:URLVariables;
            var _local_3:URLLoader;
            var _local_4:URLRequest;
            var _local_5:URLVariables;
            var _local_6:URLLoader;
            if ((!(StringHelper.isNullOrEmpty(PathManager.CommunityInvite()))))
            {
                if ((!(FilterWordManager.isGotForbiddenWords(this._text))))
                {
                    _local_1 = new URLRequest(PathManager.CommunityInvite());
                    _local_2 = new URLVariables();
                    _local_2["fuid"] = String(PlayerManager.Instance.Self.LoginName);
                    _local_2["fnick"] = PlayerManager.Instance.Self.NickName;
                    _local_2["tuid"] = this._userName;
                    _local_2["inviteCaption"] = this._text;
                    _local_2["rid"] = PlayerManager.Instance.Self.ID;
                    _local_2["serverid"] = String(ServerManager.Instance.AgentID);
                    _local_2["rnd"] = Math.random();
                    _local_1.data = _local_2;
                    _local_3 = new URLLoader(_local_1);
                    _local_3.load(_local_1);
                    MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("im.IMView.inviteInfo"));
                    _local_4 = new URLRequest(PathManager.solveRequestPath("LogInviteFriends.ashx"));
                    _local_5 = new URLVariables();
                    _local_5["Username"] = PlayerManager.Instance.Self.NickName;
                    _local_5["InviteUsername"] = this._userName;
                    _local_5["IsSucceed"] = false;
                    _local_4.data = _local_5;
                    _local_6 = new URLLoader(_local_4);
                    _local_6.load(_local_4);
                    _local_6.addEventListener(IOErrorEvent.IO_ERROR, this.onIOError);
                    this.dispose();
                }
                else
                {
                    MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("im.IMView.inviteInfo1"));
                };
            };
        }

        private function onIOError(_arg_1:IOErrorEvent):void
        {
        }

        public function show():void
        {
            LayerManager.Instance.addToLayer(this, LayerManager.GAME_DYNAMIC_LAYER, true, LayerManager.ALPHA_BLOCKGOUND);
        }

        override public function dispose():void
        {
            this._text = null;
            _inputText.removeEventListener(Event.CHANGE, this.__inputChange);
            if (this._inputBG)
            {
                this._inputBG.dispose();
            };
            this._inputBG = null;
            super.dispose();
        }


    }
}//package im

