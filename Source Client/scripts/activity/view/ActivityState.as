package activity.view
{
   import activity.ActivityController;
   import activity.ActivityEvent;
   import activity.data.ActivityChildTypes;
   import activity.data.ActivityInfo;
   import activity.data.ActivityTypes;
   import activity.view.goodsExchange.GoodsExchangeView;
   import baglocked.BaglockedManager;
   import calendar.CalendarEvent;
   import calendar.view.ICalendar;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.loader.BaseLoader;
   import com.pickgliss.loader.LoaderEvent;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.controls.ScrollPanel;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.controls.container.VBox;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import ddt.manager.LeavePageManager;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import flash.display.Bitmap;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   
   public class ActivityState extends Sprite implements ICalendar
   {
      
      public static const PICC_PRICE:int = 10000;
      
      public static const MC_DEFAULT:int = 0;
      
      public static const MC_OPEN_COMMON_ONCE:int = 1;
      
      public static const MC_GUILD:int = 2;
      
      public static const MC_DIVORCE:int = 3;
      
      public static const MC_POWER:int = 4;
      
      public static const MC_LEVEL:int = 5;
      
      public static const MC_CHARGE:int = 6;
      
      public static const MC_COST:int = 7;
      
      public static const MC_TUAN:int = 8;
       
      
      private var _titleField:FilterFrameText;
      
      private var _getButton:BaseButton;
      
      private var _exchangeButton:BaseButton;
      
      private var _piccBtn:BaseButton;
      
      private var _activityInfo:ActivityInfo;
      
      private var _back:Bitmap;
      
      private var _scrollList:ScrollPanel;
      
      private var _content:VBox;
      
      private var _detailview:ActivityDetail;
      
      private var _goodsExchangeNew:GoodsExchangeView;
      
      private var _backMC:MovieClip;
      
      private var _getAwardTimer:Timer;
      
      public function ActivityState()
      {
         super();
         this.configUI();
         this.addEvent();
      }
      
      private function configUI() : void
      {
         this._back = ComponentFactory.Instance.creatBitmap("ddtcalendar.ActivityStateBg");
         addChild(this._back);
         this._backMC = ComponentFactory.Instance.creat("ddtactivity.activitystate.openBgMC");
         this._backMC.visible = false;
         this._backMC.gotoAndStop(MC_OPEN_COMMON_ONCE);
         PositionUtils.setPos(this._backMC,"ddtactivity.activitystate.openBg.MC.pos");
         addChild(this._backMC);
         this._titleField = ComponentFactory.Instance.creatComponentByStylename("ddtcalendar.ActivityStateTitleField");
         addChild(this._titleField);
         this._detailview = ComponentFactory.Instance.creatCustomObject("ddtcalendar.ActivityDetailNew");
         this._getButton = ComponentFactory.Instance.creatComponentByStylename("ddtcalendar.ActivityState.GetButton");
         this._getButton.visible = false;
         addChild(this._getButton);
         this._exchangeButton = ComponentFactory.Instance.creatComponentByStylename("ddtcalendar.ActivityState.exchangeButton");
         this._exchangeButton.visible = false;
         addChild(this._exchangeButton);
         this._piccBtn = ComponentFactory.Instance.creatComponentByStylename("ddtcalendar.ActivityState.PiccBtn");
         addChild(this._piccBtn);
         this._content = ComponentFactory.Instance.creatComponentByStylename("ddtcalendar.ActivityState.Vbox");
         this._content.addChild(this._detailview);
         this._scrollList = ComponentFactory.Instance.creatComponentByStylename("ddtcalendar.ActivityDetailList");
         this._scrollList.setView(this._content);
         addChild(this._scrollList);
      }
      
      private function addEvent() : void
      {
         this._getButton.addEventListener(MouseEvent.CLICK,this.__getAward);
         this._exchangeButton.addEventListener(MouseEvent.CLICK,this.__exchange);
         this._piccBtn.addEventListener(MouseEvent.CLICK,this.__piccHandler);
         ActivityController.instance.model.addEventListener(ActivityEvent.BUTTON_CHANGE,this.updateBtnState);
         ActivityController.instance.model.addEventListener(ActivityEvent.GET_RAWARD,this.__getReward);
      }
      
      protected function __piccHandler(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            return;
         }
         var _loc2_:BaseAlerFrame = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("ActivityState.confirm.content",PICC_PRICE),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),false,false,false,LayerManager.ALPHA_BLOCKGOUND);
         _loc2_.moveEnable = false;
         _loc2_.addEventListener(FrameEvent.RESPONSE,this.__responseHandler);
      }
      
      protected function __responseHandler(param1:FrameEvent) : void
      {
         var _loc3_:BaseAlerFrame = null;
         var _loc2_:BaseAlerFrame = param1.currentTarget as BaseAlerFrame;
         _loc2_.removeEventListener(FrameEvent.RESPONSE,this.__responseHandler);
         if(param1.responseCode == FrameEvent.ENTER_CLICK || param1.responseCode == FrameEvent.SUBMIT_CLICK)
         {
            _loc3_ = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("poorNote"),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),false,false,false,LayerManager.BLCAK_BLOCKGOUND);
            _loc3_.moveEnable = false;
            _loc3_.addEventListener(FrameEvent.RESPONSE,this.__poorManResponse);
         }
         ObjectUtils.disposeObject(_loc2_);
      }
      
      private function __poorManResponse(param1:FrameEvent) : void
      {
         var _loc2_:BaseAlerFrame = param1.currentTarget as BaseAlerFrame;
         _loc2_.removeEventListener(FrameEvent.RESPONSE,this.__poorManResponse);
         if(param1.responseCode == FrameEvent.ENTER_CLICK || param1.responseCode == FrameEvent.SUBMIT_CLICK)
         {
            LeavePageManager.leaveToFillPath();
         }
         ObjectUtils.disposeObject(_loc2_);
      }
      
      public function __getReward(param1:ActivityEvent) : void
      {
         var _loc2_:Object = param1.data;
         if(_loc2_["ID"] == this._activityInfo.ActivityId)
         {
            this.sendSocket(_loc2_);
         }
      }
      
      private function __getAward(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         this.sendSocket();
      }
      
      private function sendSocket(param1:Object = null) : void
      {
         var _loc2_:BaseLoader = null;
         var _loc3_:BaseAlerFrame = null;
         if(!this._getAwardTimer)
         {
            this._getAwardTimer = new Timer(2000,1);
            this._getAwardTimer.addEventListener(TimerEvent.TIMER_COMPLETE,this.__getAwardTimerComplete);
            this._getAwardTimer.start();
         }
         else if(this._getAwardTimer.running)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.activityState.getAward.click"));
            return;
         }
         if(!ActivityController.instance.isInValidOpenDate(this._activityInfo))
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.calendar.ActivityDetail.hasnotbegin"));
            return;
         }
         if(this._activityInfo)
         {
            if((ActivityController.instance.checkOpenActivity(this._activityInfo) || ActivityController.instance.checkMouthActivity(this._activityInfo)) && ActivityController.instance.isInValidShowDate(this._activityInfo) || ActivityController.instance.checkChargeReward(this._activityInfo) || ActivityController.instance.checkCostReward(this._activityInfo))
            {
               if(ActivityController.instance.checkMouthActivity(this._activityInfo))
               {
                  if(!ActivityController.instance.checkCondition(this._activityInfo))
                  {
                     return;
                  }
               }
               ActivityController.instance.getActivityAward(this._activityInfo,param1);
            }
            else
            {
               if(this._detailview.getInputField().text == "" && (this._activityInfo.ActivityType == ActivityTypes.RELEASE && this._activityInfo.ActivityChildType == ActivityChildTypes.NUMBER_ACTIVE))
               {
                  _loc3_ = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("tank.movement.MovementRightView.pass"),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),true,false,false,2);
                  _loc3_.info.showCancel = false;
                  return;
               }
               _loc2_ = ActivityController.instance.reciveActivityAward(this._activityInfo,this._detailview.getInputField().text);
               _loc2_.addEventListener(LoaderEvent.LOAD_ERROR,this.__onLoadError);
               _loc2_.addEventListener(LoaderEvent.COMPLETE,this.__activityLoadComplete);
               this._detailview.getInputField().text = "";
            }
         }
      }
      
      private function __getAwardTimerComplete(param1:TimerEvent) : void
      {
         this._getAwardTimer.stop();
         this._getAwardTimer.removeEventListener(TimerEvent.TIMER_COMPLETE,this.__getAwardTimerComplete);
         this._getAwardTimer = null;
      }
      
      private function __exchange(param1:MouseEvent) : void
      {
         SoundManager.instance.playButtonSound();
         if(!this._getAwardTimer)
         {
            this._getAwardTimer = new Timer(2000,1);
            this._getAwardTimer.addEventListener(TimerEvent.TIMER_COMPLETE,this.__getAwardTimerComplete);
            this._getAwardTimer.start();
         }
         else if(this._getAwardTimer.running)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.activityState.getAward.click"));
            return;
         }
         if(!ActivityController.instance.isInValidOpenDate(this._activityInfo))
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.calendar.ActivityDetail.hasnotbegin"));
            return;
         }
         this._goodsExchangeNew.sendGoods();
      }
      
      private function __activityLoadComplete(param1:LoaderEvent) : void
      {
         var _loc2_:BaseLoader = param1.currentTarget as BaseLoader;
         _loc2_.removeEventListener(LoaderEvent.LOAD_ERROR,this.__onLoadError);
         _loc2_.removeEventListener(LoaderEvent.COMPLETE,this.__activityLoadComplete);
      }
      
      private function __onLoadError(param1:LoaderEvent) : void
      {
         var _loc2_:BaseLoader = param1.currentTarget as BaseLoader;
         _loc2_.removeEventListener(LoaderEvent.LOAD_ERROR,this.__onLoadError);
         _loc2_.removeEventListener(LoaderEvent.COMPLETE,this.__activityLoadComplete);
      }
      
      public function updataData() : void
      {
         this.setData(this._activityInfo);
      }
      
      public function setData(param1:* = null) : void
      {
         this._activityInfo = param1 as ActivityInfo;
         if(this._activityInfo)
         {
            this.visible = true;
            this._getButton.visible = true;
            this._getButton.enable = true;
            this._piccBtn.visible = false;
            this._titleField.text = this._activityInfo.ActivityName;
            if(this._activityInfo.ActivityType == ActivityTypes.CONVERT)
            {
               this.hideDetailViewNew();
               this.showGoodsExchangeViewNew();
            }
            else
            {
               this.hideGoodsExchangeViewNew();
               this.showDetailViewNew();
               if(this._activityInfo.ActivityType == ActivityTypes.CHARGE || this._activityInfo.ActivityType == ActivityTypes.COST || this._activityInfo.ActivityType == ActivityTypes.BEAD || this._activityInfo.ActivityType == ActivityTypes.PET || this._activityInfo.ActivityType == ActivityTypes.MARRIED && (this._activityInfo.ActivityChildType == ActivityChildTypes.WEDDINGS || this._activityInfo.ActivityChildType == ActivityChildTypes.WEDDING))
               {
                  this._getButton.visible = false;
               }
               else if(ActivityController.instance.checkMouthActivity(this._activityInfo))
               {
                  if(!ActivityController.instance.checkCondition(this._activityInfo))
                  {
                     this._getButton.enable = false;
                  }
               }
               if(this._getButton.enable && ActivityController.instance.checkFinish(this._activityInfo))
               {
                  this._getButton.enable = false;
               }
            }
            if(ActivityController.instance.checkOpenActivity(this._activityInfo))
            {
               this._backMC.visible = true;
               this._back.visible = false;
               this._titleField.visible = false;
               this.setMCFrame();
               this.updateBtnState(null);
            }
            else if(ActivityController.instance.checkChargeReward(this._activityInfo) || ActivityController.instance.checkCostReward(this._activityInfo))
            {
               this._backMC.visible = true;
               this._back.visible = false;
               this._titleField.visible = false;
               this.setMCFrame();
            }
            else if(ActivityController.instance.checkTuan(this._activityInfo))
            {
               this._backMC.visible = true;
               this._back.visible = false;
               this._titleField.visible = false;
               this._getButton.visible = false;
               this.setMCFrame();
            }
            else
            {
               this._backMC.visible = false;
               this._back.visible = true;
               this._titleField.visible = true;
            }
            if(ActivityController.instance.checkCostReward(this._activityInfo) || ActivityController.instance.checkChargeReward(this._activityInfo))
            {
               this._scrollList.height = 420;
            }
            else
            {
               this._scrollList.height = 350;
            }
         }
         else
         {
            this._piccBtn.visible = false;
            this._getButton.visible = false;
            this.visible = false;
         }
         this._scrollList.invalidateViewport();
      }
      
      private function updateBtnState(param1:ActivityEvent) : void
      {
         if(ActivityController.instance.checkOpenLove(this._activityInfo) || this._activityInfo.ActivityType == ActivityTypes.BEAD || this._activityInfo.ActivityType == ActivityTypes.PET)
         {
            this._getButton.visible = false;
         }
         else
         {
            this._getButton.visible = true;
            if(this._detailview.checkGetEnable())
            {
               this._getButton.enable = true;
            }
            else
            {
               this._getButton.enable = false;
            }
         }
      }
      
      private function showGoodsExchangeViewNew() : void
      {
         if(!this._goodsExchangeNew)
         {
            this._goodsExchangeNew = new GoodsExchangeView();
            this._goodsExchangeNew.addEventListener(CalendarEvent.ExchangeGoodsChange,this.__ExchangeGoodsChangeHandler);
            this._content.addChild(this._goodsExchangeNew);
         }
         this._goodsExchangeNew.info = this._activityInfo;
         this._exchangeButton.visible = true;
      }
      
      private function hideGoodsExchangeViewNew() : void
      {
         if(this._goodsExchangeNew)
         {
            this._exchangeButton.visible = false;
            this._goodsExchangeNew.removeEventListener(CalendarEvent.ExchangeGoodsChange,this.__ExchangeGoodsChangeHandler);
            ObjectUtils.disposeObject(this._goodsExchangeNew);
            this._goodsExchangeNew = null;
         }
      }
      
      private function __ExchangeGoodsChangeHandler(param1:CalendarEvent) : void
      {
         if(param1.enable == false)
         {
            this._exchangeButton.enable = false;
         }
         else
         {
            this._exchangeButton.enable = true;
         }
      }
      
      private function showDetailViewNew() : void
      {
         if(!this._detailview)
         {
            this._detailview = new ActivityDetail();
            this._content.addChild(this._detailview);
         }
         this._detailview.setData(this._activityInfo);
         this._getButton.visible = true;
         this._content.height = this._detailview.height;
      }
      
      private function setMCFrame() : void
      {
         var _loc1_:int = 0;
         if(ActivityController.instance.checkTotalMoeny(this._activityInfo))
         {
            _loc1_ = MC_OPEN_COMMON_ONCE;
         }
         else if(ActivityController.instance.checkOpenConsortiaLevel(this._activityInfo))
         {
            _loc1_ = MC_GUILD;
         }
         else if(ActivityController.instance.checkOpenLove(this._activityInfo))
         {
            _loc1_ = MC_DIVORCE;
         }
         else if(ActivityController.instance.checkOpenLevel(this._activityInfo))
         {
            _loc1_ = MC_LEVEL;
         }
         else if(ActivityController.instance.checkOpenFight(this._activityInfo))
         {
            _loc1_ = MC_POWER;
         }
         else if(ActivityController.instance.checkChargeReward(this._activityInfo))
         {
            _loc1_ = MC_CHARGE;
         }
         else if(ActivityController.instance.checkCostReward(this._activityInfo))
         {
            _loc1_ = MC_COST;
         }
         else if(ActivityController.instance.checkTuan(this._activityInfo))
         {
            _loc1_ = MC_TUAN;
         }
         this._backMC.gotoAndStop(_loc1_);
      }
      
      private function hideDetailViewNew() : void
      {
         if(this._detailview)
         {
            ObjectUtils.disposeObject(this._detailview);
            this._detailview = null;
         }
         this._getButton.visible = false;
      }
      
      private function removeEvent() : void
      {
         this._getButton.removeEventListener(MouseEvent.CLICK,this.__getAward);
         this._exchangeButton.removeEventListener(MouseEvent.CLICK,this.__exchange);
         this._piccBtn.removeEventListener(MouseEvent.CLICK,this.__piccHandler);
         ActivityController.instance.model.removeEventListener(ActivityEvent.BUTTON_CHANGE,this.updateBtnState);
         ActivityController.instance.model.removeEventListener(ActivityEvent.GET_RAWARD,this.__getReward);
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         ObjectUtils.disposeObject(this._back);
         this._back = null;
         ObjectUtils.disposeObject(this._piccBtn);
         this._piccBtn = null;
         ObjectUtils.disposeObject(this._titleField);
         this._titleField = null;
         ObjectUtils.disposeObject(this._getButton);
         this._getButton = null;
         ObjectUtils.disposeObject(this._exchangeButton);
         this._exchangeButton = null;
         ObjectUtils.disposeObject(this._scrollList);
         this._scrollList = null;
         if(parent)
         {
            parent.removeChild(this);
         }
         if(this._goodsExchangeNew)
         {
            ObjectUtils.disposeObject(this._goodsExchangeNew);
            this._goodsExchangeNew = null;
         }
         if(this._getAwardTimer)
         {
            this._getAwardTimer.stop();
            this._getAwardTimer.removeEventListener(TimerEvent.TIMER_COMPLETE,this.__getAwardTimerComplete);
            this._getAwardTimer = null;
         }
      }
   }
}
