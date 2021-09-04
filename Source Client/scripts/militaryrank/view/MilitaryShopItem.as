package militaryrank.view
{
   import bagAndInfo.cell.CellFactory;
   import baglocked.BaglockedManager;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.ShowTipManager;
   import com.pickgliss.ui.controls.TextButton;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.core.Component;
   import com.pickgliss.ui.image.Scale9CornerImage;
   import com.pickgliss.ui.image.ScaleBitmapImage;
   import com.pickgliss.ui.image.ScaleFrameImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import com.pickgliss.utils.StringUtils;
   import ddt.command.QuickBuyFrame;
   import ddt.data.EquipType;
   import ddt.data.goods.Price;
   import ddt.data.goods.ShopItemInfo;
   import ddt.events.ItemEvent;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
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
   import militaryrank.MilitaryRankManager;
   import militaryrank.model.MilitaryLevelModel;
   import shop.view.ShopItemCell;
   
   public class MilitaryShopItem extends Component
   {
      
      public static const PAYTYPE_MEDAL_MONEY:uint = 1;
      
      public static const PAYTYPE_MONEY:uint = 2;
      
      private static const LIMIT_LABEL:uint = 6;
       
      
      protected var _payPaneBuyBtn:TextButton;
      
      protected var _itemBg:Scale9CornerImage;
      
      protected var _itemCellBg:Scale9CornerImage;
      
      private var _shopItemCellBg:Bitmap;
      
      protected var _itemCell:ShopItemCell;
      
      protected var _itemCountTxt:FilterFrameText;
      
      protected var _itemNameTxt:FilterFrameText;
      
      protected var _warmTxt:FilterFrameText;
      
      protected var _priceTxtList:Vector.<FilterFrameText>;
      
      protected var _payTypeList:Vector.<MovieClip>;
      
      protected var _selected:Boolean;
      
      protected var _shopItemInfo:ShopItemInfo;
      
      protected var _shopItemCellTypeBg:ScaleFrameImage;
      
      protected var _dotLine:ScaleBitmapImage;
      
      protected var _buyGoodsFrame:BuyGoodsFrame;
      
      private var _goldAlertFrame:BaseAlerFrame;
      
      public function MilitaryShopItem()
      {
         super();
         this.initContent();
         this.addEvent();
      }
      
      protected function initContent() : void
      {
         var _loc1_:int = 0;
         this._itemBg = ComponentFactory.Instance.creat("militaryrank.shopView.GoodItemBg");
         this._itemCellBg = ComponentFactory.Instance.creatComponentByStylename("militaryrank.shopView.CellBg");
         this._dotLine = ComponentFactory.Instance.creatComponentByStylename("militaryrank.shopView.GoodItemDotLine");
         this._warmTxt = ComponentFactory.Instance.creat("militaryrank.shopView.warmTxt");
         this._payPaneBuyBtn = ComponentFactory.Instance.creatComponentByStylename("militaryrank.shopView.exchangeBtn");
         this._payPaneBuyBtn.text = LanguageMgr.GetTranslation("tank.littlegame.exchange");
         this._priceTxtList = new Vector.<FilterFrameText>(2);
         this._priceTxtList[0] = ComponentFactory.Instance.creat("militaryrank.shopView.exploitTxt");
         this._priceTxtList[1] = ComponentFactory.Instance.creatComponentByStylename("militaryrank.shopView.moneyTxt");
         this._itemNameTxt = ComponentFactory.Instance.creatComponentByStylename("militaryrank.shopView.nameTxt");
         this._itemCountTxt = ComponentFactory.Instance.creatComponentByStylename("ddtshop.GoodItemCount");
         this._itemCell = this.creatItemCell();
         PositionUtils.setPos(this._itemCell,"militaryrank.ShopGoodItemCellPos");
         this._shopItemCellTypeBg = ComponentFactory.Instance.creatComponentByStylename("ddtshop.ShopItemCellTypeBg");
         this._itemCellBg.setFrame(1);
         addChild(this._itemBg);
         addChild(this._itemCellBg);
         addChild(this._dotLine);
         addChild(this._itemCell);
         addChild(this._payPaneBuyBtn);
         addChild(this._warmTxt);
         addChild(this._itemNameTxt);
         addChild(this._priceTxtList[0]);
         addChild(this._priceTxtList[1]);
         addChild(this._itemCountTxt);
         this._payTypeList = new Vector.<MovieClip>(2);
         _loc1_ = 0;
         while(_loc1_ < 2)
         {
            this._payTypeList[_loc1_] = ComponentFactory.Instance.creat("militaryrank.shopView.moneyIcon" + (_loc1_ + 1));
            this._payTypeList[_loc1_].mouseChildren = false;
            this._payTypeList[_loc1_].mouseEnabled = false;
            addChild(this._payTypeList[_loc1_]);
            _loc1_++;
         }
         _width = this._itemBg.width;
         _height = this._itemBg.height;
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
         var _loc2_:MilitaryLevelModel = null;
         var _loc3_:int = 0;
         var _loc4_:Price = null;
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
            _loc2_ = MilitaryRankManager.Instance.getMilitaryRankInfo(PlayerManager.Instance.Self.MilitaryRankTotalScores);
            if(_loc2_.CurrKey < this._shopItemInfo.LimitGrade)
            {
               this._warmTxt.visible = true;
               this._warmTxt.text = LanguageMgr.GetTranslation("militaryrank.shopView.item.warmTxt",MilitaryRankManager.Instance.getMilitaryInfoByLevel(this._shopItemInfo.LimitGrade).Name);
               this._payTypeList[0].visible = false;
               this._payTypeList[1].visible = false;
               this._priceTxtList[0].visible = false;
               this._priceTxtList[1].visible = false;
               this._payPaneBuyBtn.enable = false;
            }
            else
            {
               _loc3_ = 0;
               while(_loc3_ < 2)
               {
                  _loc4_ = this._shopItemInfo.getItemPrice(0).getPrice(_loc3_);
                  this._payTypeList[_loc3_].gotoAndStop(-_loc4_.Unit);
                  if(PlayerManager.Instance.Self.getMoneyByType(_loc4_.Unit) < _loc4_.Value)
                  {
                     this._priceTxtList[_loc3_].htmlText = LanguageMgr.GetTranslation("redTxt",_loc4_.Value);
                  }
                  else
                  {
                     this._priceTxtList[_loc3_].htmlText = String(_loc4_.Value);
                  }
                  this._payTypeList[_loc3_].visible = this._priceTxtList[_loc3_].visible = _loc4_.Value != 0;
                  _loc3_++;
               }
               this._payPaneBuyBtn.enable = true;
               this._warmTxt.visible = false;
            }
            this._itemNameTxt.visible = true;
            this._itemCountTxt.visible = true;
            this._payPaneBuyBtn.visible = true;
            this._itemNameTxt.text = StringUtils.truncate(this._itemCell.info.Name,9);
            this._itemCell.tipInfo = param1;
            this.initPrice();
            if(EquipType.dressAble(this._shopItemInfo.TemplateInfo))
            {
               this._shopItemCellTypeBg.setFrame(1);
            }
            else
            {
               this._shopItemCellTypeBg.setFrame(2);
            }
            this._shopItemInfo.addEventListener(Event.CHANGE,this.__updateShopItem);
         }
         else
         {
            this._itemCellBg.setFrame(1);
            this._payTypeList[0].visible = false;
            this._payTypeList[1].visible = false;
            this._priceTxtList[0].visible = false;
            this._priceTxtList[1].visible = false;
            this._itemNameTxt.visible = false;
            this._itemCountTxt.visible = false;
            this._warmTxt.visible = false;
            this._payPaneBuyBtn.visible = false;
         }
         this.updateCount();
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
               this._priceTxtList[1].text = String(this._shopItemInfo.getItemPrice(1).moneyValue);
               break;
            case Price.OFFER:
               this._priceTxtList[1].text = String(this._shopItemInfo.getItemPrice(1).offValue);
         }
      }
      
      private function updateCount() : void
      {
         if(this._shopItemInfo)
         {
            if(this._shopItemInfo.Label && this._shopItemInfo.Label == LIMIT_LABEL)
            {
               if(this._itemBg && this._itemCountTxt)
               {
                  this._itemCountTxt.text = String(this._shopItemInfo.LimitCount);
               }
            }
            else if(this._itemBg && this._itemCountTxt)
            {
               this._itemCountTxt.visible = false;
               this._itemCountTxt.text = "0";
            }
         }
      }
      
      protected function addEvent() : void
      {
         this._payPaneBuyBtn.addEventListener(MouseEvent.CLICK,this.__payPanelClick);
      }
      
      protected function removeEvent() : void
      {
         this._payPaneBuyBtn.removeEventListener(MouseEvent.CLICK,this.__payPanelClick);
         MilitaryRankManager.Instance.removeEventListener(MilitaryRankManager.GET_RECORD,this.__getRecord);
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
         if(this._shopItemInfo == null)
         {
            return;
         }
         SoundManager.instance.play("008");
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            return;
         }
         MilitaryRankManager.Instance.addEventListener(MilitaryRankManager.GET_RECORD,this.__getRecord);
         SocketManager.Instance.out.sendAskForRankShopRecord();
      }
      
      private function __getRecord(param1:Event) : void
      {
         MilitaryRankManager.Instance.removeEventListener(MilitaryRankManager.GET_RECORD,this.__getRecord);
         if(MilitaryRankManager.Instance.getRankShopItemCount(this._shopItemInfo.ID) <= 0 && MilitaryRankManager.Instance.getRankShopItemCount(this._shopItemInfo.ID) > -1000)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("militaryrank.shop.noCount"));
            return;
         }
         this._buyGoodsFrame = ComponentFactory.Instance.creatComponentByStylename("militaryrank.view.buyGoodsFrame");
         this._buyGoodsFrame.titleText = LanguageMgr.GetTranslation("tank.view.store.matte.goldQuickBuy");
         this._buyGoodsFrame.shopItem = this._shopItemInfo;
         this._buyGoodsFrame.addEventListener(FrameEvent.RESPONSE,this.__buyGoodsFrameResponse);
         this._buyGoodsFrame.show();
      }
      
      private function doBuy() : Boolean
      {
         var _loc8_:Price = null;
         var _loc1_:int = 0;
         while(_loc1_ < 2)
         {
            _loc8_ = this._shopItemInfo.getItemPrice(0).getPrice(_loc1_);
            if(PlayerManager.Instance.Self.getMoneyByType(_loc8_.Unit) < _loc8_.Value * this._buyGoodsFrame.goodCount)
            {
               switch(_loc8_.Unit)
               {
                  case Price.MONEY:
                  case Price.DDT_MONEY:
                     MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("noMoney"));
                     break;
                  case Price.GOLD:
                     this.buyGoldFrame();
                     break;
                  case Price.ARMY_EXPLOIT:
                     MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("noExploit"));
                     break;
                  case Price.MATCH_MEDAL:
                     MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("noMatchMedal"));
               }
               return false;
            }
            this._priceTxtList[_loc1_].htmlText = String(_loc8_.Value);
            this._payTypeList[_loc1_].visible = this._priceTxtList[_loc1_].visible = true;
            _loc1_++;
         }
         var _loc2_:Array = new Array();
         var _loc3_:Array = new Array();
         var _loc4_:Array = new Array();
         var _loc5_:Array = new Array();
         var _loc6_:Array = new Array();
         var _loc7_:int = 0;
         while(_loc7_ < this._buyGoodsFrame.goodCount)
         {
            _loc2_.push(this._shopItemInfo.GoodsID);
            _loc3_.push(1);
            _loc4_.push("");
            _loc5_.push("");
            _loc6_.push("");
            _loc7_++;
         }
         SocketManager.Instance.out.sendBuyGoods(_loc2_,_loc3_,_loc4_,_loc5_,_loc6_);
         return true;
      }
      
      private function buyGoldFrame() : void
      {
         if(this._goldAlertFrame == null)
         {
            this._goldAlertFrame = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("tank.view.GoldInadequate"),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),false,false,false,LayerManager.BLCAK_BLOCKGOUND);
            this._goldAlertFrame.moveEnable = false;
            this._goldAlertFrame.addEventListener(FrameEvent.RESPONSE,this.__quickBuyResponse);
         }
      }
      
      private function __quickBuyResponse(param1:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         this._goldAlertFrame.removeEventListener(FrameEvent.RESPONSE,this.__quickBuyResponse);
         this._goldAlertFrame.dispose();
         this._goldAlertFrame = null;
         this._buyGoodsFrame.removeEventListener(FrameEvent.RESPONSE,this.__buyGoodsFrameResponse);
         ObjectUtils.disposeObject(this._buyGoodsFrame);
         this._buyGoodsFrame = null;
         if(param1.responseCode == FrameEvent.SUBMIT_CLICK || param1.responseCode == FrameEvent.ENTER_CLICK)
         {
            this.openGoldFrame();
         }
      }
      
      private function openGoldFrame() : void
      {
         var _loc1_:QuickBuyFrame = ComponentFactory.Instance.creatComponentByStylename("ddtcore.QuickFrame");
         _loc1_.itemID = EquipType.GOLD_BOX;
         _loc1_.setTitleText(LanguageMgr.GetTranslation("tank.view.store.matte.goldQuickBuy"));
         LayerManager.Instance.addToLayer(_loc1_,LayerManager.GAME_TOP_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
      }
      
      private function __buyGoodsFrameResponse(param1:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         if(param1.responseCode == FrameEvent.ENTER_CLICK || param1.responseCode == FrameEvent.SUBMIT_CLICK)
         {
            if(!this.doBuy())
            {
               return;
            }
         }
         this._buyGoodsFrame.removeEventListener(FrameEvent.RESPONSE,this.__buyGoodsFrameResponse);
         ObjectUtils.disposeObject(this._buyGoodsFrame);
         this._buyGoodsFrame = null;
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
         this._itemCellBg.setFrame(!!this._selected ? int(3) : int(this.checkType()));
         this._itemNameTxt.setFrame(!!param1 ? int(2) : int(1));
         this._payTypeList[1].setFrame(!!param1 ? 2 : 1);
      }
      
      override public function dispose() : void
      {
         super.dispose();
         this.removeEvent();
         if(this._shopItemInfo)
         {
            this._shopItemInfo.removeEventListener(Event.CHANGE,this.__updateShopItem);
         }
         ObjectUtils.disposeAllChildren(this);
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
         ObjectUtils.disposeObject(this._itemCountTxt);
         this._itemCountTxt = null;
         ObjectUtils.disposeObject(this._itemNameTxt);
         this._itemNameTxt = null;
         ObjectUtils.disposeObject(this._warmTxt);
         this._warmTxt = null;
         ObjectUtils.disposeObject(this._payTypeList[0]);
         this._payTypeList[0] = null;
         ObjectUtils.disposeObject(this._payTypeList[1]);
         this._payTypeList[1] = null;
         this._payTypeList.length = 0;
         this._payTypeList = null;
         ObjectUtils.disposeObject(this._priceTxtList[0]);
         this._priceTxtList[0] = null;
         ObjectUtils.disposeObject(this._priceTxtList[1]);
         this._priceTxtList[1] = null;
         this._priceTxtList.length = 0;
         this._priceTxtList = null;
         ObjectUtils.disposeObject(this._shopItemInfo);
         this._shopItemInfo = null;
         ObjectUtils.disposeObject(this._payPaneBuyBtn);
         this._payPaneBuyBtn = null;
      }
   }
}
