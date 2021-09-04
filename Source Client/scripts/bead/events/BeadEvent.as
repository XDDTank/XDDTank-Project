package bead.events
{
   import flash.events.Event;
   
   public class BeadEvent extends Event
   {
      
      public static const BEAD_LOCK:String = "bead_Lock";
      
      public static const SHOW_ConfirmFrme:String = "showConfirmFrame";
       
      
      public var data:Object;
      
      public function BeadEvent(param1:String, param2:Object = null, param3:Boolean = false, param4:Boolean = false)
      {
         super(param1,param3,param4);
         this.data = param2;
      }
   }
}
