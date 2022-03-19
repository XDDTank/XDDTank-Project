// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//com.greensock.plugins.VisiblePlugin

package com.greensock.plugins
{
    import com.greensock.TweenLite;
    import com.greensock.*;

    public class VisiblePlugin extends TweenPlugin 
    {

        public static const API:Number = 1;

        protected var _target:Object;
        protected var _tween:TweenLite;
        protected var _visible:Boolean;
        protected var _initVal:Boolean;

        public function VisiblePlugin()
        {
            this.propName = "visible";
            this.overwriteProps = ["visible"];
        }

        override public function onInitTween(_arg_1:Object, _arg_2:*, _arg_3:TweenLite):Boolean
        {
            this._target = _arg_1;
            this._tween = _arg_3;
            this._initVal = this._target.visible;
            this._visible = Boolean(_arg_2);
            return (true);
        }

        override public function set changeFactor(_arg_1:Number):void
        {
            if (((_arg_1 == 1) && ((this._tween.cachedDuration == this._tween.cachedTime) || (this._tween.cachedTime == 0))))
            {
                this._target.visible = this._visible;
            }
            else
            {
                this._target.visible = this._initVal;
            };
        }


    }
}//package com.greensock.plugins

