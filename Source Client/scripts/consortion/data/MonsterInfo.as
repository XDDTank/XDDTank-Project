package consortion.data
{
   import consortion.event.ConsortionMonsterEvent;
   import flash.events.EventDispatcher;
   import flash.geom.Point;
   
   public class MonsterInfo extends EventDispatcher
   {
      
      public static const MONSTER_STATE:String = "MonsterState";
      
      public static const LIVIN:int = 0;
      
      public static const DEAD:int = 2;
      
      public static const FIGHTING:int = 1;
       
      
      public var ActionMovieName:String = "game.living.Living082";
      
      public var ID:int;
      
      public var MonsterName:String;
      
      public var MissionID:int;
      
      private var _state:int;
      
      public var MonsterPos:Point;
      
      public function MonsterInfo()
      {
         this.MonsterName = "奥古拉斯" + int(Math.random() * 50);
         super();
      }
      
      public function get State() : int
      {
         return this._state;
      }
      
      public function set State(param1:int) : void
      {
         if(this._state != param1)
         {
            this._state = param1;
            dispatchEvent(new ConsortionMonsterEvent(ConsortionMonsterEvent.UPDATE_MONSTER_STATE,this._state));
         }
      }
   }
}
