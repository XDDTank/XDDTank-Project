// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//ddt.display.BitmapSprite

package ddt.display
{
    import flash.display.Sprite;
    import com.pickgliss.ui.core.Disposeable;
    import flash.geom.Matrix;
    import flash.display.Graphics;

    public class BitmapSprite extends Sprite implements Disposeable 
    {

        protected var _bitmap:BitmapObject;
        protected var _matrix:Matrix;
        protected var _repeat:Boolean;
        protected var _smooth:Boolean;
        protected var _w:int;
        protected var _h:int;

        public function BitmapSprite(_arg_1:BitmapObject=null, _arg_2:Matrix=null, _arg_3:Boolean=true, _arg_4:Boolean=false)
        {
            this._bitmap = _arg_1;
            this._matrix = _arg_2;
            this._repeat = _arg_3;
            this._smooth = _arg_4;
            this.configUI();
        }

        public function set bitmapObject(_arg_1:BitmapObject):void
        {
            var _local_2:BitmapObject = this._bitmap;
            this._bitmap = _arg_1;
            this.drawBitmap();
            if (_local_2)
            {
                _local_2.dispose();
            };
        }

        public function get bitmapObject():BitmapObject
        {
            return (this._bitmap);
        }

        protected function drawBitmap():void
        {
            var _local_1:Graphics;
            graphics.clear();
            if (this._bitmap)
            {
                _local_1 = graphics;
                _local_1.beginBitmapFill(this._bitmap, this._matrix, this._repeat, this._smooth);
                _local_1.drawRect(0, 0, this._bitmap.width, this._bitmap.height);
                _local_1.endFill();
            };
        }

        protected function clearBitmap():void
        {
            graphics.clear();
            if (this._bitmap)
            {
                this._bitmap.dispose();
                this._bitmap = null;
            };
        }

        protected function configUI():void
        {
            this.drawBitmap();
        }

        public function dispose():void
        {
            if (parent)
            {
                parent.removeChild(this);
            };
            if (this._bitmap)
            {
                this._bitmap.dispose();
                this._bitmap = null;
            };
        }


    }
}//package ddt.display

