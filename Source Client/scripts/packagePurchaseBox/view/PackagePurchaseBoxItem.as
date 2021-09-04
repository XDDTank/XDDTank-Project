package packagePurchaseBox.view
{
   import ddt.events.ItemEvent;
   import ddt.events.PurchaseBoxEvent;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.SoundManager;
   import flash.events.MouseEvent;
   import packagePurchaseBox.PackagePurchaseBoxController;
   import shop.manager.ShopBuyManager;
   import shop.manager.ShopGiftsManager;
   import shop.view.ShopGoodItem;
   
   public class PackagePurchaseBoxItem extends ShopGoodItem
   {
       
      
      public function PackagePurchaseBoxItem()
      {
         super();
      }
      
      override protected function __payPanelClick(param1:MouseEvent) : void
      {
         if(_shopItemInfo && !_shopItemInfo.isValid)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("shop.ShopIIModel.timeOver"));
            PackagePurchaseBoxController.instance.dispatchEvent(new PurchaseBoxEvent(PurchaseBoxEvent.PURCHAESBOX_CHANGE));
            return;
         }
         param1.stopImmediatePropagation();
         if(_shopItemInfo != null)
         {
            SoundManager.instance.play("008");
            if(param1.currentTarget == _payPaneGivingBtn)
            {
               ShopGiftsManager.Instance.buy(_shopItemInfo.GoodsID,_shopItemInfo.isDiscount == 2);
            }
            else
            {
               ShopBuyManager.Instance.buy(_shopItemInfo.GoodsID,_shopItemInfo.isDiscount);
            }
         }
         dispatchEvent(new ItemEvent(ItemEvent.ITEM_SELECT,_shopItemInfo,0));
      }
      
      override protected function __itemClick(param1:MouseEvent) : void
      {
         if(_shopItemInfo && !_shopItemInfo.isValid)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("shop.ShopIIModel.timeOver"));
            PackagePurchaseBoxController.instance.dispatchEvent(new PurchaseBoxEvent(PurchaseBoxEvent.PURCHAESBOX_CHANGE));
            return;
         }
         if(_shopItemInfo != null)
         {
            SoundManager.instance.play("008");
            ShopBuyManager.Instance.buy(_shopItemInfo.GoodsID,_shopItemInfo.isDiscount);
         }
         dispatchEvent(new ItemEvent(ItemEvent.ITEM_SELECT,_shopItemInfo,0));
      }
   }
}
