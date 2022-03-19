// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//consortion.transportSence.TransportModel

package consortion.transportSence
{
    import flash.events.EventDispatcher;
    import road7th.data.DictionaryData;
    import flash.utils.setTimeout;
    import consortion.consortionsence.ConsortionWalkPlayerInfo;
    import ddt.manager.PlayerManager;

    public class TransportModel extends EventDispatcher 
    {

        private var _players:DictionaryData;
        private var _playerBuffer:Array;
        public var _mapObjects:DictionaryData;

        public function TransportModel()
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
                setTimeout(this.addPlayerToMap, (500 + (this._playerBuffer.length * 200)));
            };
        }

        public function addObjects(_arg_1:TransportCar):void
        {
            this._mapObjects.add(_arg_1.info.ownerId, _arg_1);
        }

        public function getObjects():DictionaryData
        {
            return (this._mapObjects);
        }

        public function hasMyCar():Boolean
        {
            var _local_1:TransportCar;
            for each (_local_1 in this._mapObjects)
            {
                if (((_local_1.info.ownerId == PlayerManager.Instance.Self.ID) || (_local_1.info.guarderId == PlayerManager.Instance.Self.ID)))
                {
                    return (true);
                };
            };
            return (false);
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
            this._players = new DictionaryData(true);
        }

        public function dispose():void
        {
            this._players = null;
            this._playerBuffer = null;
        }


    }
}//package consortion.transportSence

