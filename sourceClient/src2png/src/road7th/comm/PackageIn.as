// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//road7th.comm.PackageIn

package road7th.comm
{
    import flash.utils.ByteArray;

    public class PackageIn extends ByteArray 
    {

        public static const HEADER_SIZE:Number = 20;

        private var _len:int;
        private var _checksum:int;
        private var _clientId:int;
        private var _code:int;
        private var _extend1:int;
        private var _extend2:int;


        public function load(_arg_1:ByteArray, _arg_2:int):void
        {
            writeByte(_arg_1.readByte());
            this.readHeader();
        }

        public function loadE(_arg_1:ByteArray, _arg_2:int, _arg_3:ByteArray):void
        {
            var _local_4:int;
            var _local_5:ByteArray = new ByteArray();
            var _local_6:ByteArray = new ByteArray();
            _local_4 = 0;
            while (_local_4 < _arg_2)
            {
                _local_5.writeByte(_arg_1.readByte());
                _local_6.writeByte(_local_5[_local_4]);
                _local_4++;
            };
            _local_4 = 0;
            while (_local_4 < _arg_2)
            {
                if (_local_4 > 0)
                {
                    _arg_3[(_local_4 % 8)] = ((_arg_3[(_local_4 % 8)] + _local_5[(_local_4 - 1)]) ^ _local_4);
                    _local_6[_local_4] = ((_local_5[_local_4] - _local_5[(_local_4 - 1)]) ^ _arg_3[(_local_4 % 8)]);
                }
                else
                {
                    _local_6[_local_4] = (_local_5[_local_4] ^ _arg_3[0]);
                };
                _local_4++;
            };
            _local_6.position = 0;
            _local_4 = 0;
            while (_local_4 < _arg_2)
            {
                writeByte(_local_6.readByte());
                _local_4++;
            };
            position = 0;
            this.readHeader();
        }

        public function readHeader():void
        {
            readShort();
            this._len = readShort();
            this._checksum = readShort();
            this._code = readShort();
            this._clientId = readInt();
            this._extend1 = readInt();
            this._extend2 = readInt();
        }

        public function get checkSum():int
        {
            return (this._checksum);
        }

        public function get code():int
        {
            return (this._code);
        }

        public function get clientId():int
        {
            return (this._clientId);
        }

        public function get extend1():int
        {
            return (this._extend1);
        }

        public function get extend2():int
        {
            return (this._extend2);
        }

        public function set extend2(_arg_1:int):void
        {
            this._extend2 = _arg_1;
        }

        public function get Len():int
        {
            return (this._len);
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

        public function readXml():XML
        {
            return (new XML(readUTF()));
        }

        public function readDateString():String
        {
            return ((((((((((readShort() + "-") + readByte()) + "-") + readByte()) + " ") + readByte()) + ":") + readByte()) + ":") + readByte());
        }

        public function readDate():Date
        {
            var _local_1:int = readShort();
            var _local_2:int = (readByte() - 1);
            var _local_3:int = readByte();
            var _local_4:int = readByte();
            var _local_5:int = readByte();
            var _local_6:int = readByte();
            return (new Date(_local_1, _local_2, _local_3, _local_4, _local_5, _local_6));
        }

        public function readByteArray():ByteArray
        {
            var _local_1:ByteArray = new ByteArray();
            readBytes(_local_1, 0, (this._len - position));
            _local_1.position = 0;
            return (_local_1);
        }

        public function deCompress():void
        {
            position = HEADER_SIZE;
            var _local_1:ByteArray = new ByteArray();
            readBytes(_local_1, 0, (this._len - HEADER_SIZE));
            _local_1.uncompress();
            position = HEADER_SIZE;
            writeBytes(_local_1, 0, _local_1.length);
            this._len = (HEADER_SIZE + _local_1.length);
            position = HEADER_SIZE;
        }

        public function readLong():Number
        {
            var _local_1:Number = new Number();
            var _local_2:Number = new Number(readInt());
            var _local_3:Number = new Number(readUnsignedInt());
            var _local_4:int = 1;
            if (_local_2 < 0)
            {
                _local_4 = -1;
            };
            return (_local_4 * (Math.abs((_local_2 * Math.pow(2, 32))) + _local_3));
        }


    }
}//package road7th.comm

