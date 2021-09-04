package consortion.view.selfConsortia
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.ui.controls.TextButton;
   import com.pickgliss.ui.image.Image;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.ui.Keyboard;
   
   public class ConsortionDisbandFrame extends Frame
   {
       
      
      private var _confirmBtn:TextButton;
      
      private var _cancelBtn:TextButton;
      
      private var _inputTxtBg:Image;
      
      private var _tip:FilterFrameText;
      
      private var _tip2:FilterFrameText;
      
      private var _inputTxt:FilterFrameText;
      
      private var _isYes:Boolean = false;
      
      public function ConsortionDisbandFrame()
      {
         super();
         this.initView();
         this.initEvent();
      }
      
      private function initView() : void
      {
         titleText = LanguageMgr.GetTranslation("AlertDialog.Info");
         this._confirmBtn = ComponentFactory.Instance.creatComponentByStylename("ddtconsortion.combineConfirm.confirmBtn");
         this._confirmBtn.text = LanguageMgr.GetTranslation("ok");
         this._cancelBtn = ComponentFactory.Instance.creatComponentByStylename("ddtconsortion.combineConfirm.cancelBtn");
         this._cancelBtn.text = LanguageMgr.GetTranslation("cancel");
         this._inputTxtBg = ComponentFactory.Instance.creatComponentByStylename("asset.consortion.conmbineConfirm.inputTxtBg");
         this._tip = ComponentFactory.Instance.creatComponentByStylename("ddtconsortion.combineConfirm.tipTxt");
         this._tip2 = ComponentFactory.Instance.creatComponentByStylename("ddtconsortion.combineConfirm.tip2Txt");
         this._tip.text = LanguageMgr.GetTranslation("ddtconsortion.combineConfirm.tip");
         this._tip2.htmlText = LanguageMgr.GetTranslation("ddtconsortion.combineConfirm.tip1");
         this._inputTxt = ComponentFactory.Instance.creatComponentByStylename("ddtconsortion.combineConfirm.inputTxt");
         addToContent(this._confirmBtn);
         addToContent(this._cancelBtn);
         addToContent(this._inputTxtBg);
         addToContent(this._tip);
         addToContent(this._tip2);
         addToContent(this._inputTxt);
      }
      
      private function initEvent() : void
      {
         addEventListener(FrameEvent.RESPONSE,this.__response);
         this._confirmBtn.addEventListener(MouseEvent.CLICK,this.__confirmHandler);
         this._cancelBtn.addEventListener(MouseEvent.CLICK,this.__cancelHandler);
         this._inputTxt.addEventListener(KeyboardEvent.KEY_DOWN,this.__keyDownHandler);
      }
      
      private function __confirmHandler(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         var _loc2_:String = this._inputTxt.text;
         if(_loc2_.toLocaleLowerCase() == "yes")
         {
            SocketManager.Instance.out.sendConsortiaDismiss();
            this.dispose();
            return;
         }
         if(_loc2_ == "")
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("beadSystem.bead.combineConfirm.inputError.tip"));
            return;
         }
         MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("beadSystem.bead.combineConfirm.inputError.tip2"));
      }
      
      private function __cancelHandler(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         this.dispose();
      }
      
      private function __keyDownHandler(param1:KeyboardEvent) : void
      {
         if(param1.keyCode == Keyboard.ENTER)
         {
            this.__confirmHandler(null);
         }
      }
      
      private function __response(param1:FrameEvent) : void
      {
         if(param1.responseCode == FrameEvent.ESC_CLICK || param1.responseCode == FrameEvent.CLOSE_CLICK)
         {
            SoundManager.instance.play("008");
            this.dispose();
         }
      }
      
      public function show() : void
      {
         LayerManager.Instance.addToLayer(this,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
         this._inputTxt.setFocus();
      }
      
      public function setInputTxtFocus() : void
      {
         if(this._inputTxt)
         {
            this._inputTxt.setFocus();
         }
      }
      
      private function removeEvent() : void
      {
         removeEventListener(FrameEvent.RESPONSE,this.__response);
         this._confirmBtn.removeEventListener(MouseEvent.CLICK,this.__confirmHandler);
         this._cancelBtn.removeEventListener(MouseEvent.CLICK,this.__cancelHandler);
         this._inputTxt.removeEventListener(KeyboardEvent.KEY_DOWN,this.__keyDownHandler);
      }
      
      override public function dispose() : void
      {
         this.removeEvent();
         super.dispose();
         if(this._confirmBtn)
         {
            ObjectUtils.disposeObject(this._confirmBtn);
         }
         if(this._cancelBtn)
         {
            ObjectUtils.disposeObject(this._cancelBtn);
         }
         if(this._inputTxtBg)
         {
            ObjectUtils.disposeObject(this._inputTxtBg);
         }
         if(this._tip)
         {
            ObjectUtils.disposeObject(this._tip);
         }
         if(this._tip2)
         {
            ObjectUtils.disposeObject(this._tip2);
         }
         if(this._inputTxt)
         {
            ObjectUtils.disposeObject(this._inputTxt);
         }
         this._confirmBtn = null;
         this._cancelBtn = null;
         this._inputTxtBg = null;
         this._tip = null;
         this._tip2 = null;
         this._inputTxt = null;
         if(this.parent)
         {
            this.parent.removeChild(this);
         }
      }
   }
}
