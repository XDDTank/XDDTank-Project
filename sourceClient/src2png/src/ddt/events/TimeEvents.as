// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//ddt.events.TimeEvents

package ddt.events
{
    import flash.events.Event;

    public class TimeEvents extends Event 
    {

        public static const SECONDS:String = "seconds";
        public static const MINUTES:String = "minutes";
        public static const HOURS:String = "hours";

        public function TimeEvents(_arg_1:String)
        {
            super(_arg_1, false, false);
        }

    }
}//package ddt.events

