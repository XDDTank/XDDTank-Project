package roomLoading.view
{
   import SingleDungeon.SingleDungeonManager;
   import bagAndInfo.cell.BaseCell;
   import com.greensock.TweenLite;
   import com.greensock.TweenMax;
   import com.pickgliss.loader.BaseLoader;
   import com.pickgliss.loader.LoadResourceManager;
   import com.pickgliss.loader.ModuleLoader;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.Image;
   import com.pickgliss.ui.image.ScaleFrameImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.ui.text.GradientText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.BallInfo;
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.loader.MapLoader;
   import ddt.loader.TrainerLoader;
   import ddt.manager.BallManager;
   import ddt.manager.GameInSocketOut;
   import ddt.manager.ItemManager;
   import ddt.manager.LoadBombManager;
   import ddt.manager.MapManager;
   import ddt.manager.PathManager;
   import ddt.manager.PetSkillManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.StateManager;
   import ddt.manager.TimeManager;
   import ddt.states.StateType;
   import ddt.utils.PositionUtils;
   import ddt.view.common.LevelIcon;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.TimerEvent;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.utils.Timer;
   import game.model.GameInfo;
   import game.model.GameModeType;
   import game.model.Player;
   import im.IMController;
   import pet.date.PetInfo;
   import pet.date.PetSkillInfo;
   import room.RoomManager;
   import room.model.RoomInfo;
   import room.model.RoomPlayer;
   import vip.VipController;
   import worldboss.WorldBossManager;
   
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
      
      public function RoomLoadingView(param1:GameInfo)
      {
         super();
         this._gameInfo = param1;
         this.init();
      }
      
      private function init() : void
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
         this._versus = ComponentFactory.Instance.creatCustomObject("roomLoading.VersusItem",[RoomManager.Instance.current.gameMode]);
         this._versus.addEventListener(Event.COMPLETE,this.__moveCountDownTxt);
         this._battleField = ComponentFactory.Instance.creatCustomObject("roomLoading.BattleFieldItem",[this._gameInfo.mapIndex]);
         this._viewerItem = ComponentFactory.Instance.creatCustomObject("roomLoading.ViewerItem");
         if(this._gameInfo.gameMode == GameModeType.SIMPLE_DUNGOEN || this._gameInfo.gameMode == 8 || this._gameInfo.gameMode == 10 || this._gameInfo.gameMode == 17 || this._gameInfo.gameMode == GameModeType.SINGLE_DUNGOEN || this._gameInfo.gameMode == GameModeType.MULTI_DUNGEON)
         {
            this._dungeonMapItem = ComponentFactory.Instance.creatCustomObject("roomLoading.DungeonMapItem");
            this._blueTeamBg.visible = false;
         }
         this._selfFinish = false;
         addChild(this._bg);
         addChild(this._redTeamBg);
         addChild(this._blueTeamBg);
         addChild(this._versus);
         addChild(this._countDownTxt);
         addChild(this._battleField);
         addChild(this._viewerItem);
         this.initLoadingItems();
         if(this._dungeonMapItem)
         {
            addChild(this._dungeonMapItem);
         }
         var _loc1_:int = RoomManager.Instance.current.type == RoomInfo.DUNGEON_ROOM ? int(94) : int(64);
         this._countDownTimer = new Timer(1000,_loc1_);
         this._countDownTimer.addEventListener(TimerEvent.TIMER,this.__countDownTick);
         this._countDownTimer.addEventListener(TimerEvent.TIMER_COMPLETE,this.__countDownComplete);
         this._countDownTimer.start();
         StateManager.currentStateType = StateType.GAME_LOADING;
      }
      
      private function __moveCountDownTxt(param1:Event) : void
      {
         TweenLite.to(this._countDownTxt,0.1,{
            "x":322,
            "y":267
         });
      }
      
      private function initLoadingItems() : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:RoomPlayer = null;
         var _loc7_:RoomPlayer = null;
         var _loc9_:RoomPlayer = null;
         var _loc10_:RoomLoadingCharacterItem = null;
         var _loc11_:RoomLoadingPrgressItem = null;
         var _loc12_:Player = null;
         var _loc13_:PetInfo = null;
         var _loc14_:int = 0;
         var _loc15_:PetSkillInfo = null;
         var _loc16_:BallInfo = null;
         var _loc1_:int = this._gameInfo.roomPlayers.length;
         var _loc4_:Array = this._gameInfo.roomPlayers;
         LoadBombManager.Instance.loadFullWeaponBombBitMap(_loc4_);
         for each(_loc6_ in _loc4_)
         {
            if(PlayerManager.Instance.Self.ID == _loc6_.playerInfo.ID)
            {
               _loc5_ = _loc6_.team;
            }
         }
         for each(_loc7_ in _loc4_)
         {
            if(!_loc7_.isViewer)
            {
               if(_loc7_.team == RoomPlayer.BLUE_TEAM)
               {
                  _loc2_++;
               }
               else
               {
                  _loc3_++;
               }
               if(_loc7_.team == _loc5_ && PlayerManager.Instance.Self.ID != _loc6_.playerInfo.ID)
               {
                  IMController.Instance.saveRecentContactsID(_loc7_.playerInfo.ID);
               }
            }
         }
         if(this._gameInfo.gameMode != GameModeType.SIMPLE_DUNGOEN && this._gameInfo.gameMode != 2 && this._gameInfo.gameMode != GameModeType.MULTI_DUNGEON)
         {
            if(_loc2_ + _loc3_ <= 2)
            {
               this._vsType = 1;
               this._redVsType = 1;
               this._blueVsType = 1;
               this._redTeamBg.setFrame(1);
               this._blueTeamBg.setFrame(1);
            }
            else if(_loc2_ + _loc3_ <= 4)
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
            }
         }
         else if(this._gameInfo.gameMode == 2)
         {
            if((_loc3_ + _loc2_) % 2 != 1)
            {
               if(_loc3_ == 1 && _loc2_ == 3)
               {
                  this._vsType = 3;
                  this._redVsType = 1;
                  this._blueVsType = 3;
                  this._redTeamBg.setFrame(3);
                  this._blueTeamBg.setFrame(1);
               }
               else if(_loc3_ == 3 && _loc2_ == 1)
               {
                  this._vsType = 3;
                  this._redVsType = 3;
                  this._blueVsType = 1;
                  this._redTeamBg.setFrame(1);
                  this._blueTeamBg.setFrame(3);
               }
               else if(_loc3_ == 1)
               {
                  this._vsType = 1;
                  this._redVsType = 1;
                  this._blueVsType = 1;
                  this._redTeamBg.setFrame(1);
                  this._blueTeamBg.setFrame(1);
               }
               else if(_loc3_ == 2)
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
               }
            }
            else if(_loc3_ == 1 && _loc2_ == 2)
            {
               this._vsType = 2;
               this._redVsType = 1;
               this._blueVsType = 2;
               this._redTeamBg.setFrame(2);
               this._blueTeamBg.setFrame(1);
            }
            else if(_loc3_ == 1 && _loc2_ == 3)
            {
               this._vsType = 3;
               this._redVsType = 1;
               this._blueVsType = 3;
               this._redTeamBg.setFrame(3);
               this._blueTeamBg.setFrame(1);
            }
            else if(_loc3_ == 2 && _loc2_ == 1)
            {
               this._vsType = 2;
               this._redVsType = 2;
               this._blueVsType = 1;
               this._redTeamBg.setFrame(1);
               this._blueTeamBg.setFrame(2);
            }
            else if(_loc3_ == 2 && _loc2_ == 3)
            {
               this._vsType = 3;
               this._redVsType = 2;
               this._blueVsType = 3;
               this._redTeamBg.setFrame(3);
               this._blueTeamBg.setFrame(2);
            }
            else if(_loc3_ == 3 && _loc2_ == 1)
            {
               this._vsType = 3;
               this._redVsType = 3;
               this._blueVsType = 1;
               this._redTeamBg.setFrame(1);
               this._blueTeamBg.setFrame(3);
            }
            else if(_loc3_ == 3 && _loc2_ == 2)
            {
               this._vsType = 3;
               this._redVsType = 3;
               this._blueVsType = 2;
               this._redTeamBg.setFrame(2);
               this._blueTeamBg.setFrame(3);
            }
         }
         else if(_loc2_ + _loc3_ == 1)
         {
            this._vsType = 1;
            this._redVsType = 1;
            this._blueVsType = 1;
            this._redTeamBg.setFrame(1);
            this._blueTeamBg.setFrame(1);
         }
         else if(_loc2_ + _loc3_ == 2)
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
         }
         var _loc8_:int = 0;
         while(_loc8_ < _loc1_)
         {
            _loc9_ = this._gameInfo.roomPlayers[_loc8_];
            if(_loc9_.isViewer)
            {
               addChild(this._viewerItem);
            }
            else
            {
               _loc10_ = new RoomLoadingCharacterItem(_loc9_,this._gameInfo,this._vsType);
               _loc11_ = new RoomLoadingPrgressItem(_loc9_,this._gameInfo,this._vsType);
               addChild(_loc11_);
               _loc12_ = this._gameInfo.findLivingByPlayerID(_loc9_.playerInfo.ID,_loc9_.playerInfo.ZoneID);
               this.initCharacter(_loc12_,_loc10_);
               this.initRoomItem(_loc10_,this._vsType,_loc12_,_loc11_);
               _loc11_.addEventListener(RoomLoadingPrgressItem.LOADING_FINISHED,this.__onLoadingFinished);
               _loc13_ = _loc12_.playerInfo.currentPet;
               if(_loc13_)
               {
                  for each(_loc14_ in _loc13_.skills)
                  {
                     if(_loc14_ > 0 && _loc14_ < 1000)
                     {
                        _loc15_ = PetSkillManager.instance.getSkillByID(_loc14_);
                        if(_loc15_.NewBallID != -1)
                        {
                           _loc16_ = BallManager.findBall(_loc15_.NewBallID);
                           _loc16_.loadCraterBitmap();
                        }
                     }
                  }
               }
            }
            _loc8_++;
         }
         if(this.blueBig)
         {
            addChild(this.blueBig);
         }
         if(this.redBig)
         {
            addChild(this.redBig);
         }
         this._gameInfo.loaderMap = new MapLoader(MapManager.getMapInfo(this._gameInfo.mapIndex));
         this._gameInfo.loaderMap.load();
         switch(SingleDungeonManager.Instance.currentMapId)
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
         }
         if(this._trainerLoad)
         {
            this._trainerLoad.load();
         }
         this.loadMagicSoul();
      }
      
      private function loadMagicSoul() : void
      {
         if(!ModuleLoader.hasDefinition("asset.game.dropEffect.magicSoul"))
         {
            LoadResourceManager.instance.startLoad(LoadResourceManager.instance.createLoader(PathManager.solveMagicSoul(),BaseLoader.MODULE_LOADER));
         }
      }
      
      protected function __onLoadingFinished(param1:Event) : void
      {
         ++this._amountOfFinishedPlayer;
         if(this._amountOfFinishedPlayer == this._characterItems.length)
         {
            this.leave();
         }
      }
      
      private function __timerComplete(param1:TimerEvent) : void
      {
         if(this._timer)
         {
            this._timer.stop();
            this._timer.removeEventListener(TimerEvent.TIMER_COMPLETE,this.__timerComplete);
            this._timer = null;
            this.leave();
         }
      }
      
      private function initCharacter(param1:Player, param2:RoomLoadingCharacterItem) : void
      {
         var _loc3_:Rectangle = ComponentFactory.Instance.creatCustomObject("asset.roomloading.BigCharacterSize");
         var _loc4_:Rectangle = ComponentFactory.Instance.creatCustomObject("asset.roomloading.SuitCharacterSize");
         param1.movie = param2.info.movie;
         param1.character = param2.info.character;
         param1.character.showGun = false;
         param1.character.showWing = false;
         if(param2.info.team == RoomPlayer.BLUE_TEAM)
         {
            if(param1.isSelf || this.blueCharacterIndex == 1 && this._gameInfo.selfGamePlayer.team != RoomPlayer.BLUE_TEAM)
            {
               if(param1.playerInfo.getShowSuits())
               {
                  PositionUtils.setPos(param2.displayMc,"asset.roomloading.SuitCharacterBluePos");
                  param1.character.showWithSize(false,-1,_loc4_.width,_loc4_.height);
               }
               else
               {
                  PositionUtils.setPos(param2.displayMc,"asset.roomloading.BigCharacterBluePos");
                  param1.character.showWithSize(false,-1,_loc3_.width,_loc3_.height);
                  if(this._redVsType == 1)
                  {
                     param1.character.scaleX = -1.3;
                     param1.character.scaleY = 1.3;
                  }
                  else if(this._redVsType == 2)
                  {
                     param1.character.scaleX = -1.2;
                     param1.character.scaleY = 1.2;
                  }
                  else
                  {
                     param1.character.scaleX = -1;
                     param1.character.scaleY = 1;
                  }
               }
            }
            else
            {
               PositionUtils.setPos(param2.displayMc,"asset.roomloading.SmallCharacterBluePos");
               param1.character.showWithSize(false,-1,_loc3_.width,_loc3_.height);
               if(this._blueVsType == 1)
               {
                  param1.character.scaleX = -1.3;
                  param1.character.scaleY = 1.3;
               }
               else if(this._blueVsType == 2)
               {
                  param1.character.scaleX = -0.9;
                  param1.character.scaleY = 0.9;
               }
               else
               {
                  param1.character.scaleX = -0.7;
                  param1.character.scaleY = 0.7;
               }
            }
            param2.appear(this.blueCharacterIndex.toString());
            param2.index = this.blueCharacterIndex;
            this.index = this.blueCharacterIndex;
            ++this.blueCharacterIndex;
         }
         else
         {
            if(param1.isSelf || this.redCharacterIndex == 1 && this._gameInfo.selfGamePlayer.team != RoomPlayer.RED_TEAM)
            {
               if(param1.playerInfo.getShowSuits())
               {
                  PositionUtils.setPos(param2.displayMc,"asset.roomloading.SuitCharacterRedPos");
                  param1.character.showWithSize(false,-1,_loc4_.width,_loc4_.height);
               }
               else
               {
                  param1.character.showWithSize(false,-1,_loc3_.width,_loc3_.height);
                  if(this._blueVsType == 1)
                  {
                     param1.character.scaleX = -1.3;
                     param1.character.scaleY = 1.3;
                  }
                  else if(this._blueVsType == 2)
                  {
                     param1.character.scaleX = -1.2;
                     param1.character.scaleY = 1.2;
                  }
                  else
                  {
                     param1.character.scaleX = -1;
                     param1.character.scaleY = 1;
                  }
                  PositionUtils.setPos(param2.displayMc,"asset.roomloading.BigCharacterRedPos");
               }
            }
            else
            {
               param1.character.showWithSize(false,-1,_loc3_.width,_loc3_.height);
               PositionUtils.setPos(param2.displayMc,"asset.roomloading.SmallCharacterRedPos");
               if(this._redVsType == 1)
               {
                  param1.character.scaleX = -1.3;
                  param1.character.scaleY = 1.3;
               }
               else if(this._redVsType == 2)
               {
                  param1.character.scaleX = -0.9;
                  param1.character.scaleY = 0.9;
               }
               else
               {
                  param1.character.scaleX = -0.7;
                  param1.character.scaleY = 0.7;
               }
            }
            param2.appear(this.redCharacterIndex.toString());
            param2.index = this.redCharacterIndex;
            this.index = this.redCharacterIndex;
            ++this.redCharacterIndex;
         }
      }
      
      private function initRoomItem(param1:RoomLoadingCharacterItem, param2:int, param3:Player, param4:RoomLoadingPrgressItem) : void
      {
         var _loc5_:Point = null;
         var _loc9_:RoomPlayer = null;
         if((param3.team == 4 || param3.team == 5) && (this._gameInfo.gameMode == GameModeType.SIMPLE_DUNGOEN || this._gameInfo.gameMode == 8 || this._gameInfo.gameMode == 10 || this._gameInfo.gameMode == 17 || this._gameInfo.gameMode == GameModeType.SINGLE_DUNGOEN || this._gameInfo.gameMode == GameModeType.MULTI_DUNGEON))
         {
            param3.team = 1;
         }
         var _loc6_:String = param3.team == RoomPlayer.BLUE_TEAM ? "blueTeam" : "redTeam";
         var _loc7_:ItemTemplateInfo = ItemManager.Instance.getTemplateById(param3.playerInfo.WeaponID);
         var _loc8_:int = 0;
         while(_loc8_ < this._gameInfo.roomPlayers.length)
         {
            _loc9_ = this._gameInfo.roomPlayers[_loc8_];
            if(_loc9_.isSelf && _loc9_.isViewer)
            {
               this._gameInfo.selfGamePlayer.team = 3;
            }
            _loc8_++;
         }
         if(param1.info.team == RoomPlayer.BLUE_TEAM)
         {
            if(param1.info.isSelf || this.blueIdx == 1 && this._gameInfo.selfGamePlayer.team != RoomPlayer.BLUE_TEAM)
            {
               this._nameTxt = ComponentFactory.Instance.creatComponentByStylename("roomLoading.CharacterItemNameTxt");
               this._nameTxt.text = param3.playerInfo.NickName;
               PositionUtils.setPos(this._nameTxt,"roomLoading.CharacterItem." + _loc6_ + "_" + 1 + "_" + this._blueVsType + ".NamePos");
               if(param3.playerInfo.IsVIP)
               {
                  this._vipName = VipController.instance.getVipNameTxt(this._nameTxt.width,param3.playerInfo.VIPtype);
                  this._vipName.x = this._nameTxt.x;
                  this._vipName.y = this._nameTxt.y;
                  this._vipName.text = this._nameTxt.text;
                  addChild(this._vipName);
               }
               else
               {
                  addChild(this._nameTxt);
               }
               this._levelIcon = new LevelIcon();
               this._levelIcon.setInfo(param3.playerInfo.Grade,param3.playerInfo.Repute,param3.playerInfo.WinCount,param3.playerInfo.TotalCount,param3.playerInfo.FightPower,param3.playerInfo.Offer,true,true,param3.team);
               PositionUtils.setPos(this._levelIcon,"roomLoading.CharacterItem." + _loc6_ + "_" + 1 + "_" + this._blueVsType + ".IconStartPos");
               addChild(this._levelIcon);
               this._weaponcell = new BaseCell(new Sprite(),_loc7_);
               this._weaponcell.setContentSize(58,58);
               this._weaponcell.mouseChildren = false;
               this._weaponcell.mouseEnabled = false;
               PositionUtils.setPos(this._weaponcell,"asset.roomLoadingPlayerItem." + _loc6_ + "_" + 1 + "_" + this._blueVsType + ".smallWeaponPos");
               addChild(this._weaponcell);
               PositionUtils.setPos(param1,"asset.roomLoading.CharacterItemBluePos_1_" + this._blueVsType.toString());
               _loc5_ = ComponentFactory.Instance.creatCustomObject("asset.roomLoading.CharacterItemBlueFromPos_1");
               this.blueBig = param1;
               PositionUtils.setPos(param4.perecentageTxt,"asset.roomLoadingPlayerItem." + _loc6_ + "_" + 1 + "_" + this._blueVsType + ".progressPos");
               PositionUtils.setPos(param4.okTxt,"asset.roomLoadingPlayerItem." + _loc6_ + "_" + 1 + "_" + this._blueVsType + ".okPos");
               if(this._gameInfo.selfGamePlayer.team != RoomPlayer.BLUE_TEAM)
               {
                  ++this.blueIdx;
               }
            }
            else
            {
               if(this.blueIdx == 1)
               {
                  ++this.blueIdx;
               }
               this._nameTxt = ComponentFactory.Instance.creatComponentByStylename("roomLoading.CharacterItemNameTxt");
               this._nameTxt.text = param3.playerInfo.NickName;
               PositionUtils.setPos(this._nameTxt,"roomLoading.CharacterItem." + _loc6_ + "_" + this.blueIdx + "_" + this._blueVsType + ".NamePos");
               if(param3.playerInfo.IsVIP)
               {
                  this._vipName = VipController.instance.getVipNameTxt(this._nameTxt.width,param3.playerInfo.VIPtype);
                  this._vipName.x = this._nameTxt.x;
                  this._vipName.y = this._nameTxt.y;
                  this._vipName.text = this._nameTxt.text;
                  addChild(this._vipName);
               }
               else
               {
                  addChild(this._nameTxt);
               }
               this._levelIcon = new LevelIcon();
               this._levelIcon.setInfo(param3.playerInfo.Grade,param3.playerInfo.Repute,param3.playerInfo.WinCount,param3.playerInfo.TotalCount,param3.playerInfo.FightPower,param3.playerInfo.Offer,true,true,param3.team);
               PositionUtils.setPos(this._levelIcon,"roomLoading.CharacterItem." + _loc6_ + "_" + this.blueIdx + "_" + this._blueVsType + ".IconStartPos");
               addChild(this._levelIcon);
               this._weaponcell = new BaseCell(new Sprite(),_loc7_);
               this._weaponcell.setContentSize(58,58);
               this._weaponcell.mouseChildren = false;
               this._weaponcell.mouseEnabled = false;
               PositionUtils.setPos(this._weaponcell,"asset.roomLoadingPlayerItem." + _loc6_ + "_" + this.blueIdx + "_" + this._blueVsType + ".smallWeaponPos");
               addChild(this._weaponcell);
               PositionUtils.setPos(param1,"asset.roomLoading.CharacterItemBluePos_" + this.blueIdx.toString() + "_" + this._blueVsType.toString());
               PositionUtils.setPos(param4.perecentageTxt,"asset.roomLoadingPlayerItem." + _loc6_ + "_" + this.blueIdx + "_" + this._blueVsType + ".progressPos");
               PositionUtils.setPos(param4.okTxt,"asset.roomLoadingPlayerItem." + _loc6_ + "_" + this.blueIdx + "_" + this._blueVsType + ".okPos");
               _loc5_ = ComponentFactory.Instance.creatCustomObject("asset.roomLoading.CharacterItemBlueFromPos_" + this.blueIdx.toString());
               ++this.blueIdx;
            }
         }
         else if(param1.info.isSelf || this.redIdx == 1 && this._gameInfo.selfGamePlayer.team != RoomPlayer.RED_TEAM)
         {
            this._nameTxt = ComponentFactory.Instance.creatComponentByStylename("roomLoading.CharacterItemNameTxt");
            this._nameTxt.text = param3.playerInfo.NickName;
            PositionUtils.setPos(this._nameTxt,"roomLoading.CharacterItem." + _loc6_ + "_" + 1 + "_" + this._redVsType + ".NamePos");
            if(param3.playerInfo.IsVIP)
            {
               this._vipName = VipController.instance.getVipNameTxt(this._nameTxt.width,param3.playerInfo.VIPtype);
               this._vipName.x = this._nameTxt.x;
               this._vipName.y = this._nameTxt.y;
               this._vipName.text = this._nameTxt.text;
               addChild(this._vipName);
            }
            else
            {
               addChild(this._nameTxt);
            }
            this._levelIcon = new LevelIcon();
            this._levelIcon.setInfo(param3.playerInfo.Grade,param3.playerInfo.Repute,param3.playerInfo.WinCount,param3.playerInfo.TotalCount,param3.playerInfo.FightPower,param3.playerInfo.Offer,true,true,param3.team);
            PositionUtils.setPos(this._levelIcon,"roomLoading.CharacterItem." + _loc6_ + "_" + 1 + "_" + this._redVsType + ".IconStartPos");
            addChild(this._levelIcon);
            this._weaponcell = new BaseCell(new Sprite(),_loc7_);
            this._weaponcell.setContentSize(58,58);
            this._weaponcell.mouseChildren = false;
            this._weaponcell.mouseEnabled = false;
            PositionUtils.setPos(this._weaponcell,"asset.roomLoadingPlayerItem." + _loc6_ + "_" + 1 + "_" + this._redVsType + ".smallWeaponPos");
            addChild(this._weaponcell);
            PositionUtils.setPos(param1,"asset.roomLoading.CharacterItemRedPos_1_" + this._redVsType.toString());
            PositionUtils.setPos(param4.perecentageTxt,"asset.roomLoadingPlayerItem." + _loc6_ + "_" + 1 + "_" + this._redVsType + ".progressPos");
            PositionUtils.setPos(param4.okTxt,"asset.roomLoadingPlayerItem." + _loc6_ + "_" + 1 + "_" + this._redVsType + ".okPos");
            _loc5_ = ComponentFactory.Instance.creatCustomObject("asset.roomLoading.CharacterItemRedFromPos_1");
            this.redBig = param1;
            if(this._gameInfo.selfGamePlayer.team != RoomPlayer.RED_TEAM)
            {
               ++this.redIdx;
            }
         }
         else
         {
            if(this.redIdx == 1)
            {
               ++this.redIdx;
            }
            this._nameTxt = ComponentFactory.Instance.creatComponentByStylename("roomLoading.CharacterItemNameTxt");
            this._nameTxt.text = param3.playerInfo.NickName;
            PositionUtils.setPos(this._nameTxt,"roomLoading.CharacterItem." + _loc6_ + "_" + this.redIdx + "_" + this._redVsType + ".NamePos");
            if(param3.playerInfo.IsVIP)
            {
               this._vipName = VipController.instance.getVipNameTxt(this._nameTxt.width,param3.playerInfo.VIPtype);
               this._vipName.x = this._nameTxt.x;
               this._vipName.y = this._nameTxt.y;
               this._vipName.text = this._nameTxt.text;
               addChild(this._vipName);
            }
            else
            {
               addChild(this._nameTxt);
            }
            this._levelIcon = new LevelIcon();
            this._levelIcon.setInfo(param3.playerInfo.Grade,param3.playerInfo.Repute,param3.playerInfo.WinCount,param3.playerInfo.TotalCount,param3.playerInfo.FightPower,param3.playerInfo.Offer,true,true,param3.team);
            PositionUtils.setPos(this._levelIcon,"roomLoading.CharacterItem." + _loc6_ + "_" + this.redIdx + "_" + this._redVsType + ".IconStartPos");
            addChild(this._levelIcon);
            this._weaponcell = new BaseCell(new Sprite(),_loc7_);
            this._weaponcell.setContentSize(58,58);
            this._weaponcell.mouseChildren = false;
            this._weaponcell.mouseEnabled = false;
            PositionUtils.setPos(this._weaponcell,"asset.roomLoadingPlayerItem." + _loc6_ + "_" + this.redIdx + "_" + this._redVsType + ".smallWeaponPos");
            addChild(this._weaponcell);
            PositionUtils.setPos(param1,"asset.roomLoading.CharacterItemRedPos_" + this.redIdx.toString() + "_" + this._redVsType.toString());
            PositionUtils.setPos(param4.perecentageTxt,"asset.roomLoadingPlayerItem." + _loc6_ + "_" + this.redIdx + "_" + this._redVsType + ".progressPos");
            PositionUtils.setPos(param4.okTxt,"asset.roomLoadingPlayerItem." + _loc6_ + "_" + this.redIdx + "_" + this._redVsType + ".okPos");
            _loc5_ = ComponentFactory.Instance.creatCustomObject("asset.roomLoading.CharacterItemRedFromPos_" + this.redIdx.toString());
            ++this.redIdx;
         }
         this._characterItems.push(param1);
         this._prgressItem.push(param4);
         addChild(param1);
      }
      
      private function leave() : void
      {
         var _loc1_:int = 0;
         if(!this._leaving)
         {
            _loc1_ = 0;
            while(_loc1_ < this._characterItems.length)
            {
               if(this._characterItems[_loc1_].info.team != RoomPlayer.RED_TEAM)
               {
                  TweenLite.to(this._characterItems[_loc1_],0.1,{
                     "x":this._characterItems[_loc1_].x - 291,
                     "y":this._characterItems[_loc1_].y
                  });
               }
               else
               {
                  TweenLite.to(this._characterItems[_loc1_],0.1,{
                     "x":this._characterItems[_loc1_].x + 267,
                     "y":this._characterItems[_loc1_].y
                  });
               }
               _loc1_++;
            }
            if(this._dungeonMapItem)
            {
               TweenLite.to(this._dungeonMapItem,0.1,{
                  "x":this._dungeonMapItem.x + 267,
                  "y":this._dungeonMapItem.y
               });
            }
            this._leaving = true;
         }
      }
      
      private function __countDownTick(param1:TimerEvent) : void
      {
         this._selfFinish = this.checkProgress();
         this._countDownTxt.updateNum();
         if(this._selfFinish)
         {
            dispatchEvent(new Event(Event.COMPLETE));
         }
      }
      
      private function __countDownComplete(param1:TimerEvent) : void
      {
         if(!this._selfFinish)
         {
            if(RoomManager.Instance.current.type == RoomInfo.MATCH_ROOM || RoomManager.Instance.current.type == RoomInfo.CHALLENGE_ROOM)
            {
               StateManager.setState(StateType.ROOM_LIST);
            }
            else if(RoomManager.Instance.current.type == RoomInfo.FRESHMAN_ROOM)
            {
               StateManager.setState(StateType.MAIN);
            }
            else if(RoomManager.Instance.current.type == RoomInfo.WORLD_BOSS_FIGHT)
            {
               WorldBossManager.IsSuccessStartGame = false;
               StateManager.setState(StateType.WORLDBOSS_ROOM);
            }
            else if(RoomManager.Instance.current.type == RoomInfo.SINGLE_DUNGEON)
            {
               SingleDungeonManager.Instance.setBossPetNull();
               StateManager.setState(StateType.SINGLEDUNGEON);
            }
            else
            {
               StateManager.setState(StateType.DUNGEON_LIST);
            }
            SocketManager.Instance.out.sendErrorMsg(this._unloadedmsg);
         }
         if(RoomManager.Instance.current && RoomManager.Instance.current.type == RoomInfo.WORLD_BOSS_FIGHT && !WorldBossManager.Instance.isOpen)
         {
            StateManager.setState(StateType.MAIN);
         }
      }
      
      private function checkAnimationIsFinished() : Boolean
      {
         var _loc1_:RoomLoadingCharacterItem = null;
         for each(_loc1_ in this._characterItems)
         {
            if(!_loc1_.isAnimationFinished)
            {
               return false;
            }
         }
         if(this._delayBeginTime <= 0)
         {
            this._delayBeginTime = new Date().time;
         }
         return true;
      }
      
      private function checkProgress() : Boolean
      {
         var _loc3_:RoomPlayer = null;
         var _loc6_:Player = null;
         var _loc7_:PetInfo = null;
         var _loc8_:int = 0;
         var _loc9_:PetSkillInfo = null;
         var _loc10_:BallInfo = null;
         this._unloadedmsg = "";
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         if(!this._gameInfo)
         {
            return false;
         }
         for each(_loc3_ in this._gameInfo.roomPlayers)
         {
            if(!_loc3_.isViewer)
            {
               _loc6_ = this._gameInfo.findLivingByPlayerID(_loc3_.playerInfo.ID,_loc3_.playerInfo.ZoneID);
               if(LoadBombManager.Instance.getLoadBombAssetComplete(_loc3_.currentWeapInfo))
               {
                  _loc2_++;
               }
               else
               {
                  this._unloadedmsg += "LoadBombManager.Instance.getLoadBombAssetComplete(info.currentWeapInfo) false" + "\n";
               }
               _loc1_++;
               _loc7_ = _loc6_.playerInfo.currentPet;
               if(_loc7_)
               {
                  for each(_loc8_ in _loc7_.skills)
                  {
                     if(_loc8_ > 0 && _loc8_ < 1000)
                     {
                        _loc9_ = PetSkillManager.instance.getSkillByID(_loc8_);
                        if(_loc9_.NewBallID != -1)
                        {
                           _loc10_ = BallManager.findBall(_loc9_.NewBallID);
                           if(_loc10_.bombAssetIsComplete())
                           {
                              _loc2_++;
                           }
                           else
                           {
                              this._unloadedmsg += "BallManager.findBall(skill.NewBallID):" + _loc9_.NewBallID + "false\n";
                           }
                           _loc1_++;
                        }
                     }
                  }
               }
            }
         }
         if(this._gameInfo.loaderMap.completed)
         {
            _loc2_++;
         }
         else
         {
            this._unloadedmsg += "_gameInfo.loaderMap.completed false,pic: " + this._gameInfo.loaderMap.info.Pic + "id:" + this._gameInfo.loaderMap.info.ID + "\n";
         }
         _loc1_++;
         if(this._trainerLoad)
         {
            if(this._trainerLoad.completed)
            {
               _loc2_++;
            }
            else
            {
               this._unloadedmsg += "_trainerLoad.completed false\n";
            }
            _loc1_++;
         }
         var _loc4_:Number = int(_loc2_ / _loc1_ * 100);
         var _loc5_:Boolean = _loc1_ == _loc2_;
         GameInSocketOut.sendLoadingProgress(_loc4_);
         RoomManager.Instance.current.selfRoomPlayer.progress = _loc4_;
         return _loc5_;
      }
      
      private function checkIsEnoughDelayTime() : Boolean
      {
         var _loc1_:Number = new Date().time;
         return _loc1_ - this._delayBeginTime >= DELAY_TIME;
      }
      
      public function get index() : int
      {
         return this._index;
      }
      
      public function set index(param1:int) : void
      {
         this._index = param1;
      }
      
      public function dispose() : void
      {
         this._countDownTimer.removeEventListener(TimerEvent.TIMER,this.__countDownTick);
         this._countDownTimer.removeEventListener(TimerEvent.TIMER_COMPLETE,this.__countDownComplete);
         this._countDownTimer.stop();
         this._countDownTimer = null;
         this._versus.removeEventListener(Event.CONNECT,this.__moveCountDownTxt);
         ObjectUtils.disposeObject(this._trainerLoad);
         ObjectUtils.disposeObject(this._bg);
         this._versus.dispose();
         this._countDownTxt.dispose();
         this._battleField.dispose();
         this._viewerItem.dispose();
         var _loc1_:int = 0;
         while(_loc1_ < this._characterItems.length)
         {
            TweenMax.killTweensOf(this._characterItems[_loc1_]);
            this._characterItems[_loc1_].dispose();
            this._characterItems[_loc1_] = null;
            _loc1_++;
         }
         var _loc2_:int = 0;
         while(_loc2_ < this._prgressItem.length)
         {
            this._prgressItem[_loc2_].dispose();
            this._prgressItem[_loc2_] = null;
            _loc2_++;
         }
         if(this._dungeonMapItem)
         {
            ObjectUtils.disposeObject(this._dungeonMapItem);
            this._dungeonMapItem = null;
         }
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
         if(parent)
         {
            parent.removeChild(this);
         }
      }
   }
}
