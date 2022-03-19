// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//cmodule.decry.FSM__setjmp

package cmodule.decry
{
    import flash.events.*;
    import flash.display.*;
    import flash.utils.*;
    import flash.text.*;
    import flash.net.*;
    import flash.system.*;

    public class FSM__setjmp extends Machine 
    {


        public static function start():void
        {
            gstate.gworker = new (FSM__setjmp)();
            throw (new AlchemyDispatch());
        }


        override public function work():void
        {
            public::mstate.pop();
            var _local_1:int = _mr32(public::mstate.esp);
            _mw32((_local_1 + 0), 667788);
            _mw32((_local_1 + 4), caller.state);
            _mw32((_local_1 + 8), public::mstate.esp);
            _mw32((_local_1 + 12), public::mstate.ebp);
            _mw32((_local_1 + 16), 887766);
            log(4, ("setjmp: " + _local_1));
            var _local_2:Machine = findMachineForESP(public::mstate.esp);
            if (_local_2)
            {
                delete gsetjmpMachine2ESPMap[_local_2];
            };
            gsetjmpMachine2ESPMap[caller] = public::mstate.esp;
            public::mstate.gworker = caller;
            public::mstate.eax = 0;
        }


    }
}//package cmodule.decry

