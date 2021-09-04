package CapabilityNoctice
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.ui.controls.TextButton;
   import com.pickgliss.ui.image.Scale9CornerImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import flash.display.Bitmap;
   import flash.events.MouseEvent;
   import liveness.LivenessFrameView;
   
   public class CapabilityNocticeView extends Frame
   {
       
      
      private var _picBg:Scale9CornerImage;
      
      private var _info:CapabilityNoticeInfo;
      
      private var _pic:Bitmap;
      
      private var _text:FilterFrameText;
      
      private var _checkBtn:TextButton;
      
      public function CapabilityNocticeView()
      {
         super();
         titleStyle = "ddt.view.CapabilityNocticeView.title";
         titleText = LanguageMgr.GetTranslation("ddt.capabilitynotice.viewTitle");
      }
      
      public function set info(param1:CapabilityNoticeInfo) : void
      {
         this._info = param1;
         this.initView();
         this.initEvent();
      }
      
      public function get info() : CapabilityNoticeInfo
      {
         return this._info;
      }
      
      public function show() : void
      {
         LayerManager.Instance.addToLayer(this,LayerManager.GAME_UI_LAYER);
      }
      
      private function hide() : void
      {
         CapabilityNocticeManager.instance.hide();
      }
      
      private function initView() : void
      {
         this._picBg = ComponentFactory.Instance.creatComponentByStylename("ddt.view.CapabilityNocticeView.picBg");
         addChild(this._picBg);
         this._pic = ComponentFactory.Instance.creatBitmap(this.info.pic);
         PositionUtils.setPos(this._pic,"ddt.view.CapabilityNocticeView.picPos");
         addChild(this._pic);
         this._text = ComponentFactory.Instance.creatComponentByStylename("ddt.view.CapabilityNocticeView.text");
         this._text.multiline = true;
         this._text.htmlText = LanguageMgr.GetTranslation("ddt.capabilitynotice.desicription",this.info.level,this.info.name);
         addChild(this._text);
         this._checkBtn = ComponentFactory.Instance.creatComponentByStylename("ddt.view.CapabilityNocticeView.checkBtn");
         this._checkBtn.text = LanguageMgr.GetTranslation("ddt.capabilitynotice.checkbtn");
         addChild(this._checkBtn);
      }
      
      private function initEvent() : void
      {
         addEventListener(FrameEvent.RESPONSE,this.__frameEvent);
         this._checkBtn.addEventListener(MouseEvent.CLICK,this.__check);
      }
      
      private function __frameEvent(param1:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         switch(param1.responseCode)
         {
            case FrameEvent.ESC_CLICK:
            case FrameEvent.CLOSE_CLICK:
               this.hide();
         }
      }
      
      private function __check(param1:MouseEvent) : void
      {
         var _loc2_:LivenessFrameView = null;
         if(this.info.name == CapabilityNocticeManager.ARENA_NAME)
         {
            _loc2_ = ComponentFactory.Instance.creatCustomObject("liveness.hall.livenessFrameView");
            _loc2_.show();
         }
         this.hide();
      }
      
      private function removeEvent() : void
      {
         removeEventListener(FrameEvent.RESPONSE,this.__frameEvent);
         this._checkBtn.removeEventListener(MouseEvent.CLICK,this.__check);
      }
      
      override public function dispose() : void
      {
         this.removeEvent();
         ObjectUtils.disposeObject(this._pic);
         this._pic = null;
         ObjectUtils.disposeObject(this._picBg);
         this._picBg = null;
         ObjectUtils.disposeObject(this._text);
         this._text = null;
         ObjectUtils.disposeObject(this._checkBtn);
         this._checkBtn = null;
         super.dispose();
      }
   }
}
