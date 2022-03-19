﻿// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//game.animations.StrLinearTween

package game.animations
{
    import flash.geom.Point;
    import flash.display.DisplayObject;

    public class StrLinearTween extends BaseStageTween 
    {

        private var _speed:int = 1;
        private var _duration:int = 0;

        public function StrLinearTween(_arg_1:TweenObject=null)
        {
            super(_arg_1);
        }

        override public function get type():String
        {
            return ("StrLinearTween");
        }

        override public function update(_arg_1:DisplayObject):Point
        {
            if ((!(_prepared)))
            {
                return (null);
            };
            var _local_2:Point = new Point(_arg_1.x, _arg_1.y);
            var _local_3:Point = new Point((target.x - _arg_1.x), (target.y - _arg_1.y));
            if (_local_3.length >= this.speed)
            {
                _local_3.normalize(this.speed);
                _local_2.x = (_local_2.x + _local_3.x);
                _local_2.y = (_local_2.y + _local_3.y);
            }
            else
            {
                _local_2 = target;
            };
            return (_local_2);
        }

        public function set speed(_arg_1:int):void
        {
            this._speed = _arg_1;
        }

        public function get speed():int
        {
            return (this._speed);
        }

        public function set duration(_arg_1:int):void
        {
            this._duration = _arg_1;
        }

        public function get duration():int
        {
            return (this._duration);
        }

        override protected function get propertysNeed():Array
        {
            return (["target", "speed", "duration"]);
        }


    }
}//package game.animations

