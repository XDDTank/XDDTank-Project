package store.view.Compose
{
   import flash.events.Event;
   
   public class ComposeEvents extends Event
   {
      
      public static const ITEM_BIG_UPDATE:String = "itemBigUpdate";
      
      public static const CLICK_BIG_ITEM:String = "clickBigItem";
      
      public static const CLICK_MIDDLE_ITEM:String = "clickMiddleItem";
      
      public static const CLICK_SMALL_ITEM:String = "clickSmallItem";
      
      public static const START_COMPOSE:String = "startCompose";
      
      public static const COMPOSE_COMPLETE:String = "composeComplete";
      
      public static const GET_SKILLS_COMPLETE:String = "getSkillsComplete";
       
      
      private var _num:int;
      
      public function ComposeEvents(param1:String, param2:int = -1, param3:Boolean = false, param4:Boolean = false)
      {
         super(param1,param3,param4);
         this._num = param2;
      }
      
      public function get num() : int
      {
         return this._num;
      }
   }
}
