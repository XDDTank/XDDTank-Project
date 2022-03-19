// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//com.greensock.easing.Bounce

package com.greensock.easing
{
    public class Bounce 
    {


        public static function easeOut(_arg_1:Number, _arg_2:Number, _arg_3:Number, _arg_4:Number):Number
        {
            if ((_arg_1 = (_arg_1 / _arg_4)) < (1 / 2.75))
            {
                return ((_arg_3 * ((7.5625 * _arg_1) * _arg_1)) + _arg_2);
            };
            if (_arg_1 < (2 / 2.75))
            {
                return ((_arg_3 * (((7.5625 * (_arg_1 = (_arg_1 - (1.5 / 2.75)))) * _arg_1) + 0.75)) + _arg_2);
            };
            if (_arg_1 < (2.5 / 2.75))
            {
                return ((_arg_3 * (((7.5625 * (_arg_1 = (_arg_1 - (2.25 / 2.75)))) * _arg_1) + 0.9375)) + _arg_2);
            };
            return ((_arg_3 * (((7.5625 * (_arg_1 = (_arg_1 - (2.625 / 2.75)))) * _arg_1) + 0.984375)) + _arg_2);
        }

        public static function easeIn(_arg_1:Number, _arg_2:Number, _arg_3:Number, _arg_4:Number):Number
        {
            return ((_arg_3 - easeOut((_arg_4 - _arg_1), 0, _arg_3, _arg_4)) + _arg_2);
        }

        public static function easeInOut(_arg_1:Number, _arg_2:Number, _arg_3:Number, _arg_4:Number):Number
        {
            if (_arg_1 < (_arg_4 * 0.5))
            {
                return ((easeIn((_arg_1 * 2), 0, _arg_3, _arg_4) * 0.5) + _arg_2);
            };
            return (((easeOut(((_arg_1 * 2) - _arg_4), 0, _arg_3, _arg_4) * 0.5) + (_arg_3 * 0.5)) + _arg_2);
        }


    }
}//package com.greensock.easing

