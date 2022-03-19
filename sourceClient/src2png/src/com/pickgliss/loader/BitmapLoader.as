// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//com.pickgliss.loader.BitmapLoader

package com.pickgliss.loader
{
    import flash.display.Bitmap;
    import flash.display.BitmapData;
    import flash.events.Event;

    public class BitmapLoader extends DisplayLoader 
    {

        private static const InvalidateBitmapDataID:int = 2015;

        private var _sourceBitmap:Bitmap;

        public function BitmapLoader(_arg_1:int, _arg_2:String)
        {
            super(_arg_1, _arg_2);
        }

        override public function get content():*
        {
            if (this._sourceBitmap == null)
            {
                return (null);
            };
            return (this._sourceBitmap);
        }

        public function get bitmapData():BitmapData
        {
            if (this._sourceBitmap)
            {
                return (this._sourceBitmap.bitmapData);
            };
            return (null);
        }

        override protected function __onContentLoadComplete(_arg_1:Event):void
        {
            this._sourceBitmap = (_displayLoader.content as Bitmap);
            super.__onContentLoadComplete(_arg_1);
        }

        override public function get type():int
        {
            return (BaseLoader.BITMAP_LOADER);
        }


    }
}//package com.pickgliss.loader

