// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//ddt.view.common.BuyItemButton

package ddt.view.common
{
    import com.pickgliss.ui.controls.TextButton;
    import ddt.data.goods.ItemTemplateInfo;
    import ddt.data.goods.ShopItemInfo;
    import ddt.manager.ItemManager;
    import ddt.manager.ShopManager;
    import ddt.view.tips.GoodTipInfo;
    import ddt.command.QuickBuyFrame;
    import com.pickgliss.ui.ComponentSetting;
    import ddt.manager.SoundManager;
    import ddt.manager.PlayerManager;
    import baglocked.BaglockedManager;
    import ddt.manager.LeavePageManager;
    import com.pickgliss.ui.ComponentFactory;
    import ddt.manager.LanguageMgr;
    import ddt.events.ShortcutBuyEvent;
    import flash.events.Event;
    import com.pickgliss.ui.LayerManager;
    import flash.events.MouseEvent;
    import ddt.bagStore.BagStore;

    public class BuyItemButton extends TextButton 
    {

        protected var _itemInfo:ItemTemplateInfo;
        protected var _shopItemInfo:ShopItemInfo;
        private var _needDispatchEvent:Boolean;
        private var _storeTab:int;
        private var _itemID:int;


        public function setup(_arg_1:int, _arg_2:int, _arg_3:Boolean=false):void
        {
            this._itemID = _arg_1;
            this._storeTab = _arg_2;
            this._needDispatchEvent = _arg_3;
            this.initliziItemTemplate();
        }

        protected function initliziItemTemplate():void
        {
            this._itemInfo = ItemManager.Instance.getTemplateById(this._itemID);
            this._shopItemInfo = ShopManager.Instance.getMoneyShopItemByTemplateID(this._itemID);
            var _local_1:GoodTipInfo = new GoodTipInfo();
            _local_1.itemInfo = this._itemInfo;
            _local_1.isBalanceTip = false;
            _local_1.typeIsSecond = false;
            tipData = _local_1;
        }

        override protected function __onMouseClick(_arg_1:MouseEvent):void
        {
            var _local_2:QuickBuyFrame;
            if (_enable)
            {
                _arg_1.stopImmediatePropagation();
                if (((!(useLogID == 0)) && (!(ComponentSetting.SEND_USELOG_ID == null))))
                {
                    ComponentSetting.SEND_USELOG_ID(useLogID);
                };
                SoundManager.instance.play("008");
                if (PlayerManager.Instance.Self.bagLocked)
                {
                    BaglockedManager.Instance.show();
                    return;
                };
                if (PlayerManager.Instance.Self.totalMoney < this._shopItemInfo.getItemPrice(1).moneyValue)
                {
                    LeavePageManager.showFillFrame();
                }
                else
                {
                    _local_2 = ComponentFactory.Instance.creatComponentByStylename("ddtcore.QuickFrame");
                    _local_2.setTitleText(LanguageMgr.GetTranslation("tank.view.store.matte.goldQuickBuy"));
                    _local_2.itemID = this._itemID;
                    _local_2.buyFrom = this._storeTab;
                    _local_2.addEventListener(ShortcutBuyEvent.SHORTCUT_BUY, this.__shortCutBuyHandler);
                    _local_2.addEventListener(Event.REMOVED_FROM_STAGE, this.removeFromStageHandler);
                    LayerManager.Instance.addToLayer(_local_2, LayerManager.GAME_TOP_LAYER, true, LayerManager.BLCAK_BLOCKGOUND);
                };
            };
        }

        private function removeFromStageHandler(_arg_1:Event):void
        {
            BagStore.instance.reduceTipPanelNumber();
        }

        private function __shortCutBuyHandler(_arg_1:ShortcutBuyEvent):void
        {
            _arg_1.stopImmediatePropagation();
            if (this._needDispatchEvent)
            {
                dispatchEvent(new ShortcutBuyEvent(_arg_1.ItemID, _arg_1.ItemNum));
            };
        }

        override public function dispose():void
        {
            super.dispose();
            this._itemInfo = null;
            this._shopItemInfo = null;
            if (parent)
            {
                parent.removeChild(this);
            };
        }


    }
}//package ddt.view.common

