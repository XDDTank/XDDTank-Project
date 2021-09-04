package petsBag.view.item
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Component;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import flash.display.DisplayObject;
   import flash.display.Shape;
   
   public class PetBaseBar extends Component
   {
      
      public static const P_bgStyle:String = "bgStyle";
      
      public static const P_maxStyle:String = "maxStyle";
      
      public static const P_progressTextStyle:String = "progressTextStyle";
      
      public static const P_maxValue:String = "maxValue";
      
      public static const P_value:String = "value";
       
      
      protected var _backGround:DisplayObject;
      
      protected var _maxBar:DisplayObject;
      
      protected var _maxMask:Shape;
      
      protected var _progressLabel:FilterFrameText;
      
      protected var _bgStyle:String;
      
      protected var _maxStyle:String;
      
      protected var _progressTextStyle:String;
      
      protected var _value:Number;
      
      protected var _maxValue:Number;
      
      public function PetBaseBar()
      {
         super();
      }
      
      override public function get tipData() : Object
      {
         return _tipData;
      }
      
      override protected function onProppertiesUpdate() : void
      {
         super.onProppertiesUpdate();
         if(_changedPropeties[P_bgStyle] || _changedPropeties[P_maxStyle] || _changedPropeties[P_progressTextStyle])
         {
            this.resetView();
         }
         if(_changedPropeties[P_value] || _changedPropeties[P_maxValue])
         {
            this.resetProgress();
         }
      }
      
      protected function resetView() : void
      {
         ObjectUtils.disposeObject(this._backGround);
         if(this._bgStyle)
         {
            this._backGround = ComponentFactory.Instance.creat(this._bgStyle);
         }
         addChild(this._backGround);
         ObjectUtils.disposeObject(this._maxBar);
         if(this._maxStyle)
         {
            this._maxBar = ComponentFactory.Instance.creat(this._maxStyle);
         }
         this._maxBar.cacheAsBitmap = true;
         addChild(this._maxBar);
         ObjectUtils.disposeObject(this._maxMask);
         this._maxMask = this.creatMask(this._maxBar);
         addChild(this._maxMask);
         ObjectUtils.disposeObject(this._progressLabel);
         if(this._progressTextStyle)
         {
            this._progressLabel = ComponentFactory.Instance.creatComponentByStylename(this._progressTextStyle);
         }
         addChild(this._progressLabel);
         _width = this._backGround.width;
         _height = this._backGround.height;
      }
      
      private function creatMask(param1:DisplayObject) : Shape
      {
         var _loc2_:Shape = null;
         _loc2_ = new Shape();
         _loc2_.graphics.beginFill(16711680,1);
         _loc2_.graphics.drawRect(0,0,param1.width,param1.height);
         _loc2_.graphics.endFill();
         _loc2_.x = param1.x;
         _loc2_.y = param1.y;
         param1.mask = _loc2_;
         return _loc2_;
      }
      
      protected function resetProgress() : void
      {
         this._maxBar.visible = true;
         if(this._progressLabel)
         {
            this._progressLabel.visible = true;
         }
         this.drawProgress();
      }
      
      public function noData() : void
      {
         if(this._maxBar)
         {
            this._maxBar.visible = false;
         }
         if(this._progressLabel)
         {
            this._progressLabel.visible = false;
         }
      }
      
      private function drawProgress() : void
      {
         var _loc1_:Number = this._maxValue > 0 ? Number(this._value / this._maxValue) : Number(0);
         this._maxMask.width = this._maxBar.width * _loc1_;
         if(this._progressLabel)
         {
            this._progressLabel.text = [this._value,this._maxValue].join("/");
         }
      }
      
      public function get bgStyle() : String
      {
         return this._bgStyle;
      }
      
      public function set bgStyle(param1:String) : void
      {
         this._bgStyle = param1;
         onPropertiesChanged(P_bgStyle);
      }
      
      public function get maxStyle() : String
      {
         return this._maxStyle;
      }
      
      public function set maxStyle(param1:String) : void
      {
         this._maxStyle = param1;
         onPropertiesChanged(P_maxStyle);
      }
      
      public function get progressTextStyle() : String
      {
         return this._progressTextStyle;
      }
      
      public function set progressTextStyle(param1:String) : void
      {
         this._progressTextStyle = param1;
         onPropertiesChanged(P_progressTextStyle);
      }
      
      public function get value() : Number
      {
         return this._value;
      }
      
      public function set value(param1:Number) : void
      {
         this._value = param1;
         onPropertiesChanged(P_value);
      }
      
      public function get maxValue() : Number
      {
         return this._maxValue;
      }
      
      public function set maxValue(param1:Number) : void
      {
         this._maxValue = param1;
         onPropertiesChanged(P_maxValue);
      }
      
      override public function dispose() : void
      {
         ObjectUtils.disposeObject(this._backGround);
         this._backGround = null;
         ObjectUtils.disposeObject(this._progressLabel);
         this._progressLabel = null;
         ObjectUtils.disposeObject(this._maxBar);
         this._maxBar = null;
         ObjectUtils.disposeObject(this._maxMask);
         this._maxMask = null;
         ObjectUtils.disposeAllChildren(this);
         super.dispose();
      }
   }
}
