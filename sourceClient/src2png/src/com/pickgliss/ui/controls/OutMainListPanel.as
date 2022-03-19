// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//com.pickgliss.ui.controls.OutMainListPanel

package com.pickgliss.ui.controls
{
    import com.pickgliss.ui.core.Component;
    import com.pickgliss.ui.controls.list.ListDataListener;
    import flash.display.Sprite;
    import com.pickgliss.geom.InnerRectangle;
    import com.pickgliss.ui.controls.cell.IListCellFactory;
    import com.pickgliss.ui.controls.list.VectorListModel;
    import __AS3__.vec.Vector;
    import com.pickgliss.ui.controls.cell.IListCell;
    import com.pickgliss.ui.controls.list.ListDataEvent;
    import flash.events.MouseEvent;
    import com.pickgliss.events.ListItemEvent;
    import com.pickgliss.utils.ObjectUtils;
    import com.pickgliss.utils.ClassUtils;
    import com.pickgliss.ui.ComponentFactory;
    import com.pickgliss.events.InteractiveEvent;
    import com.pickgliss.utils.DisplayUtils;
    import __AS3__.vec.*;

    public class OutMainListPanel extends Component implements ListDataListener 
    {

        private var P_vScrollbar:String = "vScrollBar";
        private var P_vScrollbarInnerRect:String = "vScrollBarInnerRect";
        private var P_cellFactory:String = "cellFactory";
        private var _cellsContainer:Sprite;
        private var _vScrollbarStyle:String;
        private var _vScrollbar:Scrollbar;
        private var _vScrollbarInnerRectString:String;
        private var _vScrollbarInnerRect:InnerRectangle;
        private var _factoryStyle:String;
        private var _factory:IListCellFactory;
        private var _model:VectorListModel;
        private var _cells:Vector.<IListCell>;
        private var _presentPos:int;
        private var _needNum:int;


        override protected function init():void
        {
            this.initEvent();
            this._presentPos = 0;
            this._cells = new Vector.<IListCell>();
            this._model = new VectorListModel();
            this._model.addListDataListener(this);
            super.init();
        }

        override protected function addChildren():void
        {
            super.addChildren();
            if (this._vScrollbar)
            {
                this._cellsContainer.addChild(this._vScrollbar);
            };
            this._cellsContainer = new Sprite();
            addChild(this._cellsContainer);
        }

        public function get vectorListModel():VectorListModel
        {
            return (this._model);
        }

        public function contentsChanged(_arg_1:ListDataEvent):void
        {
            this.changeDate();
        }

        public function intervalAdded(_arg_1:ListDataEvent):void
        {
            this.syncScrollBar();
        }

        public function intervalRemoved(_arg_1:ListDataEvent):void
        {
            this.syncScrollBar();
        }

        private function syncScrollBar():void
        {
            var _local_2:int;
            var _local_3:int;
            var _local_4:int;
            var _local_1:int = this._factory.getCellHeight();
            this._needNum = Math.floor((_height / _local_1));
            if (this._vScrollbar != null)
            {
                _local_2 = (this._needNum * this._factory.getCellHeight());
                _local_3 = (this._presentPos * this._factory.getCellHeight());
                _local_4 = (this._factory.getCellHeight() * this._model.elements.length);
                this._vScrollbar.unitIncrement = this._factory.getCellHeight();
                this._vScrollbar.blockIncrement = this._factory.getCellHeight();
                this._vScrollbar.getModel().setRangeProperties(_local_3, _local_2, 0, _local_4, false);
            };
            this.changeDate();
        }

        private function changeDate():void
        {
            var _local_1:int;
            while (_local_1 < this._needNum)
            {
                this._cells[_local_1].setCellValue(this._model.elements[(this._presentPos + _local_1)]);
                _local_1++;
            };
        }

        private function createCells():void
        {
            var _local_2:int;
            var _local_3:int;
            var _local_4:IListCell;
            var _local_5:int;
            var _local_6:Vector.<IListCell>;
            var _local_7:int;
            var _local_1:int = this._factory.getCellHeight();
            this._needNum = Math.floor((_height / _local_1));
            if (this._cells.length == this._needNum)
            {
                return;
            };
            if (this._cells.length < this._needNum)
            {
                _local_2 = (this._needNum - this._cells.length);
                _local_3 = 0;
                while (_local_3 < _local_2)
                {
                    _local_4 = this.createNewCell();
                    _local_4.y = (this._factory.getCellHeight() * _local_3);
                    this.addCellToContainer(_local_4);
                    _local_3++;
                };
            }
            else
            {
                _local_5 = this._needNum;
                _local_6 = this._cells.splice(_local_5, (this._cells.length - _local_5));
                _local_7 = 0;
                while (_local_3 < _local_6.length)
                {
                    this.removeCellFromContainer(_local_6[_local_7]);
                    _local_7++;
                };
            };
        }

        protected function createNewCell():IListCell
        {
            if (this._factory == null)
            {
                return (null);
            };
            return (this._factory.createNewCell());
        }

        protected function addCellToContainer(_arg_1:IListCell):void
        {
            _arg_1.addEventListener(MouseEvent.CLICK, this.__onItemInteractive);
            _arg_1.addEventListener(MouseEvent.MOUSE_DOWN, this.__onItemInteractive);
            _arg_1.addEventListener(MouseEvent.MOUSE_UP, this.__onItemInteractive);
            _arg_1.addEventListener(MouseEvent.ROLL_OVER, this.__onItemInteractive);
            _arg_1.addEventListener(MouseEvent.ROLL_OUT, this.__onItemInteractive);
            _arg_1.addEventListener(MouseEvent.DOUBLE_CLICK, this.__onItemInteractive);
            this._cells.push(this._cellsContainer.addChild(_arg_1.asDisplayObject()));
        }

        protected function __onItemInteractive(_arg_1:MouseEvent):void
        {
            var _local_4:String;
            var _local_2:IListCell = (_arg_1.currentTarget as IListCell);
            var _local_3:int = this._model.indexOf(_local_2.getCellValue());
            switch (_arg_1.type)
            {
                case MouseEvent.CLICK:
                    _local_4 = ListItemEvent.LIST_ITEM_CLICK;
                    break;
                case MouseEvent.DOUBLE_CLICK:
                    _local_4 = ListItemEvent.LIST_ITEM_DOUBLE_CLICK;
                    break;
                case MouseEvent.MOUSE_DOWN:
                    _local_4 = ListItemEvent.LIST_ITEM_MOUSE_DOWN;
                    break;
                case MouseEvent.MOUSE_UP:
                    _local_4 = ListItemEvent.LIST_ITEM_MOUSE_UP;
                    break;
                case MouseEvent.ROLL_OVER:
                    _local_4 = ListItemEvent.LIST_ITEM_ROLL_OVER;
                    break;
                case MouseEvent.ROLL_OUT:
                    _local_4 = ListItemEvent.LIST_ITEM_ROLL_OUT;
                    break;
            };
            dispatchEvent(new ListItemEvent(_local_2, _local_2.getCellValue(), _local_4, _local_3));
        }

        protected function removeAllCell():void
        {
            var _local_1:int;
            while (_local_1 < this._cells.length)
            {
                this.removeCellFromContainer(this._cells[_local_1]);
                _local_1++;
            };
            this._cells = new Vector.<IListCell>();
        }

        protected function removeCellFromContainer(_arg_1:IListCell):void
        {
            _arg_1.removeEventListener(MouseEvent.CLICK, this.__onItemInteractive);
            _arg_1.removeEventListener(MouseEvent.MOUSE_DOWN, this.__onItemInteractive);
            _arg_1.removeEventListener(MouseEvent.MOUSE_UP, this.__onItemInteractive);
            _arg_1.removeEventListener(MouseEvent.ROLL_OVER, this.__onItemInteractive);
            _arg_1.removeEventListener(MouseEvent.ROLL_OUT, this.__onItemInteractive);
            _arg_1.removeEventListener(MouseEvent.DOUBLE_CLICK, this.__onItemInteractive);
            ObjectUtils.disposeObject(_arg_1);
        }

        protected function initEvent():void
        {
            addEventListener(MouseEvent.MOUSE_WHEEL, this.onMouseWheel);
        }

        public function onMouseWheel(_arg_1:MouseEvent):void
        {
            var _local_2:int;
            var _local_3:int;
            if (this._needNum > 0)
            {
                _local_2 = int(Math.floor((_arg_1.delta / this._needNum)));
                _local_3 = (this._presentPos - _local_2);
                if (_local_3 > (this._model.elements.length - this._needNum))
                {
                    _local_3 = (this._model.elements.length - this._needNum);
                }
                else
                {
                    if (_local_3 < 0)
                    {
                        _local_3 = 0;
                    };
                };
                if (this._presentPos == _local_3)
                {
                    return;
                };
                this._presentPos = _local_3;
                this.syncScrollBar();
            };
        }

        public function set vScrollbarInnerRectString(_arg_1:String):void
        {
            if (this._vScrollbarInnerRectString == _arg_1)
            {
                return;
            };
            this._vScrollbarInnerRectString = _arg_1;
            this._vScrollbarInnerRect = ClassUtils.CreatInstance(ClassUtils.INNERRECTANGLE, ComponentFactory.parasArgs(this._vScrollbarInnerRectString));
            onPropertiesChanged(this.P_vScrollbarInnerRect);
        }

        public function set vScrollbarStyle(_arg_1:String):void
        {
            if (this._vScrollbarStyle == _arg_1)
            {
                return;
            };
            this._vScrollbarStyle = _arg_1;
            this.vScrollbar = ComponentFactory.Instance.creat(this._vScrollbarStyle);
        }

        public function get vScrollbar():Scrollbar
        {
            return (this._vScrollbar);
        }

        public function set vScrollbar(_arg_1:Scrollbar):void
        {
            if (this._vScrollbar == _arg_1)
            {
                return;
            };
            if (this._vScrollbar)
            {
                this._vScrollbar.removeStateListener(this.__onScrollValueChange);
                ObjectUtils.disposeObject(this._vScrollbar);
            };
            this._vScrollbar = _arg_1;
            this._vScrollbar.addStateListener(this.__onScrollValueChange);
            onPropertiesChanged(this.P_vScrollbar);
        }

        protected function __onScrollValueChange(_arg_1:InteractiveEvent):void
        {
            var _local_2:int = int(Math.floor((this._vScrollbar.getModel().getValue() / this._factory.getCellHeight())));
            if (_local_2 == this._presentPos)
            {
                return;
            };
            this._presentPos = _local_2;
            this.syncScrollBar();
        }

        public function set factoryStyle(_arg_1:String):void
        {
            if (this._factoryStyle == _arg_1)
            {
                return;
            };
            this._factoryStyle = _arg_1;
            var _local_2:Array = _arg_1.split("|");
            var _local_3:String = _local_2[0];
            var _local_4:Array = ComponentFactory.parasArgs(_local_2[1]);
            this._factory = ClassUtils.CreatInstance(_local_3, _local_4);
            onPropertiesChanged(this.P_cellFactory);
        }

        override protected function onProppertiesUpdate():void
        {
            super.onProppertiesUpdate();
            if (_changedPropeties[this.P_cellFactory])
            {
                this.createCells();
            };
            if (((_changedPropeties[this.P_vScrollbar]) || (_changedPropeties[this.P_vScrollbarInnerRect])))
            {
                this.layoutComponent();
            };
        }

        protected function layoutComponent():void
        {
            if (this._vScrollbar)
            {
                DisplayUtils.layoutDisplayWithInnerRect(this._vScrollbar, this._vScrollbarInnerRect, _width, _height);
            };
        }

        override public function dispose():void
        {
            removeEventListener(MouseEvent.MOUSE_WHEEL, this.onMouseWheel);
            this.removeAllCell();
            if (this._vScrollbar)
            {
                this._vScrollbar.removeStateListener(this.__onScrollValueChange);
                ObjectUtils.disposeObject(this._vScrollbar);
            };
            this._vScrollbar = null;
            if (this._cellsContainer)
            {
                ObjectUtils.disposeObject(this._cellsContainer);
            };
            this._cellsContainer = null;
            if (this._model)
            {
                this._model.removeListDataListener(this);
            };
            this._model = null;
            super.dispose();
            if (this.parent)
            {
                this.parent.removeChild(this);
            };
        }


    }
}//package com.pickgliss.ui.controls

