// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//room.events.RoomPlayerEvent

package room.events
{
    import flash.events.Event;

    public class RoomPlayerEvent extends Event 
    {

        public static const READY_CHANGE:String = "readyChange";
        public static const IS_HOST_CHANGE:String = "isHostChange";
        public static const PROGRESS_CHANGE:String = "progressChange";
        public static const IS_START:String = "isStart";

        public function RoomPlayerEvent(_arg_1:String, _arg_2:Boolean=false, _arg_3:Boolean=false)
        {
            super(_arg_1, _arg_2, _arg_3);
        }

    }
}//package room.events

