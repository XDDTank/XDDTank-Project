package totem.data
{
   import flash.events.Event;
   
   public class TotemEvent extends Event
   {
      
      public static const TOTEM_UPDATE:String = "totemUpdate";
       
      
      public function TotemEvent(param1:String, param2:Boolean = false, param3:Boolean = false)
      {
         super(param1,param2,param3);
      }
   }
}
