// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//store.events.StoreDargEvent

package store.events
{
    import flash.events.Event;
    import ddt.data.goods.ItemTemplateInfo;

    public class StoreDargEvent extends Event 
    {

        public static const START_DARG:String = "startDarg";
        public static const STOP_DARG:String = "stopDarg";
        public static const CLICK:String = "click";

        public var sourceInfo:ItemTemplateInfo;

        public function StoreDargEvent(_arg_1:ItemTemplateInfo, _arg_2:String, _arg_3:Boolean=false, _arg_4:Boolean=false)
        {
            this.sourceInfo = _arg_1;
            super(_arg_2, _arg_3, _arg_4);
        }

    }
}//package store.events

