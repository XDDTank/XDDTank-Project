// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//SingleDungeon.event.SingleDungeonEvent

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

        public function SingleDungeonEvent(_arg_1:String, _arg_2:Object=null, _arg_3:Boolean=false, _arg_4:Boolean=false)
        {
            super(_arg_1, _arg_3, _arg_4);
            this.data = _arg_2;
        }

    }
}//package SingleDungeon.event

