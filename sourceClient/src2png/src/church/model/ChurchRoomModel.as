// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//church.model.ChurchRoomModel

package church.model
{
    import flash.events.EventDispatcher;
    import road7th.data.DictionaryData;
    import church.vo.PlayerVO;
    import church.events.WeddingRoomEvent;

    public class ChurchRoomModel extends EventDispatcher 
    {

        private var _players:DictionaryData;
        private var _playerNameVisible:Boolean = true;
        private var _playerChatBallVisible:Boolean = true;
        private var _playerFireVisible:Boolean = true;
        private var _fireEnable:Boolean;
        private var _fireTemplateIDList:Array = [21002, 21006];

        public function ChurchRoomModel()
        {
            this._players = new DictionaryData(true);
        }

        public function get players():DictionaryData
        {
            return (this._players);
        }

        public function addPlayer(_arg_1:PlayerVO):void
        {
            this._players.add(_arg_1.playerInfo.ID, _arg_1);
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
            dispatchEvent(new WeddingRoomEvent(WeddingRoomEvent.PLAYER_NAME_VISIBLE));
        }

        public function get playerChatBallVisible():Boolean
        {
            return (this._playerChatBallVisible);
        }

        public function set playerChatBallVisible(_arg_1:Boolean):void
        {
            this._playerChatBallVisible = _arg_1;
            dispatchEvent(new WeddingRoomEvent(WeddingRoomEvent.PLAYER_CHATBALL_VISIBLE));
        }

        public function set playerFireVisible(_arg_1:Boolean):void
        {
            this._playerFireVisible = _arg_1;
        }

        public function get playerFireVisible():Boolean
        {
            return (this._playerFireVisible);
        }

        public function set fireEnable(_arg_1:Boolean):void
        {
            this._fireEnable = _arg_1;
            dispatchEvent(new WeddingRoomEvent(WeddingRoomEvent.ROOM_FIRE_ENABLE_CHANGE));
        }

        public function get fireEnable():Boolean
        {
            return (this._fireEnable);
        }

        public function get fireTemplateIDList():Array
        {
            return (this._fireTemplateIDList);
        }

        public function dispose():void
        {
            this._players = null;
        }


    }
}//package church.model

