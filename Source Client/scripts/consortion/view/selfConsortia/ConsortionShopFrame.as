package consortion.view.selfConsortia
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.ui.controls.SelectedButtonGroup;
   import com.pickgliss.ui.controls.SelectedTextButton;
   import com.pickgliss.ui.image.Scale9CornerImage;
   import com.pickgliss.ui.image.ScaleBitmapImage;
   import com.pickgliss.ui.image.ScaleFrameImage;
   import com.pickgliss.ui.image.ScaleLeftRightImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import consortion.ConosrtionTimerManager;
   import consortion.ConsortionModelControl;
   import consortion.consortionsence.ConsortionManager;
   import consortion.data.ConsortiaAssetLevelOffer;
   import consortion.event.ConsortionEvent;
   import ddt.data.goods.ShopItemInfo;
   import ddt.events.PlayerPropertyEvent;
   import ddt.events.TimeEvents;
   import ddt.manager.LanguageMgr;
   import ddt.manager.PlayerManager;
   import ddt.manager.ShopManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.manager.TimeManager;
   import ddt.utils.PositionUtils;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class ConsortionShopFrame extends Frame
   {
      
      private static const SHOP_ITEM_NUM:uint = 9;
      
      private static var CURRENT_PAGE:int = 1;
      
      private static var CONSORTION_SHOP_TYPE:int = 10;
      
      private static var ConsoRTION_MYSTERY_SHOP_TYPE:int = 11;
       
      
      private var _bg:ScaleFrameImage;
      
      private var _pageBg:Scale9CornerImage;
      
      private var _scrollbg:ScaleBitmapImage;
      
      private var _ttoffer:FilterFrameText;
      
      private var _shop1:SelectedTextButton;
      
      private var _shop2:SelectedTextButton;
      
      private var _btnGroup:SelectedButtonGroup;
      
      private var _word:FilterFrameText;
      
      private var _goodItems:Vector.<ConsortionShopItem>;
      
      private var _goodItemContainerAll:Sprite;
      
      private var _firstPage:BaseButton;
      
      private var _prePageBtn:BaseButton;
      
      private var _nextPageBtn:BaseButton;
      
      private var _endPageBtn:BaseButton;
      
      private var _pagebg:ScaleLeftRightImage;
      
      private var _page:FilterFrameText;
      
      private var _richesTxt:Bitmap;
      
      private var _shopType:int;
      
      private var _titleTxt:FilterFrameText;
      
      private var _timerTxt:FilterFrameText;
      
      public function ConsortionShopFrame()
      {
         super();
         this.initView();
         this.initEvent();
      }
      
      private function initView() : void
      {
         var _loc1_:int = 0;
         var _loc2_:Number = NaN;
         var _loc3_:Number = NaN;
         escEnable = true;
         disposeChildren = true;
         titleText = LanguageMgr.GetTranslation("tank.consortia.consortiashop.ConsortiaShopView.titleText") + PlayerManager.Instance.Self.consortiaInfo.ShopLevel + "级";
         this._bg = ComponentFactory.Instance.creatComponentByStylename("ddtconsortionshop.ItemBg");
         this._pageBg = ComponentFactory.Instance.creatComponentByStylename("ddtconsortionPageBg");
         this._scrollbg = ComponentFactory.Instance.creatComponentByStylename("consortion.shopItem.scallBG");
         this._ttoffer = ComponentFactory.Instance.creatComponentByStylename("consortion.shop.ttoffer");
         this._shop1 = ComponentFactory.Instance.creatComponentByStylename("consortion.shop.level1");
         this._shop1.text = LanguageMgr.GetTranslation("ddt.consortion.consortionShopLevel1");
         this._shop2 = ComponentFactory.Instance.creatComponentByStylename("consortion.shop.level2");
         this._shop2.text = LanguageMgr.GetTranslation("ddt.consortion.consortionShopLevel2");
         this._shop2.tipStyle = "ddt.view.tips.OneLineTip";
         this._shop2.tipDirctions = "0,1,2";
         this._shop2.tipData = LanguageMgr.GetTranslation("ddt.consortion.consortionUpdateTimer");
         this._btnGroup = new SelectedButtonGroup();
         this._word = ComponentFactory.Instance.creatComponentByStylename("consortion.shop.word");
         this._word.text = LanguageMgr.GetTranslation("consortion.shop.word.text");
         this._btnGroup.addSelectItem(this._shop1);
         this._btnGroup.addSelectItem(this._shop2);
         this._btnGroup.selectIndex = 0;
         this._richesTxt = ComponentFactory.Instance.creatBitmap("consortion.skillFrame.richesBg");
         this._ttoffer.text = String(PlayerManager.Instance.Self.RichesOffer);
         PositionUtils.setPos(this._richesTxt,"asset.consrotionShop.pos3");
         this._goodItems = new Vector.<ConsortionShopItem>();
         this._goodItemContainerAll = ComponentFactory.Instance.creatCustomObject("ddtConsortionshop.GoodItemContainerAll");
         _loc1_ = 0;
         while(_loc1_ < SHOP_ITEM_NUM)
         {
            this._goodItems[_loc1_] = ComponentFactory.Instance.creatCustomObject("ddtConsortionshop.GoodItem");
            _loc2_ = this._goodItems[_loc1_].width + 5;
            _loc3_ = this._goodItems[_loc1_].height + 2;
            _loc2_ *= int(_loc1_ % 3);
            _loc3_ *= int(_loc1_ / 3);
            this._goodItems[_loc1_].x = _loc2_;
            this._goodItems[_loc1_].y = _loc3_ + _loc1_ / 3 * 3;
            this._goodItemContainerAll.addChild(this._goodItems[_loc1_]);
            _loc1_++;
         }
         this._firstPage = ComponentFactory.Instance.creatComponentByStylename("ddtconsortionshop.BtnFirstPage");
         this._prePageBtn = ComponentFactory.Instance.creatComponentByStylename("ddtconsortionshop.BtnPrePage");
         this._nextPageBtn = ComponentFactory.Instance.creatComponentByStylename("ddtconsortionshop.BtnNextPage");
         this._endPageBtn = ComponentFactory.Instance.creatComponentByStylename("ddtconsortionshop.BtnEndPage");
         this._pagebg = ComponentFactory.Instance.creat("consortion.takeIn.pageBgI");
         PositionUtils.setPos(this._pagebg,"asset.consrotionShop.pos");
         this._page = ComponentFactory.Instance.creatComponentByStylename("consortion.takeInItem.turnPage.page");
         PositionUtils.setPos(this._page,"asset.consrotionShop.pos1");
         this._titleTxt = ComponentFactory.Instance.creatComponentByStylename("Consorionshop.titleText");
         this._titleTxt.htmlText = LanguageMgr.GetTranslation("ddtconsortion.shop.titleTxt",4);
         this._timerTxt = ComponentFactory.Instance.creatComponentByStylename("Consorionshop.timerTxt");
         this._timerTxt.setFrame(1);
         addToContent(this._bg);
         addToContent(this._richesTxt);
         addToContent(this._ttoffer);
         addToContent(this._pageBg);
         addToContent(this._shop1);
         addToContent(this._shop2);
         addToContent(this._word);
         addToContent(this._goodItemContainerAll);
         addToContent(this._firstPage);
         addToContent(this._prePageBtn);
         addToContent(this._nextPageBtn);
         addToContent(this._endPageBtn);
         addToContent(this._pagebg);
         addToContent(this._page);
         addToContent(this._titleTxt);
         addToContent(this._timerTxt);
         this._titleTxt.visible = false;
         this._shopType = CONSORTION_SHOP_TYPE;
         ConsortionManager.Instance.buyType = CONSORTION_SHOP_TYPE;
         this.setList(ShopManager.Instance.consortiaShopIdTemplates(this._shopType));
      }
      
      private function initEvent() : void
      {
         addEventListener(FrameEvent.RESPONSE,this.__responseHandler);
         this._btnGroup.addEventListener(Event.CHANGE,this.__groupChange);
         ConsortionModelControl.Instance.model.addEventListener(ConsortionEvent.USE_CONDITION_CHANGE,this.__useChangeHandler);
         ConsortionModelControl.Instance.model.addEventListener(ConsortionEvent.REFRESH_GOOD,this.__refreshGood);
         PlayerManager.Instance.Self.addEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,this.__propChangeHandler);
         this._firstPage.addEventListener(MouseEvent.CLICK,this.__pageBtnClick);
         this._prePageBtn.addEventListener(MouseEvent.CLICK,this.__pageBtnClick);
         this._nextPageBtn.addEventListener(MouseEvent.CLICK,this.__pageBtnClick);
         this._endPageBtn.addEventListener(MouseEvent.CLICK,this.__pageBtnClick);
         TimeManager.addEventListener(TimeEvents.SECONDS,this.__upTimer);
      }
      
      protected function __useChangeHandler(param1:Event) : void
      {
      }
      
      private function __refreshGood(param1:ConsortionEvent) : void
      {
         this.setList(ConosrtionTimerManager.Instance.ConsotionShopGoods);
      }
      
      private function removeEvent() : void
      {
         removeEventListener(FrameEvent.RESPONSE,this.__responseHandler);
         this._btnGroup.removeEventListener(Event.CHANGE,this.__groupChange);
         ConsortionModelControl.Instance.model.removeEventListener(ConsortionEvent.USE_CONDITION_CHANGE,this.__useChangeHandler);
         ConsortionModelControl.Instance.model.removeEventListener(ConsortionEvent.REFRESH_GOOD,this.__refreshGood);
         PlayerManager.Instance.Self.removeEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,this.__propChangeHandler);
         this._firstPage.removeEventListener(MouseEvent.CLICK,this.__pageBtnClick);
         this._prePageBtn.removeEventListener(MouseEvent.CLICK,this.__pageBtnClick);
         this._nextPageBtn.removeEventListener(MouseEvent.CLICK,this.__pageBtnClick);
         this._endPageBtn.removeEventListener(MouseEvent.CLICK,this.__pageBtnClick);
         TimeManager.removeEventListener(TimeEvents.SECONDS,this.__upTimer);
      }
      
      private function __propChangeHandler(param1:PlayerPropertyEvent) : void
      {
         if(param1.changedProperties["RichesRob"] || param1.changedProperties["RichesOffer"])
         {
            this._ttoffer.text = String(PlayerManager.Instance.Self.RichesOffer);
         }
      }
      
      private function __pageBtnClick(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         switch(param1.currentTarget)
         {
            case this._firstPage:
               if(CURRENT_PAGE != 1)
               {
                  CURRENT_PAGE = 1;
               }
               break;
            case this._prePageBtn:
               if(CURRENT_PAGE == 1)
               {
                  CURRENT_PAGE = ShopManager.Instance.getConsortionResultPages(this._shopType,SHOP_ITEM_NUM) + 1;
               }
               --CURRENT_PAGE;
               break;
            case this._nextPageBtn:
               if(CURRENT_PAGE == ShopManager.Instance.getConsortionResultPages(this._shopType,SHOP_ITEM_NUM))
               {
                  CURRENT_PAGE = 0;
               }
               ++CURRENT_PAGE;
               break;
            case this._endPageBtn:
               if(CURRENT_PAGE != ShopManager.Instance.getConsortionResultPages(this._shopType,SHOP_ITEM_NUM))
               {
                  CURRENT_PAGE = ShopManager.Instance.getConsortionResultPages(this._shopType,SHOP_ITEM_NUM);
               }
         }
         this.loadlist();
      }
      
      private function loadlist() : void
      {
         this.setList(ShopManager.Instance.getConsortionSortedGoodsByType(this._shopType,CURRENT_PAGE));
      }
      
      private function setList(param1:Vector.<ShopItemInfo>) : void
      {
         var _loc4_:int = 0;
         this.clearItems();
         var _loc2_:int = 0;
         while(_loc2_ < SHOP_ITEM_NUM)
         {
            if(_loc2_ < param1.length && param1[_loc2_])
            {
               this._goodItems[_loc2_].shopItemInfo = param1[_loc2_];
            }
            _loc2_++;
         }
         if(this._btnGroup.selectIndex + 1 == 1)
         {
            this._bg.setFrame(1);
         }
         else
         {
            this._bg.setFrame(2);
         }
         var _loc3_:Vector.<ConsortiaAssetLevelOffer> = ConsortionModelControl.Instance.model.useConditionList;
         this._page.text = CURRENT_PAGE + "/" + ShopManager.Instance.getConsortionResultPages(this._shopType,SHOP_ITEM_NUM);
      }
      
      private function __responseHandler(param1:FrameEvent) : void
      {
         if(param1.responseCode == FrameEvent.CLOSE_CLICK || param1.responseCode == FrameEvent.ESC_CLICK)
         {
            SoundManager.instance.play("008");
            this.dispose();
         }
      }
      
      private function __groupChange(param1:Event) : void
      {
         SoundManager.instance.play("008");
         if(this._btnGroup.selectIndex == 0)
         {
            this._shopType = CONSORTION_SHOP_TYPE;
            this._timerTxt.x = 260;
            this._timerTxt.y = 62;
            this._timerTxt.setFrame(1);
            CURRENT_PAGE = 1;
            this.setVible(true);
            ConsortionManager.Instance.buyType = CONSORTION_SHOP_TYPE;
            this.setList(ShopManager.Instance.consortiaShopIdTemplates(this._shopType));
         }
         else
         {
            this._shopType = ConsoRTION_MYSTERY_SHOP_TYPE;
            this._timerTxt.x = 254;
            this._timerTxt.y = 64;
            this._timerTxt.setFrame(2);
            this.setVible(false);
            ConsortionManager.Instance.buyType = ConsoRTION_MYSTERY_SHOP_TYPE;
            this.setList(ConosrtionTimerManager.Instance.ConsotionShopGoods);
         }
      }
      
      private function setVible(param1:Boolean) : void
      {
         this._prePageBtn.visible = param1;
         this._nextPageBtn.visible = param1;
         this._pagebg.visible = param1;
         this._endPageBtn.visible = param1;
         this._firstPage.visible = param1;
         this._page.visible = param1;
         this._titleTxt.visible = !param1;
      }
      
      private function __managerClickHandler(param1:MouseEvent) : void
      {
         ConsortionModelControl.Instance.alertManagerFrame();
      }
      
      private function __upTimer(param1:TimeEvents) : void
      {
         var _loc2_:uint = TimeManager.Instance.Now().getTime();
         var _loc3_:uint = ConosrtionTimerManager.Instance.NextTimer;
         var _loc4_:String = TimeManager.Instance.formatTimeToString1(_loc3_ - _loc2_);
         var _loc5_:uint = _loc3_ - _loc2_;
         this._timerTxt.text = _loc4_;
         if(_loc2_ == _loc3_ || _loc5_ <= 0)
         {
            SocketManager.Instance.out.sendShopRefreshGood();
         }
      }
      
      private function clearItems() : void
      {
         var _loc1_:int = 0;
         while(_loc1_ < SHOP_ITEM_NUM)
         {
            this._goodItems[_loc1_].shopItemInfo = null;
            _loc1_++;
         }
      }
      
      override public function dispose() : void
      {
         this.removeEvent();
         super.dispose();
         this._bg = null;
         this._scrollbg = null;
         this._ttoffer = null;
         this._pageBg = null;
         this._shop1 = null;
         this._shop2 = null;
         this._word = null;
         this._goodItemContainerAll = null;
         this._timerTxt = null;
         if(this.parent)
         {
            this.parent.removeChild(this);
         }
      }
   }
}
