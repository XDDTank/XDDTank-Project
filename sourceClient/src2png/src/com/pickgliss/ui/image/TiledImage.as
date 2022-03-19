// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//com.pickgliss.ui.image.TiledImage

package com.pickgliss.ui.image
{
    import flash.display.BitmapData;
    import com.pickgliss.ui.ComponentFactory;
    import com.pickgliss.ui.core.Component;
    import flash.geom.Matrix;
    import com.pickgliss.utils.ObjectUtils;

    public class TiledImage extends Image 
    {

        private var _imageLink:String;
        private var _image:BitmapData;


        override protected function resetDisplay():void
        {
            this.removeImages();
            this.creatImages();
        }

        private function creatImages():void
        {
            this._image = ComponentFactory.Instance.creatBitmapData(_resourceLink);
        }

        override protected function updateSize():void
        {
            if (((_changedPropeties[Component.P_width]) || (_changedPropeties[Component.P_height])))
            {
                this.drawImage();
            };
        }

        private function drawImage():void
        {
            graphics.clear();
            var _local_1:Matrix = new Matrix();
            _local_1.tx = 0;
            _local_1.ty = 0;
            graphics.beginBitmapFill(this._image, _local_1);
            graphics.drawRect(0, 0, width, height);
            graphics.endFill();
        }

        private function removeImages():void
        {
            if (this._image == null)
            {
                return;
            };
            graphics.clear();
            ObjectUtils.disposeObject(this._image);
        }

        override public function dispose():void
        {
            graphics.clear();
            this.removeImages();
            this._image = null;
            super.dispose();
        }


    }
}//package com.pickgliss.ui.image

