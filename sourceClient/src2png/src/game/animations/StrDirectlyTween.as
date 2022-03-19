// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//game.animations.StrDirectlyTween

package game.animations
{
    import flash.display.DisplayObject;
    import flash.geom.Point;

    public class StrDirectlyTween extends BaseStageTween 
    {

        public function StrDirectlyTween(_arg_1:TweenObject=null)
        {
            super(_arg_1);
        }

        override public function get type():String
        {
            return ("StrDirectlyTween");
        }

        override public function update(_arg_1:DisplayObject):Point
        {
            _isFinished = true;
            return (target);
        }

        override protected function get propertysNeed():Array
        {
            return (["target"]);
        }


    }
}//package game.animations

