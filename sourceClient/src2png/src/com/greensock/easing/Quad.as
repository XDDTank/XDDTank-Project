// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//com.greensock.easing.Quad

package com.greensock.easing
{
    public class Quad 
    {

        public static const power:uint = 1;


        public static function easeIn(_arg_1:Number, _arg_2:Number, _arg_3:Number, _arg_4:Number):Number
        {
            return (((_arg_3 * (_arg_1 = (_arg_1 / _arg_4))) * _arg_1) + _arg_2);
        }

        public static function easeOut(_arg_1:Number, _arg_2:Number, _arg_3:Number, _arg_4:Number):Number
        {
            return (((-(_arg_3) * (_arg_1 = (_arg_1 / _arg_4))) * (_arg_1 - 2)) + _arg_2);
        }

        public static function easeInOut(_arg_1:Number, _arg_2:Number, _arg_3:Number, _arg_4:Number):Number
        {
            if ((_arg_1 = (_arg_1 / (_arg_4 * 0.5))) < 1)
            {
                return ((((_arg_3 * 0.5) * _arg_1) * _arg_1) + _arg_2);
            };
            return (((-(_arg_3) * 0.5) * ((--_arg_1 * (_arg_1 - 2)) - 1)) + _arg_2);
        }


    }
}//package com.greensock.easing

