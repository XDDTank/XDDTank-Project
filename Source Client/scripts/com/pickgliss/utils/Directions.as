package com.pickgliss.utils
{
   public final class Directions
   {
      
      public static const DIRECTION_B:int = 3;
      
      public static const DIRECTION_BL:int = 6;
      
      public static const DIRECTION_BR:int = 7;
      
      public static const DIRECTION_L:int = 1;
      
      public static const DIRECTION_R:int = 2;
      
      public static const DIRECTION_T:int = 0;
      
      public static const DIRECTION_TL:int = 4;
      
      public static const DIRECTION_TR:int = 5;
       
      
      public function Directions()
      {
         super();
      }
      
      public static function getHorizontalDirection(param1:int) : int
      {
         if(param1 == DIRECTION_L || param1 == DIRECTION_TL || param1 == DIRECTION_BL)
         {
            return -1;
         }
         if(param1 == DIRECTION_R || param1 == DIRECTION_TR || param1 == DIRECTION_BR)
         {
            return 1;
         }
         return 0;
      }
      
      public static function getVerticalDirection(param1:int) : int
      {
         if(param1 == DIRECTION_T || param1 == DIRECTION_TL || param1 == DIRECTION_TR)
         {
            return -1;
         }
         if(param1 == DIRECTION_B || param1 == DIRECTION_BL || param1 == DIRECTION_BR)
         {
            return 1;
         }
         return 0;
      }
   }
}
