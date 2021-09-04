package bead
{
   import bead.events.BeadEvent;
   import bead.model.BeadConfig;
   import bead.view.BeadCombineConfirmFrame;
   import bead.view.BeadOpenCellTipPanel;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.events.UIModuleEvent;
   import com.pickgliss.loader.UIModuleLoader;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.command.QuickBuyFrame;
   import ddt.data.BagInfo;
   import ddt.data.EquipType;
   import ddt.data.ShopType;
   import ddt.data.UIModuleTypes;
   import ddt.data.VipConfigInfo;
   import ddt.data.analyze.BeadDataAnalyzer;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.data.goods.ShopItemInfo;
   import ddt.events.BagEvent;
   import ddt.events.PlayerPropertyEvent;
   import ddt.manager.LanguageMgr;
   import ddt.manager.PlayerManager;
   import ddt.manager.ShopManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.manager.VipPrivilegeConfigManager;
   import ddt.view.UIModuleSmallLoading;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   
   public class BeadManager extends EventDispatcher
   {
      
      public static const BEAD_OPEN_GUIDE_EVNET:String = "bead_open_guide_event";
      
      public static const BEAD_COMBINE_CONFIRM_RETURN_EVENT:String = "bead_combine_confirm_return_event";
      
      private static var _instance:BeadManager;
       
      
      public var doWhatHandle:int = -1;
      
      public var beadConfig:BeadConfig;
      
      private var _list:Object;
      
      private var _scoreShopItemList:Array;
      
      private var _func:Function;
      
      private var _funcParams:Array;
      
      private var _beadBag:BagInfo;
      
      private var _isCanGuide:Boolean = false;
      
      private var _curLevel:int = 100;
      
      private var _curPlace:int = -1;
      
      public var guildeStepI:Boolean;
      
      private var _combineLowList:Array;
      
      private var _combineConfirmReFuc:Function;
      
      public var _confirmFrameList:Vector.<BeadCombineConfirmFrame>;
      
      public var _combinePlaceList:Array;
      
      public var _isCombineOneKey:Boolean;
      
      public var comineCount:int;
      
      private var _goldAlertFrame:BaseAlerFrame;
      
      public function BeadManager()
      {
         super();
      }
      
      public static function get instance() : BeadManager
      {
         if(_instance == null)
         {
            _instance = new BeadManager();
         }
         return _instance;
      }
      
      public function get beadBag() : BagInfo
      {
         return this._beadBag;
      }
      
      public function get curPlace() : int
      {
         return this._curPlace;
      }
      
      public function preJudgeLevelUp(param1:int, param2:int) : void
      {
         this._curPlace = param1;
         this._curLevel = param2;
      }
      
      public function recordCombineOnekey() : void
      {
         this.preJudgeLevelUp(12,(this._beadBag.items[12] as InventoryItemInfo).beadLevel);
      }
      
      public function doJudgeLevelUp() : Boolean
      {
         if(this.doWhatHandle == 1 || this.doWhatHandle == 2)
         {
            if(this._curPlace != -1 && this._curPlace != 100 && this._curLevel != -1)
            {
               if((this._beadBag.items[this._curPlace] as InventoryItemInfo).beadLevel > this._curLevel)
               {
                  return true;
               }
            }
         }
         return false;
      }
      
      public function get isCanGuide() : Boolean
      {
         return this._isCanGuide;
      }
      
      public function get list() : Object
      {
         return this._list;
      }
      
      public function get scoreShopItemList() : Array
      {
         return this._scoreShopItemList;
      }
      
      public function calExpLimit(param1:InventoryItemInfo) : Array
      {
         var _loc2_:Object = BeadManager.instance.list;
         if(!_loc2_)
         {
            return [0,0];
         }
         param1.beadLevel = param1.beadLevel == 0 ? int(1) : int(param1.beadLevel);
         var _loc3_:int = param1.beadLevel == 30 ? int(29) : int(param1.beadLevel);
         var _loc4_:int = int(_loc2_[param1.Property2][_loc3_.toString()].Exp);
         var _loc5_:int = int(_loc2_[param1.Property2][(_loc3_ + 1).toString()].Exp);
         if(param1.beadLevel == 30)
         {
            return [_loc5_ - _loc4_,_loc5_ - _loc4_];
         }
         return [param1.beadExp - _loc4_,_loc5_ - _loc4_];
      }
      
      public function loadBeadModule(param1:Function = null, param2:Array = null) : void
      {
         this._func = param1;
         this._funcParams = param2;
         UIModuleSmallLoading.Instance.progress = 0;
         UIModuleSmallLoading.Instance.show();
         UIModuleSmallLoading.Instance.addEventListener(Event.CLOSE,this.__onClose);
         UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.loadCompleteHandler);
         UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.onUimoduleLoadProgress);
         UIModuleLoader.Instance.addUIModuleImp(UIModuleTypes.DDTBEAD);
      }
      
      private function __onClose(param1:Event) : void
      {
         UIModuleSmallLoading.Instance.hide();
         UIModuleSmallLoading.Instance.removeEventListener(Event.CLOSE,this.__onClose);
         UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.onUimoduleLoadProgress);
         UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.loadCompleteHandler);
      }
      
      private function onUimoduleLoadProgress(param1:UIModuleEvent) : void
      {
         if(param1.module == UIModuleTypes.DDTBEAD)
         {
            UIModuleSmallLoading.Instance.progress = param1.loader.progress * 100;
         }
      }
      
      private function loadCompleteHandler(param1:UIModuleEvent) : void
      {
         if(param1.module == UIModuleTypes.DDTBEAD)
         {
            UIModuleSmallLoading.Instance.hide();
            UIModuleSmallLoading.Instance.removeEventListener(Event.CLOSE,this.__onClose);
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.loadCompleteHandler);
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.onUimoduleLoadProgress);
            if(null != this._func)
            {
               this._func.apply(null,this._funcParams);
            }
            this._func = null;
            this._funcParams = null;
         }
      }
      
      public function setup() : void
      {
         this._beadBag = PlayerManager.Instance.Self.getBag(BagInfo.BEADBAG);
         this._beadBag.addEventListener(BagEvent.UPDATE,this.bagUpdateHandler,false,0,true);
         PlayerManager.Instance.Self.addEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,this.__onChange);
         this.setupBeadScoreShop();
      }
      
      private function setupBeadScoreShop() : void
      {
         var _loc4_:ShopItemInfo = null;
         var _loc5_:Object = null;
         var _loc1_:Vector.<ShopItemInfo> = ShopManager.Instance.getGoodsByType(ShopType.BEAD_GOODS_TYPE);
         this._scoreShopItemList = [];
         if(_loc1_ == null)
         {
            return;
         }
         var _loc2_:int = _loc1_.length;
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_)
         {
            _loc4_ = ShopManager.Instance.getShopItemByGoodsID(_loc1_[_loc3_].GoodsID);
            _loc5_ = {};
            _loc5_.id = _loc4_.TemplateID;
            _loc5_.score = _loc4_.AValue1;
            _loc5_.pos = _loc3_ + 1;
            this._scoreShopItemList.push(_loc5_);
            _loc3_++;
         }
      }
      
      private function bagUpdateHandler(param1:BagEvent) : void
      {
         if(this.getBeadTempBagBeadCount() >= 1)
         {
            this._isCanGuide = true;
         }
      }
      
      private function getBeadTempBagBeadCount() : int
      {
         var _loc1_:int = 0;
         var _loc2_:int = 13;
         while(_loc2_ <= 27)
         {
            if(this._beadBag.items[_loc2_])
            {
               _loc1_++;
            }
            _loc2_++;
         }
         return _loc1_;
      }
      
      public function getConfigData(param1:BeadDataAnalyzer) : void
      {
         this._list = param1.list;
         this.beadConfig = param1.beadConfig;
      }
      
      public function getBeadColorName(param1:InventoryItemInfo, param2:Boolean = true, param3:Boolean = false, param4:String = "") : String
      {
         var _loc5_:String = null;
         var _loc6_:String = null;
         if(param3)
         {
            _loc5_ = this.getBeadNameColor2(param1);
         }
         else
         {
            _loc5_ = this.getBeadNameColor(param1);
         }
         if(param2)
         {
            _loc6_ = LanguageMgr.GetTranslation("beadSystem.bead.nameLevel",param1.Name,param1.beadLevel,param4);
         }
         else
         {
            _loc6_ = param1.Name;
         }
         if(param3)
         {
            _loc6_ = LanguageMgr.GetTranslation("beadSystem.bead.name.bold.html",_loc6_);
         }
         return LanguageMgr.GetTranslation("beadSystem.bead.name.color.html",_loc5_,_loc6_);
      }
      
      public function getBeadNameColor(param1:InventoryItemInfo) : String
      {
         var _loc2_:int = int(param1.Property2);
         var _loc3_:String = "#fffcd1";
         switch(_loc2_)
         {
            case 0:
               _loc3_ = "#ffff01";
               break;
            case 1:
            case 2:
               _loc3_ = "#C4E5FF";
               break;
            case 3:
            case 4:
               _loc3_ = "#2CFD2C";
               break;
            case 5:
            case 6:
               _loc3_ = "#00FCFF";
               break;
            case 7:
            case 8:
               _loc3_ = "#CC55F1";
               break;
            case 9:
            case 10:
               _loc3_ = "#DC2DCA";
               break;
            default:
               _loc3_ = "#fffcd1";
         }
         return _loc3_;
      }
      
      public function getBeadNameColor2(param1:InventoryItemInfo) : String
      {
         var _loc2_:int = int(param1.Property2);
         var _loc3_:String = "#fffcd1";
         switch(_loc2_)
         {
            case 0:
               _loc3_ = "#ff8400";
               break;
            case 1:
            case 2:
               _loc3_ = "#7aa7bc";
               break;
            case 3:
            case 4:
               _loc3_ = "#36d51c";
               break;
            case 5:
            case 6:
               _loc3_ = "#3e98dd";
               break;
            case 7:
            case 8:
               _loc3_ = "#CC55F1";
               break;
            case 9:
            case 10:
               _loc3_ = "#DC2DCA";
               break;
            default:
               _loc3_ = "#7aa7bc";
         }
         return _loc3_;
      }
      
      public function getDescriptionStr(param1:InventoryItemInfo) : String
      {
         var _loc2_:String = this.getBeadNameColor(param1);
         var _loc3_:int = int(param1.Property3);
         var _loc4_:int = this.calVaule(param1);
         var _loc5_:Array = LanguageMgr.GetTranslation("beadSystem.bead.nameStr").split(",");
         return LanguageMgr.GetTranslation("beadSystem.bead.desc.tip",_loc2_,_loc5_[_loc3_],_loc4_);
      }
      
      public function getNextDescriptionStr(param1:InventoryItemInfo) : String
      {
         var _loc2_:InventoryItemInfo = new InventoryItemInfo();
         ObjectUtils.copyProperties(_loc2_,param1);
         _loc2_.beadLevel = param1.beadLevel + 1;
         var _loc3_:String = this.getBeadNameColor(_loc2_);
         var _loc4_:int = int(_loc2_.Property3);
         var _loc5_:int = this.calVaule(_loc2_);
         var _loc6_:Array = LanguageMgr.GetTranslation("beadSystem.bead.nameStr").split(",");
         return LanguageMgr.GetTranslation("beadSystem.bead.desc.tip",_loc3_,_loc6_[_loc4_],_loc5_);
      }
      
      public function calVaule(param1:InventoryItemInfo) : int
      {
         var _loc2_:Object = null;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         if(int(param1.Property2) == 0)
         {
            return int(param1.Property5);
         }
         if(this.list)
         {
            param1.beadLevel = param1.beadLevel == 0 ? int(1) : int(param1.beadLevel);
            _loc2_ = this.list[param1.Property2][param1.beadLevel.toString()];
            _loc3_ = int(param1.Property3);
            _loc4_ = 0;
            switch(_loc3_)
            {
               case 1:
                  _loc4_ = _loc2_.Attack;
                  break;
               case 2:
                  _loc4_ = _loc2_.Defence;
                  break;
               case 3:
                  _loc4_ = _loc2_.Agility;
                  break;
               case 4:
                  _loc4_ = _loc2_.Lucky;
                  break;
               case 5:
                  _loc4_ = _loc2_.RootBone;
                  break;
               default:
                  _loc4_ = 0;
            }
            return _loc4_;
         }
         return 0;
      }
      
      public function combineConfirm(param1:int, param2:Function) : void
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:InventoryItemInfo = null;
         var _loc7_:int = 0;
         var _loc8_:BeadCombineConfirmFrame = null;
         this.comineCount = 0;
         if(param1 == -1)
         {
            _loc3_ = 13;
            _loc4_ = 27;
            this._isCombineOneKey = true;
         }
         else
         {
            _loc3_ = param1;
            _loc4_ = param1;
            this._isCombineOneKey = false;
         }
         this._combineConfirmReFuc = param2;
         this._confirmFrameList = new Vector.<BeadCombineConfirmFrame>();
         this._combinePlaceList = [];
         this._combineLowList = [];
         if(this._isCombineOneKey)
         {
            _loc5_ = _loc4_;
            while(_loc5_ >= _loc3_)
            {
               _loc6_ = this._beadBag.items[_loc5_] as InventoryItemInfo;
               if(_loc6_ && _loc6_.beadIsLock == 0)
               {
                  if(int(_loc6_.Property2) >= 5 || _loc6_.beadLevel >= 15)
                  {
                     _loc7_ = BeadManager.instance.list[_loc6_.Property2][_loc6_.beadLevel.toString()].SellScore;
                     _loc8_ = ComponentFactory.Instance.creatCustomObject("beadCombineConfirmFrame");
                     _loc8_.show(LanguageMgr.GetTranslation("beadSystem.bead.combineConfirm.tip",this.getBeadColorName(_loc6_,true,true),this.calRequireExp(_loc6_),_loc7_ < 0 ? 0 : _loc7_),_loc5_);
                     _loc8_.addEventListener(BEAD_COMBINE_CONFIRM_RETURN_EVENT,this.combineConfirmReturnHandler);
                     this._confirmFrameList.push(_loc8_);
                     dispatchEvent(new BeadEvent(BeadEvent.SHOW_ConfirmFrme));
                  }
                  else if(_loc6_.beadLevel != 20)
                  {
                     this._combinePlaceList.push(_loc5_);
                  }
               }
               _loc5_--;
            }
         }
         if(this._confirmFrameList.length == 0 && this._combineConfirmReFuc != null)
         {
            this.comineCount = 1;
            this._combineConfirmReFuc.apply();
            this._combineConfirmReFuc = null;
         }
      }
      
      private function combineConfirmReturnHandler(param1:Event) : void
      {
         var _loc3_:int = 0;
         var _loc2_:BeadCombineConfirmFrame = param1.currentTarget as BeadCombineConfirmFrame;
         _loc2_.removeEventListener(BEAD_COMBINE_CONFIRM_RETURN_EVENT,this.combineConfirmReturnHandler);
         if(!this._isCombineOneKey)
         {
            if(_loc2_.isYes)
            {
               if(this._combineConfirmReFuc != null)
               {
                  this._combineConfirmReFuc.apply();
                  this._combineConfirmReFuc = null;
               }
            }
         }
         else
         {
            if(_loc2_.isYes)
            {
               this._combinePlaceList.push(_loc2_.place);
            }
            else
            {
               dispatchEvent(new BeadEvent(BeadEvent.BEAD_LOCK,_loc2_.place));
            }
            this._confirmFrameList.pop();
            if(this._confirmFrameList.length <= 0)
            {
               _loc3_ = 0;
               while(_loc3_ < this._combinePlaceList.length)
               {
                  SocketManager.Instance.out.sendBeadCombine(12,this._combinePlaceList[_loc3_],0);
                  _loc3_++;
               }
               if(this._combineConfirmReFuc != null && this._combinePlaceList.length != 0)
               {
                  this._combineConfirmReFuc.apply();
                  this.comineCount = this._combinePlaceList.length;
                  this._combineConfirmReFuc = null;
               }
            }
         }
      }
      
      private function __onChange(param1:PlayerPropertyEvent) : void
      {
         if(param1.changedProperties["Grade"] && PlayerManager.Instance.Self.onLevelUp && PlayerManager.Instance.Self.Grade % 10 == 0)
         {
            this.showBeadOpenCellTipPanel();
         }
      }
      
      public function showBeadOpenCellTipPanel() : void
      {
         var _loc1_:BeadOpenCellTipPanel = ComponentFactory.Instance.creatCustomObject("bead.openBeadCellTipPanel");
         _loc1_.show();
      }
      
      public function buyGoldFrame() : void
      {
         if(this._goldAlertFrame == null)
         {
            this._goldAlertFrame = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("tank.view.GoldInadequate"),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),false,false,false,LayerManager.BLCAK_BLOCKGOUND);
            this._goldAlertFrame.moveEnable = false;
            this._goldAlertFrame.addEventListener(FrameEvent.RESPONSE,this.__quickBuyResponse);
         }
      }
      
      private function __quickBuyResponse(param1:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         this._goldAlertFrame.removeEventListener(FrameEvent.RESPONSE,this.__quickBuyResponse);
         this._goldAlertFrame.dispose();
         this._goldAlertFrame = null;
         if(param1.responseCode == FrameEvent.SUBMIT_CLICK || param1.responseCode == FrameEvent.ENTER_CLICK)
         {
            this.openGoldFrame();
         }
      }
      
      public function openGoldFrame() : void
      {
         var _loc1_:QuickBuyFrame = ComponentFactory.Instance.creatComponentByStylename("ddtcore.QuickFrame");
         _loc1_.itemID = EquipType.GOLD_BOX;
         _loc1_.setTitleText(LanguageMgr.GetTranslation("tank.view.store.matte.goldQuickBuy"));
         LayerManager.Instance.addToLayer(_loc1_,LayerManager.GAME_TOP_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
      }
      
      public function canVIPOpen(param1:int) : Boolean
      {
         var _loc2_:VipConfigInfo = VipPrivilegeConfigManager.Instance.getById(param1);
         var _loc3_:int = int(_loc2_["Level" + PlayerManager.Instance.Self.VIPLevel]);
         return _loc3_ > 0 ? Boolean(true) : Boolean(false);
      }
      
      public function needVIPLevel(param1:int) : int
      {
         var _loc2_:int = 0;
         var _loc4_:int = 0;
         var _loc3_:VipConfigInfo = VipPrivilegeConfigManager.Instance.getById(param1);
         _loc2_ = 1;
         while(_loc2_ < 10)
         {
            _loc4_ = int(_loc3_["Level" + _loc2_]);
            if(_loc4_ > 0)
            {
               break;
            }
            _loc2_++;
         }
         return _loc2_;
      }
      
      public function calRequireExp(param1:InventoryItemInfo) : int
      {
         return param1.beadExp + int(param1.Property4);
      }
   }
}
