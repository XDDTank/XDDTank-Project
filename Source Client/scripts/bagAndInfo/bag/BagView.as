package bagAndInfo.bag
{
   import bagAndInfo.BagAndInfoManager;
   import bagAndInfo.PageOneSelectedButton;
   import bagAndInfo.PageThreeSelectedButton;
   import bagAndInfo.PageTwoSelectedButton;
   import bagAndInfo.ReworkName.ReworkNameConsortia;
   import bagAndInfo.ReworkName.ReworkNameFrame;
   import bagAndInfo.cell.BagCell;
   import bagAndInfo.cell.LockBagCell;
   import bagAndInfo.changeSex.ChangeSexAlertFrame;
   import bagAndInfo.info.MoneyInfoView;
   import bagAndInfo.info.PlayerViewState;
   import baglocked.BagLockedController;
   import baglocked.BaglockedManager;
   import changeColor.ChangeColorController;
   import com.pickgliss.events.ComponentEvent;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.events.UIModuleEvent;
   import com.pickgliss.loader.UIModuleLoader;
   import com.pickgliss.toplevel.StageReferance;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.controls.OutMainListPanel;
   import com.pickgliss.ui.controls.SelectedButton;
   import com.pickgliss.ui.controls.SelectedButtonGroup;
   import com.pickgliss.ui.controls.TextButton;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.controls.alert.SimpleAlert;
   import com.pickgliss.ui.image.Scale9CornerImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.ui.vo.AlertInfo;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.command.OpenAllFrame;
   import ddt.data.BagInfo;
   import ddt.data.EquipType;
   import ddt.data.UIModuleTypes;
   import ddt.data.goods.EquipmentTemplateInfo;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.data.goods.Price;
   import ddt.data.player.PlayerInfo;
   import ddt.data.player.SelfInfo;
   import ddt.events.BagEvent;
   import ddt.events.CellEvent;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.events.PlayerPropertyEvent;
   import ddt.manager.DropGoodsManager;
   import ddt.manager.ItemManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SavePointManager;
   import ddt.manager.SharedManager;
   import ddt.manager.ShopManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.manager.TimeManager;
   import ddt.utils.PositionUtils;
   import ddt.view.UIModuleSmallLoading;
   import ddt.view.bossbox.AwardsView;
   import ddt.view.bossbox.PetBlessView;
   import ddt.view.chat.ChatBugleInputFrame;
   import ddt.view.goods.AddPricePanel;
   import ddt.view.tips.OneLineTip;
   import flash.display.Bitmap;
   import flash.display.Shape;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.external.ExternalInterface;
   import flash.filters.GlowFilter;
   import flash.geom.Point;
   import flash.ui.Mouse;
   import flash.utils.Dictionary;
   import flash.utils.Timer;
   import flash.utils.getTimer;
   import pet.date.PetInfo;
   import road7th.comm.PackageIn;
   import road7th.utils.DateUtils;
   import trainer.data.ArrowType;
   import trainer.view.NewHandContainer;
   import vip.VipController;
   
   [Event(name="sellstop")]
   [Event(name="sellstart")]
   public class BagView extends Sprite
   {
      
      public static const TABCHANGE:String = "tabChange";
      
      public static const SHOWBEAD:String = "showBeadFrame";
      
      public static const EQUIP:int = 0;
      
      public static const PROP:int = 1;
      
      public static const CONSORTION:int = 3;
      
      private static const UseColorShellLevel:int = 10;
       
      
      private var _index:int = 0;
      
      private const STATE_SELL:uint = 1;
      
      protected var _bgShape:Shape;
      
      private var state:uint = 0;
      
      protected var _info:SelfInfo;
      
      protected var _equiplist:BagEquipListView;
      
      protected var _equiplist1:BagEquipListView;
      
      protected var _equiplist2:BagEquipListView;
      
      protected var _currEquipIndex:int = 1;
      
      protected var _sellBtn:SellGoodsBtn;
      
      protected var _continueBtn:ContinueGoodsBtn;
      
      protected var _currentList:BagListView;
      
      protected var _breakBtn:BreakGoodsBtn;
      
      private var _chatBugleInputFrame:ChatBugleInputFrame;
      
      protected var _currentPage:int = 1;
      
      private var _lockPageNeedMoney:int;
      
      private var startIndex:int;
      
      private var stopIndex:int;
      
      protected var _bagType:int;
      
      protected var _settedLockBtn:BaseButton;
      
      protected var _settingLockBtn:BaseButton;
      
      private var _bagLocked:Boolean;
      
      protected var _sortBagBtn:TextButton;
      
      private var _self:SelfInfo;
      
      protected var _moneyView:MoneyInfoView;
      
      protected var _ddtmoneyView:MoneyInfoView;
      
      protected var _goldView:MoneyInfoView;
      
      protected var _bg:Scale9CornerImage;
      
      protected var _bg1:Scale9CornerImage;
      
      protected var _goodsNumInfoBg:Bitmap;
      
      protected var _goodsNumInfoText:FilterFrameText;
      
      protected var _goodsNumTotalText:FilterFrameText;
      
      private var _changeColorController:ChangeColorController;
      
      private var _reworknameView:ReworkNameFrame;
      
      private var _consortaiReworkName:ReworkNameConsortia;
      
      private var _baseAlerFrame:BaseAlerFrame;
      
      private var _openBagLock:Boolean = false;
      
      private const _TRIEVENEEDLEVEL:int = 16;
      
      protected var _onePageBtn:PageOneSelectedButton;
      
      protected var _TwoPageBtn:PageTwoSelectedButton;
      
      protected var _ThreePageBtn:PageThreeSelectedButton;
      
      protected var _pageTips:OneLineTip;
      
      protected var _pageTipsI:OneLineTip;
      
      protected var _pageBtnSprite:Sprite;
      
      protected var _pageBtnSpriteI:Sprite;
      
      private var _PageBtnGroup:SelectedButtonGroup;
      
      private var _isScreenTexp:Boolean = false;
      
      private var _bagList:OutMainListPanel;
      
      private var _disEnabledFilters:Array;
      
      private var _equipBag:BagInfo;
      
      protected var _allClassBtn:SelectedButton;
      
      protected var _equipClassBtn:SelectedButton;
      
      protected var _fashionClassBtn:SelectedButton;
      
      protected var _propClassBtn:SelectedButton;
      
      protected var _questClassBtn:SelectedButton;
      
      private var _ClassBtnGroup:SelectedButtonGroup;
      
      private var _loadListTimer:Timer;
      
      private var infos:Array;
      
      private var _frame:BaseAlerFrame;
      
      private var clickSign:int = 0;
      
      private var _bagLockControl:BagLockedController;
      
      private var temInfo:InventoryItemInfo;
      
      private var _currentCell:LockBagCell;
      
      public function BagView()
      {
         this._self = PlayerManager.Instance.Self;
         super();
         this.init();
         this.initEvent();
      }
      
      public function get bagType() : int
      {
         return this._bagType;
      }
      
      protected function init() : void
      {
         this.initBackGround();
         this.initBagList();
         this.initMoneyTexts();
         this.initButtons();
         this.initGoodsNumInfo();
         this.initClassButton();
         this.initPageButton();
         this.set_breakBtn_enable();
         this.set_text_location();
         this.set_btn_location();
         this.setBagType(EQUIP);
      }
      
      protected function initBackGround() : void
      {
         this._bg = ComponentFactory.Instance.creatComponentByStylename("bagBGAsset4");
         addChild(this._bg);
         this._bg1 = ComponentFactory.Instance.creatComponentByStylename("bagAndInfo.view.bgIII");
         addChild(this._bg1);
         this._bgShape = new Shape();
         this._bgShape.graphics.beginFill(15262671,1);
         this._bgShape.graphics.drawRoundRect(0,0,327,328,2,2);
         this._bgShape.graphics.endFill();
         this._bgShape.x = 11;
         this._bgShape.y = 50;
      }
      
      protected function initBagList() : void
      {
         var _loc1_:uint = getTimer();
         this._equiplist = BagAndInfoManager.Instance.bagListView;
         this._equiplist1 = BagAndInfoManager.Instance.bagListViewTwo;
         this._equiplist2 = BagAndInfoManager.Instance.bagListViewThree;
         this._equiplist.x = this._equiplist1.x = this._equiplist2.x = 12;
         this._equiplist.y = this._equiplist1.y = this._equiplist2.y = 54;
         this._equiplist.width = this._equiplist1.width = this._equiplist2.width = 330;
         this._equiplist.height = this._equiplist2.height = this._equiplist2.height = 320;
         this._equiplist1.visible = false;
         this._equiplist2.visible = false;
         addChild(this._equiplist);
         addChild(this._equiplist1);
         addChild(this._equiplist2);
      }
      
      private function initMoneyTexts() : void
      {
         this._moneyView = new MoneyInfoView(Price.MONEY);
         this._ddtmoneyView = new MoneyInfoView(Price.DDT_MONEY);
         this._goldView = new MoneyInfoView(Price.GOLD);
         addChild(this._moneyView);
         addChild(this._ddtmoneyView);
         addChild(this._goldView);
         PositionUtils.setPos(this._moneyView,"MoneyInfoView.pos1");
         PositionUtils.setPos(this._ddtmoneyView,"MoneyInfoView.pos2");
         PositionUtils.setPos(this._goldView,"MoneyInfoView.pos3");
      }
      
      protected function initButtons() : void
      {
         this._sellBtn = ComponentFactory.Instance.creatComponentByStylename("bagSellButton1");
         this._sellBtn.text = LanguageMgr.GetTranslation("tank.view.bagII.BagIIView.bagSell");
         addChild(this._sellBtn);
         this._continueBtn = ComponentFactory.Instance.creatComponentByStylename("bagContinueButton1");
         this._continueBtn.text = LanguageMgr.GetTranslation("tank.view.bagII.BagIIView.bagContinue");
         addChild(this._continueBtn);
         this._breakBtn = ComponentFactory.Instance.creatComponentByStylename("bagBreakButton1");
         this._breakBtn.text = LanguageMgr.GetTranslation("tank.view.bagII.BagIIView.bagBreak");
         addChild(this._breakBtn);
         this._breakBtn.filters = null;
         this._breakBtn.enable = true;
         this._settingLockBtn = ComponentFactory.Instance.creatComponentByStylename("bagSetPWDButton1");
         this._settingLockBtn.tipData = LanguageMgr.GetTranslation("tank.view.bagII.baglocked.BagLockedSetFrame.titleText");
         addChild(this._settingLockBtn);
         this._settedLockBtn = ComponentFactory.Instance.creatComponentByStylename("bagSetPWDButton1");
         this._settedLockBtn.tipData = LanguageMgr.GetTranslation("tank.view.bagII.baglocked.BagLockedSetFrame.titleText");
         addChild(this._settedLockBtn);
         this._sortBagBtn = ComponentFactory.Instance.creatComponentByStylename("sortBagButton1");
         this._sortBagBtn.text = LanguageMgr.GetTranslation("tank.view.bagII.BagIIView.sortBag");
         this._sortBagBtn.tipData = LanguageMgr.GetTranslation("tank.view.bagII.BagIIView.bagFinishingBtn");
         this._sortBagBtn.filters = null;
         this._sortBagBtn.enable = true;
         addChild(this._sortBagBtn);
      }
      
      public function set sortBagEnable(param1:Boolean) : void
      {
         this._sortBagBtn.enable = param1;
      }
      
      public function set breakBtnEnable(param1:Boolean) : void
      {
         this._breakBtn.enable = param1;
         this._continueBtn.enable = param1;
         this._sellBtn.enable = param1;
      }
      
      public function set sellBtnFilter(param1:Array) : void
      {
         this._sellBtn.filters = param1;
      }
      
      public function set sortBagFilter(param1:Array) : void
      {
         this._sortBagBtn.filters = param1;
      }
      
      public function set breakBtnFilter(param1:Array) : void
      {
         this._breakBtn.filters = param1;
         this._continueBtn.filters = param1;
      }
      
      public function switchLockBtnVisible(param1:Boolean) : void
      {
         if(this._settedLockBtn)
         {
            this._settedLockBtn.visible = param1;
         }
         if(this._settingLockBtn)
         {
            this._settingLockBtn.visible = param1;
         }
      }
      
      public function switchButtomVisible(param1:Boolean) : void
      {
         this._sellBtn.visible = param1;
         this._breakBtn.visible = param1;
         this._continueBtn.visible = param1;
         this._moneyView.visible = param1;
         this._ddtmoneyView.visible = param1;
         this._goldView.visible = param1;
      }
      
      public function set switchbagViewBtn(param1:Boolean) : void
      {
         this._onePageBtn.visible = param1;
         this._TwoPageBtn.visible = param1;
         this._ThreePageBtn.visible = param1;
      }
      
      private function initClassButton() : void
      {
         this._allClassBtn = ComponentFactory.Instance.creatComponentByStylename("ddtbagAndInfo.AllBtn");
         addChild(this._allClassBtn);
         this._equipClassBtn = ComponentFactory.Instance.creatComponentByStylename("ddtbagAndInfo.EquipBtn");
         addChild(this._equipClassBtn);
         this._fashionClassBtn = ComponentFactory.Instance.creatComponentByStylename("ddtbagAndInfo.FashionBtn");
         addChild(this._fashionClassBtn);
         this._propClassBtn = ComponentFactory.Instance.creatComponentByStylename("ddtbagAndInfo.PropBtn");
         addChild(this._propClassBtn);
         this._questClassBtn = ComponentFactory.Instance.creatComponentByStylename("ddtbagAndInfo.QuestBtn");
         addChild(this._questClassBtn);
         this._ClassBtnGroup = new SelectedButtonGroup();
         this._ClassBtnGroup.addSelectItem(this._allClassBtn);
         this._ClassBtnGroup.addSelectItem(this._equipClassBtn);
         this._ClassBtnGroup.addSelectItem(this._fashionClassBtn);
         this._ClassBtnGroup.addSelectItem(this._propClassBtn);
         this._ClassBtnGroup.addSelectItem(this._questClassBtn);
         this._ClassBtnGroup.selectIndex = 0;
         this._ClassBtnGroup.addEventListener(Event.CHANGE,this.__changeClassHandler);
         this._allClassBtn.addEventListener(MouseEvent.CLICK,this.__soundPlay);
         this._equipClassBtn.addEventListener(MouseEvent.CLICK,this.__soundPlay);
         this._fashionClassBtn.addEventListener(MouseEvent.CLICK,this.__soundPlay);
         this._propClassBtn.addEventListener(MouseEvent.CLICK,this.__soundPlay);
         this._questClassBtn.addEventListener(MouseEvent.CLICK,this.__soundPlay);
      }
      
      public function set setClassBtnEnable(param1:Boolean) : void
      {
         this._allClassBtn.enable = param1;
         this._equipClassBtn.enable = param1;
         this._fashionClassBtn.enable = param1;
         this._propClassBtn.enable = param1;
         this._questClassBtn.enable = param1;
      }
      
      public function set setClassBtnVisible(param1:Boolean) : void
      {
         this._allClassBtn.visible = param1;
         this._equipClassBtn.visible = param1;
         this._fashionClassBtn.visible = param1;
         this._propClassBtn.visible = param1;
         this._questClassBtn.visible = param1;
      }
      
      public function set setClassBtnFilter(param1:Array) : void
      {
         this._allClassBtn.filters = param1;
         this._equipClassBtn.filters = param1;
         this._fashionClassBtn.filters = param1;
         this._propClassBtn.filters = param1;
         this._questClassBtn.filters = param1;
      }
      
      private function initPageButton() : void
      {
         this._onePageBtn = ComponentFactory.Instance.creatComponentByStylename("ddtbagAndInfo.equipList.PageOneBtnAsset");
         this._onePageBtn.text = "1";
         addChild(this._onePageBtn);
         PositionUtils.setPos(this._onePageBtn,"ddtbagAndInfo.PageBtn.Pos");
         this._TwoPageBtn = ComponentFactory.Instance.creatComponentByStylename("ddtbagAndInfo.equipList.PageTwoBtnAsset");
         this._TwoPageBtn.text = "2";
         addChild(this._TwoPageBtn);
         PositionUtils.setPos(this._TwoPageBtn,"ddtbagAndInfo.PageBtn.Pos1");
         this._ThreePageBtn = ComponentFactory.Instance.creatComponentByStylename("ddtbagAndInfo.equipList.PageThreeBtnAsset");
         this._ThreePageBtn.text = "3";
         addChild(this._ThreePageBtn);
         PositionUtils.setPos(this._ThreePageBtn,"ddtbagAndInfo.PageBtn.Pos2");
         this._PageBtnGroup = new SelectedButtonGroup();
         this._PageBtnGroup.addSelectItem(this._onePageBtn);
         this._PageBtnGroup.addSelectItem(this._TwoPageBtn);
         this._PageBtnGroup.addSelectItem(this._ThreePageBtn);
         this._PageBtnGroup.selectIndex = 0;
         this._PageBtnGroup.addEventListener(Event.CHANGE,this.__changeHandler);
         this._onePageBtn.addEventListener(MouseEvent.CLICK,this.__soundPlay);
         this._TwoPageBtn.addEventListener(MouseEvent.CLICK,this.__soundPlay);
         this._ThreePageBtn.addEventListener(MouseEvent.CLICK,this.__soundPlay);
      }
      
      private function __mouseOverHandler(param1:MouseEvent) : void
      {
         var _loc2_:Point = null;
         if(this._pageTips)
         {
            this._pageTips.visible = true;
            LayerManager.Instance.addToLayer(this._pageTips,LayerManager.GAME_TOP_LAYER);
            _loc2_ = this._TwoPageBtn.localToGlobal(new Point(0,0));
            this._pageTips.x = _loc2_.x;
            this._pageTips.y = _loc2_.y + this._TwoPageBtn.height;
         }
      }
      
      private function __mouseOutHandler(param1:MouseEvent) : void
      {
         if(this._pageTips)
         {
            this._pageTips.visible = false;
         }
      }
      
      private function __mouseOverHandlerI(param1:MouseEvent) : void
      {
         var _loc2_:Point = null;
         if(this._pageTipsI)
         {
            this._pageTipsI.visible = true;
            LayerManager.Instance.addToLayer(this._pageTipsI,LayerManager.GAME_TOP_LAYER);
            _loc2_ = this._ThreePageBtn.localToGlobal(new Point(0,0));
            this._pageTipsI.x = _loc2_.x;
            this._pageTipsI.y = _loc2_.y + this._ThreePageBtn.height;
         }
      }
      
      private function __mouseOutHandlerI(param1:MouseEvent) : void
      {
         if(this._pageTipsI)
         {
            this._pageTipsI.visible = false;
         }
      }
      
      private function __soundPlay(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
      }
      
      public function initEquipBagPage() : void
      {
         var _loc2_:InventoryItemInfo = null;
         var _loc3_:int = 0;
         var _loc1_:int = int.MAX_VALUE;
         for each(_loc2_ in this._info.Bag.items)
         {
            if(_loc2_.Place < _loc1_ && _loc2_.Place > 30)
            {
               _loc1_ = _loc2_.Place;
            }
         }
         _loc3_ = (_loc1_ - 31) / 49 + 1;
         if(_loc3_ <= 0 || _loc3_ > 3)
         {
            _loc3_ = 1;
         }
         this._equiplist.visible = _loc3_ == 1;
         this._equiplist1.visible = _loc3_ == 2;
         this._equiplist2.visible = _loc3_ == 3;
         this._currentList = [this._equiplist,this._equiplist1,this._equiplist2][_loc3_ - 1];
      }
      
      private function initGoodsNumInfo() : void
      {
         this._goodsNumInfoText = ComponentFactory.Instance.creatComponentByStylename("bagGoodsInfoNumText");
         this._goodsNumTotalText = ComponentFactory.Instance.creatComponentByStylename("bagGoodsInfoNumTotalText");
         this._goodsNumTotalText.text = "/ " + String(BagInfo.MAXPROPCOUNT + 1);
      }
      
      public function hideForConsortia() : void
      {
         removeChild(this._goodsNumInfoText);
         removeChild(this._goodsNumTotalText);
         removeChild(this._settingLockBtn);
         removeChild(this._settedLockBtn);
         removeChild(this._sortBagBtn);
      }
      
      private function updateView() : void
      {
         this.updateMoney();
         this.updateBagList();
         this.updateLockState();
         this.updatePageBtn();
      }
      
      protected function updateBagList() : void
      {
         var _loc1_:uint = getTimer();
         if(this._info)
         {
            this.currentPage = this._currentPage;
            if(PlayerManager.Instance.Self.bagVibleType == 0)
            {
               this._ClassBtnGroup.selectIndex = 0;
            }
         }
         else
         {
            this._equiplist.setData(null);
         }
      }
      
      protected function updateLockState() : void
      {
         this._settingLockBtn.visible = !this._info.bagLocked;
         this._settedLockBtn.visible = this._info.bagLocked;
      }
      
      private function __clearHandler(param1:BagEvent) : void
      {
         this.updateLockState();
      }
      
      public function set sorGoodsEnabel(param1:Boolean) : void
      {
         this._sortBagBtn.enable = param1;
      }
      
      private function __showBead(param1:BagEvent) : void
      {
         MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.beadSystem.beadToBeadBag"));
      }
      
      protected function initEvent() : void
      {
         PlayerManager.Instance.Self.Bag.addEventListener(BagEvent.UPDATE,this.__updateGoods);
         PlayerManager.Instance.addEventListener(PlayerManager.CHAGE_STATE,this.__changeState);
         this._sellBtn.addEventListener(MouseEvent.CLICK,this.__sellClick);
         this._breakBtn.addEventListener(MouseEvent.CLICK,this.__breakClick);
         this._equiplist.addEventListener(CellEvent.ITEM_CLICK,this.__cellEquipClick);
         this._equiplist.addEventListener(CellEvent.DOUBLE_CLICK,this.__cellDoubleClick);
         this._equiplist.addEventListener(Event.CHANGE,this.__listChange);
         this._equiplist1.addEventListener(CellEvent.ITEM_CLICK,this.__cellEquipClick);
         this._equiplist1.addEventListener(CellEvent.DOUBLE_CLICK,this.__cellDoubleClick);
         this._equiplist1.addEventListener(Event.CHANGE,this.__listChange);
         this._equiplist2.addEventListener(CellEvent.ITEM_CLICK,this.__cellEquipClick);
         this._equiplist2.addEventListener(CellEvent.DOUBLE_CLICK,this.__cellDoubleClick);
         this._equiplist2.addEventListener(Event.CHANGE,this.__listChange);
         CellMenu.instance.addEventListener(CellMenu.ADDPRICE,this.__cellAddPrice);
         CellMenu.instance.addEventListener(CellMenu.MOVE,this.__cellMove);
         CellMenu.instance.addEventListener(CellMenu.OPEN,this.__cellOpen);
         CellMenu.instance.addEventListener(CellMenu.USE,this.__cellUse);
         CellMenu.instance.addEventListener(CellMenu.OPEN_ALL,this.__cellOpenAll);
         this._settingLockBtn.addEventListener(MouseEvent.CLICK,this.__openSettingLock);
         this._settedLockBtn.addEventListener(MouseEvent.CLICK,this.__openModifyLock);
         this._sortBagBtn.addEventListener(MouseEvent.CLICK,this.__sortBagClick);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.USE_COLOR_SHELL,this.__useColorShell);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.ITEM_OPENUP,this.__openPreviewListFrame);
         this.adjustEvent();
      }
      
      protected function __updateGoods(param1:BagEvent) : void
      {
         var _loc2_:Dictionary = null;
         var _loc3_:* = null;
         var _loc4_:int = 0;
         var _loc5_:InventoryItemInfo = null;
         if(PlayerManager.Instance.Self.bagVibleType == 0)
         {
            this.updateBagList();
         }
         else
         {
            _loc2_ = param1.changedSlots;
            for(_loc3_ in _loc2_)
            {
               _loc4_ = this.findItemPlaceByPlace(int(_loc3_));
               if(this._equipBag.items[_loc4_])
               {
                  _loc5_ = PlayerManager.Instance.Self.Bag.items[_loc3_];
                  this._equiplist.setCellInfo(_loc4_,_loc5_);
                  if(this._equiplist1)
                  {
                     this._equiplist1.setCellInfo(_loc4_,_loc5_);
                  }
                  if(this._equiplist2)
                  {
                     this._equiplist2.setCellInfo(_loc4_,_loc5_);
                  }
               }
            }
            this.updateBagList();
         }
      }
      
      private function findItemPlaceByPlace(param1:int) : int
      {
         var _loc2_:* = null;
         for(_loc2_ in this._equipBag.items)
         {
            if(this._equipBag.items[_loc2_].Place == param1)
            {
               return int(_loc2_);
            }
         }
         return -1;
      }
      
      private function getEquipList(param1:BagInfo, param2:int) : BagInfo
      {
         var _loc5_:InventoryItemInfo = null;
         var _loc3_:BagInfo = new BagInfo(BagInfo.EQUIPBAG,BagInfo.MAXPROPCOUNT);
         var _loc4_:int = 30;
         for each(_loc5_ in param1.items)
         {
            if(_loc5_.Place >= 31)
            {
               if(param2 == 0)
               {
                  return this._info.Bag;
               }
               if(param2 == 1)
               {
                  if(_loc5_.CategoryID == 40)
                  {
                     var _loc8_:* = ++_loc4_;
                     _loc3_.items[_loc8_] = _loc5_;
                  }
               }
               else if(param2 == 2)
               {
                  if(EquipType.isFashionViewGoods(_loc5_))
                  {
                     _loc8_ = ++_loc4_;
                     _loc3_.items[_loc8_] = _loc5_;
                  }
               }
               else if(param2 == 3)
               {
                  if(!(_loc5_.CategoryID == 40 || EquipType.isFashionViewGoods(_loc5_) || _loc5_.CategoryID == 11 && _loc5_.Property8 == "1"))
                  {
                     _loc8_ = ++_loc4_;
                     _loc3_.items[_loc8_] = _loc5_;
                  }
               }
               else if(param2 == 4)
               {
                  if(_loc5_.CategoryID == 11 && _loc5_.Property8 == "1")
                  {
                     _loc8_ = ++_loc4_;
                     _loc3_.items[_loc8_] = _loc5_;
                  }
               }
            }
         }
         return _loc3_;
      }
      
      private function __changeState(param1:Event) : void
      {
         if(PlayerManager.Instance.playerstate == PlayerViewState.FASHION)
         {
            if(SavePointManager.Instance.isInSavePoint(64))
            {
               this.fashionShowLight();
               NewHandContainer.Instance.showArrow(ArrowType.CLICK_TO_EQUIP,135,"trainer.ClickToEquipArrowPos2","asset.trainer.clickToEquip","trainer.ClickToEquipTipPos2",LayerManager.Instance.getLayerByType(LayerManager.GAME_TOP_LAYER));
            }
         }
      }
      
      private function __changeClassHandler(param1:Event) : void
      {
         switch(this._ClassBtnGroup.selectIndex)
         {
            case 0:
               PlayerManager.Instance.Self.bagVibleType = 0;
               this.initsortBag(true);
               this.resetPageBtn();
               break;
            case 1:
               PlayerManager.Instance.Self.bagVibleType = 1;
               this.initsortBag(false);
               this.resetPageBtn();
               break;
            case 2:
               PlayerManager.Instance.Self.bagVibleType = 2;
               this.initsortBag(false);
               this.resetPageBtn();
               break;
            case 3:
               PlayerManager.Instance.Self.bagVibleType = 3;
               this.initsortBag(false);
               this.resetPageBtn();
               break;
            case 4:
               PlayerManager.Instance.Self.bagVibleType = 4;
               this.initsortBag(false);
               this.resetPageBtn();
         }
         this.updateBagList();
      }
      
      private function resetPageBtn() : void
      {
         this._PageBtnGroup.selectIndex = 0;
         this.__changeHandler(null);
      }
      
      private function initsortBag(param1:Boolean) : void
      {
         if(param1)
         {
            this._sortBagBtn.filters = null;
            this._sortBagBtn.enable = param1;
            this._breakBtn.filters = null;
            this._breakBtn.enable = param1;
         }
         else
         {
            this._sortBagBtn.filters = ComponentFactory.Instance.creatFilters("grayFilter");
            this._sortBagBtn.enable = param1;
            this._breakBtn.filters = ComponentFactory.Instance.creatFilters("grayFilter");
            this._breakBtn.enable = param1;
         }
      }
      
      private function __changeHandler(param1:Event) : void
      {
         switch(this._PageBtnGroup.selectIndex)
         {
            case 0:
               this._equiplist.visible = true;
               this._equiplist1.visible = false;
               this._equiplist2.visible = false;
               this._currentList = this._equiplist;
               this.currentPage = 1;
               break;
            case 1:
               this._equiplist.visible = false;
               this._equiplist1.visible = true;
               this._equiplist2.visible = false;
               this._currentList = this._equiplist1;
               this.currentPage = 2;
               break;
            case 2:
               this._equiplist.visible = false;
               this._equiplist1.visible = false;
               this._equiplist2.visible = true;
               this._currentList = this._equiplist2;
               this.currentPage = 3;
         }
      }
      
      private function setCurrPage(param1:int) : void
      {
      }
      
      protected function adjustEvent() : void
      {
      }
      
      protected function __openPreviewListFrame(param1:CrazyTankSocketEvent) : void
      {
         var _loc10_:InventoryItemInfo = null;
         var _loc2_:PackageIn = param1.pkg;
         var _loc3_:String = _loc2_.readUTF();
         var _loc4_:int = _loc2_.readInt();
         this.infos = [];
         var _loc5_:int = 0;
         while(_loc5_ < _loc4_)
         {
            _loc10_ = new InventoryItemInfo();
            _loc10_.TemplateID = _loc2_.readInt();
            _loc10_ = ItemManager.fill(_loc10_);
            _loc10_.Count = _loc2_.readInt();
            _loc10_.IsBinds = _loc2_.readBoolean();
            _loc10_.ValidDate = _loc2_.readInt();
            _loc10_.StrengthenLevel = _loc2_.readInt();
            _loc10_.AttackCompose = _loc2_.readInt();
            _loc10_.DefendCompose = _loc2_.readInt();
            _loc10_.AgilityCompose = _loc2_.readInt();
            _loc10_.LuckCompose = _loc2_.readInt();
            this.infos.push(_loc10_);
            _loc5_++;
         }
         var _loc6_:int = _loc2_.readInt();
         if(_loc6_ > 0)
         {
            return;
         }
         if(this.infos.length == 0)
         {
            SocketManager.Instance.out.sendClearStoreBag();
            return;
         }
         var _loc7_:AwardsView = new AwardsView();
         _loc7_.goodsList = this.infos;
         _loc7_.boxType = 4;
         var _loc8_:FilterFrameText = ComponentFactory.Instance.creat("bagandinfo.awardsFFT");
         _loc8_.text = LanguageMgr.GetTranslation("ddt.bagandinfo.awardsTitle");
         this._frame = ComponentFactory.Instance.creatComponentByStylename("bagAndInfo.ItemPreviewListFrame");
         var _loc9_:AlertInfo = new AlertInfo(_loc3_);
         _loc9_.showCancel = false;
         _loc9_.moveEnable = false;
         this._frame.info = _loc9_;
         this._frame.addToContent(_loc7_);
         this._frame.addToContent(_loc8_);
         this._frame.addEventListener(FrameEvent.RESPONSE,this.__frameClose);
         LayerManager.Instance.addToLayer(this._frame,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
      }
      
      private function __frameClose(param1:FrameEvent) : void
      {
         switch(param1.responseCode)
         {
            case FrameEvent.SUBMIT_CLICK:
            case FrameEvent.ENTER_CLICK:
               this._frame.removeEventListener(FrameEvent.RESPONSE,this.__frameClose);
               SoundManager.instance.play("008");
               (param1.currentTarget as BaseAlerFrame).removeEventListener(FrameEvent.RESPONSE,this.__frameClose);
               (param1.currentTarget as BaseAlerFrame).dispose();
               SocketManager.Instance.out.sendClearStoreBag();
               if(!PlayerManager.Instance.Self.Bag.itemBagFull())
               {
                  DropGoodsManager.play(this.infos);
               }
         }
      }
      
      protected function __useColorShell(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:PackageIn = param1.pkg;
         var _loc3_:Boolean = _loc2_.readBoolean();
         if(_loc3_)
         {
            SoundManager.instance.play("063");
         }
      }
      
      protected function removeEvents() : void
      {
         PlayerManager.Instance.Self.Bag.removeEventListener(BagEvent.UPDATE,this.__updateGoods);
         PlayerManager.Instance.removeEventListener(PlayerManager.CHAGE_STATE,this.__changeState);
         if(this._sellBtn)
         {
            this._sellBtn.removeEventListener(MouseEvent.CLICK,this.__sellClick);
         }
         if(this._breakBtn)
         {
            this._breakBtn.removeEventListener(MouseEvent.CLICK,this.__breakClick);
         }
         if(this._equiplist)
         {
            this._equiplist.removeEventListener(CellEvent.ITEM_CLICK,this.__cellEquipClick);
         }
         if(this._equiplist)
         {
            this._equiplist.removeEventListener(Event.CHANGE,this.__listChange);
         }
         if(this._equiplist)
         {
            this._equiplist.removeEventListener(CellEvent.DOUBLE_CLICK,this.__cellDoubleClick);
         }
         if(this._equiplist1)
         {
            this._equiplist1.removeEventListener(CellEvent.ITEM_CLICK,this.__cellEquipClick);
         }
         if(this._equiplist1)
         {
            this._equiplist1.removeEventListener(Event.CHANGE,this.__listChange);
         }
         if(this._equiplist1)
         {
            this._equiplist1.removeEventListener(CellEvent.DOUBLE_CLICK,this.__cellDoubleClick);
         }
         if(this._equiplist2)
         {
            this._equiplist2.removeEventListener(CellEvent.ITEM_CLICK,this.__cellEquipClick);
         }
         if(this._equiplist2)
         {
            this._equiplist2.removeEventListener(Event.CHANGE,this.__listChange);
         }
         if(this._equiplist2)
         {
            this._equiplist2.removeEventListener(CellEvent.DOUBLE_CLICK,this.__cellDoubleClick);
         }
         if(this._PageBtnGroup)
         {
            this._PageBtnGroup.removeEventListener(Event.CHANGE,this.__changeHandler);
         }
         if(this._onePageBtn)
         {
            this._onePageBtn.removeEventListener(MouseEvent.CLICK,this.__soundPlay);
         }
         if(this._ClassBtnGroup)
         {
            this._ClassBtnGroup.removeEventListener(Event.CHANGE,this.__changeClassHandler);
         }
         if(this._TwoPageBtn)
         {
            this._TwoPageBtn.removeEventListener(MouseEvent.CLICK,this.__soundPlay);
         }
         if(this._ThreePageBtn)
         {
            this._ThreePageBtn.removeEventListener(MouseEvent.CLICK,this.__soundPlay);
         }
         if(this._pageBtnSprite)
         {
            this._pageBtnSprite.removeEventListener(MouseEvent.MOUSE_OVER,this.__mouseOverHandler);
            this._pageBtnSprite.removeEventListener(MouseEvent.ROLL_OUT,this.__mouseOutHandler);
         }
         if(this._pageBtnSpriteI)
         {
            this._pageBtnSpriteI.removeEventListener(MouseEvent.MOUSE_OVER,this.__mouseOverHandlerI);
            this._pageBtnSpriteI.removeEventListener(MouseEvent.ROLL_OUT,this.__mouseOutHandlerI);
         }
         if(this._sortBagBtn)
         {
            this._sortBagBtn.removeEventListener(MouseEvent.CLICK,this.__sortBagClick);
         }
         CellMenu.instance.removeEventListener(CellMenu.ADDPRICE,this.__cellAddPrice);
         CellMenu.instance.removeEventListener(CellMenu.MOVE,this.__cellMove);
         CellMenu.instance.removeEventListener(CellMenu.OPEN,this.__cellOpen);
         CellMenu.instance.removeEventListener(CellMenu.USE,this.__cellUse);
         CellMenu.instance.removeEventListener(CellMenu.OPEN_ALL,this.__cellOpenAll);
         if(this._settingLockBtn)
         {
            this._settingLockBtn.removeEventListener(MouseEvent.CLICK,this.__openSettingLock);
         }
         if(this._settedLockBtn)
         {
            this._settedLockBtn.removeEventListener(MouseEvent.CLICK,this.__openModifyLock);
         }
         PlayerManager.Instance.Self.removeEventListener(BagEvent.CLEAR,this.__clearHandler);
         PlayerManager.Instance.Self.removeEventListener(BagEvent.AFTERDEL,this.__clearHandler);
         PlayerManager.Instance.Self.removeEventListener(BagEvent.CHANGEPSW,this.__clearHandler);
         PlayerManager.Instance.Self.removeEventListener(BagEvent.SHOW_BEAD,this.__showBead);
         if(this._info)
         {
            this._info.removeEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,this.__propertyChange);
            this._info.getBag(BagInfo.EQUIPBAG).removeEventListener(BagEvent.UPDATE,this.__onBagUpdateEQUIPBAG);
         }
         if(this._bagLockControl)
         {
            this._bagLockControl.addEventListener(Event.COMPLETE,this.__onLockComplete);
         }
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.USE_COLOR_SHELL,this.__useColorShell);
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.ITEM_OPENUP,this.__openPreviewListFrame);
      }
      
      public function setBagType(param1:int) : void
      {
         if(param1 == EQUIP)
         {
            if(this._equiplist && this.currentPage == 1)
            {
               this._currentList = this._equiplist;
            }
            else if(this._equiplist1 && this.currentPage == 2)
            {
               this._currentList = this._equiplist1;
            }
            else if(this._equiplist1 && this.currentPage == 3)
            {
               this._currentList = this._equiplist2;
            }
         }
         if(this._equiplist)
         {
            this._equiplist.visible = this._bagType == EQUIP && !this._isScreenTexp;
            if(this._equiplist.visible && this.currentPage == 1 && !this._isScreenTexp)
            {
               this._equiplist1.visible = this._bagType == EQUIP;
               this._equiplist2.visible = this._bagType == EQUIP;
               this._equiplist1.visible = false;
               this._equiplist2.visible = false;
               this._currentList = this._equiplist;
               this._PageBtnGroup.selectIndex = 0;
            }
            else if(this.currentPage == 2 && !this._isScreenTexp)
            {
               this._equiplist.visible = this._bagType == EQUIP;
               this._equiplist.visible = false;
               this._equiplist1.visible = this._bagType == EQUIP;
               this._equiplist2.visible = this._bagType == EQUIP;
               this._equiplist2.visible = false;
               this._currentList = this._equiplist1;
               this._PageBtnGroup.selectIndex = 1;
            }
            else if(this.currentPage == 3 && !this._isScreenTexp)
            {
               this._equiplist.visible = this._bagType == EQUIP;
               this._equiplist.visible = false;
               this._equiplist1.visible = this._bagType == EQUIP;
               this._equiplist1.visible = false;
               this._equiplist2.visible = this._bagType == EQUIP;
               this._currentList = this._equiplist2;
               this._PageBtnGroup.selectIndex = 2;
            }
         }
         if(this._bagType == param1)
         {
            if(this._bagType == EQUIP && !this._isScreenTexp)
            {
               if(SavePointManager.Instance.savePoints[34])
               {
                  this._sellBtn.filters = null;
                  this._continueBtn.filters = null;
               }
            }
            if(this._bagType == PROP)
            {
               this._continueBtn.filters = ComponentFactory.Instance.creatFilters("grayFilter");
            }
            return;
         }
         this._bagType = param1;
         dispatchEvent(new Event(TABCHANGE));
         this._bgShape.visible = this._bagType == EQUIP || this._bagType == PROP;
         this._equiplist.visible = this._bagType == EQUIP && !this._isScreenTexp;
         this._equiplist1.visible = this._bagType == EQUIP && !this._isScreenTexp;
         this._equiplist2.visible = this._bagType == EQUIP && !this._isScreenTexp;
         this.set_breakBtn_enable();
         if(this._bagType == EQUIP && !this._isScreenTexp)
         {
            this._sellBtn.filters = null;
            this._continueBtn.filters = null;
            this.initEquipBagPage();
         }
         if(this._bagType == PROP)
         {
            this._continueBtn.filters = ComponentFactory.Instance.creatFilters("grayFilter");
         }
      }
      
      protected function set_breakBtn_enable() : void
      {
      }
      
      protected function set_text_location() : void
      {
      }
      
      protected function set_btn_location() : void
      {
      }
      
      private function __onBagUpdateEQUIPBAG(param1:BagEvent) : void
      {
         this.setBagCountShow(BagInfo.EQUIPBAG);
      }
      
      private function __onBagUpdatePROPBAG(param1:BagEvent) : void
      {
         if(this.bagType != 21 && this.bagType != 2)
         {
            this.setBagCountShow(BagInfo.PROPBAG);
         }
      }
      
      private function __openSettingLock(param1:MouseEvent) : void
      {
         if(this._openBagLock)
         {
            return;
         }
         SoundManager.instance.play("008");
         if(!this._bagLockControl)
         {
            this._bagLockControl = new BagLockedController();
         }
         this._openBagLock = true;
         this._bagLockControl.show();
         this._bagLockControl.addEventListener(Event.COMPLETE,this.__onLockComplete);
         SharedManager.Instance.setBagLocked = true;
         SharedManager.Instance.save();
      }
      
      private function __openModifyLock(param1:MouseEvent) : void
      {
         if(this._openBagLock)
         {
            return;
         }
         SoundManager.instance.play("008");
         if(!this._bagLockControl)
         {
            this._bagLockControl = new BagLockedController();
         }
         this._bagLockControl.show();
         this._openBagLock = true;
         this._bagLockControl.addEventListener(Event.COMPLETE,this.__onLockComplete);
         SharedManager.Instance.setBagLocked = true;
         SharedManager.Instance.save();
      }
      
      private function __onLockComplete(param1:Event) : void
      {
         this._bagLockControl.removeEventListener(Event.COMPLETE,this.__onLockComplete);
         this._openBagLock = false;
      }
      
      protected function __sortBagClick(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         var _loc2_:String = LanguageMgr.GetTranslation("bagAndInfo.bag.sortBagClick.isSegistration");
         AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),_loc2_,LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),true,true,true,LayerManager.ALPHA_BLOCKGOUND).addEventListener(FrameEvent.RESPONSE,this.__frameEvent);
      }
      
      private function __frameEvent(param1:FrameEvent) : void
      {
         var _loc2_:BaseAlerFrame = param1.target as BaseAlerFrame;
         _loc2_.removeEventListener(FrameEvent.RESPONSE,this.__frameEvent);
         _loc2_.dispose();
         switch(param1.responseCode)
         {
            case FrameEvent.SUBMIT_CLICK:
            case FrameEvent.ENTER_CLICK:
               PlayerManager.Instance.Self.PropBag.sortBag(this._bagType,PlayerManager.Instance.Self.getBag(this._bagType),31,86,true);
               break;
            case FrameEvent.CANCEL_CLICK:
            case FrameEvent.CLOSE_CLICK:
            case FrameEvent.ESC_CLICK:
               PlayerManager.Instance.Self.PropBag.sortBag(this._bagType,PlayerManager.Instance.Self.getBag(this._bagType),0,48,false);
         }
      }
      
      private function __propertyChange(param1:PlayerPropertyEvent) : void
      {
         if(param1.changedProperties[PlayerInfo.MONEY] || param1.changedProperties[PlayerInfo.GOLD] || param1.changedProperties[PlayerInfo.DDT_MONEY] || param1.changedProperties[PlayerInfo.MEDAL])
         {
            this.updateMoney();
         }
         else if(param1.changedProperties["bagLocked"])
         {
            this._bagLocked = this._info.bagLocked;
            this.updateLockState();
         }
         this.updatePageBtn();
      }
      
      private function updateMoney() : void
      {
         if(this._info)
         {
            this._moneyView.setInfo(this._info);
            this._ddtmoneyView.setInfo(this._info);
            this._goldView.setInfo(this._info);
         }
      }
      
      private function updatePageBtn() : void
      {
         if(PlayerManager.Instance.Self.Grade < 20)
         {
            this._TwoPageBtn.filters = ComponentFactory.Instance.creatFilters("grayFilter");
            if(!this._pageBtnSprite)
            {
               this._pageBtnSprite = new Sprite();
               this._pageBtnSprite.addEventListener(MouseEvent.MOUSE_OVER,this.__mouseOverHandler);
               this._pageBtnSprite.addEventListener(MouseEvent.MOUSE_OUT,this.__mouseOutHandler);
               this._pageBtnSprite.graphics.beginFill(0,0);
               this._pageBtnSprite.graphics.drawRect(0,0,this._TwoPageBtn.displayWidth,this._TwoPageBtn.displayHeight);
               this._pageBtnSprite.graphics.endFill();
               this._pageBtnSprite.x = this._TwoPageBtn.x;
               this._pageBtnSprite.y = this._TwoPageBtn.y;
               addChild(this._pageBtnSprite);
            }
            if(this._pageTips == null)
            {
               this._pageTips = new OneLineTip();
               this._pageTips.tipData = LanguageMgr.GetTranslation("ddt.bagAndInfo.UnLockPage20");
               this._pageTips.visible = false;
            }
         }
         else
         {
            this._TwoPageBtn.filters = null;
            this._TwoPageBtn.enable = true;
            if(this._pageTips)
            {
               ObjectUtils.disposeObject(this._pageTips);
               this._pageTips = null;
            }
            if(this._pageBtnSprite)
            {
               ObjectUtils.disposeObject(this._pageBtnSprite);
               this._pageBtnSprite = null;
            }
         }
         if(PlayerManager.Instance.Self.Grade < 30)
         {
            this._ThreePageBtn.filters = ComponentFactory.Instance.creatFilters("grayFilter");
            this._ThreePageBtn.enable = false;
            if(!this._pageBtnSpriteI)
            {
               this._pageBtnSpriteI = new Sprite();
               this._pageBtnSpriteI.addEventListener(MouseEvent.MOUSE_OVER,this.__mouseOverHandlerI);
               this._pageBtnSpriteI.addEventListener(MouseEvent.MOUSE_OUT,this.__mouseOutHandlerI);
               this._pageBtnSpriteI.graphics.beginFill(0,0);
               this._pageBtnSpriteI.graphics.drawRect(0,0,this._ThreePageBtn.displayWidth,this._ThreePageBtn.displayHeight);
               this._pageBtnSpriteI.graphics.endFill();
               this._pageBtnSpriteI.x = this._ThreePageBtn.x;
               this._pageBtnSpriteI.y = this._ThreePageBtn.y;
               addChild(this._pageBtnSpriteI);
            }
            if(this._pageTipsI == null)
            {
               this._pageTipsI = new OneLineTip();
               this._pageTipsI.tipData = LanguageMgr.GetTranslation("ddt.bagAndInfo.UnLockPage30");
               this._pageTipsI.visible = false;
            }
         }
         else
         {
            this._ThreePageBtn.filters = null;
            this._ThreePageBtn.enable = true;
            if(this._pageTipsI)
            {
               ObjectUtils.disposeObject(this._pageTipsI);
               this._pageTipsI = null;
            }
            if(this._pageBtnSpriteI)
            {
               ObjectUtils.disposeObject(this._pageBtnSpriteI);
               this._pageBtnSpriteI = null;
            }
         }
      }
      
      protected function __listChange(param1:Event) : void
      {
         if(this._isScreenTexp)
         {
            this.setBagType(BagInfo.PROPBAG);
         }
         else
         {
            this.setBagType(BagInfo.EQUIPBAG);
         }
      }
      
      private function __sellClick(param1:MouseEvent) : void
      {
         if(this.currentPage == 1)
         {
            this._equiplist.visible = true;
            this._equiplist1.visible = false;
            this._equiplist2.visible = false;
         }
         else if(this.currentPage == 2)
         {
            this._equiplist.visible = false;
            this._equiplist1.visible = true;
            this._equiplist2.visible = false;
         }
         else
         {
            this._equiplist.visible = false;
            this._equiplist1.visible = false;
            this._equiplist2.visible = true;
         }
         if(!(this.state & this.STATE_SELL))
         {
            Mouse.hide();
            this.state |= this.STATE_SELL;
            SoundManager.instance.play("008");
            this._sellBtn.dragStart(param1.stageX,param1.stageY);
            this._sellBtn.addEventListener(SellGoodsBtn.StopSell,this.__stopSell);
            dispatchEvent(new Event("sellstart"));
            stage.addEventListener(MouseEvent.CLICK,this.__onStageClick_SellBtn);
            param1.stopImmediatePropagation();
         }
         else
         {
            this.state = ~this.STATE_SELL & this.state;
            this._sellBtn.stopDrag();
         }
      }
      
      private function __stopSell(param1:Event) : void
      {
         this.state = ~this.STATE_SELL & this.state;
         this._sellBtn.removeEventListener(SellGoodsBtn.StopSell,this.__stopSell);
         dispatchEvent(new Event("sellstop"));
         if(stage)
         {
            stage.removeEventListener(MouseEvent.CLICK,this.__onStageClick_SellBtn);
         }
      }
      
      private function __onStageClick_SellBtn(param1:Event) : void
      {
         this.state = ~this.STATE_SELL & this.state;
         dispatchEvent(new Event("sellstop"));
         if(stage)
         {
            stage.removeEventListener(MouseEvent.CLICK,this.__onStageClick_SellBtn);
         }
      }
      
      private function __breakClick(param1:MouseEvent) : void
      {
         if(this._breakBtn.enable)
         {
            SoundManager.instance.play("008");
            Mouse.hide();
            this._breakBtn.dragStart(param1.stageX,param1.stageY);
         }
      }
      
      public function resetMouse() : void
      {
         this.state = ~this.STATE_SELL & this.state;
         LayerManager.Instance.clearnStageDynamic();
         Mouse.show();
         if(this._breakBtn)
         {
            this._breakBtn.stopDrag();
         }
      }
      
      private function isOnlyGivingGoods(param1:InventoryItemInfo) : Boolean
      {
         return param1.IsBinds == false && EquipType.isPackage(param1) && param1.Property2 == "10";
      }
      
      protected function __cellEquipClick(param1:CellEvent) : void
      {
         var _loc2_:* = undefined;
         var _loc3_:InventoryItemInfo = null;
         var _loc4_:Point = null;
         var _loc5_:Point = null;
         if(!this._sellBtn.isActive)
         {
            param1.stopImmediatePropagation();
            if(param1.data is LockBagCell)
            {
               _loc2_ = param1.data as LockBagCell;
            }
            if(_loc2_)
            {
               _loc3_ = _loc2_.itemInfo as InventoryItemInfo;
            }
            if(_loc3_ == null)
            {
               return;
            }
            if(!_loc2_.locked)
            {
               SoundManager.instance.play("008");
               if(!this.isOnlyGivingGoods(_loc3_) && (_loc3_.getRemainDate() <= 0 && !EquipType.isProp(_loc3_) || EquipType.isPackage(_loc3_) || _loc3_.getRemainDate() <= 0 && _loc3_.TemplateID == 10200 || EquipType.canBeUsed(_loc3_)))
               {
                  _loc4_ = localToGlobal(new Point(_loc2_.x,_loc2_.y));
                  CellMenu.instance.show(_loc2_,_loc4_.x + 35,_loc4_.y + 77);
               }
               else if(_loc3_.CategoryID == 41)
               {
                  _loc5_ = localToGlobal(new Point(_loc2_.x,_loc2_.y));
                  CellMenu.instance.show(_loc2_,_loc5_.x + 35,_loc5_.y + 77);
               }
               else
               {
                  _loc2_.dragStart();
               }
            }
         }
      }
      
      protected function __cellClick(param1:CellEvent) : void
      {
         var _loc2_:* = undefined;
         var _loc3_:InventoryItemInfo = null;
         var _loc4_:Point = null;
         var _loc5_:Point = null;
         if(!this._sellBtn.isActive)
         {
            param1.stopImmediatePropagation();
            if(param1.data is LockBagCell)
            {
               _loc2_ = param1.data as LockBagCell;
            }
            else if(param1.data is BagCell)
            {
               _loc2_ = param1.data as BagCell;
            }
            if(_loc2_)
            {
               _loc3_ = _loc2_.itemInfo as InventoryItemInfo;
            }
            if(_loc3_ == null)
            {
               return;
            }
            if(!_loc2_.locked)
            {
               SoundManager.instance.play("008");
               if(!this.isOnlyGivingGoods(_loc3_) && (_loc3_.getRemainDate() <= 0 && !EquipType.isProp(_loc3_) || EquipType.isPackage(_loc3_) || _loc3_.getRemainDate() <= 0 && _loc3_.TemplateID == 10200 || EquipType.canBeUsed(_loc3_)))
               {
                  _loc4_ = localToGlobal(new Point(_loc2_.x,_loc2_.y));
                  CellMenu.instance.show(_loc2_,_loc4_.x + 35,_loc4_.y + 77);
               }
               else if(_loc3_.CategoryID == 41)
               {
                  _loc5_ = localToGlobal(new Point(_loc2_.x,_loc2_.y));
                  CellMenu.instance.show(_loc2_,_loc5_.x + 35,_loc5_.y + 77);
               }
               else
               {
                  _loc2_.dragStart();
               }
            }
         }
      }
      
      public function set cellDoubleClickEnable(param1:Boolean) : void
      {
         if(param1)
         {
            this._equiplist.addEventListener(CellEvent.DOUBLE_CLICK,this.__cellDoubleClick);
         }
         else
         {
            this._equiplist.removeEventListener(CellEvent.DOUBLE_CLICK,this.__cellDoubleClick);
         }
      }
      
      public function unlockBagCells() : void
      {
         this._equiplist.unlockAllCells();
      }
      
      public function weaponShowLight() : void
      {
         this._equiplist.weaponShowLight();
      }
      
      public function fashionShowLight() : void
      {
         this._equiplist.fashionEquipShine();
      }
      
      protected function __cellDoubleClick(param1:CellEvent) : void
      {
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:BaseAlerFrame = null;
         var _loc10_:Number = NaN;
         var _loc11_:Date = null;
         var _loc12_:int = 0;
         var _loc13_:int = 0;
         var _loc14_:int = 0;
         var _loc15_:BaseAlerFrame = null;
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            return;
         }
         param1.stopImmediatePropagation();
         var _loc2_:LockBagCell = param1.data as LockBagCell;
         var _loc3_:InventoryItemInfo = _loc2_.info as InventoryItemInfo;
         var _loc4_:ItemTemplateInfo = ItemManager.Instance.getTemplateById(_loc3_.TemplateID);
         var _loc5_:EquipmentTemplateInfo = ItemManager.Instance.getEquipTemplateById(_loc3_.TemplateID);
         var _loc6_:int = !!PlayerManager.Instance.Self.Sex ? int(1) : int(2);
         if(_loc3_.getRemainDate() <= 0)
         {
            return;
         }
         if(!_loc2_.locked)
         {
            if(EquipType.isEquipViewGoods(_loc3_))
            {
               _loc7_ = PlayerManager.Instance.getEquipPlace(_loc3_);
            }
            else
            {
               _loc8_ = PlayerManager.Instance.getDressEquipPlace(_loc3_);
            }
            if(_loc5_)
            {
               if(_loc3_.NeedLevel > PlayerManager.Instance.Self.Grade)
               {
                  return MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.data.player.SelfInfo.need"));
               }
            }
            if((_loc2_.info.BindType == 1 || _loc2_.info.BindType == 2 || _loc2_.info.BindType == 3) && _loc2_.itemInfo.IsBinds == false && !EquipType.isPackage(_loc3_) && !EquipType.canBeUsed(_loc3_))
            {
               _loc9_ = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("tank.view.bagII.BagIIView.BindsInfo"),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),true,true,true,LayerManager.ALPHA_BLOCKGOUND);
               _loc9_.addEventListener(FrameEvent.RESPONSE,this.__onResponse);
               this.temInfo = _loc3_;
            }
            else if(PlayerManager.Instance.playerstate != PlayerViewState.FASHION && EquipType.isFashionViewGoods(_loc3_))
            {
               PlayerManager.Instance.changeState(PlayerViewState.FASHION);
               SocketManager.Instance.out.sendMoveGoods(BagInfo.EQUIPBAG,_loc3_.Place,BagInfo.EQUIPBAG,_loc8_,_loc3_.Count);
            }
            else if(EquipType.isRingEquipment(_loc3_))
            {
               PlayerManager.Instance.changeState(PlayerViewState.FASHION);
               SocketManager.Instance.out.sendMoveGoods(BagInfo.EQUIPBAG,_loc3_.Place,BagInfo.EQUIPBAG,_loc7_,_loc3_.Count);
            }
            else if(PlayerManager.Instance.playerstate != PlayerViewState.EQUIP && EquipType.isEquipViewGoods(_loc3_))
            {
               PlayerManager.Instance.changeState(PlayerViewState.EQUIP);
               SocketManager.Instance.out.sendMoveGoods(BagInfo.EQUIPBAG,_loc3_.Place,BagInfo.EQUIPBAG,_loc7_,_loc3_.Count);
            }
            else
            {
               SoundManager.instance.play("008");
               if(_loc3_.TemplateID == EquipType.SUPER_EXP || _loc3_.TemplateID == EquipType.PET_ADVANCE || _loc3_.TemplateID == EquipType.PET_EXP)
               {
                  this.useCard(_loc3_);
               }
               else if(_loc2_.info.CategoryID == 11 && _loc2_.info.Property1 == "34")
               {
                  this.usePetBless(_loc2_.itemInfo);
               }
               else if(EquipType.isPackage(_loc3_))
               {
                  _loc10_ = !!PlayerManager.Instance.Self.Sex ? Number(1) : Number(2);
                  if(_loc2_.info.NeedSex != 0 && _loc10_ != _loc2_.info.NeedSex)
                  {
                     MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.view.bagII.sexErr"));
                     return;
                  }
                  if(PlayerManager.Instance.Self.Grade >= _loc2_.info.NeedLevel)
                  {
                     if(EquipType.isTimeBox(_loc2_.info))
                     {
                        _loc11_ = DateUtils.getDateByStr(InventoryItemInfo(_loc2_.info).BeginDate);
                        _loc12_ = int(_loc2_.info.Property3) * 60 - (TimeManager.Instance.Now().time - _loc11_.getTime()) / 1000;
                        if(_loc12_ <= 0)
                        {
                           SocketManager.Instance.out.sendItemOpenUp(_loc2_.itemInfo.BagType,_loc2_.itemInfo.Place);
                        }
                        else
                        {
                           _loc13_ = _loc12_ / 3600;
                           _loc14_ = _loc12_ % 3600 / 60;
                           _loc14_ = _loc14_ > 0 ? int(_loc14_) : int(1);
                           MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.userGuild.boxTip",_loc13_,_loc14_));
                        }
                     }
                     else if(EquipType.isSpecilPackage(_loc2_.info))
                     {
                        if(PlayerManager.Instance.Self.DDTMoney >= Number(_loc2_.info.Property3))
                        {
                           _loc15_ = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("tips"),LanguageMgr.GetTranslation("tank.view.bagII.BagIIView.AskGiftBag",_loc2_.info.Property3,_loc2_.info.Name),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),false,false,false,LayerManager.ALPHA_BLOCKGOUND);
                           _loc15_.addEventListener(FrameEvent.RESPONSE,this.__GiftBagframeClose);
                        }
                        else
                        {
                           MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.view.bagII.BagIIView.AskGiftBagII",_loc2_.info.Property3));
                        }
                     }
                     else
                     {
                        SocketManager.Instance.out.sendItemOpenUp(_loc2_.itemInfo.BagType,_loc2_.itemInfo.Place);
                     }
                  }
                  else
                  {
                     MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.view.bagII.BagIIView.level"));
                  }
               }
               else if(EquipType.canBeUsed(_loc3_))
               {
                  if(_loc2_.info.TemplateID == EquipType.VITALITY_WATER)
                  {
                     this.useCard(_loc2_.itemInfo);
                     return;
                  }
                  if(_loc2_.info.TemplateID == EquipType.REWORK_NAME)
                  {
                     this.startReworkName(_loc2_.bagType,_loc2_.itemInfo.Place);
                     return;
                  }
                  if(_loc2_.info.CategoryID == 11 && _loc2_.info.Property1 == "5" && _loc2_.info.Property2 != "0")
                  {
                     this.showChatBugleInputFrame(_loc2_.info.TemplateID);
                     return;
                  }
                  if(_loc2_.info.CategoryID == 11 && _loc2_.info.Property1 == "34")
                  {
                     this.usePetBless(_loc2_.itemInfo);
                     return;
                  }
                  if(_loc2_.info.TemplateID == EquipType.CONSORTIA_REWORK_NAME)
                  {
                     if(PlayerManager.Instance.Self.ConsortiaID == 0)
                     {
                        MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.view.ConsortiaReworkNameView.consortiaNameAlert1"));
                        return;
                     }
                     if(PlayerManager.Instance.Self.NickName != PlayerManager.Instance.Self.consortiaInfo.ChairmanName)
                     {
                        MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.view.ConsortiaReworkNameView.consortiaNameAlert2"));
                        return;
                     }
                     this.startupConsortiaReworkName(_loc2_.bagType,_loc2_.itemInfo.Place);
                     return;
                  }
                  if(_loc2_.info.TemplateID == EquipType.CHANGE_SEX)
                  {
                     this.startupChangeSex(_loc2_.bagType,_loc2_.itemInfo.Place);
                     return;
                  }
                  if(_loc2_.info.CategoryID == 11 && int(_loc2_.info.Property1) == 37)
                  {
                     if(!PlayerManager.Instance.Self.Bag.getItemAt(6))
                     {
                        MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.bagAndInfo.ColorShell.NoWeapon"));
                        return;
                     }
                     if(PlayerManager.Instance.Self.Bag.getItemAt(6).StrengthenLevel >= 10)
                     {
                        SocketManager.Instance.out.sendUseChangeColorShell(_loc2_.bagType,_loc2_.place);
                        return;
                     }
                     MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("bagAndInfo.bag.UnableUseColorShell"));
                  }
                  if(_loc2_.info.TemplateID == EquipType.COLORCARD)
                  {
                     if(!this._changeColorController)
                     {
                        this._changeColorController = new ChangeColorController();
                     }
                     this._changeColorController.changeColorModel.place = _loc2_.itemInfo.Place;
                     UIModuleSmallLoading.Instance.progress = 0;
                     UIModuleSmallLoading.Instance.show();
                     UIModuleSmallLoading.Instance.addEventListener(Event.CLOSE,this.__onClose);
                     UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.__changeColorProgress);
                     UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.__changeColorComplete);
                     UIModuleLoader.Instance.addUIModuleImp(UIModuleTypes.CHANGECOLOR);
                  }
                  else if(_loc2_.info.TemplateID != EquipType.TRANSFER_PROP)
                  {
                     if(_loc2_.info.CategoryID == EquipType.COMPOSE_SKILL)
                     {
                        SocketManager.Instance.out.sendFormula(_loc2_.itemInfo.Place);
                     }
                     else if(_loc2_.info.CategoryID == 11 && int(_loc2_.info.Property1) == 100)
                     {
                        this.useProp(_loc2_.itemInfo);
                     }
                     else
                     {
                        this.useCard(_loc2_.itemInfo);
                        if(_loc2_.itemInfo.TemplateID == EquipType.VIPCARD_TEST)
                        {
                           VipController.instance.show();
                        }
                     }
                  }
               }
               else if(PlayerManager.Instance.Self.canEquip(_loc3_))
               {
                  if(PlayerManager.Instance.playerstate == PlayerViewState.FASHION)
                  {
                     SocketManager.Instance.out.sendMoveGoods(BagInfo.EQUIPBAG,_loc3_.Place,BagInfo.EQUIPBAG,_loc8_,_loc3_.Count);
                  }
                  else
                  {
                     SocketManager.Instance.out.sendMoveGoods(BagInfo.EQUIPBAG,_loc3_.Place,BagInfo.EQUIPBAG,_loc7_,_loc3_.Count);
                  }
               }
            }
         }
      }
      
      private function usePetBless(param1:InventoryItemInfo) : void
      {
         var _loc3_:PetBlessView = null;
         var _loc2_:PetInfo = PlayerManager.Instance.Self.pets[0];
         if(_loc2_)
         {
            if(int(_loc2_.TemplateID % 100000 / 10000) + 1 == int(param1.Property2))
            {
               if(_loc2_.TemplateID % 1000 / 100 < 2)
               {
                  _loc3_ = ComponentFactory.Instance.creat("bagAndInfo.petBlessView");
                  _loc3_.petInfo = _loc2_;
                  _loc3_.itemInfo = param1;
                  LayerManager.Instance.addToLayer(_loc3_,LayerManager.STAGE_TOP_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
               }
               else
               {
                  MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddtbagAndInfo.usePetBlessAlertFailed1Msg"));
               }
            }
            else
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddtbagAndInfo.usePetBlessAlertFailed2Msg"));
            }
         }
         else
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddtbagAndInfo.usePetBlessAlertFailed3Msg"));
         }
      }
      
      private function __onResponse(param1:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         var _loc2_:BaseAlerFrame = param1.target as BaseAlerFrame;
         _loc2_.removeEventListener(FrameEvent.RESPONSE,this.__onResponse);
         _loc2_.dispose();
         if(param1.responseCode == FrameEvent.ENTER_CLICK || param1.responseCode == FrameEvent.SUBMIT_CLICK)
         {
            this.sendDefy();
         }
      }
      
      private function sendDefy() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         SoundManager.instance.play("008");
         if(EquipType.isEquipViewGoods(this.temInfo))
         {
            _loc1_ = PlayerManager.Instance.getEquipPlace(this.temInfo);
         }
         else
         {
            _loc2_ = PlayerManager.Instance.getDressEquipPlace(this.temInfo);
         }
         if(PlayerManager.Instance.playerstate != PlayerViewState.FASHION && (EquipType.isFashionViewGoods(this.temInfo) || EquipType.isRingEquipment(this.temInfo)))
         {
            PlayerManager.Instance.changeState(PlayerViewState.FASHION);
            SocketManager.Instance.out.sendMoveGoods(BagInfo.EQUIPBAG,this.temInfo.Place,BagInfo.EQUIPBAG,_loc2_,this.temInfo.Count);
         }
         else if(PlayerManager.Instance.playerstate != PlayerViewState.EQUIP && !EquipType.isFashionViewGoods(this.temInfo))
         {
            PlayerManager.Instance.changeState(PlayerViewState.EQUIP);
            SocketManager.Instance.out.sendMoveGoods(BagInfo.EQUIPBAG,this.temInfo.Place,BagInfo.EQUIPBAG,_loc1_,this.temInfo.Count);
         }
         else
         {
            SoundManager.instance.play("008");
            if(PlayerManager.Instance.Self.canEquip(this.temInfo))
            {
               if(PlayerManager.Instance.playerstate == PlayerViewState.FASHION)
               {
                  SocketManager.Instance.out.sendMoveGoods(BagInfo.EQUIPBAG,this.temInfo.Place,BagInfo.EQUIPBAG,_loc2_,this.temInfo.Count);
               }
               else
               {
                  SocketManager.Instance.out.sendMoveGoods(BagInfo.EQUIPBAG,this.temInfo.Place,BagInfo.EQUIPBAG,_loc1_,this.temInfo.Count);
               }
            }
         }
      }
      
      private function __cellAddPrice(param1:Event) : void
      {
         var _loc2_:LockBagCell = CellMenu.instance.cell;
         if(_loc2_)
         {
            if(ShopManager.Instance.canAddPrice(_loc2_.itemInfo.TemplateID))
            {
               if(PlayerManager.Instance.Self.bagLocked)
               {
                  BaglockedManager.Instance.show();
                  return;
               }
               AddPricePanel.Instance.setInfo(_loc2_.itemInfo,false);
               AddPricePanel.Instance.show();
            }
            else
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.view.bagII.cantAddPrice"));
            }
         }
      }
      
      private function __cellMove(param1:Event) : void
      {
         var _loc2_:LockBagCell = CellMenu.instance.cell;
         if(_loc2_)
         {
            _loc2_.dragStart();
         }
      }
      
      protected function __cellOpen(param1:Event) : void
      {
         var _loc3_:Number = NaN;
         var _loc4_:Date = null;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:BaseAlerFrame = null;
         var _loc2_:LockBagCell = CellMenu.instance.cell as LockBagCell;
         this._currentCell = _loc2_;
         if(_loc2_ != null && _loc2_.itemInfo != null)
         {
            if(PlayerManager.Instance.Self.bagLocked)
            {
               BaglockedManager.Instance.show();
               return;
            }
            _loc3_ = !!PlayerManager.Instance.Self.Sex ? Number(1) : Number(2);
            if(_loc2_.info.NeedSex != 0 && _loc3_ != _loc2_.info.NeedSex)
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.view.bagII.sexErr"));
               return;
            }
            if(PlayerManager.Instance.Self.Grade >= _loc2_.info.NeedLevel)
            {
               if(EquipType.isTimeBox(_loc2_.info))
               {
                  _loc4_ = DateUtils.getDateByStr(InventoryItemInfo(_loc2_.info).BeginDate);
                  _loc5_ = int(_loc2_.info.Property3) * 60 - (TimeManager.Instance.Now().time - _loc4_.getTime()) / 1000;
                  if(_loc5_ <= 0)
                  {
                     SocketManager.Instance.out.sendItemOpenUp(_loc2_.itemInfo.BagType,_loc2_.itemInfo.Place);
                  }
                  else
                  {
                     _loc6_ = _loc5_ / 3600;
                     _loc7_ = _loc5_ % 3600 / 60;
                     _loc7_ = _loc7_ > 0 ? int(_loc7_) : int(1);
                     MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.userGuild.boxTip",_loc6_,_loc7_));
                  }
               }
               else if(EquipType.isSpecilPackage(_loc2_.info))
               {
                  if(PlayerManager.Instance.Self.DDTMoney >= Number(_loc2_.info.Property3))
                  {
                     _loc8_ = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("tips"),LanguageMgr.GetTranslation("tank.view.bagII.BagIIView.AskGiftBag",_loc2_.info.Property3,_loc2_.info.Name),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),false,false,false,LayerManager.ALPHA_BLOCKGOUND);
                     _loc8_.addEventListener(FrameEvent.RESPONSE,this.__GiftBagframeClose);
                  }
                  else
                  {
                     MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.view.bagII.BagIIView.AskGiftBagII",_loc2_.info.Property3));
                  }
               }
               else
               {
                  SocketManager.Instance.out.sendItemOpenUp(_loc2_.itemInfo.BagType,_loc2_.itemInfo.Place);
               }
            }
            else
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.view.bagII.BagIIView.level"));
            }
         }
      }
      
      private function __GiftBagframeClose(param1:FrameEvent) : void
      {
         switch(param1.responseCode)
         {
            case FrameEvent.SUBMIT_CLICK:
            case FrameEvent.ENTER_CLICK:
               if(this._currentCell && this._currentCell.itemInfo)
               {
                  SocketManager.Instance.out.sendItemOpenUp(this._currentCell.itemInfo.BagType,this._currentCell["place"]);
               }
         }
         param1.currentTarget.removeEventListener(FrameEvent.RESPONSE,this.__GiftBagframeClose);
         ObjectUtils.disposeObject(param1.currentTarget);
      }
      
      private function __cellUse(param1:Event) : void
      {
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            return;
         }
         param1.stopImmediatePropagation();
         var _loc2_:LockBagCell = CellMenu.instance.cell as LockBagCell;
         if(!_loc2_ || _loc2_.info == null)
         {
            return;
         }
         if(_loc2_.info.TemplateID == EquipType.VITALITY_WATER)
         {
            this.useCard(_loc2_.itemInfo);
            return;
         }
         if(_loc2_.info.TemplateID == EquipType.REWORK_NAME)
         {
            this.startReworkName(_loc2_.bagType,_loc2_.itemInfo.Place);
            return;
         }
         if(_loc2_.info.CategoryID == 11 && _loc2_.info.Property1 == "5" && _loc2_.info.Property2 != "0")
         {
            this.showChatBugleInputFrame(_loc2_.info.TemplateID);
            return;
         }
         if(_loc2_.info.CategoryID == 11 && _loc2_.info.Property1 == "34")
         {
            this.usePetBless(_loc2_.itemInfo);
            return;
         }
         if(_loc2_.info.TemplateID == EquipType.CONSORTIA_REWORK_NAME)
         {
            if(PlayerManager.Instance.Self.ConsortiaID == 0)
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.view.ConsortiaReworkNameView.consortiaNameAlert1"));
               return;
            }
            if(PlayerManager.Instance.Self.NickName != PlayerManager.Instance.Self.consortiaInfo.ChairmanName)
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.view.ConsortiaReworkNameView.consortiaNameAlert2"));
               return;
            }
            this.startupConsortiaReworkName(_loc2_.bagType,_loc2_.itemInfo.Place);
            return;
         }
         if(_loc2_.info.TemplateID == EquipType.CHANGE_SEX)
         {
            this.startupChangeSex(_loc2_.bagType,_loc2_.itemInfo.Place);
            return;
         }
         if(_loc2_.info.CategoryID == 11 && int(_loc2_.info.Property1) == 37)
         {
            if(!PlayerManager.Instance.Self.Bag.getItemAt(6))
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.bagAndInfo.ColorShell.NoWeapon"));
               return;
            }
            if(PlayerManager.Instance.Self.Bag.getItemAt(6).StrengthenLevel >= 10)
            {
               SocketManager.Instance.out.sendUseChangeColorShell(_loc2_.bagType,_loc2_.place);
               return;
            }
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("bagAndInfo.bag.UnableUseColorShell"));
         }
         if(_loc2_.info.TemplateID == EquipType.COLORCARD)
         {
            if(!this._changeColorController)
            {
               this._changeColorController = new ChangeColorController();
            }
            this._changeColorController.changeColorModel.place = _loc2_.itemInfo.Place;
            UIModuleSmallLoading.Instance.progress = 0;
            UIModuleSmallLoading.Instance.show();
            UIModuleSmallLoading.Instance.addEventListener(Event.CLOSE,this.__onClose);
            UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.__changeColorProgress);
            UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.__changeColorComplete);
            UIModuleLoader.Instance.addUIModuleImp(UIModuleTypes.CHANGECOLOR);
         }
         else if(_loc2_.info.TemplateID != EquipType.TRANSFER_PROP)
         {
            if(_loc2_.info.CategoryID == EquipType.COMPOSE_SKILL)
            {
               SocketManager.Instance.out.sendFormula(_loc2_.itemInfo.Place);
            }
            else if(_loc2_.info.CategoryID == 11 && int(_loc2_.info.Property1) == 100)
            {
               this.useProp(_loc2_.itemInfo);
            }
            else
            {
               this.useCard(_loc2_.itemInfo);
               if(_loc2_.itemInfo.TemplateID == EquipType.VIPCARD_TEST)
               {
                  VipController.instance.show();
               }
            }
         }
      }
      
      private function __cellOpenAll(param1:Event) : void
      {
         var _loc3_:OpenAllFrame = null;
         var _loc2_:LockBagCell = CellMenu.instance.cell as LockBagCell;
         this._currentCell = _loc2_;
         if(_loc2_ != null && _loc2_.itemInfo != null)
         {
            if(PlayerManager.Instance.Self.bagLocked)
            {
               BaglockedManager.Instance.show();
               return;
            }
         }
         if(PlayerManager.Instance.Self.Grade >= _loc2_.info.NeedLevel)
         {
            _loc3_ = ComponentFactory.Instance.creatComponentByStylename("ddt.corei.OpenAllFrame");
            _loc3_.ItemInfo = _loc2_.itemInfo;
            LayerManager.Instance.addToLayer(_loc3_,LayerManager.GAME_TOP_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
         }
         else
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.view.bagII.BagIIView.level"));
         }
      }
      
      private function __onClose(param1:Event) : void
      {
         UIModuleSmallLoading.Instance.hide();
         UIModuleSmallLoading.Instance.removeEventListener(Event.CLOSE,this.__onClose);
         UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.__changeColorProgress);
         UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.__changeColorComplete);
      }
      
      private function __changeColorProgress(param1:UIModuleEvent) : void
      {
         if(param1.module == UIModuleTypes.CHANGECOLOR)
         {
            UIModuleSmallLoading.Instance.progress = param1.loader.progress * 100;
         }
      }
      
      private function __changeColorComplete(param1:UIModuleEvent) : void
      {
         if(param1.module == UIModuleTypes.CHANGECOLOR)
         {
            UIModuleSmallLoading.Instance.removeEventListener(Event.CLOSE,this.__onClose);
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.__changeColorProgress);
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.__changeColorComplete);
            UIModuleSmallLoading.Instance.hide();
            this._changeColorController.show();
         }
      }
      
      private function useCard(param1:InventoryItemInfo) : void
      {
         if(param1.CanUse)
         {
            if(this._self.Grade < 3 && (param1.TemplateID == EquipType.VIPCARD || param1.TemplateID == EquipType.VIPCARD_TEST))
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.functionLimitTip",3));
               return;
            }
            SocketManager.Instance.out.sendUseCard(param1.BagType,param1.Place,[param1.TemplateID],param1.PayType);
         }
      }
      
      private function useProp(param1:InventoryItemInfo) : void
      {
         if(!param1)
         {
            return;
         }
         SocketManager.Instance.out.sendUseProp(param1.BagType,param1.Place,[param1.TemplateID],param1.PayType);
      }
      
      public function setCellInfo(param1:int, param2:InventoryItemInfo) : void
      {
         this._currentList.setCellInfo(param1,param2);
      }
      
      public function setPlace(param1:int) : Point
      {
         if(param1 < 79)
         {
            this._PageBtnGroup.selectIndex == 0;
            this._equiplist.visible = true;
            this._equiplist1.visible = false;
            this._equiplist2.visible = false;
            this._currentPage = 1;
            return this._equiplist.getCellPosByPlace(param1);
         }
         if(79 <= param1 && param1 < 127)
         {
            this._PageBtnGroup.selectIndex == 1;
            this._equiplist.visible = false;
            this._equiplist1.visible = true;
            this._equiplist2.visible = false;
            this._currentPage = 2;
            return this._equiplist.getCellPosByPlace(param1 - 48);
         }
         if(127 <= param1 && param1 < 175)
         {
            this._PageBtnGroup.selectIndex == 2;
            this._equiplist.visible = false;
            this._equiplist1.visible = false;
            this._equiplist2.visible = true;
            this._currentPage = 3;
            return this._equiplist.getCellPosByPlace(param1 - 96);
         }
         return null;
      }
      
      public function dispose() : void
      {
         this.removeEvents();
         this.resetMouse();
         this._changeColorController = null;
         if(this._bagLockControl)
         {
            this._bagLockControl.close();
         }
         this._bagLockControl = null;
         this._info = null;
         this.infos = null;
         if(this._sellBtn)
         {
            this._sellBtn.removeEventListener(MouseEvent.CLICK,this.__sellClick);
         }
         if(this._sellBtn)
         {
            this._sellBtn.removeEventListener(SellGoodsBtn.StopSell,this.__stopSell);
         }
         if(this._breakBtn)
         {
            this._breakBtn.removeEventListener(MouseEvent.CLICK,this.__breakClick);
         }
         if(this._frame)
         {
            this._frame.removeEventListener(FrameEvent.RESPONSE,this.__frameClose);
            this._frame.dispose();
            this._frame = null;
            SocketManager.Instance.out.sendClearStoreBag();
         }
         if(this._goodsNumInfoBg)
         {
            ObjectUtils.disposeObject(this._goodsNumInfoBg);
         }
         this._goodsNumInfoBg = null;
         if(this._goodsNumInfoText)
         {
            ObjectUtils.disposeObject(this._goodsNumInfoText);
         }
         this._goodsNumInfoText = null;
         if(this._goodsNumTotalText)
         {
            ObjectUtils.disposeObject(this._goodsNumTotalText);
         }
         this._goodsNumTotalText = null;
         if(this._bg)
         {
            ObjectUtils.disposeObject(this._bg);
         }
         this._bg = null;
         if(this._bg1)
         {
            ObjectUtils.disposeObject(this._bg1);
         }
         this._bg1 = null;
         if(this._sortBagBtn)
         {
            ObjectUtils.disposeObject(this._sortBagBtn);
         }
         this._sortBagBtn = null;
         if(this._settingLockBtn)
         {
            ObjectUtils.disposeObject(this._settingLockBtn);
         }
         this._settingLockBtn = null;
         if(this._settedLockBtn)
         {
            ObjectUtils.disposeObject(this._settedLockBtn);
         }
         this._settedLockBtn = null;
         if(this._breakBtn)
         {
            ObjectUtils.disposeObject(this._breakBtn);
         }
         this._breakBtn = null;
         this._currentList = null;
         if(this._sellBtn)
         {
            ObjectUtils.disposeObject(this._sellBtn);
         }
         this._sellBtn = null;
         this._equiplist = null;
         this._equiplist1 = null;
         this._equiplist2 = null;
         if(this._bgShape)
         {
            ObjectUtils.disposeObject(this._bgShape);
         }
         this._bgShape = null;
         if(this._continueBtn)
         {
            ObjectUtils.disposeObject(this._continueBtn);
         }
         this._continueBtn = null;
         if(this._chatBugleInputFrame)
         {
            ObjectUtils.disposeObject(this._chatBugleInputFrame);
         }
         this._chatBugleInputFrame = null;
         if(this._bagList)
         {
            ObjectUtils.disposeObject(this._bagList);
         }
         this._bagList = null;
         if(this._PageBtnGroup)
         {
            ObjectUtils.disposeObject(this._PageBtnGroup);
         }
         this._PageBtnGroup = null;
         if(this._onePageBtn)
         {
            ObjectUtils.disposeObject(this._onePageBtn);
         }
         this._onePageBtn = null;
         if(this._TwoPageBtn)
         {
            ObjectUtils.disposeObject(this._TwoPageBtn);
         }
         this._TwoPageBtn = null;
         if(this._ThreePageBtn)
         {
            ObjectUtils.disposeObject(this._ThreePageBtn);
         }
         this._ThreePageBtn = null;
         if(this._ClassBtnGroup)
         {
            ObjectUtils.disposeObject(this._ClassBtnGroup);
         }
         this._ClassBtnGroup = null;
         if(this._allClassBtn)
         {
            this._allClassBtn.removeEventListener(MouseEvent.CLICK,this.__soundPlay);
            ObjectUtils.disposeObject(this._allClassBtn);
            this._allClassBtn = null;
         }
         if(this._equipClassBtn)
         {
            this._equipClassBtn.removeEventListener(MouseEvent.CLICK,this.__soundPlay);
            ObjectUtils.disposeObject(this._equipClassBtn);
            this._equipClassBtn = null;
         }
         if(this._fashionClassBtn)
         {
            this._fashionClassBtn.removeEventListener(MouseEvent.CLICK,this.__soundPlay);
            ObjectUtils.disposeObject(this._fashionClassBtn);
            this._fashionClassBtn = null;
         }
         if(this._propClassBtn)
         {
            this._propClassBtn.removeEventListener(MouseEvent.CLICK,this.__soundPlay);
            ObjectUtils.disposeObject(this._propClassBtn);
            this._propClassBtn = null;
         }
         if(this._questClassBtn)
         {
            this._questClassBtn.removeEventListener(MouseEvent.CLICK,this.__soundPlay);
            ObjectUtils.disposeObject(this._questClassBtn);
            this._questClassBtn = null;
         }
         if(this._reworknameView)
         {
            this.shutdownReworkName();
         }
         if(this._consortaiReworkName)
         {
            this.shutdownConsortiaReworkName();
         }
         if(CellMenu.instance.showed)
         {
            CellMenu.instance.hide();
         }
         if(this._moneyView)
         {
            ObjectUtils.disposeObject(this._moneyView);
            this._moneyView = null;
         }
         if(this._ddtmoneyView)
         {
            ObjectUtils.disposeObject(this._ddtmoneyView);
            this._ddtmoneyView = null;
         }
         if(this._goldView)
         {
            ObjectUtils.disposeObject(this._goldView);
            this._goldView = null;
         }
         AddPricePanel.Instance.close();
         PlayerManager.Instance.Self.bagVibleType = 0;
         if(parent)
         {
            parent.removeChild(this);
         }
      }
      
      public function setBagCountShow(param1:int) : void
      {
         var _loc2_:int = 0;
         var _loc3_:GlowFilter = null;
         var _loc4_:uint = 0;
         switch(param1)
         {
            case BagInfo.EQUIPBAG:
               _loc2_ = PlayerManager.Instance.Self.getBag(param1).itemBgNumber(this._equiplist._startIndex,this._equiplist._stopIndex);
               if(_loc2_ >= 49)
               {
                  _loc4_ = 16711680;
                  _loc3_ = new GlowFilter(16777215,0.5,3,3,10);
               }
               else
               {
                  _loc4_ = 1310468;
                  _loc3_ = new GlowFilter(876032,0.5,3,3,10);
               }
               break;
            case BagInfo.PROPBAG:
               _loc2_ = PlayerManager.Instance.Self.getBag(param1).itemBgNumber(0,BagInfo.MAXPROPCOUNT);
               if(_loc2_ >= BagInfo.MAXPROPCOUNT + 1)
               {
                  _loc4_ = 16711680;
                  _loc3_ = new GlowFilter(16777215,0.5,3,3,10);
               }
               else
               {
                  _loc4_ = 1310468;
                  _loc3_ = new GlowFilter(876032,0.5,3,3,10);
               }
         }
         this._goodsNumInfoText.textColor = _loc4_;
         this._goodsNumInfoText.text = _loc2_.toString();
         this.setBagType(param1);
      }
      
      public function get info() : SelfInfo
      {
         return this._info;
      }
      
      public function set info(param1:SelfInfo) : void
      {
         if(this._info)
         {
            this._info.removeEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,this.__propertyChange);
            this._info.getBag(BagInfo.EQUIPBAG).removeEventListener(BagEvent.UPDATE,this.__onBagUpdateEQUIPBAG);
            PlayerManager.Instance.Self.removeEventListener(BagEvent.CLEAR,this.__clearHandler);
            PlayerManager.Instance.Self.removeEventListener(BagEvent.AFTERDEL,this.__clearHandler);
            PlayerManager.Instance.Self.removeEventListener(BagEvent.CHANGEPSW,this.__clearHandler);
            PlayerManager.Instance.Self.removeEventListener(BagEvent.SHOW_BEAD,this.__showBead);
         }
         this._info = param1;
         if(this._info)
         {
            this._info.addEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,this.__propertyChange);
            this._info.getBag(BagInfo.EQUIPBAG).addEventListener(BagEvent.UPDATE,this.__onBagUpdateEQUIPBAG);
            PlayerManager.Instance.Self.addEventListener(BagEvent.CLEAR,this.__clearHandler);
            PlayerManager.Instance.Self.addEventListener(BagEvent.AFTERDEL,this.__clearHandler);
            PlayerManager.Instance.Self.addEventListener(BagEvent.CHANGEPSW,this.__clearHandler);
            PlayerManager.Instance.Self.addEventListener(BagEvent.SHOW_BEAD,this.__showBead);
         }
         this.updateView();
         if(this._bagType == EQUIP)
         {
            this.initEquipBagPage();
         }
      }
      
      private function startReworkName(param1:int, param2:int) : void
      {
         this._reworknameView = ComponentFactory.Instance.creatComponentByStylename("bagAndInfo.ReworkName.ReworkNameFrame");
         LayerManager.Instance.addToLayer(this._reworknameView,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
         this._reworknameView.initialize(param1,param2);
         this._reworknameView.addEventListener(Event.COMPLETE,this.__onRenameComplete);
      }
      
      private function shutdownReworkName() : void
      {
         this._reworknameView.removeEventListener(Event.COMPLETE,this.__onRenameComplete);
         ObjectUtils.disposeObject(this._reworknameView);
         this._reworknameView = null;
      }
      
      private function __onRenameComplete(param1:Event) : void
      {
         this.shutdownReworkName();
      }
      
      private function startupConsortiaReworkName(param1:int, param2:int) : void
      {
         this._consortaiReworkName = ComponentFactory.Instance.creatComponentByStylename("bagAndInfo.ReworkName.ReworkNameConsortia");
         LayerManager.Instance.addToLayer(this._consortaiReworkName,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
         this._consortaiReworkName.initialize(param1,param2);
         this._consortaiReworkName.addEventListener(Event.COMPLETE,this.__onConsortiaRenameComplete);
      }
      
      private function shutdownConsortiaReworkName() : void
      {
         this._consortaiReworkName.removeEventListener(Event.COMPLETE,this.__onConsortiaRenameComplete);
         ObjectUtils.disposeObject(this._consortaiReworkName);
         this._consortaiReworkName = null;
      }
      
      private function showChatBugleInputFrame(param1:int) : void
      {
         if(this._chatBugleInputFrame == null)
         {
            this._chatBugleInputFrame = ComponentFactory.Instance.creat("chat.BugleInputFrame");
         }
         this._chatBugleInputFrame.templateID = param1;
         LayerManager.Instance.addToLayer(this._chatBugleInputFrame,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.ALPHA_BLOCKGOUND);
      }
      
      private function __onConsortiaRenameComplete(param1:Event) : void
      {
         this.shutdownConsortiaReworkName();
      }
      
      public function hide() : void
      {
         if(this._reworknameView)
         {
            this.shutdownReworkName();
         }
         if(this._consortaiReworkName)
         {
            this.shutdownConsortiaReworkName();
         }
      }
      
      private function startupChangeSex(param1:int, param2:int) : void
      {
         var _loc3_:ChangeSexAlertFrame = ComponentFactory.Instance.creat("bagAndInfo.bag.changeSexAlert");
         _loc3_.bagType = param1;
         _loc3_.place = param2;
         _loc3_.info = this.getAlertInfo("tank.view.bagII.changeSexAlert",true);
         _loc3_.addEventListener(ComponentEvent.PROPERTIES_CHANGED,this.__onAlertSizeChanged);
         _loc3_.addEventListener(FrameEvent.RESPONSE,this.__onAlertResponse);
         LayerManager.Instance.addToLayer(_loc3_,LayerManager.GAME_DYNAMIC_LAYER,_loc3_.info.frameCenter,LayerManager.BLCAK_BLOCKGOUND);
         StageReferance.stage.focus = _loc3_;
      }
      
      private function getAlertInfo(param1:String, param2:Boolean = false) : AlertInfo
      {
         var _loc3_:AlertInfo = new AlertInfo();
         _loc3_.autoDispose = true;
         _loc3_.showSubmit = true;
         _loc3_.showCancel = param2;
         _loc3_.enterEnable = true;
         _loc3_.escEnable = true;
         _loc3_.moveEnable = false;
         _loc3_.title = LanguageMgr.GetTranslation("AlertDialog.Info");
         _loc3_.data = LanguageMgr.GetTranslation(param1);
         return _loc3_;
      }
      
      private function __onAlertSizeChanged(param1:ComponentEvent) : void
      {
         var _loc2_:BaseAlerFrame = param1.currentTarget as BaseAlerFrame;
         if(_loc2_.info.frameCenter)
         {
            _loc2_.x = (StageReferance.stageWidth - _loc2_.width) / 2;
            _loc2_.y = (StageReferance.stageHeight - _loc2_.height) / 2;
         }
      }
      
      private function __onAlertResponse(param1:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         var _loc2_:ChangeSexAlertFrame = ChangeSexAlertFrame(param1.currentTarget);
         _loc2_.removeEventListener(ComponentEvent.PROPERTIES_CHANGED,this.__onAlertSizeChanged);
         _loc2_.removeEventListener(FrameEvent.RESPONSE,this.__onAlertResponse);
         switch(param1.responseCode)
         {
            case FrameEvent.ENTER_CLICK:
            case FrameEvent.SUBMIT_CLICK:
               SocketManager.Instance.out.sendChangeSex(_loc2_.bagType,_loc2_.place);
         }
         _loc2_.dispose();
         _loc2_ = null;
      }
      
      private function __changeSexHandler(param1:CrazyTankSocketEvent) : void
      {
         var _loc3_:SimpleAlert = null;
         SocketManager.Instance.socket.close();
         var _loc2_:Boolean = param1.pkg.readBoolean();
         if(_loc2_)
         {
            _loc3_ = ComponentFactory.Instance.creat("sellGoodsAlert");
            _loc3_.info = this.getAlertInfo("tank.view.bagII.changeSexAlert.success",false);
            _loc3_.addEventListener(ComponentEvent.PROPERTIES_CHANGED,this.__onAlertSizeChanged);
            _loc3_.addEventListener(FrameEvent.RESPONSE,this.__onSuccessAlertResponse);
            LayerManager.Instance.addToLayer(_loc3_,LayerManager.GAME_DYNAMIC_LAYER,_loc3_.info.frameCenter,LayerManager.BLCAK_BLOCKGOUND);
            StageReferance.stage.focus = _loc3_;
         }
         else
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.view.bagII.changeSexAlert.failed"));
         }
      }
      
      private function __onSuccessAlertResponse(param1:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         ExternalInterface.call("WindowReturn");
      }
      
      public function set isScreenTexp(param1:Boolean) : void
      {
         this._isScreenTexp = param1;
      }
      
      public function get isScreenTexp() : Boolean
      {
         return this._isScreenTexp;
      }
      
      public function get currentPage() : int
      {
         return this._currentPage;
      }
      
      public function set GoodList(param1:BagInfo) : void
      {
      }
      
      public function set currentPage(param1:int) : void
      {
         this._currentPage = param1;
         this._equipBag = this.getEquipList(this._info.Bag,PlayerManager.Instance.Self.bagVibleType);
         switch(this._currentPage)
         {
            case 1:
               this._equiplist.setData(this._equipBag);
               break;
            case 2:
               this._equiplist1.setData(this._equipBag);
               break;
            case 3:
               this._equiplist2.setData(this._equipBag);
         }
      }
   }
}
