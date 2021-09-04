package farm.view
{
   import baglocked.BaglockedManager;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.ScaleBitmapImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.ui.vo.AlertInfo;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import ddt.manager.LeavePageManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.ServerConfigManager;
   import ddt.manager.SoundManager;
   import farm.FarmModelController;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   
   public class FarmCoolView extends Sprite implements Disposeable
   {
       
      
      public const COST:int = int(ServerConfigManager.instance.findInfoByName(ServerConfigManager.FARM_REFRESH_MONEY).Value);
      
      private var _bg:ScaleBitmapImage;
      
      private var _resurrectBtn:BaseButton;
      
      private var _timeCD:MovieClip;
      
      private var _txtProp:FilterFrameText;
      
      private var _totalCount:int;
      
      private var timer:Timer;
      
      private var alert:BaseAlerFrame;
      
      public function FarmCoolView(param1:int)
      {
         super();
         this._totalCount = param1;
         this.init();
         this.addEvent();
      }
      
      private function init() : void
      {
         this._bg = ComponentFactory.Instance.creat("farm.coolView.bg");
         addChild(this._bg);
         this._txtProp = ComponentFactory.Instance.creat("farm.coolView.timeTxt");
         addChild(this._txtProp);
         this._txtProp.text = LanguageMgr.GetTranslation("ddt.farms.coolView.prop");
         this._resurrectBtn = ComponentFactory.Instance.creat("farm.coolView.coolBtn");
         addChild(this._resurrectBtn);
         this._timeCD = ComponentFactory.Instance.creat("farm.coolView.timeCD");
         addChild(this._timeCD);
         this.__startCount(null);
         this.timer = new Timer(1000,this._totalCount + 1);
         this.timer.addEventListener(TimerEvent.TIMER,this.__startCount);
         this.timer.addEventListener(TimerEvent.TIMER_COMPLETE,this.__timerComplete);
         this.timer.start();
      }
      
      private function addEvent() : void
      {
         this._resurrectBtn.addEventListener(MouseEvent.CLICK,this.__coolDown);
      }
      
      private function getCostMoney() : int
      {
         return 0;
      }
      
      private function __coolDown(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            return;
         }
         var _loc2_:AlertInfo = new AlertInfo();
         _loc2_.title = LanguageMgr.GetTranslation("AlertDialog.Info");
         _loc2_.data = LanguageMgr.GetTranslation("ddt.farms.coolView.propMoney",this.getCostMoney());
         _loc2_.enableHtml = true;
         _loc2_.moveEnable = false;
         this.alert = AlertManager.Instance.alert("SimpleAlert",_loc2_,LayerManager.ALPHA_BLOCKGOUND);
         this.alert.addEventListener(FrameEvent.RESPONSE,this.__onAlertResponse);
      }
      
      private function __startCount(param1:TimerEvent) : void
      {
         if(this._totalCount < 0)
         {
            this.__timerComplete();
            return;
         }
         if(this._totalCount % 60 == 0)
         {
            FarmModelController.instance.refreshFarm();
         }
         var _loc2_:String = this.setFormat(int(this._totalCount / 3600)) + ":" + this.setFormat(int(this._totalCount / 60 % 60)) + ":" + this.setFormat(int(this._totalCount % 60));
         (this._timeCD["timeHour2"] as MovieClip).gotoAndStop("num_" + _loc2_.charAt(0));
         (this._timeCD["timeHour"] as MovieClip).gotoAndStop("num_" + _loc2_.charAt(1));
         (this._timeCD["timeMint2"] as MovieClip).gotoAndStop("num_" + _loc2_.charAt(3));
         (this._timeCD["timeMint"] as MovieClip).gotoAndStop("num_" + _loc2_.charAt(4));
         (this._timeCD["timeSecond2"] as MovieClip).gotoAndStop("num_" + _loc2_.charAt(6));
         (this._timeCD["timeSecond"] as MovieClip).gotoAndStop("num_" + _loc2_.charAt(7));
         --this._totalCount;
      }
      
      private function removeEvent() : void
      {
         this._resurrectBtn.removeEventListener(MouseEvent.CLICK,this.__coolDown);
      }
      
      private function __onAlertResponse(param1:FrameEvent) : void
      {
         var _loc2_:BaseAlerFrame = null;
         SoundManager.instance.play("008");
         this.alert.removeEventListener(FrameEvent.RESPONSE,this.__onAlertResponse);
         this.alert.dispose();
         switch(param1.responseCode)
         {
            case FrameEvent.ENTER_CLICK:
            case FrameEvent.SUBMIT_CLICK:
               if(PlayerManager.Instance.Self.totalMoney < this.getCostMoney())
               {
                  _loc2_ = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("tank.view.comon.lack"),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),false,false,false,LayerManager.ALPHA_BLOCKGOUND);
                  _loc2_.moveEnable = false;
                  _loc2_.addEventListener(FrameEvent.RESPONSE,this._responseI);
               }
               break;
            case FrameEvent.CANCEL_CLICK:
            case FrameEvent.CLOSE_CLICK:
            case FrameEvent.ESC_CLICK:
         }
      }
      
      private function _responseI(param1:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         if(param1.responseCode == FrameEvent.SUBMIT_CLICK)
         {
            LeavePageManager.leaveToFillPath();
         }
         ObjectUtils.disposeObject(param1.target);
      }
      
      private function setFormat(param1:int) : String
      {
         var _loc2_:String = param1.toString();
         if(param1 < 10)
         {
            _loc2_ = "0" + _loc2_;
         }
         return _loc2_;
      }
      
      private function __timerComplete(param1:TimerEvent = null) : void
      {
         dispatchEvent(new Event(Event.COMPLETE));
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         this.timer.stop();
         this.timer.removeEventListener(TimerEvent.TIMER,this.__startCount);
         this.timer.removeEventListener(TimerEvent.TIMER_COMPLETE,this.__timerComplete);
         this.timer = null;
         if(this.alert)
         {
            this.alert.dispose();
         }
         ObjectUtils.disposeAllChildren(this);
         if(parent)
         {
            this.parent.removeChild(this);
         }
         this._bg = null;
         this._txtProp = null;
         this._resurrectBtn = null;
         this._timeCD = null;
      }
   }
}
