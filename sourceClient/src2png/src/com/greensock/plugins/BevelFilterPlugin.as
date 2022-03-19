// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//com.greensock.plugins.BevelFilterPlugin

package com.greensock.plugins
{
    import flash.filters.BevelFilter;
    import com.greensock.TweenLite;
    import com.greensock.*;

    public class BevelFilterPlugin extends FilterPlugin 
    {

        public static const API:Number = 1;
        private static var _propNames:Array = ["distance", "angle", "highlightColor", "highlightAlpha", "shadowColor", "shadowAlpha", "blurX", "blurY", "strength", "quality"];

        public function BevelFilterPlugin()
        {
            this.propName = "bevelFilter";
            this.overwriteProps = ["bevelFilter"];
        }

        override public function onInitTween(_arg_1:Object, _arg_2:*, _arg_3:TweenLite):Boolean
        {
            _target = _arg_1;
            _type = BevelFilter;
            initFilter(_arg_2, new BevelFilter(0, 0, 0xFFFFFF, 0.5, 0, 0.5, 2, 2, 0, ((_arg_2.quality) || (2))), _propNames);
            return (true);
        }


    }
}//package com.greensock.plugins

