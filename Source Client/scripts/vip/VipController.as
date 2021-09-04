package vip
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.events.UIModuleEvent;
   import com.pickgliss.loader.UIModuleLoader;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.text.GradientText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.UIModuleTypes;
   import ddt.data.VipConfigInfo;
   import ddt.data.player.SelfInfo;
   import ddt.manager.PlayerManager;
   import ddt.manager.ServerConfigManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.manager.VipPrivilegeConfigManager;
   import ddt.view.UIModuleSmallLoading;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import platformapi.tencent.DiamondManager;
   import vip.data.VipModelInfo;
   import vip.view.RechargeAlertTxt;
   import vip.view.VIPHelpFrame;
   import vip.view.VIPRechargeAlertFrame;
   import vip.view.VipFrame;
   import vip.view.VipViewFrame;
   
   public class VipController extends EventDispatcher
   {
      
      private static var _instance:VipController;
      
      public static var useFirst:Boolean = true;
      
      public static var loadComplete:Boolean = false;
       
      
      private var _vipUILoaded:Boolean = false;
      
      public var info:VipModelInfo;
      
      public var isRechargePoped:Boolean;
      
      private var _vipFrame:VipFrame;
      
      private var _vipViewFrame:VipViewFrame;
      
      private var _helpframe:VIPHelpFrame;
      
      private var _isShow:Boolean = true;
      
      private var _rechargeAlertFrame:VIPRechargeAlertFrame;
      
      private var _rechargeAlertLoad:Boolean = false;
      
      public function VipController()
      {
         super();
      }
      
      public static function get instance() : VipController
      {
         if(!_instance)
         {
            _instance = new VipController();
         }
         return _instance;
      }
      
      public function show() : void
      {
         if(loadComplete)
         {
            this.showVipFrame();
         }
         else if(useFirst)
         {
            UIModuleSmallLoading.Instance.progress = 0;
            UIModuleSmallLoading.Instance.show();
            UIModuleSmallLoading.Instance.addEventListener(Event.CLOSE,this.__onClose);
            UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.__progressShow);
            UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.__complainShow);
            UIModuleLoader.Instance.addUIModuleImp(UIModuleTypes.VIP_VIEW);
         }
      }
      
      public function showWhenPass() : void
      {
         this.show();
         this._isShow = false;
      }
      
      public function checkVipExpire() : Boolean
      {
         if(PlayerManager.Instance.Self.VIPLevel > 0 && !PlayerManager.Instance.Self.IsVIP && PlayerManager.Instance.Self.openVipType)
         {
            return true;
         }
         return false;
      }
      
      public function get isShow() : Boolean
      {
         return this._isShow;
      }
      
      public function showRechargeAlert() : void
      {
         var _loc1_:SelfInfo = null;
         var _loc2_:RechargeAlertTxt = null;
         if(loadComplete)
         {
            if(this._rechargeAlertFrame == null)
            {
               this._rechargeAlertFrame = ComponentFactory.Instance.creatComponentByStylename("vip.vipRechargeAlertFrame");
               _loc1_ = PlayerManager.Instance.Self;
               _loc2_ = new RechargeAlertTxt();
               _loc2_.AlertContent = _loc1_.VIPLevel;
               this._rechargeAlertFrame.content = _loc2_;
               this._rechargeAlertFrame.show();
               this._rechargeAlertFrame.addEventListener(FrameEvent.RESPONSE,this.__responseRechargeAlertHandler);
            }
         }
         else if(useFirst)
         {
            this._rechargeAlertLoad = true;
            UIModuleSmallLoading.Instance.progress = 0;
            UIModuleSmallLoading.Instance.show();
            UIModuleSmallLoading.Instance.addEventListener(Event.CLOSE,this.__onClose);
            UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.__progressShow);
            UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.__complainShow);
            UIModuleLoader.Instance.addUIModuleImp(UIModuleTypes.VIP_VIEW);
            UIModuleLoader.Instance.addUIModuleImp(UIModuleTypes.MEMBER_DIAMOND_GIFT);
            useFirst = false;
         }
      }
      
      public function helpframeNull() : void
      {
         if(this._helpframe)
         {
            this._helpframe = null;
         }
      }
      
      protected function __responseHandler(param1:FrameEvent) : void
      {
         this._helpframe.removeEventListener(FrameEvent.RESPONSE,this.__responseHandler);
         SoundManager.instance.play("008");
         switch(param1.responseCode)
         {
            case FrameEvent.CLOSE_CLICK:
            case FrameEvent.ESC_CLICK:
               this._helpframe.dispose();
         }
      }
      
      protected function __responseRechargeAlertHandler(param1:FrameEvent) : void
      {
         this._rechargeAlertFrame.removeEventListener(FrameEvent.RESPONSE,this.__responseRechargeAlertHandler);
         SoundManager.instance.play("008");
         switch(param1.responseCode)
         {
            case FrameEvent.CLOSE_CLICK:
            case FrameEvent.ESC_CLICK:
               this._rechargeAlertFrame.dispose();
         }
         if(this._rechargeAlertFrame)
         {
            this._rechargeAlertFrame = null;
         }
      }
      
      private function showVipFrame() : void
      {
         this.hide();
         this._vipFrame = ComponentFactory.Instance.creatComponentByStylename("vip.VipFrame");
         this._vipFrame.show();
      }
      
      private function __complainShow(param1:UIModuleEvent) : void
      {
         if(param1.module == UIModuleTypes.VIP_VIEW)
         {
            this._vipUILoaded = true;
         }
         loadComplete = this._vipUILoaded && (!DiamondManager.instance.isInTencent || DiamondManager.instance.hasUI);
         if(loadComplete)
         {
            UIModuleSmallLoading.Instance.removeEventListener(Event.CLOSE,this.__onClose);
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.__progressShow);
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.__complainShow);
            UIModuleSmallLoading.Instance.hide();
            useFirst = false;
            if(this._rechargeAlertLoad)
            {
               this.showRechargeAlert();
            }
            else
            {
               this.show();
            }
         }
      }
      
      private function __progressShow(param1:UIModuleEvent) : void
      {
         if(param1.module == UIModuleTypes.VIP_VIEW)
         {
            UIModuleSmallLoading.Instance.progress = param1.loader.progress * 100;
         }
      }
      
      private function __onClose(param1:Event) : void
      {
         UIModuleSmallLoading.Instance.hide();
         UIModuleSmallLoading.Instance.removeEventListener(Event.CLOSE,this.__onClose);
         UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.__progressShow);
         UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.__complainShow);
      }
      
      public function sendOpenVip(param1:String, param2:int) : void
      {
         SocketManager.Instance.out.sendOpenVip(param1,param2);
      }
      
      public function hide() : void
      {
         ObjectUtils.disposeObject(this._vipFrame);
         this._vipFrame = null;
      }
      
      public function getVipNameTxt(param1:int = -1, param2:int = 1) : GradientText
      {
         var _loc3_:GradientText = null;
         switch(param2)
         {
            case 0:
               throw new Error("会员类型错误,不能为非会员玩家创建会员字体.");
            case 1:
               _loc3_ = ComponentFactory.Instance.creatComponentByStylename("vipName");
               break;
            case 2:
               _loc3_ = ComponentFactory.Instance.creatComponentByStylename("vipName");
         }
         if(_loc3_)
         {
            if(param1 != -1)
            {
               _loc3_.textField.width = param1;
            }
            else
            {
               _loc3_.textField.autoSize = "left";
            }
            return _loc3_;
         }
         return ComponentFactory.Instance.creatComponentByStylename("vipName");
      }
      
      public function getVIPStrengthenEx(param1:int) : Number
      {
         if(param1 - 1 < 0)
         {
            return 0;
         }
         var _loc2_:Array = ServerConfigManager.instance.VIPStrengthenEx;
         if(_loc2_)
         {
            return _loc2_[param1 - 1];
         }
         return 0;
      }
      
      public function getPrivilegeByIndex(param1:int) : Boolean
      {
         if(!PlayerManager.Instance.Self.IsVIP)
         {
            return false;
         }
         var _loc2_:VipConfigInfo = VipPrivilegeConfigManager.Instance.getById(param1);
         var _loc3_:int = int(_loc2_["Level" + PlayerManager.Instance.Self.VIPLevel]);
         return _loc3_ > 0 ? Boolean(true) : Boolean(false);
      }
      
      public function getPrivilegeByIndexAndLevel(param1:int, param2:int) : Boolean
      {
         if(param2 <= 0)
         {
            return false;
         }
         var _loc3_:VipConfigInfo = VipPrivilegeConfigManager.Instance.getById(param1);
         var _loc4_:int = int(_loc3_["Level" + param2]);
         return _loc4_ > 0 ? Boolean(true) : Boolean(false);
      }
   }
}
