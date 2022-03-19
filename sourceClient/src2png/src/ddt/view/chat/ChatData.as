// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//ddt.view.chat.ChatData

package ddt.view.chat
{
    import ddt.utils.Helpers;

    public class ChatData 
    {

        public static const B_BUGGLE_TYPE_NORMAL:uint = 0;
        public static const BUGLE_ANIMATION:String = "bugleAnimation";

        public var channel:uint;
        public var htmlMessage:String = "";
        public var msg:String = "";
        private var _receiver:String = "";
        public var receiverID:int;
        public var sender:String = "";
        public var isAutoReply:Boolean = false;
        public var senderID:int = -1;
        public var zoneID:int = -1;
        public var zoneName:String = "";
        public var type:int = -1;
        public var bigBuggleType:uint = 0;
        public var link:Array;
        public var anyThing:Object;


        public function set receiver(_arg_1:String):void
        {
            this._receiver = _arg_1;
        }

        public function get receiver():String
        {
            return (this._receiver);
        }

        public function clone():ChatData
        {
            var _local_1:ChatData = new ChatData();
            Helpers.copyProperty(this, _local_1, ["channel", "htmlMessage", "msg", "receiver", "receiverID", "sender", "senderID", "zoneID", "type"]);
            _local_1.link = new Array().concat(this.link);
            return (_local_1);
        }


    }
}//package ddt.view.chat

