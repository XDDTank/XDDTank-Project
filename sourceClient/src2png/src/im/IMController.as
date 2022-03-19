// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//im.IMController

package im
{
    import flash.events.EventDispatcher;
    import __AS3__.vec.Vector;
    import im.info.PresentRecordInfo;
    import ddt.data.player.PlayerInfo;
    import flash.utils.Dictionary;
    import com.pickgliss.ui.controls.alert.BaseAlerFrame;
    import com.pickgliss.loader.DisplayLoader;
    import flash.display.Bitmap;
    import im.info.CustomInfo;
    import flash.utils.Timer;
    import im.chatFrame.PrivateChatFrame;
    import im.messagebox.MessageBox;
    import ddt.manager.PlayerManager;
    import ddt.manager.SocketManager;
    import ddt.events.CrazyTankSocketEvent;
    import ddt.manager.PathManager;
    import road7th.comm.PackageIn;
    import ddt.manager.MessageTipManager;
    import ddt.manager.LanguageMgr;
    import ddt.manager.SoundManager;
    import flash.events.TimerEvent;
    import flash.events.Event;
    import ddt.utils.FilterWordManager;
    import com.pickgliss.ui.ComponentFactory;
    import ddt.events.PlayerPropertyEvent;
    import com.pickgliss.ui.LayerManager;
    import com.pickgliss.toplevel.StageReferance;
    import ddt.manager.SharedManager;
    import flash.geom.Point;
    import flash.display.DisplayObject;
    import com.pickgliss.loader.UIModuleLoader;
    import com.pickgliss.events.UIModuleEvent;
    import ddt.view.UIModuleSmallLoading;
    import ddt.data.UIModuleTypes;
    import com.pickgliss.loader.LoadResourceManager;
    import com.pickgliss.loader.BaseLoader;
    import com.pickgliss.loader.BitmapLoader;
    import ddt.manager.ChatManager;
    import com.pickgliss.events.FrameEvent;
    import ddt.data.InviteInfo;
    import ddt.manager.InviteManager;
    import game.GameManager;
    import flash.display.InteractiveObject;
    import invite.ResponseInviteFrame;
    import flash.text.TextField;
    import flash.text.TextFieldType;
    import ddt.bagStore.BagStore;
    import ddt.manager.StateManager;
    import ddt.states.StateType;
    import com.pickgliss.ui.AlertManager;
    import road7th.data.DictionaryData;
    import flash.net.URLVariables;
    import road7th.utils.StringHelper;
    import ddt.utils.RequestVairableCreater;
    import ddt.data.analyze.LoadCMFriendList;
    import com.pickgliss.loader.LoaderEvent;
    import ddt.data.CMFriendInfo;
    import ddt.data.analyze.RecentContactsAnalyze;
    import ddt.data.player.FriendListPlayer;
    import consortion.ConsortionModelControl;
    import ddt.data.player.ConsortiaPlayerInfo;
    import ddt.data.player.SelfInfo;
    import __AS3__.vec.*;

    public class IMController extends EventDispatcher 
    {

        public static const HAS_NEW_MESSAGE:String = "hasNewMessage";
        public static const NO_MESSAGE:String = "nomessage";
        public static const ALERT_MESSAGE:String = "alertMessage";
        public static const MAX_MESSAGE_IN_BOX:int = 10;
        private static var _instance:IMController;

        private var _existChat:Vector.<PresentRecordInfo>;
        private var _imview:IMView;
        private var _currentPlayer:PlayerInfo;
        private var _panels:Dictionary;
        private var _name:String;
        private var _baseAlerFrame:BaseAlerFrame;
        private var _isShow:Boolean;
        private var _recentContactsList:Array;
        private var _isLoadRecentContacts:Boolean;
        private var _titleType:int;
        private var _loader:DisplayLoader;
        private var _icon:Bitmap;
        public var isLoadComplete:Boolean = false;
        public var privateChatFocus:Boolean;
        public var changeID:int;
        public var cancelflashState:Boolean;
        public var customInfo:CustomInfo;
        public var deleteCustomID:int;
        private var _talkTimer:Timer = new Timer(1000);
        private var _privateFrame:PrivateChatFrame;
        private var _lastId:int;
        private var _changeInfo:PlayerInfo;
        private var _messageBox:MessageBox;
        private var _timer:Timer;
        private var _groupFrame:FriendGroupFrame;
        private var _tempLock:Boolean;
        private var _id:int;
        private var _groupId:int;
        private var _groupName:String;
        private var _isAddCMFriend:Boolean = true;
        private var _deleteRecentContact:int;
        private var _likeFriendList:Array;

        public function IMController()
        {
            this._existChat = new Vector.<PresentRecordInfo>();
        }

        public static function get Instance():IMController
        {
            if (_instance == null)
            {
                _instance = new (IMController)();
            };
            return (_instance);
        }


        public function setup():void
        {
            PlayerManager.Instance.addEventListener(IMEvent.ADDNEW_FRIEND, this.__addNewFriend);
            SocketManager.Instance.addEventListener(CrazyTankSocketEvent.GAME_INVITE, this.__receiveInvite);
            SocketManager.Instance.addEventListener(CrazyTankSocketEvent.FRIEND_RESPONSE, this.__friendResponse);
            SocketManager.Instance.addEventListener(CrazyTankSocketEvent.ONE_ON_ONE_TALK, this.__privateTalkHandler);
            SocketManager.Instance.addEventListener(CrazyTankSocketEvent.ADD_CUSTOM_FRIENDS, this.__addCustomHandler);
            if (PathManager.CommunityExist())
            {
                this.loadIcon();
            };
        }

        protected function __addCustomHandler(_arg_1:CrazyTankSocketEvent):void
        {
            var _local_7:int;
            var _local_8:int;
            var _local_2:PackageIn = _arg_1.pkg;
            var _local_3:int = _local_2.readByte();
            var _local_4:Boolean = _local_2.readBoolean();
            var _local_5:int = _local_2.readInt();
            var _local_6:String = _local_2.readUTF();
            switch (_local_3)
            {
                case 1:
                    if (_local_4)
                    {
                        MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("IM.addCustom.success", _local_6));
                        this.customInfo = new CustomInfo();
                        this.customInfo.ID = _local_5;
                        this.customInfo.Name = _local_6;
                        dispatchEvent(new IMEvent(IMEvent.ADD_NEW_GROUP));
                    }
                    else
                    {
                        MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("IM.addCustom.fail", _local_6));
                    };
                    return;
                case 2:
                    if (_local_4)
                    {
                        MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("IM.deleteCustom.success", _local_6));
                        PlayerManager.Instance.deleteCustomGroup(_local_5);
                        _local_7 = 0;
                        while (_local_7 < PlayerManager.Instance.customList.length)
                        {
                            if (PlayerManager.Instance.customList[_local_7].ID == _local_5)
                            {
                                PlayerManager.Instance.customList.splice(_local_7, 1);
                                break;
                            };
                            _local_7++;
                        };
                        this.deleteCustomID = _local_5;
                        dispatchEvent(new IMEvent(IMEvent.DELETE_GROUP));
                    }
                    else
                    {
                        MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("IM.deleteCustom.fail", _local_6));
                    };
                    return;
                case 3:
                    if (_local_4)
                    {
                        MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("IM.alertCustom.success"));
                        this.customInfo = new CustomInfo();
                        this.customInfo.ID = _local_5;
                        this.customInfo.Name = _local_6;
                        _local_8 = 0;
                        while (_local_8 < PlayerManager.Instance.customList.length)
                        {
                            if (PlayerManager.Instance.customList[_local_8].ID == _local_5)
                            {
                                PlayerManager.Instance.customList[_local_8].Name = _local_6;
                                break;
                            };
                            _local_8++;
                        };
                        dispatchEvent(new IMEvent(IMEvent.UPDATE_GROUP));
                    }
                    else
                    {
                        MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("IM.alertCustom.fail"));
                    };
                    return;
            };
        }

        public function checkHasNew(_arg_1:int):Boolean
        {
            var _local_2:int;
            while (_local_2 < this._existChat.length)
            {
                if (((_arg_1 == this._existChat[_local_2].id) && (this._existChat[_local_2].exist == PresentRecordInfo.UNREAD)))
                {
                    return (true);
                };
                _local_2++;
            };
            return (false);
        }

        private function __privateTalkHandler(_arg_1:CrazyTankSocketEvent):void
        {
            var _local_8:PresentRecordInfo;
            var _local_10:int;
            var _local_2:PackageIn = _arg_1.pkg;
            var _local_3:int = _local_2.readInt();
            var _local_4:String = _local_2.readUTF();
            var _local_5:Date = _local_2.readDate();
            var _local_6:String = _local_2.readUTF();
            var _local_7:Boolean = _local_2.readBoolean();
            var _local_9:int;
            while (_local_9 < this._existChat.length)
            {
                if (this._existChat[_local_9].id == _local_3)
                {
                    _local_8 = this._existChat[_local_9];
                    _local_8.addMessage(_local_4, _local_5, _local_6);
                    if (_local_4 != PlayerManager.Instance.Self.NickName)
                    {
                        if (((!(this._talkTimer.running)) && (!(this._privateFrame == null))))
                        {
                            SoundManager.instance.play("200");
                            this._talkTimer.start();
                            this._talkTimer.addEventListener(TimerEvent.TIMER, this.__stopTalkTime);
                        };
                        this._existChat.splice(_local_9, 1);
                        this._existChat.unshift(_local_8);
                    };
                    break;
                };
                _local_9++;
            };
            if (_local_8 == null)
            {
                _local_8 = new PresentRecordInfo();
                _local_8.id = _local_3;
                _local_8.addMessage(_local_4, _local_5, _local_6);
                this._existChat.unshift(_local_8);
            };
            this.saveInShared(_local_8);
            this.getMessage();
            this.saveRecentContactsID(_local_8.id);
            if ((((!(this._privateFrame == null)) && (this._privateFrame.parent)) && (this._privateFrame.playerInfo.ID == _local_3)))
            {
                _local_10 = 0;
                while (_local_10 < this._existChat.length)
                {
                    if (this._existChat[_local_10].id == _local_3)
                    {
                        this._privateFrame.addMessage(this._existChat[_local_10].lastMessage);
                        this._existChat[_local_10].exist = PresentRecordInfo.SHOW;
                        break;
                    };
                    _local_10++;
                };
            }
            else
            {
                this.setExist(_local_3, PresentRecordInfo.UNREAD);
                this.changeID = _local_3;
                this.cancelflashState = false;
                dispatchEvent(new Event(HAS_NEW_MESSAGE));
            };
            if ((((!(PlayerManager.Instance.Self.playerState.AutoReply == "")) && (!(_local_4 == PlayerManager.Instance.Self.NickName))) && (!(_local_7))))
            {
                SocketManager.Instance.out.sendOneOnOneTalk(_local_3, FilterWordManager.filterWrod(PlayerManager.Instance.Self.playerState.AutoReply), true);
            };
        }

        private function __stopTalkTime(_arg_1:TimerEvent):void
        {
            this._talkTimer.stop();
            this._talkTimer.removeEventListener(TimerEvent.TIMER, this.__stopTalkTime);
        }

        private function setExist(_arg_1:int, _arg_2:int):void
        {
            var _local_3:int;
            while (_local_3 < this._existChat.length)
            {
                if (this._existChat[_local_3].id == _arg_1)
                {
                    this._existChat[_local_3].exist = _arg_2;
                    return;
                };
                _local_3++;
            };
        }

        public function alertPrivateFrame(id:int=0):void
        {
            var messages:Vector.<String>;
            var tempInfo:PresentRecordInfo;
            if (this._privateFrame == null)
            {
                this._privateFrame = ComponentFactory.Instance.creatComponentByStylename("privateChatFrame");
            };
            if (((id == 0) && ((this._existChat.length == 0) || ((this._existChat.length == 1) && (this._privateFrame.parent)))))
            {
                return;
            };
            if (((!(id == 0)) && (this._lastId == id)))
            {
                return;
            };
            if (this._privateFrame.parent)
            {
                this.setExist(this._lastId, PresentRecordInfo.HIDE);
                this._privateFrame.parent.removeChild(this._privateFrame);
            };
            if (id != 0)
            {
                this._changeInfo = PlayerManager.Instance.findPlayer(id);
                this._lastId = id;
            }
            else
            {
                this._changeInfo = PlayerManager.Instance.findPlayer(this._existChat[0].id);
                this._lastId = this._existChat[0].id;
            };
            try
            {
                this._privateFrame.playerInfo = this._changeInfo;
            }
            catch(e:Error)
            {
                SocketManager.Instance.out.sendItemEquip(_changeInfo.ID, false);
                _changeInfo.addEventListener(PlayerPropertyEvent.PROPERTY_CHANGE, __IDChange);
            };
            var i:int;
            while (i < this._existChat.length)
            {
                if (this._existChat[i].id == this._lastId)
                {
                    this._existChat[i].exist = PresentRecordInfo.SHOW;
                    messages = this._existChat[i].messages;
                    this._privateFrame.addAllMessage(messages);
                    tempInfo = this._existChat[i];
                    this.changeID = this._existChat[i].id;
                    dispatchEvent(new Event(ALERT_MESSAGE));
                    this._existChat.splice(i, 1);
                    this._existChat.push(tempInfo);
                    break;
                };
                i = (i + 1);
            };
            if ((!(this.hasUnreadMessage())))
            {
                dispatchEvent(new Event(NO_MESSAGE));
            };
            this.getMessage();
            this.saveRecentContactsID(id);
            LayerManager.Instance.addToLayer(this._privateFrame, LayerManager.GAME_TOP_LAYER, true);
        }

        public function cancelFlash():void
        {
            this.cancelflashState = true;
            dispatchEvent(new Event(NO_MESSAGE));
        }

        public function hasUnreadMessage():Boolean
        {
            var _local_1:int;
            while (_local_1 < this._existChat.length)
            {
                if (this._existChat[_local_1].exist == PresentRecordInfo.UNREAD)
                {
                    return (true);
                };
                _local_1++;
            };
            return (false);
        }

        protected function __IDChange(_arg_1:PlayerPropertyEvent):void
        {
            this._changeInfo.removeEventListener(PlayerPropertyEvent.PROPERTY_CHANGE, this.__IDChange);
            this._privateFrame.playerInfo = this._changeInfo;
        }

        public function hidePrivateFrame(_arg_1:int):void
        {
            StageReferance.stage.focus = StageReferance.stage;
            var _local_2:int;
            while (_local_2 < this._existChat.length)
            {
                if (_arg_1 == this._existChat[_local_2].id) break;
                if (_local_2 == (this._existChat.length - 1))
                {
                    this.createPresentRecordInfo(_arg_1);
                };
                _local_2++;
            };
            if (this._existChat.length == 0)
            {
                this.createPresentRecordInfo(_arg_1);
            };
            this._lastId = 0;
            if (this._privateFrame.parent)
            {
                this._privateFrame.parent.removeChild(this._privateFrame);
            };
            this.setExist(_arg_1, PresentRecordInfo.HIDE);
        }

        private function createPresentRecordInfo(_arg_1:int):void
        {
            var _local_2:PresentRecordInfo;
            _local_2 = new PresentRecordInfo();
            _local_2.id = _arg_1;
            _local_2.exist = PresentRecordInfo.HIDE;
            this._existChat.push(_local_2);
        }

        public function disposePrivateFrame(_arg_1:int):void
        {
            StageReferance.stage.focus = StageReferance.stage;
            this._lastId = 0;
            if (this._privateFrame.parent)
            {
                this._privateFrame.parent.removeChild(this._privateFrame);
            };
            this.removePrivateMessage(_arg_1);
        }

        public function removePrivateMessage(_arg_1:int):void
        {
            var _local_2:int;
            while (_local_2 < this._existChat.length)
            {
                if (this._existChat[_local_2].id == _arg_1)
                {
                    this.changeID = _arg_1;
                    dispatchEvent(new Event(ALERT_MESSAGE));
                    this._existChat.splice(_local_2, 1);
                    break;
                };
                _local_2++;
            };
            if ((!(this.hasUnreadMessage())))
            {
                dispatchEvent(new Event(NO_MESSAGE));
            };
        }

        private function saveInShared(_arg_1:PresentRecordInfo):void
        {
            var _local_2:Vector.<Object>;
            if (SharedManager.Instance.privateChatRecord[_arg_1.id] == null)
            {
                SharedManager.Instance.privateChatRecord[_arg_1.id] = _arg_1.recordMessage;
            }
            else
            {
                _local_2 = SharedManager.Instance.privateChatRecord[_arg_1.id];
                if (_local_2 != _arg_1.recordMessage)
                {
                    _local_2.push(_arg_1.lastRecordMessage);
                };
                SharedManager.Instance.privateChatRecord[_arg_1.id] = _local_2;
            };
            SharedManager.Instance.save();
        }

        public function showMessageBox(_arg_1:DisplayObject):void
        {
            var _local_2:Point;
            if (this._messageBox == null)
            {
                this._messageBox = new MessageBox();
                this._timer = new Timer(200);
                this._timer.addEventListener(TimerEvent.TIMER, this.__timerHandler);
            };
            if (this.getMessage().length > 0)
            {
                LayerManager.Instance.addToLayer(this._messageBox, LayerManager.GAME_TOP_LAYER);
                _local_2 = _arg_1.localToGlobal(new Point(0, 0));
                this._messageBox.y = (_local_2.y - this._messageBox.height);
                this._messageBox.x = ((_local_2.x - (this._messageBox.width / 2)) + (_arg_1.width / 2));
                if ((this._messageBox.x + this._messageBox.width) > StageReferance.stageWidth)
                {
                    this._messageBox.x = ((StageReferance.stageWidth - this._messageBox.width) - 10);
                };
            };
            this._timer.stop();
        }

        public function getMessage():Vector.<PresentRecordInfo>
        {
            var _local_2:int;
            var _local_1:Vector.<PresentRecordInfo> = new Vector.<PresentRecordInfo>();
            if (this._messageBox)
            {
                _local_2 = 0;
                while (_local_2 < this._existChat.length)
                {
                    if (this._existChat[_local_2].exist != PresentRecordInfo.SHOW)
                    {
                        _local_1.push(this._existChat[_local_2]);
                    };
                    if (_local_1.length == MAX_MESSAGE_IN_BOX) break;
                    _local_2++;
                };
                this._messageBox.message = _local_1;
            };
            return (_local_1);
        }

        protected function __timerHandler(_arg_1:TimerEvent):void
        {
            if ((!(this._messageBox.overState)))
            {
                this._messageBox.parent.removeChild(this._messageBox);
                this._timer.stop();
            };
        }

        public function hideMessageBox():void
        {
            if ((((this._messageBox) && (this._messageBox.parent)) && (this._timer)))
            {
                this._timer.reset();
                this._timer.start();
            };
        }

        public function setupRecentContactsList():void
        {
            if ((!(this._recentContactsList)))
            {
                this._recentContactsList = [];
            };
            this._recentContactsList = SharedManager.Instance.recentContactsID[PlayerManager.Instance.Self.ID];
            this._isLoadRecentContacts = true;
        }

        public function switchVisible():void
        {
            UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_COMPLETE, this.__onUIModuleComplete);
            UIModuleSmallLoading.Instance.progress = 0;
            UIModuleSmallLoading.Instance.show();
            UIModuleSmallLoading.Instance.addEventListener(Event.CLOSE, this.__onClose);
            UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_PROGRESS, this.__onProgress);
            UIModuleLoader.Instance.addUIModuleImp(UIModuleTypes.IM);
        }

        public function get icon():Bitmap
        {
            return (this._loader.content as Bitmap);
        }

        private function loadIcon():void
        {
            this._loader = (LoadResourceManager.instance.creatAndStartLoad(PathManager.CommunityIcon(), BaseLoader.BITMAP_LOADER) as BitmapLoader);
        }

        private function __friendResponse(_arg_1:CrazyTankSocketEvent):void
        {
            var _local_6:String;
            var _local_2:int = _arg_1.pkg.clientId;
            var _local_3:int = _arg_1.pkg.readInt();
            var _local_4:String = _arg_1.pkg.readUTF();
            var _local_5:Boolean = _arg_1.pkg.readBoolean();
            if (_local_5)
            {
                _local_6 = LanguageMgr.GetTranslation("tank.view.im.IMController.sameCityfriend");
                _local_6 = _local_6.replace(/r/g, (("[" + _local_4) + "]"));
            }
            else
            {
                _local_6 = ((("[" + _local_4) + "]") + LanguageMgr.GetTranslation("tank.view.im.IMController.friend"));
            };
            ChatManager.Instance.sysChatYellow(_local_6);
        }

        private function __onProgress(_arg_1:UIModuleEvent):void
        {
            UIModuleSmallLoading.Instance.progress = (_arg_1.loader.progress * 100);
        }

        private function __onClose(_arg_1:Event):void
        {
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE, this.__onUIModuleComplete);
            UIModuleSmallLoading.Instance.hide();
            UIModuleSmallLoading.Instance.removeEventListener(Event.CLOSE, this.__onClose);
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_PROGRESS, this.__onProgress);
        }

        private function __addNewFriend(_arg_1:IMEvent):void
        {
            this._currentPlayer = (_arg_1.data as PlayerInfo);
        }

        private function privateChat():void
        {
            if (this._currentPlayer != null)
            {
                ChatManager.Instance.privateChatTo(this._currentPlayer.NickName, this._currentPlayer.ID);
            };
        }

        public function set isShow(_arg_1:Boolean):void
        {
            this._isShow = _arg_1;
        }

        private function hide():void
        {
            this._imview.dispose();
            this._imview = null;
        }

        private function show():void
        {
            this._imview = null;
            if (this._imview == null)
            {
                this._imview = ComponentFactory.Instance.creat("IMFrame");
                this._imview.addEventListener(FrameEvent.RESPONSE, this.__imviewEvent);
            };
            LayerManager.Instance.addToLayer(this._imview, LayerManager.GAME_DYNAMIC_LAYER, false);
        }

        private function __onUIModuleComplete(_arg_1:UIModuleEvent):void
        {
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE, this.__onUIModuleComplete);
            UIModuleSmallLoading.Instance.hide();
            if (_arg_1.module == UIModuleTypes.IM)
            {
                if (this._isLoadRecentContacts)
                {
                    PlayerManager.Instance.addEventListener(PlayerManager.RECENT_CONTAST_COMPLETE, this.__recentContactsComplete);
                    this.loadRecentContacts();
                }
                else
                {
                    if ((!(this.isLoadComplete)))
                    {
                        return;
                    };
                    if (this._isShow)
                    {
                        this.hide();
                    }
                    else
                    {
                        this.show();
                        this._isShow = true;
                        this._isLoadRecentContacts = false;
                    };
                };
            };
        }

        private function __recentContactsComplete(_arg_1:Event):void
        {
            PlayerManager.Instance.removeEventListener(PlayerManager.RECENT_CONTAST_COMPLETE, this.__recentContactsComplete);
            if ((!(this.isLoadComplete)))
            {
                return;
            };
            if (this._isShow)
            {
                this.hide();
            }
            else
            {
                this.show();
                this._isShow = true;
                this._isLoadRecentContacts = false;
            };
        }

        private function __receiveInvite(_arg_1:CrazyTankSocketEvent):void
        {
            var _local_2:PackageIn;
            var _local_3:InviteInfo;
            if (((this.getInviteState()) && (InviteManager.Instance.enabled)))
            {
                if (PlayerManager.Instance.Self.Grade < 4)
                {
                    return;
                };
                if ((!(SharedManager.Instance.showInvateWindow)))
                {
                    return;
                };
                _local_2 = _arg_1.pkg;
                _local_3 = new InviteInfo();
                _local_3.playerid = _local_2.readInt();
                _local_3.roomid = _local_2.readInt();
                _local_3.mapid = _local_2.readInt();
                _local_3.secondType = _local_2.readByte();
                _local_3.gameMode = _local_2.readByte();
                _local_3.hardLevel = _local_2.readByte();
                _local_3.levelLimits = _local_2.readByte();
                _local_3.nickname = _local_2.readUTF();
                _local_3.IsVip = _local_2.readBoolean();
                _local_3.VIPLevel = _local_2.readInt();
                _local_3.RN = _local_2.readUTF();
                _local_3.password = _local_2.readUTF();
                _local_3.barrierNum = _local_2.readInt();
                _local_3.isOpenBoss = _local_2.readBoolean();
                if (((_local_3.gameMode > 2) && (PlayerManager.Instance.Self.Grade < GameManager.MinLevelDuplicate)))
                {
                    return;
                };
                this.startReceiveInvite(_local_3);
            };
        }

        private function startReceiveInvite(_arg_1:InviteInfo):void
        {
            SoundManager.instance.play("018");
            var _local_2:InteractiveObject = StageReferance.stage.focus;
            var _local_3:ResponseInviteFrame = ResponseInviteFrame.newInvite(_arg_1);
            _local_3.addEventListener(FrameEvent.RESPONSE, this.__onResponse);
            _local_3.show();
            if ((_local_2 is TextField))
            {
                if (TextField(_local_2).type == TextFieldType.INPUT)
                {
                    StageReferance.stage.focus = _local_2;
                };
            };
        }

        private function __onResponse(_arg_1:FrameEvent):void
        {
            var _local_2:* = _arg_1.currentTarget;
            _local_2.removeEventListener(FrameEvent.RESPONSE, this.__onResponse);
            if (_arg_1.responseCode == FrameEvent.ESC_CLICK)
            {
                SoundManager.instance.play("008");
                _local_2.close();
            };
        }

        private function getInviteState():Boolean
        {
            if ((!(SharedManager.Instance.showInvateWindow)))
            {
                return (false);
            };
            if (BagStore.instance.storeOpenAble)
            {
                return (false);
            };
            switch (StateManager.currentStateType)
            {
                case StateType.MAIN:
                case StateType.ROOM_LIST:
                case StateType.DUNGEON_LIST:
                    return (true);
                default:
                    return (false);
            };
        }

        public function set titleType(_arg_1:int):void
        {
            this._titleType = _arg_1;
        }

        public function get titleType():int
        {
            return (this._titleType);
        }

        public function addFriend(_arg_1:String):void
        {
            if (this.isMaxFriend())
            {
                return;
            };
            this._name = _arg_1;
            if ((!(this.checkFriendExist(this._name))))
            {
                this.alertGroupFrame(this._name);
            };
        }

        public function isMaxFriend():Boolean
        {
            var _local_1:int;
            if (PlayerManager.Instance.Self.IsVIP)
            {
                _local_1 = (PlayerManager.Instance.Self.VIPLevel + 2);
            };
            if (PlayerManager.Instance.friendList.length >= (200 + (_local_1 * 50)))
            {
                this._baseAlerFrame = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"), LanguageMgr.GetTranslation("tank.view.im.IMController.addFriend", (200 + (_local_1 * 50))), "", "", false, false, false, LayerManager.ALPHA_BLOCKGOUND);
                this._baseAlerFrame.addEventListener(FrameEvent.RESPONSE, this.__close);
                return (true);
            };
            return (false);
        }

        private function alertGroupFrame(_arg_1:String):void
        {
            if (this._groupFrame == null)
            {
                this._groupFrame = ComponentFactory.Instance.creatComponentByStylename("friendGroupFrame");
                this._groupFrame.nickName = _arg_1;
            };
            LayerManager.Instance.addToLayer(this._groupFrame, LayerManager.GAME_DYNAMIC_LAYER, true, LayerManager.BLCAK_BLOCKGOUND);
            this._tempLock = ChatManager.Instance.lock;
            StageReferance.stage.focus = this._groupFrame;
        }

        public function clearGroupFrame():void
        {
            this._groupFrame = null;
        }

        private function __close(_arg_1:FrameEvent):void
        {
            SoundManager.instance.play("008");
            if (this._baseAlerFrame)
            {
                this._baseAlerFrame.removeEventListener(FrameEvent.RESPONSE, this.__close);
                this._baseAlerFrame.dispose();
                this._baseAlerFrame = null;
            };
        }

        public function addBlackList(_arg_1:String):void
        {
            if (PlayerManager.Instance.blackList.length >= 100)
            {
                this._baseAlerFrame = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"), LanguageMgr.GetTranslation("tank.view.im.IMController.addBlackList"), "", "", false, false, false, LayerManager.ALPHA_BLOCKGOUND);
                this._baseAlerFrame.addEventListener(FrameEvent.RESPONSE, this.__closeII);
                return;
            };
            this._name = _arg_1;
            if ((!(this.checkBlackListExit(_arg_1))))
            {
                if (this._baseAlerFrame)
                {
                    this._baseAlerFrame.removeEventListener(FrameEvent.RESPONSE, this.__frameEventII);
                    this._baseAlerFrame.dispose();
                    this._baseAlerFrame = null;
                };
                this._baseAlerFrame = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"), LanguageMgr.GetTranslation("tank.view.im.IMController.issure"), LanguageMgr.GetTranslation("ok"), LanguageMgr.GetTranslation("cancel"), true, true, true);
                this._baseAlerFrame.addEventListener(FrameEvent.RESPONSE, this.__frameEvent);
                this._tempLock = ChatManager.Instance.lock;
            };
        }

        private function __closeII(_arg_1:FrameEvent):void
        {
            SoundManager.instance.play("008");
            if (this._baseAlerFrame)
            {
                this._baseAlerFrame.removeEventListener(FrameEvent.RESPONSE, this.__closeII);
                this._baseAlerFrame.dispose();
                this._baseAlerFrame = null;
            };
        }

        private function __frameEvent(_arg_1:FrameEvent):void
        {
            if (StateManager.currentStateType == StateType.MAIN)
            {
                ChatManager.Instance.lock = this._tempLock;
            };
            switch (_arg_1.responseCode)
            {
                case FrameEvent.SUBMIT_CLICK:
                case FrameEvent.ENTER_CLICK:
                    if (this._baseAlerFrame)
                    {
                        this._baseAlerFrame.removeEventListener(FrameEvent.RESPONSE, this.__frameEvent);
                        this._baseAlerFrame.dispose();
                        this._baseAlerFrame = null;
                    };
                    this.__addBlack();
                    return;
                case FrameEvent.CANCEL_CLICK:
                case FrameEvent.CLOSE_CLICK:
                case FrameEvent.ESC_CLICK:
                    if (this._baseAlerFrame)
                    {
                        this._baseAlerFrame.removeEventListener(FrameEvent.RESPONSE, this.__frameEvent);
                        this._baseAlerFrame.dispose();
                        this._baseAlerFrame = null;
                    };
                    return;
            };
        }

        private function __frameEventII(_arg_1:FrameEvent):void
        {
            SoundManager.instance.play("008");
            if (StateManager.currentStateType == StateType.MAIN)
            {
                ChatManager.Instance.lock = this._tempLock;
            };
            switch (_arg_1.responseCode)
            {
                case FrameEvent.SUBMIT_CLICK:
                case FrameEvent.ENTER_CLICK:
                    if (this._baseAlerFrame)
                    {
                        this._baseAlerFrame.removeEventListener(FrameEvent.RESPONSE, this.__frameEventII);
                        this._baseAlerFrame.dispose();
                        this._baseAlerFrame = null;
                    };
                    this.alertGroupFrame(this._name);
                    return;
                case FrameEvent.CANCEL_CLICK:
                case FrameEvent.CLOSE_CLICK:
                case FrameEvent.ESC_CLICK:
                    if (this._baseAlerFrame)
                    {
                        this._baseAlerFrame.removeEventListener(FrameEvent.RESPONSE, this.__frameEventII);
                        this._baseAlerFrame.dispose();
                        this._baseAlerFrame = null;
                    };
                    return;
            };
        }

        private function __addBlack():void
        {
            SoundManager.instance.play("008");
            SocketManager.Instance.out.sendAddFriend(this._name, 1);
            this._name = "";
        }

        private function __addFriend():void
        {
            SoundManager.instance.play("008");
            SocketManager.Instance.out.sendAddFriend(this._name, 0);
            this._name = "";
        }

        public function deleteFriend(_arg_1:int, _arg_2:Boolean=false):void
        {
            this._id = _arg_1;
            this.disposeAlert();
            if ((!(_arg_2)))
            {
                this._baseAlerFrame = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"), LanguageMgr.GetTranslation("tank.view.im.IMFriendItem.deleteFriend"), LanguageMgr.GetTranslation("ok"), LanguageMgr.GetTranslation("cancel"), true, true, true, LayerManager.ALPHA_BLOCKGOUND);
                this._baseAlerFrame.addEventListener(FrameEvent.RESPONSE, this.__frameEventIII);
            }
            else
            {
                this._baseAlerFrame = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"), LanguageMgr.GetTranslation("tank.view.im.IMBlackItem.sure"), LanguageMgr.GetTranslation("ok"), LanguageMgr.GetTranslation("cancel"), true, true, true, LayerManager.ALPHA_BLOCKGOUND);
                this._baseAlerFrame.addEventListener(FrameEvent.RESPONSE, this.__frameEventIII);
            };
        }

        public function deleteGroup(_arg_1:int, _arg_2:String):void
        {
            this._groupId = _arg_1;
            this._groupName = _arg_2;
            this.disposeAlert();
            this._baseAlerFrame = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"), LanguageMgr.GetTranslation("tank.view.im.IMGourp.sure", _arg_2), LanguageMgr.GetTranslation("ok"), LanguageMgr.GetTranslation("cancel"), true, true, true, LayerManager.ALPHA_BLOCKGOUND);
            this._baseAlerFrame.addEventListener(FrameEvent.RESPONSE, this.__deleteGroupEvent);
        }

        private function __deleteGroupEvent(_arg_1:FrameEvent):void
        {
            switch (_arg_1.responseCode)
            {
                case FrameEvent.SUBMIT_CLICK:
                case FrameEvent.ENTER_CLICK:
                    this.disposeAlert();
                    SocketManager.Instance.out.sendCustomFriends(2, this._groupId, this._groupName);
                    return;
                case FrameEvent.CANCEL_CLICK:
                case FrameEvent.CLOSE_CLICK:
                case FrameEvent.ESC_CLICK:
                    this.disposeAlert();
                    return;
            };
        }

        private function __frameEventIII(_arg_1:FrameEvent):void
        {
            switch (_arg_1.responseCode)
            {
                case FrameEvent.SUBMIT_CLICK:
                case FrameEvent.ENTER_CLICK:
                    this.disposeAlert();
                    SocketManager.Instance.out.sendDelFriend(this._id);
                    MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.view.im.IMController.success"));
                    this._id = -1;
                    return;
                case FrameEvent.CANCEL_CLICK:
                case FrameEvent.CLOSE_CLICK:
                case FrameEvent.ESC_CLICK:
                    this.disposeAlert();
                    return;
            };
        }

        private function disposeAlert():void
        {
            if (this._baseAlerFrame)
            {
                this._baseAlerFrame.removeEventListener(FrameEvent.RESPONSE, this.__frameEventIII);
                this._baseAlerFrame.dispose();
                this._baseAlerFrame = null;
            };
        }

        private function checkBlackListExit(_arg_1:String):Boolean
        {
            var _local_3:PlayerInfo;
            if (_arg_1 == PlayerManager.Instance.Self.NickName)
            {
                MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.view.im.IMController.cannot"));
                return (true);
            };
            var _local_2:DictionaryData = PlayerManager.Instance.blackList;
            for each (_local_3 in _local_2)
            {
                if (_local_3.NickName == _arg_1)
                {
                    MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.view.im.IMController.thisplayer"));
                    return (true);
                };
            };
            return (false);
        }

        private function checkFriendExist(_arg_1:String):Boolean
        {
            var _local_3:PlayerInfo;
            var _local_4:DictionaryData;
            var _local_5:PlayerInfo;
            if ((!(_arg_1)))
            {
                return (true);
            };
            if (_arg_1.toLowerCase() == PlayerManager.Instance.Self.NickName.toLowerCase())
            {
                MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.view.im.IMController.cannotAddSelfFriend"));
                return (true);
            };
            var _local_2:DictionaryData = PlayerManager.Instance.friendList;
            for each (_local_3 in _local_2)
            {
                if (_local_3.NickName == _arg_1)
                {
                    MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.view.im.IMController.chongfu"));
                    return (true);
                };
            };
            _local_4 = PlayerManager.Instance.blackList;
            for each (_local_5 in _local_4)
            {
                if (_local_5.NickName == _arg_1)
                {
                    this._name = _arg_1;
                    this._baseAlerFrame = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"), LanguageMgr.GetTranslation("tank.view.im.IMController.thisone"), LanguageMgr.GetTranslation("ok"), LanguageMgr.GetTranslation("cancel"), false, true, true, LayerManager.ALPHA_BLOCKGOUND);
                    this._baseAlerFrame.addEventListener(FrameEvent.RESPONSE, this.__frameEventII);
                    return (true);
                };
            };
            return (false);
        }

        public function isFriend(_arg_1:String):Boolean
        {
            var _local_3:PlayerInfo;
            var _local_2:DictionaryData = PlayerManager.Instance.friendList;
            for each (_local_3 in _local_2)
            {
                if (_local_3.NickName == _arg_1)
                {
                    return (true);
                };
            };
            return (false);
        }

        public function isBlackList(_arg_1:String):Boolean
        {
            var _local_3:PlayerInfo;
            var _local_2:DictionaryData = PlayerManager.Instance.blackList;
            for each (_local_3 in _local_2)
            {
                if (_local_3.NickName == _arg_1)
                {
                    return (true);
                };
            };
            return (false);
        }

        private function __imviewEvent(_arg_1:FrameEvent):void
        {
            if (((_arg_1.responseCode == FrameEvent.CLOSE_CLICK) || (_arg_1.responseCode == FrameEvent.ESC_CLICK)))
            {
                SoundManager.instance.play("008");
                this.hide();
            };
        }

        public function createConsortiaLoader():void
        {
            var _local_1:URLVariables;
            var _local_2:BaseLoader;
            if ((!(StringHelper.isNullOrEmpty(PathManager.CommunityFriendList()))))
            {
                _local_1 = RequestVairableCreater.creatWidthKey(true);
                _local_1["uid"] = PlayerManager.Instance.Account.Account;
                _local_2 = LoadResourceManager.instance.createLoader(PathManager.CommunityFriendList(), BaseLoader.REQUEST_LOADER, _local_1);
                _local_2.analyzer = new LoadCMFriendList(this.setupCMFriendList);
                _local_2.addEventListener(LoaderEvent.LOAD_ERROR, this.__onLoadError);
                LoadResourceManager.instance.startLoad(_local_2);
            };
        }

        private function setupCMFriendList(_arg_1:LoadCMFriendList):void
        {
            dispatchEvent(new Event(Event.COMPLETE));
            if (((PlayerManager.Instance.Self.IsFirst == 1) && (this._isAddCMFriend)))
            {
                this.cmFriendAddToFriend();
            };
        }

        private function cmFriendAddToFriend():void
        {
            var _local_3:CMFriendInfo;
            this._isAddCMFriend = false;
            var _local_1:DictionaryData = PlayerManager.Instance.CMFriendList;
            var _local_2:DictionaryData = PlayerManager.Instance.friendList;
            for each (_local_3 in _local_1)
            {
                if (((_local_3.IsExist) && (!(_local_2[_local_3.UserId]))))
                {
                    SocketManager.Instance.out.sendAddFriend(_local_3.NickName, 0, true);
                    _local_1.remove(_local_3.UserName);
                };
            };
        }

        private function __onLoadError(_arg_1:LoaderEvent):void
        {
        }

        public function loadRecentContacts():void
        {
            var _local_1:URLVariables = RequestVairableCreater.creatWidthKey(true);
            _local_1["id"] = PlayerManager.Instance.Self.ID;
            _local_1["recentContacts"] = this.getFullRecentContactsID();
            var _local_2:BaseLoader = LoadResourceManager.instance.createLoader(PathManager.solveRequestPath("IMRecentContactsList.ashx"), BaseLoader.REQUEST_LOADER, _local_1);
            _local_2.loadErrorMessage = LanguageMgr.GetTranslation("ddt.loader.LoadingBuddyListFailure");
            _local_2.analyzer = new RecentContactsAnalyze(PlayerManager.Instance.setupRecentContacts);
            _local_2.addEventListener(LoaderEvent.LOAD_ERROR, this.__onLoadError);
            LoadResourceManager.instance.startLoad(_local_2);
            this._isLoadRecentContacts = false;
        }

        public function get recentContactsList():Array
        {
            return (this._recentContactsList);
        }

        public function getFullRecentContactsID():String
        {
            var _local_2:int;
            var _local_1:String = "";
            for each (_local_2 in this._recentContactsList)
            {
                if (_local_2 != 0)
                {
                    _local_1 = (_local_1 + (String(_local_2) + ","));
                };
            };
            return (_local_1.substr(0, (_local_1.length - 1)));
        }

        public function saveRecentContactsID(_arg_1:int=0):void
        {
            if ((!(this._recentContactsList)))
            {
                this._recentContactsList = [];
            };
            if (_arg_1 == PlayerManager.Instance.Self.ID)
            {
                return;
            };
            if (this._recentContactsList.length < 20)
            {
                if (this.testIdentical(_arg_1) != -1)
                {
                    this._recentContactsList.splice(this.testIdentical(_arg_1), 1);
                };
                this._recentContactsList.unshift(_arg_1);
            }
            else
            {
                if (this.testIdentical(_arg_1) != -1)
                {
                    this._recentContactsList.splice(this.testIdentical(_arg_1), 1);
                }
                else
                {
                    this._recentContactsList.splice(-1, 1);
                };
                this._recentContactsList.unshift(_arg_1);
            };
            SharedManager.Instance.recentContactsID[String(PlayerManager.Instance.Self.ID)] = this._recentContactsList;
            SharedManager.Instance.save();
            this._isLoadRecentContacts = true;
        }

        public function deleteRecentContacts(_arg_1:int=0):void
        {
            if ((!(this._recentContactsList)))
            {
                return;
            };
            this._deleteRecentContact = _arg_1;
            if (this._baseAlerFrame)
            {
                this._baseAlerFrame.removeEventListener(FrameEvent.RESPONSE, this.__deleteRecentContact);
                this._baseAlerFrame.dispose();
                this._baseAlerFrame = null;
            };
            this._baseAlerFrame = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"), LanguageMgr.GetTranslation("im.IMController.deleteRecentContactsInfo"), LanguageMgr.GetTranslation("ok"), LanguageMgr.GetTranslation("cancel"), true, true, true, LayerManager.ALPHA_BLOCKGOUND);
            this._baseAlerFrame.addEventListener(FrameEvent.RESPONSE, this.__deleteRecentContact);
        }

        private function __deleteRecentContact(_arg_1:FrameEvent):void
        {
            switch (_arg_1.responseCode)
            {
                case FrameEvent.SUBMIT_CLICK:
                case FrameEvent.ENTER_CLICK:
                    if (this._baseAlerFrame)
                    {
                        this._baseAlerFrame.removeEventListener(FrameEvent.RESPONSE, this.__deleteRecentContact);
                        this._baseAlerFrame.dispose();
                        this._baseAlerFrame = null;
                    };
                    if (this.testIdentical(this._deleteRecentContact) != -1)
                    {
                        this._recentContactsList.splice(this.testIdentical(this._deleteRecentContact), 1);
                        if (this._deleteRecentContact != 0)
                        {
                            PlayerManager.Instance.deleteRecentContact(this._deleteRecentContact);
                        };
                    };
                    MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.view.im.IMController.success"));
                    SharedManager.Instance.recentContactsID[String(PlayerManager.Instance.Self.ID)] = this._recentContactsList;
                    SharedManager.Instance.save();
                    this._isLoadRecentContacts = true;
                    return;
                case FrameEvent.ESC_CLICK:
                case FrameEvent.CLOSE_CLICK:
                case FrameEvent.CANCEL_CLICK:
                    if (this._baseAlerFrame)
                    {
                        this._baseAlerFrame.removeEventListener(FrameEvent.RESPONSE, this.__deleteRecentContact);
                        this._baseAlerFrame.dispose();
                        this._baseAlerFrame = null;
                    };
                    return;
            };
        }

        public function testIdentical(_arg_1:int):int
        {
            var _local_2:int;
            if (this._recentContactsList)
            {
                _local_2 = 0;
                while (_local_2 < this._recentContactsList.length)
                {
                    if (this._recentContactsList[_local_2] == _arg_1)
                    {
                        return (_local_2);
                    };
                    _local_2++;
                };
            };
            return (-1);
        }

        public function getRecentContactsStranger():Array
        {
            var _local_2:FriendListPlayer;
            var _local_1:Array = [];
            for each (_local_2 in PlayerManager.Instance.recentContacts)
            {
                if (this.testAlikeName(_local_2.NickName))
                {
                    _local_1.push(_local_2);
                };
            };
            return (_local_1);
        }

        public function testAlikeName(_arg_1:String):Boolean
        {
            var _local_2:Array = [];
            _local_2 = PlayerManager.Instance.friendList.list;
            _local_2 = _local_2.concat(PlayerManager.Instance.blackList.list);
            _local_2 = _local_2.concat(ConsortionModelControl.Instance.model.memberList.list);
            var _local_3:int;
            while (_local_3 < _local_2.length)
            {
                if (((_local_2[_local_3] is FriendListPlayer) && ((_local_2[_local_3] as FriendListPlayer).NickName == _arg_1)))
                {
                    return (false);
                };
                if (((_local_2[_local_3] is ConsortiaPlayerInfo) && ((_local_2[_local_3] as ConsortiaPlayerInfo).NickName == _arg_1)))
                {
                    return (false);
                };
                _local_3++;
            };
            return (true);
        }

        public function sortAcademyPlayer(_arg_1:Array):Array
        {
            var _local_5:PlayerInfo;
            var _local_6:PlayerInfo;
            var _local_2:Array = [];
            var _local_3:SelfInfo = PlayerManager.Instance.Self;
            if (_local_3.getMasterOrApprentices().length <= 0)
            {
                return (_arg_1);
            };
            var _local_4:DictionaryData = _local_3.getMasterOrApprentices();
            if (_local_3.getMasterOrApprentices().length > 0)
            {
                for each (_local_5 in _arg_1)
                {
                    if (((_local_4[_local_5.ID]) && (!(_local_5.ID == _local_3.ID))))
                    {
                        if (_local_5.ID == _local_3.masterID)
                        {
                            _local_2.unshift(_local_5);
                        }
                        else
                        {
                            _local_2.push(_local_5);
                        };
                    };
                };
                for each (_local_6 in _local_2)
                {
                    _arg_1.splice(_arg_1.indexOf(_local_6), 1);
                };
            };
            return (_local_2.concat(_arg_1));
        }

        public function set likeFriendList(_arg_1:Array):void
        {
            this._likeFriendList = _arg_1;
        }

        public function get likeFriendList():Array
        {
            return (this._likeFriendList);
        }


    }
}//package im

