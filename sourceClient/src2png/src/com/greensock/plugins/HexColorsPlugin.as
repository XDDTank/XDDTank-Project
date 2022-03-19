// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//com.greensock.plugins.HexColorsPlugin

package com.greensock.plugins
{
    import com.greensock.TweenLite;
    import com.greensock.*;

    public class HexColorsPlugin extends TweenPlugin 
    {

        public static const API:Number = 1;

        protected var _colors:Array;

        public function HexColorsPlugin()
        {
            this.propName = "hexColors";
            this.overwriteProps = [];
            this._colors = [];
        }

        override public function onInitTween(_arg_1:Object, _arg_2:*, _arg_3:TweenLite):Boolean
        {
            var _local_4:String;
            for (_local_4 in _arg_2)
            {
                this.initColor(_arg_1, _local_4, uint(_arg_1[_local_4]), uint(_arg_2[_local_4]));
            };
            return (true);
        }

        public function initColor(_arg_1:Object, _arg_2:String, _arg_3:uint, _arg_4:uint):void
        {
            var _local_5:Number;
            var _local_6:Number;
            var _local_7:Number;
            if (_arg_3 != _arg_4)
            {
                _local_5 = (_arg_3 >> 16);
                _local_6 = ((_arg_3 >> 8) & 0xFF);
                _local_7 = (_arg_3 & 0xFF);
                this._colors[this._colors.length] = [_arg_1, _arg_2, _local_5, ((_arg_4 >> 16) - _local_5), _local_6, (((_arg_4 >> 8) & 0xFF) - _local_6), _local_7, ((_arg_4 & 0xFF) - _local_7)];
                this.overwriteProps[this.overwriteProps.length] = _arg_2;
            };
        }

        override public function killProps(_arg_1:Object):void
        {
            var _local_2:int = (this._colors.length - 1);
            while (_local_2 > -1)
            {
                if (_arg_1[this._colors[_local_2][1]] != undefined)
                {
                    this._colors.splice(_local_2, 1);
                };
                _local_2--;
            };
            super.killProps(_arg_1);
        }

        override public function set changeFactor(_arg_1:Number):void
        {
            var _local_3:Array;
            var _local_2:int = this._colors.length;
            while (--_local_2 > -1)
            {
                _local_3 = this._colors[_local_2];
                _local_3[0][_local_3[1]] = ((((_local_3[2] + (_arg_1 * _local_3[3])) << 16) | ((_local_3[4] + (_arg_1 * _local_3[5])) << 8)) | (_local_3[6] + (_arg_1 * _local_3[7])));
            };
        }


    }
}//package com.greensock.plugins

