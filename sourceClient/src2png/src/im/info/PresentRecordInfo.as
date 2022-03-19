// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//im.info.PresentRecordInfo

package im.info
{
    import __AS3__.vec.Vector;
    import road7th.utils.DateUtils;
    import ddt.manager.PlayerManager;
    import __AS3__.vec.*;

    public class PresentRecordInfo 
    {

        public static const SHOW:int = 0;
        public static const HIDE:int = 1;
        public static const UNREAD:int = 2;

        public var id:int;
        public var exist:int = 2;
        public var messages:Vector.<String>;
        public var recordMessage:Vector.<Object>;

        public function PresentRecordInfo()
        {
            this.messages = new Vector.<String>();
            this.recordMessage = new Vector.<Object>();
        }

        public function addMessage(_arg_1:String, _arg_2:Date, _arg_3:String):void
        {
            var _local_4:String = DateUtils.dateFormat(_arg_2);
            var _local_5:String = "";
            if (_arg_1 == PlayerManager.Instance.Self.NickName)
            {
                _local_5 = (_local_5 + (((("<FONT COLOR='#06f710'>" + _arg_1) + "   ") + _local_4.split(" ")[1]) + "</FONT>\n"));
            }
            else
            {
                _local_5 = (_local_5 + (((("<FONT COLOR='#ffff01'>" + _arg_1) + "   ") + _local_4.split(" ")[1]) + "</FONT>\n"));
            };
            _local_5 = (_local_5 + _arg_3);
            this.messages.push(_local_5);
            var _local_6:String = "";
            if (_arg_1 == PlayerManager.Instance.Self.NickName)
            {
                _local_6 = (_local_6 + (((("<FONT COLOR='#06f710'>" + _arg_1) + "   ") + _local_4) + "</FONT>\n"));
            }
            else
            {
                _local_6 = (_local_6 + (((("<FONT COLOR='#ffff01'>" + _arg_1) + "   ") + _local_4) + "</FONT>\n"));
            };
            _local_6 = (_local_6 + _arg_3);
            this.recordMessage.push(_local_6);
        }

        public function get lastMessage():String
        {
            return (this.messages[(this.messages.length - 1)]);
        }

        public function get lastRecordMessage():Object
        {
            return (this.recordMessage[(this.recordMessage.length - 1)]);
        }


    }
}//package im.info

