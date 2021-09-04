package consortion.event
{
   import flash.events.Event;
   
   public class ConsortionMonsterEvent extends Event
   {
      
      public static const UPDATE_RANKING:String = "update_monster_ranking";
      
      public static const UPDATE_SELF_RANK_INFO:String = "update_self_rank_info";
      
      public static const UPDATE_MONSTER_STATE:String = "update_monster_state";
      
      public static const MONSTER_ACTIVE_START:String = "monster_active_start";
       
      
      public var data:Object;
      
      public function ConsortionMonsterEvent(param1:String, param2:Object = null)
      {
         this.data = param2;
         super(param1);
      }
   }
}
