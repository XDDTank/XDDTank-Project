package game.model
{
   import ddt.data.map.MissionInfo;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.events.GameEvent;
   import ddt.loader.MapLoader;
   import ddt.manager.PlayerManager;
   import flash.events.EventDispatcher;
   import flash.geom.Point;
   import flash.utils.Dictionary;
   import game.GameManager;
   import game.objects.ActionType;
   import game.objects.BombAction;
   import game.view.Bomb;
   import road7th.data.DictionaryData;
   import room.RoomManager;
   import room.model.RoomPlayer;
   
   public class GameInfo extends EventDispatcher
   {
      
      public static const ADD_ROOM_PLAYER:String = "addRoomPlayer";
      
      public static const REMOVE_ROOM_PLAYER:String = "removeRoomPlayer";
      
      public static const DAMAGE_TYPE_LIST:Array = [0,60,80,80,80,80,80];
       
      
      private var _mapIndex:int = 1305;
      
      public var roomType:int;
      
      public var showAllCard:Array;
      
      public var startEvent:CrazyTankSocketEvent;
      
      public var GainRiches:int;
      
      public var PlayerCount:int;
      
      public var startPlayer:int;
      
      public var hasNextSession:Boolean;
      
      public var neededMovies:Array;
      
      public var neededPetSkillResource:Array;
      
      private var _selfGamePlayer:LocalPlayer;
      
      public var roomPlayers:Array;
      
      public var timeType:int;
      
      public var maxTime:int;
      
      public var loaderMap:MapLoader;
      
      public var livings:DictionaryData;
      
      private var _teams:DictionaryData;
      
      public var viewers:DictionaryData;
      
      public var currentLiving:Living;
      
      private var _gameMode:int;
      
      private var _resultCard:Array;
      
      private var _missionInfo:MissionInfo;
      
      public var missionCount:int;
      
      public var gameOverNpcMovies:Array;
      
      private var _tempPlayerForSettlement:Player;
      
      private var _wind:Number = 0;
      
      private var _hasNextMission:Boolean;
      
      private var _lastShootPos:Point;
      
      private var _stasticHurtList:DictionaryData;
      
      private var _stasticDamageList:DictionaryData;
      
      private var _currentTurn:int;
      
      private var _lastTurn:int;
      
      public function GameInfo()
      {
         this.showAllCard = new Array();
         this.neededMovies = new Array();
         this.neededPetSkillResource = new Array();
         this.roomPlayers = [];
         this.livings = new DictionaryData();
         this._teams = new DictionaryData();
         this.viewers = new DictionaryData();
         this._resultCard = [];
         this.gameOverNpcMovies = [];
         this._stasticHurtList = new DictionaryData();
         this._stasticDamageList = new DictionaryData();
         super();
      }
      
      public function get mapIndex() : int
      {
         return this._mapIndex;
      }
      
      public function set mapIndex(param1:int) : void
      {
         this._mapIndex = param1;
      }
      
      public function get teams() : DictionaryData
      {
         return this._teams;
      }
      
      public function set teams(param1:DictionaryData) : void
      {
         this._teams = param1;
      }
      
      public function get currentTeam() : int
      {
         return Boolean(this.currentLiving) ? int(this.currentLiving.team) : int(0);
      }
      
      public function set gameMode(param1:int) : void
      {
         this._gameMode = param1;
      }
      
      public function get gameMode() : int
      {
         return this._gameMode;
      }
      
      public function get resultCard() : Array
      {
         return this._resultCard;
      }
      
      public function set resultCard(param1:Array) : void
      {
         this._resultCard = param1;
      }
      
      public function get missionInfo() : MissionInfo
      {
         return this._missionInfo;
      }
      
      public function set missionInfo(param1:MissionInfo) : void
      {
         this._missionInfo = param1;
      }
      
      public function resetBossCardCnt() : void
      {
         var _loc1_:Living = null;
         var _loc2_:Player = null;
         for each(_loc1_ in this.livings)
         {
            _loc2_ = _loc1_ as Player;
            if(_loc2_)
            {
               _loc2_.BossCardCount = 0;
               _loc2_.GetCardCount = 0;
            }
         }
      }
      
      public function addGamePlayer(param1:Living) : void
      {
         var _loc2_:Living = this.livings[param1.LivingID];
         if(_loc2_)
         {
            _loc2_.dispose();
         }
         if(param1 is LocalPlayer)
         {
            this._selfGamePlayer = param1 as LocalPlayer;
         }
         this.livings.add(param1.LivingID,param1);
         this.addTeamPlayer(param1);
      }
      
      public function addGameViewer(param1:Living) : void
      {
         var _loc2_:Living = this.viewers[param1.playerInfo.ID];
         if(_loc2_)
         {
            _loc2_.dispose();
         }
         if(param1 is LocalPlayer)
         {
            this._selfGamePlayer = param1 as LocalPlayer;
         }
         this.viewers.add(param1.playerInfo.ID,param1);
      }
      
      public function viewerToLiving(param1:int) : void
      {
         var _loc2_:Living = this.viewers[param1];
         if(_loc2_)
         {
            this.viewers.remove(param1);
            if(_loc2_ is LocalPlayer)
            {
               this._selfGamePlayer = _loc2_ as LocalPlayer;
            }
            this.livings.add(_loc2_.LivingID,_loc2_);
            this.addTeamPlayer(_loc2_);
         }
      }
      
      public function livingToViewer(param1:int, param2:int) : void
      {
         var _loc3_:Living = this.findLivingByPlayerID(param1,param2);
         if(_loc3_)
         {
            this.livings.remove(_loc3_.LivingID);
            this.removeTeamPlayer(_loc3_);
            if(_loc3_ is LocalPlayer)
            {
               this._selfGamePlayer = _loc3_ as LocalPlayer;
            }
            this.viewers.add(param1,_loc3_);
         }
      }
      
      public function addTeamPlayer(param1:Living) : void
      {
         var _loc2_:DictionaryData = new DictionaryData();
         if(this.teams[param1.team] == null)
         {
            _loc2_ = new DictionaryData();
            this.teams[param1.team] = _loc2_;
         }
         else
         {
            _loc2_ = this.teams[param1.team];
         }
         if(_loc2_[param1.LivingID] == null)
         {
            _loc2_.add(param1.LivingID,param1);
         }
      }
      
      public function removeTeamPlayer(param1:Living) : void
      {
         var _loc3_:int = 0;
         var _loc4_:Player = null;
         var _loc2_:DictionaryData = this.teams[param1.team];
         if(_loc2_ && _loc2_[param1.LivingID])
         {
            _loc2_.remove(param1.LivingID);
         }
         if(param1.team != this.selfGamePlayer.team)
         {
            _loc3_ = 0;
            for each(_loc4_ in _loc2_)
            {
               _loc3_++;
            }
            if(_loc3_ == 0)
            {
               this._tempPlayerForSettlement = param1 as Player;
            }
         }
      }
      
      public function setSelfGamePlayer(param1:Living) : void
      {
         this._selfGamePlayer = param1 as LocalPlayer;
      }
      
      public function removeGamePlayer(param1:int) : Living
      {
         var _loc2_:Living = this.livings[param1];
         if(_loc2_)
         {
            this.removeTeamPlayer(_loc2_);
            this.livings.remove(param1);
         }
         return _loc2_;
      }
      
      public function removeGamePlayerByPlayerID(param1:int, param2:int) : void
      {
         var _loc3_:Living = null;
         var _loc4_:Living = null;
         for each(_loc3_ in this.livings)
         {
            if(_loc3_ is Player && _loc3_.playerInfo)
            {
               if(_loc3_.playerInfo.ZoneID == param1 && _loc3_.playerInfo.ID == param2)
               {
                  this.removeGamePlayer(_loc3_.LivingID);
                  if(GameManager.Instance.Current.gameMode != GameModeType.MULTI_DUNGEON || GameManager.Instance.Current.gameMode != GameModeType.MULTI_MATCH)
                  {
                     _loc3_.dispose();
                  }
               }
            }
         }
         for each(_loc4_ in this.viewers)
         {
            if(_loc4_.playerInfo.ZoneID == param1 && _loc4_.playerInfo.ID == param2)
            {
               this.viewers.remove(_loc4_.playerInfo.ID);
               _loc4_.dispose();
            }
         }
      }
      
      public function isAllReady() : Boolean
      {
         var _loc2_:Player = null;
         var _loc1_:Boolean = true;
         for each(_loc2_ in this.livings)
         {
            if(_loc2_.isReady == false)
            {
               _loc1_ = false;
               break;
            }
         }
         return _loc1_;
      }
      
      public function findPlayer(param1:int) : Player
      {
         return this.livings[param1] as Player;
      }
      
      public function findPlayerByPlayerID(param1:int) : Player
      {
         var _loc2_:Living = null;
         for each(_loc2_ in this.livings)
         {
            if(_loc2_.isPlayer() && _loc2_.playerInfo.ID == param1)
            {
               return _loc2_ as Player;
            }
         }
         return null;
      }
      
      public function findGamerbyPlayerId(param1:int) : Player
      {
         var _loc2_:Living = null;
         var _loc3_:Living = null;
         for each(_loc2_ in this.livings)
         {
            if(_loc2_ && _loc2_.isPlayer() && _loc2_.playerInfo.ID == param1)
            {
               return _loc2_ as Player;
            }
         }
         for each(_loc3_ in this.viewers)
         {
            if(_loc3_ && _loc3_.playerInfo.ID == param1)
            {
               return _loc3_ as Player;
            }
         }
         return null;
      }
      
      public function get haveAllias() : Boolean
      {
         var _loc1_:Living = null;
         for each(_loc1_ in this.livings)
         {
            if(_loc1_.isLiving && _loc1_.team == this.selfGamePlayer.team)
            {
               return true;
            }
         }
         return false;
      }
      
      public function get allias() : Vector.<Player>
      {
         var _loc3_:RoomPlayer = null;
         var _loc4_:Player = null;
         var _loc1_:Vector.<Player> = new Vector.<Player>();
         var _loc2_:int = 0;
         while(_loc2_ < this.roomPlayers.length)
         {
            _loc3_ = this.roomPlayers[_loc2_] as RoomPlayer;
            if(_loc3_)
            {
               _loc4_ = this.findPlayerByPlayerID(_loc3_.playerInfo.ID);
               if(_loc4_ && _loc4_.team == this.selfGamePlayer.team && _loc4_ != this.selfGamePlayer && _loc4_.expObj)
               {
                  _loc1_.push(_loc4_);
               }
            }
            _loc2_++;
         }
         return _loc1_;
      }
      
      public function findLiving(param1:int) : Living
      {
         return this.livings[param1];
      }
      
      public function findTeam(param1:int) : DictionaryData
      {
         return this.teams[param1];
      }
      
      public function getTeamLiveCount(param1:int) : int
      {
         var _loc4_:Living = null;
         var _loc2_:DictionaryData = this.findTeam(param1);
         var _loc3_:int = 0;
         if(_loc2_)
         {
            for each(_loc4_ in _loc2_)
            {
               if(_loc4_.isLiving)
               {
                  _loc3_++;
               }
            }
         }
         return _loc3_;
      }
      
      public function get self() : Player
      {
         return this.findGamerbyPlayerId(PlayerManager.Instance.Self.ID);
      }
      
      public function findLivingByPlayerID(param1:int, param2:int) : Player
      {
         var _loc3_:Living = null;
         for each(_loc3_ in this.livings)
         {
            if(_loc3_ is Player && _loc3_.playerInfo)
            {
               if(_loc3_.playerInfo.ID == param1 && _loc3_.playerInfo.ZoneID == param2)
               {
                  return _loc3_ as Player;
               }
            }
         }
         return null;
      }
      
      public function removeAllMonsters() : void
      {
         var _loc2_:Living = null;
         var _loc3_:int = 0;
         var _loc1_:Array = [];
         for each(_loc2_ in this.livings)
         {
            if(!(_loc2_ is Player))
            {
               _loc1_.push(_loc2_.LivingID);
            }
         }
         for each(_loc3_ in _loc1_)
         {
            this.livings[_loc3_].dispose();
            this.livings.remove(_loc3_);
         }
      }
      
      public function removeAllTeam() : void
      {
      }
      
      public function get selfGamePlayer() : LocalPlayer
      {
         return this._selfGamePlayer;
      }
      
      public function addRoomPlayer(param1:RoomPlayer) : void
      {
         var _loc2_:int = this.roomPlayers.indexOf(param1);
         if(_loc2_ > -1)
         {
            this.removeRoomPlayer(param1.playerInfo.ZoneID,param1.playerInfo.ID);
         }
         this.roomPlayers.push(param1);
      }
      
      public function removeRoomPlayer(param1:int, param2:int) : void
      {
         var _loc3_:RoomPlayer = this.findRoomPlayer(param2,param1);
         if(_loc3_)
         {
            this.roomPlayers.splice(this.roomPlayers.indexOf(_loc3_),1);
         }
      }
      
      public function get tempPlayer() : Player
      {
         return this._tempPlayerForSettlement;
      }
      
      public function set tempPlayer(param1:Player) : void
      {
         this._tempPlayerForSettlement = param1;
      }
      
      public function findRoomPlayer(param1:int, param2:int) : RoomPlayer
      {
         var _loc3_:RoomPlayer = null;
         for each(_loc3_ in this.roomPlayers)
         {
            if(_loc3_.playerInfo != null)
            {
               if(_loc3_.playerInfo.ID == param1 && _loc3_.playerInfo.ZoneID == param2)
               {
                  return _loc3_;
               }
            }
         }
         return null;
      }
      
      public function setWind(param1:Number, param2:Boolean = false, param3:Array = null) : void
      {
         this._wind = param1;
         dispatchEvent(new GameEvent(GameEvent.WIND_CHANGED,{
            "wind":this._wind,
            "isSelfTurn":param2,
            "windNumArr":param3
         }));
      }
      
      public function get wind() : Number
      {
         return this._wind;
      }
      
      public function get hasNextMission() : Boolean
      {
         return this._hasNextMission;
      }
      
      public function set hasNextMission(param1:Boolean) : void
      {
         if(this._hasNextMission == param1)
         {
            return;
         }
         this._hasNextMission = param1;
      }
      
      public function resetResultCard() : void
      {
         this._resultCard = [];
      }
      
      public function get lastShootPos() : Point
      {
         return this._lastShootPos;
      }
      
      public function set lastShootPos(param1:Point) : void
      {
         this._lastShootPos = param1;
      }
      
      public function resetReady() : void
      {
         var _loc1_:Living = null;
         for each(_loc1_ in this.livings)
         {
            if(_loc1_ as Player && Player(_loc1_).isReady)
            {
               Player(_loc1_).isReady = false;
            }
         }
      }
      
      public function dispose() : void
      {
         var _loc1_:RoomPlayer = null;
         var _loc2_:Living = null;
         for each(_loc1_ in this.roomPlayers)
         {
            if(RoomManager.Instance.current.players.list.indexOf(_loc1_) == -1)
            {
               _loc1_.dispose();
            }
         }
         if(this.roomPlayers)
         {
            this.roomPlayers = null;
         }
         if(this.livings)
         {
            for each(_loc2_ in this.livings)
            {
               _loc2_.dispose();
               _loc2_ = null;
            }
            this.livings.clear();
         }
         if(this._resultCard)
         {
            this._resultCard = [];
         }
         this.missionInfo = null;
         if(this.loaderMap)
         {
            this.loaderMap.dispose();
         }
         if(PlayerManager.Instance.hasTempStyle)
         {
            PlayerManager.Instance.readAllTempStyleEvent();
         }
      }
      
      public function getDamageStasticInfo(param1:DictionaryData) : Dictionary
      {
         var _loc3_:Array = null;
         var _loc4_:Bomb = null;
         var _loc5_:BombAction = null;
         var _loc2_:Dictionary = new Dictionary();
         for each(_loc3_ in param1[this.self.LivingID])
         {
            for each(_loc4_ in _loc3_)
            {
               for each(_loc5_ in _loc4_.Actions)
               {
                  switch(_loc5_.type)
                  {
                     case ActionType.KILL_PLAYER:
                        if(!_loc2_[_loc5_.param1])
                        {
                           _loc2_[_loc5_.param1] = 0;
                        }
                        _loc2_[_loc5_.param1] += _loc5_.param2;
                        break;
                     case ActionType.PET:
                        if(!_loc2_[_loc5_.param1])
                        {
                           _loc2_[_loc5_.param1] = 0;
                        }
                        _loc2_[_loc5_.param1] += _loc5_.param3;
                        break;
                  }
               }
            }
         }
         return _loc2_;
      }
      
      public function getHurtStastic(param1:DictionaryData) : Dictionary
      {
         var _loc3_:* = null;
         var _loc4_:Array = null;
         var _loc5_:Bomb = null;
         var _loc6_:BombAction = null;
         var _loc2_:Dictionary = new Dictionary();
         for(_loc3_ in param1)
         {
            for each(_loc4_ in param1[_loc3_])
            {
               for each(_loc5_ in _loc4_)
               {
                  for each(_loc6_ in _loc5_.Actions)
                  {
                     if(_loc6_.param1 != this.self.LivingID)
                     {
                        continue;
                     }
                     switch(_loc6_.type)
                     {
                        case ActionType.KILL_PLAYER:
                           if(!_loc2_[_loc3_])
                           {
                              _loc2_[_loc3_] = 0;
                           }
                           _loc2_[_loc3_] += _loc6_.param2;
                           break;
                        case ActionType.PET:
                           if(!_loc2_[_loc3_])
                           {
                              _loc2_[_loc3_] = 0;
                           }
                           _loc2_[_loc3_] += _loc6_.param3;
                           break;
                     }
                  }
               }
            }
         }
         return _loc2_;
      }
      
      public function get stasticHurtList() : DictionaryData
      {
         return this._stasticHurtList;
      }
      
      public function get stasticDamageList() : DictionaryData
      {
         return this._stasticDamageList;
      }
      
      public function clearStasticInfo() : void
      {
         this._stasticDamageList.clear();
         this._stasticHurtList.clear();
      }
      
      public function get isMultiGame() : Boolean
      {
         return true;
      }
      
      public function set currentTurn(param1:int) : void
      {
         this._currentTurn = param1;
         dispatchEvent(new GameEvent(GameEvent.TURN_CHANGED,this._currentTurn));
      }
      
      public function get currentTurn() : int
      {
         return this._currentTurn;
      }
      
      public function isTurnChanged() : Boolean
      {
         if(this._lastTurn == this._currentTurn)
         {
            return false;
         }
         this._lastTurn = this._currentTurn;
         return true;
      }
      
      public function getNearestPlayer(param1:DictionaryData) : Player
      {
         var _loc2_:Player = null;
         var _loc3_:Living = null;
         for each(_loc3_ in param1)
         {
            if(_loc3_.isLiving && _loc3_ is Player)
            {
               if(_loc2_)
               {
                  if(_loc3_.getHorizonDistance(this.self) < _loc2_.getHorizonDistance(this.self))
                  {
                     _loc2_ = _loc3_ as Player;
                  }
               }
               else
               {
                  _loc2_ = _loc3_ as Player;
               }
            }
         }
         return _loc2_;
      }
      
      public function bombComplete() : void
      {
         dispatchEvent(new GameEvent(GameEvent.BOMB_COMPLETE));
      }
   }
}
