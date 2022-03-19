// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//ddt.view.scenePathSearcher.SceneScene

package ddt.view.scenePathSearcher
{
    import flash.events.EventDispatcher;
    import flash.geom.Point;

    public class SceneScene extends EventDispatcher 
    {

        private var _hitTester:PathIHitTester;
        private var _pathSearcher:PathIPathSearcher;
        private var _x:Number;
        private var _y:Number;

        public function SceneScene()
        {
            this._pathSearcher = new PathRoboSearcher(18, 1000, 8);
            this._x = 0;
            this._y = 0;
        }

        public function get HitTester():PathIHitTester
        {
            return (this._hitTester);
        }

        public function get x():Number
        {
            return (this._x);
        }

        public function get y():Number
        {
            return (this._y);
        }

        public function set position(_arg_1:Point):void
        {
            if (((!(_arg_1.x == this._x)) || (!(_arg_1.y == this._y))))
            {
                this._x = _arg_1.x;
                this._y = _arg_1.y;
            };
        }

        public function get position():Point
        {
            return (new Point(this._x, this._y));
        }

        public function setPathSearcher(_arg_1:PathIPathSearcher):void
        {
            this._pathSearcher = _arg_1;
        }

        public function setHitTester(_arg_1:PathIHitTester):void
        {
            this._hitTester = _arg_1;
        }

        public function hit(_arg_1:Point):Boolean
        {
            return (this._hitTester.isHit(_arg_1));
        }

        public function searchPath(_arg_1:Point, _arg_2:Point):Array
        {
            return (this._pathSearcher.search(_arg_1, _arg_2, this._hitTester));
        }

        public function localToGlobal(_arg_1:Point):Point
        {
            return (new Point((_arg_1.x + this._x), (_arg_1.y + this._y)));
        }

        public function globalToLocal(_arg_1:Point):Point
        {
            return (new Point((_arg_1.x - this._x), (_arg_1.y - this._y)));
        }

        public function dispose():void
        {
            this._hitTester = null;
            this._pathSearcher = null;
        }


    }
}//package ddt.view.scenePathSearcher

