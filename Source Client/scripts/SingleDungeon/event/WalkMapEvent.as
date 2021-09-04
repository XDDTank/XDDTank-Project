package SingleDungeon.event
{
   import flash.events.Event;
   
   public class WalkMapEvent extends Event
   {
      
      public static const WALKMAP_PLAYER_POS_CHANGED:String = "walkMapPlayerPosChanged";
      
      public static const WALKMAP_PLAYER_SPEED_CHANGED:String = "walkMapPlayerSpeedChanged";
       
      
      public var playerID:int;
      
      public function WalkMapEvent(param1:String, param2:int)
      {
         this.playerID = param2;
         super(param1);
      }
   }
}
