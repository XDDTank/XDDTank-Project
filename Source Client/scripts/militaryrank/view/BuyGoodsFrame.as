package militaryrank.view
{
   import bagAndInfo.cell.BaseCell;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.ui.controls.TextButton;
   import com.pickgliss.ui.image.Image;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.command.NumberSelecter;
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.data.goods.Price;
   import ddt.data.goods.ShopItemInfo;
   import ddt.manager.ItemManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.utils.PositionUtils;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import militaryrank.MilitaryRankManager;
   
   public class BuyGoodsFrame extends Frame
   {
       
      
      private var _bg:Image;
      
      private var _number:NumberSelecter;
      
      private var _itemTemplateInfo:ItemTemplateInfo;
      
      private var _submitButton:TextButton;
      
      private var _shopItem:ShopItemInfo;
      
      private var _cell:BaseCell;
      
      public var _itemID:int;
      
      private var _goodCount:int = 1;
      
      private var _priceTxtList:Vector.<FilterFrameText>;
      
      private var _payTypeList:Vector.<MovieClip>;
      
      private var _totalTipText:FilterFrameText;
      
      public function BuyGoodsFrame()
      {
         super();
         this.initView();
         this.initEvent();
      }
      
      public function set ItemID(param1:int) : void
      {
         this._itemID = param1;
         this._goodCount = 1;
         this._number.number = this._goodCount;
         this.initInfo();
         this.refreshNumText();
      }
      
      public function get goodCount() : int
      {
         return this._goodCount;
      }
      
      public function set shopItem(param1:ShopItemInfo) : void
      {
         this._shopItem = param1;
         this.ItemID = this._shopItem.TemplateID;
      }
      
      public function show() : void
      {
         LayerManager.Instance.addToLayer(this,LayerManager.GAME_TOP_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
      }
      
      private function initView() : void
      {
         var _loc2_:int = 0;
         escEnable = true;
         enterEnable = true;
         this._submitButton = ComponentFactory.Instance.creatComponentByStylename("ddtcore.quickEnter");
         this._submitButton.text = LanguageMgr.GetTranslation("store.view.shortcutBuy.buyBtn");
         addToContent(this._submitButton);
         this._bg = ComponentFactory.Instance.creatComponentByStylename("ddtcore.CellBg");
         addToContent(this._bg);
         this._number = ComponentFactory.Instance.creatCustomObject("ddtcore.numberSelecter");
         addToContent(this._number);
         var _loc1_:Sprite = new Sprite();
         _loc1_.addChild(ComponentFactory.Instance.creatBitmap("asset.ddtcore.EquipCellBG"));
         this._cell = new BaseCell(_loc1_);
         this._cell.x = this._bg.x + 4;
         this._cell.y = this._bg.y + 4;
         addToContent(this._cell);
         this._cell.tipDirctions = "7,0";
         this._priceTxtList = new Vector.<FilterFrameText>(2);
         this._priceTxtList[0] = ComponentFactory.Instance.creat("militaryrank.buyGoodsFrame.exploitTxt");
         this._priceTxtList[1] = ComponentFactory.Instance.creatComponentByStylename("militaryrank.buyGoodsFrame.moneyTxt");
         addToContent(this._priceTxtList[0]);
         addToContent(this._priceTxtList[1]);
         this._payTypeList = new Vector.<MovieClip>(2);
         _loc2_ = 0;
         while(_loc2_ < 2)
         {
            this._payTypeList[_loc2_] = ComponentFactory.Instance.creat("militaryrank.buygoodsframe.moneyIcon" + (_loc2_ + 1));
            this._payTypeList[_loc2_].mouseChildren = false;
            this._payTypeList[_loc2_].mouseEnabled = false;
            addToContent(this._payTypeList[_loc2_]);
            _loc2_++;
         }
         this._totalTipText = ComponentFactory.Instance.creatComponentByStylename("ddtcore.TotalTipsText");
         PositionUtils.setPos(this._totalTipText,"militaryrank.buygoodsframe.TotalTipsTextPos");
         this._totalTipText.text = LanguageMgr.GetTranslation("ddt.QuickFrame.TotalTipText");
         addToContent(this._totalTipText);
      }
      
      private function initEvent() : void
      {
         this._number.addEventListener(Event.CHANGE,this.__selectHandler);
         this._number.addEventListener(NumberSelecter.NUMBER_CLOSE,this.__numberClose);
         this._submitButton.addEventListener(MouseEvent.CLICK,this.__submit);
      }
      
      private function __selectHandler(param1:Event) : void
      {
         this._goodCount = this._number.number;
         if(this._goodCount > MilitaryRankManager.Instance.getRankShopItemCount(this._shopItem.ID) && MilitaryRankManager.Instance.getRankShopItemCount(this._shopItem.ID) > -1000)
         {
            this._goodCount = MilitaryRankManager.Instance.getRankShopItemCount(this._shopItem.ID);
            this._number.number = this._goodCount;
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("militaryrank.shop.countLimit",this._goodCount));
         }
         this.refreshNumText();
      }
      
      private function __numberClose(param1:Event) : void
      {
         dispatchEvent(param1);
      }
      
      private function __submit(param1:MouseEvent) : void
      {
         dispatchEvent(new FrameEvent(FrameEvent.SUBMIT_CLICK));
      }
      
      private function initInfo() : void
      {
         this._itemTemplateInfo = ItemManager.Instance.getTemplateById(this._itemID);
         this._cell.info = this._itemTemplateInfo;
      }
      
      private function refreshNumText() : void
      {
         var _loc2_:Price = null;
         var _loc1_:int = 0;
         while(_loc1_ < 2)
         {
            _loc2_ = this._shopItem.getItemPrice(0).getPrice(_loc1_);
            this._payTypeList[_loc1_].gotoAndStop(-_loc2_.Unit);
            if(PlayerManager.Instance.Self.getMoneyByType(_loc2_.Unit) < _loc2_.Value * this._goodCount)
            {
               this._priceTxtList[_loc1_].htmlText = LanguageMgr.GetTranslation("redTxt",_loc2_.Value * this._goodCount);
            }
            else
            {
               this._priceTxtList[_loc1_].htmlText = String(_loc2_.Value * this._goodCount);
            }
            this._payTypeList[_loc1_].visible = this._priceTxtList[_loc1_].visible = _loc2_.Value != 0;
            _loc1_++;
         }
      }
      
      override public function dispose() : void
      {
         if(this._number)
         {
            this._number.removeEventListener(Event.CANCEL,this.__selectHandler);
            this._number.removeEventListener(NumberSelecter.NUMBER_CLOSE,this.__numberClose);
            ObjectUtils.disposeObject(this._number);
         }
         this._submitButton.removeEventListener(MouseEvent.CLICK,this.__submit);
         ObjectUtils.disposeObject(this._bg);
         this._bg = null;
         ObjectUtils.disposeObject(this._priceTxtList[0]);
         this._priceTxtList[0] = null;
         ObjectUtils.disposeObject(this._priceTxtList[1]);
         this._priceTxtList[1] = null;
         this._priceTxtList.length = 0;
         this._priceTxtList = null;
         ObjectUtils.disposeObject(this._submitButton);
         this._submitButton = null;
         ObjectUtils.disposeObject(this._totalTipText);
         this._totalTipText = null;
         ObjectUtils.disposeObject(this._payTypeList[0]);
         this._payTypeList[0] = null;
         ObjectUtils.disposeObject(this._payTypeList[1]);
         this._payTypeList[1] = null;
         this._payTypeList.length = 0;
         this._payTypeList = null;
         ObjectUtils.disposeObject(this._cell);
         this._cell = null;
         this._number = null;
         this._itemTemplateInfo = null;
         this._shopItem = null;
         if(parent)
         {
            parent.removeChild(this);
         }
      }
   }
}
