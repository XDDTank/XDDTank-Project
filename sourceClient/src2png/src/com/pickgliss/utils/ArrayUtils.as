// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//com.pickgliss.utils.ArrayUtils

package com.pickgliss.utils
{
    public class ArrayUtils 
    {


        public static function each(_arg_1:Array, _arg_2:Function):void
        {
            var _local_3:int;
            while (_local_3 < _arg_1.length)
            {
                (_arg_2(_arg_1[_local_3]));
                _local_3++;
            };
        }

        public static function setSize(_arg_1:Array, _arg_2:int):void
        {
            if (_arg_2 < 0)
            {
                _arg_2 = 0;
            };
            if (_arg_2 == _arg_1.length)
            {
                return;
            };
            if (_arg_2 > _arg_1.length)
            {
                _arg_1[(_arg_2 - 1)] = undefined;
            }
            else
            {
                _arg_1.splice(_arg_2);
            };
        }

        public static function removeFromArray(_arg_1:Array, _arg_2:Object):int
        {
            var _local_3:int;
            while (_local_3 < _arg_1.length)
            {
                if (_arg_1[_local_3] == _arg_2)
                {
                    _arg_1.splice(_local_3, 1);
                    return (_local_3);
                };
                _local_3++;
            };
            return (-1);
        }

        public static function removeAllFromArray(_arg_1:Array, _arg_2:Object):void
        {
            var _local_3:int;
            while (_local_3 < _arg_1.length)
            {
                if (_arg_1[_local_3] == _arg_2)
                {
                    _arg_1.splice(_local_3, 1);
                    _local_3--;
                };
                _local_3++;
            };
        }

        public static function removeAllBehindSomeIndex(_arg_1:Array, _arg_2:int):void
        {
            if (_arg_2 <= 0)
            {
                _arg_1.splice(0, _arg_1.length);
                return;
            };
            var _local_3:int = _arg_1.length;
            var _local_4:int = (_arg_2 + 1);
            while (_local_4 < _local_3)
            {
                _arg_1.pop();
                _local_4++;
            };
        }

        public static function indexInArray(_arg_1:Array, _arg_2:Object):int
        {
            var _local_3:int;
            while (_local_3 < _arg_1.length)
            {
                if (_arg_1[_local_3] == _arg_2)
                {
                    return (_local_3);
                };
                _local_3++;
            };
            return (-1);
        }

        public static function cloneArray(_arg_1:Array):Array
        {
            return (_arg_1.concat());
        }

        public static function swapItems(_arg_1:Array, _arg_2:Object, _arg_3:Object):void
        {
            var _local_6:Object;
            var _local_4:int = _arg_1.indexOf(_arg_2);
            var _local_5:int = _arg_1.indexOf(_arg_3);
            if (((!(_local_4 == -1)) && (!(_local_5 == -1))))
            {
                _local_6 = _arg_1[_local_5];
                _arg_1[_local_5] = _arg_1[_local_4];
                _arg_1[_local_4] = _local_6;
            };
        }

        public static function disorder(_arg_1:Array):void
        {
            var _local_3:int;
            var _local_4:*;
            var _local_2:int;
            while (_local_2 < _arg_1.length)
            {
                _local_3 = ((Math.random() * 10000) % _arg_1.length);
                _local_4 = _arg_1[_local_2];
                _arg_1[_local_2] = _arg_1[_local_3];
                _arg_1[_local_3] = _local_4;
                _local_2++;
            };
        }

        public static function createUniqueCopy(_arg_1:Array):Array
        {
            var _local_4:Object;
            var _local_2:Array = new Array();
            var _local_3:Number = _arg_1.length;
            var _local_5:uint;
            while (_local_5 < _local_3)
            {
                _local_4 = _arg_1[_local_5];
                if (!arrayContainsValue(_local_2, _local_4))
                {
                    _local_2.push(_local_4);
                };
                _local_5++;
            };
            return (_local_2);
        }

        public static function arrayContainsValue(_arg_1:Array, _arg_2:Object):Boolean
        {
            return (!(_arg_1.indexOf(_arg_2) == -1));
        }


    }
}//package com.pickgliss.utils

