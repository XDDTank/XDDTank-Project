// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//com.greensock.easing.Quint

package com.greensock.easing
{
    public class Quint 
    {

        public static const power:uint = 4;


        public static function easeIn(_arg_1:Number, _arg_2:Number, _arg_3:Number, _arg_4:Number):Number
        {
            var _local_5:Number = ((((((_arg_3 * (_arg_1 = (_arg_1 / _arg_4))) * _arg_1) * _arg_1) * _arg_1) * _arg_1) + _arg_2);
            if (((_local_5 > Number.MAX_VALUE) || (_local_5 < Number.MAX_VALUE)))
            {
                return (1);
            };
            return (_local_5);
        }

        public static function easeOut(_arg_1:Number, _arg_2:Number, _arg_3:Number, _arg_4:Number):Number
        {
            return ((_arg_3 * ((((((_arg_1 = ((_arg_1 / _arg_4) - 1)) * _arg_1) * _arg_1) * _arg_1) * _arg_1) + 1)) + _arg_2);
        }

        public static function easeInOut(_arg_1:Number, _arg_2:Number, _arg_3:Number, _arg_4:Number):Number
        {
            if ((_arg_1 = (_arg_1 / (_arg_4 * 0.5))) < 1)
            {
                return (((((((_arg_3 * 0.5) * _arg_1) * _arg_1) * _arg_1) * _arg_1) * _arg_1) + _arg_2);
            };
            return (((_arg_3 * 0.5) * ((((((_arg_1 = (_arg_1 - 2)) * _arg_1) * _arg_1) * _arg_1) * _arg_1) + 2)) + _arg_2);
        }


    }
}//package com.greensock.easing

