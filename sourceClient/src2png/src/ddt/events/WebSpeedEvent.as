// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//ddt.events.WebSpeedEvent

package ddt.events
{
    import flash.events.Event;

    public class WebSpeedEvent extends Event 
    {

        public static const STATE_CHANE:String = "stateChange";

        public function WebSpeedEvent(_arg_1:String)
        {
            super(_arg_1, bubbles, cancelable);
        }

    }
}//package ddt.events

