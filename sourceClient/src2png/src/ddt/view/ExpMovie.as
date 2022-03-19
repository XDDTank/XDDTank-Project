// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//ddt.view.ExpMovie

package ddt.view
{
    import flash.display.Sprite;
    import com.pickgliss.ui.core.Disposeable;
    import com.pickgliss.ui.text.FilterFrameText;
    import flash.display.Bitmap;
    import com.pickgliss.ui.ComponentFactory;
    import com.greensock.TweenLite;
    import com.pickgliss.utils.ObjectUtils;

    public class ExpMovie extends Sprite implements Disposeable 
    {

        private var _expText:FilterFrameText;
        private var _expUpAsset:Bitmap;

        public function ExpMovie()
        {
            this.initView();
        }

        private function initView():void
        {
            this._expText = ComponentFactory.Instance.creatComponentByStylename("ExpMovie.expText");
            this._expUpAsset = ComponentFactory.Instance.creatBitmap("asset.expMovie.ExpUPAsset");
            addChild(this._expText);
            addChild(this._expUpAsset);
            this._expText.alpha = 0;
            this._expUpAsset.alpha = 0;
        }

        public function set exp(_arg_1:int):void
        {
            this._expText.text = _arg_1.toString();
        }

        public function play():void
        {
            this._expText.y = 0;
            this._expText.alpha = 0;
            TweenLite.to(this._expText, 0.4, {
                "y":-22,
                "alpha":1,
                "onComplete":this.onOut
            });
            this._expUpAsset.y = 28;
            this._expUpAsset.alpha = 0;
            TweenLite.to(this._expUpAsset, 0.4, {
                "y":4,
                "alpha":1,
                "delay":0.2,
                "onComplete":this.onOut1
            });
        }

        private function onOut():void
        {
            TweenLite.to(this._expText, 0.4, {
                "y":-20,
                "alpha":0,
                "delay":1
            });
        }

        private function onOut1():void
        {
            TweenLite.to(this._expUpAsset, 0.4, {
                "y":0,
                "alpha":0,
                "delay":0.9
            });
        }

        public function dispose():void
        {
            TweenLite.killTweensOf(this._expText);
            TweenLite.killTweensOf(this._expUpAsset);
            if (this._expText)
            {
                ObjectUtils.disposeObject(this._expText);
            };
            this._expText = null;
            if (this._expUpAsset)
            {
                ObjectUtils.disposeObject(this._expUpAsset);
            };
            this._expUpAsset = null;
            if (this.parent)
            {
                this.parent.removeChild(this);
            };
        }


    }
}//package ddt.view

