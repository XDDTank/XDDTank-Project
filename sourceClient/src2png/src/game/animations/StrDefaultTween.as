// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//game.animations.StrDefaultTween

package game.animations
{
    import flash.geom.Point;
    import flash.display.DisplayObject;

    public class StrDefaultTween extends BaseStageTween 
    {

        protected var speed:int = 4;

        public function StrDefaultTween(_arg_1:TweenObject=null)
        {
            super(_arg_1);
        }

        override public function get type():String
        {
            return ("StrDefaultTween");
        }

        override public function copyPropertyFromData(_arg_1:TweenObject):void
        {
            if (_arg_1.target)
            {
                target = _arg_1.target;
            };
            if (_arg_1.speed)
            {
                this.speed = _arg_1.speed;
            };
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
                _local_3.normalize(((_local_3.length / 16) * this.speed));
                _local_2.x = (_local_2.x + _local_3.x);
                _local_2.y = (_local_2.y + _local_3.y);
            }
            else
            {
                _local_2.x = (_local_2.x + _local_3.x);
                _local_2.y = (_local_2.y + _local_3.y);
                _isFinished = true;
            };
            return (_local_2);
        }

        override protected function get propertysNeed():Array
        {
            return (["target", "speed"]);
        }


    }
}//package game.animations

