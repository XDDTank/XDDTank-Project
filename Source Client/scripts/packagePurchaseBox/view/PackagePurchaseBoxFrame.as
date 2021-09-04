package packagePurchaseBox.view
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.ui.controls.ScrollPanel;
   import com.pickgliss.ui.controls.container.VBox;
   import com.pickgliss.ui.image.Scale9CornerImage;
   import com.pickgliss.ui.image.ScaleBitmapImage;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.goods.ShopItemInfo;
   import ddt.events.PurchaseBoxEvent;
   import ddt.events.TimeEvents;
   import ddt.manager.LanguageMgr;
   import ddt.manager.ShopManager;
   import ddt.manager.SoundManager;
   import ddt.manager.TimeManager;
   import flash.display.Sprite;
   import packagePurchaseBox.PackagePurchaseBoxController;
   
   public class PackagePurchaseBoxFrame extends Frame
   {
      
      public static var STACTICITEM:int = 4;
      
      public static const PURCHASEPACKAGEBOX:int = 86;
       
      
      private var itemMount:int;
      
      private var _goodItemContainerAll:Sprite;
      
      private var _cartScroll:ScrollPanel;
      
      private var _cartList:VBox;
      
      private var _BG0:ScaleBitmapImage;
      
      private var _BG:Scale9CornerImage;
      
      private var _goodItems:Vector.<PackagePurchaseBoxItem>;
      
      private var itemlength:uint;
      
      public function PackagePurchaseBoxFrame()
      {
         super();
         this.intview();
         this.intEvent();
      }
      
      private function intview() : void
      {
         this._BG0 = ComponentFactory.Instance.creatComponentByStylename("packagePurchaseBoxFrameBG0");
         this._BG = ComponentFactory.Instance.creatComponentByStylename("packagePurchaseBoxFrameBg");
         titleText = LanguageMgr.GetTranslation("ddt.packagePurchaseBox.frameTitle");
         this._goodItems = new Vector.<PackagePurchaseBoxItem>();
         this._cartList = new VBox();
         this._cartScroll = ComponentFactory.Instance.creatComponentByStylename("ddtshop.CheckOutViewItemListI");
         this._cartList.spacing = 5;
         this._cartScroll.setView(this._cartList);
         this._cartScroll.vScrollProxy = ScrollPanel.ON;
         this._cartList.isReverAdd = true;
         addToContent(this._BG0);
         addToContent(this._BG);
         addToContent(this._cartScroll);
         this.updateItems();
         this.clearitems();
         this.loadList();
      }
      
      private function updateItems() : void
      {
         var _loc1_:int = 0;
         var _loc2_:Number = NaN;
         var _loc3_:Number = NaN;
         if(this._goodItemContainerAll)
         {
            ObjectUtils.disposeObject(this._goodItemContainerAll);
            this._goodItemContainerAll = null;
         }
         this._goodItemContainerAll = ComponentFactory.Instance.creatCustomObject("ddtshop.GoodItemContainerAll");
         this.itemlength = PackagePurchaseBoxController.instance.measureList(ShopManager.Instance.getValidSortedGoodsByType(PURCHASEPACKAGEBOX,1)).length;
         this.itemMount = Math.max(this.itemlength,STACTICITEM);
         _loc1_ = 0;
         while(_loc1_ < this.itemMount)
         {
            this._goodItems[_loc1_] = ComponentFactory.Instance.creatCustomObject("ddtshop.packagePurchaseBoxItem");
            _loc2_ = this._goodItems[_loc1_].width;
            _loc3_ = this._goodItems[_loc1_].height;
            _loc2_ *= int(_loc1_ % 2);
            _loc3_ *= int(_loc1_ / 2);
            this._goodItems[_loc1_].x = _loc2_;
            this._goodItems[_loc1_].y = _loc3_ + _loc1_ / 2 * 2;
            this._goodItemContainerAll.addChild(this._goodItems[_loc1_]);
            _loc1_++;
         }
         this._cartList.addChild(this._goodItemContainerAll);
         this._cartScroll.invalidateViewport();
      }
      
      private function clearitems() : void
      {
         var _loc1_:int = 0;
         while(_loc1_ < this.itemMount)
         {
            this._goodItems[_loc1_].shopItemInfo = null;
            _loc1_++;
         }
      }
      
      public function loadList() : void
      {
         this.clearitems();
         this.setList(ShopManager.Instance.getValidSortedGoodsByType(PURCHASEPACKAGEBOX,1));
      }
      
      public function setList(param1:Vector.<ShopItemInfo>) : void
      {
         var _loc2_:int = 0;
         while(_loc2_ < this.itemlength)
         {
            this._goodItems[_loc2_].selected = false;
            if(!param1)
            {
               break;
            }
            this._goodItems[_loc2_].ableButton();
            if(_loc2_ < param1.length && param1[_loc2_])
            {
               if(param1[_loc2_].isValid)
               {
                  this._goodItems[_loc2_].shopItemInfo = param1[_loc2_];
               }
            }
            _loc2_++;
         }
      }
      
      public function show() : void
      {
         LayerManager.Instance.addToLayer(this,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.ALPHA_BLOCKGOUND);
      }
      
      public function intEvent() : void
      {
         PackagePurchaseBoxController.instance.addEventListener(PurchaseBoxEvent.PURCHAESBOX_CHANGE,this.__update);
         addEventListener(FrameEvent.RESPONSE,this.__frameEventHandler);
         TimeManager.addEventListener(TimeEvents.MINUTES,this.__updateByMinutes);
      }
      
      private function __updateByMinutes(param1:TimeEvents) : void
      {
         this.updateItems();
         this.loadList();
      }
      
      private function __update(param1:PurchaseBoxEvent) : void
      {
         this.updateItems();
         this.loadList();
      }
      
      private function __frameEventHandler(param1:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         switch(param1.responseCode)
         {
            case FrameEvent.ESC_CLICK:
            case FrameEvent.CLOSE_CLICK:
               PackagePurchaseBoxController.instance.hide();
         }
      }
      
      private function removeEvent() : void
      {
         TimeManager.removeEventListener(TimeEvents.MINUTES,this.__updateByMinutes);
         PackagePurchaseBoxController.instance.removeEventListener(PurchaseBoxEvent.PURCHAESBOX_CHANGE,this.__update);
      }
      
      override public function dispose() : void
      {
         this.removeEvent();
         super.dispose();
         ObjectUtils.disposeObject(this._BG0);
         this._BG0 = null;
         ObjectUtils.disposeObject(this._BG);
         this._BG = null;
         var _loc1_:int = 0;
         while(_loc1_ < this.itemlength)
         {
            ObjectUtils.disposeObject(this._goodItems[_loc1_]);
            this._goodItems[_loc1_] = null;
            _loc1_++;
         }
         this._goodItems = null;
         ObjectUtils.disposeObject(this._goodItemContainerAll);
         this._goodItemContainerAll = null;
      }
   }
}
