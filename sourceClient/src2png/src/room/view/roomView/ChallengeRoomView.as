// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//room.view.roomView.ChallengeRoomView

package room.view.roomView
{
    import com.pickgliss.ui.core.Disposeable;
    import flash.display.Bitmap;
    import com.pickgliss.ui.controls.BaseButton;
    import __AS3__.vec.Vector;
    import com.pickgliss.ui.controls.container.SimpleTileList;
    import room.view.smallMapInfoPanel.ChallengeRoomSmallMapInfoPanel;
    import flash.display.MovieClip;
    import ddt.data.player.SelfInfo;
    import flash.utils.Timer;
    import room.model.RoomInfo;
    import room.view.RoomPlayerItem;
    import room.view.ChallengeRoomPlayerItem;
    import room.RoomManager;
    import room.model.RoomPlayer;
    import flash.events.MouseEvent;
    import com.pickgliss.ui.ComponentFactory;
    import ddt.utils.PositionUtils;
    import com.pickgliss.utils.ClassUtils;
    import ddt.manager.PlayerManager;
    import game.view.DefyAfficheViewFrame;
    import ddt.events.RoomEvent;
    import room.view.RoomViewerItem;
    import flash.events.Event;
    import ddt.manager.SoundManager;
    import ddt.manager.MessageTipManager;
    import ddt.manager.LanguageMgr;
    import ddt.manager.GameInSocketOut;
    import flash.events.TimerEvent;
    import __AS3__.vec.*;

    public class ChallengeRoomView extends BaseRoomView implements Disposeable 
    {

        public static const PLAYER_POS_CHANGE:String = "playerposchange";

        private var _bg:Bitmap;
        private var _vsBg:Bitmap;
        private var _btnSwitchTeam:BaseButton;
        private var _playerItemContainers:Vector.<SimpleTileList>;
        private var _smallMapInfoPanel:ChallengeRoomSmallMapInfoPanel;
        private var _blueTeamBitmap:MovieClip;
        private var _redTeamBitmap:MovieClip;
        private var _self:SelfInfo;
        private var _ItemArr:Array;
        private var _clickTimer:Timer;

        public function ChallengeRoomView(_arg_1:RoomInfo)
        {
            super(_arg_1);
        }

        override public function dispose():void
        {
            super.dispose();
            this._btnSwitchTeam.dispose();
            this._smallMapInfoPanel.dispose();
            removeChild(this._bg);
            this._bg = null;
            removeChild(this._vsBg);
            this._vsBg = null;
            this._btnSwitchTeam = null;
            this._playerItemContainers = null;
            this._smallMapInfoPanel = null;
            this.__clickTimerHandler(null);
        }

        override protected function updateButtons():void
        {
            var _local_4:RoomPlayerItem;
            var _local_5:ChallengeRoomPlayerItem;
            super.updateButtons();
            if (_info.selfRoomPlayer.isViewer)
            {
                this._btnSwitchTeam.enable = false;
                return;
            };
            if (RoomManager.Instance.current.selfRoomPlayer.isHost)
            {
                this._btnSwitchTeam.enable = _startBtn.visible;
                _cancelBtn.visible = (!(_startBtn.visible));
            }
            else
            {
                this._btnSwitchTeam.enable = _prepareBtn.visible;
                _cancelBtn.visible = (!(_prepareBtn.visible));
            };
            var _local_1:Boolean;
            var _local_2:Boolean;
            var _local_3:int;
            while (_local_3 < _playerItems.length)
            {
                if ((_local_3 % 2) != 1)
                {
                    _local_4 = (_playerItems[_local_3] as RoomPlayerItem);
                    if (((_local_4.info) && (_local_4.info.team == RoomPlayer.BLUE_TEAM)))
                    {
                        _local_1 = true;
                    };
                    if (((_local_4.info) && (_local_4.info.team == RoomPlayer.RED_TEAM)))
                    {
                        _local_2 = true;
                    };
                }
                else
                {
                    _local_5 = (_playerItems[_local_3] as ChallengeRoomPlayerItem);
                    if (((_local_5.info) && (_local_5.info.team == RoomPlayer.BLUE_TEAM)))
                    {
                        _local_1 = true;
                    };
                    if (((_local_5.info) && (_local_5.info.team == RoomPlayer.RED_TEAM)))
                    {
                        _local_2 = true;
                    };
                };
                _local_3++;
            };
            if (((!(_local_1)) || (!(_local_2))))
            {
                _startBtn.removeEventListener(MouseEvent.CLICK, __startClick);
                _startBtn.filters = [ComponentFactory.Instance.model.getSet("grayFilter")];
                if (((_startBtn) && (_startBtn.hasOwnProperty("startA"))))
                {
                    _startBtn["startA"].gotoAndStop(1);
                };
                _startBtn.buttonMode = false;
            };
        }

        override protected function initEvents():void
        {
            super.initEvents();
            this._btnSwitchTeam.addEventListener(MouseEvent.CLICK, this.__switchTeam);
        }

        override protected function initTileList():void
        {
            var _local_1:int;
            var _local_2:RoomPlayerItem;
            var _local_3:ChallengeRoomPlayerItem;
            super.initTileList();
            this._playerItemContainers = new Vector.<SimpleTileList>();
            this._playerItemContainers[(RoomPlayer.BLUE_TEAM - 1)] = new SimpleTileList(2);
            this._playerItemContainers[(RoomPlayer.RED_TEAM - 1)] = new SimpleTileList(2);
            this._playerItemContainers[(RoomPlayer.BLUE_TEAM - 1)].hSpace = (this._playerItemContainers[(RoomPlayer.RED_TEAM - 1)].hSpace = 2);
            this._playerItemContainers[(RoomPlayer.BLUE_TEAM - 1)].vSpace = (this._playerItemContainers[(RoomPlayer.RED_TEAM - 1)].vSpace = 4);
            PositionUtils.setPos(this._playerItemContainers[(RoomPlayer.BLUE_TEAM - 1)], "asset.ddtchallengeRoom.BlueTeamPos");
            PositionUtils.setPos(this._playerItemContainers[(RoomPlayer.RED_TEAM - 1)], "asset.ddtchallengeRoom.RedTeamPos");
            this._ItemArr = [ComponentFactory.Instance.creatCustomObject("asset.ddtchallengeRoom.itemPos1"), ComponentFactory.Instance.creatCustomObject("asset.ddtchallengeRoom.itemPos4"), ComponentFactory.Instance.creatCustomObject("asset.ddtchallengeRoom.itemPos2"), ComponentFactory.Instance.creatCustomObject("asset.ddtchallengeRoom.itemPos5"), ComponentFactory.Instance.creatCustomObject("asset.ddtchallengeRoom.itemPos3"), ComponentFactory.Instance.creatCustomObject("asset.ddtchallengeRoom.itemPos6")];
            _local_1 = 0;
            while (_local_1 < 6)
            {
                _local_2 = new RoomPlayerItem(_local_1);
                _local_2.x = this._ItemArr[_local_1].x;
                _local_2.y = this._ItemArr[_local_1].y;
                addChild(_local_2);
                _playerItems.push(_local_2);
                _local_3 = new ChallengeRoomPlayerItem((_local_1 + 1));
                _local_3.x = this._ItemArr[(_local_1 + 1)].x;
                _local_3.y = this._ItemArr[(_local_1 + 1)].y;
                addChild(_local_3);
                _playerItems.push(_local_3);
                _local_1 = (_local_1 + 2);
            };
            PositionUtils.setPos(_viewerItems[0], "asset.ddtchallengeroom.ViewerItemPos_0");
            PositionUtils.setPos(_viewerItems[1], "asset.ddtchallengeroom.ViewerItemPos_1");
            addChild(_viewerItems[0]);
            addChild(_viewerItems[1]);
        }

        override protected function initView():void
        {
            this._bg = ComponentFactory.Instance.creatBitmap("asset.background.room.rightBg");
            PositionUtils.setPos(this._bg, "asset.ddtChallengeRomm.bgPos");
            this._vsBg = ComponentFactory.Instance.creatBitmap("asset.ddtdungeonRoom.VSbg");
            this._smallMapInfoPanel = ComponentFactory.Instance.creatCustomObject("asset.ddtchallengeRoom.smallMapInfoPanel");
            this._btnSwitchTeam = ComponentFactory.Instance.creatComponentByStylename("asset.ddtChallengeRoom.switchTeamBtn");
            this._blueTeamBitmap = (ClassUtils.CreatInstance("asset.ddtChallengeRoom.blueBg") as MovieClip);
            PositionUtils.setPos(this._blueTeamBitmap, "asset.ddtchallengeroom.blueBgpos");
            this._redTeamBitmap = (ClassUtils.CreatInstance("asset.ddtChallengeRoom.redBg") as MovieClip);
            PositionUtils.setPos(this._redTeamBitmap, "asset.ddtchallengeroom.redBgpos");
            this._smallMapInfoPanel.info = _info;
            this._self = PlayerManager.Instance.Self;
            addChild(this._bg);
            addChild(this._vsBg);
            addChild(this._btnSwitchTeam);
            super.initView();
            _btnBg.visible = false;
            _btnBgOne.visible = true;
            addChild(this._smallMapInfoPanel);
            PositionUtils.setPos(_startBtn, "asset.ddtroom.ChallengeRoomstartMoviePos");
            PositionUtils.setPos(_prepareBtn, "asset.ddtroom.ChallengeRoomstartMoviePos");
            PositionUtils.setPos(_cancelBtn, "asset.ddtroom.ChallengeRoomstartMoviePos");
            if ((!(_info.selfRoomPlayer.isViewer)))
            {
                this.openDefyAffiche();
            };
        }

        private function openDefyAffiche():void
        {
            var _local_2:DefyAfficheViewFrame;
            if (((!(_info)) || (!(_info.defyInfo))))
            {
                return;
            };
            var _local_1:int;
            while (_local_1 <= _info.defyInfo[0].length)
            {
                if (this._self.NickName == _info.defyInfo[0][_local_1])
                {
                    if (_info.defyInfo[1].length != 0)
                    {
                        _local_2 = ComponentFactory.Instance.creatComponentByStylename("game.view.defyAfficheViewFrame");
                        _local_2.roomInfo = _info;
                        _local_2.show();
                    };
                };
                _local_1++;
            };
        }

        override protected function __switchClickEnabled(_arg_1:RoomEvent):void
        {
            var _local_3:RoomPlayerItem;
            var _local_4:ChallengeRoomPlayerItem;
            var _local_2:int;
            while (_local_2 < _playerItems.length)
            {
                if ((_local_2 % 2) != 1)
                {
                    _local_3 = (_playerItems[_local_2] as RoomPlayerItem);
                    _local_3.switchInEnabled = (_arg_1.params[0] == 1);
                }
                else
                {
                    _local_4 = (_playerItems[_local_2] as ChallengeRoomPlayerItem);
                    _local_4.switchInEnabled = (_arg_1.params[0] == 1);
                };
                _local_2++;
            };
        }

        override protected function __updatePlayerItems(_arg_1:RoomEvent):void
        {
            this.initPlayerItems();
            this.updateButtons();
        }

        override protected function initPlayerItems():void
        {
            var _local_1:int;
            var _local_2:int;
            var _local_3:int;
            var _local_4:int;
            var _local_8:RoomPlayerItem;
            var _local_9:ChallengeRoomPlayerItem;
            var _local_11:RoomViewerItem;
            var _local_5:Boolean;
            var _local_6:int;
            while (_local_6 < _playerItems.length)
            {
                if (_info.findPlayerByPlace(_local_6) != null)
                {
                    if (_info.findPlayerByPlace(_local_6).isSelf)
                    {
                        _local_1 = _info.findPlayerByPlace(_local_6).team;
                        RoomManager.Instance.beforePlace = _info.findPlayerByPlace(_local_6).place;
                        break;
                    };
                    if (_info.findPlayerByPlace(_local_6).isHost)
                    {
                        _local_3 = _info.findPlayerByPlace(_local_6).place;
                        _local_4 = _info.findPlayerByPlace(_local_6).team;
                    };
                };
                _local_6++;
            };
            _local_2 = RoomManager.Instance.beforePlace;
            var _local_7:int;
            while (_local_7 < 2)
            {
                if (_info.findPlayerByPlace((_local_7 + 6)) != null)
                {
                    if (_info.findPlayerByPlace((_local_7 + 6)).isSelf)
                    {
                        _local_1 = 0;
                        _local_5 = true;
                        break;
                    };
                };
                _local_7++;
            };
            var _local_10:int;
            while (_local_10 < _playerItems.length)
            {
                if (_info.findPlayerByPlace(_local_10))
                {
                    if (_local_1 == 0)
                    {
                        if ((_local_10 % 2) != 1)
                        {
                            _local_8 = (_playerItems[_local_10] as RoomPlayerItem);
                            _local_8.place = _local_10;
                            _local_8.disposeCharacterContainer();
                            _local_8.info = _info.findPlayerByPlace(_local_10);
                            _local_8.opened = (!(_info.placesState[_local_10] == 0));
                        }
                        else
                        {
                            _local_9 = (_playerItems[_local_10] as ChallengeRoomPlayerItem);
                            _local_9.place = _local_10;
                            _local_9.info = _info.findPlayerByPlace(_local_10);
                            _local_9.opened = (!(_info.placesState[_local_10] == 0));
                        };
                    }
                    else
                    {
                        if (_local_1 == _info.findPlayerByPlace(_local_10).team)
                        {
                            _local_8 = (_playerItems[((!((_local_10 % 2) == 1)) ? _local_10 : (_local_10 - 1))] as RoomPlayerItem);
                            _local_8.place = _local_10;
                            _local_8.disposeCharacterContainer();
                            _local_8.info = _info.findPlayerByPlace(_local_10);
                            _local_8.opened = (!(_info.placesState[_local_10] == 0));
                        }
                        else
                        {
                            _local_9 = (_playerItems[(((_local_10 % 2) == 1) ? _local_10 : (_local_10 + 1))] as ChallengeRoomPlayerItem);
                            _local_9.place = _local_10;
                            _local_9.info = _info.findPlayerByPlace(_local_10);
                            _local_9.opened = (!(_info.placesState[_local_10] == 0));
                        };
                    };
                }
                else
                {
                    if (_local_5)
                    {
                        if ((_local_10 % 2) != 1)
                        {
                            _local_8 = (_playerItems[_local_10] as RoomPlayerItem);
                            _local_8.place = _local_10;
                            _local_8.disposeCharacterContainer();
                            _local_8.info = _info.findPlayerByPlace(_local_10);
                            _local_8.opened = (!(_info.placesState[_local_10] == 0));
                        }
                        else
                        {
                            _local_9 = (_playerItems[_local_10] as ChallengeRoomPlayerItem);
                            _local_9.place = _local_10;
                            _local_9.info = _info.findPlayerByPlace(_local_10);
                            _local_9.opened = (!(_info.placesState[_local_10] == 0));
                        };
                    }
                    else
                    {
                        if ((_local_10 % 2) != 1)
                        {
                            if ((_local_2 % 2) != 1)
                            {
                                _local_8 = (_playerItems[_local_10] as RoomPlayerItem);
                                _local_8.place = _local_10;
                                _local_8.disposeCharacterContainer();
                                _local_8.info = _info.findPlayerByPlace(_local_10);
                                _local_8.opened = (!(_info.placesState[_local_10] == 0));
                                _local_9 = (_playerItems[(_local_10 + 1)] as ChallengeRoomPlayerItem);
                                if (_local_10 < 3)
                                {
                                    _local_9.place = (_local_10 + 1);
                                }
                                else
                                {
                                    if (_local_10 == 5)
                                    {
                                        _local_9.place = _local_10;
                                    };
                                };
                                _local_9.info = _info.findPlayerByPlace(_local_10);
                                _local_9.opened = (!(_info.placesState[_local_10] == 0));
                            }
                            else
                            {
                                _local_8 = (_playerItems[_local_10] as RoomPlayerItem);
                                if (_local_10 < 5)
                                {
                                    _local_8.place = (_local_10 + 1);
                                };
                                _local_8.disposeCharacterContainer();
                                _local_8.info = _info.findPlayerByPlace(_local_10);
                                _local_8.opened = (!(_info.placesState[_local_10] == 0));
                                _local_9 = (_playerItems[(_local_10 + 1)] as ChallengeRoomPlayerItem);
                                _local_9.place = _local_10;
                                _local_9.info = _info.findPlayerByPlace(_local_10);
                                _local_9.opened = (!(_info.placesState[_local_10] == 0));
                            };
                        }
                        else
                        {
                            if ((_local_2 % 2) != 1)
                            {
                                _local_9 = (_playerItems[_local_10] as ChallengeRoomPlayerItem);
                                if (_local_10 <= 5)
                                {
                                    _local_9.place = _local_10;
                                };
                                _local_9.info = _info.findPlayerByPlace(_local_10);
                                _local_9.opened = (!(_info.placesState[_local_10] == 0));
                            }
                            else
                            {
                                _local_8 = (_playerItems[(_local_10 - 1)] as RoomPlayerItem);
                                if (_local_10 != 5)
                                {
                                    _local_8.place = _local_10;
                                };
                                _local_8.disposeCharacterContainer();
                                _local_8.info = _info.findPlayerByPlace(_local_10);
                                _local_8.opened = (!(_info.placesState[_local_10] == 0));
                            };
                        };
                    };
                };
                _local_10++;
            };
            PlayerManager.Instance.dispatchEvent(new Event(PlayerManager.UPDATE_ROOMPLAYER));
            if (isViewerRoom)
            {
                _local_10 = 0;
                while (_local_10 < 2)
                {
                    if (((_viewerItems) && (_viewerItems[_local_10])))
                    {
                        _local_11 = (_viewerItems[_local_10] as RoomViewerItem);
                        _local_11.info = _info.findPlayerByPlace((_local_10 + 6));
                        _local_11.opened = (!(_info.placesState[(_local_10 + 6)] == 0));
                    };
                    _local_10++;
                };
            };
        }

        override protected function removeEvents():void
        {
            super.removeEvents();
            this._btnSwitchTeam.removeEventListener(MouseEvent.CLICK, this.__switchTeam);
        }

        private function __switchTeam(_arg_1:MouseEvent):void
        {
            SoundManager.instance.play("012");
            if (((this._clickTimer) && (this._clickTimer.running)))
            {
                MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.game.fightModelPropBar.error"));
                return;
            };
            if ((!(this._clickTimer)))
            {
                this._clickTimer = new Timer(1000, 1);
            };
            this._clickTimer.start();
            if (((!(_info.selfRoomPlayer.isReady)) || (_info.selfRoomPlayer.isHost)))
            {
                GameInSocketOut.sendGameTeam(int(((_info.selfRoomPlayer.team == RoomPlayer.BLUE_TEAM) ? RoomPlayer.RED_TEAM : RoomPlayer.BLUE_TEAM)));
            };
        }

        private function __clickTimerHandler(_arg_1:TimerEvent):void
        {
            if (this._clickTimer)
            {
                this._clickTimer.stop();
                this._clickTimer = null;
            };
        }


    }
}//package room.view.roomView

