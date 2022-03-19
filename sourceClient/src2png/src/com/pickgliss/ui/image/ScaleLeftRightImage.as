// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//com.pickgliss.ui.image.ScaleLeftRightImage

package com.pickgliss.ui.image
{
    import __AS3__.vec.Vector;
    import flash.display.Bitmap;
    import com.pickgliss.ui.ComponentFactory;
    import com.pickgliss.ui.core.Component;
    import com.pickgliss.utils.ObjectUtils;
    import __AS3__.vec.*;

    public class ScaleLeftRightImage extends Image 
    {

        private var _bitmaps:Vector.<Bitmap>;
        private var _imageLinks:Array;


        override public function dispose():void
        {
            this.removeImages();
            graphics.clear();
            this._bitmaps = null;
            super.dispose();
        }

        override protected function addChildren():void
        {
            if (this._bitmaps == null)
            {
                return;
            };
            addChild(this._bitmaps[0]);
            addChild(this._bitmaps[2]);
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
            var _local_2:Bitmap;
            this._bitmaps = new Vector.<Bitmap>();
            var _local_1:int;
            while (_local_1 < this._imageLinks.length)
            {
                _local_2 = ComponentFactory.Instance.creat(this._imageLinks[_local_1]);
                this._bitmaps.push(_local_2);
                _local_1++;
            };
            _height = this._bitmaps[1].bitmapData.height;
            _changedPropeties[Component.P_height] = true;
        }

        private function drawImage():void
        {
            graphics.clear();
            graphics.beginBitmapFill(this._bitmaps[1].bitmapData);
            graphics.drawRect(this._bitmaps[0].width, 0, ((_width - this._bitmaps[0].width) - this._bitmaps[2].width), _height);
            graphics.endFill();
            this._bitmaps[2].x = (_width - this._bitmaps[2].width);
        }

        private function removeImages():void
        {
            if (this._bitmaps == null)
            {
                return;
            };
            var _local_1:int;
            while (_local_1 < this._bitmaps.length)
            {
                ObjectUtils.disposeObject(this._bitmaps[_local_1]);
                _local_1++;
            };
        }


    }
}//package com.pickgliss.ui.image

