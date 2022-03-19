// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//com.wirelust.as3zlib.Adler32

package com.wirelust.as3zlib
{
    import flash.utils.ByteArray;

    public final class Adler32 
    {

        private static var BASE:int = 65521;
        private static var NMAX:int = 5552;


        public function adler32(_arg_1:Number, _arg_2:ByteArray, _arg_3:int, _arg_4:int):Number
        {
            var _local_7:int;
            if (_arg_2 == null)
            {
                return (1);
            };
            var _local_5:Number = (_arg_1 & 0xFFFF);
            var _local_6:Number = ((_arg_1 >> 16) & 0xFFFF);
            while (_arg_4 > 0)
            {
                _local_7 = ((_arg_4 < NMAX) ? _arg_4 : NMAX);
                _arg_4 = (_arg_4 - _local_7);
                while (_local_7 >= 16)
                {
                    _local_5 = (_local_5 + (_arg_2[_arg_3++] & 0xFF));
                    _local_6 = (_local_6 + _local_5);
                    _local_5 = (_local_5 + (_arg_2[_arg_3++] & 0xFF));
                    _local_6 = (_local_6 + _local_5);
                    _local_5 = (_local_5 + (_arg_2[_arg_3++] & 0xFF));
                    _local_6 = (_local_6 + _local_5);
                    _local_5 = (_local_5 + (_arg_2[_arg_3++] & 0xFF));
                    _local_6 = (_local_6 + _local_5);
                    _local_5 = (_local_5 + (_arg_2[_arg_3++] & 0xFF));
                    _local_6 = (_local_6 + _local_5);
                    _local_5 = (_local_5 + (_arg_2[_arg_3++] & 0xFF));
                    _local_6 = (_local_6 + _local_5);
                    _local_5 = (_local_5 + (_arg_2[_arg_3++] & 0xFF));
                    _local_6 = (_local_6 + _local_5);
                    _local_5 = (_local_5 + (_arg_2[_arg_3++] & 0xFF));
                    _local_6 = (_local_6 + _local_5);
                    _local_5 = (_local_5 + (_arg_2[_arg_3++] & 0xFF));
                    _local_6 = (_local_6 + _local_5);
                    _local_5 = (_local_5 + (_arg_2[_arg_3++] & 0xFF));
                    _local_6 = (_local_6 + _local_5);
                    _local_5 = (_local_5 + (_arg_2[_arg_3++] & 0xFF));
                    _local_6 = (_local_6 + _local_5);
                    _local_5 = (_local_5 + (_arg_2[_arg_3++] & 0xFF));
                    _local_6 = (_local_6 + _local_5);
                    _local_5 = (_local_5 + (_arg_2[_arg_3++] & 0xFF));
                    _local_6 = (_local_6 + _local_5);
                    _local_5 = (_local_5 + (_arg_2[_arg_3++] & 0xFF));
                    _local_6 = (_local_6 + _local_5);
                    _local_5 = (_local_5 + (_arg_2[_arg_3++] & 0xFF));
                    _local_6 = (_local_6 + _local_5);
                    _local_5 = (_local_5 + (_arg_2[_arg_3++] & 0xFF));
                    _local_6 = (_local_6 + _local_5);
                    _local_7 = (_local_7 - 16);
                };
                if (_local_7 != 0)
                {
                    do 
                    {
                        _local_5 = (_local_5 + (_arg_2[_arg_3++] & 0xFF));
                        _local_6 = (_local_6 + _local_5);
                    } while (--_local_7 != 0);
                };
                _local_5 = (_local_5 % BASE);
                _local_6 = (_local_6 % BASE);
            };
            return ((_local_6 << 16) | _local_5);
        }


    }
}//package com.wirelust.as3zlib

