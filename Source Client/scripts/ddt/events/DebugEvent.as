package ddt.events
{
   import flash.events.Event;
   
   public class DebugEvent extends Event
   {
      
      public static const DEBUG:String = "debug";
       
      
      public var data;
      
      public function DebugEvent(param1:String, param2:*)
      {
         super(param1);
         this.data = param2;
      }
   }
}
