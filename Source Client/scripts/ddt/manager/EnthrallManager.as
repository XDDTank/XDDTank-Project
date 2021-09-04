package ddt.manager
{
   import com.pickgliss.action.FunctionAction;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.manager.CacheSysManager;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.vo.AlertInfo;
   import ddt.constants.CacheConsts;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.events.TimeEvents;
   import ddt.states.StateType;
   import ddt.view.enthrall.EnthrallView;
   import ddt.view.enthrall.Validate17173;
   import ddt.view.enthrall.ValidateFrame;
   import road7th.comm.PackageIn;
   
   public class EnthrallManager
   {
      
      private static var _instance:EnthrallManager;
      
      public static var STATE_1:int = 60;
      
      public static var STATE_2:int = 120;
      
      public static var STATE_3:int = 175;
      
      public static var STATE_4:int = 180;
       
      
      private var _view:EnthrallView;
      
      private var _loadedTime:int = 0;
      
      private var _showEnthrallLight:Boolean = false;
      
      private var _popCIDChecker:Boolean = false;
      
      private var _enthrallSwicth:Boolean;
      
      private var _hasApproved:Boolean;
      
      private var _isMinor:Boolean;
      
      private var _interfaceID:int;
      
      private var validateFrame:ValidateFrame;
      
      private var inited:Boolean;
      
      private var initValid:Boolean;
      
      public function EnthrallManager(param1:SingletonEnfocer)
      {
         super();
         this.inited = false;
      }
      
      public static function getInstance() : EnthrallManager
      {
         if(_instance == null)
         {
            _instance = new EnthrallManager(new SingletonEnfocer());
         }
         return _instance;
      }
      
      private function init() : void
      {
         this.inited = true;
         this._view = ComponentFactory.Instance.creat("EnthrallViewSprite");
         this._view.manager = this;
         TimeManager.addEventListener(TimeEvents.MINUTES,this.__timerHandler);
         TimeManager.addEventListener(TimeEvents.SECONDS,this.__timer1Handler);
      }
      
      private function __timerHandler(param1:TimeEvents) : void
      {
         ++this._loadedTime;
         TimeManager.Instance.enthrallTime += 1;
         if(!this._hasApproved)
         {
            this.checkState();
         }
         else if(this._hasApproved && this._isMinor)
         {
            this.checkState();
         }
      }
      
      private function checkState() : void
      {
         var state:int = 0;
         if(!StateManager.isInFight)
         {
            if(TimeManager.Instance.enthrallTime == STATE_1 || TimeManager.Instance.enthrallTime == STATE_2 || TimeManager.Instance.enthrallTime == STATE_3 || TimeManager.Instance.enthrallTime == STATE_4)
            {
               state = TimeManager.Instance.enthrallTime;
               this.showantiAddictionFrame(state);
            }
         }
         else if(TimeManager.Instance.enthrallTime == STATE_1 || TimeManager.Instance.enthrallTime == STATE_2 || TimeManager.Instance.enthrallTime == STATE_3 || TimeManager.Instance.enthrallTime == STATE_4)
         {
            state = TimeManager.Instance.enthrallTime;
            CacheSysManager.getInstance().cacheFunction(CacheConsts.ALERT_IN_FIGHT,new FunctionAction(function():void
            {
               showantiAddictionFrame(state);
            }));
         }
      }
      
      private function showantiAddictionFrame(param1:int) : void
      {
         var _loc2_:BaseAlerFrame = null;
         var _loc3_:AlertInfo = null;
         var _loc4_:AlertInfo = null;
         var _loc5_:AlertInfo = null;
         var _loc6_:AlertInfo = null;
         if(param1 == STATE_1)
         {
            _loc3_ = new AlertInfo();
            _loc3_.title = LanguageMgr.GetTranslation("AlertDialog.Info");
            _loc3_.buttonGape = 20;
            _loc3_.showCancel = false;
            _loc3_.submitLabel = LanguageMgr.GetTranslation("ok");
            _loc3_.data = LanguageMgr.GetTranslation("tank.manager.enthrallRemind1");
            _loc2_ = AlertManager.Instance.alert("SimpleAlert",_loc3_);
            _loc2_.addEventListener(FrameEvent.RESPONSE,this.__antiAddictionFrame);
         }
         if(param1 == STATE_2)
         {
            _loc4_ = new AlertInfo();
            _loc4_.title = LanguageMgr.GetTranslation("AlertDialog.Info");
            _loc4_.buttonGape = 20;
            _loc4_.showCancel = false;
            _loc4_.submitLabel = LanguageMgr.GetTranslation("ok");
            _loc4_.data = LanguageMgr.GetTranslation("tank.manager.enthrallRemind2");
            _loc2_ = AlertManager.Instance.alert("SimpleAlert",_loc4_);
            _loc2_.addEventListener(FrameEvent.RESPONSE,this.__antiAddictionFrame);
         }
         if(param1 == STATE_3)
         {
            _loc5_ = new AlertInfo();
            _loc5_.title = LanguageMgr.GetTranslation("AlertDialog.Info");
            _loc5_.buttonGape = 20;
            _loc5_.showCancel = false;
            _loc5_.submitLabel = LanguageMgr.GetTranslation("ok");
            _loc5_.data = LanguageMgr.GetTranslation("tank.manager.enthrallRemind3");
            _loc2_ = AlertManager.Instance.alert("SimpleAlert",_loc5_);
            _loc2_.addEventListener(FrameEvent.RESPONSE,this.__antiAddictionFrame);
         }
         if(param1 == STATE_4)
         {
            _loc6_ = new AlertInfo();
            _loc6_.title = LanguageMgr.GetTranslation("AlertDialog.Info");
            _loc6_.buttonGape = 20;
            _loc6_.showCancel = false;
            _loc6_.submitLabel = LanguageMgr.GetTranslation("ok");
            _loc6_.data = LanguageMgr.GetTranslation("tank.manager.enthrallRemind4");
            _loc2_ = AlertManager.Instance.alert("SimpleAlert",_loc6_);
            _loc2_.addEventListener(FrameEvent.RESPONSE,this.__antiAddictionFrame);
         }
      }
      
      private function __antiAddictionFrame(param1:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         var _loc2_:BaseAlerFrame = param1.currentTarget as BaseAlerFrame;
         if(param1.responseCode == FrameEvent.SUBMIT_CLICK || param1.responseCode == FrameEvent.CLOSE_CLICK)
         {
            _loc2_.dispose();
         }
      }
      
      public function updateLight() : void
      {
         this._view.update();
      }
      
      private function __timer1Handler(param1:TimeEvents) : void
      {
         if(!this._popCIDChecker)
         {
            return;
         }
         if(StateManager.currentStateType == StateType.MAIN)
         {
            TimeManager.removeEventListener(TimeEvents.SECONDS,this.__timer1Handler);
         }
      }
      
      public function setup() : void
      {
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.CID_CHECK,this.changeCIDChecker);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.ENTHRALL_LIGHT,this.readStates);
      }
      
      private function get isSpecifiedDate() : Boolean
      {
         var _loc1_:Number = 9;
         var _loc2_:Number = TimeManager.Instance.Now().month + 1;
         var _loc3_:Number = TimeManager.Instance.Now().date;
         if((_loc2_ == _loc1_ || _loc2_ == 10) && (_loc3_ == 8 || _loc3_ == 9 || _loc3_ == 10 || _loc3_ == 29 || _loc3_ == 30))
         {
            return true;
         }
         return false;
      }
      
      private function changeCIDChecker(param1:CrazyTankSocketEvent) : void
      {
         if(!this.inited)
         {
            this.init();
         }
         var _loc2_:PackageIn = param1.pkg;
         this._popCIDChecker = _loc2_.readBoolean();
         if(this._popCIDChecker)
         {
            TimeManager.addEventListener(TimeEvents.SECONDS,this.__timer1Handler);
         }
         else
         {
            this.closeCIDCheckerFrame();
         }
      }
      
      private function readStates(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:PackageIn = param1.pkg;
         this._enthrallSwicth = _loc2_.readBoolean();
         this._interfaceID = _loc2_.readInt();
         this._hasApproved = _loc2_.readBoolean();
         this._isMinor = _loc2_.readBoolean();
         this.updateEnthrallView();
      }
      
      public function updateEnthrallView() : void
      {
         if(!this._enthrallSwicth)
         {
            this.hideEnthrallLight();
            return;
         }
         if(!this.inited)
         {
            this.init();
         }
         if(this._enthrallSwicth && StateManager.currentStateType == StateType.MAIN)
         {
            if(this._hasApproved)
            {
               if(!this._isMinor)
               {
                  this.hideEnthrallLight();
               }
               else
               {
                  this.showEnthrallLight();
               }
            }
            else
            {
               if(!this.initValid)
               {
                  this.showCIDCheckerFrame();
               }
               this.showEnthrallLight();
            }
         }
         else
         {
            this.hideEnthrallLight();
         }
         this._view.changeBtn(false);
         this._view.changeToGameState(false);
         this._view.changeBtn(false);
         switch(StateManager.currentStateType)
         {
            case StateType.MAIN:
               this._view.changeBtn(!this._hasApproved);
               return;
            case StateType.TRAINER1:
            case StateType.TRAINER2:
               this._view.changeToGameState(true);
               return;
            default:
               return;
         }
      }
      
      private function closeCIDCheckerFrame() : void
      {
         this.validateFrame.hide();
      }
      
      public function showCIDCheckerFrame() : void
      {
         if(this.interfaceID != 0)
         {
            LayerManager.Instance.addToLayer(ComponentFactory.Instance.creat("EnthrallValidateFrame17173") as Validate17173,LayerManager.GAME_DYNAMIC_LAYER,true,0,false);
            return;
         }
         if(!this.validateFrame || !this.validateFrame.parent)
         {
            this.initValid = true;
            this.validateFrame = ComponentFactory.Instance.creat("EnthrallValidateFrame");
         }
         LayerManager.Instance.addToLayer(this.validateFrame,LayerManager.GAME_DYNAMIC_LAYER,true,1,false);
      }
      
      public function showEnthrallLight() : void
      {
         LayerManager.Instance.addToLayer(this._view,LayerManager.GAME_DYNAMIC_LAYER,false,0,false);
         this.updateLight();
      }
      
      public function hideEnthrallLight() : void
      {
         if(this._view && this._view.parent)
         {
            this._view.parent.removeChild(this._view);
         }
      }
      
      public function gameState(param1:Number) : void
      {
         this._view.x = param1 - 100;
         this._view.y = 15;
      }
      
      public function outGame() : void
      {
         this._view.x = 110;
         this._view.y = 5;
      }
      
      public function get enthrallSwicth() : Boolean
      {
         return this._enthrallSwicth;
      }
      
      public function get isEnthrall() : Boolean
      {
         return this.enthrallSwicth && (!this._hasApproved || this._isMinor);
      }
      
      public function get interfaceID() : int
      {
         if(!this._interfaceID)
         {
            return 0;
         }
         return this._interfaceID;
      }
   }
}

class SingletonEnfocer
{
    
   
   function SingletonEnfocer()
   {
      super();
   }
}
