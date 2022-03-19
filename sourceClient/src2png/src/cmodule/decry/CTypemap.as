// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//cmodule.decry.CTypemap

package cmodule.decry
{
    import cmodule.decry.*;
    import flash.events.*;
    import flash.display.*;
    import flash.utils.*;
    import flash.text.*;
    import flash.net.*;
    import flash.system.*;

    internal class CTypemap 
    {

        public static var BufferType:CBufferTypemap;
        public static var SizedStrType:CSizedStrUTF8Typemap;
        public static var AS3ValType:CAS3ValTypemap;
        public static var VoidType:CVoidTypemap;
        public static var PtrType:CPtrTypemap;
        public static var IntType:CIntTypemap;
        public static var DoubleType:CDoubleTypemap;
        public static var StrType:CStrUTF8Typemap;
        public static var IntRefType:CRefTypemap;
        public static var DoubleRefType:CRefTypemap;
        public static var StrRefType:CRefTypemap;


        public static function getTypeByName(_arg_1:String):CTypemap
        {
            return (CTypemap[_arg_1]);
        }

        public static function getTypesByNames(_arg_1:String):Array
        {
            return (CTypemap.getTypesByNameArray(_arg_1.split(/\s*,\s*/)));
        }

        public static function getTypesByNameArray(_arg_1:Array):Array
        {
            var _local_3:*;
            var _local_2:Array = [];
            if (_arg_1)
            {
                for each (_local_3 in _arg_1)
                {
                    _local_2.push(CTypemap.getTypeByName(_local_3));
                };
            };
            return (_local_2);
        }


        public function fromC(_arg_1:Array):*
        {
            return (undefined);
        }

        public function writeValue(_arg_1:int, _arg_2:*):void
        {
            var _local_3:Array = this.createC(_arg_2);
            mstate.ds.position = _arg_1;
            var _local_4:int;
            while (_local_4 < _local_3.length)
            {
                mstate.ds.writeInt(_local_3[_local_4]);
                _local_4++;
            };
        }

        public function readValue(_arg_1:int):*
        {
            var _local_2:Array = [];
            mstate.ds.position = _arg_1;
            var _local_3:int;
            while (_local_3 < this.typeSize)
            {
                _local_2.push(mstate.ds.readInt());
                _local_3++;
            };
            return (this.fromC(_local_2));
        }

        public function get ptrLevel():int
        {
            return (0);
        }

        public function createC(_arg_1:*, _arg_2:int=0):Array
        {
            return (null);
        }

        public function fromReturnRegs(_arg_1:Object):*
        {
            var _local_2:Array = [_arg_1.eax];
            var _local_3:* = this.fromC(_local_2);
            this.destroyC(_local_2);
            return (_local_3);
        }

        public function destroyC(_arg_1:Array):void
        {
        }

        public function toReturnRegs(_arg_1:Object, _arg_2:*, _arg_3:int=0):void
        {
            _arg_1.eax = this.createC(_arg_2, _arg_3)[0];
        }

        public function get typeSize():int
        {
            return (4);
        }

        public function getValueSize(_arg_1:*):int
        {
            return (this.typeSize);
        }


    }
}//package cmodule.decry

