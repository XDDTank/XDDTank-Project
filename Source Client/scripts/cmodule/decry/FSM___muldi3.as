package cmodule.decry
{
   import avm2.intrinsics.memory.li32;
   import avm2.intrinsics.memory.si32;
   
   public final class FSM___muldi3 extends Machine
   {
       
      
      public function FSM___muldi3()
      {
         super();
      }
      
      public static function start() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         var _loc10_:int = 0;
         var _loc11_:int = 0;
         var _loc12_:int = 0;
         mstate.esp -= 4;
         si32(mstate.ebp,mstate.esp);
         mstate.ebp = mstate.esp;
         mstate.esp -= 0;
         _loc1_ = 0;
         _loc1_ = li32(mstate.ebp + 12);
         _loc2_ = li32(mstate.ebp + 20);
         _loc3_ = li32(mstate.ebp + 8);
         _loc4_ = _loc1_ >> 31;
         _loc5_ = li32(mstate.ebp + 16);
         _loc6_ = _loc2_ >> 31;
         _loc3_ = __addc(_loc3_,_loc4_);
         _loc7_ = __adde(_loc1_,_loc4_);
         _loc5_ = __addc(_loc5_,_loc6_);
         _loc8_ = __adde(_loc2_,_loc6_);
         _loc1_ >>>= 31;
         _loc7_ ^= _loc4_;
         _loc3_ ^= _loc4_;
         _loc2_ >>>= 31;
         _loc4_ = _loc8_ ^ _loc6_;
         _loc5_ ^= _loc6_;
         _loc6_ = _loc7_;
         _loc8_ = _loc7_;
         if(_loc7_ == 0)
         {
            if(_loc4_ == 0)
            {
               mstate.esp -= 8;
               si32(_loc3_,mstate.esp);
               si32(_loc5_,mstate.esp + 4);
               mstate.esp -= 4;
               FSM___lmulq.start();
               _loc3_ = mstate.eax;
               _loc4_ = mstate.edx;
               mstate.esp += 8;
               if(_loc1_ != _loc2_)
               {
                  addr428:
                  _loc1_ = 0;
                  _loc3_ = __subc(_loc1_,_loc3_);
                  _loc4_ = __sube(_loc1_,_loc4_);
                  mstate.edx = _loc4_;
                  mstate.eax = _loc3_;
               }
               else
               {
                  addr455:
                  _loc1_ = _loc3_;
                  _loc2_ = _loc4_;
                  mstate.edx = _loc2_;
                  mstate.eax = _loc1_;
               }
               §§goto(addr469);
            }
            else
            {
               _loc7_ = uint(_loc5_) < uint(_loc4_) ? int(_loc5_) : int(_loc4_);
               _loc9_ = uint(_loc5_) < uint(_loc4_) ? int(_loc4_) : int(_loc5_);
               _loc10_ = uint(_loc6_) < uint(_loc3_) ? int(_loc8_) : int(_loc3_);
               _loc8_ = uint(_loc6_) < uint(_loc3_) ? int(_loc3_) : int(_loc8_);
               _loc11_ = uint(_loc5_) < uint(_loc4_) ? int(1) : int(0);
               _loc12_ = uint(_loc6_) < uint(_loc3_) ? int(1) : int(0);
               _loc7_ = _loc9_ - _loc7_;
               _loc8_ -= _loc10_;
               mstate.esp -= 8;
               _loc9_ = _loc11_ ^ _loc12_;
               _loc7_ *= _loc8_;
               si32(_loc3_,mstate.esp);
               si32(_loc5_,mstate.esp + 4);
               _loc3_ = _loc9_ & 1;
               _loc5_ = 0 - _loc7_;
               _loc3_ = _loc3_ != 0 ? int(_loc5_) : int(_loc7_);
               _loc4_ *= _loc6_;
               mstate.esp -= 4;
               FSM___lmulq.start();
               _loc5_ = mstate.eax;
               _loc6_ = mstate.edx;
               _loc3_ += _loc4_;
               _loc3_ += _loc5_;
               mstate.esp += 8;
               _loc4_ = _loc3_ + _loc6_;
               §§goto(addr226);
            }
         }
         addr226:
         if(_loc1_ != _loc2_)
         {
            _loc3_ = _loc5_;
            §§goto(addr428);
         }
         else
         {
            _loc3_ = _loc5_;
            §§goto(addr455);
         }
         mstate.esp += 4;
         mstate.esp += 4;
      }
   }
}
