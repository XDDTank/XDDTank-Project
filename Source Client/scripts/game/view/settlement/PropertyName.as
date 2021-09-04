package game.view.settlement
{
   import flash.display.MovieClip;
   
   public class PropertyName extends MovieClip
   {
      
      public static const DAMAGE:String = "damage";
      
      public static const AGILITY:String = "agility";
      
      public static const LUCY:String = "lucy";
      
      public static const ARMOR:String = "armor";
      
      public static const HP:String = "hp";
      
      public static const BROWN:int = 1;
      
      public static const BLUE:int = 2;
      
      public static const GREEN:int = 3;
      
      public static const RED:int = 4;
      
      public static const BLUE_BUTTON:int = 5;
       
      
      private var _type:int = 1;
      
      public function PropertyName()
      {
         super();
      }
      
      public function setType(param1:String, param2:int) : void
      {
         this._type = param2;
         gotoAndStop(param1);
         var _loc3_:int = currentFrame + param2 - 1;
         gotoAndStop(_loc3_);
      }
      
      public function get type() : int
      {
         return this._type;
      }
   }
}
