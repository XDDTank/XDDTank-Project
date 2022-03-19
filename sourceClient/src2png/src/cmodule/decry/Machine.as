// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//cmodule.decry.Machine

package cmodule.decry
{
    import flash.events.*;
    import flash.display.*;
    import flash.utils.*;
    import flash.text.*;
    import flash.net.*;
    import flash.system.*;

    public class Machine extends MemUser 
    {

        public static const dbgFileNames:Array = [];
        public static const dbgFuncs:Array = [];
        public static const dbgFuncNames:Array = [];
        public static const dbgLabels:Array = [];
        public static const dbgLocs:Array = [];
        public static const dbgScopes:Array = [];
        public static const dbgGlobals:Array = [];
        public static const dbgBreakpoints:Object = {};
        public static var dbgFrameBreakLow:int = 0;
        public static var dbgFrameBreakHigh:int = -1;
        public static var sMS:uint;

        public var dbgFileId:int = 0;
        public var dbgLabel:int = 0;
        public var state:int = 0;
        public var dbgLineNo:int = 0;

        public var caller:Machine = ((gstate) ? gstate.gworker : null);
        public var mstate:MState = ((caller) ? caller.mstate : null);


        public static function debugTraverseScope(_arg_1:Object, _arg_2:int, _arg_3:Function):void
        {
            var _local_4:Array;
            var _local_5:int;
            if ((((_arg_1) && (_arg_2 >= _arg_1.startLabelId)) && (_arg_2 < _arg_1.endLabelId)))
            {
                (_arg_3(_arg_1));
                _local_4 = _arg_1.scopes;
                _local_5 = 0;
                while (_local_5 < _local_4.length)
                {
                    debugTraverseScope(_local_4[_local_5], _arg_2, _arg_3);
                    _local_5++;
                };
            };
        }


        public function debugTraceMem(_arg_1:int, _arg_2:int):void
        {
            trace("");
            trace("*****");
            while (_arg_1 <= _arg_2)
            {
                trace(((("* " + _arg_1) + " : ") + this.mstate._mr32(_arg_1)));
                _arg_1 = (_arg_1 + 4);
            };
            trace("");
        }

        public function get dbgFuncId():int
        {
            return (-1);
        }

        public function work():void
        {
            throw (new AlchemyYield());
        }

        public function stringFromPtr(_arg_1:int):String
        {
            var _local_3:int;
            var _local_2:String = "";
            while (true)
            {
                _local_3 = this.mstate._mru8(_arg_1++);
                if ((!(_local_3))) break;
                _local_2 = (_local_2 + String.fromCharCode(_local_3));
            };
            return (_local_2);
        }

        public function get dbgLoc():Object
        {
            return ({
                "fileId":this.dbgFileId,
                "lineNo":this.dbgLineNo
            });
        }

        public function get dbgDepth():int
        {
            var _local_2:int;
            var _local_1:Machine = this;
            while (_local_1)
            {
                _local_2++;
                _local_1 = _local_1.caller;
            };
            return (_local_2);
        }

        public function get dbgTrace():String
        {
            return (((((((((this.dbgFuncName + "(") + (this as Object).constructor) + ") - ") + this.dbgFileName) + " : ") + this.dbgLineNo) + "(") + this.state) + ")");
        }

        public function debugTraverseCurrentScope(_arg_1:Function):void
        {
            debugTraverseScope(dbgScopes[this.dbgFuncId], this.dbgLabel, _arg_1);
        }

        public function debugLabel(_arg_1:int):void
        {
            this.dbgLabel = _arg_1;
        }

        public function stringToPtr(_arg_1:int, _arg_2:int, _arg_3:String):int
        {
            var _local_4:int = _arg_3.length;
            if (((_arg_2 >= 0) && (_arg_2 < _local_4)))
            {
                _local_4 = _arg_2;
            };
            var _local_5:int;
            while (_local_5 < _local_4)
            {
                this.mstate._mw8(_arg_1++, _arg_3.charCodeAt(_local_5));
                _local_5++;
            };
            return (_local_4);
        }

        public function debugBreak(_arg_1:Object):void
        {
            throw (new AlchemyBreakpoint(_arg_1));
        }

        public function debugLoc(_arg_1:int, _arg_2:int):void
        {
            var _local_5:int;
            if (((this.dbgFileId == _arg_1) && (this.dbgLineNo == _arg_2)))
            {
                return;
            };
            this.dbgFileId = _arg_1;
            this.dbgLineNo = _arg_2;
            var _local_3:String = ((_arg_1 + ":") + _arg_2);
            var _local_4:Object = dbgBreakpoints[_local_3];
            if (((_local_4) && (_local_4.enabled)))
            {
                if (_local_4.temp)
                {
                    delete dbgBreakpoints[_local_3];
                };
                this.debugBreak(_local_4);
            }
            else
            {
                if (dbgFrameBreakHigh >= dbgFrameBreakLow)
                {
                    _local_5 = this.dbgDepth;
                    if (((_local_5 >= dbgFrameBreakLow) && (_local_5 <= dbgFrameBreakHigh)))
                    {
                        this.debugBreak(null);
                    };
                };
            };
        }

        public function get dbgFileName():String
        {
            return (dbgFileNames[this.dbgFileId]);
        }

        public function getSecsSetMS():uint
        {
            var _local_1:Number = new Date().time;
            Machine.sMS = (_local_1 % 1000);
            return (_local_1 / 1000);
        }

        public function get dbgFuncName():String
        {
            return (dbgFuncNames[this.dbgFuncId]);
        }

        public function backtrace():void
        {
            var framePtr:int;
            var cur:Machine = this;
            trace("");
            trace("*** backtrace");
            framePtr = this.mstate.ebp;
            while (cur)
            {
                trace(cur.dbgTrace);
                cur.debugTraverseCurrentScope(function (_arg_1:Object):void
                {
                    var _local_4:int;
                    var _local_5:int;
                    var _local_6:String;
                    var _local_7:int;
                    trace("{{{");
                    var _local_2:Array = _arg_1.vars;
                    var _local_3:int;
                    while (_local_3 < _local_2.length)
                    {
                        _local_4 = _local_2[(_local_3 + 0)];
                        _local_5 = public::mstate._mr32((_local_4 + 8));
                        _local_6 = stringFromPtr(_local_5);
                        _local_7 = _local_2[(_local_3 + 1)];
                        trace((((("--- " + _local_6) + " (") + (_local_7 + framePtr)) + ")"));
                        _local_3 = (_local_3 + 2);
                    };
                });
                framePtr = this.mstate._mr32(framePtr);
                cur = cur.caller;
            };
            trace("");
        }


    }
}//package cmodule.decry

