// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//cmodule.decry.CLibInit

package cmodule.decry
{
    import flash.utils.ByteArray;
    import flash.display.Sprite;
    import flash.events.*;
    import flash.display.*;
    import flash.utils.*;
    import flash.text.*;
    import flash.net.*;
    import flash.system.*;

    public class CLibInit 
    {


        public function init():*
        {
            var result:* = undefined;
            var regged:Boolean;
            var runner:CRunner = new CRunner(true);
            var saveState:MState = new MState(null);
            mstate.copyTo(saveState);
            try
            {
                runner.startSystem();
                while (true)
                {
                    try
                    {
                        while (true)
                        {
                            runner.work();
                        };
                    }
                    catch(e:AlchemyDispatch)
                    {
                    }
                    catch(e:AlchemyYield)
                    {
                    };
                };
            }
            catch(e:AlchemyLibInit)
            {
                log(3, ("Caught AlchemyLibInit " + e.rv));
                regged = true;
                result = CTypemap.AS3ValType.valueTracker.release(e.rv);
            }
            finally
            {
                saveState.copyTo(mstate);
                if ((!(regged)))
                {
                    log(1, "Lib didn't register");
                };
            };
            return (result);
        }

        public function supplyFile(_arg_1:String, _arg_2:ByteArray):void
        {
            gfiles[_arg_1] = _arg_2;
        }

        public function putEnv(_arg_1:String, _arg_2:String):void
        {
            genv[_arg_1] = _arg_2;
        }

        public function setSprite(_arg_1:Sprite):void
        {
            gsprite = _arg_1;
        }


    }
}//package cmodule.decry
import cmodule.decry.gshell;
import cmodule.decry.establishEnv;
import cmodule.decry.glogLvl;
import cmodule.decry.gstackSize;
import cmodule.decry.gstaticInitter;
import cmodule.decry.StaticInitter;
import cmodule.decry.genv;
import cmodule.decry.gargs;
import cmodule.decry.gstate;
import cmodule.decry.MState;
import cmodule.decry.Machine;
import cmodule.decry.gsetjmpMachine2ESPMap;
import flash.utils.Dictionary;
import cmodule.decry.i__setjmp;
import cmodule.decry.exportSym;
import cmodule.decry.regFunc;
import cmodule.decry.FSM__setjmp;
import cmodule.decry.i_setjmp;
import cmodule.decry.i__longjmp;
import cmodule.decry.FSM__longjmp;
import cmodule.decry.i_longjmp;
import cmodule.decry.vglKeys;
import cmodule.decry.vglKeyFirst;
import cmodule.decry.vglMouseFirst;
import cmodule.decry.__fini;
import cmodule.decry.FSM__fini;
import cmodule.decry.___error;
import cmodule.decry.FSM___error;
import cmodule.decry._ioctl;
import cmodule.decry.FSM_ioctl;
import cmodule.decry._fstat;
import cmodule.decry.FSM_fstat;
import cmodule.decry.__exit;
import cmodule.decry.FSM__exit;
import cmodule.decry._sprintf;
import cmodule.decry.FSM_sprintf;
import cmodule.decry.__start;
import cmodule.decry.FSM__start;
import cmodule.decry._atexit;
import cmodule.decry.FSM_atexit;
import cmodule.decry._exit;
import cmodule.decry.FSM_exit;
import cmodule.decry._dorounding;
import cmodule.decry.FSM_dorounding;
import cmodule.decry._abort1;
import cmodule.decry.FSM_abort1;
import cmodule.decry.___gdtoa;
import cmodule.decry.FSM___gdtoa;
import cmodule.decry.___Balloc_D2A;
import cmodule.decry.FSM___Balloc_D2A;
import cmodule.decry.___quorem_D2A;
import cmodule.decry.FSM___quorem_D2A;
import cmodule.decry.___pow5mult_D2A;
import cmodule.decry.FSM___pow5mult_D2A;
import cmodule.decry.___mult_D2A;
import cmodule.decry.FSM___mult_D2A;
import cmodule.decry.___lshift_D2A;
import cmodule.decry.FSM___lshift_D2A;
import cmodule.decry.___multadd_D2A;
import cmodule.decry.FSM___multadd_D2A;
import cmodule.decry.___diff_D2A;
import cmodule.decry.FSM___diff_D2A;
import cmodule.decry.___lo0bits_D2A;
import cmodule.decry.FSM___lo0bits_D2A;
import cmodule.decry.___trailz_D2A;
import cmodule.decry.FSM___trailz_D2A;
import cmodule.decry._fprintf;
import cmodule.decry.FSM_fprintf;
import cmodule.decry._getenv;
import cmodule.decry.FSM_getenv;
import cmodule.decry._bcopy;
import cmodule.decry.FSM_bcopy;
import cmodule.decry._free;
import cmodule.decry.FSM_free;
import cmodule.decry.__UTF8_wcrtomb;
import cmodule.decry.FSM__UTF8_wcrtomb;
import cmodule.decry.___adddi3;
import cmodule.decry.FSM___adddi3;
import cmodule.decry.___anddi3;
import cmodule.decry.FSM___anddi3;
import cmodule.decry.___ashldi3;
import cmodule.decry.FSM___ashldi3;
import cmodule.decry.___ashrdi3;
import cmodule.decry.FSM___ashrdi3;
import cmodule.decry.___cmpdi2;
import cmodule.decry.FSM___cmpdi2;
import cmodule.decry.___divdi3;
import cmodule.decry.FSM___divdi3;
import cmodule.decry.___qdivrem;
import cmodule.decry.FSM___qdivrem;
import cmodule.decry.___fixdfdi;
import cmodule.decry.FSM___fixdfdi;
import cmodule.decry.___fixsfdi;
import cmodule.decry.FSM___fixsfdi;
import cmodule.decry.___fixunsdfdi;
import cmodule.decry.FSM___fixunsdfdi;
import cmodule.decry.___fixunssfdi;
import cmodule.decry.FSM___fixunssfdi;
import cmodule.decry.___floatdidf;
import cmodule.decry.FSM___floatdidf;
import cmodule.decry.___floatdisf;
import cmodule.decry.FSM___floatdisf;
import cmodule.decry.___floatunsdidf;
import cmodule.decry.FSM___floatunsdidf;
import cmodule.decry.___iordi3;
import cmodule.decry.FSM___iordi3;
import cmodule.decry.___lshldi3;
import cmodule.decry.FSM___lshldi3;
import cmodule.decry.___lshrdi3;
import cmodule.decry.FSM___lshrdi3;
import cmodule.decry.___moddi3;
import cmodule.decry.FSM___moddi3;
import cmodule.decry.___lmulq;
import cmodule.decry.FSM___lmulq;
import cmodule.decry.___muldi3;
import cmodule.decry.FSM___muldi3;
import cmodule.decry.___negdi2;
import cmodule.decry.FSM___negdi2;
import cmodule.decry.___one_cmpldi2;
import cmodule.decry.FSM___one_cmpldi2;
import cmodule.decry.___subdi3;
import cmodule.decry.FSM___subdi3;
import cmodule.decry.___ucmpdi2;
import cmodule.decry.FSM___ucmpdi2;
import cmodule.decry.___udivdi3;
import cmodule.decry.FSM___udivdi3;
import cmodule.decry.___umoddi3;
import cmodule.decry.FSM___umoddi3;
import cmodule.decry.___xordi3;
import cmodule.decry.FSM___xordi3;
import cmodule.decry.___vfprintf;
import cmodule.decry.FSM___vfprintf;
import cmodule.decry.___sflush;
import cmodule.decry.FSM___sflush;
import cmodule.decry.___sread;
import cmodule.decry.FSM___sread;
import cmodule.decry.___swrite;
import cmodule.decry.FSM___swrite;
import cmodule.decry.___sseek;
import cmodule.decry.FSM___sseek;
import cmodule.decry.___sclose;
import cmodule.decry.FSM___sclose;
import cmodule.decry.__swrite;
import cmodule.decry.FSM__swrite;
import cmodule.decry.___fflush;
import cmodule.decry.FSM___fflush;
import cmodule.decry.__cleanup;
import cmodule.decry.FSM__cleanup;
import cmodule.decry.__sseek;
import cmodule.decry.FSM__sseek;
import cmodule.decry.___sfvwrite;
import cmodule.decry.FSM___sfvwrite;
import cmodule.decry.___swsetup;
import cmodule.decry.FSM___swsetup;
import cmodule.decry.___smakebuf;
import cmodule.decry.FSM___smakebuf;
import cmodule.decry.___ultoa;
import cmodule.decry.FSM___ultoa;
import cmodule.decry.___grow_type_table;
import cmodule.decry.FSM___grow_type_table;
import cmodule.decry.___find_arguments;
import cmodule.decry.FSM___find_arguments;
import cmodule.decry._ifree;
import cmodule.decry.FSM_ifree;
import cmodule.decry._imalloc;
import cmodule.decry.FSM_imalloc;
import cmodule.decry._malloc_pages;
import cmodule.decry.FSM_malloc_pages;
import cmodule.decry._pubrealloc;
import cmodule.decry.FSM_pubrealloc;
import cmodule.decry._malloc;
import cmodule.decry.FSM_malloc;
import cmodule.decry._decry;
import cmodule.decry.FSM_decry;
import cmodule.decry.modEnd;

