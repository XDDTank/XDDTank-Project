package ddt.events
{
   import flash.events.Event;
   
   public class PurchaseBoxEvent extends Event
   {
      
      public static const PURCHAESBOX_CHANGE:String = "purchaesBoxChane";
       
      
      public function PurchaseBoxEvent(param1:String, param2:Boolean = false, param3:Boolean = false)
      {
         super(param1);
      }
   }
}
