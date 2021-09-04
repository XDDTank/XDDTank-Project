package auctionHouse.view
{
   import auctionHouse.AuctionState;
   import auctionHouse.event.AuctionHouseEvent;
   import auctionHouse.model.AuctionHouseModel;
   import com.pickgliss.events.ListItemEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.controls.ListPanel;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.Scale9CornerImage;
   import com.pickgliss.ui.image.ScaleFrameImage;
   import com.pickgliss.ui.image.ScaleLeftRightImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.auctionHouse.AuctionGoodsInfo;
   import ddt.manager.LanguageMgr;
   import ddt.manager.SoundManager;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   
   public class AuctionRightView extends Sprite implements Disposeable
   {
       
      
      private var _prePage_btn:BaseButton;
      
      private var _nextPage_btn:BaseButton;
      
      private var _first_btn:BaseButton;
      
      private var _end_btn:BaseButton;
      
      public var page_txt:FilterFrameText;
      
      private var _sorttxtItems:Vector.<FilterFrameText>;
      
      private var _sortBtItems:Vector.<Sprite>;
      
      private var _sortArrowItems:Vector.<ScaleFrameImage>;
      
      private var _stripList:ListPanel;
      
      private var _state:String;
      
      private var _currentButtonIndex:uint = 0;
      
      private var _currentIsdown:Boolean = true;
      
      private var _selectStrip:StripView;
      
      private var _selectInfo:AuctionGoodsInfo;
      
      private var help_mc:Bitmap;
      
      private var _nameTxt:FilterFrameText;
      
      private var _bidNumberTxt:FilterFrameText;
      
      private var _RemainingTimeTxt:FilterFrameText;
      
      private var _SellPersonTxt:FilterFrameText;
      
      private var _bidpriceTxt:FilterFrameText;
      
      private var _BidPersonTxt:FilterFrameText;
      
      private var _tableline:Bitmap;
      
      private var _tableline1:Bitmap;
      
      private var _tableline2:Bitmap;
      
      private var _tableline3:Bitmap;
      
      private var GoodsName_btn:Sprite;
      
      private var RemainingTime_btn:Sprite;
      
      private var SellPerson_btn:Sprite;
      
      private var BidPrice_btn:Sprite;
      
      private var BidPerson_btn:Sprite;
      
      private var index:int = 0;
      
      private var _startNum:int = 0;
      
      private var _endNum:int = 0;
      
      private var _totalCount:int = 0;
      
      public function AuctionRightView()
      {
         super();
      }
      
      public function setup(param1:String = "") : void
      {
         this._state = param1;
         this.initView();
         this.addEvent();
      }
      
      private function initView() : void
      {
         var _loc8_:ScaleFrameImage = null;
         this._sortBtItems = new Vector.<Sprite>(6);
         this._sorttxtItems = new Vector.<FilterFrameText>(6);
         this._sortArrowItems = new Vector.<ScaleFrameImage>(4);
         var _loc1_:Scale9CornerImage = ComponentFactory.Instance.creatComponentByStylename("auctionHouse.RightBG1");
         addChild(_loc1_);
         var _loc2_:Scale9CornerImage = ComponentFactory.Instance.creatComponentByStylename("auctionHouse.RightItemButtomBG");
         addChild(_loc2_);
         var _loc3_:ScaleLeftRightImage = ComponentFactory.Instance.creatComponentByStylename("asset.auctionHouse.Browse.PageCountBgI");
         addChild(_loc3_);
         var _loc4_:ScaleLeftRightImage = ComponentFactory.Instance.creatComponentByStylename("asset.auctionHouse.Browse.PageCountBg");
         addChild(_loc4_);
         this.help_mc = ComponentFactory.Instance.creatBitmap("asset.auctionHouse.Help");
         addChild(this.help_mc);
         this._prePage_btn = ComponentFactory.Instance.creat("auctionHouse.Prev_btn");
         addChild(this._prePage_btn);
         this._nextPage_btn = ComponentFactory.Instance.creat("auctionHouse.Next_btn");
         addChild(this._nextPage_btn);
         this._first_btn = ComponentFactory.Instance.creat("auctionHouse.first_btn");
         this._end_btn = ComponentFactory.Instance.creat("auctionHouse.end_btn");
         this.page_txt = ComponentFactory.Instance.creat("auctionHouse.RightPageText");
         addChild(this.page_txt);
         var _loc5_:ScaleLeftRightImage = ComponentFactory.Instance.creatComponentByStylename("auctionHouse.RightItemTopBG");
         addChild(_loc5_);
         this._nameTxt = ComponentFactory.Instance.creat("ddtauction.nameTxt");
         this._nameTxt.text = LanguageMgr.GetTranslation("tank.ddtauctionHouse.text.name");
         this._bidNumberTxt = ComponentFactory.Instance.creat("ddtauction.bidNumerTxt");
         this._bidNumberTxt.text = LanguageMgr.GetTranslation("tank.ddtauctionHouse.text.number");
         addChild(this._bidNumberTxt);
         this._RemainingTimeTxt = ComponentFactory.Instance.creat("ddtauction.remainingTimeTxt");
         this._RemainingTimeTxt.text = LanguageMgr.GetTranslation("tank.ddtauctionHouse.text.timer");
         this._SellPersonTxt = ComponentFactory.Instance.creat("ddtauction.SellPersonTxt");
         this._SellPersonTxt.text = LanguageMgr.GetTranslation("tank.ddtauctionHouse.text.sellPron");
         this._BidPersonTxt = ComponentFactory.Instance.creat("ddtauction.BidPersonTxt");
         this._BidPersonTxt.text = LanguageMgr.GetTranslation("tank.ddtauctionHouse.text.bidPron");
         this._bidpriceTxt = ComponentFactory.Instance.creat("ddtauction.BidPriceTxt");
         this._bidpriceTxt.text = LanguageMgr.GetTranslation("tank.ddtauctionHouse.text.price");
         this._tableline = ComponentFactory.Instance.creatBitmap("asset.formTop.Line");
         addChild(this._tableline);
         this._tableline.x = 264;
         this._tableline1 = ComponentFactory.Instance.creatBitmap("asset.formTop.Line");
         addChild(this._tableline1);
         this._tableline1.x = 314;
         this._tableline2 = ComponentFactory.Instance.creatBitmap("asset.formTop.Line");
         addChild(this._tableline2);
         this._tableline2.x = 426;
         this._tableline3 = ComponentFactory.Instance.creatBitmap("asset.formTop.Line");
         addChild(this._tableline3);
         this._tableline3.x = 517;
         this._tableline.y = this._tableline1.y = this._tableline2.y = this._tableline3.y = 7;
         this.GoodsName_btn = new Sprite();
         this.GoodsName_btn.graphics.beginFill(16777215,1);
         this.GoodsName_btn.graphics.drawRect(0,6,190,30);
         this.GoodsName_btn.graphics.endFill();
         this.GoodsName_btn.alpha = 0;
         this.GoodsName_btn.buttonMode = true;
         addChild(this.GoodsName_btn);
         this.GoodsName_btn.x = 74;
         this.RemainingTime_btn = new Sprite();
         this.RemainingTime_btn.graphics.beginFill(16777215,1);
         this.RemainingTime_btn.graphics.drawRect(0,6,109,30);
         this.RemainingTime_btn.graphics.endFill();
         this.RemainingTime_btn.alpha = 0;
         this.RemainingTime_btn.buttonMode = true;
         addChild(this.RemainingTime_btn);
         this.RemainingTime_btn.x = 317;
         this.SellPerson_btn = new Sprite();
         this.SellPerson_btn.graphics.beginFill(16777215,1);
         this.SellPerson_btn.graphics.drawRect(0,6,88,30);
         this.SellPerson_btn.graphics.endFill();
         this.SellPerson_btn.alpha = 0;
         this.SellPerson_btn.buttonMode = true;
         addChild(this.SellPerson_btn);
         this.SellPerson_btn.x = 429;
         this.BidPrice_btn = new Sprite();
         this.BidPrice_btn.graphics.beginFill(16777215,1);
         this.BidPrice_btn.graphics.drawRect(0,6,173,30);
         this.BidPrice_btn.graphics.endFill();
         this.BidPrice_btn.alpha = 0;
         this.BidPrice_btn.buttonMode = true;
         addChild(this.BidPrice_btn);
         this.BidPrice_btn.x = 520;
         this.BidPerson_btn = new Sprite();
         this.BidPerson_btn.graphics.beginFill(16777215,1);
         this.BidPerson_btn.graphics.drawRect(0,6,88,30);
         this.BidPerson_btn.graphics.endFill();
         this.BidPerson_btn.alpha = 0;
         this.BidPerson_btn.buttonMode = true;
         this.BidPerson_btn.x = 429;
         addChild(this.BidPerson_btn);
         this._sorttxtItems[0] = this._nameTxt;
         this._sorttxtItems[2] = this._RemainingTimeTxt;
         this._sorttxtItems[3] = this._SellPersonTxt;
         this._sorttxtItems[4] = this._bidpriceTxt;
         this._sorttxtItems[5] = this._BidPersonTxt;
         var _loc6_:int = 0;
         while(_loc6_ < this._sorttxtItems.length)
         {
            if(_loc6_ != 1)
            {
               if(_loc6_ == 3)
               {
                  if(this._state == AuctionState.BROWSE)
                  {
                     addChild(this._sorttxtItems[_loc6_]);
                  }
               }
               else if(_loc6_ == 5)
               {
                  if(this._state == AuctionState.SELL)
                  {
                     addChild(this._sorttxtItems[_loc6_]);
                  }
               }
               else
               {
                  addChild(this._sorttxtItems[_loc6_]);
               }
            }
            _loc6_++;
         }
         this._sortBtItems[0] = this.GoodsName_btn;
         this._sortBtItems[2] = this.RemainingTime_btn;
         this._sortBtItems[3] = this.SellPerson_btn;
         this._sortBtItems[4] = this.BidPrice_btn;
         this._sortBtItems[5] = this.BidPerson_btn;
         var _loc7_:int = 0;
         while(_loc7_ < this._sortBtItems.length)
         {
            if(_loc7_ != 1)
            {
               if(_loc7_ == 3)
               {
                  if(this._state == AuctionState.BROWSE)
                  {
                     addChild(this._sortBtItems[_loc7_]);
                  }
               }
               else if(_loc7_ == 5)
               {
                  if(this._state == AuctionState.SELL)
                  {
                     addChild(this._sortBtItems[_loc7_]);
                  }
               }
               else
               {
                  addChild(this._sortBtItems[_loc7_]);
               }
            }
            _loc7_++;
         }
         this._sortArrowItems[0] = ComponentFactory.Instance.creat("auctionHouse.ArrowI");
         this._sortArrowItems[1] = ComponentFactory.Instance.creat("auctionHouse.ArrowII");
         this._sortArrowItems[2] = ComponentFactory.Instance.creat("auctionHouse.ArrowIII");
         this._sortArrowItems[3] = ComponentFactory.Instance.creat("auctionHouse.ArrowV");
         for each(_loc8_ in this._sortArrowItems)
         {
            addChild(_loc8_);
            _loc8_.visible = false;
         }
         this._stripList = ComponentFactory.Instance.creatComponentByStylename("auctionHouse.rightListII");
         addChild(this._stripList);
         this._stripList.list.updateListView();
         this._stripList.list.addEventListener(ListItemEvent.LIST_ITEM_CLICK,this.__itemClick);
         if(this._state == AuctionState.SELL)
         {
            this.help_mc.visible = false;
         }
         this.addStageInit();
         this._nextPage_btn.enable = false;
         this._prePage_btn.enable = false;
         this._first_btn.enable = false;
         this._end_btn.enable = false;
      }
      
      private function addEvent() : void
      {
         var _loc1_:int = 0;
         while(_loc1_ < this._sortBtItems.length)
         {
            if(_loc1_ != 1)
            {
               this._sortBtItems[_loc1_].addEventListener(MouseEvent.CLICK,this.sortHandler);
            }
            _loc1_++;
         }
      }
      
      public function addStageInit() : void
      {
      }
      
      public function hideReady() : void
      {
         this._hideArrow();
      }
      
      public function addAuction(param1:AuctionGoodsInfo) : void
      {
         param1.index = this._stripList.vectorListModel.getSize();
         this._stripList.vectorListModel.append(param1);
         this._stripList.list.updateListView();
         this.help_mc.visible = false;
      }
      
      public function updateAuction(param1:AuctionGoodsInfo) : void
      {
         var _loc2_:AuctionGoodsInfo = null;
         var _loc4_:AuctionGoodsInfo = null;
         var _loc3_:int = 0;
         for each(_loc4_ in this._stripList.vectorListModel.elements)
         {
            if(_loc4_.AuctionID == param1.AuctionID)
            {
               _loc2_ = _loc4_;
               break;
            }
         }
         if(_loc2_ != null)
         {
            param1.BagItemInfo = _loc2_.BagItemInfo;
         }
         if(this._stripList.vectorListModel.indexOf(_loc2_) != -1)
         {
            this._stripList.vectorListModel.replaceAt(this._stripList.vectorListModel.indexOf(_loc2_),param1);
         }
         else
         {
            this._stripList.vectorListModel.append(param1);
         }
         this._stripList.list.updateListView();
      }
      
      function getStripCount() : int
      {
         return this._stripList.vectorListModel.size();
      }
      
      function setPage(param1:int, param2:int) : void
      {
         var _loc3_:int = 0;
         param1 = 1 + AuctionHouseModel.SINGLE_PAGE_NUM * (param1 - 1);
         if(param1 + AuctionHouseModel.SINGLE_PAGE_NUM - 1 < param2)
         {
            _loc3_ = param1 + AuctionHouseModel.SINGLE_PAGE_NUM - 1;
         }
         else
         {
            _loc3_ = param2;
         }
         this._startNum = param1;
         this._endNum = _loc3_;
         this._totalCount = param2;
         if(param2 == 0)
         {
            if(this._stripList.vectorListModel.elements.length == 0)
            {
               this.page_txt.text = "";
            }
         }
         else
         {
            this.page_txt.text = (int(this._startNum / AuctionHouseModel.SINGLE_PAGE_NUM) + 1).toString() + "/" + (int((this._totalCount - 1) / AuctionHouseModel.SINGLE_PAGE_NUM) + 1).toString();
         }
         this.buttonStatus(param1,_loc3_,param2);
      }
      
      private function upPageTxt() : void
      {
         if(this._endNum < this._startNum)
         {
            this.page_txt.text = "";
         }
         else
         {
            this.page_txt.text = (int(this._startNum / AuctionHouseModel.SINGLE_PAGE_NUM) + 1).toString() + "/" + (int((this._totalCount - 1) / AuctionHouseModel.SINGLE_PAGE_NUM) + 1).toString();
         }
         if(this._stripList.vectorListModel.elements.length == 0)
         {
            this.page_txt.text = "";
         }
         if(this._endNum < this._totalCount)
         {
            this._nextPage_btn.enable = true;
            this._end_btn.enable = true;
         }
         else
         {
            this._nextPage_btn.enable = false;
            this._end_btn.enable = false;
         }
      }
      
      private function buttonStatus(param1:int, param2:int, param3:int) : void
      {
         if(param1 <= 1)
         {
            this._prePage_btn.enable = false;
            this._first_btn.enable = false;
         }
         else
         {
            this._prePage_btn.enable = true;
            this._first_btn.enable = true;
         }
         if(param2 < param3)
         {
            this._nextPage_btn.enable = true;
            this._end_btn.enable = true;
         }
         else
         {
            this._nextPage_btn.enable = false;
            this._end_btn.enable = false;
         }
         this._nextPage_btn.alpha = 1;
         this._prePage_btn.alpha = 1;
      }
      
      function clearList() : void
      {
         this._clearItems();
         this._selectInfo = null;
         this.page_txt.text = "";
         if(this._state == AuctionState.BROWSE)
         {
            this.help_mc.visible = true;
         }
         if(this._stripList.vectorListModel.elements.length == 0)
         {
            this.help_mc.visible = true;
         }
         else
         {
            this.help_mc.visible = false;
         }
         if(this._state == AuctionState.SELL)
         {
            this.help_mc.visible = false;
         }
      }
      
      private function _clearItems() : void
      {
         this._stripList.vectorListModel.clear();
         this._stripList.list.updateListView();
      }
      
      private function invalidatePanel() : void
      {
      }
      
      function getSelectInfo() : AuctionGoodsInfo
      {
         if(this._selectInfo)
         {
            return this._selectInfo;
         }
         return null;
      }
      
      function deleteItem() : void
      {
         var _loc1_:AuctionGoodsInfo = null;
         for each(_loc1_ in this._stripList.vectorListModel.elements)
         {
            if(_loc1_.AuctioneerID == this._selectInfo.AuctioneerID)
            {
               this._stripList.vectorListModel.remove(_loc1_);
               this._selectInfo = null;
               this.upPageTxt();
               break;
            }
         }
         this._stripList.list.updateListView();
      }
      
      function clearSelectStrip() : void
      {
         this._stripList.vectorListModel.remove(this._selectInfo);
         this._selectInfo = null;
         this.upPageTxt();
         this._stripList.list.unSelectedAll();
         this._stripList.list.updateListView();
      }
      
      function setSelectEmpty() : void
      {
         this._selectStrip.isSelect = false;
         this._selectStrip = null;
         this._selectInfo = null;
      }
      
      function get sortCondition() : int
      {
         return this._currentButtonIndex;
      }
      
      function get sortBy() : Boolean
      {
         return this._currentIsdown;
      }
      
      private function __itemClick(param1:ListItemEvent) : void
      {
         var _loc2_:StripView = param1.cell as StripView;
         this._selectStrip = _loc2_;
         this._selectInfo = _loc2_.info;
         dispatchEvent(new AuctionHouseEvent(AuctionHouseEvent.SELECT_STRIP));
      }
      
      private function removeEvent() : void
      {
         var _loc1_:int = 0;
         while(_loc1_ < this._sortBtItems.length)
         {
            if(_loc1_ != 1)
            {
               this._sortBtItems[_loc1_].removeEventListener(MouseEvent.CLICK,this.sortHandler);
               ObjectUtils.disposeObject(this._sortBtItems[_loc1_]);
            }
            _loc1_++;
         }
         this._sortBtItems = null;
      }
      
      private function sortHandler(param1:MouseEvent) : void
      {
         AuctionHouseModel._dimBooble = false;
         SoundManager.instance.play("047");
         var _loc2_:uint = this._sortBtItems.indexOf(param1.target as Sprite);
         if(this._currentButtonIndex == _loc2_)
         {
            this.changeArrow(_loc2_,!this._currentIsdown);
         }
         else
         {
            this.changeArrow(_loc2_,true);
         }
      }
      
      private function _showOneArrow(param1:uint) : void
      {
         this._hideArrow();
         this._sortArrowItems[param1].visible = true;
      }
      
      private function _hideArrow() : void
      {
         var _loc1_:ScaleFrameImage = null;
         for each(_loc1_ in this._sortArrowItems)
         {
            _loc1_.visible = false;
         }
      }
      
      private function changeArrow(param1:uint, param2:Boolean) : void
      {
         var _loc3_:uint = param1;
         if(param1 == 5)
         {
            param1 = 3;
         }
         param1 = param1 == 0 ? uint(0) : uint(param1 - 1);
         this._showOneArrow(param1);
         if(param2)
         {
            this._sortArrowItems[param1].setFrame(2);
         }
         else
         {
            this._sortArrowItems[param1].setFrame(1);
         }
         this._currentIsdown = param2;
         this._currentButtonIndex = _loc3_;
         AuctionHouseModel.searchType = 3;
         if(this._stripList.vectorListModel.elements.length < 1)
         {
            return;
         }
         dispatchEvent(new AuctionHouseEvent(AuctionHouseEvent.SORT_CHANGE));
      }
      
      public function get prePage_btn() : BaseButton
      {
         return this._prePage_btn;
      }
      
      public function get nextPage_btn() : BaseButton
      {
         return this._nextPage_btn;
      }
      
      public function dispose() : void
      {
         var _loc1_:ScaleFrameImage = null;
         this.removeEvent();
         this._selectInfo = null;
         if(this._first_btn)
         {
            ObjectUtils.disposeObject(this._first_btn);
         }
         this._first_btn = null;
         if(this._end_btn)
         {
            ObjectUtils.disposeObject(this._end_btn);
         }
         this._end_btn = null;
         if(this._prePage_btn)
         {
            ObjectUtils.disposeObject(this._prePage_btn);
         }
         this._prePage_btn = null;
         if(this._nextPage_btn)
         {
            ObjectUtils.disposeObject(this._nextPage_btn);
         }
         this._nextPage_btn = null;
         if(this.page_txt)
         {
            ObjectUtils.disposeObject(this.page_txt);
         }
         this.page_txt = null;
         for each(_loc1_ in this._sortArrowItems)
         {
            ObjectUtils.disposeObject(_loc1_);
         }
         this._sortArrowItems = null;
         if(this._selectStrip)
         {
            ObjectUtils.disposeObject(this._selectStrip);
         }
         this._selectStrip = null;
         this._stripList.vectorListModel.clear();
         if(this._stripList)
         {
            this._stripList.list.removeEventListener(ListItemEvent.LIST_ITEM_CLICK,this.__itemClick);
            ObjectUtils.disposeObject(this._stripList);
         }
         this._stripList = null;
         if(this.help_mc)
         {
            ObjectUtils.disposeObject(this.help_mc);
         }
         this.help_mc = null;
         ObjectUtils.disposeAllChildren(this);
         if(parent)
         {
            parent.removeChild(this);
         }
      }
   }
}
