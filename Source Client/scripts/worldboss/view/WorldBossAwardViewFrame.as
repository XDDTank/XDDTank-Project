package worldboss.view
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import flash.display.Bitmap;
   import worldboss.event.WorldBossRoomEvent;
   
   public class WorldBossAwardViewFrame extends Frame
   {
       
      
      private var _titleBg:Bitmap;
      
      private var _leftView:WorldBossAwardOptionLeftView;
      
      private var _rightView:WorldBossAwardOptionRightView;
      
      public function WorldBossAwardViewFrame()
      {
         super();
         this.initView();
         this.addEvent();
      }
      
      private function initView() : void
      {
         escEnable = true;
         this._titleBg = ComponentFactory.Instance.creatBitmap("asset.worldBoss.title");
         addToContent(this._titleBg);
         this._rightView = new WorldBossAwardOptionRightView();
         addToContent(this._rightView);
         this._leftView = new WorldBossAwardOptionLeftView();
         addToContent(this._leftView);
         PositionUtils.setPos(this._rightView,"WorldBossAwardRightView.pos");
         PositionUtils.setPos(this._leftView,"WorldBossAwardleftView.pos");
      }
      
      private function addEvent() : void
      {
         addEventListener(FrameEvent.RESPONSE,this.__responseHandler);
      }
      
      private function removeEvent() : void
      {
         removeEventListener(FrameEvent.RESPONSE,this.__responseHandler);
      }
      
      private function __responseHandler(param1:FrameEvent) : void
      {
         if(param1.responseCode == FrameEvent.ESC_CLICK || param1.responseCode == FrameEvent.CLOSE_CLICK)
         {
            SoundManager.instance.play("008");
            dispatchEvent(new WorldBossRoomEvent(WorldBossRoomEvent.WORLDBOSS_AWARD_CLOSE));
         }
      }
      
      public function show() : void
      {
         LayerManager.Instance.addToLayer(this,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
      }
      
      public function get leftView() : WorldBossAwardOptionLeftView
      {
         return this._leftView;
      }
      
      override public function dispose() : void
      {
         this.removeEvent();
         if(this._titleBg)
         {
            ObjectUtils.disposeObject(this._titleBg);
         }
         this._titleBg = null;
         if(this._leftView)
         {
            ObjectUtils.disposeObject(this._leftView);
         }
         this._leftView = null;
         if(this._rightView)
         {
            ObjectUtils.disposeObject(this._rightView);
         }
         this._rightView = null;
         if(parent)
         {
            parent.removeChild(this);
         }
      }
   }
}
