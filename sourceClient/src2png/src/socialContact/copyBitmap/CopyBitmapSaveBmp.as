// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//socialContact.copyBitmap.CopyBitmapSaveBmp

package socialContact.copyBitmap
{
    import flash.display.BitmapData;
    import com.pickgliss.toplevel.StageReferance;
    import flash.geom.Rectangle;
    import flash.geom.Point;
    import flash.utils.ByteArray;

    public class CopyBitmapSaveBmp 
    {

        private var _jpgEncder:JPGEncoder = new JPGEncoder();
        private var _bitmapData:BitmapData;


        public function copyBmp(_arg_1:int, _arg_2:int, _arg_3:int, _arg_4:int):void
        {
            var _local_5:BitmapData = new BitmapData(StageReferance.stage.stageWidth, StageReferance.stage.stageHeight);
            _local_5.draw(StageReferance.stage);
            this._bitmapData = new BitmapData(Math.abs((_arg_3 - _arg_1)), Math.abs((_arg_4 - _arg_2)));
            var _local_6:int = ((_arg_1 < _arg_3) ? _arg_1 : _arg_3);
            var _local_7:int = ((_arg_2 < _arg_4) ? _arg_2 : _arg_4);
            this._bitmapData.copyPixels(_local_5, new Rectangle(_local_6, _local_7, Math.abs((_arg_3 - _arg_1)), Math.abs((_arg_4 - _arg_2))), new Point(0, 0));
            _local_5.dispose();
            _local_5 = null;
        }

        public function get bitmapData():ByteArray
        {
            return (this._jpgEncder.encode(this._bitmapData));
        }


    }
}//package socialContact.copyBitmap

