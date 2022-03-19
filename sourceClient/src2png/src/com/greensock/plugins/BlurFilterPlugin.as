// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//com.greensock.plugins.BlurFilterPlugin

package com.greensock.plugins
{
    import flash.filters.BlurFilter;
    import com.greensock.TweenLite;
    import com.greensock.*;

    public class BlurFilterPlugin extends FilterPlugin 
    {

        public static const API:Number = 1;
        private static var _propNames:Array = ["blurX", "blurY", "quality"];

        public function BlurFilterPlugin()
        {
            this.propName = "blurFilter";
            this.overwriteProps = ["blurFilter"];
        }

        override public function onInitTween(_arg_1:Object, _arg_2:*, _arg_3:TweenLite):Boolean
        {
            _target = _arg_1;
            _type = BlurFilter;
            initFilter(_arg_2, new BlurFilter(0, 0, ((_arg_2.quality) || (2))), _propNames);
            return (true);
        }


    }
}//package com.greensock.plugins

