// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//ddt.events.DuowanInterfaceEvent

package ddt.events
{
    import flash.events.Event;

    public class DuowanInterfaceEvent extends Event 
    {

        public static const ADD_ROLE:String = "addRole";
        public static const UP_GRADE:String = "upGrade";
        public static const ONLINE:String = "onLine";
        public static const OUTLINE:String = "outLine";

        public var data:Object;

        public function DuowanInterfaceEvent(_arg_1:String, _arg_2:Object=null)
        {
            super(_arg_1);
            this.data = _arg_2;
        }

    }
}//package ddt.events

