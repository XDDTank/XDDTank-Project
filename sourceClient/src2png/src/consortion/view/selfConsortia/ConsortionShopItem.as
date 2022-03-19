// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//consortion.view.selfConsortia.ConsortionShopItem

package consortion.view.selfConsortia
{
    import shop.view.ShopGoodItem;
    import ddt.data.goods.ShopItemInfo;
    import com.pickgliss.ui.text.FilterFrameText;
    import com.pickgliss.ui.ComponentFactory;
    import flash.events.MouseEvent;
    import ddt.manager.SoundManager;
    import ddt.manager.PlayerManager;
    import baglocked.BaglockedManager;
    import ddt.manager.MessageTipManager;
    import ddt.manager.LanguageMgr;
    import consortion.consortionsence.ConsortionManager;
    import ddt.manager.SocketManager;
    import com.pickgliss.utils.ObjectUtils;

    public class ConsortionShopItem extends ShopGoodItem 
    {

        private var _enable:Boolean;
        private var _info:ShopItemInfo;
        private var _time:int;
        private var _needOffer:FilterFrameText;
        private var _needLevelTxt:FilterFrameText;


        override protected function initContent():void
        {
            super.initContent();
            this._needOffer = ComponentFactory.Instance.creatComponentByStylename("ConsorionshopItem.NeedOfferTxt");
            this._needOffer.text = "贡献度";
            addChild(this._needOffer);
            this._needLevelTxt = ComponentFactory.Instance.creatComponentByStylename("Consorionshop.NeedLevelTxt");
            addChild(this._needLevelTxt);
            this._needLevelTxt.visible = false;
            _dotLine.visible = false;
            _payPaneGivingBtn.visible = false;
            _shopItemCellTypeBg.visible = false;
            _payType.visible = false;
        }

        override protected function addEvent():void
        {
            super.addEvent();
            _payPaneBuyBtn.addEventListener(MouseEvent.CLICK, this.__payPanelClick);
        }

        override protected function __payPanelClick(_arg_1:MouseEvent):void
        {
            SoundManager.instance.play("008");
            if (PlayerManager.Instance.Self.bagLocked)
            {
                BaglockedManager.Instance.show();
                return;
            };
            if (((this._info) && (this.cheackMoney())))
            {
                this.sendConsortiaShop();
            };
        }

        private function cheackMoney():Boolean
        {
            if (PlayerManager.Instance.Self.RichesOffer < this._info.getItemPrice(this._time).offValue)
            {
                MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ConsortiaShopItem.gongxianbuzu"));
                return (false);
            };
            return (true);
        }

        override protected function __itemMouseOver(_arg_1:MouseEvent):void
        {
        }

        override protected function __itemMouseOut(_arg_1:MouseEvent):void
        {
        }

        override public function set shopItemInfo(_arg_1:ShopItemInfo):void
        {
            super.shopItemInfo = _arg_1;
            this._info = _arg_1;
            _payPaneGivingBtn.visible = false;
            _payType.visible = false;
            _shopItemCellTypeBg.visible = false;
            if (this._info == null)
            {
                this._needOffer.visible = false;
                this._needLevelTxt.visible = false;
                _dotLine.visible = false;
                _itemBg.filters = null;
                _itemCell.filters = null;
                _itemCellBg.filters = null;
                _itemNameTxt.filters = null;
                return;
            };
            this._needOffer.visible = true;
            _dotLine.visible = true;
            this._needLevelTxt.visible = true;
            if (this._info.LimitGrade > PlayerManager.Instance.Self.consortiaInfo.ShopLevel)
            {
                this.setfilter(false);
                _itemPriceTxt.visible = false;
                _payPaneBuyBtn.enable = false;
                this._needLevelTxt.text = LanguageMgr.GetTranslation("ddt.consortionShop.NeedLevelTxt", this._info.LimitGrade);
                this._needLevelTxt.visible = true;
                this._needOffer.visible = false;
                this._needLevelTxt.filters = null;
            }
            else
            {
                this.setfilter(true);
                this._needLevelTxt.visible = false;
                this._needOffer.visible = true;
                _payPaneBuyBtn.enable = true;
                _itemPriceTxt.visible = true;
            };
            if (ConsortionManager.Instance.buyType != 10)
            {
                if (this._info.isBuy)
                {
                    _payPaneBuyBtn.enable = false;
                }
                else
                {
                    _payPaneBuyBtn.enable = true;
                };
            };
        }

        private function setfilter(_arg_1:Boolean):void
        {
            if (_arg_1)
            {
                _itemBg.filters = null;
                _itemCell.filters = null;
                _itemCellBg.filters = null;
                _itemNameTxt.filters = null;
            }
            else
            {
                _itemBg.filters = ComponentFactory.Instance.creatFilters("grayFilter");
                _itemCellBg.filters = ComponentFactory.Instance.creatFilters("grayFilter");
                _itemNameTxt.filters = ComponentFactory.Instance.creatFilters("grayFilter");
            };
        }

        private function sendConsortiaShop():void
        {
            var _local_1:Array = [this._info.ID];
            var _local_2:Array = [1];
            var _local_3:Array = [""];
            var _local_4:Array = [false];
            var _local_5:Array = [""];
            var _local_6:Array = [-1];
            SocketManager.Instance.out.sendBuyGoods(_local_1, _local_2, _local_3, _local_6, _local_4, _local_5);
            if (ConsortionManager.Instance.buyType == 10)
            {
                _payPaneBuyBtn.enable = true;
            }
            else
            {
                _payPaneBuyBtn.enable = false;
                this._info.isBuy = true;
            };
        }

        override public function dispose():void
        {
            if (this._needOffer)
            {
                ObjectUtils.disposeObject(this._needOffer);
            };
            this._needOffer = null;
            super.dispose();
        }


    }
}//package consortion.view.selfConsortia

