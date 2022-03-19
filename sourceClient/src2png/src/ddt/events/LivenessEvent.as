// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//ddt.events.LivenessEvent

package ddt.events
{
    import flash.events.Event;

    public class LivenessEvent extends Event 
    {

        public static const TASK_DIRECT:String = "taskDirect";
        public static const SHOW_SHINE:String = "showShine";
        public static const REFLASH_LIVENESS:String = "reflashLiveness";

        private var _info:Object;

        public function LivenessEvent(_arg_1:String, _arg_2:*=null)
        {
            this._info = _arg_2;
            super(_arg_1, false, false);
        }

        public function get info():Object
        {
            return (this._info);
        }


    }
}//package ddt.events

