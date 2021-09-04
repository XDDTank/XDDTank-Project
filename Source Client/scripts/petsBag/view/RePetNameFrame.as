package petsBag.view
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.toplevel.StageReferance;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.ui.vo.AlertInfo;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import ddt.manager.SoundManager;
   import ddt.utils.FilterWordManager;
   import flash.display.DisplayObject;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import road7th.utils.StringHelper;
   
   public class RePetNameFrame extends BaseAlerFrame
   {
       
      
      protected var _inputBackground:DisplayObject;
      
      private var _alertInfo:AlertInfo;
      
      private var _inputText:FilterFrameText;
      
      private var _inputLbl:FilterFrameText;
      
      private var _petName:String = "";
      
      public function RePetNameFrame()
      {
         super();
         this.initView();
         this.initEvent();
      }
      
      public function get petName() : String
      {
         return this._petName;
      }
      
      private function initView() : void
      {
         this._alertInfo = new AlertInfo(LanguageMgr.GetTranslation("ddt.pets.rePetNameTitle"),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"));
         this._alertInfo.moveEnable = false;
         info = this._alertInfo;
         this.escEnable = true;
         this._inputBackground = ComponentFactory.Instance.creat("petsBag.repetName.inputBG");
         this._inputText = ComponentFactory.Instance.creat("petsBag.text.inputPetName");
         addToContent(this._inputBackground);
         addToContent(this._inputText);
         this._inputLbl = ComponentFactory.Instance.creat("petsBag.text.inputPetNameLbl");
         this._inputLbl.text = LanguageMgr.GetTranslation("ddt.pets.reInputPetName");
         addToContent(this._inputLbl);
      }
      
      private function initEvent() : void
      {
         this._inputText.addEventListener(Event.CHANGE,this.__inputChange);
      }
      
      private function removeEvent() : void
      {
         this._inputText.removeEventListener(Event.CHANGE,this.__inputChange);
      }
      
      override protected function __onSubmitClick(param1:MouseEvent) : void
      {
         param1.stopImmediatePropagation();
         SoundManager.instance.play("008");
         if(this.nameInputCheck())
         {
            this._petName = this._inputText.text;
            super.__onSubmitClick(param1);
            return;
         }
      }
      
      private function __inputChange(param1:Event) : void
      {
         StringHelper.checkTextFieldLength(this._inputText,10);
      }
      
      private function getStrActualLen(param1:String) : int
      {
         return param1.replace(/[^\x00-\xff]/g,"xx").length;
      }
      
      private function nameInputCheck() : Boolean
      {
         var _loc1_:BaseAlerFrame = null;
         if(this._inputText.text != "")
         {
            if(FilterWordManager.isGotForbiddenWords(this._inputText.text,"name"))
            {
               _loc1_ = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("choosecharacter.ChooseCharacterView.name"),LanguageMgr.GetTranslation("ok"),"",false,false,false,LayerManager.ALPHA_BLOCKGOUND);
               _loc1_.addEventListener(FrameEvent.RESPONSE,this.__onAlertResponse);
               return false;
            }
            if(FilterWordManager.IsNullorEmpty(this._inputText.text))
            {
               _loc1_ = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("choosecharacter.ChooseCharacterView.space"),LanguageMgr.GetTranslation("ok"),"",false,false,false,LayerManager.ALPHA_BLOCKGOUND);
               _loc1_.addEventListener(FrameEvent.RESPONSE,this.__onAlertResponse);
               return false;
            }
            if(FilterWordManager.containUnableChar(this._inputText.text))
            {
               _loc1_ = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("choosecharacter.ChooseCharacterView.string"),LanguageMgr.GetTranslation("ok"),"",false,false,false,LayerManager.ALPHA_BLOCKGOUND);
               _loc1_.addEventListener(FrameEvent.RESPONSE,this.__onAlertResponse);
               return false;
            }
            return true;
         }
         _loc1_ = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("choosecharacter.ChooseCharacterView.input"),LanguageMgr.GetTranslation("ok"),"",false,false,false,LayerManager.ALPHA_BLOCKGOUND);
         _loc1_.addEventListener(FrameEvent.RESPONSE,this.__onAlertResponse);
         return false;
      }
      
      protected function __onAlertResponse(param1:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         var _loc2_:BaseAlerFrame = param1.currentTarget as BaseAlerFrame;
         _loc2_.removeEventListener(FrameEvent.RESPONSE,this.__onAlertResponse);
         switch(param1.responseCode)
         {
            case FrameEvent.ESC_CLICK:
            case FrameEvent.ENTER_CLICK:
            case FrameEvent.SUBMIT_CLICK:
            case FrameEvent.CANCEL_CLICK:
            case FrameEvent.CLOSE_CLICK:
               _loc2_.dispose();
         }
         StageReferance.stage.focus = this._inputText;
      }
      
      public function show() : void
      {
         LayerManager.Instance.addToLayer(this,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
      }
      
      override public function dispose() : void
      {
         this.removeEvent();
         ObjectUtils.disposeObject(this._inputLbl);
         this._inputLbl = null;
         if(this._inputText)
         {
            ObjectUtils.disposeObject(this._inputText);
            this._inputText = null;
         }
         if(this._inputBackground)
         {
            ObjectUtils.disposeObject(this._inputBackground);
            this._inputBackground = null;
         }
         ObjectUtils.disposeAllChildren(this);
         this._petName = "";
         super.dispose();
      }
   }
}