gshell = false;
establishEnv();
glogLvl = 0;
this.gstackSize = (0x0400 * 0x0400);
gfiles = {};
this.gstaticInitter = new StaticInitter();
this.inf = Number.POSITIVE_INFINITY;
this.nan = Number.NaN;
genv = {
    "LANG":"en_US.UTF-8",
    "TERM":"ansi"
};
gargs = ["a.out"];
this.gstate = new MState(new Machine());
this.mstate = gstate;
this.gsetjmpMachine2ESPMap = new Dictionary(true);
this.i__setjmp = exportSym("__setjmp", regFunc(FSM__setjmp.start));
this.i_setjmp = exportSym("_setjmp", i__setjmp);
this.i__longjmp = exportSym("__longjmp", regFunc(FSM__longjmp.start));
this.i_longjmp = exportSym("_longjmp", i__longjmp);
CTypemap.BufferType = new CBufferTypemap();
CTypemap.SizedStrType = new CSizedStrUTF8Typemap();
CTypemap.AS3ValType = new CAS3ValTypemap();
CTypemap.VoidType = new CVoidTypemap();
CTypemap.PtrType = new CPtrTypemap();
CTypemap.IntType = new CIntTypemap();
CTypemap.DoubleType = new CDoubleTypemap();
CTypemap.StrType = new CStrUTF8Typemap();
CTypemap.IntRefType = new CRefTypemap(CTypemap.IntType);
CTypemap.DoubleRefType = new CRefTypemap(CTypemap.DoubleType);
CTypemap.StrRefType = new CRefTypemap(CTypemap.StrType);
this.i_AS3_Acquire = exportSym("_AS3_Acquire", new CProcTypemap(CTypemap.VoidType, [CTypemap.PtrType]).createC(CTypemap.AS3ValType.valueTracker.acquireId)[0]);
this.i_AS3_Release = exportSym("_AS3_Release", new CProcTypemap(CTypemap.VoidType, [CTypemap.PtrType]).createC(CTypemap.AS3ValType.valueTracker.release)[0]);
this.i_AS3_NSGet = exportSym("_AS3_NSGet", new CProcTypemap(CTypemap.AS3ValType, [CTypemap.AS3ValType, CTypemap.AS3ValType]).createC(AS3_NSGet)[0]);
this.i_AS3_NSGetS = exportSym("_AS3_NSGetS", new CProcTypemap(CTypemap.AS3ValType, [CTypemap.AS3ValType, CTypemap.StrType]).createC(AS3_NSGet)[0]);
this.i_AS3_TypeOf = exportSym("_AS3_TypeOf", new CProcTypemap(CTypemap.StrType, [CTypemap.AS3ValType]).createC(AS3_TypeOf)[0]);
this.i_AS3_String = exportSym("_AS3_String", new CProcTypemap(CTypemap.AS3ValType, [CTypemap.StrType]).createC(AS3_NOP)[0]);
this.i_AS3_StringN = exportSym("_AS3_StringN", new CProcTypemap(CTypemap.AS3ValType, [CTypemap.SizedStrType]).createC(AS3_NOP)[0]);
this.i_AS3_Int = exportSym("_AS3_Int", new CProcTypemap(CTypemap.AS3ValType, [CTypemap.IntType]).createC(AS3_NOP)[0]);
this.i_AS3_Ptr = exportSym("_AS3_Ptr", new CProcTypemap(CTypemap.AS3ValType, [CTypemap.PtrType]).createC(AS3_NOP)[0]);
this.i_AS3_Number = exportSym("_AS3_Number", new CProcTypemap(CTypemap.AS3ValType, [CTypemap.DoubleType]).createC(AS3_NOP)[0]);
this.i_AS3_True = exportSym("_AS3_True", new CProcTypemap(CTypemap.AS3ValType, []).createC(function ():Boolean
{
    return (true);
})[0]);
this.i_AS3_False = exportSym("_AS3_False", new CProcTypemap(CTypemap.AS3ValType, []).createC(function ():Boolean
{
    return (false);
})[0]);
this.i_AS3_Null = exportSym("_AS3_Null", new CProcTypemap(CTypemap.AS3ValType, []).createC(function ():*
{
    return (null);
})[0]);
this.i_AS3_Undefined = exportSym("_AS3_Undefined", new CProcTypemap(CTypemap.AS3ValType, []).createC(function ():*
{
    return (undefined);
})[0]);
this.i_AS3_StringValue = exportSym("_AS3_StringValue", new CProcTypemap(CTypemap.StrType, [CTypemap.AS3ValType]).createC(AS3_NOP)[0]);
this.i_AS3_IntValue = exportSym("_AS3_IntValue", new CProcTypemap(CTypemap.IntType, [CTypemap.AS3ValType]).createC(AS3_NOP)[0]);
this.i_AS3_PtrValue = exportSym("_AS3_PtrValue", new CProcTypemap(CTypemap.PtrType, [CTypemap.AS3ValType]).createC(AS3_NOP)[0]);
this.i_AS3_NumberValue = exportSym("_AS3_NumberValue", new CProcTypemap(CTypemap.DoubleType, [CTypemap.AS3ValType]).createC(AS3_NOP)[0]);
this.i_AS3_Get = exportSym("_AS3_Get", new CProcTypemap(CTypemap.AS3ValType, [CTypemap.AS3ValType, CTypemap.AS3ValType]).createC(AS3_Get)[0]);
this.i_AS3_GetS = exportSym("_AS3_GetS", new CProcTypemap(CTypemap.AS3ValType, [CTypemap.AS3ValType, CTypemap.StrType]).createC(AS3_Get)[0]);
this.i_AS3_Set = exportSym("_AS3_Set", new CProcTypemap(CTypemap.VoidType, [CTypemap.AS3ValType, CTypemap.AS3ValType, CTypemap.AS3ValType]).createC(AS3_Set)[0]);
this.i_AS3_SetS = exportSym("_AS3_SetS", new CProcTypemap(CTypemap.VoidType, [CTypemap.AS3ValType, CTypemap.StrType, CTypemap.AS3ValType]).createC(AS3_Set)[0]);
this.i_AS3_Array = exportSym("_AS3_Array", new CProcTypemap(CTypemap.AS3ValType, [CTypemap.StrType], true).createC(AS3_Array)[0]);
this.i_AS3_Object = exportSym("_AS3_Object", new CProcTypemap(CTypemap.AS3ValType, [CTypemap.StrType], true).createC(AS3_Object)[0]);
this.i_AS3_Call = exportSym("_AS3_Call", new CProcTypemap(CTypemap.AS3ValType, [CTypemap.AS3ValType, CTypemap.AS3ValType, CTypemap.AS3ValType]).createC(AS3_Call)[0]);
this.i_AS3_CallS = exportSym("_AS3_CallS", new CProcTypemap(CTypemap.AS3ValType, [CTypemap.StrType, CTypemap.AS3ValType, CTypemap.AS3ValType]).createC(AS3_CallS)[0]);
this.i_AS3_CallT = exportSym("_AS3_CallT", new CProcTypemap(CTypemap.AS3ValType, [CTypemap.AS3ValType, CTypemap.AS3ValType, CTypemap.StrType], true).createC(AS3_CallT)[0]);
this.i_AS3_CallTS = exportSym("_AS3_CallTS", new CProcTypemap(CTypemap.AS3ValType, [CTypemap.StrType, CTypemap.AS3ValType, CTypemap.StrType], true).createC(AS3_CallTS)[0]);
this.i_AS3_Shim = exportSym("_AS3_Shim", new CProcTypemap(CTypemap.PtrType, [CTypemap.AS3ValType, CTypemap.AS3ValType, CTypemap.StrType, CTypemap.StrType, CTypemap.IntType]).createC(AS3_Shim)[0]);
this.i_AS3_New = exportSym("_AS3_New", new CProcTypemap(CTypemap.AS3ValType, [CTypemap.AS3ValType, CTypemap.AS3ValType]).createC(AS3_New)[0]);
this.i_AS3_Function = exportSym("_AS3_Function", new CProcTypemap(CTypemap.AS3ValType, [CTypemap.PtrType, new CProcTypemap(CTypemap.AS3ValType, [CTypemap.PtrType, CTypemap.AS3ValType])]).createC(AS3_Function)[0]);
this.i_AS3_FunctionAsync = exportSym("_AS3_FunctionAsync", new CProcTypemap(CTypemap.AS3ValType, [CTypemap.PtrType, new CProcTypemap(CTypemap.AS3ValType, [CTypemap.PtrType, CTypemap.AS3ValType], false, true)]).createC(AS3_FunctionAsync)[0]);
this.i_AS3_FunctionT = exportSym("_AS3_FunctionT", new CProcTypemap(CTypemap.AS3ValType, [CTypemap.PtrType, CTypemap.PtrType, CTypemap.StrType, CTypemap.StrType, CTypemap.IntType]).createC(AS3_FunctionT)[0]);
this.i_AS3_FunctionAsyncT = exportSym("_AS3_FunctionAsyncT", new CProcTypemap(CTypemap.AS3ValType, [CTypemap.PtrType, CTypemap.PtrType, CTypemap.StrType, CTypemap.StrType, CTypemap.IntType]).createC(AS3_FunctionAsyncT)[0]);
this.i_AS3_InstanceOf = exportSym("_AS3_InstanceOf", new CProcTypemap(CTypemap.IntType, [CTypemap.AS3ValType, CTypemap.AS3ValType]).createC(AS3_InstanceOf)[0]);
this.i_AS3_Stage = exportSym("_AS3_Stage", new CProcTypemap(CTypemap.AS3ValType, []).createC(AS3_Stage)[0]);
this.i_AS3_ArrayValue = exportSym("_AS3_ArrayValue", new CProcTypemap(CTypemap.VoidType, [CTypemap.AS3ValType, CTypemap.StrType], true).createC(AS3_ArrayValue)[0]);
this.i_AS3_ObjectValue = exportSym("_AS3_ObjectValue", new CProcTypemap(CTypemap.VoidType, [CTypemap.AS3ValType, CTypemap.StrType], true).createC(AS3_ObjectValue)[0]);
this.i_AS3_Proxy = exportSym("_AS3_Proxy", new CProcTypemap(CTypemap.AS3ValType, [], false).createC(AS3_Proxy)[0]);
this.i_AS3_Ram = exportSym("_AS3_Ram", new CProcTypemap(CTypemap.AS3ValType, [], false).createC(AS3_Ram)[0]);
this.i_AS3_ByteArray_readBytes = exportSym("_AS3_ByteArray_readBytes", new CProcTypemap(CTypemap.IntType, [CTypemap.IntType, CTypemap.AS3ValType, CTypemap.IntType], false).createC(AS3_ByteArray_readBytes)[0]);
this.i_AS3_ByteArray_writeBytes = exportSym("_AS3_ByteArray_writeBytes", new CProcTypemap(CTypemap.IntType, [CTypemap.AS3ValType, CTypemap.IntType, CTypemap.IntType], false).createC(AS3_ByteArray_writeBytes)[0]);
this.i_AS3_ByteArray_seek = exportSym("_AS3_ByteArray_seek", new CProcTypemap(CTypemap.IntType, [CTypemap.AS3ValType, CTypemap.IntType, CTypemap.IntType], false).createC(AS3_ByteArray_seek)[0]);
this.i_AS3_Trace = exportSym("_AS3_Trace", new CProcTypemap(CTypemap.VoidType, [CTypemap.AS3ValType], false).createC(trace)[0]);
this.i_AS3_Reg_jmp_buf_AbuseHelpers = exportSym("_AS3_Reg_jmp_buf_AbuseHelpers", new CProcTypemap(CTypemap.VoidType, [new CProcTypemap(CTypemap.PtrType, [CTypemap.IntType]), new CProcTypemap(CTypemap.VoidType, [CTypemap.PtrType])], false).createC(AS3_Reg_jmp_buf_AbuseHelpers)[0]);
this.i_AS3_RegAbused_jmp_buf = exportSym("_AS3_RegAbused_jmp_buf", new CProcTypemap(CTypemap.VoidType, [CTypemap.PtrType], false).createC(AS3_RegAbused_jmp_buf)[0]);
this.i_AS3_UnregAbused_jmp_buf = exportSym("_AS3_UnregAbused_jmp_buf", new CProcTypemap(CTypemap.VoidType, [CTypemap.PtrType], false).createC(AS3_UnregAbused_jmp_buf)[0]);
vglKeys = [];
vglKeyFirst = true;
vglMouseFirst = true;
this.__fini = regFunc(FSM__fini.start);
this.___error = regFunc(FSM___error.start);
this._ioctl = regFunc(FSM_ioctl.start);
this._fstat = regFunc(FSM_fstat.start);
this.__exit = regFunc(FSM__exit.start);
this._sprintf = regFunc(FSM_sprintf.start);
this.__start = regFunc(FSM__start.start);
this._atexit = regFunc(FSM_atexit.start);
this._exit = regFunc(FSM_exit.start);
this._dorounding = regFunc(FSM_dorounding.start);
this._abort1 = regFunc(FSM_abort1.start);
this.___gdtoa = regFunc(FSM___gdtoa.start);
this.___Balloc_D2A = regFunc(FSM___Balloc_D2A.start);
this.___quorem_D2A = regFunc(FSM___quorem_D2A.start);
this.___pow5mult_D2A = regFunc(FSM___pow5mult_D2A.start);
this.___mult_D2A = regFunc(FSM___mult_D2A.start);
this.___lshift_D2A = regFunc(FSM___lshift_D2A.start);
this.___multadd_D2A = regFunc(FSM___multadd_D2A.start);
this.___diff_D2A = regFunc(FSM___diff_D2A.start);
this.___lo0bits_D2A = regFunc(FSM___lo0bits_D2A.start);
this.___trailz_D2A = regFunc(FSM___trailz_D2A.start);
this._fprintf = regFunc(FSM_fprintf.start);
this._getenv = regFunc(FSM_getenv.start);
this._bcopy = regFunc(FSM_bcopy.start);
this._free = regFunc(FSM_free.start);
this.__UTF8_wcrtomb = regFunc(FSM__UTF8_wcrtomb.start);
this.___adddi3 = regFunc(FSM___adddi3.start);
this.___anddi3 = regFunc(FSM___anddi3.start);
this.___ashldi3 = regFunc(FSM___ashldi3.start);
this.___ashrdi3 = regFunc(FSM___ashrdi3.start);
this.___cmpdi2 = regFunc(FSM___cmpdi2.start);
this.___divdi3 = regFunc(FSM___divdi3.start);
this.___qdivrem = regFunc(FSM___qdivrem.start);
this.___fixdfdi = regFunc(FSM___fixdfdi.start);
this.___fixsfdi = regFunc(FSM___fixsfdi.start);
this.___fixunsdfdi = regFunc(FSM___fixunsdfdi.start);
this.___fixunssfdi = regFunc(FSM___fixunssfdi.start);
this.___floatdidf = regFunc(FSM___floatdidf.start);
this.___floatdisf = regFunc(FSM___floatdisf.start);
this.___floatunsdidf = regFunc(FSM___floatunsdidf.start);
this.___iordi3 = regFunc(FSM___iordi3.start);
this.___lshldi3 = regFunc(FSM___lshldi3.start);
this.___lshrdi3 = regFunc(FSM___lshrdi3.start);
this.___moddi3 = regFunc(FSM___moddi3.start);
this.___lmulq = regFunc(FSM___lmulq.start);
this.___muldi3 = regFunc(FSM___muldi3.start);
this.___negdi2 = regFunc(FSM___negdi2.start);
this.___one_cmpldi2 = regFunc(FSM___one_cmpldi2.start);
this.___subdi3 = regFunc(FSM___subdi3.start);
this.___ucmpdi2 = regFunc(FSM___ucmpdi2.start);
this.___udivdi3 = regFunc(FSM___udivdi3.start);
this.___umoddi3 = regFunc(FSM___umoddi3.start);
this.___xordi3 = regFunc(FSM___xordi3.start);
this.___vfprintf = regFunc(FSM___vfprintf.start);
this.___sflush = regFunc(FSM___sflush.start);
this.___sread = regFunc(FSM___sread.start);
this.___swrite = regFunc(FSM___swrite.start);
this.___sseek = regFunc(FSM___sseek.start);
this.___sclose = regFunc(FSM___sclose.start);
this.__swrite = regFunc(FSM__swrite.start);
this.___fflush = regFunc(FSM___fflush.start);
this.__cleanup = regFunc(FSM__cleanup.start);
this.__sseek = regFunc(FSM__sseek.start);
this.___sfvwrite = regFunc(FSM___sfvwrite.start);
this.___swsetup = regFunc(FSM___swsetup.start);
this.___smakebuf = regFunc(FSM___smakebuf.start);
this.___ultoa = regFunc(FSM___ultoa.start);
this.___grow_type_table = regFunc(FSM___grow_type_table.start);
this.___find_arguments = regFunc(FSM___find_arguments.start);
this._ifree = regFunc(FSM_ifree.start);
this._imalloc = regFunc(FSM_imalloc.start);
this._malloc_pages = regFunc(FSM_malloc_pages.start);
this._pubrealloc = regFunc(FSM_pubrealloc.start);
this._malloc = regFunc(FSM_malloc.start);
this._decry = regFunc(FSM_decry.start);
this.__2E_str = gstaticInitter.alloc(6, 1);
this.__2E_str1 = gstaticInitter.alloc(6, 1);
this._val_2E_939 = gstaticInitter.alloc(4, 4);
this.__2E_str8 = gstaticInitter.alloc(10, 1);
this.__2E_str311 = gstaticInitter.alloc(7, 1);
this.__2E_str4 = gstaticInitter.alloc(8, 1);
this.__2E_str37 = gstaticInitter.alloc(10, 1);
this.__2E_str138 = gstaticInitter.alloc(14, 1);
this.__2E_str441 = gstaticInitter.alloc(12, 1);
this.__2E_str643 = gstaticInitter.alloc(5, 1);
this.__2E_str150 = gstaticInitter.alloc(12, 1);
this.__2E_str169 = gstaticInitter.alloc(14, 1);
this.__2E_str775 = gstaticInitter.alloc(7, 1);
this.__2E_str1679 = gstaticInitter.alloc(10, 1);
this.__2E_str95 = gstaticInitter.alloc(23, 1);
this.__2E_str58 = gstaticInitter.alloc(1, 1);
this._environ = gstaticInitter.alloc(4, 4);
this.__2E_str161 = gstaticInitter.alloc(9, 1);
this.__2E_str262 = gstaticInitter.alloc(4, 1);
this.___tens_D2A = gstaticInitter.alloc(184, 8);
this.___bigtens_D2A = gstaticInitter.alloc(40, 8);
this._pmem_next = gstaticInitter.alloc(4, 4);
this._private_mem = gstaticInitter.alloc(0x0900, 8);
this._freelist = gstaticInitter.alloc(64, 4);
this._p05_2E_3275 = gstaticInitter.alloc(12, 4);
this._p5s = gstaticInitter.alloc(4, 4);
this.___mlocale_changed_2E_b = gstaticInitter.alloc(1, 1);
this.__2E_str20157 = gstaticInitter.alloc(2, 1);
this._numempty22 = gstaticInitter.alloc(2, 1);
this.___nlocale_changed_2E_b = gstaticInitter.alloc(1, 1);
this._ret_2E_993_2E_0_2E_b = gstaticInitter.alloc(1, 1);
this._ret_2E_993_2E_2_2E_b = gstaticInitter.alloc(1, 1);
this.___sF = gstaticInitter.alloc(264, 8);
this.___sglue = gstaticInitter.alloc(12, 8);
this._uglue = gstaticInitter.alloc(12, 8);
this._usual = gstaticInitter.alloc(1496, 8);
this.___sFX = gstaticInitter.alloc(456, 8);
this.___sdidinit_2E_b = gstaticInitter.alloc(1, 1);
this._usual_extra = gstaticInitter.alloc(2584, 8);
this.___cleanup_2E_b = gstaticInitter.alloc(1, 1);
this._blanks_2E_4034 = gstaticInitter.alloc(16, 1);
this._zeroes_2E_4035 = gstaticInitter.alloc(16, 1);
this._xdigs_lower_2E_4036 = gstaticInitter.alloc(17, 1);
this._xdigs_upper_2E_4037 = gstaticInitter.alloc(17, 1);
this._initial_2E_4084 = gstaticInitter.alloc(128, 8);
this.__2E_str118276 = gstaticInitter.alloc(4, 1);
this.__2E_str219277 = gstaticInitter.alloc(4, 1);
this.__2E_str320278 = gstaticInitter.alloc(4, 1);
this.__2E_str421 = gstaticInitter.alloc(4, 1);
this.__2E_str522 = gstaticInitter.alloc(7, 1);
this.___atexit0_2E_2520 = gstaticInitter.alloc(520, 8);
this.___atexit = gstaticInitter.alloc(4, 4);
this._malloc_junk_2E_b = gstaticInitter.alloc(1, 1);
this._malloc_hint_2E_b = gstaticInitter.alloc(1, 1);
this._malloc_cache = gstaticInitter.alloc(4, 4);
this._malloc_origo = gstaticInitter.alloc(4, 4);
this._last_index = gstaticInitter.alloc(4, 4);
this._page_dir = gstaticInitter.alloc(4, 4);
this._px = gstaticInitter.alloc(4, 4);
this._free_list = gstaticInitter.alloc(20, 8);
this._malloc_brk = gstaticInitter.alloc(4, 4);
this._malloc_ninfo = gstaticInitter.alloc(4, 4);
this._malloc_zero_2E_b = gstaticInitter.alloc(1, 1);
this._malloc_active_2E_3023 = gstaticInitter.alloc(4, 4);
this._malloc_started_2E_3024_2E_b = gstaticInitter.alloc(1, 1);
this.__2E_str113328 = gstaticInitter.alloc(15, 1);
this._malloc_realloc_2E_b = gstaticInitter.alloc(1, 1);
this._malloc_sysv_2E_b = gstaticInitter.alloc(1, 1);
this.__2E_str4397 = gstaticInitter.alloc(13, 1);
this.__2E_str99 = gstaticInitter.alloc(11, 1);
this.__2E_str1100 = gstaticInitter.alloc(12, 1);
this.__2E_str2101 = gstaticInitter.alloc(10, 1);
this.__2E_str4103 = gstaticInitter.alloc(10, 1);
this.__2E_str5104 = gstaticInitter.alloc(9, 1);
this.__2E_str6105 = gstaticInitter.alloc(7, 1);
this.__2E_str7106 = gstaticInitter.alloc(15, 1);
this.__2E_str8107 = gstaticInitter.alloc(27, 1);
this.__2E_str9108 = gstaticInitter.alloc(19, 1);
this.__2E_str10109 = gstaticInitter.alloc(9, 1);
this.__2E_str11110 = gstaticInitter.alloc(18, 1);
modEnd();

