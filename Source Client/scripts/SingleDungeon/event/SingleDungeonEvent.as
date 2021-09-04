package SingleDungeon.event
{
   import flash.events.Event;
   import flash.events.EventDispatcher;
   
   public class SingleDungeonEvent extends Event
   {
      
      public static const DUNGEON_CHANGE:String = "dungeon_Change";
      
      public static const COLLECTION_COMPLETE:String = "collectionComplete";
      
      public static const START_COLLECT:String = "start_collect";
      
      public static const FRAME_EXIT:String = "fram_exit";
      
      public static const UPGRADE_COMPLETE:String = "upgrade_complete";
      
      public static const WALKMAP_EXIT:String = "walkmap_exit";
      
      public static const CLICK_MISSION_VIEW:String = "clickMissionView";
      
      public static const UPDATE_TIMES:String = "updateTimes";
      
      public static const ENTER_GAME_TIME_OUT:String = "enterGameTimeOut";
      
      public static var dispatcher:EventDispatcher = new EventDispatcher();
       
      
      public var data:Object;
      
      public function SingleDungeonEvent(param1:String, param2:Object = null, param3:Boolean = false, param4:Boolean = false)
      {
         super(param1,param3,param4);
         this.data = param2;
      }
   }
}
