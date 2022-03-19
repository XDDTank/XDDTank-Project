// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//com.greensock.plugins.ColorTransformPlugin

package com.greensock.plugins
{
    import flash.display.DisplayObject;
    import flash.geom.ColorTransform;
    import com.greensock.TweenLite;
    import flash.display.*;
    import com.greensock.*;

    public class ColorTransformPlugin extends TintPlugin 
    {

        public static const API:Number = 1;

        public function ColorTransformPlugin()
        {
            this.propName = "colorTransform";
        }

        override public function onInitTween(_arg_1:Object, _arg_2:*, _arg_3:TweenLite):Boolean
        {
            var _local_5:String;
            var _local_6:Number;
            if ((!(_arg_1 is DisplayObject)))
            {
                return (false);
            };
            var _local_4:ColorTransform = _arg_1.transform.colorTransform;
            for (_local_5 in _arg_2)
            {
                if (((_local_5 == "tint") || (_local_5 == "color")))
                {
                    if (_arg_2[_local_5] != null)
                    {
                        _local_4.color = int(_arg_2[_local_5]);
                    };
                }
                else
                {
                    if (!(((_local_5 == "tintAmount") || (_local_5 == "exposure")) || (_local_5 == "brightness")))
                    {
                        _local_4[_local_5] = _arg_2[_local_5];
                    };
                };
            };
            if ((!(isNaN(_arg_2.tintAmount))))
            {
                _local_6 = (_arg_2.tintAmount / (1 - (((_local_4.redMultiplier + _local_4.greenMultiplier) + _local_4.blueMultiplier) / 3)));
                _local_4.redOffset = (_local_4.redOffset * _local_6);
                _local_4.greenOffset = (_local_4.greenOffset * _local_6);
                _local_4.blueOffset = (_local_4.blueOffset * _local_6);
                _local_4.redMultiplier = (_local_4.greenMultiplier = (_local_4.blueMultiplier = (1 - _arg_2.tintAmount)));
            }
            else
            {
                if ((!(isNaN(_arg_2.exposure))))
                {
                    _local_4.redOffset = (_local_4.greenOffset = (_local_4.blueOffset = (0xFF * (_arg_2.exposure - 1))));
                    _local_4.redMultiplier = (_local_4.greenMultiplier = (_local_4.blueMultiplier = 1));
                }
                else
                {
                    if ((!(isNaN(_arg_2.brightness))))
                    {
                        _local_4.redOffset = (_local_4.greenOffset = (_local_4.blueOffset = Math.max(0, ((_arg_2.brightness - 1) * 0xFF))));
                        _local_4.redMultiplier = (_local_4.greenMultiplier = (_local_4.blueMultiplier = (1 - Math.abs((_arg_2.brightness - 1)))));
                    };
                };
            };
            _ignoreAlpha = Boolean(((!(_arg_3.vars.alpha == undefined)) && (_arg_2.alphaMultiplier == undefined)));
            init((_arg_1 as DisplayObject), _local_4);
            return (true);
        }


    }
}//package com.greensock.plugins

