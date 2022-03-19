// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//civil.CivilModel

package civil
{
    import flash.events.EventDispatcher;
    import ddt.data.player.CivilPlayerInfo;
    import ddt.manager.PlayerManager;

    public class CivilModel extends EventDispatcher 
    {

        private var _civilPlayers:Array;
        private var _currentcivilItemInfo:CivilPlayerInfo;
        private var _totalPage:int;
        private var _currentLeafSex:Boolean = true;
        private var _register:Boolean = false;
        private var _IsFirst:Boolean = false;

        public function CivilModel(_arg_1:Boolean)
        {
            this._IsFirst = _arg_1;
            super();
        }

        public function set currentcivilItemInfo(_arg_1:CivilPlayerInfo):void
        {
            this._currentcivilItemInfo = _arg_1;
            dispatchEvent(new CivilEvent(CivilEvent.SELECTED_CHANGE));
        }

        public function get currentcivilItemInfo():CivilPlayerInfo
        {
            return (this._currentcivilItemInfo);
        }

        public function upSelfPublishEquit(_arg_1:Boolean):void
        {
            var _local_2:int;
            while (_local_2 < this._civilPlayers.length)
            {
                if (PlayerManager.Instance.Self.ID == this._civilPlayers[_local_2].UserId)
                {
                    (this._civilPlayers[_local_2] as CivilPlayerInfo).IsPublishEquip = _arg_1;
                    return;
                };
                _local_2++;
            };
        }

        public function upSelfIntroduction(_arg_1:String):void
        {
            var _local_2:int;
            while (_local_2 < this._civilPlayers.length)
            {
                if (PlayerManager.Instance.Self.ID == this._civilPlayers[_local_2].UserId)
                {
                    (this._civilPlayers[_local_2] as CivilPlayerInfo).Introduction = _arg_1;
                    return;
                };
                _local_2++;
            };
        }

        public function set civilPlayers(_arg_1:Array):void
        {
            this._civilPlayers = _arg_1;
            var _local_2:int = this._civilPlayers.length;
            var _local_3:int;
            while (_local_3 < _local_2)
            {
                if (((PlayerManager.Instance.Self.ID == this._civilPlayers[_local_3].UserId) && (PlayerManager.Instance.Self.Introduction == "")))
                {
                    PlayerManager.Instance.Self.Introduction = (this._civilPlayers[_local_3] as CivilPlayerInfo).Introduction;
                    break;
                };
                _local_3++;
            };
            dispatchEvent(new CivilEvent(CivilEvent.CIVIL_PLAYERINFO_ARRAY_CHANGE));
        }

        public function update():void
        {
        }

        public function updateBtn():void
        {
            dispatchEvent(new CivilEvent(CivilEvent.CIVIL_UPDATE_BTN));
        }

        public function get civilPlayers():Array
        {
            return (this._civilPlayers);
        }

        public function set TotalPage(_arg_1:int):void
        {
            this._totalPage = _arg_1;
        }

        public function get TotalPage():int
        {
            return (this._totalPage);
        }

        public function get sex():Boolean
        {
            return (this._currentLeafSex);
        }

        public function set sex(_arg_1:Boolean):void
        {
            this._currentLeafSex = _arg_1;
        }

        public function get registed():Boolean
        {
            return (this._register);
        }

        public function set registed(_arg_1:Boolean):void
        {
            this._register = _arg_1;
            dispatchEvent(new CivilEvent(CivilEvent.REGISTER_CHANGE));
        }

        public function get IsFirst():Boolean
        {
            return (this._IsFirst);
        }

        public function dispose():void
        {
            this._civilPlayers = null;
            this.currentcivilItemInfo = null;
        }


    }
}//package civil

