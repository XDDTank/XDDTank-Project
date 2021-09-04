package fightToolBox.view
{
   import baglocked.BaglockedManager;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.TextArea;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import ddt.manager.LeavePageManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SoundManager;
   import fightToolBox.FightToolBoxController;
   import flash.display.Sprite;
   
   public class YourSelfView extends Sprite implements Disposeable
   {
       
      
      private var _textArea:TextArea;
      
      private var _payNum:int;
      
      private var _level:int;
      
      private var _moneyConfirm:BaseAlerFrame;
      
      private var _confirmFrame:BaseAlerFrame;
      
      public function YourSelfView()
      {
         super();
      }
      
      public function show() : void
      {
         this.visible = true;
      }
      
      public function hide() : void
      {
         this.visible = false;
      }
      
      public function sendOpen(param1:int) : void
      {
         SoundManager.instance.play("008");
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            return;
         }
         switch(param1)
         {
            case 0:
               this._level = FightToolBoxController.instance.model.fightVipTime_high;
               this._payNum = FightToolBoxController.instance.model.fightVipPrice_high;
               break;
            case 1:
               this._level = FightToolBoxController.instance.model.fightVipTime_mid;
               this._payNum = FightToolBoxController.instance.model.fightVipPrice_mid;
               break;
            case 2:
               this._level = FightToolBoxController.instance.model.fightVipTime_low;
               this._payNum = FightToolBoxController.instance.model.fightVipPrice_low;
         }
         if(PlayerManager.Instance.Self.Money < this._payNum)
         {
            this._moneyConfirm = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("tank.view.comon.lack"),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),false,false,false,LayerManager.ALPHA_BLOCKGOUND);
            this._moneyConfirm.moveEnable = false;
            this._moneyConfirm.addEventListener(FrameEvent.RESPONSE,this.__moneyConfirmHandler);
            return;
         }
         var _loc2_:String = LanguageMgr.GetTranslation("FightToolBox.yourselfView.confirmforSelf",this._level,this._payNum);
         this._confirmFrame = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("FightToolBox.ConfirmTitle"),_loc2_,LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),false,true,true,LayerManager.BLCAK_BLOCKGOUND);
         this._confirmFrame.moveEnable = false;
         this._confirmFrame.addEventListener(FrameEvent.RESPONSE,this.__confirm);
      }
      
      private function __moneyConfirmHandler(param1:FrameEvent) : void
      {
         this._moneyConfirm.removeEventListener(FrameEvent.RESPONSE,this.__moneyConfirmHandler);
         switch(param1.responseCode)
         {
            case FrameEvent.ENTER_CLICK:
            case FrameEvent.SUBMIT_CLICK:
               LeavePageManager.leaveToFillPath();
         }
         this._moneyConfirm.dispose();
         if(this._moneyConfirm.parent)
         {
            this._moneyConfirm.parent.removeChild(this._moneyConfirm);
         }
         this._moneyConfirm = null;
      }
      
      private function __confirm(param1:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         this._confirmFrame.removeEventListener(FrameEvent.RESPONSE,this.__confirm);
         switch(param1.responseCode)
         {
            case FrameEvent.SUBMIT_CLICK:
            case FrameEvent.ENTER_CLICK:
               FightToolBoxController.instance.sendOpen(PlayerManager.Instance.Self.NickName,this._level);
         }
         this._confirmFrame.dispose();
         if(this._confirmFrame.parent)
         {
            this._confirmFrame.parent.removeChild(this._confirmFrame);
         }
      }
      
      private function removeView() : void
      {
         if(this._textArea)
         {
            ObjectUtils.disposeObject(this._textArea);
         }
         this._textArea = null;
         if(this._confirmFrame)
         {
            this._confirmFrame.dispose();
         }
         this._confirmFrame = null;
         if(this._moneyConfirm)
         {
            this._moneyConfirm.dispose();
         }
         this._moneyConfirm = null;
      }
      
      public function dispose() : void
      {
         this.removeView();
      }
   }
}
