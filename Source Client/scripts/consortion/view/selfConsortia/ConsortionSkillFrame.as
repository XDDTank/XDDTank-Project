package consortion.view.selfConsortia
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.ui.controls.ScrollPanel;
   import com.pickgliss.ui.controls.container.VBox;
   import com.pickgliss.ui.text.FilterFrameText;
   import consortion.ConsortionModel;
   import consortion.ConsortionModelControl;
   import consortion.event.ConsortionEvent;
   import ddt.events.PlayerPropertyEvent;
   import ddt.manager.LanguageMgr;
   import ddt.manager.PlayerManager;
   import ddt.manager.SoundManager;
   import flash.display.Bitmap;
   import flash.events.MouseEvent;
   
   public class ConsortionSkillFrame extends Frame
   {
      
      public static const CONSORTION_SKILL:int = 0;
      
      public static const PERSONAL_SKILL_CON:int = 1;
      
      public static const PERSONAL_SKILL_METAL:int = 2;
       
      
      private var _titleBg:Bitmap;
      
      private var _richLabel:Bitmap;
      
      private var _riches:FilterFrameText;
      
      private var _vbox:VBox;
      
      private var _panel:ScrollPanel;
      
      private var _items:Vector.<ConsortionSkillItem>;
      
      private var _oldType:int = 0;
      
      public function ConsortionSkillFrame()
      {
         super();
         this.initView();
         this.initEvent();
      }
      
      private function initView() : void
      {
         escEnable = true;
         disposeChildren = true;
         titleText = LanguageMgr.GetTranslation("ddt.consortion.skillFrame.title") + PlayerManager.Instance.Self.consortiaInfo.SmithLevel + "级";
         this._titleBg = ComponentFactory.Instance.creatBitmap("asset.consortionSkillFrame.titleBg");
         this._richLabel = ComponentFactory.Instance.creatBitmap("consortion.skillFrame.richesBg");
         this._riches = ComponentFactory.Instance.creatComponentByStylename("consortion.skillFrame.riches");
         this._riches.text = String(PlayerManager.Instance.Self.RichesOffer);
         this._vbox = ComponentFactory.Instance.creatComponentByStylename("consortion.skillFrame.vbox");
         this._panel = ComponentFactory.Instance.creatComponentByStylename("consortion.skillFrame.panel");
         addToContent(this._titleBg);
         addToContent(this._richLabel);
         addToContent(this._riches);
         addToContent(this._panel);
         this._panel.setView(this._vbox);
         this.showContent();
      }
      
      private function initEvent() : void
      {
         addEventListener(FrameEvent.RESPONSE,this.__responseHandler);
         ConsortionModelControl.Instance.addEventListener(ConsortionEvent.SKILL_STATE_CHANGE,this.__stateChange);
         PlayerManager.Instance.Self.addEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,this.__selfRichChangeHandler);
      }
      
      private function removeEvent() : void
      {
         removeEventListener(FrameEvent.RESPONSE,this.__responseHandler);
         ConsortionModelControl.Instance.removeEventListener(ConsortionEvent.SKILL_STATE_CHANGE,this.__stateChange);
         PlayerManager.Instance.Self.removeEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,this.__selfRichChangeHandler);
      }
      
      private function __selfRichChangeHandler(param1:PlayerPropertyEvent) : void
      {
         if(param1.changedProperties["RichesRob"] || param1.changedProperties["RichesOffer"])
         {
            this._riches.text = String(PlayerManager.Instance.Self.RichesOffer);
         }
      }
      
      private function __stateChange(param1:ConsortionEvent) : void
      {
         ConsortionModelControl.Instance.model.shinePlay = true;
         this.showContent();
      }
      
      private function __responseHandler(param1:FrameEvent) : void
      {
         if(param1.responseCode == FrameEvent.CLOSE_CLICK || param1.responseCode == FrameEvent.ESC_CLICK)
         {
            SoundManager.instance.play("008");
            this.dispose();
         }
      }
      
      private function __manageHandler(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         ConsortionModelControl.Instance.alertManagerFrame();
      }
      
      private function showContent() : void
      {
         var _loc2_:Boolean = false;
         var _loc3_:ConsortionSkillItem = null;
         this.clearItem();
         this._riches.text = PlayerManager.Instance.Self.RichesOffer.toString();
         var _loc1_:int = 0;
         while(_loc1_ < ConsortionModel.SKILL_MAX_LEVEL)
         {
            _loc2_ = _loc1_ + 1 > PlayerManager.Instance.Self.consortiaInfo.SmithLevel ? Boolean(false) : Boolean(true);
            _loc3_ = new ConsortionSkillItem(_loc1_ + 1,_loc2_);
            _loc3_.data = ConsortionModelControl.Instance.model.getskillInfoWithTypeAndLevel(_loc1_ + 1);
            this._vbox.addChild(_loc3_);
            this._items.push(_loc3_);
            _loc1_++;
         }
         this._panel.invalidateViewport();
      }
      
      private function clearItem() : void
      {
         var _loc1_:int = 0;
         if(this._items)
         {
            _loc1_ = 0;
            while(_loc1_ < this._items.length)
            {
               this._items[_loc1_].dispose();
               this._items[_loc1_] = null;
               _loc1_++;
            }
         }
         this._items = new Vector.<ConsortionSkillItem>();
      }
      
      override public function dispose() : void
      {
         this.removeEvent();
         this.clearItem();
         this._items = null;
         super.dispose();
         this._titleBg = null;
         this._richLabel = null;
         this._riches = null;
         this._vbox = null;
         this._panel = null;
         if(this.parent)
         {
            this.parent.removeChild(this);
         }
      }
   }
}
