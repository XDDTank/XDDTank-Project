// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//ddt.events.DebugEvent

package ddt.events
{
    import flash.events.Event;

    public class DebugEvent extends Event 
    {

        public static const DEBUG:String = "debug";

        public var data:*;

        public function DebugEvent(_arg_1:String, _arg_2:*)
        {
            super(_arg_1);
            this.data = _arg_2;
        }

    }
}//package ddt.events

