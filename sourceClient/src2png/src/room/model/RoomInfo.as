// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//room.model.RoomInfo

package room.model
{
    import flash.events.EventDispatcher;
    import road7th.data.DictionaryData;
    import ddt.events.RoomEvent;
    import ddt.manager.PlayerManager;
    import flash.events.Event;
    import ddt.manager.MapManager;
    import ddt.manager.LanguageMgr;

    public class RoomInfo extends EventDispatcher 
    {

        public static const MATCH_ROOM:int = 0;
        public static const CHALLENGE_ROOM:int = 1;
        public static const DUNGEON_ROOM:int = 4;
        public static const MULTI_DUNGEON:int = 20;
        public static const FRESHMAN_ROOM:int = 10;
        public static const WORLD_BOSS_FIGHT:int = 14;
        public static const SINGLE_DUNGEON:int = 15;
        public static const SINGLE_ROOM:int = 16;
        public static const CONSORTION_MONSTER:int = 17;
        public static const HIJACK_CAR:int = 18;
        public static const ARENA:int = 19;
        public static const MULTI_MATCH:int = 21;
        public static const FIGHT_ROBOT:int = 22;
        public static const FREE_MODE:int = 0;
        public static const GUILD_MODE:int = 1;
        public static const BOTH_MODE:int = 4;
        public static const MATCH_NPC:int = 9;
        public static const EASY:int = 0;
        public static const NORMAL:int = 1;
        public static const HARD:int = 2;
        public static const HERO:int = 3;
        public static const DUNGEONTYPE_NO:int = 1;
        public static const DUNGEONTYPE_SP:int = 2;
        public static const NULL_ROOM:int = -100;
        public static const CHANGE_DUNGEON:int = 7;

        public var ID:int;
        public var Name:String = "团队作战,乐趣无限!";
        public var maxViewerCnt:int = 2;
        public var isWithinLeageTime:Boolean;
        private var _type:int;
        private var _players:DictionaryData;
        private var _gameMode:int;
        private var _mapId:int;
        private var _timeType:int = -1;
        private var _hardLevel:int = 1;
        private var _levelLimits:int;
        private var _totalPlayer:int;
        private var _viewerCnt:int;
        private var _placeCount:int;
        public var isLocked:Boolean;
        private var _started:Boolean;
        private var _isCrossZone:Boolean;
        private var _isPlaying:Boolean;
        private var _isLocked:Boolean;
        private var _changedCount:int;
        private var _isOpenBoss:Boolean;
        private var _pic:String;
        private var _roomPass:String = "";
        private var _dungeonType:int;
        private var _placesState:Array = [-1, -1, -1, -1, -1, -1, -1, -1];
        private var _defyInfo:Array;

        public function RoomInfo()
        {
            this._players = new DictionaryData();
        }

        public function get pic():String
        {
            return (this._pic);
        }

        public function set pic(_arg_1:String):void
        {
            this._pic = _arg_1;
        }

        public function get isOpenBoss():Boolean
        {
            return (this._isOpenBoss);
        }

        public function set isOpenBoss(_arg_1:Boolean):void
        {
            if (this._isOpenBoss == _arg_1)
            {
                return;
            };
            this._isOpenBoss = _arg_1;
            dispatchEvent(new RoomEvent(RoomEvent.OPEN_BOSS_CHANGED, this._isOpenBoss));
        }

        public function get roomPass():String
        {
            return (this._roomPass);
        }

        public function set roomPass(_arg_1:String):void
        {
            if (this._roomPass == _arg_1)
            {
                return;
            };
            this._roomPass = _arg_1;
        }

        public function get roomName():String
        {
            return (this.Name);
        }

        public function set roomName(_arg_1:String):void
        {
            if (this.Name == _arg_1)
            {
                return;
            };
            this.Name = _arg_1;
            dispatchEvent(new RoomEvent(RoomEvent.ROOM_NAME_CHANGED));
        }

        public function get defyInfo():Array
        {
            return (this._defyInfo);
        }

        public function set defyInfo(_arg_1:Array):void
        {
            this._defyInfo = _arg_1;
        }

        public function get placesState():Array
        {
            return (this._placesState);
        }

        public function updatePlaceState(_arg_1:Array):void
        {
            var _local_2:Boolean;
            var _local_10:RoomPlayer;
            var _local_3:int;
            var _local_4:int = ((this.type == CHALLENGE_ROOM) ? 6 : 3);
            var _local_5:int = -100;
            var _local_6:int;
            while (_local_6 < 8)
            {
                if (this._placesState[_local_6] != _arg_1[_local_6])
                {
                    if (_local_6 >= 6)
                    {
                        if (_arg_1[_local_6] != -1)
                        {
                            _local_10 = this.findPlayerByID(_arg_1[_local_6]);
                            if (_local_10 != null)
                            {
                                _local_10.place = _local_6;
                            };
                        }
                        else
                        {
                            if (this._placesState[_local_6] != -1)
                            {
                                _local_10 = this.findPlayerByID(this._placesState[_local_6]);
                                if (_local_10 != null)
                                {
                                    if (_local_5 != -100)
                                    {
                                        _local_10.place = _local_5;
                                    };
                                };
                            };
                        };
                    };
                    _local_5 = _local_6;
                    _local_2 = true;
                };
                _local_6++;
            };
            var _local_7:int;
            while (_local_7 < _local_4)
            {
                if (_arg_1[_local_7] == -1)
                {
                    _local_3++;
                };
                _local_7++;
            };
            var _local_8:int;
            switch (this._type)
            {
                case RoomInfo.MATCH_ROOM:
                    _local_8 = 8;
                    break;
                case RoomInfo.CHALLENGE_ROOM:
                case RoomInfo.DUNGEON_ROOM:
                case RoomInfo.MULTI_DUNGEON:
                    _local_8 = 8;
                    break;
            };
            var _local_9:int = 6;
            while (_local_9 < _local_8)
            {
                if (_arg_1[_local_9] == -1)
                {
                    _local_3++;
                };
                _local_9++;
            };
            this.placeCount = _local_3;
            if (_local_2)
            {
                this._placesState = _arg_1;
                dispatchEvent(new RoomEvent(RoomEvent.ROOMPLACE_CHANGED));
            };
        }

        public function updatePlayerState(_arg_1:Array):void
        {
            var _local_2:RoomPlayer;
            for each (_local_2 in this.players)
            {
                _local_2.isReady = (_arg_1[_local_2.place] == 1);
                _local_2.isHost = (_arg_1[_local_2.place] == 2);
            };
            dispatchEvent(new RoomEvent(RoomEvent.PLAYER_STATE_CHANGED));
        }

        public function setPlayerReadyState(_arg_1:int, _arg_2:Boolean):void
        {
            this.findPlayerByID(_arg_1).isReady = _arg_2;
            dispatchEvent(new RoomEvent(RoomEvent.PLAYER_STATE_CHANGED));
        }

        public function updatePlayerTeam(_arg_1:int, _arg_2:int, _arg_3:int):void
        {
            var _local_4:RoomPlayer = this._players[_arg_1];
            if (_local_4)
            {
                _local_4.team = _arg_2;
                _local_4.place = _arg_3;
            };
            dispatchEvent(new RoomEvent(RoomEvent.ROOMPLACE_CHANGED));
        }

        public function addPlayer(_arg_1:RoomPlayer):void
        {
            this._players.add(_arg_1.playerInfo.ID, _arg_1);
            dispatchEvent(new RoomEvent(RoomEvent.ADD_PLAYER, _arg_1));
        }

        public function removePlayer(_arg_1:int, _arg_2:int):RoomPlayer
        {
            if (_arg_1 != PlayerManager.Instance.Self.ZoneID)
            {
                return (null);
            };
            var _local_3:RoomPlayer = this.players[_arg_2];
            if (_local_3)
            {
                this._players.remove(_arg_2);
                dispatchEvent(new RoomEvent(RoomEvent.REMOVE_PLAYER, _local_3));
            };
            return (_local_3);
        }

        public function findPlayerByID(_arg_1:int, _arg_2:int=-1):RoomPlayer
        {
            return (this._players[_arg_1] as RoomPlayer);
        }

        public function findPlayerByPlace(_arg_1:int):RoomPlayer
        {
            var _local_2:RoomPlayer;
            var _local_3:RoomPlayer;
            for each (_local_3 in this.players)
            {
                if (_local_3.place == _arg_1)
                {
                    _local_2 = _local_3;
                    break;
                };
            };
            return (_local_2);
        }

        public function dispose():void
        {
            var _local_1:RoomPlayer;
            for each (_local_1 in this._players)
            {
                _local_1.dispose();
            };
            this._players.clear();
            this._players = null;
            this._type = NULL_ROOM;
            this.ID = -1;
        }

        public function get players():DictionaryData
        {
            return (this._players);
        }

        public function startPickup():void
        {
            this.started = true;
        }

        public function cancelPickup():void
        {
            this.started = false;
        }

        public function pickupFailed():void
        {
            this.started = false;
        }

        public function get selfRoomPlayer():RoomPlayer
        {
            return (this.findPlayerByID(PlayerManager.Instance.Self.ID));
        }

        public function get type():int
        {
            return (this._type);
        }

        public function set type(_arg_1:int):void
        {
            if (this._type == _arg_1)
            {
                return;
            };
            this._type = _arg_1;
            dispatchEvent(new Event(Event.CHANGE));
        }

        public function isYellowBg():Boolean
        {
            return (((this._type == DUNGEON_ROOM) || (this._type == MULTI_DUNGEON)) || (this._type == MATCH_ROOM));
        }

        public function canShowTitle():Boolean
        {
            return ((((this._type == SINGLE_DUNGEON) || (this._type == CHANGE_DUNGEON)) || (this._type == DUNGEON_ROOM)) || (this._type == MULTI_DUNGEON));
        }

        public function isPVP():Boolean
        {
            return ((this._type < 2) || (this._type == RoomInfo.MULTI_MATCH));
        }

        public function get gameMode():int
        {
            return (this._gameMode);
        }

        public function set gameMode(_arg_1:int):void
        {
            if (this._gameMode == _arg_1)
            {
                return;
            };
            this._gameMode = _arg_1;
            dispatchEvent(new RoomEvent(RoomEvent.GAME_MODE_CHANGE));
        }

        public function canPlayGuidMode():Boolean
        {
            var _local_1:int;
            var _local_3:RoomPlayer;
            var _local_4:RoomPlayer;
            if ((this._players.length - this.currentViewerCnt) <= 1)
            {
                return (false);
            };
            if (this.selfRoomPlayer.isViewer)
            {
                for each (_local_4 in this.players)
                {
                    if (_local_4 != this.selfRoomPlayer)
                    {
                        _local_1 = _local_4.playerInfo.ConsortiaID;
                        break;
                    };
                };
            }
            else
            {
                _local_1 = this.selfRoomPlayer.playerInfo.ConsortiaID;
            };
            if (_local_1 <= 0)
            {
                return (false);
            };
            var _local_2:Boolean = true;
            for each (_local_3 in this.players)
            {
                if (!_local_3.isViewer)
                {
                    if (_local_3.playerInfo.ConsortiaID != _local_1)
                    {
                        _local_2 = false;
                        break;
                    };
                };
            };
            return (_local_2);
        }

        public function isAllReady():Boolean
        {
            var _local_2:RoomPlayer;
            var _local_1:Boolean = true;
            if (this.type == CHALLENGE_ROOM)
            {
                if (this._players.length == 1)
                {
                    return (false);
                };
            };
            for each (_local_2 in this._players)
            {
                if ((((!(_local_2.isReady)) && (!(_local_2.isHost))) && (!(_local_2.isViewer))))
                {
                    _local_1 = false;
                    break;
                };
            };
            return (_local_1);
        }

        public function getDifficulty(_arg_1:int):String
        {
            switch (_arg_1)
            {
                case 0:
                    if (this._type == MapManager.FIGHT_LIB)
                    {
                        return (LanguageMgr.GetTranslation("tank.fightLib.GameOver.Title.Easy"));
                    };
                    return (LanguageMgr.GetTranslation("tank.room.difficulty.simple"));
                case 1:
                    if (this._type == MapManager.FIGHT_LIB)
                    {
                        return (LanguageMgr.GetTranslation("tank.fightLib.GameOver.Title.Nomal"));
                    };
                    return (LanguageMgr.GetTranslation("tank.room.difficulty.normal"));
                case 2:
                    if (this._type == MapManager.FIGHT_LIB)
                    {
                        return (LanguageMgr.GetTranslation("tank.fightLib.GameOver.Title.Difficult"));
                    };
                    return (LanguageMgr.GetTranslation("tank.room.difficulty.hard"));
                case 3:
                    return (LanguageMgr.GetTranslation("tank.room.difficulty.hero"));
            };
            return ("");
        }

        public function get mapId():int
        {
            return (this._mapId);
        }

        public function set mapId(_arg_1:int):void
        {
            if (this._mapId == _arg_1)
            {
                return;
            };
            this._mapId = _arg_1;
            dispatchEvent(new RoomEvent(RoomEvent.MAP_CHANGED));
        }

        public function get timeType():int
        {
            return (this._timeType);
        }

        public function set timeType(_arg_1:int):void
        {
            if (this._timeType == _arg_1)
            {
                return;
            };
            this._timeType = _arg_1;
            dispatchEvent(new RoomEvent(RoomEvent.MAP_TIME_CHANGED));
        }

        public function get hardLevel():int
        {
            return (this._hardLevel);
        }

        public function set hardLevel(_arg_1:int):void
        {
            if (this._hardLevel == _arg_1)
            {
                return;
            };
            this._hardLevel = _arg_1;
            dispatchEvent(new RoomEvent(RoomEvent.HARD_LEVEL_CHANGED));
        }

        public function get levelLimits():int
        {
            return (this._levelLimits);
        }

        public function set levelLimits(_arg_1:int):void
        {
            this._levelLimits = _arg_1;
        }

        public function get totalPlayer():int
        {
            return (this._totalPlayer);
        }

        public function set totalPlayer(_arg_1:int):void
        {
            if (this._totalPlayer == _arg_1)
            {
                return;
            };
            this._totalPlayer = _arg_1;
            dispatchEvent(new Event(Event.CHANGE));
        }

        public function get currentViewerCnt():int
        {
            var _local_2:RoomPlayer;
            var _local_1:int;
            for each (_local_2 in this._players)
            {
                if (_local_2.isViewer)
                {
                    _local_1++;
                };
            };
            return (_local_1);
        }

        public function get viewerCnt():int
        {
            return (this._viewerCnt);
        }

        public function set viewerCnt(_arg_1:int):void
        {
            if (this._viewerCnt == _arg_1)
            {
                return;
            };
            this._viewerCnt = _arg_1;
            dispatchEvent(new Event(Event.CHANGE));
        }

        public function get placeCount():int
        {
            return (this._placeCount);
        }

        public function set placeCount(_arg_1:int):void
        {
            if (this._placeCount == _arg_1)
            {
                return;
            };
            this._placeCount = _arg_1;
            dispatchEvent(new RoomEvent(RoomEvent.PLACE_COUNT_CHANGED));
        }

        public function get started():Boolean
        {
            return (this._started);
        }

        public function set started(_arg_1:Boolean):void
        {
            if (this._started == _arg_1)
            {
                return;
            };
            this._started = _arg_1;
            dispatchEvent(new RoomEvent(RoomEvent.STARTED_CHANGED));
        }

        public function get isCrossZone():Boolean
        {
            return (this._isCrossZone);
        }

        public function set isCrossZone(_arg_1:Boolean):void
        {
            if (this._isCrossZone == _arg_1)
            {
                return;
            };
            this._isCrossZone = _arg_1;
            dispatchEvent(new RoomEvent(RoomEvent.ALLOW_CROSS_CHANGE));
        }

        public function resetStates():void
        {
            var _local_1:RoomPlayer;
            for each (_local_1 in this._players)
            {
                _local_1.isReady = false;
            };
            this._started = false;
        }

        public function get isPlaying():Boolean
        {
            return (this._isPlaying);
        }

        public function set isPlaying(_arg_1:Boolean):void
        {
            this._isPlaying = _arg_1;
        }

        public function get IsLocked():Boolean
        {
            return (this._isLocked);
        }

        public function set IsLocked(_arg_1:Boolean):void
        {
            this._isLocked = _arg_1;
        }

        public function get dungeonType():int
        {
            return (this._dungeonType);
        }

        public function set dungeonType(_arg_1:int):void
        {
            if (this._dungeonType == _arg_1)
            {
                return;
            };
            this._dungeonType = _arg_1;
        }

        public function get isDungeonType():Boolean
        {
            return (((RoomInfo.DUNGEON_ROOM == this._type) || (RoomInfo.MULTI_DUNGEON == this._type)) || (RoomInfo.SINGLE_DUNGEON == this._type));
        }


    }
}//package room.model

