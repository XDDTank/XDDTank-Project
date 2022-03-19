// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//ddt.events.EffortEvent

package ddt.events
{
    import flash.events.Event;
    import ddt.data.effort.EffortInfo;

    public class EffortEvent extends Event 
    {

        public static const INIT:String = "init";
        public static const CHANGED:String = "changed";
        public static const LIST_CHANGED:String = "listChanged";
        public static const TYPE_CHANGED:String = "typeChanged";
        public static const ADD:String = "add";
        public static const REMOVE:String = "remove";
        public static const FINISH:String = "finish";

        private var _info:EffortInfo;

        public function EffortEvent(_arg_1:String, _arg_2:EffortInfo=null)
        {
            this._info = _arg_2;
            super(_arg_1, false, false);
        }

    }
}//package ddt.events

