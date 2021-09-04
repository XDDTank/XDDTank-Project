package game.animations
{
   public class DragMapAnimation extends BaseSetCenterAnimation
   {
       
      
      public function DragMapAnimation(param1:Number, param2:Number, param3:Boolean = false, param4:int = 100, param5:int = 1, param6:int = -1)
      {
         super(param1,param2,param4,param3,param5,param6);
      }
      
      override public function canAct() : Boolean
      {
         return !_finished;
      }
   }
}
