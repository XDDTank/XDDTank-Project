package SingleDungeon.event
{
   import flash.events.Event;
   
   public class CDCollingEvent extends Event
   {
      
      public static const CD_COLLING:String = "CD_colling";
      
      public static const CD_UPDATE:String = "CDUpdate";
      
      public static const CD_STOP:String = "CDStop";
       
      
      public var ID:int;
      
      public var count:int;
      
      public var collingTime:int;
      
      public function CDCollingEvent(param1:String)
      {
         super(param1);
      }
   }
}
