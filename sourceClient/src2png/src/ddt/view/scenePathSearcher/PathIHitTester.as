// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//ddt.view.scenePathSearcher.PathIHitTester

package ddt.view.scenePathSearcher
{
    import flash.geom.Point;

    public interface PathIHitTester 
    {

        function isHit(_arg_1:Point):Boolean;
        function getNextMoveAblePoint(_arg_1:Point, _arg_2:Number, _arg_3:Number, _arg_4:Number):Point;

    }
}//package ddt.view.scenePathSearcher

