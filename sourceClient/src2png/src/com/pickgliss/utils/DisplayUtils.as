// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//com.pickgliss.utils.DisplayUtils

package com.pickgliss.utils
{
    import flash.geom.Point;
    import flash.display.DisplayObject;
    import flash.display.Shape;
    import flash.display.BitmapData;
    import flash.text.TextField;
    import com.pickgliss.toplevel.StageReferance;
    import flash.display.DisplayObjectContainer;
    import com.pickgliss.ui.core.Component;
    import flash.geom.Rectangle;
    import com.pickgliss.geom.InnerRectangle;
    import com.pickgliss.ui.image.Image;
    import flash.display.MovieClip;
    import com.pickgliss.ui.text.FilterFrameText;
    import com.pickgliss.ui.text.GradientText;
    import flash.display.InteractiveObject;
    import flash.text.TextFieldAutoSize;
    import flash.text.TextFormat;
    import flash.display.Sprite;
    import flash.display.Bitmap;

    public final class DisplayUtils 
    {

        private static const ZERO_POINT:Point = new Point(0, 0);


        public static function removeDisplay(... _args):DisplayObject
        {
            var _local_2:DisplayObject;
            for each (_local_2 in _args)
            {
                if (((_local_2) && (_local_2.parent)))
                {
                    _local_2.parent.removeChild(_local_2);
                };
            };
            return (_args[0]);
        }

        public static function drawRectShape(_arg_1:Number, _arg_2:Number, _arg_3:Shape=null):Shape
        {
            var _local_4:Shape;
            if (_arg_3 == null)
            {
                _local_4 = new Shape();
            }
            else
            {
                _local_4 = _arg_3;
            };
            _local_4.graphics.clear();
            _local_4.graphics.beginFill(0xFF0000, 1);
            _local_4.graphics.drawRect(0, 0, _arg_1, _arg_2);
            _local_4.graphics.endFill();
            return (_local_4);
        }

        public static function drawTextShape(_arg_1:TextField):DisplayObject
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

        public static function isInTheStage(_arg_1:Point, _arg_2:DisplayObjectContainer=null):Boolean
        {
            var _local_3:Point = _arg_1;
            if (_arg_2)
            {
                _local_3 = _arg_2.localToGlobal(_arg_1);
            };
            if (((((_local_3.x < 0) || (_local_3.y < 0)) || (_local_3.x > StageReferance.stageWidth)) || (_local_3.y > StageReferance.stageHeight)))
            {
                return (false);
            };
            return (true);
        }

        public static function layoutDisplayWithInnerRect(_arg_1:DisplayObject, _arg_2:InnerRectangle, _arg_3:int, _arg_4:int):void
        {
            if (_arg_2 == null)
            {
                return;
            };
            if ((_arg_1 is Component))
            {
                Component(_arg_1).beginChanges();
            };
            var _local_5:Rectangle = _arg_2.getInnerRect(_arg_3, _arg_4);
            _arg_1.x = _local_5.x;
            _arg_1.y = _local_5.y;
            _arg_1.width = _local_5.width;
            _arg_1.height = _local_5.height;
            if ((_arg_1 is Component))
            {
                Component(_arg_1).commitChanges();
            };
        }

        public static function setFrame(_arg_1:DisplayObject, _arg_2:int):void
        {
            if ((_arg_1 is Image))
            {
                Image(_arg_1).setFrame(_arg_2);
            }
            else
            {
                if ((_arg_1 is MovieClip))
                {
                    MovieClip(_arg_1).gotoAndStop(_arg_2);
                }
                else
                {
                    if ((_arg_1 is FilterFrameText))
                    {
                        FilterFrameText(_arg_1).setFrame(_arg_2);
                    }
                    else
                    {
                        if ((_arg_1 is GradientText))
                        {
                            GradientText(_arg_1).setFrame(_arg_2);
                        };
                    };
                };
            };
        }

        public static function setDisplayObjectNotEnable(_arg_1:DisplayObject):void
        {
            if ((_arg_1 is InteractiveObject))
            {
                InteractiveObject(_arg_1).mouseEnabled = false;
            };
            if ((_arg_1 is DisplayObjectContainer))
            {
                DisplayObjectContainer(_arg_1).mouseChildren = false;
                DisplayObjectContainer(_arg_1).mouseEnabled = false;
            };
        }

        public static function getTextFieldLineHeight(_arg_1:TextField):int
        {
            return (_arg_1.getLineMetrics(0).height);
        }

        public static function getTextFieldCareLinePosY(_arg_1:TextField):Number
        {
            var _local_2:int = (_arg_1.caretIndex - 1);
            var _local_3:int = _arg_1.text.charCodeAt(_local_2);
            var _local_4:int = _arg_1.getLineIndexOfChar(_local_2);
            var _local_5:int;
            if (_local_3 == 13)
            {
                _local_5 = (_local_4 + 1);
            }
            else
            {
                _local_5 = _local_4;
            };
            return (getTextFieldLineHeight(_arg_1) * _local_5);
        }

        public static function getTextFieldCareLinePosX(_arg_1:TextField):Number
        {
            var _local_2:int = (_arg_1.caretIndex - 1);
            var _local_3:Rectangle = _arg_1.getCharBoundaries(_local_2);
            if (_local_3 == null)
            {
                return (0);
            };
            return (_local_3.x + _local_3.width);
        }

        public static function subStringByLength(_arg_1:TextField, _arg_2:String, _arg_3:uint):String
        {
            var _local_4:int = _arg_2.length;
            _local_4--;
            _arg_1.text = _arg_2;
            while (_arg_1.textWidth > _arg_3)
            {
                _local_4--;
                _arg_1.text = (_arg_2.substring(0, _local_4) + "..");
            };
            return (_arg_1.text);
        }

        public static function getVisibleSize(_arg_1:DisplayObject):Rectangle
        {
            var _local_3:Rectangle;
            var _local_2:int = 2000;
            var _local_4:BitmapData = new BitmapData(_local_2, _local_2, true, 0);
            _local_4.draw(_arg_1);
            _local_3 = _local_4.getColorBoundsRect(0xFF000000, 0, false);
            _local_4.dispose();
            return (new Rectangle(_local_3.x, _local_3.y, (_local_3.x + _local_3.width), (_local_3.y + _local_3.height)));
        }

        public static function getTextFieldMaxLineWidth(_arg_1:String, _arg_2:TextFormat, _arg_3:Boolean):Number
        {
            var _local_5:Array;
            var _local_4:TextField = new TextField();
            _local_4.autoSize = TextFieldAutoSize.LEFT;
            if (_arg_3)
            {
                _arg_1 = _arg_1.replace("<BR>", "\n");
                _arg_1 = _arg_1.replace("<Br>", "\n");
                _arg_1 = _arg_1.replace("<bR>", "\n");
                _arg_1 = _arg_1.replace("<br>", "\n");
            };
            _local_5 = _arg_1.split("\n");
            var _local_6:Number = 0;
            var _local_7:int;
            while (_local_7 < _local_5.length)
            {
                if (_arg_3)
                {
                    _local_4.htmlText = _local_5[_local_7];
                }
                else
                {
                    _local_4.text = _local_5[_local_7];
                    _local_4.setTextFormat(_arg_2);
                };
                _local_6 = Math.max(_local_6, _local_4.width);
                _local_7++;
            };
            return (_local_6 + 2);
        }

        public static function isTargetOrContain(_arg_1:DisplayObject, _arg_2:DisplayObject):Boolean
        {
            if (_arg_1 == null)
            {
                return (false);
            };
            if (_arg_1 == _arg_2)
            {
                return (true);
            };
            if ((_arg_2 is DisplayObjectContainer))
            {
                return (DisplayObjectContainer(_arg_2).contains(_arg_1));
            };
            return (false);
        }

        public static function getPointFromObject(_arg_1:Point, _arg_2:DisplayObject, _arg_3:DisplayObject):Point
        {
            _arg_1 = _arg_2.localToGlobal(_arg_1);
            return (_arg_3.globalToLocal(_arg_1));
        }

        public static function clearChildren(_arg_1:Sprite):void
        {
            while (_arg_1.numChildren > 0)
            {
                _arg_1.removeChildAt(0);
            };
        }

        public static function getDisplayBitmapData(_arg_1:DisplayObject):BitmapData
        {
            if ((_arg_1 is Bitmap))
            {
                return (Bitmap(_arg_1).bitmapData);
            };
            var _local_2:BitmapData = new BitmapData(_arg_1.width, _arg_1.height, true, 0);
            _local_2.draw(_arg_1);
            return (_local_2);
        }

        public static function localizePoint(_arg_1:DisplayObject, _arg_2:DisplayObject, _arg_3:Point=null):Point
        {
            return (_arg_1.globalToLocal(_arg_2.localToGlobal(((_arg_3) ? _arg_3 : new Point(0, 0)))));
        }

        public static function setDisplayPos(_arg_1:DisplayObject, _arg_2:Point):void
        {
            _arg_1.x = _arg_2.x;
            _arg_1.y = _arg_2.y;
        }

        public static function changeSize(_arg_1:DisplayObject, _arg_2:int, _arg_3:int):void
        {
            _arg_1.width = _arg_2;
            _arg_1.height = _arg_3;
        }

        public static function horizontalArrange(_arg_1:Sprite, _arg_2:int=1, _arg_3:Number=0, _arg_4:Number=0):void
        {
            var _local_12:int;
            var _local_13:int;
            var _local_14:DisplayObject;
            var _local_5:int;
            var _local_6:int = ZERO_POINT.x;
            var _local_7:int = ZERO_POINT.y;
            var _local_8:int;
            var _local_9:int;
            var _local_10:int = int(Math.ceil((_arg_1.numChildren / _arg_2)));
            var _local_11:int;
            while (_local_11 < _local_10)
            {
                _local_12 = 0;
                _local_13 = 0;
                while (_local_13 < _arg_2)
                {
                    _local_14 = _arg_1.getChildAt(_local_5++);
                    _local_14.x = _local_6;
                    _local_14.y = _local_7;
                    _local_8 = Math.max(_local_8, (_local_6 + _local_14.width));
                    _local_9 = Math.max(_local_9, (_local_7 + _local_14.height));
                    _local_6 = (_local_6 + (_local_14.width + _arg_3));
                    if (_local_12 < _local_14.height)
                    {
                        _local_12 = _local_14.height;
                    };
                    if (_local_5 >= _arg_1.numChildren)
                    {
                        changeSize(_arg_1, _local_8, _local_9);
                        return;
                    };
                    _local_13++;
                };
                _local_6 = ZERO_POINT.x;
                _local_7 = (_local_7 + (_local_12 + _arg_4));
                _local_11++;
            };
            changeSize(_arg_1, _local_8, _local_9);
        }

        public static function verticalArrange(_arg_1:Sprite, _arg_2:int=1, _arg_3:Number=0, _arg_4:Number=0):void
        {
            var _local_12:int;
            var _local_13:int;
            var _local_14:DisplayObject;
            var _local_5:int;
            var _local_6:int = ZERO_POINT.x;
            var _local_7:int = ZERO_POINT.y;
            var _local_8:int;
            var _local_9:int;
            var _local_10:int = int(Math.ceil((_arg_1.numChildren / _arg_2)));
            var _local_11:int;
            while (_local_11 < _local_10)
            {
                _local_12 = 0;
                _local_13 = 0;
                while (_local_13 < _arg_2)
                {
                    _local_14 = _arg_1.getChildAt(_local_5++);
                    _local_14.x = _local_6;
                    _local_14.y = _local_7;
                    _local_8 = Math.max(_local_8, (_local_6 + _local_14.width));
                    _local_9 = Math.max(_local_9, (_local_7 + _local_14.height));
                    _local_7 = (_local_7 + (_local_14.height + _arg_4));
                    if (_local_12 < _local_14.width)
                    {
                        _local_12 = _local_14.width;
                    };
                    if (_local_5 >= _arg_1.numChildren)
                    {
                        changeSize(_arg_1, _local_8, _local_9);
                        return;
                    };
                    _local_13++;
                };
                _local_6 = (_local_6 + (_local_12 + _arg_3));
                _local_7 = ZERO_POINT.y;
                _local_11++;
            };
            changeSize(_arg_1, _local_8, _local_9);
        }


    }
}//package com.pickgliss.utils

