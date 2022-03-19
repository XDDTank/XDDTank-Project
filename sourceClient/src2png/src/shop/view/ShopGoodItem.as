// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//shop.view.ShopGoodItem

package shop.view
{
    import flash.display.Sprite;
    import com.pickgliss.ui.controls.ISelectable;
    import com.pickgliss.ui.core.Disposeable;
    import com.pickgliss.ui.controls.TextButton;
    import com.pickgliss.ui.image.ScaleFrameImage;
    import com.pickgliss.ui.image.Image;
    import flash.display.Bitmap;
    import com.pickgliss.ui.text.FilterFrameText;
    import ddt.data.goods.ShopItemInfo;
    import com.greensock.TimelineMax;
    import flash.display.MovieClip;
    import com.pickgliss.ui.ComponentFactory;
    import ddt.manager.LanguageMgr;
    import ddt.manager.SavePointManager;
    import ddt.utils.PositionUtils;
    import com.greensock.events.TweenEvent;
    import com.greensock.TweenLite;
    import com.greensock.TweenMax;
    import bagAndInfo.cell.CellFactory;
    import flash.events.Event;
    import ddt.data.EquipType;
    import ddt.manager.PlayerManager;
    import ddt.data.goods.Price;
    import flash.events.MouseEvent;
    import com.pickgliss.ui.ShowTipManager;
    import ddt.manager.MessageTipManager;
    import ddt.manager.SoundManager;
    import shop.manager.ShopGiftsManager;
    import shop.manager.ShopBuyManager;
    import ddt.events.ItemEvent;
    import baglocked.BaglockedManager;
    import com.pickgliss.ui.AlertManager;
    import com.pickgliss.ui.controls.alert.BaseAlerFrame;
    import com.pickgliss.events.FrameEvent;
    import ddt.manager.SocketManager;
    import com.pickgliss.utils.ObjectUtils;
    import flash.filters.ColorMatrixFilter;
    import flash.display.DisplayObject;

    public class ShopGoodItem extends Sprite implements ISelectable, Disposeable 
    {

        public static const PAYTYPE_MONEY:uint = 2;
        private static const LIMIT_LABEL:uint = 6;

        protected var _payPaneGivingBtn:TextButton;
        protected var _payPaneBuyBtn:TextButton;
        protected var _itemBg:ScaleFrameImage;
        protected var _itemCellBg:Image;
        private var _shopItemCellBg:Bitmap;
        protected var _itemCell:ShopItemCell;
        protected var _itemCellBtn:Sprite;
        protected var _itemCountTxt:FilterFrameText;
        protected var _itemNameTxt:FilterFrameText;
        protected var _itemPriceTxt:FilterFrameText;
        protected var _labelIcon:ScaleFrameImage;
        protected var _payType:ScaleFrameImage;
        protected var _selected:Boolean;
        protected var _shopItemInfo:ShopItemInfo;
        protected var _shopItemCellTypeBg:ScaleFrameImage;
        private var _payPaneBuyBtnHotArea:Sprite;
        protected var _dotLine:Image;
        protected var _timeline:TimelineMax;
        protected var _isMouseOver:Boolean;
        protected var _lightMc:MovieClip;

        public function ShopGoodItem()
        {
            this.initContent();
            this.addEvent();
        }

        public function get payPaneGivingBtn():TextButton
        {
            return (this._payPaneGivingBtn);
        }

        public function get payPaneBuyBtn():TextButton
        {
            return (this._payPaneBuyBtn);
        }

        public function get itemBg():ScaleFrameImage
        {
            return (this._itemBg);
        }

        public function get itemCell():ShopItemCell
        {
            return (this._itemCell);
        }

        public function get itemCellBtn():Sprite
        {
            return (this._itemCellBtn);
        }

        public function get dotLine():Image
        {
            return (this._dotLine);
        }

        protected function initContent():void
        {
            this._itemBg = ComponentFactory.Instance.creatComponentByStylename("ddtshop.GoodItemBg");
            this._itemCellBg = ComponentFactory.Instance.creatComponentByStylename("ddtshop.GoodItemCellBg");
            this._dotLine = ComponentFactory.Instance.creatComponentByStylename("ddtshop.GoodItemDotLine");
            this._payType = ComponentFactory.Instance.creatComponentByStylename("ddtshop.GoodPayTypeLabel");
            this._payType.mouseChildren = false;
            this._payType.mouseEnabled = false;
            this._payPaneGivingBtn = ComponentFactory.Instance.creatComponentByStylename("ddtshop.PayPaneGivingBtn");
            this._payPaneGivingBtn.text = LanguageMgr.GetTranslation("shop.view.present");
            this._payPaneBuyBtn = ComponentFactory.Instance.creatComponentByStylename("ddtshop.PayPaneBuyBtn");
            this._payPaneBuyBtn.text = LanguageMgr.GetTranslation("store.Strength.BuyButtonText");
            if ((!(SavePointManager.Instance.savePoints[15])))
            {
                this._payPaneGivingBtn.mouseEnabled = false;
                this.applyGray(this._payPaneGivingBtn);
            };
            this._payPaneBuyBtnHotArea = new Sprite();
            this._payPaneBuyBtnHotArea.graphics.beginFill(0, 0);
            this._payPaneBuyBtnHotArea.graphics.drawRect(0, 0, this._payPaneBuyBtn.width, this._payPaneBuyBtn.height);
            PositionUtils.setPos(this._payPaneBuyBtnHotArea, this._payPaneBuyBtn);
            this._itemNameTxt = ComponentFactory.Instance.creatComponentByStylename("ddtshop.GoodItemName");
            this._itemPriceTxt = ComponentFactory.Instance.creatComponentByStylename("ddtshop.GoodItemPrice");
            this._itemCountTxt = ComponentFactory.Instance.creatComponentByStylename("ddtshop.GoodItemCount");
            this._itemCell = this.creatItemCell();
            PositionUtils.setPos(this._itemCell, "ddtshop.ShopGoodItemCellPos");
            this._labelIcon = ComponentFactory.Instance.creatComponentByStylename("ddtshop.GoodLabelIcon");
            this._labelIcon.mouseChildren = false;
            this._labelIcon.mouseEnabled = false;
            this._shopItemCellTypeBg = ComponentFactory.Instance.creatComponentByStylename("ddtshop.ShopItemCellTypeBg");
            this._itemCellBtn = new Sprite();
            this._itemCellBtn.buttonMode = true;
            this._itemCellBtn.addChild(this._itemCell);
            this._itemCellBtn.addChild(this._shopItemCellTypeBg);
            this._itemBg.setFrame(1);
            this._itemCellBg.setFrame(1);
            this._labelIcon.setFrame(1);
            this._payType.setFrame(1);
            addChild(this._itemBg);
            addChild(this._itemCellBg);
            addChild(this._dotLine);
            addChild(this._payPaneGivingBtn);
            addChild(this._payPaneBuyBtn);
            addChild(this._payPaneBuyBtnHotArea);
            addChild(this._payType);
            addChild(this._itemCellBtn);
            addChild(this._labelIcon);
            addChild(this._itemNameTxt);
            addChild(this._itemPriceTxt);
            addChild(this._itemCountTxt);
            this._timeline = new TimelineMax();
            this._timeline.addEventListener(TweenEvent.COMPLETE, this.__timelineComplete);
            var _local_1:TweenLite = TweenLite.to(this._labelIcon, 0.25, {
                "alpha":0,
                "y":"-30"
            });
            this._timeline.append(_local_1);
            var _local_2:TweenLite = TweenLite.to(this._itemCountTxt, 0.25, {
                "alpha":0,
                "y":"-30"
            });
            this._timeline.append(_local_2, -0.25);
            var _local_3:TweenMax = TweenMax.from(this._shopItemCellTypeBg, 0.1, {
                "autoAlpha":0,
                "y":"5"
            });
            this._timeline.append(_local_3, -0.2);
            this._timeline.stop();
        }

        protected function creatItemCell():ShopItemCell
        {
            var _local_1:Sprite = new Sprite();
            _local_1.graphics.beginFill(0xFFFFFF, 0);
            _local_1.graphics.drawRect(0, 0, 75, 75);
            _local_1.graphics.endFill();
            return (CellFactory.instance.createShopItemCell(_local_1, null, true, true) as ShopItemCell);
        }

        public function get shopItemInfo():ShopItemInfo
        {
            return (this._shopItemInfo);
        }

        public function set shopItemInfo(_arg_1:ShopItemInfo):void
        {
            if (this._shopItemInfo)
            {
                this._shopItemInfo.removeEventListener(Event.CHANGE, this.__updateShopItem);
            };
            if (_arg_1 == null)
            {
                this._shopItemInfo = null;
                this._itemCell.info = null;
            }
            else
            {
                this._shopItemInfo = _arg_1;
                this._itemCell.info = _arg_1.TemplateInfo;
                this._itemCell.tipInfo = _arg_1;
            };
            if (this._itemCell.info != null)
            {
                this._itemCell.visible = true;
                this._itemCellBtn.visible = true;
                this._itemCellBtn.buttonMode = true;
                this._payType.visible = true;
                this._itemPriceTxt.visible = true;
                this._itemNameTxt.visible = true;
                this._itemCountTxt.visible = true;
                this._payPaneGivingBtn.visible = true;
                this._payPaneBuyBtn.visible = true;
                this._itemNameTxt.text = String(this._itemCell.info.Name);
                this._itemCell.tipInfo = _arg_1;
                this.initPrice();
                if (this._shopItemInfo.ShopID == 1)
                {
                    this._itemBg.setFrame(1);
                    this._itemCellBg.setFrame(1);
                }
                else
                {
                    this._itemBg.setFrame(2);
                    this._itemCellBg.setFrame(2);
                };
                if (EquipType.dressAble(this._shopItemInfo.TemplateInfo))
                {
                    this._shopItemCellTypeBg.setFrame(1);
                }
                else
                {
                    this._shopItemCellTypeBg.setFrame(2);
                };
                this._labelIcon.visible = ((this._shopItemInfo.Label == 0) ? false : true);
                this._labelIcon.setFrame(this._shopItemInfo.Label);
                this._shopItemInfo.addEventListener(Event.CHANGE, this.__updateShopItem);
            }
            else
            {
                this._itemBg.setFrame(1);
                this._itemCellBg.setFrame(1);
                this._itemCellBtn.visible = false;
                this._labelIcon.visible = false;
                this._payType.visible = false;
                this._itemPriceTxt.visible = false;
                this._itemNameTxt.visible = false;
                this._itemCountTxt.visible = false;
                this._payPaneGivingBtn.visible = false;
                this._payPaneBuyBtn.visible = false;
            };
            this.updateCount();
            this.updateBtn();
        }

        private function updateBtn():void
        {
            if ((!(this._shopItemInfo)))
            {
                return;
            };
            if (PlayerManager.Instance.Self.Grade < this._shopItemInfo.LimitGrade)
            {
                this._payPaneBuyBtn.enable = false;
                this._payPaneBuyBtnHotArea.mouseEnabled = true;
            }
            else
            {
                this._payPaneBuyBtn.enable = true;
                this._payPaneBuyBtnHotArea.mouseEnabled = false;
            };
        }

        private function __updateShopItem(_arg_1:Event):void
        {
            this.updateCount();
        }

        private function checkType():int
        {
            if (this._shopItemInfo)
            {
                return ((this._shopItemInfo.ShopID == 1) ? 1 : 2);
            };
            return (1);
        }

        private function initPrice():void
        {
            switch (this._shopItemInfo.getItemPrice(1).PriceType)
            {
                case Price.MONEY:
                    this._payType.setFrame(PAYTYPE_MONEY);
                    this._itemPriceTxt.text = String(this._shopItemInfo.getItemPrice(1).moneyValue);
                    return;
                case Price.OFFER:
                    this._itemPriceTxt.text = String(this._shopItemInfo.getItemPrice(1).offValue);
                    this._payPaneGivingBtn.visible = false;
            };
        }

        private function updateCount():void
        {
            if (this._shopItemInfo)
            {
                if (((this._shopItemInfo.Label) && (this._shopItemInfo.Label == LIMIT_LABEL)))
                {
                    if ((((this._itemBg) && (this._labelIcon)) && (this._itemCountTxt)))
                    {
                        this._itemCountTxt.text = String(this._shopItemInfo.LimitCount);
                    };
                }
                else
                {
                    if ((((this._itemBg) && (this._labelIcon)) && (this._itemCountTxt)))
                    {
                        this._itemCountTxt.visible = false;
                        this._itemCountTxt.text = "0";
                    };
                };
            };
        }

        protected function addEvent():void
        {
            this._payPaneBuyBtn.addEventListener(MouseEvent.CLICK, this.__payPanelClick);
            this._payPaneBuyBtnHotArea.addEventListener(MouseEvent.MOUSE_OVER, this.__payPaneBuyBtnOver);
            this._payPaneBuyBtnHotArea.addEventListener(MouseEvent.MOUSE_OUT, this.__payPaneBuyBtnOut);
            this._payPaneGivingBtn.addEventListener(MouseEvent.CLICK, this.__payPanelClick);
            this._itemCellBtn.addEventListener(MouseEvent.CLICK, this.__itemClick);
            this._itemCellBtn.addEventListener(MouseEvent.MOUSE_OVER, this.__itemMouseOver);
            this._itemCellBtn.addEventListener(MouseEvent.MOUSE_OUT, this.__itemMouseOut);
            this._itemBg.addEventListener(MouseEvent.MOUSE_OVER, this.__itemMouseOver);
            this._itemBg.addEventListener(MouseEvent.MOUSE_OUT, this.__itemMouseOut);
        }

        protected function removeEvent():void
        {
            this._payPaneBuyBtn.removeEventListener(MouseEvent.CLICK, this.__payPanelClick);
            this._payPaneBuyBtnHotArea.removeEventListener(MouseEvent.MOUSE_OVER, this.__payPaneBuyBtnOver);
            this._payPaneBuyBtnHotArea.removeEventListener(MouseEvent.MOUSE_OUT, this.__payPaneBuyBtnOut);
            this._payPaneGivingBtn.removeEventListener(MouseEvent.CLICK, this.__payPanelClick);
            this._itemCellBtn.removeEventListener(MouseEvent.CLICK, this.__itemClick);
            this._itemCellBtn.removeEventListener(MouseEvent.MOUSE_OVER, this.__itemMouseOver);
            this._itemCellBtn.removeEventListener(MouseEvent.MOUSE_OUT, this.__itemMouseOut);
            this._itemBg.removeEventListener(MouseEvent.MOUSE_OVER, this.__itemMouseOver);
            this._itemBg.removeEventListener(MouseEvent.MOUSE_OUT, this.__itemMouseOut);
        }

        protected function __payPaneBuyBtnOver(_arg_1:MouseEvent):void
        {
            if (((this._shopItemInfo) && (this._shopItemInfo.LimitGrade > PlayerManager.Instance.Self.Grade)))
            {
                this._payPaneBuyBtn.tipStyle = "ddt.view.tips.OneLineTip";
                this._payPaneBuyBtn.tipData = LanguageMgr.GetTranslation("ddt.shop.LimitGradeBuy", this._shopItemInfo.LimitGrade);
                this._payPaneBuyBtn.tipDirctions = "3,7,6";
                ShowTipManager.Instance.showTip(this._payPaneBuyBtn);
            };
        }

        protected function __payPaneBuyBtnOut(_arg_1:MouseEvent):void
        {
            ShowTipManager.Instance.removeTip(this._payPaneBuyBtn);
        }

        protected function __payPanelClick(_arg_1:MouseEvent):void
        {
            _arg_1.stopImmediatePropagation();
            if (((this._shopItemInfo) && (this._shopItemInfo.LimitCount == 0)))
            {
                MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("shop.ShopIIModel.countOver"));
                return;
            };
            if (this._shopItemInfo != null)
            {
                SoundManager.instance.play("008");
                if (_arg_1.currentTarget == this._payPaneGivingBtn)
                {
                    ShopGiftsManager.Instance.buy(this._shopItemInfo.GoodsID, (this._shopItemInfo.isDiscount == 2));
                }
                else
                {
                    ShopBuyManager.Instance.buy(this._shopItemInfo.GoodsID, this._shopItemInfo.isDiscount);
                };
            };
            dispatchEvent(new ItemEvent(ItemEvent.ITEM_SELECT, this._shopItemInfo, 0));
        }

        protected function __payPaneGetBtnClick(_arg_1:MouseEvent):void
        {
            SoundManager.instance.play("008");
            if (PlayerManager.Instance.Self.bagLocked)
            {
                BaglockedManager.Instance.show();
                return;
            };
            var _local_2:BaseAlerFrame = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("shop.view.ShopRightView.getSimpleAlert.title"), LanguageMgr.GetTranslation("shop.view.ShopRightView.getSimpleAlert.msg"), "", LanguageMgr.GetTranslation("cancel"), true, false, false, 2);
            _local_2.addEventListener(FrameEvent.RESPONSE, this.__onResponse);
            dispatchEvent(new ItemEvent(ItemEvent.ITEM_SELECT, this._shopItemInfo, 0));
        }

        private function __onResponse(_arg_1:FrameEvent):void
        {
            var _local_3:Array;
            var _local_4:Array;
            var _local_5:Array;
            var _local_6:Array;
            var _local_7:Array;
            var _local_8:int;
            SoundManager.instance.play("008");
            var _local_2:BaseAlerFrame = (_arg_1.target as BaseAlerFrame);
            _local_2.removeEventListener(FrameEvent.RESPONSE, this.__onResponse);
            _local_2.dispose();
            if (((_arg_1.responseCode == FrameEvent.ENTER_CLICK) || (_arg_1.responseCode == FrameEvent.SUBMIT_CLICK)))
            {
                _local_3 = new Array();
                _local_4 = new Array();
                _local_5 = new Array();
                _local_6 = new Array();
                _local_7 = new Array();
                _local_8 = 0;
                while (_local_8 < 1)
                {
                    _local_3.push(this._shopItemInfo.GoodsID);
                    _local_4.push(1);
                    _local_5.push("");
                    _local_6.push("");
                    _local_7.push("");
                    _local_8++;
                };
                SocketManager.Instance.out.sendBuyGoods(_local_3, _local_4, _local_5, _local_7, _local_6);
            };
        }

        protected function __itemClick(_arg_1:MouseEvent):void
        {
            if ((!(this._shopItemInfo)))
            {
                return;
            };
            if (PlayerManager.Instance.Self.Grade < this._shopItemInfo.LimitGrade)
            {
                return;
            };
            SoundManager.instance.play("008");
            if (this._shopItemInfo.LimitCount == 0)
            {
                MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("shop.ShopIIModel.countOver"));
                return;
            };
            dispatchEvent(new ItemEvent(ItemEvent.ITEM_CLICK, this._shopItemInfo, 1));
        }

        protected function __itemMouseOver(_arg_1:MouseEvent):void
        {
            if ((!(this._itemCell.info)))
            {
                return;
            };
            if (this._lightMc)
            {
                addChild(this._lightMc);
            };
            parent.addChild(this);
            this._isMouseOver = true;
            this._timeline.play();
        }

        protected function __itemMouseOut(_arg_1:MouseEvent):void
        {
            ObjectUtils.disposeObject(this._lightMc);
            if ((!(this._shopItemInfo)))
            {
                return;
            };
            this._isMouseOver = false;
            this.__timelineComplete();
        }

        public function setItemLight(_arg_1:MovieClip):void
        {
            if (this._lightMc == _arg_1)
            {
                return;
            };
            this._lightMc = _arg_1;
            this._lightMc.mouseChildren = false;
            this._lightMc.mouseEnabled = false;
            this._lightMc.gotoAndPlay(1);
        }

        protected function __timelineComplete(_arg_1:TweenEvent=null):void
        {
            if (this._timeline.currentTime < this._timeline.totalDuration)
            {
                return;
            };
            if (this._isMouseOver)
            {
                return;
            };
            this._timeline.reverse();
        }

        public function ableButton():void
        {
            this._payPaneGivingBtn.enable = true;
            this._payPaneBuyBtn.enable = true;
        }

        public function enableButton():void
        {
            this._payPaneGivingBtn.enable = false;
            this._payPaneBuyBtn.enable = false;
        }

        public function givingDisable():void
        {
            this._payPaneGivingBtn.enable = false;
        }

        private function applyGray(_arg_1:DisplayObject):void
        {
            var _local_2:Array = new Array();
            _local_2 = _local_2.concat([0.3086, 0.6094, 0.082, 0, 0]);
            _local_2 = _local_2.concat([0.3086, 0.6094, 0.082, 0, 0]);
            _local_2 = _local_2.concat([0.3086, 0.6094, 0.082, 0, 0]);
            _local_2 = _local_2.concat([0, 0, 0, 1, 0]);
            var _local_3:ColorMatrixFilter = new ColorMatrixFilter(_local_2);
            var _local_4:Array = new Array();
            _local_4.push(_local_3);
            _arg_1.filters = _local_4;
        }

        public function asDisplayObject():DisplayObject
        {
            return (this);
        }

        public function set autoSelect(_arg_1:Boolean):void
        {
        }

        public function get selected():Boolean
        {
            return (this._selected);
        }

        public function set selected(_arg_1:Boolean):void
        {
            if (this._selected == _arg_1)
            {
                return;
            };
            this._selected = _arg_1;
            this._itemBg.setFrame(((this._selected) ? 3 : this.checkType()));
            this._itemCellBg.setFrame(((this._selected) ? 3 : this.checkType()));
            this._itemNameTxt.setFrame(((_arg_1) ? 2 : 1));
            this._itemPriceTxt.setFrame(((_arg_1) ? 2 : 1));
        }

        public function dispose():void
        {
            this.removeEvent();
            if (this._shopItemInfo)
            {
                this._shopItemInfo.removeEventListener(Event.CHANGE, this.__updateShopItem);
            };
            ObjectUtils.disposeAllChildren(this);
            this._timeline.removeEventListener(TweenEvent.COMPLETE, this.__timelineComplete);
            this._timeline = null;
            ObjectUtils.disposeObject(this._lightMc);
            this._lightMc = null;
            ObjectUtils.disposeObject(this._itemBg);
            this._itemBg = null;
            ObjectUtils.disposeObject(this._itemCellBg);
            this._itemCellBg = null;
            ObjectUtils.disposeObject(this._shopItemCellBg);
            this._shopItemCellBg = null;
            ObjectUtils.disposeObject(this._dotLine);
            this._dotLine = null;
            ObjectUtils.disposeObject(this._itemCell);
            this._itemCell = null;
            ObjectUtils.disposeObject(this._shopItemCellTypeBg);
            this._shopItemCellTypeBg = null;
            ObjectUtils.disposeObject(this._payPaneBuyBtnHotArea);
            this._payPaneBuyBtnHotArea = null;
            ObjectUtils.disposeObject(this._itemCountTxt);
            this._itemCountTxt = null;
            ObjectUtils.disposeObject(this._itemNameTxt);
            this._itemNameTxt = null;
            ObjectUtils.disposeObject(this._itemPriceTxt);
            this._itemPriceTxt = null;
            ObjectUtils.disposeObject(this._labelIcon);
            this._labelIcon = null;
            ObjectUtils.disposeObject(this._payType);
            this._payType = null;
            ObjectUtils.disposeObject(this._itemCellBtn);
            this._itemCellBtn = null;
            ObjectUtils.disposeObject(this._shopItemInfo);
            this._shopItemInfo = null;
            ObjectUtils.disposeObject(this._payPaneGivingBtn);
            this._payPaneGivingBtn = null;
            ObjectUtils.disposeObject(this._payPaneBuyBtnHotArea);
            this._payPaneBuyBtn = null;
        }


    }
}//package shop.view

