// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//church.events.ChurchScenePlayerEvent

package church.events
{
    import flash.events.Event;

    public class ChurchScenePlayerEvent extends Event 
    {

        public static const PLAYER_POS_CHANGE:String = "playerPosChange";
        public static const PLAYER_MOVE_SPEED_CHANGE:String = "playerMoveSpeedChange";

        public var playerid:int;

        public function ChurchScenePlayerEvent(_arg_1:String, _arg_2:int)
        {
            this.playerid = _arg_2;
            super(_arg_1);
        }

    }
}//package church.events

