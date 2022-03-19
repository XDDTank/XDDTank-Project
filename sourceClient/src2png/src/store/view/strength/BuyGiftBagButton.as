// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//store.view.strength.BuyGiftBagButton

package store.view.strength
{
    import ddt.view.common.BuyItemButton;
    import ddt.data.goods.ItemTemplateInfo;
    import ddt.manager.LanguageMgr;
    import ddt.view.tips.GoodTipInfo;
    import com.pickgliss.ui.controls.alert.BaseAlerFrame;
    import ddt.manager.SoundManager;
    import ddt.manager.PlayerManager;
    import baglocked.BaglockedManager;
    import ddt.manager.LeavePageManager;
    import com.pickgliss.ui.AlertManager;
    import com.pickgliss.ui.LayerManager;
    import com.pickgliss.events.FrameEvent;
    import flash.events.MouseEvent;
    import com.pickgliss.utils.ObjectUtils;
    import ddt.manager.SocketManager;
    import ddt.data.EquipType;
    import ddt.events.ShortcutBuyEvent;

    public class BuyGiftBagButton extends BuyItemButton 
    {

        public static const GIFTBAG_PRICE:int = 4599;


        override protected function initliziItemTemplate():void
        {
            _itemInfo = new ItemTemplateInfo();
            _itemInfo.Name = LanguageMgr.GetTranslation("tank.view.common.BuyGiftBagButton.initliziItemTemplate.excellent");
            _itemInfo.Quality = 4;
            _itemInfo.TemplateID = 2;
            _itemInfo.CategoryID = 11;
            _itemInfo.Description = LanguageMgr.GetTranslation("tank.view.common.BuyGiftBagButton.initliziItemTemplate.info");
            var _local_1:GoodTipInfo = new GoodTipInfo();
            _local_1.itemInfo = _itemInfo;
            _local_1.isBalanceTip = false;
            _local_1.typeIsSecond = false;
            tipData = _local_1;
        }

        override protected function __onMouseClick(_arg_1:MouseEvent):void
        {
            var _local_2:BaseAlerFrame;
            if (_enable)
            {
                _arg_1.stopImmediatePropagation();
                SoundManager.instance.play("008");
                if (PlayerManager.Instance.Self.bagLocked)
                {
                    BaglockedManager.Instance.show();
                    return;
                };
                if (PlayerManager.Instance.Self.totalMoney < GIFTBAG_PRICE)
                {
                    LeavePageManager.showFillFrame();
                    return;
                };
                _local_2 = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"), LanguageMgr.GetTranslation("store.view.strength.buyGift"), LanguageMgr.GetTranslation("ok"), LanguageMgr.GetTranslation("cancel"), false, true, false, LayerManager.ALPHA_BLOCKGOUND);
                _local_2.moveEnable = false;
                _local_2.addEventListener(FrameEvent.RESPONSE, this._responseI);
            };
        }

        private function _responseI(_arg_1:FrameEvent):void
        {
            SoundManager.instance.play("008");
            (_arg_1.currentTarget as BaseAlerFrame).removeEventListener(FrameEvent.RESPONSE, this._responseI);
            if (((_arg_1.responseCode == FrameEvent.SUBMIT_CLICK) || (_arg_1.responseCode == FrameEvent.ENTER_CLICK)))
            {
                this.doBuy();
            };
            ObjectUtils.disposeObject(_arg_1.target);
        }

        private function doBuy():void
        {
            SocketManager.Instance.out.sendBuyGiftBag(EquipType.STRENGTH_GIFT_BAG);
            dispatchEvent(new ShortcutBuyEvent(2, 5));
        }


    }
}//package store.view.strength

