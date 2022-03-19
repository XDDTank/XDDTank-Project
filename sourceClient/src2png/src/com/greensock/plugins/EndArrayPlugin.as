// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//com.greensock.plugins.EndArrayPlugin

package com.greensock.plugins
{
    import com.greensock.TweenLite;
    import com.greensock.*;

    public class EndArrayPlugin extends TweenPlugin 
    {

        public static const API:Number = 1;

        protected var _a:Array;
        protected var _info:Array = [];

        public function EndArrayPlugin()
        {
            this.propName = "endArray";
            this.overwriteProps = ["endArray"];
        }

        override public function onInitTween(_arg_1:Object, _arg_2:*, _arg_3:TweenLite):Boolean
        {
            if (((!(_arg_1 is Array)) || (!(_arg_2 is Array))))
            {
                return (false);
            };
            this.init((_arg_1 as Array), _arg_2);
            return (true);
        }

        public function init(_arg_1:Array, _arg_2:Array):void
        {
            this._a = _arg_1;
            var _local_3:int = _arg_2.length;
            while (_local_3--)
            {
                if (((!(_arg_1[_local_3] == _arg_2[_local_3])) && (!(_arg_1[_local_3] == null))))
                {
                    this._info[this._info.length] = new ArrayTweenInfo(_local_3, this._a[_local_3], (_arg_2[_local_3] - this._a[_local_3]));
                };
            };
        }

        override public function set changeFactor(_arg_1:Number):void
        {
            var _local_3:ArrayTweenInfo;
            var _local_4:Number;
            var _local_2:int = this._info.length;
            if (this.round)
            {
                while (_local_2--)
                {
                    _local_3 = this._info[_local_2];
                    _local_4 = (_local_3.start + (_local_3.change * _arg_1));
                    if (_local_4 > 0)
                    {
                        this._a[_local_3.index] = ((_local_4 + 0.5) >> 0);
                    }
                    else
                    {
                        this._a[_local_3.index] = ((_local_4 - 0.5) >> 0);
                    };
                };
            }
            else
            {
                while (_local_2--)
                {
                    _local_3 = this._info[_local_2];
                    this._a[_local_3.index] = (_local_3.start + (_local_3.change * _arg_1));
                };
            };
        }


    }
}//package com.greensock.plugins

class ArrayTweenInfo 
{

    public var index:uint;
    public var start:Number;
    public var change:Number;

    public function ArrayTweenInfo(_arg_1:uint, _arg_2:Number, _arg_3:Number)
    {
        this.index = _arg_1;
        this.start = _arg_2;
        this.change = _arg_3;
    }

}


