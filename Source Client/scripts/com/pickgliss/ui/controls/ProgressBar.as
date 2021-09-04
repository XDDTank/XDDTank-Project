package com.pickgliss.ui.controls
{
   import com.pickgliss.geom.InnerRectangle;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Component;
   import com.pickgliss.utils.ClassUtils;
   import com.pickgliss.utils.ObjectUtils;
   import flash.display.BitmapData;
   import flash.display.DisplayObject;
   import flash.display.Shape;
   import flash.geom.Rectangle;
   import flash.text.TextField;
   
   public class ProgressBar extends Component
   {
      
      public static const P_troughStyle:String = "troughStyle";
      
      public static const P_barStyle:String = "barStyle";
      
      public static const P_maskStyle:String = "maskStyle";
      
      public static const P_textStyle:String = "textStyle";
      
      public static const P_rotationStyle:String = "textStyle";
      
      public static const P_textInnerRect:String = "textInnerRect";
      
      public static const FILL_L2R:int = 0;
      
      public static const FILL_R2L:int = 1;
      
      public static const DIG_L2R:int = 2;
      
      public static const DIG_R2L:int = 3;
       
      
      private var _trough:DisplayObject;
      
      private var _troughStyle:String;
      
      private var _bar:DisplayObject;
      
      private var _barStyle:String;
      
      private var _mask:DisplayObject;
      
      private var _maskStyle:String;
      
      private var _text:DisplayObject;
      
      private var _textStyle:String;
      
      private var _progress:Number;
      
      private var _vertical:Boolean;
      
      private var _fillType:int;
      
      private var _shape:Shape;
      
      private var _textInnerRect:InnerRectangle;
      
      private var _textInnerRectString:String;
      
      public function ProgressBar()
      {
         super();
      }
      
      override protected function init() : void
      {
         this._shape = new Shape();
         this._progress = 0;
      }
      
      override protected function addChildren() : void
      {
         super.addChildren();
         if(this._trough)
         {
            addChild(this._trough);
         }
         if(this._bar)
         {
            addChild(this._bar);
         }
         if(this._mask)
         {
            this._bar.mask = this._mask;
         }
         addChild(this._shape);
         if(this._text)
         {
            addChild(this._text);
         }
      }
      
      public function set textInnerRectString(param1:String) : void
      {
         if(this._textInnerRectString == param1)
         {
            return;
         }
         this._textInnerRectString = param1;
         this._textInnerRect = ClassUtils.CreatInstance(ClassUtils.INNERRECTANGLE,ComponentFactory.parasArgs(this._textInnerRectString));
         onPropertiesChanged(P_textInnerRect);
      }
      
      public function set vertical(param1:Boolean) : void
      {
         var _loc2_:Number = NaN;
         this._vertical = param1;
         if(this._vertical)
         {
            if(this._trough)
            {
               this._trough.rotation = -90;
               _loc2_ = this._trough.x;
               this._trough.x = this._trough.y;
               this._trough.y = -_loc2_;
            }
            if(this._bar)
            {
               this._bar.rotation = -90;
               _loc2_ = this._bar.x;
               this._bar.x = this._bar.y;
               this._bar.y = -_loc2_;
            }
         }
      }
      
      public function get progress() : Number
      {
         return this._progress;
      }
      
      public function set progress(param1:Number) : void
      {
         if(this._progress == param1)
         {
            return;
         }
         if(param1 > 1)
         {
            param1 = 1;
         }
         this._progress = param1;
         this.updateView();
      }
      
      private function updateView() : void
      {
         var _loc1_:BitmapData = null;
         this._shape.graphics.clear();
         if(this._mask)
         {
            _loc1_ = new BitmapData(this._mask.width,this._mask.height);
            _loc1_.draw(this._mask);
            this._shape.graphics.beginBitmapFill(_loc1_);
         }
         else
         {
            this._shape.graphics.beginFill(0);
         }
         switch(this._fillType)
         {
            case FILL_L2R:
               if(!this._vertical)
               {
                  this._shape.graphics.drawRect(this._bar.x,this._bar.y,this._bar.width * this._progress,this._bar.height);
               }
               else
               {
                  this._shape.graphics.drawRect(x + this._bar.x,y + this._bar.y,this._bar.height,-this._bar.width * this._progress);
               }
               if(this._text is TextField)
               {
                  TextField(this._text).text = String(Math.round(this._progress * 100));
               }
               break;
            case FILL_R2L:
               if(!this._vertical)
               {
                  this._shape.graphics.drawRect(x + this._bar.x + this._bar.width,y + this._bar.y,-this._bar.width * this._progress,this._bar.height);
               }
               else
               {
                  this._shape.graphics.drawRect(x + this._bar.x,y + this._bar.y - this._bar.width,this._bar.height,this._bar.width * this._progress);
               }
               if(this._text is TextField)
               {
                  TextField(this._text).text = String(Math.round(this._progress * 100));
               }
               break;
            case DIG_L2R:
               if(!this._vertical)
               {
                  this._shape.graphics.drawRect(x + this._bar.x + this._bar.width,y + this._bar.y,-this._bar.width * (1 - this._progress),this._bar.height);
               }
               else
               {
                  this._shape.graphics.drawRect(x + this._bar.x,y + this._bar.y - this._bar.width,this._bar.height,this._bar.width * (1 - this._progress));
               }
               if(this._text is TextField)
               {
                  TextField(this._text).text = String(Math.round((1 - this._progress) * 100));
               }
               break;
            case DIG_R2L:
               if(!this._vertical)
               {
                  this._shape.graphics.drawRect(x + this._bar.x,y + this._bar.y,this._bar.width * (1 - this._progress),this._bar.height);
               }
               else
               {
                  this._shape.graphics.drawRect(x + this._bar.x,y + this._bar.y,this._bar.height,-this._bar.width * (1 - this._progress));
               }
               if(this._text is TextField)
               {
                  TextField(this._text).text = String(Math.round((1 - this._progress) * 100));
               }
         }
         this._shape.graphics.endFill();
         this._bar.mask = this._shape;
      }
      
      public function set fillType(param1:int) : void
      {
         if(this._fillType == param1)
         {
            return;
         }
         this._fillType = param1;
      }
      
      public function get troughStyle() : String
      {
         return this._troughStyle;
      }
      
      public function set troughStyle(param1:String) : void
      {
         if(param1 == this._troughStyle)
         {
            return;
         }
         this._troughStyle = param1;
         this.trough = ComponentFactory.Instance.creat(this._troughStyle);
         onPropertiesChanged(P_troughStyle);
      }
      
      public function set trough(param1:DisplayObject) : void
      {
         if(this._trough == param1)
         {
            return;
         }
         ObjectUtils.disposeObject(this._trough);
         this._trough = param1;
         onPropertiesChanged(P_troughStyle);
      }
      
      public function get barStyle() : String
      {
         return this._barStyle;
      }
      
      public function set barStyle(param1:String) : void
      {
         if(param1 == this._barStyle)
         {
            return;
         }
         this._barStyle = param1;
         this.bar = ComponentFactory.Instance.creat(this._barStyle);
         onPropertiesChanged(P_barStyle);
      }
      
      public function set bar(param1:DisplayObject) : void
      {
         if(this._trough == param1)
         {
            return;
         }
         ObjectUtils.disposeObject(this._bar);
         this._bar = param1;
         this._bar.cacheAsBitmap = true;
         onPropertiesChanged(P_barStyle);
      }
      
      public function get maskStyle() : String
      {
         return this._maskStyle;
      }
      
      public function set maskStyle(param1:String) : void
      {
         if(param1 == this._maskStyle)
         {
            return;
         }
         this._maskStyle = param1;
         this.barMask = ComponentFactory.Instance.creat(this._maskStyle);
         onPropertiesChanged(P_maskStyle);
      }
      
      public function set barMask(param1:DisplayObject) : void
      {
         if(this._mask == param1)
         {
            return;
         }
         ObjectUtils.disposeObject(this._mask);
         this._mask = param1;
         onPropertiesChanged(P_maskStyle);
      }
      
      public function get textStyle() : String
      {
         return this._textStyle;
      }
      
      public function set textStyle(param1:String) : void
      {
         if(param1 == this._textStyle)
         {
            return;
         }
         this._textStyle = param1;
         this.textFiled = ComponentFactory.Instance.creat(this._textStyle);
         onPropertiesChanged(P_textStyle);
      }
      
      public function set textFiled(param1:DisplayObject) : void
      {
         if(this._text == param1)
         {
            return;
         }
         ObjectUtils.disposeObject(this._text);
         this._text = param1;
         onPropertiesChanged(P_textStyle);
      }
      
      public function set text(param1:String) : void
      {
         TextField(this._text).text = param1;
      }
      
      override protected function onProppertiesUpdate() : void
      {
         var _loc1_:Rectangle = null;
         super.onProppertiesUpdate();
         if(_changedPropeties[P_troughStyle])
         {
            if(this._trough && (this._trough.width > 0 || this._trough.height > 0))
            {
               _width = this._trough.width;
               _height = this._trough.height;
            }
         }
         if(_changedPropeties[P_textInnerRect] && this._text)
         {
            _loc1_ = this._textInnerRect.getInnerRect(_width,_height);
            this._text.width = _loc1_.width;
            this._text.height = _loc1_.height;
            this._text.x = _loc1_.x;
            this._text.y = _loc1_.y;
         }
      }
      
      override public function dispose() : void
      {
      }
   }
}
