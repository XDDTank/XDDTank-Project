// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//bagAndInfo.bag.BagListView

package bagAndInfo.bag
{
    import com.pickgliss.ui.controls.container.SimpleTileList;
    import ddt.data.BagInfo;
    import flash.utils.Dictionary;
    import flash.display.Bitmap;
    import bagAndInfo.cell.LockBagCell;
    import com.pickgliss.ui.ComponentFactory;
    import bagAndInfo.cell.CellFactory;
    import com.pickgliss.events.InteractiveEvent;
    import flash.events.MouseEvent;
    import com.pickgliss.utils.DoubleClickManager;
    import ddt.events.CellEvent;
    import ddt.manager.SoundManager;
    import flash.events.Event;
    import ddt.data.goods.InventoryItemInfo;
    import ddt.data.goods.EquipmentTemplateInfo;
    import ddt.manager.SavePointManager;
    import ddt.events.BagEvent;
    import ddt.data.EquipType;
    import ddt.manager.ItemManager;
    import trainer.view.NewHandContainer;
    import trainer.data.ArrowType;
    import com.pickgliss.ui.LayerManager;

    public class BagListView extends SimpleTileList 
    {

        private var _allBagData:BagInfo;
        protected var _bagdata:BagInfo;
        protected var _bagType:int;
        protected var _cells:Dictionary;
        protected var _cellMouseOverBg:Bitmap;
        protected var _cellVec:Array;
        private var _isSetFoodData:Boolean;

        public function BagListView(_arg_1:int, _arg_2:int=8)
        {
            this._bagType = _arg_1;
            super(_arg_2);
            _hSpace = 1;
            _vSpace = 5;
            this._cellVec = new Array();
            this.createCells();
        }

        protected function createCells():void
        {
            var _local_2:LockBagCell;
            this._cells = new Dictionary();
            this._cellMouseOverBg = ComponentFactory.Instance.creatBitmap("bagAndInfo.cell.bagCellOverBgAsset");
            var _local_1:int = 31;
            while (_local_1 < 87)
            {
                _local_2 = LockBagCell(CellFactory.instance.createLockBagCell(_local_1));
                _local_2.mouseOverEffBoolean = false;
                addChild(_local_2);
                _local_2.bagType = this._bagType;
                _local_2.addEventListener(InteractiveEvent.CLICK, this.__clickHandler);
                _local_2.addEventListener(MouseEvent.MOUSE_OVER, this._cellOverEff);
                _local_2.addEventListener(MouseEvent.MOUSE_OUT, this._cellOutEff);
                _local_2.addEventListener(InteractiveEvent.DOUBLE_CLICK, this.__doubleClickHandler);
                DoubleClickManager.Instance.enableDoubleClick(_local_2);
                _local_2.addEventListener(CellEvent.LOCK_CHANGED, this.__cellChanged);
                this._cells[_local_2.place] = _local_2;
                this._cellVec.push(_local_2);
                _local_1++;
            };
        }

        protected function __doubleClickHandler(_arg_1:InteractiveEvent):void
        {
            if ((_arg_1.currentTarget as LockBagCell).info != null)
            {
                SoundManager.instance.play("008");
                dispatchEvent(new CellEvent(CellEvent.DOUBLE_CLICK, _arg_1.currentTarget));
            };
        }

        protected function __cellChanged(_arg_1:Event):void
        {
            dispatchEvent(new Event(Event.CHANGE));
        }

        protected function __clickHandler(_arg_1:InteractiveEvent):void
        {
            if ((_arg_1.currentTarget as LockBagCell).info != null)
            {
                dispatchEvent(new CellEvent(CellEvent.ITEM_CLICK, _arg_1.currentTarget, false, false, _arg_1.ctrlKey));
            };
        }

        public function _cellOverEff(_arg_1:MouseEvent):void
        {
            LockBagCell(_arg_1.currentTarget).onParentMouseOver(this._cellMouseOverBg);
        }

        public function _cellOutEff(_arg_1:MouseEvent):void
        {
            LockBagCell(_arg_1.currentTarget).onParentMouseOut();
        }

        public function setCellInfo(_arg_1:int, _arg_2:InventoryItemInfo):void
        {
            if (_arg_2 == null)
            {
                if (this._cells[String(_arg_1)])
                {
                    this._cells[String(_arg_1)].info = null;
                };
                return;
            };
            if (_arg_2.Count == 0)
            {
                this._cells[String(_arg_1)].info = null;
            }
            else
            {
                this._cells[String(_arg_1)].info = _arg_2;
            };
        }

        protected function clearDataCells():void
        {
            var _local_1:LockBagCell;
            for each (_local_1 in this._cells)
            {
                _local_1.info = null;
            };
        }

        public function setData(_arg_1:BagInfo):void
        {
            var _local_2:String;
            var _local_3:EquipmentTemplateInfo;
            this._isSetFoodData = false;
            if (((this._bagdata == _arg_1) && (SavePointManager.Instance.savePoints[64])))
            {
                return;
            };
            if (this._bagdata != null)
            {
                this._bagdata.removeEventListener(BagEvent.UPDATE, this.__updateGoods);
            };
            this.clearDataCells();
            this._bagdata = _arg_1;
            for (_local_2 in this._bagdata.items)
            {
                if (this._cells[_local_2] != null)
                {
                    this._bagdata.items[_local_2].isMoveSpace = true;
                    this._cells[_local_2].info = this._bagdata.items[_local_2];
                    if (SavePointManager.Instance.isInSavePoint(33))
                    {
                        if (int(_local_2) > BagInfo.PERSONAL_EQUIP_COUNT)
                        {
                            if (this._cells[_local_2].info.CategoryID == EquipType.EQUIP)
                            {
                                _local_3 = ItemManager.Instance.getEquipTemplateById(this._cells[_local_2].info.TemplateID);
                                if ((this._cells[_local_2] is LockBagCell))
                                {
                                    if (_local_3.TemplateType == 5)
                                    {
                                        this._cells[_local_2].light = true;
                                    }
                                    else
                                    {
                                        this._cells[_local_2].locked = true;
                                    };
                                };
                                NewHandContainer.Instance.showArrow(ArrowType.CLICK_TO_EQUIP, 135, "trainer.ClickToEquipArrowPos", "asset.trainer.clickToEquip", "trainer.ClickToEquipTipPos", LayerManager.Instance.getLayerByType(LayerManager.GAME_TOP_LAYER));
                            }
                            else
                            {
                                if ((this._cells[_local_2] is LockBagCell))
                                {
                                    this._cells[_local_2].locked = true;
                                };
                            };
                        };
                    };
                };
            };
            this._bagdata.addEventListener(BagEvent.UPDATE, this.__updateGoods);
        }

        protected function __updateFoodGoods(_arg_1:BagEvent):void
        {
            var _local_3:InventoryItemInfo;
            var _local_4:int;
            var _local_5:InventoryItemInfo;
            var _local_6:String;
            var _local_7:InventoryItemInfo;
            var _local_8:InventoryItemInfo;
            if ((!(this._bagdata)))
            {
                return;
            };
            var _local_2:Dictionary = _arg_1.changedSlots;
            for each (_local_3 in _local_2)
            {
                _local_4 = -1;
                _local_5 = null;
                for (_local_6 in this._bagdata.items)
                {
                    _local_7 = (this._bagdata.items[_local_6] as InventoryItemInfo);
                    if (_local_3.ItemID == _local_7.ItemID)
                    {
                        _local_5 = _local_3;
                        _local_4 = int(_local_6);
                        break;
                    };
                };
                if (_local_4 != -1)
                {
                    _local_8 = this._bagdata.getItemAt(_local_4);
                    if (_local_8)
                    {
                        _local_8.Count = _local_5.Count;
                        if (this._cells[String(_local_4)].info)
                        {
                            this.setCellInfo(_local_4, null);
                        }
                        else
                        {
                            this.setCellInfo(_local_4, _local_8);
                        };
                    }
                    else
                    {
                        this.setCellInfo(_local_4, null);
                    };
                    dispatchEvent(new Event(Event.CHANGE));
                };
            };
        }

        protected function __updateGoods(_arg_1:BagEvent):void
        {
            var _local_2:Dictionary;
            var _local_3:InventoryItemInfo;
            var _local_4:InventoryItemInfo;
            if (this._isSetFoodData)
            {
                this.__updateFoodGoods(_arg_1);
            }
            else
            {
                _local_2 = _arg_1.changedSlots;
                for each (_local_3 in _local_2)
                {
                    _local_4 = this._bagdata.getItemAt(_local_3.Place);
                    if (_local_4)
                    {
                        this.setCellInfo(_local_4.Place, _local_4);
                    }
                    else
                    {
                        this.setCellInfo(_local_3.Place, null);
                    };
                    dispatchEvent(new Event(Event.CHANGE));
                };
            };
        }

        public function unlockAllCells():void
        {
            var _local_1:LockBagCell;
            for each (_local_1 in this._cells)
            {
                _local_1.locked = false;
                if (_local_1.isLighting)
                {
                    _local_1.light = false;
                };
            };
        }

        public function weaponShowLight():void
        {
            var _local_1:String;
            var _local_2:EquipmentTemplateInfo;
            for (_local_1 in this._bagdata.items)
            {
                if (int(_local_1) > BagInfo.PERSONAL_EQUIP_COUNT)
                {
                    if (this._cells[_local_1] != null)
                    {
                        if (this._cells[_local_1].info.CategoryID == EquipType.EQUIP)
                        {
                            _local_2 = ItemManager.Instance.getEquipTemplateById(this._cells[_local_1].info.TemplateID);
                            if ((this._cells[_local_1] is LockBagCell))
                            {
                                if (_local_2.TemplateType == 5)
                                {
                                    this._cells[_local_1].light = true;
                                }
                                else
                                {
                                    this._cells[_local_1].locked = true;
                                };
                            };
                        }
                        else
                        {
                            if ((this._cells[_local_1] is LockBagCell))
                            {
                                this._cells[_local_1].locked = true;
                            };
                        };
                    };
                };
            };
        }

        override public function dispose():void
        {
            var _local_1:LockBagCell;
            if (this._bagdata != null)
            {
                this._bagdata.removeEventListener(BagEvent.UPDATE, this.__updateGoods);
                this._bagdata = null;
            };
            for each (_local_1 in this._cells)
            {
                _local_1.removeEventListener(InteractiveEvent.CLICK, this.__clickHandler);
                _local_1.removeEventListener(CellEvent.LOCK_CHANGED, this.__cellChanged);
                _local_1.removeEventListener(MouseEvent.MOUSE_OVER, this._cellOverEff);
                _local_1.removeEventListener(MouseEvent.MOUSE_OUT, this._cellOutEff);
                _local_1.removeEventListener(InteractiveEvent.DOUBLE_CLICK, this.__doubleClickHandler);
                DoubleClickManager.Instance.disableDoubleClick(_local_1);
                _local_1.dispose();
            };
            this._cells = null;
            this._cellVec = null;
            if (this._cellMouseOverBg)
            {
                if (this._cellMouseOverBg.parent)
                {
                    this._cellMouseOverBg.parent.removeChild(this._cellMouseOverBg);
                };
                this._cellMouseOverBg.bitmapData.dispose();
            };
            this._cellMouseOverBg = null;
            super.dispose();
        }


    }
}//package bagAndInfo.bag

