// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//com.pickgliss.events.InteractiveEvent

package com.pickgliss.events
{
    import flash.events.Event;

    public class InteractiveEvent extends Event 
    {

        public static const STATE_CHANGED:String = "stateChange";
        public static const CLICK:String = "interactive_click";
        public static const MOUSE_DOWN:String = "interactive_down";
        public static const MOUSE_Up:String = "interactive_up";
        public static const DOUBLE_CLICK:String = "interactive_double_click";

        public var ctrlKey:Boolean;

        public function InteractiveEvent(_arg_1:String)
        {
            super(_arg_1);
        }

    }
}//package com.pickgliss.events

