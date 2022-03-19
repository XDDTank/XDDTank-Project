// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//phy.bombs.BaseBomb

package phy.bombs
{
    import phy.object.PhysicalObj;
    import flash.display.Sprite;
    import flash.display.Bitmap;
    import flash.geom.Rectangle;

    public class BaseBomb extends PhysicalObj 
    {

        protected var _movie:Sprite;
        protected var _shape:Bitmap;
        protected var _border:Bitmap;

        public function BaseBomb(_arg_1:int, _arg_2:Number=10, _arg_3:Number=100, _arg_4:Number=1, _arg_5:Number=1)
        {
            super(_arg_1, 1, _arg_2, _arg_3, _arg_4, _arg_5);
            _testRect = new Rectangle(-3, -3, 6, 6);
        }

        public function setMovie(_arg_1:Sprite, _arg_2:Bitmap, _arg_3:Bitmap):void
        {
            this._movie = _arg_1;
            if (this._movie)
            {
                this._movie.x = 0;
                this._movie.y = 0;
                addChild(this._movie);
            };
            this._shape = _arg_2;
            this._border = _arg_3;
        }

        override public function update(_arg_1:Number):void
        {
            super.update(_arg_1);
        }

        public function get bombRectang():Rectangle
        {
            if (((_map) && (this._shape)))
            {
                return (this._shape.getRect(_map));
            };
            return (new Rectangle((x - 200), (y - 200), 400, 400));
        }

        override protected function collideGround():void
        {
            this.bomb();
        }

        public function bomb():void
        {
            this.DigMap();
            this.die();
        }

        public function bombAtOnce():void
        {
        }

        protected function DigMap():void
        {
            if ((((this._shape) && (this._shape.width > 0)) && (this._shape.height > 0)))
            {
                _map.Dig(pos, this._shape, this._border);
            };
        }

        override public function die():void
        {
            super.die();
            if (_map)
            {
                _map.removePhysical(this);
            };
        }

        override public function dispose():void
        {
            super.dispose();
            if (((this._movie) && (this._movie.parent)))
            {
                this._movie.parent.removeChild(this._movie);
            };
            this._shape = null;
            this._border = null;
        }


    }
}//package phy.bombs

