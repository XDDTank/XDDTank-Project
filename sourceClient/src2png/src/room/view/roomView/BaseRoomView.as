// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//room.view.roomView.BaseRoomView

package room.view.roomView
{
    import flash.display.Sprite;
    import com.pickgliss.ui.core.Disposeable;
    import flash.utils.Timer;
    import room.model.RoomInfo;
    import room.view.RoomRightPropView;
    import flash.display.Bitmap;
    import flash.display.MovieClip;
    import com.pickgliss.ui.controls.SimpleBitmapButton;
    import invite.InviteFrame;
    import __AS3__.vec.Vector;
    import room.view.RoomViewerItem;
    import com.pickgliss.ui.controls.alert.BaseAlerFrame;
    import roomList.LookupRoomFrame;
    import com.pickgliss.ui.ComponentFactory;
    import ddt.utils.PositionUtils;
    import com.pickgliss.utils.ClassUtils;
    import room.model.RoomPlayer;
    import ddt.view.MainToolBar;
    import flash.events.MouseEvent;
    import room.view.RoomPlayerItem;
    import ddt.manager.PlayerManager;
    import flash.events.Event;
    import ddt.events.RoomEvent;
    import ddt.manager.SoundManager;
    import room.RoomManager;
    import ddt.manager.MessageTipManager;
    import ddt.manager.LanguageMgr;
    import com.pickgliss.ui.LayerManager;
    import com.pickgliss.loader.UIModuleLoader;
    import com.pickgliss.events.UIModuleEvent;
    import ddt.view.UIModuleSmallLoading;
    import ddt.data.UIModuleTypes;
    import com.pickgliss.utils.ObjectUtils;
    import flash.events.TimerEvent;
    import ddt.manager.GameInSocketOut;
    import ddt.manager.StateManager;
    import ddt.states.StateType;
    import game.model.GameInfo;
    import flash.utils.setTimeout;
    import flash.utils.clearTimeout;
    import ddt.manager.TaskManager;
    import ddt.manager.ChatManager;
    import trainer.view.NewHandContainer;
    import trainer.data.ArrowType;
    import __AS3__.vec.*;

    public class BaseRoomView extends Sprite implements Disposeable 
    {

        protected static const HURRY_UP_TIME:int = 30;
        protected static const KICK_TIME:int = 60;
        protected static const KICK_TIMEII:int = 300;
        protected static const KICK_TIMEIII:int = 1200;

        protected var _hostTimer:Timer;
        protected var _normalTimer:Timer;
        protected var _info:RoomInfo;
        protected var _roomPropView:RoomRightPropView;
        protected var _btnBg:Bitmap;
        protected var _btnBgOne:Bitmap;
        protected var _startBtn:MovieClip;
        protected var _prepareBtn:MovieClip;
        protected var _cancelBtn:SimpleBitmapButton;
        protected var _inviteBtn:SimpleBitmapButton;
        protected var _findBtn:SimpleBitmapButton;
        protected var _inviteFrame:InviteFrame;
        protected var _startInvite:Boolean = false;
        protected var _playerItems:Array;
        protected var _smallPlayerItems:Array;
        protected var _viewerItems:Vector.<RoomViewerItem>;
        private var _multiAlertFrame:BaseAlerFrame;
        protected var _findRoom:LookupRoomFrame;
        private var timeoutId:uint = 0;

        public function BaseRoomView(_arg_1:RoomInfo)
        {
            this._info = _arg_1;
            this.initTimer();
            this.initView();
            this.initEvents();
        }

        protected function initView():void
        {
            this._roomPropView = ComponentFactory.Instance.creatCustomObject("asset.ddtroom.roomPropView");
            addChild(this._roomPropView);
            this._btnBg = ComponentFactory.Instance.creatBitmap("asset.ddtroom.StartbtnBg");
            this._btnBgOne = ComponentFactory.Instance.creatBitmap("asset.ddtroom.btnBg");
            addChild(this._btnBgOne);
            PositionUtils.setPos(this._btnBg, "asset.ddtroom.btnBgPos");
            PositionUtils.setPos(this._btnBgOne, "asset.ddtroom.BigbtnBgPos");
            this._startBtn = (ClassUtils.CreatInstance("asset.ddtroom.startMovie") as MovieClip);
            PositionUtils.setPos(this._startBtn, "asset.ddtroom.startMoviePos");
            this._prepareBtn = (ClassUtils.CreatInstance("asset.ddtroom.preparMovie") as MovieClip);
            PositionUtils.setPos(this._prepareBtn, "asset.ddtroom.startMoviePos");
            this._cancelBtn = ComponentFactory.Instance.creatComponentByStylename("asset.ddtroom.cancelButton");
            this._inviteBtn = ComponentFactory.Instance.creatComponentByStylename("asset.ddtroom.inviteButton");
            addChild(this._inviteBtn);
            this._findBtn = ComponentFactory.Instance.creatComponentByStylename("asset.ddtroom.findButton");
            addChild(this._findBtn);
            this._startBtn.buttonMode = (this._prepareBtn.buttonMode = true);
            this.initTileList();
            addChild(this._startBtn);
            addChild(this._prepareBtn);
            addChild(this._cancelBtn);
            this.initPlayerItems();
            this.updateButtons();
        }

        private function initTimer():void
        {
            this._hostTimer = new Timer(1000);
            this._normalTimer = new Timer(1000);
            if (((!(this._info)) || (!(this._info.selfRoomPlayer))))
            {
                return;
            };
            if ((!(this._info.selfRoomPlayer.isHost)))
            {
                this.startNormalTimer();
            }
            else
            {
                if (this._info.isAllReady())
                {
                    this.startHostTimer();
                };
            };
        }

        protected function updateButtons():void
        {
            this.updateTimer();
            this._startBtn.visible = ((this._info.selfRoomPlayer.isHost) && (!(this._info.started)));
            this._prepareBtn.visible = ((!(this._info.selfRoomPlayer.isHost)) && (!(this._info.selfRoomPlayer.isReady)));
            this._cancelBtn.visible = ((this._info.selfRoomPlayer.isHost) ? this._info.started : this._info.selfRoomPlayer.isReady);
            this._cancelBtn.enable = ((this._info.selfRoomPlayer.isHost) || (!(this._info.started)));
            this._inviteBtn.enable = (!(this._info.started));
            this._findBtn.enable = (!(this._info.started));
            var _local_1:RoomPlayer = this._info.selfRoomPlayer;
            MainToolBar.Instance.setRoomStartState2(((this._info.selfRoomPlayer.isHost) ? (!(this._info.started)) : (!(this._info.selfRoomPlayer.isReady))));
            _local_1.isStarted = false;
            if (this._info.isAllReady())
            {
                this._startBtn.addEventListener(MouseEvent.CLICK, this.__startClick);
                this._startBtn.filters = null;
                if (((this._startBtn) && (this._startBtn.hasOwnProperty("startA"))))
                {
                    this._startBtn["startA"].play();
                };
                this._startBtn.buttonMode = true;
            }
            else
            {
                this._startBtn.removeEventListener(MouseEvent.CLICK, this.__startClick);
                this._startBtn.filters = [ComponentFactory.Instance.model.getSet("grayFilter")];
                if (((this._startBtn) && (this._startBtn.hasOwnProperty("startA"))))
                {
                    this._startBtn["startA"].gotoAndStop(1);
                };
                this._startBtn.buttonMode = false;
            };
            if (this._info.selfRoomPlayer.isViewer)
            {
                this._prepareBtn.visible = false;
                this._cancelBtn.visible = true;
                this._cancelBtn.enable = false;
            };
        }

        protected function initTileList():void
        {
            var _local_1:int;
            var _local_2:RoomViewerItem;
            this._playerItems = [];
            this._smallPlayerItems = [];
            if (this.isViewerRoom)
            {
                this._viewerItems = new Vector.<RoomViewerItem>();
                _local_1 = 6;
                while (_local_1 < 8)
                {
                    if (((this._info.type == RoomInfo.MATCH_ROOM) || (this._info.type == RoomInfo.MULTI_MATCH)))
                    {
                        _local_2 = new RoomViewerItem(_local_1);
                    }
                    else
                    {
                        _local_2 = new RoomViewerItem(_local_1, RoomViewerItem.SHORT);
                    };
                    this._viewerItems.push(_local_2);
                    _local_1++;
                };
            };
        }

        protected function get isViewerRoom():Boolean
        {
            return ((((((this._info.type == RoomInfo.CHALLENGE_ROOM) || (this._info.type == RoomInfo.MATCH_ROOM)) || (this._info.type == RoomInfo.DUNGEON_ROOM)) || (this._info.type == RoomInfo.CHANGE_DUNGEON)) || (this._info.type == RoomInfo.MULTI_DUNGEON)) || (this._info.type == RoomInfo.MULTI_MATCH));
        }

        protected function initPlayerItems():void
        {
            var _local_2:RoomPlayerItem;
            var _local_3:RoomViewerItem;
            var _local_1:int;
            while (_local_1 < this._playerItems.length)
            {
                _local_2 = (this._playerItems[_local_1] as RoomPlayerItem);
                _local_2.info = this._info.findPlayerByPlace(_local_1);
                PlayerManager.Instance.dispatchEvent(new Event(PlayerManager.UPDATE_ROOMPLAYER));
                _local_2.opened = (!(this._info.placesState[_local_1] == 0));
                _local_1++;
            };
            if (this.isViewerRoom)
            {
                _local_1 = 0;
                while (_local_1 < 2)
                {
                    if (((this._viewerItems) && (this._viewerItems[_local_1])))
                    {
                        _local_3 = (this._viewerItems[_local_1] as RoomViewerItem);
                        _local_3.info = this._info.findPlayerByPlace((_local_1 + 6));
                        _local_3.opened = (!(this._info.placesState[(_local_1 + 6)] == 0));
                    };
                    _local_1++;
                };
            };
        }

        protected function initEvents():void
        {
            var _local_1:int;
            var _local_2:RoomViewerItem;
            this._inviteBtn.addEventListener(MouseEvent.CLICK, this.__inviteClick);
            this._findBtn.addEventListener(MouseEvent.CLICK, this.__findClick);
            this._info.addEventListener(RoomEvent.ROOMPLACE_CHANGED, this.__updatePlayerItems);
            this._info.addEventListener(RoomEvent.PLAYER_STATE_CHANGED, this.__updateState);
            this._info.addEventListener(RoomEvent.ADD_PLAYER, this.__addPlayer);
            this._info.addEventListener(RoomEvent.REMOVE_PLAYER, this.__removePlayer);
            this._info.addEventListener(RoomEvent.STARTED_CHANGED, this.__startHandler);
            this._startBtn.addEventListener(MouseEvent.CLICK, this.__startClick);
            this._cancelBtn.addEventListener(MouseEvent.CLICK, this.__cancelClick);
            this._prepareBtn.addEventListener(MouseEvent.CLICK, this.__prepareClick);
            addEventListener(Event.ADDED_TO_STAGE, this.__loadWeakGuild);
            if (this.isViewerRoom)
            {
                _local_1 = 0;
                while (_local_1 < 2)
                {
                    if (((this._viewerItems) && (this._viewerItems[_local_1])))
                    {
                        _local_2 = this._viewerItems[_local_1];
                        this._viewerItems[_local_1].addEventListener(RoomEvent.VIEWER_ITEM_INFO_SET, this.__switchClickEnabled);
                    };
                    _local_1++;
                };
            };
        }

        protected function __switchClickEnabled(_arg_1:RoomEvent):void
        {
            var _local_3:RoomPlayerItem;
            var _local_2:int;
            while (_local_2 < this._playerItems.length)
            {
                _local_3 = (this._playerItems[_local_2] as RoomPlayerItem);
                _local_3.switchInEnabled = (_arg_1.params[0] == 1);
                _local_2++;
            };
        }

        private function __loadWeakGuild(_arg_1:Event):void
        {
            removeEventListener(Event.ADDED_TO_STAGE, this.__loadWeakGuild);
        }

        protected function __inviteClick(_arg_1:MouseEvent):void
        {
            if (this._inviteFrame != null)
            {
                SoundManager.instance.play("008");
                this.__onInviteComplete(null);
            }
            else
            {
                if (RoomManager.Instance.current.placeCount < 1)
                {
                    if (RoomManager.Instance.current.players.length > 1)
                    {
                        MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.roomlist.RoomListIIBGView.room"));
                    }
                    else
                    {
                        MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.room.RoomIIView2.noplacetoinvite"));
                    };
                    return;
                };
                this.startInvite();
            };
        }

        protected function __findClick(_arg_1:MouseEvent):void
        {
            SoundManager.instance.play("008");
            if (this._findRoom)
            {
                this._findRoom.dispose();
            };
            this._findRoom = null;
            this._findRoom = ComponentFactory.Instance.creatCustomObject("asset.ddtroomList.LookupRoomFrame", [this._info.ID]);
            LayerManager.Instance.addToLayer(this._findRoom, LayerManager.GAME_DYNAMIC_LAYER);
        }

        protected function startInvite():void
        {
            if (((!(this._startInvite)) && (this._inviteFrame == null)))
            {
                this._startInvite = true;
                this.loadInviteRes();
            };
        }

        private function loadInviteRes():void
        {
            UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_COMPLETE, this.__onInviteResComplete);
            UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_ERROR, this.__onInviteResError);
            UIModuleSmallLoading.Instance.progress = 0;
            UIModuleSmallLoading.Instance.show();
            UIModuleSmallLoading.Instance.addEventListener(Event.CLOSE, this.__onClose);
            UIModuleLoader.Instance.addUIModuleImp(UIModuleTypes.DDTINVITE);
        }

        private function __onClose(_arg_1:Event):void
        {
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE, this.__onInviteResComplete);
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_ERROR, this.__onInviteResError);
            UIModuleSmallLoading.Instance.hide();
            UIModuleSmallLoading.Instance.removeEventListener(Event.CLOSE, this.__onClose);
        }

        private function __onInviteResComplete(_arg_1:UIModuleEvent):void
        {
            if (_arg_1.module == UIModuleTypes.DDTINVITE)
            {
                UIModuleSmallLoading.Instance.hide();
                UIModuleSmallLoading.Instance.removeEventListener(Event.CLOSE, this.__onClose);
                UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE, this.__onInviteResComplete);
                UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_ERROR, this.__onInviteResError);
                if (((this._startInvite) && (this._inviteFrame == null)))
                {
                    this._inviteFrame = ComponentFactory.Instance.creatComponentByStylename("asset.ddtInviteFrame");
                    LayerManager.Instance.addToLayer(this._inviteFrame, LayerManager.GAME_DYNAMIC_LAYER, true, LayerManager.BLCAK_BLOCKGOUND);
                    this._inviteFrame.addEventListener(Event.COMPLETE, this.__onInviteComplete);
                    this._startInvite = false;
                };
            };
        }

        private function __onInviteComplete(_arg_1:Event):void
        {
            this._inviteFrame.removeEventListener(Event.COMPLETE, this.__onInviteComplete);
            ObjectUtils.disposeObject(this._inviteFrame);
            this._inviteFrame = null;
        }

        private function __onInviteResError(_arg_1:UIModuleEvent):void
        {
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE, this.__onInviteResComplete);
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_ERROR, this.__onInviteResError);
        }

        protected function removeEvents():void
        {
            var _local_1:int;
            var _local_2:RoomViewerItem;
            this._findBtn.removeEventListener(MouseEvent.CLICK, this.__findClick);
            this._info.removeEventListener(RoomEvent.ROOMPLACE_CHANGED, this.__updatePlayerItems);
            this._info.removeEventListener(RoomEvent.PLAYER_STATE_CHANGED, this.__updateState);
            this._info.removeEventListener(RoomEvent.ADD_PLAYER, this.__addPlayer);
            this._info.removeEventListener(RoomEvent.REMOVE_PLAYER, this.__removePlayer);
            this._info.removeEventListener(RoomEvent.STARTED_CHANGED, this.__startHandler);
            this._startBtn.removeEventListener(MouseEvent.CLICK, this.__startClick);
            this._cancelBtn.removeEventListener(MouseEvent.CLICK, this.__cancelClick);
            this._hostTimer.removeEventListener(TimerEvent.TIMER, this.__onHostTimer);
            this._normalTimer.removeEventListener(TimerEvent.TIMER, this.__onTimerII);
            this._prepareBtn.removeEventListener(MouseEvent.CLICK, this.__prepareClick);
            removeEventListener(Event.ADDED_TO_STAGE, this.__loadWeakGuild);
            if (this.isViewerRoom)
            {
                _local_1 = 0;
                while (_local_1 < 2)
                {
                    if (((this._viewerItems) && (this._viewerItems[_local_1])))
                    {
                        _local_2 = this._viewerItems[_local_1];
                        this._viewerItems[_local_1].removeEventListener(RoomEvent.VIEWER_ITEM_INFO_SET, this.__switchClickEnabled);
                    };
                    _local_1++;
                };
            };
        }

        private function updateTimer():void
        {
            if (((this._info.selfRoomPlayer.isHost) && (this._startBtn.buttonMode == (!(this._info.isAllReady())))))
            {
                this.resetHostTimer();
            };
            if (((!(this._info.selfRoomPlayer.isHost)) && (this._prepareBtn.visible == this._info.selfRoomPlayer.isReady)))
            {
                this.resetNormalTimer();
            };
        }

        protected function __updatePlayerItems(_arg_1:RoomEvent):void
        {
            var _local_3:RoomPlayerItem;
            var _local_2:int;
            while (_local_2 < this._playerItems.length)
            {
                _local_3 = (this._playerItems[_local_2] as RoomPlayerItem);
                _local_3.opened = (!(this._info.placesState[_local_2] == 0));
                _local_2++;
            };
            if (this.isViewerRoom)
            {
                if (this._viewerItems)
                {
                    if (this._viewerItems[0])
                    {
                        this._viewerItems[0].opened = (!(this._info.placesState[6] == 0));
                    };
                    if (this._viewerItems[1])
                    {
                        this._viewerItems[1].opened = (!(this._info.placesState[7] == 0));
                    };
                };
            };
            this.initPlayerItems();
            this.updateButtons();
        }

        protected function __updateState(_arg_1:RoomEvent):void
        {
            this.updateButtons();
            if (this._info.selfRoomPlayer.isHost)
            {
                this.startHostTimer();
                this.stopNormalTimer();
                if (((!(this._info.isAllReady())) && (this._info.started)))
                {
                    GameInSocketOut.sendCancelWait();
                    this._info.started = false;
                    SoundManager.instance.stop("007");
                };
                if (this._info.started)
                {
                    MainToolBar.Instance.setRoomStartState2(true);
                }
                else
                {
                    MainToolBar.Instance.enableAll();
                };
            }
            else
            {
                this.stopHostTimer();
                this.startNormalTimer();
                if (this._info.selfRoomPlayer.isReady)
                {
                    MainToolBar.Instance.setRoomStartState();
                }
                else
                {
                    if ((!(this._info.selfRoomPlayer.isViewer)))
                    {
                        MainToolBar.Instance.enableAll();
                    };
                };
            };
        }

        protected function __addPlayer(_arg_1:RoomEvent):void
        {
            var _local_2:RoomPlayer = (_arg_1.params[0] as RoomPlayer);
            if (_local_2.isFirstIn)
            {
                SoundManager.instance.play("158");
            };
            if (_local_2.place >= 6)
            {
                this._viewerItems[(_local_2.place - 6)].info = _local_2;
            }
            else
            {
                this._playerItems[_local_2.place].info = _local_2;
                PlayerManager.Instance.dispatchEvent(new Event(PlayerManager.UPDATE_ROOMPLAYER));
            };
            this.updateButtons();
        }

        protected function __removePlayer(_arg_1:RoomEvent):void
        {
            var _local_2:int;
            var _local_3:Boolean;
            var _local_4:int;
            while (_local_4 < this._playerItems.length)
            {
                if (this._info.findPlayerByPlace(_local_4) != null)
                {
                    if (this._info.findPlayerByPlace(_local_4).isSelf)
                    {
                        _local_2 = this._info.findPlayerByPlace(_local_4).team;
                        break;
                    };
                };
                _local_4++;
            };
            var _local_5:int;
            while (_local_5 < 2)
            {
                if (this._info.findPlayerByPlace((_local_5 + 6)) != null)
                {
                    if (this._info.findPlayerByPlace((_local_5 + 6)).isSelf)
                    {
                        _local_3 = true;
                        break;
                    };
                };
                _local_5++;
            };
            var _local_6:RoomPlayer = (_arg_1.params[0] as RoomPlayer);
            if (_local_6.place >= 6)
            {
                this._viewerItems[(_local_6.place - 6)].info = null;
            }
            else
            {
                if (((StateManager.currentStateType == StateType.CHALLENGE_ROOM) && (!(_local_3))))
                {
                    if (_local_6.team == _local_2)
                    {
                        this._playerItems[((!((_local_6.place % 2) == 1)) ? _local_6.place : (_local_6.place - 1))].info = null;
                    }
                    else
                    {
                        this._playerItems[(((_local_6.place % 2) == 1) ? _local_6.place : (_local_6.place + 1))].info = null;
                    };
                }
                else
                {
                    this._playerItems[_local_6.place].info = null;
                };
            };
            _local_6.dispose();
            this.updateButtons();
        }

        protected function __startClick(_arg_1:MouseEvent):void
        {
            var _local_3:RoomPlayer;
            if ((!(this._info.isAllReady())))
            {
                return;
            };
            SoundManager.instance.play("008");
            var _local_2:GameInfo = new GameInfo();
            if (this.checkCanStartGame())
            {
                this.startGame();
                this._info.started = true;
                _local_3 = this._info.selfRoomPlayer;
                _local_3.isStarted = true;
            };
        }

        protected function __prepareClick(_arg_1:MouseEvent):void
        {
            SoundManager.instance.play("008");
            if (PlayerManager.Instance.Self.Bag.getItemAt(14) == null)
            {
                MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.room.RoomIIController.weapon"));
                return;
            };
            this.prepareGame();
        }

        protected function prepareGame():void
        {
            GameInSocketOut.sendPlayerState(1);
        }

        protected function startGame():void
        {
            this._startInvite = false;
            if (this.timeoutId == 0)
            {
                GameInSocketOut.sendGameStart();
            };
            this.timeoutId = setTimeout(this.suspend, 300);
        }

        private function suspend():void
        {
            clearTimeout(this.timeoutId);
            this.timeoutId = 0;
        }

        protected function __cancelClick(_arg_1:MouseEvent):void
        {
            var _local_2:RoomPlayer;
            SoundManager.instance.play("008");
            if (this._info.selfRoomPlayer.isHost)
            {
                GameInSocketOut.sendCancelWait();
                _local_2 = this._info.selfRoomPlayer;
                _local_2.isStarted = false;
            }
            else
            {
                if (this._info.started)
                {
                    GameInSocketOut.sendCancelWait();
                }
                else
                {
                    GameInSocketOut.sendPlayerState(0);
                };
            };
        }

        protected function checkCanStartGame():Boolean
        {
            var _local_1:Boolean = true;
            if (this._info.selfRoomPlayer.isViewer)
            {
                return (_local_1);
            };
            if (PlayerManager.Instance.Self.Bag.getItemAt(14) == null)
            {
                MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.room.RoomIIController.weapon"));
                _local_1 = false;
            };
            return (_local_1);
        }

        protected function academyDungeonAllow():Boolean
        {
            var _local_1:int;
            if (RoomManager.Instance.current.players.length < 2)
            {
                MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.room.roomStart.academy.warning4"));
                return (false);
            };
            if (_local_1 < 2)
            {
                MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.room.roomStart.academy.warning4"));
                return (false);
            };
            _local_1 = 0;
            if (_local_1 == 0)
            {
                MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.room.roomStart.academy.warning2"));
                return (false);
            };
            return (true);
        }

        protected function __startHandler(_arg_1:RoomEvent):void
        {
            this.updateButtons();
            if (this._info.started)
            {
                this.stopHostTimer();
                MainToolBar.Instance.setRoomStartState();
                SoundManager.instance.stop("007");
            }
            else
            {
                if (((this._info.selfRoomPlayer.isHost) && (this._info.isAllReady())))
                {
                    this.startHostTimer();
                };
                if (this._info.selfRoomPlayer.isHost)
                {
                    MainToolBar.Instance.enableAll();
                }
                else
                {
                    if (this._info.selfRoomPlayer.isViewer)
                    {
                        MainToolBar.Instance.setRoomStartState();
                        MainToolBar.Instance.setReturnEnable(true);
                        return;
                    };
                    if (this._info.selfRoomPlayer.isReady)
                    {
                        MainToolBar.Instance.setRoomStartState();
                    }
                    else
                    {
                        MainToolBar.Instance.enableAll();
                    };
                };
            };
        }

        protected function startHostTimer():void
        {
            if ((!(this._hostTimer.running)))
            {
                this._hostTimer.start();
                this._hostTimer.addEventListener(TimerEvent.TIMER, this.__onHostTimer);
            };
        }

        protected function startNormalTimer():void
        {
            if ((!(this._normalTimer.running)))
            {
                this._normalTimer.start();
                this._normalTimer.addEventListener(TimerEvent.TIMER, this.__onTimerII);
            };
        }

        protected function stopHostTimer():void
        {
            this._hostTimer.reset();
            this._hostTimer.removeEventListener(TimerEvent.TIMER, this.__onHostTimer);
            SoundManager.instance.stop("007");
        }

        protected function stopNormalTimer():void
        {
            this._normalTimer.reset();
            this._normalTimer.removeEventListener(TimerEvent.TIMER, this.__onTimerII);
            SoundManager.instance.stop("007");
        }

        protected function resetHostTimer():void
        {
            this.stopHostTimer();
            this.startHostTimer();
            SoundManager.instance.stop("007");
        }

        protected function resetNormalTimer():void
        {
            this.stopNormalTimer();
            this.startNormalTimer();
            SoundManager.instance.stop("007");
        }

        protected function __onTimerII(_arg_1:TimerEvent):void
        {
            if (((!(this._info.selfRoomPlayer.isHost)) && (!(this._info.selfRoomPlayer.isViewer))))
            {
                if (((this._normalTimer.currentCount >= HURRY_UP_TIME) && (!(this._info.selfRoomPlayer.isReady))))
                {
                    if ((!(TaskManager.instance.Model.taskViewIsShow)))
                    {
                        if ((!(SoundManager.instance.isPlaying("007"))))
                        {
                            SoundManager.instance.play("007", false, true);
                        };
                    }
                    else
                    {
                        SoundManager.instance.stop("007");
                    };
                };
            };
        }

        protected function __onHostTimer(_arg_1:TimerEvent):void
        {
            if (((this._info.selfRoomPlayer.isHost) && (!(this._info.isOpenBoss))))
            {
                if (((this._hostTimer.currentCount >= KICK_TIMEIII) && ((this._info.players.length - this._info.currentViewerCnt) > 1)))
                {
                    this.kickHandler();
                }
                else
                {
                    if (((this._hostTimer.currentCount >= KICK_TIMEII) && ((this._info.players.length - this._info.currentViewerCnt) == 1)))
                    {
                        this.kickHandler();
                    }
                    else
                    {
                        if (((((this._hostTimer.currentCount >= KICK_TIME) && ((this._info.players.length - this._info.currentViewerCnt) > 1)) && (this._info.currentViewerCnt == 0)) && (this._info.isAllReady())))
                        {
                            this.kickHandler();
                        }
                        else
                        {
                            if (((((this._hostTimer.currentCount == (KICK_TIMEIII - 30)) && ((this._info.players.length - this._info.currentViewerCnt) > 1)) || ((this._hostTimer.currentCount == (KICK_TIMEII - 30)) && ((this._info.players.length - this._info.currentViewerCnt) == 1))) || ((((this._hostTimer.currentCount == (KICK_TIME - 30)) && ((this._info.players.length - this._info.currentViewerCnt) > 1)) && (this._info.currentViewerCnt == 0)) && (this._info.isAllReady()))))
                            {
                                ChatManager.Instance.sysChatRed(LanguageMgr.GetTranslation("BaseRoomView.getout.Timeout"));
                                MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("BaseRoomView.getout.Timeout"));
                            }
                            else
                            {
                                if (((this._hostTimer.currentCount >= HURRY_UP_TIME) && (this._info.isAllReady())))
                                {
                                    if ((!(TaskManager.instance.Model.taskViewIsShow)))
                                    {
                                        if ((!(SoundManager.instance.isPlaying("007"))))
                                        {
                                            SoundManager.instance.play("007", false, true);
                                        };
                                    }
                                    else
                                    {
                                        SoundManager.instance.stop("007");
                                    };
                                };
                            };
                        };
                    };
                };
            };
        }

        protected function kickHandler():void
        {
            ChatManager.Instance.sysChatRed(LanguageMgr.GetTranslation("tank.room.RoomIIView2.kick"));
            if (this._info.type == RoomInfo.DUNGEON_ROOM)
            {
                StateManager.setState(StateType.MAIN);
            }
            else
            {
                StateManager.setState(StateType.MAIN);
            };
            PlayerManager.Instance.Self.unlockAllBag();
        }

        public function dispose():void
        {
            var _local_1:Object;
            var _local_2:RoomViewerItem;
            NewHandContainer.Instance.clearArrowByID(ArrowType.GET_ZXC_ITEM);
            this.removeEvents();
            clearTimeout(this.timeoutId);
            this._roomPropView.dispose();
            this._roomPropView = null;
            if (this._btnBg)
            {
                ObjectUtils.disposeObject(this._btnBg);
                this._btnBg = null;
            };
            if (this._btnBgOne)
            {
                ObjectUtils.disposeObject(this._btnBgOne);
                this._btnBgOne = null;
            };
            if (this._startBtn.parent)
            {
                this._startBtn.parent.removeChild(this._startBtn);
            };
            this._startBtn.stop();
            this._startBtn = null;
            if (this._prepareBtn.parent)
            {
                this._prepareBtn.parent.removeChild(this._prepareBtn);
            };
            this._prepareBtn.stop();
            this._cancelBtn.dispose();
            this._cancelBtn = null;
            this._inviteBtn.dispose();
            this._inviteBtn = null;
            this._findBtn.dispose();
            this._findBtn = null;
            if (this._inviteFrame)
            {
                this._inviteFrame.dispose();
            };
            this._inviteFrame = null;
            if (this._viewerItems)
            {
                for each (_local_2 in this._viewerItems)
                {
                    _local_2.dispose();
                    _local_2 = null;
                };
            };
            if (this._findRoom)
            {
                this._findRoom.dispose();
            };
            this._findRoom = null;
            this._viewerItems = null;
            for each (_local_1 in this._playerItems)
            {
                if (_local_1.numChildren > 0)
                {
                    _local_1.dispose();
                };
            };
            ObjectUtils.disposeObject(this._multiAlertFrame);
            this._multiAlertFrame = null;
            this._playerItems = null;
            this._hostTimer.stop();
            this._hostTimer = null;
            this._normalTimer.stop();
            this._normalTimer = null;
            this._info = null;
            SoundManager.instance.stop("007");
            if (parent)
            {
                parent.removeChild(this);
            };
        }


    }
}//package room.view.roomView

