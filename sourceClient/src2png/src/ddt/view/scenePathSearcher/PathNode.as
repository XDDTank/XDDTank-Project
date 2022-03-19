// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//ddt.view.scenePathSearcher.PathNode

package ddt.view.scenePathSearcher
{
    import flash.geom.Point;

    public class PathNode 
    {

        public var costFromStart:int = 0;
        public var costToGoal:int = 0;
        public var totalCost:int = 0;
        public var location:Point;
        public var parent:PathNode;


        public function equals(_arg_1:PathNode):Boolean
        {
            return (_arg_1.location.equals(this.location));
        }

        public function toString():String
        {
            return ((((((((("x=" + this.location.x) + " y=") + this.location.y) + " G=") + this.costFromStart) + " H=") + this.costToGoal) + " F=") + this.totalCost);
        }


    }
}//package ddt.view.scenePathSearcher

