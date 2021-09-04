package petsBag.view
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
   import flash.events.MouseEvent;
   
   public class PetHelpFrame extends Frame
   {
       
      
      private var _bg:DisplayObject;
      
      private var _view:Sprite;
      
      private var _submitButton:TextButton;
      
      public function PetHelpFrame()
      {
         super();
         this.addEvent();
         titleText = LanguageMgr.GetTranslation("petsbag.frame.helpFrame.title");
      }
      
      override protected function init() : void
      {
         super.init();
         this._bg = ComponentFactory.Instance.creat("petsBag.frame.FrameBg");
         addToContent(this._bg);
         this._view = new Sprite();
         addToContent(this._view);
         this._submitButton = ComponentFactory.Instance.creat("ddtstore.HelpFrame.EnterBtn");
         this._submitButton.text = LanguageMgr.GetTranslation("ok");
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
         this.dispose();
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
