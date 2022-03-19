// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//consortion.consortionsence.ConsortionWalkMapModel

package consortion.consortionsence
{
    import flash.events.EventDispatcher;
    import road7th.data.DictionaryData;
    import flash.utils.setTimeout;
    import SingleDungeon.model.WalkMapObject;
    import flash.utils.clearTimeout;

    public class ConsortionWalkMapModel extends EventDispatcher 
    {

        private var _players:DictionaryData;
        private var _playerBuffer:Array;
        public var _mapObjects:DictionaryData;
        private var _timeOut:uint;

        public function ConsortionWalkMapModel()
        {
            this._players = new DictionaryData(true);
            this._playerBuffer = new Array();
            this._mapObjects = new DictionaryData(true);
        }

        public function addPlayer(_arg_1:ConsortionWalkPlayerInfo):void
        {
            if (_arg_1 != null)
            {
                this._playerBuffer.push(_arg_1);
                this._timeOut = setTimeout(this.addPlayerToMap, (500 + (this._playerBuffer.length * 200)));
            };
        }

        public function addObjects(_arg_1:WalkMapObject, _arg_2:int):void
        {
        }

        public function getObjects():DictionaryData
        {
            return (this._mapObjects);
        }

        private function addPlayerToMap():void
        {
            if (((!(this._players)) || (!(this._playerBuffer[0]))))
            {
                return;
            };
            this._players.add(this._playerBuffer[0].playerInfo.ID, this._playerBuffer[0]);
            this._playerBuffer.shift();
        }

        public function removePlayer(_arg_1:int):void
        {
            this._players.remove(_arg_1);
        }

        public function getPlayers():DictionaryData
        {
            return (this._players);
        }

        public function getPlayerFromID(_arg_1:int):ConsortionWalkPlayerInfo
        {
            return (this._players[_arg_1]);
        }

        public function reset():void
        {
            this.dispose();
            clearTimeout(this._timeOut);
            this._players = new DictionaryData(true);
        }

        public function dispose():void
        {
            this._players = null;
            this._playerBuffer = null;
        }


    }
}//package consortion.consortionsence

