// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//game.model.GameInfo

package game.model
{
    import flash.events.EventDispatcher;
    import ddt.events.CrazyTankSocketEvent;
    import ddt.loader.MapLoader;
    import road7th.data.DictionaryData;
    import ddt.data.map.MissionInfo;
    import flash.geom.Point;
    import game.GameManager;
    import room.model.RoomPlayer;
    import __AS3__.vec.Vector;
    import ddt.manager.PlayerManager;
    import ddt.events.GameEvent;
    import room.RoomManager;
    import game.view.Bomb;
    import game.objects.BombAction;
    import flash.utils.Dictionary;
    import game.objects.ActionType;
    import __AS3__.vec.*;

    public class GameInfo extends EventDispatcher 
    {

        public static const ADD_ROOM_PLAYER:String = "addRoomPlayer";
        public static const REMOVE_ROOM_PLAYER:String = "removeRoomPlayer";
        public static const DAMAGE_TYPE_LIST:Array = [0, 60, 80, 80, 80, 80, 80];

        private var _mapIndex:int = 1305;
        public var roomType:int;
        public var showAllCard:Array = new Array();
        public var startEvent:CrazyTankSocketEvent;
        public var GainRiches:int;
        public var PlayerCount:int;
        public var startPlayer:int;
        public var hasNextSession:Boolean;
        public var neededMovies:Array = new Array();
        public var neededPetSkillResource:Array = new Array();
        private var _selfGamePlayer:LocalPlayer;
        public var roomPlayers:Array = [];
        public var timeType:int;
        public var maxTime:int;
        public var loaderMap:MapLoader;
        public var livings:DictionaryData = new DictionaryData();
        private var _teams:DictionaryData = new DictionaryData();
        public var viewers:DictionaryData = new DictionaryData();
        public var currentLiving:Living;
        private var _gameMode:int;
        private var _resultCard:Array = [];
        private var _missionInfo:MissionInfo;
        public var missionCount:int;
        public var gameOverNpcMovies:Array = [];
        private var _tempPlayerForSettlement:Player;
        private var _wind:Number = 0;
        private var _hasNextMission:Boolean;
        private var _lastShootPos:Point;
        private var _stasticHurtList:DictionaryData = new DictionaryData();
        private var _stasticDamageList:DictionaryData = new DictionaryData();
        private var _currentTurn:int;
        private var _lastTurn:int;


        public function get mapIndex():int
        {
            return (this._mapIndex);
        }

        public function set mapIndex(_arg_1:int):void
        {
            this._mapIndex = _arg_1;
        }

        public function get teams():DictionaryData
        {
            return (this._teams);
        }

        public function set teams(_arg_1:DictionaryData):void
        {
            this._teams = _arg_1;
        }

        public function get currentTeam():int
        {
            return ((this.currentLiving) ? this.currentLiving.team : 0);
        }

        public function set gameMode(_arg_1:int):void
        {
            this._gameMode = _arg_1;
        }

        public function get gameMode():int
        {
            return (this._gameMode);
        }

        public function get resultCard():Array
        {
            return (this._resultCard);
        }

        public function set resultCard(_arg_1:Array):void
        {
            this._resultCard = _arg_1;
        }

        public function get missionInfo():MissionInfo
        {
            return (this._missionInfo);
        }

        public function set missionInfo(_arg_1:MissionInfo):void
        {
            this._missionInfo = _arg_1;
        }

        public function resetBossCardCnt():void
        {
            var _local_1:Living;
            var _local_2:Player;
            for each (_local_1 in this.livings)
            {
                _local_2 = (_local_1 as Player);
                if (_local_2)
                {
                    _local_2.BossCardCount = 0;
                    _local_2.GetCardCount = 0;
                };
            };
        }

        public function addGamePlayer(_arg_1:Living):void
        {
            var _local_2:Living = this.livings[_arg_1.LivingID];
            if (_local_2)
            {
                _local_2.dispose();
            };
            if ((_arg_1 is LocalPlayer))
            {
                this._selfGamePlayer = (_arg_1 as LocalPlayer);
            };
            this.livings.add(_arg_1.LivingID, _arg_1);
            this.addTeamPlayer(_arg_1);
        }

        public function addGameViewer(_arg_1:Living):void
        {
            var _local_2:Living = this.viewers[_arg_1.playerInfo.ID];
            if (_local_2)
            {
                _local_2.dispose();
            };
            if ((_arg_1 is LocalPlayer))
            {
                this._selfGamePlayer = (_arg_1 as LocalPlayer);
            };
            this.viewers.add(_arg_1.playerInfo.ID, _arg_1);
        }

        public function viewerToLiving(_arg_1:int):void
        {
            var _local_2:Living = this.viewers[_arg_1];
            if (_local_2)
            {
                this.viewers.remove(_arg_1);
                if ((_local_2 is LocalPlayer))
                {
                    this._selfGamePlayer = (_local_2 as LocalPlayer);
                };
                this.livings.add(_local_2.LivingID, _local_2);
                this.addTeamPlayer(_local_2);
            };
        }

        public function livingToViewer(_arg_1:int, _arg_2:int):void
        {
            var _local_3:Living = this.findLivingByPlayerID(_arg_1, _arg_2);
            if (_local_3)
            {
                this.livings.remove(_local_3.LivingID);
                this.removeTeamPlayer(_local_3);
                if ((_local_3 is LocalPlayer))
                {
                    this._selfGamePlayer = (_local_3 as LocalPlayer);
                };
                this.viewers.add(_arg_1, _local_3);
            };
        }

        public function addTeamPlayer(_arg_1:Living):void
        {
            var _local_2:DictionaryData = new DictionaryData();
            if (this.teams[_arg_1.team] == null)
            {
                _local_2 = new DictionaryData();
                this.teams[_arg_1.team] = _local_2;
            }
            else
            {
                _local_2 = this.teams[_arg_1.team];
            };
            if (_local_2[_arg_1.LivingID] == null)
            {
                _local_2.add(_arg_1.LivingID, _arg_1);
            };
        }

        public function removeTeamPlayer(_arg_1:Living):void
        {
            var _local_3:int;
            var _local_4:Player;
            var _local_2:DictionaryData = this.teams[_arg_1.team];
            if (((_local_2) && (_local_2[_arg_1.LivingID])))
            {
                _local_2.remove(_arg_1.LivingID);
            };
            if (_arg_1.team != this.selfGamePlayer.team)
            {
                _local_3 = 0;
                for each (_local_4 in _local_2)
                {
                    _local_3++;
                };
                if (_local_3 == 0)
                {
                    this._tempPlayerForSettlement = (_arg_1 as Player);
                };
            };
        }

        public function setSelfGamePlayer(_arg_1:Living):void
        {
            this._selfGamePlayer = (_arg_1 as LocalPlayer);
        }

        public function removeGamePlayer(_arg_1:int):Living
        {
            var _local_2:Living = this.livings[_arg_1];
            if (_local_2)
            {
                this.removeTeamPlayer(_local_2);
                this.livings.remove(_arg_1);
            };
            return (_local_2);
        }

        public function removeGamePlayerByPlayerID(_arg_1:int, _arg_2:int):void
        {
            var _local_3:Living;
            var _local_4:Living;
            for each (_local_3 in this.livings)
            {
                if (((_local_3 is Player) && (_local_3.playerInfo)))
                {
                    if (((_local_3.playerInfo.ZoneID == _arg_1) && (_local_3.playerInfo.ID == _arg_2)))
                    {
                        this.removeGamePlayer(_local_3.LivingID);
                        if (((!(GameManager.Instance.Current.gameMode == GameModeType.MULTI_DUNGEON)) || (!(GameManager.Instance.Current.gameMode == GameModeType.MULTI_MATCH))))
                        {
                            _local_3.dispose();
                        };
                    };
                };
            };
            for each (_local_4 in this.viewers)
            {
                if (((_local_4.playerInfo.ZoneID == _arg_1) && (_local_4.playerInfo.ID == _arg_2)))
                {
                    this.viewers.remove(_local_4.playerInfo.ID);
                    _local_4.dispose();
                };
            };
        }

        public function isAllReady():Boolean
        {
            var _local_2:Player;
            var _local_1:Boolean = true;
            for each (_local_2 in this.livings)
            {
                if (_local_2.isReady == false)
                {
                    _local_1 = false;
                    break;
                };
            };
            return (_local_1);
        }

        public function findPlayer(_arg_1:int):Player
        {
            return (this.livings[_arg_1] as Player);
        }

        public function findPlayerByPlayerID(_arg_1:int):Player
        {
            var _local_2:Living;
            for each (_local_2 in this.livings)
            {
                if (((_local_2.isPlayer()) && (_local_2.playerInfo.ID == _arg_1)))
                {
                    return (_local_2 as Player);
                };
            };
            return (null);
        }

        public function findGamerbyPlayerId(_arg_1:int):Player
        {
            var _local_2:Living;
            var _local_3:Living;
            for each (_local_2 in this.livings)
            {
                if ((((_local_2) && (_local_2.isPlayer())) && (_local_2.playerInfo.ID == _arg_1)))
                {
                    return (_local_2 as Player);
                };
            };
            for each (_local_3 in this.viewers)
            {
                if (((_local_3) && (_local_3.playerInfo.ID == _arg_1)))
                {
                    return (_local_3 as Player);
                };
            };
            return (null);
        }

        public function get haveAllias():Boolean
        {
            var _local_1:Living;
            for each (_local_1 in this.livings)
            {
                if (((_local_1.isLiving) && (_local_1.team == this.selfGamePlayer.team)))
                {
                    return (true);
                };
            };
            return (false);
        }

        public function get allias():Vector.<Player>
        {
            var _local_3:RoomPlayer;
            var _local_4:Player;
            var _local_1:Vector.<Player> = new Vector.<Player>();
            var _local_2:int;
            while (_local_2 < this.roomPlayers.length)
            {
                _local_3 = (this.roomPlayers[_local_2] as RoomPlayer);
                if (_local_3)
                {
                    _local_4 = this.findPlayerByPlayerID(_local_3.playerInfo.ID);
                    if (((((_local_4) && (_local_4.team == this.selfGamePlayer.team)) && (!(_local_4 == this.selfGamePlayer))) && (_local_4.expObj)))
                    {
                        _local_1.push(_local_4);
                    };
                };
                _local_2++;
            };
            return (_local_1);
        }

        public function findLiving(_arg_1:int):Living
        {
            return (this.livings[_arg_1]);
        }

        public function findTeam(_arg_1:int):DictionaryData
        {
            return (this.teams[_arg_1]);
        }

        public function getTeamLiveCount(_arg_1:int):int
        {
            var _local_4:Living;
            var _local_2:DictionaryData = this.findTeam(_arg_1);
            var _local_3:int;
            if (_local_2)
            {
                for each (_local_4 in _local_2)
                {
                    if (_local_4.isLiving)
                    {
                        _local_3++;
                    };
                };
            };
            return (_local_3);
        }

        public function get self():Player
        {
            return (this.findGamerbyPlayerId(PlayerManager.Instance.Self.ID));
        }

        public function findLivingByPlayerID(_arg_1:int, _arg_2:int):Player
        {
            var _local_3:Living;
            for each (_local_3 in this.livings)
            {
                if (((_local_3 is Player) && (_local_3.playerInfo)))
                {
                    if (((_local_3.playerInfo.ID == _arg_1) && (_local_3.playerInfo.ZoneID == _arg_2)))
                    {
                        return (_local_3 as Player);
                    };
                };
            };
            return (null);
        }

        public function removeAllMonsters():void
        {
            var _local_2:Living;
            var _local_3:int;
            var _local_1:Array = [];
            for each (_local_2 in this.livings)
            {
                if ((!(_local_2 is Player)))
                {
                    _local_1.push(_local_2.LivingID);
                };
            };
            for each (_local_3 in _local_1)
            {
                this.livings[_local_3].dispose();
                this.livings.remove(_local_3);
            };
        }

        public function removeAllTeam():void
        {
        }

        public function get selfGamePlayer():LocalPlayer
        {
            return (this._selfGamePlayer);
        }

        public function addRoomPlayer(_arg_1:RoomPlayer):void
        {
            var _local_2:int = this.roomPlayers.indexOf(_arg_1);
            if (_local_2 > -1)
            {
                this.removeRoomPlayer(_arg_1.playerInfo.ZoneID, _arg_1.playerInfo.ID);
            };
            this.roomPlayers.push(_arg_1);
        }

        public function removeRoomPlayer(_arg_1:int, _arg_2:int):void
        {
            var _local_3:RoomPlayer = this.findRoomPlayer(_arg_2, _arg_1);
            if (_local_3)
            {
                this.roomPlayers.splice(this.roomPlayers.indexOf(_local_3), 1);
            };
        }

        public function get tempPlayer():Player
        {
            return (this._tempPlayerForSettlement);
        }

        public function set tempPlayer(_arg_1:Player):void
        {
            this._tempPlayerForSettlement = _arg_1;
        }

        public function findRoomPlayer(_arg_1:int, _arg_2:int):RoomPlayer
        {
            var _local_3:RoomPlayer;
            for each (_local_3 in this.roomPlayers)
            {
                if (_local_3.playerInfo != null)
                {
                    if (((_local_3.playerInfo.ID == _arg_1) && (_local_3.playerInfo.ZoneID == _arg_2)))
                    {
                        return (_local_3);
                    };
                };
            };
            return (null);
        }

        public function setWind(_arg_1:Number, _arg_2:Boolean=false, _arg_3:Array=null):void
        {
            this._wind = _arg_1;
            dispatchEvent(new GameEvent(GameEvent.WIND_CHANGED, {
                "wind":this._wind,
                "isSelfTurn":_arg_2,
                "windNumArr":_arg_3
            }));
        }

        public function get wind():Number
        {
            return (this._wind);
        }

        public function get hasNextMission():Boolean
        {
            return (this._hasNextMission);
        }

        public function set hasNextMission(_arg_1:Boolean):void
        {
            if (this._hasNextMission == _arg_1)
            {
                return;
            };
            this._hasNextMission = _arg_1;
        }

        public function resetResultCard():void
        {
            this._resultCard = [];
        }

        public function get lastShootPos():Point
        {
            return (this._lastShootPos);
        }

        public function set lastShootPos(_arg_1:Point):void
        {
            this._lastShootPos = _arg_1;
        }

        public function resetReady():void
        {
            var _local_1:Living;
            for each (_local_1 in this.livings)
            {
                if (((_local_1 as Player) && (Player(_local_1).isReady)))
                {
                    Player(_local_1).isReady = false;
                };
            };
        }

        public function dispose():void
        {
            var _local_1:RoomPlayer;
            var _local_2:Living;
            for each (_local_1 in this.roomPlayers)
            {
                if (RoomManager.Instance.current.players.list.indexOf(_local_1) == -1)
                {
                    _local_1.dispose();
                };
            };
            if (this.roomPlayers)
            {
                this.roomPlayers = null;
            };
            if (this.livings)
            {
                for each (_local_2 in this.livings)
                {
                    _local_2.dispose();
                    _local_2 = null;
                };
                this.livings.clear();
            };
            if (this._resultCard)
            {
                this._resultCard = [];
            };
            this.missionInfo = null;
            if (this.loaderMap)
            {
                this.loaderMap.dispose();
            };
            if (PlayerManager.Instance.hasTempStyle)
            {
                PlayerManager.Instance.readAllTempStyleEvent();
            };
        }

        public function getDamageStasticInfo(_arg_1:DictionaryData):Dictionary
        {
            var _local_3:Array;
            var _local_4:Bomb;
            var _local_5:BombAction;
            var _local_2:Dictionary = new Dictionary();
            for each (_local_3 in _arg_1[this.self.LivingID])
            {
                for each (_local_4 in _local_3)
                {
                    for each (_local_5 in _local_4.Actions)
                    {
                        switch (_local_5.type)
                        {
                            case ActionType.KILL_PLAYER:
                                if ((!(_local_2[_local_5.param1])))
                                {
                                    _local_2[_local_5.param1] = 0;
                                };
                                _local_2[_local_5.param1] = (_local_2[_local_5.param1] + _local_5.param2);
                                break;
                            case ActionType.PET:
                                if ((!(_local_2[_local_5.param1])))
                                {
                                    _local_2[_local_5.param1] = 0;
                                };
                                _local_2[_local_5.param1] = (_local_2[_local_5.param1] + _local_5.param3);
                                break;
                        };
                    };
                };
            };
            return (_local_2);
        }

        public function getHurtStastic(_arg_1:DictionaryData):Dictionary
        {
            var _local_3:String;
            var _local_4:Array;
            var _local_5:Bomb;
            var _local_6:BombAction;
            var _local_2:Dictionary = new Dictionary();
            for (_local_3 in _arg_1)
            {
                for each (_local_4 in _arg_1[_local_3])
                {
                    for each (_local_5 in _local_4)
                    {
                        for each (_local_6 in _local_5.Actions)
                        {
                            if (_local_6.param1 == this.self.LivingID)
                            {
                                switch (_local_6.type)
                                {
                                    case ActionType.KILL_PLAYER:
                                        if ((!(_local_2[_local_3])))
                                        {
                                            _local_2[_local_3] = 0;
                                        };
                                        _local_2[_local_3] = (_local_2[_local_3] + _local_6.param2);
                                        break;
                                    case ActionType.PET:
                                        if ((!(_local_2[_local_3])))
                                        {
                                            _local_2[_local_3] = 0;
                                        };
                                        _local_2[_local_3] = (_local_2[_local_3] + _local_6.param3);
                                        break;
                                };
                            };
                        };
                    };
                };
            };
            return (_local_2);
        }

        public function get stasticHurtList():DictionaryData
        {
            return (this._stasticHurtList);
        }

        public function get stasticDamageList():DictionaryData
        {
            return (this._stasticDamageList);
        }

        public function clearStasticInfo():void
        {
            this._stasticDamageList.clear();
            this._stasticHurtList.clear();
        }

        public function get isMultiGame():Boolean
        {
            return (true);
        }

        public function set currentTurn(_arg_1:int):void
        {
            this._currentTurn = _arg_1;
            dispatchEvent(new GameEvent(GameEvent.TURN_CHANGED, this._currentTurn));
        }

        public function get currentTurn():int
        {
            return (this._currentTurn);
        }

        public function isTurnChanged():Boolean
        {
            if (this._lastTurn == this._currentTurn)
            {
                return (false);
            };
            this._lastTurn = this._currentTurn;
            return (true);
        }

        public function getNearestPlayer(_arg_1:DictionaryData):Player
        {
            var _local_2:Player;
            var _local_3:Living;
            for each (_local_3 in _arg_1)
            {
                if (((_local_3.isLiving) && (_local_3 is Player)))
                {
                    if (_local_2)
                    {
                        if (_local_3.getHorizonDistance(this.self) < _local_2.getHorizonDistance(this.self))
                        {
                            _local_2 = (_local_3 as Player);
                        };
                    }
                    else
                    {
                        _local_2 = (_local_3 as Player);
                    };
                };
            };
            return (_local_2);
        }

        public function bombComplete():void
        {
            dispatchEvent(new GameEvent(GameEvent.BOMB_COMPLETE));
        }


    }
}//package game.model

