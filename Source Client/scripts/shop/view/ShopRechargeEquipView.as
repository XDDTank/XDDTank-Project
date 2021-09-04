package shop.view
{
   import baglocked.BaglockedManager;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.controls.ScrollPanel;
   import com.pickgliss.ui.controls.TextButton;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.controls.container.VBox;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.Image;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.ui.vo.AlertInfo;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.data.goods.ItemPrice;
   import ddt.data.goods.ShopCarItemInfo;
   import ddt.events.PlayerPropertyEvent;
   import ddt.manager.LanguageMgr;
   import ddt.manager.LeavePageManager;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.ShopManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class ShopRechargeEquipView extends Sprite implements Disposeable
   {
       
      
      private var price:ItemPrice;
      
      private var _bg:Image;
      
      private var _frame:BaseAlerFrame;
      
      private var _chargeBtn:TextButton;
      
      private var _itemContainer:VBox;
      
      private var _scrollPanel:ScrollPanel;
      
      private var _equipList:Array;
      
      private var _costMoneyTxt:FilterFrameText;
      
      private var _costGiftTxt:FilterFrameText;
      
      private var _playerMoneyTxt:FilterFrameText;
      
      private var _playerGiftTxt:FilterFrameText;
      
      private var _currentCountTxt:FilterFrameText;
      
      private var _affirmContinuBt:BaseButton;
      
      private var theDifferenceOfmoneyValuAndDDTMoney:int;
      
      private var _needToPayPanelBg:Bitmap;
      
      private var _haveOwnPanelBg:Bitmap;
      
      private var _amountOfItemTipText:FilterFrameText;
      
      public function ShopRechargeEquipView()
      {
         super();
         this.init();
      }
      
      private function init() : void
      {
         this._frame = ComponentFactory.Instance.creatComponentByStylename("ddtshop.RechargeViewFrame");
         this._bg = ComponentFactory.Instance.creatComponentByStylename("ddtshop.RechargeViewFrameBg");
         this._needToPayPanelBg = ComponentFactory.Instance.creatBitmap("ddtshop.RechargeView.NeedToPayPanelBg");
         this._haveOwnPanelBg = ComponentFactory.Instance.creatBitmap("ddtshop.RechargeView.HaveOwnPanelBg");
         this._amountOfItemTipText = ComponentFactory.Instance.creatComponentByStylename("ddtshop.RechargeView.AmountOfItemTipText");
         this._amountOfItemTipText.text = LanguageMgr.GetTranslation("shop.RechargeView.AmountOfItemTipText");
         this._chargeBtn = ComponentFactory.Instance.creatComponentByStylename("ddtshop.RechargeView.RechargeBtn");
         this._chargeBtn.text = LanguageMgr.GetTranslation("shop.RechargeView.RechargeBtnText");
         this._scrollPanel = ComponentFactory.Instance.creatComponentByStylename("ddtshop.RechargeViewItemList");
         this._itemContainer = ComponentFactory.Instance.creatComponentByStylename("ddtshop.CartItemContainer");
         this._costMoneyTxt = ComponentFactory.Instance.creatComponentByStylename("ddtshop.RechargeView.LeftTicketNumberText");
         this._costGiftTxt = ComponentFactory.Instance.creatComponentByStylename("ddtshop.RechargeView.LeftGiftNumberText");
         this._playerMoneyTxt = ComponentFactory.Instance.creatComponentByStylename("ddtshop.RechargeView.RightTicketNumberText");
         this._playerGiftTxt = ComponentFactory.Instance.creatComponentByStylename("ddtshop.RechargeView.RightGiftNumberText");
         this._currentCountTxt = ComponentFactory.Instance.creatComponentByStylename("ddtshop.RechargeViewCurrentCount");
         this._affirmContinuBt = ComponentFactory.Instance.creatComponentByStylename("ddtshop.RechargeView.RechargeConfirmationBtn");
         var _loc1_:AlertInfo = new AlertInfo(LanguageMgr.GetTranslation("tank.view.continuation.contiuationTitle"),LanguageMgr.GetTranslation("tank.view.common.AddPricePanel.xu"),LanguageMgr.GetTranslation("cancel"),false,false);
         this._frame.info = _loc1_;
         this._equipList = PlayerManager.Instance.Self.OvertimeListByBody;
         this._scrollPanel.vScrollProxy = ScrollPanel.ON;
         this._scrollPanel.setView(this._itemContainer);
         this._itemContainer.spacing = 5;
         this._itemContainer.strictSize = 80;
         this._scrollPanel.invalidateViewport();
         this._frame.moveEnable = false;
         this._frame.addToContent(this._bg);
         this._frame.addToContent(this._needToPayPanelBg);
         this._frame.addToContent(this._haveOwnPanelBg);
         this._frame.addToContent(this._amountOfItemTipText);
         this._frame.addToContent(this._chargeBtn);
         this._frame.addToContent(this._scrollPanel);
         this._frame.addToContent(this._costMoneyTxt);
         this._frame.addToContent(this._costGiftTxt);
         this._frame.addToContent(this._playerMoneyTxt);
         this._frame.addToContent(this._playerGiftTxt);
         this._frame.addToContent(this._currentCountTxt);
         this._frame.addToContent(this._affirmContinuBt);
         this.setList();
         this.__onPlayerPropertyChange();
         this._chargeBtn.addEventListener(MouseEvent.CLICK,this.__onChargeClick);
         this._frame.addEventListener(FrameEvent.RESPONSE,this.__frameEventHandler);
         this._affirmContinuBt.addEventListener(MouseEvent.CLICK,this._clickContinuBt);
         addChild(this._frame);
      }
      
      private function __frameEventHandler(param1:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         switch(param1.responseCode)
         {
            case FrameEvent.SUBMIT_CLICK:
               if(PlayerManager.Instance.Self.bagLocked)
               {
                  BaglockedManager.Instance.show();
               }
               else
               {
                  this.payAll();
               }
               break;
            case FrameEvent.CANCEL_CLICK:
            case FrameEvent.CLOSE_CLICK:
            case FrameEvent.ESC_CLICK:
               InventoryItemInfo.startTimer();
               this.dispose();
         }
      }
      
      private function _clickContinuBt(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
         }
         else
         {
            this.payAll();
         }
      }
      
      private function __onChargeClick(param1:Event) : void
      {
         LeavePageManager.leaveToFillPath();
      }
      
      private function payAll() : void
      {
         var _loc3_:Array = null;
         var _loc4_:Array = null;
         var _loc5_:Array = null;
         var _loc6_:ShopCarItemInfo = null;
         var _loc7_:ShopRechargeEquipViewItem = null;
         var _loc8_:int = 0;
         var _loc9_:uint = 0;
         var _loc10_:ShopRechargeEquipViewItem = null;
         var _loc11_:Boolean = false;
         var _loc1_:Array = this.shopInfoList;
         var _loc2_:Array = this.shopInfoListWithOutDelete;
         if(_loc2_.length > 0)
         {
            _loc3_ = new Array();
            _loc4_ = new Array();
            _loc5_ = new Array();
            for each(_loc6_ in _loc2_)
            {
               _loc9_ = _loc1_.indexOf(_loc6_);
               _loc10_ = this._itemContainer.getChildAt(_loc9_) as ShopRechargeEquipViewItem;
               _loc4_.push(_loc10_.info);
               _loc5_.push(_loc10_);
            }
            for each(_loc7_ in _loc5_)
            {
               this._itemContainer.removeChild(_loc7_);
            }
            this._scrollPanel.invalidateViewport();
            _loc8_ = 0;
            while(_loc8_ < _loc2_.length)
            {
               _loc11_ = _loc4_[_loc8_].Place <= 30;
               _loc3_.push([_loc4_[_loc8_].BagType,_loc4_[_loc8_].Place,_loc2_[_loc8_].GoodsID,_loc2_[_loc8_].currentBuyType,_loc11_]);
               _loc8_++;
            }
            this.updateTxt();
            SocketManager.Instance.out.sendGoodsContinue(_loc3_);
            if(this._itemContainer.numChildren <= 0)
            {
               this.dispose();
            }
            else if(this.shopInfoListWithOutDelete.length > 0)
            {
               this.showAlert();
            }
         }
         else if(this.shopInfoListWithOutDelete.length != 0)
         {
            this.showAlert();
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.view.continuation.contiuationFailed"));
         }
      }
      
      private function setList() : void
      {
         var i:InventoryItemInfo = null;
         var item:ShopRechargeEquipViewItem = null;
         this._equipList.sort(function(param1:InventoryItemInfo, param2:InventoryItemInfo):Number
         {
            var _loc3_:Array = [7,5,1,17,8,9,14,6,13,15,3,4,2];
            var _loc4_:uint = _loc3_.indexOf(param1.CategoryID);
            var _loc5_:uint = _loc3_.indexOf(param2.CategoryID);
            if(_loc4_ < _loc5_)
            {
               return -1;
            }
            if(_loc4_ == _loc5_)
            {
               return 0;
            }
            return 1;
         });
         for each(i in this._equipList)
         {
            if(ShopManager.Instance.canAddPrice(i.TemplateID))
            {
               item = new ShopRechargeEquipViewItem();
               item.itemInfo = i;
               item.setColor(i.Color);
               item.addEventListener(ShopCartItem.DELETE_ITEM,this.__onItemDelete);
               item.addEventListener(ShopCartItem.CONDITION_CHANGE,this.__onItemChange);
               this._itemContainer.addChild(item);
            }
         }
         this._scrollPanel.invalidateViewport();
         this.updateTxt();
      }
      
      private function __onItemDelete(param1:Event) : void
      {
         var _loc2_:ShopRechargeEquipViewItem = param1.currentTarget as ShopRechargeEquipViewItem;
         _loc2_.removeEventListener(ShopCartItem.DELETE_ITEM,this.__onItemDelete);
         _loc2_.removeEventListener(ShopCartItem.CONDITION_CHANGE,this.__onItemChange);
         this._itemContainer.removeChild(_loc2_);
         this.updateTxt();
         this._scrollPanel.invalidateViewport();
      }
      
      private function __onItemChange(param1:Event) : void
      {
         this.updateTxt();
      }
      
      private function get shopInfoListWithOutDelete() : Array
      {
         var _loc3_:ShopRechargeEquipViewItem = null;
         var _loc1_:Array = new Array();
         var _loc2_:uint = 0;
         while(_loc2_ < this._itemContainer.numChildren)
         {
            _loc3_ = this._itemContainer.getChildAt(_loc2_) as ShopRechargeEquipViewItem;
            if(_loc3_ && !_loc3_.isDelete)
            {
               _loc1_.push(_loc3_.shopItemInfo);
            }
            _loc2_++;
         }
         return _loc1_;
      }
      
      private function get shopInfoList() : Array
      {
         var _loc3_:ShopRechargeEquipViewItem = null;
         var _loc1_:Array = new Array();
         var _loc2_:uint = 0;
         while(_loc2_ < this._itemContainer.numChildren)
         {
            _loc3_ = this._itemContainer.getChildAt(_loc2_) as ShopRechargeEquipViewItem;
            _loc1_.push(_loc3_.shopItemInfo);
            _loc2_++;
         }
         return _loc1_;
      }
      
      private function updateTxt() : void
      {
         var _loc3_:ShopCarItemInfo = null;
         var _loc1_:Array = this.shopInfoListWithOutDelete;
         var _loc2_:uint = _loc1_.length;
         this._currentCountTxt.text = String(_loc2_);
         if(_loc2_ == 0)
         {
            this._affirmContinuBt.enable = false;
         }
         else
         {
            this._affirmContinuBt.enable = true;
         }
         this._frame.submitButtonEnable = _loc2_ <= 0 ? Boolean(false) : Boolean(true);
         this.price = new ItemPrice(null,null,null);
         for each(_loc3_ in _loc1_)
         {
            this.price.addItemPrice(_loc3_.getCurrentPrice());
         }
         this.theDifferenceOfmoneyValuAndDDTMoney = this.price.moneyValue - PlayerManager.Instance.Self.DDTMoney;
         if(this.theDifferenceOfmoneyValuAndDDTMoney >= 0)
         {
            this._costMoneyTxt.text = String(this.theDifferenceOfmoneyValuAndDDTMoney);
            this._costGiftTxt.text = String(PlayerManager.Instance.Self.DDTMoney);
         }
         else
         {
            this._costMoneyTxt.text = String(0);
            this._costGiftTxt.text = String(this.price.moneyValue);
         }
         this.updataTextColor();
         PlayerManager.Instance.Self.addEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,this.__onPlayerPropertyChange,false,0,true);
      }
      
      private function __onPlayerPropertyChange(param1:Event = null) : void
      {
         this._playerMoneyTxt.text = String(PlayerManager.Instance.Self.Money);
         this._playerGiftTxt.text = String(PlayerManager.Instance.Self.DDTMoney);
         this.updataTextColor();
      }
      
      private function updataTextColor() : void
      {
         if(this.price)
         {
            if(this.price.moneyValue > PlayerManager.Instance.Self.Money)
            {
               this._costMoneyTxt.setTextFormat(ComponentFactory.Instance.model.getSet("ddtshop.DigitWarningTF"));
            }
            else
            {
               this._costMoneyTxt.setTextFormat(ComponentFactory.Instance.model.getSet("ddtshop.RechargeView.NumberTextTF"));
            }
            if(this.price.ddtMoneyValue > PlayerManager.Instance.Self.DDTMoney)
            {
               this._costGiftTxt.setTextFormat(ComponentFactory.Instance.model.getSet("ddtshop.DigitWarningTF"));
            }
            else
            {
               this._costGiftTxt.setTextFormat(ComponentFactory.Instance.model.getSet("ddtshop.RechargeView.NumberTextTF"));
            }
         }
      }
      
      private function showAlert() : void
      {
         var _loc1_:BaseAlerFrame = null;
         if(this.price.moneyValue > PlayerManager.Instance.Self.totalMoney)
         {
            _loc1_ = LeavePageManager.showFillFrame();
         }
         else if(this.price.ddtMoneyValue > PlayerManager.Instance.Self.DDTMoney)
         {
            _loc1_ = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("store.view.transfer.StoreIITransferBG.lijinbuzu"),LanguageMgr.GetTranslation("ok"),"",true,false,false,LayerManager.ALPHA_BLOCKGOUND);
         }
      }
      
      public function dispose() : void
      {
         InventoryItemInfo.startTimer();
         PlayerManager.Instance.Self.removeEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,this.__onPlayerPropertyChange);
         this._frame.removeEventListener(FrameEvent.RESPONSE,this.__frameEventHandler);
         this._chargeBtn.removeEventListener(MouseEvent.CLICK,this.__onChargeClick);
         this._affirmContinuBt.removeEventListener(MouseEvent.CLICK,this._clickContinuBt);
         this._frame.dispose();
         this._frame = null;
         this.price = null;
         this._bg = null;
         ObjectUtils.disposeObject(this._amountOfItemTipText);
         this._amountOfItemTipText = null;
         ObjectUtils.disposeObject(this._needToPayPanelBg);
         this._needToPayPanelBg = null;
         ObjectUtils.disposeObject(this._haveOwnPanelBg);
         this._haveOwnPanelBg = null;
         this._chargeBtn = null;
         this._itemContainer = null;
         this._scrollPanel = null;
         this._equipList = null;
         this._costMoneyTxt = null;
         this._costGiftTxt = null;
         this._playerMoneyTxt = null;
         this._playerGiftTxt = null;
         this._currentCountTxt = null;
         this._affirmContinuBt = null;
         if(parent)
         {
            parent.removeChild(this);
         }
      }
   }
}
