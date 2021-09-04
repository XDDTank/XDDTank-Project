package liveness
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.ui.controls.TextButton;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class LivenessHelpFrame extends Frame
   {
       
      
      private var _submitButton:TextButton;
      
      private var _view:Sprite;
      
      private var _bg:DisplayObject;
      
      public function LivenessHelpFrame()
      {
         super();
         this.addEvent();
         titleText = LanguageMgr.GetTranslation("petsbag.frame.helpFrame.title");
      }
      
      override protected function init() : void
      {
         super.init();
         this._bg = ComponentFactory.Instance.creat("liveness.frame.LivenessHelpFrameBg");
         addToContent(this._bg);
         this._view = new Sprite();
         addToContent(this._view);
         this._submitButton = ComponentFactory.Instance.creat("liveness.HelpFrame.joinBtn");
         this._submitButton.text = LanguageMgr.GetTranslation("consortion.ConsortionCampaign.goTransportBtn.text");
         addToContent(this._submitButton);
         escEnable = true;
         enterEnable = true;
      }
      
      public function setView(param1:DisplayObject, param2:* = null) : void
      {
         ObjectUtils.disposeAllChildren(this._view);
         if(param2)
         {
            PositionUtils.setPos(param1,param2);
         }
         this._view.addChild(param1);
      }
      
      public function set btnEnable(param1:Boolean) : void
      {
         this._submitButton.enable = param1;
      }
      
      private function addEvent() : void
      {
         addEventListener(FrameEvent.RESPONSE,this.___response);
         this._submitButton.addEventListener(MouseEvent.CLICK,this._submit);
      }
      
      private function removeEvent() : void
      {
         removeEventListener(FrameEvent.RESPONSE,this.___response);
         this._submitButton.removeEventListener(MouseEvent.CLICK,this._submit);
      }
      
      protected function _submit(param1:MouseEvent) : void
      {
         onResponse(FrameEvent.SUBMIT_CLICK);
      }
      
      protected function ___response(param1:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         if(param1.responseCode == FrameEvent.SUBMIT_CLICK)
         {
            dispatchEvent(new Event(Event.COMPLETE));
         }
         this.parent.removeChild(this);
      }
      
      public function show() : void
      {
         LayerManager.Instance.addToLayer(this,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
      }
      
      override public function dispose() : void
      {
         this.removeEvent();
         ObjectUtils.disposeObject(this._bg);
         this._bg = null;
         ObjectUtils.disposeAllChildren(this._view);
         ObjectUtils.disposeObject(this._view);
         this._view = null;
         ObjectUtils.disposeObject(this._submitButton);
         this._submitButton = null;
         super.dispose();
      }
   }
}
