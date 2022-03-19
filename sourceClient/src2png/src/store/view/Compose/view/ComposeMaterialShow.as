// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//store.view.Compose.view.ComposeMaterialShow

package store.view.Compose.view
{
    import flash.display.Sprite;
    import com.pickgliss.ui.core.Disposeable;
    import store.view.StoneCellFrame;
    import __AS3__.vec.Vector;
    import flash.geom.Point;
    import com.pickgliss.ui.image.ScaleLeftRightImage;
    import com.pickgliss.ui.controls.TextInput;
    import com.pickgliss.ui.controls.BaseButton;
    import com.pickgliss.ui.text.FilterFrameText;
    import com.pickgliss.ui.image.Image;
    import com.pickgliss.ui.ComponentFactory;
    import ddt.manager.LanguageMgr;
    import ddt.utils.PositionUtils;
    import ddt.data.goods.ItemTemplateInfo;
    import store.view.Compose.ComposeController;
    import store.data.ComposeItemInfo;
    import ddt.manager.ItemManager;
    import store.view.Compose.ComposeEvents;
    import flash.events.MouseEvent;
    import flash.events.Event;
    import ddt.manager.SoundManager;
    import ddt.data.goods.EquipmentTemplateInfo;
    import ddt.manager.PlayerManager;
    import trainer.view.NewHandContainer;
    import trainer.data.ArrowType;
    import bead.BeadManager;
    import ddt.manager.MessageTipManager;
    import ddt.manager.TaskManager;
    import ddt.manager.SavePointManager;
    import com.pickgliss.ui.LayerManager;
    import com.pickgliss.utils.ObjectUtils;
    import __AS3__.vec.*;

    public class ComposeMaterialShow extends Sprite implements Disposeable 
    {

        private static var CELL_COUNT:int = 4;

        private var _count:int;
        private var _items:Array;
        private var _mainCell:ComposeItemCell;
        private var _equipmentCell:StoneCellFrame;
        private var _pointArray:Vector.<Point>;
        private var _mainCellPos:Point;
        private var _composeCountTextBg:ScaleLeftRightImage;
        private var _composeCountText:TextInput;
        private var _reduceBtn:BaseButton;
        private var _addBtn:BaseButton;
        private var _compose_btn:BaseButton;
        private var _neededGoldTipText:FilterFrameText;
        private var _gold_txt:FilterFrameText;
        private var _goldIcon:Image;
        private var _composeCount:int;
        private var _goldNeed:int;

        public function ComposeMaterialShow()
        {
            this.intView();
            this.initEvent();
        }

        private function intView():void
        {
            var _local_2:ComposeMaterialCell;
            this._items = new Array();
            this.getCellsPoint();
            this._equipmentCell = ComponentFactory.Instance.creatCustomObject("ddtstore.StoreIIComposeBG.EquipmentCell");
            this._equipmentCell.label = LanguageMgr.GetTranslation("store.Strength.StrengthenEquipmentCellText");
            addChild(this._equipmentCell);
            this._mainCell = new ComposeItemCell(0);
            this._mainCellPos = ComponentFactory.Instance.creatCustomObject("ddtstore.StoreIIComposeBG.ComposepointMain");
            PositionUtils.setPos(this._mainCell, this._mainCellPos);
            addChild(this._mainCell);
            this._composeCountTextBg = ComponentFactory.Instance.creatComponentByStylename("ddtstore.composeView.composeCountTextBg");
            addChild(this._composeCountTextBg);
            this._composeCountText = ComponentFactory.Instance.creatComponentByStylename("ddtstore.composeView.composeCountText");
            this._composeCountText.text = "1";
            addChild(this._composeCountText);
            this._composeCountText.textField.restrict = "0-9";
            this._reduceBtn = ComponentFactory.Instance.creatComponentByStylename("ddtstore.composeView.reduceBtn");
            this._reduceBtn.enable = false;
            addChild(this._reduceBtn);
            this._addBtn = ComponentFactory.Instance.creatComponentByStylename("ddtstore.composeView.addBtn");
            this._addBtn.enable = false;
            addChild(this._addBtn);
            this._neededGoldTipText = ComponentFactory.Instance.creatComponentByStylename("ddtstore.StoreIIComposeBG.NeededGoldTipText");
            this._neededGoldTipText.text = LanguageMgr.GetTranslation("store.Transfer.NeededGoldTipText");
            addChild(this._neededGoldTipText);
            this._gold_txt = ComponentFactory.Instance.creatComponentByStylename("ddtstore.StoreIIComposeBG.NeedMoneyText");
            addChild(this._gold_txt);
            this._goldIcon = ComponentFactory.Instance.creatComponentByStylename("ddtstore.StoreIITransferBG.GoldIcon");
            addChild(this._goldIcon);
            PositionUtils.setPos(this._neededGoldTipText, "asset.ddtstore.composeMoneyPos1");
            PositionUtils.setPos(this._gold_txt, "asset.ddtstore.composeMoneyPos2");
            PositionUtils.setPos(this._goldIcon, "asset.ddtstore.composeMoneyPos3");
            this._compose_btn = ComponentFactory.Instance.creatComponentByStylename("ddtstore.StoreIIComposeBG.ComposeBtn");
            addChild(this._compose_btn);
            var _local_1:int;
            while (_local_1 < CELL_COUNT)
            {
                _local_2 = new ComposeMaterialCell();
                _local_2.x = this._pointArray[_local_1].x;
                _local_2.y = this._pointArray[_local_1].y;
                addChild(_local_2);
                this._items.push(_local_2);
                _local_1++;
            };
        }

        public function set info(_arg_1:ItemTemplateInfo):void
        {
            this._mainCell.info = _arg_1;
            this.updateData();
            this.composeCount = 1;
        }

        public function get info():ItemTemplateInfo
        {
            return (this._mainCell.info);
        }

        private function getCellsPoint():void
        {
            var _local_2:Point;
            this._pointArray = new Vector.<Point>();
            var _local_1:int;
            while (_local_1 < CELL_COUNT)
            {
                _local_2 = ComponentFactory.Instance.creatCustomObject(("ddtstore.StoreIIComposeBG.Composepoint" + _local_1));
                this._pointArray.push(_local_2);
                _local_1++;
            };
        }

        public function getLargeCount():int
        {
            var _local_2:ComposeMaterialCell;
            var _local_3:int;
            var _local_1:int = this.getEquipComposeMaxCount();
            for each (_local_2 in this._items)
            {
                _local_3 = _local_2.LargestTime;
                if (_local_2.info)
                {
                    if (_local_3 == 0)
                    {
                        return (0);
                    };
                    if (_local_1 > _local_3)
                    {
                        _local_1 = _local_3;
                    };
                };
            };
            return (_local_1);
        }

        private function getEquipComposeMaxCount():int
        {
            return (ComposeController.instance.model.composeItemInfoDic[this.info.TemplateID].MaxCount);
        }

        private function getEnough():int
        {
            var _local_1:ComposeMaterialCell;
            for each (_local_1 in this._items)
            {
                if (!_local_1.enough)
                {
                    if (_local_1.haveCount > _local_1.canUseCount)
                    {
                        return (-1);
                    };
                    return (0);
                };
            };
            return (1);
        }

        public function getBind():Boolean
        {
            var _local_1:ComposeMaterialCell;
            for each (_local_1 in this._items)
            {
                if (((_local_1.info) && (_local_1.isNotBind)))
                {
                    return (true);
                };
            };
            return (false);
        }

        public function updateData():void
        {
            var _local_2:int;
            var _local_1:ComposeItemInfo = new ComposeItemInfo();
            if (this._mainCell.info)
            {
                _local_2 = this._mainCell.info.TemplateID;
                _local_1 = ComposeController.instance.model.composeItemInfoDic[_local_2];
            };
            if (((_local_1) && (_local_1.Material1ID)))
            {
                this._items[0].info = ItemManager.Instance.getTemplateById(_local_1.Material1ID);
                this._items[0].count = _local_1.NeedCount1;
            }
            else
            {
                this._items[0].info = null;
                this._items[0].count = 0;
            };
            if (((_local_1) && (_local_1.Material2ID)))
            {
                this._items[1].info = ItemManager.Instance.getTemplateById(_local_1.Material2ID);
                this._items[1].count = _local_1.NeedCount2;
            }
            else
            {
                this._items[1].info = null;
                this._items[1].count = 0;
            };
            if (((_local_1) && (_local_1.Material3ID)))
            {
                this._items[2].info = ItemManager.Instance.getTemplateById(_local_1.Material3ID);
                this._items[2].count = _local_1.NeedCount3;
            }
            else
            {
                this._items[2].info = null;
                this._items[2].count = 0;
            };
            if (((_local_1) && (_local_1.Material4ID)))
            {
                this._items[3].info = ItemManager.Instance.getTemplateById(_local_1.Material4ID);
                this._items[3].count = _local_1.NeedCount4;
            }
            else
            {
                this._items[3].info = null;
                this._items[3].count = 0;
            };
        }

        public function get composeCount():int
        {
            return (this._composeCount);
        }

        public function set composeCount(_arg_1:int):void
        {
            var _local_2:ComposeMaterialCell;
            var _local_3:ComposeItemInfo;
            if (_arg_1 <= 1)
            {
                _arg_1 = 1;
            };
            this._composeCount = _arg_1;
            this._composeCountText.text = this._composeCount.toString();
            for each (_local_2 in this._items)
            {
                _local_2.setTime(_arg_1);
            };
            if (this.info)
            {
                this._addBtn.enable = (this._composeCount < this.getLargeCount());
                this._reduceBtn.enable = (this._composeCount > 1);
                _local_3 = ComposeController.instance.model.composeItemInfoDic[this.info.TemplateID];
                this._goldNeed = (_local_3.NeedGold * this.composeCount);
                this._gold_txt.text = this._goldNeed.toString();
            }
            else
            {
                this._addBtn.enable = (this._reduceBtn.enable = false);
                this._gold_txt.text = "0";
            };
        }

        private function initEvent():void
        {
            ComposeController.instance.model.addEventListener(ComposeEvents.CLICK_SMALL_ITEM, this.__clickHandle);
            this._compose_btn.addEventListener(MouseEvent.CLICK, this.__sendCompose);
            this._addBtn.addEventListener(MouseEvent.CLICK, this.__addCount);
            this._reduceBtn.addEventListener(MouseEvent.CLICK, this.__reduceCount);
            this._composeCountText.addEventListener(Event.CHANGE, this.__countChange);
        }

        private function __countChange(_arg_1:Event):void
        {
            SoundManager.instance.play("008");
            this.composeCount = int(this._composeCountText.text);
            if (((this.composeCount <= 0) || (!(this.haveItem()))))
            {
                this.composeCount = 1;
                if ((!(this.haveItem())))
                {
                    return;
                };
            };
            var _local_2:int = this.getLargeCount();
            if (_local_2 == 0)
            {
                this.composeCount = 1;
                return;
            };
            if (this.composeCount > _local_2)
            {
                this.composeCount = _local_2;
            };
        }

        private function haveItem():Boolean
        {
            if (this.info)
            {
                return (true);
            };
            return (false);
        }

        private function __sendCompose(_arg_1:MouseEvent):void
        {
            var _local_3:EquipmentTemplateInfo;
            SoundManager.instance.playButtonSound();
            if (PlayerManager.Instance.Self.Gold < this._goldNeed)
            {
                NewHandContainer.Instance.clearArrowByID(ArrowType.STR_WEAPON);
                BeadManager.instance.buyGoldFrame();
                return;
            };
            var _local_2:int = this.getEnough();
            if (_local_2 == 1)
            {
                dispatchEvent(new ComposeEvents(ComposeEvents.START_COMPOSE));
            }
            else
            {
                if (_local_2 == 0)
                {
                    NewHandContainer.Instance.clearArrowByID(ArrowType.STR_WEAPON);
                    _local_3 = ItemManager.Instance.getEquipTemplateById(this.info.TemplateID);
                    if (((_local_3) && (_local_3.TemplateType == 12)))
                    {
                        MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("store.StoreIIComposeBG.noEnoughRune"));
                    }
                    else
                    {
                        MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("store.StoreIIComposeBG.noEnoughMaterial"));
                    };
                }
                else
                {
                    MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("store.StoreIIComposeBG.noEnoughMaterial1"));
                };
            };
        }

        private function __clickHandle(_arg_1:ComposeEvents):void
        {
            this.info = ComposeController.instance.model.currentItem;
            if ((((SavePointManager.Instance.isInSavePoint(26)) && (!(TaskManager.instance.isNewHandTaskCompleted(23)))) && (!(ComposeController.instance.model.composeSuccess))))
            {
                NewHandContainer.Instance.showArrow(ArrowType.STR_WEAPON, 0, "trainer.composeSureArrowPos", "", "", LayerManager.Instance.getLayerByType(LayerManager.GAME_TOP_LAYER));
            };
        }

        private function __addCount(_arg_1:MouseEvent):void
        {
            SoundManager.instance.play("008");
            if (this.haveItem())
            {
                this.composeCount++;
                this.__countChange(null);
            };
        }

        private function __reduceCount(_arg_1:MouseEvent):void
        {
            SoundManager.instance.play("008");
            if (this.haveItem())
            {
                this.composeCount--;
                this.__countChange(null);
            };
        }

        private function removeEvent():void
        {
            ComposeController.instance.model.removeEventListener(ComposeEvents.CLICK_SMALL_ITEM, this.__clickHandle);
            this._compose_btn.removeEventListener(MouseEvent.CLICK, this.__sendCompose);
            this._addBtn.removeEventListener(MouseEvent.CLICK, this.__addCount);
            this._reduceBtn.removeEventListener(MouseEvent.CLICK, this.__reduceCount);
            this._composeCountText.removeEventListener(Event.CHANGE, this.__countChange);
        }

        public function dispose():void
        {
            this.removeEvent();
            while (this._items.length > 0)
            {
                ObjectUtils.disposeObject(this._items.shift());
            };
            this._items = null;
            ObjectUtils.disposeObject(this._mainCell);
            this._mainCell = null;
            ObjectUtils.disposeObject(this._equipmentCell);
            this._equipmentCell = null;
            this._pointArray.length = 0;
            this._pointArray = null;
            this._mainCellPos = null;
            ObjectUtils.disposeObject(this._composeCountTextBg);
            this._composeCountTextBg = null;
            ObjectUtils.disposeObject(this._composeCountText);
            this._composeCountText = null;
            ObjectUtils.disposeObject(this._reduceBtn);
            this._reduceBtn = null;
            ObjectUtils.disposeObject(this._addBtn);
            this._addBtn = null;
            ObjectUtils.disposeObject(this._compose_btn);
            this._compose_btn = null;
            ObjectUtils.disposeObject(this._neededGoldTipText);
            this._neededGoldTipText = null;
            ObjectUtils.disposeObject(this._gold_txt);
            this._gold_txt = null;
            ObjectUtils.disposeObject(this._goldIcon);
            this._goldIcon = null;
            if (parent)
            {
                parent.removeChild(this);
            };
        }


    }
}//package store.view.Compose.view

