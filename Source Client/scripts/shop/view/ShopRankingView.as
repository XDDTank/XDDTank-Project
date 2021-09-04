package shop.view
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.Scale9CornerImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.goods.ShopItemInfo;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.ShopManager;
   import ddt.manager.SoundManager;
   import flash.display.Sprite;
   import flash.events.FocusEvent;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import shop.ShopController;
   
   public class ShopRankingView extends Sprite implements Disposeable
   {
       
      
      private var _controller:ShopController;
      
      private var _shopSearchBg:Scale9CornerImage;
      
      private var _shopSearchBtn:BaseButton;
      
      private var _shopSearchText:FilterFrameText;
      
      private var _currentShopSearchText:String;
      
      private var _currentList:Vector.<ShopItemInfo>;
      
      public function ShopRankingView()
      {
         super();
      }
      
      public function setup(param1:ShopController) : void
      {
         this._controller = param1;
         this.initView();
         this.addEvent();
      }
      
      private function initView() : void
      {
         this._shopSearchBg = ComponentFactory.Instance.creatComponentByStylename("ddtshop.ShopSearchBg");
         addChild(this._shopSearchBg);
         this._shopSearchBtn = ComponentFactory.Instance.creatComponentByStylename("ddtshop.ShopSearchBtn");
         addChild(this._shopSearchBtn);
         this._shopSearchText = ComponentFactory.Instance.creatComponentByStylename("ddtshop.ShopSearchText");
         this._shopSearchText.text = LanguageMgr.GetTranslation("shop.view.ShopRankingView.shopSearchText");
         addChild(this._shopSearchText);
      }
      
      private function addEvent() : void
      {
         this._shopSearchText.addEventListener(FocusEvent.FOCUS_IN,this.__shopSearchTextFousIn);
         this._shopSearchText.addEventListener(FocusEvent.FOCUS_OUT,this.__shopSearchTextFousOut);
         this._shopSearchText.addEventListener(KeyboardEvent.KEY_DOWN,this.__shopSearchTextKeyDown);
         this._shopSearchBtn.addEventListener(MouseEvent.CLICK,this.__shopSearchBtnClick);
      }
      
      private function removeEvent() : void
      {
         this._shopSearchText.removeEventListener(FocusEvent.FOCUS_IN,this.__shopSearchTextFousIn);
         this._shopSearchText.removeEventListener(FocusEvent.FOCUS_OUT,this.__shopSearchTextFousOut);
         this._shopSearchText.removeEventListener(KeyboardEvent.KEY_DOWN,this.__shopSearchTextKeyDown);
         this._shopSearchBtn.removeEventListener(MouseEvent.CLICK,this.__shopSearchBtnClick);
      }
      
      protected function __shopSearchTextKeyDown(param1:KeyboardEvent) : void
      {
         if(param1.keyCode == 13)
         {
            this.__shopSearchBtnClick();
         }
      }
      
      protected function __shopSearchTextFousIn(param1:FocusEvent) : void
      {
         if(this._shopSearchText.text == LanguageMgr.GetTranslation("shop.view.ShopRankingView.shopSearchText"))
         {
            this._shopSearchText.text = "";
         }
      }
      
      protected function __shopSearchTextFousOut(param1:FocusEvent) : void
      {
         if(this._shopSearchText.text.length == 0)
         {
            this._shopSearchText.text = LanguageMgr.GetTranslation("shop.view.ShopRankingView.shopSearchText");
         }
      }
      
      protected function __shopSearchBtnClick(param1:MouseEvent = null) : void
      {
         var _loc2_:Vector.<ShopItemInfo> = null;
         SoundManager.instance.play("008");
         if(this._shopSearchText.text == LanguageMgr.GetTranslation("shop.view.ShopRankingView.shopSearchText") || this._shopSearchText.text.length == 0)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("shop.view.ShopRankingView.PleaseEnterTheKeywords"));
            return;
         }
         if(this._currentShopSearchText != this._shopSearchText.text)
         {
            this._currentShopSearchText = this._shopSearchText.text;
            _loc2_ = ShopManager.Instance.getDesignatedAllShopItem();
            _loc2_ = ShopManager.Instance.fuzzySearch(_loc2_,this._currentShopSearchText);
            this._currentList = _loc2_;
         }
         else
         {
            _loc2_ = this._currentList;
         }
         if(_loc2_.length > 0)
         {
            this._controller.rightView.searchList(_loc2_);
         }
         else
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("shop.view.ShopRankingView.NoSearchResults"));
         }
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         ObjectUtils.disposeObject(this._shopSearchBg);
         this._shopSearchBg = null;
         ObjectUtils.disposeObject(this._shopSearchBtn);
         this._shopSearchBtn = null;
         ObjectUtils.disposeObject(this._shopSearchText);
         this._shopSearchText = null;
         if(parent)
         {
            parent.removeChild(this);
         }
      }
   }
}
