// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//game.motions.ExplosionMotionFunc

package game.motions
{
    public class ExplosionMotionFunc extends BaseMotionFunc 
    {

        private static var D:int = 10;

        public function ExplosionMotionFunc(_arg_1:Object)
        {
            super(_arg_1);
        }

        override public function getVectorByTime(_arg_1:int):Object
        {
            switch ((_arg_1 % 4))
            {
                case 0:
                    _result.x = -(D);
                    _result.y = -(D);
                    break;
                case 1:
                    _result.x = D;
                    _result.y = D;
                    break;
                case 2:
                    _result.x = -(D);
                    _result.y = D;
                    break;
                case 3:
                    _result.x = D;
                    _result.y = -(D);
                    break;
            };
            return (_result);
        }


    }
}//package game.motions

