// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//com.pickgliss.ui.image.MovieImage

package com.pickgliss.ui.image
{
    import flash.display.MovieClip;
    import com.pickgliss.ui.core.Component;
    import com.pickgliss.utils.ClassUtils;

    public class MovieImage extends Image 
    {


        public function get movie():MovieClip
        {
            return (_display as MovieClip);
        }

        override public function setFrame(_arg_1:int):void
        {
            super.setFrame(_arg_1);
            this.movie.gotoAndStop(_arg_1);
            if (_width != Math.round(this.movie.width))
            {
                _width = Math.round(this.movie.width);
                _changedPropeties[Component.P_width] = true;
            };
        }

        override protected function resetDisplay():void
        {
            if (_display)
            {
                removeChild(_display);
            };
            _display = ClassUtils.CreatInstance(_resourceLink);
        }


    }
}//package com.pickgliss.ui.image

