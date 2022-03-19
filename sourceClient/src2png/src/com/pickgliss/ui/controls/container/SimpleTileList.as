// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//com.pickgliss.ui.controls.container.SimpleTileList

package com.pickgliss.ui.controls.container
{
    import flash.geom.Point;
    import flash.events.MouseEvent;
    import flash.display.DisplayObject;
    import flash.events.Event;

    public class SimpleTileList extends BoxContainer 
    {

        public var startPos:Point = new Point(0, 0);
        protected var _column:int;
        protected var _arrangeType:int;
        protected var _hSpace:Number = 0;
        protected var _rowNum:int;
        protected var _vSpace:Number = 0;
        private var _selectedIndex:int;

        public function SimpleTileList(_arg_1:int=1, _arg_2:int=0)
        {
            this._column = _arg_1;
            this._arrangeType = _arg_2;
        }

        public function get selectedIndex():int
        {
            return (this._selectedIndex);
        }

        public function set selectedIndex(_arg_1:int):void
        {
            if (this._selectedIndex == _arg_1)
            {
                return;
            };
            this._selectedIndex = _arg_1;
        }

        public function get hSpace():Number
        {
            return (this._hSpace);
        }

        public function set hSpace(_arg_1:Number):void
        {
            this._hSpace = _arg_1;
            onProppertiesUpdate();
        }

        public function get vSpace():Number
        {
            return (this._vSpace);
        }

        public function set vSpace(_arg_1:Number):void
        {
            this._vSpace = _arg_1;
            onProppertiesUpdate();
        }

        override public function addChild(_arg_1:DisplayObject):DisplayObject
        {
            _arg_1.addEventListener(MouseEvent.CLICK, this.__itemClick);
            super.addChild(_arg_1);
            return (_arg_1);
        }

        private function __itemClick(_arg_1:MouseEvent):void
        {
            var _local_2:DisplayObject = (_arg_1.currentTarget as DisplayObject);
            this._selectedIndex = getChildIndex(_local_2);
        }

        override public function arrange():void
        {
            this.caculateRows();
            if (this._arrangeType == 0)
            {
                this.horizontalArrange();
            }
            else
            {
                this.verticalArrange();
            };
        }

        private function horizontalArrange():void
        {
            var _local_7:int;
            var _local_8:int;
            var _local_9:DisplayObject;
            var _local_1:int;
            var _local_2:int = this.startPos.x;
            var _local_3:int = this.startPos.y;
            var _local_4:int;
            var _local_5:int;
            var _local_6:int;
            while (_local_6 < this._rowNum)
            {
                _local_7 = 0;
                _local_8 = 0;
                while (_local_8 < this._column)
                {
                    _local_9 = getChildAt(_local_1++);
                    _local_9.x = _local_2;
                    _local_9.y = _local_3;
                    _local_4 = Math.max(_local_4, (_local_2 + _local_9.width));
                    _local_5 = Math.max(_local_5, (_local_3 + _local_9.height));
                    _local_2 = (_local_2 + (_local_9.width + this._hSpace));
                    if (_local_7 < _local_9.height)
                    {
                        _local_7 = _local_9.height;
                    };
                    if (_local_1 >= numChildren)
                    {
                        this.changeSize(_local_4, _local_5);
                        return;
                    };
                    _local_8++;
                };
                _local_2 = this.startPos.x;
                _local_3 = (_local_3 + (_local_7 + this._vSpace));
                _local_6++;
            };
            this.changeSize(_local_4, _local_5);
            dispatchEvent(new Event(Event.RESIZE));
        }

        private function verticalArrange():void
        {
            var _local_7:int;
            var _local_8:int;
            var _local_9:DisplayObject;
            var _local_1:int;
            var _local_2:int = this.startPos.x;
            var _local_3:int = this.startPos.y;
            var _local_4:int;
            var _local_5:int;
            var _local_6:int;
            while (_local_6 < this._rowNum)
            {
                _local_7 = 0;
                _local_8 = 0;
                while (_local_8 < this._column)
                {
                    _local_9 = getChildAt(_local_1++);
                    _local_9.x = _local_2;
                    _local_9.y = _local_3;
                    _local_4 = Math.max(_local_4, (_local_2 + _local_9.width));
                    _local_5 = Math.max(_local_5, (_local_3 + _local_9.height));
                    _local_3 = (_local_3 + (_local_9.height + this._vSpace));
                    if (_local_7 < _local_9.width)
                    {
                        _local_7 = _local_9.width;
                    };
                    if (_local_1 >= numChildren)
                    {
                        this.changeSize(_local_4, _local_5);
                        return;
                    };
                    _local_8++;
                };
                _local_2 = (_local_2 + (_local_7 + this._hSpace));
                _local_3 = this.startPos.y;
                _local_6++;
            };
            this.changeSize(_local_4, _local_5);
            dispatchEvent(new Event(Event.RESIZE));
        }

        private function changeSize(_arg_1:int, _arg_2:int):void
        {
            if (((!(_arg_1 == _width)) || (!(_arg_2 == _height))))
            {
                width = _arg_1;
                height = _arg_2;
            };
        }

        private function caculateRows():void
        {
            this._rowNum = Math.ceil((numChildren / this._column));
        }

        override public function dispose():void
        {
            var _local_2:DisplayObject;
            var _local_1:int;
            while (_local_1 < numChildren)
            {
                _local_2 = (getChildAt(_local_1) as DisplayObject);
                _local_2.removeEventListener(MouseEvent.CLICK, this.__itemClick);
                _local_1++;
            };
            super.dispose();
        }


    }
}//package com.pickgliss.ui.controls.container

