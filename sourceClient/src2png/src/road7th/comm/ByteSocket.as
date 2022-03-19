// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//road7th.comm.ByteSocket

package road7th.comm
{
    import flash.events.EventDispatcher;
    import flash.utils.ByteArray;
    import flash.net.Socket;
    import flash.events.ErrorEvent;
    import flash.events.Event;
    import flash.events.ProgressEvent;
    import flash.events.IOErrorEvent;
    import flash.events.SecurityErrorEvent;

    [Event(name="connect", type="flash.events.Event")]
    [Event(name="close", type="flash.events.Event")]
    [Event(name="error", type="flash.events.ErrorEvent")]
    [Event(name="data", type="SocketEvent")]
    public class ByteSocket extends EventDispatcher 
    {

        private static var KEY:Array = [174, 191, 86, 120, 171, 205, 239, 241];
        public static var RECEIVE_KEY:ByteArray;
        public static var SEND_KEY:ByteArray;

        private var _debug:Boolean;
        private var _socket:Socket;
        private var _ip:String;
        private var _port:Number;
        private var _send_fsm:FSM;
        private var _receive_fsm:FSM;
        private var _encrypted:Boolean;
        private var _readBuffer:ByteArray;
        private var _readOffset:int;
        private var _writeOffset:int;
        private var _headerTemp:ByteArray;
        private var pkgNumber:int = 0;

        public function ByteSocket(_arg_1:Boolean=true, _arg_2:Boolean=false)
        {
            this._readBuffer = new ByteArray();
            this._send_fsm = new FSM(2059198199, 1501);
            this._receive_fsm = new FSM(2059198199, 1501);
            this._headerTemp = new ByteArray();
            this._encrypted = _arg_1;
            this._debug = _arg_2;
            this.setKey(KEY);
        }

        public function setKey(_arg_1:Array):void
        {
            RECEIVE_KEY = new ByteArray();
            SEND_KEY = new ByteArray();
            var _local_2:int;
            while (_local_2 < 8)
            {
                RECEIVE_KEY.writeByte(_arg_1[_local_2]);
                SEND_KEY.writeByte(_arg_1[_local_2]);
                _local_2++;
            };
        }

        public function resetKey():void
        {
            this.setKey(KEY);
        }

        public function setFsm(_arg_1:int, _arg_2:int):void
        {
            this._send_fsm.setup(_arg_1, _arg_2);
            this._receive_fsm.setup(_arg_1, _arg_2);
        }

        public function connect(ip:String, port:Number):void
        {
            try
            {
                if (this._socket)
                {
                    this.close();
                };
                this._socket = new Socket();
                this.addEvent(this._socket);
                this._ip = ip;
                this._port = port;
                this._readBuffer.position = 0;
                this._readOffset = 0;
                this._writeOffset = 0;
                this._socket.connect(ip, port);
            }
            catch(err:Error)
            {
                dispatchEvent(new ErrorEvent(ErrorEvent.ERROR, false, false, err.message));
            };
        }

        private function addEvent(_arg_1:Socket):void
        {
            _arg_1.addEventListener(Event.CONNECT, this.handleConnect);
            _arg_1.addEventListener(Event.CLOSE, this.handleClose);
            _arg_1.addEventListener(ProgressEvent.SOCKET_DATA, this.handleIncoming);
            _arg_1.addEventListener(IOErrorEvent.IO_ERROR, this.handleIoError);
            _arg_1.addEventListener(SecurityErrorEvent.SECURITY_ERROR, this.handleIoError);
        }

        private function removeEvent(_arg_1:Socket):void
        {
            _arg_1.removeEventListener(Event.CONNECT, this.handleConnect);
            _arg_1.removeEventListener(Event.CLOSE, this.handleClose);
            _arg_1.removeEventListener(ProgressEvent.SOCKET_DATA, this.handleIncoming);
            _arg_1.removeEventListener(IOErrorEvent.IO_ERROR, this.handleIoError);
            _arg_1.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, this.handleIoError);
        }

        public function get connected():Boolean
        {
            return ((this._socket) && (this._socket.connected));
        }

        public function isSame(_arg_1:String, _arg_2:int):Boolean
        {
            return ((this._ip == _arg_1) && (_arg_2 == this._port));
        }

        public function send(_arg_1:PackageOut):void
        {
            var _local_2:int;
            if (((this._socket) && (this._socket.connected)))
            {
                _arg_1.pack();
                if (this._debug)
                {
                };
                if (this._encrypted)
                {
                    _local_2 = 0;
                    while (_local_2 < _arg_1.length)
                    {
                        if (_local_2 > 0)
                        {
                            SEND_KEY[(_local_2 % 8)] = ((SEND_KEY[(_local_2 % 8)] + _arg_1[(_local_2 - 1)]) ^ _local_2);
                            _arg_1[_local_2] = ((_arg_1[_local_2] ^ SEND_KEY[(_local_2 % 8)]) + _arg_1[(_local_2 - 1)]);
                        }
                        else
                        {
                            _arg_1[0] = (_arg_1[0] ^ SEND_KEY[0]);
                        };
                        _local_2++;
                    };
                };
                this._socket.writeBytes(_arg_1, 0, _arg_1.length);
                this._socket.flush();
            };
        }

        public function sendString(_arg_1:String):void
        {
            if (this._socket.connected)
            {
                this._socket.writeUTF(_arg_1);
                this._socket.flush();
            };
        }

        public function sendByteArrayString(_arg_1:String):void
        {
            var _local_2:ByteArray = new ByteArray();
            _local_2.writeUTF(_arg_1);
            if (this._socket.connected)
            {
                this._socket.writeBytes(_local_2, 2, (_local_2.length - 2));
                this._socket.flush();
            };
        }

        public function close():void
        {
            this.removeEvent(this._socket);
            if (this._socket.connected)
            {
                this._socket.close();
            };
        }

        private function handleConnect(_arg_1:Event):void
        {
            try
            {
                this._send_fsm.reset();
                this._receive_fsm.reset();
                this._send_fsm.setup(2059198199, 1501);
                this._receive_fsm.setup(2059198199, 1501);
                dispatchEvent(new Event(Event.CONNECT));
            }
            catch(e:Error)
            {
            };
        }

        private function handleClose(_arg_1:Event):void
        {
            try
            {
                this.removeEvent(this._socket);
                dispatchEvent(new Event(Event.CLOSE));
            }
            catch(e:Error)
            {
            };
        }

        private function handleIoError(_arg_1:ErrorEvent):void
        {
            try
            {
                dispatchEvent(new ErrorEvent(ErrorEvent.ERROR, false, false, _arg_1.text));
            }
            catch(e:Error)
            {
            };
        }

        private function handleIncoming(_arg_1:ProgressEvent):void
        {
            var _local_2:int;
            if (this._socket.bytesAvailable > 0)
            {
                _local_2 = this._socket.bytesAvailable;
                this._socket.readBytes(this._readBuffer, this._writeOffset, this._socket.bytesAvailable);
                this._writeOffset = (this._writeOffset + _local_2);
                if (this._writeOffset > 1)
                {
                    this._readBuffer.position = 0;
                    this._readOffset = 0;
                    if (this._readBuffer.bytesAvailable >= PackageIn.HEADER_SIZE)
                    {
                        this.readPackage();
                    };
                };
            };
        }

        private function readPackage():void
        {
            var _local_2:int;
            var _local_3:PackageIn;
            var _local_1:int = (this._writeOffset - this._readOffset);
            do 
            {
                _local_2 = 0;
                while ((this._readOffset + 4) < this._writeOffset)
                {
                    this._headerTemp.position = 0;
                    this._headerTemp.writeByte(this._readBuffer[this._readOffset]);
                    this._headerTemp.writeByte(this._readBuffer[(this._readOffset + 1)]);
                    this._headerTemp.writeByte(this._readBuffer[(this._readOffset + 2)]);
                    this._headerTemp.writeByte(this._readBuffer[(this._readOffset + 3)]);
                    if (this._encrypted)
                    {
                        this._headerTemp = this.decrptBytes(this._headerTemp, 4, this.copyByteArray(RECEIVE_KEY));
                    };
                    this._headerTemp.position = 0;
                    if (this._headerTemp.readShort() == PackageOut.HEADER)
                    {
                        _local_2 = this._headerTemp.readUnsignedShort();
                        break;
                    };
                    this._readOffset++;
                };
                _local_1 = (this._writeOffset - this._readOffset);
                if (((_local_1 >= _local_2) && (!(_local_2 == 0))))
                {
                    this._readBuffer.position = this._readOffset;
                    _local_3 = new PackageIn();
                    if (this._encrypted)
                    {
                        _local_3.loadE(this._readBuffer, _local_2, RECEIVE_KEY);
                    }
                    else
                    {
                        _local_3.load(this._readBuffer, _local_2);
                    };
                    this._readOffset = (this._readOffset + _local_2);
                    _local_1 = (this._writeOffset - this._readOffset);
                    this.handlePackage(_local_3);
                }
                else
                {
                    break;
                };
            } while (_local_1 >= PackageIn.HEADER_SIZE);
            this._readBuffer.position = 0;
            if (_local_1 > 0)
            {
                this._readBuffer.writeBytes(this._readBuffer, this._readOffset, _local_1);
            };
            this._readOffset = 0;
            this._writeOffset = _local_1;
        }

        private function copyByteArray(_arg_1:ByteArray):ByteArray
        {
            var _local_2:ByteArray = new ByteArray();
            var _local_3:int;
            while (_local_3 < _arg_1.length)
            {
                _local_2.writeByte(_arg_1[_local_3]);
                _local_3++;
            };
            return (_local_2);
        }

        public function decrptBytes(_arg_1:ByteArray, _arg_2:int, _arg_3:ByteArray):ByteArray
        {
            var _local_4:int;
            var _local_5:ByteArray = new ByteArray();
            _local_4 = 0;
            while (_local_4 < _arg_2)
            {
                _local_5.writeByte(_arg_1[_local_4]);
                _local_4++;
            };
            _local_4 = 0;
            while (_local_4 < _arg_2)
            {
                if (_local_4 > 0)
                {
                    _arg_3[(_local_4 % 8)] = ((_arg_3[(_local_4 % 8)] + _arg_1[(_local_4 - 1)]) ^ _local_4);
                    _local_5[_local_4] = ((_arg_1[_local_4] - _arg_1[(_local_4 - 1)]) ^ _arg_3[(_local_4 % 8)]);
                }
                else
                {
                    _local_5[0] = (_arg_1[0] ^ _arg_3[0]);
                };
                _local_4++;
            };
            return (_local_5);
        }

        private function tracePkg(_arg_1:ByteArray, _arg_2:String, _arg_3:int=-1):void
        {
            var _local_4:String = _arg_2;
            var _local_5:int = ((_arg_3 < 0) ? _arg_1.length : _arg_3);
            var _local_6:int;
            while (_local_6 < _local_5)
            {
                _local_4 = (_local_4 + (String(_arg_1[_local_6]) + ", "));
                _local_6++;
            };
        }

        private function traceArr(_arg_1:ByteArray):void
        {
            var _local_2:String = "[";
            var _local_3:int;
            while (_local_3 < _arg_1.length)
            {
                _local_2 = (_local_2 + (_arg_1[_local_3] + " "));
                _local_3++;
            };
            _local_2 = (_local_2 + "]");
        }

        private function handlePackage(_arg_1:PackageIn):void
        {
            if (this._debug)
            {
            };
            try
            {
                if (_arg_1.checkSum == _arg_1.calculateCheckSum())
                {
                    _arg_1.position = PackageIn.HEADER_SIZE;
                    dispatchEvent(new SocketEvent(SocketEvent.DATA, _arg_1));
                };
            }
            catch(err:Error)
            {
            };
        }

        public function dispose():void
        {
            if (this._socket.connected)
            {
                this._socket.close();
            };
            this._socket = null;
        }


    }
}//package road7th.comm

class FSM 
{

    /*private*/ var _state:int;
    /*private*/ var _adder:int;
    /*private*/ var _multiper:int;

    public function FSM(_arg_1:int, _arg_2:int)
    {
        this.setup(_arg_1, _arg_2);
    }

    public function getState():int
    {
        return (this._state);
    }

    public function reset():void
    {
        this._state = 0;
    }

    public function setup(_arg_1:int, _arg_2:int):void
    {
        this._adder = _arg_1;
        this._multiper = _arg_2;
        this.updateState();
    }

    public function updateState():int
    {
        this._state = (((~(this._state)) + this._adder) * this._multiper);
        this._state = (this._state ^ (this._state >> 16));
        return (this._state);
    }


}


