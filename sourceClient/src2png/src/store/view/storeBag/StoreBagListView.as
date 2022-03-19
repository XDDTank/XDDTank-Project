// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//store.view.storeBag.StoreBagListView

package store.view.storeBag
{
    import flash.display.Sprite;
    import com.pickgliss.ui.core.Disposeable;
    import com.pickgliss.ui.controls.container.SimpleTileList;
    import com.pickgliss.ui.controls.ScrollPanel;
    import road7th.data.DictionaryData;
    import com.pickgliss.ui.ComponentFactory;
    import bagAndInfo.cell.BagCell;
    import ddt.events.CellEvent;
    import ddt.manager.SoundManager;
    import com.pickgliss.events.InteractiveEvent;
    import flash.events.Event;
    import flash.events.MouseEvent;
    import ddt.data.EquipType;
    import ddt.data.goods.InventoryItemInfo;
    import road7th.data.DictionaryEvent;
    import store.events.StoreBagEvent;
    import store.events.UpdateItemEvent;
    import ddt.manager.TaskManager;
    import ddt.manager.SavePointManager;
    import com.pickgliss.utils.DoubleClickManager;
    import flash.geom.Point;
    import com.pickgliss.utils.ObjectUtils;

    public class StoreBagListView extends Sprite implements Disposeable 
    {

        private static var cellNum:int = 70;
        public static const SMALLGRID:int = 21;

        private var _list:SimpleTileList;
        protected var panel:ScrollPanel;
        protected var _cells:DictionaryData;
        protected var _bagdata:DictionaryData;
        protected var _controller:StoreBagController;
        protected var _bagType:int;
        private var beginGridNumber:int;
        private var _weaponNeedLight:Boolean;
        private var _doubleClickEnable:Boolean;


        public function setup(_arg_1:int, _arg_2:StoreBagController, _arg_3:int):void
        {
            this._bagType = _arg_1;
            this._controller = _arg_2;
            this.beginGridNumber = _arg_3;
            this.init();
        }

        private function init():void
        {
            this.createPanel();
            this._list = new SimpleTileList(7);
            this._list.vSpace = 0;
            this._list.hSpace = 0;
            this.panel.setView(this._list);
            this.panel.invalidateViewport();
            this.createCells();
        }

        protected function createPanel():void
        {
            this.panel = ComponentFactory.Instance.creat("ddtstore.StoreBagView.BagEquipScrollPanel");
            addChild(this.panel);
            this.panel.hScrollProxy = ScrollPanel.OFF;
            this.panel.vScrollProxy = ScrollPanel.ON;
        }

        protected function createCells():void
        {
            this._cells = new DictionaryData();
        }

        public function set doubleClickEnable(_arg_1:Boolean):void
        {
            this._doubleClickEnable = _arg_1;
        }

        private function __doubleClickHandler(_arg_1:InteractiveEvent):void
        {
            _arg_1.stopImmediatePropagation();
            if ((!(this._doubleClickEnable)))
            {
                return;
            };
            if ((_arg_1.currentTarget as BagCell).info != null)
            {
                if ((!((_arg_1.currentTarget as BagCell).locked)))
                {
                    dispatchEvent(new CellEvent(CellEvent.DOUBLE_CLICK, _arg_1.currentTarget, true));
                    SoundManager.instance.play("008");
                };
            };
        }

        private function __clickHandler(_arg_1:InteractiveEvent):void
        {
            if (_arg_1.currentTarget)
            {
                dispatchEvent(new CellEvent(CellEvent.ITEM_CLICK, _arg_1.currentTarget));
            };
        }

        protected function __cellChanged(_arg_1:Event):void
        {
            dispatchEvent(new Event(Event.CHANGE));
        }

        protected function __cellClick(_arg_1:MouseEvent):void
        {
            _arg_1.stopImmediatePropagation();
            if (_arg_1.currentTarget.light)
            {
                _arg_1.currentTarget.light = false;
            };
        }

        public function getCellByPlace(_arg_1:int):BagCell
        {
            return (this._cells[_arg_1]);
        }

        public function setCellInfo(_arg_1:int, _arg_2:InventoryItemInfo):void
        {
            var _local_3:StoreBagCell;
            if (_arg_2 == null)
            {
                if (((this._cells) && (this._cells[String(_arg_1)])))
                {
                    this._cells[String(_arg_1)].info = null;
                };
                return;
            };
            if (_arg_2.Count == 0)
            {
                if (((this._cells) && (this._cells[String(_arg_1)])))
                {
                    this._cells[String(_arg_1)].info = null;
                };
            }
            else
            {
                if (this._cells[String(_arg_1)])
                {
                    this._cells[String(_arg_1)].info = _arg_2;
                }
                else
                {
                    this._appendCell(_arg_1);
                    this._cells[String(_arg_1)].info = _arg_2;
                };
                if (this._weaponNeedLight)
                {
                    for each (_local_3 in this._cells)
                    {
                        if (_local_3.info)
                        {
                            if (EquipType.isWeapon(_local_3.info.TemplateID))
                            {
                                _local_3.locked = false;
                                _local_3.light = true;
                            };
                        };
                    };
                    this._weaponNeedLight = false;
                };
            };
        }

        public function setData(_arg_1:DictionaryData):void
        {
            var _local_2:String;
            if (this._bagdata != null)
            {
                this._bagdata.removeEventListener(DictionaryEvent.ADD, this.__addGoods);
                this._bagdata.removeEventListener(StoreBagEvent.REMOVE, this.__removeGoods);
                this._bagdata.removeEventListener(UpdateItemEvent.UPDATEITEMEVENT, this.__updateGoods);
            };
            this._bagdata = _arg_1;
            this.addGrid(_arg_1);
            if (_arg_1)
            {
                for (_local_2 in _arg_1)
                {
                    if (this._cells[_local_2] != null)
                    {
                        this._cells[_local_2].info = _arg_1[_local_2];
                        if (((SavePointManager.Instance.isInSavePoint(9)) && (!(TaskManager.instance.isNewHandTaskCompleted(7)))))
                        {
                            this._cells[_local_2].locked = true;
                            if (this._cells[_local_2].info)
                            {
                                if (EquipType.isWeapon(this._cells[_local_2].info.TemplateID))
                                {
                                    this._cells[_local_2].light = true;
                                    this._cells[_local_2].locked = false;
                                };
                            };
                        };
                    };
                };
            };
            this._bagdata.addEventListener(DictionaryEvent.ADD, this.__addGoods);
            this._bagdata.addEventListener(StoreBagEvent.REMOVE, this.__removeGoods);
            this._bagdata.addEventListener(UpdateItemEvent.UPDATEITEMEVENT, this.__updateGoods);
            this.updateScrollBar();
        }

        private function addGrid(_arg_1:DictionaryData):void
        {
            var _local_3:String;
            var _local_4:int;
            this._cells.clear();
            this._list.disposeAllChildren();
            var _local_2:int;
            for (_local_3 in _arg_1)
            {
                _local_2++;
            };
            _local_4 = int(((int(((_local_2 - 1) / 7)) + 1) * 7));
            _local_4 = ((_local_4 < this.beginGridNumber) ? this.beginGridNumber : _local_4);
            this._list.beginChanges();
            var _local_5:int;
            while (_local_5 < _local_4)
            {
                this.createCell(_local_5);
                _local_5++;
            };
            this._list.commitChanges();
            this.invalidatePanel();
        }

        private function createCell(_arg_1:int):void
        {
            var _local_2:StoreBagCell = new StoreBagCell(_arg_1);
            _local_2.bagType = this._bagType;
            _local_2.tipDirctions = "7,5,2,6,4,1";
            _local_2.addEventListener(InteractiveEvent.CLICK, this.__clickHandler);
            _local_2.addEventListener(InteractiveEvent.DOUBLE_CLICK, this.__doubleClickHandler);
            DoubleClickManager.Instance.enableDoubleClick(_local_2);
            _local_2.addEventListener(MouseEvent.CLICK, this.__cellClick);
            _local_2.addEventListener(CellEvent.LOCK_CHANGED, this.__cellChanged);
            this._cells.add(_local_2.place, _local_2);
            this._list.addChild(_local_2);
        }

        private function _appendCell(_arg_1:int):void
        {
            var _local_2:int = _arg_1;
            while (_local_2 < (_arg_1 + 7))
            {
                this.createCell(_local_2);
                _local_2++;
            };
        }

        private function updateScrollBar(_arg_1:Boolean=true):void
        {
        }

        protected function __addGoods(_arg_1:DictionaryEvent):void
        {
            var _local_2:InventoryItemInfo = (_arg_1.data as InventoryItemInfo);
            var _local_3:int;
            while (_local_3 < this._bagdata.length)
            {
                if (this._bagdata[_local_3] == _local_2)
                {
                    this.setCellInfo(_local_3, _local_2);
                    break;
                };
                _local_3++;
            };
            this.updateScrollBar();
        }

        private function checkShouldAutoLink(_arg_1:InventoryItemInfo):Boolean
        {
            if (this._controller.model.NeedAutoLink <= 0)
            {
                return (false);
            };
            if (((((_arg_1.TemplateID == EquipType.LUCKY) || (_arg_1.TemplateID == EquipType.SYMBLE)) || (_arg_1.TemplateID == EquipType.STRENGTH_STONE4)) || (_arg_1.StrengthenLevel >= 10)))
            {
                return (true);
            };
            return (false);
        }

        protected function __removeGoods(_arg_1:StoreBagEvent):void
        {
            this._cells[_arg_1.pos].info = null;
            this.updateScrollBar(false);
        }

        private function __updateGoods(_arg_1:UpdateItemEvent):void
        {
            this._cells[_arg_1.pos].info = (_arg_1.item as InventoryItemInfo);
            this.updateScrollBar(false);
        }

        public function getCellByPos(_arg_1:int):BagCell
        {
            return (this._cells[_arg_1]);
        }

        private function invalidatePanel():void
        {
            this.panel.invalidateViewport();
        }

        public function showLightById(_arg_1:Array):void
        {
            var _local_2:StoreBagCell;
            var _local_3:uint;
            for each (_local_2 in this._cells)
            {
                _local_2.locked = true;
                if (_local_2.info)
                {
                    _local_3 = 0;
                    while (_local_3 < _arg_1.length)
                    {
                        if (_local_2.info.TemplateID == _arg_1[_local_3])
                        {
                            _local_2.locked = false;
                            _local_2.light = true;
                        };
                        _local_3++;
                    };
                };
            };
        }

        public function weaponShowLight():void
        {
            var _local_1:StoreBagCell;
            this._weaponNeedLight = true;
            for each (_local_1 in this._cells)
            {
                _local_1.locked = true;
                if (_local_1.info)
                {
                    if (EquipType.isWeapon(_local_1.info.TemplateID))
                    {
                        _local_1.locked = false;
                        _local_1.light = true;
                    };
                };
            };
        }

        public function getWeaponPos():Point
        {
            var _local_2:StoreBagCell;
            var _local_1:Point = new Point(0, 0);
            for each (_local_2 in this._cells)
            {
                if (_local_2.info)
                {
                    if (EquipType.isWeapon(_local_2.info.TemplateID))
                    {
                        _local_1 = _local_2.localToGlobal(new Point((_local_2.width / 2), (_local_2.height + 50)));
                        break;
                    };
                };
            };
            return (_local_1);
        }

        public function releaseAllCell():void
        {
            var _local_1:StoreBagCell;
            for each (_local_1 in this._cells)
            {
                _local_1.locked = false;
            };
        }

        public function lockAllCell():void
        {
            var _local_1:StoreBagCell;
            for each (_local_1 in this._cells)
            {
                _local_1.locked = true;
            };
        }

        public function dispose():void
        {
            var _local_1:BagCell;
            this._controller = null;
            if (this._bagdata != null)
            {
                this._bagdata.removeEventListener(DictionaryEvent.ADD, this.__addGoods);
                this._bagdata.removeEventListener(StoreBagEvent.REMOVE, this.__removeGoods);
                this._bagdata.removeEventListener(UpdateItemEvent.UPDATEITEMEVENT, this.__updateGoods);
                this._bagdata = null;
            };
            for each (_local_1 in this._cells)
            {
                _local_1.removeEventListener(InteractiveEvent.CLICK, this.__clickHandler);
                _local_1.removeEventListener(InteractiveEvent.DOUBLE_CLICK, this.__doubleClickHandler);
                DoubleClickManager.Instance.disableDoubleClick(_local_1);
                _local_1.addEventListener(MouseEvent.CLICK, this.__cellClick);
                _local_1.removeEventListener(CellEvent.LOCK_CHANGED, this.__cellChanged);
                ObjectUtils.disposeObject(_local_1);
            };
            this._cells.clear();
            DoubleClickManager.Instance.clearTarget();
            this._list.disposeAllChildren();
            this._list = null;
            this._cells = null;
            if (this.panel)
            {
                ObjectUtils.disposeObject(this.panel);
            };
            this.panel = null;
            if (parent)
            {
                parent.removeChild(this);
            };
        }


    }
}//package store.view.storeBag

