package game
{
   import SingleDungeon.SingleDungeonManager;
   import com.pickgliss.events.UIModuleEvent;
   import com.pickgliss.loader.UIModuleLoader;
   import ddt.data.BuffInfo;
   import ddt.data.FightBuffInfo;
   import ddt.data.UIModuleTypes;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.data.map.MissionInfo;
   import ddt.data.player.PlayerInfo;
   import ddt.data.player.SelfInfo;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.events.GameEvent;
   import ddt.manager.BuffManager;
   import ddt.manager.ChatManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.PathManager;
   import ddt.manager.PetInfoManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.QueueManager;
   import ddt.manager.SavePointManager;
   import ddt.manager.SocketManager;
   import ddt.manager.StateManager;
   import ddt.states.StateType;
   import ddt.view.UIModuleSmallLoading;
   import ddt.view.chat.ChatData;
   import ddt.view.chat.ChatFormats;
   import ddt.view.chat.ChatInputView;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.geom.Point;
   import flash.utils.Dictionary;
   import flash.utils.Timer;
   import game.model.GameInfo;
   import game.model.GameNeedMovieInfo;
   import game.model.GameNeedPetSkillInfo;
   import game.model.Living;
   import game.model.LocalPlayer;
   import game.model.Pet;
   import game.model.PetLiving;
   import game.model.Player;
   import game.view.DropGoods;
   import game.view.HitsNumView;
   import game.view.effects.BloodNumberCreater;
   import game.view.experience.ExpTweenManager;
   import pet.date.PetInfo;
   import road7th.comm.PackageIn;
   import road7th.data.DictionaryData;
   import room.RoomManager;
   import room.model.RoomInfo;
   import room.model.RoomPlayer;
   
   public class GameManager extends EventDispatcher
   {
      
      public static const START_LOAD:String = "StartLoading";
      
      public static var MinLevelDuplicate:int = 13;
      
      public static const ENTER_MISSION_RESULT:String = "EnterMissionResult";
      
      public static const ENTER_ROOM:String = "EnterRoom";
      
      public static const LEAVE_MISSION:String = "leaveMission";
      
      public static const ENTER_DUNGEON:String = "EnterDungeon";
      
      public static const PLAYER_CLICK_PAY:String = "PlayerClickPay";
      
      public static const MOVE_PROPBAR:String = "Move_propBar";
      
      public static const TASK_GOOD_THREE:uint = 0;
      
      public static const TASK_GOOD_ADDONE:uint = 1;
      
      public static const TASK_GOOD_ADDTWO:uint = 2;
      
      public static const TASK_GOOD_POWMAX:uint = 3;
      
      public static const TASK_GOOD_PLANE:uint = 4;
      
      public static const TASK_GOOD_LEAD:uint = 5;
      
      private static var _instance:GameManager;
      
      public static const MissionGiveup:int = 0;
      
      public static const MissionAgain:int = 1;
      
      public static const MissionTimeout:int = 2;
       
      
      private var _current:GameInfo;
      
      private var _numCreater:BloodNumberCreater;
      
      public var dropGoodslist:Vector.<DropGoods>;
      
      public var dropData:Array;
      
      public var dropGlod:int;
      
      public var isRed:Boolean;
      
      public var hitsNumView:HitsNumView;
      
      private var _hitsNum:int;
      
      public var dropTaskGoodsId:int = -1;
      
      public var dropTaskGoodsNpcId:int = -1;
      
      public var dialogId:int = -1;
      
      public var petReduceList:Array;
      
      public var isLeaving:Boolean;
      
      public var fightRobotChangePlayerID1:int = -1;
      
      public var fightRobotChangePlayerID2:int = -1;
      
      private var _hasRoomLoading:Boolean;
      
      public var TryAgain:int = 0;
      
      private var _recevieLoadSocket:Boolean;
      
      private var _timer:Timer;
      
      private var _MissionOverType:uint = 0;
      
      public var isDieFight:Boolean = false;
      
      public function GameManager()
      {
         this.dropGoodslist = new Vector.<DropGoods>();
         this.dropData = new Array();
         this.petReduceList = new Array();
         super();
      }
      
      public static function isDungeonRoom(param1:GameInfo) : Boolean
      {
         return param1.roomType == RoomInfo.DUNGEON_ROOM || param1.roomType == RoomInfo.SINGLE_DUNGEON || RoomInfo.MULTI_DUNGEON;
      }
      
      public static function isFreshMan(param1:GameInfo) : Boolean
      {
         return param1.roomType == RoomInfo.FRESHMAN_ROOM;
      }
      
      public static function get Instance() : GameManager
      {
         if(_instance == null)
         {
            _instance = new GameManager();
         }
         return _instance;
      }
      
      public function get hasRoomLoading() : Boolean
      {
         return this._hasRoomLoading;
      }
      
      public function get hitsNum() : int
      {
         return this._hitsNum;
      }
      
      public function set hitsNum(param1:int) : void
      {
         this._hitsNum = param1;
         if(this.hitsNumView && this._hitsNum > 0)
         {
            this.hitsNumView.setHitsNum(this._hitsNum);
         }
      }
      
      public function resetHitsNum() : void
      {
         this._hitsNum = 0;
      }
      
      public function setDropData(param1:int, param2:int) : void
      {
         var _loc3_:Boolean = false;
         var _loc5_:Object = null;
         var _loc4_:int = 0;
         while(_loc4_ < this.dropData.length)
         {
            if(this.dropData[_loc4_].itemId == param1)
            {
               this.dropData[_loc4_].count += param2;
               _loc3_ = true;
               break;
            }
            _loc4_++;
         }
         if(!_loc3_)
         {
            _loc5_ = new Object();
            _loc5_.count = param2;
            _loc5_.itemId = param1;
            this.dropData.push(_loc5_);
         }
      }
      
      public function clearDropData() : void
      {
         var _loc1_:int = 0;
         while(_loc1_ < this.dropData.length)
         {
            this.dropData.splice(0);
            _loc1_++;
         }
         this.dropGlod = 0;
      }
      
      public function get Current() : GameInfo
      {
         return this._current;
      }
      
      public function set trainerCurrent(param1:GameInfo) : void
      {
         this._current = param1;
      }
      
      public function setup() : void
      {
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.GAME_CREATE,this.__createGame);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.GAME_START,this.__gameStart);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.GAME_LOAD,this.__beginLoad);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.LOAD,this.__loadprogress);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.GAME_ALL_MISSION_OVER,this.__missionAllOver);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.GAME_TAKE_OUT,this.__takeOut);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.SHOW_CARDS,this.__showAllCard);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.GAME_MISSION_INFO,this.__gameMissionInfo);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.GAME_MISSION_START,this.__gameMissionStart);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.GAME_MISSION_PREPARE,this.__gameMissionPrepare);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.GAME_ROOM_INFO,this.__missionInviteRoomInfo);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.PLAY_INFO_IN_GAME,this.__updatePlayInfoInGame);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.GAME_MISSION_TRY_AGAIN,this.__missionTryAgain);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.LOAD_RESOURCE,this.__loadResource);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.BUFF_OBTAIN,this.__buffObtain);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.BUFF_UPDATE,this.__buffUpdate);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.BOSS_PLAYER_OBJECT,this.__onUpdateBossPlayerThing);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.FIGHTROBOT_CHANGE_PLAYER,this.__fightRobotChangePlayer);
      }
      
      private function __fightRobotChangePlayer(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:PackageIn = param1.pkg;
         this.fightRobotChangePlayerID1 = _loc2_.readInt();
         this.fightRobotChangePlayerID2 = _loc2_.readInt();
      }
      
      private function __onUpdateBossPlayerThing(param1:CrazyTankSocketEvent) : void
      {
         var _loc5_:int = 0;
         var _loc6_:Player = null;
         var _loc7_:PetInfo = null;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         var _loc10_:int = 0;
         var _loc2_:PackageIn = param1.pkg;
         var _loc3_:int = _loc2_.readInt();
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_)
         {
            _loc5_ = _loc2_.readInt();
            _loc6_ = this._current.findPlayer(_loc5_);
            _loc6_.npcID = _loc2_.readInt();
            _loc6_.bossCreateAction = _loc2_.readUTF();
            _loc6_.typeLiving = _loc2_.readByte();
            _loc6_.bossName = _loc2_.readUTF();
            _loc6_.actionMCname = _loc2_.readUTF();
            _loc6_.shootPos = new Point(_loc2_.readInt(),_loc2_.readInt());
            _loc7_ = new PetInfo();
            _loc7_.TemplateID = -1;
            _loc7_.ID = _loc6_.playerInfo.ID;
            _loc7_.Name = "BossPlayer";
            _loc7_.UserID = _loc6_.playerInfo.ID;
            _loc7_.Attack = 0;
            _loc7_.Defence = 0;
            _loc7_.Luck = 0;
            _loc7_.Agility = 0;
            _loc7_.Blood = 0;
            _loc7_.AttackGrow = 0;
            _loc7_.DefenceGrow = 0;
            _loc7_.LuckGrow = 0;
            _loc7_.AgilityGrow = 0;
            _loc7_.BloodGrow = 0;
            _loc7_.Level = 0;
            _loc7_.GP = 0;
            _loc7_.MaxGP = 0;
            _loc7_.Hunger = 0;
            _loc7_.PetHappyStar = 0;
            _loc7_.clearSkills();
            _loc8_ = _loc2_.readInt();
            _loc9_ = 0;
            while(_loc9_ < _loc8_)
            {
               _loc10_ = _loc2_.readInt();
               _loc7_.addSkill(_loc9_,_loc10_);
               _loc9_++;
            }
            if(_loc6_.playerInfo.ID == PlayerManager.Instance.Self.ID)
            {
               PlayerManager.Instance.Self.currentPet = _loc7_;
            }
            else
            {
               _loc6_.playerInfo.currentPet = _loc7_;
            }
            _loc4_++;
         }
      }
      
      private function __missionTryAgain(param1:CrazyTankSocketEvent) : void
      {
         this.TryAgain = param1.pkg.readInt();
         dispatchEvent(new GameEvent(GameEvent.MISSIONAGAIN,this.TryAgain));
      }
      
      public function isSingleDungeonRoom(param1:GameInfo = null) : Boolean
      {
         if(!param1)
         {
            param1 = this.Current;
         }
         return param1.roomType == RoomInfo.SINGLE_DUNGEON;
      }
      
      public function gotoRoomLoading() : void
      {
         if(UIModuleLoader.Instance.checkIsLoaded(UIModuleTypes.DDTROOMLOADING))
         {
            StateManager.setState(StateType.ROOM_LOADING,this.Current);
         }
         else
         {
            UIModuleSmallLoading.Instance.progress = 0;
            UIModuleSmallLoading.Instance.show();
            UIModuleSmallLoading.Instance.addEventListener(Event.CLOSE,this.__onClose);
            UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.__roomListComplete);
            UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.__roomListProgress);
            UIModuleLoader.Instance.addUIModuleImp(UIModuleTypes.DDTROOMLOADING);
         }
      }
      
      private function __onClose(param1:Event) : void
      {
         UIModuleSmallLoading.Instance.hide();
         UIModuleSmallLoading.Instance.removeEventListener(Event.CLOSE,this.__onClose);
         UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.__roomListComplete);
         UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.__roomListProgress);
      }
      
      protected function __roomListComplete(param1:UIModuleEvent) : void
      {
         UIModuleSmallLoading.Instance.removeEventListener(Event.CLOSE,this.__onClose);
         UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.__roomListComplete);
         UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.__roomListProgress);
         this.gotoRoomLoading();
      }
      
      protected function __roomListProgress(param1:UIModuleEvent) : void
      {
         if(param1.module == UIModuleTypes.DDTROOMLOADING)
         {
            UIModuleSmallLoading.Instance.progress = param1.loader.progress * 100;
         }
      }
      
      private function __updatePlayInfoInGame(param1:CrazyTankSocketEvent) : void
      {
         var _loc11_:Player = null;
         var _loc2_:RoomInfo = RoomManager.Instance.current;
         if(_loc2_ == null)
         {
            return;
         }
         var _loc3_:PackageIn = param1.pkg;
         var _loc4_:int = _loc3_.readInt();
         var _loc5_:int = _loc3_.readInt();
         var _loc6_:int = _loc3_.readInt();
         var _loc7_:int = _loc3_.readInt();
         var _loc8_:int = _loc3_.readInt();
         var _loc9_:Boolean = _loc3_.readBoolean();
         var _loc10_:RoomPlayer = RoomManager.Instance.current.findPlayerByID(_loc5_);
         if(_loc4_ != PlayerManager.Instance.Self.ZoneID || _loc10_ == null || this._current == null)
         {
            return;
         }
         if(_loc10_.isSelf)
         {
            _loc11_ = new LocalPlayer(PlayerManager.Instance.Self,_loc7_,_loc6_,_loc8_);
         }
         else
         {
            _loc11_ = new Player(_loc10_.playerInfo,_loc7_,_loc6_,_loc8_);
         }
         _loc11_.isReady = _loc9_;
         _loc11_.isShowReadyMC = this._current.isMultiGame;
         if(_loc11_.movie)
         {
            _loc11_.movie.setDefaultAction(_loc11_.movie.standAction);
         }
         this._current.addRoomPlayer(_loc10_);
         if(_loc10_.isViewer)
         {
            this._current.addGameViewer(_loc11_);
         }
         else
         {
            this._current.addGamePlayer(_loc11_);
         }
         if(_loc10_.isSelf)
         {
            StateManager.setState(StateType.MISSION_ROOM);
         }
      }
      
      private function __missionInviteRoomInfo(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:PackageIn = null;
         var _loc3_:GameInfo = null;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:MissionInfo = null;
         var _loc7_:int = 0;
         var _loc8_:PlayerInfo = null;
         var _loc9_:RoomPlayer = null;
         var _loc10_:Boolean = false;
         var _loc11_:int = 0;
         var _loc12_:String = null;
         var _loc13_:String = null;
         var _loc14_:int = 0;
         var _loc15_:int = 0;
         var _loc16_:int = 0;
         var _loc17_:int = 0;
         var _loc18_:Boolean = false;
         var _loc19_:Player = null;
         if(RoomManager.Instance.current)
         {
            _loc2_ = param1.pkg;
            _loc3_ = new GameInfo();
            _loc3_.mapIndex = _loc2_.readInt();
            _loc3_.roomType = _loc2_.readInt();
            _loc3_.gameMode = _loc2_.readInt();
            _loc3_.timeType = _loc2_.readInt();
            RoomManager.Instance.current.timeType = _loc3_.timeType;
            _loc4_ = _loc2_.readInt();
            _loc5_ = 0;
            while(_loc5_ < _loc4_)
            {
               _loc7_ = _loc2_.readInt();
               _loc8_ = PlayerManager.Instance.findPlayer(_loc7_);
               _loc8_.beginChanges();
               _loc9_ = RoomManager.Instance.current.findPlayerByID(_loc7_);
               if(_loc9_ == null)
               {
                  _loc9_ = new RoomPlayer(_loc8_);
                  _loc8_.ID = _loc7_;
               }
               _loc8_.ZoneID = PlayerManager.Instance.Self.ZoneID;
               _loc8_.NickName = _loc2_.readUTF();
               _loc10_ = _loc2_.readBoolean();
               _loc8_.VIPtype = _loc2_.readByte();
               _loc8_.VIPLevel = _loc2_.readInt();
               _loc8_.Sex = _loc2_.readBoolean();
               _loc8_.Hide = _loc2_.readInt();
               _loc8_.Style = _loc2_.readUTF();
               _loc8_.Colors = _loc2_.readUTF();
               _loc8_.Skin = _loc2_.readUTF();
               _loc8_.Grade = _loc2_.readInt();
               _loc8_.Repute = _loc2_.readInt();
               _loc8_.WeaponID = _loc2_.readInt();
               if(_loc8_.WeaponID > 0)
               {
                  _loc11_ = _loc2_.readInt();
                  _loc12_ = _loc2_.readUTF();
                  _loc13_ = _loc2_.readDateString();
               }
               _loc8_.DeputyWeaponID = _loc2_.readInt();
               _loc8_.ConsortiaID = _loc2_.readInt();
               _loc8_.ConsortiaName = _loc2_.readUTF();
               _loc8_.badgeID = _loc2_.readInt();
               _loc14_ = _loc2_.readInt();
               _loc15_ = _loc2_.readInt();
               _loc8_.DailyLeagueFirst = _loc2_.readBoolean();
               _loc8_.DailyLeagueLastScore = _loc2_.readInt();
               _loc8_.commitChanges();
               _loc9_.team = _loc2_.readInt();
               _loc3_.addRoomPlayer(_loc9_);
               _loc16_ = _loc2_.readInt();
               _loc17_ = _loc2_.readInt();
               _loc18_ = _loc2_.readBoolean();
               if(_loc9_.isSelf)
               {
                  _loc19_ = new LocalPlayer(PlayerManager.Instance.Self,_loc16_,_loc9_.team,_loc17_);
               }
               else
               {
                  _loc19_ = new Player(_loc9_.playerInfo,_loc16_,_loc9_.team,_loc17_);
               }
               _loc19_.isReady = _loc18_;
               _loc19_.isShowReadyMC = _loc3_.isMultiGame;
               _loc19_.currentWeapInfo.refineryLevel = _loc11_;
               if(!_loc10_)
               {
                  _loc3_.addGamePlayer(_loc19_);
               }
               else
               {
                  if(_loc9_.isSelf)
                  {
                     _loc3_.setSelfGamePlayer(_loc19_);
                  }
                  _loc3_.addGameViewer(_loc19_);
               }
               _loc5_++;
            }
            this._current = _loc3_;
            _loc6_ = new MissionInfo();
            _loc6_.name = _loc2_.readUTF();
            _loc6_.pic = _loc2_.readUTF();
            _loc6_.success = _loc2_.readUTF();
            _loc6_.failure = _loc2_.readUTF();
            _loc6_.description = _loc2_.readUTF();
            _loc6_.totalMissiton = _loc2_.readInt();
            _loc6_.missionIndex = _loc2_.readInt();
            _loc6_.nextMissionIndex = _loc6_.missionIndex + 1;
            this._current.missionInfo = _loc6_;
            this._current.hasNextMission = true;
         }
      }
      
      private function __createGame(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:PackageIn = null;
         var _loc3_:GameInfo = null;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:String = null;
         var _loc8_:int = 0;
         var _loc9_:PlayerInfo = null;
         var _loc10_:RoomPlayer = null;
         var _loc11_:String = null;
         var _loc12_:Boolean = false;
         var _loc13_:int = 0;
         var _loc14_:int = 0;
         var _loc15_:int = 0;
         var _loc16_:int = 0;
         var _loc17_:Player = null;
         var _loc18_:Boolean = false;
         var _loc19_:int = 0;
         var _loc20_:String = null;
         var _loc21_:String = null;
         var _loc22_:int = 0;
         var _loc23_:int = 0;
         var _loc24_:PetInfo = null;
         var _loc25_:int = 0;
         var _loc26_:int = 0;
         var _loc27_:int = 0;
         var _loc28_:int = 0;
         if(RoomManager.Instance.current)
         {
            _loc2_ = param1.pkg;
            _loc3_ = new GameInfo();
            _loc3_.roomType = _loc2_.readInt();
            _loc3_.gameMode = _loc2_.readInt();
            _loc3_.timeType = _loc2_.readInt();
            RoomManager.Instance.current.timeType = _loc3_.timeType;
            _loc4_ = _loc2_.readInt();
            _loc5_ = 0;
            while(_loc5_ < _loc4_)
            {
               _loc6_ = _loc2_.readInt();
               _loc7_ = _loc2_.readUTF();
               _loc8_ = _loc2_.readInt();
               _loc9_ = PlayerManager.Instance.findPlayer(_loc8_,_loc6_);
               _loc9_.beginChanges();
               _loc10_ = RoomManager.Instance.current.findPlayerByID(_loc8_,_loc6_);
               if(_loc10_ == null)
               {
                  _loc10_ = new RoomPlayer(_loc9_);
               }
               _loc9_.ID = _loc8_;
               _loc9_.ZoneID = _loc6_;
               _loc11_ = _loc2_.readUTF();
               _loc12_ = _loc2_.readBoolean();
               if(_loc12_ && _loc10_.place < 6)
               {
                  _loc10_.place = 6;
               }
               if(!(_loc10_ is SelfInfo))
               {
                  _loc9_.NickName = _loc11_;
               }
               _loc9_.VIPtype = _loc2_.readByte();
               _loc9_.VIPLevel = _loc2_.readInt();
               _loc9_.isFightVip = _loc2_.readBoolean();
               _loc9_.fightToolBoxSkillNum = _loc2_.readInt();
               if(PlayerManager.Instance.isChangeStyleTemp(_loc9_.ID))
               {
                  _loc2_.readBoolean();
                  _loc2_.readInt();
                  _loc2_.readUTF();
                  _loc2_.readUTF();
                  _loc2_.readUTF();
               }
               else
               {
                  _loc9_.Sex = _loc2_.readBoolean();
                  _loc9_.Hide = _loc2_.readInt();
                  _loc9_.Style = _loc2_.readUTF();
                  _loc9_.Colors = _loc2_.readUTF();
                  _loc9_.Skin = _loc2_.readUTF();
               }
               _loc9_.Grade = _loc2_.readInt();
               _loc9_.Repute = _loc2_.readInt();
               _loc9_.WeaponID = _loc2_.readInt();
               if(_loc9_.WeaponID != 0)
               {
                  _loc19_ = _loc2_.readInt();
                  _loc20_ = _loc2_.readUTF();
                  _loc21_ = _loc2_.readDateString();
               }
               _loc9_.DeputyWeaponID = _loc2_.readInt();
               _loc9_.Nimbus = _loc2_.readInt();
               _loc9_.IsShowConsortia = _loc2_.readBoolean();
               _loc9_.ConsortiaID = _loc2_.readInt();
               _loc9_.ConsortiaName = _loc2_.readUTF();
               _loc9_.badgeID = _loc2_.readInt();
               _loc13_ = _loc2_.readInt();
               _loc14_ = _loc2_.readInt();
               _loc9_.WinCount = _loc2_.readInt();
               _loc9_.TotalCount = _loc2_.readInt();
               _loc9_.FightPower = _loc2_.readInt();
               _loc9_.apprenticeshipState = _loc2_.readInt();
               _loc9_.masterID = _loc2_.readInt();
               _loc9_.setMasterOrApprentices(_loc2_.readUTF());
               _loc9_.AchievementPoint = _loc2_.readInt();
               _loc9_.honor = _loc2_.readUTF();
               _loc9_.Offer = _loc2_.readInt();
               _loc9_.DailyLeagueFirst = _loc2_.readBoolean();
               _loc9_.DailyLeagueLastScore = _loc2_.readInt();
               _loc9_.commitChanges();
               _loc10_.playerInfo.IsMarried = _loc2_.readBoolean();
               if(_loc10_.playerInfo.IsMarried)
               {
                  _loc10_.playerInfo.SpouseID = _loc2_.readInt();
                  _loc10_.playerInfo.SpouseName = _loc2_.readUTF();
               }
               _loc10_.additionInfo.resetAddition();
               _loc10_.additionInfo.GMExperienceAdditionType = Number(_loc2_.readInt() / 100);
               _loc10_.additionInfo.AuncherExperienceAddition = Number(_loc2_.readInt() / 100);
               _loc10_.additionInfo.GMOfferAddition = Number(_loc2_.readInt() / 100);
               _loc10_.additionInfo.AuncherOfferAddition = Number(_loc2_.readInt() / 100);
               _loc10_.additionInfo.GMRichesAddition = Number(_loc2_.readInt() / 100);
               _loc10_.additionInfo.AuncherRichesAddition = Number(_loc2_.readInt() / 100);
               _loc10_.team = _loc2_.readInt();
               _loc3_.addRoomPlayer(_loc10_);
               _loc15_ = _loc2_.readInt();
               _loc16_ = _loc2_.readInt();
               if(_loc10_.isSelf)
               {
                  _loc17_ = new LocalPlayer(PlayerManager.Instance.Self,_loc15_,_loc10_.team,_loc16_);
               }
               else
               {
                  _loc17_ = new Player(_loc10_.playerInfo,_loc15_,_loc10_.team,_loc16_);
               }
               _loc17_.isShowReadyMC = _loc3_.isMultiGame;
               _loc18_ = _loc2_.readBoolean();
               if(_loc18_)
               {
                  _loc22_ = _loc2_.readInt();
                  _loc23_ = _loc2_.readInt();
                  _loc24_ = new PetInfo();
                  _loc24_.TemplateID = _loc23_;
                  PetInfoManager.instance.fillPetInfo(_loc24_);
                  _loc24_.Place = _loc22_;
                  _loc24_.ID = _loc2_.readInt();
                  _loc24_.Name = _loc2_.readUTF();
                  _loc24_.UserID = _loc2_.readInt();
                  _loc24_.Level = _loc2_.readInt();
                  _loc24_.clearSkills();
                  _loc25_ = _loc2_.readInt();
                  _loc26_ = 0;
                  while(_loc26_ < _loc25_)
                  {
                     _loc27_ = _loc2_.readInt();
                     _loc28_ = _loc2_.readInt();
                     _loc24_.addSkill(_loc27_,_loc28_);
                     _loc26_++;
                  }
                  if(!RoomManager.Instance.current || RoomManager.Instance.current.type != RoomInfo.CHANGE_DUNGEON)
                  {
                     _loc9_.currentPet = _loc24_;
                  }
               }
               _loc9_.MilitaryRankTotalScores = _loc2_.readInt();
               _loc17_.zoneName = _loc7_;
               _loc17_.currentWeapInfo.refineryLevel = _loc19_;
               if(!_loc10_.isViewer)
               {
                  _loc3_.addGamePlayer(_loc17_);
               }
               else
               {
                  if(_loc10_.isSelf)
                  {
                     _loc3_.setSelfGamePlayer(_loc17_);
                  }
                  _loc3_.addGameViewer(_loc17_);
               }
               _loc5_++;
            }
            this._current = _loc3_;
            QueueManager.setLifeTime(0);
         }
      }
      
      private function __buffObtain(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:PackageIn = null;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:Boolean = false;
         var _loc7_:Date = null;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         var _loc10_:BuffInfo = null;
         if(this._current)
         {
            _loc2_ = param1.pkg;
            if(_loc2_.extend1 == this._current.selfGamePlayer.LivingID)
            {
               return;
            }
            if(this._current.findPlayer(_loc2_.extend1) != null)
            {
               _loc3_ = _loc2_.readInt();
               _loc4_ = 0;
               while(_loc4_ < _loc3_)
               {
                  _loc5_ = _loc2_.readInt();
                  _loc6_ = _loc2_.readBoolean();
                  _loc7_ = _loc2_.readDate();
                  _loc8_ = _loc2_.readInt();
                  _loc9_ = _loc2_.readInt();
                  _loc10_ = new BuffInfo(_loc5_,_loc6_,_loc7_,_loc8_,_loc9_);
                  this._current.findPlayer(_loc2_.extend1).playerInfo.buffInfo.add(_loc10_.Type,_loc10_);
                  _loc4_++;
               }
               param1.stopImmediatePropagation();
            }
         }
      }
      
      private function __buffUpdate(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:PackageIn = null;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:Boolean = false;
         var _loc6_:Date = null;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:BuffInfo = null;
         if(this._current)
         {
            _loc2_ = param1.pkg;
            if(_loc2_.extend1 == this._current.selfGamePlayer.LivingID)
            {
               return;
            }
            if(this._current.findPlayer(_loc2_.extend1) != null)
            {
               _loc3_ = _loc2_.readInt();
               _loc4_ = _loc2_.readInt();
               _loc5_ = _loc2_.readBoolean();
               _loc6_ = _loc2_.readDate();
               _loc7_ = _loc2_.readInt();
               _loc8_ = _loc2_.readInt();
               _loc9_ = new BuffInfo(_loc4_,_loc5_,_loc6_,_loc7_,_loc8_);
               if(_loc5_)
               {
                  this._current.findPlayer(_loc2_.extend1).playerInfo.buffInfo.add(_loc9_.Type,_loc9_);
               }
               else
               {
                  this._current.findPlayer(_loc2_.extend1).playerInfo.buffInfo.remove(_loc9_.Type);
               }
               param1.stopImmediatePropagation();
            }
         }
      }
      
      private function __beginLoad(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:GameNeedMovieInfo = null;
         var _loc7_:GameNeedPetSkillInfo = null;
         StateManager.getInGame_Step_3 = true;
         this._recevieLoadSocket = true;
         if(this._current)
         {
            StateManager.getInGame_Step_4 = true;
            this._current.maxTime = param1.pkg.readInt();
            this._current.mapIndex = param1.pkg.readInt();
            _loc2_ = param1.pkg.readInt();
            _loc3_ = 1;
            while(_loc3_ <= _loc2_)
            {
               _loc6_ = new GameNeedMovieInfo();
               _loc6_.type = param1.pkg.readInt();
               _loc6_.path = param1.pkg.readUTF();
               _loc6_.classPath = param1.pkg.readUTF();
               this._current.neededMovies.push(_loc6_);
               _loc3_++;
            }
            _loc4_ = param1.pkg.readInt();
            _loc5_ = 0;
            while(_loc5_ < _loc4_)
            {
               _loc7_ = new GameNeedPetSkillInfo();
               _loc7_.pic = param1.pkg.readUTF();
               _loc7_.effect = param1.pkg.readUTF();
               this._current.neededPetSkillResource.push(_loc7_);
               _loc5_++;
            }
         }
         this.checkCanToLoader();
      }
      
      private function checkCanToLoader() : void
      {
         if(this._recevieLoadSocket && (this._current.missionInfo || !this.getRoomTypeNeedMissionInfo(this._current.roomType)))
         {
            dispatchEvent(new Event(START_LOAD));
            StateManager.getInGame_Step_5 = true;
            this._recevieLoadSocket = false;
         }
      }
      
      private function getRoomTypeNeedMissionInfo(param1:int) : Boolean
      {
         return param1 == 2 || param1 == 3 || param1 == 4 || param1 == 5 || param1 == 8 || param1 == 10 || param1 == 11 || param1 == 14;
      }
      
      private function __gameMissionStart(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:PackageIn = param1.pkg;
         var _loc3_:Object = new Object();
         _loc3_.id = _loc2_.clientId;
         var _loc4_:Boolean = _loc2_.readBoolean();
      }
      
      public function dispatchAllGameReadyState(param1:Array) : void
      {
         var _loc2_:CrazyTankSocketEvent = null;
         var _loc3_:PackageIn = null;
         var _loc4_:Object = null;
         var _loc5_:int = 0;
         var _loc6_:Player = null;
         var _loc7_:RoomPlayer = null;
         for each(_loc2_ in param1)
         {
            _loc3_ = _loc2_.pkg;
            _loc4_ = new Object();
            _loc5_ = _loc3_.clientId;
            if(this._current)
            {
               _loc6_ = this._current.findPlayerByPlayerID(_loc5_);
               _loc6_.isReady = _loc3_.readBoolean();
               if(!_loc6_.isSelf && _loc6_.isReady)
               {
                  _loc7_ = RoomManager.Instance.current.findPlayerByID(_loc5_);
                  _loc7_.isReady = true;
               }
            }
            _loc3_.position = SocketManager.PACKAGE_CONTENT_START_INDEX;
         }
      }
      
      private function __gameMissionPrepare(param1:CrazyTankSocketEvent) : void
      {
         if(RoomManager.Instance.current)
         {
            RoomManager.Instance.current.setPlayerReadyState(param1.pkg.clientId,param1.pkg.readBoolean());
         }
      }
      
      private function __gameMissionInfo(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:String = null;
         var _loc3_:MissionInfo = null;
         if(this._current == null)
         {
            return;
         }
         if(!this._current.missionInfo)
         {
            _loc3_ = this._current.missionInfo = new MissionInfo();
         }
         else
         {
            _loc3_ = this._current.missionInfo;
         }
         _loc3_.name = param1.pkg.readUTF();
         _loc3_.success = param1.pkg.readUTF();
         _loc3_.failure = param1.pkg.readUTF();
         _loc3_.description = param1.pkg.readUTF();
         _loc2_ = param1.pkg.readUTF();
         _loc3_.totalMissiton = param1.pkg.readInt();
         _loc3_.missionIndex = param1.pkg.readInt();
         _loc3_.totalValue1 = param1.pkg.readInt();
         _loc3_.totalValue2 = param1.pkg.readInt();
         _loc3_.totalValue3 = param1.pkg.readInt();
         _loc3_.totalValue4 = param1.pkg.readInt();
         _loc3_.nextMissionIndex = _loc3_.missionIndex + 1;
         _loc3_.parseString(_loc2_);
         _loc3_.tryagain = param1.pkg.readInt();
         RoomManager.Instance.current.pic = param1.pkg.readUTF();
         this.checkCanToLoader();
      }
      
      private function __loadprogress(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:RoomPlayer = null;
         if(this._current)
         {
            _loc2_ = param1.pkg.readInt();
            _loc3_ = param1.pkg.readInt();
            _loc4_ = param1.pkg.readInt();
            _loc5_ = this._current.findRoomPlayer(_loc4_,_loc3_);
            if(_loc5_ && !_loc5_.isSelf)
            {
               _loc5_.progress = _loc2_;
            }
         }
      }
      
      private function __gameStart(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:PackageIn = null;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:Player = null;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         var _loc10_:int = 0;
         var _loc11_:FightBuffInfo = null;
         var _loc12_:int = 0;
         this.TryAgain = -1;
         ExpTweenManager.Instance.deleteTweens();
         if(this._current)
         {
            param1.executed = false;
            _loc2_ = param1.pkg;
            _loc3_ = _loc2_.readInt();
            _loc4_ = 1;
            while(_loc4_ <= _loc3_)
            {
               _loc5_ = _loc2_.readInt();
               _loc6_ = this._current.findPlayer(_loc5_);
               if(_loc6_ != null)
               {
                  _loc6_.reset();
                  _loc6_.pos = new Point(_loc2_.readInt(),_loc2_.readInt());
                  _loc6_.energy = 1;
                  _loc6_.direction = _loc2_.readInt();
                  _loc7_ = _loc2_.readInt();
                  _loc6_.team = _loc2_.readInt();
                  _loc8_ = _loc2_.readInt();
                  _loc6_.powerRatio = _loc2_.readInt();
                  _loc6_.dander = _loc2_.readInt();
                  _loc6_.maxBlood = _loc7_;
                  _loc6_.updateBlood(_loc7_,0,0);
                  _loc6_.wishKingCount = _loc2_.readInt();
                  _loc6_.wishKingEnergy = _loc2_.readInt();
                  _loc6_.currentWeapInfo.refineryLevel = _loc8_;
                  _loc9_ = _loc2_.readInt();
                  _loc10_ = 0;
                  while(_loc10_ < _loc9_)
                  {
                     _loc11_ = BuffManager.creatBuff(_loc2_.readInt());
                     _loc12_ = _loc2_.readInt();
                     if(_loc12_ >= 0)
                     {
                        if(_loc11_)
                        {
                           _loc11_.data = _loc12_;
                           _loc6_.addBuff(_loc11_);
                        }
                     }
                     _loc10_++;
                  }
                  if(RoomManager.Instance.current.type != 5 && _loc6_.playerInfo.currentPet)
                  {
                     _loc6_.currentPet = new Pet(_loc6_.playerInfo.currentPet);
                     _loc6_.petLiving = new PetLiving(_loc6_.playerInfo.currentPet,_loc6_,-1,_loc6_.team,100000);
                     _loc6_.petLiving.pos = new Point(_loc6_.pos.x,_loc6_.pos.y);
                  }
               }
               _loc4_++;
            }
            if(_loc3_ == 0)
            {
               if(RoomManager.Instance.current.type == RoomInfo.DUNGEON_ROOM || RoomManager.Instance.current.type == RoomInfo.MULTI_DUNGEON)
               {
                  StateManager.setState(StateType.DUNGEON_LIST);
               }
               else if(RoomManager.Instance.current.type == RoomInfo.SINGLE_DUNGEON)
               {
                  StateManager.setState(StateType.SINGLEDUNGEON);
               }
               else
               {
                  StateManager.setState(StateType.ROOM_LIST);
               }
            }
            else if(RoomManager.Instance.current.type == RoomInfo.CHANGE_DUNGEON)
            {
               StateManager.setState(StateType.FIGHTING);
            }
            else
            {
               StateManager.setState(StateType.MULTISHOOT_FIGHTING,this._current);
            }
            RoomManager.Instance.resetAllPlayerState();
         }
      }
      
      private function __missionAllOver(param1:CrazyTankSocketEvent) : void
      {
         var _loc4_:int = 0;
         var _loc7_:Object = null;
         var _loc8_:int = 0;
         var _loc9_:Player = null;
         var _loc10_:SelfInfo = null;
         var _loc2_:PackageIn = param1.pkg;
         var _loc3_:int = _loc2_.readInt();
         if(this._current == null)
         {
            return;
         }
         for(; _loc4_ < _loc3_; _loc4_++)
         {
            _loc8_ = _loc2_.readInt();
            _loc9_ = this._current.findPlayerByPlayerID(_loc8_);
            if(_loc9_.expObj)
            {
               _loc7_ = _loc9_.expObj;
            }
            else
            {
               _loc7_ = new Object();
            }
            if(!_loc9_)
            {
               continue;
            }
            _loc7_.baseExp = _loc2_.readInt();
            _loc7_.gpForVIP = _loc2_.readInt();
            _loc7_.gpForApprenticeTeam = _loc2_.readInt();
            _loc7_.gpForApprenticeOnline = _loc2_.readInt();
            _loc7_.gpForSpouse = _loc2_.readInt();
            _loc7_.gpForServer = _loc2_.readInt();
            _loc7_.gpForDoubleCard = _loc2_.readInt();
            _loc7_.consortiaSkill = _loc2_.readInt();
            _loc7_.gainGP = _loc2_.readInt();
            _loc9_.isWin = _loc2_.readBoolean();
            _loc9_.expObj = _loc7_;
            if(!_loc9_.isWin)
            {
               continue;
            }
            switch(SingleDungeonManager.Instance.currentMapId)
            {
               case 1011:
               case 2011:
                  if(SavePointManager.Instance.isInSavePoint(4))
                  {
                     SavePointManager.Instance.setSavePoint(4);
                  }
                  break;
               case 1005:
               case 2005:
                  if(SavePointManager.Instance.isInSavePoint(6))
                  {
                     SavePointManager.Instance.setSavePoint(6);
                  }
                  break;
               case 1006:
               case 2006:
                  if(SavePointManager.Instance.isInSavePoint(8))
                  {
                     SavePointManager.Instance.setSavePoint(8);
                  }
                  break;
               case 1007:
               case 2007:
                  if(SavePointManager.Instance.isInSavePoint(12))
                  {
                     SavePointManager.Instance.setSavePoint(12);
                  }
                  break;
               case 1008:
               case 2008:
                  if(SavePointManager.Instance.isInSavePoint(19))
                  {
                     SavePointManager.Instance.setSavePoint(19);
                  }
                  break;
            }
         }
         if(PathManager.solveExternalInterfaceEnabel() && this._current.selfGamePlayer.isWin)
         {
            _loc10_ = PlayerManager.Instance.Self;
         }
         this._current.missionInfo.missionOverNPCMovies = [];
         var _loc5_:int = _loc2_.readInt();
         var _loc6_:int = 0;
         while(_loc6_ < _loc5_)
         {
            this._current.missionInfo.missionOverNPCMovies.push(_loc2_.readUTF());
            _loc6_++;
         }
      }
      
      private function __takeOut(param1:CrazyTankSocketEvent) : void
      {
         if(this._current)
         {
            this._current.resultCard.push(param1);
         }
      }
      
      private function __showAllCard(param1:CrazyTankSocketEvent) : void
      {
         if(this._current)
         {
            this._current.showAllCard.push(param1);
         }
      }
      
      public function reset() : void
      {
         if(this._current)
         {
            this._current.dispose();
            this._current = null;
         }
      }
      
      public function startLoading() : void
      {
         StateManager.setState(StateType.GAME_LOADING);
      }
      
      public function dispatchEnterRoom() : void
      {
         dispatchEvent(new Event(ENTER_ROOM));
      }
      
      public function dispatchLeaveMission() : void
      {
         dispatchEvent(new Event(LEAVE_MISSION));
      }
      
      public function dispatchPaymentConfirm() : void
      {
         dispatchEvent(new Event(PLAYER_CLICK_PAY));
      }
      
      public function selfGetItemShowAndSound(param1:Dictionary) : Boolean
      {
         var _loc3_:InventoryItemInfo = null;
         var _loc4_:ChatData = null;
         var _loc5_:String = null;
         var _loc6_:Array = null;
         var _loc7_:String = null;
         var _loc2_:Boolean = false;
         for each(_loc3_ in param1)
         {
            _loc4_ = new ChatData();
            _loc4_.channel = ChatInputView.SYS_NOTICE;
            _loc5_ = LanguageMgr.GetTranslation("tank.data.player.FightingPlayerInfo.your");
            _loc6_ = ChatFormats.getTagsByChannel(_loc4_.channel);
            _loc7_ = ChatFormats.creatGoodTag("[" + _loc3_.Name + "]",ChatFormats.CLICK_GOODS,_loc3_.TemplateID,_loc3_.Quality,_loc3_.IsBinds,_loc4_);
            _loc4_.htmlMessage = _loc6_[0] + _loc5_ + _loc7_ + _loc6_[1] + "<BR>";
            ChatManager.Instance.chat(_loc4_,false);
            if(_loc3_.Quality >= 3)
            {
               _loc2_ = true;
            }
         }
         return _loc2_;
      }
      
      public function isIdenticalGame(param1:int = 0) : Boolean
      {
         var _loc4_:RoomPlayer = null;
         var _loc2_:DictionaryData = RoomManager.Instance.current.players;
         var _loc3_:SelfInfo = PlayerManager.Instance.Self;
         if(param1 == _loc3_.ID)
         {
            return false;
         }
         for each(_loc4_ in _loc2_)
         {
            if(_loc4_.playerInfo.ID == param1 && _loc4_.playerInfo.ZoneID == _loc3_.ZoneID)
            {
               return true;
            }
         }
         return false;
      }
      
      private function __loadResource(param1:CrazyTankSocketEvent) : void
      {
         var _loc4_:GameNeedMovieInfo = null;
         var _loc2_:int = param1.pkg.readInt();
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_)
         {
            _loc4_ = new GameNeedMovieInfo();
            _loc4_.type = param1.pkg.readInt();
            _loc4_.path = param1.pkg.readUTF();
            _loc4_.classPath = param1.pkg.readUTF();
            _loc4_.startLoad();
            _loc3_++;
         }
      }
      
      public function get numCreater() : BloodNumberCreater
      {
         if(this._numCreater)
         {
            return this._numCreater;
         }
         this._numCreater = new BloodNumberCreater();
         return this._numCreater;
      }
      
      public function disposeNumCreater() : void
      {
         if(this._numCreater)
         {
            this._numCreater.dispose();
         }
         this._numCreater = null;
      }
      
      public function getMinDistanceLiving(param1:Living) : Living
      {
         var _loc4_:Living = null;
         var _loc5_:Living = null;
         var _loc2_:int = -1;
         var _loc3_:int = param1.pos.x;
         for each(_loc5_ in this.Current.livings)
         {
            if(_loc5_.isLiving && _loc5_.typeLiving != 3 && _loc5_ != param1)
            {
               if(_loc2_ == -1 || Math.abs(_loc5_.pos.x - _loc3_) < _loc2_)
               {
                  _loc2_ = Math.abs(_loc5_.pos.x - _loc3_);
                  _loc4_ = _loc5_ as Living;
                  _loc4_ = _loc5_;
               }
            }
         }
         return _loc4_;
      }
      
      public function set MissionOverType(param1:uint) : void
      {
         this._MissionOverType = param1;
      }
      
      public function get MissionOverType() : uint
      {
         return this._MissionOverType;
      }
   }
}
