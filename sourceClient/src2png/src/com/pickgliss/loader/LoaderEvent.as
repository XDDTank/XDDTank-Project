// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//com.pickgliss.loader.LoaderEvent

package com.pickgliss.loader
{
    import flash.events.Event;

    public class LoaderEvent extends Event 
    {

        public static const COMPLETE:String = "complete";
        public static const LOAD_ERROR:String = "loadError";
        public static const PROGRESS:String = "progress";

        public var loader:BaseLoader;

        public function LoaderEvent(_arg_1:String, _arg_2:BaseLoader)
        {
            this.loader = _arg_2;
            super(_arg_1);
        }

    }
}//package com.pickgliss.loader

