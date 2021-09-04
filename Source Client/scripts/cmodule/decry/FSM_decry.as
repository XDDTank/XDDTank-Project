package cmodule.decry
{
   import avm2.intrinsics.memory.li32;
   import avm2.intrinsics.memory.si32;
   
   public final class FSM_decry extends Machine
   {
      
      public static const intRegCount:int = 5;
      
      public static const NumberRegCount:int = 0;
       
      
      public var i0:int;
      
      public var i1:int;
      
      public var i2:int;
      
      public var i3:int;
      
      public var i4:int;
      
      public function FSM_decry()
      {
         super();
      }
      
      public static function start() : void
      {
         var _loc1_:FSM_decry = null;
         _loc1_ = new FSM_decry();
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
               mstate.esp -= 16;
               this.i0 = __2E_str99;
               mstate.esp -= 12;
               this.i1 = li32(mstate.ebp + 12);
               this.i2 = mstate.ebp + -4;
               si32(this.i1,mstate.esp);
               si32(this.i0,mstate.esp + 4);
               si32(this.i2,mstate.esp + 8);
               state = 1;
               mstate.esp -= 4;
               mstate.funcs[_AS3_ArrayValue]();
               return;
            case 1:
               mstate.esp += 12;
               mstate.esp -= 4;
               this.i0 = __2E_str1100;
               si32(this.i0,mstate.esp);
               state = 2;
               mstate.esp -= 4;
               mstate.funcs[_AS3_String]();
               return;
            case 2:
               this.i0 = mstate.eax;
               mstate.esp += 4;
               mstate.esp -= 8;
               this.i1 = __2E_str2101;
               si32(this.i0,mstate.esp);
               si32(this.i1,mstate.esp + 4);
               state = 3;
               mstate.esp -= 4;
               mstate.funcs[_AS3_NSGetS]();
               return;
            case 3:
               this.i0 = mstate.eax;
               mstate.esp += 8;
               mstate.esp -= 4;
               this.i1 = __2E_str58;
               si32(this.i1,mstate.esp);
               state = 4;
               mstate.esp -= 4;
               mstate.funcs[_AS3_Array]();
               return;
            case 4:
               this.i1 = mstate.eax;
               mstate.esp += 4;
               mstate.esp -= 8;
               si32(this.i0,mstate.esp);
               si32(this.i1,mstate.esp + 4);
               state = 5;
               mstate.esp -= 4;
               mstate.funcs[_AS3_New]();
               return;
            case 5:
               this.i1 = mstate.eax;
               mstate.esp += 8;
               this.i0 = li32(mstate.ebp + -4);
               mstate.esp -= 8;
               this.i2 = __2E_str4103;
               si32(this.i0,mstate.esp);
               si32(this.i2,mstate.esp + 4);
               state = 6;
               mstate.esp -= 4;
               mstate.funcs[_AS3_GetS]();
               return;
            case 6:
               this.i0 = mstate.eax;
               mstate.esp += 8;
               this.i2 = 67;
               si32(this.i2,mstate.ebp + -8);
               this.i2 = 87;
               si32(this.i2,mstate.ebp + -12);
               this.i2 = 83;
               si32(this.i2,mstate.ebp + -16);
               mstate.esp -= 12;
               this.i2 = 1;
               this.i3 = mstate.ebp + -8;
               si32(this.i1,mstate.esp);
               si32(this.i3,mstate.esp + 4);
               si32(this.i2,mstate.esp + 8);
               state = 7;
               mstate.esp -= 4;
               mstate.funcs[_AS3_ByteArray_writeBytes]();
               return;
            case 7:
               this.i3 = mstate.eax;
               mstate.esp += 12;
               mstate.esp -= 12;
               this.i3 = mstate.ebp + -12;
               si32(this.i1,mstate.esp);
               si32(this.i3,mstate.esp + 4);
               si32(this.i2,mstate.esp + 8);
               state = 8;
               mstate.esp -= 4;
               mstate.funcs[_AS3_ByteArray_writeBytes]();
               return;
            case 8:
               this.i3 = mstate.eax;
               mstate.esp += 12;
               mstate.esp -= 12;
               this.i3 = mstate.ebp + -16;
               si32(this.i1,mstate.esp);
               si32(this.i3,mstate.esp + 4);
               si32(this.i2,mstate.esp + 8);
               state = 9;
               mstate.esp -= 4;
               mstate.funcs[_AS3_ByteArray_writeBytes]();
               return;
            case 9:
               this.i2 = mstate.eax;
               mstate.esp += 12;
               this.i2 = li32(mstate.ebp + -4);
               mstate.esp -= 12;
               this.i3 = 21;
               this.i4 = 0;
               si32(this.i2,mstate.esp);
               si32(this.i3,mstate.esp + 4);
               si32(this.i4,mstate.esp + 8);
               state = 10;
               mstate.esp -= 4;
               mstate.funcs[_AS3_ByteArray_seek]();
               return;
            case 10:
               this.i2 = mstate.eax;
               mstate.esp += 12;
               this.i2 = li32(mstate.ebp + -4);
               mstate.esp -= 8;
               this.i3 = __2E_str5104;
               si32(this.i2,mstate.esp);
               si32(this.i3,mstate.esp + 4);
               state = 11;
               mstate.esp -= 4;
               mstate.funcs[_AS3_GetS]();
               return;
            case 11:
               this.i2 = mstate.eax;
               mstate.esp += 8;
               mstate.esp -= 4;
               si32(this.i2,mstate.esp);
               state = 12;
               mstate.esp -= 4;
               mstate.funcs[_AS3_Trace]();
               return;
            case 12:
               mstate.esp += 4;
               this.i2 = li32(mstate.ebp + -4);
               mstate.esp -= 8;
               this.i3 = __2E_str6105;
               si32(this.i2,mstate.esp);
               si32(this.i3,mstate.esp + 4);
               state = 13;
               mstate.esp -= 4;
               mstate.funcs[_AS3_GetS]();
               return;
            case 13:
               this.i2 = mstate.eax;
               mstate.esp += 8;
               mstate.esp -= 4;
               si32(this.i2,mstate.esp);
               state = 14;
               mstate.esp -= 4;
               mstate.funcs[_AS3_Trace]();
               return;
            case 14:
               mstate.esp += 4;
               this.i2 = li32(mstate.ebp + -4);
               mstate.esp -= 8;
               this.i3 = __2E_str7106;
               si32(this.i2,mstate.esp);
               si32(this.i3,mstate.esp + 4);
               state = 15;
               mstate.esp -= 4;
               mstate.funcs[_AS3_GetS]();
               return;
            case 15:
               this.i2 = mstate.eax;
               mstate.esp += 8;
               mstate.esp -= 4;
               si32(this.i2,mstate.esp);
               state = 16;
               mstate.esp -= 4;
               mstate.funcs[_AS3_IntValue]();
               return;
            case 16:
               this.i2 = mstate.eax;
               mstate.esp += 4;
               mstate.esp -= 4;
               this.i2 += -121;
               si32(this.i2,mstate.esp);
               state = 17;
               mstate.esp -= 4;
               mstate.funcs[_AS3_Int]();
               return;
            case 17:
               this.i3 = mstate.eax;
               mstate.esp += 4;
               mstate.esp -= 4;
               si32(this.i3,mstate.esp);
               state = 18;
               mstate.esp -= 4;
               mstate.funcs[_AS3_Trace]();
               return;
            case 18:
               mstate.esp += 4;
               mstate.esp -= 16;
               this.i3 = __2E_str8107;
               this.i4 = 124;
               si32(this.i3,mstate.esp);
               si32(this.i1,mstate.esp + 4);
               si32(this.i4,mstate.esp + 8);
               si32(this.i2,mstate.esp + 12);
               state = 19;
               mstate.esp -= 4;
               mstate.funcs[_AS3_Array]();
               return;
            case 19:
               this.i2 = mstate.eax;
               mstate.esp += 16;
               this.i3 = li32(mstate.ebp + -4);
               mstate.esp -= 12;
               si32(this.i0,mstate.esp);
               si32(this.i3,mstate.esp + 4);
               si32(this.i2,mstate.esp + 8);
               state = 20;
               mstate.esp -= 4;
               mstate.funcs[_AS3_Call]();
               return;
            case 20:
               this.i2 = mstate.eax;
               mstate.esp += 12;
               mstate.esp -= 12;
               this.i2 = __2E_str9108;
               this.i3 = 3;
               si32(this.i2,mstate.esp);
               si32(this.i1,mstate.esp + 4);
               si32(this.i3,mstate.esp + 8);
               state = 21;
               mstate.esp -= 4;
               mstate.funcs[_AS3_Array]();
               return;
            case 21:
               this.i2 = mstate.eax;
               mstate.esp += 12;
               this.i3 = li32(mstate.ebp + -4);
               mstate.esp -= 12;
               si32(this.i0,mstate.esp);
               si32(this.i3,mstate.esp + 4);
               si32(this.i2,mstate.esp + 8);
               state = 22;
               mstate.esp -= 4;
               mstate.funcs[_AS3_Call]();
               return;
            case 22:
               this.i0 = mstate.eax;
               mstate.esp += 12;
               this.i0 = __2E_str10109;
               trace(mstate.gworker.stringFromPtr(this.i0));
               mstate.eax = this.i1;
               mstate.esp = mstate.ebp;
               mstate.ebp = li32(mstate.esp);
               mstate.esp += 4;
               mstate.esp += 4;
               mstate.gworker = caller;
               return;
            default:
               throw "Invalid state in _decry";
         }
      }
   }
}
