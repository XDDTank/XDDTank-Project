// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//cmodule.decry.FSM__start

package cmodule.decry
{
    import flash.events.*;
    import flash.display.*;
    import flash.utils.*;
    import flash.text.*;
    import flash.net.*;
    import flash.system.*;
    import avm2.intrinsics.memory.*; // ASC2.0, AIR3.6 SDK and above, FlasCC (Alchemy)

    public final class FSM__start extends Machine 
    {

        public static const intRegCount:int = 3;
        public static const NumberRegCount:int = 0;

        public var i0:int;
        public var i1:int;
        public var i2:int;


        public static function start():void
        {
            var _local_1:FSM__start;
            _local_1 = new (FSM__start)();
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
                    this.i0 = li32(public::mstate.ebp + 8);
                    this.i1 = li32(this.i0);
                    this.i2 = (this.i1 << 2);
                    this.i2 = (this.i2 + this.i0);
                    this.i2 = (this.i2 + 8);
                    si32(this.i2, _environ);
                    if (!(this.i1 < 1))
                    {
                        this.i0 = li32(this.i0 + 4);
                        this.i1 = this.i0;
                        if (!(this.i0 == 0))
                        {
                            this.i1 = li8(this.i1);
                            if (!(this.i1 == 0))
                            {
                                this.i0 = (this.i0 + 1);
                                do 
                                {
                                    this.i1 = li8(this.i0);
                                    this.i0 = (this.i0 + 1);
                                } while (!(this.i1 == 0));
                            };
                        };
                    };
                    this.i2 = 0;
                    public::mstate.esp = (public::mstate.esp - 4);
                    si32(this.i2, public::mstate.esp);
                    state = 1;
                    public::mstate.esp = (public::mstate.esp - 4);
                    FSM_atexit.start();
                    return;
                case 1:
                    public::mstate.esp = (public::mstate.esp + 4);
                    public::mstate.esp = (public::mstate.esp - 4);
                    this.i0 = __fini;
                    si32(this.i0, public::mstate.esp);
                    state = 2;
                    public::mstate.esp = (public::mstate.esp - 4);
                    FSM_atexit.start();
                    return;
                case 2:
                    public::mstate.esp = (public::mstate.esp + 4);
                    this.i0 = __2E_str1;
                    this.i1 = 4;
                    log(this.i1, public::mstate.gworker.stringFromPtr(this.i0));
                    public::mstate.esp = (public::mstate.esp - 8);
                    this.i0 = _decry;
                    si32(this.i2, public::mstate.esp);
                    si32(this.i0, (public::mstate.esp + 4));
                    state = 3;
                    public::mstate.esp = (public::mstate.esp - 4);
                    (public::mstate.funcs[_AS3_Function]());
                    return;
                case 3:
                    this.i0 = public::mstate.eax;
                    public::mstate.esp = (public::mstate.esp + 8);
                    public::mstate.esp = (public::mstate.esp - 8);
                    this.i1 = __2E_str11110;
                    si32(this.i1, public::mstate.esp);
                    si32(this.i0, (public::mstate.esp + 4));
                    state = 4;
                    public::mstate.esp = (public::mstate.esp - 4);
                    (public::mstate.funcs[_AS3_Object]());
                    return;
                case 4:
                    this.i1 = public::mstate.eax;
                    public::mstate.esp = (public::mstate.esp + 8);
                    public::mstate.esp = (public::mstate.esp - 4);
                    si32(this.i0, public::mstate.esp);
                    state = 5;
                    public::mstate.esp = (public::mstate.esp - 4);
                    (public::mstate.funcs[_AS3_Release]());
                    return;
                case 5:
                    public::mstate.esp = (public::mstate.esp + 4);
                    this.i0 = 1;
                    state = 6;
                case 6:
                    if (this.i0)
                    {
                        this.i0 = 0;
                        throw (new AlchemyLibInit(this.i1));
                    };
                    public::mstate.esp = (public::mstate.esp - 4);
                    si32(this.i2, public::mstate.esp);
                    state = 7;
                    public::mstate.esp = (public::mstate.esp - 4);
                    FSM_exit.start();
                    return;
                case 7:
                    public::mstate.esp = (public::mstate.esp + 4);
                default:
                    throw ("Invalid state in __start");
            };
        }


    }
}//package cmodule.decry

