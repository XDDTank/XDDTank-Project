package consortion.transportSence
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.TextButton;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.ui.vo.AlertInfo;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.manager.StateManager;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   import game.GameManager;
   
   public class TransportHijackProposeFrame extends BaseAlerFrame
   {
       
      
      private var _alertInfo:AlertInfo;
      
      private var _autoDisappearTimer:Timer;
      
      private var _ownerId:int;
      
      private var _carType:int;
      
      private var _hijackerId:int;
      
      private var _hijackerName:String;
      
      private var _normalTxt:FilterFrameText;
      
      private var _timeRemainTxt:FilterFrameText;
      
      private var _totalTime:uint;
      
      private var _fightBtn:TextButton;
      
      private var _isShowing:Boolean;
      
      private var _hasSendAnswer:Boolean;
      
      private var _expeditionAlert:BaseAlerFrame;
      
      public function TransportHijackProposeFrame()
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
         this._alertInfo.title = LanguageMgr.GetTranslation("consortion.ConsortionTransport.hijack.title.text");
         this._alertInfo.showSubmit = false;
         this._alertInfo.showCancel = false;
         this._alertInfo.moveEnable = false;
         info = this._alertInfo;
         this._normalTxt = ComponentFactory.Instance.creatComponentByStylename("asset.Transport.tips.normalTxt.TF");
         this._timeRemainTxt = ComponentFactory.Instance.creatComponentByStylename("asset.Transport.tips.timeRemainTxt.TF");
         this._timeRemainTxt.htmlText = LanguageMgr.GetTranslation("consortion.ConsortionTransport.alertTips.timeRemain.txt",[this._totalTime]);
         this._fightBtn = ComponentFactory.Instance.creatComponentByStylename("hijackTipsView.confirmBtn");
         this._fightBtn.text = LanguageMgr.GetTranslation("consortion.ConsortionTransport.alertTips.hijackDescript.btn");
         addToContent(this._normalTxt);
         addToContent(this._timeRemainTxt);
         addToContent(this._fightBtn);
      }
      
      private function addEvent() : void
      {
         addEventListener(FrameEvent.RESPONSE,this.onFrameResponse);
         this._autoDisappearTimer.addEventListener(TimerEvent.TIMER,this.__timeCount);
         this._autoDisappearTimer.addEventListener(TimerEvent.TIMER_COMPLETE,this.__autoDisappear);
         this._fightBtn.addEventListener(MouseEvent.CLICK,this.__sendSubmit);
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
            SocketManager.Instance.out.SendHijackAnswer(this._ownerId,this._hijackerId,this._hijackerName,false);
         }
         this.dispose();
      }
      
      public function show() : void
      {
         var _loc1_:String = null;
         var _loc2_:String = null;
         switch(this._carType)
         {
            case TransportCar.CARI:
               _loc1_ = LanguageMgr.GetTranslation("consortion.ConsortionComfirm.normalCarName.text");
               break;
            case TransportCar.CARII:
               _loc1_ = LanguageMgr.GetTranslation("consortion.ConsortionComfirm.highClassCarName.text");
         }
         if(this._ownerId == PlayerManager.Instance.Self.ID)
         {
            _loc2_ = LanguageMgr.GetTranslation("consortion.ConsortionTransport.alertTips.hijackDescript.my.txt",_loc1_);
         }
         else
         {
            _loc2_ = LanguageMgr.GetTranslation("consortion.ConsortionTransport.alertTips.hijackDescript.txt",_loc1_);
         }
         this._normalTxt.text = this._hijackerName + _loc2_;
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
                  SocketManager.Instance.out.SendHijackAnswer(this._ownerId,this._hijackerId,this._hijackerName,false);
               }
               this.dispose();
               break;
            case FrameEvent.ENTER_CLICK:
            case FrameEvent.SUBMIT_CLICK:
         }
      }
      
      private function __sendSubmit(param1:MouseEvent) : void
      {
         if(!PlayerManager.Instance.Self.Bag.getItemAt(14))
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("consortion.ConsortionTransport.convoyWithoutWeaponError.txt",15));
            return;
         }
         this.checkExpedition();
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
            this.sendAnswer();
         }
      }
      
      private function __confirmResponse(param1:FrameEvent) : void
      {
         var _loc2_:BaseAlerFrame = param1.currentTarget as BaseAlerFrame;
         _loc2_.removeEventListener(FrameEvent.RESPONSE,this.__confirmResponse);
         if(param1.responseCode == FrameEvent.ENTER_CLICK || param1.responseCode == FrameEvent.SUBMIT_CLICK)
         {
            SocketManager.Instance.out.sendExpeditionCancle();
            this.sendAnswer();
         }
         if(param1.responseCode == FrameEvent.CANCEL_CLICK || param1.responseCode == FrameEvent.CLOSE_CLICK || param1.responseCode == FrameEvent.ESC_CLICK)
         {
            SocketManager.Instance.out.SendHijackAnswer(this._ownerId,this._hijackerId,this._hijackerName,false);
            this.dispose();
         }
         ObjectUtils.disposeObject(_loc2_);
      }
      
      private function sendAnswer() : void
      {
         this._fightBtn.enable = false;
         GameManager.Instance.addEventListener(GameManager.START_LOAD,this.__startLoading,false,2);
         if(!this._hasSendAnswer)
         {
            this._hasSendAnswer = true;
            SocketManager.Instance.out.SendHijackAnswer(this._ownerId,this._hijackerId,this._hijackerName,true);
         }
      }
      
      private function __startLoading(param1:Event) : void
      {
         param1.stopImmediatePropagation();
         GameManager.Instance.removeEventListener(GameManager.START_LOAD,this.__startLoading);
         StateManager.getInGame_Step_6 = true;
         this.dispose();
         if(GameManager.Instance.Current == null)
         {
            return;
         }
         LayerManager.Instance.clearnGameDynamic();
         GameManager.Instance.gotoRoomLoading();
         StateManager.getInGame_Step_7 = true;
      }
      
      public function setIdAndName(param1:int, param2:int, param3:int, param4:String) : void
      {
         this._ownerId = param1;
         this._carType = param2;
         this._hijackerId = param3;
         this._hijackerName = param4;
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
         this._fightBtn.removeEventListener(MouseEvent.CLICK,this.__sendSubmit);
      }
      
      override public function dispose() : void
      {
         this._autoDisappearTimer.stop();
         this.removeEvent();
         this._isShowing = false;
         this._autoDisappearTimer = null;
         ObjectUtils.disposeObject(this._normalTxt);
         this._normalTxt = null;
         ObjectUtils.disposeObject(this._timeRemainTxt);
         this._timeRemainTxt = null;
         ObjectUtils.disposeObject(this._fightBtn);
         this._fightBtn = null;
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
         super.dispose();
      }
   }
}
