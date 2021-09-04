package consortion.transportSence
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.ui.vo.AlertInfo;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   
   public class TransportProposeFrame extends BaseAlerFrame
   {
       
      
      private var _alertInfo:AlertInfo;
      
      private var _autoDisappearTimer:Timer;
      
      private var _inviteId:int;
      
      private var _inviteName:String;
      
      private var _normalTxt:FilterFrameText;
      
      private var _timeRemainTxt:FilterFrameText;
      
      private var _totalTime:uint;
      
      private var _isShowing:Boolean;
      
      private var _hasSendAnswer:Boolean;
      
      private var _expeditionAlert:BaseAlerFrame;
      
      public function TransportProposeFrame()
      {
         super();
         this.initialize();
         this.addEvent();
      }
      
      private function initialize() : void
      {
         this._totalTime = 10;
         this._autoDisappearTimer = new Timer(1000,this._totalTime);
         this._alertInfo = new AlertInfo();
         this._alertInfo.title = LanguageMgr.GetTranslation("consortion.ConsortionTransport.invite.title.text");
         this._alertInfo.submitLabel = LanguageMgr.GetTranslation("accept");
         this._alertInfo.cancelLabel = LanguageMgr.GetTranslation("refuse");
         this._alertInfo.moveEnable = false;
         info = this._alertInfo;
         this._normalTxt = ComponentFactory.Instance.creatComponentByStylename("asset.Transport.tips.normalTxt.TF");
         this._timeRemainTxt = ComponentFactory.Instance.creatComponentByStylename("asset.Transport.tips.timeRemainTxt.TF");
         this._timeRemainTxt.htmlText = LanguageMgr.GetTranslation("consortion.ConsortionTransport.alertTips.timeRemain.txt",[this._totalTime]);
         addToContent(this._normalTxt);
         addToContent(this._timeRemainTxt);
      }
      
      private function addEvent() : void
      {
         addEventListener(FrameEvent.RESPONSE,this.onFrameResponse);
         this._autoDisappearTimer.addEventListener(TimerEvent.TIMER,this.__timeCount);
         this._autoDisappearTimer.addEventListener(TimerEvent.TIMER_COMPLETE,this.__autoDisappear);
      }
      
      private function __timeCount(param1:TimerEvent) : void
      {
         --this._totalTime;
         this._timeRemainTxt.htmlText = LanguageMgr.GetTranslation("consortion.ConsortionTransport.alertTips.timeRemain.txt",[this._totalTime]);
      }
      
      private function __autoDisappear(param1:TimerEvent) : void
      {
         if(!this._hasSendAnswer)
         {
            this._hasSendAnswer = true;
            SocketManager.Instance.out.SendInviteAnswer(this._inviteId,this._inviteName,false);
         }
         this.dispose();
      }
      
      public function show() : void
      {
         this._normalTxt.text = this._inviteName + LanguageMgr.GetTranslation("consortion.ConsortionTransport.alertTips.convoyDescript.txt");
         LayerManager.Instance.addToLayer(this,LayerManager.GAME_TOP_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
         this._autoDisappearTimer.start();
         this._isShowing = true;
      }
      
      private function onFrameResponse(param1:FrameEvent) : void
      {
         switch(param1.responseCode)
         {
            case FrameEvent.CANCEL_CLICK:
            case FrameEvent.CLOSE_CLICK:
            case FrameEvent.ESC_CLICK:
               SoundManager.instance.play("008");
               this._autoDisappearTimer.stop();
               if(!this._hasSendAnswer)
               {
                  this._hasSendAnswer = true;
                  SocketManager.Instance.out.SendInviteAnswer(this._inviteId,this._inviteName,false);
               }
               this.dispose();
               break;
            case FrameEvent.ENTER_CLICK:
            case FrameEvent.SUBMIT_CLICK:
               if(!this._hasSendAnswer)
               {
                  this._hasSendAnswer = true;
                  this.checkExpedition();
               }
         }
      }
      
      private function checkExpedition() : void
      {
         if(PlayerManager.Instance.checkExpedition())
         {
            this._expeditionAlert = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("tips"),LanguageMgr.GetTranslation("ddt.consortion.ConsortionTransport.stopExpedition"),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),false,true,false,LayerManager.BLCAK_BLOCKGOUND);
            this._expeditionAlert.moveEnable = false;
            this._expeditionAlert.addEventListener(FrameEvent.RESPONSE,this.__confirmResponse);
         }
         else
         {
            SocketManager.Instance.out.SendInviteAnswer(this._inviteId,this._inviteName,true);
            this.dispose();
         }
      }
      
      private function __confirmResponse(param1:FrameEvent) : void
      {
         var _loc2_:BaseAlerFrame = param1.currentTarget as BaseAlerFrame;
         _loc2_.removeEventListener(FrameEvent.RESPONSE,this.__confirmResponse);
         if(param1.responseCode == FrameEvent.ENTER_CLICK || param1.responseCode == FrameEvent.SUBMIT_CLICK)
         {
            SocketManager.Instance.out.sendExpeditionCancle();
            SocketManager.Instance.out.SendInviteAnswer(this._inviteId,this._inviteName,true);
         }
         if(param1.responseCode == FrameEvent.CANCEL_CLICK || param1.responseCode == FrameEvent.CLOSE_CLICK || param1.responseCode == FrameEvent.ESC_CLICK)
         {
            SocketManager.Instance.out.SendInviteAnswer(this._inviteId,this._inviteName,false);
         }
         ObjectUtils.disposeObject(_loc2_);
         this.dispose();
      }
      
      public function setIdAndName(param1:int, param2:String) : void
      {
         this._inviteId = param1;
         this._inviteName = param2;
      }
      
      public function get isShowing() : Boolean
      {
         return this._isShowing;
      }
      
      private function removeEvent() : void
      {
         removeEventListener(FrameEvent.RESPONSE,this.onFrameResponse);
         this._autoDisappearTimer.removeEventListener(TimerEvent.TIMER_COMPLETE,this.__autoDisappear);
         this._autoDisappearTimer.removeEventListener(TimerEvent.TIMER,this.__timeCount);
      }
      
      override public function dispose() : void
      {
         this._autoDisappearTimer.stop();
         super.dispose();
         this.removeEvent();
         this._isShowing = false;
         this._autoDisappearTimer = null;
         ObjectUtils.disposeObject(this._alertInfo);
         this._alertInfo = null;
         ObjectUtils.disposeObject(this._normalTxt);
         this._normalTxt = null;
         ObjectUtils.disposeObject(this._timeRemainTxt);
         this._timeRemainTxt = null;
         if(this._expeditionAlert)
         {
            this._expeditionAlert.removeEventListener(FrameEvent.RESPONSE,this.__confirmResponse);
            ObjectUtils.disposeObject(this._expeditionAlert);
            this._expeditionAlert = null;
         }
         if(parent)
         {
            parent.removeChild(this);
         }
      }
   }
}
