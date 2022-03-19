// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//com.greensock.plugins.DropShadowFilterPlugin

package com.greensock.plugins
{
    import flash.filters.DropShadowFilter;
    import com.greensock.TweenLite;
    import com.greensock.*;

    public class DropShadowFilterPlugin extends FilterPlugin 
    {

        public static const API:Number = 1;
        private static var _propNames:Array = ["distance", "angle", "color", "alpha", "blurX", "blurY", "strength", "quality", "inner", "knockout", "hideObject"];

        public function DropShadowFilterPlugin()
        {
            this.propName = "dropShadowFilter";
            this.overwriteProps = ["dropShadowFilter"];
        }

        override public function onInitTween(_arg_1:Object, _arg_2:*, _arg_3:TweenLite):Boolean
        {
            _target = _arg_1;
            _type = DropShadowFilter;
            initFilter(_arg_2, new DropShadowFilter(0, 45, 0, 0, 0, 0, 1, ((_arg_2.quality) || (2)), _arg_2.inner, _arg_2.knockout, _arg_2.hideObject), _propNames);
            return (true);
        }


    }
}//package com.greensock.plugins

