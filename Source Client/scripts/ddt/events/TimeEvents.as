package ddt.events
{
   import flash.events.Event;
   
   public class TimeEvents extends Event
   {
      
      public static const SECONDS:String = "seconds";
      
      public static const MINUTES:String = "minutes";
      
      public static const HOURS:String = "hours";
       
      
      public function TimeEvents(param1:String)
      {
         super(param1,false,false);
      }
   }
}
