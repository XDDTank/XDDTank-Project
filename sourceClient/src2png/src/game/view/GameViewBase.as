// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//game.view.GameViewBase

package game.view
{
    import ddt.states.BaseStateView;
    import game.view.propContainer.PlayerStateContainer;
    import game.view.control.FightControlBar;
    import game.view.playerThumbnail.PlayerThumbnailController;
    import game.view.map.MapView;
    import flash.utils.Dictionary;
    import game.model.GameInfo;
    import game.objects.GameLocalPlayer;
    import game.objects.GameTurnedLiving;
    import game.view.buff.SelfBuffBar;
    import game.view.control.MouseStateAccieve;
    import ddt.manager.BitmapManager;
    import game.view.control.MouseStateView;
    import game.model.LocalPlayer;
    import game.objects.GameLiving;
    import game.objects.GamePlayer;
    import road7th.data.DictionaryData;
    import flash.geom.Point;
    import flash.geom.Rectangle;
    import flash.display.Sprite;
    import room.RoomManager;
    import game.model.GameNeedPetSkillInfo;
    import game.model.Living;
    import room.model.RoomPlayer;
    import game.model.Player;
    import pet.date.PetInfo;
    import pet.date.PetSkillInfo;
    import ddt.data.BallInfo;
    import game.GameManager;
    import ddt.manager.LoadBombManager;
    import com.pickgliss.loader.LoadResourceManager;
    import ddt.manager.PathManager;
    import com.pickgliss.loader.BaseLoader;
    import ddt.manager.PetSkillManager;
    import ddt.manager.BuffManager;
    import ddt.manager.BallManager;
    import ddt.manager.SharedManager;
    import ddt.view.MainToolBar;
    import com.pickgliss.ui.LayerManager;
    import ddt.view.chat.ChatBugleView;
    import ddt.manager.PlayerManager;
    import com.pickgliss.toplevel.StageReferance;
    import ddt.events.LivingEvent;
    import ddt.manager.SoundManager;
    import com.pickgliss.ui.ComponentFactory;
    import flash.events.Event;
    import ddt.manager.ChatManager;
    import ddt.utils.PositionUtils;
    import com.greensock.TweenLite;
    import room.model.RoomInfo;
    import ddt.events.DungeonInfoEvent;
    import ddt.events.GameEvent;
    import ddt.data.map.MissionInfo;
    import flash.events.MouseEvent;
    import ddt.manager.SavePointManager;
    import flash.utils.setTimeout;
    import road7th.utils.MovieClipWrapper;
    import com.pickgliss.utils.ClassUtils;
    import ddt.manager.LanguageMgr;
    import flash.media.SoundTransform;
    import com.pickgliss.utils.ObjectUtils;
    import bagAndInfo.info.PlayerInfoViewControl;
    import ddt.manager.IMEManager;
    import ddt.utils.MenoryUtil;
    import game.objects.BossLocalPlayer;
    import game.objects.BossPlayer;
    import game.actions.ViewEachPlayerAction;
    import game.model.TurnedLiving;
    import ddt.manager.MessageTipManager;
    import ddt.events.CrazyTankSocketEvent;
    import game.view.control.LiveState;
    import game.view.control.ControlState;
    import ddt.manager.SocketManager;
    import phy.math.EulerVector;
    import __AS3__.vec.Vector;
    import flash.display.Graphics;
    import game.model.SmallEnemy;
    import __AS3__.vec.*;

    public class GameViewBase extends BaseStateView 
    {

        private const GUIDEID:int = 10029;

        protected var _selfUsedProp:PlayerStateContainer;
        protected var _leftPlayerView:LeftPlayerCartoonView;
        protected var _missionHelp:DungeonHelpView;
        protected var _fightControlBar:FightControlBar;
        protected var _vane:VaneView;
        protected var _playerThumbnailLController:PlayerThumbnailController;
        protected var _map:MapView;
        protected var _players:Dictionary;
        protected var _gameInfo:GameInfo;
        protected var _selfGamePlayer:GameLocalPlayer;
        protected var _selfTurnedLiving:GameTurnedLiving;
        protected var _selfBuffBar:SelfBuffBar;
        protected var _selfMarkBar:SelfMarkBar;
        protected var _achievBar:FightAchievBar;
        protected var _mouseState:MouseStateAccieve;
        protected var _bitmapMgr:BitmapManager;
        private var _mouseStateView:MouseStateView;
        private var _hasShowMouseGuilde:Boolean;
        protected var _useFightModel:Boolean = false;
        protected var _barrier:DungeonInfoView;
        protected var _barrierVisible:Boolean = true;
        protected var _self:LocalPlayer;
        private var _level:int;
        private var _gameLiving:GameLiving;
        private var _selfGameLiving:GamePlayer;
        private var _allLivings:DictionaryData;
        private var _mass:Number = 10;
        private var _gravityFactor:Number = 70;
        protected var _windFactor:Number = 240;
        private var _powerRef:Number = 1;
        private var _reangle:Number = 0;
        private var _dt:Number = 0.04;
        private var _arf:Number;
        private var _gf:Number;
        private var _ga:Number;
        private var _mapWind:Number = 0;
        private var _wa:Number;
        private var _ef:Point = new Point(0, 0);
        private var _shootAngle:Number;
        private var _state:Boolean = false;
        private var _useAble:Boolean = false;
        private var _stateFlag:int;
        private var _currentLivID:int;
        private var _collideRect:Rectangle = new Rectangle(-45, -30, 100, 80);
        private var _drawRoute:Sprite;


        protected function needLeftPlayerView():Boolean
        {
            return (true);
        }

        override public function prepare():void
        {
            super.prepare();
        }

        override public function fadingComplete():void
        {
            super.fadingComplete();
            if (this._barrierVisible)
            {
                this.drawMissionInfo();
            };
            if ((!(RoomManager.Instance.current.selfRoomPlayer.isViewer)))
            {
                this._fightControlBar.setState(FightControlBar.LIVE);
            };
        }

        override public function enter(_arg_1:BaseStateView, _arg_2:Object=null):void
        {
            var _local_4:GameNeedPetSkillInfo;
            var _local_5:Array;
            var _local_6:int;
            var _local_7:int;
            var _local_8:Living;
            var _local_10:RoomPlayer;
            var _local_11:Player;
            var _local_12:PetInfo;
            var _local_13:int;
            var _local_14:PetSkillInfo;
            var _local_15:BallInfo;
            super.enter(_arg_1, _arg_2);
            this._gameInfo = GameManager.Instance.Current;
            var _local_3:int;
            while (_local_3 < this._gameInfo.neededMovies.length)
            {
                this._gameInfo.neededMovies[_local_3].startLoad();
                _local_3++;
            };
            for each (_local_4 in this._gameInfo.neededPetSkillResource)
            {
                _local_4.startLoad();
            };
            _local_5 = this._gameInfo.roomPlayers;
            LoadBombManager.Instance.loadFullWeaponBombMovie(_local_5);
            _local_6 = this._gameInfo.roomPlayers.length;
            _local_7 = 0;
            while (_local_7 < _local_6)
            {
                _local_10 = this._gameInfo.roomPlayers[_local_7];
                if (!_local_10.isViewer)
                {
                    _local_11 = this._gameInfo.findLivingByPlayerID(_local_10.playerInfo.ID, _local_10.playerInfo.ZoneID);
                    _local_11.movie.show(true, -1);
                    _local_12 = _local_11.playerInfo.currentPet;
                    if (_local_12)
                    {
                        LoadResourceManager.instance.creatAndStartLoad(PathManager.solvePetGameAssetUrl(_local_12.GameAssetUrl), BaseLoader.MODULE_LOADER);
                        for each (_local_13 in _local_12.skills)
                        {
                            if (((_local_13 > 0) && (_local_13 < 1000)))
                            {
                                _local_14 = PetSkillManager.instance.getSkillByID(_local_13);
                                BuffManager.getResource(_local_14.ElementIDs);
                                if (_local_14.NewBallID != -1)
                                {
                                    _local_15 = BallManager.findBall(_local_14.NewBallID);
                                    _local_15.loadBombAsset();
                                };
                            };
                        };
                    };
                };
                _local_7++;
            };
            GameManager.Instance.isLeaving = false;
            this._bitmapMgr = BitmapManager.getBitmapMgr("GameView");
            SharedManager.Instance.propTransparent = false;
            MainToolBar.Instance.hide();
            LayerManager.Instance.clearnStageDynamic();
            ChatBugleView.instance.hide();
            PlayerManager.Instance.Self.TempBag.clearnAll();
            GameManager.Instance.Current.selfGamePlayer.petSkillEnabled = true;
            for each (_local_8 in this._gameInfo.livings)
            {
                if ((_local_8 is Player))
                {
                    Player(_local_8).isUpGrade = false;
                    Player(_local_8).LockState = false;
                };
            };
            this._map = this.newMap();
            this._map.gameView = this;
            this._map.x = (this._map.y = 0);
            addChild(this._map);
            this._map.smallMap.x = ((StageReferance.stageWidth - this._map.smallMap.realWidth) - 1);
            this._map.smallMap.enableExit = ((!(this._gameInfo.roomType == 10)) && (!(this._gameInfo.roomType == 14)));
            addChild(this._map.smallMap);
            this._map.smallMap.hideSpliter();
            this._mouseState = new MouseStateAccieve(this._gameInfo.selfGamePlayer);
            this._mouseState.enter(LayerManager.Instance.getLayerByType(LayerManager.GAME_TOP_LAYER));
            this._selfMarkBar = new SelfMarkBar(this._gameInfo.selfGamePlayer, this);
            this._selfMarkBar.x = 500;
            this._selfMarkBar.y = 79;
            this._fightControlBar = new FightControlBar(this._gameInfo.selfGamePlayer, this);
            GameManager.Instance.Current.selfGamePlayer.addEventListener(LivingEvent.DIE, this.__selfDie);
            if (this.needLeftPlayerView())
            {
                this._leftPlayerView = new LeftPlayerCartoonView();
            };
            this._vane = new VaneView();
            this._vane.setUpCenter(446, 0);
            addChild(this._vane);
            SoundManager.instance.playGameBackMusic(this._map.info.BackMusic);
            this._selfBuffBar = ComponentFactory.Instance.creatCustomObject("SelfBuffBar", [this]);
            addChildAt(this._selfBuffBar, (this.numChildren - 1));
            this.setSlefBuffBarPos();
            this._players = new Dictionary();
            this._playerThumbnailLController = new PlayerThumbnailController(this._gameInfo);
            var _local_9:Point = ComponentFactory.Instance.creatCustomObject("asset.game.ThumbnailLPos");
            this._playerThumbnailLController.x = _local_9.x;
            this._playerThumbnailLController.y = _local_9.y;
            addChildAt(this._playerThumbnailLController, getChildIndex(this._map.smallMap));
            SharedManager.Instance.addEventListener(Event.CHANGE, this.__soundChange);
            this.__soundChange(null);
            this.setupGameData();
            this.addChatView();
            if (this.switchUserGuide)
            {
                this.loadWeakGuild();
            };
            this.defaultForbidDragFocus();
            this.initEvent();
            this.resetPlayerCharacters();
        }

        protected function addChatView():void
        {
            ChatManager.Instance.state = ChatManager.CHAT_GAME_STATE;
            addChild(ChatManager.Instance.view);
        }

        public function get switchUserGuide():Boolean
        {
            return (((PlayerManager.Instance.Self.Grade <= 15) ? true : false) && (PathManager.solveUserGuildEnable()));
        }

        protected function setSlefBuffBarPos():void
        {
            if (GameManager.Instance.Current.selfGamePlayer.mouseState)
            {
                PositionUtils.setPos(this._selfBuffBar, "SelfBuffBar.pos2");
            }
            else
            {
                PositionUtils.setPos(this._selfBuffBar, "SelfBuffBar.pos1");
            };
            if (this._useFightModel)
            {
                this._selfBuffBar.x = (this._selfBuffBar.x - 60);
            };
        }

        private function resetPlayerCharacters():void
        {
            var _local_1:GameLiving;
            for each (_local_1 in this._players)
            {
                _local_1.info.character.resetShowBitmapBig();
                _local_1.info.character.showWing = true;
                _local_1.info.character.show();
            };
        }

        protected function __mouseModelStateChange(_arg_1:Event):void
        {
            this.setSlefBuffBarPos();
            if (((this._gameInfo.selfGamePlayer.isLiving) && (this._gameInfo.selfGamePlayer.isAttacking)))
            {
                if (this._selfGamePlayer)
                {
                    this._selfGamePlayer.aim.visible = (!(this._gameInfo.selfGamePlayer.mouseState));
                };
                if (((this._gameInfo.selfGamePlayer.mouseState) && ((!(this._selfTurnedLiving)) || ((this._selfTurnedLiving) && (this._gameInfo.selfGamePlayer.canNormalShoot)))))
                {
                    this._mouseStateView.show();
                    this._mouseStateView.setPos();
                    if ((!(this._hasShowMouseGuilde)))
                    {
                        this._hasShowMouseGuilde = true;
                        this._mouseStateView.showLead();
                    };
                }
                else
                {
                    this._mouseStateView.removeLastPowerLead();
                    this._mouseStateView.hide();
                };
            };
        }

        protected function __moveProp(_arg_1:Event):void
        {
            this._useFightModel = true;
            if (this._selfBuffBar)
            {
                TweenLite.to(this._selfBuffBar, 0.5, {"x":(this._selfBuffBar.x - 60)});
            };
        }

        protected function __wishClick(_arg_1:Event):void
        {
            this._selfUsedProp.info.addState(0);
        }

        protected function __selfDie(_arg_1:LivingEvent):void
        {
            var _local_4:Living;
            var _local_2:Living = (_arg_1.currentTarget as Living);
            var _local_3:DictionaryData = this._gameInfo.findTeam(_local_2.team);
            for each (_local_4 in _local_3)
            {
                if (_local_4.isLiving)
                {
                    this._fightControlBar.setState(FightControlBar.SOUL);
                    return;
                };
            };
            if (this._selfBuffBar)
            {
                this._selfBuffBar.dispose();
            };
            this._selfBuffBar = null;
        }

        protected function drawMissionInfo():void
        {
            if ((((((this._gameInfo.roomType == RoomInfo.DUNGEON_ROOM) || (this._gameInfo.roomType == RoomInfo.MULTI_DUNGEON)) || (this._gameInfo.roomType == RoomInfo.SINGLE_DUNGEON)) || (this._gameInfo.roomType == RoomInfo.CONSORTION_MONSTER)) || (this._gameInfo.roomType == RoomInfo.CHANGE_DUNGEON)))
            {
                this._map.smallMap.titleBar.addEventListener(DungeonInfoEvent.DungeonHelpChanged, this.__dungeonVisibleChanged);
                this._barrier = new DungeonInfoView(this._map.smallMap.titleBar.turnButton, this);
                this._barrier.addEventListener(GameEvent.DungeonHelpVisibleChanged, this.__dungeonHelpChanged);
                this._barrier.addEventListener(GameEvent.UPDATE_SMALLMAPVIEW, this.__updateSmallMapView);
                this._missionHelp = new DungeonHelpView(this._map.smallMap.titleBar.turnButton, this._barrier, this);
                addChild(this._missionHelp);
                this._barrier.open();
            };
        }

        protected function __updateSmallMapView(_arg_1:GameEvent):void
        {
            var _local_2:MissionInfo = GameManager.Instance.Current.missionInfo;
            if (((!(_local_2.currentValue1 == -1)) && (_local_2.totalValue1 > 0)))
            {
                this._map.smallMap.setBarrier(_local_2.currentValue1, _local_2.totalValue1);
            };
        }

        protected function __dungeonHelpChanged(_arg_1:GameEvent):void
        {
            var _local_2:Rectangle;
            if (this._missionHelp)
            {
                if (_arg_1.data)
                {
                    if (this._missionHelp.opened)
                    {
                        _local_2 = this._barrier.getBounds(this);
                        _local_2.width = (_local_2.height = 1);
                        this._missionHelp.close(_local_2);
                    }
                    else
                    {
                        this._missionHelp.open();
                    };
                }
                else
                {
                    if (this._missionHelp.opened)
                    {
                        _local_2 = this._map.smallMap.titleBar.turnButton.getBounds(this);
                        this._missionHelp.close(_local_2);
                    };
                };
            };
        }

        protected function __dungeonVisibleChanged(_arg_1:DungeonInfoEvent):void
        {
            if (((this._barrier) && (this._barrierVisible)))
            {
                if (this._barrier.parent)
                {
                    this._barrier.close();
                }
                else
                {
                    this._barrier.open();
                };
            };
        }

        private function __onMissonHelpClick(_arg_1:MouseEvent):void
        {
            StageReferance.stage.focus = this._map;
        }

        protected function initEvent():void
        {
            this._playerThumbnailLController.addEventListener(GameEvent.WISH_SELECT, this.__thumbnailControlHandle);
            GameManager.Instance.Current.selfGamePlayer.addEventListener(GameEvent.MOUSE_MODEL_STATE, this.__mouseModelStateChange);
            GameManager.Instance.Current.selfGamePlayer.addEventListener(LivingEvent.GUNANGLE_CHANGED, this.__changeGunAngle);
            GameManager.Instance.Current.selfGamePlayer.addEventListener(LivingEvent.ANGLE_CHANGED, this.__changePlayerAngle);
            GameManager.Instance.Current.selfGamePlayer.addEventListener(GameEvent.MOUSE_MODEL_DOWN, this.__mouseModelDown);
            GameManager.Instance.addEventListener(GameManager.MOVE_PROPBAR, this.__moveProp);
            this._gameInfo.selfGamePlayer.addEventListener(GameEvent.MOUSE_MODEL_CHANGE_ANGLE, this.__changeMouseStateAngle);
            this._gameInfo.selfGamePlayer.addEventListener(LivingEvent.FORCE_CHANGED, this.__changeForce);
            this._gameInfo.selfGamePlayer.addEventListener(LivingEvent.POS_CHANGED, this.__moveMouseState);
        }

        protected function loadWeakGuild():void
        {
            this._vane.visible = ((SavePointManager.Instance.savePoints[59]) ? true : false);
            if (SavePointManager.Instance.isInSavePoint(59))
            {
                setTimeout(this.propOpenShow, 2000, "asset.trainer.openVane");
            };
        }

        private function isWishGuideLoad():Boolean
        {
            return (true);
        }

        private function propOpenShow(_arg_1:String):void
        {
            var _local_2:MovieClipWrapper = new MovieClipWrapper(ClassUtils.CreatInstance(_arg_1), true, true);
            LayerManager.Instance.addToLayer(_local_2.movie, LayerManager.GAME_UI_LAYER, false);
            if (SavePointManager.Instance.isInSavePoint(59))
            {
                SavePointManager.Instance.setSavePoint(59);
                this._vane.visible = true;
            };
        }

        protected function newMap():MapView
        {
            if (this._map)
            {
                throw (new Error(LanguageMgr.GetTranslation("tank.game.mapGenerated")));
            };
            return (new MapView(this._gameInfo, this._gameInfo.loaderMap));
        }

        private function __soundChange(_arg_1:Event):void
        {
            var _local_2:SoundTransform = new SoundTransform();
            if (SharedManager.Instance.allowSound)
            {
                _local_2.volume = (SharedManager.Instance.soundVolumn / 100);
                this.soundTransform = _local_2;
            }
            else
            {
                _local_2.volume = 0;
                this.soundTransform = _local_2;
            };
        }

        public function restoreSmallMap():void
        {
            this._map.smallMap.restore();
        }

        protected function disposeUI():void
        {
            ObjectUtils.disposeObject(this._achievBar);
            this._achievBar = null;
            if (this._playerThumbnailLController)
            {
                this._playerThumbnailLController.dispose();
            };
            this._playerThumbnailLController = null;
            ObjectUtils.disposeObject(this._selfUsedProp);
            this._selfUsedProp = null;
            if (this._leftPlayerView)
            {
                this._leftPlayerView.dispose();
            };
            this._leftPlayerView = null;
            ObjectUtils.disposeObject(this._fightControlBar);
            this._fightControlBar = null;
            ObjectUtils.disposeObject(this._selfMarkBar);
            this._selfMarkBar = null;
            if (this._selfBuffBar)
            {
                ObjectUtils.disposeObject(this._selfBuffBar);
            };
            this._selfBuffBar = null;
            if (this._vane)
            {
                this._vane.dispose();
                this._vane = null;
            };
            ObjectUtils.disposeObject(this._mouseState);
            this._mouseState = null;
        }

        override public function leaving(_arg_1:BaseStateView):void
        {
            super.leaving(_arg_1);
            ObjectUtils.disposeObject(this._mouseStateView);
            this._mouseStateView = null;
            this._useFightModel = false;
            this._playerThumbnailLController.removeEventListener(GameEvent.WISH_SELECT, this.__thumbnailControlHandle);
            this._gameInfo.selfGamePlayer.removeEventListener(LivingEvent.POS_CHANGED, this.__moveMouseState);
            this._gameInfo.selfGamePlayer.removeEventListener(LivingEvent.FORCE_CHANGED, this.__changeForce);
            this._gameInfo.selfGamePlayer.removeEventListener(GameEvent.MOUSE_MODEL_CHANGE_ANGLE, this.__changeMouseStateAngle);
            GameManager.Instance.isLeaving = true;
            this.disposeUI();
            this.removeGameData();
            ObjectUtils.disposeObject(this._bitmapMgr);
            this._bitmapMgr = null;
            this._map.smallMap.titleBar.removeEventListener(DungeonInfoEvent.DungeonHelpChanged, this.__dungeonVisibleChanged);
            GameManager.Instance.Current.selfGamePlayer.removeEventListener(GameEvent.MOUSE_MODEL_STATE, this.__mouseModelStateChange);
            GameManager.Instance.Current.selfGamePlayer.removeEventListener(LivingEvent.GUNANGLE_CHANGED, this.__changeGunAngle);
            GameManager.Instance.Current.selfGamePlayer.removeEventListener(LivingEvent.ANGLE_CHANGED, this.__changePlayerAngle);
            GameManager.Instance.Current.selfGamePlayer.removeEventListener(GameEvent.MOUSE_MODEL_DOWN, this.__mouseModelDown);
            GameManager.Instance.removeEventListener(GameManager.MOVE_PROPBAR, this.__moveProp);
            PlayerInfoViewControl.clearView();
            LayerManager.Instance.clearnGameDynamic();
            removeChild(this._map);
            this._map.dispose();
            this._map = null;
            SharedManager.Instance.removeEventListener(Event.CHANGE, this.__soundChange);
            GameManager.Instance.Current.selfGamePlayer.removeEventListener(LivingEvent.DIE, this.__selfDie);
            IMEManager.enable();
            while (numChildren > 0)
            {
                removeChildAt(0);
            };
            MenoryUtil.clearMenory();
            if (this._barrier)
            {
                this._barrier.removeEventListener(GameEvent.DungeonHelpVisibleChanged, this.__dungeonHelpChanged);
                this._barrier.removeEventListener(GameEvent.UPDATE_SMALLMAPVIEW, this.__updateSmallMapView);
                ObjectUtils.disposeObject(this._barrier);
                this._barrier = null;
            };
            ObjectUtils.disposeObject(this._drawRoute);
            this._drawRoute = null;
        }

        protected function setupGameData():void
        {
            var _local_2:Living;
            var _local_3:GameLiving;
            var _local_4:Player;
            var _local_5:RoomPlayer;
            var _local_1:Array = new Array();
            for each (_local_2 in this._gameInfo.livings)
            {
                if ((_local_2 is Player))
                {
                    _local_4 = (_local_2 as Player);
                    _local_5 = RoomManager.Instance.current.findPlayerByID(_local_4.playerInfo.ID);
                    if (_local_4.isSelf)
                    {
                        this._self = (_local_4 as LocalPlayer);
                        if ((!(_local_4.isBoss)))
                        {
                            _local_3 = new GameLocalPlayer(this._gameInfo.selfGamePlayer, _local_4.character, _local_4.movie);
                        }
                        else
                        {
                            _local_3 = new BossLocalPlayer(this._gameInfo.selfGamePlayer, _local_4.character, _local_4.movie);
                        };
                        this._selfGamePlayer = (_local_3 as GameLocalPlayer);
                        this._selfTurnedLiving = (_local_3 as GameTurnedLiving);
                        if (this._selfGamePlayer)
                        {
                            this._selfGamePlayer.turnedLiving.addEventListener(LivingEvent.ATTACKING_CHANGED, this.__attackingChanged);
                            this._selfGamePlayer.addEventListener(GameEvent.TURN_LEFT, this.__playerTurnLeft);
                            this._selfGamePlayer.addEventListener(GameEvent.TURN_RIGHT, this.__playerTurnRight);
                        };
                        if (this._selfTurnedLiving)
                        {
                            this._selfTurnedLiving.turnedLiving.addEventListener(LivingEvent.ATTACKING_CHANGED, this.__attackingChanged);
                            this._selfTurnedLiving.addEventListener(GameEvent.TURN_LEFT, this.__playerTurnLeft);
                            this._selfTurnedLiving.addEventListener(GameEvent.TURN_RIGHT, this.__playerTurnRight);
                            this._selfTurnedLiving.addEventListener(GameEvent.BOSS_USE_SKILL, this.__bossUseSkill);
                        };
                        this._mouseStateView = new MouseStateView(GameTurnedLiving(_local_3), this._map);
                        this._map.addToControlLayer(this._mouseStateView);
                    }
                    else
                    {
                        if ((!(_local_4.isBoss)))
                        {
                            _local_3 = new GamePlayer(_local_4, _local_4.character, _local_4.movie);
                        }
                        else
                        {
                            _local_3 = new BossPlayer(_local_4, _local_4.character, _local_4.movie);
                        };
                    };
                    if (((_local_4.movie) && (!(_local_4.isBoss))))
                    {
                        _local_4.movie.setDefaultAction(_local_4.movie.standAction);
                        _local_4.movie.doAction(_local_4.movie.standAction);
                    };
                    _local_1.push(_local_3);
                    this._map.addPhysical(_local_3);
                    if (((_local_3 is GamePlayer) && (GamePlayer(_local_3).gamePet)))
                    {
                        this._map.addPhysical(GamePlayer(_local_3).gamePet);
                    };
                    this._players[_local_2] = _local_3;
                };
            };
            this._map.wind = GameManager.Instance.Current.wind;
            this._gameInfo.currentTurn = 1;
            this._vane.initialize();
            this._vane.update(this._map.wind);
            this._map.act(new ViewEachPlayerAction(this._map, _local_1));
        }

        private function removeGameData():void
        {
            var _local_1:GameLiving;
            if (this._selfGamePlayer)
            {
                this._selfGamePlayer.turnedLiving.removeEventListener(LivingEvent.ATTACKING_CHANGED, this.__attackingChanged);
                this._selfGamePlayer.removeEventListener(GameEvent.TURN_LEFT, this.__playerTurnLeft);
                this._selfGamePlayer.removeEventListener(GameEvent.TURN_RIGHT, this.__playerTurnRight);
            };
            if (this._selfTurnedLiving)
            {
                this._selfTurnedLiving.turnedLiving.removeEventListener(LivingEvent.ATTACKING_CHANGED, this.__attackingChanged);
                this._selfTurnedLiving.removeEventListener(GameEvent.TURN_LEFT, this.__playerTurnLeft);
                this._selfTurnedLiving.removeEventListener(GameEvent.TURN_RIGHT, this.__playerTurnRight);
                this._selfTurnedLiving.addEventListener(GameEvent.BOSS_USE_SKILL, this.__bossUseSkill);
            };
            for each (_local_1 in this._players)
            {
                _local_1.dispose();
                delete this._players[_local_1.info];
            };
            this._players = null;
            this._selfGamePlayer = null;
            this._selfTurnedLiving = null;
            this._gameInfo = null;
            this._barrierVisible = true;
        }

        public function addLiving(_arg_1:Living):void
        {
        }

        protected function updatePlayerState(_arg_1:Living):void
        {
            if (this._selfUsedProp == null)
            {
                this._selfUsedProp = new PlayerStateContainer(12);
                PositionUtils.setPos(this._selfUsedProp, "asset.game.selfUsedProp");
                addChild(this._selfUsedProp);
            };
            if (this._selfUsedProp)
            {
                this._selfUsedProp.disposeAllChildren();
            };
            if (((this._selfUsedProp) && (this._selfBuffBar)))
            {
                this._selfUsedProp.x = this._selfBuffBar.right;
            };
            if ((_arg_1 is TurnedLiving))
            {
                this._selfUsedProp.info = TurnedLiving(_arg_1);
            };
            if (((GameManager.Instance.Current.selfGamePlayer.isAutoGuide) && (GameManager.Instance.Current.currentLiving.LivingID == GameManager.Instance.Current.selfGamePlayer.LivingID)))
            {
                MessageTipManager.getInstance().show(String(GameManager.Instance.Current.selfGamePlayer.LivingID), 3);
            };
        }

        public function setCurrentPlayer(_arg_1:Living):void
        {
            if (((!(GameManager.Instance.Current.selfGamePlayer.isLiving)) && (this._selfBuffBar)))
            {
                this._selfBuffBar.visible = false;
            }
            else
            {
                if (this._selfBuffBar)
                {
                    this._selfBuffBar.visible = true;
                };
            };
            if ((((!(RoomManager.Instance.current.selfRoomPlayer.isViewer)) && (_arg_1)) && (this._selfBuffBar)))
            {
                this._selfBuffBar.drawBuff(_arg_1);
            };
            if (this._leftPlayerView)
            {
                this._leftPlayerView.info = _arg_1;
            };
            this._map.bringToFront(_arg_1);
            if (((this._map.currentPlayer) && (!(_arg_1 is TurnedLiving))))
            {
                this._map.currentPlayer.isAttacking = false;
                this._map.currentPlayer = null;
            }
            else
            {
                this._map.currentPlayer = (_arg_1 as TurnedLiving);
            };
            this.updatePlayerState(_arg_1);
            if (this._leftPlayerView)
            {
                addChildAt(this._leftPlayerView, (this.numChildren - 3));
            };
            var _local_2:LocalPlayer = GameManager.Instance.Current.selfGamePlayer;
            if (this._map.currentPlayer)
            {
                if (_local_2)
                {
                    _local_2.soulPropEnabled = ((!(_local_2.isLiving)) && (this._map.currentPlayer.team == _local_2.team));
                };
            }
            else
            {
                if (_local_2)
                {
                    _local_2.soulPropEnabled = false;
                };
            };
        }

        public function updateControlBarState(_arg_1:Living):void
        {
            if (GameManager.Instance.Current == null)
            {
                return;
            };
            if (GameManager.Instance.Current.selfGamePlayer.LockState)
            {
                this.setPropBarClickEnable(false, true);
                return;
            };
            if ((((_arg_1 is TurnedLiving) && (_arg_1.isLiving)) && (GameManager.Instance.Current.selfGamePlayer.canUseProp((_arg_1 as TurnedLiving)))))
            {
                this.setPropBarClickEnable(true, false);
            }
            else
            {
                if (_arg_1)
                {
                    if (((!(GameManager.Instance.Current.selfGamePlayer.isLiving)) && (_arg_1.isSelf)))
                    {
                        this.setPropBarClickEnable(true, false);
                    }
                    else
                    {
                        if (((!(GameManager.Instance.Current.selfGamePlayer.isLiving)) && (!(GameManager.Instance.Current.selfGamePlayer.team == _arg_1.team))))
                        {
                            this.setPropBarClickEnable(false, true);
                        }
                        else
                        {
                            this.setPropBarClickEnable(true, false);
                        };
                    };
                }
                else
                {
                    this.setPropBarClickEnable(true, false);
                };
            };
        }

        protected function setPropBarClickEnable(_arg_1:Boolean, _arg_2:Boolean):void
        {
            GameManager.Instance.Current.selfGamePlayer.rightPropEnabled = _arg_1;
            GameManager.Instance.Current.selfGamePlayer.weaponPropEnbled = _arg_1;
            GameManager.Instance.Current.selfGamePlayer.customPropEnabled = _arg_1;
        }

        protected function gameOver():void
        {
            this._map.smallMap.enableExit = false;
            SoundManager.instance.stopMusic();
            this.setPropBarClickEnable(false, false);
            if (this._leftPlayerView)
            {
                this._leftPlayerView.gameOver();
                this._leftPlayerView.visible = false;
            };
            this._selfMarkBar.shutdown();
            this._selfMarkBar.shutdownInSingle();
        }

        protected function set barrierInfo(_arg_1:CrazyTankSocketEvent):void
        {
            if (this._barrier)
            {
                this._barrier.barrierInfoHandler(_arg_1);
            };
        }

        protected function set arrowHammerEnable(_arg_1:Boolean):void
        {
        }

        public function blockHammer():void
        {
        }

        public function allowHammer():void
        {
        }

        protected function defaultForbidDragFocus():void
        {
        }

        protected function setBarrierVisible(_arg_1:Boolean):void
        {
            this._barrierVisible = _arg_1;
        }

        protected function setVaneVisible(_arg_1:Boolean):void
        {
            this._vane.visible = _arg_1;
        }

        protected function setPlayerThumbVisible(_arg_1:Boolean):void
        {
            this._playerThumbnailLController.visible = _arg_1;
        }

        protected function setEnergyVisible(_arg_1:Boolean):void
        {
            var _local_2:LiveState = (this.currentControllState as LiveState);
            if (_local_2)
            {
                _local_2.setEnergyVisible(_arg_1);
            };
        }

        protected function get currentControllState():ControlState
        {
            return (this._fightControlBar.current);
        }

        public function setRecordRotation():void
        {
        }

        public function get map():MapView
        {
            return (this._map);
        }

        protected function set mapWind(_arg_1:Number):void
        {
            this._mapWind = _arg_1;
            if (this._useAble)
            {
                this.showShoot();
            };
        }

        public function get currentLivID():int
        {
            return (this._currentLivID);
        }

        public function set currentLivID(_arg_1:int):void
        {
            this._currentLivID = _arg_1;
            this.drawRouteLine(this._currentLivID);
            if (this._map)
            {
                this._map.smallMap.drawRouteLine(this._currentLivID);
            };
        }

        private function wishInit():void
        {
            this._self = GameManager.Instance.Current.selfGamePlayer;
            this._selfGameLiving = (this._map.getPhysical(this._self.LivingID) as GamePlayer);
            this._allLivings = GameManager.Instance.Current.livings;
            this._drawRoute = new Sprite();
            this._map.addChild(this._drawRoute);
            this.currentLivID = -1;
            this._self.addEventListener(LivingEvent.GUNANGLE_CHANGED, this.__changeAngle);
            this._self.addEventListener(LivingEvent.POS_CHANGED, this.__changeAngle);
            this._self.addEventListener(LivingEvent.DIR_CHANGED, this.__changeAngle);
            SocketManager.Instance.addEventListener(CrazyTankSocketEvent.WISHOFDD, this.__wishofdd);
            SocketManager.Instance.addEventListener(CrazyTankSocketEvent.PLAYER_CHANGE, this.__playerChange);
            RoomManager.Instance.addEventListener(RoomManager.PLAYER_ROOM_EXIT, this.__playerExit);
        }

        private function wishRemoveEvent():void
        {
            this._self.removeEventListener(LivingEvent.GUNANGLE_CHANGED, this.__changeAngle);
            this._self.removeEventListener(LivingEvent.POS_CHANGED, this.__changeAngle);
            this._self.removeEventListener(LivingEvent.DIR_CHANGED, this.__changeAngle);
            SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.WISHOFDD, this.__wishofdd);
            SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.PLAYER_CHANGE, this.__playerChange);
            RoomManager.Instance.removeEventListener(RoomManager.PLAYER_ROOM_EXIT, this.__playerExit);
        }

        protected function showShoot():void
        {
            var _local_2:Point;
            var _local_3:Player;
            var _local_4:Living;
            var _local_5:Number;
            var _local_6:Boolean;
            var _local_7:Boolean;
            var _local_1:Point = this._selfGameLiving.body.localToGlobal(new Point(30, -20));
            _local_1 = this._map.globalToLocal(_local_1);
            this._shootAngle = this._self.calcBombAngle();
            this._arf = this._map.airResistance;
            this._gf = ((this._map.gravity * this._mass) * this._gravityFactor);
            this._ga = (this._gf / this._mass);
            this._wa = (this._mapWind / this._mass);
            for each (_local_4 in this._allLivings)
            {
                _local_4.route = null;
                if (!((((_local_4.isHidden) || (_local_4.team == GameManager.Instance.Current.selfGamePlayer.team)) || (!(_local_4.isLiving))) || (_local_4.LivingID == this._self.LivingID)))
                {
                    _local_2 = _local_4.pos;
                    if (((this._self.isLiving) && (this._self.isAttacking)))
                    {
                        _local_4.route = null;
                        _local_6 = true;
                        _local_7 = true;
                        if (_local_1.x > _local_2.x)
                        {
                            _local_6 = false;
                        };
                        if (_local_1.y > _local_2.y)
                        {
                            _local_7 = false;
                        };
                        if (this.judgeMaxPower(_local_1, _local_2, this._shootAngle, _local_6, _local_7))
                        {
                            _local_5 = this.getPower(0, 2000, _local_1, _local_2, this._shootAngle, _local_6, _local_7);
                        }
                        else
                        {
                            _local_5 = 2100;
                        };
                        this._stateFlag = 0;
                        if (_local_5 > 2000)
                        {
                            if (_local_4.state)
                            {
                                this._stateFlag = 1;
                            }
                            else
                            {
                                this._stateFlag = 2;
                            };
                            _local_4.state = false;
                        }
                        else
                        {
                            if (_local_4.state)
                            {
                                this._stateFlag = 3;
                            }
                            else
                            {
                                this._stateFlag = 4;
                            };
                            _local_4.state = true;
                        };
                        this._gameLiving = (this._map.getPhysical(_local_4.LivingID) as GameLiving);
                        if (((this._stateFlag == 1) || (this._stateFlag == 2)))
                        {
                            _local_4.route = null;
                        }
                        else
                        {
                            _local_4.route = this.getRouteData(_local_5, this._shootAngle, _local_1, _local_2);
                        };
                        _local_4.fightPower = Number(((_local_5 * 100) / 2000).toFixed(1));
                    };
                };
            };
            if (((this.currentLivID == -1) || (!(GameManager.Instance.Current.findPlayer(this.currentLivID).route))))
            {
                this.currentLivID = this.calculateRecent();
            }
            else
            {
                this.currentLivID = this.currentLivID;
            };
        }

        private function judgeMaxPower(_arg_1:Point, _arg_2:Point, _arg_3:Number, _arg_4:Boolean, _arg_5:Boolean):Boolean
        {
            var _local_6:EulerVector;
            var _local_7:EulerVector;
            var _local_8:int;
            var _local_9:int;
            _local_8 = (2000 * Math.cos(((_arg_3 / 180) * Math.PI)));
            _local_6 = new EulerVector(_arg_1.x, _local_8, this._wa);
            _local_9 = (2000 * Math.sin(((_arg_3 / 180) * Math.PI)));
            _local_7 = new EulerVector(_arg_1.y, _local_9, this._ga);
            var _local_10:Boolean;
            while (true)
            {
                if (_arg_4)
                {
                    if (_local_6.x0 > this._map.bound.width)
                    {
                        return (true);
                    };
                    if (((_local_6.x0 < this._map.bound.x) || (_local_7.x0 > this._map.bound.height)))
                    {
                        return (false);
                    };
                }
                else
                {
                    if (_local_6.x0 < this._map.bound.x)
                    {
                        return (true);
                    };
                    if (((_local_6.x0 > this._map.bound.width) || (_local_7.x0 > this._map.bound.height)))
                    {
                        return (false);
                    };
                };
                if (this.ifHit(_local_6.x0, _local_7.x0, _arg_2))
                {
                    return (true);
                };
                _local_6.ComputeOneEulerStep(this._mass, this._arf, this._mapWind, this._dt);
                _local_7.ComputeOneEulerStep(this._mass, this._arf, this._gf, this._dt);
                if (((_arg_4) && (_arg_5)))
                {
                    if (_local_7.x0 > _arg_2.y)
                    {
                        if (_local_6.x0 < _arg_2.x)
                        {
                            return (false);
                        };
                        return (true);
                    };
                }
                else
                {
                    if (((_arg_4) && (!(_arg_5))))
                    {
                        if ((!(_local_10)))
                        {
                            if (_local_6.x0 > _arg_2.x)
                            {
                                return (false);
                            };
                            if (_local_7.x0 < _arg_2.y)
                            {
                                _local_10 = true;
                            };
                        }
                        else
                        {
                            if (_local_10)
                            {
                                if (_local_7.x0 > _arg_2.y)
                                {
                                    if (_local_6.x0 < _arg_2.x)
                                    {
                                        return (false);
                                    };
                                    return (true);
                                };
                            };
                        };
                    }
                    else
                    {
                        if (((!(_arg_4)) && (!(_arg_5))))
                        {
                            if ((!(_local_10)))
                            {
                                if (_local_6.x0 < _arg_2.x)
                                {
                                    return (false);
                                };
                                if (_local_7.x0 < _arg_2.y)
                                {
                                    _local_10 = true;
                                };
                            }
                            else
                            {
                                if (_local_10)
                                {
                                    if (_local_7.x0 > _arg_2.y)
                                    {
                                        if (_local_6.x0 < _arg_2.x)
                                        {
                                            return (true);
                                        };
                                        return (false);
                                    };
                                };
                            };
                        }
                        else
                        {
                            if (((!(_arg_4)) && (_arg_5)))
                            {
                                if (_local_7.x0 > _arg_2.y)
                                {
                                    if (_local_6.x0 < _arg_2.x)
                                    {
                                        return (true);
                                    };
                                    return (false);
                                };
                            };
                        };
                    };
                };
            };
            return (false);
        }

        protected function getPower(_arg_1:Number, _arg_2:Number, _arg_3:Point, _arg_4:Point, _arg_5:Number, _arg_6:Boolean, _arg_7:Boolean):Number
        {
            var _local_8:EulerVector;
            var _local_9:EulerVector;
            var _local_10:int;
            var _local_11:int;
            var _local_12:int = int(((_arg_1 + _arg_2) / 2));
            if (((_local_12 <= _arg_1) || (_local_12 >= _arg_2)))
            {
                return (_local_12);
            };
            _local_10 = (_local_12 * Math.cos(((_arg_5 / 180) * Math.PI)));
            _local_8 = new EulerVector(_arg_3.x, _local_10, this._wa);
            _local_11 = (_local_12 * Math.sin(((_arg_5 / 180) * Math.PI)));
            _local_9 = new EulerVector(_arg_3.y, _local_11, this._ga);
            var _local_13:Boolean;
            while (true)
            {
                if (_arg_6)
                {
                    if (_local_8.x0 > this._map.bound.width)
                    {
                        _local_12 = this.getPower(_arg_1, _local_12, _arg_3, _arg_4, _arg_5, _arg_6, _arg_7);
                        break;
                    };
                    if (_local_9.x0 > this._map.bound.height)
                    {
                        _local_12 = this.getPower(_local_12, _arg_2, _arg_3, _arg_4, _arg_5, _arg_6, _arg_7);
                        break;
                    };
                    if (_local_8.x0 < this._map.bound.x)
                    {
                        return (_local_12 = 2100);
                    };
                }
                else
                {
                    if (_local_8.x0 < this._map.bound.x)
                    {
                        _local_12 = this.getPower(_arg_1, _local_12, _arg_3, _arg_4, _arg_5, _arg_6, _arg_7);
                        break;
                    };
                    if (_local_9.x0 > this._map.bound.height)
                    {
                        _local_12 = this.getPower(_local_12, _arg_2, _arg_3, _arg_4, _arg_5, _arg_6, _arg_7);
                        break;
                    };
                    if (_local_8.x0 > this._map.bound.width)
                    {
                        return (_local_12 = 2100);
                    };
                };
                if (this.ifHit(_local_8.x0, _local_9.x0, _arg_4))
                {
                    return (_local_12);
                };
                _local_8.ComputeOneEulerStep(this._mass, this._arf, this._mapWind, this._dt);
                _local_9.ComputeOneEulerStep(this._mass, this._arf, this._gf, this._dt);
                if (((_arg_6) && (_arg_7)))
                {
                    if (_local_9.x0 > _arg_4.y)
                    {
                        if (_local_8.x0 < _arg_4.x)
                        {
                            _local_12 = this.getPower(_local_12, _arg_2, _arg_3, _arg_4, _arg_5, _arg_6, _arg_7);
                        }
                        else
                        {
                            _local_12 = this.getPower(_arg_1, _local_12, _arg_3, _arg_4, _arg_5, _arg_6, _arg_7);
                        };
                        break;
                    };
                }
                else
                {
                    if (((_arg_6) && (!(_arg_7))))
                    {
                        if ((!(_local_13)))
                        {
                            if (_local_8.x0 > _arg_4.x)
                            {
                                _local_12 = this.getPower(_local_12, _arg_2, _arg_3, _arg_4, _arg_5, _arg_6, _arg_7);
                                break;
                            };
                            if (_local_9.x0 < _arg_4.y)
                            {
                                _local_13 = true;
                            };
                        }
                        else
                        {
                            if (_local_13)
                            {
                                if (_local_9.x0 > _arg_4.y)
                                {
                                    if (_local_8.x0 < _arg_4.x)
                                    {
                                        _local_12 = this.getPower(_local_12, _arg_2, _arg_3, _arg_4, _arg_5, _arg_6, _arg_7);
                                    }
                                    else
                                    {
                                        _local_12 = this.getPower(_arg_1, _local_12, _arg_3, _arg_4, _arg_5, _arg_6, _arg_7);
                                    };
                                    break;
                                };
                            };
                        };
                    }
                    else
                    {
                        if (((!(_arg_6)) && (!(_arg_7))))
                        {
                            if ((!(_local_13)))
                            {
                                if (_local_8.x0 < _arg_4.x)
                                {
                                    _local_12 = this.getPower(_local_12, _arg_2, _arg_3, _arg_4, _arg_5, _arg_6, _arg_7);
                                    break;
                                };
                                if (_local_9.x0 < _arg_4.y)
                                {
                                    _local_13 = true;
                                };
                            }
                            else
                            {
                                if (_local_13)
                                {
                                    if (_local_9.x0 > _arg_4.y)
                                    {
                                        if (_local_8.x0 > _arg_4.x)
                                        {
                                            _local_12 = this.getPower(_local_12, _arg_2, _arg_3, _arg_4, _arg_5, _arg_6, _arg_7);
                                        }
                                        else
                                        {
                                            _local_12 = this.getPower(_arg_1, _local_12, _arg_3, _arg_4, _arg_5, _arg_6, _arg_7);
                                        };
                                        break;
                                    };
                                };
                            };
                        }
                        else
                        {
                            if (((!(_arg_6)) && (_arg_7)))
                            {
                                if (_local_9.x0 > _arg_4.y)
                                {
                                    if (_local_8.x0 > _arg_4.x)
                                    {
                                        _local_12 = this.getPower(_local_12, _arg_2, _arg_3, _arg_4, _arg_5, _arg_6, _arg_7);
                                    }
                                    else
                                    {
                                        _local_12 = this.getPower(_arg_1, _local_12, _arg_3, _arg_4, _arg_5, _arg_6, _arg_7);
                                    };
                                    break;
                                };
                            };
                        };
                    };
                };
            };
            return (_local_12);
        }

        protected function ifHit(_arg_1:Number, _arg_2:Number, _arg_3:Point):Boolean
        {
            if (((((_arg_1 > (_arg_3.x - 15)) && (_arg_1 < (_arg_3.x + 20))) && (_arg_2 > (_arg_3.y - 20))) && (_arg_2 < (_arg_3.y + 30))))
            {
                return (true);
            };
            return (false);
        }

        private function isOutOfMap(_arg_1:EulerVector, _arg_2:EulerVector):Boolean
        {
            if ((((_arg_1.x0 < this._map.bound.x) || (_arg_1.x0 > this._map.bound.width)) || (_arg_2.x0 > this._map.bound.height)))
            {
                return (true);
            };
            return (false);
        }

        private function drawRouteLine(_arg_1:int):void
        {
            var _local_2:Living;
            this._drawRoute.graphics.clear();
            for each (_local_2 in this._allLivings)
            {
                _local_2.currentSelectId = _arg_1;
            };
            if (_arg_1 < 0)
            {
                return;
            };
            var _local_3:Player = GameManager.Instance.Current.findPlayer(_arg_1);
            if ((!(_local_3)))
            {
                return;
            };
            var _local_4:Vector.<Point> = _local_3.route;
            if (((!(_local_4)) || (_local_4.length == 0)))
            {
                return;
            };
            var _local_5:GamePlayer = (this._map.getPhysical(_arg_1) as GamePlayer);
            this._collideRect.x = (_local_5.pos.x - 50);
            this._collideRect.y = (_local_5.pos.y - 50);
            this._drawRoute.graphics.lineStyle(2, 0xFF0000, 0.5);
            var _local_6:int = _local_4.length;
            var _local_7:int;
            while (_local_7 < (_local_6 - 1))
            {
                this.drawDashed(this._drawRoute.graphics, _local_4[_local_7], _local_4[(_local_7 + 1)], 8, 5);
                _local_7++;
            };
        }

        private function getRouteData(_arg_1:Number, _arg_2:Number, _arg_3:Point, _arg_4:Point):Vector.<Point>
        {
            var _local_5:EulerVector;
            var _local_6:EulerVector;
            var _local_7:int;
            var _local_8:int;
            if (_arg_1 > 2000)
            {
                return (null);
            };
            _local_7 = (_arg_1 * Math.cos(((_arg_2 / 180) * Math.PI)));
            _local_5 = new EulerVector(_arg_3.x, _local_7, this._wa);
            _local_8 = (_arg_1 * Math.sin(((_arg_2 / 180) * Math.PI)));
            _local_6 = new EulerVector(_arg_3.y, _local_8, this._ga);
            var _local_9:Vector.<Point> = new Vector.<Point>();
            _local_9.push(new Point(_arg_3.x, _arg_3.y));
            while (true)
            {
                if (this.isOutOfMap(_local_5, _local_6))
                {
                    return (_local_9);
                };
                if (this.ifHit(_local_5.x0, _local_6.x0, _arg_4))
                {
                    return (_local_9);
                };
                _local_5.ComputeOneEulerStep(this._mass, this._arf, this._mapWind, this._dt);
                _local_6.ComputeOneEulerStep(this._mass, this._arf, this._gf, this._dt);
                _local_9.push(new Point(_local_5.x0, _local_6.x0));
            };
            return (_local_9);
        }

        public function drawDashed(_arg_1:Graphics, _arg_2:Point, _arg_3:Point, _arg_4:Number, _arg_5:Number):void
        {
            var _local_11:Number;
            var _local_12:Number;
            if ((((((!(_arg_1)) || (!(_arg_2))) || (!(_arg_3))) || (_arg_4 <= 0)) || (_arg_5 <= 0)))
            {
                return;
            };
            var _local_6:Number = _arg_2.x;
            var _local_7:Number = _arg_2.y;
            var _local_8:Number = Math.atan2((_arg_3.y - _local_7), (_arg_3.x - _local_6));
            var _local_9:Number = Point.distance(_arg_2, _arg_3);
            var _local_10:Number = 0;
            while (_local_10 <= _local_9)
            {
                if (this._collideRect.contains(_local_11, _local_12))
                {
                    return;
                };
                _local_11 = (_local_6 + (Math.cos(_local_8) * _local_10));
                _local_12 = (_local_7 + (Math.sin(_local_8) * _local_10));
                _arg_1.moveTo(_local_11, _local_12);
                _local_10 = (_local_10 + _arg_4);
                if (_local_10 > _local_9)
                {
                    _local_10 = _local_9;
                };
                _local_11 = (_local_6 + (Math.cos(_local_8) * _local_10));
                _local_12 = (_local_7 + (Math.sin(_local_8) * _local_10));
                _arg_1.lineTo(_local_11, _local_12);
                _local_10 = (_local_10 + _arg_5);
            };
        }

        private function drawArrow(_arg_1:Graphics, _arg_2:Point, _arg_3:Point, _arg_4:Number, _arg_5:int):void
        {
            var _local_7:Number;
            var _local_8:Number;
            if (((((!(_arg_2)) || (!(_arg_3))) || (!(_arg_4))) || (_arg_5 <= 0)))
            {
                return;
            };
            var _local_6:Number = Math.atan2((_arg_3.y - _arg_2.y), (_arg_3.x - _arg_2.x));
            _arg_4 = ((_arg_4 * Math.PI) / 180);
            _arg_1.moveTo(_arg_3.x, _arg_3.y);
            _local_7 = (_arg_3.x + (Math.cos((_local_6 + _arg_4)) * _arg_5));
            _local_8 = (_arg_3.y + (Math.sin((_local_6 + _arg_4)) * _arg_5));
            _arg_1.lineTo(_local_7, _local_8);
            _arg_1.moveTo(_arg_3.x, _arg_3.y);
            _local_7 = (_arg_3.x + (Math.cos((_local_6 - _arg_4)) * _arg_5));
            _local_8 = (_arg_3.y + (Math.sin((_local_6 - _arg_4)) * _arg_5));
            _arg_1.lineTo(_local_7, _local_8);
        }

        private function __playerChange(_arg_1:CrazyTankSocketEvent):void
        {
            var _local_2:Living;
            this._drawRoute.graphics.clear();
            this._useAble = false;
            this.currentLivID = -1;
            for each (_local_2 in this._allLivings)
            {
                _local_2.state = false;
            };
        }

        private function __playerExit(_arg_1:Event):void
        {
            if (this._useAble)
            {
                this.currentLivID = this.calculateRecent();
            };
        }

        protected function __changeAngle(_arg_1:LivingEvent):void
        {
            if (this._useAble)
            {
                this.showShoot();
            };
        }

        protected function __wishofdd(_arg_1:CrazyTankSocketEvent):void
        {
            var _local_3:Number;
            var _local_4:Number;
            var _local_2:Boolean = _arg_1.pkg.readBoolean();
            if (_local_2)
            {
                _local_3 = _arg_1.pkg.readInt();
                this._mapWind = ((_local_3 / 10) * this._windFactor);
                this._useAble = true;
                this.showShoot();
            }
            else
            {
                _local_4 = _arg_1.pkg.readInt();
                this._useAble = false;
            };
        }

        private function __thumbnailControlHandle(_arg_1:GameEvent):void
        {
            this.currentLivID = (_arg_1.data as int);
        }

        private function calculateRecent():int
        {
            var _local_3:Living;
            var _local_4:Vector.<Point>;
            var _local_5:int;
            var _local_6:int;
            var _local_1:int = int.MAX_VALUE;
            var _local_2:int = -1;
            for each (_local_3 in this._allLivings)
            {
                if (((_local_3.route) && (!(_local_3 is SmallEnemy))))
                {
                    _local_4 = _local_3.route;
                    _local_5 = _local_4.length;
                    if (_local_5 >= 2)
                    {
                        _local_6 = this.getDistance(_local_4[0], _local_4[(_local_5 - 1)]);
                        if (_local_6 < _local_1)
                        {
                            _local_1 = _local_6;
                            _local_2 = _local_3.LivingID;
                        };
                    };
                };
            };
            return (_local_2);
        }

        private function getDistance(_arg_1:Point, _arg_2:Point):int
        {
            return (((_arg_2.x - _arg_1.x) * (_arg_2.x - _arg_1.x)) + ((_arg_2.y - _arg_1.y) * (_arg_2.y - _arg_1.y)));
        }

        private function __moveMouseState(_arg_1:LivingEvent):void
        {
            this._mouseStateView.setPos();
        }

        private function __playerTurnLeft(_arg_1:GameEvent):void
        {
            if (this._gameInfo.selfGamePlayer.direction == 1)
            {
                this._mouseStateView.turnLeft();
            };
            this.__changeMouseStateAngle(null);
        }

        private function __playerTurnRight(_arg_1:GameEvent):void
        {
            if (this._gameInfo.selfGamePlayer.direction == -1)
            {
                this._mouseStateView.turnRight();
            };
            this.__changeMouseStateAngle(null);
        }

        private function __changeMouseStateAngle(_arg_1:GameEvent):void
        {
            this._mouseStateView.changeDegree();
        }

        private function __changeForce(_arg_1:LivingEvent):void
        {
            this._mouseStateView.changeForce();
        }

        private function __changeGunAngle(_arg_1:LivingEvent):void
        {
            this._mouseStateView.changeDegree();
        }

        private function __changePlayerAngle(_arg_1:LivingEvent):void
        {
            this._mouseStateView.setPos();
            this._mouseStateView.changeDegree();
        }

        protected function __attackingChanged(_arg_1:LivingEvent):void
        {
            this._mouseStateView.attactionChange();
            this._mouseStateView.hide();
            if (this._selfGamePlayer)
            {
                if (((this._gameInfo.selfGamePlayer.isLiving) && (this._gameInfo.selfGamePlayer.isAttacking)))
                {
                    if (this._gameInfo.selfGamePlayer.mouseState)
                    {
                        setTimeout(this.mouseStateSetPos, 100);
                    }
                    else
                    {
                        this._mouseStateView.hide();
                    };
                };
            };
        }

        private function mouseStateSetPos():void
        {
            this._mouseStateView.setPos();
            this._mouseStateView.show();
            this._mouseStateView.setLastAngleAndForce();
            if (SavePointManager.Instance.isInSavePoint(4))
            {
                this._hasShowMouseGuilde = true;
                this._mouseStateView.showLead();
            };
        }

        private function __bossUseSkill(_arg_1:GameEvent):void
        {
            if (this._gameInfo.selfGamePlayer.mouseState)
            {
                this._mouseStateView.show();
                this._mouseStateView.setPos();
                this._mouseStateView.setLastAngleAndForce();
            }
            else
            {
                this._mouseStateView.hide();
            };
        }

        private function __mouseModelDown(_arg_1:GameEvent):void
        {
            this._selfMarkBar.visible = false;
        }


    }
}//package game.view

