// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//com.pickgliss.ui.controls.list.List

package com.pickgliss.ui.controls.list
{
    import com.pickgliss.ui.core.Component;
    import com.pickgliss.ui.core.IViewprot;
    import __AS3__.vec.Vector;
    import com.pickgliss.ui.controls.cell.IListCell;
    import flash.display.Sprite;
    import com.pickgliss.ui.controls.cell.IListCellFactory;
    import com.pickgliss.ui.ComponentSetting;
    import flash.display.Shape;
    import com.pickgliss.geom.IntPoint;
    import com.pickgliss.events.InteractiveEvent;
    import com.pickgliss.geom.IntDimension;
    import com.pickgliss.geom.IntRectangle;
    import com.pickgliss.events.ListItemEvent;
    import flash.events.MouseEvent;
    import com.pickgliss.utils.ObjectUtils;
    import __AS3__.vec.*;

    [Event(name="listItemClick", type="com.pickgliss.events.ListItemEvent")]
    [Event(name="listItemDoubleclick", type="com.pickgliss.events.ListItemEvent")]
    [Event(name="listItemMouseDown", type="com.pickgliss.events.ListItemEvent")]
    [Event(name="listItemMouseUp", type="com.pickgliss.events.ListItemEvent")]
    [Event(name="listItemRollOver", type="com.pickgliss.events.ListItemEvent")]
    [Event(name="listItemRollOut", type="com.pickgliss.events.ListItemEvent")]
    public class List extends Component implements IViewprot, ListDataListener 
    {

        public static const AUTO_INCREMENT:int = int.MIN_VALUE;//-2147483648
        public static const P_cellFactory:String = "cellFactory";
        public static const P_horizontalBlockIncrement:String = "horizontalBlockIncrement";
        public static const P_horizontalUnitIncrement:String = "horizontalUnitIncrement";
        public static const P_model:String = "model";
        public static const P_verticalBlockIncrement:String = "verticalBlockIncrement";
        public static const P_verticalUnitIncrement:String = "verticalUnitIncrement";
        public static const P_viewPosition:String = "viewPosition";
        public static const P_viewSize:String = "viewSize";

        protected var _cells:Vector.<IListCell>;
        protected var _cellsContainer:Sprite;
        protected var _factory:IListCellFactory;
        protected var _firstVisibleIndex:int;
        protected var _firstVisibleIndexOffset:int;
        protected var _horizontalBlockIncrement:int = ComponentSetting.SCROLL_BLOCK_INCREMENT;
        protected var _horizontalUnitIncrement:int = ComponentSetting.SCROLL_UINT_INCREMENT;
        protected var _lastVisibleIndex:int;
        protected var _lastVisibleIndexOffset:int;
        protected var _maskShape:Shape;
        protected var _model:IListModel;
        protected var _mouseActiveObjectShape:Shape;
        protected var _verticalBlockIncrement:int = ComponentSetting.SCROLL_BLOCK_INCREMENT;
        protected var _verticalUnitIncrement:int = ComponentSetting.SCROLL_UINT_INCREMENT;
        protected var _viewHeight:int;
        protected var _viewPosition:IntPoint;
        protected var _viewWidth:int;
        protected var _viewWidthNoCount:int;
        protected var _visibleCellWidth:int;
        protected var _visibleRowCount:int;
        protected var _currentSelectedIndex:int = -1;


        public function addStateListener(_arg_1:Function, _arg_2:int=0, _arg_3:Boolean=false):void
        {
            addEventListener(InteractiveEvent.STATE_CHANGED, _arg_1, false, _arg_2);
        }

        public function get cellFactory():IListCellFactory
        {
            return (this._factory);
        }

        public function set cellFactory(_arg_1:IListCellFactory):void
        {
            if (this._factory == _arg_1)
            {
                return;
            };
            this._factory = _arg_1;
            onPropertiesChanged(P_cellFactory);
        }

        public function contentsChanged(_arg_1:ListDataEvent):void
        {
            if (((((_arg_1.getIndex0() >= this._firstVisibleIndex) && (_arg_1.getIndex0() <= this._lastVisibleIndex)) || ((_arg_1.getIndex1() >= this._firstVisibleIndex) && (_arg_1.getIndex1() <= this._lastVisibleIndex))) || (this._lastVisibleIndex == -1)))
            {
                this.updateListView();
            };
        }

        override public function dispose():void
        {
            this._mouseActiveObjectShape.graphics.clear();
            this._mouseActiveObjectShape = null;
            this._maskShape.graphics.clear();
            this._maskShape = null;
            this.removeAllCell();
            this._cells = null;
            if (this._model)
            {
                this._model.removeListDataListener(this);
            };
            this._model = null;
            super.dispose();
        }

        public function getExtentSize():IntDimension
        {
            return (new IntDimension(_width, _height));
        }

        public function getViewSize():IntDimension
        {
            return (new IntDimension(this._viewWidth, this._viewHeight));
        }

        public function getViewportPane():Component
        {
            return (this);
        }

        public function get horizontalBlockIncrement():int
        {
            return (this._horizontalBlockIncrement);
        }

        public function set horizontalBlockIncrement(_arg_1:int):void
        {
            if (this._horizontalBlockIncrement == _arg_1)
            {
                return;
            };
            this._horizontalBlockIncrement = _arg_1;
            onPropertiesChanged(P_horizontalBlockIncrement);
        }

        public function get horizontalUnitIncrement():int
        {
            return (this._horizontalUnitIncrement);
        }

        public function set horizontalUnitIncrement(_arg_1:int):void
        {
            if (this._horizontalUnitIncrement == _arg_1)
            {
                return;
            };
            this._horizontalUnitIncrement = _arg_1;
            onPropertiesChanged(P_horizontalUnitIncrement);
        }

        public function intervalAdded(_arg_1:ListDataEvent):void
        {
            this.refreshViewSize();
            onPropertiesChanged(P_viewSize);
            var _local_2:int = this._factory.getCellHeight();
            var _local_3:int = int(Math.floor((_height / _local_2)));
            if (((((_arg_1.getIndex1() <= this._lastVisibleIndex) || (this._lastVisibleIndex == -1)) || (this.viewHeight < _height)) || (this._lastVisibleIndex <= _local_3)))
            {
                this.updateListView();
            };
        }

        public function intervalRemoved(_arg_1:ListDataEvent):void
        {
            this.refreshViewSize();
            onPropertiesChanged(P_viewSize);
            var _local_2:int = this._factory.getCellHeight();
            var _local_3:int = int(Math.floor((_height / _local_2)));
            if (((((_arg_1.getIndex1() <= this._lastVisibleIndex) || (this._lastVisibleIndex == -1)) || (this.viewHeight < _height)) || (this._lastVisibleIndex <= _local_3)))
            {
                this.updateListView();
            };
        }

        public function isSelectedIndex(_arg_1:int):Boolean
        {
            return (this._currentSelectedIndex == _arg_1);
        }

        public function get model():IListModel
        {
            return (this._model);
        }

        public function set model(_arg_1:IListModel):void
        {
            if (_arg_1 != this.model)
            {
                if (this._model)
                {
                    this._model.removeListDataListener(this);
                };
                this._model = _arg_1;
                this._model.addListDataListener(this);
                onPropertiesChanged(P_model);
            };
        }

        public function removeStateListener(_arg_1:Function):void
        {
            removeEventListener(InteractiveEvent.STATE_CHANGED, _arg_1);
        }

        public function scrollRectToVisible(_arg_1:IntRectangle):void
        {
            this.viewPosition = new IntPoint(_arg_1.x, _arg_1.y);
        }

        public function setListData(_arg_1:Array):void
        {
            var _local_2:IListModel = new VectorListModel(_arg_1);
            this.model = _local_2;
        }

        public function setViewportTestSize(_arg_1:IntDimension):void
        {
        }

        public function updateListView():void
        {
            if (this._factory == null)
            {
                return;
            };
            this.createCells();
            this.updateShowMask();
            this.updatePos();
        }

        public function get verticalBlockIncrement():int
        {
            return (this._verticalBlockIncrement);
        }

        public function set verticalBlockIncrement(_arg_1:int):void
        {
            if (this._verticalBlockIncrement == _arg_1)
            {
                return;
            };
            this._verticalBlockIncrement = _arg_1;
            onPropertiesChanged(P_verticalBlockIncrement);
        }

        public function get verticalUnitIncrement():int
        {
            return (this._verticalUnitIncrement);
        }

        public function set verticalUnitIncrement(_arg_1:int):void
        {
            if (this._verticalUnitIncrement == _arg_1)
            {
                return;
            };
            this._verticalUnitIncrement = _arg_1;
            onPropertiesChanged(P_verticalUnitIncrement);
        }

        public function get viewPosition():IntPoint
        {
            return (this._viewPosition);
        }

        public function set viewPosition(_arg_1:IntPoint):void
        {
            if (this._viewPosition.equals(this.restrictionViewPos(_arg_1)))
            {
                return;
            };
            this._viewPosition.setLocation(_arg_1);
            onPropertiesChanged(P_viewPosition);
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
                    this._currentSelectedIndex = _local_3;
                    this.updateListView();
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

        public function getCellAt(_arg_1:int):IListCell
        {
            return (this._cells[_arg_1]);
        }

        public function getAllCells():Vector.<IListCell>
        {
            return (this._cells);
        }

        public function get currentSelectedIndex():int
        {
            return (this._currentSelectedIndex);
        }

        public function set currentSelectedIndex(_arg_1:int):void
        {
            var _local_2:IListCell = this._cells[_arg_1];
            if (_local_2 != null)
            {
                this._currentSelectedIndex = _arg_1;
                this.updateListView();
                dispatchEvent(new ListItemEvent(_local_2, _local_2.getCellValue(), ListItemEvent.LIST_ITEM_CLICK, this._currentSelectedIndex));
            };
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

        override protected function addChildren():void
        {
            super.addChildren();
            addChild(this._mouseActiveObjectShape);
            addChild(this._maskShape);
            addChild(this._cellsContainer);
        }

        protected function creatMaskShape():void
        {
            this._maskShape = new Shape();
            this._maskShape.graphics.beginFill(0xFF0000, 1);
            this._maskShape.graphics.drawRect(0, 0, 100, 100);
            this._maskShape.graphics.endFill();
            this._mouseActiveObjectShape = new Shape();
            this._mouseActiveObjectShape.graphics.beginFill(0xFF0000, 0);
            this._mouseActiveObjectShape.graphics.drawRect(0, 0, 100, 100);
            this._mouseActiveObjectShape.graphics.endFill();
        }

        protected function createCells():void
        {
            if (this._factory.isShareCells())
            {
                this.createCellsWhenShareCells();
            }
            else
            {
                this.createCellsWhenNotShareCells();
            };
        }

        protected function createCellsWhenNotShareCells():void
        {
        }

        protected function createCellsWhenShareCells():void
        {
            var _local_3:int;
            var _local_4:IListCell;
            var _local_5:int;
            var _local_6:int;
            var _local_7:int;
            var _local_8:Vector.<IListCell>;
            var _local_1:int = this._factory.getCellHeight();
            var _local_2:int = int((Math.floor((_height / _local_1)) + 2));
            this._viewWidth = this._factory.getViewWidthNoCount();
            if (this._cells.length == _local_2)
            {
                return;
            };
            if (this._cells.length < _local_2)
            {
                _local_6 = (_local_2 - this._cells.length);
                _local_3 = 0;
                while (_local_3 < _local_6)
                {
                    _local_4 = this.createNewCell();
                    _local_5 = Math.max(_local_4.width, _local_5);
                    this.addCellToContainer(_local_4);
                    _local_3++;
                };
            }
            else
            {
                if (this._cells.length > _local_2)
                {
                    _local_7 = _local_2;
                    _local_8 = this._cells.splice(_local_7, (this._cells.length - _local_7));
                    _local_3 = 0;
                    while (_local_3 < _local_8.length)
                    {
                        this.removeCellFromContainer(_local_8[_local_3]);
                        _local_3++;
                    };
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

        protected function fireStateChanged(_arg_1:Boolean=true):void
        {
            dispatchEvent(new InteractiveEvent(InteractiveEvent.STATE_CHANGED));
        }

        protected function getListCellModelHeight(_arg_1:int):int
        {
            return (0);
        }

        protected function getViewMaxPos():IntPoint
        {
            var _local_1:IntDimension = this.getExtentSize();
            var _local_2:IntDimension = this.getViewSize();
            var _local_3:IntPoint = new IntPoint((_local_2.width - _local_1.width), (_local_2.height - _local_1.height));
            if (_local_3.x < 0)
            {
                _local_3.x = 0;
            };
            if (_local_3.y < 0)
            {
                _local_3.y = 0;
            };
            return (_local_3);
        }

        override protected function init():void
        {
            this.creatMaskShape();
            this._cellsContainer = new Sprite();
            addChild(this._cellsContainer);
            this._viewPosition = new IntPoint(0, 0);
            this._firstVisibleIndex = 0;
            this._lastVisibleIndex = -1;
            this._firstVisibleIndexOffset = 0;
            this._lastVisibleIndexOffset = 0;
            this._visibleRowCount = -1;
            this._visibleCellWidth = -1;
            this._cells = new Vector.<IListCell>();
            super.init();
            this._model = new VectorListModel();
            this._model.addListDataListener(this);
        }

        protected function layoutWhenShareCellsHasNotSameHeight():void
        {
            var _local_8:IListCell;
            var _local_9:int;
            this.createCellsWhenShareCells();
            this.restrictionViewPos(this._viewPosition);
            var _local_1:int = this._viewPosition.x;
            var _local_2:int = this._viewPosition.y;
            var _local_3:int = this._model.getStartIndexByPosY(_local_2);
            var _local_4:int = this._model.getSize();
            var _local_5:int = -(_local_1);
            var _local_6:int = _height;
            if (_local_4 < 0)
            {
                this._lastVisibleIndex = -1;
            };
            var _local_7:int;
            while (_local_7 < this._cells.length)
            {
                _local_8 = this._cells[_local_7];
                _local_9 = (_local_3 + _local_7);
                if (_local_9 < _local_4)
                {
                    _local_8.setCellValue(this._model.getElementAt(_local_9));
                    _local_8.setListCellStatus(this, this.isSelectedIndex(_local_9), _local_9);
                    _local_8.visible = true;
                    _local_8.x = _local_5;
                    _local_8.y = (this._model.getCellPosFromIndex(_local_9) - _local_2);
                    if (_local_8.y < _local_6)
                    {
                        this._lastVisibleIndex = _local_9;
                    };
                }
                else
                {
                    _local_8.visible = false;
                };
                _local_7++;
            };
            this.refreshViewSize();
            this._firstVisibleIndex = _local_3;
        }

        protected function layoutWhenShareCellsHasSameHeight():void
        {
            var _local_11:IListCell;
            var _local_12:int;
            this.createCellsWhenShareCells();
            this.restrictionViewPos(this._viewPosition);
            var _local_1:int = this._viewPosition.x;
            var _local_2:int = this._viewPosition.y;
            var _local_3:int = this._factory.getCellHeight();
            var _local_4:int = int(Math.floor((_local_2 / _local_3)));
            var _local_5:int = ((_local_4 * _local_3) - _local_2);
            var _local_6:int = this._model.getSize();
            var _local_7:int = -(_local_1);
            var _local_8:int = _local_5;
            var _local_9:int = _height;
            if (_local_6 < 0)
            {
                this._lastVisibleIndex = -1;
            };
            var _local_10:int;
            while (_local_10 < this._cells.length)
            {
                _local_11 = this._cells[_local_10];
                _local_12 = (_local_4 + _local_10);
                if (_local_12 < _local_6)
                {
                    _local_11.setCellValue(this._model.getElementAt(_local_12));
                    _local_11.setListCellStatus(this, this.isSelectedIndex(_local_12), _local_12);
                    _local_11.visible = true;
                    _local_11.x = _local_7;
                    _local_11.y = _local_8;
                    if (_local_8 < _local_9)
                    {
                        this._lastVisibleIndex = _local_12;
                    };
                    _local_8 = (_local_8 + _local_3);
                }
                else
                {
                    _local_11.visible = false;
                };
                _local_10++;
            };
            this.refreshViewSize();
            this._firstVisibleIndex = _local_4;
        }

        override protected function onProppertiesUpdate():void
        {
            super.onProppertiesUpdate();
            var _local_1:Boolean;
            this._cellsContainer.mask = this._maskShape;
            if ((((((_changedPropeties[P_model]) || (_changedPropeties[P_cellFactory])) || (_changedPropeties[P_viewPosition])) || (_changedPropeties[Component.P_width])) || (_changedPropeties[Component.P_height])))
            {
                if (_changedPropeties[P_cellFactory])
                {
                    this.removeAllCell();
                };
                _local_1 = true;
            };
            if (_local_1)
            {
                this.updateListView();
            };
            if (((((((((_changedPropeties[P_verticalBlockIncrement]) || (_changedPropeties[P_verticalUnitIncrement])) || (_changedPropeties[P_horizontalBlockIncrement])) || (_changedPropeties[P_horizontalUnitIncrement])) || (_changedPropeties[Component.P_height])) || (_changedPropeties[Component.P_width])) || (_changedPropeties[P_viewPosition])) || (_changedPropeties[P_viewSize])))
            {
                this.fireStateChanged();
            };
        }

        protected function refreshViewSize():void
        {
            if (this._factory.isShareCells())
            {
                this._viewWidth = this._factory.getViewWidthNoCount();
                if (this._factory.isAllCellHasSameHeight())
                {
                    this.viewHeight = (this._model.getSize() * this._factory.getCellHeight());
                }
                else
                {
                    this.viewHeight = this._model.getAllCellHeight();
                };
            };
        }

        public function get viewHeight():Number
        {
            return (this._viewHeight);
        }

        public function set viewHeight(_arg_1:Number):void
        {
            if (this._viewHeight == _arg_1)
            {
                return;
            };
            this._viewHeight = _arg_1;
            onPropertiesChanged(P_viewSize);
        }

        public function get viewWidth():Number
        {
            return (this._viewWidth);
        }

        public function set viewWidth(_arg_1:Number):void
        {
            if (this._viewWidth == _arg_1)
            {
                return;
            };
            this._viewWidth = _arg_1;
            onPropertiesChanged(P_viewSize);
        }

        public function unSelectedAll():void
        {
            this._currentSelectedIndex = -1;
            this.updateListView();
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

        protected function restrictionViewPos(_arg_1:IntPoint):IntPoint
        {
            var _local_2:IntPoint = this.getViewMaxPos();
            _arg_1.x = Math.max(0, Math.min(_local_2.x, _arg_1.x));
            _arg_1.y = Math.max(0, Math.min(_local_2.y, _arg_1.y));
            return (_arg_1);
        }

        protected function updatePos():void
        {
            if (this._factory.isShareCells())
            {
                if (this._factory.isAllCellHasSameHeight())
                {
                    this.layoutWhenShareCellsHasSameHeight();
                }
                else
                {
                    this.layoutWhenShareCellsHasNotSameHeight();
                };
            };
        }

        protected function updateShowMask():void
        {
            this._mouseActiveObjectShape.width = (this._maskShape.width = _width);
            this._mouseActiveObjectShape.height = (this._maskShape.height = _height);
        }


    }
}//package com.pickgliss.ui.controls.list

