// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//road7th.utils.MathUtils

package road7th.utils
{
    import flash.geom.Point;

    public class MathUtils 
    {


        public static function AngleToRadian(_arg_1:Number):Number
        {
            return ((_arg_1 / 180) * Math.PI);
        }

        public static function RadianToAngle(_arg_1:Number):Number
        {
            return ((_arg_1 / Math.PI) * 180);
        }

        public static function atan2(_arg_1:Number, _arg_2:Number):Number
        {
            return (RadianToAngle(Math.atan2(_arg_1, _arg_2)));
        }

        public static function GetAngleTwoPoint(_arg_1:Point, _arg_2:Point):Number
        {
            var _local_3:Number = (_arg_1.x - _arg_2.x);
            var _local_4:Number = (_arg_1.y - _arg_2.y);
            return (Math.floor(RadianToAngle(Math.atan2(_local_4, _local_3))));
        }

        public static function cos(_arg_1:Number):Number
        {
            return (Math.cos(MathUtils.AngleToRadian(_arg_1)));
        }

        public static function sin(_arg_1:Number):Number
        {
            return (Math.sin(MathUtils.AngleToRadian(_arg_1)));
        }

        public static function getValueInRange(_arg_1:Number, _arg_2:Number, _arg_3:Number):Number
        {
            if (_arg_1 <= _arg_2)
            {
                return (_arg_2);
            };
            if (_arg_1 >= _arg_3)
            {
                return (_arg_3);
            };
            return (_arg_1);
        }

        public static function isInRange(_arg_1:Number, _arg_2:Number, _arg_3:Number, _arg_4:Boolean=false, _arg_5:Boolean=true):Boolean
        {
            if (((_arg_1 < _arg_2) || (_arg_1 > _arg_3)))
            {
                return (false);
            };
            if (_arg_1 == _arg_2)
            {
                return (_arg_4);
            };
            if (_arg_1 == _arg_3)
            {
                return (_arg_5);
            };
            return (true);
        }


    }
}//package road7th.utils

