package store.view.refining
{
   import ddt.data.goods.InventoryItemInfo;
   import flash.events.Event;
   
   public class RefiningEvent extends Event
   {
      
      public static const MOVE:String = "move";
       
      
      public var info:InventoryItemInfo;
      
      public function RefiningEvent(param1:String, param2:InventoryItemInfo)
      {
         this.info = param2;
         super(param1);
      }
   }
}
