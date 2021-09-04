package weekend
{
   import flash.events.Event;
   
   public class WeekendEvent extends Event
   {
      
      public static const ENERGY_CHANGE:String = "energyChange";
       
      
      public var data:Object;
      
      public function WeekendEvent(param1:String, param2:Object = null)
      {
         this.data = param2;
         super(param1,bubbles,cancelable);
      }
   }
}
