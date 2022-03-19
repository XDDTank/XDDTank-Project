// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//com.pickgliss.geom.IntRectangle

package com.pickgliss.geom
{
    import flash.geom.Rectangle;

    public class IntRectangle 
    {

        public var x:int = 0;
        public var y:int = 0;
        public var width:int = 0;
        public var height:int = 0;

        public function IntRectangle(_arg_1:int=0, _arg_2:int=0, _arg_3:int=0, _arg_4:int=0)
        {
            this.setRectXYWH(_arg_1, _arg_2, _arg_3, _arg_4);
        }

        public static function creatWithRectangle(_arg_1:Rectangle):IntRectangle
        {
            return (new IntRectangle(_arg_1.x, _arg_1.y, _arg_1.width, _arg_1.height));
        }


        public function toRectangle():Rectangle
        {
            return (new Rectangle(this.x, this.y, this.width, this.height));
        }

        public function setWithRectangle(_arg_1:Rectangle):void
        {
            this.x = _arg_1.x;
            this.y = _arg_1.y;
            this.width = _arg_1.width;
            this.height = _arg_1.height;
        }

        public function setRect(_arg_1:IntRectangle):void
        {
            this.setRectXYWH(_arg_1.x, _arg_1.y, _arg_1.width, _arg_1.height);
        }

        public function setRectXYWH(_arg_1:int, _arg_2:int, _arg_3:int, _arg_4:int):void
        {
            this.x = _arg_1;
            this.y = _arg_2;
            this.width = _arg_3;
            this.height = _arg_4;
        }

        public function setLocation(_arg_1:IntPoint):void
        {
            this.x = _arg_1.x;
            this.y = _arg_1.y;
        }

        public function setSize(_arg_1:IntDimension):void
        {
            this.width = _arg_1.width;
            this.height = _arg_1.height;
        }

        public function getSize():IntDimension
        {
            return (new IntDimension(this.width, this.height));
        }

        public function getLocation():IntPoint
        {
            return (new IntPoint(this.x, this.y));
        }

        public function union(_arg_1:IntRectangle):IntRectangle
        {
            var _local_2:int = Math.min(this.x, _arg_1.x);
            var _local_3:int = Math.max((this.x + this.width), (_arg_1.x + _arg_1.width));
            var _local_4:int = Math.min(this.y, _arg_1.y);
            var _local_5:int = Math.max((this.y + this.height), (_arg_1.y + _arg_1.height));
            return (new IntRectangle(_local_2, _local_4, (_local_3 - _local_2), (_local_5 - _local_4)));
        }

        public function grow(_arg_1:int, _arg_2:int):void
        {
            this.x = (this.x - _arg_1);
            this.y = (this.y - _arg_2);
            this.width = (this.width + (_arg_1 * 2));
            this.height = (this.height + (_arg_2 * 2));
        }

        public function move(_arg_1:int, _arg_2:int):void
        {
            this.x = (this.x + _arg_1);
            this.y = (this.y + _arg_2);
        }

        public function resize(_arg_1:int=0, _arg_2:int=0):void
        {
            this.width = (this.width + _arg_1);
            this.height = (this.height + _arg_2);
        }

        public function leftTop():IntPoint
        {
            return (new IntPoint(this.x, this.y));
        }

        public function rightTop():IntPoint
        {
            return (new IntPoint((this.x + this.width), this.y));
        }

        public function leftBottom():IntPoint
        {
            return (new IntPoint(this.x, (this.y + this.height)));
        }

        public function rightBottom():IntPoint
        {
            return (new IntPoint((this.x + this.width), (this.y + this.height)));
        }

        public function containsPoint(_arg_1:IntPoint):Boolean
        {
            if (((((_arg_1.x < this.x) || (_arg_1.y < this.y)) || (_arg_1.x > (this.x + this.width))) || (_arg_1.y > (this.y + this.height))))
            {
                return (false);
            };
            return (true);
        }

        public function equals(_arg_1:Object):Boolean
        {
            var _local_2:IntRectangle = (_arg_1 as IntRectangle);
            if (_local_2 == null)
            {
                return (false);
            };
            return ((((this.x === _local_2.x) && (this.y === _local_2.y)) && (this.width === _local_2.width)) && (this.height === _local_2.height));
        }

        public function clone():IntRectangle
        {
            return (new IntRectangle(this.x, this.y, this.width, this.height));
        }

        public function toString():String
        {
            return (((((((("IntRectangle[x:" + this.x) + ",y:") + this.y) + ", width:") + this.width) + ",height:") + this.height) + "]");
        }


    }
}//package com.pickgliss.geom

