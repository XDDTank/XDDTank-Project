// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//com.wirelust.as3zlib.System

package com.wirelust.as3zlib
{
    import flash.utils.ByteArray;

    public class System 
    {


        public static function arrayCopy(_arg_1:Array, _arg_2:int, _arg_3:Array, _arg_4:int, _arg_5:int):void
        {
            var _local_6:int;
            while (_local_6 < _arg_5)
            {
                _arg_3[(_arg_4 + _local_6)] = _arg_1[(_arg_2 + _local_6)];
                _local_6++;
            };
        }

        public static function byteArrayCopy(_arg_1:ByteArray, _arg_2:int, _arg_3:ByteArray, _arg_4:int, _arg_5:int):void
        {
            var _local_6:int;
            while (_local_6 < _arg_5)
            {
                _arg_3[(_arg_4 + _local_6)] = _arg_1[(_arg_2 + _local_6)];
                _local_6++;
            };
        }


    }
}//package com.wirelust.as3zlib

