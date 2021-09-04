package petsBag.event
{
   import flash.events.Event;
   
   public class PetItemEvent extends Event
   {
      
      public static const MOUSE_DOWN:String = "mousedown";
      
      public static const ITEM_CLICK:String = "itemclick";
      
      public static const DOUBLE_CLICK:String = "doubleclick";
      
      public static const LOCK_CHANGED:String = "lockChanged";
      
      public static const DRAGSTART:String = "dragStart";
      
      public static const DRAGDROP:String = "dragDrop";
      
      public static const DRAGSTOP:String = "dragStop";
      
      public static const ITEM_CHANGE:String = "itemChange";
      
      public static const SHINE:String = "shine";
       
      
      public var data;
      
      public var ctrlKey:Boolean;
      
      public function PetItemEvent(param1:String, param2:* = null, param3:Boolean = false, param4:Boolean = false, param5:Boolean = false)
      {
         this.data = param2;
         this.ctrlKey = param5;
         super(param1,param3,param4);
      }
   }
}
