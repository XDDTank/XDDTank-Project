// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//ddt.manager.ChurchManager

package ddt.manager
{
    import flash.events.EventDispatcher;
    import ddt.view.common.church.ChurchDialogueUnmarried;
    import ddt.view.common.church.ChurchProposeFrame;
    import ddt.view.common.church.ChurchProposeResponseFrame;
    import ddt.view.common.church.ChurchMarryApplySuccess;
    import com.pickgliss.ui.controls.alert.BaseAlerFrame;
    import ddt.data.ChurchRoomInfo;
    import com.pickgliss.loader.BaseLoader;
    import church.view.weddingRoom.frame.WeddingRoomGiftFrameView;
    import ddt.view.common.church.ChurchDialogueAgreePropose;
    import ddt.view.common.church.ChurchDialogueRejectPropose;
    import church.events.WeddingRoomEvent;
    import com.pickgliss.loader.LoadResourceManager;
    import com.pickgliss.loader.LoaderEvent;
    import ddt.states.StateType;
    import ddt.view.UIModuleSmallLoading;
    import flash.events.Event;
    import ddt.events.CrazyTankSocketEvent;
    import com.pickgliss.ui.ComponentFactory;
    import com.pickgliss.manager.CacheSysManager;
    import ddt.constants.CacheConsts;
    import com.pickgliss.action.AlertAction;
    import com.pickgliss.ui.LayerManager;
    import ddt.view.chat.ChatData;
    import ddt.view.chat.ChatInputView;
    import ddt.action.FrameShowAction;
    import road7th.utils.StringHelper;
    import com.pickgliss.ui.AlertManager;
    import com.pickgliss.events.FrameEvent;
    import com.pickgliss.utils.ObjectUtils;
    import road7th.comm.PackageIn;
    import ddt.view.common.church.ChurchInviteFrame;
    import ddt.data.player.PlayerInfo;
    import baglocked.BaglockedManager;
    import ddt.data.player.BasePlayer;
    import com.pickgliss.loader.UIModuleLoader;
    import com.pickgliss.events.UIModuleEvent;

    public class ChurchManager extends EventDispatcher 
    {

        private static const WEDDING_SCENE:Boolean = false;
        private static const MOON_SCENE:Boolean = true;
        public static const CIVIL_PLAYER_INFO_MODIFY:String = "civilplayerinfomodify";
        public static const CIVIL_SELFINFO_CHANGE:String = "civilselfinfochange";
        public static const SUBMIT_REFUND:String = "submitRefund";
        private static var _instance:ChurchManager;

        private var _currentScene:Boolean = false;
        private var _churchDialogueUnmarried:ChurchDialogueUnmarried;
        private var _churchProposeFrame:ChurchProposeFrame;
        private var _proposeResposeFrame:ChurchProposeResponseFrame;
        private var _churchMarryApplySuccess:ChurchMarryApplySuccess;
        private var _alertMarried:BaseAlerFrame;
        public var _weddingSuccessfulComplete:Boolean;
        private var _resposeFrameCount:uint = 0;
        public var _selfRoom:ChurchRoomInfo;
        private var _currentRoom:ChurchRoomInfo;
        private var _mapLoader01:BaseLoader;
        private var _mapLoader02:BaseLoader;
        private var _isRemoveLoading:Boolean = true;
        private var _weddingRoomGiftFrameView:WeddingRoomGiftFrameView;
        private var marryApplyList:Array = new Array();
        private var _churchDialogueAgreePropose:ChurchDialogueAgreePropose;
        private var _churchDialogueRejectPropose:ChurchDialogueRejectPropose;
        private var _loadedCallBack:Function;
        private var _loadingModuleType:String;


        public static function get instance():ChurchManager
        {
            if ((!(_instance)))
            {
                _instance = new (ChurchManager)();
            };
            return (_instance);
        }


        public function get currentScene():Boolean
        {
            return (this._currentScene);
        }

        public function set currentScene(_arg_1:Boolean):void
        {
            if (this._currentScene == _arg_1)
            {
                return;
            };
            this._currentScene = _arg_1;
            dispatchEvent(new WeddingRoomEvent(WeddingRoomEvent.SCENE_CHANGE, this._currentScene));
        }

        public function get resposeFrameCount():uint
        {
            return (this._resposeFrameCount);
        }

        public function set resposeFrameCount(_arg_1:uint):void
        {
            this._resposeFrameCount = _arg_1;
        }

        public function get selfRoom():ChurchRoomInfo
        {
            return (this._selfRoom);
        }

        public function set selfRoom(_arg_1:ChurchRoomInfo):void
        {
            this._selfRoom = _arg_1;
        }

        public function set currentRoom(_arg_1:ChurchRoomInfo):void
        {
            if (this._currentRoom == _arg_1)
            {
                return;
            };
            this._currentRoom = _arg_1;
            this.onChurchRoomInfoChange();
        }

        public function get currentRoom():ChurchRoomInfo
        {
            return (this._currentRoom);
        }

        private function onChurchRoomInfoChange():void
        {
            if (this._currentRoom != null)
            {
                this.loadMap();
            };
        }

        public function loadMap():void
        {
            this._mapLoader01 = LoadResourceManager.instance.createLoader(PathManager.solveChurchSceneSourcePath("Map01"), BaseLoader.MODULE_LOADER);
            this._mapLoader01.addEventListener(LoaderEvent.COMPLETE, this.onMapSrcLoadedComplete);
            LoadResourceManager.instance.startLoad(this._mapLoader01);
            this._mapLoader02 = LoadResourceManager.instance.createLoader(PathManager.solveChurchSceneSourcePath("Map02"), BaseLoader.MODULE_LOADER);
            this._mapLoader02.addEventListener(LoaderEvent.COMPLETE, this.onMapSrcLoadedComplete);
            LoadResourceManager.instance.startLoad(this._mapLoader02);
        }

        protected function onMapSrcLoadedComplete(_arg_1:LoaderEvent=null):void
        {
            if (((this._mapLoader01.isSuccess) && (this._mapLoader02.isSuccess)))
            {
                this.tryLoginScene();
            };
        }

        public function tryLoginScene():void
        {
            if (StateManager.getState(StateType.CHURCH_ROOM) == null)
            {
                this._isRemoveLoading = false;
                UIModuleSmallLoading.Instance.addEventListener(Event.CLOSE, this.__loadingIsClose);
            };
            StateManager.setState(StateType.CHURCH_ROOM);
        }

        private function __loadingIsClose(_arg_1:Event):void
        {
            this._isRemoveLoading = true;
            UIModuleSmallLoading.Instance.removeEventListener(Event.CLOSE, this.__loadingIsClose);
            SocketManager.Instance.out.sendExitRoom();
        }

        public function removeLoadingEvent():void
        {
            if ((!(this._isRemoveLoading)))
            {
                UIModuleSmallLoading.Instance.removeEventListener(Event.CLOSE, this.__loadingIsClose);
            };
        }

        public function closeRefundView():void
        {
            if (this._weddingRoomGiftFrameView)
            {
                if (this._weddingRoomGiftFrameView.parent)
                {
                    this._weddingRoomGiftFrameView.parent.removeChild(this._weddingRoomGiftFrameView);
                };
                this._weddingRoomGiftFrameView.removeEventListener(Event.CLOSE, this.closeRoomGift);
                this._weddingRoomGiftFrameView.dispose();
                this._weddingRoomGiftFrameView = null;
            };
        }

        public function setup():void
        {
            SocketManager.Instance.addEventListener(CrazyTankSocketEvent.MARRY_ROOM_LOGIN, this.__roomLogin);
            SocketManager.Instance.addEventListener(CrazyTankSocketEvent.MARRY_ROOM_STATE, this.__updateSelfRoom);
            SocketManager.Instance.addEventListener(CrazyTankSocketEvent.PLAYER_EXIT_MARRY_ROOM, this.__removePlayer);
            SocketManager.Instance.addEventListener(CrazyTankSocketEvent.MARRY_STATUS, this.__showPropose);
            SocketManager.Instance.addEventListener(CrazyTankSocketEvent.MARRY_APPLY, this.__marryApply);
            SocketManager.Instance.addEventListener(CrazyTankSocketEvent.MARRY_APPLY_REPLY, this.__marryApplyReply);
            SocketManager.Instance.addEventListener(CrazyTankSocketEvent.DIVORCE_APPLY, this.__divorceApply);
            SocketManager.Instance.addEventListener(CrazyTankSocketEvent.INVITE, this.__churchInvite);
            SocketManager.Instance.addEventListener(CrazyTankSocketEvent.MARRYPROP_GET, this.__marryPropGet);
            SocketManager.Instance.addEventListener(CrazyTankSocketEvent.AMARRYINFO_REFRESH, this.__upCivilPlayerView);
            SocketManager.Instance.addEventListener(CrazyTankSocketEvent.MARRYINFO_GET, this.__getMarryInfo);
            SocketManager.Instance.addEventListener(CrazyTankSocketEvent.MARRYROOMSENDGIFT, this.__showGiftView);
            this.addEventListener(ChurchManager.SUBMIT_REFUND, this.__onSubmitRefund);
        }

        private function __onSubmitRefund(_arg_1:Event):void
        {
            SocketManager.Instance.out.refund();
        }

        private function __upCivilPlayerView(_arg_1:CrazyTankSocketEvent):void
        {
            PlayerManager.Instance.Self.MarryInfoID = _arg_1.pkg.readInt();
            var _local_2:Boolean = _arg_1.pkg.readBoolean();
            if (_local_2)
            {
                PlayerManager.Instance.Self.ID = _arg_1.pkg.readInt();
                PlayerManager.Instance.Self.IsPublishEquit = _arg_1.pkg.readBoolean();
                PlayerManager.Instance.Self.Introduction = _arg_1.pkg.readUTF();
            };
            dispatchEvent(new Event(CIVIL_PLAYER_INFO_MODIFY));
        }

        private function __getMarryInfo(_arg_1:CrazyTankSocketEvent):void
        {
            PlayerManager.Instance.Self.Introduction = _arg_1.pkg.readUTF();
            PlayerManager.Instance.Self.IsPublishEquit = _arg_1.pkg.readBoolean();
            dispatchEvent(new Event(CIVIL_SELFINFO_CHANGE));
        }

        public function __showPropose(_arg_1:CrazyTankSocketEvent):void
        {
            var _local_2:int = _arg_1.pkg.readInt();
            var _local_3:Boolean = _arg_1.pkg.readBoolean();
            if (_local_3)
            {
                MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.manager.PlayerManager.married"));
            }
            else
            {
                if (PlayerManager.Instance.Self.IsMarried)
                {
                    MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.manager.PlayerManager.youMarried"));
                }
                else
                {
                    this._churchProposeFrame = ComponentFactory.Instance.creat("common.church.ChurchProposeFrame");
                    this._churchProposeFrame.addEventListener(Event.CLOSE, this.churchProposeFrameClose);
                    this._churchProposeFrame.spouseID = _local_2;
                    this._churchProposeFrame.show();
                };
            };
        }

        private function __showGiftView(_arg_1:CrazyTankSocketEvent):void
        {
            _arg_1.pkg.readByte();
            var _local_2:int = _arg_1.pkg.readInt();
            if (this._weddingRoomGiftFrameView)
            {
                if (this._weddingRoomGiftFrameView.parent)
                {
                    this._weddingRoomGiftFrameView.parent.removeChild(this._weddingRoomGiftFrameView);
                };
                this._weddingRoomGiftFrameView.removeEventListener(Event.CLOSE, this.closeRoomGift);
                this._weddingRoomGiftFrameView.dispose();
                this._weddingRoomGiftFrameView = null;
            }
            else
            {
                this._weddingRoomGiftFrameView = ComponentFactory.Instance.creat("church.weddingRoom.frame.WeddingRoomGiftFrameView");
                this._weddingRoomGiftFrameView.addEventListener(Event.CLOSE, this.closeRoomGift);
                this._weddingRoomGiftFrameView.txtMoney = _local_2.toString();
                this._weddingRoomGiftFrameView.show();
            };
        }

        private function closeRoomGift(_arg_1:Event=null):void
        {
            if (this._weddingRoomGiftFrameView)
            {
                this._weddingRoomGiftFrameView.removeEventListener(Event.CLOSE, this.closeRoomGift);
                if (this._weddingRoomGiftFrameView.parent)
                {
                    this._weddingRoomGiftFrameView.parent.removeChild(this._weddingRoomGiftFrameView);
                };
                this._weddingRoomGiftFrameView.dispose();
            };
            this._weddingRoomGiftFrameView = null;
        }

        private function churchProposeFrameClose(_arg_1:Event):void
        {
            if (this._churchProposeFrame)
            {
                this._churchProposeFrame.removeEventListener(Event.CLOSE, this.churchProposeFrameClose);
                if (this._churchProposeFrame.parent)
                {
                    this._churchProposeFrame.parent.removeChild(this._churchProposeFrame);
                };
            };
            this._churchProposeFrame = null;
        }

        private function __marryApply(_arg_1:CrazyTankSocketEvent):void
        {
            var _local_2:int = _arg_1.pkg.readInt();
            var _local_3:String = _arg_1.pkg.readUTF();
            var _local_4:String = _arg_1.pkg.readUTF();
            var _local_5:int = _arg_1.pkg.readInt();
            if (_local_2 == PlayerManager.Instance.Self.ID)
            {
                this._churchMarryApplySuccess = ComponentFactory.Instance.creat("common.church.ChurchMarryApplySuccess");
                this._churchMarryApplySuccess.addEventListener(Event.CLOSE, this.churchMarryApplySuccessClose);
                this._churchMarryApplySuccess.show();
                return;
            };
            if (this.checkMarryApplyList(_local_5))
            {
                return;
            };
            this.marryApplyList.push(_local_5);
            SoundManager.instance.play("018");
            this._proposeResposeFrame = ComponentFactory.Instance.creat("common.church.ChurchProposeResponseFrame");
            this._proposeResposeFrame.addEventListener(Event.CLOSE, this.ProposeResposeFrameClose);
            this._proposeResposeFrame.spouseID = _local_2;
            this._proposeResposeFrame.spouseName = _local_3;
            this._proposeResposeFrame.answerId = _local_5;
            this._proposeResposeFrame.love = _local_4;
            if (CacheSysManager.isLock(CacheConsts.ALERT_IN_FIGHT))
            {
                CacheSysManager.getInstance().cache(CacheConsts.ALERT_IN_FIGHT, new AlertAction(this._proposeResposeFrame, LayerManager.GAME_UI_LAYER, LayerManager.BLCAK_BLOCKGOUND));
            }
            else
            {
                this._resposeFrameCount++;
                this._proposeResposeFrame.show();
            };
        }

        private function checkMarryApplyList(_arg_1:int):Boolean
        {
            var _local_2:int;
            while (_local_2 < this.marryApplyList.length)
            {
                if (_arg_1 == this.marryApplyList[_local_2])
                {
                    return (true);
                };
                _local_2++;
            };
            return (false);
        }

        private function churchMarryApplySuccessClose(_arg_1:Event):void
        {
            if (this._churchMarryApplySuccess)
            {
                this._churchMarryApplySuccess.removeEventListener(Event.CLOSE, this.churchMarryApplySuccessClose);
                if (this._churchMarryApplySuccess.parent)
                {
                    this._churchMarryApplySuccess.parent.removeChild(this._churchMarryApplySuccess);
                };
                this._churchMarryApplySuccess.dispose();
            };
            this._churchMarryApplySuccess = null;
        }

        private function ProposeResposeFrameClose(_arg_1:Event):void
        {
            if (this._proposeResposeFrame)
            {
                this._proposeResposeFrame.removeEventListener(Event.CLOSE, this.ProposeResposeFrameClose);
                if (this._proposeResposeFrame.parent)
                {
                    this._proposeResposeFrame.parent.removeChild(this._proposeResposeFrame);
                };
                this._proposeResposeFrame.dispose();
            };
            this._proposeResposeFrame = null;
        }

        private function __marryApplyReply(_arg_1:CrazyTankSocketEvent):void
        {
            var _local_6:ChatData;
            var _local_7:String;
            var _local_2:int = _arg_1.pkg.readInt();
            var _local_3:Boolean = _arg_1.pkg.readBoolean();
            var _local_4:String = _arg_1.pkg.readUTF();
            var _local_5:Boolean = _arg_1.pkg.readBoolean();
            if (_local_3)
            {
                PlayerManager.Instance.Self.IsMarried = true;
                PlayerManager.Instance.Self.SpouseID = _local_2;
                PlayerManager.Instance.Self.SpouseName = _local_4;
                TaskManager.instance.checkHighLight();
                TaskManager.instance.requestCanAcceptTask();
                if (PathManager.solveExternalInterfaceEnabel())
                {
                    ExternalInterfaceManager.sendToAgent(7, PlayerManager.Instance.Self.ID, PlayerManager.Instance.Self.NickName, ServerManager.Instance.zoneName, -1, "", _local_4);
                };
            };
            if (_local_5)
            {
                _local_6 = new ChatData();
                _local_7 = "";
                if (_local_3)
                {
                    _local_6.channel = ChatInputView.SYS_NOTICE;
                    _local_7 = ((("<" + _local_4) + ">") + LanguageMgr.GetTranslation("tank.manager.PlayerManager.isApplicant"));
                    this._churchDialogueAgreePropose = ComponentFactory.Instance.creat("common.church.ChurchDialogueAgreePropose");
                    this._churchDialogueAgreePropose.msgInfo = _local_4;
                    this._churchDialogueAgreePropose.addEventListener(Event.CLOSE, this.churchDialogueAgreeProposeClose);
                    if (CacheSysManager.isLock(CacheConsts.ALERT_IN_FIGHT))
                    {
                        CacheSysManager.getInstance().cache(CacheConsts.ALERT_IN_FIGHT, new FrameShowAction(this._churchDialogueAgreePropose));
                    }
                    else
                    {
                        this._churchDialogueAgreePropose.show();
                    };
                }
                else
                {
                    _local_6.channel = ChatInputView.SYS_TIP;
                    _local_7 = ((("<" + _local_4) + ">") + LanguageMgr.GetTranslation("tank.manager.PlayerManager.refuseMarry"));
                    if (this._churchDialogueRejectPropose)
                    {
                        this._churchDialogueRejectPropose.dispose();
                        this._churchDialogueRejectPropose = null;
                    };
                    this._churchDialogueRejectPropose = ComponentFactory.Instance.creat("common.church.ChurchDialogueRejectPropose");
                    this._churchDialogueRejectPropose.msgInfo = _local_4;
                    this._churchDialogueRejectPropose.addEventListener(Event.CLOSE, this.churchDialogueRejectProposeClose);
                    if (CacheSysManager.isLock(CacheConsts.ALERT_IN_FIGHT))
                    {
                        CacheSysManager.getInstance().cache(CacheConsts.ALERT_IN_FIGHT, new AlertAction(this._churchDialogueRejectPropose, LayerManager.GAME_DYNAMIC_LAYER, LayerManager.BLCAK_BLOCKGOUND, "018", true));
                    }
                    else
                    {
                        this._churchDialogueRejectPropose.show();
                    };
                };
                _local_6.msg = StringHelper.rePlaceHtmlTextField(_local_7);
                ChatManager.Instance.chat(_local_6);
            }
            else
            {
                if (_local_3)
                {
                    this._alertMarried = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("tank.view.task.TaskCatalogContentView.tip"), LanguageMgr.GetTranslation("tank.manager.PlayerManager.youAndOtherMarried", _local_4), LanguageMgr.GetTranslation("ok"), "", false, false, false, 0, CacheConsts.ALERT_IN_FIGHT);
                    this._alertMarried.addEventListener(FrameEvent.RESPONSE, this.marriedResponse);
                };
            };
        }

        private function marriedResponse(_arg_1:FrameEvent):void
        {
            SoundManager.instance.play("008");
            switch (_arg_1.responseCode)
            {
                case FrameEvent.SUBMIT_CLICK:
                case FrameEvent.CANCEL_CLICK:
                case FrameEvent.CLOSE_CLICK:
                case FrameEvent.ESC_CLICK:
                    if (this._alertMarried)
                    {
                        if (this._alertMarried.parent)
                        {
                            this._alertMarried.parent.removeChild(this._alertMarried);
                        };
                        this._alertMarried.dispose();
                    };
                    this._alertMarried = null;
                    break;
            };
            ObjectUtils.disposeObject(_arg_1.target);
        }

        private function churchDialogueRejectProposeClose(_arg_1:Event):void
        {
            if (this._churchDialogueRejectPropose)
            {
                this._churchDialogueRejectPropose.removeEventListener(Event.CLOSE, this.churchDialogueRejectProposeClose);
                if (this._churchDialogueRejectPropose.parent)
                {
                    this._churchDialogueRejectPropose.parent.removeChild(this._churchDialogueRejectPropose);
                };
                this._churchDialogueRejectPropose.dispose();
            };
            this._churchDialogueRejectPropose = null;
        }

        private function churchDialogueAgreeProposeClose(_arg_1:Event):void
        {
            if (this._churchDialogueAgreePropose)
            {
                this._churchDialogueAgreePropose.removeEventListener(Event.CLOSE, this.churchDialogueAgreeProposeClose);
                if (this._churchDialogueAgreePropose.parent)
                {
                    this._churchDialogueAgreePropose.parent.removeChild(this._churchDialogueAgreePropose);
                };
                this._churchDialogueAgreePropose.dispose();
            };
            this._churchDialogueAgreePropose = null;
        }

        private function __divorceApply(_arg_1:CrazyTankSocketEvent):void
        {
            var _local_2:Boolean = _arg_1.pkg.readBoolean();
            var _local_3:Boolean = _arg_1.pkg.readBoolean();
            if ((!(_local_2)))
            {
                return;
            };
            PlayerManager.Instance.Self.IsMarried = false;
            PlayerManager.Instance.Self.SpouseID = 0;
            PlayerManager.Instance.Self.SpouseName = "";
            ChurchManager.instance.selfRoom = null;
            if ((!(_local_3)))
            {
                SoundManager.instance.play("018");
                this._churchDialogueUnmarried = ComponentFactory.Instance.creat("ddt.common.church.ChurchDialogueUnmarried");
                if (CacheSysManager.isLock(CacheConsts.ALERT_IN_FIGHT))
                {
                    CacheSysManager.getInstance().cache(CacheConsts.ALERT_IN_FIGHT, new AlertAction(this._churchDialogueUnmarried, LayerManager.GAME_DYNAMIC_LAYER, LayerManager.BLCAK_BLOCKGOUND));
                }
                else
                {
                    this._churchDialogueUnmarried.show();
                };
                this._churchDialogueUnmarried.addEventListener(Event.CLOSE, this.churchDialogueUnmarriedClose);
            }
            else
            {
                MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.manager.PlayerManager.divorce"));
            };
            if (((StateManager.currentStateType == StateType.CHURCH_ROOM) && ((this.currentRoom.brideID == PlayerManager.Instance.Self.ID) || (this.currentRoom.createID == PlayerManager.Instance.Self.ID))))
            {
                StateManager.setState(StateType.MAIN);
            };
        }

        private function churchDialogueUnmarriedClose(_arg_1:Event):void
        {
            SoundManager.instance.play("008");
            if (this._churchDialogueUnmarried)
            {
                this._churchDialogueUnmarried.removeEventListener(Event.CLOSE, this.churchDialogueUnmarriedClose);
                if (this._churchDialogueUnmarried.parent)
                {
                    this._churchDialogueUnmarried.parent.removeChild(this._churchDialogueUnmarried);
                };
                this._churchDialogueUnmarried.dispose();
            };
            this._churchDialogueUnmarried = null;
        }

        private function __churchInvite(_arg_1:CrazyTankSocketEvent):void
        {
            var _local_2:PackageIn;
            var _local_3:Object;
            var _local_4:ChurchInviteFrame;
            if (InviteManager.Instance.enabled)
            {
                _local_2 = _arg_1.pkg;
                _local_3 = new Object();
                _local_3["inviteID"] = _local_2.readInt();
                _local_3["inviteName"] = _local_2.readUTF();
                _local_3["IsVip"] = _local_2.readBoolean();
                _local_3["VIPLevel"] = _local_2.readInt();
                _local_3["roomID"] = _local_2.readInt();
                _local_3["roomName"] = _local_2.readUTF();
                _local_3["pwd"] = _local_2.readUTF();
                _local_3["sceneIndex"] = _local_2.readInt();
                _local_4 = ComponentFactory.Instance.creatComponentByStylename("common.church.ChurchInviteFrame");
                _local_4.msgInfo = _local_3;
                _local_4.show();
                SoundManager.instance.play("018");
            };
        }

        private function __marryPropGet(_arg_1:CrazyTankSocketEvent):void
        {
            var _local_6:ChurchRoomInfo;
            var _local_2:PackageIn = _arg_1.pkg;
            PlayerManager.Instance.Self.IsMarried = _local_2.readBoolean();
            PlayerManager.Instance.Self.SpouseID = _local_2.readInt();
            PlayerManager.Instance.Self.SpouseName = _local_2.readUTF();
            var _local_3:Boolean = _local_2.readBoolean();
            var _local_4:int = _local_2.readInt();
            var _local_5:Boolean = _local_2.readBoolean();
            if (_local_3)
            {
                if ((!(ChurchManager.instance.selfRoom)))
                {
                    _local_6 = new ChurchRoomInfo();
                    _local_6.id = _local_4;
                    ChurchManager.instance.selfRoom = _local_6;
                };
            }
            else
            {
                ChurchManager.instance.selfRoom = null;
            };
        }

        private function __roomLogin(_arg_1:CrazyTankSocketEvent):void
        {
            var _local_2:PackageIn = _arg_1.pkg;
            var _local_3:Boolean = _local_2.readBoolean();
            if ((!(_local_3)))
            {
                return;
            };
            var _local_4:ChurchRoomInfo = new ChurchRoomInfo();
            _local_4.id = _local_2.readInt();
            _local_4.roomName = _local_2.readUTF();
            _local_4.mapID = _local_2.readInt();
            _local_4.valideTimes = _local_2.readInt();
            _local_4.currentNum = _local_2.readInt();
            _local_4.createID = _local_2.readInt();
            _local_4.createName = _local_2.readUTF();
            _local_4.groomID = _local_2.readInt();
            _local_4.groomName = _local_2.readUTF();
            _local_4.brideID = _local_2.readInt();
            _local_4.brideName = _local_2.readUTF();
            _local_4.creactTime = _local_2.readDate();
            _local_4.isStarted = _local_2.readBoolean();
            var _local_5:int = _local_2.readByte();
            if (_local_5 == 1)
            {
                _local_4.status = ChurchRoomInfo.WEDDING_NONE;
            }
            else
            {
                _local_4.status = ChurchRoomInfo.WEDDING_ING;
            };
            _local_4.discription = _local_2.readUTF();
            _local_4.canInvite = _local_2.readBoolean();
            var _local_6:int = _local_2.readInt();
            ChurchManager.instance.currentScene = ((_local_6 == 1) ? false : true);
            _local_4.isUsedSalute = _local_2.readBoolean();
            this.currentRoom = _local_4;
            if (this.isAdmin(PlayerManager.Instance.Self))
            {
                this.selfRoom = _local_4;
            };
        }

        private function __updateSelfRoom(_arg_1:CrazyTankSocketEvent):void
        {
            var _local_2:PackageIn = _arg_1.pkg;
            var _local_3:int = _local_2.readInt();
            var _local_4:Boolean = _local_2.readBoolean();
            if ((!(_local_4)))
            {
                this.selfRoom = null;
                return;
            };
            if (this.selfRoom == null)
            {
                this.selfRoom = new ChurchRoomInfo();
            };
            this.selfRoom.id = _local_2.readInt();
            this.selfRoom.roomName = _local_2.readUTF();
            this.selfRoom.mapID = _local_2.readInt();
            this.selfRoom.valideTimes = _local_2.readInt();
            this.selfRoom.createID = _local_2.readInt();
            this.selfRoom.groomID = _local_2.readInt();
            this.selfRoom.brideID = _local_2.readInt();
            this.selfRoom.creactTime = _local_2.readDate();
            this.selfRoom.isUsedSalute = _local_2.readBoolean();
        }

        public function __removePlayer(_arg_1:CrazyTankSocketEvent):void
        {
            var _local_2:int = _arg_1.pkg.clientId;
            if (_local_2 == PlayerManager.Instance.Self.ID)
            {
                StateManager.setState(StateType.MAIN);
            };
        }

        public function isAdmin(_arg_1:PlayerInfo):Boolean
        {
            if (((this._currentRoom) && (_arg_1)))
            {
                return ((_arg_1.ID == this._currentRoom.groomID) || (_arg_1.ID == this._currentRoom.brideID));
            };
            return (false);
        }

        public function sendValidateMarry(_arg_1:BasePlayer):void
        {
            if (PlayerManager.Instance.Self.Grade < 13)
            {
                MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.manager.PlayerManager.notLvWoo"));
            }
            else
            {
                if (_arg_1.Grade < 13)
                {
                    MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.manager.PlayerManager.notOtherLvWoo"));
                }
                else
                {
                    if (PlayerManager.Instance.Self.IsMarried)
                    {
                        MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.manager.PlayerManager.IsMarried"));
                    }
                    else
                    {
                        if (PlayerManager.Instance.Self.Sex == _arg_1.Sex)
                        {
                            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.manager.PlayerManager.notAllow"));
                        }
                        else
                        {
                            if (PlayerManager.Instance.Self.bagLocked)
                            {
                                BaglockedManager.Instance.show();
                            }
                            else
                            {
                                SocketManager.Instance.out.sendValidateMarry(_arg_1.ID);
                            };
                        };
                    };
                };
            };
        }

        public function showChurchlist(_arg_1:Function, _arg_2:String):void
        {
            if (UIModuleLoader.Instance.checkIsLoaded(_arg_2))
            {
                if (_arg_1 != null)
                {
                    (_arg_1());
                };
            }
            else
            {
                this._loadingModuleType = _arg_2;
                this._loadedCallBack = _arg_1;
                UIModuleSmallLoading.Instance.progress = 0;
                UIModuleSmallLoading.Instance.show();
                UIModuleSmallLoading.Instance.addEventListener(Event.CLOSE, this.__onClose);
                UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_COMPLETE, this.__churchlistComplete);
                UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_PROGRESS, this.__churchtProgress);
                UIModuleLoader.Instance.addUIModuleImp(_arg_2);
            };
        }

        private function __onClose(_arg_1:Event):void
        {
            this._loadedCallBack = null;
            UIModuleSmallLoading.Instance.hide();
            UIModuleSmallLoading.Instance.removeEventListener(Event.CLOSE, this.__onClose);
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE, this.__churchlistComplete);
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_PROGRESS, this.__churchtProgress);
        }

        protected function __churchlistComplete(_arg_1:UIModuleEvent):void
        {
            UIModuleSmallLoading.Instance.hide();
            UIModuleSmallLoading.Instance.removeEventListener(Event.CLOSE, this.__onClose);
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE, this.__churchlistComplete);
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_PROGRESS, this.__churchtProgress);
            this.showChurchlist(this._loadedCallBack, this._loadingModuleType);
        }

        protected function __churchtProgress(_arg_1:UIModuleEvent):void
        {
            if (_arg_1.module == this._loadingModuleType)
            {
                UIModuleSmallLoading.Instance.progress = (_arg_1.loader.progress * 100);
            };
        }


    }
}//package ddt.manager

