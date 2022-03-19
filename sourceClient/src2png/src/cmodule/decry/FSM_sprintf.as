// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//cmodule.decry.FSM_sprintf

package cmodule.decry
{
    import avm2.intrinsics.memory.*; // ASC2.0, AIR3.6 SDK and above, FlasCC (Alchemy)

    public final class FSM_sprintf extends Machine 
    {

        public static const intRegCount:int = 4;
        public static const NumberRegCount:int = 0;

        public var i0:int;
        public var i1:int;
        public var i2:int;
        public var i3:int;


        public static function start():void
        {
            var _local_1:FSM_sprintf;
            _local_1 = new (FSM_sprintf)();
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
                    public::mstate.esp = (public::mstate.esp - 0x0100);
                    this.i0 = -1;
                    si16(this.i0, (public::mstate.ebp + -82));
                    this.i0 = 520;
                    si16(this.i0, (public::mstate.ebp + -84));
                    this.i0 = li32(public::mstate.ebp + 8);
                    si32(this.i0, (public::mstate.ebp + -96));
                    si32(this.i0, (public::mstate.ebp + -80));
                    this.i0 = 2147483647;
                    si32(this.i0, (public::mstate.ebp + -88));
                    this.i1 = (public::mstate.ebp + -256);
                    si32(this.i0, (public::mstate.ebp + -76));
                    si32(this.i1, (public::mstate.ebp + -40));
                    this.i0 = 0;
                    si32(this.i0, (public::mstate.ebp + -256));
                    si32(this.i0, (public::mstate.ebp + -252));
                    si32(this.i0, (public::mstate.ebp + -248));
                    si32(this.i0, (public::mstate.ebp + -244));
                    si32(this.i0, (public::mstate.ebp + -240));
                    this.i1 = (this.i1 + 24);
                    this.i2 = 128;
                    memset(this.i1, this.i0, this.i2);
                    this.i1 = (public::mstate.ebp + 16);
                    si32(this.i1, (public::mstate.ebp + -4));
                    public::mstate.esp = (public::mstate.esp - 12);
                    this.i2 = li32(public::mstate.ebp + 12);
                    this.i3 = (public::mstate.ebp + -96);
                    si32(this.i3, public::mstate.esp);
                    si32(this.i2, (public::mstate.esp + 4));
                    si32(this.i1, (public::mstate.esp + 8));
                    state = 1;
                    public::mstate.esp = (public::mstate.esp - 4);
                    FSM___vfprintf.start();
                    return;
                case 1:
                    this.i1 = public::mstate.eax;
                    public::mstate.esp = (public::mstate.esp + 12);
                    this.i1 = li32(public::mstate.ebp + -96);
                    si8(this.i0, this.i1);
                    public::mstate.esp = public::mstate.ebp;
                    public::mstate.ebp = li32(public::mstate.esp);
                    public::mstate.esp = (public::mstate.esp + 4);
                    public::mstate.esp = (public::mstate.esp + 4);
                    public::mstate.gworker = caller;
                    return;
                default:
                    throw ("Invalid state in _sprintf");
            };
        }


    }
}//package cmodule.decry

