package fightToolBox
{
   import flash.events.Event;
   
   public class FightToolBoxEvent extends Event
   {
      
      public static const CHANGE:String = "change";
       
      
      public function FightToolBoxEvent(param1:String, param2:Object = null, param3:Boolean = false, param4:Boolean = false, param5:Boolean = false)
      {
         super(param1,param4,param5);
      }
   }
}
