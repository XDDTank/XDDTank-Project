// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//com.pickgliss.ui.image.ScaleBitmapImage

package com.pickgliss.ui.image
{
    import flash.display.BitmapData;
    import com.pickgliss.utils.ObjectUtils;
    import com.pickgliss.utils.ClassUtils;
    import org.bytearray.display.ScaleBitmap;

    public class ScaleBitmapImage extends Image 
    {

        private var _resource:BitmapData;


        public function set resource(_arg_1:BitmapData):void
        {
            if (_arg_1 == this._resource)
            {
                return;
            };
            this._resource = _arg_1;
            onPropertiesChanged(Image.P_reourceLink);
        }

        public function get resource():BitmapData
        {
            return (this._resource);
        }

        override protected function resetDisplay():void
        {
            ObjectUtils.disposeObject(_display);
            var _local_1:BitmapData = ((this._resource == null) ? ClassUtils.CreatInstance(_resourceLink, [_width, _height]) : this._resource);
            _display = new ScaleBitmap(_local_1);
        }


    }
}//package com.pickgliss.ui.image

