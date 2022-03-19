// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//ddt.events.SharedEvent

package ddt.events
{
    import flash.events.Event;

    public class SharedEvent extends Event 
    {

        public static const TRANSPARENTCHANGED:String = "transparentChanged";

        public function SharedEvent(_arg_1:String, _arg_2:Boolean=false, _arg_3:Boolean=false)
        {
            super(_arg_1, _arg_2, _arg_3);
        }

    }
}//package ddt.events

