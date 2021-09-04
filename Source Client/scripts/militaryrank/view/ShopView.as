package militaryrank.view
{
   import bagAndInfo.info.MoneyInfoView;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.container.SimpleTileList;
   import com.pickgliss.ui.core.Component;
   import com.pickgliss.ui.image.Scale9CornerImage;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.ShopType;
   import ddt.data.goods.Price;
   import ddt.data.goods.ShopItemInfo;
   import ddt.data.player.SelfInfo;
   import ddt.events.PlayerPropertyEvent;
   import ddt.manager.PlayerManager;
   import ddt.manager.ShopManager;
   import ddt.view.controls.PageSelector;
   import flash.display.Bitmap;
   import flash.events.Event;
   
   public class ShopView extends Component
   {
      
      public static const COUNT_PER_PAGE:int = 6;
       
      
      private var _bg:Scale9CornerImage;
      
      private var _shopItemList:Vector.<MilitaryShopItem>;
      
      private var _listView:SimpleTileList;
      
      private var _pageSelector:PageSelector;
      
      private var _goldBg:Bitmap;
      
      private var _matchMedal:MoneyInfoView;
      
      private var _exploitView:MoneyInfoView;
      
      private var _goldView:MoneyInfoView;
      
      private var _shopInfoList:Vector.<ShopItemInfo>;
      
      private var _self:SelfInfo;
      
      public function ShopView()
      {
         super();
         this.initData();
         this.initEvent();
      }
      
      override protected function init() : void
      {
         this._bg = ComponentFactory.Instance.creatComponentByStylename("asset.militaryrank.shopView.bg");
         addChild(this._bg);
         this.createItems();
         this._pageSelector = ComponentFactory.Instance.creat("militaryrank.shopView.pageSelector");
         addChild(this._pageSelector);
         this._goldBg = ComponentFactory.Instance.creatBitmap("asset.militaryrank.goldBg");
         addChild(this._goldBg);
         this._matchMedal = ComponentFactory.Instance.creat("militaryrank.shopView.matchView",[Price.MATCH_MEDAL]);
         this._exploitView = ComponentFactory.Instance.creat("militaryrank.shopView.exploitView",[Price.ARMY_EXPLOIT]);
         this._goldView = ComponentFactory.Instance.creat("militaryrank.shopView.goldView",[Price.GOLD]);
         addChild(this._matchMedal);
         addChild(this._exploitView);
         addChild(this._goldView);
      }
      
      private function createItems() : void
      {
         var _loc2_:MilitaryShopItem = null;
         this._listView = ComponentFactory.Instance.creatCustomObject("militaryrank.shopView.listView",[2]);
         this._shopItemList = new Vector.<MilitaryShopItem>(COUNT_PER_PAGE);
         var _loc1_:int = 0;
         while(_loc1_ < COUNT_PER_PAGE)
         {
            _loc2_ = new MilitaryShopItem();
            this._shopItemList[_loc1_] = _loc2_;
            this._listView.addChild(_loc2_);
            _loc1_++;
         }
         addChild(this._listView);
      }
      
      private function initEvent() : void
      {
         this._pageSelector.addEventListener(Event.CHANGE,this.__pageChange);
         this._self.addEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,this.__propertyChanged);
      }
      
      protected function __propertyChanged(param1:PlayerPropertyEvent) : void
      {
         this._exploitView.setInfo(this._self);
         this._matchMedal.setInfo(this._self);
         this._goldView.setInfo(this._self);
         this.setpage(this._pageSelector.page);
      }
      
      private function removeEvent() : void
      {
         this._pageSelector.removeEventListener(Event.CHANGE,this.__pageChange);
         this._self.removeEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,this.__propertyChanged);
      }
      
      protected function __pageChange(param1:Event) : void
      {
         this.setpage(this._pageSelector.page);
      }
      
      private function initData() : void
      {
         this._shopInfoList = ShopManager.Instance.getValidSortedGoodsByType(ShopType.ARMY_EXPLOIT_SHOP,1,COUNT_PER_PAGE);
         this._pageSelector.maxPage = ShopManager.Instance.getResultPages(ShopType.ARMY_EXPLOIT_SHOP,COUNT_PER_PAGE);
         this.setpage(1);
         this._self = PlayerManager.Instance.Self;
         this._exploitView.setInfo(this._self);
         this._matchMedal.setInfo(this._self);
         this._goldView.setInfo(this._self);
      }
      
      private function setpage(param1:int) : void
      {
         this._shopInfoList.length = 0;
         this._shopInfoList = ShopManager.Instance.getValidSortedGoodsByType(ShopType.ARMY_EXPLOIT_SHOP,this._pageSelector.page,COUNT_PER_PAGE);
         var _loc2_:int = 0;
         while(_loc2_ < COUNT_PER_PAGE)
         {
            this._shopItemList[_loc2_].shopItemInfo = _loc2_ < this._shopInfoList.length ? this._shopInfoList[_loc2_] : null;
            _loc2_++;
         }
      }
      
      override public function dispose() : void
      {
         super.dispose();
         this.removeEvent();
         ObjectUtils.disposeObject(this._bg);
         this._bg = null;
         while(this._shopItemList.length > 0)
         {
            this._shopItemList.shift().dispose();
         }
         this._shopItemList = null;
         ObjectUtils.disposeObject(this._listView);
         this._listView = null;
         ObjectUtils.disposeObject(this._pageSelector);
         this._pageSelector = null;
         ObjectUtils.disposeObject(this._goldBg);
         this._goldBg = null;
         ObjectUtils.disposeObject(this._exploitView);
         this._exploitView = null;
         ObjectUtils.disposeObject(this._matchMedal);
         this._matchMedal = null;
         ObjectUtils.disposeObject(this._goldView);
         this._goldView = null;
         this._shopInfoList.length = 0;
         this._shopInfoList = null;
         this._self = null;
      }
   }
}
