// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//packagePurchaseBox.view.PackagePurchaseBoxItem

package packagePurchaseBox.view
{
    import shop.view.ShopGoodItem;
    import ddt.manager.MessageTipManager;
    import ddt.manager.LanguageMgr;
    import packagePurchaseBox.PackagePurchaseBoxController;
    import ddt.events.PurchaseBoxEvent;
    import ddt.manager.SoundManager;
    import shop.manager.ShopGiftsManager;
    import shop.manager.ShopBuyManager;
    import ddt.events.ItemEvent;
    import flash.events.MouseEvent;

    public class PackagePurchaseBoxItem extends ShopGoodItem 
    {


        override protected function __payPanelClick(_arg_1:MouseEvent):void
        {
            if (((_shopItemInfo) && (!(_shopItemInfo.isValid))))
            {
                MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("shop.ShopIIModel.timeOver"));
                PackagePurchaseBoxController.instance.dispatchEvent(new PurchaseBoxEvent(PurchaseBoxEvent.PURCHAESBOX_CHANGE));
                return;
            };
            _arg_1.stopImmediatePropagation();
            if (_shopItemInfo != null)
            {
                SoundManager.instance.play("008");
                if (_arg_1.currentTarget == _payPaneGivingBtn)
                {
                    ShopGiftsManager.Instance.buy(_shopItemInfo.GoodsID, (_shopItemInfo.isDiscount == 2));
                }
                else
                {
                    ShopBuyManager.Instance.buy(_shopItemInfo.GoodsID, _shopItemInfo.isDiscount);
                };
            };
            dispatchEvent(new ItemEvent(ItemEvent.ITEM_SELECT, _shopItemInfo, 0));
        }

        override protected function __itemClick(_arg_1:MouseEvent):void
        {
            if (((_shopItemInfo) && (!(_shopItemInfo.isValid))))
            {
                MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("shop.ShopIIModel.timeOver"));
                PackagePurchaseBoxController.instance.dispatchEvent(new PurchaseBoxEvent(PurchaseBoxEvent.PURCHAESBOX_CHANGE));
                return;
            };
            if (_shopItemInfo != null)
            {
                SoundManager.instance.play("008");
                ShopBuyManager.Instance.buy(_shopItemInfo.GoodsID, _shopItemInfo.isDiscount);
            };
            dispatchEvent(new ItemEvent(ItemEvent.ITEM_SELECT, _shopItemInfo, 0));
        }


    }
}//package packagePurchaseBox.view

