// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//com.greensock.plugins.FilterPlugin

package com.greensock.plugins
{
    import flash.filters.BitmapFilter;
    import com.greensock.core.PropTween;
    import com.greensock.core.*;
    import flash.filters.*;

    public class FilterPlugin extends TweenPlugin 
    {

        public static const VERSION:Number = 2.03;
        public static const API:Number = 1;

        protected var _target:Object;
        protected var _type:Class;
        protected var _filter:BitmapFilter;
        protected var _index:int;
        protected var _remove:Boolean;


        protected function initFilter(_arg_1:Object, _arg_2:BitmapFilter, _arg_3:Array):void
        {
            var _local_5:String;
            var _local_6:int;
            var _local_7:HexColorsPlugin;
            var _local_4:Array = this._target.filters;
            var _local_8:Object = ((_arg_1 is BitmapFilter) ? {} : _arg_1);
            this._index = -1;
            if (_local_8.index != null)
            {
                this._index = _local_8.index;
            }
            else
            {
                _local_6 = _local_4.length;
                while (_local_6--)
                {
                    if ((_local_4[_local_6] is this._type))
                    {
                        this._index = _local_6;
                        break;
                    };
                };
            };
            if ((((this._index == -1) || (_local_4[this._index] == null)) || (_local_8.addFilter == true)))
            {
                this._index = ((_local_8.index != null) ? _local_8.index : _local_4.length);
                _local_4[this._index] = _arg_2;
                this._target.filters = _local_4;
            };
            this._filter = _local_4[this._index];
            if (_local_8.remove == true)
            {
                this._remove = true;
                this.onComplete = this.onCompleteTween;
            };
            _local_6 = _arg_3.length;
            while (_local_6--)
            {
                _local_5 = _arg_3[_local_6];
                if (((_local_5 in _arg_1) && (!(this._filter[_local_5] == _arg_1[_local_5]))))
                {
                    if ((((_local_5 == "color") || (_local_5 == "highlightColor")) || (_local_5 == "shadowColor")))
                    {
                        _local_7 = new HexColorsPlugin();
                        _local_7.initColor(this._filter, _local_5, this._filter[_local_5], _arg_1[_local_5]);
                        _tweens[_tweens.length] = new PropTween(_local_7, "changeFactor", 0, 1, _local_5, false);
                    }
                    else
                    {
                        if (((((_local_5 == "quality") || (_local_5 == "inner")) || (_local_5 == "knockout")) || (_local_5 == "hideObject")))
                        {
                            this._filter[_local_5] = _arg_1[_local_5];
                        }
                        else
                        {
                            addTween(this._filter, _local_5, this._filter[_local_5], _arg_1[_local_5], _local_5);
                        };
                    };
                };
            };
        }

        public function onCompleteTween():void
        {
            var _local_1:Array;
            var _local_2:int;
            if (this._remove)
            {
                _local_1 = this._target.filters;
                if ((!(_local_1[this._index] is this._type)))
                {
                    _local_2 = _local_1.length;
                    while (_local_2--)
                    {
                        if ((_local_1[_local_2] is this._type))
                        {
                            _local_1.splice(_local_2, 1);
                            break;
                        };
                    };
                }
                else
                {
                    _local_1.splice(this._index, 1);
                };
                this._target.filters = _local_1;
            };
        }

        override public function set changeFactor(_arg_1:Number):void
        {
            var _local_3:PropTween;
            var _local_2:int = _tweens.length;
            var _local_4:Array = this._target.filters;
            while (_local_2--)
            {
                _local_3 = _tweens[_local_2];
                _local_3.target[_local_3.property] = (_local_3.start + (_local_3.change * _arg_1));
            };
            if ((!(_local_4[this._index] is this._type)))
            {
                _local_2 = (this._index = _local_4.length);
                while (_local_2--)
                {
                    if ((_local_4[_local_2] is this._type))
                    {
                        this._index = _local_2;
                        break;
                    };
                };
            };
            _local_4[this._index] = this._filter;
            this._target.filters = _local_4;
        }


    }
}//package com.greensock.plugins

