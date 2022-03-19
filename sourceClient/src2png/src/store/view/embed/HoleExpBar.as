// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//store.view.embed.HoleExpBar

package store.view.embed
{
    import com.pickgliss.ui.core.TransformableComponent;
    import flash.display.BitmapData;
    import com.pickgliss.ui.text.FilterFrameText;
    import com.pickgliss.ui.ComponentFactory;
    import flash.geom.Matrix;
    import flash.display.Graphics;
    import com.pickgliss.utils.ObjectUtils;

    public class HoleExpBar extends TransformableComponent 
    {

        private static const P_Rate:String = "p_rate";

        private var thickness:int = 3;
        private var _rate:Number = 0;
        private var _back:BitmapData;
        private var _thumb:BitmapData;
        private var _rateField:FilterFrameText;

        public function HoleExpBar()
        {
            this.configUI();
        }

        private function configUI():void
        {
            this._back = ComponentFactory.Instance.creatBitmapData("asset.ddtstore.EmbedHoleExpBack");
            this._thumb = ComponentFactory.Instance.creatBitmapData("asset.ddtstore.EmbedHoleExpThumb");
            this._rateField = ComponentFactory.Instance.creatComponentByStylename("ddttore.StoreEmbedBG.ExpRateFieldText");
            addChild(this._rateField);
            _width = this._back.width;
            _height = this._back.height;
            this.draw();
        }

        override public function set visible(_arg_1:Boolean):void
        {
            super.visible = _arg_1;
        }

        override public function draw():void
        {
            var _local_2:int;
            var _local_3:Matrix;
            super.draw();
            var _local_1:Graphics = graphics;
            _local_1.clear();
            _local_1.beginBitmapFill(this._back);
            _local_1.drawRect(0, 0, _width, _height);
            _local_1.endFill();
            if ((((_width > (this.thickness * 3)) && (_height > (this.thickness * 3))) && (this._rate > 0)))
            {
                _local_2 = (_width - (this.thickness * 2));
                _local_3 = new Matrix();
                _local_3.translate(this.thickness, this.thickness);
                _local_1.beginBitmapFill(this._thumb, _local_3);
                _local_1.drawRect(this.thickness, this.thickness, (_local_2 * this._rate), (_height - (this.thickness * 2)));
                _local_1.endFill();
            };
            this._rateField.text = (int((this._rate * 100)) + "%");
        }

        public function setProgress(_arg_1:int, _arg_2:int=100):void
        {
            this._rate = (_arg_1 / _arg_2);
            this._rate = ((this._rate > 1) ? 1 : this._rate);
            onPropertiesChanged(P_Rate);
        }

        override public function dispose():void
        {
            if (this._back)
            {
                ObjectUtils.disposeObject(this._back);
                this._back = null;
            };
            if (this._thumb)
            {
                ObjectUtils.disposeObject(this._thumb);
                this._thumb = null;
            };
            if (this._rateField)
            {
                ObjectUtils.disposeObject(this._rateField);
            };
            this._rateField = null;
            super.dispose();
        }


    }
}//package store.view.embed

