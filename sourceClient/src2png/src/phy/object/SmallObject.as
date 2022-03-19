// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//phy.object.SmallObject

package phy.object
{
    import flash.display.Shape;
    import flash.geom.Point;

    public class SmallObject extends Shape 
    {

        protected static const MovieTime:Number = 0.6;

        protected var _elapsed:int = 0;
        protected var _color:int = 0xFF0000;
        protected var _radius:int = 4;
        private var _pos:Point = new Point();
        protected var _isAttacking:Boolean = false;
        public var onProcess:Boolean = false;

        public function SmallObject()
        {
            this.draw();
        }

        override public function set visible(_arg_1:Boolean):void
        {
            super.visible = _arg_1;
        }

        public function get color():int
        {
            return (this._color);
        }

        public function set color(_arg_1:int):void
        {
            this._color = _arg_1;
            this.draw();
        }

        public function get onMap():Boolean
        {
            return (!(parent == null));
        }

        protected function draw():void
        {
        }

        public function onFrame(_arg_1:int):void
        {
        }

        public function dispose():void
        {
            if (parent)
            {
                parent.removeChild(this);
            };
        }

        public function get pos():Point
        {
            return (this._pos);
        }

        public function set isAttacking(_arg_1:Boolean):void
        {
            this._isAttacking = _arg_1;
        }

        public function get isAttacking():Boolean
        {
            return (this._isAttacking);
        }


    }
}//package phy.object

