package com.pickgliss.ui.tip
{
   import com.pickgliss.ui.vo.DirectionPos;
   import flash.display.IDisplayObject;
   
   public interface ITip extends IDisplayObject
   {
       
      
      function get tipData() : Object;
      
      function set tipData(param1:Object) : void;
      
      function get currentDirectionPos() : DirectionPos;
      
      function set currentDirectionPos(param1:DirectionPos) : void;
   }
}
