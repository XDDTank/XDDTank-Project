// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//SingleDungeon.event.WalkMapEvent

package SingleDungeon.event
{
    import flash.events.Event;

    public class WalkMapEvent extends Event 
    {

        public static const WALKMAP_PLAYER_POS_CHANGED:String = "walkMapPlayerPosChanged";
        public static const WALKMAP_PLAYER_SPEED_CHANGED:String = "walkMapPlayerSpeedChanged";

        public var playerID:int;

        public function WalkMapEvent(_arg_1:String, _arg_2:int)
        {
            this.playerID = _arg_2;
            super(_arg_1);
        }

    }
}//package SingleDungeon.event

