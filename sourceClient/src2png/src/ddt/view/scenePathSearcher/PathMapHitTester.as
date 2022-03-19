// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//ddt.view.scenePathSearcher.PathMapHitTester

package ddt.view.scenePathSearcher
{
    import flash.display.Sprite;
    import flash.geom.Point;
    import ddt.utils.Geometry;

    public class PathMapHitTester implements PathIHitTester 
    {

        private var mc:Sprite;

        public function PathMapHitTester(_arg_1:Sprite)
        {
            this.mc = _arg_1;
        }

        public function isHit(_arg_1:Point):Boolean
        {
            var _local_2:Point = this.mc.localToGlobal(_arg_1);
            return (this.mc.hitTestPoint(_local_2.x, _local_2.y, true));
        }

        public function getNextMoveAblePoint(_arg_1:Point, _arg_2:Number, _arg_3:Number, _arg_4:Number):Point
        {
            var _local_5:Number = 0;
            while (this.isHit(_arg_1))
            {
                _arg_1 = Geometry.nextPoint(_arg_1, _arg_2, _arg_3);
                _local_5 = (_local_5 + _arg_3);
                if (_local_5 > _arg_4)
                {
                    return (null);
                };
            };
            return (_arg_1);
        }


    }
}//package ddt.view.scenePathSearcher

