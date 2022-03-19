// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//cmodule.decry.FSM___error

package cmodule.decry
{
    import avm2.intrinsics.memory.*; // ASC2.0, AIR3.6 SDK and above, FlasCC (Alchemy)

    public final class FSM___error extends Machine 
    {


        public static function start():void
        {
            var _local_1:int;
            mstate.esp = (mstate.esp - 4);
            si32(mstate.ebp, mstate.esp);
            mstate.ebp = mstate.esp;
            mstate.esp = (mstate.esp - 0);
            _local_1 = _val_2E_939;
            mstate.eax = _local_1;
            mstate.esp = mstate.ebp;
            mstate.ebp = li32(mstate.esp);
            mstate.esp = (mstate.esp + 4);
            mstate.esp = (mstate.esp + 4);
        }


    }
}//package cmodule.decry

