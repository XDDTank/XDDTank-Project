// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//com.greensock.plugins.ShortRotationPlugin

package com.greensock.plugins
{
    import com.greensock.TweenLite;
    import com.greensock.*;

    public class ShortRotationPlugin extends TweenPlugin 
    {

        public static const API:Number = 1;

        public function ShortRotationPlugin()
        {
            this.propName = "shortRotation";
            this.overwriteProps = [];
        }

        override public function onInitTween(_arg_1:Object, _arg_2:*, _arg_3:TweenLite):Boolean
        {
            var _local_4:String;
            if (typeof(_arg_2) == "number")
            {
                return (false);
            };
            for (_local_4 in _arg_2)
            {
                this.initRotation(_arg_1, _local_4, _arg_1[_local_4], ((typeof(_arg_2[_local_4]) == "number") ? Number(_arg_2[_local_4]) : (_arg_1[_local_4] + Number(_arg_2[_local_4]))));
            };
            return (true);
        }

        public function initRotation(_arg_1:Object, _arg_2:String, _arg_3:Number, _arg_4:Number):void
        {
            var _local_5:Number = ((_arg_4 - _arg_3) % 360);
            if (_local_5 != (_local_5 % 180))
            {
                _local_5 = ((_local_5 < 0) ? (_local_5 + 360) : (_local_5 - 360));
            };
            addTween(_arg_1, _arg_2, _arg_3, (_arg_3 + _local_5), _arg_2);
            this.overwriteProps[this.overwriteProps.length] = _arg_2;
        }


    }
}//package com.greensock.plugins

