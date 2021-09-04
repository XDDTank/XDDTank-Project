package arena.model
{
   import flash.events.Event;
   
   public class ArenaEvent extends Event
   {
      
      public static const MOVE:String = "move";
      
      public static const ENTER_SCENE:String = "enterScene";
      
      public static const LEAVE_SCENE:String = "leaveScene";
      
      public static const UPDATE_SELF:String = "updateSelf";
      
      public static const ARENA_ACTIVITY:String = "arenaActivity";
       
      
      private var _data:Object;
      
      public function ArenaEvent(param1:String, param2:Object = null)
      {
         super(param1);
         this._data = param2;
      }
      
      public function get data() : Object
      {
         return this._data;
      }
   }
}
