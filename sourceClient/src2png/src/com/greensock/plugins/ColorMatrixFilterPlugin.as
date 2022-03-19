﻿// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//com.greensock.plugins.ColorMatrixFilterPlugin

package com.greensock.plugins
{
    import flash.filters.ColorMatrixFilter;
    import com.greensock.TweenLite;
    import com.greensock.*;

    public class ColorMatrixFilterPlugin extends FilterPlugin 
    {

        public static const API:Number = 1;
        private static var _propNames:Array = [];
        protected static var _idMatrix:Array = [1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1, 0];
        protected static var _lumR:Number = 0.212671;
        protected static var _lumG:Number = 0.71516;
        protected static var _lumB:Number = 0.072169;

        protected var _matrix:Array;
        protected var _matrixTween:EndArrayPlugin;

        public function ColorMatrixFilterPlugin()
        {
            this.propName = "colorMatrixFilter";
            this.overwriteProps = ["colorMatrixFilter"];
        }

        public static function colorize(_arg_1:Array, _arg_2:Number, _arg_3:Number=1):Array
        {
            if (isNaN(_arg_2))
            {
                return (_arg_1);
            };
            if (isNaN(_arg_3))
            {
                _arg_3 = 1;
            };
            var _local_4:Number = (((_arg_2 >> 16) & 0xFF) / 0xFF);
            var _local_5:Number = (((_arg_2 >> 8) & 0xFF) / 0xFF);
            var _local_6:Number = ((_arg_2 & 0xFF) / 0xFF);
            var _local_7:Number = (1 - _arg_3);
            var _local_8:Array = [(_local_7 + ((_arg_3 * _local_4) * _lumR)), ((_arg_3 * _local_4) * _lumG), ((_arg_3 * _local_4) * _lumB), 0, 0, ((_arg_3 * _local_5) * _lumR), (_local_7 + ((_arg_3 * _local_5) * _lumG)), ((_arg_3 * _local_5) * _lumB), 0, 0, ((_arg_3 * _local_6) * _lumR), ((_arg_3 * _local_6) * _lumG), (_local_7 + ((_arg_3 * _local_6) * _lumB)), 0, 0, 0, 0, 0, 1, 0];
            return (applyMatrix(_local_8, _arg_1));
        }

        public static function setThreshold(_arg_1:Array, _arg_2:Number):Array
        {
            if (isNaN(_arg_2))
            {
                return (_arg_1);
            };
            var _local_3:Array = [(_lumR * 0x0100), (_lumG * 0x0100), (_lumB * 0x0100), 0, (-256 * _arg_2), (_lumR * 0x0100), (_lumG * 0x0100), (_lumB * 0x0100), 0, (-256 * _arg_2), (_lumR * 0x0100), (_lumG * 0x0100), (_lumB * 0x0100), 0, (-256 * _arg_2), 0, 0, 0, 1, 0];
            return (applyMatrix(_local_3, _arg_1));
        }

        public static function setHue(_arg_1:Array, _arg_2:Number):Array
        {
            if (isNaN(_arg_2))
            {
                return (_arg_1);
            };
            _arg_2 = (_arg_2 * (Math.PI / 180));
            var _local_3:Number = Math.cos(_arg_2);
            var _local_4:Number = Math.sin(_arg_2);
            var _local_5:Array = [((_lumR + (_local_3 * (1 - _lumR))) + (_local_4 * -(_lumR))), ((_lumG + (_local_3 * -(_lumG))) + (_local_4 * -(_lumG))), ((_lumB + (_local_3 * -(_lumB))) + (_local_4 * (1 - _lumB))), 0, 0, ((_lumR + (_local_3 * -(_lumR))) + (_local_4 * 0.143)), ((_lumG + (_local_3 * (1 - _lumG))) + (_local_4 * 0.14)), ((_lumB + (_local_3 * -(_lumB))) + (_local_4 * -0.283)), 0, 0, ((_lumR + (_local_3 * -(_lumR))) + (_local_4 * -(1 - _lumR))), ((_lumG + (_local_3 * -(_lumG))) + (_local_4 * _lumG)), ((_lumB + (_local_3 * (1 - _lumB))) + (_local_4 * _lumB)), 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1];
            return (applyMatrix(_local_5, _arg_1));
        }

        public static function setBrightness(_arg_1:Array, _arg_2:Number):Array
        {
            if (isNaN(_arg_2))
            {
                return (_arg_1);
            };
            _arg_2 = ((_arg_2 * 100) - 100);
            return (applyMatrix([1, 0, 0, 0, _arg_2, 0, 1, 0, 0, _arg_2, 0, 0, 1, 0, _arg_2, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1], _arg_1));
        }

        public static function setSaturation(_arg_1:Array, _arg_2:Number):Array
        {
            if (isNaN(_arg_2))
            {
                return (_arg_1);
            };
            var _local_3:Number = (1 - _arg_2);
            var _local_4:Number = (_local_3 * _lumR);
            var _local_5:Number = (_local_3 * _lumG);
            var _local_6:Number = (_local_3 * _lumB);
            var _local_7:Array = [(_local_4 + _arg_2), _local_5, _local_6, 0, 0, _local_4, (_local_5 + _arg_2), _local_6, 0, 0, _local_4, _local_5, (_local_6 + _arg_2), 0, 0, 0, 0, 0, 1, 0];
            return (applyMatrix(_local_7, _arg_1));
        }

        public static function setContrast(_arg_1:Array, _arg_2:Number):Array
        {
            if (isNaN(_arg_2))
            {
                return (_arg_1);
            };
            _arg_2 = (_arg_2 + 0.01);
            var _local_3:Array = [_arg_2, 0, 0, 0, (128 * (1 - _arg_2)), 0, _arg_2, 0, 0, (128 * (1 - _arg_2)), 0, 0, _arg_2, 0, (128 * (1 - _arg_2)), 0, 0, 0, 1, 0];
            return (applyMatrix(_local_3, _arg_1));
        }

        public static function applyMatrix(_arg_1:Array, _arg_2:Array):Array
        {
            var _local_6:int;
            var _local_7:int;
            if (((!(_arg_1 is Array)) || (!(_arg_2 is Array))))
            {
                return (_arg_2);
            };
            var _local_3:Array = [];
            var _local_4:int;
            var _local_5:int;
            _local_6 = 0;
            while (_local_6 < 4)
            {
                _local_7 = 0;
                while (_local_7 < 5)
                {
                    if (_local_7 == 4)
                    {
                        _local_5 = _arg_1[(_local_4 + 4)];
                    }
                    else
                    {
                        _local_5 = 0;
                    };
                    _local_3[(_local_4 + _local_7)] = (((((_arg_1[_local_4] * _arg_2[_local_7]) + (_arg_1[(_local_4 + 1)] * _arg_2[(_local_7 + 5)])) + (_arg_1[(_local_4 + 2)] * _arg_2[(_local_7 + 10)])) + (_arg_1[(_local_4 + 3)] * _arg_2[(_local_7 + 15)])) + _local_5);
                    _local_7 = (_local_7 + 1);
                };
                _local_4 = (_local_4 + 5);
                _local_6 = (_local_6 + 1);
            };
            return (_local_3);
        }


        override public function onInitTween(_arg_1:Object, _arg_2:*, _arg_3:TweenLite):Boolean
        {
            _target = _arg_1;
            _type = ColorMatrixFilter;
            var _local_4:Object = _arg_2;
            initFilter({
                "remove":_arg_2.remove,
                "index":_arg_2.index,
                "addFilter":_arg_2.addFilter
            }, new ColorMatrixFilter(_idMatrix.slice()), _propNames);
            this._matrix = ColorMatrixFilter(_filter).matrix;
            var _local_5:Array = [];
            if (((!(_local_4.matrix == null)) && (_local_4.matrix is Array)))
            {
                _local_5 = _local_4.matrix;
            }
            else
            {
                if (_local_4.relative == true)
                {
                    _local_5 = this._matrix.slice();
                }
                else
                {
                    _local_5 = _idMatrix.slice();
                };
                _local_5 = setBrightness(_local_5, _local_4.brightness);
                _local_5 = setContrast(_local_5, _local_4.contrast);
                _local_5 = setHue(_local_5, _local_4.hue);
                _local_5 = setSaturation(_local_5, _local_4.saturation);
                _local_5 = setThreshold(_local_5, _local_4.threshold);
                if ((!(isNaN(_local_4.colorize))))
                {
                    _local_5 = colorize(_local_5, _local_4.colorize, _local_4.amount);
                };
            };
            this._matrixTween = new EndArrayPlugin();
            this._matrixTween.init(this._matrix, _local_5);
            return (true);
        }

        override public function set changeFactor(_arg_1:Number):void
        {
            this._matrixTween.changeFactor = _arg_1;
            ColorMatrixFilter(_filter).matrix = this._matrix;
            super.changeFactor = _arg_1;
        }


    }
}//package com.greensock.plugins
