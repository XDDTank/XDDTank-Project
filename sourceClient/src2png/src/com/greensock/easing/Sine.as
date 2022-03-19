// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//com.greensock.easing.Sine

package com.greensock.easing
{
    public class Sine 
    {

        private static const _HALF_PI:Number = (Math.PI * 0.5);//1.5707963267949


        public static function easeIn(_arg_1:Number, _arg_2:Number, _arg_3:Number, _arg_4:Number):Number
        {
            return (((-(_arg_3) * Math.cos(((_arg_1 / _arg_4) * _HALF_PI))) + _arg_3) + _arg_2);
        }

        public static function easeOut(_arg_1:Number, _arg_2:Number, _arg_3:Number, _arg_4:Number):Number
        {
            return ((_arg_3 * Math.sin(((_arg_1 / _arg_4) * _HALF_PI))) + _arg_2);
        }

        public static function easeInOut(_arg_1:Number, _arg_2:Number, _arg_3:Number, _arg_4:Number):Number
        {
            return (((-(_arg_3) * 0.5) * (Math.cos(((Math.PI * _arg_1) / _arg_4)) - 1)) + _arg_2);
        }


    }
}//package com.greensock.easing

