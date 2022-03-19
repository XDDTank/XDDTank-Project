// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//roomLoading.view.RoomLoadingView

package roomLoading.view
{
    import flash.display.Sprite;
    import com.pickgliss.ui.core.Disposeable;
    import flash.display.Bitmap;
    import game.model.GameInfo;
    import __AS3__.vec.Vector;
    import flash.utils.Timer;
    import ddt.loader.TrainerLoader;
    import com.pickgliss.ui.image.Image;
    import com.pickgliss.ui.image.ScaleFrameImage;
    import com.pickgliss.ui.text.FilterFrameText;
    import com.pickgliss.ui.text.GradientText;
    import ddt.view.common.LevelIcon;
    import bagAndInfo.cell.BaseCell;
    import ddt.manager.TimeManager;
    import com.pickgliss.ui.ComponentFactory;
    import room.RoomManager;
    import flash.events.Event;
    import game.model.GameModeType;
    import room.model.RoomInfo;
    import flash.events.TimerEvent;
    import ddt.manager.StateManager;
    import ddt.states.StateType;
    import com.greensock.TweenLite;
    import room.model.RoomPlayer;
    import game.model.Player;
    import pet.date.PetInfo;
    import pet.date.PetSkillInfo;
    import ddt.data.BallInfo;
    import ddt.manager.LoadBombManager;
    import ddt.manager.PlayerManager;
    import im.IMController;
    import ddt.manager.PetSkillManager;
    import ddt.manager.BallManager;
    import ddt.loader.MapLoader;
    import ddt.manager.MapManager;
    import SingleDungeon.SingleDungeonManager;
    import com.pickgliss.loader.ModuleLoader;
    import com.pickgliss.loader.LoadResourceManager;
    import ddt.manager.PathManager;
    import com.pickgliss.loader.BaseLoader;
    import flash.geom.Rectangle;
    import ddt.utils.PositionUtils;
    import flash.geom.Point;
    import ddt.manager.ItemManager;
    import ddt.data.goods.ItemTemplateInfo;
    import vip.VipController;
    import worldboss.WorldBossManager;
    import ddt.manager.SocketManager;
    import ddt.manager.GameInSocketOut;
    import com.pickgliss.utils.ObjectUtils;
    import com.greensock.TweenMax;
    import __AS3__.vec.*;

    public class RoomLoadingView extends Sprite implements Disposeable 
    {

        private static const DELAY_TIME:int = 1000;

        private var _bg:Bitmap;
        private var _gameInfo:GameInfo;
        private var _versus:RoomLoadingVersusItem;
        private var _countDownTxt:RoomLoadingCountDownNum;
        private var _battleField:RoomLoadingBattleFieldItem;
        private var _viewerItem:RoomLoadingViewerItem;
        private var _dungeonMapItem:RoomLoadingDungeonMapItem;
        private var _characterItems:Vector.<RoomLoadingCharacterItem>;
        private var _prgressItem:Vector.<RoomLoadingPrgressItem>;
        private var _countDownTimer:Timer;
        private var _selfFinish:Boolean;
        private var _trainerLoad:TrainerLoader;
        private var _chatViewBg:Image;
        private var blueIdx:int = 1;
        private var redIdx:int = 1;
        private var blueCharacterIndex:int = 1;
        private var redCharacterIndex:int = 1;
        private var blueBig:RoomLoadingCharacterItem;
        private var redBig:RoomLoadingCharacterItem;
        private var _leaving:Boolean = false;
        private var _amountOfFinishedPlayer:int = 0;
        private var _delayBeginTime:Number = 0;
        private var _redTeamBg:ScaleFrameImage;
        private var _blueTeamBg:ScaleFrameImage;
        private var _redVsType:int;
        private var _blueVsType:int;
        private var _vsType:int;
        private var _nameTxt:FilterFrameText;
        private var _vipName:GradientText;
        private var _levelIcon:LevelIcon;
        private var _weaponcell:BaseCell;
        private var _index:int = 1;
        private var _timer:Timer;
        private var _unloadedmsg:String = "";

        public function RoomLoadingView(_arg_1:GameInfo)
        {
            this._gameInfo = _arg_1;
            this.init();
        }

        private function init():void
        {
            TimeManager.Instance.enterFightTime = new Date().getTime();
            this._characterItems = new Vector.<RoomLoadingCharacterItem>();
            this._prgressItem = new Vector.<RoomLoadingPrgressItem>();
            this._bg = ComponentFactory.Instance.creatBitmap("asset.roomloading.vsBg");
            this._redTeamBg = ComponentFactory.Instance.creatComponentByStylename("asset.ddtroomloading.redBg");
            this._redTeamBg.setFrame(2);
            this._blueTeamBg = ComponentFactory.Instance.creatComponentByStylename("asset.ddtroomloading.blueBg");
            this._blueTeamBg.setFrame(2);
            this._countDownTxt = ComponentFactory.Instance.creatCustomObject("roomLoading.CountDownItem");
            this._versus = ComponentFactory.Instance.creatCustomObject("roomLoading.VersusItem", [RoomManager.Instance.current.gameMode]);
            this._versus.addEventListener(Event.COMPLETE, this.__moveCountDownTxt);
            this._battleField = ComponentFactory.Instance.creatCustomObject("roomLoading.BattleFieldItem", [this._gameInfo.mapIndex]);
            this._viewerItem = ComponentFactory.Instance.creatCustomObject("roomLoading.ViewerItem");
            if (((((((this._gameInfo.gameMode == GameModeType.SIMPLE_DUNGOEN) || (this._gameInfo.gameMode == 8)) || (this._gameInfo.gameMode == 10)) || (this._gameInfo.gameMode == 17)) || (this._gameInfo.gameMode == GameModeType.SINGLE_DUNGOEN)) || (this._gameInfo.gameMode == GameModeType.MULTI_DUNGEON)))
            {
                this._dungeonMapItem = ComponentFactory.Instance.creatCustomObject("roomLoading.DungeonMapItem");
                this._blueTeamBg.visible = false;
            };
            this._selfFinish = false;
            addChild(this._bg);
            addChild(this._redTeamBg);
            addChild(this._blueTeamBg);
            addChild(this._versus);
            addChild(this._countDownTxt);
            addChild(this._battleField);
            addChild(this._viewerItem);
            this.initLoadingItems();
            if (this._dungeonMapItem)
            {
                addChild(this._dungeonMapItem);
            };
            var _local_1:int = ((RoomManager.Instance.current.type == RoomInfo.DUNGEON_ROOM) ? 94 : 64);
            this._countDownTimer = new Timer(1000, _local_1);
            this._countDownTimer.addEventListener(TimerEvent.TIMER, this.__countDownTick);
            this._countDownTimer.addEventListener(TimerEvent.TIMER_COMPLETE, this.__countDownComplete);
            this._countDownTimer.start();
            StateManager.currentStateType = StateType.GAME_LOADING;
        }

        private function __moveCountDownTxt(_arg_1:Event):void
        {
            TweenLite.to(this._countDownTxt, 0.1, {
                "x":322,
                "y":267
            });
        }

        private function initLoadingItems():void
        {
            var _local_2:int;
            var _local_3:int;
            var _local_5:int;
            var _local_6:RoomPlayer;
            var _local_7:RoomPlayer;
            var _local_9:RoomPlayer;
            var _local_10:RoomLoadingCharacterItem;
            var _local_11:RoomLoadingPrgressItem;
            var _local_12:Player;
            var _local_13:PetInfo;
            var _local_14:int;
            var _local_15:PetSkillInfo;
            var _local_16:BallInfo;
            var _local_1:int = this._gameInfo.roomPlayers.length;
            var _local_4:Array = this._gameInfo.roomPlayers;
            LoadBombManager.Instance.loadFullWeaponBombBitMap(_local_4);
            for each (_local_6 in _local_4)
            {
                if (PlayerManager.Instance.Self.ID == _local_6.playerInfo.ID)
                {
                    _local_5 = _local_6.team;
                };
            };
            for each (_local_7 in _local_4)
            {
                if (!_local_7.isViewer)
                {
                    if ((_local_7.team == RoomPlayer.BLUE_TEAM))
                    {
                        _local_2++;
                    }
                    else
                    {
                        _local_3++;
                    };
                    if (((_local_7.team == _local_5) && (!(PlayerManager.Instance.Self.ID == _local_6.playerInfo.ID))))
                    {
                        IMController.Instance.saveRecentContactsID(_local_7.playerInfo.ID);
                    };
                };
            };
            if ((((!(this._gameInfo.gameMode == GameModeType.SIMPLE_DUNGOEN)) && (!(this._gameInfo.gameMode == 2))) && (!(this._gameInfo.gameMode == GameModeType.MULTI_DUNGEON))))
            {
                if ((_local_2 + _local_3) <= 2)
                {
                    this._vsType = 1;
                    this._redVsType = 1;
                    this._blueVsType = 1;
                    this._redTeamBg.setFrame(1);
                    this._blueTeamBg.setFrame(1);
                }
                else
                {
                    if ((_local_2 + _local_3) <= 4)
                    {
                        this._vsType = 2;
                        this._redVsType = 2;
                        this._blueVsType = 2;
                        this._redTeamBg.setFrame(2);
                        this._blueTeamBg.setFrame(2);
                    }
                    else
                    {
                        this._vsType = 3;
                        this._redVsType = 3;
                        this._blueVsType = 3;
                        this._redTeamBg.setFrame(3);
                        this._blueTeamBg.setFrame(3);
                    };
                };
            }
            else
            {
                if (this._gameInfo.gameMode == 2)
                {
                    if (((_local_3 + _local_2) % 2) != 1)
                    {
                        if (((_local_3 == 1) && (_local_2 == 3)))
                        {
                            this._vsType = 3;
                            this._redVsType = 1;
                            this._blueVsType = 3;
                            this._redTeamBg.setFrame(3);
                            this._blueTeamBg.setFrame(1);
                        }
                        else
                        {
                            if (((_local_3 == 3) && (_local_2 == 1)))
                            {
                                this._vsType = 3;
                                this._redVsType = 3;
                                this._blueVsType = 1;
                                this._redTeamBg.setFrame(1);
                                this._blueTeamBg.setFrame(3);
                            }
                            else
                            {
                                if (_local_3 == 1)
                                {
                                    this._vsType = 1;
                                    this._redVsType = 1;
                                    this._blueVsType = 1;
                                    this._redTeamBg.setFrame(1);
                                    this._blueTeamBg.setFrame(1);
                                }
                                else
                                {
                                    if (_local_3 == 2)
                                    {
                                        this._vsType = 2;
                                        this._redVsType = 2;
                                        this._blueVsType = 2;
                                        this._redTeamBg.setFrame(2);
                                        this._blueTeamBg.setFrame(2);
                                    }
                                    else
                                    {
                                        this._vsType = 3;
                                        this._redVsType = 3;
                                        this._blueVsType = 3;
                                        this._redTeamBg.setFrame(3);
                                        this._blueTeamBg.setFrame(3);
                                    };
                                };
                            };
                        };
                    }
                    else
                    {
                        if (((_local_3 == 1) && (_local_2 == 2)))
                        {
                            this._vsType = 2;
                            this._redVsType = 1;
                            this._blueVsType = 2;
                            this._redTeamBg.setFrame(2);
                            this._blueTeamBg.setFrame(1);
                        }
                        else
                        {
                            if (((_local_3 == 1) && (_local_2 == 3)))
                            {
                                this._vsType = 3;
                                this._redVsType = 1;
                                this._blueVsType = 3;
                                this._redTeamBg.setFrame(3);
                                this._blueTeamBg.setFrame(1);
                            }
                            else
                            {
                                if (((_local_3 == 2) && (_local_2 == 1)))
                                {
                                    this._vsType = 2;
                                    this._redVsType = 2;
                                    this._blueVsType = 1;
                                    this._redTeamBg.setFrame(1);
                                    this._blueTeamBg.setFrame(2);
                                }
                                else
                                {
                                    if (((_local_3 == 2) && (_local_2 == 3)))
                                    {
                                        this._vsType = 3;
                                        this._redVsType = 2;
                                        this._blueVsType = 3;
                                        this._redTeamBg.setFrame(3);
                                        this._blueTeamBg.setFrame(2);
                                    }
                                    else
                                    {
                                        if (((_local_3 == 3) && (_local_2 == 1)))
                                        {
                                            this._vsType = 3;
                                            this._redVsType = 3;
                                            this._blueVsType = 1;
                                            this._redTeamBg.setFrame(1);
                                            this._blueTeamBg.setFrame(3);
                                        }
                                        else
                                        {
                                            if (((_local_3 == 3) && (_local_2 == 2)))
                                            {
                                                this._vsType = 3;
                                                this._redVsType = 3;
                                                this._blueVsType = 2;
                                                this._redTeamBg.setFrame(2);
                                                this._blueTeamBg.setFrame(3);
                                            };
                                        };
                                    };
                                };
                            };
                        };
                    };
                }
                else
                {
                    if ((_local_2 + _local_3) == 1)
                    {
                        this._vsType = 1;
                        this._redVsType = 1;
                        this._blueVsType = 1;
                        this._redTeamBg.setFrame(1);
                        this._blueTeamBg.setFrame(1);
                    }
                    else
                    {
                        if ((_local_2 + _local_3) == 2)
                        {
                            this._vsType = 2;
                            this._redVsType = 2;
                            this._blueVsType = 2;
                            this._redTeamBg.setFrame(2);
                            this._blueTeamBg.setFrame(2);
                        }
                        else
                        {
                            this._vsType = 3;
                            this._redVsType = 3;
                            this._blueVsType = 3;
                            this._redTeamBg.setFrame(3);
                            this._blueTeamBg.setFrame(3);
                        };
                    };
                };
            };
            var _local_8:int;
            while (_local_8 < _local_1)
            {
                _local_9 = this._gameInfo.roomPlayers[_local_8];
                if (_local_9.isViewer)
                {
                    addChild(this._viewerItem);
                }
                else
                {
                    _local_10 = new RoomLoadingCharacterItem(_local_9, this._gameInfo, this._vsType);
                    _local_11 = new RoomLoadingPrgressItem(_local_9, this._gameInfo, this._vsType);
                    addChild(_local_11);
                    _local_12 = this._gameInfo.findLivingByPlayerID(_local_9.playerInfo.ID, _local_9.playerInfo.ZoneID);
                    this.initCharacter(_local_12, _local_10);
                    this.initRoomItem(_local_10, this._vsType, _local_12, _local_11);
                    _local_11.addEventListener(RoomLoadingPrgressItem.LOADING_FINISHED, this.__onLoadingFinished);
                    _local_13 = _local_12.playerInfo.currentPet;
                    if (_local_13)
                    {
                        for each (_local_14 in _local_13.skills)
                        {
                            if (((_local_14 > 0) && (_local_14 < 1000)))
                            {
                                _local_15 = PetSkillManager.instance.getSkillByID(_local_14);
                                if (_local_15.NewBallID != -1)
                                {
                                    _local_16 = BallManager.findBall(_local_15.NewBallID);
                                    _local_16.loadCraterBitmap();
                                };
                            };
                        };
                    };
                };
                _local_8++;
            };
            if (this.blueBig)
            {
                addChild(this.blueBig);
            };
            if (this.redBig)
            {
                addChild(this.redBig);
            };
            this._gameInfo.loaderMap = new MapLoader(MapManager.getMapInfo(this._gameInfo.mapIndex));
            this._gameInfo.loaderMap.load();
            switch (SingleDungeonManager.Instance.currentMapId)
            {
                case 1011:
                case 2011:
                    this._trainerLoad = new TrainerLoader("7");
                    break;
                case 1005:
                case 2005:
                    this._trainerLoad = new TrainerLoader("8");
                    break;
                case 1008:
                case 2008:
                    this._trainerLoad = new TrainerLoader("9");
                    break;
                case 1007:
                case 2007:
                    this._trainerLoad = new TrainerLoader("10");
                    break;
            };
            if (this._trainerLoad)
            {
                this._trainerLoad.load();
            };
            this.loadMagicSoul();
        }

        private function loadMagicSoul():void
        {
            if ((!(ModuleLoader.hasDefinition("asset.game.dropEffect.magicSoul"))))
            {
                LoadResourceManager.instance.startLoad(LoadResourceManager.instance.createLoader(PathManager.solveMagicSoul(), BaseLoader.MODULE_LOADER));
            };
        }

        protected function __onLoadingFinished(_arg_1:Event):void
        {
            this._amountOfFinishedPlayer++;
            if (this._amountOfFinishedPlayer == this._characterItems.length)
            {
                this.leave();
            };
        }

        private function __timerComplete(_arg_1:TimerEvent):void
        {
            if (this._timer)
            {
                this._timer.stop();
                this._timer.removeEventListener(TimerEvent.TIMER_COMPLETE, this.__timerComplete);
                this._timer = null;
                this.leave();
            };
        }

        private function initCharacter(_arg_1:Player, _arg_2:RoomLoadingCharacterItem):void
        {
            var _local_3:Rectangle = ComponentFactory.Instance.creatCustomObject("asset.roomloading.BigCharacterSize");
            var _local_4:Rectangle = ComponentFactory.Instance.creatCustomObject("asset.roomloading.SuitCharacterSize");
            _arg_1.movie = _arg_2.info.movie;
            _arg_1.character = _arg_2.info.character;
            _arg_1.character.showGun = false;
            _arg_1.character.showWing = false;
            if (_arg_2.info.team == RoomPlayer.BLUE_TEAM)
            {
                if (((_arg_1.isSelf) || ((this.blueCharacterIndex == 1) && (!(this._gameInfo.selfGamePlayer.team == RoomPlayer.BLUE_TEAM)))))
                {
                    if (_arg_1.playerInfo.getShowSuits())
                    {
                        PositionUtils.setPos(_arg_2.displayMc, "asset.roomloading.SuitCharacterBluePos");
                        _arg_1.character.showWithSize(false, -1, _local_4.width, _local_4.height);
                    }
                    else
                    {
                        PositionUtils.setPos(_arg_2.displayMc, "asset.roomloading.BigCharacterBluePos");
                        _arg_1.character.showWithSize(false, -1, _local_3.width, _local_3.height);
                        if (this._redVsType == 1)
                        {
                            _arg_1.character.scaleX = -1.3;
                            _arg_1.character.scaleY = 1.3;
                        }
                        else
                        {
                            if (this._redVsType == 2)
                            {
                                _arg_1.character.scaleX = -1.2;
                                _arg_1.character.scaleY = 1.2;
                            }
                            else
                            {
                                _arg_1.character.scaleX = -1;
                                _arg_1.character.scaleY = 1;
                            };
                        };
                    };
                }
                else
                {
                    PositionUtils.setPos(_arg_2.displayMc, "asset.roomloading.SmallCharacterBluePos");
                    _arg_1.character.showWithSize(false, -1, _local_3.width, _local_3.height);
                    if (this._blueVsType == 1)
                    {
                        _arg_1.character.scaleX = -1.3;
                        _arg_1.character.scaleY = 1.3;
                    }
                    else
                    {
                        if (this._blueVsType == 2)
                        {
                            _arg_1.character.scaleX = -0.9;
                            _arg_1.character.scaleY = 0.9;
                        }
                        else
                        {
                            _arg_1.character.scaleX = -0.7;
                            _arg_1.character.scaleY = 0.7;
                        };
                    };
                };
                _arg_2.appear(this.blueCharacterIndex.toString());
                _arg_2.index = this.blueCharacterIndex;
                this.index = this.blueCharacterIndex;
                this.blueCharacterIndex++;
            }
            else
            {
                if (((_arg_1.isSelf) || ((this.redCharacterIndex == 1) && (!(this._gameInfo.selfGamePlayer.team == RoomPlayer.RED_TEAM)))))
                {
                    if (_arg_1.playerInfo.getShowSuits())
                    {
                        PositionUtils.setPos(_arg_2.displayMc, "asset.roomloading.SuitCharacterRedPos");
                        _arg_1.character.showWithSize(false, -1, _local_4.width, _local_4.height);
                    }
                    else
                    {
                        _arg_1.character.showWithSize(false, -1, _local_3.width, _local_3.height);
                        if (this._blueVsType == 1)
                        {
                            _arg_1.character.scaleX = -1.3;
                            _arg_1.character.scaleY = 1.3;
                        }
                        else
                        {
                            if (this._blueVsType == 2)
                            {
                                _arg_1.character.scaleX = -1.2;
                                _arg_1.character.scaleY = 1.2;
                            }
                            else
                            {
                                _arg_1.character.scaleX = -1;
                                _arg_1.character.scaleY = 1;
                            };
                        };
                        PositionUtils.setPos(_arg_2.displayMc, "asset.roomloading.BigCharacterRedPos");
                    };
                }
                else
                {
                    _arg_1.character.showWithSize(false, -1, _local_3.width, _local_3.height);
                    PositionUtils.setPos(_arg_2.displayMc, "asset.roomloading.SmallCharacterRedPos");
                    if (this._redVsType == 1)
                    {
                        _arg_1.character.scaleX = -1.3;
                        _arg_1.character.scaleY = 1.3;
                    }
                    else
                    {
                        if (this._redVsType == 2)
                        {
                            _arg_1.character.scaleX = -0.9;
                            _arg_1.character.scaleY = 0.9;
                        }
                        else
                        {
                            _arg_1.character.scaleX = -0.7;
                            _arg_1.character.scaleY = 0.7;
                        };
                    };
                };
                _arg_2.appear(this.redCharacterIndex.toString());
                _arg_2.index = this.redCharacterIndex;
                this.index = this.redCharacterIndex;
                this.redCharacterIndex++;
            };
        }

        private function initRoomItem(_arg_1:RoomLoadingCharacterItem, _arg_2:int, _arg_3:Player, _arg_4:RoomLoadingPrgressItem):void
        {
            var _local_5:Point;
            var _local_9:RoomPlayer;
            if ((((_arg_3.team == 4) || (_arg_3.team == 5)) && ((((((this._gameInfo.gameMode == GameModeType.SIMPLE_DUNGOEN) || (this._gameInfo.gameMode == 8)) || (this._gameInfo.gameMode == 10)) || (this._gameInfo.gameMode == 17)) || (this._gameInfo.gameMode == GameModeType.SINGLE_DUNGOEN)) || (this._gameInfo.gameMode == GameModeType.MULTI_DUNGEON))))
            {
                _arg_3.team = 1;
            };
            var _local_6:String = ((_arg_3.team == RoomPlayer.BLUE_TEAM) ? "blueTeam" : "redTeam");
            var _local_7:ItemTemplateInfo = ItemManager.Instance.getTemplateById(_arg_3.playerInfo.WeaponID);
            var _local_8:int;
            while (_local_8 < this._gameInfo.roomPlayers.length)
            {
                _local_9 = this._gameInfo.roomPlayers[_local_8];
                if (((_local_9.isSelf) && (_local_9.isViewer)))
                {
                    this._gameInfo.selfGamePlayer.team = 3;
                };
                _local_8++;
            };
            if (_arg_1.info.team == RoomPlayer.BLUE_TEAM)
            {
                if (((_arg_1.info.isSelf) || ((this.blueIdx == 1) && (!(this._gameInfo.selfGamePlayer.team == RoomPlayer.BLUE_TEAM)))))
                {
                    this._nameTxt = ComponentFactory.Instance.creatComponentByStylename("roomLoading.CharacterItemNameTxt");
                    this._nameTxt.text = _arg_3.playerInfo.NickName;
                    PositionUtils.setPos(this._nameTxt, (((((("roomLoading.CharacterItem." + _local_6) + "_") + 1) + "_") + this._blueVsType) + ".NamePos"));
                    if (_arg_3.playerInfo.IsVIP)
                    {
                        this._vipName = VipController.instance.getVipNameTxt(this._nameTxt.width, _arg_3.playerInfo.VIPtype);
                        this._vipName.x = this._nameTxt.x;
                        this._vipName.y = this._nameTxt.y;
                        this._vipName.text = this._nameTxt.text;
                        addChild(this._vipName);
                    }
                    else
                    {
                        addChild(this._nameTxt);
                    };
                    this._levelIcon = new LevelIcon();
                    this._levelIcon.setInfo(_arg_3.playerInfo.Grade, _arg_3.playerInfo.Repute, _arg_3.playerInfo.WinCount, _arg_3.playerInfo.TotalCount, _arg_3.playerInfo.FightPower, _arg_3.playerInfo.Offer, true, true, _arg_3.team);
                    PositionUtils.setPos(this._levelIcon, (((((("roomLoading.CharacterItem." + _local_6) + "_") + 1) + "_") + this._blueVsType) + ".IconStartPos"));
                    addChild(this._levelIcon);
                    this._weaponcell = new BaseCell(new Sprite(), _local_7);
                    this._weaponcell.setContentSize(58, 58);
                    this._weaponcell.mouseChildren = false;
                    this._weaponcell.mouseEnabled = false;
                    PositionUtils.setPos(this._weaponcell, (((((("asset.roomLoadingPlayerItem." + _local_6) + "_") + 1) + "_") + this._blueVsType) + ".smallWeaponPos"));
                    addChild(this._weaponcell);
                    PositionUtils.setPos(_arg_1, ("asset.roomLoading.CharacterItemBluePos_1_" + this._blueVsType.toString()));
                    _local_5 = ComponentFactory.Instance.creatCustomObject("asset.roomLoading.CharacterItemBlueFromPos_1");
                    this.blueBig = _arg_1;
                    PositionUtils.setPos(_arg_4.perecentageTxt, (((((("asset.roomLoadingPlayerItem." + _local_6) + "_") + 1) + "_") + this._blueVsType) + ".progressPos"));
                    PositionUtils.setPos(_arg_4.okTxt, (((((("asset.roomLoadingPlayerItem." + _local_6) + "_") + 1) + "_") + this._blueVsType) + ".okPos"));
                    if (this._gameInfo.selfGamePlayer.team != RoomPlayer.BLUE_TEAM)
                    {
                        this.blueIdx++;
                    };
                }
                else
                {
                    if (this.blueIdx == 1)
                    {
                        this.blueIdx++;
                    };
                    this._nameTxt = ComponentFactory.Instance.creatComponentByStylename("roomLoading.CharacterItemNameTxt");
                    this._nameTxt.text = _arg_3.playerInfo.NickName;
                    PositionUtils.setPos(this._nameTxt, (((((("roomLoading.CharacterItem." + _local_6) + "_") + this.blueIdx) + "_") + this._blueVsType) + ".NamePos"));
                    if (_arg_3.playerInfo.IsVIP)
                    {
                        this._vipName = VipController.instance.getVipNameTxt(this._nameTxt.width, _arg_3.playerInfo.VIPtype);
                        this._vipName.x = this._nameTxt.x;
                        this._vipName.y = this._nameTxt.y;
                        this._vipName.text = this._nameTxt.text;
                        addChild(this._vipName);
                    }
                    else
                    {
                        addChild(this._nameTxt);
                    };
                    this._levelIcon = new LevelIcon();
                    this._levelIcon.setInfo(_arg_3.playerInfo.Grade, _arg_3.playerInfo.Repute, _arg_3.playerInfo.WinCount, _arg_3.playerInfo.TotalCount, _arg_3.playerInfo.FightPower, _arg_3.playerInfo.Offer, true, true, _arg_3.team);
                    PositionUtils.setPos(this._levelIcon, (((((("roomLoading.CharacterItem." + _local_6) + "_") + this.blueIdx) + "_") + this._blueVsType) + ".IconStartPos"));
                    addChild(this._levelIcon);
                    this._weaponcell = new BaseCell(new Sprite(), _local_7);
                    this._weaponcell.setContentSize(58, 58);
                    this._weaponcell.mouseChildren = false;
                    this._weaponcell.mouseEnabled = false;
                    PositionUtils.setPos(this._weaponcell, (((((("asset.roomLoadingPlayerItem." + _local_6) + "_") + this.blueIdx) + "_") + this._blueVsType) + ".smallWeaponPos"));
                    addChild(this._weaponcell);
                    PositionUtils.setPos(_arg_1, ((("asset.roomLoading.CharacterItemBluePos_" + this.blueIdx.toString()) + "_") + this._blueVsType.toString()));
                    PositionUtils.setPos(_arg_4.perecentageTxt, (((((("asset.roomLoadingPlayerItem." + _local_6) + "_") + this.blueIdx) + "_") + this._blueVsType) + ".progressPos"));
                    PositionUtils.setPos(_arg_4.okTxt, (((((("asset.roomLoadingPlayerItem." + _local_6) + "_") + this.blueIdx) + "_") + this._blueVsType) + ".okPos"));
                    _local_5 = ComponentFactory.Instance.creatCustomObject(("asset.roomLoading.CharacterItemBlueFromPos_" + this.blueIdx.toString()));
                    this.blueIdx++;
                };
            }
            else
            {
                if (((_arg_1.info.isSelf) || ((this.redIdx == 1) && (!(this._gameInfo.selfGamePlayer.team == RoomPlayer.RED_TEAM)))))
                {
                    this._nameTxt = ComponentFactory.Instance.creatComponentByStylename("roomLoading.CharacterItemNameTxt");
                    this._nameTxt.text = _arg_3.playerInfo.NickName;
                    PositionUtils.setPos(this._nameTxt, (((((("roomLoading.CharacterItem." + _local_6) + "_") + 1) + "_") + this._redVsType) + ".NamePos"));
                    if (_arg_3.playerInfo.IsVIP)
                    {
                        this._vipName = VipController.instance.getVipNameTxt(this._nameTxt.width, _arg_3.playerInfo.VIPtype);
                        this._vipName.x = this._nameTxt.x;
                        this._vipName.y = this._nameTxt.y;
                        this._vipName.text = this._nameTxt.text;
                        addChild(this._vipName);
                    }
                    else
                    {
                        addChild(this._nameTxt);
                    };
                    this._levelIcon = new LevelIcon();
                    this._levelIcon.setInfo(_arg_3.playerInfo.Grade, _arg_3.playerInfo.Repute, _arg_3.playerInfo.WinCount, _arg_3.playerInfo.TotalCount, _arg_3.playerInfo.FightPower, _arg_3.playerInfo.Offer, true, true, _arg_3.team);
                    PositionUtils.setPos(this._levelIcon, (((((("roomLoading.CharacterItem." + _local_6) + "_") + 1) + "_") + this._redVsType) + ".IconStartPos"));
                    addChild(this._levelIcon);
                    this._weaponcell = new BaseCell(new Sprite(), _local_7);
                    this._weaponcell.setContentSize(58, 58);
                    this._weaponcell.mouseChildren = false;
                    this._weaponcell.mouseEnabled = false;
                    PositionUtils.setPos(this._weaponcell, (((((("asset.roomLoadingPlayerItem." + _local_6) + "_") + 1) + "_") + this._redVsType) + ".smallWeaponPos"));
                    addChild(this._weaponcell);
                    PositionUtils.setPos(_arg_1, ("asset.roomLoading.CharacterItemRedPos_1_" + this._redVsType.toString()));
                    PositionUtils.setPos(_arg_4.perecentageTxt, (((((("asset.roomLoadingPlayerItem." + _local_6) + "_") + 1) + "_") + this._redVsType) + ".progressPos"));
                    PositionUtils.setPos(_arg_4.okTxt, (((((("asset.roomLoadingPlayerItem." + _local_6) + "_") + 1) + "_") + this._redVsType) + ".okPos"));
                    _local_5 = ComponentFactory.Instance.creatCustomObject("asset.roomLoading.CharacterItemRedFromPos_1");
                    this.redBig = _arg_1;
                    if (this._gameInfo.selfGamePlayer.team != RoomPlayer.RED_TEAM)
                    {
                        this.redIdx++;
                    };
                }
                else
                {
                    if (this.redIdx == 1)
                    {
                        this.redIdx++;
                    };
                    this._nameTxt = ComponentFactory.Instance.creatComponentByStylename("roomLoading.CharacterItemNameTxt");
                    this._nameTxt.text = _arg_3.playerInfo.NickName;
                    PositionUtils.setPos(this._nameTxt, (((((("roomLoading.CharacterItem." + _local_6) + "_") + this.redIdx) + "_") + this._redVsType) + ".NamePos"));
                    if (_arg_3.playerInfo.IsVIP)
                    {
                        this._vipName = VipController.instance.getVipNameTxt(this._nameTxt.width, _arg_3.playerInfo.VIPtype);
                        this._vipName.x = this._nameTxt.x;
                        this._vipName.y = this._nameTxt.y;
                        this._vipName.text = this._nameTxt.text;
                        addChild(this._vipName);
                    }
                    else
                    {
                        addChild(this._nameTxt);
                    };
                    this._levelIcon = new LevelIcon();
                    this._levelIcon.setInfo(_arg_3.playerInfo.Grade, _arg_3.playerInfo.Repute, _arg_3.playerInfo.WinCount, _arg_3.playerInfo.TotalCount, _arg_3.playerInfo.FightPower, _arg_3.playerInfo.Offer, true, true, _arg_3.team);
                    PositionUtils.setPos(this._levelIcon, (((((("roomLoading.CharacterItem." + _local_6) + "_") + this.redIdx) + "_") + this._redVsType) + ".IconStartPos"));
                    addChild(this._levelIcon);
                    this._weaponcell = new BaseCell(new Sprite(), _local_7);
                    this._weaponcell.setContentSize(58, 58);
                    this._weaponcell.mouseChildren = false;
                    this._weaponcell.mouseEnabled = false;
                    PositionUtils.setPos(this._weaponcell, (((((("asset.roomLoadingPlayerItem." + _local_6) + "_") + this.redIdx) + "_") + this._redVsType) + ".smallWeaponPos"));
                    addChild(this._weaponcell);
                    PositionUtils.setPos(_arg_1, ((("asset.roomLoading.CharacterItemRedPos_" + this.redIdx.toString()) + "_") + this._redVsType.toString()));
                    PositionUtils.setPos(_arg_4.perecentageTxt, (((((("asset.roomLoadingPlayerItem." + _local_6) + "_") + this.redIdx) + "_") + this._redVsType) + ".progressPos"));
                    PositionUtils.setPos(_arg_4.okTxt, (((((("asset.roomLoadingPlayerItem." + _local_6) + "_") + this.redIdx) + "_") + this._redVsType) + ".okPos"));
                    _local_5 = ComponentFactory.Instance.creatCustomObject(("asset.roomLoading.CharacterItemRedFromPos_" + this.redIdx.toString()));
                    this.redIdx++;
                };
            };
            this._characterItems.push(_arg_1);
            this._prgressItem.push(_arg_4);
            addChild(_arg_1);
        }

        private function leave():void
        {
            var _local_1:int;
            if ((!(this._leaving)))
            {
                _local_1 = 0;
                while (_local_1 < this._characterItems.length)
                {
                    if (this._characterItems[_local_1].info.team != RoomPlayer.RED_TEAM)
                    {
                        TweenLite.to(this._characterItems[_local_1], 0.1, {
                            "x":(this._characterItems[_local_1].x - 291),
                            "y":this._characterItems[_local_1].y
                        });
                    }
                    else
                    {
                        TweenLite.to(this._characterItems[_local_1], 0.1, {
                            "x":(this._characterItems[_local_1].x + 267),
                            "y":this._characterItems[_local_1].y
                        });
                    };
                    _local_1++;
                };
                if (this._dungeonMapItem)
                {
                    TweenLite.to(this._dungeonMapItem, 0.1, {
                        "x":(this._dungeonMapItem.x + 267),
                        "y":this._dungeonMapItem.y
                    });
                };
                this._leaving = true;
            };
        }

        private function __countDownTick(_arg_1:TimerEvent):void
        {
            this._selfFinish = this.checkProgress();
            this._countDownTxt.updateNum();
            if (this._selfFinish)
            {
                dispatchEvent(new Event(Event.COMPLETE));
            };
        }

        private function __countDownComplete(_arg_1:TimerEvent):void
        {
            if ((!(this._selfFinish)))
            {
                if (((RoomManager.Instance.current.type == RoomInfo.MATCH_ROOM) || (RoomManager.Instance.current.type == RoomInfo.CHALLENGE_ROOM)))
                {
                    StateManager.setState(StateType.ROOM_LIST);
                }
                else
                {
                    if (RoomManager.Instance.current.type == RoomInfo.FRESHMAN_ROOM)
                    {
                        StateManager.setState(StateType.MAIN);
                    }
                    else
                    {
                        if (RoomManager.Instance.current.type == RoomInfo.WORLD_BOSS_FIGHT)
                        {
                            WorldBossManager.IsSuccessStartGame = false;
                            StateManager.setState(StateType.WORLDBOSS_ROOM);
                        }
                        else
                        {
                            if (RoomManager.Instance.current.type == RoomInfo.SINGLE_DUNGEON)
                            {
                                SingleDungeonManager.Instance.setBossPetNull();
                                StateManager.setState(StateType.SINGLEDUNGEON);
                            }
                            else
                            {
                                StateManager.setState(StateType.DUNGEON_LIST);
                            };
                        };
                    };
                };
                SocketManager.Instance.out.sendErrorMsg(this._unloadedmsg);
            };
            if ((((RoomManager.Instance.current) && (RoomManager.Instance.current.type == RoomInfo.WORLD_BOSS_FIGHT)) && (!(WorldBossManager.Instance.isOpen))))
            {
                StateManager.setState(StateType.MAIN);
            };
        }

        private function checkAnimationIsFinished():Boolean
        {
            var _local_1:RoomLoadingCharacterItem;
            for each (_local_1 in this._characterItems)
            {
                if ((!(_local_1.isAnimationFinished)))
                {
                    return (false);
                };
            };
            if (this._delayBeginTime <= 0)
            {
                this._delayBeginTime = new Date().time;
            };
            return (true);
        }

        private function checkProgress():Boolean
        {
            var _local_3:RoomPlayer;
            var _local_6:Player;
            var _local_7:PetInfo;
            var _local_8:int;
            var _local_9:PetSkillInfo;
            var _local_10:BallInfo;
            this._unloadedmsg = "";
            var _local_1:int;
            var _local_2:int;
            if ((!(this._gameInfo)))
            {
                return (false);
            };
            for each (_local_3 in this._gameInfo.roomPlayers)
            {
                if (!_local_3.isViewer)
                {
                    _local_6 = this._gameInfo.findLivingByPlayerID(_local_3.playerInfo.ID, _local_3.playerInfo.ZoneID);
                    if (LoadBombManager.Instance.getLoadBombAssetComplete(_local_3.currentWeapInfo))
                    {
                        _local_2++;
                    }
                    else
                    {
                        this._unloadedmsg = (this._unloadedmsg + ("LoadBombManager.Instance.getLoadBombAssetComplete(info.currentWeapInfo) false" + "\n"));
                    };
                    _local_1++;
                    _local_7 = _local_6.playerInfo.currentPet;
                    if (_local_7)
                    {
                        for each (_local_8 in _local_7.skills)
                        {
                            if (((_local_8 > 0) && (_local_8 < 1000)))
                            {
                                _local_9 = PetSkillManager.instance.getSkillByID(_local_8);
                                if (_local_9.NewBallID != -1)
                                {
                                    _local_10 = BallManager.findBall(_local_9.NewBallID);
                                    if (_local_10.bombAssetIsComplete())
                                    {
                                        _local_2++;
                                    }
                                    else
                                    {
                                        this._unloadedmsg = (this._unloadedmsg + (("BallManager.findBall(skill.NewBallID):" + _local_9.NewBallID) + "false\n"));
                                    };
                                    _local_1++;
                                };
                            };
                        };
                    };
                };
            };
            if (this._gameInfo.loaderMap.completed)
            {
                _local_2++;
            }
            else
            {
                this._unloadedmsg = (this._unloadedmsg + (((("_gameInfo.loaderMap.completed false,pic: " + this._gameInfo.loaderMap.info.Pic) + "id:") + this._gameInfo.loaderMap.info.ID) + "\n"));
            };
            _local_1++;
            if (this._trainerLoad)
            {
                if (this._trainerLoad.completed)
                {
                    _local_2++;
                }
                else
                {
                    this._unloadedmsg = (this._unloadedmsg + "_trainerLoad.completed false\n");
                };
                _local_1++;
            };
            var _local_4:Number = int(((_local_2 / _local_1) * 100));
            var _local_5:Boolean = (_local_1 == _local_2);
            GameInSocketOut.sendLoadingProgress(_local_4);
            RoomManager.Instance.current.selfRoomPlayer.progress = _local_4;
            return (_local_5);
        }

        private function checkIsEnoughDelayTime():Boolean
        {
            var _local_1:Number = new Date().time;
            return ((_local_1 - this._delayBeginTime) >= DELAY_TIME);
        }

        public function get index():int
        {
            return (this._index);
        }

        public function set index(_arg_1:int):void
        {
            this._index = _arg_1;
        }

        public function dispose():void
        {
            this._countDownTimer.removeEventListener(TimerEvent.TIMER, this.__countDownTick);
            this._countDownTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, this.__countDownComplete);
            this._countDownTimer.stop();
            this._countDownTimer = null;
            this._versus.removeEventListener(Event.CONNECT, this.__moveCountDownTxt);
            ObjectUtils.disposeObject(this._trainerLoad);
            ObjectUtils.disposeObject(this._bg);
            this._versus.dispose();
            this._countDownTxt.dispose();
            this._battleField.dispose();
            this._viewerItem.dispose();
            var _local_1:int;
            while (_local_1 < this._characterItems.length)
            {
                TweenMax.killTweensOf(this._characterItems[_local_1]);
                this._characterItems[_local_1].dispose();
                this._characterItems[_local_1] = null;
                _local_1++;
            };
            var _local_2:int;
            while (_local_2 < this._prgressItem.length)
            {
                this._prgressItem[_local_2].dispose();
                this._prgressItem[_local_2] = null;
                _local_2++;
            };
            if (this._dungeonMapItem)
            {
                ObjectUtils.disposeObject(this._dungeonMapItem);
                this._dungeonMapItem = null;
            };
            this._characterItems = null;
            this._prgressItem = null;
            this._trainerLoad = null;
            this._bg = null;
            this._gameInfo = null;
            this._versus = null;
            this._countDownTxt = null;
            this._battleField = null;
            this._countDownTimer = null;
            this._viewerItem = null;
            if (parent)
            {
                parent.removeChild(this);
            };
        }


    }
}//package roomLoading.view

