package auctionHouse.view
{
   import auctionHouse.event.AuctionHouseEvent;
   import auctionHouse.model.AuctionHouseModel;
   import com.pickgliss.toplevel.StageReferance;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.controls.ScrollPanel;
   import com.pickgliss.ui.controls.SimpleDropListTarget;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.Scale9CornerImage;
   import com.pickgliss.ui.image.ScaleFrameImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.goods.CateCoryInfo;
   import ddt.manager.LanguageMgr;
   import ddt.manager.SoundManager;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.ui.Keyboard;
   import flash.utils.Dictionary;
   
   public class BrowseLeftMenuView extends Sprite implements Disposeable
   {
      
      private static const ALL:int = -1;
      
      private static const DRESS_UP:int = 1;
      
      private static const CLOTH:int = 101;
      
      private static const HAT:int = 102;
      
      private static const HAIR:int = 103;
      
      private static const EYES:int = 104;
      
      private static const FACE:int = 105;
      
      private static const FASHION:int = 106;
      
      private static const DECRORATE:int = 107;
      
      private static const GLASS:int = 108;
      
      private static const PAOPAO:int = 109;
      
      private static const CAILIAO:int = 2;
      
      private static const CAIJINGSHI:int = 201;
      
      private static const CAILIAO1:int = 202;
      
      private static const CAILIAO2:int = 203;
      
      private static const CAILIAO3:int = 204;
      
      private static const CAILIAO4:int = 205;
      
      private static const CAILIAO5:int = 206;
      
      private static const CAILIAO6:int = 207;
      
      private static const CAILIAO7:int = 208;
      
      private static const FROMULE:int = 3;
      
      private static const FROMULE1:int = 301;
      
      private static const FROMULE2:int = 302;
      
      private static const FROMULE3:int = 303;
      
      private static const FROMULE4:int = 304;
      
      private static const FROMULE5:int = 305;
      
      private static const FROMULE6:int = 306;
      
      private static const FROMULE7:int = 307;
      
      private static const WEAPON:int = 4;
      
      private static const WEAPON1:int = 401;
      
      private static const WEAPON2:int = 402;
      
      private static const WEAPON3:int = 403;
      
      private static const WEAPON4:int = 404;
      
      private static const WEAPON5:int = 405;
      
      private static const WEAPON6:int = 406;
      
      private static const WEAPON7:int = 407;
      
      private static const OTHER:int = 5;
      
      private static const OTHERPOPRO:int = 501;
      
      private static const ALL_IDS:Array = [CLOTH,HAT,HAIR,EYES,FACE,FASHION,DECRORATE,GLASS,PAOPAO,CAIJINGSHI,CAILIAO1,CAILIAO2,CAILIAO3,CAILIAO4,CAILIAO5,CAILIAO6,CAILIAO7,FROMULE1,FROMULE2,FROMULE3,FROMULE4,FROMULE5,FROMULE6,FROMULE7,WEAPON1,WEAPON2,WEAPON3,WEAPON4,WEAPON5,WEAPON6,WEAPON7,OTHERPOPRO];
      
      private static const ALL_NAMES:Array = ["shop.ShopRightView.SubBtn.cloth","shop.ShopRightView.SubBtn.hat","shop.ShopRightView.SubBtn.hair","shop.ShopRightView.SubBtn.eye","shop.ShopRightView.SubBtn.face","shop.ShopRightView.SubBtn.suit","shop.ShopRightView.SubBtn.wing","shop.ShopRightView.SubBtn.glasses","shop.ShopRightView.SubBtn.Bubble","tank.auctionHouse.view.caijingshi","tank.auctionHouse.view.cailiao1","tank.auctionHouse.view.cailiao2","tank.auctionHouse.view.cailiao3","tank.auctionHouse.view.cailiao4","tank.auctionHouse.view.cailiao5","tank.auctionHouse.view.cailiao6","tank.auctionHouse.view.cailiao7","tank.auctionHouse.view.gongshi1","tank.auctionHouse.view.gongshi2","tank.auctionHouse.view.gongshi3","tank.auctionHouse.view.gongshi4","tank.auctionHouse.view.gongshi5","tank.auctionHouse.view.gongshi6","tank.auctionHouse.view.gongshi7","tank.auctionHouse.view.weapon1","tank.auctionHouse.view.weapon2","tank.auctionHouse.view.weapon3","tank.auctionHouse.view.weapon4","tank.auctionHouse.view.weapon5","tank.auctionHouse.view.weapon6","tank.auctionHouse.view.weapon7","tank.auctionHouse.view.otherpopro"];
       
      
      private var menu:VerticalMenu;
      
      private var list:ScrollPanel;
      
      private var _name:SimpleDropListTarget;
      
      private var searchStatus:Boolean;
      
      private var _equip:Bitmap;
      
      private var _cloth:Bitmap;
      
      private var _sphere:Bitmap;
      
      private var _prop:Bitmap;
      
      private var _gongshi:Bitmap;
      
      private var _searchBtn:BaseButton;
      
      private var _WuqiFont:ScaleFrameImage;
      
      private var _searchValue:String;
      
      private var _glowState:Boolean;
      
      private var _dictionary:Dictionary;
      
      private var _dimListArr:Array;
      
      private var _isForAll:Boolean = true;
      
      private var _isFindAll:Boolean = false;
      
      public function BrowseLeftMenuView()
      {
         this._equip = ComponentFactory.Instance.creatBitmap("asset.ddtauctionHouse.equip");
         this._cloth = ComponentFactory.Instance.creatBitmap("asset.ddtauctionHouse.cloth");
         this._sphere = ComponentFactory.Instance.creatBitmap("asset.auctionHouse.cailiaoIcon");
         this._prop = ComponentFactory.Instance.creatBitmap("asset.ddtauctionHouse.prop");
         this._gongshi = ComponentFactory.Instance.creatBitmap("asset.auctionHouse.gongshi");
         super();
         this.initView();
         this.addEvent();
      }
      
      private function initView() : void
      {
         var _loc1_:Bitmap = ComponentFactory.Instance.creatBitmap("auctionHouse.LeftBG1");
         addChild(_loc1_);
         var _loc2_:Scale9CornerImage = ComponentFactory.Instance.creatComponentByStylename("asset.auctionHouse.Browse.baiduBG");
         addChild(_loc2_);
         this._searchBtn = ComponentFactory.Instance.creatComponentByStylename("auctionHouse.baidu_btn");
         addChild(this._searchBtn);
         this._name = ComponentFactory.Instance.creat("auctionHouse.baiduText");
         this._searchValue = "";
         this._name.maxChars = 20;
         addChild(this._name);
         this.list = ComponentFactory.Instance.creat("auctionHouse.BrowseLeftScrollpanel");
         addChild(this.list);
         this.list.hScrollProxy = ScrollPanel.OFF;
         this.list.vScrollProxy = ScrollPanel.ON;
         this.menu = new VerticalMenu(11,45,33);
         this.list.setView(this.menu);
         this._dictionary = new Dictionary();
         this._dimListArr = new Array();
      }
      
      private function menuRefrash(param1:Event) : void
      {
         this._isFindAll = ((param1.currentTarget as VerticalMenu).currentItem as BrowseLeftMenuItem).isOpen;
         this.list.invalidateViewport();
      }
      
      private function addEvent() : void
      {
         StageReferance.stage.addEventListener(MouseEvent.CLICK,this._clickStage);
         this._name.addEventListener(MouseEvent.MOUSE_DOWN,this._clickName);
         this._name.addEventListener(Event.CHANGE,this._nameChange);
         this._name.addEventListener(KeyboardEvent.KEY_UP,this._nameKeyUp);
         this._name.addEventListener(Event.ADDED_TO_STAGE,this.setFocus);
         this._searchBtn.addEventListener(MouseEvent.CLICK,this.__searchCondition);
         this.menu.addEventListener(VerticalMenu.MENU_CLICKED,this.menuItemClick);
         this.menu.addEventListener(VerticalMenu.MENU_REFRESH,this.menuRefrash);
      }
      
      private function removeEvent() : void
      {
         StageReferance.stage.removeEventListener(MouseEvent.CLICK,this._clickStage);
         this._name.removeEventListener(MouseEvent.MOUSE_DOWN,this._clickName);
         this._name.removeEventListener(Event.CHANGE,this._nameChange);
         this._name.removeEventListener(KeyboardEvent.KEY_UP,this._nameKeyUp);
         this._name.removeEventListener(Event.ADDED_TO_STAGE,this.setFocus);
         this._searchBtn.removeEventListener(MouseEvent.CLICK,this.__searchCondition);
         this.menu.removeEventListener(VerticalMenu.MENU_CLICKED,this.menuItemClick);
         this.menu.removeEventListener(VerticalMenu.MENU_REFRESH,this.menuRefrash);
      }
      
      private function _clickName(param1:MouseEvent) : void
      {
         if(this._name.text == LanguageMgr.GetTranslation("tank.auctionHouse.view.pleaseInputOnThere"))
         {
            this._name.text = "";
         }
      }
      
      private function setFocus(param1:Event) : void
      {
         this._name.text = LanguageMgr.GetTranslation("tank.auctionHouse.view.pleaseInputOnThere");
         this._searchValue = "";
         this._name.setFocus();
         this._name.setCursor(this._name.text.length);
      }
      
      public function setFocusName() : void
      {
         this._name.setFocus();
      }
      
      function getInfo() : CateCoryInfo
      {
         if(this._isForAll)
         {
            return this.getMainCateInfo(ALL,LanguageMgr.GetTranslation("tank.auctionHouse.view.BrowseLeftMenuView.All"));
         }
         if(this.menu.currentItem)
         {
            return this.menu.currentItem.info as CateCoryInfo;
         }
         return this.getMainCateInfo(ALL,LanguageMgr.GetTranslation("tank.auctionHouse.view.BrowseLeftMenuView.All"));
      }
      
      function setSelectType(param1:CateCoryInfo) : void
      {
      }
      
      function getType() : int
      {
         if(this._isForAll)
         {
            return -1;
         }
         if(this.menu.currentItem)
         {
            return this.menu.currentItem.info.ID;
         }
         return -1;
      }
      
      function setCategory(param1:Vector.<CateCoryInfo>) : void
      {
         var _loc10_:CateCoryInfo = null;
         var _loc11_:BrowseLeftMenuItem = null;
         LanguageMgr.GetTranslation("tank.auctionHouse.view.BrowseLeftMenuView.Weapon");
         var _loc2_:BrowseLeftMenuItem = new BrowseLeftMenuItem(new BrowserLeftStripAsset(ComponentFactory.Instance.creatComponentByStylename("ddtauctionHouse.fuzhuang")),this.getMainCateInfo(DRESS_UP,LanguageMgr.GetTranslation("")));
         var _loc3_:BrowseLeftMenuItem = new BrowseLeftMenuItem(new BrowserLeftStripAsset(ComponentFactory.Instance.creatComponentByStylename("ddtauctionHouse.prop")),this.getMainCateInfo(OTHER,LanguageMgr.GetTranslation("")));
         var _loc4_:BrowseLeftMenuItem = new BrowseLeftMenuItem(new BrowserLeftStripAsset(ComponentFactory.Instance.creatComponentByStylename("ddtauctionHouse.equip")),this.getMainCateInfo(WEAPON,LanguageMgr.GetTranslation("")));
         var _loc5_:BrowseLeftMenuItem = new BrowseLeftMenuItem(new BrowserLeftStripAsset(ComponentFactory.Instance.creatComponentByStylename("ddtauctionHouse.cailiao")),this.getMainCateInfo(CAILIAO,LanguageMgr.GetTranslation("")));
         var _loc6_:BrowseLeftMenuItem = new BrowseLeftMenuItem(new BrowserLeftStripAsset(ComponentFactory.Instance.creatComponentByStylename("ddtauctionHouse.gongshi")),this.getMainCateInfo(FROMULE,LanguageMgr.GetTranslation("")));
         this._equip = ComponentFactory.Instance.creatBitmap("asset.ddtauctionHouse.equip");
         this._cloth = ComponentFactory.Instance.creatBitmap("asset.ddtauctionHouse.cloth");
         this._sphere = ComponentFactory.Instance.creatBitmap("asset.auctionHouse.cailiaoIcon");
         this._prop = ComponentFactory.Instance.creatBitmap("asset.ddtauctionHouse.prop");
         this._gongshi = ComponentFactory.Instance.creatBitmap("asset.auctionHouse.gongshi");
         this.menu.addItemAt(_loc2_,-1);
         this.menu.addItemAt(_loc5_,-1);
         this.menu.addItemAt(_loc6_,-1);
         this.menu.addItemAt(_loc4_,-1);
         this.menu.addItemAt(_loc3_,-1);
         _loc4_.addChild(this._equip);
         _loc2_.addChild(this._cloth);
         _loc5_.addChild(this._sphere);
         _loc3_.addChild(this._prop);
         _loc6_.addChild(this._gongshi);
         var _loc7_:Array = [9,17,24,31,32];
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         while(_loc9_ < 35)
         {
            if(_loc9_ == _loc7_[_loc8_])
            {
               _loc8_++;
            }
            _loc10_ = new CateCoryInfo();
            _loc10_.ID = ALL_IDS[_loc9_];
            _loc10_.Name = LanguageMgr.GetTranslation(ALL_NAMES[_loc9_]);
            _loc11_ = new BrowseLeftMenuItem(new BrowserLeftSubStripAsset(),_loc10_);
            this.menu.addItemAt(_loc11_,_loc8_);
            _loc9_++;
         }
         this.list.invalidateViewport();
      }
      
      private function getMainCateInfo(param1:int, param2:String) : CateCoryInfo
      {
         var _loc3_:CateCoryInfo = new CateCoryInfo();
         _loc3_.ID = param1;
         _loc3_.Name = param2;
         return _loc3_;
      }
      
      private function _nameKeyUp(param1:KeyboardEvent) : void
      {
         if(param1.keyCode == Keyboard.ENTER)
         {
            AuctionHouseModel._dimBooble = false;
            if(!this._isFindAll)
            {
               this.__searchGoods(true);
               return;
            }
            this.__searchGoods(false);
         }
      }
      
      private function _nameChange(param1:Event) : void
      {
         if(this._name.text.indexOf(LanguageMgr.GetTranslation("tank.auctionHouse.view.pleaseInputOnThere")) > -1)
         {
            this._name.text = this._name.text.replace(LanguageMgr.GetTranslation("tank.auctionHouse.view.pleaseInputOnThere"),"");
         }
      }
      
      private function _clickStage(param1:MouseEvent) : void
      {
         var _loc2_:int = this._dimListArr.length - 1;
         while(_loc2_ >= 0)
         {
            if(this._dimListArr[_loc2_].parent)
            {
               this._dimListArr[_loc2_].dispose();
            }
            _loc2_--;
         }
         this._dimListArr = new Array();
      }
      
      private function __selectedDrop(param1:Event) : void
      {
         AuctionHouseModel._dimBooble = false;
         this.__searchGoods(false);
      }
      
      public function get searchText() : String
      {
         return this._searchValue;
      }
      
      public function set setSearchStatus(param1:Boolean) : void
      {
         this.searchStatus = param1;
      }
      
      public function set searchText(param1:String) : void
      {
         this._name.text = param1;
         this._searchValue = param1;
      }
      
      private function __searchCondition(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         AuctionHouseModel._dimBooble = false;
         if(!this._isFindAll)
         {
            this.__searchGoods(true);
            return;
         }
         this.__searchGoods(false);
      }
      
      private function __searchGoods(param1:Boolean = false) : void
      {
         this._isForAll = param1;
         AuctionHouseModel._dimBooble = false;
         this._clickStage(new MouseEvent("*"));
         if(this._name.text == LanguageMgr.GetTranslation("tank.auctionHouse.view.pleaseInputOnThere"))
         {
            this._name.text = "";
         }
         this._dictionary = new Dictionary();
         this._searchValue = "";
         this._name.text = this._trim(this._name.text);
         this._searchValue = this._name.text;
         AuctionHouseModel.searchType = 2;
         dispatchEvent(new AuctionHouseEvent(AuctionHouseEvent.SELECT_STRIP));
         this._name.stage.focus = FilterFrameText(this._name);
         var _loc2_:int = this._dimListArr.length - 1;
         while(_loc2_ >= 0)
         {
            if(this._dimListArr[_loc2_].parent)
            {
               this._dimListArr[_loc2_].parent.removeChild(this._dimListArr[_loc2_]);
            }
            _loc2_--;
         }
         this._dimListArr = new Array();
      }
      
      private function __searchGoodsII(param1:Boolean = false) : void
      {
         this._isForAll = param1;
         AuctionHouseModel._dimBooble = false;
         this._clickStage(new MouseEvent("*"));
         this._dictionary = new Dictionary();
         this._searchValue = "";
         AuctionHouseModel.searchType = 2;
         dispatchEvent(new AuctionHouseEvent(AuctionHouseEvent.SELECT_STRIP));
         var _loc2_:int = this._dimListArr.length - 1;
         while(_loc2_ >= 0)
         {
            if(this._dimListArr[_loc2_].parent)
            {
               this._dimListArr[_loc2_].parent.removeChild(this._dimListArr[_loc2_]);
            }
            _loc2_--;
         }
         this._dimListArr = new Array();
      }
      
      private function _trim(param1:String) : String
      {
         if(!param1)
         {
            return param1;
         }
         return param1.replace(/(^\s*)|(\s*$)/g,"");
      }
      
      private function menuItemClick(param1:Event) : void
      {
         this.list.invalidateViewport();
         if(this.menu.isseach)
         {
            AuctionHouseModel._dimBooble = false;
            this.__searchGoodsII();
         }
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         if(this._searchBtn)
         {
            this._searchBtn.removeEventListener(MouseEvent.CLICK,this.__searchCondition);
         }
         if(this.menu)
         {
            this.menu.removeEventListener(VerticalMenu.MENU_CLICKED,this.menuItemClick);
            this.menu.dispose();
            this.menu = null;
         }
         ObjectUtils.disposeObject(this._equip);
         this._equip = null;
         ObjectUtils.disposeObject(this._cloth);
         this._cloth = null;
         ObjectUtils.disposeObject(this._sphere);
         this._sphere = null;
         ObjectUtils.disposeObject(this._prop);
         this._prop = null;
         ObjectUtils.disposeObject(this._gongshi);
         this._gongshi = null;
         if(this.list)
         {
            ObjectUtils.disposeObject(this.list);
            this.list = null;
         }
         if(this._name)
         {
            ObjectUtils.disposeObject(this._name);
         }
         this._name = null;
         if(this._searchBtn)
         {
            ObjectUtils.disposeObject(this._searchBtn);
         }
         this._searchBtn = null;
         ObjectUtils.disposeAllChildren(this);
         if(parent)
         {
            parent.removeChild(this);
         }
      }
   }
}
