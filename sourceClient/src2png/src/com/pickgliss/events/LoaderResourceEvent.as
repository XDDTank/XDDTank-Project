// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//com.pickgliss.events.LoaderResourceEvent

package com.pickgliss.events
{
    import flash.events.Event;

    public class LoaderResourceEvent extends Event 
    {

        public static const INIT_COMPLETE:String = "init complete";
        public static const COMPLETE:String = "complete";
        public static const LOAD_ERROR:String = "loadError";
        public static const PROGRESS:String = "progress";
        public static const DELETE:String = "delete";

        public var filePath:String;
        public var data:*;
        public var progress:Number;

        public function LoaderResourceEvent(_arg_1:String)
        {
            super(_arg_1);
        }

    }
}//package com.pickgliss.events

