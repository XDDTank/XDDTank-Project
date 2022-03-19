// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//ddt.view.tips.WinRate

package ddt.view.tips
{
    import flash.display.Sprite;
    import com.pickgliss.ui.core.Disposeable;
    import flash.display.Bitmap;
    import com.pickgliss.ui.text.FilterFrameText;
    import com.pickgliss.ui.ComponentFactory;
    import com.pickgliss.utils.ObjectUtils;

    public class WinRate extends Sprite implements Disposeable 
    {

        private var _win:int;
        private var _total:int;
        private var _bg:Bitmap;
        private var rate_txt:FilterFrameText;

        public function WinRate(_arg_1:int, _arg_2:int):void
        {
            this._win = _arg_1;
            this._total = _arg_2;
            this.init();
            this.setRate(this._win, this._total);
        }

        private function init():void
        {
            this._bg = ComponentFactory.Instance.creat("asset.core.leveltip.WinRateBg");
            this.rate_txt = ComponentFactory.Instance.creat("core.WinRateTxt");
            addChild(this._bg);
            addChild(this.rate_txt);
        }

        public function setRate(_arg_1:int, _arg_2:int):void
        {
            this._win = _arg_1;
            this._total = _arg_2;
            var _local_3:Number = ((this._total > 0) ? ((this._win / this._total) * 100) : 0);
            this.rate_txt.text = (_local_3.toFixed(2) + "%");
        }

        public function dispose():void
        {
            if (this.rate_txt)
            {
                ObjectUtils.disposeObject(this.rate_txt);
            };
            this.rate_txt = null;
            if (this._bg)
            {
                ObjectUtils.disposeObject(this._bg);
            };
            this._bg = null;
            ObjectUtils.disposeAllChildren(this);
            if (parent)
            {
                parent.removeChild(this);
            };
        }


    }
}//package ddt.view.tips

