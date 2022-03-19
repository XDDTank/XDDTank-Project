// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//bagAndInfo.info.PlayerFashionView

package bagAndInfo.info
{
    import flash.display.Sprite;
    import com.pickgliss.ui.core.Disposeable;
    import ddt.data.player.PlayerInfo;
    import ddt.data.BagInfo;
    import flash.display.Bitmap;
    import __AS3__.vec.Vector;
    import bagAndInfo.cell.PersonalInfoCell;
    import com.pickgliss.ui.text.FilterFrameText;
    import com.pickgliss.ui.ComponentFactory;
    import flash.geom.Point;
    import ddt.manager.LanguageMgr;
    import ddt.events.BagEvent;
    import bagAndInfo.cell.CellFactory;
    import ddt.events.CellEvent;
    import ddt.data.goods.InventoryItemInfo;
    import ddt.manager.PlayerManager;
    import ddt.manager.MessageTipManager;
    import ddt.manager.SocketManager;
    import ddt.manager.SavePointManager;
    import trainer.view.NewHandContainer;
    import trainer.data.ArrowType;
    import flash.utils.Dictionary;
    import ddt.data.goods.ItemTemplateInfo;
    import ddt.data.EquipType;
    import com.pickgliss.utils.ObjectUtils;
    import __AS3__.vec.*;

    public class PlayerFashionView extends Sprite implements Disposeable 
    {

        private var _info:PlayerInfo;
        private var _bagInfo:BagInfo;
        private var _cellPos:Array;
        private var _bg:Bitmap;
        private var _cellContent:Sprite;
        private var _cells:Vector.<PersonalInfoCell>;
        private var _cellNames:Vector.<FilterFrameText>;
        private var _showSelfOperation:Boolean;

        public function PlayerFashionView()
        {
            this.initView();
            this.initPos();
            this.creatCells();
        }

        private function initView():void
        {
            this._bg = ComponentFactory.Instance.creatBitmap("bagAndInfo.Fashionview.bg");
            addChild(this._bg);
            this._cellContent = new Sprite();
            addChild(this._cellContent);
            this._cellNames = new Vector.<FilterFrameText>();
            this.initName();
        }

        private function initName():void
        {
            var _local_2:Point;
            var _local_3:FilterFrameText;
            var _local_1:int;
            while (_local_1 < 10)
            {
                _local_2 = ComponentFactory.Instance.creatCustomObject(("bagAndInfo.info.FashionCellName.pos" + _local_1.toString()));
                _local_3 = ComponentFactory.Instance.creatComponentByStylename("ddtbagAndInfo.FashionName.text");
                _local_3.text = LanguageMgr.GetTranslation(("ddtbagAndInfo.FashionName.txt" + _local_1.toString()));
                _local_3.x = _local_2.x;
                _local_3.y = _local_2.y;
                addChild(_local_3);
                this._cellNames.push(_local_3);
                _local_1++;
            };
        }

        private function initPos():void
        {
            this._cellPos = [ComponentFactory.Instance.creatCustomObject("bagAndInfo.info.Fashion.pos1"), ComponentFactory.Instance.creatCustomObject("bagAndInfo.info.Fashion.pos2"), ComponentFactory.Instance.creatCustomObject("bagAndInfo.info.Fashion.pos3"), ComponentFactory.Instance.creatCustomObject("bagAndInfo.info.Fashion.pos4"), ComponentFactory.Instance.creatCustomObject("bagAndInfo.info.Fashion.pos5"), ComponentFactory.Instance.creatCustomObject("bagAndInfo.info.Fashion.pos6"), ComponentFactory.Instance.creatCustomObject("bagAndInfo.info.Fashion.pos7"), ComponentFactory.Instance.creatCustomObject("bagAndInfo.info.Fashion.pos8"), ComponentFactory.Instance.creatCustomObject("bagAndInfo.info.Fashion.pos9"), ComponentFactory.Instance.creatCustomObject("bagAndInfo.info.Fashion.pos10")];
        }

        private function removeEvent():void
        {
            if (this._bagInfo)
            {
                this._bagInfo.removeEventListener(BagEvent.UPDATE, this.__updateCells);
            };
        }

        public function set info(_arg_1:PlayerInfo):void
        {
            if (this._info == _arg_1)
            {
                return;
            };
            this._info = _arg_1;
        }

        public function get info():PlayerInfo
        {
            return (this._info);
        }

        public function set bagInfo(_arg_1:BagInfo):void
        {
            if (this._bagInfo == _arg_1)
            {
                return;
            };
            if (this._bagInfo)
            {
                this._bagInfo.removeEventListener(BagEvent.UPDATE, this.__updateCells);
                this._bagInfo = null;
            };
            this._bagInfo = _arg_1;
            if (this._bagInfo)
            {
                this._bagInfo.addEventListener(BagEvent.UPDATE, this.__updateCells);
            };
            this.updateCells();
        }

        public function get bagInfo():BagInfo
        {
            return (this._bagInfo);
        }

        private function creatCells():void
        {
            var _local_1:int;
            var _local_2:PersonalInfoCell;
            this._cells = new Vector.<PersonalInfoCell>();
            _local_1 = 0;
            while (_local_1 < 10)
            {
                _local_2 = (CellFactory.instance.createPersonalInfoCell(_local_1) as PersonalInfoCell);
                _local_2.addEventListener(CellEvent.ITEM_CLICK, this.__cellClickHandler);
                _local_2.addEventListener(CellEvent.DOUBLE_CLICK, this.__cellDoubleClickHandler);
                _local_2.x = this._cellPos[_local_1].x;
                _local_2.y = this._cellPos[_local_1].y;
                this._cellContent.addChild(_local_2);
                this._cells.push(_local_2);
                _local_1++;
            };
        }

        private function __cellClickHandler(_arg_1:CellEvent):void
        {
            var _local_2:PersonalInfoCell;
            if (this._showSelfOperation)
            {
                _local_2 = (_arg_1.data as PersonalInfoCell);
                _local_2.dragStart();
            };
        }

        private function __cellDoubleClickHandler(_arg_1:CellEvent):void
        {
            var _local_2:PersonalInfoCell;
            var _local_3:InventoryItemInfo;
            var _local_4:int;
            if (this._showSelfOperation)
            {
                _local_2 = (_arg_1.data as PersonalInfoCell);
                if (((_local_2) && (_local_2.info)))
                {
                    _local_3 = (_local_2.info as InventoryItemInfo);
                    _local_4 = this._info.Bag.itemBagNumber;
                    if (PlayerManager.Instance.Self.Bag.itemBagFull())
                    {
                        return (MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.bagAndInfo.moveGooDtips")));
                    };
                    PlayerManager.Instance.Self.bagVibleType = 0;
                    SocketManager.Instance.out.sendMoveGoods(BagInfo.EQUIPBAG, _local_3.Place, BagInfo.EQUIPBAG, -1, _local_3.Count);
                };
            };
        }

        private function __updateCells(_arg_1:BagEvent):void
        {
            var _local_2:String;
            var _local_3:int;
            for (_local_2 in _arg_1.changedSlots)
            {
                _local_3 = int(_local_2);
                if (_local_3 <= BagInfo.PERSONAL_EQUIP_COUNT)
                {
                    if (_local_3 >= 10)
                    {
                        return;
                    };
                    this._cells[_local_3].info = this._bagInfo.getItemAt(_local_3);
                    if (this._cells[_local_3].info == null)
                    {
                        this._cellNames[_local_3].visible = true;
                    }
                    else
                    {
                        this._cellNames[_local_3].visible = false;
                    };
                    if (SavePointManager.Instance.isInSavePoint(64))
                    {
                        if (this._cells[_local_3].info)
                        {
                            SavePointManager.Instance.setSavePoint(64);
                            NewHandContainer.Instance.clearArrowByID(ArrowType.CLICK_TO_EQUIP);
                            NewHandContainer.Instance.clearArrowByID(ArrowType.CLICK_FASHION_BTN);
                            dispatchEvent(new BagEvent(BagEvent.FASHION_READY, new Dictionary()));
                        }
                        else
                        {
                            dispatchEvent(new BagEvent(BagEvent.FASHION_REMOVE, new Dictionary()));
                        };
                    };
                };
            };
        }

        private function updateCells():void
        {
            var _local_1:PersonalInfoCell;
            for each (_local_1 in this._cells)
            {
                _local_1.info = ((this._info == null) ? null : this._bagInfo.getItemAt(_local_1.place));
                if ((_local_1.info == null))
                {
                    this._cellNames[_local_1.place].visible = true;
                }
                else
                {
                    this._cellNames[_local_1.place].visible = false;
                };
            };
        }

        private function clearCells():void
        {
            var _local_1:int;
            while (_local_1 < this._cells.length)
            {
                if (this._cells[_local_1])
                {
                    this._cells[_local_1].removeEventListener(CellEvent.ITEM_CLICK, this.__cellClickHandler);
                    this._cells[_local_1].removeEventListener(CellEvent.DOUBLE_CLICK, this.__cellDoubleClickHandler);
                    if (this._cells[_local_1].parent)
                    {
                        this._cells[_local_1].parent.removeChild((this._cells[_local_1] as PersonalInfoCell));
                    };
                    this._cells[_local_1].dispose();
                    this._cells[_local_1] = null;
                };
                _local_1++;
            };
            var _local_2:int;
            while (_local_2 < this._cellNames.length)
            {
                if (this._cellNames[_local_2])
                {
                    this._cellNames[_local_2].dispose();
                    this._cellNames[_local_2] = null;
                };
                _local_2++;
            };
        }

        public function get showSelfOperation():Boolean
        {
            return (this._showSelfOperation);
        }

        public function set showSelfOperation(_arg_1:Boolean):void
        {
            this._showSelfOperation = _arg_1;
        }

        public function startShine(_arg_1:ItemTemplateInfo):void
        {
            var _local_2:Array = this.getCellIndex(_arg_1).split(",");
            var _local_3:int;
            while (_local_3 < _local_2.length)
            {
                if (int(_local_2[_local_3]) >= 0)
                {
                    (this._cells[int(_local_2[_local_3])] as PersonalInfoCell).shine();
                };
                _local_3++;
            };
        }

        public function stopShine():void
        {
            var _local_1:PersonalInfoCell;
            for each (_local_1 in this._cells)
            {
                (_local_1 as PersonalInfoCell).stopShine();
            };
        }

        private function getCellIndex(_arg_1:ItemTemplateInfo):String
        {
            if (EquipType.isRingEquipment(_arg_1))
            {
                return ("6");
            };
            switch (_arg_1.CategoryID)
            {
                case EquipType.HEAD:
                    return ("2");
                case EquipType.GLASS:
                    return ("8");
                case EquipType.HAIR:
                    return ("4");
                case EquipType.EFF:
                    return ("3");
                case EquipType.CLOTH:
                    return ("0");
                case EquipType.FACE:
                    return ("1");
                case EquipType.SUITS:
                    return ("5");
                case EquipType.WING:
                    return ("7");
                case EquipType.CHATBALL:
                    return ("9");
                default:
                    return ("-1");
            };
        }

        public function dispose():void
        {
            this.clearCells();
            this.removeEvent();
            if (parent)
            {
                parent.removeChild(this);
            };
            ObjectUtils.disposeObject(this._bg);
            this._bg = null;
            ObjectUtils.disposeAllChildren(this._cellContent);
            this._cellContent = null;
            this._cells = null;
            this._info = null;
            this._bagInfo = null;
        }


    }
}//package bagAndInfo.info

