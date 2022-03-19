// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//socialContact.friendBirthday.FriendBirthdayManager

package socialContact.friendBirthday
{
    import ddt.data.player.FriendListPlayer;
    import __AS3__.vec.Vector;
    import ddt.manager.PlayerManager;
    import road7th.data.DictionaryData;
    import ddt.manager.SharedManager;
    import ddt.manager.SocketManager;
    import __AS3__.vec.*;

    public class FriendBirthdayManager 
    {

        private static var _instance:FriendBirthdayManager;

        private const INTERVAL:int = 86400;

        private var _friendName:String;


        public static function get Instance():FriendBirthdayManager
        {
            if (_instance == null)
            {
                _instance = new (FriendBirthdayManager)();
            };
            return (_instance);
        }


        public function findFriendBirthday():void
        {
            var _local_3:String;
            var _local_4:FriendListPlayer;
            var _local_1:Vector.<FriendListPlayer> = new Vector.<FriendListPlayer>();
            var _local_2:DictionaryData = PlayerManager.Instance.friendList;
            for (_local_3 in _local_2)
            {
                _local_4 = (_local_2[_local_3] as FriendListPlayer);
                if ((((_local_4.BirthdayDate) && (this._countBrithday(_local_4.BirthdayDate))) && (this._countNameInShare(_local_4.NickName))))
                {
                    _local_1.push(_local_4);
                    SharedManager.Instance.friendBrithdayName = ((SharedManager.Instance.friendBrithdayName + ",") + _local_4.NickName);
                    SharedManager.Instance.save();
                };
            };
            if (_local_1.length > 0)
            {
                this._sendMySelfEmail(_local_1);
            };
        }

        private function _countBrithday(_arg_1:Date):Boolean
        {
            var _local_2:Date = new Date();
            var _local_3:Boolean;
            if ((((_local_2.monthUTC == _arg_1.monthUTC) && ((_arg_1.dateUTC - _local_2.dateUTC) <= 1)) && ((_arg_1.dateUTC - _local_2.dateUTC) > -1)))
            {
                _local_3 = true;
            };
            return (_local_3);
        }

        private function _sendMySelfEmail(_arg_1:Vector.<FriendListPlayer>):void
        {
            SocketManager.Instance.out.sendWithBrithday(_arg_1);
        }

        public function set friendName(_arg_1:String):void
        {
            this._friendName = _arg_1;
        }

        public function get friendName():String
        {
            return (this._friendName);
        }

        private function _countNameInShare(_arg_1:String):Boolean
        {
            var _local_2:Array = SharedManager.Instance.friendBrithdayName.split(/,/);
            var _local_3:int;
            while (_local_3 < _local_2.length)
            {
                if (_arg_1 == _local_2[_local_3])
                {
                    return (false);
                };
                _local_3++;
            };
            return (true);
        }


    }
}//package socialContact.friendBirthday

