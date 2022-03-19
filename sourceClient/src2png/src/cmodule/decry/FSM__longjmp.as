// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//cmodule.decry.FSM__longjmp

package cmodule.decry
{
    import flash.events.*;
    import flash.display.*;
    import flash.utils.*;
    import flash.text.*;
    import flash.net.*;
    import flash.system.*;

    public class FSM__longjmp extends Machine 
    {


        public static function start():void
        {
            gstate.gworker = new (FSM__longjmp)();
            throw (new AlchemyDispatch());
        }


        override public function work():void
        {
            public::mstate.pop();
            var _local_1:int = _mr32(public::mstate.esp);
            var _local_2:int = _mr32((public::mstate.esp + 4));
            log(4, ("longjmp: " + _local_1));
            var _local_3:int = _mr32((_local_1 + 4));
            var _local_4:int = _mr32((_local_1 + 8));
            var _local_5:int = _mr32((_local_1 + 12));
            log(3, ((((((("longjmp -- buf: " + _local_1) + " state: ") + _local_3) + " esp: ") + _local_4) + " ebp: ") + _local_5));
            if ((((!(_local_1)) || (!(_local_4))) || (!(_local_5))))
            {
                throw ("longjmp -- bad jmp_buf");
            };
            var _local_6:Machine = findMachineForESP(_local_4);
            if ((!(_local_6)))
            {
                debugTraceMem((_local_1 - 24), (_local_1 + 24));
                throw ("longjmp -- bad esp");
            };
            delete gsetjmpMachine2ESPMap[_local_6];
            public::mstate.gworker = _local_6;
            _local_6.state = _local_3;
            public::mstate.esp = _local_4;
            public::mstate.ebp = _local_5;
            public::mstate.eax = _local_2;
            throw (new AlchemyDispatch());
        }


    }
}//package cmodule.decry

