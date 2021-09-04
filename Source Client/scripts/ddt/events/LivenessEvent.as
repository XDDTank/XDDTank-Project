package ddt.events
{
   import flash.events.Event;
   
   public class LivenessEvent extends Event
   {
      
      public static const TASK_DIRECT:String = "taskDirect";
      
      public static const SHOW_SHINE:String = "showShine";
      
      public static const REFLASH_LIVENESS:String = "reflashLiveness";
       
      
      private var _info:Object;
      
      public function LivenessEvent(param1:String, param2:* = null)
      {
         this._info = param2;
         super(param1,false,false);
      }
      
      public function get info() : Object
      {
         return this._info;
      }
   }
}
