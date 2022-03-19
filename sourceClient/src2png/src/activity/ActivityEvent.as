// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//activity.ActivityEvent

package activity
{
    import flash.events.Event;

    public class ActivityEvent extends Event 
    {

        public static const BUTTON_CHANGE:String = "buttonChange";
        public static const ACTIVITY_UPDATE:String = "activityUpdate";
        public static const GET_RAWARD:String = "getReward";

        public var data:Object;

        public function ActivityEvent(_arg_1:String, _arg_2:Object=null)
        {
            super(_arg_1);
            this.data = _arg_2;
        }

    }
}//package activity

