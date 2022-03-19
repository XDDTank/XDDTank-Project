// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//game.animations.DirectionMovingAnimation

package game.animations
{
    import game.view.map.MapView;

    public class DirectionMovingAnimation extends BaseAnimate 
    {

        public static const UP:String = "up";
        public static const DOWN:String = "down";
        public static const LEFT:String = "left";
        public static const RIGHT:String = "right";

        private var _dir:String;

        public function DirectionMovingAnimation(_arg_1:String)
        {
            this._dir = _arg_1;
            _level = AnimationLevel.MIDDLE;
        }

        override public function cancel():void
        {
            _finished = true;
        }

        override public function update(_arg_1:MapView):Boolean
        {
            switch (this._dir)
            {
                case RIGHT:
                    _arg_1.x = (_arg_1.x - 18);
                    break;
                case LEFT:
                    _arg_1.x = (_arg_1.x + 18);
                    break;
                case UP:
                    _arg_1.y = (_arg_1.y + 18);
                    break;
                case DOWN:
                    _arg_1.y = (_arg_1.y - 18);
                    break;
                default:
                    return (false);
            };
            return (true);
        }


    }
}//package game.animations

