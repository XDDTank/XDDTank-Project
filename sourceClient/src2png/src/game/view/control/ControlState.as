﻿// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//game.view.control.ControlState

package game.view.control
{
    import flash.display.Sprite;
    import com.pickgliss.ui.core.Disposeable;
    import game.model.LocalPlayer;
    import flash.display.DisplayObjectContainer;
    import flash.display.DisplayObject;
    import com.greensock.TweenLite;
    import com.pickgliss.utils.ObjectUtils;

    public class ControlState extends Sprite implements Disposeable 
    {

        protected var _self:LocalPlayer;
        protected var _container:DisplayObjectContainer;
        protected var _leavingFunc:Function;
        protected var _background:DisplayObject;

        public function ControlState(_arg_1:LocalPlayer)
        {
            this._self = _arg_1;
            this.configUI();
        }

        protected function configUI():void
        {
        }

        protected function addEvent():void
        {
        }

        protected function removeEvent():void
        {
        }

        public function enter(_arg_1:DisplayObjectContainer):void
        {
            this._leavingFunc = null;
            this._container = _arg_1;
            this._container.addChild(this);
            this.addEvent();
            this.tweenIn();
        }

        public function tweenIn():void
        {
            y = 600;
            TweenLite.to(this, 0.3, {
                "y":(600 - height),
                "onComplete":this.enterComplete
            });
        }

        public function tweenOut():void
        {
            TweenLite.to(this, 0.3, {
                "y":600,
                "onComplete":this.leavingComplete
            });
        }

        public function leaving(_arg_1:Function=null):void
        {
            this._leavingFunc = _arg_1;
            this.removeEvent();
            this.tweenOut();
        }

        protected function enterComplete():void
        {
        }

        protected function leavingComplete():void
        {
            if (parent)
            {
                parent.removeChild(this);
            };
            if (this._leavingFunc != null)
            {
                this._leavingFunc.apply();
            };
        }

        public function dispose():void
        {
            this.removeEvent();
            TweenLite.killTweensOf(this);
            ObjectUtils.disposeObject(this._background);
            this._background = null;
            if (parent)
            {
                parent.removeChild(this);
            };
        }


    }
}//package game.view.control
