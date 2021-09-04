package auctionHouse.view
{
   import auctionHouse.event.AuctionHouseEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.ScrollPanel;
   import com.pickgliss.ui.controls.container.VBox;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.Scale9CornerImage;
   import com.pickgliss.ui.image.ScaleLeftRightImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.auctionHouse.AuctionGoodsInfo;
   import ddt.manager.LanguageMgr;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   
   public class AuctionBuyRightView extends Sprite implements Disposeable
   {
       
      
      private var panel:ScrollPanel;
      
      private var _strips:Vector.<AuctionBuyStripView>;
      
      private var _selectStrip:AuctionBuyStripView;
      
      private var _list:VBox;
      
      private var _nameTxt:FilterFrameText;
      
      private var _bidNumberTxt:FilterFrameText;
      
      private var _RemainingTimeTxt:FilterFrameText;
      
      private var _bidpriceTxt:FilterFrameText;
      
      private var _statusTxt:FilterFrameText;
      
      private var _mouthfulTxt:FilterFrameText;
      
      private var _tableline:Bitmap;
      
      private var _tableline1:Bitmap;
      
      private var _tableline2:Bitmap;
      
      private var _tableline3:Bitmap;
      
      private var _tableline4:Bitmap;
      
      private var _tableline5:Bitmap;
      
      public function AuctionBuyRightView()
      {
         super();
         this.initView();
         this.addEvent();
      }
      
      private function initView() : void
      {
         var _loc1_:Scale9CornerImage = ComponentFactory.Instance.creatComponentByStylename("asset.auctionHouse.BuyBG");
         addChild(_loc1_);
         var _loc2_:ScaleLeftRightImage = ComponentFactory.Instance.creatComponentByStylename("ddtauction.sellItemBG5");
         addChild(_loc2_);
         var _loc3_:Scale9CornerImage = ComponentFactory.Instance.creatComponentByStylename("asset.auctionHouse.BuyBGI");
         addChild(_loc3_);
         this._nameTxt = ComponentFactory.Instance.creat("ddtauction.nameTxt");
         this._nameTxt.text = LanguageMgr.GetTranslation("tank.ddtauctionHouse.text.name");
         addChild(this._nameTxt);
         this._bidNumberTxt = ComponentFactory.Instance.creat("ddtauction.bidNumerTxt");
         this._bidNumberTxt.text = LanguageMgr.GetTranslation("tank.ddtauctionHouse.text.number");
         addChild(this._bidNumberTxt);
         this._bidNumberTxt.x = 275;
         this._RemainingTimeTxt = ComponentFactory.Instance.creat("ddtauction.remainingTimeTxt");
         this._RemainingTimeTxt.text = LanguageMgr.GetTranslation("tank.ddtauctionHouse.text.timer");
         addChild(this._RemainingTimeTxt);
         this._RemainingTimeTxt.x = 384;
         this._bidpriceTxt = ComponentFactory.Instance.creat("ddtauction.BidPriceTxt");
         this._bidpriceTxt.text = LanguageMgr.GetTranslation("tank.ddtauctionHouse.text.price");
         addChild(this._bidpriceTxt);
         this._bidpriceTxt.x = 807;
         this._statusTxt = ComponentFactory.Instance.creat("ddtauction.statusTxt");
         this._statusTxt.text = LanguageMgr.GetTranslation("tank.ddtauctionHouse.text.status");
         addChild(this._statusTxt);
         this._statusTxt.x = 638;
         this._mouthfulTxt = ComponentFactory.Instance.creat("ddtauction.mouthfulTxt");
         this._mouthfulTxt.text = LanguageMgr.GetTranslation("tank.ddtauctionHouse.view.mouthful");
         addChild(this._mouthfulTxt);
         this._mouthfulTxt.x = 522;
         this._tableline = ComponentFactory.Instance.creatBitmap("asset.formTop.Line");
         addChild(this._tableline);
         this._tableline.x = 289;
         this._tableline1 = ComponentFactory.Instance.creatBitmap("asset.formTop.Line");
         addChild(this._tableline1);
         this._tableline1.x = 339;
         this._tableline2 = ComponentFactory.Instance.creatBitmap("asset.formTop.Line");
         addChild(this._tableline2);
         this._tableline2.x = 501;
         this._tableline3 = ComponentFactory.Instance.creatBitmap("asset.formTop.Line");
         addChild(this._tableline3);
         this._tableline3.x = 606;
         this._tableline4 = ComponentFactory.Instance.creatBitmap("asset.formTop.Line");
         addChild(this._tableline4);
         this._tableline4.x = 739;
         this._tableline.y = this._tableline1.y = this._tableline2.y = this._tableline3.y = this._tableline4.y = 10;
         this._list = new VBox();
         this._strips = new Vector.<AuctionBuyStripView>();
         this.panel = ComponentFactory.Instance.creat("auctionHouse.BrowseBuyScrollpanel");
         this.panel.hScrollProxy = ScrollPanel.OFF;
         this.panel.vScrollProxy = ScrollPanel.ON;
         this.panel.setView(this._list);
         addChild(this.panel);
         this.invalidatePanel();
      }
      
      private function addEvent() : void
      {
      }
      
      private function removeEvent() : void
      {
      }
      
      function addAuction(param1:AuctionGoodsInfo) : void
      {
         param1.index = this._strips.length;
         var _loc2_:AuctionBuyStripView = new AuctionBuyStripView();
         _loc2_.info = param1;
         _loc2_.addEventListener(AuctionHouseEvent.SELECT_STRIP,this.__selectStrip);
         this._strips.push(_loc2_);
         this._list.addChild(_loc2_);
         this.invalidatePanel();
      }
      
      private function invalidatePanel() : void
      {
         this.panel.invalidateViewport();
      }
      
      function clearList() : void
      {
         this._clearItems();
         this._selectStrip = null;
         this._strips = new Vector.<AuctionBuyStripView>();
      }
      
      private function _clearItems() : void
      {
         this._strips.splice(0,this._strips.length);
         this._list.disposeAllChildren();
         this._list.height = 0;
         this.invalidatePanel();
      }
      
      function getSelectInfo() : AuctionGoodsInfo
      {
         if(this._selectStrip)
         {
            return this._selectStrip.info;
         }
         return null;
      }
      
      function deleteItem() : void
      {
         var _loc1_:int = 0;
         while(_loc1_ < this._strips.length)
         {
            if(this._selectStrip == this._strips[_loc1_])
            {
               this._selectStrip.removeEventListener(AuctionHouseEvent.SELECT_STRIP,this.__selectStrip);
               this._selectStrip.dispose();
               this._strips.splice(_loc1_,1);
               this._selectStrip = null;
               break;
            }
            _loc1_++;
         }
      }
      
      function clearSelectStrip() : void
      {
         var _loc1_:AuctionBuyStripView = null;
         for each(_loc1_ in this._strips)
         {
            if(this._selectStrip == _loc1_)
            {
               this._selectStrip.removeEventListener(AuctionHouseEvent.SELECT_STRIP,this.__selectStrip);
               this._selectStrip.clearSelectStrip();
               this._selectStrip = null;
               break;
            }
         }
      }
      
      function updateAuction(param1:AuctionGoodsInfo) : void
      {
         var _loc2_:AuctionBuyStripView = null;
         for each(_loc2_ in this._strips)
         {
            if(_loc2_.info.AuctionID == param1.AuctionID)
            {
               param1.BagItemInfo = _loc2_.info.BagItemInfo;
               _loc2_.info = param1;
               break;
            }
         }
      }
      
      private function __selectStrip(param1:AuctionHouseEvent) : void
      {
         if(this._selectStrip)
         {
            this._selectStrip.isSelect = false;
         }
         var _loc2_:AuctionBuyStripView = param1.target as AuctionBuyStripView;
         _loc2_.isSelect = true;
         this._selectStrip = _loc2_;
         dispatchEvent(new AuctionHouseEvent(AuctionHouseEvent.SELECT_STRIP));
      }
      
      public function dispose() : void
      {
         var _loc1_:AuctionBuyStripView = null;
         this.removeEvent();
         if(this.panel)
         {
            ObjectUtils.disposeObject(this.panel);
         }
         this.panel = null;
         if(this._selectStrip)
         {
            ObjectUtils.disposeObject(this._selectStrip);
         }
         this._selectStrip = null;
         if(this._list)
         {
            ObjectUtils.disposeObject(this._list);
         }
         this._list = null;
         for each(_loc1_ in this._strips)
         {
            if(_loc1_)
            {
               ObjectUtils.disposeObject(_loc1_);
            }
            _loc1_ = null;
         }
         this._strips = null;
         ObjectUtils.disposeAllChildren(this);
         if(parent)
         {
            parent.removeChild(this);
         }
      }
   }
}
