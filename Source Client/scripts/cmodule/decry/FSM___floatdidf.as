package cmodule.decry
{
   import avm2.intrinsics.memory.li32;
   import avm2.intrinsics.memory.si32;
   
   public final class FSM___floatdidf extends Machine
   {
       
      
      public function FSM___floatdidf()
      {
         super();
      }
      
      public static function start() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:Number = NaN;
         var _loc6_:Number = NaN;
         mstate.esp -= 4;
         si32(mstate.ebp,mstate.esp);
         mstate.ebp = mstate.esp;
         mstate.esp -= 0;
         _loc1_ = li32(mstate.ebp + 12);
         _loc2_ = li32(mstate.ebp + 8);
         _loc3_ = _loc1_ >> 31;
         _loc2_ = __addc(_loc2_,_loc3_);
         _loc4_ = __adde(_loc1_,_loc3_);
         _loc4_ ^= _loc3_;
         _loc2_ ^= _loc3_;
         _loc5_ = Number(uint(_loc4_));
         _loc6_ = Number(uint(_loc2_));
         _loc5_ *= 4294970000;
         _loc5_ = _loc6_ + _loc5_;
         if(_loc1_ <= -1)
         {
            _loc5_ = -_loc5_;
         }
         mstate.st0 = _loc5_;
         mstate.esp = mstate.ebp;
         mstate.ebp = li32(mstate.esp);
         mstate.esp += 4;
         mstate.esp += 4;
      }
   }
}
