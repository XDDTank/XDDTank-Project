// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//com.pickgliss.ui.image.MutipleImage

package com.pickgliss.ui.image
{
    import __AS3__.vec.Vector;
    import flash.display.DisplayObject;
    import com.pickgliss.geom.InnerRectangle;
    import com.pickgliss.utils.ObjectUtils;
    import com.pickgliss.ui.ComponentFactory;
    import com.pickgliss.utils.ClassUtils;
    import flash.display.Sprite;
    import flash.geom.Rectangle;
    import com.pickgliss.ui.core.Component;
    import __AS3__.vec.*;

    public class MutipleImage extends Image 
    {

        public static const P_imageRect:String = "imagesRect";

        private var _imageLinks:Array;
        private var _imageRectString:String;
        private var _images:Vector.<DisplayObject>;
        private var _imagesRect:Vector.<InnerRectangle>;


        override public function dispose():void
        {
            var _local_1:int;
            if (this._images)
            {
                _local_1 = 0;
                while (_local_1 < this._images.length)
                {
                    ObjectUtils.disposeObject(this._images[_local_1]);
                    _local_1++;
                };
            };
            this._images = null;
            this._imagesRect = null;
            super.dispose();
        }

        public function set imageRectString(_arg_1:String):void
        {
            if (this._imageRectString == _arg_1)
            {
                return;
            };
            this._imagesRect = new Vector.<InnerRectangle>();
            this._imageRectString = _arg_1;
            var _local_2:Array = ComponentFactory.parasArgs(this._imageRectString);
            var _local_3:int;
            while (_local_3 < _local_2.length)
            {
                if (String(_local_2[_local_3]) == "")
                {
                    this._imagesRect.push(null);
                }
                else
                {
                    this._imagesRect.push(ClassUtils.CreatInstance(ClassUtils.INNERRECTANGLE, String(_local_2[_local_3]).split("|")));
                };
                _local_3++;
            };
            onPropertiesChanged(P_imageRect);
        }

        override protected function addChildren():void
        {
            super.addChildren();
            if (this._images == null)
            {
                return;
            };
            var _local_1:int;
            while (_local_1 < this._images.length)
            {
                Sprite(_display).addChild(this._images[_local_1]);
                _local_1++;
            };
        }

        override protected function init():void
        {
            _display = new Sprite();
            super.init();
        }

        override protected function resetDisplay():void
        {
            this._imageLinks = ComponentFactory.parasArgs(_resourceLink);
            this.removeImages();
            this.creatImages();
        }

        override protected function updateSize():void
        {
            var _local_1:int;
            var _local_2:Rectangle;
            if (this._images == null)
            {
                return;
            };
            if ((((_changedPropeties[Component.P_width]) || (_changedPropeties[Component.P_height])) || (_changedPropeties[P_imageRect])))
            {
                _local_1 = 0;
                while (_local_1 < this._images.length)
                {
                    if (((this._imagesRect) && (this._imagesRect[_local_1])))
                    {
                        _local_2 = this._imagesRect[_local_1].getInnerRect(_width, _height);
                        this._images[_local_1].x = _local_2.x;
                        this._images[_local_1].y = _local_2.y;
                        this._images[_local_1].height = _local_2.height;
                        this._images[_local_1].width = _local_2.width;
                        _width = Math.max(_width, this._images[_local_1].width);
                        _height = Math.max(_height, this._images[_local_1].height);
                    }
                    else
                    {
                        this._images[_local_1].width = _width;
                        this._images[_local_1].height = _height;
                    };
                    _local_1++;
                };
            };
        }

        private function creatImages():void
        {
            var _local_2:DisplayObject;
            var _local_3:Array;
            this._images = new Vector.<DisplayObject>();
            var _local_1:int;
            while (_local_1 < this._imageLinks.length)
            {
                _local_3 = String(this._imageLinks[_local_1]).split("|");
                _local_2 = ComponentFactory.Instance.creat(_local_3[0]);
                this._images.push(_local_2);
                _local_1++;
            };
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


    }
}//package com.pickgliss.ui.image

