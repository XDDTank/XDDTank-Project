// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//road7th.utils.BitmapReader

package road7th.utils
{
    import flash.events.EventDispatcher;
    import flash.display.Loader;
    import flash.display.Bitmap;
    import flash.events.Event;
    import flash.utils.ByteArray;

    public class BitmapReader extends EventDispatcher 
    {

        private var loader:Loader;
        public var bitmap:Bitmap;


        public function readByteArray(_arg_1:ByteArray):void
        {
            this.loader = new Loader();
            this.loader.contentLoaderInfo.addEventListener(Event.COMPLETE, this.dataComplete);
            this.loader.loadBytes(_arg_1);
        }

        public function dataComplete(_arg_1:Event):void
        {
            this.bitmap = _arg_1.target.content;
            dispatchEvent(new Event(Event.COMPLETE));
        }


    }
}//package road7th.utils

