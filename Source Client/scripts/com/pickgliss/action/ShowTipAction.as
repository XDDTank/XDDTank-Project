package com.pickgliss.action
{
   import com.pickgliss.ui.ComponentSetting;
   import com.pickgliss.ui.LayerManager;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.MouseEvent;
   
   public class ShowTipAction extends BaseAction
   {
       
      
      private var _tip:MovieClip;
      
      private var _sound:String;
      
      private var _dispatcher:EventDispatcher;
      
      public function ShowTipAction(param1:DisplayObject, param2:String = null)
      {
         super();
         this._tip = param1 as MovieClip;
         this._sound = param2;
      }
      
      override public function act() : void
      {
         if(this._sound && ComponentSetting.PLAY_SOUND_FUNC is Function)
         {
            ComponentSetting.PLAY_SOUND_FUNC(this._sound);
         }
         LayerManager.Instance.addToLayer(this._tip,LayerManager.GAME_TOP_LAYER,false,LayerManager.NONE_BLOCKGOUND,false);
         this._tip.addEventListener(Event.ENTER_FRAME,this.__frameHandler);
         this._tip.addEventListener(MouseEvent.CLICK,this.__newQuestClickHandler);
         this._tip.play();
      }
      
      private function __frameHandler(param1:Event) : void
      {
         if(this._tip)
         {
            if(this._tip.currentFrame == this._tip.totalFrames)
            {
               this._tip.removeEventListener(Event.ENTER_FRAME,this.__frameHandler);
               this._tip.stop();
               this._tip.parent.removeChild(this._tip);
               this._tip = null;
            }
         }
      }
      
      private function __newQuestClickHandler(param1:MouseEvent) : void
      {
         this._dispatcher.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
      }
      
      public function get dispatcher() : EventDispatcher
      {
         return this._dispatcher;
      }
      
      public function dispose() : void
      {
         this._dispatcher = null;
         if(this._tip)
         {
            this._tip.removeEventListener(Event.ENTER_FRAME,this.__frameHandler);
            this._tip.stop();
            this._tip.parent.removeChild(this._tip);
            this._tip = null;
         }
      }
   }
}
