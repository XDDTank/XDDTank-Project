// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//email.view.WritingView

package email.view
{
    import com.pickgliss.ui.controls.Frame;
    import email.data.EmailInfo;
    import ddt.view.chat.ChatFriendListPanel;
    import flash.display.MovieClip;
    import ddt.view.FriendDropListTarget;
    import com.pickgliss.ui.text.FilterFrameText;
    import com.pickgliss.ui.controls.list.DropList;
    import com.pickgliss.ui.controls.TextInput;
    import com.pickgliss.ui.text.TextArea;
    import com.pickgliss.ui.controls.TextButton;
    import com.pickgliss.ui.controls.alert.BaseAlerFrame;
    import ddt.manager.LanguageMgr;
    import com.pickgliss.ui.ComponentFactory;
    import com.pickgliss.ui.image.ScaleBitmapImage;
    import com.pickgliss.utils.ClassUtils;
    import ddt.utils.PositionUtils;
    import com.pickgliss.ui.image.Image;
    import flash.events.Event;
    import flash.events.FocusEvent;
    import com.pickgliss.toplevel.StageReferance;
    import flash.events.MouseEvent;
    import flash.events.TextEvent;
    import ddt.manager.SocketManager;
    import ddt.events.CrazyTankSocketEvent;
    import flash.events.KeyboardEvent;
    import com.pickgliss.events.FrameEvent;
    import ddt.manager.PlayerManager;
    import consortion.ConsortionModelControl;
    import road7th.utils.StringHelper;
    import ddt.utils.FilterWordManager;
    import ddt.manager.SoundManager;
    import com.pickgliss.ui.AlertManager;
    import com.pickgliss.ui.LayerManager;
    import email.manager.MailManager;
    import email.data.EmailState;
    import baglocked.BaglockedManager;
    import ddt.manager.MessageTipManager;
    import ddt.command.QuickBuyFrame;
    import ddt.data.EquipType;
    import flash.geom.Point;
    import flash.ui.Keyboard;
    import com.pickgliss.utils.ObjectUtils;

    public class WritingView extends Frame 
    {

        private var _selectInfo:EmailInfo;
        private var _titleIsManMade:Boolean = false;
        private var _friendList:ChatFriendListPanel;
        private var _writingViewBG:MovieClip;
        private var _receiver:FriendDropListTarget;
        private var _senderTip:FilterFrameText;
        private var _topicTip:FilterFrameText;
        private var _dropList:DropList;
        private var _topic:TextInput;
        private var _content:TextArea;
        private var _friendsBtn:TextButton;
        private var _moneyInput:TextInput;
        private var _sendBtn:TextButton;
        private var _cancelBtn:TextButton;
        private var _type:int;
        private var _confirmFrame:BaseAlerFrame;

        public function WritingView()
        {
            this.initView();
            this.addEvent();
        }

        private function initView():void
        {
            disposeChildren = true;
            titleText = LanguageMgr.GetTranslation("tank.view.emailII.writingView.titleTxt");
            var _local_1:ScaleBitmapImage = ComponentFactory.Instance.creatComponentByStylename("email.writeBG1");
            addToContent(_local_1);
            this._writingViewBG = ClassUtils.CreatInstance("asset.email.writeViewBg");
            PositionUtils.setPos(this._writingViewBG, "writingView.BGPos");
            addToContent(this._writingViewBG);
            var _local_2:Image = ComponentFactory.Instance.creatComponentByStylename("email.writeLine");
            addToContent(_local_2);
            this._senderTip = ComponentFactory.Instance.creatComponentByStylename("email.geterTipTxt");
            this._senderTip.text = LanguageMgr.GetTranslation("tank.view.emailII.readView.geterTip");
            addToContent(this._senderTip);
            this._topicTip = ComponentFactory.Instance.creatComponentByStylename("email.topicTipTxtII");
            this._topicTip.text = LanguageMgr.GetTranslation("tank.view.emailII.readView.topicTip");
            addToContent(this._topicTip);
            this._receiver = ComponentFactory.Instance.creat("email.receiverInput");
            addToContent(this._receiver);
            this._dropList = ComponentFactory.Instance.creatComponentByStylename("droplist.SimpleDropList");
            this._dropList.targetDisplay = this._receiver;
            this._dropList.x = this._receiver.x;
            this._dropList.y = (this._receiver.y + this._receiver.height);
            this._topic = ComponentFactory.Instance.creat("email.writeTopicInput");
            this._topic.textField.maxChars = 16;
            addToContent(this._topic);
            this._content = ComponentFactory.Instance.creatComponentByStylename("email.writeContent");
            this._content.textField.maxChars = 200;
            addToContent(this._content);
            this._friendsBtn = ComponentFactory.Instance.creat("email.friendsBtn");
            this._friendsBtn.text = LanguageMgr.GetTranslation("tank.view.emailII.writingView.friendlist");
            addToContent(this._friendsBtn);
            this._sendBtn = ComponentFactory.Instance.creat("email.sendBtn");
            this._sendBtn.text = LanguageMgr.GetTranslation("send");
            addToContent(this._sendBtn);
            this._cancelBtn = ComponentFactory.Instance.creat("email.cancelBtn");
            this._cancelBtn.text = LanguageMgr.GetTranslation("cancel");
            addToContent(this._cancelBtn);
            this._friendList = new ChatFriendListPanel();
            this._friendList.setup(this.selectName);
        }

        private function addEvent():void
        {
            this._receiver.addEventListener(Event.CHANGE, this.__onReceiverChange);
            this._receiver.addEventListener(FocusEvent.FOCUS_IN, this.__onReceiverChange);
            StageReferance.stage.addEventListener(MouseEvent.CLICK, this.__hideDropList);
            this._content.textField.addEventListener(Event.CHANGE, this.__sound);
            this._content.textField.addEventListener(TextEvent.TEXT_INPUT, this.__taInput);
            this._friendsBtn.addEventListener(MouseEvent.CLICK, this.__friendListView);
            this._sendBtn.addEventListener(MouseEvent.CLICK, this.__send);
            this._cancelBtn.addEventListener(MouseEvent.CLICK, this.__close);
            SocketManager.Instance.addEventListener(CrazyTankSocketEvent.SEND_EMAIL, this.__sendEmailBack);
            addEventListener(KeyboardEvent.KEY_DOWN, this.__StopEnter);
            addEventListener(Event.ADDED_TO_STAGE, this.addToStageListener);
            addEventListener(FrameEvent.RESPONSE, this.__frameClose);
        }

        private function __hideDropList(_arg_1:MouseEvent):void
        {
            if ((_arg_1.target is FriendDropListTarget))
            {
                return;
            };
            if (((this._dropList) && (this._dropList.parent)))
            {
                this._dropList.parent.removeChild(this._dropList);
            };
        }

        private function __onReceiverChange(_arg_1:Event):void
        {
            if (this._receiver.text == "")
            {
                this._dropList.dataList = null;
                return;
            };
            var _local_2:Array = PlayerManager.Instance.onlineFriendList.concat(PlayerManager.Instance.offlineFriendList).concat(ConsortionModelControl.Instance.model.onlineConsortiaMemberList).concat(ConsortionModelControl.Instance.model.offlineConsortiaMemberList);
            this._dropList.dataList = this.filterRepeatInArray(this.filterSearch(_local_2, this._receiver.text));
        }

        private function filterRepeatInArray(_arg_1:Array):Array
        {
            var _local_4:int;
            var _local_2:Array = new Array();
            var _local_3:int;
            while (_local_3 < _arg_1.length)
            {
                if (_local_3 == 0)
                {
                    _local_2.push(_arg_1[_local_3]);
                };
                _local_4 = 0;
                while (_local_4 < _local_2.length)
                {
                    if (_local_2[_local_4].NickName == _arg_1[_local_3].NickName) break;
                    if (_local_4 == (_local_2.length - 1))
                    {
                        _local_2.push(_arg_1[_local_3]);
                    };
                    _local_4++;
                };
                _local_3++;
            };
            return (_local_2);
        }

        private function filterSearch(_arg_1:Array, _arg_2:String):Array
        {
            var _local_3:Array = [];
            var _local_4:int;
            while (_local_4 < _arg_1.length)
            {
                if (_arg_1[_local_4].NickName.indexOf(_arg_2) != -1)
                {
                    _local_3.push(_arg_1[_local_4]);
                };
                _local_4++;
            };
            return (_local_3);
        }

        private function removeEvent():void
        {
            this._friendsBtn.removeEventListener(MouseEvent.CLICK, this.__friendListView);
            this._sendBtn.removeEventListener(MouseEvent.CLICK, this.__send);
            this._cancelBtn.removeEventListener(MouseEvent.CLICK, this.__close);
            SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.SEND_EMAIL, this.__sendEmailBack);
            removeEventListener(KeyboardEvent.KEY_DOWN, this.__StopEnter);
            removeEventListener(Event.ADDED_TO_STAGE, this.addToStageListener);
            removeEventListener(FrameEvent.RESPONSE, this.__frameClose);
        }

        public function set selectInfo(_arg_1:EmailInfo):void
        {
            this._selectInfo = _arg_1;
        }

        public function isHasWrite():Boolean
        {
            if ((!(StringHelper.isNullOrEmpty(FilterWordManager.filterWrod(this._receiver.text)))))
            {
                return (true);
            };
            if ((!(StringHelper.isNullOrEmpty(FilterWordManager.filterWrod(this._topic.text)))))
            {
                return (true);
            };
            if ((!(StringHelper.isNullOrEmpty(FilterWordManager.filterWrod(this._content.text)))))
            {
                return (true);
            };
            return (false);
        }

        private function selectName(_arg_1:String, _arg_2:int=0):void
        {
            this._receiver.text = _arg_1;
            this._friendList.setVisible = false;
        }

        public function reset():void
        {
            this._receiver.text = "";
            this._topic.text = "";
            this._content.text = "";
        }

        private function btnSound():void
        {
            SoundManager.instance.play("043");
        }

        public function closeWin():void
        {
            if (this.isHasWrite())
            {
                if (this._confirmFrame == null)
                {
                    this._confirmFrame = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("tank.view.emailII.WritingView.tip"), LanguageMgr.GetTranslation("tank.view.emailII.WritingView.isEdit"), LanguageMgr.GetTranslation("ok"), LanguageMgr.GetTranslation("cancel"), false, false, false, LayerManager.ALPHA_BLOCKGOUND);
                    this._confirmFrame.addEventListener(FrameEvent.RESPONSE, this.__confirmResponse);
                };
            }
            else
            {
                if (this._type == 0)
                {
                    this.okCancel();
                    dispatchEvent(new EmailEvent(EmailEvent.CLOSE_WRITING_FRAME));
                };
            };
        }

        public function okCancel():void
        {
            this.btnSound();
            this.reset();
            if (((this._friendList) && (this._friendList.parent)))
            {
                this._friendList.setVisible = false;
            };
            MailManager.Instance.changeState(EmailState.READ);
        }

        private function __send(_arg_1:MouseEvent):void
        {
            var _local_2:BaseAlerFrame;
            var _local_3:Object;
            var _local_4:Array;
            this.btnSound();
            if (PlayerManager.Instance.Self.bagLocked)
            {
                BaglockedManager.Instance.show();
                return;
            };
            if (FilterWordManager.IsNullorEmpty(this._receiver.text))
            {
                this._receiver.text = "";
                MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.view.emailII.WritingView.sender"));
            }
            else
            {
                if (this._receiver.text == PlayerManager.Instance.Self.NickName)
                {
                    this._receiver.text = "";
                    MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.view.emailII.WritingView.NickName"));
                }
                else
                {
                    if (FilterWordManager.IsNullorEmpty(this._topic.text))
                    {
                        MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.view.emailII.WritingView.topic"));
                    }
                    else
                    {
                        if (PlayerManager.Instance.Self.Gold < 100)
                        {
                            _local_2 = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"), LanguageMgr.GetTranslation("tank.view.GoldInadequate"), LanguageMgr.GetTranslation("ok"), LanguageMgr.GetTranslation("cancel"), false, false, false, LayerManager.BLCAK_BLOCKGOUND);
                            _local_2.moveEnable = false;
                            _local_2.addEventListener(FrameEvent.RESPONSE, this.__quickBuyResponse);
                        }
                        else
                        {
                            if (this._content.text.length > 200)
                            {
                                MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.view.emailII.WritingView.contentLength"));
                            }
                            else
                            {
                                _local_3 = new Object();
                                _local_3.NickName = this._receiver.text;
                                _local_3.Title = FilterWordManager.filterWrod(this._topic.text);
                                _local_3.Content = FilterWordManager.filterWrod(this._content.text);
                                _local_4 = [];
                                MailManager.Instance.sendEmail(_local_3);
                                MailManager.Instance.onSendAnnex(_local_4);
                                this._sendBtn.enable = false;
                            };
                        };
                    };
                };
            };
        }

        private function __quickBuyResponse(_arg_1:FrameEvent):void
        {
            var _local_3:QuickBuyFrame;
            SoundManager.instance.play("008");
            var _local_2:BaseAlerFrame = (_arg_1.currentTarget as BaseAlerFrame);
            _local_2.removeEventListener(FrameEvent.RESPONSE, this.__quickBuyResponse);
            _local_2.dispose();
            if (_local_2.parent)
            {
                _local_2.parent.removeChild(_local_2);
            };
            _local_2 = null;
            if (_arg_1.responseCode == FrameEvent.SUBMIT_CLICK)
            {
                _local_3 = ComponentFactory.Instance.creatComponentByStylename("ddtcore.QuickFrame");
                _local_3.itemID = EquipType.GOLD_BOX;
                _local_3.setTitleText(LanguageMgr.GetTranslation("tank.view.store.matte.goldQuickBuy"));
                LayerManager.Instance.addToLayer(_local_3, LayerManager.GAME_TOP_LAYER, true, LayerManager.BLCAK_BLOCKGOUND);
            };
        }

        private function __friendListView(_arg_1:MouseEvent):void
        {
            this.btnSound();
            var _local_2:Point = this._friendsBtn.localToGlobal(new Point(0, 0));
            this._friendList.x = (_local_2.x + this._friendsBtn.width);
            this._friendList.y = _local_2.y;
            this._friendList.setVisible = true;
        }

        private function __taInput(_arg_1:TextEvent):void
        {
            if (this._content.text.length > 300)
            {
                _arg_1.preventDefault();
            };
        }

        private function __sendEmailBack(_arg_1:CrazyTankSocketEvent):void
        {
            this._sendBtn.enable = true;
        }

        private function __StopEnter(_arg_1:KeyboardEvent):void
        {
            if (_arg_1.keyCode == Keyboard.ENTER)
            {
                _arg_1.stopImmediatePropagation();
            }
            else
            {
                if (_arg_1.keyCode == Keyboard.ESCAPE)
                {
                    _arg_1.stopImmediatePropagation();
                    SoundManager.instance.play("008");
                    this.closeWin();
                };
            };
        }

        private function addToStageListener(_arg_1:Event):void
        {
            this.reset();
            this._receiver.text = ((this._selectInfo) ? this._selectInfo.Sender : "");
            this._topic.text = "";
            this._content.text = "";
            if (stage)
            {
                stage.focus = this;
            };
        }

        private function __sound(_arg_1:Event):void
        {
            this._titleIsManMade = true;
        }

        private function __frameClose(_arg_1:FrameEvent):void
        {
            this.btnSound();
            this.closeWin();
        }

        private function __close(_arg_1:MouseEvent):void
        {
            this.btnSound();
            this.closeWin();
        }

        private function __confirmResponse(_arg_1:FrameEvent):void
        {
            SoundManager.instance.play("008");
            this._confirmFrame.removeEventListener(FrameEvent.RESPONSE, this.__confirmResponse);
            this._confirmFrame.dispose();
            this._confirmFrame = null;
            if (((_arg_1.responseCode == FrameEvent.SUBMIT_CLICK) || (_arg_1.responseCode == FrameEvent.ENTER_CLICK)))
            {
                if (this._type == 0)
                {
                    this.okCancel();
                };
                dispatchEvent(new EmailEvent(EmailEvent.CLOSE_WRITING_FRAME));
            };
        }

        public function set type(_arg_1:int):void
        {
            this._type = _arg_1;
        }

        public function get type():int
        {
            return (this._type);
        }

        public function setName(_arg_1:String):void
        {
            this._receiver.text = _arg_1;
        }

        override public function dispose():void
        {
            this.removeEvent();
            ObjectUtils.disposeObject(this._friendList);
            this._friendList = null;
            ObjectUtils.disposeObject(this._writingViewBG);
            this._writingViewBG = null;
            ObjectUtils.disposeObject(this._receiver);
            this._receiver = null;
            ObjectUtils.disposeObject(this._dropList);
            this._dropList = null;
            ObjectUtils.disposeObject(this._topic);
            this._topic = null;
            ObjectUtils.disposeObject(this._friendsBtn);
            this._friendsBtn = null;
            ObjectUtils.disposeObject(this._sendBtn);
            this._sendBtn = null;
            ObjectUtils.disposeObject(this._cancelBtn);
            this._cancelBtn = null;
            ObjectUtils.disposeObject(this._confirmFrame);
            this._confirmFrame = null;
            ObjectUtils.disposeObject(this._selectInfo);
            this._selectInfo = null;
            if (this._content)
            {
                ObjectUtils.disposeObject(this._content);
            };
            this._content = null;
            if (this._senderTip)
            {
                ObjectUtils.disposeObject(this._senderTip);
            };
            this._senderTip = null;
            if (this._topicTip)
            {
                ObjectUtils.disposeObject(this._topicTip);
            };
            this._topicTip = null;
            if (this.parent)
            {
                this.parent.removeChild(this);
            };
            super.dispose();
            dispatchEvent(new EmailEvent(EmailEvent.DISPOSED));
        }


    }
}//package email.view

