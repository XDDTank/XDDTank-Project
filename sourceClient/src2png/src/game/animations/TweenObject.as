// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//game.animations.TweenObject

package game.animations
{
    import flash.geom.Point;

    public dynamic class TweenObject 
    {

        public var speed:uint;
        public var duration:uint;
        private var _x:Number;
        private var _y:Number;
        private var _strategy:String;

        public function TweenObject(_arg_1:Object=null)
        {
            var _local_2:*;
            super();
            for (_local_2 in _arg_1)
            {
                this[_local_2] = _arg_1[_local_2];
            };
        }

        public function set x(_arg_1:Number):void
        {
            this._x = _arg_1;
        }

        public function get x():Number
        {
            return (this._x);
        }

        public function set y(_arg_1:Number):void
        {
            this._y = _arg_1;
        }

        public function get y():Number
        {
            return (this._y);
        }

        public function set target(_arg_1:Point):void
        {
            this._x = _arg_1.x;
            this._y = _arg_1.y;
        }

        public function get target():Point
        {
            return (new Point(this._x, this._y));
        }

        public function set strategy(_arg_1:String):void
        {
            this._strategy = _arg_1;
        }

        public function get strategy():String
        {
            if (this._strategy)
            {
                return (this._strategy);
            };
            return ("default");
        }


    }
}//package game.animations

