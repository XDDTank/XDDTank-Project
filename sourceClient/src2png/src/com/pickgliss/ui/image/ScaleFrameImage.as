// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//com.pickgliss.ui.image.ScaleFrameImage

package com.pickgliss.ui.image
{
    import __AS3__.vec.Vector;
    import flash.display.DisplayObject;
    import flash.display.MovieClip;
    import com.pickgliss.ui.core.Component;
    import com.pickgliss.ui.ComponentFactory;
    import com.pickgliss.utils.StringUtils;
    import com.pickgliss.utils.ObjectUtils;
    import __AS3__.vec.*;

    public class ScaleFrameImage extends Image 
    {

        public static const P_fillAlphaRect:String = "fillAlphaRect";

        private var _currentFrame:uint;
        private var _fillAlphaRect:Boolean;
        private var _imageLinks:Array;
        private var _images:Vector.<DisplayObject>;


        override public function dispose():void
        {
            this.removeImages();
            this._images = null;
            this._imageLinks = null;
            super.dispose();
        }

        public function set fillAlphaRect(_arg_1:Boolean):void
        {
            if (this._fillAlphaRect == _arg_1)
            {
                return;
            };
            this._fillAlphaRect = _arg_1;
            onPropertiesChanged(P_fillAlphaRect);
        }

        public function get getFrame():uint
        {
            return (this._currentFrame);
        }

        override public function setFrame(_arg_1:int):void
        {
            super.setFrame(_arg_1);
            this._currentFrame = _arg_1;
            var _local_2:int;
            while (_local_2 < this._images.length)
            {
                if (this._images[_local_2] != null)
                {
                    if ((_arg_1 - 1) == _local_2)
                    {
                        addChild(this._images[_local_2]);
                        if ((this._images[_local_2] is MovieImage))
                        {
                            ((this._images[_local_2] as MovieImage).display as MovieClip).gotoAndPlay(1);
                        };
                        if (_width != Math.round(this._images[_local_2].width))
                        {
                            _width = Math.round(this._images[_local_2].width);
                            _changedPropeties[Component.P_width] = true;
                        };
                    }
                    else
                    {
                        if (((this._images[_local_2]) && (this._images[_local_2].parent)))
                        {
                            removeChild(this._images[_local_2]);
                        };
                    };
                };
                _local_2++;
            };
            this.fillRect();
        }

        private function fillRect():void
        {
            if (this._fillAlphaRect)
            {
                graphics.beginFill(0xFF00FF, 0);
                graphics.drawRect(0, 0, _width, _height);
                graphics.endFill();
            };
        }

        override protected function init():void
        {
            super.init();
        }

        override protected function resetDisplay():void
        {
            this._imageLinks = ComponentFactory.parasArgs(_resourceLink);
            this.removeImages();
            this.fillImages();
            this.creatFrameImage(0);
        }

        override protected function updateSize():void
        {
            var _local_1:int;
            if (this._images == null)
            {
                return;
            };
            if (((_changedPropeties[Component.P_width]) || (_changedPropeties[Component.P_height])))
            {
                _local_1 = 0;
                while (_local_1 < this._images.length)
                {
                    if (this._images[_local_1] != null)
                    {
                        this._images[_local_1].width = _width;
                        this._images[_local_1].height = _height;
                    };
                    _local_1++;
                };
            };
        }

        private function fillImages():void
        {
            this._images = new Vector.<DisplayObject>();
            var _local_1:int;
            while (_local_1 < this._imageLinks.length)
            {
                this._images.push(null);
                _local_1++;
            };
        }

        public function creatFrameImage(_arg_1:int):void
        {
            var _local_2:int;
            var _local_3:DisplayObject;
            _local_2 = 0;
            while (_local_2 < this._imageLinks.length)
            {
                if (((!(StringUtils.isEmpty(this._imageLinks[_local_2]))) && (this._images[_local_2] == null)))
                {
                    _local_3 = ComponentFactory.Instance.creat(this._imageLinks[_local_2]);
                    _width = Math.max(_width, _local_3.width);
                    _height = Math.max(_height, _local_3.height);
                    this._images[_local_2] = _local_3;
                    addChild(_local_3);
                };
                _local_2++;
            };
        }

        public function getFrameImage(_arg_1:int):DisplayObject
        {
            return (this._images[_arg_1]);
        }

        private function removeImages():void
        {
            if (this._images == null)
            {
                return;
            };
            var _local_1:int;
            while (_local_1 < this._images.length)
            {
                ObjectUtils.disposeObject(this._images[_local_1]);
                _local_1++;
            };
        }

        public function get totalFrames():int
        {
            return (this._images.length);
        }


    }
}//package com.pickgliss.ui.image

