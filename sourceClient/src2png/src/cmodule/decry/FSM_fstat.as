// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//cmodule.decry.FSM_fstat

package cmodule.decry
{
    import avm2.intrinsics.memory.*; // ASC2.0, AIR3.6 SDK and above, FlasCC (Alchemy)

    public final class FSM_fstat extends Machine 
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
            var _local_1:FSM_fstat;
            _local_1 = new (FSM_fstat)();
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
                    public::mstate.esp = (public::mstate.esp - 0x1000);
                    this.i0 = li32(public::mstate.ebp + 8);
                    this.i1 = li32(public::mstate.ebp + 12);
                    if (this.i0 < 2) goto _label_2;
                    state = 1;
                case 1:
                    this.i0 = public::mstate.system.fsize(this.i0);
                    if (this.i0 > -1) goto _label_1;
                    this.i0 = __2E_str95;
                    public::mstate.esp = (public::mstate.esp - 20);
                    this.i1 = __2E_str150;
                    this.i2 = 59;
                    this.i3 = 2;
                    this.i4 = (public::mstate.ebp + -4096);
                    si32(this.i4, public::mstate.esp);
                    si32(this.i0, (public::mstate.esp + 4));
                    si32(this.i3, (public::mstate.esp + 8));
                    si32(this.i1, (public::mstate.esp + 12));
                    si32(this.i2, (public::mstate.esp + 16));
                    state = 2;
                    public::mstate.esp = (public::mstate.esp - 4);
                    FSM_sprintf.start();
                    return;
                case 2:
                    public::mstate.esp = (public::mstate.esp + 20);
                    this.i1 = 3;
                    this.i0 = this.i4;
                    log(this.i1, public::mstate.gworker.stringFromPtr(this.i0));
                    si32(this.i3, _val_2E_939);
                    this.i0 = -1;
                    goto _label_3;
                    
                _label_1: 
                    this.i2 = 0;
                    this.i3 = this.i1;
                    this.i4 = 96;
                    memset(this.i3, this.i2, this.i4);
                    this.i3 = (this.i0 >> 31);
                    si32(this.i0, (this.i1 + 48));
                    si32(this.i3, (this.i1 + 52));
                    public::mstate.eax = this.i2;
                    goto _label_4;
                    
                _label_2: 
                    this.i0 = 0;
                    
                _label_3: 
                    public::mstate.eax = this.i0;
                    
                _label_4: 
                    public::mstate.esp = public::mstate.ebp;
                    public::mstate.ebp = li32(public::mstate.esp);
                    public::mstate.esp = (public::mstate.esp + 4);
                    public::mstate.esp = (public::mstate.esp + 4);
                    public::mstate.gworker = caller;
                    return;
                default:
                    throw ("Invalid state in _fstat");
            };
        }


    }
}//package cmodule.decry

