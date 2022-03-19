// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//bagAndInfo.info.PlayerEquipView

package bagAndInfo.info
{
    import flash.display.Sprite;
    import com.pickgliss.ui.core.Disposeable;
    import ddt.data.player.PlayerInfo;
    import ddt.data.BagInfo;
    import flash.display.Bitmap;
    import __AS3__.vec.Vector;
    import bagAndInfo.cell.PersonalInfoCell;
    import bagAndInfo.cell.EquipLock;
    import com.pickgliss.ui.ComponentFactory;
    import ddt.events.BagEvent;
    import ddt.events.PlayerPropertyEvent;
    import ddt.manager.PlayerManager;
    import bagAndInfo.cell.CellFactory;
    import ddt.events.CellEvent;
    import ddt.data.goods.InventoryItemInfo;
    import ddt.manager.MessageTipManager;
    import ddt.manager.LanguageMgr;
    import ddt.manager.SocketManager;
    import ddt.data.goods.EquipmentTemplateInfo;
    import ddt.manager.ItemManager;
    import ddt.manager.SavePointManager;
    import ddt.data.EquipType;
    import trainer.view.NewHandContainer;
    import trainer.data.ArrowType;
    import com.pickgliss.ui.LayerManager;
    import flash.utils.Dictionary;
    import ddt.data.goods.ItemTemplateInfo;
    import flash.geom.Point;
    import com.pickgliss.utils.ObjectUtils;
    import __AS3__.vec.*;

    public class PlayerEquipView extends Sprite implements Disposeable 
    {

        private var _info:PlayerInfo;
        private var _bagInfo:BagInfo;
        private var _cellPos:Array;
        private var _bg:Bitmap;
        private var _cellContent:Sprite;
        private var _cells:Vector.<PersonalInfoCell>;
        private var _showSelfOperation:Boolean;
        private var _lockCell:Vector.<EquipLock>;
        private var _lockPos:Array;

        public function PlayerEquipView()
        {
            this.initView();
            this.initPos();
            this.initLockPos();
            this.creatCells();
        }

        private function initView():void
        {
            this._bg = ComponentFactory.Instance.creatBitmap("bagAndInfo.Equipview.bg");
            addChild(this._bg);
            this._cellContent = new Sprite();
            addChild(this._cellContent);
        }

        private function initPos():void
        {
            this._cellPos = ["", "", "", "", "", "", "", "", "", "", ComponentFactory.Instance.creatCustomObject("bagAndInfo.info.equip.pos1"), ComponentFactory.Instance.creatCustomObject("bagAndInfo.info.equip.pos2"), ComponentFactory.Instance.creatCustomObject("bagAndInfo.info.equip.pos5"), ComponentFactory.Instance.creatCustomObject("bagAndInfo.info.equip.pos6"), ComponentFactory.Instance.creatCustomObject("bagAndInfo.info.equip.pos8"), ComponentFactory.Instance.creatCustomObject("bagAndInfo.info.equip.pos7"), ComponentFactory.Instance.creatCustomObject("bagAndInfo.info.equip.pos9"), ComponentFactory.Instance.creatCustomObject("bagAndInfo.info.equip.pos10"), ComponentFactory.Instance.creatCustomObject("bagAndInfo.info.equip.pos11"), ComponentFactory.Instance.creatCustomObject("bagAndInfo.info.equip.pos12"), ComponentFactory.Instance.creatCustomObject("bagAndInfo.info.equip.pos13"), ComponentFactory.Instance.creatCustomObject("bagAndInfo.info.equip.pos14")];
        }

        private function initLockPos():void
        {
            this._lockPos = [ComponentFactory.Instance.creatCustomObject("bagAndInfo.lockCell.pos0"), ComponentFactory.Instance.creatCustomObject("bagAndInfo.lockCell.pos1"), ComponentFactory.Instance.creatCustomObject("bagAndInfo.lockCell.pos2"), ComponentFactory.Instance.creatCustomObject("bagAndInfo.lockCell.pos3")];
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
            if (this.info)
            {
                this._info.removeEventListener(PlayerPropertyEvent.PROPERTY_CHANGE, this.__proertyChange);
                this._info = null;
            };
            this._info = _arg_1;
            if (((this._info) && (PlayerManager.Instance.playerstate == PlayerViewState.EQUIP)))
            {
                if (this._info.ID == PlayerManager.Instance.Self.ID)
                {
                    this._info.addEventListener(PlayerPropertyEvent.PROPERTY_CHANGE, this.__proertyChange);
                };
            };
            if (this._info.ID == PlayerManager.Instance.Self.ID)
            {
                this.creatLockCells();
            };
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
            if (((this._info) && (PlayerManager.Instance.playerstate == PlayerViewState.EQUIP)))
            {
                this._bagInfo.addEventListener(BagEvent.UPDATE, this.__updateCells);
            };
            this.updateCells();
        }

        public function get bagInfo():BagInfo
        {
            return (this._bagInfo);
        }

        private function __proertyChange(_arg_1:PlayerPropertyEvent):void
        {
            this.updateLockCells();
        }

        private function creatCells():void
        {
            var _local_1:PersonalInfoCell;
            var _local_2:int;
            this._cells = new Vector.<PersonalInfoCell>();
            _local_2 = 0;
            while (_local_2 < 22)
            {
                if (_local_2 >= 10)
                {
                    _local_1 = (CellFactory.instance.createPersonalInfoCell(_local_2) as PersonalInfoCell);
                    _local_1.addEventListener(CellEvent.ITEM_CLICK, this.__cellClickHandler);
                    _local_1.addEventListener(CellEvent.DOUBLE_CLICK, this.__cellDoubleClickHandler);
                    _local_1.x = this._cellPos[_local_2].x;
                    _local_1.y = this._cellPos[_local_2].y;
                    this._cellContent.addChild(_local_1);
                    this._cells.push(_local_1);
                }
                else
                {
                    _local_1 = (CellFactory.instance.createPersonalInfoCell(0) as PersonalInfoCell);
                    this._cells.push(_local_1);
                };
                _local_2++;
            };
        }

        private function creatLockCells():void
        {
            var _local_1:int;
            var _local_2:EquipLock;
            this._lockCell = new Vector.<EquipLock>(4);
            _local_1 = 0;
            while (_local_1 < this._lockCell.length)
            {
                _local_2 = new EquipLock();
                if (((_local_1 == 0) && (PlayerManager.Instance.Self.Grade < 25)))
                {
                    addChild(_local_2);
                    this._lockCell[_local_1] = _local_2;
                }
                else
                {
                    if (((_local_1 == 1) && (PlayerManager.Instance.Self.Grade < 30)))
                    {
                        addChild(_local_2);
                        this._lockCell[_local_1] = _local_2;
                    }
                    else
                    {
                        if (((_local_1 == 2) && (PlayerManager.Instance.Self.Grade < 35)))
                        {
                            addChild(_local_2);
                            this._lockCell[_local_1] = _local_2;
                        }
                        else
                        {
                            if (((_local_1 == 3) && (PlayerManager.Instance.Self.Grade < 40)))
                            {
                                addChild(_local_2);
                                this._lockCell[_local_1] = _local_2;
                            };
                        };
                    };
                };
                _local_2.x = this._lockPos[_local_1].x;
                _local_2.y = this._lockPos[_local_1].y;
                _local_2.tipStyle = "ddt.view.tips.OneLineTip";
                _local_2.tipData = _local_2.gettipData(_local_1);
                _local_2.tipDirctions = "0,3,7";
                _local_1++;
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

        private function clearCells():void
        {
            var _local_1:PersonalInfoCell;
            while (this._cells.length > 0)
            {
                _local_1 = this._cells.shift();
                _local_1.removeEventListener(CellEvent.ITEM_CLICK, this.__cellClickHandler);
                _local_1.removeEventListener(CellEvent.DOUBLE_CLICK, this.__cellDoubleClickHandler);
                _local_1.dispose();
                _local_1 = null;
            };
        }

        private function updateLockCells():void
        {
            var _local_1:int;
            while (_local_1 < this._lockCell.length)
            {
                if (this._lockCell[_local_1])
                {
                    if (((_local_1 == 0) && (PlayerManager.Instance.Self.Grade >= 25)))
                    {
                        if (this._lockCell[_local_1].parent)
                        {
                            this._lockCell[_local_1].parent.removeChild((this._lockCell[_local_1] as EquipLock));
                            this._lockCell[_local_1].dispose();
                            this._lockCell[_local_1] = null;
                        };
                    }
                    else
                    {
                        if (((_local_1 == 1) && (PlayerManager.Instance.Self.Grade >= 30)))
                        {
                            if (this._lockCell[_local_1].parent)
                            {
                                this._lockCell[_local_1].parent.removeChild((this._lockCell[_local_1] as EquipLock));
                                this._lockCell[_local_1].dispose();
                                this._lockCell[_local_1] = null;
                            };
                        }
                        else
                        {
                            if (((_local_1 == 2) && (PlayerManager.Instance.Self.Grade >= 35)))
                            {
                                if (this._lockCell[_local_1].parent)
                                {
                                    this._lockCell[_local_1].parent.removeChild((this._lockCell[_local_1] as EquipLock));
                                    this._lockCell[_local_1].dispose();
                                    this._lockCell[_local_1] = null;
                                };
                            }
                            else
                            {
                                if (((_local_1 == 3) && (PlayerManager.Instance.Self.Grade >= 40)))
                                {
                                    if (this._lockCell[_local_1].parent)
                                    {
                                        this._lockCell[_local_1].parent.removeChild((this._lockCell[_local_1] as EquipLock));
                                        this._lockCell[_local_1].dispose();
                                        this._lockCell[_local_1] = null;
                                    };
                                };
                            };
                        };
                    };
                };
                _local_1++;
            };
        }

        private function clearLockCells():void
        {
            var _local_1:int;
            while (_local_1 < this._lockCell.length)
            {
                if (this._lockCell[_local_1])
                {
                    this._lockCell[_local_1].parent.removeChild((this._lockCell[_local_1] as EquipLock));
                    this._lockCell[_local_1].dispose();
                    this._lockCell[_local_1] = null;
                };
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
            var _local_4:EquipmentTemplateInfo;
            for (_local_2 in _arg_1.changedSlots)
            {
                _local_3 = int(_local_2);
                if (_local_3 <= BagInfo.PERSONAL_EQUIP_COUNT)
                {
                    this._cells[_local_3].info = this._bagInfo.getItemAt(_local_3);
                    if (this._cells[_local_3].info == null)
                    {
                        this._cells[_local_3].seteuipQualityBg(0);
                    }
                    else
                    {
                        if (this._cells[_local_3].info != null)
                        {
                            _local_4 = ItemManager.Instance.getEquipTemplateById(this._cells[_local_3].info.TemplateID);
                            if (((!(_local_4 == null)) && (this._cells[_local_3].info.Property8 == "0")))
                            {
                                this._cells[_local_3].seteuipQualityBg(_local_4.QualityID);
                            }
                            else
                            {
                                this._cells[_local_3].seteuipQualityBg(0);
                            };
                        };
                    };
                    if (SavePointManager.Instance.isInSavePoint(33))
                    {
                        if (this._cells[_local_3].info != null)
                        {
                            if (this._cells[_local_3].info.CategoryID == EquipType.EQUIP)
                            {
                                NewHandContainer.Instance.clearArrowByID(ArrowType.CLICK_TO_EQUIP);
                                NewHandContainer.Instance.showArrow(ArrowType.CLICK_FASHION_BTN, 45, "trainer.clickFashionTipPos", "", "", LayerManager.Instance.getLayerByType(LayerManager.GAME_TOP_LAYER));
                                dispatchEvent(new BagEvent(BagEvent.WEAPON_READY, new Dictionary()));
                            };
                        }
                        else
                        {
                            NewHandContainer.Instance.clearArrowByID(ArrowType.CLICK_FASHION_BTN);
                            dispatchEvent(new BagEvent(BagEvent.WEAPON_REMOVE, new Dictionary()));
                        };
                    };
                };
            };
        }

        private function updateCells():void
        {
            var _local_1:PersonalInfoCell;
            var _local_2:EquipmentTemplateInfo;
            for each (_local_1 in this._cells)
            {
                _local_1.info = ((this._info == null) ? null : this._bagInfo.getItemAt(_local_1.place));
                if (_local_1.info == null)
                {
                    _local_2 = null;
                };
                if (_local_1.info != null)
                {
                    _local_2 = ItemManager.Instance.getEquipTemplateById(_local_1.info.TemplateID);
                };
                if (((!(_local_2 == null)) && (_local_1.info.Property8 == "0")))
                {
                    _local_1.seteuipQualityBg(_local_2.QualityID);
                }
                else
                {
                    _local_1.seteuipQualityBg(0);
                };
                if (SavePointManager.Instance.isInSavePoint(64))
                {
                    if (_local_1.place == 14)
                    {
                        if (_local_1.info)
                        {
                            NewHandContainer.Instance.clearArrowByID(ArrowType.CLICK_FASHION_BTN);
                            dispatchEvent(new BagEvent(BagEvent.WEAPON_READY, new Dictionary()));
                            NewHandContainer.Instance.showArrow(ArrowType.CLICK_FASHION_BTN, 45, "trainer.clickFashionTipPos", "", "", LayerManager.Instance.getLayerByType(LayerManager.GAME_TOP_LAYER));
                        };
                    };
                };
            };
        }

        public function get info():PlayerInfo
        {
            return (this._info);
        }

        public function startShine(_arg_1:ItemTemplateInfo):void
        {
            var _local_3:Array;
            var _local_4:int;
            var _local_5:Array;
            var _local_6:int;
            var _local_2:EquipmentTemplateInfo = ItemManager.Instance.getEquipTemplateById(_arg_1.TemplateID);
            if (((_local_2 == null) && (!(EquipType.isWeddingRing(_arg_1)))))
            {
                return;
            };
            if (((_local_2.TemplateType == 8) && (PlayerManager.Instance.Self.Grade < 30)))
            {
                return;
            };
            if (((_local_2.TemplateType == 9) && (PlayerManager.Instance.Self.Grade < 35)))
            {
                return;
            };
            if (((_local_2.TemplateType == 10) && (PlayerManager.Instance.Self.Grade < 40)))
            {
                return;
            };
            if (EquipType.isWeddingRing(_arg_1))
            {
                _local_3 = this.getWeddingRingIndex().split(",");
                _local_4 = 0;
                while (_local_4 < _local_3.length)
                {
                    if (int(_local_3[_local_6]) >= 0)
                    {
                        (this._cells[int(_local_3[_local_6])] as PersonalInfoCell).shine();
                    };
                    _local_4++;
                };
            };
            if ((((_arg_1.NeedSex == 0) || (_arg_1.NeedSex == ((PlayerManager.Instance.Self.Sex) ? 1 : 2))) && (!(EquipType.isWeddingRing(_arg_1)))))
            {
                _local_5 = this.getCellIndex(_local_2).split(",");
                _local_6 = 0;
                while (_local_6 < _local_5.length)
                {
                    if (int(_local_5[_local_6]) >= 0)
                    {
                        (this._cells[int(_local_5[_local_6])] as PersonalInfoCell).shine();
                    };
                    _local_6++;
                };
            };
        }

        private function getWeddingRingIndex():String
        {
            return ("16");
        }

        public function stopShine():void
        {
            var _local_1:PersonalInfoCell;
            for each (_local_1 in this._cells)
            {
                (_local_1 as PersonalInfoCell).stopShine();
            };
        }

        private function getCellIndex(_arg_1:EquipmentTemplateInfo):String
        {
            switch (_arg_1.TemplateType)
            {
                case 1:
                    return ("10");
                case 2:
                    return ("11");
                case 3:
                    return ("12");
                case 4:
                    return ("13");
                case 6:
                    return ("15");
                case 5:
                    return ("14");
                case 7:
                    return ("16");
                case 8:
                    return ("17");
                case 9:
                    return ("18");
                case 10:
                    return ("19");
                case 11:
                    return ("20");
                case 13:
                    return ("22");
                case 14:
                    return ("21");
                default:
                    return ("-1");
            };
        }

        public function getCellPos(_arg_1:int):Point
        {
            return (localToGlobal(new Point(this._cellPos[_arg_1].x, this._cellPos[_arg_1].y)));
        }

        public function dispose():void
        {
            this.removeEvent();
            this.clearCells();
            if (this._info.ID == PlayerManager.Instance.Self.ID)
            {
                this.clearLockCells();
            };
            this._cells = null;
            if (parent)
            {
                parent.removeChild(this);
            };
            ObjectUtils.disposeObject(this._bg);
            this._bg = null;
            ObjectUtils.disposeObject(this._cellContent);
            this._cellContent = null;
            this._info = null;
            this._bagInfo = null;
        }


    }
}//package bagAndInfo.info

