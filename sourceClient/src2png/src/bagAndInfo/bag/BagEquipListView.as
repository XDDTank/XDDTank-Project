// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//bagAndInfo.bag.BagEquipListView

package bagAndInfo.bag
{
    import bagAndInfo.cell.LockBagCell;
    import flash.utils.Dictionary;
    import com.pickgliss.ui.ComponentFactory;
    import bagAndInfo.cell.CellFactory;
    import com.pickgliss.events.InteractiveEvent;
    import com.pickgliss.utils.DoubleClickManager;
    import ddt.events.CellEvent;
    import ddt.manager.SoundManager;
    import com.pickgliss.ui.controls.alert.BaseAlerFrame;
    import com.pickgliss.events.FrameEvent;
    import flash.events.Event;
    import ddt.manager.LeavePageManager;
    import com.pickgliss.utils.ObjectUtils;
    import flash.events.MouseEvent;
    import ddt.data.EquipType;
    import flash.geom.Point;
    import ddt.data.goods.InventoryItemInfo;

    public class BagEquipListView extends BagListView 
    {

        public var _startIndex:int;
        public var _stopIndex:int;
        private var place:int;

        public function BagEquipListView(_arg_1:int, _arg_2:int=31, _arg_3:int=79, _arg_4:int=8)
        {
            this._startIndex = _arg_2;
            this._stopIndex = _arg_3;
            super(_arg_1, _arg_4);
        }

        override protected function createCells():void
        {
            var _local_2:LockBagCell;
            _cells = new Dictionary();
            _cellMouseOverBg = ComponentFactory.Instance.creatBitmap("bagAndInfo.cell.bagCellOverBgAsset");
            var _local_1:int = this._startIndex;
            while (_local_1 < this._stopIndex)
            {
                _local_2 = (CellFactory.instance.createLockBagCell(_local_1) as LockBagCell);
                _local_2.mouseOverEffBoolean = false;
                addChild(_local_2);
                _local_2.addEventListener(InteractiveEvent.CLICK, this.__clickHandler);
                _local_2.addEventListener(InteractiveEvent.DOUBLE_CLICK, this.__doubleClickHandler);
                _local_2.addEventListener(InteractiveEvent.MOUSE_DOWN, this.__mouseDownHandler);
                DoubleClickManager.Instance.enableDoubleClick(_local_2);
                _local_2.bagType = _bagType;
                _local_2.addEventListener(CellEvent.LOCK_CHANGED, __cellChanged);
                _cells[_local_2.place] = _local_2;
                _local_1++;
            };
        }

        override protected function __doubleClickHandler(_arg_1:InteractiveEvent):void
        {
            if ((_arg_1.currentTarget as LockBagCell).info != null)
            {
                if (_arg_1.currentTarget.isLighting)
                {
                    _arg_1.currentTarget.light = false;
                };
                SoundManager.instance.play("008");
                dispatchEvent(new CellEvent(CellEvent.DOUBLE_CLICK, _arg_1.currentTarget));
            };
        }

        protected function __mouseDownHandler(_arg_1:InteractiveEvent):void
        {
            if (_arg_1.currentTarget)
            {
                dispatchEvent(new CellEvent(CellEvent.ITEM_CLICK, _arg_1.currentTarget, false, false, _arg_1.ctrlKey));
            };
        }

        override protected function __clickHandler(_arg_1:InteractiveEvent):void
        {
            if (_arg_1.currentTarget)
            {
                if (_arg_1.currentTarget.isLighting)
                {
                    _arg_1.currentTarget.light = false;
                };
                dispatchEvent(new CellEvent(CellEvent.ITEM_CLICK, _arg_1.currentTarget, false, false, _arg_1.ctrlKey));
            };
        }

        private function __poorManResponse(_arg_1:FrameEvent):void
        {
            SoundManager.instance.play("008");
            var _local_2:BaseAlerFrame = (_arg_1.target as BaseAlerFrame);
            _local_2.removeEventListener(FrameEvent.RESPONSE, this.__poorManResponse);
            if (((_arg_1.responseCode == FrameEvent.SUBMIT_CLICK) || (_arg_1.responseCode == FrameEvent.ENTER_CLICK)))
            {
                dispatchEvent(new Event("unSelectAutoOpenBtn"));
                LeavePageManager.leaveToFillPath();
            }
            else
            {
                dispatchEvent(new Event("unSelectAutoOpenBtn"));
            };
            ObjectUtils.disposeObject(_local_2);
            _local_2 = null;
        }

        protected function __cellClick(_arg_1:MouseEvent):void
        {
        }

        public function fashionEquipShine():void
        {
            var _local_1:LockBagCell;
            for each (_local_1 in _cells)
            {
                if ((_local_1 is LockBagCell))
                {
                    if (((EquipType.isFashionViewGoods(_local_1.info)) || (EquipType.isRingEquipment(_local_1.info))))
                    {
                        _local_1.light = true;
                    }
                    else
                    {
                        _local_1.locked = true;
                    };
                };
            };
        }

        public function getCellPosByPlace(_arg_1:int):Point
        {
            return (localToGlobal(new Point(_cells[_arg_1].x, _cells[_arg_1].y)));
        }

        override public function setCellInfo(_arg_1:int, _arg_2:InventoryItemInfo):void
        {
            if (((_arg_1 >= this._startIndex) && (_arg_1 < this._stopIndex)))
            {
                if (_arg_2 == null)
                {
                    _cells[String(_arg_1)].info = null;
                    return;
                };
                if (_arg_2.Count == 0)
                {
                    _cells[String(_arg_1)].info = null;
                }
                else
                {
                    _cells[String(_arg_1)].info = _arg_2;
                };
            };
        }

        override public function dispose():void
        {
            var _local_1:LockBagCell;
            for each (_local_1 in _cells)
            {
                _local_1.removeEventListener(InteractiveEvent.CLICK, this.__clickHandler);
                _local_1.removeEventListener(InteractiveEvent.DOUBLE_CLICK, this.__doubleClickHandler);
                _local_1.removeEventListener(InteractiveEvent.MOUSE_DOWN, this.__mouseDownHandler);
                DoubleClickManager.Instance.disableDoubleClick(_local_1);
                _local_1.removeEventListener(CellEvent.LOCK_CHANGED, __cellChanged);
            };
            _cellMouseOverBg = null;
            super.dispose();
            if (this.parent)
            {
                this.parent.removeChild(this);
            };
        }


    }
}//package bagAndInfo.bag

