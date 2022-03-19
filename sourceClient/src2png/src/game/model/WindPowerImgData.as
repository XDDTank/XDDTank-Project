// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//game.model.WindPowerImgData

package game.model
{
    import flash.events.EventDispatcher;
    import __AS3__.vec.Vector;
    import flash.display.BitmapData;
    import flash.display.Loader;
    import flash.display.Bitmap;
    import flash.events.Event;
    import flash.utils.ByteArray;
    import flash.geom.Point;
    import __AS3__.vec.*;

    public class WindPowerImgData extends EventDispatcher 
    {

        private var _imgBitmapVec:Vector.<BitmapData>;

        public function WindPowerImgData()
        {
            this._init();
        }

        private function _init():void
        {
            var _local_1:int;
            var _local_2:BitmapData;
            this._imgBitmapVec = new Vector.<BitmapData>();
            while (_local_1 < 11)
            {
                _local_2 = new BitmapData(1, 1);
                this._imgBitmapVec.push(_local_2);
                _local_1++;
            };
        }

        public function refeshData(bmpBytData:ByteArray, bmpID:int):void
        {
            var imgLoad:Loader;
            var _imgLoadOk:Function;
            _imgLoadOk = function (_arg_1:Event):void
            {
                BitmapData(_imgBitmapVec[bmpID]).dispose();
                _imgBitmapVec[bmpID] = Bitmap(imgLoad.contentLoaderInfo.content).bitmapData;
                imgLoad.contentLoaderInfo.removeEventListener(Event.COMPLETE, _imgLoadOk);
                imgLoad.unload();
                imgLoad = null;
            };
            imgLoad = new Loader();
            imgLoad.contentLoaderInfo.addEventListener(Event.COMPLETE, _imgLoadOk);
            imgLoad.loadBytes(bmpBytData);
        }

        public function getImgBmp(_arg_1:Array):BitmapData
        {
            var _local_4:int;
            var _local_2:BitmapData = new BitmapData(((this._imgBitmapVec[_arg_1[1]].width + this._imgBitmapVec[_arg_1[2]].width) + this._imgBitmapVec[_arg_1[3]].width), this._imgBitmapVec[0].height);
            var _local_3:int = 1;
            while (_local_3 <= 3)
            {
                _local_4 = 0;
                switch (_local_3)
                {
                    case 2:
                        _local_4 = this._imgBitmapVec[_arg_1[1]].width;
                        break;
                    case 3:
                        _local_4 = (this._imgBitmapVec[_arg_1[1]].width + this._imgBitmapVec[_arg_1[2]].width);
                        break;
                };
                _local_2.copyPixels(this._imgBitmapVec[_arg_1[_local_3]], this._imgBitmapVec[_arg_1[_local_3]].rect, new Point(_local_4, 0));
                _local_3++;
            };
            return (_local_2);
        }

        public function getImgBmpById(_arg_1:int):BitmapData
        {
            return (this._imgBitmapVec[_arg_1]);
        }


    }
}//package game.model

