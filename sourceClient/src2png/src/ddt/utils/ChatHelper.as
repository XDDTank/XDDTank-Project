// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//ddt.utils.ChatHelper

package ddt.utils
{
    import flash.utils.ByteArray;
    import ddt.view.chat.chat_system; 

    use namespace chat_system;

    public class ChatHelper 
    {


        chat_system static function readGoodsLinks(_arg_1:ByteArray, _arg_2:Boolean=false):Array
        {
            var _local_6:Object;
            var _local_3:Array = [];
            var _local_4:uint = _arg_1.readUnsignedByte();
            var _local_5:int;
            while (_local_5 < _local_4)
            {
                _local_6 = new Object();
                _local_6.index = _arg_1.readInt();
                _local_6.TemplateID = _arg_1.readInt();
                _local_6.ItemID = _arg_1.readInt();
                if (_arg_2)
                {
                    _local_6.key = _arg_1.readUTF();
                };
                _local_3.push(_local_6);
                _local_5++;
            };
            return (_local_3);
        }

        chat_system static function readDungeonInfo(_arg_1:ByteArray):Object
        {
            var _local_2:Object = new Object();
            _arg_1.readByte();
            _local_2.infoIndex = _arg_1.readInt();
            _local_2.dungeonID = _arg_1.readInt();
            _local_2.roomID = _arg_1.readInt();
            _local_2.barrierNum = _arg_1.readInt();
            _local_2.hardLevel = _arg_1.readInt();
            _local_2.levelLimit = _arg_1.readInt();
            _local_2.roompass = _arg_1.readUTF();
            _local_2.inviterNickName = _arg_1.readUTF();
            return (_local_2);
        }


    }
}//package ddt.utils

