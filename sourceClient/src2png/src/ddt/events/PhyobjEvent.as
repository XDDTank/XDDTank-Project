// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//ddt.events.PhyobjEvent

package ddt.events
{
    import flash.events.Event;

    public class PhyobjEvent extends Event 
    {

        public static const CHANGE:String = "phyobjChange";

        public var action:String;

        public function PhyobjEvent(_arg_1:String, _arg_2:Boolean=false, _arg_3:Boolean=false)
        {
            super(PhyobjEvent.CHANGE, _arg_2, _arg_3);
            this.action = _arg_1;
        }

    }
}//package ddt.events

