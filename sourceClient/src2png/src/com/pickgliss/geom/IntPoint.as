// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//com.pickgliss.geom.IntPoint

package com.pickgliss.geom
{
    import flash.geom.Point;

    public class IntPoint 
    {

        public var x:int = 0;
        public var y:int = 0;

        public function IntPoint(_arg_1:int=0, _arg_2:int=0)
        {
            this.x = _arg_1;
            this.y = _arg_2;
        }

        public static function creatWithPoint(_arg_1:Point):IntPoint
        {
            return (new IntPoint(_arg_1.x, _arg_1.y));
        }


        public function toPoint():Point
        {
            return (new Point(this.x, this.y));
        }

        public function setWithPoint(_arg_1:Point):void
        {
            this.x = _arg_1.x;
            this.y = _arg_1.y;
        }

        public function setLocation(_arg_1:IntPoint):void
        {
            this.x = _arg_1.x;
            this.y = _arg_1.y;
        }

        public function setLocationXY(_arg_1:int=0, _arg_2:int=0):void
        {
            this.x = _arg_1;
            this.y = _arg_2;
        }

        public function move(_arg_1:int, _arg_2:int):IntPoint
        {
            this.x = (this.x + _arg_1);
            this.y = (this.y + _arg_2);
            return (this);
        }

        public function moveRadians(_arg_1:int, _arg_2:int):IntPoint
        {
            this.x = (this.x + Math.round((Math.cos(_arg_1) * _arg_2)));
            this.y = (this.y + Math.round((Math.sin(_arg_1) * _arg_2)));
            return (this);
        }

        public function nextPoint(_arg_1:Number, _arg_2:Number):IntPoint
        {
            return (new IntPoint((this.x + (Math.cos(_arg_1) * _arg_2)), (this.y + (Math.sin(_arg_1) * _arg_2))));
        }

        public function distanceSq(_arg_1:IntPoint):int
        {
            var _local_2:int = _arg_1.x;
            var _local_3:int = _arg_1.y;
            return (((this.x - _local_2) * (this.x - _local_2)) + ((this.y - _local_3) * (this.y - _local_3)));
        }

        public function distance(_arg_1:IntPoint):int
        {
            return (Math.sqrt(this.distanceSq(_arg_1)));
        }

        public function equals(_arg_1:Object):Boolean
        {
            var _local_2:IntPoint = (_arg_1 as IntPoint);
            if (_local_2 == null)
            {
                return (false);
            };
            return ((this.x === _local_2.x) && (this.y === _local_2.y));
        }

        public function clone():IntPoint
        {
            return (new IntPoint(this.x, this.y));
        }

        public function toString():String
        {
            return (((("IntPoint[" + this.x) + ",") + this.y) + "]");
        }


    }
}//package com.pickgliss.geom

