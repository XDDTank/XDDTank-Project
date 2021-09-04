package fightRobot
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.SelectedCheckButton;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.ui.vo.AlertInfo;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import ddt.manager.ServerConfigManager;
   import ddt.manager.SharedManager;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import flash.events.Event;
   
   public class FightRobotCoolDownConfirmFrame extends BaseAlerFrame
   {
       
      
      private var _tips:FilterFrameText;
      
      private var _notTipAgainBtn:SelectedCheckButton;
      
      public function FightRobotCoolDownConfirmFrame()
      {
         super();
         var _loc1_:AlertInfo = new AlertInfo();
         _loc1_.title = LanguageMgr.GetTranslation("AlertDialog.Info");
         this.info = _loc1_;
         this.initView();
         this.initEvent();
      }
      
      private function initView() : void
      {
         this._tips = ComponentFactory.Instance.creatComponentByStylename("asset.core.alertFrameTxt");
         this._tips.htmlText = LanguageMgr.GetTranslation("ddt.fightrobot.coolDownTxt",ServerConfigManager.instance.getShadowNpcClearCdPrice());
         PositionUtils.setPos(this._tips,"fightrobot.coolDownConfirmTxt.pos");
         this._notTipAgainBtn = ComponentFactory.Instance.creatComponentByStylename("fightrobot.coolDown.notTipAgain");
         this._notTipAgainBtn.text = LanguageMgr.GetTranslation("ddt.farms.refreshPetsNOAlert");
         addToContent(this._tips);
         addToContent(this._notTipAgainBtn);
      }
      
      private function initEvent() : void
      {
         addEventListener(FrameEvent.RESPONSE,this.__framePesponse);
         this._notTipAgainBtn.addEventListener(Event.SELECT,this.__noAlertTip);
      }
      
      private function removeEvent() : void
      {
         removeEventListener(FrameEvent.RESPONSE,this.__framePesponse);
      }
      
      private function __noAlertTip(param1:Event) : void
      {
         SoundManager.instance.play("008");
         SharedManager.Instance.coolDownFightRobot = this._notTipAgainBtn.selected;
         SharedManager.Instance.save();
      }
      
      private function __framePesponse(param1:FrameEvent) : void
      {
         removeEventListener(FrameEvent.RESPONSE,this.__framePesponse);
         SoundManager.instance.play("008");
         this.dispose();
      }
      
      override public function dispose() : void
      {
         ObjectUtils.disposeObject(this._tips);
         this._tips = null;
         ObjectUtils.disposeObject(this._notTipAgainBtn);
         this._notTipAgainBtn = null;
         super.dispose();
      }
   }
}
