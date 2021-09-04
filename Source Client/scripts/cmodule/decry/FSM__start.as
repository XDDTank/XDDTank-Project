package cmodule.decry
{
   import avm2.intrinsics.memory.li32;
   import avm2.intrinsics.memory.li8;
   import avm2.intrinsics.memory.si32;
   
   public final class FSM__start extends Machine
   {
      
      public static const intRegCount:int = 3;
      
      public static const NumberRegCount:int = 0;
       
      
      public var i0:int;
      
      public var i1:int;
      
      public var i2:int;
      
      public function FSM__start()
      {
         super();
      }
      
      public static function start() : void
      {
         var _loc1_:FSM__start = null;
         _loc1_ = new FSM__start();
         gstate.gworker = _loc1_;
      }
      
      override public final function work() : void
      {
         switch(state)
         {
            case 0:
               mstate.esp -= 4;
               si32(mstate.ebp,mstate.esp);
               mstate.ebp = mstate.esp;
               mstate.esp -= 0;
               this.i0 = li32(mstate.ebp + 8);
               this.i1 = li32(this.i0);
               this.i2 = this.i1 << 2;
               this.i2 += this.i0;
               this.i2 += 8;
               si32(this.i2,_environ);
               if(this.i1 >= 1)
               {
                  this.i0 = li32(this.i0 + 4);
                  this.i1 = this.i0;
                  if(this.i0 != 0)
                  {
                     this.i1 = li8(this.i1);
                     if(this.i1 != 0)
                     {
                        this.i0 += 1;
                        do
                        {
                           this.i1 = li8(this.i0);
                           this.i0 += 1;
                        }
                        while(this.i1 != 0);
                        
                     }
                  }
               }
               this.i2 = 0;
               mstate.esp -= 4;
               si32(this.i2,mstate.esp);
               state = 1;
               mstate.esp -= 4;
               FSM_atexit.start();
               return;
            case 1:
               mstate.esp += 4;
               mstate.esp -= 4;
               this.i0 = __fini;
               si32(this.i0,mstate.esp);
               state = 2;
               mstate.esp -= 4;
               FSM_atexit.start();
               return;
            case 2:
               mstate.esp += 4;
               this.i0 = __2E_str1;
               this.i1 = 4;
               log(this.i1,mstate.gworker.stringFromPtr(this.i0));
               mstate.esp -= 8;
               this.i0 = _decry;
               si32(this.i2,mstate.esp);
               si32(this.i0,mstate.esp + 4);
               state = 3;
               mstate.esp -= 4;
               mstate.funcs[_AS3_Function]();
               return;
            case 3:
               this.i0 = mstate.eax;
               mstate.esp += 8;
               mstate.esp -= 8;
               this.i1 = __2E_str11110;
               si32(this.i1,mstate.esp);
               si32(this.i0,mstate.esp + 4);
               state = 4;
               mstate.esp -= 4;
               mstate.funcs[_AS3_Object]();
               return;
            case 4:
               this.i1 = mstate.eax;
               mstate.esp += 8;
               mstate.esp -= 4;
               si32(this.i0,mstate.esp);
               state = 5;
               mstate.esp -= 4;
               mstate.funcs[_AS3_Release]();
               return;
            case 5:
               mstate.esp += 4;
               this.i0 = 1;
               state = 6;
            case 6:
               if(this.i0)
               {
                  this.i0 = 0;
                  throw new AlchemyLibInit(this.i1);
               }
               mstate.esp -= 4;
               si32(this.i2,mstate.esp);
               state = 7;
               mstate.esp -= 4;
               FSM_exit.start();
               return;
               break;
            case 7:
               mstate.esp += 4;
         }
         throw "Invalid state in __start";
      }
   }
}
