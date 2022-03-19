// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//roomList.pvpRoomList.RoomListModel

package roomList.pvpRoomList
{
    import flash.events.EventDispatcher;
    import road7th.data.DictionaryData;
    import ddt.data.player.PlayerInfo;
    import ddt.manager.PlayerManager;
    import flash.events.Event;
    import room.model.RoomInfo;

    public class RoomListModel extends EventDispatcher 
    {

        public static const ROOMSHOWMODE_CHANGE:String = "roomshowmodechange";
        public static const ROOM_ITEM_UPDATE:String = "roomItemUpdate";

        private var _roomList:DictionaryData;
        private var _playerlist:DictionaryData;
        private var _self:PlayerInfo;
        private var _roomTotal:int;
        private var _currentType:int;
        private var _roomShowMode:int;
        private var _temListArray:Array;
        private var _isAddEnd:Boolean;

        public function RoomListModel()
        {
            this._roomList = new DictionaryData(true);
            this._playerlist = new DictionaryData(true);
            this._self = PlayerManager.Instance.Self;
            this._roomShowMode = 1;
        }

        public function getSelfPlayerInfo():PlayerInfo
        {
            return (this._self);
        }

        public function get isAddEnd():Boolean
        {
            return (this._isAddEnd);
        }

        public function updateRoom(_arg_1:Array):void
        {
            this._roomList.clear();
            this._isAddEnd = false;
            if (_arg_1.length == 0)
            {
                dispatchEvent(new Event(ROOM_ITEM_UPDATE));
                return;
            };
            _arg_1 = RoomListController.Instance.disorder(_arg_1);
            var _local_2:int;
            while (_local_2 < _arg_1.length)
            {
                if (_local_2 == (_arg_1.length - 1))
                {
                    this._isAddEnd = true;
                };
                this._roomList.add((_arg_1[_local_2] as RoomInfo).ID, (_arg_1[_local_2] as RoomInfo));
                _local_2++;
            };
            dispatchEvent(new Event(ROOM_ITEM_UPDATE));
        }

        public function set roomTotal(_arg_1:int):void
        {
            this._roomTotal = _arg_1;
        }

        public function get roomTotal():int
        {
            return (this._roomTotal);
        }

        public function getRoomById(_arg_1:int):RoomInfo
        {
            return (this._roomList[_arg_1]);
        }

        public function getRoomList():DictionaryData
        {
            return (this._roomList);
        }

        public function addWaitingPlayer(_arg_1:PlayerInfo):void
        {
            this._playerlist.add(_arg_1.ID, _arg_1);
        }

        public function removeWaitingPlayer(_arg_1:int):void
        {
            this._playerlist.remove(_arg_1);
        }

        public function getPlayerList():DictionaryData
        {
            return (this._playerlist);
        }

        public function get roomShowMode():int
        {
            return (this._roomShowMode);
        }

        public function set roomShowMode(_arg_1:int):void
        {
            this._roomShowMode = _arg_1;
            dispatchEvent(new Event(ROOMSHOWMODE_CHANGE));
        }

        public function get currentType():int
        {
            return (this._currentType);
        }

        public function set currentType(_arg_1:int):void
        {
            this._currentType = _arg_1;
        }

        public function dispose():void
        {
            this._roomList = null;
            this._playerlist = null;
            this._self = null;
        }


    }
}//package roomList.pvpRoomList

