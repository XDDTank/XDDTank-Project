// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//game.motions.VerticalMoveMotionFunc

package game.motions
{
    public class VerticalMoveMotionFunc extends BaseMotionFunc 
    {

        private var speed:int;

        public function VerticalMoveMotionFunc(_arg_1:Object)
        {
            super(_arg_1);
        }

        override public function getVectorByTime(_arg_1:int):Object
        {
            _result = new Object();
            _result.x = this.speed;
            return (_result);
        }


    }
}//package game.motions

