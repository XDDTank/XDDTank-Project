package mainbutton
{
   import activity.ActivityController;
   import com.pickgliss.events.UIModuleEvent;
   import com.pickgliss.loader.UIModuleLoader;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import ddt.data.BuffInfo;
   import ddt.data.UIModuleTypes;
   import ddt.manager.PlayerManager;
   import ddt.manager.ServerConfigManager;
   import ddt.view.UIModuleSmallLoading;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import mainbutton.data.MainButtonManager;
   
   public class MainButtnController extends EventDispatcher
   {
      
      private static var _instance:MainButtnController;
      
      public static var useFirst:Boolean = true;
      
      public static var loadComplete:Boolean = false;
      
      public static var ACTIVITIES:String = "1";
      
      public static var ROULETTE:String = "2";
      
      public static var VIP:String = "3";
      
      public static var SIGN:String = "5";
      
      public static var AWARD:String = "6";
      
      public static var ANGELBLESS:String = "7";
      
      public static var FIGHTTOOLBOX:String = "8";
      
      public static var PACKAGEPURCHAESBOX:String = "9";
      
      public static var ONLINE_AWEAD:String = "10";
      
      public static var FIRTST_CHARGE:String = "12";
      
      public static var WEEKEND:String = "13";
      
      public static var TURN_PLATE:String = "14";
      
      public static var FIGHT_ROBOT:String = "15";
      
      public static var DEAILY_RECEIVE:String = "16";
      
      public static var DDT_ACTIVITY:String = "ddtactivity";
      
      public static var DDT_AWARD:String = "ddtaward";
      
      public static var ICONCLOSE:String = "iconClose";
      
      public static var CLOSESIGN:String = "closeSign";
      
      public static var ICONOPEN:String = "iconOpen";
       
      
      public var btnList:Vector.<MainButton>;
      
      private var _currntType:String;
      
      private var _awardFrame:AwardFrame;
      
      private var _dailAwardState:Boolean;
      
      private var _vipAwardState:Boolean;
      
      public function MainButtnController()
      {
         super();
      }
      
      public static function get instance() : MainButtnController
      {
         if(!_instance)
         {
            _instance = new MainButtnController();
         }
         return _instance;
      }
      
      public function show(param1:String) : void
      {
         this._currntType = param1;
         if(loadComplete)
         {
            this.showFrame(this._currntType);
         }
         else if(useFirst)
         {
            UIModuleSmallLoading.Instance.progress = 0;
            UIModuleSmallLoading.Instance.show();
            UIModuleSmallLoading.Instance.addEventListener(Event.CLOSE,this.__onClose);
            UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.__progressShow);
            UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.__complainShow);
            UIModuleLoader.Instance.addUIModuleImp(UIModuleTypes.DDTMAINBTN);
            useFirst = false;
         }
      }
      
      private function showFrame(param1:String) : void
      {
         switch(param1)
         {
            case MainButtnController.DDT_AWARD:
               this._awardFrame = ComponentFactory.Instance.creatCustomObject("ddtmainbutton.AwardFrame");
               LayerManager.Instance.addToLayer(this._awardFrame,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
         }
      }
      
      private function __onClose(param1:Event) : void
      {
         UIModuleSmallLoading.Instance.hide();
         UIModuleSmallLoading.Instance.removeEventListener(Event.CLOSE,this.__onClose);
         UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.__progressShow);
         UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.__complainShow);
      }
      
      private function __progressShow(param1:UIModuleEvent) : void
      {
         if(param1.module == UIModuleTypes.DDTMAINBTN)
         {
            UIModuleSmallLoading.Instance.progress = param1.loader.progress * 100;
         }
      }
      
      private function __complainShow(param1:UIModuleEvent) : void
      {
         if(param1.module == UIModuleTypes.DDTMAINBTN)
         {
            UIModuleSmallLoading.Instance.removeEventListener(Event.CLOSE,this.__onClose);
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.__progressShow);
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.__complainShow);
            UIModuleSmallLoading.Instance.hide();
            loadComplete = true;
            this.showFrame(this._currntType);
         }
      }
      
      public function set DailyAwardState(param1:Boolean) : void
      {
         this._dailAwardState = param1;
      }
      
      public function get DailyAwardState() : Boolean
      {
         return this._dailAwardState;
      }
      
      public function set VipAwardState(param1:Boolean) : void
      {
         this._vipAwardState = param1;
      }
      
      public function get VipAwardState() : Boolean
      {
         return this._vipAwardState;
      }
      
      public function test() : Vector.<MainButton>
      {
         this.btnList = new Vector.<MainButton>();
         var _loc1_:MainButton = MainButtonManager.instance.getInfoByID(ACTIVITIES);
         var _loc2_:MainButton = MainButtonManager.instance.getInfoByID(ROULETTE);
         var _loc3_:MainButton = MainButtonManager.instance.getInfoByID(VIP);
         var _loc4_:MainButton = MainButtonManager.instance.getInfoByID(SIGN);
         var _loc5_:MainButton = MainButtonManager.instance.getInfoByID(AWARD);
         var _loc6_:MainButton = MainButtonManager.instance.getInfoByID(ANGELBLESS);
         var _loc7_:MainButton = MainButtonManager.instance.getInfoByID(FIGHTTOOLBOX);
         var _loc8_:MainButton = MainButtonManager.instance.getInfoByID(PACKAGEPURCHAESBOX);
         var _loc9_:MainButton = MainButtonManager.instance.getInfoByID(VIP);
         var _loc10_:MainButton = MainButtonManager.instance.getInfoByID(FIRTST_CHARGE);
         var _loc11_:MainButton = MainButtonManager.instance.getInfoByID(WEEKEND);
         var _loc12_:MainButton = MainButtonManager.instance.getInfoByID(TURN_PLATE);
         var _loc13_:MainButton = MainButtonManager.instance.getInfoByID(FIGHT_ROBOT);
         var _loc14_:MainButton = MainButtonManager.instance.getInfoByID(DEAILY_RECEIVE);
         if(PlayerManager.Instance.Self.Grade >= 13)
         {
            _loc4_.btnMark = 5;
            _loc4_.btnServerVisable = 1;
            _loc4_.btnCompleteVisable = 1;
            this.btnList.push(_loc4_);
         }
         if(ActivityController.instance.checkHasFirstCharge() != null)
         {
            _loc10_.btnMark = 12;
            _loc10_.btnServerVisable = 1;
            _loc10_.btnCompleteVisable = 1;
            this.btnList.push(_loc10_);
         }
         if(_loc1_.IsShow)
         {
            _loc1_.btnMark = 1;
            _loc1_.btnServerVisable = 1;
            _loc1_.btnCompleteVisable = 1;
            this.btnList.push(_loc1_);
         }
         else
         {
            _loc1_.btnMark = 1;
            _loc1_.btnServerVisable = 2;
            _loc1_.btnCompleteVisable = 2;
         }
         if(_loc2_.IsShow)
         {
            _loc2_.btnMark = 2;
            _loc2_.btnServerVisable = 1;
            _loc2_.btnCompleteVisable = 1;
            this.btnList.push(_loc2_);
         }
         else
         {
            _loc2_.btnMark = 2;
            _loc2_.btnServerVisable = 2;
            _loc2_.btnCompleteVisable = 2;
         }
         if(_loc3_.IsShow)
         {
            _loc3_.btnMark = 3;
            _loc3_.btnServerVisable = 1;
            _loc3_.btnCompleteVisable = 1;
            this.btnList.push(_loc3_);
         }
         else
         {
            _loc3_.btnMark = 3;
            _loc3_.btnServerVisable = 2;
            _loc3_.btnCompleteVisable = 2;
         }
         if(_loc6_.IsShow)
         {
            _loc6_.btnMark = 7;
            _loc6_.btnServerVisable = 1;
            _loc6_.btnCompleteVisable = 1;
            this.btnList.push(_loc6_);
         }
         else
         {
            _loc6_.btnMark = 7;
            _loc6_.btnServerVisable = 2;
            _loc6_.btnCompleteVisable = 2;
         }
         if(_loc8_.IsShow)
         {
            _loc8_.btnMark = 9;
            _loc8_.btnServerVisable = 1;
            _loc8_.btnCompleteVisable = 1;
            this.btnList.push(_loc8_);
         }
         else
         {
            _loc8_.btnMark = 9;
            _loc8_.btnServerVisable = 2;
            _loc8_.btnCompleteVisable = 2;
         }
         if(PlayerManager.Instance.Self.IsVIP)
         {
            if((PlayerManager.Instance.Self.canTakeVipReward || this._dailAwardState) && _loc5_.IsShow)
            {
               _loc5_.btnMark = 6;
               _loc5_.btnServerVisable = 1;
               _loc5_.btnCompleteVisable = 1;
               this.btnList.push(_loc5_);
            }
            else
            {
               _loc5_.btnServerVisable = 2;
               _loc5_.btnCompleteVisable = 2;
            }
         }
         else if(this._dailAwardState && _loc5_.IsShow)
         {
            _loc5_.btnMark = 6;
            _loc5_.btnServerVisable = 1;
            _loc5_.btnCompleteVisable = 1;
            this.btnList.push(_loc5_);
         }
         else
         {
            _loc5_.btnServerVisable = 2;
            _loc5_.btnCompleteVisable = 2;
         }
         if(_loc11_.IsShow && PlayerManager.Instance.Self.returnEnergy > 0)
         {
            _loc11_.btnMark = 13;
            _loc11_.btnServerVisable = 1;
            _loc11_.btnCompleteVisable = 1;
            this.btnList.push(_loc11_);
         }
         else
         {
            _loc11_.btnMark = 13;
            _loc11_.btnServerVisable = 2;
            _loc11_.btnCompleteVisable = 2;
         }
         if(_loc12_.IsShow && PlayerManager.Instance.Self.Grade >= 13)
         {
            _loc12_.btnMark = 14;
            _loc12_.btnServerVisable = 1;
            _loc12_.btnCompleteVisable = 1;
            this.btnList.push(_loc12_);
         }
         else
         {
            _loc12_.btnMark = 14;
            _loc12_.btnServerVisable = 2;
            _loc12_.btnCompleteVisable = 2;
         }
         if(_loc13_.IsShow && PlayerManager.Instance.Self.Grade >= ServerConfigManager.instance.getShadowNpcLimit())
         {
            _loc13_.btnMark = 15;
            _loc13_.btnServerVisable = 1;
            _loc13_.btnCompleteVisable = 1;
            this.btnList.push(_loc13_);
         }
         else
         {
            _loc13_.btnMark = 14;
            _loc13_.btnServerVisable = 2;
            _loc13_.btnCompleteVisable = 2;
         }
         if(!PlayerManager.Instance.Self.isAward)
         {
            _loc14_.btnMark = 16;
            _loc14_.btnServerVisable = 1;
            _loc14_.btnCompleteVisable = 1;
            this.btnList.push(_loc14_);
         }
         else
         {
            _loc14_.btnMark = 16;
            _loc14_.btnServerVisable = 2;
            _loc14_.btnCompleteVisable = 2;
         }
         var _loc15_:BuffInfo = PlayerManager.Instance.Self.buffInfo[BuffInfo.GET_ONLINE_REWARS];
         if(_loc15_)
         {
            if(_loc15_.ValidCount == 1 && PlayerManager.Instance.Self.consortionStatus)
            {
               _loc7_.btnMark = 11;
               _loc7_.btnServerVisable = 1;
               _loc7_.btnCompleteVisable = 1;
               this.btnList.push(_loc7_);
            }
         }
         return this.btnList;
      }
   }
}
