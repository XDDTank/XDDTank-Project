package shop.view
{
   import com.greensock.TimelineLite;
   import com.greensock.TweenLite;
   import com.greensock.TweenProxy;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.controls.ISelectable;
   import com.pickgliss.ui.controls.SelectedButton;
   import com.pickgliss.ui.controls.SelectedButtonGroup;
   import com.pickgliss.ui.controls.SelectedTextButton;
   import com.pickgliss.ui.controls.container.HBox;
   import com.pickgliss.ui.controls.container.VBox;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.Image;
   import com.pickgliss.ui.image.ScaleLeftRightImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.DisplayUtils;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.EquipType;
   import ddt.data.ShopType;
   import ddt.data.goods.ShopCarItemInfo;
   import ddt.data.goods.ShopItemInfo;
   import ddt.events.ItemEvent;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SavePointManager;
   import ddt.manager.ShopManager;
   import ddt.manager.SoundManager;
   import ddt.manager.TaskManager;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import shop.ShopController;
   import shop.ShopEvent;
   import trainer.data.ArrowType;
   import trainer.view.NewHandContainer;
   
   public class ShopRightView extends Sprite implements Disposeable
   {
      
      public static const VIP_SHOPID:int = 60;
      
      public static const M_SPECIALPROPS:int = 30;
      
      public static const F_SPECIALPROPS:int = 31;
      
      public static const TOP_RECOMMEND:uint = 0;
      
      public static const SHOP_ITEM_NUM:uint = 12;
      
      public static var CURRENT_GENDER:int = -1;
      
      public static var CURRENT_MONEY_TYPE:int = 1;
      
      public static var CURRENT_PAGE:int = 1;
      
      public static var TOP_TYPE:int = 0;
      
      public static var SUB_TYPE:int = 0;
      
      public static const SHOW_LIGHT:String = "SHOW_LIGHT";
      
      private static var isDiscountType:Boolean = false;
       
      
      private var _bg:Image;
      
      private var _bg1:Bitmap;
      
      private var _controller:ShopController;
      
      private var _currentPageTxt:FilterFrameText;
      
      private var _currentPageInput:ScaleLeftRightImage;
      
      private var _femaleBtn:SelectedButton;
      
      private var _genderContainer:VBox;
      
      private var _genderGroup:SelectedButtonGroup;
      
      private var _rightViewTitleBg:Bitmap;
      
      private var _goodItemContainerAll:Sprite;
      
      private var _goodItemContainerBg:Bitmap;
      
      private var _goodItemGroup:SelectedButtonGroup;
      
      private var _goodItems:Vector.<ShopGoodItem>;
      
      private var _maleBtn:SelectedButton;
      
      private var _firstPage:BaseButton;
      
      private var _prePageBtn:BaseButton;
      
      private var _nextPageBtn:BaseButton;
      
      private var _endPageBtn:BaseButton;
      
      private var _subBtns:Vector.<SelectedTextButton>;
      
      private var _subBtnsContainers:Vector.<HBox>;
      
      private var _subBtnsGroups:Vector.<SelectedButtonGroup>;
      
      private var _currentSubBtnContainerIndex:int;
      
      private var _topBtns:Vector.<SelectedTextButton>;
      
      private var _topBtnsContainer:HBox;
      
      private var _topBtnsGroup:SelectedButtonGroup;
      
      private var _shopSearchBox:Sprite;
      
      private var _shopSearchEndBtnBg:Bitmap;
      
      private var _shopSearchColseBtn:BaseButton;
      
      private var _rightItemLightMc:MovieClip;
      
      private var _tempTopType:int = -1;
      
      private var _tempCurrentPage:int = -1;
      
      private var _tempSubBtnHBox:HBox;
      
      private var _isSearch:Boolean;
      
      private var _searchShopItemList:Vector.<ShopItemInfo>;
      
      private var _searchItemTotalPage:int;
      
      public function ShopRightView()
      {
         super();
      }
      
      public function get genderGroup() : SelectedButtonGroup
      {
         return this._genderGroup;
      }
      
      public function setup(param1:ShopController) : void
      {
         this._controller = param1;
         this.init();
      }
      
      private function init() : void
      {
         this._bg = ComponentFactory.Instance.creat("ddtshop.RightViewBg");
         addChild(this._bg);
         this._rightViewTitleBg = ComponentFactory.Instance.creatBitmap("asset.ddtshop.RightViewTitleBg");
         addChild(this._rightViewTitleBg);
         this.initBtns();
         this.initEvent();
         if(CURRENT_GENDER < 0)
         {
            this.setCurrentSex(!!PlayerManager.Instance.Self.Sex ? int(1) : int(2));
         }
      }
      
      private function initBtns() : void
      {
         var topBtnTextTranslation:Array = null;
         var subBtnTextTranslation:Array = null;
         var dx:Number = NaN;
         var dy:Number = NaN;
         var k:uint = 0;
         var i:uint = 0;
         this._topBtns = new Vector.<SelectedTextButton>();
         this._topBtnsGroup = new SelectedButtonGroup();
         this._subBtns = new Vector.<SelectedTextButton>();
         this._subBtnsContainers = new Vector.<HBox>();
         this._subBtnsGroups = new Vector.<SelectedButtonGroup>();
         this._genderGroup = new SelectedButtonGroup();
         this._goodItems = new Vector.<ShopGoodItem>();
         this._goodItemGroup = new SelectedButtonGroup();
         this._firstPage = ComponentFactory.Instance.creat("ddtshop.BtnFirstPage");
         this._prePageBtn = ComponentFactory.Instance.creat("ddtshop.BtnPrePage");
         this._nextPageBtn = ComponentFactory.Instance.creat("ddtshop.BtnNextPage");
         this._endPageBtn = ComponentFactory.Instance.creat("ddtshop.BtnEndPage");
         this._currentPageTxt = ComponentFactory.Instance.creatComponentByStylename("ddtshop.CurrentPage");
         this._currentPageInput = ComponentFactory.Instance.creatComponentByStylename("ddtshop.CurrentPageInput");
         this._topBtnsContainer = ComponentFactory.Instance.creat("ddtshop.TopBtnContainer");
         var topBtnStyleName:Array = ["ddtshop.TopBtnFashionArea","ddtshop.TopBtnPropArea"];
         topBtnTextTranslation = ["shop.ShopRightView.TopBtn.FashionArea","shop.ShopRightView.TopBtn.propArea"];
         topBtnStyleName.forEach(function(param1:*, param2:int, param3:Array):void
         {
            var _loc4_:SelectedTextButton = ComponentFactory.Instance.creat(param1 as String);
            _loc4_.text = LanguageMgr.GetTranslation(topBtnTextTranslation[param2]);
            _topBtns.push(_loc4_);
         });
         this._goodItemContainerBg = ComponentFactory.Instance.creatBitmap("ddtshop.GoodItemContainerBg");
         addChild(this._goodItemContainerBg);
         this._genderContainer = ComponentFactory.Instance.creat("ddtshop.GenderBtnContainer");
         this._maleBtn = ComponentFactory.Instance.creat("ddtshop.GenderBtnMale");
         this._femaleBtn = ComponentFactory.Instance.creat("ddtshop.GenderBtnFemale");
         this._rightItemLightMc = ComponentFactory.Instance.creatCustomObject("ddtshop.RightItemLightMc");
         this._goodItemContainerAll = ComponentFactory.Instance.creatCustomObject("ddtshop.GoodItemContainerAll");
         i = 0;
         while(i < SHOP_ITEM_NUM)
         {
            this._goodItems[i] = ComponentFactory.Instance.creatCustomObject("ddtshop.GoodItem");
            dx = this._goodItems[i].width + 10;
            dy = this._goodItems[i].height + 10;
            dx *= int(i % 3);
            dy *= int(i / 3);
            this._goodItems[i].x = dx;
            this._goodItems[i].y = dy + i / 3 * 3;
            this._goodItemContainerAll.addChild(this._goodItems[i]);
            this._goodItems[i].setItemLight(this._rightItemLightMc);
            this._goodItems[i].addEventListener(ItemEvent.ITEM_CLICK,this.__itemClick);
            this._goodItems[i].addEventListener(ItemEvent.ITEM_SELECT,this.__itemSelect);
            i++;
         }
         this._maleBtn.displacement = this._femaleBtn.displacement = false;
         this._genderContainer.addChild(this._femaleBtn);
         this._genderContainer.addChild(this._maleBtn);
         this._genderGroup.addSelectItem(this._maleBtn);
         this._genderGroup.addSelectItem(this._femaleBtn);
         i = 0;
         while(i < this._topBtns.length)
         {
            this._topBtns[i].addEventListener(MouseEvent.CLICK,this.__topBtnClick);
            this._topBtnsContainer.addChild(this._topBtns[i]);
            this._topBtnsGroup.addSelectItem(this._topBtns[i]);
            if(i == 0)
            {
               this._topBtnsGroup.selectIndex = i;
            }
            this._subBtnsGroups[i] = new SelectedButtonGroup();
            i++;
         }
         this._subBtnsContainers.push(ComponentFactory.Instance.creat("ddtshop.SubBtnContainerRecommend"));
         this._subBtnsContainers.push(ComponentFactory.Instance.creat("ddtshop.SubBtnContainerEquipment"));
         this._subBtnsContainers.push(ComponentFactory.Instance.creat("ddtshop.SubBtnContainerBeautyup"));
         var subBtnStyleName:Array = ["ddtshop.SubBtnCloth","ddtshop.SubBtnHat","ddtshop.SubBtnEye","ddtshop.SubBtnFace","ddtshop.SubBtnHair","ddtshop.SubBtnSuit","ddtshop.SubBtnGlasses","ddtshop.SubBtnBubble","ddtshop.SubBtnprop"];
         subBtnTextTranslation = ["shop.ShopRightView.SubBtn.cloth","shop.ShopRightView.SubBtn.hat","shop.ShopRightView.SubBtn.eye","shop.ShopRightView.SubBtn.face","shop.ShopRightView.SubBtn.hair","shop.ShopRightView.SubBtn.suit","shop.ShopRightView.SubBtn.glasses","shop.ShopRightView.SubBtn.Bubble","shop.ShopRightView.SubBtn.prop"];
         subBtnStyleName.forEach(function(param1:*, param2:int, param3:Array):void
         {
            var _loc4_:SelectedTextButton = ComponentFactory.Instance.creat(param1 as String);
            _loc4_.text = LanguageMgr.GetTranslation(subBtnTextTranslation[param2]);
            _subBtns.push(_loc4_);
         });
         var controlArr:Array = [8,9];
         k = 0;
         i = 0;
         while(i < 9)
         {
            if(i == controlArr[k])
            {
               k++;
            }
            if(this._subBtnsContainers[k] == null)
            {
               k++;
            }
            this._subBtns[i].addEventListener(MouseEvent.CLICK,this.__subBtnClick);
            this._subBtnsContainers[k].addChild(this._subBtns[i]);
            this._subBtnsGroups[k].addSelectItem(this._subBtns[i]);
            if(i == 0)
            {
               this._subBtnsGroups[k].selectIndex = i;
            }
            this._subBtnsGroups[k].addEventListener(Event.CHANGE,this.subButtonSelectedChangeHandler);
            i++;
         }
         addChild(this._firstPage);
         addChild(this._prePageBtn);
         addChild(this._nextPageBtn);
         addChild(this._endPageBtn);
         addChild(this._currentPageInput);
         addChild(this._currentPageTxt);
         addChild(this._genderContainer);
         addChild(this._goodItemContainerAll);
         addChild(this._topBtnsContainer);
         i = 0;
         while(i < this._subBtnsContainers.length)
         {
            if(this._subBtnsContainers[i])
            {
               addChild(this._subBtnsContainers[i]);
               this._subBtnsContainers[i].visible = false;
               if(i == 0)
               {
                  this._subBtnsContainers[i].visible = true;
               }
            }
            i++;
         }
         this._shopSearchBox = ComponentFactory.Instance.creatCustomObject("ddtshop.SearchBox");
         this._shopSearchEndBtnBg = ComponentFactory.Instance.creatBitmap("asset.ddtshop.SearchResultImage");
         this._shopSearchBox.addChild(this._shopSearchEndBtnBg);
         this._shopSearchColseBtn = ComponentFactory.Instance.creatComponentByStylename("ddtshop.ShopSearchColseBtn");
         this._shopSearchBox.addChild(this._shopSearchColseBtn);
         addChild(this._shopSearchBox);
         this._shopSearchBox.visible = false;
         this._currentSubBtnContainerIndex = SUB_TYPE;
         this._topBtnsContainer.arrange();
      }
      
      private function subButtonSelectedChangeHandler(param1:Event) : void
      {
         if(this._currentSubBtnContainerIndex >= 3)
         {
            this._currentSubBtnContainerIndex = 1;
         }
         this._subBtnsContainers[this._currentSubBtnContainerIndex].arrange();
      }
      
      private function initEvent() : void
      {
         this._topBtnsGroup.addEventListener(Event.CHANGE,this.__topBtnChangeHandler);
         this._maleBtn.addEventListener(MouseEvent.CLICK,this.__genderClick);
         this._femaleBtn.addEventListener(MouseEvent.CLICK,this.__genderClick);
         this._firstPage.addEventListener(MouseEvent.CLICK,this.__pageBtnClick);
         this._prePageBtn.addEventListener(MouseEvent.CLICK,this.__pageBtnClick);
         this._nextPageBtn.addEventListener(MouseEvent.CLICK,this.__pageBtnClick);
         this._endPageBtn.addEventListener(MouseEvent.CLICK,this.__pageBtnClick);
         this._shopSearchColseBtn.addEventListener(MouseEvent.CLICK,this.__shopSearchColseBtnClick);
         ShopManager.Instance.addEventListener(ShopEvent.SHOW_WEAK_GUILDE,this.showUserGuide);
         this.showUserGuide();
      }
      
      protected function __topBtnChangeHandler(param1:Event) : void
      {
         SoundManager.instance.play("008");
         this._topBtnsContainer.arrange();
      }
      
      private function showUserGuide(param1:ShopEvent = null) : void
      {
         if(SavePointManager.Instance.isInSavePoint(15) && !TaskManager.instance.isNewHandTaskCompleted(11))
         {
            if(this._controller.model.allItemsCount > 0)
            {
               NewHandContainer.Instance.showArrow(ArrowType.SHOP_GIFT,45,"trainer.buyConfirmArrowPos","","",null);
            }
            else
            {
               NewHandContainer.Instance.showArrow(ArrowType.SHOP_GIFT,180,"trainer.buyThingsArrowPos","","",null);
            }
         }
      }
      
      private function reoveArrow() : void
      {
         NewHandContainer.Instance.clearArrowByID(ArrowType.SHOP_GIFT);
      }
      
      protected function __shopSearchColseBtnClick(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         this._isSearch = false;
         this._shopSearchBox.visible = false;
         TOP_TYPE = this._tempTopType;
         this._tempTopType = -1;
         this._topBtnsGroup.selectIndex = TOP_TYPE;
         if(!this._tempSubBtnHBox)
         {
            this._tempSubBtnHBox = this._subBtnsContainers[0];
         }
         this._tempSubBtnHBox.visible = true;
         CURRENT_PAGE = this._tempCurrentPage;
         this._tempCurrentPage = -1;
         this.loadList();
      }
      
      public function loadList() : void
      {
         if(this._isSearch)
         {
            return;
         }
         this.setList(ShopManager.Instance.getValidSortedGoodsByType(this.getType(),CURRENT_PAGE));
      }
      
      private function getType() : int
      {
         var _loc1_:Array = [];
         _loc1_ = CURRENT_GENDER == 1 ? ShopType.MALE_MONEY_TYPE : ShopType.FEMALE_MONEY_TYPE;
         var _loc2_:* = _loc1_[TOP_TYPE];
         if(_loc2_ is Array && SUB_TYPE > -1)
         {
            _loc2_ = _loc2_[SUB_TYPE];
         }
         return int(_loc2_);
      }
      
      public function setCurrentSex(param1:int) : void
      {
         CURRENT_GENDER = param1;
         this._genderGroup.selectIndex = CURRENT_GENDER - 1;
      }
      
      public function setList(param1:Vector.<ShopItemInfo>) : void
      {
         this.clearitems();
         var _loc2_:int = 0;
         while(_loc2_ < SHOP_ITEM_NUM)
         {
            this._goodItems[_loc2_].selected = false;
            if(!param1)
            {
               break;
            }
            this._goodItems[_loc2_].ableButton();
            if(_loc2_ < param1.length && param1[_loc2_])
            {
               this._goodItems[_loc2_].shopItemInfo = param1[_loc2_];
            }
            if(!SavePointManager.Instance.savePoints[15])
            {
               this._goodItems[_loc2_].givingDisable();
            }
            if(this.getType() == M_SPECIALPROPS && (PlayerManager.Instance.Self.VIPLevel < 5 || PlayerManager.Instance.Self.VIPtype == 0))
            {
               this._goodItems[_loc2_].enableButton();
            }
            if(this.getType() == F_SPECIALPROPS && (PlayerManager.Instance.Self.VIPLevel < 5 || PlayerManager.Instance.Self.VIPtype == 0))
            {
               this._goodItems[_loc2_].enableButton();
            }
            _loc2_++;
         }
         this._currentPageTxt.text = CURRENT_PAGE + "/" + ShopManager.Instance.getResultPages(this.getType());
      }
      
      public function searchList(param1:Vector.<ShopItemInfo>) : void
      {
         var _loc3_:HBox = null;
         if(this._searchShopItemList == param1 && this._isSearch)
         {
            return;
         }
         this._searchShopItemList = param1;
         if(!this._isSearch)
         {
            this._tempTopType = TOP_TYPE;
            this._tempCurrentPage = CURRENT_PAGE;
         }
         this._isSearch = true;
         TOP_TYPE = -1;
         this._topBtnsGroup.selectIndex = -1;
         this._topBtnsContainer.arrange();
         CURRENT_PAGE = 1;
         var _loc2_:int = 0;
         while(_loc2_ < this._subBtnsContainers.length)
         {
            _loc3_ = this._subBtnsContainers[_loc2_] as HBox;
            if(_loc3_)
            {
               _loc3_.visible = false;
            }
            _loc2_++;
         }
         this._shopSearchBox.visible = true;
         this.runSearch();
      }
      
      private function runSearch() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         this.clearitems();
         this._searchItemTotalPage = Math.ceil(this._searchShopItemList.length / 12);
         if(CURRENT_PAGE > 0 && CURRENT_PAGE <= this._searchItemTotalPage)
         {
            _loc1_ = 12 * (CURRENT_PAGE - 1);
            _loc2_ = Math.min(this._searchShopItemList.length - _loc1_,12);
            _loc3_ = 0;
            while(_loc3_ < _loc2_)
            {
               this._goodItems[_loc3_].ableButton();
               this._goodItems[_loc3_].selected = false;
               if(!SavePointManager.Instance.savePoints[15])
               {
                  this._goodItems[_loc3_].givingDisable();
               }
               if(this._searchShopItemList[_loc3_ + _loc1_])
               {
                  this._goodItems[_loc3_].shopItemInfo = this._searchShopItemList[_loc3_ + _loc1_];
                  _loc4_ = this._searchShopItemList[_loc3_ + _loc1_].ShopID;
                  if(_loc4_ == VIP_SHOPID && PlayerManager.Instance.Self.VIPLevel < 5)
                  {
                     this._goodItems[_loc3_].enableButton();
                     if(!PlayerManager.Instance.Self.IsVIP)
                     {
                        this._goodItems[_loc3_].enableButton();
                     }
                  }
               }
               _loc3_++;
            }
         }
         this._currentPageTxt.text = CURRENT_PAGE + "/" + this._searchItemTotalPage;
      }
      
      private function __genderClick(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         var _loc2_:int = param1.currentTarget as SelectedButton == this._maleBtn ? int(1) : int(2);
         if(CURRENT_GENDER == _loc2_)
         {
            return;
         }
         this.setCurrentSex(_loc2_);
         if(!this._isSearch)
         {
            CURRENT_PAGE = 1;
         }
         this._controller.setFittingModel(CURRENT_GENDER == 1);
      }
      
      private function __itemSelect(param1:ItemEvent) : void
      {
         var _loc3_:ISelectable = null;
         param1.stopImmediatePropagation();
         var _loc2_:ShopGoodItem = param1.currentTarget as ShopGoodItem;
         for each(_loc3_ in this._goodItems)
         {
            _loc3_.selected = false;
         }
         _loc2_.selected = true;
      }
      
      private function __itemClick(param1:ItemEvent) : void
      {
         var _loc3_:ISelectable = null;
         var _loc4_:ISelectable = null;
         var _loc5_:Boolean = false;
         var _loc6_:int = 0;
         var _loc7_:Boolean = false;
         var _loc8_:ShopCarItemInfo = null;
         var _loc2_:ShopGoodItem = param1.currentTarget as ShopGoodItem;
         if(this._controller.model.isOverCount(_loc2_.shopItemInfo))
         {
            for each(_loc3_ in this._goodItems)
            {
               _loc3_.selected = _loc3_ == _loc2_;
            }
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("shop.ShopIIModel.GoodsNumberLimit"));
            return;
         }
         if(_loc2_.shopItemInfo && _loc2_.shopItemInfo.TemplateInfo)
         {
            for each(_loc4_ in this._goodItems)
            {
               _loc4_.selected = _loc4_ == _loc2_;
            }
            _loc6_ = _loc2_.shopItemInfo.ShopID;
            if(EquipType.dressAble(_loc2_.shopItemInfo.TemplateInfo))
            {
               if(_loc6_ == VIP_SHOPID)
               {
                  if(PlayerManager.Instance.Self.VIPLevel < 5)
                  {
                     MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.view.changeColor.VIPshop"));
                     return;
                  }
                  if(!PlayerManager.Instance.Self.IsVIP)
                  {
                     MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.view.changeColor.VIPshop1"));
                     return;
                  }
               }
               if(this.getType() != F_SPECIALPROPS && this.getType() != M_SPECIALPROPS || PlayerManager.Instance.Self.IsVIP)
               {
                  this._controller.addTempEquip(_loc2_.shopItemInfo);
               }
            }
            else
            {
               _loc8_ = new ShopCarItemInfo(_loc2_.shopItemInfo.GoodsID,_loc2_.shopItemInfo.TemplateID);
               ObjectUtils.copyProperties(_loc8_,_loc2_.shopItemInfo);
               _loc6_ = _loc8_.ShopID;
               if(_loc6_ == VIP_SHOPID)
               {
                  if(PlayerManager.Instance.Self.VIPLevel < 5)
                  {
                     MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.view.changeColor.VIPshop"));
                     return;
                  }
                  if(!PlayerManager.Instance.Self.IsVIP)
                  {
                     MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.view.changeColor.VIPshop1"));
                     return;
                  }
               }
               _loc5_ = this._controller.addToCar(_loc8_);
            }
            this.showUserGuide();
            this.itemClick(_loc2_);
            _loc7_ = this._controller.leftView.getColorEditorVisble();
            if(_loc5_ && !_loc7_)
            {
               this.addCartEffects(_loc2_.itemCell);
            }
         }
         dispatchEvent(new Event(SHOW_LIGHT));
      }
      
      private function addCartEffects(param1:DisplayObject) : void
      {
         var _loc4_:TweenProxy = null;
         var _loc5_:TimelineLite = null;
         var _loc6_:TweenLite = null;
         var _loc7_:TweenLite = null;
         if(!param1)
         {
            return;
         }
         var _loc2_:BitmapData = new BitmapData(param1.width,param1.height,true,0);
         _loc2_.draw(param1);
         var _loc3_:Bitmap = new Bitmap(_loc2_,"auto",true);
         parent.addChild(_loc3_);
         _loc4_ = TweenProxy.create(_loc3_);
         _loc4_.registrationX = _loc4_.width / 2;
         _loc4_.registrationY = _loc4_.height / 2;
         var _loc8_:Point = DisplayUtils.localizePoint(parent,param1);
         _loc4_.x = _loc8_.x + _loc4_.width / 2;
         _loc4_.y = _loc8_.y + _loc4_.height / 2;
         _loc5_ = new TimelineLite();
         _loc5_.vars.onComplete = this.twComplete;
         _loc5_.vars.onCompleteParams = [_loc5_,_loc4_,_loc3_];
         _loc6_ = new TweenLite(_loc4_,0.3,{
            "x":220,
            "y":430
         });
         _loc7_ = new TweenLite(_loc4_,0.3,{
            "scaleX":0.1,
            "scaleY":0.1
         });
         _loc5_.append(_loc6_);
         _loc5_.append(_loc7_,-0.2);
      }
      
      private function twComplete(param1:TimelineLite, param2:TweenProxy, param3:Bitmap) : void
      {
         if(param1)
         {
            param1.kill();
         }
         if(param2)
         {
            param2.destroy();
         }
         if(param3.parent)
         {
            param3.parent.removeChild(param3);
            param3.bitmapData.dispose();
         }
         param2 = null;
         param3 = null;
         param1 = null;
      }
      
      private function itemClick(param1:ShopGoodItem) : void
      {
         if(param1.shopItemInfo.TemplateInfo != null)
         {
            if(CURRENT_GENDER != param1.shopItemInfo.TemplateInfo.NeedSex && param1.shopItemInfo.TemplateInfo.NeedSex != 0)
            {
               this.setCurrentSex(param1.shopItemInfo.TemplateInfo.NeedSex);
               this._controller.setFittingModel(CURRENT_GENDER == 1);
            }
         }
      }
      
      private function __pageBtnClick(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(!this._isSearch)
         {
            if(ShopManager.Instance.getResultPages(this.getType()) == 0)
            {
               return;
            }
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
                     CURRENT_PAGE = ShopManager.Instance.getResultPages(this.getType()) + 1;
                  }
                  --CURRENT_PAGE;
                  break;
               case this._nextPageBtn:
                  if(CURRENT_PAGE == ShopManager.Instance.getResultPages(this.getType()))
                  {
                     CURRENT_PAGE = 0;
                  }
                  ++CURRENT_PAGE;
                  break;
               case this._endPageBtn:
                  if(CURRENT_PAGE != ShopManager.Instance.getResultPages(this.getType()))
                  {
                     CURRENT_PAGE = ShopManager.Instance.getResultPages(this.getType());
                  }
            }
            this.loadList();
         }
         else
         {
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
                     CURRENT_PAGE = this._searchItemTotalPage + 1;
                  }
                  --CURRENT_PAGE;
                  break;
               case this._nextPageBtn:
                  if(CURRENT_PAGE == this._searchItemTotalPage)
                  {
                     CURRENT_PAGE = 0;
                  }
                  ++CURRENT_PAGE;
                  break;
               case this._endPageBtn:
                  if(CURRENT_PAGE != this._searchItemTotalPage)
                  {
                     CURRENT_PAGE = this._searchItemTotalPage;
                  }
            }
            this.runSearch();
         }
      }
      
      private function __subBtnClick(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         this.reoveArrow();
         var _loc2_:int = this._subBtnsContainers[TOP_TYPE].getChildIndex(param1.currentTarget as SelectedButton);
         if(_loc2_ != SUB_TYPE)
         {
            SUB_TYPE = _loc2_;
            CURRENT_PAGE = 1;
            this.loadList();
         }
      }
      
      private function __topBtnClick(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         this._topBtnsContainer.arrange();
         var _loc2_:int = this._topBtns.indexOf(param1.currentTarget as SelectedButton);
         this._isSearch = false;
         this._shopSearchBox.visible = false;
         this._tempTopType = -1;
         this._tempCurrentPage = -1;
         if(_loc2_ != TOP_TYPE)
         {
            TOP_TYPE = _loc2_;
            SUB_TYPE = 0;
            CURRENT_PAGE = 1;
            this.showSubBtns(_loc2_);
            this._currentSubBtnContainerIndex = _loc2_;
            this.loadList();
         }
         if(_loc2_ == 0)
         {
            this.showUserGuide();
         }
         else if(this._controller.model.allItemsCount <= 0)
         {
            NewHandContainer.Instance.clearArrowByID(ArrowType.SHOP_GIFT);
         }
      }
      
      private function disposeUserGuide() : void
      {
      }
      
      private function clearitems() : void
      {
         var _loc1_:int = 0;
         while(_loc1_ < SHOP_ITEM_NUM)
         {
            this._goodItems[_loc1_].shopItemInfo = null;
            _loc1_++;
         }
      }
      
      private function removeEvent() : void
      {
         this._topBtnsGroup.removeEventListener(Event.CHANGE,this.__topBtnChangeHandler);
         this._maleBtn.removeEventListener(MouseEvent.CLICK,this.__genderClick);
         this._femaleBtn.removeEventListener(MouseEvent.CLICK,this.__genderClick);
         this._prePageBtn.removeEventListener(MouseEvent.CLICK,this.__pageBtnClick);
         this._nextPageBtn.removeEventListener(MouseEvent.CLICK,this.__pageBtnClick);
         var _loc1_:uint = 0;
         while(_loc1_ < SHOP_ITEM_NUM)
         {
            this._goodItems[_loc1_].removeEventListener(ItemEvent.ITEM_CLICK,this.__itemClick);
            this._goodItems[_loc1_].removeEventListener(ItemEvent.ITEM_SELECT,this.__itemSelect);
            _loc1_++;
         }
         _loc1_ = 0;
         while(_loc1_ < this._topBtns.length)
         {
            this._topBtns[_loc1_].removeEventListener(MouseEvent.CLICK,this.__topBtnClick);
            _loc1_++;
         }
         _loc1_ = 0;
         while(_loc1_ < this._subBtns.length)
         {
            this._subBtns[_loc1_].removeEventListener(MouseEvent.CLICK,this.__subBtnClick);
            _loc1_++;
         }
         this._shopSearchColseBtn.removeEventListener(MouseEvent.CLICK,this.__shopSearchColseBtnClick);
         ShopManager.Instance.removeEventListener(ShopEvent.SHOW_WEAK_GUILDE,this.showUserGuide);
      }
      
      private function showSubBtns(param1:int) : void
      {
         var _loc3_:HBox = null;
         var _loc2_:int = 0;
         while(_loc2_ < this._subBtnsContainers.length)
         {
            _loc3_ = this._subBtnsContainers[_loc2_] as HBox;
            if(_loc3_)
            {
               _loc3_.visible = false;
            }
            _loc2_++;
         }
         if(this._subBtnsContainers[param1])
         {
            this._subBtnsContainers[param1].visible = true;
            this._tempSubBtnHBox = this._subBtnsContainers[param1];
            this._subBtnsGroups[param1].selectIndex = SUB_TYPE;
            this._subBtnsContainers[param1].arrange();
         }
      }
      
      public function gotoPage(param1:int = -1, param2:int = -1, param3:int = 1, param4:int = 1) : void
      {
         var _loc6_:HBox = null;
         if(param1 != -1)
         {
            TOP_TYPE = param1;
         }
         if(param2 != -1)
         {
            SUB_TYPE = param2;
         }
         CURRENT_PAGE = param3;
         CURRENT_GENDER = param4;
         this._topBtnsGroup.selectIndex = TOP_TYPE;
         this._subBtnsGroups[TOP_TYPE].selectIndex = SUB_TYPE;
         this._genderGroup.selectIndex = CURRENT_GENDER - 1;
         this.setCurrentSex(CURRENT_GENDER);
         this._currentPageTxt.text = CURRENT_PAGE + "/" + this._searchItemTotalPage;
         var _loc5_:int = 0;
         while(_loc5_ < this._subBtnsContainers.length)
         {
            _loc6_ = this._subBtnsContainers[_loc5_] as HBox;
            if(_loc6_)
            {
               _loc6_.visible = false;
            }
            _loc5_++;
         }
         if(this._subBtnsContainers[TOP_TYPE])
         {
            this._subBtnsContainers[TOP_TYPE].visible = true;
            this._subBtnsContainers[TOP_TYPE].arrange();
            this._tempSubBtnHBox = this._subBtnsContainers[TOP_TYPE];
         }
         this.loadList();
      }
      
      public function dispose() : void
      {
         if(this._tempCurrentPage > -1)
         {
            CURRENT_PAGE = this._tempCurrentPage;
         }
         if(this._tempTopType > -1)
         {
            TOP_TYPE = this._tempTopType;
         }
         this.removeEvent();
         this.disposeUserGuide();
         ObjectUtils.disposeAllChildren(this);
         if(this._currentPageTxt)
         {
            this._currentPageTxt.dispose();
         }
         this._currentPageTxt = null;
         var _loc1_:int = 0;
         while(_loc1_ < this._goodItems.length)
         {
            ObjectUtils.disposeObject(this._goodItems[_loc1_]);
            this._goodItems[_loc1_] = null;
            _loc1_++;
         }
         ObjectUtils.disposeObject(this._goodItems);
         this._goodItems = null;
         _loc1_ = 0;
         while(_loc1_ < this._topBtns.length)
         {
            ObjectUtils.disposeObject(this._topBtns[_loc1_]);
            this._topBtns[_loc1_] = null;
            _loc1_++;
         }
         ObjectUtils.disposeObject(this._topBtns);
         this._topBtns = null;
         _loc1_ = 0;
         while(_loc1_ < this._subBtns.length)
         {
            ObjectUtils.disposeObject(this._subBtns[_loc1_]);
            this._subBtns[_loc1_] = null;
            _loc1_++;
         }
         this._subBtns = null;
         _loc1_ = 0;
         while(_loc1_ < this._subBtnsGroups.length)
         {
            ObjectUtils.disposeObject(this._subBtnsGroups[_loc1_]);
            this._subBtnsGroups[_loc1_] = null;
            ObjectUtils.disposeObject(this._subBtnsContainers[_loc1_]);
            this._subBtnsContainers[_loc1_] = null;
            _loc1_++;
         }
         ObjectUtils.disposeObject(this._subBtnsContainers);
         this._subBtnsContainers = null;
         ObjectUtils.disposeObject(this._subBtnsGroups);
         this._subBtnsGroups = null;
         ObjectUtils.disposeObject(this._controller);
         this._controller = null;
         ObjectUtils.disposeObject(this._goodItemGroup);
         this._goodItemGroup = null;
         ObjectUtils.disposeObject(this._nextPageBtn);
         this._nextPageBtn = null;
         ObjectUtils.disposeObject(this._prePageBtn);
         this._prePageBtn = null;
         ObjectUtils.disposeObject(this._topBtnsGroup);
         this._topBtnsGroup = null;
         ObjectUtils.disposeObject(this._tempSubBtnHBox);
         this._tempSubBtnHBox = null;
         ObjectUtils.disposeObject(this._bg);
         this._bg = null;
         ObjectUtils.disposeObject(this._bg1);
         this._bg1 = null;
         ObjectUtils.disposeObject(this._currentPageInput);
         this._currentPageInput = null;
         ObjectUtils.disposeObject(this._femaleBtn);
         this._femaleBtn = null;
         ObjectUtils.disposeObject(this._genderContainer);
         this._genderContainer = null;
         ObjectUtils.disposeObject(this._genderGroup);
         this._genderGroup = null;
         ObjectUtils.disposeObject(this._rightViewTitleBg);
         this._rightViewTitleBg = null;
         ObjectUtils.disposeObject(this._goodItemContainerAll);
         this._goodItemContainerAll = null;
         ObjectUtils.disposeObject(this._maleBtn);
         this._maleBtn = null;
         ObjectUtils.disposeObject(this._firstPage);
         this._firstPage = null;
         ObjectUtils.disposeObject(this._prePageBtn);
         this._prePageBtn = null;
         ObjectUtils.disposeObject(this._nextPageBtn);
         this._nextPageBtn = null;
         ObjectUtils.disposeObject(this._endPageBtn);
         this._endPageBtn = null;
         ObjectUtils.disposeObject(this._topBtnsContainer);
         this._topBtnsContainer = null;
         ObjectUtils.disposeObject(this._rightItemLightMc);
         this._rightItemLightMc = null;
         ObjectUtils.disposeObject(this._shopSearchEndBtnBg);
         this._shopSearchEndBtnBg = null;
         ObjectUtils.disposeObject(this._shopSearchColseBtn);
         this._shopSearchColseBtn = null;
         ObjectUtils.disposeObject(this._shopSearchBox);
         this._shopSearchBox = null;
         ObjectUtils.disposeObject(this._goodItemContainerBg);
         this._goodItemContainerBg = null;
         if(parent)
         {
            parent.removeChild(this);
         }
      }
   }
}
