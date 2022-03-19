// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//com.pickgliss.ui.controls.SelectedButtonGroup

package com.pickgliss.ui.controls
{
    import flash.events.EventDispatcher;
    import com.pickgliss.ui.core.Disposeable;
    import __AS3__.vec.Vector;
    import flash.events.MouseEvent;
    import com.pickgliss.utils.ObjectUtils;
    import flash.events.Event;
    import __AS3__.vec.*;

    public class SelectedButtonGroup extends EventDispatcher implements Disposeable 
    {

        private var _canUnSelect:Boolean;
        private var _currentSelecetdIndex:int = -1;
        private var _items:Vector.<ISelectable>;
        private var _lastSelectedButton:ISelectable;
        private var _mutiSelectCount:int;

        public function SelectedButtonGroup(_arg_1:Boolean=false, _arg_2:int=1)
        {
            this._mutiSelectCount = _arg_2;
            this._canUnSelect = _arg_1;
            this._items = new Vector.<ISelectable>();
        }

        public function addSelectItem(_arg_1:ISelectable):void
        {
            _arg_1.addEventListener(MouseEvent.CLICK, this.__onItemClicked);
            _arg_1.autoSelect = false;
            this._items.push(_arg_1);
        }

        public function dispose():void
        {
            var _local_1:int;
            while (_local_1 < this._items.length)
            {
                this.removeItemByIndex(0);
            };
            this._lastSelectedButton = null;
            this._items = null;
        }

        public function getSelectIndexByItem(_arg_1:ISelectable):int
        {
            return (this._items.indexOf(_arg_1));
        }

        public function getItemByIndex(_arg_1:int):ISelectable
        {
            return (this._items[_arg_1]);
        }

        public function removeItemByIndex(_arg_1:int):void
        {
            if (_arg_1 != -1)
            {
                this._items[_arg_1].removeEventListener(MouseEvent.CLICK, this.__onItemClicked);
                ObjectUtils.disposeObject(this._items[_arg_1]);
                this._items.splice(_arg_1, 1);
            };
        }

        public function removeSelectItem(_arg_1:ISelectable):void
        {
            var _local_2:int = this._items.indexOf(_arg_1);
            this.removeItemByIndex(_local_2);
        }

        public function get selectIndex():int
        {
            return (this._items.indexOf(this._lastSelectedButton));
        }

        public function set selectIndex(_arg_1:int):void
        {
            var _local_4:ISelectable;
            if (_arg_1 == -1)
            {
                this._currentSelecetdIndex = _arg_1;
                for each (_local_4 in this._items)
                {
                    _local_4.selected = false;
                };
                return;
            };
            var _local_2:Boolean = (!(this._currentSelecetdIndex == _arg_1));
            var _local_3:ISelectable = this._items[_arg_1];
            if ((!(_local_3.selected)))
            {
                if (((this._lastSelectedButton) && (this.selectedCount == this._mutiSelectCount)))
                {
                    this._lastSelectedButton.selected = false;
                };
                _local_3.selected = true;
                this._currentSelecetdIndex = _arg_1;
                this._lastSelectedButton = _local_3;
            }
            else
            {
                if (this._canUnSelect)
                {
                    _local_3.selected = false;
                };
            };
            if (_local_2)
            {
                dispatchEvent(new Event(Event.CHANGE));
            };
        }

        public function get selectedCount():int
        {
            var _local_1:int;
            var _local_2:int;
            while (_local_2 < this._items.length)
            {
                if (this._items[_local_2].selected)
                {
                    _local_1++;
                };
                _local_2++;
            };
            return (_local_1);
        }

        public function set selectedCount(_arg_1:int):void
        {
            this._mutiSelectCount = _arg_1;
        }

        public function get itemCount():int
        {
            return (this._items.length);
        }

        private function __onItemClicked(_arg_1:MouseEvent):void
        {
            var _local_2:ISelectable = (_arg_1.currentTarget as ISelectable);
            this.selectIndex = this._items.indexOf(_local_2);
        }


    }
}//package com.pickgliss.ui.controls

