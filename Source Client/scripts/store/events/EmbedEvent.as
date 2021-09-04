package store.events
{
   import ddt.data.goods.InventoryItemInfo;
   import flash.events.Event;
   
   public class EmbedEvent extends Event
   {
      
      public static const EMBED:String = "embed";
      
      public static const MOVE:String = "move";
       
      
      public var data:InventoryItemInfo;
      
      public function EmbedEvent(param1:String, param2:InventoryItemInfo, param3:Boolean = false, param4:Boolean = false)
      {
         super(param1,param3,param4);
         this.data = param2;
      }
   }
}
