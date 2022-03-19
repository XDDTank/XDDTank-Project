// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//com.greensock.plugins.TransformAroundCenterPlugin

package com.greensock.plugins
{
    import flash.display.Sprite;
    import flash.display.DisplayObject;
    import flash.geom.Rectangle;
    import flash.geom.Point;
    import com.greensock.TweenLite;
    import flash.display.*;
    import flash.geom.*;
    import com.greensock.*;

    public class TransformAroundCenterPlugin extends TransformAroundPointPlugin 
    {

        public static const API:Number = 1;

        public function TransformAroundCenterPlugin()
        {
            this.propName = "transformAroundCenter";
        }

        override public function onInitTween(_arg_1:Object, _arg_2:*, _arg_3:TweenLite):Boolean
        {
            var _local_8:Sprite;
            var _local_4:Boolean;
            var _local_5:DisplayObject = (_arg_1 as DisplayObject);
            if (_local_5.parent == null)
            {
                _local_4 = true;
                _local_8 = new Sprite();
                _local_8.addChild(_local_5);
            };
            var _local_6:Rectangle = _local_5.getBounds(_local_5.parent);
            _arg_2.point = new Point((_local_6.x + (_local_6.width * 0.5)), (_local_6.y + (_local_6.height * 0.5)));
            if (_local_4)
            {
                _local_5.parent.removeChild(_local_5);
            };
            var _local_7:Boolean = super.onInitTween(_local_5, _arg_2, _arg_3);
            if (((_local_6.width < 1) || (_local_6.height < 1)))
            {
                _local_6 = _local_5.getBounds(_local_5);
                _local = new Point((_local_6.x + (_local_6.width * 0.5)), (_local_6.y + (_local_6.height * 0.5)));
            };
            return (_local_7);
        }


    }
}//package com.greensock.plugins

