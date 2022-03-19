// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//com.wirelust.util.Cast

package com.wirelust.util
{
    public class Cast 
    {


        public static function toShort(_arg_1:int):int
        {
            var _local_2:Number = (_arg_1 & 0x7FFF);
            var _local_3:Number = _local_2;
            if ((_arg_1 >> 15) == 1)
            {
                _local_3 = (_local_2 - 0x8000);
            };
            return (_local_3);
        }

        public static function toByte(_arg_1:int):int
        {
            var _local_2:Number = (_arg_1 & 0x7F);
            var _local_3:Number = _local_2;
            var _local_4:Number = ((_arg_1 & 0xFF) >> 7);
            if (_local_4 == 1)
            {
                _local_3 = (_local_2 - 128);
            };
            return (_local_3);
        }


    }
}//package com.wirelust.util

