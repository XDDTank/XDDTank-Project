// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//com.pickgliss.utils.PNGHitAreaFactory

package com.pickgliss.utils
{
    import __AS3__.vec.Vector;
    import flash.geom.Point;
    import flash.display.Sprite;
    import flash.display.BitmapData;
    import __AS3__.vec.*;

    public class PNGHitAreaFactory 
    {

        private static var points1:Vector.<Point>;
        private static var points2:Vector.<Point>;
        private static var coord:Vector.<Number>;
        private static var commands:Vector.<int>;


        public static function drawHitArea(_arg_1:BitmapData):Sprite
        {
            var _local_2:Point;
            var _local_3:Point;
            var _local_4:uint;
            var _local_5:int;
            getPointAroundImage(_arg_1);
            for each (_local_2 in points1)
            {
                coord.push(_local_2.x);
                coord.push(_local_2.y);
            };
            for each (_local_3 in points2)
            {
                coord.push(_local_3.x);
                coord.push(_local_3.y);
            };
            _local_4 = (points1.length + points2.length);
            commands.push(1);
            _local_5 = 1;
            while (_local_5 < _local_4)
            {
                commands.push(2);
                _local_5++;
            };
            var _local_6:Sprite = new Sprite();
            _local_6.graphics.beginFill(0xFF0000);
            _local_6.graphics.drawPath(commands, coord);
            _local_6.graphics.endFill();
            return (_local_6);
        }

        private static function getPointAroundImage(_arg_1:BitmapData):void
        {
            var _local_4:int;
            var _local_5:int;
            var _local_6:int;
            var _local_7:uint;
            var _local_8:uint;
            points1 = new Vector.<Point>();
            points2 = new Vector.<Point>();
            commands = new Vector.<int>();
            coord = new Vector.<Number>();
            var _local_2:int = _arg_1.width;
            var _local_3:int = _arg_1.height;
            _local_4 = 1;
            while (_local_4 <= _local_2)
            {
                _local_5 = 1;
                while (_local_5 <= _local_3)
                {
                    _local_7 = ((_arg_1.getPixel32(_local_4, _local_5) >> 24) & 0xFF);
                    if (_local_7 != 0)
                    {
                        points1.push(new Point(_local_4, _local_5));
                        break;
                    };
                    _local_5++;
                };
                _local_6 = _local_3;
                while (_local_6 > 0)
                {
                    _local_8 = ((_arg_1.getPixel32(_local_4, _local_6) >> 24) & 0xFF);
                    if (((!(_local_8 == 0)) && (!(_local_4 == _local_6))))
                    {
                        points2.unshift(new Point(_local_4, _local_6));
                        break;
                    };
                    _local_6--;
                };
                _local_4++;
            };
        }


    }
}//package com.pickgliss.utils

