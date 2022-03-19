// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//com.pickgliss.ui.image.Scale9CornerImage

package com.pickgliss.ui.image
{
    import __AS3__.vec.Vector;
    import flash.display.BitmapData;
    import com.pickgliss.ui.ComponentFactory;
    import com.pickgliss.ui.core.Component;
    import flash.geom.Matrix;
    import com.pickgliss.utils.ObjectUtils;
    import __AS3__.vec.*;

    public class Scale9CornerImage extends Image 
    {

        private var _imageLinks:Array;
        private var _images:Vector.<BitmapData>;


        override public function dispose():void
        {
            graphics.clear();
            this.removeImages();
            this._images = null;
            this._imageLinks = null;
            super.dispose();
        }

        override protected function resetDisplay():void
        {
            this._imageLinks = ComponentFactory.parasArgs(_resourceLink);
            this.removeImages();
            this.creatImages();
        }

        override protected function updateSize():void
        {
            if (((_changedPropeties[Component.P_width]) || (_changedPropeties[Component.P_height])))
            {
                this.drawImage();
            };
        }

        private function creatImages():void
        {
            this._images = new Vector.<BitmapData>();
            var _local_1:int;
            while (_local_1 < this._imageLinks.length)
            {
                this._images.push(ComponentFactory.Instance.creatBitmapData(this._imageLinks[_local_1]));
                _local_1++;
            };
        }

        private function drawImage():void
        {
            graphics.clear();
            var _local_1:Matrix = new Matrix();
            _local_1.tx = 0;
            _local_1.ty = 0;
            graphics.beginBitmapFill(this._images[0], _local_1);
            graphics.drawRect(0, 0, this._images[0].width, this._images[0].height);
            _local_1.tx = this._images[0].width;
            _local_1.ty = 0;
            graphics.beginBitmapFill(this._images[1], _local_1);
            graphics.drawRect(this._images[0].width, 0, ((_width - this._images[0].width) - this._images[2].width), this._images[1].height);
            _local_1.tx = (_width - this._images[2].width);
            _local_1.ty = 0;
            graphics.beginBitmapFill(this._images[2], _local_1);
            graphics.drawRect((_width - this._images[2].width), 0, this._images[2].width, this._images[2].height);
            _local_1.tx = 0;
            _local_1.ty = this._images[0].height;
            graphics.beginBitmapFill(this._images[3], _local_1);
            graphics.drawRect(0, this._images[0].height, this._images[3].width, ((_height - this._images[0].height) - this._images[6].height));
            _local_1.tx = this._images[0].width;
            _local_1.ty = this._images[0].height;
            graphics.beginBitmapFill(this._images[4], _local_1);
            graphics.drawRect(this._images[0].width, this._images[0].height, ((_width - this._images[0].width) - this._images[2].width), ((_height - this._images[0].height) - this._images[6].height));
            _local_1.tx = (_width - this._images[5].width);
            _local_1.ty = this._images[2].height;
            graphics.beginBitmapFill(this._images[5], _local_1);
            graphics.drawRect((_width - this._images[5].width), this._images[2].height, this._images[5].width, ((_height - this._images[2].height) - this._images[8].height));
            _local_1.tx = 0;
            _local_1.ty = (_height - this._images[6].height);
            graphics.beginBitmapFill(this._images[6], _local_1);
            graphics.drawRect(0, (_height - this._images[6].height), this._images[6].width, this._images[6].height);
            _local_1.tx = this._images[6].width;
            _local_1.ty = (_height - this._images[7].height);
            graphics.beginBitmapFill(this._images[7], _local_1);
            graphics.drawRect(this._images[6].width, (_height - this._images[7].height), ((_width - this._images[6].width) - this._images[8].width), this._images[7].height);
            _local_1.tx = (_width - this._images[8].width);
            _local_1.ty = (_height - this._images[8].height);
            graphics.beginBitmapFill(this._images[8], _local_1);
            graphics.drawRect((_width - this._images[8].width), (_height - this._images[8].height), this._images[8].width, this._images[8].height);
            graphics.endFill();
        }

        private function removeImages():void
        {
            if (this._images == null)
            {
                return;
            };
            graphics.clear();
            var _local_1:int;
            while (_local_1 < this._images.length)
            {
                ObjectUtils.disposeObject(this._images[_local_1]);
                _local_1++;
            };
        }


    }
}//package com.pickgliss.ui.image

