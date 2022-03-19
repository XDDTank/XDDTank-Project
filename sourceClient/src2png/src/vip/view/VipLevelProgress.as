// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//vip.view.VipLevelProgress

package vip.view
{
    import bagAndInfo.info.LevelProgress;
    import flash.display.Bitmap;
    import com.pickgliss.ui.ComponentFactory;
    import flash.display.Graphics;
    import com.pickgliss.utils.ObjectUtils;

    public class VipLevelProgress extends LevelProgress 
    {

        private var _backBG:Bitmap;


        public function set progressLabelTextFormatStyle(_arg_1:String):void
        {
            _progressLabel.textFormatStyle = _arg_1;
        }

        public function set progressLabelFilterString(_arg_1:String):void
        {
            _progressLabel.filterString = _arg_1;
        }

        override protected function initView():void
        {
            _thuck = ComponentFactory.Instance.creatComponentByStylename("VIP.thunck");
            addChildAt(_thuck, 0);
            this._backBG = ComponentFactory.Instance.creatBitmap("VIP.LeveLBG");
            addChildAt(this._backBG, 0);
            _graphics_thuck = ComponentFactory.Instance.creatBitmapData("asset.vip.levelProgressBar");
            _progressLabel = ComponentFactory.Instance.creatComponentByStylename("vipLevelProgressTxt");
            addChild(_progressLabel);
        }

        override protected function drawProgress():void
        {
            var _local_1:Number = (((_value / _max) > 1) ? 1 : (_value / _max));
            var _local_2:Graphics = _thuck.graphics;
            _local_2.clear();
            if (_local_1 >= 0)
            {
                _progressLabel.text = ((Math.floor((_local_1 * 10000)) / 100) + "%");
                _local_2.beginBitmapFill(_graphics_thuck);
                _local_2.drawRect(0, 0, (_width * _local_1), _height);
                _local_2.endFill();
            };
        }

        override public function dispose():void
        {
            super.dispose();
            ObjectUtils.disposeObject(this._backBG);
            this._backBG = null;
        }


    }
}//package vip.view

