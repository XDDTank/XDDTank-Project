package com.pickgliss.ui.controls
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.utils.ObjectUtils;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   
   public class HelpFrame extends Frame
   {
       
      
      private var _bg:DisplayObject;
      
      private var _view:Sprite;
      
      protected var _submitButton:TextButton;
      
      protected var _submitstyle:String;
      
      protected var _submitText:String;
      
      public function HelpFrame()
      {
         super();
         super.init();
         escEnable = true;
         this.addEvent();
         this._bg = ComponentFactory.Instance.creat("frame.helpFrame.FrameBg");
         addToContent(this._bg);
         this._view = new Sprite();
         addToContent(this._view);
      }
      
      public function setView(param1:DisplayObject) : void
      {
         var _loc2_:Point = ComponentFactory.Instance.creatCustomObject("helpFrame.helpPos");
         ObjectUtils.disposeAllChildren(this._view);
         if(_loc2_)
         {
            this._view.x = _loc2_.x;
            this._view.y = _loc2_.y;
         }
         this._view.addChild(param1);
      }
      
      public function show() : void
      {
         LayerManager.Instance.addToLayer(this,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
      }
      
      override protected function addChildren() : void
      {
         var _loc1_:Point = null;
         super.addChildren();
         if(this._submitButton)
         {
            _loc1_ = ComponentFactory.Instance.creatCustomObject("helpFrame.submitBtnPos");
            this._submitButton.x = _loc1_.x;
            this._submitButton.y = _loc1_.y;
            this._submitButton.addEventListener(MouseEvent.CLICK,this.__onClick);
            addChild(this._submitButton);
         }
      }
      
      private function addEvent() : void
      {
         addEventListener(FrameEvent.RESPONSE,this.___response);
      }
      
      private function removeEvent() : void
      {
         removeEventListener(FrameEvent.RESPONSE,this.___response);
         if(this._submitButton)
         {
            this._submitButton.removeEventListener(MouseEvent.CLICK,this.__onClick);
         }
      }
      
      private function __onClick(param1:MouseEvent) : void
      {
         onResponse(FrameEvent.HELP_CLOSE);
      }
      
      protected function ___response(param1:FrameEvent) : void
      {
         this.dispose();
      }
      
      override public function dispose() : void
      {
         this.removeEvent();
         ObjectUtils.disposeObject(this._bg);
         this._bg = null;
         ObjectUtils.disposeObject(this._submitButton);
         this._submitButton = null;
         ObjectUtils.disposeAllChildren(this._view);
         ObjectUtils.disposeObject(this._view);
         this._view = null;
         super.dispose();
      }
      
      public function get submitButton() : TextButton
      {
         return this._submitButton;
      }
      
      public function set submitButton(param1:TextButton) : void
      {
         if(this._submitButton == param1)
         {
            return;
         }
         if(this._submitButton)
         {
            this._submitButton.removeEventListener(MouseEvent.CLICK,this.__onClick);
            ObjectUtils.disposeObject(this._submitButton);
         }
         this._submitButton = param1;
      }
      
      public function get submitstyle() : String
      {
         return this._submitstyle;
      }
      
      public function set submitstyle(param1:String) : void
      {
         if(this._submitstyle == param1)
         {
            return;
         }
         this._submitstyle = param1;
         this.submitButton = ComponentFactory.Instance.creat(this._submitstyle);
      }
      
      public function get submitText() : String
      {
         return this._submitText;
      }
      
      public function set submitText(param1:String) : void
      {
         this._submitText = param1;
         if(this._submitButton)
         {
            this._submitButton.text = this._submitText;
         }
      }
   }
}
