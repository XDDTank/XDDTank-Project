package com.pickgliss.ui.view
{
   import com.pickgliss.ui.DialogManagerBase;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ClassUtils;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.TimerEvent;
   import flash.filters.BitmapFilterQuality;
   import flash.filters.GlowFilter;
   import flash.text.TextField;
   import flash.text.TextFormat;
   import flash.utils.Timer;
   import flash.utils.getDefinitionByName;
   
   public class DialogView extends Sprite implements Disposeable
   {
       
      
      private var _contentString:String;
      
      private var _animationTimer:Timer;
      
      private var _contentTxt:TextField;
      
      private var _dialogMc:Sprite;
      
      private var _headImgMc:Sprite;
      
      private var _headMc:MovieClip;
      
      private var _mouseBitmap:Bitmap;
      
      private var _showMouse:Boolean;
      
      public function DialogView()
      {
         super();
         this._dialogMc = new Sprite();
         this._headImgMc = new Sprite();
         var _loc1_:BitmapData = ClassUtils.CreatInstance("asset.dialog.mouse") as BitmapData;
         this._mouseBitmap = new Bitmap(_loc1_);
         this._mouseBitmap.x = 825;
         this._mouseBitmap.y = 152;
         this.addChild(this._headImgMc);
         this.addChild(this._dialogMc);
         this.addEventListener(Event.ADDED_TO_STAGE,this.start);
      }
      
      public function setHeadImgIndex(param1:String) : void
      {
         var instanceClass:Object = null;
         var index:String = param1;
         var mask:Sprite = this.createHeadImgMask();
         try
         {
            instanceClass = getDefinitionByName("asset.dialog.face" + index);
            this._headMc = new instanceClass() as MovieClip;
         }
         catch(e:ReferenceError)
         {
         }
         if(!this._headMc)
         {
            this._headMc = new MovieClip();
         }
         this._headMc.x = 85;
         this._headMc.y = 180;
         this._headImgMc.addChild(this._headMc);
         this._headImgMc.addChild(mask);
         this._headMc.mask = mask;
      }
      
      public function setName(param1:String) : void
      {
         var _loc2_:TextField = null;
         _loc2_ = new TextField();
         var _loc3_:TextFormat = new TextFormat();
         _loc2_.selectable = false;
         _loc2_.mouseEnabled = false;
         _loc3_.font = "Tahoma";
         _loc3_.size = 16;
         _loc3_.color = 16764006;
         _loc2_.defaultTextFormat = _loc3_;
         _loc2_.width = 616;
         _loc2_.height = 28;
         _loc2_.x = 225;
         _loc2_.y = 95;
         _loc2_.text = param1 + "：";
         _loc2_.filters = [new GlowFilter(4001792,1,5,5,10,BitmapFilterQuality.LOW,false,false)];
         this._dialogMc.addChild(_loc2_);
      }
      
      public function setContent(param1:String, param2:Boolean = true, param3:uint = 80) : void
      {
         this._showMouse = param2;
         this._contentTxt = new TextField();
         var _loc4_:TextFormat = new TextFormat();
         this._contentTxt.selectable = false;
         this._contentTxt.mouseEnabled = false;
         this._contentTxt.multiline = true;
         this._contentTxt.wordWrap = true;
         _loc4_.font = "Tahoma";
         _loc4_.size = 16;
         _loc4_.color = 16777215;
         this._contentTxt.defaultTextFormat = _loc4_;
         this._contentTxt.width = 445;
         this._contentTxt.height = 102;
         this._contentTxt.x = 255;
         this._contentTxt.y = 126;
         this._dialogMc.addChild(this._contentTxt);
         this._contentString = param1;
         this._animationTimer = new Timer(param3,0);
         this._animationTimer.addEventListener(TimerEvent.TIMER,this.showContent);
      }
      
      public function get headMc() : MovieClip
      {
         return this._headMc;
      }
      
      public function get isRunning() : Boolean
      {
         if(this._animationTimer == null)
         {
            return false;
         }
         return this._animationTimer.running;
      }
      
      public function start(param1:Event) : void
      {
         if(this._animationTimer != null)
         {
            this._animationTimer.start();
         }
      }
      
      public function showAllContentString() : void
      {
         this._contentTxt.text = this._contentString;
         this._animationTimer.stop();
         this._animationTimer = null;
         if(this._showMouse)
         {
            if(!this._mouseBitmap.parent)
            {
               addChild(this._mouseBitmap);
            }
         }
      }
      
      private function showContent(param1:TimerEvent) : void
      {
         if(this._animationTimer.currentCount <= this._contentString.length)
         {
            this._contentTxt.text = this._contentString.substr(0,this._animationTimer.currentCount);
         }
         else
         {
            this._animationTimer.stop();
            this._animationTimer = null;
            if(this._showMouse)
            {
               if(!this._mouseBitmap.parent)
               {
                  addChild(this._mouseBitmap);
               }
            }
         }
      }
      
      private function createHeadImgMask() : Sprite
      {
         var _loc1_:Sprite = new Sprite();
         _loc1_.graphics.beginFill(1,1);
         _loc1_.graphics.drawRect(0,0,DialogManagerBase.HEAD_IMG_WIDTH + 400,DialogManagerBase.HEAD_IMG_HEIGHT + 185);
         _loc1_.graphics.endFill();
         _loc1_.x = -16;
         _loc1_.y = -DialogManagerBase.HEAD_IMG_HEIGHT;
         return _loc1_;
      }
      
      public function dispose() : void
      {
         if(this._animationTimer)
         {
            this._animationTimer.stop();
            this._animationTimer = null;
         }
         while(this._dialogMc.numChildren > 0)
         {
            this._dialogMc.removeChildAt(0);
         }
         while(this._headImgMc.numChildren > 0)
         {
            this._headImgMc.removeChildAt(0);
         }
         if(this._mouseBitmap.parent)
         {
            removeChild(this._mouseBitmap);
         }
         this._mouseBitmap = null;
         this._headMc = null;
         this._contentTxt = null;
         this.removeChild(this._dialogMc);
         this.removeChild(this._headImgMc);
         this._dialogMc = null;
         this._headImgMc = null;
         this.parent.removeChild(this);
      }
   }
}
