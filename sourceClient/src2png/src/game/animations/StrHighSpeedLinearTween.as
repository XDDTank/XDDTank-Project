// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//game.animations.StrHighSpeedLinearTween

package game.animations
{
    import flash.geom.Point;
    import flash.display.DisplayObject;

    public class StrHighSpeedLinearTween extends BaseStageTween 
    {

        private var _speed:int = 8;

        public function StrHighSpeedLinearTween(_arg_1:TweenObject=null)
        {
            super(_arg_1);
        }

        override public function update(_arg_1:DisplayObject):Point
        {
            if ((!(_prepared)))
            {
                return (null);
            };
            var _local_2:Point = new Point(_arg_1.x, _arg_1.y);
            var _local_3:Point = new Point((target.x - _arg_1.x), (target.y - _arg_1.y));
            if (_local_3.length >= this._speed)
            {
                _local_3.normalize(this._speed);
                _local_2.x = (_local_2.x + _local_3.x);
                _local_2.y = (_local_2.y + _local_3.y);
            }
            else
            {
                _local_2 = target;
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

