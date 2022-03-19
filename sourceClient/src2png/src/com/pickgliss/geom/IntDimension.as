// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//com.pickgliss.geom.IntDimension

package com.pickgliss.geom
{
    public class IntDimension 
    {

        public var width:int = 0;
        public var height:int = 0;

        public function IntDimension(_arg_1:int=0, _arg_2:int=0)
        {
            this.width = _arg_1;
            this.height = _arg_2;
        }

        public static function createBigDimension():IntDimension
        {
            return (new IntDimension(100000, 100000));
        }


        public function setSize(_arg_1:IntDimension):void
        {
            this.width = _arg_1.width;
            this.height = _arg_1.height;
        }

        public function setSizeWH(_arg_1:int, _arg_2:int):void
        {
            this.width = _arg_1;
            this.height = _arg_2;
        }

        public function increaseSize(_arg_1:IntDimension):IntDimension
        {
            this.width = (this.width + _arg_1.width);
            this.height = (this.height + _arg_1.height);
            return (this);
        }

        public function decreaseSize(_arg_1:IntDimension):IntDimension
        {
            this.width = (this.width - _arg_1.width);
            this.height = (this.height - _arg_1.height);
            return (this);
        }

        public function change(_arg_1:int, _arg_2:int):IntDimension
        {
            this.width = (this.width + _arg_1);
            this.height = (this.height + _arg_2);
            return (this);
        }

        public function changedSize(_arg_1:int, _arg_2:int):IntDimension
        {
            return (new IntDimension(_arg_1, _arg_2));
        }

        public function combine(_arg_1:IntDimension):IntDimension
        {
            this.width = Math.max(this.width, _arg_1.width);
            this.height = Math.max(this.height, _arg_1.height);
            return (this);
        }

        public function combineSize(_arg_1:IntDimension):IntDimension
        {
            return (this.clone().combine(_arg_1));
        }

        public function getBounds(_arg_1:int=0, _arg_2:int=0):IntRectangle
        {
            var _local_3:IntPoint = new IntPoint(_arg_1, _arg_2);
            var _local_4:IntRectangle = new IntRectangle();
            _local_4.setLocation(_local_3);
            _local_4.setSize(this);
            return (_local_4);
        }

        public function equals(_arg_1:Object):Boolean
        {
            var _local_2:IntDimension = (_arg_1 as IntDimension);
            if (_local_2 == null)
            {
                return (false);
            };
            return ((this.width === _local_2.width) && (this.height === _local_2.height));
        }

        public function clone():IntDimension
        {
            return (new IntDimension(this.width, this.height));
        }

        public function toString():String
        {
            return (((("IntDimension[" + this.width) + ",") + this.height) + "]");
        }


    }
}//package com.pickgliss.geom

