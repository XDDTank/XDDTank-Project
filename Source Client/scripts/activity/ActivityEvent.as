package activity
{
   import flash.events.Event;
   
   public class ActivityEvent extends Event
   {
      
      public static const BUTTON_CHANGE:String = "buttonChange";
      
      public static const ACTIVITY_UPDATE:String = "activityUpdate";
      
      public static const GET_RAWARD:String = "getReward";
       
      
      public var data:Object;
      
      public function ActivityEvent(param1:String, param2:Object = null)
      {
         super(param1);
         this.data = param2;
      }
   }
}
