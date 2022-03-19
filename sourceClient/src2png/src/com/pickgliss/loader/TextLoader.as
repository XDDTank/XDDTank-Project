// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//com.pickgliss.loader.TextLoader

package com.pickgliss.loader
{
    import flash.net.URLVariables;
    import flash.events.Event;
    import flash.net.URLLoaderDataFormat;

    public class TextLoader extends BaseLoader 
    {

        public static var TextLoaderKey:String;

        public function TextLoader(_arg_1:int, _arg_2:String, _arg_3:URLVariables=null, _arg_4:String="GET")
        {
            super(_arg_1, _arg_2, _arg_3, _arg_4);
        }

        override public function get content():*
        {
            return (_loader.data);
        }

        override protected function __onDataLoadComplete(_arg_1:Event):void
        {
            removeEvent();
            _loader.close();
            if (analyzer)
            {
                analyzer.analyzeCompleteCall = fireCompleteEvent;
                analyzer.analyzeErrorCall = fireErrorEvent;
                analyzer.analyze(_loader.data);
            }
            else
            {
                fireCompleteEvent();
            };
        }

        override protected function getLoadDataFormat():String
        {
            return (URLLoaderDataFormat.TEXT);
        }

        override public function get type():int
        {
            return (BaseLoader.TEXT_LOADER);
        }


    }
}//package com.pickgliss.loader

