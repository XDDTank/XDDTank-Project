// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//com.pickgliss.ui.controls.BoundedRangeModel

package com.pickgliss.ui.controls
{
    import flash.events.EventDispatcher;
    import com.pickgliss.events.InteractiveEvent;

    public class BoundedRangeModel extends EventDispatcher 
    {

        private var value:int;
        private var extent:int;
        private var min:int;
        private var max:int;
        private var isAdjusting:Boolean;

        public function BoundedRangeModel(_arg_1:int=0, _arg_2:int=0, _arg_3:int=0, _arg_4:int=100)
        {
            this.isAdjusting = false;
            if (((((_arg_4 >= _arg_3) && (_arg_1 >= _arg_3)) && ((_arg_1 + _arg_2) >= _arg_1)) && ((_arg_1 + _arg_2) <= _arg_4)))
            {
                this.value = _arg_1;
                this.extent = _arg_2;
                this.min = _arg_3;
                this.max = _arg_4;
            }
            else
            {
                throw (new RangeError("invalid range properties"));
            };
        }

        public function getValue():int
        {
            return (this.value);
        }

        public function getExtent():int
        {
            return (this.extent);
        }

        public function getMinimum():int
        {
            return (this.min);
        }

        public function getMaximum():int
        {
            return (this.max);
        }

        public function setValue(_arg_1:int):void
        {
            _arg_1 = Math.min(_arg_1, (this.max - this.extent));
            var _local_2:int = Math.max(_arg_1, this.min);
            this.setRangeProperties(_local_2, this.extent, this.min, this.max, this.isAdjusting);
        }

        public function setExtent(_arg_1:int):void
        {
            var _local_2:int = Math.max(0, _arg_1);
            if ((this.value + _local_2) > this.max)
            {
                _local_2 = (this.max - this.value);
            };
            this.setRangeProperties(this.value, _local_2, this.min, this.max, this.isAdjusting);
        }

        public function setMinimum(_arg_1:int):void
        {
            var _local_2:int = Math.max(_arg_1, this.max);
            var _local_3:int = Math.max(_arg_1, this.value);
            var _local_4:int = Math.min((_local_2 - _local_3), this.extent);
            this.setRangeProperties(_local_3, _local_4, _arg_1, _local_2, this.isAdjusting);
        }

        public function setMaximum(_arg_1:int):void
        {
            var _local_2:int = Math.min(_arg_1, this.min);
            var _local_3:int = Math.min((_arg_1 - _local_2), this.extent);
            var _local_4:int = Math.min((_arg_1 - _local_3), this.value);
            this.setRangeProperties(_local_4, _local_3, _local_2, _arg_1, this.isAdjusting);
        }

        public function setValueIsAdjusting(_arg_1:Boolean):void
        {
            this.setRangeProperties(this.value, this.extent, this.min, this.max, _arg_1);
        }

        public function getValueIsAdjusting():Boolean
        {
            return (this.isAdjusting);
        }

        public function setRangeProperties(_arg_1:int, _arg_2:int, _arg_3:int, _arg_4:int, _arg_5:Boolean):void
        {
            if (_arg_3 > _arg_4)
            {
                _arg_3 = _arg_4;
            };
            if (_arg_1 > _arg_4)
            {
                _arg_4 = _arg_1;
            };
            if (_arg_1 < _arg_3)
            {
                _arg_3 = _arg_1;
            };
            if ((_arg_2 + _arg_1) > _arg_4)
            {
                _arg_2 = (_arg_4 - _arg_1);
            };
            if (_arg_2 < 0)
            {
                _arg_2 = 0;
            };
            var _local_6:Boolean = (((((!(_arg_1 == this.value)) || (!(_arg_2 == this.extent))) || (!(_arg_3 == this.min))) || (!(_arg_4 == this.max))) || (!(_arg_5 == this.isAdjusting)));
            if (_local_6)
            {
                this.value = _arg_1;
                this.extent = _arg_2;
                this.min = _arg_3;
                this.max = _arg_4;
                this.isAdjusting = _arg_5;
                this.fireStateChanged();
            };
        }

        public function addStateListener(_arg_1:Function, _arg_2:int=0, _arg_3:Boolean=false):void
        {
            addEventListener(InteractiveEvent.STATE_CHANGED, _arg_1, false, _arg_2);
        }

        public function removeStateListener(_arg_1:Function):void
        {
            removeEventListener(InteractiveEvent.STATE_CHANGED, _arg_1);
        }

        protected function fireStateChanged():void
        {
            dispatchEvent(new InteractiveEvent(InteractiveEvent.STATE_CHANGED));
        }

        override public function toString():String
        {
            var _local_1:String = ((((((((((((("value=" + this.getValue()) + ", ") + "extent=") + this.getExtent()) + ", ") + "min=") + this.getMinimum()) + ", ") + "max=") + this.getMaximum()) + ", ") + "adj=") + this.getValueIsAdjusting());
            return ((("BoundedRangeModel" + "[") + _local_1) + "]");
        }


    }
}//package com.pickgliss.ui.controls

