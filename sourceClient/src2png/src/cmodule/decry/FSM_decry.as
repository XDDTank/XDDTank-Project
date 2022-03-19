// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//cmodule.decry.FSM_decry

package cmodule.decry
{
    import flash.events.*;
    import flash.display.*;
    import flash.utils.*;
    import flash.text.*;
    import flash.net.*;
    import flash.system.*;
    import avm2.intrinsics.memory.*; // ASC2.0, AIR3.6 SDK and above, FlasCC (Alchemy)

    public final class FSM_decry extends Machine 
    {

        public static const intRegCount:int = 5;
        public static const NumberRegCount:int = 0;

        public var i0:int;
        public var i1:int;
        public var i2:int;
        public var i3:int;
        public var i4:int;


        public static function start():void
        {
            var _local_1:FSM_decry;
            _local_1 = new (FSM_decry)();
            gstate.gworker = _local_1;
        }


        final override public function work():void
        {
            switch (state)
            {
                case 0:
                    public::mstate.esp = (public::mstate.esp - 4);
                    si32(public::mstate.ebp, public::mstate.esp);
                    public::mstate.ebp = public::mstate.esp;
                    public::mstate.esp = (public::mstate.esp - 16);
                    this.i0 = __2E_str99;
                    public::mstate.esp = (public::mstate.esp - 12);
                    this.i1 = li32(public::mstate.ebp + 12);
                    this.i2 = (public::mstate.ebp + -4);
                    si32(this.i1, public::mstate.esp);
                    si32(this.i0, (public::mstate.esp + 4));
                    si32(this.i2, (public::mstate.esp + 8));
                    state = 1;
                    public::mstate.esp = (public::mstate.esp - 4);
                    (public::mstate.funcs[_AS3_ArrayValue]());
                    return;
                case 1:
                    public::mstate.esp = (public::mstate.esp + 12);
                    public::mstate.esp = (public::mstate.esp - 4);
                    this.i0 = __2E_str1100;
                    si32(this.i0, public::mstate.esp);
                    state = 2;
                    public::mstate.esp = (public::mstate.esp - 4);
                    (public::mstate.funcs[_AS3_String]());
                    return;
                case 2:
                    this.i0 = public::mstate.eax;
                    public::mstate.esp = (public::mstate.esp + 4);
                    public::mstate.esp = (public::mstate.esp - 8);
                    this.i1 = __2E_str2101;
                    si32(this.i0, public::mstate.esp);
                    si32(this.i1, (public::mstate.esp + 4));
                    state = 3;
                    public::mstate.esp = (public::mstate.esp - 4);
                    (public::mstate.funcs[_AS3_NSGetS]());
                    return;
                case 3:
                    this.i0 = public::mstate.eax;
                    public::mstate.esp = (public::mstate.esp + 8);
                    public::mstate.esp = (public::mstate.esp - 4);
                    this.i1 = __2E_str58;
                    si32(this.i1, public::mstate.esp);
                    state = 4;
                    public::mstate.esp = (public::mstate.esp - 4);
                    (public::mstate.funcs[_AS3_Array]());
                    return;
                case 4:
                    this.i1 = public::mstate.eax;
                    public::mstate.esp = (public::mstate.esp + 4);
                    public::mstate.esp = (public::mstate.esp - 8);
                    si32(this.i0, public::mstate.esp);
                    si32(this.i1, (public::mstate.esp + 4));
                    state = 5;
                    public::mstate.esp = (public::mstate.esp - 4);
                    (public::mstate.funcs[_AS3_New]());
                    return;
                case 5:
                    this.i1 = public::mstate.eax;
                    public::mstate.esp = (public::mstate.esp + 8);
                    this.i0 = li32(public::mstate.ebp + -4);
                    public::mstate.esp = (public::mstate.esp - 8);
                    this.i2 = __2E_str4103;
                    si32(this.i0, public::mstate.esp);
                    si32(this.i2, (public::mstate.esp + 4));
                    state = 6;
                    public::mstate.esp = (public::mstate.esp - 4);
                    (public::mstate.funcs[_AS3_GetS]());
                    return;
                case 6:
                    this.i0 = public::mstate.eax;
                    public::mstate.esp = (public::mstate.esp + 8);
                    this.i2 = 67;
                    si32(this.i2, (public::mstate.ebp + -8));
                    this.i2 = 87;
                    si32(this.i2, (public::mstate.ebp + -12));
                    this.i2 = 83;
                    si32(this.i2, (public::mstate.ebp + -16));
                    public::mstate.esp = (public::mstate.esp - 12);
                    this.i2 = 1;
                    this.i3 = (public::mstate.ebp + -8);
                    si32(this.i1, public::mstate.esp);
                    si32(this.i3, (public::mstate.esp + 4));
                    si32(this.i2, (public::mstate.esp + 8));
                    state = 7;
                    public::mstate.esp = (public::mstate.esp - 4);
                    (public::mstate.funcs[_AS3_ByteArray_writeBytes]());
                    return;
                case 7:
                    this.i3 = public::mstate.eax;
                    public::mstate.esp = (public::mstate.esp + 12);
                    public::mstate.esp = (public::mstate.esp - 12);
                    this.i3 = (public::mstate.ebp + -12);
                    si32(this.i1, public::mstate.esp);
                    si32(this.i3, (public::mstate.esp + 4));
                    si32(this.i2, (public::mstate.esp + 8));
                    state = 8;
                    public::mstate.esp = (public::mstate.esp - 4);
                    (public::mstate.funcs[_AS3_ByteArray_writeBytes]());
                    return;
                case 8:
                    this.i3 = public::mstate.eax;
                    public::mstate.esp = (public::mstate.esp + 12);
                    public::mstate.esp = (public::mstate.esp - 12);
                    this.i3 = (public::mstate.ebp + -16);
                    si32(this.i1, public::mstate.esp);
                    si32(this.i3, (public::mstate.esp + 4));
                    si32(this.i2, (public::mstate.esp + 8));
                    state = 9;
                    public::mstate.esp = (public::mstate.esp - 4);
                    (public::mstate.funcs[_AS3_ByteArray_writeBytes]());
                    return;
                case 9:
                    this.i2 = public::mstate.eax;
                    public::mstate.esp = (public::mstate.esp + 12);
                    this.i2 = li32(public::mstate.ebp + -4);
                    public::mstate.esp = (public::mstate.esp - 12);
                    this.i3 = 21;
                    this.i4 = 0;
                    si32(this.i2, public::mstate.esp);
                    si32(this.i3, (public::mstate.esp + 4));
                    si32(this.i4, (public::mstate.esp + 8));
                    state = 10;
                    public::mstate.esp = (public::mstate.esp - 4);
                    (public::mstate.funcs[_AS3_ByteArray_seek]());
                    return;
                case 10:
                    this.i2 = public::mstate.eax;
                    public::mstate.esp = (public::mstate.esp + 12);
                    this.i2 = li32(public::mstate.ebp + -4);
                    public::mstate.esp = (public::mstate.esp - 8);
                    this.i3 = __2E_str5104;
                    si32(this.i2, public::mstate.esp);
                    si32(this.i3, (public::mstate.esp + 4));
                    state = 11;
                    public::mstate.esp = (public::mstate.esp - 4);
                    (public::mstate.funcs[_AS3_GetS]());
                    return;
                case 11:
                    this.i2 = public::mstate.eax;
                    public::mstate.esp = (public::mstate.esp + 8);
                    public::mstate.esp = (public::mstate.esp - 4);
                    si32(this.i2, public::mstate.esp);
                    state = 12;
                    public::mstate.esp = (public::mstate.esp - 4);
                    (public::mstate.funcs[_AS3_Trace]());
                    return;
                case 12:
                    public::mstate.esp = (public::mstate.esp + 4);
                    this.i2 = li32(public::mstate.ebp + -4);
                    public::mstate.esp = (public::mstate.esp - 8);
                    this.i3 = __2E_str6105;
                    si32(this.i2, public::mstate.esp);
                    si32(this.i3, (public::mstate.esp + 4));
                    state = 13;
                    public::mstate.esp = (public::mstate.esp - 4);
                    (public::mstate.funcs[_AS3_GetS]());
                    return;
                case 13:
                    this.i2 = public::mstate.eax;
                    public::mstate.esp = (public::mstate.esp + 8);
                    public::mstate.esp = (public::mstate.esp - 4);
                    si32(this.i2, public::mstate.esp);
                    state = 14;
                    public::mstate.esp = (public::mstate.esp - 4);
                    (public::mstate.funcs[_AS3_Trace]());
                    return;
                case 14:
                    public::mstate.esp = (public::mstate.esp + 4);
                    this.i2 = li32(public::mstate.ebp + -4);
                    public::mstate.esp = (public::mstate.esp - 8);
                    this.i3 = __2E_str7106;
                    si32(this.i2, public::mstate.esp);
                    si32(this.i3, (public::mstate.esp + 4));
                    state = 15;
                    public::mstate.esp = (public::mstate.esp - 4);
                    (public::mstate.funcs[_AS3_GetS]());
                    return;
                case 15:
                    this.i2 = public::mstate.eax;
                    public::mstate.esp = (public::mstate.esp + 8);
                    public::mstate.esp = (public::mstate.esp - 4);
                    si32(this.i2, public::mstate.esp);
                    state = 16;
                    public::mstate.esp = (public::mstate.esp - 4);
                    (public::mstate.funcs[_AS3_IntValue]());
                    return;
                case 16:
                    this.i2 = public::mstate.eax;
                    public::mstate.esp = (public::mstate.esp + 4);
                    public::mstate.esp = (public::mstate.esp - 4);
                    this.i2 = (this.i2 + -121);
                    si32(this.i2, public::mstate.esp);
                    state = 17;
                    public::mstate.esp = (public::mstate.esp - 4);
                    (public::mstate.funcs[_AS3_Int]());
                    return;
                case 17:
                    this.i3 = public::mstate.eax;
                    public::mstate.esp = (public::mstate.esp + 4);
                    public::mstate.esp = (public::mstate.esp - 4);
                    si32(this.i3, public::mstate.esp);
                    state = 18;
                    public::mstate.esp = (public::mstate.esp - 4);
                    (public::mstate.funcs[_AS3_Trace]());
                    return;
                case 18:
                    public::mstate.esp = (public::mstate.esp + 4);
                    public::mstate.esp = (public::mstate.esp - 16);
                    this.i3 = __2E_str8107;
                    this.i4 = 124;
                    si32(this.i3, public::mstate.esp);
                    si32(this.i1, (public::mstate.esp + 4));
                    si32(this.i4, (public::mstate.esp + 8));
                    si32(this.i2, (public::mstate.esp + 12));
                    state = 19;
                    public::mstate.esp = (public::mstate.esp - 4);
                    (public::mstate.funcs[_AS3_Array]());
                    return;
                case 19:
                    this.i2 = public::mstate.eax;
                    public::mstate.esp = (public::mstate.esp + 16);
                    this.i3 = li32(public::mstate.ebp + -4);
                    public::mstate.esp = (public::mstate.esp - 12);
                    si32(this.i0, public::mstate.esp);
                    si32(this.i3, (public::mstate.esp + 4));
                    si32(this.i2, (public::mstate.esp + 8));
                    state = 20;
                    public::mstate.esp = (public::mstate.esp - 4);
                    (public::mstate.funcs[_AS3_Call]());
                    return;
                case 20:
                    this.i2 = public::mstate.eax;
                    public::mstate.esp = (public::mstate.esp + 12);
                    public::mstate.esp = (public::mstate.esp - 12);
                    this.i2 = __2E_str9108;
                    this.i3 = 3;
                    si32(this.i2, public::mstate.esp);
                    si32(this.i1, (public::mstate.esp + 4));
                    si32(this.i3, (public::mstate.esp + 8));
                    state = 21;
                    public::mstate.esp = (public::mstate.esp - 4);
                    (public::mstate.funcs[_AS3_Array]());
                    return;
                case 21:
                    this.i2 = public::mstate.eax;
                    public::mstate.esp = (public::mstate.esp + 12);
                    this.i3 = li32(public::mstate.ebp + -4);
                    public::mstate.esp = (public::mstate.esp - 12);
                    si32(this.i0, public::mstate.esp);
                    si32(this.i3, (public::mstate.esp + 4));
                    si32(this.i2, (public::mstate.esp + 8));
                    state = 22;
                    public::mstate.esp = (public::mstate.esp - 4);
                    (public::mstate.funcs[_AS3_Call]());
                    return;
                case 22:
                    this.i0 = public::mstate.eax;
                    public::mstate.esp = (public::mstate.esp + 12);
                    this.i0 = __2E_str10109;
                    trace(public::mstate.gworker.stringFromPtr(this.i0));
                    public::mstate.eax = this.i1;
                    public::mstate.esp = public::mstate.ebp;
                    public::mstate.ebp = li32(public::mstate.esp);
                    public::mstate.esp = (public::mstate.esp + 4);
                    public::mstate.esp = (public::mstate.esp + 4);
                    public::mstate.gworker = caller;
                    return;
                default:
                    throw ("Invalid state in _decry");
            };
        }


    }
}//package cmodule.decry

