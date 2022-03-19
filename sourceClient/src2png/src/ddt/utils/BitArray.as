// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//ddt.utils.BitArray

package ddt.utils
{
    import flash.utils.ByteArray;

    public class BitArray extends ByteArray 
    {


        public function setBit(_arg_1:uint, _arg_2:Boolean):Boolean
        {
            var _local_3:uint = (_arg_1 >> 3);
            var _local_4:uint = (_arg_1 & 0x07);
            var _local_5:uint = this[_local_3];
            _local_5 = (_local_5 | (1 << _local_4));
            this[_local_3] = _local_5;
            return (true);
        }

        public function getBit(_arg_1:uint):Boolean
        {
            var _local_2:int = (_arg_1 >> 3);
            var _local_3:int = (_arg_1 & 0x07);
            var _local_4:int = this[_local_2];
            var _local_5:uint = (_local_4 & (1 << _local_3));
            if (_local_5)
            {
                return (true);
            };
            return (false);
        }

        public function loadBinary(_arg_1:String):void
        {
            var _local_2:Number = 0;
            while (_local_2 < (_arg_1.length * 32))
            {
                this.setBit(_local_2, ((_arg_1) && (1 >> _local_2)));
                _local_2++;
            };
        }

        public function traceBinary(_arg_1:uint):String
        {
            var _local_2:uint = (_arg_1 >> 3);
            var _local_3:int = (_arg_1 & 0x07);
            var _local_4:int = this[_local_2];
            var _local_5:String = "";
            var _local_6:uint;
            while (_local_6 < 8)
            {
                if (_local_6 == _local_3)
                {
                    if ((_local_4 & (1 << _local_6)))
                    {
                        _local_5 = (_local_5 + "[1]");
                    }
                    else
                    {
                        _local_5 = (_local_5 + "[0]");
                    };
                }
                else
                {
                    if ((_local_4 & (1 << _local_6)))
                    {
                        _local_5 = (_local_5 + " 1 ");
                    }
                    else
                    {
                        _local_5 = (_local_5 + " 0 ");
                    };
                };
                _local_6++;
            };
            return (_local_5);
        }


    }
}//package ddt.utils

