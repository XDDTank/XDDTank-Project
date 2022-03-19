// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//ddt.events.TempleteLoaderEvent

package ddt.events
{
    import flash.events.Event;

    public class TempleteLoaderEvent extends Event 
    {

        public static const LOAD_COMPLETE:String = "TempleteLoadComplete";
        public static const LOAD_ERROR:String = "TempleteLoadError";
        public static const LOAD_PROGRESS:String = "TempleteLoadProgress";
        public static const ZIP_COMPLETE:String = "TempleteZipComplete";
        public static const ZIP_ERROR:String = "TempleteZipError";
        public static const ZIP_PROGRESS:String = "TempleteZipProgress";

        public var data:Object;

        public function TempleteLoaderEvent(_arg_1:String, _arg_2:Object=null, _arg_3:Boolean=false, _arg_4:Boolean=false)
        {
            super(_arg_1, _arg_3, _arg_4);
            this.data = _arg_2;
        }

    }
}//package ddt.events

