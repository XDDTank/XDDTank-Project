package worldboss.view
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.SelectedCheckButton;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.ui.vo.AlertInfo;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import ddt.manager.SharedManager;
   import ddt.manager.SoundManager;
   import flash.events.Event;
   import worldboss.WorldBossManager;
   
   public class WorldBossBuyBuffConfirmFrame extends BaseAlerFrame
   {
       
      
      protected var _alertTips:FilterFrameText;
      
      protected var _alertTips2:FilterFrameText;
      
      protected var _buyBtn:SelectedCheckButton;
      
      public function WorldBossBuyBuffConfirmFrame()
      {
         super();
         var _loc1_:AlertInfo = new AlertInfo();
         _loc1_.title = LanguageMgr.GetTranslation("worldboss.buyBuff.confirmFrame.title");
         _loc1_.bottomGap = 15;
         _loc1_.buttonGape = 65;
         this.info = _loc1_;
         this.initView();
         this.initEvent();
      }
      
      protected function initView() : void
      {
         this._alertTips = ComponentFactory.Instance.creatComponentByStylename("worldboss.buyBuffFrame.text");
         addToContent(this._alertTips);
         this._alertTips2 = ComponentFactory.Instance.creatComponentByStylename("worldboss.buyBuffFrame.text2");
         addToContent(this._alertTips2);
         this._alertTips2.text = "";
         this._buyBtn = ComponentFactory.Instance.creatComponentByStylename("worldboss.buyBuffFrame.selectBtn");
         addToContent(this._buyBtn);
         this._buyBtn.text = LanguageMgr.GetTranslation("worldboss.buyBuff.confirmFrame.noAlert");
      }
      
      public function show(param1:int = 1) : void
      {
         var _loc2_:int = WorldBossManager.Instance.bossInfo.addInjureBuffMoney;
         var _loc3_:int = WorldBossManager.Instance.bossInfo.addInjureValue;
         if(param1 == 1)
         {
            this._alertTips.text = LanguageMgr.GetTranslation("worldboss.buyBuff.confirmFrame.desc",_loc2_,_loc3_);
         }
         else
         {
            this._alertTips.text = LanguageMgr.GetTranslation("worldboss.buyBuff.confirmFrame.desc2",_loc2_,_loc3_);
         }
         LayerManager.Instance.addToLayer(this,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
      }
      
      protected function initEvent() : void
      {
         addEventListener(FrameEvent.RESPONSE,this.__framePesponse);
         this._buyBtn.addEventListener(Event.SELECT,this.__noAlertTip);
      }
      
      protected function __noAlertTip(param1:Event) : void
      {
         SoundManager.instance.play("008");
         SharedManager.Instance.isWorldBossBuyBuff = this._buyBtn.selected;
         SharedManager.Instance.save();
      }
      
      protected function __framePesponse(param1:FrameEvent) : void
      {
         removeEventListener(FrameEvent.RESPONSE,this.__framePesponse);
         SoundManager.instance.play("008");
         switch(param1.responseCode)
         {
            case FrameEvent.CLOSE_CLICK:
            case FrameEvent.ESC_CLICK:
               this.dispose();
               break;
            case FrameEvent.ENTER_CLICK:
            case FrameEvent.SUBMIT_CLICK:
               WorldBossManager.Instance.buyNewBuff();
         }
         this.dispose();
      }
      
      protected function removeEvent() : void
      {
         removeEventListener(FrameEvent.RESPONSE,this.__framePesponse);
      }
      
      override public function dispose() : void
      {
         if(this._buyBtn)
         {
            ObjectUtils.disposeObject(this._buyBtn);
            this._buyBtn = null;
         }
         if(this._alertTips2)
         {
            ObjectUtils.disposeObject(this._alertTips2);
            this._alertTips2 = null;
         }
         if(this._alertTips)
         {
            ObjectUtils.disposeObject(this._alertTips);
            this._alertTips = null;
         }
         super.dispose();
      }
   }
}
