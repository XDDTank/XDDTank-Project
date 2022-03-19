// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//phy.maps.Tile

package phy.maps
{
    import flash.display.Bitmap;
    import flash.display.BitmapData;
    import flash.geom.Matrix;
    import flash.display.BlendMode;
    import flash.geom.Point;
    import flash.geom.Rectangle;

    public class Tile extends Bitmap 
    {

        private var _digable:Boolean;

        public function Tile(_arg_1:BitmapData, _arg_2:Boolean)
        {
            super(_arg_1);
            this._digable = _arg_2;
            this.cacheAsBitmap = true;
        }

        public function Dig(_arg_1:Point, _arg_2:Bitmap, _arg_3:Bitmap=null):void
        {
            var _local_5:BitmapData;
            var _local_4:Matrix = new Matrix(1, 0, 0, 1, _arg_1.x, _arg_1.y);
            if (((_arg_2) && (this._digable)))
            {
                _local_4.tx = (_local_4.tx - (_arg_2.width / 2));
                _local_4.ty = (_local_4.ty - (_arg_2.height / 2));
                bitmapData.draw(_arg_2, _local_4, null, BlendMode.ERASE);
            };
            if (((_arg_3) && (this._digable)))
            {
                _local_5 = _arg_3.bitmapData.clone();
                _local_4.tx = (-(_arg_1.x) + (_arg_3.width / 2));
                _local_4.ty = (-(_arg_1.y) + (_arg_3.height / 2));
                _local_5.draw(this, _local_4, null, BlendMode.ALPHA);
                _local_4.tx = (_arg_1.x - (_arg_3.width / 2));
                _local_4.ty = (_arg_1.y - (_arg_3.height / 2));
                bitmapData.draw(_local_5, _local_4, null, _arg_3.blendMode);
                _local_5.dispose();
            };
        }

        public function DigFillRect(_arg_1:Rectangle):void
        {
            bitmapData.fillRect(_arg_1, 0);
        }

        public function GetAlpha(_arg_1:int, _arg_2:int):uint
        {
            return ((bitmapData.getPixel32(_arg_1, _arg_2) >> 24) & 0xFF);
        }

        public function dispose():void
        {
            bitmapData.dispose();
        }


    }
}//package phy.maps

