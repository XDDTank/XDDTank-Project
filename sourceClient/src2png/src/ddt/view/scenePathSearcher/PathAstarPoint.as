// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//ddt.view.scenePathSearcher.PathAstarPoint

package ddt.view.scenePathSearcher
{
    import flash.geom.Point;

    public class PathAstarPoint extends Point 
    {

        public var g:int;
        public var h:int;
        public var f:int;
        public var source_point:PathAstarPoint;

        public function PathAstarPoint(_arg_1:int=0, _arg_2:int=0)
        {
            super(_arg_1, _arg_2);
            this.source_point = null;
        }

    }
}//package ddt.view.scenePathSearcher

