package shop.view
{
   import baglocked.BaglockedManager;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.ui.controls.NumberSelecter;
   import com.pickgliss.ui.core.Disposeable;
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
   import ddt.manager.SavePointManager;
   import ddt.manager.ShopManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.manager.TaskManager;
   import ddt.utils.PositionUtils;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import shop.ShopEvent;
   import trainer.data.ArrowType;
   import trainer.view.NewHandContainer;
   
   public class BuySingleGoodsView extends Sprite implements Disposeable
   {
      
      public static const SHOP_CANNOT_FIND:String = "shopCannotfind";
       
      
      private var _frame:Frame;
      
      private var _shopCartItem:ShopCartItem;
      
      private var _commodityPricesText1:FilterFrameText;
      
      private var _commodityPricesText2:FilterFrameText;
      
      private var _purchaseConfirmationBtn:BaseButton;
      
      private var _numberSelecter:NumberSelecter;
      
      private var _goodsID:int;
      
      private var _isDisCount:Boolean = false;
      
      public function BuySingleGoodsView()
      {
         super();
         this.initView();
         this.addEvent();
      }
      
      private function initView() : void
      {
         this._frame = ComponentFactory.Instance.creatComponentByStylename("core.ddtshop.CheckOutViewFrame");
         this._frame.titleText = LanguageMgr.GetTranslation("store.view.shortcutBuy.buyBtn");
         var _loc1_:Scale9CornerImage = ComponentFactory.Instance.creatComponentByStylename("core.ddtshop.CheckOutViewBg");
         this._frame.addToContent(_loc1_);
         this._purchaseConfirmationBtn = ComponentFactory.Instance.creatComponentByStylename("core.ddtshop.SingleGoodView.PurchaseBtn");
         this._frame.addToContent(this._purchaseConfirmationBtn);
         var _loc2_:Bitmap = ComponentFactory.Instance.creatBitmap("ddtshop.TotalMoneyPanel2");
         PositionUtils.setPos(_loc2_,"ddtshop.CheckOutViewBgPos");
         this._frame.addToContent(_loc2_);
         var _loc3_:Bitmap = ComponentFactory.Instance.creatBitmap("asset.ddtshop.PurchaseAmount");
         PositionUtils.setPos(_loc3_,"ddtshop.PurchaseAmountTextImgPos");
         this._frame.addToContent(_loc3_);
         this._numberSelecter = ComponentFactory.Instance.creatComponentByStylename("core.ddtshop.NumberSelecter");
         this._frame.addToContent(this._numberSelecter);
         this._commodityPricesText1 = ComponentFactory.Instance.creatComponentByStylename("core.ddtshop.CommodityPricesText");
         this._commodityPricesText1.text = "0";
         PositionUtils.setPos(this._commodityPricesText1,"ddtshop.commodityPricesText1Pos");
         this._frame.addToContent(this._commodityPricesText1);
         this._commodityPricesText2 = ComponentFactory.Instance.creatComponentByStylename("core.ddtshop.CommodityPricesText");
         this._commodityPricesText2.text = "0";
         PositionUtils.setPos(this._commodityPricesText2,"ddtshop.commodityPricesText2Pos");
         this._frame.addToContent(this._commodityPricesText2);
         addChild(this._frame);
         this.showGuilde();
      }
      
      public function set isDisCount(param1:Boolean) : void
      {
         this._isDisCount = param1;
      }
      
      public function set goodsID(param1:int) : void
      {
         var _loc2_:ShopItemInfo = null;
         if(this._shopCartItem)
         {
            this._shopCartItem.removeEventListener(ShopCartItem.CONDITION_CHANGE,this.__shopCartItemChange);
            this._shopCartItem.dispose();
         }
         this._goodsID = param1;
         _loc2_ = ShopManager.Instance.getShopItemByGoodsID(this._goodsID);
         if(!_loc2_)
         {
            _loc2_ = ShopManager.Instance.getGoodsByTemplateID(this._goodsID);
         }
         var _loc3_:ShopCarItemInfo = new ShopCarItemInfo(_loc2_.GoodsID,_loc2_.TemplateID);
         ObjectUtils.copyProperties(_loc3_,_loc2_);
         this._shopCartItem = new ShopCartItem();
         PositionUtils.setPos(this._shopCartItem,"ddtshop.shopCartItemPos");
         this._shopCartItem.closeBtn.visible = false;
         this._shopCartItem.shopItemInfo = _loc3_;
         this._shopCartItem.setColor(_loc3_.Color);
         this._frame.addToContent(this._shopCartItem);
         this._shopCartItem.addEventListener(ShopCartItem.CONDITION_CHANGE,this.__shopCartItemChange);
         this.updateCommodityPrices();
      }
      
      private function showGuilde() : void
      {
         if(SavePointManager.Instance.isInSavePoint(15) && !TaskManager.instance.isNewHandTaskCompleted(11))
         {
            NewHandContainer.Instance.clearArrowByID(ArrowType.SHOP_GIFT);
            NewHandContainer.Instance.showArrow(ArrowType.SHOP_SINGLE_GOODS,90,"trainer.shopSingleGoodsArrowPos","","",LayerManager.Instance.getLayerByType(LayerManager.GAME_TOP_LAYER));
         }
      }
      
      private function addEvent() : void
      {
         this._purchaseConfirmationBtn.addEventListener(MouseEvent.CLICK,this.__purchaseConfirmationBtnClick);
         this._numberSelecter.addEventListener(Event.CHANGE,this.__numberSelecterChange);
         this._frame.addEventListener(FrameEvent.RESPONSE,this.__framePesponse);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.BUY_GOODS,this.onBuyedGoods);
      }
      
      private function removeEvent() : void
      {
         this._purchaseConfirmationBtn.removeEventListener(MouseEvent.CLICK,this.__purchaseConfirmationBtnClick);
         this._numberSelecter.removeEventListener(Event.CHANGE,this.__numberSelecterChange);
         if(this._shopCartItem)
         {
            this._shopCartItem.removeEventListener(ShopCartItem.CONDITION_CHANGE,this.__shopCartItemChange);
         }
         this._frame.removeEventListener(FrameEvent.RESPONSE,this.__framePesponse);
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.BUY_GOODS,this.onBuyedGoods);
      }
      
      private function updateCommodityPrices() : void
      {
         var _loc1_:int = 0;
         _loc1_ = this._shopCartItem.shopItemInfo.getCurrentPrice().moneyValue * this._numberSelecter.currentValue - PlayerManager.Instance.Self.DDTMoney;
         if(_loc1_ >= 0)
         {
            this._commodityPricesText1.text = String(_loc1_);
            this._commodityPricesText2.text = String(PlayerManager.Instance.Self.DDTMoney);
         }
         else
         {
            this._commodityPricesText1.text = String(0);
            this._commodityPricesText2.text = String(this._shopCartItem.shopItemInfo.getCurrentPrice().moneyValue * this._numberSelecter.currentValue);
         }
      }
      
      protected function __purchaseConfirmationBtnClick(param1:MouseEvent) : void
      {
         var _loc11_:ShopCarItemInfo = null;
         SoundManager.instance.play("008");
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            return;
         }
         if(this._shopCartItem.shopItemInfo && !this._shopCartItem.shopItemInfo.isValid)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("shop.ShopIIModel.timeOver"));
            this.dispose();
            return;
         }
         var _loc2_:int = this._shopCartItem.shopItemInfo.getCurrentPrice().moneyValue;
         var _loc3_:int = _loc2_ - PlayerManager.Instance.Self.DDTMoney;
         if(PlayerManager.Instance.Self.Money < _loc3_ && _loc2_ != 0)
         {
            LeavePageManager.showFillFrame();
            return;
         }
         this._purchaseConfirmationBtn.enable = false;
         var _loc4_:Array = new Array();
         var _loc5_:Array = new Array();
         var _loc6_:Array = new Array();
         var _loc7_:Array = new Array();
         var _loc8_:Array = new Array();
         var _loc9_:Array = [];
         var _loc10_:int = 0;
         while(_loc10_ < this._numberSelecter.currentValue)
         {
            _loc11_ = this._shopCartItem.shopItemInfo;
            _loc4_.push(_loc11_.GoodsID);
            _loc5_.push(_loc11_.currentBuyType);
            _loc6_.push("");
            _loc7_.push("");
            _loc8_.push("");
            _loc9_.push(_loc11_.isDiscount);
            _loc10_++;
         }
         SocketManager.Instance.out.sendBuyGoods(_loc4_,_loc5_,_loc6_,_loc8_,_loc7_,null,0,_loc9_);
         this.dispose();
      }
      
      protected function onBuyedGoods(param1:CrazyTankSocketEvent) : void
      {
         this._purchaseConfirmationBtn.enable = true;
         param1.pkg.position = SocketManager.PACKAGE_CONTENT_START_INDEX;
         var _loc2_:int = param1.pkg.readInt();
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
               ShopManager.Instance.dispatchEvent(new ShopEvent(ShopEvent.SHOW_WEAK_GUILDE));
               this.dispose();
         }
      }
      
      public function dispose() : void
      {
         NewHandContainer.Instance.clearArrowByID(ArrowType.SHOP_SINGLE_GOODS);
         this.removeEvent();
         if(this._frame)
         {
            ObjectUtils.disposeObject(this._frame);
         }
         this._frame = null;
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
         if(this._purchaseConfirmationBtn)
         {
            ObjectUtils.disposeObject(this._purchaseConfirmationBtn);
         }
         this._purchaseConfirmationBtn = null;
         if(this._numberSelecter)
         {
            ObjectUtils.disposeObject(this._numberSelecter);
         }
         this._numberSelecter = null;
         if(parent)
         {
            parent.removeChild(this);
         }
      }
   }
}
