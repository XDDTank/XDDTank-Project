package arena.view
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
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   
   public class ArenaHelpFrame extends Frame
   {
       
      
      private var _submitButton:TextButton;
      
      private var _help:MovieClip;
      
      public function ArenaHelpFrame()
      {
         super();
         titleText = LanguageMgr.GetTranslation("petsbag.frame.helpFrame.title");
      }
      
      override protected function init() : void
      {
         super.init();
         this._submitButton = ComponentFactory.Instance.creat("ddtstore.HelpFrame.EnterBtn");
         this._submitButton.text = LanguageMgr.GetTranslation("ok");
         addToContent(this._submitButton);
         escEnable = true;
         enterEnable = true;
         this._help = ComponentFactory.Instance.creat("ddtarena.helpMC");
         PositionUtils.setPos(this._help,"ddtarena.helpframe.helpmc.pos");
         addToContent(this._help);
         this.initEvent();
      }
      
      private function initEvent() : void
      {
         addEventListener(FrameEvent.RESPONSE,this.___response);
         this._submitButton.addEventListener(MouseEvent.CLICK,this._submit);
      }
      
      protected function _submit(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
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
      
      private function removeEvent() : void
      {
         removeEventListener(FrameEvent.RESPONSE,this.___response);
         this._submitButton.removeEventListener(MouseEvent.CLICK,this._submit);
      }
      
      override public function dispose() : void
      {
         this.removeEvent();
         ObjectUtils.disposeObject(this._help);
         this._help = null;
         ObjectUtils.disposeObject(this._submitButton);
         this._submitButton = null;
         super.dispose();
      }
   }
}
