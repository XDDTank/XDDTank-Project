// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//SingleDungeon.model.SingleDungeonWalkMapModel

package SingleDungeon.model
{
    import flash.events.EventDispatcher;
    import road7th.data.DictionaryData;
    import flash.utils.setTimeout;
    import flash.geom.Point;

    public class SingleDungeonWalkMapModel extends EventDispatcher 
    {

        private var _players:DictionaryData;
        private var _playersBuffer:Array;
        private var _mapObjects:DictionaryData;
        public var _mapSceneModel:MapSceneModel;
        private var _playerNameVisible:Boolean = true;
        private var _playerChatBallVisible:Boolean = true;
        private var _playerFireVisible:Boolean = true;

        public function SingleDungeonWalkMapModel()
        {
            this._players = new DictionaryData(true);
            this._playersBuffer = new Array();
            this._mapObjects = new DictionaryData(true);
        }

        public function addPlayer(_arg_1:SingleDungeonPlayerInfo):void
        {
            if (_arg_1 != null)
            {
                this._playersBuffer.push(_arg_1);
                setTimeout(this.addPlayerToMap, (500 + (this._playersBuffer.length * 200)));
            };
        }

        public function addObjects(_arg_1:WalkMapObject, _arg_2:int):void
        {
            var _local_3:String = ("mapObj" + _arg_2);
            if (this._mapObjects.hasKey(_local_3))
            {
                this._mapObjects[_local_3] = _arg_1;
            }
            else
            {
                this._mapObjects.add(_local_3, _arg_1);
            };
        }

        public function getObjects():DictionaryData
        {
            return (this._mapObjects);
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
            var _local_5:SingleDungeonPlayerInfo;
            if (((this._playersBuffer) && (this._playersBuffer.length > 0)))
            {
                _local_4 = 0;
                while (_local_4 < this._playersBuffer.length)
                {
                    if (_arg_1 == this._playersBuffer[_local_4].playerInfo.ID)
                    {
                        _local_5 = (this._playersBuffer[_local_4] as SingleDungeonPlayerInfo);
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

        public function removeRobot():void
        {
            var _local_1:SingleDungeonPlayerInfo;
            for each (_local_1 in this._players)
            {
                if (((_local_1.playerInfo) && (_local_1.playerInfo.isRobot)))
                {
                    this._players.remove(_local_1.playerInfo.ID);
                    break;
                };
            };
        }

        public function getPlayers():DictionaryData
        {
            return (this._players);
        }

        public function getPlayerFromID(_arg_1:int):SingleDungeonPlayerInfo
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
        }

        public function dispose():void
        {
            this._players = null;
            this._playersBuffer = null;
        }


    }
}//package SingleDungeon.model

