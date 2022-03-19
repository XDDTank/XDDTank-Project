// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//im.IMEvent

package im
{
    import flash.events.Event;

    public class IMEvent extends Event 
    {

        public static const ADDNEW_FRIEND:String = "addnewfriend";
        public static const ADD_NEW_GROUP:String = "addNewGroup";
        public static const UPDATE_GROUP:String = "updateGroup";
        public static const DELETE_GROUP:String = "deleteGroup";

        public var data:Object;

        public function IMEvent(_arg_1:String, _arg_2:Object=null, _arg_3:Boolean=false, _arg_4:Boolean=false)
        {
            this.data = _arg_2;
            super(_arg_1, _arg_3, _arg_4);
        }

    }
}//package im

