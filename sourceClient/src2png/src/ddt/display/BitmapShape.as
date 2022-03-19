// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//ddt.display.BitmapShape

package ddt.display
{
    import flash.display.Shape;
    import com.pickgliss.ui.core.Disposeable;
    import flash.geom.Matrix;
    import flash.display.Graphics;

    public class BitmapShape extends Shape implements Disposeable 
    {

        private var _bitmap:BitmapObject;
        private var _matrix:Matrix;
        private var _repeat:Boolean;
        private var _smooth:Boolean;

        public function BitmapShape(_arg_1:BitmapObject=null, _arg_2:Matrix=null, _arg_3:Boolean=true, _arg_4:Boolean=false)
        {
            this._bitmap = _arg_1;
            this._matrix = _arg_2;
            this._repeat = _arg_3;
            this._smooth = _arg_4;
            this.draw();
        }

        public function set bitmapObject(_arg_1:BitmapObject):void
        {
        }

        public function get bitmapObject():BitmapObject
        {
            return (this._bitmap);
        }

        protected function draw():void
        {
            var _local_1:Graphics;
            if (this._bitmap)
            {
                _local_1 = graphics;
                _local_1.clear();
                _local_1.beginBitmapFill(this._bitmap, this._matrix, this._repeat, this._smooth);
                _local_1.drawRect(0, 0, this._bitmap.width, this._bitmap.height);
                _local_1.endFill();
            };
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
            };
        }


    }
}//package ddt.display

