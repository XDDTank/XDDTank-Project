package shop.manager
{
   import baglocked.BaglockedManager;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.toplevel.StageReferance;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.ui.controls.NumberSelecter;
   import com.pickgliss.ui.image.Scale9CornerImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.goods.ShopCarItemInfo;
   import ddt.data.goods.ShopItemInfo;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.manager.LanguageMgr;
   import ddt.manager.LeavePageManager;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.ShopManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.utils.FilterWordManager;
   import ddt.utils.PositionUtils;
   import flash.display.Bitmap;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import shop.view.ShopCartItem;
   import shop.view.ShopPresentClearingFrame;
   
   public class ShopGiftsManager
   {
      
      private static var _instance:ShopGiftsManager;
       
      
      private var _frame:Frame;
      
      private var _shopCartItem:ShopCartItem;
      
      private var _titleTxt:FilterFrameText;
      
      private var _commodityPricesText1:FilterFrameText;
      
      private var _commodityPricesText2:FilterFrameText;
      
      private var _giftsBtn:BaseButton;
      
      private var _numberSelecter:NumberSelecter;
      
      private var _goodsID:int;
      
      private var _isDiscountType:Boolean = true;
      
      private var _shopPresentClearingFrame:ShopPresentClearingFrame;
      
      public function ShopGiftsManager()
      {
         super();
      }
      
      public static function get Instance() : ShopGiftsManager
      {
         if(_instance == null)
         {
            _instance = new ShopGiftsManager();
         }
         return _instance;
      }
      
      public function buy(param1:int, param2:Boolean = false) : void
      {
         if(this._frame)
         {
            return;
         }
         this._goodsID = param1;
         this._isDiscountType = param2;
         this.initView();
         this.addEvent();
         LayerManager.Instance.addToLayer(this._frame,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
      }
      
      private function initView() : void
      {
         var _loc4_:ShopCarItemInfo = null;
         this._frame = ComponentFactory.Instance.creatComponentByStylename("core.ddtshop.CheckOutViewFrame");
         this._frame.titleText = LanguageMgr.GetTranslation("shop.view.present");
         this._titleTxt = ComponentFactory.Instance.creatComponentByStylename("shop.PresentFrame.titleText");
         this._titleTxt.text = LanguageMgr.GetTranslation("shop.PresentFrame.titleText");
         this._frame.addToContent(this._titleTxt);
         var _loc1_:Scale9CornerImage = ComponentFactory.Instance.creatComponentByStylename("core.ddtshop.CheckOutViewBg");
         this._frame.addToContent(_loc1_);
         this._giftsBtn = ComponentFactory.Instance.creatComponentByStylename("ddtshop.GiftManager.GiftBtn");
         this._frame.addToContent(this._giftsBtn);
         var _loc2_:Bitmap = ComponentFactory.Instance.creatBitmap("ddtshop.TotalMoneyPanel2");
         PositionUtils.setPos(_loc2_,"ddtshop.CheckOutViewBgPos");
         this._frame.addToContent(_loc2_);
         var _loc3_:ShopItemInfo = null;
         _loc3_ = ShopManager.Instance.getShopItemByGoodsID(this._goodsID);
         _loc4_ = new ShopCarItemInfo(_loc3_.GoodsID,_loc3_.TemplateID);
         ObjectUtils.copyProperties(_loc4_,_loc3_);
         this._shopCartItem = new ShopCartItem();
         PositionUtils.setPos(this._shopCartItem,"ddtshop.shopCartItemPos");
         this._shopCartItem.closeBtn.visible = false;
         this._shopCartItem.shopItemInfo = _loc4_;
         this._shopCartItem.setColor(_loc4_.Color);
         this._frame.addToContent(this._shopCartItem);
         var _loc5_:Bitmap = ComponentFactory.Instance.creatBitmap("asset.ddtshop.PurchaseAmount");
         PositionUtils.setPos(_loc5_,"ddtshop.PurchaseAmountTextImgPos");
         this._frame.addToContent(_loc5_);
         this._numberSelecter = ComponentFactory.Instance.creatComponentByStylename("core.ddtshop.NumberSelecter");
         this._frame.addToContent(this._numberSelecter);
         this._commodityPricesText1 = ComponentFactory.Instance.creatComponentByStylename("core.ddtshop.CommodityPricesText");
         PositionUtils.setPos(this._commodityPricesText1,"ddtshop.commodityPricesText1Pos");
         this._commodityPricesText1.text = "0";
         this._frame.addToContent(this._commodityPricesText1);
         this._commodityPricesText2 = ComponentFactory.Instance.creatComponentByStylename("core.ddtshop.CommodityPricesText");
         PositionUtils.setPos(this._commodityPricesText2,"ddtshop.commodityPricesText2Pos");
         this._commodityPricesText2.text = "0";
         this._frame.addToContent(this._commodityPricesText2);
         this.updateCommodityPrices();
      }
      
      private function addEvent() : void
      {
         this._giftsBtn.addEventListener(MouseEvent.CLICK,this.__giftsBtnClick);
         this._numberSelecter.addEventListener(Event.CHANGE,this.__numberSelecterChange);
         this._shopCartItem.addEventListener(ShopCartItem.CONDITION_CHANGE,this.__shopCartItemChange);
         this._frame.addEventListener(FrameEvent.RESPONSE,this.__framePesponse);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.GOODS_PRESENT,this.onPresent);
      }
      
      private function removeEvent() : void
      {
         this._giftsBtn.removeEventListener(MouseEvent.CLICK,this.__giftsBtnClick);
         this._numberSelecter.removeEventListener(Event.CHANGE,this.__numberSelecterChange);
         this._shopCartItem.removeEventListener(ShopCartItem.CONDITION_CHANGE,this.__shopCartItemChange);
         this._frame.removeEventListener(FrameEvent.RESPONSE,this.__framePesponse);
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.GOODS_PRESENT,this.onPresent);
      }
      
      private function updateCommodityPrices() : void
      {
         this._commodityPricesText1.text = String(this._shopCartItem.shopItemInfo.getCurrentPrice().moneyValue * this._numberSelecter.currentValue);
         this._commodityPricesText2.text = String(0);
      }
      
      protected function __giftsBtnClick(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         this._shopPresentClearingFrame = ComponentFactory.Instance.creatComponentByStylename("core.ddtshop.ShopPresentClearingFrame");
         this._shopPresentClearingFrame.show();
         this._shopPresentClearingFrame.presentBtn.addEventListener(MouseEvent.CLICK,this.__presentBtnClick);
         this._shopPresentClearingFrame.addEventListener(FrameEvent.RESPONSE,this.__responseHandler);
      }
      
      private function __responseHandler(param1:FrameEvent) : void
      {
         if(param1.responseCode == FrameEvent.CLOSE_CLICK || param1.responseCode == FrameEvent.ESC_CLICK)
         {
            StageReferance.stage.focus = this._frame;
         }
      }
      
      protected function __presentBtnClick(param1:MouseEvent) : void
      {
         var _loc11_:ShopCarItemInfo = null;
         SoundManager.instance.play("008");
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            return;
         }
         if(this._shopPresentClearingFrame.nameInput.text == "")
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("shop.ShopIIPresentView.give"));
            return;
         }
         if(FilterWordManager.IsNullorEmpty(this._shopPresentClearingFrame.nameInput.text))
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("shop.ShopIIPresentView.space"));
            return;
         }
         var _loc2_:int = this._shopCartItem.shopItemInfo.getCurrentPrice().moneyValue;
         if(this._shopCartItem.shopItemInfo && !this._shopCartItem.shopItemInfo.isValid)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("shop.ShopIIModel.timeOver"));
            this.dispose();
            return;
         }
         if(PlayerManager.Instance.Self.Money < _loc2_)
         {
            LeavePageManager.showFillFrame();
            return;
         }
         this._shopPresentClearingFrame.presentBtn.enable = false;
         var _loc3_:Array = new Array();
         var _loc4_:Array = new Array();
         var _loc5_:Array = new Array();
         var _loc6_:Array = new Array();
         var _loc7_:Array = new Array();
         var _loc8_:Array = new Array();
         var _loc9_:int = 0;
         while(_loc9_ < this._numberSelecter.currentValue)
         {
            _loc11_ = this._shopCartItem.shopItemInfo;
            _loc3_.push(_loc11_.GoodsID);
            _loc4_.push(_loc11_.currentBuyType);
            _loc5_.push(_loc11_.Color);
            _loc6_.push("");
            _loc7_.push("");
            _loc8_.push(_loc11_.isDiscount);
            _loc9_++;
         }
         var _loc10_:String = FilterWordManager.filterWrod(this._shopPresentClearingFrame.textArea.text);
         SocketManager.Instance.out.sendPresentGoods(_loc3_,_loc4_,_loc5_,_loc8_,_loc10_,this._shopPresentClearingFrame.nameInput.text);
      }
      
      protected function onPresent(param1:CrazyTankSocketEvent) : void
      {
         this._shopPresentClearingFrame.presentBtn.enable = true;
         this._shopPresentClearingFrame.presentBtn.removeEventListener(MouseEvent.CLICK,this.__presentBtnClick);
         this._shopPresentClearingFrame.dispose();
         this._shopPresentClearingFrame = null;
         var _loc2_:Boolean = param1.pkg.readBoolean();
         this.dispose();
      }
      
      protected function __numberSelecterChange(param1:Event) : void
      {
         SoundManager.instance.play("008");
         this.updateCommodityPrices();
      }
      
      protected function __shopCartItemChange(param1:Event) : void
      {
         this.updateCommodityPrices();
      }
      
      protected function __framePesponse(param1:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         switch(param1.responseCode)
         {
            case FrameEvent.CLOSE_CLICK:
            case FrameEvent.ESC_CLICK:
               this.dispose();
         }
      }
      
      private function dispose() : void
      {
         this.removeEvent();
         if(this._shopPresentClearingFrame)
         {
            ObjectUtils.disposeObject(this._shopPresentClearingFrame);
         }
         this._shopPresentClearingFrame = null;
         if(this._titleTxt)
         {
            ObjectUtils.disposeObject(this._titleTxt);
         }
         this._titleTxt = null;
         if(this._shopCartItem)
         {
            ObjectUtils.disposeObject(this._shopCartItem);
         }
         this._shopCartItem = null;
         if(this._commodityPricesText1)
         {
            ObjectUtils.disposeObject(this._commodityPricesText1);
         }
         this._commodityPricesText1 = null;
         if(this._commodityPricesText2)
         {
            ObjectUtils.disposeObject(this._commodityPricesText2);
         }
         this._commodityPricesText2 = null;
         if(this._giftsBtn)
         {
            ObjectUtils.disposeObject(this._giftsBtn);
         }
         this._giftsBtn = null;
         if(this._numberSelecter)
         {
            ObjectUtils.disposeObject(this._numberSelecter);
         }
         this._numberSelecter = null;
         if(this._frame)
         {
            ObjectUtils.disposeObject(this._frame);
         }
         this._frame = null;
      }
   }
}
