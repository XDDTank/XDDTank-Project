// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//ddt.view.chat.ChatInputView

package ddt.view.chat
{
    import flash.display.Sprite;
    import flash.display.Bitmap;
    import com.pickgliss.ui.controls.BaseButton;
    import com.pickgliss.ui.image.ScaleFrameImage;
    import flash.geom.Point;
    import com.pickgliss.ui.controls.SimpleBitmapButton;
    import ddt.manager.ChatManager;
    import com.pickgliss.ui.ComponentFactory;
    import com.pickgliss.ui.vo.AlertInfo;
    import ddt.manager.LanguageMgr;
    import com.pickgliss.events.FrameEvent;
    import com.pickgliss.ui.LayerManager;
    import ddt.manager.SoundManager;
    import ddt.manager.MessageTipManager;
    import im.IMController;
    import flash.events.MouseEvent;
    import flash.events.Event;
    import ddt.manager.PlayerManager;
    import ddt.utils.Helpers;
    import flash.utils.getTimer;
    import ddt.utils.PositionUtils;

    public class ChatInputView extends Sprite 
    {

        public static const ADMIN_NOTICE:int = 8;
        public static const BIG_BUGLE:uint = 0;
        public static const CHURCH_CHAT:int = 9;
        public static const CONSORTIA:uint = 3;
        public static const CROSS_BUGLE:uint = 15;
        public static const CROSS_NOTICE:uint = 12;
        public static const CURRENT:uint = 5;
        public static const DEFENSE_TIP:int = 10;
        public static const DEFY_AFFICHE:uint = 11;
        public static const HOTSPRING_ROOM:uint = 13;
        public static const PRIVATE:uint = 2;
        public static const SMALL_BUGLE:uint = 1;
        public static const SYS_NOTICE:uint = 6;
        public static const SYS_TIP:uint = 7;
        public static const TEAM:uint = 4;
        public static const GM_NOTICE:uint = 14;
        public static const WORLDBOSS_ROOM:uint = 20;
        public static const ACTIVITY:uint = 30;
        public static const CONSORTIA_VIEW:uint = 21;

        private var _preChannel:int = -1;
        private var _bg:Bitmap;
        private var _bgI:Bitmap;
        private var _btnEnter:BaseButton;
        private var _channel:int = 0;
        private var _channelBtn:Sprite;
        private var _channelPanel:ChatChannelPanel;
        private var _channelState:ScaleFrameImage;
        private var _faceBtn:BaseButton;
        private var _facePanel:ChatFacePanel;
        private var _fastReplyBtn:BaseButton;
        private var _fastReplyPanel:ChatFastReplyPanel;
        private var _friendListBtn:BaseButton;
        private var _friendListPanel:ChatFriendListPanel;
        private var _inputField:ChatInputField;
        private var _lastRecentSendTime:int = -30000;
        private var _lastSendChatTime:int = -30000;
        private var _chatPrivateFrame:ChatPrivateFrame;
        private var _friendListPanelPos:Point;
        private var _fastReplyPanelPos:Point;
        private var _facePanelPos:Point;
        private var _facePanelPos2:Point;
        private var _channelPanelPos:Point;
        public var _imBtnInGame:SimpleBitmapButton;
        private var _faceBtnInGame:SimpleBitmapButton;
        private var _fastReplyBtnInGame:SimpleBitmapButton;
        private var channelII:uint;

        public function ChatInputView()
        {
            this.init();
            this.initEvent();
        }

        public function set enableGameState(_arg_1:Boolean):void
        {
            if (_arg_1)
            {
                this._facePanelPos2.x = (this._facePanelPos.x - 23);
                addChild(this._fastReplyBtnInGame);
                addChild(this._faceBtnInGame);
                addChild(this._imBtnInGame);
                if (this._faceBtn.parent)
                {
                    removeChild(this._faceBtn);
                };
                if (this._fastReplyBtn.parent)
                {
                    removeChild(this._fastReplyBtn);
                };
                if (this._friendListBtn.parent)
                {
                    removeChild(this._friendListBtn);
                };
            }
            else
            {
                this._facePanelPos2.x = this._facePanelPos.x;
                if (this._fastReplyBtnInGame.parent)
                {
                    removeChild(this._fastReplyBtnInGame);
                };
                if (this._faceBtnInGame.parent)
                {
                    removeChild(this._faceBtnInGame);
                };
                if (this._imBtnInGame.parent)
                {
                    removeChild(this._imBtnInGame);
                };
                addChild(this._faceBtn);
                addChild(this._fastReplyBtn);
                addChild(this._friendListBtn);
            };
        }

        public function savePreChannel():void
        {
            if (this._channel == TEAM)
            {
                this._preChannel = CURRENT;
            };
            this._preChannel = CURRENT;
        }

        public function revertChannel():void
        {
            if (this._preChannel != -1)
            {
                this.channel = this._preChannel;
                this._preChannel = -1;
            };
        }

        public function get fastReplyPanel():ChatFastReplyPanel
        {
            return (this._fastReplyPanel);
        }

        public function set channel(_arg_1:int):void
        {
            ChatManager.Instance.view.addChild(this);
            ChatManager.Instance.setFocus();
            if (this._channel == _arg_1)
            {
                return;
            };
            this._channel = _arg_1;
            this._channelState.setFrame((((this._channel == ChatInputView.WORLDBOSS_ROOM) || (this._channel == ChatInputView.CONSORTIA_VIEW)) ? (5 + 1) : (this._channel + 1)));
            this._inputField.channel = this._channel;
            if (this._channel == PRIVATE)
            {
                this._chatPrivateFrame = ComponentFactory.Instance.creatComponentByStylename("chat.PrivateFrame");
                this._chatPrivateFrame.info = new AlertInfo(LanguageMgr.GetTranslation("tank.view.scenechatII.PrivateChatIIView.privatename"), LanguageMgr.GetTranslation("ok"), LanguageMgr.GetTranslation("cancel"));
                this._chatPrivateFrame.addEventListener(FrameEvent.RESPONSE, this.__frameEventHandler);
                LayerManager.Instance.addToLayer(this._chatPrivateFrame, LayerManager.GAME_DYNAMIC_LAYER, true, LayerManager.ALPHA_BLOCKGOUND);
            };
        }

        private function __onCustomSetPrivateChatTo(_arg_1:ChatEvent):void
        {
            this._channel = int(_arg_1.data.channel);
            this._channelState.setFrame((this._channel + 1));
            this._inputField.channel = this._channel;
            ChatManager.Instance.setFocus();
            this.setPrivateChatTo(_arg_1.data.nickName);
        }

        private function __frameEventHandler(_arg_1:FrameEvent):void
        {
            var _local_2:String;
            SoundManager.instance.play("008");
            switch (_arg_1.responseCode)
            {
                case FrameEvent.SUBMIT_CLICK:
                case FrameEvent.ENTER_CLICK:
                    _local_2 = (_arg_1.currentTarget as ChatPrivateFrame).currentFriend;
                    if ((!(_local_2)))
                    {
                        MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.view.chat.SelectPlayerChatView.name"));
                        return;
                    };
                    this.setPrivateChatTo(_local_2);
                    break;
                case FrameEvent.ESC_CLICK:
                case FrameEvent.CLOSE_CLICK:
                case FrameEvent.CANCEL_CLICK:
                    this.channel = CURRENT;
                    break;
            };
            this._chatPrivateFrame.dispose();
            this._chatPrivateFrame = null;
            ChatManager.Instance.setFocus();
        }

        public function set faceEnabled(_arg_1:Boolean):void
        {
            this._faceBtn.enable = _arg_1;
            this._faceBtnInGame.enable = _arg_1;
        }

        public function getCurrentInputChannel():int
        {
            if (this._channel != CURRENT)
            {
                return (this._channel);
            };
            var _local_1:int = this._channel;
            switch (ChatManager.Instance.state)
            {
                case ChatManager.CHAT_WEDDINGROOM_STATE:
                    _local_1 = CHURCH_CHAT;
                    break;
                case ChatManager.CHAT_HOTSPRING_ROOM_VIEW:
                case ChatManager.CHAT_HOTSPRING_ROOM_GOLD_VIEW:
                case ChatManager.CHAT_LITTLEGAME:
                    _local_1 = HOTSPRING_ROOM;
                    break;
                case ChatManager.CHAT_ACADEMY_VIEW:
                    _local_1 = CURRENT;
                    break;
                case ChatManager.CHAT_WORLDBOS_ROOM:
                    _local_1 = WORLDBOSS_ROOM;
                    break;
                case ChatManager.CHAT_CONSORTIA_VIEW:
                    _local_1 = CONSORTIA_VIEW;
                    break;
                case ChatManager.CHAT_CONSORTIA_TRANSPORT_VIEW:
                    _local_1 = CURRENT;
                    break;
            };
            return (_local_1);
        }

        public function get inputField():ChatInputField
        {
            return (this._inputField);
        }

        public function sendCurrentText():void
        {
            this._inputField.sendCurrnetText();
        }

        public function setInputText(_arg_1:String):void
        {
            this._inputField.setInputText(_arg_1);
        }

        public function setPrivateChatTo(_arg_1:String, _arg_2:int=0, _arg_3:Object=null):void
        {
            if (this._friendListPanel.parent)
            {
                this._friendListPanel.parent.removeChild(this._friendListPanel);
            };
            this._channel = PRIVATE;
            this._channelState.setFrame((this._channel + 1));
            this._inputField.channel = this._channel;
            this._inputField.setPrivateChatName(_arg_1, _arg_2, _arg_3);
            if (ChatManager.Instance.visibleSwitchEnable)
            {
                ChatManager.Instance.view.addChild(this);
            };
        }

        public function hidePanel():void
        {
            if (this._channelPanel.parent)
            {
                this._channelPanel.parent.removeChild(this._channelPanel);
            };
            if (this._friendListPanel.parent)
            {
                this._friendListPanel.parent.removeChild(this._friendListPanel);
            };
            if (this._fastReplyPanel.parent)
            {
                this._fastReplyPanel.parent.removeChild(this._fastReplyPanel);
            };
            if (this._facePanel.parent)
            {
                this._facePanel.parent.removeChild(this._facePanel);
            };
        }

        public function showFastReplypanel():void
        {
            this._fastReplyPanel.setText();
        }

        private function __panelBtnClick(_arg_1:MouseEvent):void
        {
            SoundManager.instance.play("008");
            _arg_1.stopImmediatePropagation();
            switch (_arg_1.currentTarget)
            {
                case this._channelBtn:
                    this.showPanel(this._channelPanel, this._channelPanelPos);
                    return;
                case this._friendListBtn:
                    this.showPanel(this._friendListPanel, this._friendListPanelPos);
                    this._friendListPanel.refreshAllList();
                    return;
                case this._fastReplyBtn:
                case this._fastReplyBtnInGame:
                    this.showPanel(this._fastReplyPanel, this._fastReplyPanelPos);
                    return;
                case this._faceBtn:
                case this._faceBtnInGame:
                    this.showPanel(this._facePanel, this._facePanelPos2);
                    return;
                case this._imBtnInGame:
                    IMController.Instance.switchVisible();
                    return;
            };
        }

        private function showPanel(_arg_1:ChatBasePanel, _arg_2:Point):void
        {
            _arg_1.x = localToGlobal(new Point(_arg_2.x, _arg_2.y)).x;
            _arg_1.y = localToGlobal(new Point(_arg_2.x, _arg_2.y)).y;
            _arg_1.setVisible = true;
        }

        private function __onChannelSelected(_arg_1:ChatEvent):void
        {
            this.channel = int(_arg_1.data);
        }

        private function __onEnterClick(_arg_1:MouseEvent):void
        {
            SoundManager.instance.play("008");
            this.sendCurrentText();
            ChatManager.Instance.view.output.visible = true;
        }

        private function __onFaceSelect(_arg_1:Event):void
        {
            ChatManager.Instance.sendFace(this._facePanel.selected);
        }

        private function __onFastSelect(_arg_1:Event):void
        {
            this.setInputText(this._fastReplyPanel.selectedWrod);
            this.sendCurrentText();
        }

        private function __onInputTextChanged(_arg_1:ChatEvent):void
        {
            var _local_3:Boolean;
            var _local_2:ChatData = new ChatData();
            _local_2.channel = (this.channelII = this.getCurrentInputChannel());
            _local_2.msg = String(_arg_1.data);
            _local_2.sender = PlayerManager.Instance.Self.NickName;
            _local_2.senderID = PlayerManager.Instance.Self.ID;
            _local_2.receiver = this._inputField.privateChatName;
            _local_2.sender = ChatFormats.replaceUnacceptableChar(_local_2.sender);
            _local_2.receiver = ChatFormats.replaceUnacceptableChar(this._inputField.privateChatName);
            if (this.checkCanSendChannel(_local_2))
            {
                _local_3 = false;
                _local_3 = ((((_local_2.channel == CROSS_BUGLE) || (_local_2.channel == BIG_BUGLE)) || (_local_2.channel == SMALL_BUGLE)) || (this.checkCanSendTime()));
                if (_local_3)
                {
                    ChatManager.Instance.sendChat(_local_2);
                    if ((((!(_local_2.channel == BIG_BUGLE)) && (!(_local_2.channel == SMALL_BUGLE))) && (!(_local_2.channel == CROSS_BUGLE))))
                    {
                        _local_2.msg = Helpers.enCodeString(_local_2.msg);
                        ChatManager.Instance.chat(_local_2);
                    };
                };
            };
            ChatManager.Instance.output.currentOffset = 0;
        }

        private function checkCanSendChannel(_arg_1:ChatData):Boolean
        {
            if (((_arg_1.channel == ChatInputView.PRIVATE) && (_arg_1.receiver == PlayerManager.Instance.Self.NickName)))
            {
                MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.manager.ChatManagerII.cannot"));
                return (false);
            };
            if (((_arg_1.channel == ChatInputView.CONSORTIA) && (PlayerManager.Instance.Self.ConsortiaID == 0)))
            {
                MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.manager.ChatManagerII.you"));
                return (false);
            };
            if (_arg_1.channel == ChatInputView.TEAM)
            {
                if (((((((!(ChatManager.Instance.state == ChatManager.CHAT_ROOM_STATE)) && (!(ChatManager.Instance.state == ChatManager.CHAT_GAME_STATE))) && (!(ChatManager.Instance.state == ChatManager.CHAT_GAMEOVER_STATE))) && (!(ChatManager.Instance.state == ChatManager.CHAT_MULTI_SHOOT_GAME_STATE))) && (!(ChatManager.Instance.state == ChatManager.CHAT_DUNGEON_STATE))) && (!(ChatManager.Instance.state == ChatManager.CHAT_GAME_LOADING))))
                {
                    MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.manager.ChatManagerII.now"));
                    return (false);
                };
            };
            return (true);
        }

        private function checkCanSendTime():Boolean
        {
            if (((this.channelII == CHURCH_CHAT) || (this.channelII == CONSORTIA_VIEW)))
            {
                if ((getTimer() - this._lastSendChatTime) < 5000)
                {
                    ChatManager.Instance.sysChatRed(LanguageMgr.GetTranslation("tank.view.chat.ChatInput.time1"));
                    return (false);
                };
                this._lastSendChatTime = getTimer();
            }
            else
            {
                if ((getTimer() - this._lastSendChatTime) < 1000)
                {
                    ChatManager.Instance.sysChatRed(LanguageMgr.GetTranslation("tank.view.chat.ChatInput.time2"));
                    return (false);
                };
                this._lastSendChatTime = getTimer();
            };
            if (this._channel != CURRENT)
            {
                return (true);
            };
            if ((getTimer() - this._lastRecentSendTime) < 30000)
            {
                if (((((((((((((ChatManager.Instance.state == ChatManager.CHAT_WEDDINGLIST_STATE) || (ChatManager.Instance.state == ChatManager.CHAT_DUNGEONLIST_STATE)) || (ChatManager.Instance.state == ChatManager.CHAT_ROOMLIST_STATE)) || (ChatManager.Instance.state == ChatManager.CHAT_HALL_STATE)) || (ChatManager.Instance.state == ChatManager.CHAT_CIVIL_VIEW)) || (ChatManager.Instance.state == ChatManager.CHAT_TOFFLIST_VIEW)) || (ChatManager.Instance.state == ChatManager.CHAT_ACADEMY_VIEW)) || (ChatManager.Instance.state == ChatManager.CHAT_HOTSPRING_VIEW)) || (ChatManager.Instance.state == ChatManager.CHAT_LITTLEHALL)) || (ChatManager.Instance.state == ChatManager.CHAT_CONSORTIA_TRANSPORT_VIEW)) || (ChatManager.Instance.state == ChatManager.CHAT_FARM)) && (this._channel == CURRENT)))
                {
                    ChatManager.Instance.sysChatRed(LanguageMgr.GetTranslation("tank.view.chat.ChatInputView.channel"));
                    return (false);
                };
                this._lastRecentSendTime = getTimer();
            }
            else
            {
                this._lastRecentSendTime = getTimer();
            };
            return (true);
        }

        private function init():void
        {
            this._channelBtn = new Sprite();
            PositionUtils.setPos(this._channelBtn, "chat.channelBtn.pos");
            this._facePanelPos2 = new Point();
            this._bg = ComponentFactory.Instance.creatBitmap("asset.chat.InputBg");
            this._bgI = ComponentFactory.Instance.creatBitmap("asset.chat.InputBgI");
            this._channelState = ComponentFactory.Instance.creatComponentByStylename("chat.ChannelState");
            this._btnEnter = ComponentFactory.Instance.creatComponentByStylename("chat.InputEnterBtn");
            this._friendListBtn = ComponentFactory.Instance.creatComponentByStylename("chat.InputFriendListBtn");
            this._fastReplyBtn = ComponentFactory.Instance.creatComponentByStylename("chat.InputFastReplyBtn");
            this._faceBtn = ComponentFactory.Instance.creatComponentByStylename("chat.InputFaceBtn");
            this._faceBtnInGame = ComponentFactory.Instance.creatComponentByStylename("chat.InputFaceInGameBtn");
            this._fastReplyBtnInGame = ComponentFactory.Instance.creatComponentByStylename("chat.InputFastReplyInGameBtn");
            this._imBtnInGame = ComponentFactory.Instance.creatComponentByStylename("chat.InputIMBtn");
            this._inputField = ComponentFactory.Instance.creatCustomObject("chat.InputField");
            this._channelPanel = ComponentFactory.Instance.creatCustomObject("chat.ChannelPanel");
            this._channelPanelPos = ComponentFactory.Instance.creatCustomObject(("chat.ChannelPanelPosT" + this._channelPanel.btnLen));
            this._facePanel = ComponentFactory.Instance.creatCustomObject("chat.FacePanel");
            this._facePanelPos = ComponentFactory.Instance.creatCustomObject("chat.FacePanelPos");
            this._facePanelPos2.y = this._facePanelPos.y;
            this._fastReplyPanel = ComponentFactory.Instance.creatCustomObject("chat.FastReplyPanel");
            this._fastReplyPanelPos = ComponentFactory.Instance.creatCustomObject("chat.FastReplyPanelPos");
            this._friendListPanel = ComponentFactory.Instance.creatCustomObject("chat.FriendListPanel");
            this._friendListPanelPos = ComponentFactory.Instance.creatCustomObject("chat.FriendListPanelPos");
            this._btnEnter.tipData = LanguageMgr.GetTranslation("chat.Send");
            this._friendListBtn.tipData = LanguageMgr.GetTranslation("chat.FriendList");
            this._fastReplyBtnInGame.tipData = (this._fastReplyBtn.tipData = LanguageMgr.GetTranslation("chat.FastReply"));
            this._faceBtnInGame.tipData = (this._faceBtn.tipData = LanguageMgr.GetTranslation("chat.Expression"));
            this._imBtnInGame.tipData = LanguageMgr.GetTranslation("chat.Friend");
            this._channelState.setFrame(1);
            this._friendListPanel.setup(this.setPrivateChatTo, false);
            addChild(this._bg);
            addChild(this._bgI);
            addChild(this._btnEnter);
            addChild(this._friendListBtn);
            addChild(this._fastReplyBtn);
            addChild(this._faceBtn);
            addChild(this._inputField);
            addChild(this._channelBtn);
            this._channelState.buttonMode = true;
            this._channelBtn.addChild(this._channelState);
        }

        private function initEvent():void
        {
            this._channelBtn.buttonMode = true;
            this._channelPanel.addEventListener(ChatEvent.INPUT_CHANNEL_CHANNGED, this.__onChannelSelected);
            this._fastReplyPanel.addEventListener(Event.SELECT, this.__onFastSelect);
            this._facePanel.addEventListener(Event.SELECT, this.__onFaceSelect);
            this._channelBtn.addEventListener(MouseEvent.CLICK, this.__panelBtnClick);
            this._friendListBtn.addEventListener(MouseEvent.CLICK, this.__panelBtnClick);
            this._fastReplyBtn.addEventListener(MouseEvent.CLICK, this.__panelBtnClick);
            this._faceBtn.addEventListener(MouseEvent.CLICK, this.__panelBtnClick);
            this._faceBtnInGame.addEventListener(MouseEvent.CLICK, this.__panelBtnClick);
            this._fastReplyBtnInGame.addEventListener(MouseEvent.CLICK, this.__panelBtnClick);
            this._imBtnInGame.addEventListener(MouseEvent.CLICK, this.__panelBtnClick);
            this._inputField.addEventListener(ChatEvent.INPUT_CHANNEL_CHANNGED, this.__onChannelSelected);
            this._inputField.addEventListener(ChatEvent.INPUT_TEXT_CHANGED, this.__onInputTextChanged);
            this._inputField.addEventListener(ChatEvent.CUSTOM_SET_PRIVATE_CHAT_TO, this.__onCustomSetPrivateChatTo);
            this._btnEnter.addEventListener(MouseEvent.CLICK, this.__onEnterClick);
        }


    }
}//package ddt.view.chat

