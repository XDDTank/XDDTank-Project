package room
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.events.UIModuleEvent;
   import com.pickgliss.loader.UIModuleLoader;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.BuffInfo;
   import ddt.data.UIModuleTypes;
   import ddt.data.player.PlayerInfo;
   import ddt.data.player.SelfInfo;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.loader.StartupResourceLoader;
   import ddt.manager.GameInSocketOut;
   import ddt.manager.LanguageMgr;
   import ddt.manager.LeavePageManager;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PetInfoManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.StateManager;
   import ddt.states.StateType;
   import ddt.view.UIModuleSmallLoading;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import game.GameManager;
   import invite.ResponseInviteFrame;
   import pet.date.PetInfo;
   import road7th.comm.PackageIn;
   import road7th.data.DictionaryData;
   import room.model.RoomInfo;
   import room.model.RoomPlayer;
   import room.view.ChallengeRoomPlayerItem;
   import room.view.RoomPlayerItem;
   import roomList.pvpRoomList.RoomListCreateRoomView;
   import roomList.pvpRoomList.RoomListModel;
   import roomList.pvpRoomList.SingleRoomView;
   import worldboss.WorldBossManager;
   
   public class RoomManager extends EventDispatcher
   {
      
      public static const PAYMENT_TAKE_CARD:String = "PaymentCard";
      
      public static const LOGIN_ROOM_RESULT:String = "loginRoomResult";
      
      public static const PLAYER_ROOM_EXIT:String = "PlayerRoomExit";
      
      public static const ROOM_LIST_LOADED:String = "roomListLoaded";
      
      public static const ROOM_LOADING_LOADED:String = "roomLoadingLoaded";
      
      public static const DDTROOM:String = "ddtRoom";
      
      private static var _instance:RoomManager;
       
      
      private var _current:RoomInfo;
      
      public var _removeRoomMsg:String = "";
      
      private var _loadedCallBack:Function;
      
      private var _loadingModuleType:String;
      
      private var _tempInventPlayerID:int = -1;
      
      private var _func:Function;
      
      private var _funcParams:Array;
      
      private var _loadComplete:Boolean = false;
      
      private var _model:RoomListModel;
      
      private var _beforePlace:int = 0;
      
      private var _findLoginRoom:Boolean = false;
      
      public function RoomManager()
      {
         super();
      }
      
      public static function getTurnTimeByType(param1:int) : int
      {
         switch(param1)
         {
            case 1:
               return 6;
            case 2:
               return 8;
            case 3:
               return 11;
            case 4:
               return 16;
            case 5:
               return 21;
            case 6:
               return 31;
            default:
               return -1;
         }
      }
      
      public static function get Instance() : RoomManager
      {
         if(_instance == null)
         {
            _instance = new RoomManager();
         }
         return _instance;
      }
      
      public function showRoomList(param1:Function, param2:String) : void
      {
         if(UIModuleLoader.Instance.checkIsLoaded(param2))
         {
            if(param1 != null)
            {
               param1();
            }
         }
         else
         {
            this._loadingModuleType = param2;
            this._loadedCallBack = param1;
            UIModuleSmallLoading.Instance.progress = 0;
            UIModuleSmallLoading.Instance.show();
            UIModuleSmallLoading.Instance.addEventListener(Event.CLOSE,this.__onClose);
            UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.__roomListComplete);
            UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.__roomListProgress);
            UIModuleLoader.Instance.addUIModuleImp(param2);
         }
      }
      
      private function __onClose(param1:Event) : void
      {
      }
      
      protected function __roomListComplete(param1:UIModuleEvent) : void
      {
      }
      
      protected function __roomListProgress(param1:UIModuleEvent) : void
      {
         if(param1.module == this._loadingModuleType)
         {
            UIModuleSmallLoading.Instance.progress = param1.loader.progress * 100;
         }
      }
      
      public function set current(param1:RoomInfo) : void
      {
         this.setCurrent(param1);
      }
      
      public function get current() : RoomInfo
      {
         return this._current;
      }
      
      private function setCurrent(param1:RoomInfo) : void
      {
         if(this._current)
         {
            this._current.dispose();
         }
         this._current = param1;
      }
      
      public function createTrainerRoom() : void
      {
         this.setCurrent(new RoomInfo());
         this._current.timeType = 3;
      }
      
      public function setRoomDefyInfo(param1:Array) : void
      {
         if(this._current)
         {
            this._current.defyInfo = param1;
         }
      }
      
      public function setup() : void
      {
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.GAME_ROOM_CREATE,this.__createRoom);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.GAME_ROOM_LOGIN,this.__loginRoomResult);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.GAME_ROOM_SETUP_CHANGE,this.__settingRoom);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.GAME_ROOM_UPDATE_PLACE,this.__updateRoomPlaces);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.GAME_PLAYER_STATE_CHANGE,this.__playerStateChange);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.GMAE_STYLE_RECV,this.__updateGameStyle);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.GAME_TEAM,this.__setPlayerTeam);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.NETWORK,this.__netWork);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.BUFF_OBTAIN,this.__buffObtain);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.BUFF_UPDATE,this.__buffUpdate);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.GAME_WAIT_FAILED,this.__waitGameFailed);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.GAME_WAIT_RECV,this.__waitGameRecv);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.GAME_AWIT_CANCEL,this.__waitCancel);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.GAME_PLAYER_ENTER,this.__addPlayerInRoom);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.GAME_PLAYER_EXIT,this.__removePlayerInRoom);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.INSUFFICIENT_MONEY,this.__paymentFailed);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.RANDOM_PVE,this.__randomPve);
      }
      
      public function canCloseItem(param1:RoomPlayerItem) : Boolean
      {
         var _loc2_:int = param1.place;
         var _loc3_:uint = 3;
         var _loc4_:Array = this._current.placesState;
         var _loc5_:int = 0;
         while(_loc5_ < 6)
         {
            if(_loc5_ % 2 == _loc2_ % 2)
            {
               if(_loc4_[_loc5_] == 0)
               {
                  _loc3_--;
               }
            }
            _loc5_++;
         }
         if(_loc3_ <= 1)
         {
            return false;
         }
         return true;
      }
      
      public function canSmallCloseItem(param1:ChallengeRoomPlayerItem) : Boolean
      {
         var _loc2_:int = param1.place;
         var _loc3_:uint = 3;
         var _loc4_:Array = this._current.placesState;
         var _loc5_:int = 0;
         while(_loc5_ < 6)
         {
            if(_loc5_ % 2 == _loc2_ % 2)
            {
               if(_loc4_[_loc5_] == 0)
               {
                  _loc3_--;
               }
            }
            _loc5_++;
         }
         if(_loc3_ <= 1)
         {
            return false;
         }
         return true;
      }
      
      private function __paymentFailed(param1:CrazyTankSocketEvent) : void
      {
         var _loc5_:BaseAlerFrame = null;
         var _loc6_:BaseAlerFrame = null;
         var _loc7_:BaseAlerFrame = null;
         var _loc2_:PackageIn = param1.pkg;
         var _loc3_:int = _loc2_.readByte();
         var _loc4_:Boolean = _loc2_.readBoolean();
         if(_loc3_ == 0)
         {
            if(!_loc4_)
            {
               _loc5_ = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("tank.room.RoomIIView2.notenoughmoney.title"),LanguageMgr.GetTranslation("tank.room.RoomIIView2.notenoughmoney.content"),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),false,true,true,LayerManager.ALPHA_BLOCKGOUND);
               _loc5_.addEventListener(FrameEvent.RESPONSE,this._responseI);
            }
         }
         else if(_loc3_ == 1)
         {
            if(!_loc4_)
            {
               dispatchEvent(new Event(PAYMENT_TAKE_CARD));
               _loc6_ = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("tank.room.RoomIIView2.notenoughmoney.title"),LanguageMgr.GetTranslation("tank.room.RoomIIView2.notenoughmoney.content"),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),false,true,true,LayerManager.ALPHA_BLOCKGOUND);
               if(_loc6_.parent)
               {
                  _loc6_.parent.removeChild(_loc6_);
               }
               LayerManager.Instance.addToLayer(_loc6_,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.ALPHA_BLOCKGOUND);
               _loc6_.addEventListener(FrameEvent.RESPONSE,this._responseI);
            }
         }
         else if(_loc3_ == 2)
         {
            if(!_loc4_)
            {
               _loc7_ = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("tank.room.RoomIIView2.notenoughmoney.title"),LanguageMgr.GetTranslation("tank.room.RoomIIView2.notenoughmoney.content"),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),false,true,true,LayerManager.ALPHA_BLOCKGOUND);
               _loc7_.addEventListener(FrameEvent.RESPONSE,this._responseII);
            }
         }
      }
      
      private function _responseI(param1:FrameEvent) : void
      {
         (param1.currentTarget as BaseAlerFrame).removeEventListener(FrameEvent.RESPONSE,this._responseI);
         if(param1.responseCode == FrameEvent.SUBMIT_CLICK || param1.responseCode == FrameEvent.ENTER_CLICK)
         {
            LeavePageManager.leaveToFillPath();
         }
         ObjectUtils.disposeObject(param1.currentTarget);
      }
      
      private function _responseII(param1:FrameEvent) : void
      {
         (param1.currentTarget as BaseAlerFrame).removeEventListener(FrameEvent.RESPONSE,this._responseII);
         if(param1.responseCode == FrameEvent.SUBMIT_CLICK || param1.responseCode == FrameEvent.ENTER_CLICK)
         {
            this.__toPaymentTryagainHandler();
         }
         else
         {
            this.__cancelPaymenttryagainHandler();
         }
         ObjectUtils.disposeObject(param1.currentTarget);
      }
      
      private function __toPaymentTryagainHandler() : void
      {
         LeavePageManager.leaveToFillPath();
         GameManager.Instance.dispatchPaymentConfirm();
      }
      
      private function __cancelPaymenttryagainHandler() : void
      {
         GameManager.Instance.dispatchLeaveMission();
      }
      
      private function __createRoom(param1:CrazyTankSocketEvent) : void
      {
         var _loc3_:RoomInfo = null;
         var _loc2_:PackageIn = param1.pkg;
         _loc3_ = new RoomInfo();
         _loc3_.ID = _loc2_.readInt();
         _loc3_.type = _loc2_.readByte();
         _loc3_.hardLevel = _loc2_.readByte();
         _loc3_.timeType = _loc2_.readByte();
         _loc3_.totalPlayer = _loc2_.readByte();
         _loc3_.viewerCnt = _loc2_.readByte();
         _loc3_.placeCount = _loc2_.readByte();
         _loc3_.isLocked = _loc2_.readBoolean();
         _loc3_.mapId = _loc2_.readInt();
         _loc3_.started = _loc2_.readBoolean();
         _loc3_.Name = _loc2_.readUTF();
         _loc3_.gameMode = _loc2_.readByte();
         _loc3_.levelLimits = _loc2_.readInt();
         _loc3_.isCrossZone = _loc2_.readBoolean();
         _loc3_.isWithinLeageTime = _loc2_.readBoolean();
         this.setCurrent(_loc3_);
         dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.GAME_ROOM_CREATE));
      }
      
      public function set tempInventPlayerID(param1:int) : void
      {
         this._tempInventPlayerID = param1;
      }
      
      public function get tempInventPlayerID() : int
      {
         return this._tempInventPlayerID;
      }
      
      public function haveTempInventPlayer() : Boolean
      {
         return this._tempInventPlayerID != -1;
      }
      
      private function __loginRoomResult(param1:CrazyTankSocketEvent) : void
      {
         dispatchEvent(new Event(LOGIN_ROOM_RESULT));
         if(param1.pkg.readBoolean() == false)
         {
            this.findLoginRoom = false;
         }
      }
      
      private function __addPlayerInRoom(param1:CrazyTankSocketEvent) : void
      {
         var pkg:PackageIn = null;
         var id:int = 0;
         var isInGame:Boolean = false;
         var pos:int = 0;
         var team:int = 0;
         var isFirstIn:Boolean = false;
         var level:int = 0;
         var offer:int = 0;
         var hide:int = 0;
         var repute:int = 0;
         var speed:int = 0;
         var zoneID:int = 0;
         var info:PlayerInfo = null;
         var fpInfo:RoomPlayer = null;
         var unknown1:int = 0;
         var unknown2:int = 0;
         var hasPet:Boolean = false;
         var place:int = 0;
         var templateID:int = 0;
         var fightPet:PetInfo = null;
         var skillCount:int = 0;
         var i:int = 0;
         var skillplace:int = 0;
         var sID:int = 0;
         var si:SingleRoomView = null;
         var evt:CrazyTankSocketEvent = param1;
         ResponseInviteFrame.clearInviteFrame();
         if(this._current)
         {
            pkg = evt.pkg;
            id = pkg.clientId;
            isInGame = pkg.readBoolean();
            pos = pkg.readByte();
            team = pkg.readByte();
            isFirstIn = pkg.readBoolean();
            level = pkg.readInt();
            offer = pkg.readInt();
            hide = pkg.readInt();
            repute = pkg.readInt();
            speed = pkg.readInt();
            zoneID = pkg.readInt();
            if(id != PlayerManager.Instance.Self.ID)
            {
               info = PlayerManager.Instance.findPlayer(id);
               info.beginChanges();
               info.ID = pkg.readInt();
               info.NickName = pkg.readUTF();
               info.VIPtype = pkg.readByte();
               info.VIPLevel = pkg.readInt();
               info.Sex = pkg.readBoolean();
               info.Style = pkg.readUTF();
               info.Colors = pkg.readUTF();
               info.Skin = pkg.readUTF();
               info.WeaponID = pkg.readInt();
               info.DeputyWeaponID = pkg.readInt();
               info.Repute = repute;
               info.Grade = level;
               info.Offer = offer;
               info.Hide = hide;
               info.ConsortiaID = pkg.readInt();
               info.ConsortiaName = pkg.readUTF();
               info.badgeID = pkg.readInt();
               info.WinCount = pkg.readInt();
               info.TotalCount = pkg.readInt();
               info.EscapeCount = pkg.readInt();
               unknown1 = pkg.readInt();
               unknown2 = pkg.readInt();
               info.IsMarried = pkg.readBoolean();
               if(info.IsMarried)
               {
                  info.SpouseID = pkg.readInt();
                  info.SpouseName = pkg.readUTF();
               }
               else
               {
                  info.SpouseID = 0;
                  info.SpouseName = "";
               }
               info.LoginName = pkg.readUTF();
               info.Nimbus = pkg.readInt();
               info.FightPower = pkg.readInt();
               info.apprenticeshipState = pkg.readInt();
               info.masterID = pkg.readInt();
               info.setMasterOrApprentices(pkg.readUTF());
               info.graduatesCount = pkg.readInt();
               info.honourOfMaster = pkg.readUTF();
               info.DailyLeagueFirst = pkg.readBoolean();
               info.DailyLeagueLastScore = pkg.readInt();
               info.isOld = pkg.readBoolean();
               info.MilitaryRankTotalScores = pkg.readInt();
               hasPet = pkg.readBoolean();
               if(hasPet)
               {
                  place = pkg.readInt();
                  templateID = pkg.readInt();
                  fightPet = PetInfoManager.instance.getPetInfoByTemplateID(templateID);
                  fightPet.Place = place;
                  fightPet.ID = pkg.readInt();
                  fightPet.Name = pkg.readUTF();
                  fightPet.UserID = pkg.readInt();
                  fightPet.Level = pkg.readInt();
                  fightPet.clearSkills();
                  skillCount = pkg.readInt();
                  i = 0;
                  while(i < skillCount)
                  {
                     skillplace = pkg.readInt();
                     sID = pkg.readInt();
                     fightPet.addSkill(skillplace,sID);
                     i++;
                  }
                  info.pets.add(fightPet.Place,fightPet);
                  if(fightPet.Place == 0)
                  {
                     info.currentPet = fightPet;
                  }
               }
               info.commitChanges();
            }
            else
            {
               info = PlayerManager.Instance.Self;
            }
            info.ZoneID = zoneID;
            if(GameManager.Instance.Current != null)
            {
               fpInfo = GameManager.Instance.Current.findRoomPlayer(id,zoneID);
            }
            if(fpInfo == null)
            {
               fpInfo = new RoomPlayer(info);
            }
            fpInfo.isFirstIn = isFirstIn;
            fpInfo.place = pos;
            fpInfo.team = team;
            fpInfo.webSpeedInfo.delay = speed;
            this._current.addPlayer(fpInfo);
            if(fpInfo.isSelf && this._current)
            {
               if(this._current.type == RoomInfo.SINGLE_ROOM)
               {
                  si = ComponentFactory.Instance.creatComponentByStylename("asset.ddtroomList.RoomList.SingleRoomView");
                  si.initII(this._current);
                  si.show();
               }
               else if(this._current.type != 5)
               {
                  if(this._current.type == RoomInfo.MATCH_ROOM || this._current.type == RoomInfo.MULTI_MATCH)
                  {
                     RoomManager.Instance.showRoomList(function():void
                     {
                        StateManager.setState(StateType.MATCH_ROOM);
                     },UIModuleTypes.DDTROOM);
                  }
                  else if(this._current.type == RoomInfo.CHALLENGE_ROOM)
                  {
                     RoomManager.Instance.showRoomList(function():void
                     {
                        StateManager.setState(StateType.CHALLENGE_ROOM);
                     },UIModuleTypes.DDTROOM);
                  }
                  else if(this._current.type == RoomInfo.DUNGEON_ROOM)
                  {
                     RoomManager.Instance.showRoomList(function():void
                     {
                        StateManager.setState(StateType.DUNGEON_ROOM);
                     },UIModuleTypes.DDTROOM);
                  }
                  else if(this._current.type == RoomInfo.FRESHMAN_ROOM)
                  {
                     if(StartupResourceLoader.firstEnterHall)
                     {
                        RoomManager.Instance.showRoomList(function():void
                        {
                           StateManager.setState(StateType.FRESHMAN_ROOM2);
                        },UIModuleTypes.DDTROOM);
                     }
                     else
                     {
                        RoomManager.Instance.showRoomList(function():void
                        {
                           StateManager.setState(StateType.FRESHMAN_ROOM1);
                        },UIModuleTypes.DDTROOM);
                     }
                  }
                  else if(this._current.type == RoomInfo.WORLD_BOSS_FIGHT)
                  {
                     WorldBossManager.Instance.enterGame();
                  }
                  else if(this._current.type == RoomInfo.CHANGE_DUNGEON)
                  {
                     RoomManager.Instance.showRoomList(function():void
                     {
                        StateManager.setState(StateType.DUNGEON_ROOM);
                     },UIModuleTypes.DDTROOM);
                  }
                  else if(this._current.type == RoomInfo.MULTI_DUNGEON)
                  {
                     RoomManager.Instance.showRoomList(function():void
                     {
                        StateManager.setState(StateType.DUNGEON_ROOM);
                     },UIModuleTypes.DDTROOM);
                  }
               }
            }
         }
      }
      
      private function __removePlayerInRoom(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:RoomPlayer = null;
         if(this._current)
         {
            _loc2_ = param1.pkg.clientId;
            _loc3_ = param1.pkg.readInt();
            _loc4_ = this._current.findPlayerByID(_loc2_,_loc3_);
            if(_loc4_ && _loc4_.isSelf)
            {
               if(StateManager.currentStateType == StateType.MATCH_ROOM || StateManager.currentStateType == StateType.CHALLENGE_ROOM)
               {
                  StateManager.setState(StateType.MAIN);
               }
               else if(StateManager.currentStateType == StateType.DUNGEON_ROOM || StateManager.currentStateType == StateType.MISSION_ROOM)
               {
                  StateManager.setState(StateType.MAIN);
               }
               else if(StateManager.currentStateType == StateType.FIGHT_LIB_GAMEVIEW)
               {
                  StateManager.setState(StateType.MAIN);
               }
               else if(StateManager.isInFight || StateManager.currentStateType == StateType.MULTISHOOT_FIGHTING || StateManager.currentStateType == StateType.ROOM_LOADING || StateManager.currentStateType == StateType.GAME_LOADING)
               {
                  if(this._current.type == RoomInfo.DUNGEON_ROOM)
                  {
                     StateManager.setState(StateType.MAIN);
                  }
                  else if(this._current.type != RoomInfo.WORLD_BOSS_FIGHT)
                  {
                     if(this._current.type == RoomInfo.SINGLE_DUNGEON)
                     {
                        StateManager.setState(StateType.SINGLEDUNGEON);
                     }
                     else if(this._current.type == RoomInfo.CONSORTION_MONSTER && PlayerManager.Instance.Self.ConsortiaID != 0)
                     {
                        SocketManager.Instance.out.SendenterConsortion();
                     }
                     else
                     {
                        StateManager.setState(StateType.MAIN);
                     }
                  }
               }
               PlayerManager.Instance.Self.unlockAllBag();
            }
            else
            {
               if(GameManager.Instance.Current)
               {
                  GameManager.Instance.Current.removeRoomPlayer(_loc3_,_loc2_);
                  GameManager.Instance.Current.removeGamePlayerByPlayerID(_loc3_,_loc2_);
               }
               this._current.removePlayer(_loc3_,_loc2_);
            }
            dispatchEvent(new Event(PLAYER_ROOM_EXIT));
         }
      }
      
      private function __playerStateChange(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:Array = null;
         var _loc3_:int = 0;
         if(this._current)
         {
            _loc2_ = new Array();
            _loc3_ = 0;
            while(_loc3_ < 6)
            {
               _loc2_[_loc3_] = param1.pkg.readByte();
               _loc3_++;
            }
            this._current.updatePlayerState(_loc2_);
         }
      }
      
      public function findRoomPlayer(param1:int) : RoomPlayer
      {
         if(this._current)
         {
            return this._current.players[param1] as RoomPlayer;
         }
         return null;
      }
      
      private function __settingRoom(param1:CrazyTankSocketEvent) : void
      {
         if(this._current == null)
         {
            return;
         }
         var _loc2_:Boolean = param1.pkg.readBoolean();
         this._current.type = param1.pkg.readByte();
         if(_loc2_ || StateManager.currentStateType == StateType.SINGLEDUNGEON && this._current.type != RoomInfo.HIJACK_CAR)
         {
            this._current.pic = param1.pkg.readUTF();
            if(!RoomManager.Instance.current.selfRoomPlayer.isHost && StateManager.currentStateType != StateType.DUNGEON_ROOM)
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("BaseRoomView.getout.bossRoom"));
            }
         }
         this._current.isOpenBoss = _loc2_;
         this._current.mapId = param1.pkg.readInt();
         this._current.roomPass = param1.pkg.readUTF();
         this._current.roomName = param1.pkg.readUTF();
         this._current.timeType = param1.pkg.readByte();
         this._current.hardLevel = param1.pkg.readByte();
         this._current.levelLimits = param1.pkg.readInt();
         this._current.isCrossZone = param1.pkg.readBoolean();
         dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.GAME_ROOM_SETUP_CHANGE));
      }
      
      private function __updateRoomPlaces(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:Array = new Array();
         var _loc3_:int = 0;
         while(_loc3_ < 8)
         {
            _loc2_[_loc3_] = param1.pkg.readInt();
            _loc3_++;
         }
         if(this._current)
         {
            this._current.updatePlaceState(_loc2_);
         }
      }
      
      private function __updateGameStyle(param1:CrazyTankSocketEvent) : void
      {
         if(this._current == null)
         {
            return;
         }
         this._current.gameMode = param1.pkg.readByte();
      }
      
      private function __setPlayerTeam(param1:CrazyTankSocketEvent) : void
      {
         if(this._current == null)
         {
            return;
         }
         this._current.updatePlayerTeam(param1.pkg.clientId,param1.pkg.readByte(),param1.pkg.readByte());
      }
      
      private function __netWork(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:PlayerInfo = PlayerManager.Instance.findPlayer(param1.pkg.clientId);
         var _loc3_:int = param1.pkg.readInt();
         if(_loc2_)
         {
            _loc2_.webSpeed = _loc3_;
         }
      }
      
      private function __buffObtain(param1:CrazyTankSocketEvent) : void
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:Boolean = false;
         var _loc7_:Date = null;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         var _loc10_:BuffInfo = null;
         var _loc2_:PackageIn = param1.pkg;
         if(_loc2_.clientId == PlayerManager.Instance.Self.ID)
         {
            return;
         }
         if(this._current.findPlayerByID(_loc2_.clientId) != null)
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
               this._current.findPlayerByID(_loc2_.clientId).playerInfo.buffInfo.add(_loc10_.Type,_loc10_);
               _loc4_++;
            }
            param1.stopImmediatePropagation();
         }
      }
      
      private function __buffUpdate(param1:CrazyTankSocketEvent) : void
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:Boolean = false;
         var _loc7_:Date = null;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         var _loc10_:BuffInfo = null;
         var _loc2_:PackageIn = param1.pkg;
         if(_loc2_.clientId == PlayerManager.Instance.Self.ID)
         {
            return;
         }
         if(this._current.findPlayerByID(_loc2_.clientId) != null)
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
               if(_loc6_)
               {
                  this._current.findPlayerByID(_loc2_.clientId).playerInfo.buffInfo.add(_loc10_.Type,_loc10_);
               }
               else
               {
                  this._current.findPlayerByID(_loc2_.clientId).playerInfo.buffInfo.remove(_loc10_.Type);
               }
               _loc4_++;
            }
            param1.stopImmediatePropagation();
         }
      }
      
      private function __randomPve(param1:CrazyTankSocketEvent) : void
      {
         GameInSocketOut.sendGameRoomSetUp(17,RoomInfo.DUNGEON_ROOM,false,"",RoomListCreateRoomView.PREWORD[int(Math.random() * RoomListCreateRoomView.PREWORD.length)],1,0,0,false,17);
      }
      
      private function __waitGameFailed(param1:CrazyTankSocketEvent) : void
      {
         if(this._current)
         {
            this._current.pickupFailed();
         }
      }
      
      private function __waitGameRecv(param1:CrazyTankSocketEvent) : void
      {
         if(this._current)
         {
            this._current.startPickup();
         }
      }
      
      private function __waitCancel(param1:CrazyTankSocketEvent) : void
      {
         if(this._current)
         {
            this._current.cancelPickup();
         }
      }
      
      public function resetAllPlayerState() : void
      {
         var _loc1_:RoomPlayer = null;
         for each(_loc1_ in this._current.players)
         {
            _loc1_.isReady = false;
            _loc1_.progress = 0;
            if(this._current.type != RoomInfo.CHALLENGE_ROOM)
            {
               _loc1_.team = 1;
            }
         }
      }
      
      public function isIdenticalRoom(param1:int = 0, param2:String = "") : Boolean
      {
         var _loc5_:RoomPlayer = null;
         var _loc3_:DictionaryData = this.current.players;
         var _loc4_:SelfInfo = PlayerManager.Instance.Self;
         if(param1 == _loc4_.ID)
         {
            return false;
         }
         for each(_loc5_ in _loc3_)
         {
            if(_loc5_.playerInfo.ID == param1 || _loc5_.playerInfo.NickName == param2)
            {
               return true;
            }
         }
         return false;
      }
      
      public function get loadComplete() : Boolean
      {
         return this._loadComplete;
      }
      
      public function set model(param1:RoomListModel) : void
      {
         this._model = param1;
      }
      
      public function get model() : RoomListModel
      {
         return this._model;
      }
      
      public function reset() : void
      {
         if(this._current)
         {
            this._current.dispose();
            this._current = null;
         }
      }
      
      public function set beforePlace(param1:int) : void
      {
         this._beforePlace = param1;
      }
      
      public function get beforePlace() : int
      {
         return this._beforePlace;
      }
      
      public function set findLoginRoom(param1:Boolean) : void
      {
         this._findLoginRoom = param1;
      }
      
      public function get findLoginRoom() : Boolean
      {
         return this._findLoginRoom;
      }
   }
}
