// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//cmodule.decry.FSM___multadd_D2A

package cmodule.decry
{
    import flash.events.*;
    import flash.display.*;
    import flash.utils.*;
    import flash.text.*;
    import flash.net.*;
    import flash.system.*;
    import avm2.intrinsics.memory.*; // ASC2.0, AIR3.6 SDK and above, FlasCC (Alchemy)

    public final class FSM___multadd_D2A extends Machine 
    {

        public static const intRegCount:int = 12;
        public static const NumberRegCount:int = 0;

        public var i10:int;
        public var i11:int;
        public var i0:int;
        public var i1:int;
        public var i2:int;
        public var i3:int;
        public var i4:int;
        public var i5:int;
        public var i6:int;
        public var i7:int;
        public var i8:int;
        public var i9:int;


        public static function start():void
        {
            var _local_1:FSM___multadd_D2A;
            _local_1 = new (FSM___multadd_D2A)();
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
                    public::mstate.esp = (public::mstate.esp - 0);
                    this.i0 = 0;
                    this.i1 = li32(public::mstate.ebp + 8);
                    this.i2 = li32(public::mstate.ebp + 12);
                    this.i3 = li32(this.i1 + 16);
                    this.i4 = (this.i2 >> 31);
                    this.i5 = (this.i1 + 20);
                    this.i6 = (this.i1 + 16);
                    this.i7 = this.i0;
                    this.i8 = this.i0;
                    
                _label_1: 
                    this.i9 = 0;
                    public::mstate.esp = (public::mstate.esp - 16);
                    this.i10 = li32(this.i5);
                    si32(this.i10, public::mstate.esp);
                    si32(this.i9, (public::mstate.esp + 4));
                    si32(this.i2, (public::mstate.esp + 8));
                    si32(this.i4, (public::mstate.esp + 12));
                    public::mstate.esp = (public::mstate.esp - 4);
                    (public::mstate.funcs[___muldi3]());
                case 1:
                    this.i10 = public::mstate.eax;
                    this.i11 = public::mstate.edx;
                    this.i7 = __addc(this.i10, this.i7);
                    this.i0 = __adde(this.i11, this.i0);
                    si32(this.i7, this.i5);
                    this.i5 = (this.i5 + 4);
                    this.i7 = (this.i8 + 1);
                    public::mstate.esp = (public::mstate.esp + 16);
                    this.i8 = this.i0;
                    if (!(this.i7 >= this.i3))
                    {
                        this.i8 = this.i7;
                        this.i7 = this.i0;
                        this.i0 = this.i9;
                        goto _label_1;
                    };
                    this.i2 = ((this.i8 == 0) ? 1 : 0);
                    if (!(this.i2 == 0)) goto _label_3;
                    this.i2 = li32(this.i1 + 8);
                    if (!(this.i2 <= this.i3)) goto _label_2;
                    this.i2 = li32(this.i1 + 4);
                    public::mstate.esp = (public::mstate.esp - 4);
                    this.i2 = (this.i2 + 1);
                    si32(this.i2, public::mstate.esp);
                    state = 2;
                    public::mstate.esp = (public::mstate.esp - 4);
                    FSM___Balloc_D2A.start();
                    return;
                case 2:
                    this.i2 = public::mstate.eax;
                    public::mstate.esp = (public::mstate.esp + 4);
                    this.i4 = li32(this.i6);
                    this.i5 = (this.i2 + 12);
                    this.i4 = (this.i4 << 2);
                    this.i6 = (this.i1 + 12);
                    this.i4 = (this.i4 + 8);
                    memcpy(this.i5, this.i6, this.i4);
                    this.i4 = (this.i1 + 4);
                    if (!(!(this.i1 == 0)))
                    {
                        this.i1 = this.i2;
                    }
                    else
                    {
                        this.i5 = _freelist;
                        this.i4 = li32(this.i4);
                        this.i4 = (this.i4 << 2);
                        this.i4 = (this.i5 + this.i4);
                        this.i5 = li32(this.i4);
                        si32(this.i5, this.i1);
                        si32(this.i1, this.i4);
                        this.i1 = this.i2;
                    };
                    
                _label_2: 
                    this.i2 = (this.i3 << 2);
                    this.i2 = (this.i1 + this.i2);
                    si32(this.i0, (this.i2 + 20));
                    this.i0 = (this.i3 + 1);
                    si32(this.i0, (this.i1 + 16));
                    
                _label_3: 
                    public::mstate.eax = this.i1;
                    public::mstate.esp = public::mstate.ebp;
                    public::mstate.ebp = li32(public::mstate.esp);
                    public::mstate.esp = (public::mstate.esp + 4);
                    public::mstate.esp = (public::mstate.esp + 4);
                    public::mstate.gworker = caller;
                    return;
                default:
                    throw ("Invalid state in ___multadd_D2A");
            };
        }


    }
}//package cmodule.decry

