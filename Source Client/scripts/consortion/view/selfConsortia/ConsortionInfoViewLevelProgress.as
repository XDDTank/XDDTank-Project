package consortion.view.selfConsortia
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Component;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.Graphics;
   import flash.geom.Matrix;
   
   public class ConsortionInfoViewLevelProgress extends Component
   {
      
      public static const Progress:String = "progress";
       
      
      protected var _background:Bitmap;
      
      protected var _thuck:Component;
      
      protected var _graphics_thuck:BitmapData;
      
      protected var _value:Number = 0;
      
      protected var _max:Number = 100;
      
      protected var _progressLabel:FilterFrameText;
      
      public function ConsortionInfoViewLevelProgress()
      {
         super();
         _width = _height = 23;
         this.initView();
         this.drawProgress();
      }
      
      protected function initView() : void
      {
         this._background = ComponentFactory.Instance.creatBitmap("asset.ConsortionInfoView.LevelProssBg");
         addChild(this._background);
         this._thuck = ComponentFactory.Instance.creatComponentByStylename("ConsortionInfoViewLevelProgress.thunck");
         addChild(this._thuck);
         this._graphics_thuck = ComponentFactory.Instance.creatBitmapData("asset.ConsortionInfoView.LevelPross");
         this._progressLabel = ComponentFactory.Instance.creatComponentByStylename("ConsortionInfoViewLevelProgress.levelProgressText");
         addChild(this._progressLabel);
      }
      
      public function setProgress(param1:Number, param2:Number) : void
      {
         if(this._value != param1 || this._max != param2)
         {
            this._value = param1;
            this._max = param2;
            this.drawProgress();
         }
      }
      
      protected function drawProgress() : void
      {
         var _loc1_:Number = this._value / this._max > 1 ? Number(1) : Number(this._value / this._max);
         var _loc2_:Graphics = this._thuck.graphics;
         _loc2_.clear();
         if(_loc1_ >= 0)
         {
            this._progressLabel.text = Math.floor(_loc1_ * 10000 / 100) + "%";
            _loc2_.beginBitmapFill(this._graphics_thuck,new Matrix(128 / 123));
            _loc2_.drawRect(0,0,(_width + 360) * _loc1_,_height);
            _loc2_.endFill();
         }
      }
      
      override public function dispose() : void
      {
         ObjectUtils.disposeObject(this._graphics_thuck);
         this._graphics_thuck = null;
         ObjectUtils.disposeObject(this._thuck);
         this._thuck = null;
         ObjectUtils.disposeObject(this._progressLabel);
         this._progressLabel = null;
         ObjectUtils.disposeObject(this._background);
         this._background = null;
         super.dispose();
      }
   }
}
