// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//bagAndInfo.info.LevelProgress

package bagAndInfo.info
{
    import com.pickgliss.ui.core.Component;
    import flash.display.Bitmap;
    import flash.display.BitmapData;
    import com.pickgliss.ui.text.FilterFrameText;
    import com.pickgliss.ui.ComponentFactory;
    import flash.display.Graphics;
    import flash.geom.Matrix;
    import com.pickgliss.utils.ObjectUtils;

    public class LevelProgress extends Component 
    {

        public static const Progress:String = "progress";

        protected var _background:Bitmap;
        protected var _thuck:Component;
        protected var _graphics_thuck:BitmapData;
        protected var _value:Number = 0;
        protected var _max:Number = 100;
        protected var _progressLabel:FilterFrameText;

        public function LevelProgress()
        {
            _width = (_height = 10);
            this.initView();
            this.drawProgress();
        }

        protected function initView():void
        {
            this._background = ComponentFactory.Instance.creatBitmap("bagAndInfo.info.Background_Progress1");
            addChild(this._background);
            this._thuck = ComponentFactory.Instance.creatComponentByStylename("bagAndInfo.info.thunck");
            addChild(this._thuck);
            this._graphics_thuck = ComponentFactory.Instance.creatBitmapData("bagAndInfo.info.Bitmap_thuck1");
            this._progressLabel = ComponentFactory.Instance.creatComponentByStylename("bagAndInfo.info.LevelProgressText");
            addChild(this._progressLabel);
        }

        public function setProgress(_arg_1:Number, _arg_2:Number):void
        {
            if (((!(this._value == _arg_1)) || (!(this._max == _arg_2))))
            {
                this._value = _arg_1;
                this._max = _arg_2;
                this.drawProgress();
            };
        }

        protected function drawProgress():void
        {
            var _local_1:Number = (((this._value / this._max) > 1) ? 1 : (this._value / this._max));
            var _local_2:Graphics = this._thuck.graphics;
            _local_2.clear();
            if (_local_1 >= 0)
            {
                this._progressLabel.text = ((Math.floor((_local_1 * 10000)) / 100) + "%");
                _local_2.beginBitmapFill(this._graphics_thuck, new Matrix((128 / 123)));
                _local_2.drawRect(0, 0, ((_width + 63) * _local_1), (_height + 16));
                _local_2.endFill();
            };
        }

        public function set labelText(_arg_1:String):void
        {
            this._progressLabel.text = _arg_1;
        }

        override public function dispose():void
        {
            ObjectUtils.disposeObject(this._graphics_thuck);
            this._graphics_thuck = null;
            ObjectUtils.disposeObject(this._background);
            this._background = null;
            ObjectUtils.disposeObject(this._thuck);
            this._thuck = null;
            ObjectUtils.disposeObject(this._progressLabel);
            this._progressLabel = null;
            super.dispose();
        }


    }
}//package bagAndInfo.info

