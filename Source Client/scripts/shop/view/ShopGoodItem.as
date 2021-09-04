package shop.view
{
   import bagAndInfo.cell.CellFactory;
   import baglocked.BaglockedManager;
   import com.greensock.TimelineMax;
   import com.greensock.TweenLite;
   import com.greensock.TweenMax;
   import com.greensock.events.TweenEvent;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.ShowTipManager;
   import com.pickgliss.ui.controls.ISelectable;
   import com.pickgliss.ui.controls.TextButton;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.Image;
   import com.pickgliss.ui.image.ScaleFrameImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.EquipType;
   import ddt.data.goods.Price;
   import ddt.data.goods.ShopItemInfo;
   import ddt.events.ItemEvent;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SavePointManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import flash.display.Bitmap;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.filters.ColorMatrixFilter;
   import shop.manager.ShopBuyManager;
   import shop.manager.ShopGiftsManager;
   
   public class ShopGoodItem extends Sprite implements ISelectable, Disposeable
   {
      
      public static const PAYTYPE_MONEY:uint = 2;
      
      private static const LIMIT_LABEL:uint = 6;
       
      
      protected var _payPaneGivingBtn:TextButton;
      
      protected var _payPaneBuyBtn:TextButton;
      
      protected var _itemBg:ScaleFrameImage;
      
      protected var _itemCellBg:Image;
      
      private var _shopItemCellBg:Bitmap;
      
      protected var _itemCell:ShopItemCell;
      
      protected var _itemCellBtn:Sprite;
      
      protected var _itemCountTxt:FilterFrameText;
      
      protected var _itemNameTxt:FilterFrameText;
      
      protected var _itemPriceTxt:FilterFrameText;
      
      protected var _labelIcon:ScaleFrameImage;
      
      protected var _payType:ScaleFrameImage;
      
      protected var _selected:Boolean;
      
      protected var _shopItemInfo:ShopItemInfo;
      
      protected var _shopItemCellTypeBg:ScaleFrameImage;
      
      private var _payPaneBuyBtnHotArea:Sprite;
      
      protected var _dotLine:Image;
      
      protected var _timeline:TimelineMax;
      
      protected var _isMouseOver:Boolean;
      
      protected var _lightMc:MovieClip;
      
      public function ShopGoodItem()
      {
         super();
         this.initContent();
         this.addEvent();
      }
      
      public function get payPaneGivingBtn() : TextButton
      {
         return this._payPaneGivingBtn;
      }
      
      public function get payPaneBuyBtn() : TextButton
      {
         return this._payPaneBuyBtn;
      }
      
      public function get itemBg() : ScaleFrameImage
      {
         return this._itemBg;
      }
      
      public function get itemCell() : ShopItemCell
      {
         return this._itemCell;
      }
      
      public function get itemCellBtn() : Sprite
      {
         return this._itemCellBtn;
      }
      
      public function get dotLine() : Image
      {
         return this._dotLine;
      }
      
      protected function initContent() : void
      {
         this._itemBg = ComponentFactory.Instance.creatComponentByStylename("ddtshop.GoodItemBg");
         this._itemCellBg = ComponentFactory.Instance.creatComponentByStylename("ddtshop.GoodItemCellBg");
         this._dotLine = ComponentFactory.Instance.creatComponentByStylename("ddtshop.GoodItemDotLine");
         this._payType = ComponentFactory.Instance.creatComponentByStylename("ddtshop.GoodPayTypeLabel");
         this._payType.mouseChildren = false;
         this._payType.mouseEnabled = false;
         this._payPaneGivingBtn = ComponentFactory.Instance.creatComponentByStylename("ddtshop.PayPaneGivingBtn");
         this._payPaneGivingBtn.text = LanguageMgr.GetTranslation("shop.view.present");
         this._payPaneBuyBtn = ComponentFactory.Instance.creatComponentByStylename("ddtshop.PayPaneBuyBtn");
         this._payPaneBuyBtn.text = LanguageMgr.GetTranslation("store.Strength.BuyButtonText");
         if(!SavePointManager.Instance.savePoints[15])
         {
            this._payPaneGivingBtn.mouseEnabled = false;
            this.applyGray(this._payPaneGivingBtn);
         }
         this._payPaneBuyBtnHotArea = new Sprite();
         this._payPaneBuyBtnHotArea.graphics.beginFill(0,0);
         this._payPaneBuyBtnHotArea.graphics.drawRect(0,0,this._payPaneBuyBtn.width,this._payPaneBuyBtn.height);
         PositionUtils.setPos(this._payPaneBuyBtnHotArea,this._payPaneBuyBtn);
         this._itemNameTxt = ComponentFactory.Instance.creatComponentByStylename("ddtshop.GoodItemName");
         this._itemPriceTxt = ComponentFactory.Instance.creatComponentByStylename("ddtshop.GoodItemPrice");
         this._itemCountTxt = ComponentFactory.Instance.creatComponentByStylename("ddtshop.GoodItemCount");
         this._itemCell = this.creatItemCell();
         PositionUtils.setPos(this._itemCell,"ddtshop.ShopGoodItemCellPos");
         this._labelIcon = ComponentFactory.Instance.creatComponentByStylename("ddtshop.GoodLabelIcon");
         this._labelIcon.mouseChildren = false;
         this._labelIcon.mouseEnabled = false;
         this._shopItemCellTypeBg = ComponentFactory.Instance.creatComponentByStylename("ddtshop.ShopItemCellTypeBg");
         this._itemCellBtn = new Sprite();
         this._itemCellBtn.buttonMode = true;
         this._itemCellBtn.addChild(this._itemCell);
         this._itemCellBtn.addChild(this._shopItemCellTypeBg);
         this._itemBg.setFrame(1);
         this._itemCellBg.setFrame(1);
         this._labelIcon.setFrame(1);
         this._payType.setFrame(1);
         addChild(this._itemBg);
         addChild(this._itemCellBg);
         addChild(this._dotLine);
         addChild(this._payPaneGivingBtn);
         addChild(this._payPaneBuyBtn);
         addChild(this._payPaneBuyBtnHotArea);
         addChild(this._payType);
         addChild(this._itemCellBtn);
         addChild(this._labelIcon);
         addChild(this._itemNameTxt);
         addChild(this._itemPriceTxt);
         addChild(this._itemCountTxt);
         this._timeline = new TimelineMax();
         this._timeline.addEventListener(TweenEvent.COMPLETE,this.__timelineComplete);
         var _loc1_:TweenLite = TweenLite.to(this._labelIcon,0.25,{
            "alpha":0,
            "y":"-30"
         });
         this._timeline.append(_loc1_);
         var _loc2_:TweenLite = TweenLite.to(this._itemCountTxt,0.25,{
            "alpha":0,
            "y":"-30"
         });
         this._timeline.append(_loc2_,-0.25);
         var _loc3_:TweenMax = TweenMax.from(this._shopItemCellTypeBg,0.1,{
            "autoAlpha":0,
            "y":"5"
         });
         this._timeline.append(_loc3_,-0.2);
         this._timeline.stop();
      }
      
      protected function creatItemCell() : ShopItemCell
      {
         var _loc1_:Sprite = new Sprite();
         _loc1_.graphics.beginFill(16777215,0);
         _loc1_.graphics.drawRect(0,0,75,75);
         _loc1_.graphics.endFill();
         return CellFactory.instance.createShopItemCell(_loc1_,null,true,true) as ShopItemCell;
      }
      
      public function get shopItemInfo() : ShopItemInfo
      {
         return this._shopItemInfo;
      }
      
      public function set shopItemInfo(param1:ShopItemInfo) : void
      {
         if(this._shopItemInfo)
         {
            this._shopItemInfo.removeEventListener(Event.CHANGE,this.__updateShopItem);
         }
         if(param1 == null)
         {
            this._shopItemInfo = null;
            this._itemCell.info = null;
         }
         else
         {
            this._shopItemInfo = param1;
            this._itemCell.info = param1.TemplateInfo;
            this._itemCell.tipInfo = param1;
         }
         if(this._itemCell.info != null)
         {
            this._itemCell.visible = true;
            this._itemCellBtn.visible = true;
            this._itemCellBtn.buttonMode = true;
            this._payType.visible = true;
            this._itemPriceTxt.visible = true;
            this._itemNameTxt.visible = true;
            this._itemCountTxt.visible = true;
            this._payPaneGivingBtn.visible = true;
            this._payPaneBuyBtn.visible = true;
            this._itemNameTxt.text = String(this._itemCell.info.Name);
            this._itemCell.tipInfo = param1;
            this.initPrice();
            if(this._shopItemInfo.ShopID == 1)
            {
               this._itemBg.setFrame(1);
               this._itemCellBg.setFrame(1);
            }
            else
            {
               this._itemBg.setFrame(2);
               this._itemCellBg.setFrame(2);
            }
            if(EquipType.dressAble(this._shopItemInfo.TemplateInfo))
            {
               this._shopItemCellTypeBg.setFrame(1);
            }
            else
            {
               this._shopItemCellTypeBg.setFrame(2);
            }
            this._labelIcon.visible = this._shopItemInfo.Label == 0 ? Boolean(false) : Boolean(true);
            this._labelIcon.setFrame(this._shopItemInfo.Label);
            this._shopItemInfo.addEventListener(Event.CHANGE,this.__updateShopItem);
         }
         else
         {
            this._itemBg.setFrame(1);
            this._itemCellBg.setFrame(1);
            this._itemCellBtn.visible = false;
            this._labelIcon.visible = false;
            this._payType.visible = false;
            this._itemPriceTxt.visible = false;
            this._itemNameTxt.visible = false;
            this._itemCountTxt.visible = false;
            this._payPaneGivingBtn.visible = false;
            this._payPaneBuyBtn.visible = false;
         }
         this.updateCount();
         this.updateBtn();
      }
      
      private function updateBtn() : void
      {
         if(!this._shopItemInfo)
         {
            return;
         }
         if(PlayerManager.Instance.Self.Grade < this._shopItemInfo.LimitGrade)
         {
            this._payPaneBuyBtn.enable = false;
            this._payPaneBuyBtnHotArea.mouseEnabled = true;
         }
         else
         {
            this._payPaneBuyBtn.enable = true;
            this._payPaneBuyBtnHotArea.mouseEnabled = false;
         }
      }
      
      private function __updateShopItem(param1:Event) : void
      {
         this.updateCount();
      }
      
      private function checkType() : int
      {
         if(this._shopItemInfo)
         {
            return this._shopItemInfo.ShopID == 1 ? int(1) : int(2);
         }
         return 1;
      }
      
      private function initPrice() : void
      {
         switch(this._shopItemInfo.getItemPrice(1).PriceType)
         {
            case Price.MONEY:
               this._payType.setFrame(PAYTYPE_MONEY);
               this._itemPriceTxt.text = String(this._shopItemInfo.getItemPrice(1).moneyValue);
               break;
            case Price.OFFER:
               this._itemPriceTxt.text = String(this._shopItemInfo.getItemPrice(1).offValue);
               this._payPaneGivingBtn.visible = false;
         }
      }
      
      private function updateCount() : void
      {
         if(this._shopItemInfo)
         {
            if(this._shopItemInfo.Label && this._shopItemInfo.Label == LIMIT_LABEL)
            {
               if(this._itemBg && this._labelIcon && this._itemCountTxt)
               {
                  this._itemCountTxt.text = String(this._shopItemInfo.LimitCount);
               }
            }
            else if(this._itemBg && this._labelIcon && this._itemCountTxt)
            {
               this._itemCountTxt.visible = false;
               this._itemCountTxt.text = "0";
            }
         }
      }
      
      protected function addEvent() : void
      {
         this._payPaneBuyBtn.addEventListener(MouseEvent.CLICK,this.__payPanelClick);
         this._payPaneBuyBtnHotArea.addEventListener(MouseEvent.MOUSE_OVER,this.__payPaneBuyBtnOver);
         this._payPaneBuyBtnHotArea.addEventListener(MouseEvent.MOUSE_OUT,this.__payPaneBuyBtnOut);
         this._payPaneGivingBtn.addEventListener(MouseEvent.CLICK,this.__payPanelClick);
         this._itemCellBtn.addEventListener(MouseEvent.CLICK,this.__itemClick);
         this._itemCellBtn.addEventListener(MouseEvent.MOUSE_OVER,this.__itemMouseOver);
         this._itemCellBtn.addEventListener(MouseEvent.MOUSE_OUT,this.__itemMouseOut);
         this._itemBg.addEventListener(MouseEvent.MOUSE_OVER,this.__itemMouseOver);
         this._itemBg.addEventListener(MouseEvent.MOUSE_OUT,this.__itemMouseOut);
      }
      
      protected function removeEvent() : void
      {
         this._payPaneBuyBtn.removeEventListener(MouseEvent.CLICK,this.__payPanelClick);
         this._payPaneBuyBtnHotArea.removeEventListener(MouseEvent.MOUSE_OVER,this.__payPaneBuyBtnOver);
         this._payPaneBuyBtnHotArea.removeEventListener(MouseEvent.MOUSE_OUT,this.__payPaneBuyBtnOut);
         this._payPaneGivingBtn.removeEventListener(MouseEvent.CLICK,this.__payPanelClick);
         this._itemCellBtn.removeEventListener(MouseEvent.CLICK,this.__itemClick);
         this._itemCellBtn.removeEventListener(MouseEvent.MOUSE_OVER,this.__itemMouseOver);
         this._itemCellBtn.removeEventListener(MouseEvent.MOUSE_OUT,this.__itemMouseOut);
         this._itemBg.removeEventListener(MouseEvent.MOUSE_OVER,this.__itemMouseOver);
         this._itemBg.removeEventListener(MouseEvent.MOUSE_OUT,this.__itemMouseOut);
      }
      
      protected function __payPaneBuyBtnOver(param1:MouseEvent) : void
      {
         if(this._shopItemInfo && this._shopItemInfo.LimitGrade > PlayerManager.Instance.Self.Grade)
         {
            this._payPaneBuyBtn.tipStyle = "ddt.view.tips.OneLineTip";
            this._payPaneBuyBtn.tipData = LanguageMgr.GetTranslation("ddt.shop.LimitGradeBuy",this._shopItemInfo.LimitGrade);
            this._payPaneBuyBtn.tipDirctions = "3,7,6";
            ShowTipManager.Instance.showTip(this._payPaneBuyBtn);
         }
      }
      
      protected function __payPaneBuyBtnOut(param1:MouseEvent) : void
      {
         ShowTipManager.Instance.removeTip(this._payPaneBuyBtn);
      }
      
      protected function __payPanelClick(param1:MouseEvent) : void
      {
         param1.stopImmediatePropagation();
         if(this._shopItemInfo && this._shopItemInfo.LimitCount == 0)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("shop.ShopIIModel.countOver"));
            return;
         }
         if(this._shopItemInfo != null)
         {
            SoundManager.instance.play("008");
            if(param1.currentTarget == this._payPaneGivingBtn)
            {
               ShopGiftsManager.Instance.buy(this._shopItemInfo.GoodsID,this._shopItemInfo.isDiscount == 2);
            }
            else
            {
               ShopBuyManager.Instance.buy(this._shopItemInfo.GoodsID,this._shopItemInfo.isDiscount);
            }
         }
         dispatchEvent(new ItemEvent(ItemEvent.ITEM_SELECT,this._shopItemInfo,0));
      }
      
      protected function __payPaneGetBtnClick(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            return;
         }
         var _loc2_:BaseAlerFrame = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("shop.view.ShopRightView.getSimpleAlert.title"),LanguageMgr.GetTranslation("shop.view.ShopRightView.getSimpleAlert.msg"),"",LanguageMgr.GetTranslation("cancel"),true,false,false,2);
         _loc2_.addEventListener(FrameEvent.RESPONSE,this.__onResponse);
         dispatchEvent(new ItemEvent(ItemEvent.ITEM_SELECT,this._shopItemInfo,0));
      }
      
      private function __onResponse(param1:FrameEvent) : void
      {
         var _loc3_:Array = null;
         var _loc4_:Array = null;
         var _loc5_:Array = null;
         var _loc6_:Array = null;
         var _loc7_:Array = null;
         var _loc8_:int = 0;
         SoundManager.instance.play("008");
         var _loc2_:BaseAlerFrame = param1.target as BaseAlerFrame;
         _loc2_.removeEventListener(FrameEvent.RESPONSE,this.__onResponse);
         _loc2_.dispose();
         if(param1.responseCode == FrameEvent.ENTER_CLICK || param1.responseCode == FrameEvent.SUBMIT_CLICK)
         {
            _loc3_ = new Array();
            _loc4_ = new Array();
            _loc5_ = new Array();
            _loc6_ = new Array();
            _loc7_ = new Array();
            _loc8_ = 0;
            while(_loc8_ < 1)
            {
               _loc3_.push(this._shopItemInfo.GoodsID);
               _loc4_.push(1);
               _loc5_.push("");
               _loc6_.push("");
               _loc7_.push("");
               _loc8_++;
            }
            SocketManager.Instance.out.sendBuyGoods(_loc3_,_loc4_,_loc5_,_loc7_,_loc6_);
         }
      }
      
      protected function __itemClick(param1:MouseEvent) : void
      {
         if(!this._shopItemInfo)
         {
            return;
         }
         if(PlayerManager.Instance.Self.Grade < this._shopItemInfo.LimitGrade)
         {
            return;
         }
         SoundManager.instance.play("008");
         if(this._shopItemInfo.LimitCount == 0)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("shop.ShopIIModel.countOver"));
            return;
         }
         dispatchEvent(new ItemEvent(ItemEvent.ITEM_CLICK,this._shopItemInfo,1));
      }
      
      protected function __itemMouseOver(param1:MouseEvent) : void
      {
         if(!this._itemCell.info)
         {
            return;
         }
         if(this._lightMc)
         {
            addChild(this._lightMc);
         }
         parent.addChild(this);
         this._isMouseOver = true;
         this._timeline.play();
      }
      
      protected function __itemMouseOut(param1:MouseEvent) : void
      {
         ObjectUtils.disposeObject(this._lightMc);
         if(!this._shopItemInfo)
         {
            return;
         }
         this._isMouseOver = false;
         this.__timelineComplete();
      }
      
      public function setItemLight(param1:MovieClip) : void
      {
         if(this._lightMc == param1)
         {
            return;
         }
         this._lightMc = param1;
         this._lightMc.mouseChildren = false;
         this._lightMc.mouseEnabled = false;
         this._lightMc.gotoAndPlay(1);
      }
      
      protected function __timelineComplete(param1:TweenEvent = null) : void
      {
         if(this._timeline.currentTime < this._timeline.totalDuration)
         {
            return;
         }
         if(this._isMouseOver)
         {
            return;
         }
         this._timeline.reverse();
      }
      
      public function ableButton() : void
      {
         this._payPaneGivingBtn.enable = true;
         this._payPaneBuyBtn.enable = true;
      }
      
      public function enableButton() : void
      {
         this._payPaneGivingBtn.enable = false;
         this._payPaneBuyBtn.enable = false;
      }
      
      public function givingDisable() : void
      {
         this._payPaneGivingBtn.enable = false;
      }
      
      private function applyGray(param1:DisplayObject) : void
      {
         var _loc2_:Array = new Array();
         _loc2_ = _loc2_.concat([0.3086,0.6094,0.082,0,0]);
         _loc2_ = _loc2_.concat([0.3086,0.6094,0.082,0,0]);
         _loc2_ = _loc2_.concat([0.3086,0.6094,0.082,0,0]);
         _loc2_ = _loc2_.concat([0,0,0,1,0]);
         var _loc3_:ColorMatrixFilter = new ColorMatrixFilter(_loc2_);
         var _loc4_:Array = new Array();
         _loc4_.push(_loc3_);
         param1.filters = _loc4_;
      }
      
      public function asDisplayObject() : DisplayObject
      {
         return this;
      }
      
      public function set autoSelect(param1:Boolean) : void
      {
      }
      
      public function get selected() : Boolean
      {
         return this._selected;
      }
      
      public function set selected(param1:Boolean) : void
      {
         if(this._selected == param1)
         {
            return;
         }
         this._selected = param1;
         this._itemBg.setFrame(!!this._selected ? int(3) : int(this.checkType()));
         this._itemCellBg.setFrame(!!this._selected ? int(3) : int(this.checkType()));
         this._itemNameTxt.setFrame(!!param1 ? int(2) : int(1));
         this._itemPriceTxt.setFrame(!!param1 ? int(2) : int(1));
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         if(this._shopItemInfo)
         {
            this._shopItemInfo.removeEventListener(Event.CHANGE,this.__updateShopItem);
         }
         ObjectUtils.disposeAllChildren(this);
         this._timeline.removeEventListener(TweenEvent.COMPLETE,this.__timelineComplete);
         this._timeline = null;
         ObjectUtils.disposeObject(this._lightMc);
         this._lightMc = null;
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
         ObjectUtils.disposeObject(this._payPaneBuyBtnHotArea);
         this._payPaneBuyBtnHotArea = null;
         ObjectUtils.disposeObject(this._itemCountTxt);
         this._itemCountTxt = null;
         ObjectUtils.disposeObject(this._itemNameTxt);
         this._itemNameTxt = null;
         ObjectUtils.disposeObject(this._itemPriceTxt);
         this._itemPriceTxt = null;
         ObjectUtils.disposeObject(this._labelIcon);
         this._labelIcon = null;
         ObjectUtils.disposeObject(this._payType);
         this._payType = null;
         ObjectUtils.disposeObject(this._itemCellBtn);
         this._itemCellBtn = null;
         ObjectUtils.disposeObject(this._shopItemInfo);
         this._shopItemInfo = null;
         ObjectUtils.disposeObject(this._payPaneGivingBtn);
         this._payPaneGivingBtn = null;
         ObjectUtils.disposeObject(this._payPaneBuyBtnHotArea);
         this._payPaneBuyBtn = null;
      }
   }
}
