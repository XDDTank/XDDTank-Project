// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//ddt.utils.GraphicsUtils

package ddt.utils
{
    import flash.display.Sprite;
    import flash.display.BitmapData;
    import flash.display.Shape;
    import flash.display.DisplayObject;

    public class GraphicsUtils 
    {


        public static function drawSector(_arg_1:Number, _arg_2:Number, _arg_3:Number, _arg_4:Number, _arg_5:Number):Sprite
        {
            var _local_14:Number;
            var _local_15:Number;
            var _local_6:Sprite = new Sprite();
            var _local_7:Number = _arg_3;
            var _local_8:Number = 0;
            if (_arg_4 != 0)
            {
                _local_7 = (Math.cos(((_arg_4 * Math.PI) / 180)) * _arg_3);
                _local_8 = (Math.sin(((_arg_4 * Math.PI) / 180)) * _arg_3);
            };
            _local_6.graphics.beginFill(0xFFFF00, 1);
            _local_6.graphics.moveTo(_arg_1, _arg_2);
            _local_6.graphics.lineTo((_arg_1 + _local_7), (_arg_2 - _local_8));
            var _local_9:Number = (((_arg_5 * Math.PI) / 180) / _arg_5);
            var _local_10:Number = Math.cos(_local_9);
            var _local_11:Number = Math.sin(_local_9);
            var _local_12:Number = 0;
            var _local_13:Number = 0;
            while (_local_13 < _arg_5)
            {
                _local_14 = ((_local_10 * _local_7) - (_local_11 * _local_8));
                _local_15 = ((_local_10 * _local_8) + (_local_11 * _local_7));
                _local_7 = _local_14;
                _local_8 = _local_15;
                _local_6.graphics.lineTo((_local_7 + _arg_1), (-(_local_8) + _arg_2));
                _local_13++;
            };
            _local_6.graphics.lineTo(_arg_1, _arg_2);
            _local_6.graphics.endFill();
            return (_local_6);
        }

        public static function drawDisplayMask(_arg_1:DisplayObject):DisplayObject
        {
            var _local_5:uint;
            var _local_6:uint;
            var _local_7:uint;
            var _local_8:Number;
            var _local_2:BitmapData = new BitmapData(_arg_1.width, _arg_1.height, true, 0xFF0000);
            _local_2.draw(_arg_1);
            var _local_3:Shape = new Shape();
            _local_3.cacheAsBitmap = true;
            var _local_4:uint;
            while (_local_4 < _local_2.width)
            {
                _local_5 = 0;
                while (_local_5 < _local_2.height)
                {
                    _local_6 = _local_2.getPixel32(_local_4, _local_5);
                    _local_7 = ((_local_6 >> 24) & 0xFF);
                    _local_8 = (_local_7 / 0xFF);
                    if (_local_6 > 0)
                    {
                        _local_3.graphics.beginFill(0, _local_8);
                        _local_3.graphics.drawCircle(_local_4, _local_5, 1);
                    };
                    _local_5++;
                };
                _local_4++;
            };
            return (_local_3);
        }

        public static function changeSectorAngle(_arg_1:Sprite, _arg_2:Number, _arg_3:Number, _arg_4:Number, _arg_5:Number, _arg_6:Number):void
        {
            var _local_14:Number;
            var _local_15:Number;
            _arg_1.graphics.clear();
            var _local_7:Number = _arg_4;
            var _local_8:Number = 0;
            if (_arg_5 != 0)
            {
                _local_7 = (Math.cos(((_arg_5 * Math.PI) / 180)) * _arg_4);
                _local_8 = (Math.sin(((_arg_5 * Math.PI) / 180)) * _arg_4);
            };
            _arg_1.graphics.beginFill(0xFFFF00, 1);
            _arg_1.graphics.moveTo(_arg_2, _arg_3);
            _arg_1.graphics.lineTo((_arg_2 + _local_7), (_arg_3 - _local_8));
            var _local_9:Number = (((_arg_6 * Math.PI) / 180) / _arg_6);
            var _local_10:Number = Math.cos(_local_9);
            var _local_11:Number = Math.sin(_local_9);
            var _local_12:Number = 0;
            var _local_13:Number = 0;
            while (_local_13 < _arg_6)
            {
                _local_14 = ((_local_10 * _local_7) - (_local_11 * _local_8));
                _local_15 = ((_local_10 * _local_8) + (_local_11 * _local_7));
                _local_7 = _local_14;
                _local_8 = _local_15;
                _arg_1.graphics.lineTo((_local_7 + _arg_2), (-(_local_8) + _arg_3));
                _local_13++;
            };
            _arg_1.graphics.lineTo(_arg_2, _arg_3);
            _arg_1.graphics.endFill();
        }


    }
}//package ddt.utils

