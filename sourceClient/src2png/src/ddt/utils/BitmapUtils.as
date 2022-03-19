// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//ddt.utils.BitmapUtils

package ddt.utils
{
    import flash.display.Shape;
    import flash.utils.Timer;
    import flash.display.BitmapData;
    import flash.geom.ColorTransform;
    import flash.display.BlendMode;
    import __AS3__.vec.Vector;
    import flash.events.Event;
    import flash.events.TimerEvent;
    import flash.display.DisplayObject;
    import flash.geom.Rectangle;

    public class BitmapUtils 
    {

        private static var _maskShape:Shape;
        private static var _curX:Number;
        private static var _curY:Number;
        private static var _rowNumber:Number;
        private static var _rowWitdh:Number;
        private static var _rowHeight:Number;
        private static var _frameStep:Number;
        private static var _curRow:Number = 0;
        private static var _sleepSecond:int = 0;
        private static var _callBack:Function;
        private static var _timer:Timer;
        private static var _isMask:String;


        public static function updateColor(_arg_1:BitmapData, _arg_2:Number):BitmapData
        {
            if (((!(_arg_1)) || (isNaN(_arg_2))))
            {
                return (_arg_1);
            };
            var _local_3:BitmapData = new BitmapData(_arg_1.width, _arg_1.height, true, 0);
            var _local_4:BitmapData = _arg_1.clone();
            var _local_5:ColorTransform = getHightlightColorTransfrom(_arg_2);
            if (_local_5)
            {
                _local_4.draw(_arg_1, null, _local_5, null, null, true);
            };
            _local_3.draw(_arg_1, null, getColorTransfromByColor(_arg_2));
            _local_3.draw(_local_4, null, null, BlendMode.HARDLIGHT);
            _local_4.dispose();
            _local_4 = null;
            return (_local_3);
        }

        public static function getHightlightColorTransfrom(_arg_1:uint):ColorTransform
        {
            var _local_2:uint = ((_arg_1 >> 16) & 0xFF);
            var _local_3:uint = ((_arg_1 >> 8) & 0xFF);
            var _local_4:uint = (_arg_1 & 0xFF);
            var _local_5:uint = ((_arg_1 >> 24) & 0xFF);
            var _local_6:int = _local_2;
            var _local_7:int = _local_3;
            var _local_8:int = _local_4;
            var _local_9:Boolean;
            if ((!(((_local_6 == _local_7) || (_local_6 == _local_8)) || (_local_7 == _local_8))))
            {
                if (_local_6 > _local_7)
                {
                    if (_local_6 > _local_8)
                    {
                        _local_6 = 50;
                        _local_7 = 0;
                        _local_8 = 0;
                        _local_9 = true;
                    }
                    else
                    {
                        _local_6 = 0;
                        _local_7 = 0;
                        _local_8 = 50;
                        _local_9 = true;
                    };
                }
                else
                {
                    if (_local_7 > _local_8)
                    {
                        _local_6 = 10;
                        _local_7 = 30;
                        _local_8 = 30;
                        _local_9 = true;
                    }
                    else
                    {
                        _local_6 = 0;
                        _local_7 = 0;
                        _local_8 = 50;
                        _local_9 = true;
                    };
                };
            };
            if (_local_9)
            {
                return (new ColorTransform(1, 1, 1, 1, _local_6, _local_7, _local_8, 0));
            };
            return (null);
        }

        public static function setBitmapDataGray(_arg_1:BitmapData):void
        {
            var _local_5:uint;
            var _local_2:Vector.<uint> = _arg_1.getVector(_arg_1.rect);
            var _local_3:uint = _local_2.length;
            var _local_4:uint;
            while (_local_4 < _local_3)
            {
                _local_5 = ((_local_2[_local_4] << 16) >>> 24);
                _local_2[_local_4] = (((_local_5 << 16) | (_local_5 << 8)) | _local_5);
                _local_4++;
            };
            _arg_1.setVector(_arg_1.rect, _local_2);
        }

        public static function getColorTransfromByColor(_arg_1:uint):ColorTransform
        {
            var _local_2:uint = ((_arg_1 >> 16) & 0xFF);
            var _local_3:uint = ((_arg_1 >> 8) & 0xFF);
            var _local_4:uint = (_arg_1 & 0xFF);
            var _local_5:uint = ((_arg_1 >> 24) & 0xFF);
            if ((!(((_local_2 == _local_3) || (_local_2 == _local_4)) || (_local_3 == _local_4))))
            {
                if (((_local_2 < _local_3) && (_local_2 < _local_4)))
                {
                    if (_local_3 < _local_4)
                    {
                        _local_3 = (_local_3 + 40);
                        _local_4 = (_local_4 + 10);
                    }
                    else
                    {
                        _local_3 = (_local_3 + 40);
                        _local_4 = (_local_4 + 10);
                    };
                }
                else
                {
                    if (((_local_3 < _local_2) && (_local_3 < _local_4)))
                    {
                        if (_local_2 < _local_4)
                        {
                            _local_2 = (_local_2 + 40);
                            _local_4 = (_local_4 + 10);
                        }
                        else
                        {
                            _local_2 = (_local_2 + 40);
                            _local_4 = (_local_4 + 10);
                        };
                    }
                    else
                    {
                        if (((_local_4 < _local_3) && (_local_4 < _local_2)))
                        {
                            if (_local_3 < _local_2)
                            {
                                _local_3 = (_local_3 + 40);
                                _local_2 = (_local_2 + 10);
                            }
                            else
                            {
                                _local_3 = (_local_3 + 40);
                                _local_2 = (_local_2 + 10);
                            };
                        };
                    };
                };
            };
            return (new ColorTransform(0, 0, 0, 1, _local_2, _local_3, _local_4, 0));
        }

        public static function maskMovie(_arg_1:DisplayObject, _arg_2:Shape, _arg_3:String, _arg_4:Number, _arg_5:Number, _arg_6:Number, _arg_7:Number, _arg_8:int, _arg_9:Function):void
        {
            if (((!(_arg_1)) && (!(_arg_1.parent))))
            {
                return;
            };
            _callBack = _arg_9;
            _maskShape = _arg_2;
            _isMask = _arg_3;
            _curX = 0;
            _curY = 0;
            _rowNumber = _arg_4;
            _rowWitdh = _arg_5;
            _rowHeight = _arg_6;
            _sleepSecond = _arg_8;
            _frameStep = _arg_7;
            _curRow = 0;
            if (_isMask == "true")
            {
                _arg_1.parent.addChild(_maskShape);
                _arg_1.mask = _maskShape;
                _maskShape.addEventListener(Event.ENTER_FRAME, onMaskMovieEnerFrame);
            }
            else
            {
                _arg_1.mask = null;
                _timer = new Timer((_sleepSecond * 1000));
                _timer.addEventListener(TimerEvent.TIMER, onMaskMovieTimer);
                _timer.start();
            };
        }

        private static function onMaskMovieEnerFrame(_arg_1:Event):void
        {
            _maskShape.graphics.beginFill(0);
            _maskShape.graphics.drawRect(_curX, _curY, _frameStep, _rowHeight);
            _maskShape.graphics.endFill();
            _curX = (_curX + _frameStep);
            if (_curX >= _rowWitdh)
            {
                _curRow++;
                _curX = 0;
                _curY = (_curRow * _rowHeight);
            };
            if (_curRow >= _rowNumber)
            {
                _maskShape.removeEventListener(Event.ENTER_FRAME, onMaskMovieEnerFrame);
                if (_callBack == null)
                {
                    return;
                };
                if (_sleepSecond > 0)
                {
                    _timer = new Timer((_sleepSecond * 1000));
                    _timer.addEventListener(TimerEvent.TIMER, onMaskMovieTimer);
                    _timer.start();
                }
                else
                {
                    if (_maskShape.parent)
                    {
                        _maskShape.parent.removeChild(_maskShape);
                    };
                    _maskShape = null;
                    _callBack();
                };
            };
        }

        private static function onMaskMovieTimer(_arg_1:TimerEvent):void
        {
            _timer.stop();
            _timer.removeEventListener(TimerEvent.TIMER_COMPLETE, onMaskMovieTimer);
            _timer = null;
            if (((_maskShape) && (_maskShape.parent)))
            {
                _maskShape.parent.removeChild(_maskShape);
            };
            _maskShape = null;
            if (_callBack != null)
            {
                _callBack();
            };
        }

        public static function reverseBtimapData(_arg_1:BitmapData):void
        {
            var _local_2:int = _arg_1.width;
            var _local_3:int = _arg_1.height;
            var _local_4:Vector.<uint> = _arg_1.getVector(new Rectangle(0, 0, _local_2, _local_3));
            var _local_5:int;
            while (_local_5 < _local_3)
            {
                _arg_1.setVector(new Rectangle(0, _local_5, _local_2, 1), _local_4.splice(0, _local_2).reverse());
                _local_5++;
            };
        }


    }
}//package ddt.utils

