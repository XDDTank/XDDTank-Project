// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//militaryrank.view.MilitaryShopItem

package militaryrank.view
{
    import com.pickgliss.ui.core.Component;
    import com.pickgliss.ui.controls.TextButton;
    import com.pickgliss.ui.image.Scale9CornerImage;
    import flash.display.Bitmap;
    import shop.view.ShopItemCell;
    import com.pickgliss.ui.text.FilterFrameText;
    import __AS3__.vec.Vector;
    import flash.display.MovieClip;
    import ddt.data.goods.ShopItemInfo;
    import com.pickgliss.ui.image.ScaleFrameImage;
    import com.pickgliss.ui.image.ScaleBitmapImage;
    import com.pickgliss.ui.controls.alert.BaseAlerFrame;
    import com.pickgliss.ui.ComponentFactory;
    import ddt.manager.LanguageMgr;
    import ddt.utils.PositionUtils;
    import flash.display.Sprite;
    import bagAndInfo.cell.CellFactory;
    import militaryrank.model.MilitaryLevelModel;
    import ddt.data.goods.Price;
    import flash.events.Event;
    import militaryrank.MilitaryRankManager;
    import ddt.manager.PlayerManager;
    import com.pickgliss.utils.StringUtils;
    import ddt.data.EquipType;
    import flash.events.MouseEvent;
    import com.pickgliss.ui.ShowTipManager;
    import ddt.manager.SoundManager;
    import baglocked.BaglockedManager;
    import ddt.manager.SocketManager;
    import ddt.manager.MessageTipManager;
    import com.pickgliss.events.FrameEvent;
    import com.pickgliss.ui.AlertManager;
    import com.pickgliss.ui.LayerManager;
    import com.pickgliss.utils.ObjectUtils;
    import ddt.command.QuickBuyFrame;
    import ddt.events.ItemEvent;
    import flash.filters.ColorMatrixFilter;
    import flash.display.DisplayObject;
    import __AS3__.vec.*;

    public class MilitaryShopItem extends Component 
    {

        public static const PAYTYPE_MEDAL_MONEY:uint = 1;
        public static const PAYTYPE_MONEY:uint = 2;
        private static const LIMIT_LABEL:uint = 6;

        protected var _payPaneBuyBtn:TextButton;
        protected var _itemBg:Scale9CornerImage;
        protected var _itemCellBg:Scale9CornerImage;
        private var _shopItemCellBg:Bitmap;
        protected var _itemCell:ShopItemCell;
        protected var _itemCountTxt:FilterFrameText;
        protected var _itemNameTxt:FilterFrameText;
        protected var _warmTxt:FilterFrameText;
        protected var _priceTxtList:Vector.<FilterFrameText>;
        protected var _payTypeList:Vector.<MovieClip>;
        protected var _selected:Boolean;
        protected var _shopItemInfo:ShopItemInfo;
        protected var _shopItemCellTypeBg:ScaleFrameImage;
        protected var _dotLine:ScaleBitmapImage;
        protected var _buyGoodsFrame:BuyGoodsFrame;
        private var _goldAlertFrame:BaseAlerFrame;

        public function MilitaryShopItem()
        {
            this.initContent();
            this.addEvent();
        }

        protected function initContent():void
        {
            var _local_1:int;
            this._itemBg = ComponentFactory.Instance.creat("militaryrank.shopView.GoodItemBg");
            this._itemCellBg = ComponentFactory.Instance.creatComponentByStylename("militaryrank.shopView.CellBg");
            this._dotLine = ComponentFactory.Instance.creatComponentByStylename("militaryrank.shopView.GoodItemDotLine");
            this._warmTxt = ComponentFactory.Instance.creat("militaryrank.shopView.warmTxt");
            this._payPaneBuyBtn = ComponentFactory.Instance.creatComponentByStylename("militaryrank.shopView.exchangeBtn");
            this._payPaneBuyBtn.text = LanguageMgr.GetTranslation("tank.littlegame.exchange");
            this._priceTxtList = new Vector.<FilterFrameText>(2);
            this._priceTxtList[0] = ComponentFactory.Instance.creat("militaryrank.shopView.exploitTxt");
            this._priceTxtList[1] = ComponentFactory.Instance.creatComponentByStylename("militaryrank.shopView.moneyTxt");
            this._itemNameTxt = ComponentFactory.Instance.creatComponentByStylename("militaryrank.shopView.nameTxt");
            this._itemCountTxt = ComponentFactory.Instance.creatComponentByStylename("ddtshop.GoodItemCount");
            this._itemCell = this.creatItemCell();
            PositionUtils.setPos(this._itemCell, "militaryrank.ShopGoodItemCellPos");
            this._shopItemCellTypeBg = ComponentFactory.Instance.creatComponentByStylename("ddtshop.ShopItemCellTypeBg");
            this._itemCellBg.setFrame(1);
            addChild(this._itemBg);
            addChild(this._itemCellBg);
            addChild(this._dotLine);
            addChild(this._itemCell);
            addChild(this._payPaneBuyBtn);
            addChild(this._warmTxt);
            addChild(this._itemNameTxt);
            addChild(this._priceTxtList[0]);
            addChild(this._priceTxtList[1]);
            addChild(this._itemCountTxt);
            this._payTypeList = new Vector.<MovieClip>(2);
            _local_1 = 0;
            while (_local_1 < 2)
            {
                this._payTypeList[_local_1] = ComponentFactory.Instance.creat(("militaryrank.shopView.moneyIcon" + (_local_1 + 1)));
                this._payTypeList[_local_1].mouseChildren = false;
                this._payTypeList[_local_1].mouseEnabled = false;
                addChild(this._payTypeList[_local_1]);
                _local_1++;
            };
            _width = this._itemBg.width;
            _height = this._itemBg.height;
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
            var _local_2:MilitaryLevelModel;
            var _local_3:int;
            var _local_4:Price;
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
                _local_2 = MilitaryRankManager.Instance.getMilitaryRankInfo(PlayerManager.Instance.Self.MilitaryRankTotalScores);
                if (_local_2.CurrKey < this._shopItemInfo.LimitGrade)
                {
                    this._warmTxt.visible = true;
                    this._warmTxt.text = LanguageMgr.GetTranslation("militaryrank.shopView.item.warmTxt", MilitaryRankManager.Instance.getMilitaryInfoByLevel(this._shopItemInfo.LimitGrade).Name);
                    this._payTypeList[0].visible = false;
                    this._payTypeList[1].visible = false;
                    this._priceTxtList[0].visible = false;
                    this._priceTxtList[1].visible = false;
                    this._payPaneBuyBtn.enable = false;
                }
                else
                {
                    _local_3 = 0;
                    while (_local_3 < 2)
                    {
                        _local_4 = this._shopItemInfo.getItemPrice(0).getPrice(_local_3);
                        this._payTypeList[_local_3].gotoAndStop(-(_local_4.Unit));
                        if (PlayerManager.Instance.Self.getMoneyByType(_local_4.Unit) < _local_4.Value)
                        {
                            this._priceTxtList[_local_3].htmlText = LanguageMgr.GetTranslation("redTxt", _local_4.Value);
                        }
                        else
                        {
                            this._priceTxtList[_local_3].htmlText = String(_local_4.Value);
                        };
                        this._payTypeList[_local_3].visible = (this._priceTxtList[_local_3].visible = (!(_local_4.Value == 0)));
                        _local_3++;
                    };
                    this._payPaneBuyBtn.enable = true;
                    this._warmTxt.visible = false;
                };
                this._itemNameTxt.visible = true;
                this._itemCountTxt.visible = true;
                this._payPaneBuyBtn.visible = true;
                this._itemNameTxt.text = StringUtils.truncate(this._itemCell.info.Name, 9);
                this._itemCell.tipInfo = _arg_1;
                this.initPrice();
                if (EquipType.dressAble(this._shopItemInfo.TemplateInfo))
                {
                    this._shopItemCellTypeBg.setFrame(1);
                }
                else
                {
                    this._shopItemCellTypeBg.setFrame(2);
                };
                this._shopItemInfo.addEventListener(Event.CHANGE, this.__updateShopItem);
            }
            else
            {
                this._itemCellBg.setFrame(1);
                this._payTypeList[0].visible = false;
                this._payTypeList[1].visible = false;
                this._priceTxtList[0].visible = false;
                this._priceTxtList[1].visible = false;
                this._itemNameTxt.visible = false;
                this._itemCountTxt.visible = false;
                this._warmTxt.visible = false;
                this._payPaneBuyBtn.visible = false;
            };
            this.updateCount();
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
                    this._priceTxtList[1].text = String(this._shopItemInfo.getItemPrice(1).moneyValue);
                    return;
                case Price.OFFER:
                    this._priceTxtList[1].text = String(this._shopItemInfo.getItemPrice(1).offValue);
            };
        }

        private function updateCount():void
        {
            if (this._shopItemInfo)
            {
                if (((this._shopItemInfo.Label) && (this._shopItemInfo.Label == LIMIT_LABEL)))
                {
                    if (((this._itemBg) && (this._itemCountTxt)))
                    {
                        this._itemCountTxt.text = String(this._shopItemInfo.LimitCount);
                    };
                }
                else
                {
                    if (((this._itemBg) && (this._itemCountTxt)))
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
        }

        protected function removeEvent():void
        {
            this._payPaneBuyBtn.removeEventListener(MouseEvent.CLICK, this.__payPanelClick);
            MilitaryRankManager.Instance.removeEventListener(MilitaryRankManager.GET_RECORD, this.__getRecord);
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
            if (this._shopItemInfo == null)
            {
                return;
            };
            SoundManager.instance.play("008");
            if (PlayerManager.Instance.Self.bagLocked)
            {
                BaglockedManager.Instance.show();
                return;
            };
            MilitaryRankManager.Instance.addEventListener(MilitaryRankManager.GET_RECORD, this.__getRecord);
            SocketManager.Instance.out.sendAskForRankShopRecord();
        }

        private function __getRecord(_arg_1:Event):void
        {
            MilitaryRankManager.Instance.removeEventListener(MilitaryRankManager.GET_RECORD, this.__getRecord);
            if (((MilitaryRankManager.Instance.getRankShopItemCount(this._shopItemInfo.ID) <= 0) && (MilitaryRankManager.Instance.getRankShopItemCount(this._shopItemInfo.ID) > -1000)))
            {
                MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("militaryrank.shop.noCount"));
                return;
            };
            this._buyGoodsFrame = ComponentFactory.Instance.creatComponentByStylename("militaryrank.view.buyGoodsFrame");
            this._buyGoodsFrame.titleText = LanguageMgr.GetTranslation("tank.view.store.matte.goldQuickBuy");
            this._buyGoodsFrame.shopItem = this._shopItemInfo;
            this._buyGoodsFrame.addEventListener(FrameEvent.RESPONSE, this.__buyGoodsFrameResponse);
            this._buyGoodsFrame.show();
        }

        private function doBuy():Boolean
        {
            var _local_8:Price;
            var _local_1:int;
            while (_local_1 < 2)
            {
                _local_8 = this._shopItemInfo.getItemPrice(0).getPrice(_local_1);
                if (PlayerManager.Instance.Self.getMoneyByType(_local_8.Unit) < (_local_8.Value * this._buyGoodsFrame.goodCount))
                {
                    switch (_local_8.Unit)
                    {
                        case Price.MONEY:
                        case Price.DDT_MONEY:
                            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("noMoney"));
                            break;
                        case Price.GOLD:
                            this.buyGoldFrame();
                            break;
                        case Price.ARMY_EXPLOIT:
                            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("noExploit"));
                            break;
                        case Price.MATCH_MEDAL:
                            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("noMatchMedal"));
                            break;
                    };
                    return (false);
                };
                this._priceTxtList[_local_1].htmlText = String(_local_8.Value);
                this._payTypeList[_local_1].visible = (this._priceTxtList[_local_1].visible = true);
                _local_1++;
            };
            var _local_2:Array = new Array();
            var _local_3:Array = new Array();
            var _local_4:Array = new Array();
            var _local_5:Array = new Array();
            var _local_6:Array = new Array();
            var _local_7:int;
            while (_local_7 < this._buyGoodsFrame.goodCount)
            {
                _local_2.push(this._shopItemInfo.GoodsID);
                _local_3.push(1);
                _local_4.push("");
                _local_5.push("");
                _local_6.push("");
                _local_7++;
            };
            SocketManager.Instance.out.sendBuyGoods(_local_2, _local_3, _local_4, _local_5, _local_6);
            return (true);
        }

        private function buyGoldFrame():void
        {
            if (this._goldAlertFrame == null)
            {
                this._goldAlertFrame = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"), LanguageMgr.GetTranslation("tank.view.GoldInadequate"), LanguageMgr.GetTranslation("ok"), LanguageMgr.GetTranslation("cancel"), false, false, false, LayerManager.BLCAK_BLOCKGOUND);
                this._goldAlertFrame.moveEnable = false;
                this._goldAlertFrame.addEventListener(FrameEvent.RESPONSE, this.__quickBuyResponse);
            };
        }

        private function __quickBuyResponse(_arg_1:FrameEvent):void
        {
            SoundManager.instance.play("008");
            this._goldAlertFrame.removeEventListener(FrameEvent.RESPONSE, this.__quickBuyResponse);
            this._goldAlertFrame.dispose();
            this._goldAlertFrame = null;
            this._buyGoodsFrame.removeEventListener(FrameEvent.RESPONSE, this.__buyGoodsFrameResponse);
            ObjectUtils.disposeObject(this._buyGoodsFrame);
            this._buyGoodsFrame = null;
            if (((_arg_1.responseCode == FrameEvent.SUBMIT_CLICK) || (_arg_1.responseCode == FrameEvent.ENTER_CLICK)))
            {
                this.openGoldFrame();
            };
        }

        private function openGoldFrame():void
        {
            var _local_1:QuickBuyFrame = ComponentFactory.Instance.creatComponentByStylename("ddtcore.QuickFrame");
            _local_1.itemID = EquipType.GOLD_BOX;
            _local_1.setTitleText(LanguageMgr.GetTranslation("tank.view.store.matte.goldQuickBuy"));
            LayerManager.Instance.addToLayer(_local_1, LayerManager.GAME_TOP_LAYER, true, LayerManager.BLCAK_BLOCKGOUND);
        }

        private function __buyGoodsFrameResponse(_arg_1:FrameEvent):void
        {
            SoundManager.instance.play("008");
            if (((_arg_1.responseCode == FrameEvent.ENTER_CLICK) || (_arg_1.responseCode == FrameEvent.SUBMIT_CLICK)))
            {
                if ((!(this.doBuy())))
                {
                    return;
                };
            };
            this._buyGoodsFrame.removeEventListener(FrameEvent.RESPONSE, this.__buyGoodsFrameResponse);
            ObjectUtils.disposeObject(this._buyGoodsFrame);
            this._buyGoodsFrame = null;
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
            this._itemCellBg.setFrame(((this._selected) ? 3 : this.checkType()));
            this._itemNameTxt.setFrame(((_arg_1) ? 2 : 1));
            this._payTypeList[1].setFrame(((_arg_1) ? 2 : 1));
        }

        override public function dispose():void
        {
            super.dispose();
            this.removeEvent();
            if (this._shopItemInfo)
            {
                this._shopItemInfo.removeEventListener(Event.CHANGE, this.__updateShopItem);
            };
            ObjectUtils.disposeAllChildren(this);
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
            ObjectUtils.disposeObject(this._itemCountTxt);
            this._itemCountTxt = null;
            ObjectUtils.disposeObject(this._itemNameTxt);
            this._itemNameTxt = null;
            ObjectUtils.disposeObject(this._warmTxt);
            this._warmTxt = null;
            ObjectUtils.disposeObject(this._payTypeList[0]);
            this._payTypeList[0] = null;
            ObjectUtils.disposeObject(this._payTypeList[1]);
            this._payTypeList[1] = null;
            this._payTypeList.length = 0;
            this._payTypeList = null;
            ObjectUtils.disposeObject(this._priceTxtList[0]);
            this._priceTxtList[0] = null;
            ObjectUtils.disposeObject(this._priceTxtList[1]);
            this._priceTxtList[1] = null;
            this._priceTxtList.length = 0;
            this._priceTxtList = null;
            ObjectUtils.disposeObject(this._shopItemInfo);
            this._shopItemInfo = null;
            ObjectUtils.disposeObject(this._payPaneBuyBtn);
            this._payPaneBuyBtn = null;
        }


    }
}//package militaryrank.view

