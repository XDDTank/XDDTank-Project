package cmodule.decry
{
   import avm2.intrinsics.memory.li32;
   import avm2.intrinsics.memory.si32;
   
   public final class FSM___pow5mult_D2A extends Machine
   {
      
      public static const intRegCount:int = 6;
      
      public static const NumberRegCount:int = 0;
       
      
      public var i0:int;
      
      public var i1:int;
      
      public var i2:int;
      
      public var i3:int;
      
      public var i4:int;
      
      public var i5:int;
      
      public function FSM___pow5mult_D2A()
      {
         super();
      }
      
      public static function start() : void
      {
         var _loc1_:FSM___pow5mult_D2A = null;
         _loc1_ = new FSM___pow5mult_D2A();
         gstate.gworker = _loc1_;
      }
      
      override public final function work() : void
      {
         loop3:
         switch(state)
         {
            case 0:
               mstate.esp -= 4;
               si32(mstate.ebp,mstate.esp);
               mstate.ebp = mstate.esp;
               mstate.esp -= 0;
               this.i0 = li32(mstate.ebp + 12);
               this.i1 = li32(mstate.ebp + 8);
               this.i2 = this.i0 & 3;
               if(this.i2 != 0)
               {
                  this.i3 = _p05_2E_3275;
                  this.i2 <<= 2;
                  this.i2 += this.i3;
                  this.i2 = li32(this.i2 + -4);
                  mstate.esp -= 8;
                  si32(this.i1,mstate.esp);
                  si32(this.i2,mstate.esp + 4);
                  state = 1;
                  mstate.esp -= 4;
                  FSM___multadd_D2A.start();
                  return;
               }
               addr139:
               this.i2 = this.i0 >> 2;
               if(uint(this.i0) > uint(3))
               {
                  this.i0 = li32(_p5s);
                  if(this.i0 != 0)
                  {
                     break;
                  }
                  this.i0 = li32(_freelist + 4);
                  if(this.i0 != 0)
                  {
                     this.i3 = li32(this.i0);
                     si32(this.i3,_freelist + 4);
                  }
                  else
                  {
                     this.i0 = _private_mem;
                     this.i3 = li32(_pmem_next);
                     this.i0 = this.i3 - this.i0;
                     this.i0 >>= 3;
                     this.i0 += 4;
                     if(uint(this.i0) > uint(288))
                     {
                        this.i0 = 32;
                        mstate.esp -= 4;
                        si32(this.i0,mstate.esp);
                        state = 2;
                        mstate.esp -= 4;
                        FSM_malloc.start();
                        return;
                     }
                     this.i0 = 1;
                     this.i4 = this.i3 + 32;
                     si32(this.i4,_pmem_next);
                     si32(this.i0,this.i3 + 4);
                     this.i0 = 2;
                     si32(this.i0,this.i3 + 8);
                     this.i0 = this.i3;
                  }
                  addr376:
                  this.i3 = 0;
                  si32(this.i3,this.i0 + 12);
                  this.i4 = 625;
                  si32(this.i4,this.i0 + 20);
                  this.i4 = 1;
                  si32(this.i4,this.i0 + 16);
                  si32(this.i0,_p5s);
                  si32(this.i3,this.i0);
                  break;
               }
               §§goto(addr157);
               break;
            case 1:
               this.i1 = mstate.eax;
               mstate.esp += 8;
               §§goto(addr139);
            case 2:
               this.i0 = mstate.eax;
               mstate.esp += 4;
               this.i3 = 1;
               si32(this.i3,this.i0 + 4);
               this.i3 = 2;
               si32(this.i3,this.i0 + 8);
               §§goto(addr376);
            case 3:
               this.i3 = mstate.eax;
               mstate.esp += 8;
               if(this.i1 == 0)
               {
                  this.i1 = this.i3;
               }
               else
               {
                  this.i4 = _freelist;
                  this.i5 = li32(this.i1 + 4);
                  this.i5 <<= 2;
                  this.i4 += this.i5;
                  this.i5 = li32(this.i4);
                  si32(this.i5,this.i1);
                  si32(this.i1,this.i4);
                  this.i1 = this.i3;
               }
               while(true)
               {
                  this.i3 = this.i2 >> 1;
                  if(uint(this.i2) <= uint(1))
                  {
                     break;
                  }
                  this.i2 = li32(this.i0);
                  this.i4 = this.i0;
                  if(this.i2 == 0)
                  {
                     this.i2 = 0;
                     mstate.esp -= 8;
                     si32(this.i0,mstate.esp);
                     si32(this.i0,mstate.esp + 4);
                     state = 4;
                     mstate.esp -= 4;
                     FSM___mult_D2A.start();
                     return;
                  }
                  this.i0 = this.i2;
                  this.i2 = this.i3;
                  while(true)
                  {
                     break loop3;
                  }
               }
               addr157:
               this.i0 = this.i1;
               mstate.eax = this.i0;
               mstate.esp = mstate.ebp;
               mstate.ebp = li32(mstate.esp);
               mstate.esp += 4;
               mstate.esp += 4;
               mstate.gworker = caller;
               return;
            case 4:
               this.i0 = mstate.eax;
               mstate.esp += 8;
               si32(this.i0,this.i4);
               si32(this.i2,this.i0);
               this.i2 = this.i3;
               §§goto(addr417);
            default:
               throw "Invalid state in ___pow5mult_D2A";
         }
         continue loop2;
      }
   }
}
