// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//road7th.comm.PackageOut

package road7th.comm
{
    import flash.utils.ByteArray;

    public class PackageOut extends ByteArray 
    {

        public static const HEADER:int = 29099;

        private var _checksum:int;
        private var _code:int;

        public function PackageOut(_arg_1:int, _arg_2:int=0, _arg_3:int=0, _arg_4:int=0)
        {
            writeShort(HEADER);
            writeShort(0);
            writeShort(0);
            writeShort(_arg_1);
            writeInt(_arg_2);
            writeInt(_arg_3);
            writeInt(_arg_4);
            this._code = _arg_1;
            this._checksum = 0;
        }

        public function get code():int
        {
            return (this._code);
        }

        public function pack():void
        {
            this._checksum = this.calculateCheckSum();
            var _local_1:ByteArray = new ByteArray();
            _local_1.writeShort(length);
            _local_1.writeShort(this._checksum);
            this[2] = _local_1[0];
            this[3] = _local_1[1];
            this[4] = _local_1[2];
            this[5] = _local_1[3];
        }

        public function calculateCheckSum():int
        {
            var _local_1:int = 119;
            var _local_2:int = 6;
            while (_local_2 < length)
            {
                _local_1 = (_local_1 + this[_local_2++]);
            };
            return (_local_1 & 0x7F7F);
        }

        public function writeDate(_arg_1:Date):void
        {
            writeShort(_arg_1.getFullYear());
            writeByte((_arg_1.month + 1));
            writeByte(_arg_1.date);
            writeByte(_arg_1.hours);
            writeByte(_arg_1.minutes);
            writeByte(_arg_1.seconds);
        }

        public function writeLong(_arg_1:Number):void
        {
            var _local_7:String;
            var _local_2:Number = _arg_1;
            var _local_3:int = int(_local_2);
            var _local_4:String = _local_2.toString(2);
            if (_local_4.length > 32)
            {
                _local_4 = _local_4.substr(0, (_local_4.length - 32));
            }
            else
            {
                _local_4 = "";
            };
            var _local_5:int;
            var _local_6:int;
            while (_local_6 < _local_4.length)
            {
                _local_7 = _local_4.charAt((_local_4.length - (_local_6 + 1)));
                if (_local_7 != "0")
                {
                    if (_local_7 == "1")
                    {
                        _local_5 = (_local_5 + (1 << _local_6));
                    }
                    else
                    {
                        break;
                    };
                };
                _local_6++;
            };
            writeInt(_local_5);
            writeInt(_local_3);
        }


    }
}//package road7th.comm

