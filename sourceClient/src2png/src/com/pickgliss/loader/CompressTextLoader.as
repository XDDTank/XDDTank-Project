// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//com.pickgliss.loader.CompressTextLoader

package com.pickgliss.loader
{
    import flash.net.URLVariables;
    import flash.utils.ByteArray;
    import flash.events.Event;

    public class CompressTextLoader extends BaseLoader 
    {

        private var _deComressedText:String;

        public function CompressTextLoader(_arg_1:int, _arg_2:String, _arg_3:URLVariables=null, _arg_4:String="GET")
        {
            if (_arg_3 == null)
            {
                _arg_3 = new URLVariables();
            };
            if (_arg_3["rnd"] == null)
            {
                _arg_3["rnd"] = TextLoader.TextLoaderKey;
            };
            super(_arg_1, _arg_2, _arg_3, _arg_4);
        }

        override protected function __onDataLoadComplete(_arg_1:Event):void
        {
            removeEvent();
            _loader.close();
            var _local_2:ByteArray = _loader.data;
            _local_2.uncompress();
            _local_2.position = 0;
            this._deComressedText = _local_2.readUTFBytes(_local_2.bytesAvailable);
            if (analyzer)
            {
                analyzer.analyzeCompleteCall = fireCompleteEvent;
                analyzer.analyzeErrorCall = fireErrorEvent;
                analyzer.analyze(this._deComressedText);
            }
            else
            {
                fireCompleteEvent();
            };
        }

        override public function get content():*
        {
            return (this._deComressedText);
        }

        override public function get type():int
        {
            return (BaseLoader.COMPRESS_TEXT_LOADER);
        }


    }
}//package com.pickgliss.loader

