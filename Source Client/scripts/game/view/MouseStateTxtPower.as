package game.view
{
   import flash.display.MovieClip;
   
   public class MouseStateTxtPower extends MovieClip
   {
       
      
      public var num1:MovieClip;
      
      public var num2:MovieClip;
      
      public var num3:MovieClip;
      
      public function MouseStateTxtPower()
      {
         super();
         stop();
      }
      
      public function setNum(param1:int) : void
      {
         var _loc2_:int = 0;
         param1 = Math.abs(param1);
         _loc2_ = param1 / 100;
         var _loc3_:int = param1 % 100 / 10;
         var _loc4_:int = param1 % 100 % 10;
         if(_loc2_ == 0)
         {
            this.num3.visible = false;
            if(_loc3_ == 0)
            {
               this.num2.visible = false;
               this.num1.gotoAndStop(_loc4_ + 1);
            }
            else
            {
               this.num2.visible = true;
               this.num2.gotoAndStop(_loc4_ + 1);
               this.num1.gotoAndStop(_loc3_ + 1);
            }
         }
         else
         {
            this.num3.visible = true;
            this.num2.visible = true;
            this.num3.gotoAndStop(_loc4_ + 1);
            this.num2.gotoAndStop(_loc3_ + 1);
            this.num1.gotoAndStop(_loc2_ + 1);
         }
      }
   }
}
