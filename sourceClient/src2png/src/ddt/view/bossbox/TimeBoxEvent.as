// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//ddt.view.bossbox.TimeBoxEvent

package ddt.view.bossbox
{
    import flash.events.Event;

    public class TimeBoxEvent extends Event 
    {

        public static const UPDATETIMECOUNT:String = "updateTimeCount";
        public static const UPDATESMALLBOXBUTTONSTATE:String = "update_smallBoxButton_state";
        public static const CLOSE_BOX:String = "close_box";

        public var delaySumTime:int = 0;
        public var boxButtonShowType:int = 0;

        public function TimeBoxEvent(_arg_1:String, _arg_2:Boolean=false, _arg_3:Boolean=false)
        {
            super(_arg_1, _arg_2, _arg_3);
        }

    }
}//package ddt.view.bossbox

