// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//com.pickgliss.ui.image.CloneImage

package com.pickgliss.ui.image
{
    import flash.display.BitmapData;
    import com.pickgliss.utils.ObjectUtils;
    import com.pickgliss.utils.ClassUtils;
    import flash.geom.Matrix;
    import com.pickgliss.ui.core.Component;

    public class CloneImage extends Image 
    {

        public static const P_direction:String = "direction";
        public static const P_gape:String = "gape";

        protected var _brush:BitmapData;
        protected var _direction:int = -1;
        protected var _gape:int = 0;
        private var _brushHeight:Number;
        private var _brushWidth:Number;


        public function set direction(_arg_1:int):void
        {
            if (this._direction == _arg_1)
            {
                return;
            };
            this._direction = _arg_1;
            onPropertiesChanged(P_direction);
        }

        override public function dispose():void
        {
            graphics.clear();
            ObjectUtils.disposeObject(this._brush);
            this._brush = null;
            super.dispose();
        }

        public function set gape(_arg_1:int):void
        {
            if (this._gape == _arg_1)
            {
                return;
            };
            this._gape = _arg_1;
            onPropertiesChanged(P_gape);
        }

        override protected function resetDisplay():void
        {
            graphics.clear();
            this._brushWidth = _width;
            this._brushHeight = _height;
            this._brush = ClassUtils.CreatInstance(_resourceLink, [0, 0]);
        }

        override protected function updateSize():void
        {
            var _local_1:int;
            var _local_2:Matrix;
            var _local_3:int;
            if (((((_changedPropeties[Component.P_width]) || (_changedPropeties[Component.P_height])) || (_changedPropeties[P_direction])) || (_changedPropeties[P_gape])))
            {
                _local_1 = 0;
                if (this._direction != -1)
                {
                    if (this._direction == 1)
                    {
                        _local_1 = int((_height / this._brush.height));
                    }
                    else
                    {
                        _local_1 = int((_width / this._brush.width));
                    };
                };
                graphics.clear();
                graphics.beginBitmapFill(this._brush);
                _local_2 = new Matrix();
                _local_3 = 0;
                while (_local_3 < _local_1)
                {
                    if (this._direction == 1)
                    {
                        graphics.drawRect(0, ((_local_3 * this._brush.height) + this._gape), this._brush.width, this._brush.height);
                    }
                    else
                    {
                        if (this._direction > 1)
                        {
                            graphics.drawRect(((_local_3 * this._brush.width) + this._gape), 0, this._brush.width, this._brush.height);
                        }
                        else
                        {
                            graphics.drawRect(0, 0, this._brush.width, this._brush.height);
                        };
                    };
                    _local_3++;
                };
                graphics.endFill();
            };
        }


    }
}//package com.pickgliss.ui.image

