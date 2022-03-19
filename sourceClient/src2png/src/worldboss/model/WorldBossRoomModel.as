// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//worldboss.model.WorldBossRoomModel

package worldboss.model
{
    import flash.events.EventDispatcher;
    import road7th.data.DictionaryData;
    import __AS3__.vec.Vector;
    import worldboss.player.RankingPersonInfo;
    import worldboss.player.WorldBossActiveTimeInfo;
    import flash.utils.setTimeout;
    import worldboss.player.PlayerVO;
    import flash.geom.Point;
    import worldboss.event.WorldBossRoomEvent;
    import __AS3__.vec.*;

    public class WorldBossRoomModel extends EventDispatcher 
    {

        private var _players:DictionaryData;
        private var _playersBuffer:Array;
        private var _list:Vector.<RankingPersonInfo> = new Vector.<RankingPersonInfo>();
        private var _timeList:Vector.<WorldBossActiveTimeInfo> = new Vector.<WorldBossActiveTimeInfo>();
        private var _playerNameVisible:Boolean = true;
        private var _playerChatBallVisible:Boolean = true;
        private var _playerFireVisible:Boolean = true;

        public function WorldBossRoomModel()
        {
            this._players = new DictionaryData(true);
            this._playersBuffer = new Array();
        }

        public function get timeList():Vector.<WorldBossActiveTimeInfo>
        {
            return (this._timeList);
        }

        public function set timeList(_arg_1:Vector.<WorldBossActiveTimeInfo>):void
        {
            this._timeList = _arg_1;
        }

        public function get list():Vector.<RankingPersonInfo>
        {
            return (this._list);
        }

        public function set list(_arg_1:Vector.<RankingPersonInfo>):void
        {
            this._list = _arg_1;
        }

        public function get players():DictionaryData
        {
            return (this._players);
        }

        public function addPlayer(_arg_1:PlayerVO):void
        {
            this._playersBuffer.push(_arg_1);
            setTimeout(this.addPlayerToMap, (500 + (this._playersBuffer.length * 200)));
        }

        private function addPlayerToMap():void
        {
            if (((!(this._players)) || (!(this._playersBuffer[0]))))
            {
                return;
            };
            this._players.add(this._playersBuffer[0].playerInfo.ID, this._playersBuffer[0]);
            this._playersBuffer.shift();
        }

        public function updatePlayerStauts(_arg_1:int, _arg_2:int, _arg_3:Point):void
        {
            var _local_4:int;
            var _local_5:PlayerVO;
            if (((this._playersBuffer) && (this._playersBuffer.length > 0)))
            {
                _local_4 = 0;
                while (_local_4 < this._playersBuffer.length)
                {
                    if (_arg_1 == this._playersBuffer[_local_4].playerInfo.ID)
                    {
                        _local_5 = (this._playersBuffer[_local_4] as PlayerVO);
                        _local_5.playerStauts = _arg_2;
                        _local_5.playerPos = _arg_3;
                        return;
                    };
                    _local_4++;
                };
            };
        }

        public function removePlayer(_arg_1:int):void
        {
            this._players.remove(_arg_1);
        }

        public function getPlayers():DictionaryData
        {
            return (this._players);
        }

        public function getPlayerFromID(_arg_1:int):PlayerVO
        {
            return (this._players[_arg_1]);
        }

        public function reset():void
        {
            this.dispose();
            this._players = new DictionaryData(true);
        }

        public function get playerNameVisible():Boolean
        {
            return (this._playerNameVisible);
        }

        public function set playerNameVisible(_arg_1:Boolean):void
        {
            this._playerNameVisible = _arg_1;
            dispatchEvent(new WorldBossRoomEvent(WorldBossRoomEvent.PLAYER_NAME_VISIBLE));
        }

        public function dispose():void
        {
            this._players = null;
            this._playersBuffer = null;
        }


    }
}//package worldboss.model

