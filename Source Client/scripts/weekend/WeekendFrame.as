package weekend
{
   import baglocked.BaglockedManager;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.image.Scale9CornerImage;
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
   import flash.events.MouseEvent;
   
   public class WeekendFrame extends Frame
   {
       
      
      private var _bg:Scale9CornerImage;
      
      private var _bgNormal:Bitmap;
      
      private var _bgMoney:Bitmap;
      
      private var _movieNormal:MovieClip;
      
      private var _movieMoney:MovieClip;
      
      private var _btnNormal:BaseButton;
      
      private var _btnMoney:BaseButton;
      
      private var _txtNormal:FilterFrameText;
      
      private var _txtMoney:FilterFrameText;
      
      private var _clickMovieNormal:MovieClip;
      
      private var _clickMovieMoney:MovieClip;
      
      private var _moneyAlert:BaseAlerFrame;
      
      public function WeekendFrame()
      {
         super();
         this.initView();
         this.initEvent();
      }
      
      private function initView() : void
      {
         titleText = LanguageMgr.GetTranslation("ddt.weekend.frame.title");
         _helpButton = ComponentFactory.Instance.creat("weekend.WeekendFrame.helpBtn");
         addToContent(_helpButton);
         this._bg = ComponentFactory.Instance.creatComponentByStylename("weekend.WeekendFrame.bg");
         addToContent(this._bg);
         this._bgNormal = ComponentFactory.Instance.creatBitmap("ddt.weekend.getBgNormal");
         addToContent(this._bgNormal);
         this._bgMoney = ComponentFactory.Instance.creatBitmap("ddt.weekend.getBgMoney");
         addToContent(this._bgMoney);
         this._movieNormal = ComponentFactory.Instance.creat("ddt.weekend.movieNormal") as MovieClip;
         PositionUtils.setPos(this._movieNormal,"ddt.weekend.WeekendFrame.movieNormalPos");
         addToContent(this._movieNormal);
         this._movieMoney = ComponentFactory.Instance.creat("ddt.weekend.movieMoney") as MovieClip;
         PositionUtils.setPos(this._movieMoney,"ddt.weekend.WeekendFrame.movieMoneyPos");
         addToContent(this._movieMoney);
         this._btnNormal = ComponentFactory.Instance.creatComponentByStylename("weekend.WeekendFrame.getBtnNormal");
         addToContent(this._btnNormal);
         this._btnMoney = ComponentFactory.Instance.creatComponentByStylename("weekend.WeekendFrame.getBtnMoney");
         addToContent(this._btnMoney);
         this._txtNormal = ComponentFactory.Instance.creatComponentByStylename("weekend.WeekendFrame.txtNormal");
         this._txtNormal.text = WeekendManager.instance.getNormalEnergy().toString();
         addToContent(this._txtNormal);
         this._txtMoney = ComponentFactory.Instance.creatComponentByStylename("weekend.WeekendFrame.txtMoney");
         this._txtMoney.text = WeekendManager.instance.getMoneyEnergy().toString();
         addToContent(this._txtMoney);
         this._clickMovieNormal = ComponentFactory.Instance.creat("ddt.weekend.clickMovieNormal") as MovieClip;
         PositionUtils.setPos(this._clickMovieNormal,"ddt.weekend.WeekendFrame.clickmovieNormalPos");
         this._clickMovieNormal.gotoAndStop(1);
         this._clickMovieNormal.visible = false;
         addToContent(this._clickMovieNormal);
         this._clickMovieMoney = ComponentFactory.Instance.creat("ddt.weekend.clickMovieMoney") as MovieClip;
         PositionUtils.setPos(this._clickMovieMoney,"ddt.weekend.WeekendFrame.clickmovieMoneyPos");
         this._clickMovieMoney.gotoAndStop(1);
         this._clickMovieMoney.visible = false;
         addToContent(this._clickMovieMoney);
      }
      
      private function clickMovieNormalDone() : void
      {
         this._clickMovieNormal.gotoAndStop(1);
         this._clickMovieNormal.visible = false;
         this.dispose();
      }
      
      private function clickMovieMoneyDone() : void
      {
         this._clickMovieMoney.gotoAndStop(1);
         this._clickMovieMoney.visible = false;
         this.dispose();
      }
      
      private function initEvent() : void
      {
         addEventListener(FrameEvent.RESPONSE,this.__frameEvent);
         this._clickMovieNormal.addFrameScript(this._clickMovieNormal.totalFrames - 1,this.clickMovieNormalDone);
         this._clickMovieMoney.addFrameScript(this._clickMovieMoney.totalFrames - 1,this.clickMovieMoneyDone);
         this._btnNormal.addEventListener(MouseEvent.CLICK,this.__clickNormal);
         this._btnMoney.addEventListener(MouseEvent.CLICK,this.__clickMoeny);
         _helpButton.addEventListener(MouseEvent.CLICK,this.__helpClick);
      }
      
      private function __clickNormal(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(!(this._clickMovieNormal.isPlaying || this._clickMovieMoney.isPlaying))
         {
            if(PlayerManager.Instance.Self.returnEnergy > 0)
            {
               this._clickMovieNormal.gotoAndPlay(1);
               this._clickMovieNormal.visible = true;
               WeekendManager.instance.sendSocket(false);
            }
            else
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.weekend.frame.noenergy"));
            }
         }
      }
      
      private function __clickMoeny(param1:MouseEvent) : void
      {
         var _loc2_:Number = NaN;
         SoundManager.instance.play("008");
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            return;
         }
         if(PlayerManager.Instance.Self.returnEnergy <= 0)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.weekend.frame.noenergy"));
         }
         else
         {
            _loc2_ = int(this._txtMoney.text) * WeekendManager.instance.getNeedMoney();
            _loc2_ = Math.max(_loc2_,1);
            this._moneyAlert = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("ddt.weekend.frame.moneyNotice",int(_loc2_)),LanguageMgr.GetTranslation("yes"),LanguageMgr.GetTranslation("no"),false,true,true,LayerManager.BLCAK_BLOCKGOUND);
            this._moneyAlert.addEventListener(FrameEvent.RESPONSE,this.__moneyAlertResponse);
         }
      }
      
      protected function __moneyAlertResponse(param1:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         this._moneyAlert.removeEventListener(FrameEvent.RESPONSE,this.__moneyAlertResponse);
         this._moneyAlert.dispose();
         switch(param1.responseCode)
         {
            case FrameEvent.ENTER_CLICK:
            case FrameEvent.SUBMIT_CLICK:
               if(!(this._clickMovieNormal.isPlaying || this._clickMovieMoney.isPlaying))
               {
                  if(PlayerManager.Instance.Self.totalMoney < int(int(this._txtMoney.text) * WeekendManager.instance.getNeedMoney()))
                  {
                     LeavePageManager.showFillFrame();
                  }
                  else
                  {
                     this._clickMovieMoney.gotoAndPlay(1);
                     this._clickMovieMoney.visible = true;
                     WeekendManager.instance.sendSocket(true);
                  }
               }
         }
      }
      
      private function __frameEvent(param1:FrameEvent) : void
      {
         var _loc2_:WeekendHelpFrame = null;
         SoundManager.instance.play("008");
         switch(param1.responseCode)
         {
            case FrameEvent.CLOSE_CLICK:
            case FrameEvent.ESC_CLICK:
               WeekendManager.instance.hide();
               break;
            case FrameEvent.HELP_CLICK:
               _loc2_ = ComponentFactory.Instance.creat("weekendframe.HelpFrame");
               _loc2_.setView(ComponentFactory.Instance.creat("ddt.weekend.HelpFrameText"),"ddt.weekend.WeekendFrame.helpPos");
               _loc2_.show();
         }
      }
      
      private function __helpClick(param1:MouseEvent) : void
      {
         onResponse(FrameEvent.HELP_CLICK);
      }
      
      private function removeEvent() : void
      {
         removeEventListener(FrameEvent.RESPONSE,this.__frameEvent);
         this._clickMovieNormal.addFrameScript(this._clickMovieNormal.totalFrames - 1,null);
         this._clickMovieMoney.addFrameScript(this._clickMovieMoney.totalFrames - 1,null);
         this._btnNormal.removeEventListener(MouseEvent.CLICK,this.__clickNormal);
         this._btnMoney.removeEventListener(MouseEvent.CLICK,this.__clickMoeny);
         _helpButton.removeEventListener(MouseEvent.CLICK,this.__helpClick);
      }
      
      private function removeView() : void
      {
         ObjectUtils.disposeObject(this._movieNormal);
         this._movieNormal = null;
         ObjectUtils.disposeObject(this._movieMoney);
         this._movieMoney = null;
         ObjectUtils.disposeObject(this._btnMoney);
         this._btnMoney = null;
         ObjectUtils.disposeObject(this._btnNormal);
         this._btnNormal = null;
         ObjectUtils.disposeObject(this._bgNormal);
         this._bgNormal = null;
         ObjectUtils.disposeObject(this._bgMoney);
         this._bgMoney = null;
         ObjectUtils.disposeObject(this._bg);
         this._bg = null;
         ObjectUtils.disposeObject(this._txtNormal);
         this._txtNormal = null;
         ObjectUtils.disposeObject(this._txtMoney);
         this._txtMoney = null;
         ObjectUtils.disposeObject(this._clickMovieNormal);
         this._clickMovieNormal = null;
         ObjectUtils.disposeObject(this._clickMovieMoney);
         this._clickMovieMoney = null;
         ObjectUtils.disposeObject(_helpButton);
         _helpButton = null;
      }
      
      override public function dispose() : void
      {
         this.removeEvent();
         this.removeView();
         super.dispose();
      }
   }
}
