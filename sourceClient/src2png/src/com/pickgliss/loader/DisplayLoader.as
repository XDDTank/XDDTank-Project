// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//com.pickgliss.loader.DisplayLoader

package com.pickgliss.loader
{
    import flash.system.LoaderContext;
    import flash.display.Loader;
    import flash.events.Event;
    import flash.events.IOErrorEvent;
    import flash.utils.ByteArray;
    import flash.net.URLLoaderDataFormat;

    public class DisplayLoader extends BaseLoader 
    {

        public static var Context:LoaderContext;
        public static var isDebug:Boolean = false;

        protected var _displayLoader:Loader = new Loader();

        public function DisplayLoader(_arg_1:int, _arg_2:String)
        {
            super(_arg_1, _arg_2, null);
        }

        override public function loadFromBytes(_arg_1:ByteArray):void
        {
            super.loadFromBytes(_arg_1);
            this._displayLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, this.__onContentLoadComplete);
            this._displayLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, this.__onIoError);
            if (this.type == BaseLoader.MODULE_LOADER)
            {
                this._displayLoader.loadBytes(_arg_1, Context);
            }
            else
            {
                this._displayLoader.loadBytes(_arg_1);
            };
        }

        private function __onIoError(_arg_1:IOErrorEvent):void
        {
            this._displayLoader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, this.__onIoError);
            throw (new Error(((_arg_1.text + " url: ") + _url)));
        }

        protected function __onContentLoadComplete(_arg_1:Event):void
        {
            this._displayLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE, this.__onContentLoadComplete);
            this._displayLoader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, this.__onIoError);
            fireCompleteEvent();
            this._displayLoader.unload();
            this._displayLoader = null;
        }

        override protected function __onDataLoadComplete(_arg_1:Event):void
        {
            removeEvent();
            _loader.close();
            if (_loader.data.length == 0)
            {
                return;
            };
            LoaderSavingManager.cacheFile(_url, _loader.data, true);
            this.loadFromBytes(_loader.data);
        }

        override public function get content():*
        {
            return (this._displayLoader.content);
        }

        override protected function getLoadDataFormat():String
        {
            return (URLLoaderDataFormat.BINARY);
        }

        override public function get type():int
        {
            return (BaseLoader.DISPLAY_LOADER);
        }


    }
}//package com.pickgliss.loader

