// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//petsBag.view.space.PetSpaceBagList

package petsBag.view.space
{
    import flash.display.Sprite;
    import com.pickgliss.ui.core.Disposeable;
    import com.pickgliss.ui.image.MutipleImage;
    import com.pickgliss.ui.controls.container.SimpleTileList;
    import com.pickgliss.ui.controls.ScrollPanel;
    import com.pickgliss.ui.text.FilterFrameText;
    import road7th.data.DictionaryData;
    import com.pickgliss.ui.ComponentFactory;
    import ddt.manager.LanguageMgr;
    import bagAndInfo.cell.BagCell;
    import ddt.events.CellEvent;
    import ddt.manager.SoundManager;
    import com.pickgliss.events.InteractiveEvent;
    import flash.events.Event;
    import flash.events.MouseEvent;
    import ddt.data.goods.InventoryItemInfo;
    import road7th.data.DictionaryEvent;
    import store.events.StoreBagEvent;
    import store.events.UpdateItemEvent;
    import com.pickgliss.utils.DoubleClickManager;
    import com.pickgliss.utils.ObjectUtils;

    public class PetSpaceBagList extends Sprite implements Disposeable 
    {

        private static var cellNum:int = 70;
        public static const SMALLGRID:int = 21;

        protected var _bg:MutipleImage;
        private var _list:SimpleTileList;
        protected var panel:ScrollPanel;
        private var _titleText:FilterFrameText;
        private var _tipText:FilterFrameText;
        protected var _cells:DictionaryData;
        protected var _bagdata:DictionaryData;
        protected var _bagType:int;
        private var beginGridNumber:int;
        private var _selectedIndex:int;


        public function setup(_arg_1:int, _arg_2:int):void
        {
            this._bagType = _arg_1;
            this.beginGridNumber = _arg_2;
            this.init();
        }

        private function init():void
        {
            this._bg = ComponentFactory.Instance.creatComponentByStylename("petBag.space.bagBg");
            addChild(this._bg);
            this._titleText = ComponentFactory.Instance.creat("petsBag。bagList.ItemCellTitleText");
            this._titleText.text = LanguageMgr.GetTranslation("petsBag.view.bagList.title");
            addChild(this._titleText);
            this._tipText = ComponentFactory.Instance.creat("petsBag。bagList.ItemCellTipText");
            this._tipText.text = LanguageMgr.GetTranslation("petsBag.view.bagList.tip");
            addChild(this._tipText);
            this.createPanel();
            this._list = new SimpleTileList(4);
            this._list.vSpace = 0;
            this._list.hSpace = 0;
            this.panel.setView(this._list);
            this.createCells();
            this.panel.invalidateViewport();
        }

        protected function createPanel():void
        {
            this.panel = ComponentFactory.Instance.creat("petsBag.space.baglistScrollPanel");
            addChild(this.panel);
        }

        protected function createCells():void
        {
            this._cells = new DictionaryData();
        }

        private function __doubleClickHandler(_arg_1:InteractiveEvent):void
        {
            _arg_1.stopImmediatePropagation();
            if ((_arg_1.currentTarget as BagCell).info != null)
            {
                dispatchEvent(new CellEvent(CellEvent.DOUBLE_CLICK, _arg_1.currentTarget, true));
                this.selectedIndex = _arg_1.target.place;
                SoundManager.instance.play("008");
            };
        }

        private function __clickHandler(_arg_1:InteractiveEvent):void
        {
            dispatchEvent(new CellEvent(CellEvent.ITEM_CLICK, _arg_1.target));
            this.selectedIndex = _arg_1.target.place;
        }

        protected function __cellChanged(_arg_1:Event):void
        {
            dispatchEvent(new Event(Event.CHANGE));
        }

        protected function __cellClick(_arg_1:MouseEvent):void
        {
            _arg_1.stopImmediatePropagation();
        }

        public function getCellByPlace(_arg_1:int):BagCell
        {
            return (this._cells[_arg_1]);
        }

        public function setCellInfo(_arg_1:int, _arg_2:InventoryItemInfo):void
        {
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
            };
        }

        public function setData(_arg_1:DictionaryData):void
        {
            var _local_2:String;
            if (this._bagdata == _arg_1)
            {
                return;
            };
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
                    };
                };
            };
            this._bagdata.addEventListener(DictionaryEvent.ADD, this.__addGoods);
            this._bagdata.addEventListener(StoreBagEvent.REMOVE, this.__removeGoods);
            this._bagdata.addEventListener(DictionaryEvent.UPDATE, this.__updateGoods);
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
            _local_4 = int(((int(((_local_2 - 1) / 4)) + 1) * 4));
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
            var _local_2:PetSpaceBagCell = new PetSpaceBagCell(_arg_1);
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
            while (_local_2 < (_arg_1 + 4))
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

        protected function __removeGoods(_arg_1:StoreBagEvent):void
        {
            this._cells[_arg_1.pos].info = null;
            this.updateScrollBar(false);
        }

        private function __updateGoods(_arg_1:DictionaryEvent):void
        {
            var _local_2:InventoryItemInfo = (_arg_1.data as InventoryItemInfo);
            if (_local_2)
            {
                this._cells[_local_2.Place] = _local_2;
                this.updateScrollBar(false);
            };
        }

        public function getCellByPos(_arg_1:int):BagCell
        {
            return (this._cells[_arg_1]);
        }

        private function invalidatePanel():void
        {
            this.panel.invalidateViewport();
        }

        public function dispose():void
        {
            var _local_1:BagCell;
            ObjectUtils.disposeObject(this._bg);
            this._bg = null;
            ObjectUtils.disposeObject(this._titleText);
            this._titleText = null;
            ObjectUtils.disposeObject(this._tipText);
            this._tipText = null;
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
                _local_1.removeEventListener(MouseEvent.CLICK, this.__cellClick);
                _local_1.removeEventListener(CellEvent.LOCK_CHANGED, this.__cellChanged);
                ObjectUtils.disposeObject(_local_1);
            };
            this._cells.clear();
            DoubleClickManager.Instance.clearTarget();
            ObjectUtils.disposeObject(this._list);
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

        public function get selectedIndex():int
        {
            return (this._selectedIndex);
        }

        public function set selectedIndex(_arg_1:int):void
        {
            var _local_2:PetSpaceBagCell;
            this._selectedIndex = _arg_1;
            for each (_local_2 in this._cells)
            {
                _local_2.selected = ((_local_2.info) && (_local_2.place == this._selectedIndex));
            };
        }


    }
}//package petsBag.view.space

