// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//ddt.utils.Geometry

package ddt.utils
{
    import flash.geom.Point;

    public class Geometry 
    {


        public static function getAngle4(_arg_1:Number, _arg_2:Number, _arg_3:Number, _arg_4:Number):Number
        {
            return (Math.atan2((_arg_4 - _arg_2), (_arg_3 - _arg_1)));
        }

        public static function getAngle(_arg_1:Point, _arg_2:Point):Number
        {
            return (Math.atan2((_arg_2.y - _arg_1.y), (_arg_2.x - _arg_1.x)));
        }

        public static function nextPoint2(_arg_1:Number, _arg_2:Number, _arg_3:Number, _arg_4:Number):Point
        {
            return (new Point((_arg_1 + (Math.cos(_arg_3) * _arg_4)), (_arg_2 + (Math.sin(_arg_3) * _arg_4))));
        }

        public static function nextPoint(_arg_1:Point, _arg_2:Number, _arg_3:Number):Point
        {
            return (new Point((_arg_1.x + (Math.cos(_arg_2) * _arg_3)), (_arg_1.y + (Math.sin(_arg_2) * _arg_3))));
        }

        private static function standardAngle(_arg_1:Number):Number
        {
            _arg_1 = (_arg_1 % (2 * Math.PI));
            if (_arg_1 > Math.PI)
            {
                _arg_1 = (_arg_1 - (2 * Math.PI));
            }
            else
            {
                if (_arg_1 < -(Math.PI))
                {
                    _arg_1 = (_arg_1 + (2 * Math.PI));
                };
            };
            return (_arg_1);
        }

        public static function crossAngle(_arg_1:Number, _arg_2:Number):Number
        {
            return (standardAngle((standardAngle(_arg_1) - standardAngle(_arg_2))));
        }

        public static function isClockwish(_arg_1:Number, _arg_2:Number):Boolean
        {
            return (crossAngle(_arg_1, _arg_2) < 0);
        }

        public static function cross_x(_arg_1:Number, _arg_2:Number, _arg_3:Number, _arg_4:Number, _arg_5:Number, _arg_6:Number, _arg_7:Number, _arg_8:Number):Number
        {
            var _local_9:Number = ((_arg_2 - _arg_4) / ((_arg_3 * _arg_2) - (_arg_1 * _arg_4)));
            var _local_10:Number = ((_arg_3 - _arg_1) / ((_arg_3 * _arg_2) - (_arg_1 * _arg_4)));
            var _local_11:Number = ((_arg_6 - _arg_8) / ((_arg_7 * _arg_6) - (_arg_5 * _arg_8)));
            var _local_12:Number = ((_arg_7 - _arg_5) / ((_arg_7 * _arg_6) - (_arg_5 * _arg_8)));
            return ((_local_10 - _local_12) / ((_local_11 * _local_10) - (_local_9 * _local_12)));
        }

        public static function cross_y(_arg_1:Number, _arg_2:Number, _arg_3:Number, _arg_4:Number, _arg_5:Number, _arg_6:Number, _arg_7:Number, _arg_8:Number):Number
        {
            var _local_9:Number = ((_arg_2 - _arg_4) / ((_arg_3 * _arg_2) - (_arg_1 * _arg_4)));
            var _local_10:Number = ((_arg_3 - _arg_1) / ((_arg_3 * _arg_2) - (_arg_1 * _arg_4)));
            var _local_11:Number = ((_arg_6 - _arg_8) / ((_arg_7 * _arg_6) - (_arg_5 * _arg_8)));
            var _local_12:Number = ((_arg_7 - _arg_5) / ((_arg_7 * _arg_6) - (_arg_5 * _arg_8)));
            return ((_local_9 - _local_11) / ((_local_12 * _local_9) - (_local_10 * _local_11)));
        }

        public static function crossPoint2D(_arg_1:Number, _arg_2:Number, _arg_3:Number, _arg_4:Number, _arg_5:Number, _arg_6:Number, _arg_7:Number, _arg_8:Number):Point
        {
            var _local_9:Number = ((_arg_2 - _arg_4) / ((_arg_3 * _arg_2) - (_arg_1 * _arg_4)));
            var _local_10:Number = ((_arg_3 - _arg_1) / ((_arg_3 * _arg_2) - (_arg_1 * _arg_4)));
            var _local_11:Number = ((_arg_6 - _arg_8) / ((_arg_7 * _arg_6) - (_arg_5 * _arg_8)));
            var _local_12:Number = ((_arg_7 - _arg_5) / ((_arg_7 * _arg_6) - (_arg_5 * _arg_8)));
            var _local_13:Number = ((_local_10 - _local_12) / ((_local_11 * _local_10) - (_local_9 * _local_12)));
            var _local_14:Number = ((_local_9 - _local_11) / ((_local_12 * _local_9) - (_local_10 * _local_11)));
            return (new Point(_local_13, _local_14));
        }

        public static function distance(_arg_1:Point, _arg_2:Point):Number
        {
            return (Math.sqrt(distanceSq(_arg_1, _arg_2)));
        }

        public static function distanceSq(_arg_1:Point, _arg_2:Point):Number
        {
            return (((_arg_1.x - _arg_2.x) * (_arg_1.x - _arg_2.x)) + ((_arg_1.y - _arg_2.y) * (_arg_1.y - _arg_2.y)));
        }


    }
}//package ddt.utils

