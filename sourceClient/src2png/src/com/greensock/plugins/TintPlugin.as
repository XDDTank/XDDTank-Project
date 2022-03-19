// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//com.greensock.plugins.TintPlugin

package com.greensock.plugins
{
    import flash.geom.Transform;
    import flash.geom.ColorTransform;
    import flash.display.DisplayObject;
    import com.greensock.TweenLite;
    import com.greensock.core.PropTween;
    import flash.display.*;
    import com.greensock.*;
    import com.greensock.core.*;

    public class TintPlugin extends TweenPlugin 
    {

        public static const API:Number = 1;
        protected static var _props:Array = ["redMultiplier", "greenMultiplier", "blueMultiplier", "alphaMultiplier", "redOffset", "greenOffset", "blueOffset", "alphaOffset"];

        protected var _transform:Transform;
        protected var _ct:ColorTransform;
        protected var _ignoreAlpha:Boolean;

        public function TintPlugin()
        {
            this.propName = "tint";
            this.overwriteProps = ["tint"];
        }

        override public function onInitTween(_arg_1:Object, _arg_2:*, _arg_3:TweenLite):Boolean
        {
            if ((!(_arg_1 is DisplayObject)))
            {
                return (false);
            };
            var _local_4:ColorTransform = new ColorTransform();
            if (((!(_arg_2 == null)) && (!(_arg_3.vars.removeTint == true))))
            {
                _local_4.color = uint(_arg_2);
            };
            this._ignoreAlpha = true;
            this.init((_arg_1 as DisplayObject), _local_4);
            return (true);
        }

        public function init(_arg_1:DisplayObject, _arg_2:ColorTransform):void
        {
            var _local_4:String;
            this._transform = _arg_1.transform;
            this._ct = this._transform.colorTransform;
            var _local_3:int = _props.length;
            while (_local_3--)
            {
                _local_4 = _props[_local_3];
                if (this._ct[_local_4] != _arg_2[_local_4])
                {
                    _tweens[_tweens.length] = new PropTween(this._ct, _local_4, this._ct[_local_4], (_arg_2[_local_4] - this._ct[_local_4]), "tint", false);
                };
            };
        }

        override public function set changeFactor(_arg_1:Number):void
        {
            var _local_2:ColorTransform;
            updateTweens(_arg_1);
            if (this._ignoreAlpha)
            {
                _local_2 = this._transform.colorTransform;
                this._ct.alphaMultiplier = _local_2.alphaMultiplier;
                this._ct.alphaOffset = _local_2.alphaOffset;
            };
            this._transform.colorTransform = this._ct;
        }


    }
}//package com.greensock.plugins

