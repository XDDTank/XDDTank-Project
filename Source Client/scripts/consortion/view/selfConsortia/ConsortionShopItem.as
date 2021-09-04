package consortion.view.selfConsortia
{
   import baglocked.BaglockedManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import consortion.consortionsence.ConsortionManager;
   import ddt.data.goods.ShopItemInfo;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import flash.events.MouseEvent;
   import shop.view.ShopGoodItem;
   
   public class ConsortionShopItem extends ShopGoodItem
   {
       
      
      private var _enable:Boolean;
      
      private var _info:ShopItemInfo;
      
      private var _time:int;
      
      private var _needOffer:FilterFrameText;
      
      private var _needLevelTxt:FilterFrameText;
      
      public function ConsortionShopItem()
      {
         super();
      }
      
      override protected function initContent() : void
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
      
      override protected function addEvent() : void
      {
         super.addEvent();
         _payPaneBuyBtn.addEventListener(MouseEvent.CLICK,this.__payPanelClick);
      }
      
      override protected function __payPanelClick(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            return;
         }
         if(this._info && this.cheackMoney())
         {
            this.sendConsortiaShop();
         }
      }
      
      private function cheackMoney() : Boolean
      {
         if(PlayerManager.Instance.Self.RichesOffer < this._info.getItemPrice(this._time).offValue)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ConsortiaShopItem.gongxianbuzu"));
            return false;
         }
         return true;
      }
      
      override protected function __itemMouseOver(param1:MouseEvent) : void
      {
      }
      
      override protected function __itemMouseOut(param1:MouseEvent) : void
      {
      }
      
      override public function set shopItemInfo(param1:ShopItemInfo) : void
      {
         super.shopItemInfo = param1;
         this._info = param1;
         _payPaneGivingBtn.visible = false;
         _payType.visible = false;
         _shopItemCellTypeBg.visible = false;
         if(this._info == null)
         {
            this._needOffer.visible = false;
            this._needLevelTxt.visible = false;
            _dotLine.visible = false;
            _itemBg.filters = null;
            _itemCell.filters = null;
            _itemCellBg.filters = null;
            _itemNameTxt.filters = null;
            return;
         }
         this._needOffer.visible = true;
         _dotLine.visible = true;
         this._needLevelTxt.visible = true;
         if(this._info.LimitGrade > PlayerManager.Instance.Self.consortiaInfo.ShopLevel)
         {
            this.setfilter(false);
            _itemPriceTxt.visible = false;
            _payPaneBuyBtn.enable = false;
            this._needLevelTxt.text = LanguageMgr.GetTranslation("ddt.consortionShop.NeedLevelTxt",this._info.LimitGrade);
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
         }
         if(ConsortionManager.Instance.buyType != 10)
         {
            if(this._info.isBuy)
            {
               _payPaneBuyBtn.enable = false;
            }
            else
            {
               _payPaneBuyBtn.enable = true;
            }
         }
      }
      
      private function setfilter(param1:Boolean) : void
      {
         if(param1)
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
         }
      }
      
      private function sendConsortiaShop() : void
      {
         var _loc1_:Array = [this._info.ID];
         var _loc2_:Array = [1];
         var _loc3_:Array = [""];
         var _loc4_:Array = [false];
         var _loc5_:Array = [""];
         var _loc6_:Array = [-1];
         SocketManager.Instance.out.sendBuyGoods(_loc1_,_loc2_,_loc3_,_loc6_,_loc4_,_loc5_);
         if(ConsortionManager.Instance.buyType == 10)
         {
            _payPaneBuyBtn.enable = true;
         }
         else
         {
            _payPaneBuyBtn.enable = false;
            this._info.isBuy = true;
         }
      }
      
      override public function dispose() : void
      {
         if(this._needOffer)
         {
            ObjectUtils.disposeObject(this._needOffer);
         }
         this._needOffer = null;
         super.dispose();
      }
   }
}
