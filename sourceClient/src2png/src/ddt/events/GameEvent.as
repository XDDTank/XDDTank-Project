// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//ddt.events.GameEvent

package ddt.events
{
    import flash.events.Event;

    public class GameEvent extends Event 
    {

        public static const WIND_CHANGED:String = "windChanged";
        public static const TURN_CHANGED:String = "turnChanged";
        public static const READY_CHANGED:String = "readyChanged";
        public static const DungeonHelpVisibleChanged:String = "DungeonHelpVisibleChanged";
        public static const UPDATE_SMALLMAPVIEW:String = "updateSmallMapView";
        public static const EXPSHOWED:String = "expshowed";
        public static const TRYAGAIN:String = "tryagain";
        public static const GIVEUP:String = "giveup";
        public static const TIMEOUT:String = "timeOut";
        public static const MISSIONAGAIN:String = "missionAgain";
        public static const WISH_SELECT:String = "wishSelect";
        public static const SETTLESHOWED:String = "settleshowed";
        public static const FIGHT_MODEL:String = "fightModel";
        public static const FIGHT_TOOL_BOX:String = "fightToolBox";
        public static const LOCK_SCREEN:String = "lockScreen";
        public static const GET_THREE_ICON:String = "getThreeIcon";
        public static const GET_ADDONE_ICON:String = "getAddOneIcon";
        public static const GET_ADDTWO_ICON:String = "getAddTwoIcon";
        public static const GET_POWMAX_ICON:String = "getPowMaxIcon";
        public static const GET_PLANE_ICON:String = "getPlaneIcon";
        public static const GET_LEAD_ICON:String = "getLeadIcon";
        public static const GET_NORMAL_ICON:String = "getNormalIcon";
        public static const USE_THREE:String = "useThree";
        public static const USE_ADDONE:String = "useAddOne";
        public static const SINGLE_TURN_NOTICE:String = "singleTurnNotice";
        public static const MOUSE_MODEL_OVER:String = "mouseModelOver";
        public static const MOUSE_MODEL_OUT:String = "mouseModelOut";
        public static const MOUSE_MODEL_UP:String = "mouseModelUp";
        public static const MOUSE_MODEL_DOWN:String = "mouseModelDown";
        public static const MOUSE_MODEL_CHANGE_ANGLE:String = "mouseModelChangeAngle";
        public static const MOUSE_STATE_CHANGE:String = "mouseStateChange";
        public static const MOUSE_DOWN_LEFT:String = "mouseDownLeft";
        public static const MOUSE_UP_LEFT:String = "mouseUpLeft";
        public static const MOUSE_DOWN_Right:String = "mouseDownRight";
        public static const MOUSE_UP_Right:String = "mouseUpRight";
        public static const MOUSE_MODEL_STATE:String = "MouseModelState";
        public static const TURN_LEFT:String = "turnLeft";
        public static const TURN_RIGHT:String = "turnRight";
        public static const BOSS_USE_SKILL:String = "bossUseSkill";
        public static const BOMB_COMPLETE:String = "bombComplete";

        public var data:*;

        public function GameEvent(_arg_1:String, _arg_2:*=null)
        {
            this.data = _arg_2;
            super(_arg_1);
        }

    }
}//package ddt.events

