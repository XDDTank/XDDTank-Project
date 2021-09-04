package platformapi.tencent
{
   import com.pickgliss.events.UIModuleEvent;
   import com.pickgliss.loader.UIModuleLoader;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import ddt.data.UIModuleTypes;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.view.UIModuleSmallLoading;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import platformapi.tencent.model.DiamondModel;
   import platformapi.tencent.view.BlueDiamondGiftView;
   import platformapi.tencent.view.BlueDiamondNewHandGiftView;
   import platformapi.tencent.view.BunAwardFrame;
   import platformapi.tencent.view.MemberDiamondFrame;
   import platformapi.tencent.view.MemberDiamondRepaymentFrame;
   
   public class DiamondManager extends EventDispatcher
   {
      
      private static var _instance:DiamondManager;
       
      
      private var _model:DiamondModel;
      
      private var _hasUI:Boolean;
      
      private var _isFirst:Boolean = true;
      
      public function DiamondManager(param1:SingleTon)
      {
         super();
         if(!param1)
         {
            throw "单例无法实例化";
         }
      }
      
      public static function get instance() : DiamondManager
      {
         return _instance = _instance || new DiamondManager(new SingleTon());
      }
      
      public function get model() : DiamondModel
      {
         return this._model = this._model || new DiamondModel();
      }
      
      public function get isInTencent() : Boolean
      {
         return this.model.pfdata.pfType > 0;
      }
      
      public function get pfType() : int
      {
         return this.model.pfdata.pfType;
      }
      
      public function get hasUI() : Boolean
      {
         return this._hasUI;
      }
      
      public function get isFirst() : Boolean
      {
         if(PlayerManager.Instance.Self.Grade <= 3)
         {
            return false;
         }
         if(this._isFirst)
         {
            this._isFirst = false;
            return true;
         }
         return this._isFirst;
      }
      
      public function loadUIModule() : void
      {
         if(!this._hasUI)
         {
            UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.__onUIModuleComplete);
            UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.__onProgress);
            UIModuleLoader.Instance.addUIModuleImp(UIModuleTypes.MEMBER_DIAMOND_GIFT);
         }
         else
         {
            dispatchEvent(new Event(Event.COMPLETE));
         }
      }
      
      protected function __onProgress(param1:UIModuleEvent) : void
      {
         UIModuleSmallLoading.Instance.progress = param1.loader.progress * 100;
      }
      
      protected function __onUIModuleComplete(param1:UIModuleEvent) : void
      {
         if(param1.module == UIModuleTypes.MEMBER_DIAMOND_GIFT)
         {
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.__onUIModuleComplete);
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.__onProgress);
            this._hasUI = true;
            dispatchEvent(new Event(Event.COMPLETE));
         }
      }
      
      protected function __onClose(param1:Event) : void
      {
         UIModuleSmallLoading.Instance.hide();
         UIModuleSmallLoading.Instance.removeEventListener(Event.CLOSE,this.__onClose);
         UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.__onUIModuleComplete);
         UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.__onProgress);
      }
      
      public function dailyAward(param1:Boolean) : void
      {
         if(param1)
         {
            SocketManager.Instance.out.sendDiamondAward(8);
         }
         else
         {
            SocketManager.Instance.out.sendDiamondAward(7);
         }
      }
      
      public function firstEnterOpen() : void
      {
         if(PlayerManager.Instance.Self.Grade < 9)
         {
            return;
         }
         if(this.isFirst)
         {
            if(PlayerManager.Instance.Self.isGetNewHandPack)
            {
               switch(DiamondManager.instance.model.pfdata.pfType)
               {
                  case DiamondType.YELLOW_DIAMOND:
                     this.openDiamondFrame(1);
                     break;
                  case DiamondType.BLUE_DIAMOND:
                     this.openBlueFrame(1);
                     break;
                  case DiamondType.MEMBER_DIAMOND:
                     this.openBlueFrame(1);
               }
            }
            else
            {
               switch(DiamondManager.instance.model.pfdata.pfType)
               {
                  case DiamondType.YELLOW_DIAMOND:
                     this.openDiamondFrame(0);
                     break;
                  case DiamondType.BLUE_DIAMOND:
                     this.openBlueNewHandFrame(0);
                     break;
                  case DiamondType.MEMBER_DIAMOND:
                     this.openBlueNewHandFrame(0);
               }
            }
         }
      }
      
      public function openNewHand() : void
      {
         switch(this.pfType)
         {
            case DiamondType.YELLOW_DIAMOND:
               this.openDiamondFrame(0);
               break;
            case DiamondType.BLUE_DIAMOND:
               this.openBlueNewHandFrame();
               break;
            case DiamondType.MEMBER_DIAMOND:
               this.openDiamondFrame(0);
         }
      }
      
      public function openDiamond() : void
      {
         switch(this.pfType)
         {
            case DiamondType.YELLOW_DIAMOND:
               this.openDiamondFrame(1);
               break;
            case DiamondType.BLUE_DIAMOND:
               this.openBlueFrame();
               break;
            case DiamondType.MEMBER_DIAMOND:
               this.openDiamondFrame(1);
         }
      }
      
      public function openDiamondFrame(param1:int) : void
      {
         var _loc2_:MemberDiamondFrame = null;
         if(this._hasUI)
         {
            _loc2_ = ComponentFactory.Instance.creatComponentByStylename("memberDiamondFrame");
            _loc2_.show(param1);
         }
         else
         {
            addEventListener(Event.COMPLETE,this.callBackFunc(this.openDiamondFrame,param1));
            this.loadUIModule();
         }
      }
      
      private function callBackFunc(param1:Function, param2:int) : Function
      {
         var func:Function = param1;
         var index:int = param2;
         func(index);
         return function(param1:Event):void
         {
         };
      }
      
      public function openBlueFrame(param1:int = 0) : void
      {
         var _loc2_:BlueDiamondGiftView = null;
         if(this._hasUI)
         {
            _loc2_ = ComponentFactory.Instance.creatComponentByStylename("memberDiamondGift.view.memberDiamondGiftView");
            _loc2_.show();
         }
         else
         {
            addEventListener(Event.COMPLETE,this.callBackFunc(this.openBlueFrame,param1));
            this.loadUIModule();
         }
      }
      
      public function openBunFrame(param1:int = 0) : void
      {
         var _loc2_:BunAwardFrame = null;
         if(this._hasUI)
         {
            _loc2_ = ComponentFactory.Instance.creatComponentByStylename("memberDiamondGift.view.bunAwardFrame");
            LayerManager.Instance.addToLayer(_loc2_,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
         }
         else
         {
            addEventListener(Event.COMPLETE,this.callBackFunc(this.openBunFrame,param1));
            this.loadUIModule();
         }
      }
      
      public function openBlueNewHandFrame(param1:int = 0) : void
      {
         var _loc2_:BlueDiamondNewHandGiftView = null;
         if(this._hasUI)
         {
            _loc2_ = ComponentFactory.Instance.creatComponentByStylename("memberDiamondGift.view.memberDiamondNewHandGiftView");
            _loc2_.show();
         }
         else
         {
            addEventListener(Event.COMPLETE,this.callBackFunc(this.openBlueNewHandFrame,param1));
            this.loadUIModule();
         }
      }
      
      public function openMemberDiamondRepaymentFrame(param1:int = 0) : void
      {
         var _loc2_:MemberDiamondRepaymentFrame = null;
         if(this._hasUI)
         {
            _loc2_ = ComponentFactory.Instance.creatComponentByStylename("memberDiamondGift.view.memberDiamondRepaymentFrame");
            _loc2_.show();
         }
         else
         {
            addEventListener(Event.COMPLETE,this.callBackFunc(this.openMemberDiamondRepaymentFrame,param1));
            this.loadUIModule();
         }
      }
      
      public function openMemberDiamond() : void
      {
         TencentExternalInterfaceManager.openDiamond();
      }
      
      public function openYearMemberDiamond() : void
      {
         TencentExternalInterfaceManager.openDiamond(true);
      }
   }
}

class SingleTon
{
    
   
   function SingleTon()
   {
      super();
   }
}
