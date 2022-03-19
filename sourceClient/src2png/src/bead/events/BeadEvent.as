// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//bead.events.BeadEvent

package bead.events
{
    import flash.events.Event;

    public class BeadEvent extends Event 
    {

        public static const BEAD_LOCK:String = "bead_Lock";
        public static const SHOW_ConfirmFrme:String = "showConfirmFrame";

        public var data:Object;

        public function BeadEvent(_arg_1:String, _arg_2:Object=null, _arg_3:Boolean=false, _arg_4:Boolean=false)
        {
            super(_arg_1, _arg_3, _arg_4);
            this.data = _arg_2;
        }

    }
}//package bead.events

