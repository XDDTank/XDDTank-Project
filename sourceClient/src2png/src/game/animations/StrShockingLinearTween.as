// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//game.animations.StrShockingLinearTween

package game.animations
{
    import flash.geom.Point;
    import flash.display.DisplayObject;

    public class StrShockingLinearTween extends StrLinearTween 
    {

        protected var shockingX:int;
        protected var shockingY:int;
        protected var shockingFreq:uint = 1;
        protected var life:uint;

        public function StrShockingLinearTween(_arg_1:TweenObject=null)
        {
            super(_arg_1);
            this.life = 0;
        }

        override public function get type():String
        {
            return ("StrShockingLinearTween");
        }

        override public function copyPropertyFromData(_arg_1:TweenObject):void
        {
            this.shockingX = _arg_1.shockingX;
            this.shockingY = _arg_1.shockingY;
            duration = _arg_1.duration;
            target = _arg_1.target;
            speed = _arg_1.speed;
        }

        override public function update(_arg_1:DisplayObject):Point
        {
            var _local_2:Point = super.update(_arg_1);
            if ((!(_local_2)))
            {
                return (null);
            };
            if (this.life == duration)
            {
                _isFinished = true;
                return (_local_2);
            };
            if (this.life == 0)
            {
                _local_2.x = (_local_2.x + this.shockingX);
                this.shockingX = -(this.shockingX);
                _local_2.y = (_local_2.y + this.shockingY);
                this.shockingY = -(this.shockingY);
            };
            this.life++;
            if ((this.life % this.shockingFreq) == 0)
            {
                _local_2.x = (_local_2.x + (this.shockingX * 2));
                this.shockingX = -(this.shockingX);
                _local_2.y = (_local_2.y + (this.shockingY * 2));
                this.shockingY = -(this.shockingY);
            };
            return (_local_2);
        }

        override protected function get propertysNeed():Array
        {
            return (["target", "speed", "shockingX", "shockingY", "shockingFreq"]);
        }


    }
}//package game.animations

