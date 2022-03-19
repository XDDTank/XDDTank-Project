// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//com.pickgliss.events.FrameEvent

package com.pickgliss.events
{
    import flash.events.Event;

    public class FrameEvent extends Event 
    {

        public static const CANCEL_CLICK:int = 4;
        public static const CLOSE_CLICK:int = 0;
        public static const ENTER_CLICK:int = 2;
        public static const ESC_CLICK:int = 1;
        public static const RESPONSE:String = "response";
        public static const SUBMIT_CLICK:int = 3;
        public static const MINIMIZE_CLICK:int = 5;
        public static const HELP_CLICK:int = 6;
        public static const HELP_CLOSE:int = 7;

        public var responseCode:int = -1;

        public function FrameEvent(_arg_1:int)
        {
            this.responseCode = _arg_1;
            super(RESPONSE);
        }

    }
}//package com.pickgliss.events

