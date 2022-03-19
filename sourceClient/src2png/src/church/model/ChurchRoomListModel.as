// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//church.model.ChurchRoomListModel

package church.model
{
    import road7th.data.DictionaryData;
    import ddt.data.ChurchRoomInfo;

    public class ChurchRoomListModel 
    {

        private var _roomList:DictionaryData;

        public function ChurchRoomListModel()
        {
            this._roomList = new DictionaryData(true);
        }

        public function get roomList():DictionaryData
        {
            return (this._roomList);
        }

        public function addRoom(_arg_1:ChurchRoomInfo):void
        {
            if (_arg_1)
            {
                this._roomList.add(_arg_1.id, _arg_1);
            };
        }

        public function removeRoom(_arg_1:int):void
        {
            if (this._roomList[_arg_1])
            {
                this._roomList.remove(_arg_1);
            };
        }

        public function updateRoom(_arg_1:ChurchRoomInfo):void
        {
            if (_arg_1)
            {
                this._roomList.add(_arg_1.id, _arg_1);
            };
        }

        public function dispose():void
        {
            this._roomList = null;
        }


    }
}//package church.model

