// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//im.AddCommunityFriend

package im
{
    import road7th.utils.StringHelper;
    import ddt.manager.PathManager;
    import flash.net.URLLoader;
    import flash.events.Event;
    import flash.events.IOErrorEvent;
    import flash.net.URLRequest;
    import flash.net.URLVariables;
    import ddt.manager.PlayerManager;

    public class AddCommunityFriend 
    {

        public function AddCommunityFriend(_arg_1:String, _arg_2:String)
        {
            if (StringHelper.isNullOrEmpty(PathManager.solveCommunityFriend))
            {
                return;
            };
            var _local_3:URLLoader = new URLLoader();
            _local_3.addEventListener(Event.COMPLETE, this.__addFriendComplete);
            _local_3.addEventListener(IOErrorEvent.IO_ERROR, this.__addFriendError);
            var _local_4:URLRequest = new URLRequest(PathManager.solveCommunityFriend);
            var _local_5:URLVariables = new URLVariables();
            _local_5["fuid"] = PlayerManager.Instance.Self.LoginName;
            _local_5["fnick"] = PlayerManager.Instance.Self.NickName;
            _local_5["tuid"] = _arg_1;
            _local_5["tnick"] = _arg_2;
            _local_4.data = _local_5;
            _local_3.load(_local_4);
        }

        private function __addFriendComplete(_arg_1:Event):void
        {
            if ((_arg_1.currentTarget as URLLoader).data == "0")
            {
            };
        }

        private function __addFriendError(_arg_1:IOErrorEvent):void
        {
        }


    }
}//package im

