// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//com.greensock.plugins.FrameLabelPlugin

package com.greensock.plugins
{
    import flash.display.MovieClip;
    import com.greensock.TweenLite;
    import flash.display.*;
    import com.greensock.*;

    public class FrameLabelPlugin extends FramePlugin 
    {

        public static const API:Number = 1;

        public function FrameLabelPlugin()
        {
            this.propName = "frameLabel";
        }

        override public function onInitTween(_arg_1:Object, _arg_2:*, _arg_3:TweenLite):Boolean
        {
            if (((!(_arg_3.target)) is MovieClip))
            {
                return (false);
            };
            _target = (_arg_1 as MovieClip);
            this.frame = _target.currentFrame;
            var _local_4:Array = _target.currentLabels;
            var _local_5:String = _arg_2;
            var _local_6:int = _target.currentFrame;
            var _local_7:int = _local_4.length;
            while (_local_7--)
            {
                if (_local_4[_local_7].name == _local_5)
                {
                    _local_6 = _local_4[_local_7].frame;
                    break;
                };
            };
            if (this.frame != _local_6)
            {
                addTween(this, "frame", this.frame, _local_6, "frame");
            };
            return (true);
        }


    }
}//package com.greensock.plugins

