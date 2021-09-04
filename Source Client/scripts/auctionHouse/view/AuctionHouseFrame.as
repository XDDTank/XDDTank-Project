package auctionHouse.view
{
   import auctionHouse.AuctionState;
   import auctionHouse.controller.AuctionHouseController;
   import auctionHouse.event.AuctionHouseEvent;
   import auctionHouse.model.AuctionHouseModel;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.ui.controls.SelectedButtonGroup;
   import com.pickgliss.ui.controls.SelectedTextButton;
   import com.pickgliss.ui.image.ScaleBitmapImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.auctionHouse.AuctionGoodsInfo;
   import ddt.events.PlayerPropertyEvent;
   import ddt.manager.LanguageMgr;
   import ddt.manager.PlayerManager;
   import ddt.manager.SharedManager;
   import ddt.manager.SoundManager;
   import ddt.manager.StateManager;
   import ddt.states.StateType;
   import ddt.utils.PositionUtils;
   import flash.display.Bitmap;
   import flash.events.MouseEvent;
   import road7th.data.DictionaryEvent;
   
   public class AuctionHouseFrame extends Frame
   {
       
      
      private var _titleBg:Bitmap;
      
      private var _model:AuctionHouseModel;
      
      private var _controller:AuctionHouseController;
      
      private var _titleBroweBtn:SelectedTextButton;
      
      private var _titleSellBtn:SelectedTextButton;
      
      private var _titleBuyBtn:SelectedTextButton;
      
      private var _btnGroup:SelectedButtonGroup;
      
      private var _tabLine:ScaleBitmapImage;
      
      private var _isInit:Boolean;
      
      private var _browse:AuctionBrowseView;
      
      private var _buy:AuctionBuyView;
      
      private var _sell:AuctionSellView;
      
      private var _notesButton:BaseButton;
      
      private var _browse_btn:BaseButton;
      
      private var _buy_btn:BaseButton;
      
      private var _sell_btn:BaseButton;
      
      private var _money:FilterFrameText;
      
      private var moneyBG:Bitmap;
      
      private var moneyInfoBG:ScaleBitmapImage;
      
      private var _moneyBitmap:Bitmap;
      
      private var _explainTxt:FilterFrameText;
      
      public function AuctionHouseFrame(param1:AuctionHouseController, param2:AuctionHouseModel)
      {
         super();
         StateManager.currentStateType = StateType.AUCTION;
         this._model = param2;
         this._controller = param1;
         this.initView();
         this.addEvent();
      }
      
      private function initView() : void
      {
         escEnable = true;
         this._titleBg = ComponentFactory.Instance.creatBitmap("asset.auction.title");
         addToContent(this._titleBg);
         this._titleBroweBtn = ComponentFactory.Instance.creatComponentByStylename("asset.ddtauctionHouse.TitleAsset");
         this._titleBroweBtn.text = LanguageMgr.GetTranslation("tank.ddtauctionHouse.view.serchText");
         addToContent(this._titleBroweBtn);
         this._titleSellBtn = ComponentFactory.Instance.creatComponentByStylename("asset.ddtauctionHouse.TitleSellAsset");
         this._titleSellBtn.text = LanguageMgr.GetTranslation("tank.ddtauctionHouse.view.text");
         addToContent(this._titleSellBtn);
         this._titleBuyBtn = ComponentFactory.Instance.creatComponentByStylename("asset.ddtauctionHouse.TitleBuyAsset");
         this._titleBuyBtn.text = LanguageMgr.GetTranslation("tank.ddtauctionHouse.view.buyText");
         addToContent(this._titleBuyBtn);
         this._tabLine = ComponentFactory.Instance.creatComponentByStylename("asset.ddtauctionHouse.tabLine");
         addToContent(this._tabLine);
         this._explainTxt = ComponentFactory.Instance.creatComponentByStylename("auctionHouse.explainTxt.text");
         this._explainTxt.textColor = 9554915;
         this._explainTxt.text = LanguageMgr.GetTranslation("auctionHouse.explainTxt.text");
         addToContent(this._explainTxt);
         this._browse_btn = ComponentFactory.Instance.creat("auctionHouse.Browse_btn");
         addToContent(this._browse_btn);
         this._notesButton = ComponentFactory.Instance.creat("auctionHouse.NotesButton");
         addToContent(this._notesButton);
         this._buy_btn = ComponentFactory.Instance.creat("auctionHouse.Buy_btn");
         addToContent(this._buy_btn);
         this._sell_btn = ComponentFactory.Instance.creat("auctionHouse.Sell_btn");
         addToContent(this._sell_btn);
         this._browse = new AuctionBrowseView(this._controller,this._model);
         this._buy = new AuctionBuyView();
         this._sell = new AuctionSellView(this._controller,this._model);
         this._btnGroup = new SelectedButtonGroup();
         this._btnGroup.addSelectItem(this._titleBroweBtn);
         this._btnGroup.addSelectItem(this._titleSellBtn);
         this._btnGroup.addSelectItem(this._titleBuyBtn);
         this._btnGroup.selectIndex = 0;
         this._moneyBitmap = ComponentFactory.Instance.creatBitmap("asset.core.bagAndInfo.MoneyBg");
         PositionUtils.setPos(this._moneyBitmap,"asset.core.ticketIcon.pos");
         this._money = ComponentFactory.Instance.creat("auctionHouse.money");
         this.update();
         this.updateAccount();
      }
      
      private function addEvent() : void
      {
         addEventListener(FrameEvent.RESPONSE,this.__responseHandler);
         this._browse_btn.addEventListener(MouseEvent.CLICK,this.__browse);
         this._buy_btn.addEventListener(MouseEvent.CLICK,this.__buy);
         this._sell_btn.addEventListener(MouseEvent.CLICK,this.__sell);
         this._notesButton.addEventListener(MouseEvent.CLICK,this.__showDescription);
         this._model.addEventListener(AuctionHouseEvent.CHANGE_STATE,this.__changeState);
         this._btnGroup.addEventListener(AuctionHouseEvent.CHANGE_STATE,this.__changeState);
         this._model.addEventListener(AuctionHouseEvent.GET_GOOD_CATEGORY,this.__getCategory);
         this._model.myAuctionData.addEventListener(DictionaryEvent.ADD,this.__addMyAuction);
         this._model.myAuctionData.addEventListener(DictionaryEvent.CLEAR,this.__clearMyAuction);
         this._model.myAuctionData.addEventListener(DictionaryEvent.REMOVE,this.__removeMyAuction);
         this._model.myAuctionData.addEventListener(DictionaryEvent.UPDATE,this.__updateMyAuction);
         this._model.browseAuctionData.addEventListener(DictionaryEvent.ADD,this.__addBrowse);
         this._model.browseAuctionData.addEventListener(DictionaryEvent.CLEAR,this.__clearBrowse);
         this._model.browseAuctionData.addEventListener(DictionaryEvent.UPDATE,this.__updateBrowse);
         this._model.buyAuctionData.addEventListener(DictionaryEvent.ADD,this.__addBuyAuction);
         this._model.buyAuctionData.addEventListener(DictionaryEvent.CLEAR,this.__clearBuyAuction);
         this._model.buyAuctionData.addEventListener(DictionaryEvent.UPDATE,this.__updateBuyAuction);
         this._model.addEventListener(AuctionHouseEvent.UPDATE_PAGE,this.__updatePage);
         this._model.addEventListener(AuctionHouseEvent.BROWSE_TYPE_CHANGE,this.__browserTypeChange);
         this._sell.addEventListener(AuctionHouseEvent.PRE_PAGE,this.__prePage);
         this._sell.addEventListener(AuctionHouseEvent.NEXT_PAGE,this.__nextPage);
         this._sell.addEventListener(AuctionHouseEvent.SORT_CHANGE,this.__sellSortChange);
         this._browse.addEventListener(AuctionHouseEvent.PRE_PAGE,this.__prePage);
         this._browse.addEventListener(AuctionHouseEvent.NEXT_PAGE,this.__nextPage);
         PlayerManager.Instance.Self.addEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,this.__changeMoney);
      }
      
      private function removeEvent() : void
      {
         removeEventListener(FrameEvent.RESPONSE,this.__responseHandler);
         this._browse_btn.removeEventListener(MouseEvent.CLICK,this.__browse);
         this._buy_btn.removeEventListener(MouseEvent.CLICK,this.__buy);
         this._sell_btn.removeEventListener(MouseEvent.CLICK,this.__sell);
         this._notesButton.removeEventListener(MouseEvent.CLICK,this.__showDescription);
         this._model.removeEventListener(AuctionHouseEvent.CHANGE_STATE,this.__changeState);
         this._model.removeEventListener(AuctionHouseEvent.GET_GOOD_CATEGORY,this.__getCategory);
         this._model.myAuctionData.removeEventListener(DictionaryEvent.ADD,this.__addMyAuction);
         this._model.myAuctionData.removeEventListener(DictionaryEvent.CLEAR,this.__clearMyAuction);
         this._model.myAuctionData.removeEventListener(DictionaryEvent.REMOVE,this.__removeMyAuction);
         this._model.myAuctionData.removeEventListener(DictionaryEvent.UPDATE,this.__updateMyAuction);
         this._model.browseAuctionData.removeEventListener(DictionaryEvent.ADD,this.__addBrowse);
         this._model.browseAuctionData.removeEventListener(DictionaryEvent.CLEAR,this.__clearBrowse);
         this._model.browseAuctionData.removeEventListener(DictionaryEvent.UPDATE,this.__updateBrowse);
         this._model.buyAuctionData.removeEventListener(DictionaryEvent.ADD,this.__addBuyAuction);
         this._model.buyAuctionData.removeEventListener(DictionaryEvent.CLEAR,this.__clearBuyAuction);
         this._model.buyAuctionData.removeEventListener(DictionaryEvent.UPDATE,this.__updateBuyAuction);
         this._sell.removeEventListener(AuctionHouseEvent.PRE_PAGE,this.__prePage);
         this._sell.removeEventListener(AuctionHouseEvent.NEXT_PAGE,this.__nextPage);
         this._sell.removeEventListener(AuctionHouseEvent.SORT_CHANGE,this.__sellSortChange);
         this._model.removeEventListener(AuctionHouseEvent.UPDATE_PAGE,this.__updatePage);
         this._model.removeEventListener(AuctionHouseEvent.BROWSE_TYPE_CHANGE,this.__browserTypeChange);
         this._browse.removeEventListener(AuctionHouseEvent.PRE_PAGE,this.__prePage);
         this._browse.removeEventListener(AuctionHouseEvent.NEXT_PAGE,this.__nextPage);
         PlayerManager.Instance.Self.removeEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,this.__changeMoney);
      }
      
      public function forbidChangeState() : void
      {
         this._browse_btn.removeEventListener(MouseEvent.CLICK,this.__browse);
         this._buy_btn.removeEventListener(MouseEvent.CLICK,this.__buy);
         this._sell_btn.removeEventListener(MouseEvent.CLICK,this.__sell);
      }
      
      public function allowChangeState() : void
      {
         this._browse_btn.addEventListener(MouseEvent.CLICK,this.__browse);
         this._buy_btn.addEventListener(MouseEvent.CLICK,this.__buy);
         this._sell_btn.addEventListener(MouseEvent.CLICK,this.__sell);
      }
      
      private function __browse(param1:MouseEvent) : void
      {
         SoundManager.instance.play("047");
         this._controller.setState(AuctionState.BROWSE);
      }
      
      private function __buy(param1:MouseEvent) : void
      {
         SoundManager.instance.play("047");
         this._controller.setState(AuctionState.BUY);
      }
      
      private function __sell(param1:MouseEvent) : void
      {
         SoundManager.instance.play("047");
         this._controller.setState(AuctionState.SELL);
      }
      
      private function __changeState(param1:AuctionHouseEvent) : void
      {
         this.update();
      }
      
      private function update() : void
      {
         var _loc1_:Array = null;
         var _loc2_:String = null;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         if(this._model.state == AuctionState.BROWSE)
         {
            this._btnGroup.selectIndex = 0;
            this._browse_btn.mouseEnabled = false;
            this._buy_btn.mouseEnabled = true;
            this._sell_btn.mouseEnabled = true;
            addToContent(this._browse);
            PositionUtils.setPos(this._browse,"auctionHouseBrowse.pos");
            this._browse.visible = true;
            this._buy.visible = false;
            this._sell.visible = false;
            if(this._isInit)
            {
               this._isInit = false;
            }
         }
         else if(this._model.state == AuctionState.BUY)
         {
            this._btnGroup.selectIndex = 2;
            this._browse_btn.mouseEnabled = true;
            this._buy_btn.mouseEnabled = false;
            this._sell_btn.mouseEnabled = true;
            addToContent(this._buy);
            PositionUtils.setPos(this._buy,"auctionHouseBrowse.pos");
            this._browse.visible = false;
            this._buy.visible = true;
            this._sell.visible = false;
            _loc1_ = SharedManager.Instance.AuctionIDs[PlayerManager.Instance.Self.ID];
            _loc2_ = "";
            if(_loc1_ && _loc1_.length > 0)
            {
               _loc3_ = _loc1_.length;
               _loc2_ = _loc1_[0].toString();
               if(_loc3_ > 1)
               {
                  _loc4_ = 1;
                  while(_loc4_ < _loc3_)
                  {
                     _loc2_ += "," + _loc1_[_loc4_].toString();
                     _loc4_++;
                  }
               }
            }
            if(this._model.buyAuctionData.length < 50)
            {
               this._controller.searchAuctionList(1,"",-1,-1,-1,PlayerManager.Instance.Self.ID,0,"false",_loc2_);
            }
         }
         else if(this._model.state == AuctionState.SELL)
         {
            this._btnGroup.selectIndex = 1;
            this._browse_btn.mouseEnabled = true;
            this._buy_btn.mouseEnabled = true;
            this._sell_btn.mouseEnabled = false;
            this._sell.this_left.openBagFrame();
            addToContent(this._sell);
            PositionUtils.setPos(this._sell,"auctionHouseBrowse.pos");
            this._browse.visible = false;
            this._buy.visible = false;
            this._sell.visible = true;
            if(this._model.myAuctionData.length < 50)
            {
               this._model.sellCurrent = 1;
               this._controller.searchAuctionList(1,"",-1,-1,PlayerManager.Instance.Self.ID,-1,0,"true");
            }
         }
         addToContent(this._moneyBitmap);
         addToContent(this._money);
      }
      
      private function __responseHandler(param1:FrameEvent) : void
      {
         if(param1.responseCode == FrameEvent.CLOSE_CLICK || param1.responseCode == FrameEvent.ESC_CLICK)
         {
            SoundManager.instance.play("008");
            dispatchEvent(new AuctionHouseEvent(AuctionHouseEvent.CLOSE_FRAME));
         }
      }
      
      public function show() : void
      {
         LayerManager.Instance.addToLayer(this,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
      }
      
      private function __updatePage(param1:AuctionHouseEvent) : void
      {
         if(this._model.state == AuctionState.SELL)
         {
            this._sell.setPage(this._model.sellCurrent,this._model.sellTotal);
         }
         else if(this._model.state == AuctionState.BROWSE)
         {
            this._browse.setPage(this._model.browseCurrent,this._model.browseTotal);
         }
      }
      
      private function __prePage(param1:AuctionHouseEvent) : void
      {
         if(this._model.state == AuctionState.SELL)
         {
            if(this._model.sellCurrent > 1)
            {
               this._model.sellCurrent -= 1;
               this._sell.searchByCurCondition(this._model.sellCurrent,PlayerManager.Instance.Self.ID);
            }
         }
         else if(this._model.state == AuctionState.BROWSE)
         {
            if(this._model.browseCurrent > 1)
            {
               this._model.browseCurrent -= 1;
               this._browse.searchByCurCondition(this._model.browseCurrent);
            }
         }
      }
      
      private function __nextPage(param1:AuctionHouseEvent) : void
      {
         if(this._model.state == AuctionState.SELL)
         {
            if(this._model.sellCurrent < this._model.sellTotalPage)
            {
               this._model.sellCurrent += 1;
               this._sell.searchByCurCondition(this._model.sellCurrent,PlayerManager.Instance.Self.ID);
            }
         }
         else if(this._model.state == AuctionState.BROWSE)
         {
            if(this._model.browseCurrent < this._model.browseTotalPage)
            {
               this._model.browseCurrent += 1;
               this._browse.searchByCurCondition(this._model.browseCurrent);
            }
         }
      }
      
      private function __addMyAuction(param1:DictionaryEvent) : void
      {
         this._sell.addAuction(param1.data as AuctionGoodsInfo);
         this._sell.clearLeft();
      }
      
      private function __clearMyAuction(param1:DictionaryEvent) : void
      {
         this._sell.clearList();
      }
      
      private function __removeMyAuction(param1:DictionaryEvent) : void
      {
         this._controller.searchAuctionList(this._model.sellCurrent,"",-1,-1,PlayerManager.Instance.Self.ID,-1,0,"true");
      }
      
      private function __updateMyAuction(param1:DictionaryEvent) : void
      {
         this._sell.updateList(param1.data as AuctionGoodsInfo);
      }
      
      private function __addBrowse(param1:DictionaryEvent) : void
      {
         this._browse.addAuction(param1.data as AuctionGoodsInfo);
      }
      
      private function __removeBrowse(param1:DictionaryEvent) : void
      {
         this._browse.searchByCurCondition(this._model.browseCurrent);
      }
      
      private function __updateBrowse(param1:DictionaryEvent) : void
      {
         this._browse.updateAuction(param1.data as AuctionGoodsInfo);
      }
      
      private function __clearBrowse(param1:DictionaryEvent) : void
      {
         this._browse.clearList();
      }
      
      private function __browserTypeChange(param1:AuctionHouseEvent) : void
      {
         this._browse.setSelectType(this._model.currentBrowseGoodInfo);
         this._model.browseCurrent = 1;
         this._browse.searchByCurCondition(1);
      }
      
      private function __addBuyAuction(param1:DictionaryEvent) : void
      {
         this._buy.addAuction(param1.data as AuctionGoodsInfo);
      }
      
      private function __removeBuyAuction(param1:DictionaryEvent) : void
      {
         this._buy.removeAuction();
         this._controller.searchAuctionList(this._model.browseCurrent,"",-1,-1,-1,PlayerManager.Instance.Self.ID);
      }
      
      private function __clearBuyAuction(param1:DictionaryEvent) : void
      {
         this._buy.clearList();
      }
      
      private function __updateBuyAuction(param1:DictionaryEvent) : void
      {
         this._buy.updateAuction(param1.data as AuctionGoodsInfo);
      }
      
      private function __changeMoney(param1:PlayerPropertyEvent) : void
      {
         this.updateAccount();
      }
      
      private function __sellSortChange(param1:AuctionHouseEvent) : void
      {
         this._browse.searchByCurCondition(this._model.sellCurrent,PlayerManager.Instance.Self.ID);
      }
      
      private function updateAccount() : void
      {
         this._money.text = String(PlayerManager.Instance.Self.Money);
      }
      
      private function __showDescription(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         var _loc2_:AuctionDescriptionFrame = ComponentFactory.Instance.creat("auctionHouse.NotesFrame");
         LayerManager.Instance.addToLayer(_loc2_,LayerManager.STAGE_TOP_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
      }
      
      private function __getCategory(param1:AuctionHouseEvent) : void
      {
         this._model.browseCurrent = 1;
         this._browse.setCategory(this._model.category);
      }
      
      override public function dispose() : void
      {
         this.removeEvent();
         StateManager.currentStateType = StateType.MAIN;
         this._model = null;
         this._controller = null;
         if(this._titleBg)
         {
            ObjectUtils.disposeObject(this._titleBg);
         }
         this._titleBg = null;
         if(this._tabLine)
         {
            ObjectUtils.disposeObject(this._tabLine);
         }
         this._tabLine = null;
         if(this._browse)
         {
            ObjectUtils.disposeObject(this._browse);
         }
         this._browse = null;
         if(this._buy)
         {
            ObjectUtils.disposeObject(this._buy);
         }
         this._buy = null;
         if(this._sell)
         {
            ObjectUtils.disposeObject(this._sell);
         }
         this._sell = null;
         if(this._notesButton)
         {
            ObjectUtils.disposeObject(this._notesButton);
         }
         this._notesButton = null;
         if(this._browse_btn)
         {
            ObjectUtils.disposeObject(this._browse_btn);
         }
         this._browse_btn = null;
         if(this._buy_btn)
         {
            ObjectUtils.disposeObject(this._buy_btn);
         }
         this._buy_btn = null;
         if(this._sell_btn)
         {
            ObjectUtils.disposeObject(this._sell_btn);
         }
         this._sell_btn = null;
         if(this._money)
         {
            ObjectUtils.disposeObject(this._money);
         }
         this._money = null;
         ObjectUtils.disposeAllChildren(this);
         if(parent)
         {
            parent.removeChild(this);
         }
         if(this.moneyBG)
         {
            ObjectUtils.disposeObject(this.moneyBG);
         }
         this.moneyBG = null;
         if(this.moneyInfoBG)
         {
            ObjectUtils.disposeObject(this.moneyInfoBG);
         }
         this.moneyInfoBG = null;
         if(this._titleBroweBtn)
         {
            ObjectUtils.disposeObject(this._titleBroweBtn);
         }
         this._titleBroweBtn = null;
         if(this._titleBuyBtn)
         {
            ObjectUtils.disposeObject(this._titleBuyBtn);
         }
         this._titleBuyBtn = null;
         if(this._explainTxt)
         {
            ObjectUtils.disposeObject(this._explainTxt);
         }
         this._explainTxt = null;
         if(this._titleSellBtn)
         {
            ObjectUtils.disposeObject(this._titleSellBtn);
         }
         this._titleSellBtn = null;
         if(this._moneyBitmap)
         {
            ObjectUtils.disposeObject(this._moneyBitmap);
         }
         this._moneyBitmap = null;
         if(this._btnGroup)
         {
            ObjectUtils.disposeObject(this._btnGroup);
         }
         this._btnGroup = null;
      }
   }
}
