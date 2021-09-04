package game.view
{
   import bagAndInfo.info.PlayerInfoViewControl;
   import com.greensock.TweenLite;
   import com.pickgliss.loader.BaseLoader;
   import com.pickgliss.loader.LoadResourceManager;
   import com.pickgliss.toplevel.StageReferance;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.utils.ClassUtils;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.BallInfo;
   import ddt.data.map.MissionInfo;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.events.DungeonInfoEvent;
   import ddt.events.GameEvent;
   import ddt.events.LivingEvent;
   import ddt.manager.BallManager;
   import ddt.manager.BitmapManager;
   import ddt.manager.BuffManager;
   import ddt.manager.ChatManager;
   import ddt.manager.IMEManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.LoadBombManager;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PathManager;
   import ddt.manager.PetSkillManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SavePointManager;
   import ddt.manager.SharedManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.states.BaseStateView;
   import ddt.utils.MenoryUtil;
   import ddt.utils.PositionUtils;
   import ddt.view.MainToolBar;
   import ddt.view.chat.ChatBugleView;
   import flash.display.Graphics;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.media.SoundTransform;
   import flash.utils.Dictionary;
   import flash.utils.setTimeout;
   import game.GameManager;
   import game.actions.ViewEachPlayerAction;
   import game.model.GameInfo;
   import game.model.GameNeedPetSkillInfo;
   import game.model.Living;
   import game.model.LocalPlayer;
   import game.model.Player;
   import game.model.SmallEnemy;
   import game.model.TurnedLiving;
   import game.objects.BossLocalPlayer;
   import game.objects.BossPlayer;
   import game.objects.GameLiving;
   import game.objects.GameLocalPlayer;
   import game.objects.GamePlayer;
   import game.objects.GameTurnedLiving;
   import game.view.buff.SelfBuffBar;
   import game.view.control.ControlState;
   import game.view.control.FightControlBar;
   import game.view.control.LiveState;
   import game.view.control.MouseStateAccieve;
   import game.view.control.MouseStateView;
   import game.view.map.MapView;
   import game.view.playerThumbnail.PlayerThumbnailController;
   import game.view.propContainer.PlayerStateContainer;
   import pet.date.PetInfo;
   import pet.date.PetSkillInfo;
   import phy.math.EulerVector;
   import road7th.data.DictionaryData;
   import road7th.utils.MovieClipWrapper;
   import room.RoomManager;
   import room.model.RoomInfo;
   import room.model.RoomPlayer;
   
   public class GameViewBase extends BaseStateView
   {
       
      
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
      
      private const GUIDEID:int = 10029;
      
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
      
      private var _ef:Point;
      
      private var _shootAngle:Number;
      
      private var _state:Boolean = false;
      
      private var _useAble:Boolean = false;
      
      private var _stateFlag:int;
      
      private var _currentLivID:int;
      
      private var _collideRect:Rectangle;
      
      private var _drawRoute:Sprite;
      
      public function GameViewBase()
      {
         this._ef = new Point(0,0);
         this._collideRect = new Rectangle(-45,-30,100,80);
         super();
      }
      
      protected function needLeftPlayerView() : Boolean
      {
         return true;
      }
      
      override public function prepare() : void
      {
         super.prepare();
      }
      
      override public function fadingComplete() : void
      {
         super.fadingComplete();
         if(this._barrierVisible)
         {
            this.drawMissionInfo();
         }
         if(!RoomManager.Instance.current.selfRoomPlayer.isViewer)
         {
            this._fightControlBar.setState(FightControlBar.LIVE);
         }
      }
      
      override public function enter(param1:BaseStateView, param2:Object = null) : void
      {
         var _loc4_:GameNeedPetSkillInfo = null;
         var _loc5_:Array = null;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:Living = null;
         var _loc10_:RoomPlayer = null;
         var _loc11_:Player = null;
         var _loc12_:PetInfo = null;
         var _loc13_:int = 0;
         var _loc14_:PetSkillInfo = null;
         var _loc15_:BallInfo = null;
         super.enter(param1,param2);
         this._gameInfo = GameManager.Instance.Current;
         var _loc3_:int = 0;
         while(_loc3_ < this._gameInfo.neededMovies.length)
         {
            this._gameInfo.neededMovies[_loc3_].startLoad();
            _loc3_++;
         }
         for each(_loc4_ in this._gameInfo.neededPetSkillResource)
         {
            _loc4_.startLoad();
         }
         _loc5_ = this._gameInfo.roomPlayers;
         LoadBombManager.Instance.loadFullWeaponBombMovie(_loc5_);
         _loc6_ = this._gameInfo.roomPlayers.length;
         _loc7_ = 0;
         while(_loc7_ < _loc6_)
         {
            _loc10_ = this._gameInfo.roomPlayers[_loc7_];
            if(!_loc10_.isViewer)
            {
               _loc11_ = this._gameInfo.findLivingByPlayerID(_loc10_.playerInfo.ID,_loc10_.playerInfo.ZoneID);
               _loc11_.movie.show(true,-1);
               _loc12_ = _loc11_.playerInfo.currentPet;
               if(_loc12_)
               {
                  LoadResourceManager.instance.creatAndStartLoad(PathManager.solvePetGameAssetUrl(_loc12_.GameAssetUrl),BaseLoader.MODULE_LOADER);
                  for each(_loc13_ in _loc12_.skills)
                  {
                     if(_loc13_ > 0 && _loc13_ < 1000)
                     {
                        _loc14_ = PetSkillManager.instance.getSkillByID(_loc13_);
                        BuffManager.getResource(_loc14_.ElementIDs);
                        if(_loc14_.NewBallID != -1)
                        {
                           _loc15_ = BallManager.findBall(_loc14_.NewBallID);
                           _loc15_.loadBombAsset();
                        }
                     }
                  }
               }
            }
            _loc7_++;
         }
         GameManager.Instance.isLeaving = false;
         this._bitmapMgr = BitmapManager.getBitmapMgr("GameView");
         SharedManager.Instance.propTransparent = false;
         MainToolBar.Instance.hide();
         LayerManager.Instance.clearnStageDynamic();
         ChatBugleView.instance.hide();
         PlayerManager.Instance.Self.TempBag.clearnAll();
         GameManager.Instance.Current.selfGamePlayer.petSkillEnabled = true;
         for each(_loc8_ in this._gameInfo.livings)
         {
            if(_loc8_ is Player)
            {
               Player(_loc8_).isUpGrade = false;
               Player(_loc8_).LockState = false;
            }
         }
         this._map = this.newMap();
         this._map.gameView = this;
         this._map.x = this._map.y = 0;
         addChild(this._map);
         this._map.smallMap.x = StageReferance.stageWidth - this._map.smallMap.realWidth - 1;
         this._map.smallMap.enableExit = this._gameInfo.roomType != 10 && this._gameInfo.roomType != 14;
         addChild(this._map.smallMap);
         this._map.smallMap.hideSpliter();
         this._mouseState = new MouseStateAccieve(this._gameInfo.selfGamePlayer);
         this._mouseState.enter(LayerManager.Instance.getLayerByType(LayerManager.GAME_TOP_LAYER));
         this._selfMarkBar = new SelfMarkBar(this._gameInfo.selfGamePlayer,this);
         this._selfMarkBar.x = 500;
         this._selfMarkBar.y = 79;
         this._fightControlBar = new FightControlBar(this._gameInfo.selfGamePlayer,this);
         GameManager.Instance.Current.selfGamePlayer.addEventListener(LivingEvent.DIE,this.__selfDie);
         if(this.needLeftPlayerView())
         {
            this._leftPlayerView = new LeftPlayerCartoonView();
         }
         this._vane = new VaneView();
         this._vane.setUpCenter(446,0);
         addChild(this._vane);
         SoundManager.instance.playGameBackMusic(this._map.info.BackMusic);
         this._selfBuffBar = ComponentFactory.Instance.creatCustomObject("SelfBuffBar",[this]);
         addChildAt(this._selfBuffBar,this.numChildren - 1);
         this.setSlefBuffBarPos();
         this._players = new Dictionary();
         this._playerThumbnailLController = new PlayerThumbnailController(this._gameInfo);
         var _loc9_:Point = ComponentFactory.Instance.creatCustomObject("asset.game.ThumbnailLPos");
         this._playerThumbnailLController.x = _loc9_.x;
         this._playerThumbnailLController.y = _loc9_.y;
         addChildAt(this._playerThumbnailLController,getChildIndex(this._map.smallMap));
         SharedManager.Instance.addEventListener(Event.CHANGE,this.__soundChange);
         this.__soundChange(null);
         this.setupGameData();
         this.addChatView();
         if(this.switchUserGuide)
         {
            this.loadWeakGuild();
         }
         this.defaultForbidDragFocus();
         this.initEvent();
         this.resetPlayerCharacters();
      }
      
      protected function addChatView() : void
      {
         ChatManager.Instance.state = ChatManager.CHAT_GAME_STATE;
         addChild(ChatManager.Instance.view);
      }
      
      public function get switchUserGuide() : Boolean
      {
         return (PlayerManager.Instance.Self.Grade <= 15 ? Boolean(true) : Boolean(false)) && PathManager.solveUserGuildEnable();
      }
      
      protected function setSlefBuffBarPos() : void
      {
         if(GameManager.Instance.Current.selfGamePlayer.mouseState)
         {
            PositionUtils.setPos(this._selfBuffBar,"SelfBuffBar.pos2");
         }
         else
         {
            PositionUtils.setPos(this._selfBuffBar,"SelfBuffBar.pos1");
         }
         if(this._useFightModel)
         {
            this._selfBuffBar.x -= 60;
         }
      }
      
      private function resetPlayerCharacters() : void
      {
         var _loc1_:GameLiving = null;
         for each(_loc1_ in this._players)
         {
            _loc1_.info.character.resetShowBitmapBig();
            _loc1_.info.character.showWing = true;
            _loc1_.info.character.show();
         }
      }
      
      protected function __mouseModelStateChange(param1:Event) : void
      {
         this.setSlefBuffBarPos();
         if(this._gameInfo.selfGamePlayer.isLiving && this._gameInfo.selfGamePlayer.isAttacking)
         {
            if(this._selfGamePlayer)
            {
               this._selfGamePlayer.aim.visible = !this._gameInfo.selfGamePlayer.mouseState;
            }
            if(this._gameInfo.selfGamePlayer.mouseState && (!this._selfTurnedLiving || this._selfTurnedLiving && this._gameInfo.selfGamePlayer.canNormalShoot))
            {
               this._mouseStateView.show();
               this._mouseStateView.setPos();
               if(!this._hasShowMouseGuilde)
               {
                  this._hasShowMouseGuilde = true;
                  this._mouseStateView.showLead();
               }
            }
            else
            {
               this._mouseStateView.removeLastPowerLead();
               this._mouseStateView.hide();
            }
         }
      }
      
      protected function __moveProp(param1:Event) : void
      {
         this._useFightModel = true;
         if(this._selfBuffBar)
         {
            TweenLite.to(this._selfBuffBar,0.5,{"x":this._selfBuffBar.x - 60});
         }
      }
      
      protected function __wishClick(param1:Event) : void
      {
         this._selfUsedProp.info.addState(0);
      }
      
      protected function __selfDie(param1:LivingEvent) : void
      {
         var _loc4_:Living = null;
         var _loc2_:Living = param1.currentTarget as Living;
         var _loc3_:DictionaryData = this._gameInfo.findTeam(_loc2_.team);
         for each(_loc4_ in _loc3_)
         {
            if(_loc4_.isLiving)
            {
               this._fightControlBar.setState(FightControlBar.SOUL);
               return;
            }
         }
         if(this._selfBuffBar)
         {
            this._selfBuffBar.dispose();
         }
         this._selfBuffBar = null;
      }
      
      protected function drawMissionInfo() : void
      {
         if(this._gameInfo.roomType == RoomInfo.DUNGEON_ROOM || this._gameInfo.roomType == RoomInfo.MULTI_DUNGEON || this._gameInfo.roomType == RoomInfo.SINGLE_DUNGEON || this._gameInfo.roomType == RoomInfo.CONSORTION_MONSTER || this._gameInfo.roomType == RoomInfo.CHANGE_DUNGEON)
         {
            this._map.smallMap.titleBar.addEventListener(DungeonInfoEvent.DungeonHelpChanged,this.__dungeonVisibleChanged);
            this._barrier = new DungeonInfoView(this._map.smallMap.titleBar.turnButton,this);
            this._barrier.addEventListener(GameEvent.DungeonHelpVisibleChanged,this.__dungeonHelpChanged);
            this._barrier.addEventListener(GameEvent.UPDATE_SMALLMAPVIEW,this.__updateSmallMapView);
            this._missionHelp = new DungeonHelpView(this._map.smallMap.titleBar.turnButton,this._barrier,this);
            addChild(this._missionHelp);
            this._barrier.open();
         }
      }
      
      protected function __updateSmallMapView(param1:GameEvent) : void
      {
         var _loc2_:MissionInfo = GameManager.Instance.Current.missionInfo;
         if(_loc2_.currentValue1 != -1 && _loc2_.totalValue1 > 0)
         {
            this._map.smallMap.setBarrier(_loc2_.currentValue1,_loc2_.totalValue1);
         }
      }
      
      protected function __dungeonHelpChanged(param1:GameEvent) : void
      {
         var _loc2_:Rectangle = null;
         if(this._missionHelp)
         {
            if(param1.data)
            {
               if(this._missionHelp.opened)
               {
                  _loc2_ = this._barrier.getBounds(this);
                  _loc2_.width = _loc2_.height = 1;
                  this._missionHelp.close(_loc2_);
               }
               else
               {
                  this._missionHelp.open();
               }
            }
            else if(this._missionHelp.opened)
            {
               _loc2_ = this._map.smallMap.titleBar.turnButton.getBounds(this);
               this._missionHelp.close(_loc2_);
            }
         }
      }
      
      protected function __dungeonVisibleChanged(param1:DungeonInfoEvent) : void
      {
         if(this._barrier && this._barrierVisible)
         {
            if(this._barrier.parent)
            {
               this._barrier.close();
            }
            else
            {
               this._barrier.open();
            }
         }
      }
      
      private function __onMissonHelpClick(param1:MouseEvent) : void
      {
         StageReferance.stage.focus = this._map;
      }
      
      protected function initEvent() : void
      {
         this._playerThumbnailLController.addEventListener(GameEvent.WISH_SELECT,this.__thumbnailControlHandle);
         GameManager.Instance.Current.selfGamePlayer.addEventListener(GameEvent.MOUSE_MODEL_STATE,this.__mouseModelStateChange);
         GameManager.Instance.Current.selfGamePlayer.addEventListener(LivingEvent.GUNANGLE_CHANGED,this.__changeGunAngle);
         GameManager.Instance.Current.selfGamePlayer.addEventListener(LivingEvent.ANGLE_CHANGED,this.__changePlayerAngle);
         GameManager.Instance.Current.selfGamePlayer.addEventListener(GameEvent.MOUSE_MODEL_DOWN,this.__mouseModelDown);
         GameManager.Instance.addEventListener(GameManager.MOVE_PROPBAR,this.__moveProp);
         this._gameInfo.selfGamePlayer.addEventListener(GameEvent.MOUSE_MODEL_CHANGE_ANGLE,this.__changeMouseStateAngle);
         this._gameInfo.selfGamePlayer.addEventListener(LivingEvent.FORCE_CHANGED,this.__changeForce);
         this._gameInfo.selfGamePlayer.addEventListener(LivingEvent.POS_CHANGED,this.__moveMouseState);
      }
      
      protected function loadWeakGuild() : void
      {
         this._vane.visible = Boolean(SavePointManager.Instance.savePoints[59]) ? Boolean(true) : Boolean(false);
         if(SavePointManager.Instance.isInSavePoint(59))
         {
            setTimeout(this.propOpenShow,2000,"asset.trainer.openVane");
         }
      }
      
      private function isWishGuideLoad() : Boolean
      {
         return true;
      }
      
      private function propOpenShow(param1:String) : void
      {
         var _loc2_:MovieClipWrapper = new MovieClipWrapper(ClassUtils.CreatInstance(param1),true,true);
         LayerManager.Instance.addToLayer(_loc2_.movie,LayerManager.GAME_UI_LAYER,false);
         if(SavePointManager.Instance.isInSavePoint(59))
         {
            SavePointManager.Instance.setSavePoint(59);
            this._vane.visible = true;
         }
      }
      
      protected function newMap() : MapView
      {
         if(this._map)
         {
            throw new Error(LanguageMgr.GetTranslation("tank.game.mapGenerated"));
         }
         return new MapView(this._gameInfo,this._gameInfo.loaderMap);
      }
      
      private function __soundChange(param1:Event) : void
      {
         var _loc2_:SoundTransform = new SoundTransform();
         if(SharedManager.Instance.allowSound)
         {
            _loc2_.volume = SharedManager.Instance.soundVolumn / 100;
            this.soundTransform = _loc2_;
         }
         else
         {
            _loc2_.volume = 0;
            this.soundTransform = _loc2_;
         }
      }
      
      public function restoreSmallMap() : void
      {
         this._map.smallMap.restore();
      }
      
      protected function disposeUI() : void
      {
         ObjectUtils.disposeObject(this._achievBar);
         this._achievBar = null;
         if(this._playerThumbnailLController)
         {
            this._playerThumbnailLController.dispose();
         }
         this._playerThumbnailLController = null;
         ObjectUtils.disposeObject(this._selfUsedProp);
         this._selfUsedProp = null;
         if(this._leftPlayerView)
         {
            this._leftPlayerView.dispose();
         }
         this._leftPlayerView = null;
         ObjectUtils.disposeObject(this._fightControlBar);
         this._fightControlBar = null;
         ObjectUtils.disposeObject(this._selfMarkBar);
         this._selfMarkBar = null;
         if(this._selfBuffBar)
         {
            ObjectUtils.disposeObject(this._selfBuffBar);
         }
         this._selfBuffBar = null;
         if(this._vane)
         {
            this._vane.dispose();
            this._vane = null;
         }
         ObjectUtils.disposeObject(this._mouseState);
         this._mouseState = null;
      }
      
      override public function leaving(param1:BaseStateView) : void
      {
         super.leaving(param1);
         ObjectUtils.disposeObject(this._mouseStateView);
         this._mouseStateView = null;
         this._useFightModel = false;
         this._playerThumbnailLController.removeEventListener(GameEvent.WISH_SELECT,this.__thumbnailControlHandle);
         this._gameInfo.selfGamePlayer.removeEventListener(LivingEvent.POS_CHANGED,this.__moveMouseState);
         this._gameInfo.selfGamePlayer.removeEventListener(LivingEvent.FORCE_CHANGED,this.__changeForce);
         this._gameInfo.selfGamePlayer.removeEventListener(GameEvent.MOUSE_MODEL_CHANGE_ANGLE,this.__changeMouseStateAngle);
         GameManager.Instance.isLeaving = true;
         this.disposeUI();
         this.removeGameData();
         ObjectUtils.disposeObject(this._bitmapMgr);
         this._bitmapMgr = null;
         this._map.smallMap.titleBar.removeEventListener(DungeonInfoEvent.DungeonHelpChanged,this.__dungeonVisibleChanged);
         GameManager.Instance.Current.selfGamePlayer.removeEventListener(GameEvent.MOUSE_MODEL_STATE,this.__mouseModelStateChange);
         GameManager.Instance.Current.selfGamePlayer.removeEventListener(LivingEvent.GUNANGLE_CHANGED,this.__changeGunAngle);
         GameManager.Instance.Current.selfGamePlayer.removeEventListener(LivingEvent.ANGLE_CHANGED,this.__changePlayerAngle);
         GameManager.Instance.Current.selfGamePlayer.removeEventListener(GameEvent.MOUSE_MODEL_DOWN,this.__mouseModelDown);
         GameManager.Instance.removeEventListener(GameManager.MOVE_PROPBAR,this.__moveProp);
         PlayerInfoViewControl.clearView();
         LayerManager.Instance.clearnGameDynamic();
         removeChild(this._map);
         this._map.dispose();
         this._map = null;
         SharedManager.Instance.removeEventListener(Event.CHANGE,this.__soundChange);
         GameManager.Instance.Current.selfGamePlayer.removeEventListener(LivingEvent.DIE,this.__selfDie);
         IMEManager.enable();
         while(numChildren > 0)
         {
            removeChildAt(0);
         }
         MenoryUtil.clearMenory();
         if(this._barrier)
         {
            this._barrier.removeEventListener(GameEvent.DungeonHelpVisibleChanged,this.__dungeonHelpChanged);
            this._barrier.removeEventListener(GameEvent.UPDATE_SMALLMAPVIEW,this.__updateSmallMapView);
            ObjectUtils.disposeObject(this._barrier);
            this._barrier = null;
         }
         ObjectUtils.disposeObject(this._drawRoute);
         this._drawRoute = null;
      }
      
      protected function setupGameData() : void
      {
         var _loc2_:Living = null;
         var _loc3_:GameLiving = null;
         var _loc4_:Player = null;
         var _loc5_:RoomPlayer = null;
         var _loc1_:Array = new Array();
         for each(_loc2_ in this._gameInfo.livings)
         {
            if(_loc2_ is Player)
            {
               _loc4_ = _loc2_ as Player;
               _loc5_ = RoomManager.Instance.current.findPlayerByID(_loc4_.playerInfo.ID);
               if(_loc4_.isSelf)
               {
                  this._self = _loc4_ as LocalPlayer;
                  if(!_loc4_.isBoss)
                  {
                     _loc3_ = new GameLocalPlayer(this._gameInfo.selfGamePlayer,_loc4_.character,_loc4_.movie);
                  }
                  else
                  {
                     _loc3_ = new BossLocalPlayer(this._gameInfo.selfGamePlayer,_loc4_.character,_loc4_.movie);
                  }
                  this._selfGamePlayer = _loc3_ as GameLocalPlayer;
                  this._selfTurnedLiving = _loc3_ as GameTurnedLiving;
                  if(this._selfGamePlayer)
                  {
                     this._selfGamePlayer.turnedLiving.addEventListener(LivingEvent.ATTACKING_CHANGED,this.__attackingChanged);
                     this._selfGamePlayer.addEventListener(GameEvent.TURN_LEFT,this.__playerTurnLeft);
                     this._selfGamePlayer.addEventListener(GameEvent.TURN_RIGHT,this.__playerTurnRight);
                  }
                  if(this._selfTurnedLiving)
                  {
                     this._selfTurnedLiving.turnedLiving.addEventListener(LivingEvent.ATTACKING_CHANGED,this.__attackingChanged);
                     this._selfTurnedLiving.addEventListener(GameEvent.TURN_LEFT,this.__playerTurnLeft);
                     this._selfTurnedLiving.addEventListener(GameEvent.TURN_RIGHT,this.__playerTurnRight);
                     this._selfTurnedLiving.addEventListener(GameEvent.BOSS_USE_SKILL,this.__bossUseSkill);
                  }
                  this._mouseStateView = new MouseStateView(GameTurnedLiving(_loc3_),this._map);
                  this._map.addToControlLayer(this._mouseStateView);
               }
               else if(!_loc4_.isBoss)
               {
                  _loc3_ = new GamePlayer(_loc4_,_loc4_.character,_loc4_.movie);
               }
               else
               {
                  _loc3_ = new BossPlayer(_loc4_,_loc4_.character,_loc4_.movie);
               }
               if(_loc4_.movie && !_loc4_.isBoss)
               {
                  _loc4_.movie.setDefaultAction(_loc4_.movie.standAction);
                  _loc4_.movie.doAction(_loc4_.movie.standAction);
               }
               _loc1_.push(_loc3_);
               this._map.addPhysical(_loc3_);
               if(_loc3_ is GamePlayer && GamePlayer(_loc3_).gamePet)
               {
                  this._map.addPhysical(GamePlayer(_loc3_).gamePet);
               }
               this._players[_loc2_] = _loc3_;
            }
         }
         this._map.wind = GameManager.Instance.Current.wind;
         this._gameInfo.currentTurn = 1;
         this._vane.initialize();
         this._vane.update(this._map.wind);
         this._map.act(new ViewEachPlayerAction(this._map,_loc1_));
      }
      
      private function removeGameData() : void
      {
         var _loc1_:GameLiving = null;
         if(this._selfGamePlayer)
         {
            this._selfGamePlayer.turnedLiving.removeEventListener(LivingEvent.ATTACKING_CHANGED,this.__attackingChanged);
            this._selfGamePlayer.removeEventListener(GameEvent.TURN_LEFT,this.__playerTurnLeft);
            this._selfGamePlayer.removeEventListener(GameEvent.TURN_RIGHT,this.__playerTurnRight);
         }
         if(this._selfTurnedLiving)
         {
            this._selfTurnedLiving.turnedLiving.removeEventListener(LivingEvent.ATTACKING_CHANGED,this.__attackingChanged);
            this._selfTurnedLiving.removeEventListener(GameEvent.TURN_LEFT,this.__playerTurnLeft);
            this._selfTurnedLiving.removeEventListener(GameEvent.TURN_RIGHT,this.__playerTurnRight);
            this._selfTurnedLiving.addEventListener(GameEvent.BOSS_USE_SKILL,this.__bossUseSkill);
         }
         for each(_loc1_ in this._players)
         {
            _loc1_.dispose();
            delete this._players[_loc1_.info];
         }
         this._players = null;
         this._selfGamePlayer = null;
         this._selfTurnedLiving = null;
         this._gameInfo = null;
         this._barrierVisible = true;
      }
      
      public function addLiving(param1:Living) : void
      {
      }
      
      protected function updatePlayerState(param1:Living) : void
      {
         if(this._selfUsedProp == null)
         {
            this._selfUsedProp = new PlayerStateContainer(12);
            PositionUtils.setPos(this._selfUsedProp,"asset.game.selfUsedProp");
            addChild(this._selfUsedProp);
         }
         if(this._selfUsedProp)
         {
            this._selfUsedProp.disposeAllChildren();
         }
         if(this._selfUsedProp && this._selfBuffBar)
         {
            this._selfUsedProp.x = this._selfBuffBar.right;
         }
         if(param1 is TurnedLiving)
         {
            this._selfUsedProp.info = TurnedLiving(param1);
         }
         if(GameManager.Instance.Current.selfGamePlayer.isAutoGuide && GameManager.Instance.Current.currentLiving.LivingID == GameManager.Instance.Current.selfGamePlayer.LivingID)
         {
            MessageTipManager.getInstance().show(String(GameManager.Instance.Current.selfGamePlayer.LivingID),3);
         }
      }
      
      public function setCurrentPlayer(param1:Living) : void
      {
         if(!GameManager.Instance.Current.selfGamePlayer.isLiving && this._selfBuffBar)
         {
            this._selfBuffBar.visible = false;
         }
         else if(this._selfBuffBar)
         {
            this._selfBuffBar.visible = true;
         }
         if(!RoomManager.Instance.current.selfRoomPlayer.isViewer && param1 && this._selfBuffBar)
         {
            this._selfBuffBar.drawBuff(param1);
         }
         if(this._leftPlayerView)
         {
            this._leftPlayerView.info = param1;
         }
         this._map.bringToFront(param1);
         if(this._map.currentPlayer && !(param1 is TurnedLiving))
         {
            this._map.currentPlayer.isAttacking = false;
            this._map.currentPlayer = null;
         }
         else
         {
            this._map.currentPlayer = param1 as TurnedLiving;
         }
         this.updatePlayerState(param1);
         if(this._leftPlayerView)
         {
            addChildAt(this._leftPlayerView,this.numChildren - 3);
         }
         var _loc2_:LocalPlayer = GameManager.Instance.Current.selfGamePlayer;
         if(this._map.currentPlayer)
         {
            if(_loc2_)
            {
               _loc2_.soulPropEnabled = !_loc2_.isLiving && this._map.currentPlayer.team == _loc2_.team;
            }
         }
         else if(_loc2_)
         {
            _loc2_.soulPropEnabled = false;
         }
      }
      
      public function updateControlBarState(param1:Living) : void
      {
         if(GameManager.Instance.Current == null)
         {
            return;
         }
         if(GameManager.Instance.Current.selfGamePlayer.LockState)
         {
            this.setPropBarClickEnable(false,true);
            return;
         }
         if(param1 is TurnedLiving && param1.isLiving && GameManager.Instance.Current.selfGamePlayer.canUseProp(param1 as TurnedLiving))
         {
            this.setPropBarClickEnable(true,false);
         }
         else if(param1)
         {
            if(!GameManager.Instance.Current.selfGamePlayer.isLiving && param1.isSelf)
            {
               this.setPropBarClickEnable(true,false);
            }
            else if(!GameManager.Instance.Current.selfGamePlayer.isLiving && GameManager.Instance.Current.selfGamePlayer.team != param1.team)
            {
               this.setPropBarClickEnable(false,true);
            }
            else
            {
               this.setPropBarClickEnable(true,false);
            }
         }
         else
         {
            this.setPropBarClickEnable(true,false);
         }
      }
      
      protected function setPropBarClickEnable(param1:Boolean, param2:Boolean) : void
      {
         GameManager.Instance.Current.selfGamePlayer.rightPropEnabled = param1;
         GameManager.Instance.Current.selfGamePlayer.weaponPropEnbled = param1;
         GameManager.Instance.Current.selfGamePlayer.customPropEnabled = param1;
      }
      
      protected function gameOver() : void
      {
         this._map.smallMap.enableExit = false;
         SoundManager.instance.stopMusic();
         this.setPropBarClickEnable(false,false);
         if(this._leftPlayerView)
         {
            this._leftPlayerView.gameOver();
            this._leftPlayerView.visible = false;
         }
         this._selfMarkBar.shutdown();
         this._selfMarkBar.shutdownInSingle();
      }
      
      protected function set barrierInfo(param1:CrazyTankSocketEvent) : void
      {
         if(this._barrier)
         {
            this._barrier.barrierInfoHandler(param1);
         }
      }
      
      protected function set arrowHammerEnable(param1:Boolean) : void
      {
      }
      
      public function blockHammer() : void
      {
      }
      
      public function allowHammer() : void
      {
      }
      
      protected function defaultForbidDragFocus() : void
      {
      }
      
      protected function setBarrierVisible(param1:Boolean) : void
      {
         this._barrierVisible = param1;
      }
      
      protected function setVaneVisible(param1:Boolean) : void
      {
         this._vane.visible = param1;
      }
      
      protected function setPlayerThumbVisible(param1:Boolean) : void
      {
         this._playerThumbnailLController.visible = param1;
      }
      
      protected function setEnergyVisible(param1:Boolean) : void
      {
         var _loc2_:LiveState = this.currentControllState as LiveState;
         if(_loc2_)
         {
            _loc2_.setEnergyVisible(param1);
         }
      }
      
      protected function get currentControllState() : ControlState
      {
         return this._fightControlBar.current;
      }
      
      public function setRecordRotation() : void
      {
      }
      
      public function get map() : MapView
      {
         return this._map;
      }
      
      protected function set mapWind(param1:Number) : void
      {
         this._mapWind = param1;
         if(this._useAble)
         {
            this.showShoot();
         }
      }
      
      public function get currentLivID() : int
      {
         return this._currentLivID;
      }
      
      public function set currentLivID(param1:int) : void
      {
         this._currentLivID = param1;
         this.drawRouteLine(this._currentLivID);
         if(this._map)
         {
            this._map.smallMap.drawRouteLine(this._currentLivID);
         }
      }
      
      private function wishInit() : void
      {
         this._self = GameManager.Instance.Current.selfGamePlayer;
         this._selfGameLiving = this._map.getPhysical(this._self.LivingID) as GamePlayer;
         this._allLivings = GameManager.Instance.Current.livings;
         this._drawRoute = new Sprite();
         this._map.addChild(this._drawRoute);
         this.currentLivID = -1;
         this._self.addEventListener(LivingEvent.GUNANGLE_CHANGED,this.__changeAngle);
         this._self.addEventListener(LivingEvent.POS_CHANGED,this.__changeAngle);
         this._self.addEventListener(LivingEvent.DIR_CHANGED,this.__changeAngle);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.WISHOFDD,this.__wishofdd);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.PLAYER_CHANGE,this.__playerChange);
         RoomManager.Instance.addEventListener(RoomManager.PLAYER_ROOM_EXIT,this.__playerExit);
      }
      
      private function wishRemoveEvent() : void
      {
         this._self.removeEventListener(LivingEvent.GUNANGLE_CHANGED,this.__changeAngle);
         this._self.removeEventListener(LivingEvent.POS_CHANGED,this.__changeAngle);
         this._self.removeEventListener(LivingEvent.DIR_CHANGED,this.__changeAngle);
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.WISHOFDD,this.__wishofdd);
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.PLAYER_CHANGE,this.__playerChange);
         RoomManager.Instance.removeEventListener(RoomManager.PLAYER_ROOM_EXIT,this.__playerExit);
      }
      
      protected function showShoot() : void
      {
         var _loc2_:Point = null;
         var _loc3_:Player = null;
         var _loc4_:Living = null;
         var _loc5_:Number = NaN;
         var _loc6_:Boolean = false;
         var _loc7_:Boolean = false;
         var _loc1_:Point = this._selfGameLiving.body.localToGlobal(new Point(30,-20));
         _loc1_ = this._map.globalToLocal(_loc1_);
         this._shootAngle = this._self.calcBombAngle();
         this._arf = this._map.airResistance;
         this._gf = this._map.gravity * this._mass * this._gravityFactor;
         this._ga = this._gf / this._mass;
         this._wa = this._mapWind / this._mass;
         for each(_loc4_ in this._allLivings)
         {
            _loc4_.route = null;
            if(!(_loc4_.isHidden || _loc4_.team == GameManager.Instance.Current.selfGamePlayer.team || !_loc4_.isLiving || _loc4_.LivingID == this._self.LivingID))
            {
               _loc2_ = _loc4_.pos;
               if(this._self.isLiving && this._self.isAttacking)
               {
                  _loc4_.route = null;
                  _loc6_ = true;
                  _loc7_ = true;
                  if(_loc1_.x > _loc2_.x)
                  {
                     _loc6_ = false;
                  }
                  if(_loc1_.y > _loc2_.y)
                  {
                     _loc7_ = false;
                  }
                  if(this.judgeMaxPower(_loc1_,_loc2_,this._shootAngle,_loc6_,_loc7_))
                  {
                     _loc5_ = this.getPower(0,2000,_loc1_,_loc2_,this._shootAngle,_loc6_,_loc7_);
                  }
                  else
                  {
                     _loc5_ = 2100;
                  }
                  this._stateFlag = 0;
                  if(_loc5_ > 2000)
                  {
                     if(_loc4_.state)
                     {
                        this._stateFlag = 1;
                     }
                     else
                     {
                        this._stateFlag = 2;
                     }
                     _loc4_.state = false;
                  }
                  else
                  {
                     if(_loc4_.state)
                     {
                        this._stateFlag = 3;
                     }
                     else
                     {
                        this._stateFlag = 4;
                     }
                     _loc4_.state = true;
                  }
                  this._gameLiving = this._map.getPhysical(_loc4_.LivingID) as GameLiving;
                  if(this._stateFlag == 1 || this._stateFlag == 2)
                  {
                     _loc4_.route = null;
                  }
                  else
                  {
                     _loc4_.route = this.getRouteData(_loc5_,this._shootAngle,_loc1_,_loc2_);
                  }
                  _loc4_.fightPower = Number((_loc5_ * 100 / 2000).toFixed(1));
               }
            }
         }
         if(this.currentLivID == -1 || !GameManager.Instance.Current.findPlayer(this.currentLivID).route)
         {
            this.currentLivID = this.calculateRecent();
         }
         else
         {
            this.currentLivID = this.currentLivID;
         }
      }
      
      private function judgeMaxPower(param1:Point, param2:Point, param3:Number, param4:Boolean, param5:Boolean) : Boolean
      {
         var _loc6_:EulerVector = null;
         var _loc7_:EulerVector = null;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         _loc8_ = 2000 * Math.cos(param3 / 180 * Math.PI);
         _loc6_ = new EulerVector(param1.x,_loc8_,this._wa);
         _loc9_ = 2000 * Math.sin(param3 / 180 * Math.PI);
         _loc7_ = new EulerVector(param1.y,_loc9_,this._ga);
         var _loc10_:Boolean = false;
         while(true)
         {
            if(param4)
            {
               if(_loc6_.x0 > this._map.bound.width)
               {
                  return true;
               }
               if(_loc6_.x0 < this._map.bound.x || _loc7_.x0 > this._map.bound.height)
               {
                  return false;
               }
            }
            else
            {
               if(_loc6_.x0 < this._map.bound.x)
               {
                  return true;
               }
               if(_loc6_.x0 > this._map.bound.width || _loc7_.x0 > this._map.bound.height)
               {
                  return false;
               }
            }
            if(this.ifHit(_loc6_.x0,_loc7_.x0,param2))
            {
               return true;
            }
            _loc6_.ComputeOneEulerStep(this._mass,this._arf,this._mapWind,this._dt);
            _loc7_.ComputeOneEulerStep(this._mass,this._arf,this._gf,this._dt);
            if(param4 && param5)
            {
               if(_loc7_.x0 > param2.y)
               {
                  if(_loc6_.x0 < param2.x)
                  {
                     return false;
                  }
                  return true;
               }
            }
            else if(param4 && !param5)
            {
               if(!_loc10_)
               {
                  if(_loc6_.x0 > param2.x)
                  {
                     return false;
                  }
                  if(_loc7_.x0 < param2.y)
                  {
                     _loc10_ = true;
                  }
               }
               else if(_loc10_)
               {
                  if(_loc7_.x0 > param2.y)
                  {
                     if(_loc6_.x0 < param2.x)
                     {
                        return false;
                     }
                     return true;
                  }
               }
            }
            else if(!param4 && !param5)
            {
               if(!_loc10_)
               {
                  if(_loc6_.x0 < param2.x)
                  {
                     return false;
                  }
                  if(_loc7_.x0 < param2.y)
                  {
                     _loc10_ = true;
                  }
               }
               else if(_loc10_)
               {
                  if(_loc7_.x0 > param2.y)
                  {
                     if(_loc6_.x0 < param2.x)
                     {
                        return true;
                     }
                     return false;
                  }
               }
            }
            else if(!param4 && param5)
            {
               if(_loc7_.x0 > param2.y)
               {
                  if(_loc6_.x0 < param2.x)
                  {
                     return true;
                  }
                  return false;
               }
            }
         }
         return false;
      }
      
      protected function getPower(param1:Number, param2:Number, param3:Point, param4:Point, param5:Number, param6:Boolean, param7:Boolean) : Number
      {
         var _loc8_:EulerVector = null;
         var _loc9_:EulerVector = null;
         var _loc10_:int = 0;
         var _loc11_:int = 0;
         var _loc12_:int = (param1 + param2) / 2;
         if(_loc12_ <= param1 || _loc12_ >= param2)
         {
            return _loc12_;
         }
         _loc10_ = _loc12_ * Math.cos(param5 / 180 * Math.PI);
         _loc8_ = new EulerVector(param3.x,_loc10_,this._wa);
         _loc11_ = _loc12_ * Math.sin(param5 / 180 * Math.PI);
         _loc9_ = new EulerVector(param3.y,_loc11_,this._ga);
         var _loc13_:Boolean = false;
         while(true)
         {
            if(param6)
            {
               if(_loc8_.x0 > this._map.bound.width)
               {
                  _loc12_ = this.getPower(param1,_loc12_,param3,param4,param5,param6,param7);
                  break;
               }
               if(_loc9_.x0 > this._map.bound.height)
               {
                  _loc12_ = this.getPower(_loc12_,param2,param3,param4,param5,param6,param7);
                  break;
               }
               if(_loc8_.x0 < this._map.bound.x)
               {
                  return int(2100);
               }
            }
            else
            {
               if(_loc8_.x0 < this._map.bound.x)
               {
                  _loc12_ = this.getPower(param1,_loc12_,param3,param4,param5,param6,param7);
                  break;
               }
               if(_loc9_.x0 > this._map.bound.height)
               {
                  _loc12_ = this.getPower(_loc12_,param2,param3,param4,param5,param6,param7);
                  break;
               }
               if(_loc8_.x0 > this._map.bound.width)
               {
                  return int(2100);
               }
            }
            if(this.ifHit(_loc8_.x0,_loc9_.x0,param4))
            {
               return _loc12_;
            }
            _loc8_.ComputeOneEulerStep(this._mass,this._arf,this._mapWind,this._dt);
            _loc9_.ComputeOneEulerStep(this._mass,this._arf,this._gf,this._dt);
            if(param6 && param7)
            {
               if(_loc9_.x0 > param4.y)
               {
                  if(_loc8_.x0 < param4.x)
                  {
                     _loc12_ = this.getPower(_loc12_,param2,param3,param4,param5,param6,param7);
                  }
                  else
                  {
                     _loc12_ = this.getPower(param1,_loc12_,param3,param4,param5,param6,param7);
                  }
                  break;
               }
            }
            else if(param6 && !param7)
            {
               if(!_loc13_)
               {
                  if(_loc8_.x0 > param4.x)
                  {
                     _loc12_ = this.getPower(_loc12_,param2,param3,param4,param5,param6,param7);
                     break;
                  }
                  if(_loc9_.x0 < param4.y)
                  {
                     _loc13_ = true;
                  }
               }
               else if(_loc13_)
               {
                  if(_loc9_.x0 > param4.y)
                  {
                     if(_loc8_.x0 < param4.x)
                     {
                        _loc12_ = this.getPower(_loc12_,param2,param3,param4,param5,param6,param7);
                     }
                     else
                     {
                        _loc12_ = this.getPower(param1,_loc12_,param3,param4,param5,param6,param7);
                     }
                     break;
                  }
               }
            }
            else if(!param6 && !param7)
            {
               if(!_loc13_)
               {
                  if(_loc8_.x0 < param4.x)
                  {
                     _loc12_ = this.getPower(_loc12_,param2,param3,param4,param5,param6,param7);
                     break;
                  }
                  if(_loc9_.x0 < param4.y)
                  {
                     _loc13_ = true;
                  }
               }
               else if(_loc13_)
               {
                  if(_loc9_.x0 > param4.y)
                  {
                     if(_loc8_.x0 > param4.x)
                     {
                        _loc12_ = this.getPower(_loc12_,param2,param3,param4,param5,param6,param7);
                     }
                     else
                     {
                        _loc12_ = this.getPower(param1,_loc12_,param3,param4,param5,param6,param7);
                     }
                     break;
                  }
               }
            }
            else if(!param6 && param7)
            {
               if(_loc9_.x0 > param4.y)
               {
                  if(_loc8_.x0 > param4.x)
                  {
                     _loc12_ = this.getPower(_loc12_,param2,param3,param4,param5,param6,param7);
                  }
                  else
                  {
                     _loc12_ = this.getPower(param1,_loc12_,param3,param4,param5,param6,param7);
                  }
                  break;
               }
            }
         }
         return _loc12_;
      }
      
      protected function ifHit(param1:Number, param2:Number, param3:Point) : Boolean
      {
         if(param1 > param3.x - 15 && param1 < param3.x + 20 && param2 > param3.y - 20 && param2 < param3.y + 30)
         {
            return true;
         }
         return false;
      }
      
      private function isOutOfMap(param1:EulerVector, param2:EulerVector) : Boolean
      {
         if(param1.x0 < this._map.bound.x || param1.x0 > this._map.bound.width || param2.x0 > this._map.bound.height)
         {
            return true;
         }
         return false;
      }
      
      private function drawRouteLine(param1:int) : void
      {
         var _loc2_:Living = null;
         this._drawRoute.graphics.clear();
         for each(_loc2_ in this._allLivings)
         {
            _loc2_.currentSelectId = param1;
         }
         if(param1 < 0)
         {
            return;
         }
         var _loc3_:Player = GameManager.Instance.Current.findPlayer(param1);
         if(!_loc3_)
         {
            return;
         }
         var _loc4_:Vector.<Point> = _loc3_.route;
         if(!_loc4_ || _loc4_.length == 0)
         {
            return;
         }
         var _loc5_:GamePlayer = this._map.getPhysical(param1) as GamePlayer;
         this._collideRect.x = _loc5_.pos.x - 50;
         this._collideRect.y = _loc5_.pos.y - 50;
         this._drawRoute.graphics.lineStyle(2,16711680,0.5);
         var _loc6_:int = _loc4_.length;
         var _loc7_:int = 0;
         while(_loc7_ < _loc6_ - 1)
         {
            this.drawDashed(this._drawRoute.graphics,_loc4_[_loc7_],_loc4_[_loc7_ + 1],8,5);
            _loc7_++;
         }
      }
      
      private function getRouteData(param1:Number, param2:Number, param3:Point, param4:Point) : Vector.<Point>
      {
         var _loc5_:EulerVector = null;
         var _loc6_:EulerVector = null;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         if(param1 > 2000)
         {
            return null;
         }
         _loc7_ = param1 * Math.cos(param2 / 180 * Math.PI);
         _loc5_ = new EulerVector(param3.x,_loc7_,this._wa);
         _loc8_ = param1 * Math.sin(param2 / 180 * Math.PI);
         _loc6_ = new EulerVector(param3.y,_loc8_,this._ga);
         var _loc9_:Vector.<Point> = new Vector.<Point>();
         _loc9_.push(new Point(param3.x,param3.y));
         while(true)
         {
            if(this.isOutOfMap(_loc5_,_loc6_))
            {
               return _loc9_;
            }
            if(this.ifHit(_loc5_.x0,_loc6_.x0,param4))
            {
               return _loc9_;
            }
            _loc5_.ComputeOneEulerStep(this._mass,this._arf,this._mapWind,this._dt);
            _loc6_.ComputeOneEulerStep(this._mass,this._arf,this._gf,this._dt);
            _loc9_.push(new Point(_loc5_.x0,_loc6_.x0));
         }
         return _loc9_;
      }
      
      public function drawDashed(param1:Graphics, param2:Point, param3:Point, param4:Number, param5:Number) : void
      {
         var _loc11_:Number = NaN;
         var _loc12_:Number = NaN;
         if(!param1 || !param2 || !param3 || param4 <= 0 || param5 <= 0)
         {
            return;
         }
         var _loc6_:Number = param2.x;
         var _loc7_:Number = param2.y;
         var _loc8_:Number = Math.atan2(param3.y - _loc7_,param3.x - _loc6_);
         var _loc9_:Number = Point.distance(param2,param3);
         var _loc10_:Number = 0;
         while(_loc10_ <= _loc9_)
         {
            if(this._collideRect.contains(_loc11_,_loc12_))
            {
               return;
            }
            _loc11_ = _loc6_ + Math.cos(_loc8_) * _loc10_;
            _loc12_ = _loc7_ + Math.sin(_loc8_) * _loc10_;
            param1.moveTo(_loc11_,_loc12_);
            _loc10_ += param4;
            if(_loc10_ > _loc9_)
            {
               _loc10_ = _loc9_;
            }
            _loc11_ = _loc6_ + Math.cos(_loc8_) * _loc10_;
            _loc12_ = _loc7_ + Math.sin(_loc8_) * _loc10_;
            param1.lineTo(_loc11_,_loc12_);
            _loc10_ += param5;
         }
      }
      
      private function drawArrow(param1:Graphics, param2:Point, param3:Point, param4:Number, param5:int) : void
      {
         var _loc7_:Number = NaN;
         var _loc8_:Number = NaN;
         if(!param2 || !param3 || !param4 || param5 <= 0)
         {
            return;
         }
         var _loc6_:Number = Math.atan2(param3.y - param2.y,param3.x - param2.x);
         param4 = param4 * Math.PI / 180;
         param1.moveTo(param3.x,param3.y);
         _loc7_ = param3.x + Math.cos(_loc6_ + param4) * param5;
         _loc8_ = param3.y + Math.sin(_loc6_ + param4) * param5;
         param1.lineTo(_loc7_,_loc8_);
         param1.moveTo(param3.x,param3.y);
         _loc7_ = param3.x + Math.cos(_loc6_ - param4) * param5;
         _loc8_ = param3.y + Math.sin(_loc6_ - param4) * param5;
         param1.lineTo(_loc7_,_loc8_);
      }
      
      private function __playerChange(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:Living = null;
         this._drawRoute.graphics.clear();
         this._useAble = false;
         this.currentLivID = -1;
         for each(_loc2_ in this._allLivings)
         {
            _loc2_.state = false;
         }
      }
      
      private function __playerExit(param1:Event) : void
      {
         if(this._useAble)
         {
            this.currentLivID = this.calculateRecent();
         }
      }
      
      protected function __changeAngle(param1:LivingEvent) : void
      {
         if(this._useAble)
         {
            this.showShoot();
         }
      }
      
      protected function __wishofdd(param1:CrazyTankSocketEvent) : void
      {
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         var _loc2_:Boolean = param1.pkg.readBoolean();
         if(_loc2_)
         {
            _loc3_ = param1.pkg.readInt();
            this._mapWind = _loc3_ / 10 * this._windFactor;
            this._useAble = true;
            this.showShoot();
         }
         else
         {
            _loc4_ = param1.pkg.readInt();
            this._useAble = false;
         }
      }
      
      private function __thumbnailControlHandle(param1:GameEvent) : void
      {
         this.currentLivID = param1.data as int;
      }
      
      private function calculateRecent() : int
      {
         var _loc3_:Living = null;
         var _loc4_:Vector.<Point> = null;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc1_:int = int.MAX_VALUE;
         var _loc2_:int = -1;
         for each(_loc3_ in this._allLivings)
         {
            if(_loc3_.route && !(_loc3_ is SmallEnemy))
            {
               _loc4_ = _loc3_.route;
               _loc5_ = _loc4_.length;
               if(_loc5_ >= 2)
               {
                  _loc6_ = this.getDistance(_loc4_[0],_loc4_[_loc5_ - 1]);
                  if(_loc6_ < _loc1_)
                  {
                     _loc1_ = _loc6_;
                     _loc2_ = _loc3_.LivingID;
                  }
               }
            }
         }
         return _loc2_;
      }
      
      private function getDistance(param1:Point, param2:Point) : int
      {
         return (param2.x - param1.x) * (param2.x - param1.x) + (param2.y - param1.y) * (param2.y - param1.y);
      }
      
      private function __moveMouseState(param1:LivingEvent) : void
      {
         this._mouseStateView.setPos();
      }
      
      private function __playerTurnLeft(param1:GameEvent) : void
      {
         if(this._gameInfo.selfGamePlayer.direction == 1)
         {
            this._mouseStateView.turnLeft();
         }
         this.__changeMouseStateAngle(null);
      }
      
      private function __playerTurnRight(param1:GameEvent) : void
      {
         if(this._gameInfo.selfGamePlayer.direction == -1)
         {
            this._mouseStateView.turnRight();
         }
         this.__changeMouseStateAngle(null);
      }
      
      private function __changeMouseStateAngle(param1:GameEvent) : void
      {
         this._mouseStateView.changeDegree();
      }
      
      private function __changeForce(param1:LivingEvent) : void
      {
         this._mouseStateView.changeForce();
      }
      
      private function __changeGunAngle(param1:LivingEvent) : void
      {
         this._mouseStateView.changeDegree();
      }
      
      private function __changePlayerAngle(param1:LivingEvent) : void
      {
         this._mouseStateView.setPos();
         this._mouseStateView.changeDegree();
      }
      
      protected function __attackingChanged(param1:LivingEvent) : void
      {
         this._mouseStateView.attactionChange();
         this._mouseStateView.hide();
         if(this._selfGamePlayer)
         {
            if(this._gameInfo.selfGamePlayer.isLiving && this._gameInfo.selfGamePlayer.isAttacking)
            {
               if(this._gameInfo.selfGamePlayer.mouseState)
               {
                  setTimeout(this.mouseStateSetPos,100);
               }
               else
               {
                  this._mouseStateView.hide();
               }
            }
         }
      }
      
      private function mouseStateSetPos() : void
      {
         this._mouseStateView.setPos();
         this._mouseStateView.show();
         this._mouseStateView.setLastAngleAndForce();
         if(SavePointManager.Instance.isInSavePoint(4))
         {
            this._hasShowMouseGuilde = true;
            this._mouseStateView.showLead();
         }
      }
      
      private function __bossUseSkill(param1:GameEvent) : void
      {
         if(this._gameInfo.selfGamePlayer.mouseState)
         {
            this._mouseStateView.show();
            this._mouseStateView.setPos();
            this._mouseStateView.setLastAngleAndForce();
         }
         else
         {
            this._mouseStateView.hide();
         }
      }
      
      private function __mouseModelDown(param1:GameEvent) : void
      {
         this._selfMarkBar.visible = false;
      }
   }
}
