// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//game.animations.StrStayTween

package game.animations
{
    import flash.geom.Point;
    import flash.display.DisplayObject;

    public class StrStayTween extends BaseStageTween 
    {

        public function StrStayTween(_arg_1:TweenObject=null)
        {
            super(_arg_1);
        }

        override public function get type():String
        {
            return ("StrStay");
        }

        override public function get isFinished():Boolean
        {
            return (true);
        }

        override public function update(_arg_1:DisplayObject):Point
        {
            if ((!(_prepared)))
            {
                return (null);
            };
            return (new Point(_arg_1.x, _arg_1.y));
        }


    }
}//package game.animations

