package ddt.view.sceneCharacter
{
   import flash.events.Event;
   
   public class SceneCharacterEvent extends Event
   {
      
      public static const CHARACTER_PLAYER_POS_CHANGED:String = "characterPlayerPosChanged";
      
      public static const CHARACTER_PLAYER_SPEED_CHANGED:String = "characterPlayerSpeedChanged";
      
      public static const CHARACTER_MOVEMENT:String = "characterMovement";
      
      public static const CHARACTER_ARRIVED_NEXT_STEP:String = "characterArrivedNextStep";
      
      public static const CHARACTER_ACTION_CHANGE:String = "characterActionChange";
      
      public static const CHARACTER_DIRECTION_CHANGE:String = "characterDirectionChange";
       
      
      private var _data:Object;
      
      public function SceneCharacterEvent(param1:String, param2:Object = null)
      {
         super(param1);
         this._data = param2;
      }
      
      public function get data() : Object
      {
         return this._data;
      }
   }
}
