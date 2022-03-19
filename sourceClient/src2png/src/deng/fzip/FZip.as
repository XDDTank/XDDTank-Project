// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//deng.fzip.FZip

package deng.fzip
{
    import flash.events.EventDispatcher;
    import flash.utils.Dictionary;
    import flash.net.URLStream;
    import flash.utils.ByteArray;
    import flash.utils.Endian;
    import flash.net.URLRequest;
    import flash.events.Event;
    import flash.utils.IDataOutput;
    import flash.utils.IDataInput;
    import flash.events.HTTPStatusEvent;
    import flash.events.IOErrorEvent;
    import flash.events.SecurityErrorEvent;
    import flash.events.ProgressEvent;
    import flash.utils.*;
    import flash.events.*;

    [Event(name="fileLoaded", type="deng.fzip.FZipEvent")]
    [Event(name="parseError", type="deng.fzip.FZipErrorEvent")]
    [Event(name="complete", type="flash.events.Event")]
    [Event(name="httpStatus", type="flash.events.HTTPStatusEvent")]
    [Event(name="ioError", type="flash.events.IOErrorEvent")]
    [Event(name="open", type="flash.events.Event")]
    [Event(name="progress", type="flash.events.ProgressEvent")]
    [Event(name="securityError", type="flash.events.SecurityErrorEvent")]
    public class FZip extends EventDispatcher 
    {

        internal static const SIG_CENTRAL_FILE_HEADER:uint = 33639248;
        internal static const SIG_SPANNING_MARKER:uint = 808471376;
        internal static const SIG_LOCAL_FILE_HEADER:uint = 67324752;
        internal static const SIG_DIGITAL_SIGNATURE:uint = 84233040;
        internal static const SIG_END_OF_CENTRAL_DIRECTORY:uint = 101010256;
        internal static const SIG_ZIP64_END_OF_CENTRAL_DIRECTORY:uint = 101075792;
        internal static const SIG_ZIP64_END_OF_CENTRAL_DIRECTORY_LOCATOR:uint = 117853008;
        internal static const SIG_DATA_DESCRIPTOR:uint = 134695760;
        internal static const SIG_ARCHIVE_EXTRA_DATA:uint = 134630224;
        internal static const SIG_SPANNING:uint = 134695760;

        protected var filesList:Array;
        protected var filesDict:Dictionary;
        protected var urlStream:URLStream;
        protected var charEncoding:String;
        protected var parseFunc:Function;
        protected var currentFile:FZipFile;
        protected var ddBuffer:ByteArray;
        protected var ddSignature:uint;
        protected var ddCompressedSize:uint;

        public function FZip(_arg_1:String="utf-8")
        {
            this.charEncoding = _arg_1;
            this.parseFunc = this.parseIdle;
        }

        public function get active():Boolean
        {
            return (!(this.parseFunc === this.parseIdle));
        }

        public function load(_arg_1:URLRequest):void
        {
            if (((!(this.urlStream)) && (this.parseFunc == this.parseIdle)))
            {
                this.urlStream = new URLStream();
                this.urlStream.endian = Endian.LITTLE_ENDIAN;
                this.addEventHandlers();
                this.filesList = [];
                this.filesDict = new Dictionary();
                this.parseFunc = this.parseSignature;
                this.urlStream.load(_arg_1);
            };
        }

        public function loadBytes(_arg_1:ByteArray):void
        {
            if (((!(this.urlStream)) && (this.parseFunc == this.parseIdle)))
            {
                this.filesList = [];
                this.filesDict = new Dictionary();
                _arg_1.position = 0;
                _arg_1.endian = Endian.LITTLE_ENDIAN;
                this.parseFunc = this.parseSignature;
                if (this.parse(_arg_1))
                {
                    this.parseFunc = this.parseIdle;
                    dispatchEvent(new Event(Event.COMPLETE));
                }
                else
                {
                    dispatchEvent(new FZipErrorEvent(FZipErrorEvent.PARSE_ERROR, "EOF"));
                };
            };
        }

        public function close():void
        {
            if (this.urlStream)
            {
                this.parseFunc = this.parseIdle;
                this.removeEventHandlers();
                this.urlStream.close();
                this.urlStream = null;
            };
        }

        public function serialize(_arg_1:IDataOutput, _arg_2:Boolean=false):void
        {
            var _local_3:String;
            var _local_4:ByteArray;
            var _local_5:uint;
            var _local_6:uint;
            var _local_7:int;
            var _local_8:FZipFile;
            if (((!(_arg_1 == null)) && (this.filesList.length > 0)))
            {
                _local_3 = _arg_1.endian;
                _local_4 = new ByteArray();
                _arg_1.endian = (_local_4.endian = Endian.LITTLE_ENDIAN);
                _local_5 = 0;
                _local_6 = 0;
                _local_7 = 0;
                while (_local_7 < this.filesList.length)
                {
                    _local_8 = (this.filesList[_local_7] as FZipFile);
                    if (_local_8 != null)
                    {
                        _local_8.serialize(_local_4, _arg_2, true, _local_5);
                        _local_5 = (_local_5 + _local_8.serialize(_arg_1, _arg_2));
                        _local_6++;
                    };
                    _local_7++;
                };
                if (_local_4.length > 0)
                {
                    _arg_1.writeBytes(_local_4);
                };
                _arg_1.writeUnsignedInt(SIG_END_OF_CENTRAL_DIRECTORY);
                _arg_1.writeShort(0);
                _arg_1.writeShort(0);
                _arg_1.writeShort(_local_6);
                _arg_1.writeShort(_local_6);
                _arg_1.writeUnsignedInt(_local_4.length);
                _arg_1.writeUnsignedInt(_local_5);
                _arg_1.writeShort(0);
                _arg_1.endian = _local_3;
            };
        }

        public function getFileCount():uint
        {
            return ((this.filesList) ? this.filesList.length : 0);
        }

        public function getFileAt(_arg_1:uint):FZipFile
        {
            return ((this.filesList) ? (this.filesList[_arg_1] as FZipFile) : null);
        }

        public function getFileByName(_arg_1:String):FZipFile
        {
            return ((this.filesDict[_arg_1]) ? (this.filesDict[_arg_1] as FZipFile) : null);
        }

        public function addFile(_arg_1:String, _arg_2:ByteArray=null, _arg_3:Boolean=true):FZipFile
        {
            return (this.addFileAt(((this.filesList) ? this.filesList.length : 0), _arg_1, _arg_2, _arg_3));
        }

        public function addFileFromString(_arg_1:String, _arg_2:String, _arg_3:String="utf-8", _arg_4:Boolean=true):FZipFile
        {
            return (this.addFileFromStringAt(((this.filesList) ? this.filesList.length : 0), _arg_1, _arg_2, _arg_3, _arg_4));
        }

        public function addFileAt(_arg_1:uint, _arg_2:String, _arg_3:ByteArray=null, _arg_4:Boolean=true):FZipFile
        {
            if (this.filesList == null)
            {
                this.filesList = [];
            };
            if (this.filesDict == null)
            {
                this.filesDict = new Dictionary();
            }
            else
            {
                if (this.filesDict[_arg_2])
                {
                    throw (new Error((("File already exists: " + _arg_2) + ". Please remove first.")));
                };
            };
            var _local_5:FZipFile = new FZipFile();
            _local_5.filename = _arg_2;
            _local_5.setContent(_arg_3, _arg_4);
            if (_arg_1 >= this.filesList.length)
            {
                this.filesList.push(_local_5);
            }
            else
            {
                this.filesList.splice(_arg_1, 0, _local_5);
            };
            this.filesDict[_arg_2] = _local_5;
            return (_local_5);
        }

        public function addFileFromStringAt(_arg_1:uint, _arg_2:String, _arg_3:String, _arg_4:String="utf-8", _arg_5:Boolean=true):FZipFile
        {
            if (this.filesList == null)
            {
                this.filesList = [];
            };
            if (this.filesDict == null)
            {
                this.filesDict = new Dictionary();
            }
            else
            {
                if (this.filesDict[_arg_2])
                {
                    throw (new Error((("File already exists: " + _arg_2) + ". Please remove first.")));
                };
            };
            var _local_6:FZipFile = new FZipFile();
            _local_6.filename = _arg_2;
            _local_6.setContentAsString(_arg_3, _arg_4, _arg_5);
            if (_arg_1 >= this.filesList.length)
            {
                this.filesList.push(_local_6);
            }
            else
            {
                this.filesList.splice(_arg_1, 0, _local_6);
            };
            this.filesDict[_arg_2] = _local_6;
            return (_local_6);
        }

        public function removeFileAt(_arg_1:uint):FZipFile
        {
            var _local_2:FZipFile;
            if ((((!(this.filesList == null)) && (!(this.filesDict == null))) && (_arg_1 < this.filesList.length)))
            {
                _local_2 = (this.filesList[_arg_1] as FZipFile);
                if (_local_2 != null)
                {
                    this.filesList.splice(_arg_1, 1);
                    delete this.filesDict[_local_2.filename];
                    return (_local_2);
                };
            };
            return (null);
        }

        protected function parse(_arg_1:IDataInput):Boolean
        {
            do 
            {
            } while (this.parseFunc(_arg_1));
            return (this.parseFunc === this.parseIdle);
        }

        protected function parseIdle(_arg_1:IDataInput):Boolean
        {
            return (false);
        }

        protected function parseSignature(_arg_1:IDataInput):Boolean
        {
            var _local_2:uint;
            if (_arg_1.bytesAvailable >= 4)
            {
                _local_2 = _arg_1.readUnsignedInt();
                switch (_local_2)
                {
                    case SIG_LOCAL_FILE_HEADER:
                        this.parseFunc = this.parseLocalfile;
                        this.currentFile = new FZipFile(this.charEncoding);
                        break;
                    case SIG_CENTRAL_FILE_HEADER:
                    case SIG_END_OF_CENTRAL_DIRECTORY:
                    case SIG_SPANNING_MARKER:
                    case SIG_DIGITAL_SIGNATURE:
                    case SIG_ZIP64_END_OF_CENTRAL_DIRECTORY:
                    case SIG_ZIP64_END_OF_CENTRAL_DIRECTORY_LOCATOR:
                    case SIG_DATA_DESCRIPTOR:
                    case SIG_ARCHIVE_EXTRA_DATA:
                    case SIG_SPANNING:
                        this.parseFunc = this.parseIdle;
                        break;
                    default:
                        throw (new Error("Unknown record signature."));
                };
                return (true);
            };
            return (false);
        }

        protected function parseLocalfile(_arg_1:IDataInput):Boolean
        {
            if (this.currentFile.parse(_arg_1))
            {
                if (this.currentFile.hasDataDescriptor)
                {
                    this.parseFunc = this.findDataDescriptor;
                    this.ddBuffer = new ByteArray();
                    this.ddSignature = 0;
                    this.ddCompressedSize = 0;
                    return (true);
                };
                this.onFileLoaded();
                if (this.parseFunc != this.parseIdle)
                {
                    this.parseFunc = this.parseSignature;
                    return (true);
                };
            };
            return (false);
        }

        protected function findDataDescriptor(_arg_1:IDataInput):Boolean
        {
            var _local_2:uint;
            while (_arg_1.bytesAvailable > 0)
            {
                _local_2 = _arg_1.readUnsignedByte();
                this.ddSignature = ((this.ddSignature >>> 8) | (_local_2 << 24));
                if (this.ddSignature == SIG_DATA_DESCRIPTOR)
                {
                    this.ddBuffer.length = (this.ddBuffer.length - 3);
                    this.parseFunc = this.validateDataDescriptor;
                    return (true);
                };
                this.ddBuffer.writeByte(_local_2);
            };
            return (false);
        }

        protected function validateDataDescriptor(_arg_1:IDataInput):Boolean
        {
            var _local_2:uint;
            var _local_3:uint;
            var _local_4:uint;
            if (_arg_1.bytesAvailable >= 12)
            {
                _local_2 = _arg_1.readUnsignedInt();
                _local_3 = _arg_1.readUnsignedInt();
                _local_4 = _arg_1.readUnsignedInt();
                if (this.ddBuffer.length == _local_3)
                {
                    this.ddBuffer.position = 0;
                    this.currentFile._crc32 = _local_2;
                    this.currentFile._sizeCompressed = _local_3;
                    this.currentFile._sizeUncompressed = _local_4;
                    this.currentFile.parseContent(this.ddBuffer);
                    this.onFileLoaded();
                    this.parseFunc = this.parseSignature;
                }
                else
                {
                    this.ddBuffer.writeUnsignedInt(_local_2);
                    this.ddBuffer.writeUnsignedInt(_local_3);
                    this.ddBuffer.writeUnsignedInt(_local_4);
                    this.parseFunc = this.findDataDescriptor;
                };
                return (true);
            };
            return (false);
        }

        protected function onFileLoaded():void
        {
            this.filesList.push(this.currentFile);
            if (this.currentFile.filename)
            {
                this.filesDict[this.currentFile.filename] = this.currentFile;
            };
            dispatchEvent(new FZipEvent(FZipEvent.FILE_LOADED, this.currentFile));
            this.currentFile = null;
        }

        protected function progressHandler(evt:Event):void
        {
            dispatchEvent(evt.clone());
            try
            {
                if (this.parse(this.urlStream))
                {
                    this.close();
                    dispatchEvent(new Event(Event.COMPLETE));
                };
            }
            catch(e:Error)
            {
                close();
                if (hasEventListener(FZipErrorEvent.PARSE_ERROR))
                {
                    dispatchEvent(new FZipErrorEvent(FZipErrorEvent.PARSE_ERROR, e.message));
                }
                else
                {
                    throw (e);
                };
            };
        }

        protected function defaultHandler(_arg_1:Event):void
        {
            dispatchEvent(_arg_1.clone());
        }

        protected function defaultErrorHandler(_arg_1:Event):void
        {
            this.close();
            dispatchEvent(_arg_1.clone());
        }

        protected function addEventHandlers():void
        {
            this.urlStream.addEventListener(Event.COMPLETE, this.defaultHandler);
            this.urlStream.addEventListener(Event.OPEN, this.defaultHandler);
            this.urlStream.addEventListener(HTTPStatusEvent.HTTP_STATUS, this.defaultHandler);
            this.urlStream.addEventListener(IOErrorEvent.IO_ERROR, this.defaultErrorHandler);
            this.urlStream.addEventListener(SecurityErrorEvent.SECURITY_ERROR, this.defaultErrorHandler);
            this.urlStream.addEventListener(ProgressEvent.PROGRESS, this.progressHandler);
        }

        protected function removeEventHandlers():void
        {
            this.urlStream.removeEventListener(Event.COMPLETE, this.defaultHandler);
            this.urlStream.removeEventListener(Event.OPEN, this.defaultHandler);
            this.urlStream.removeEventListener(HTTPStatusEvent.HTTP_STATUS, this.defaultHandler);
            this.urlStream.removeEventListener(IOErrorEvent.IO_ERROR, this.defaultErrorHandler);
            this.urlStream.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, this.defaultErrorHandler);
            this.urlStream.removeEventListener(ProgressEvent.PROGRESS, this.progressHandler);
        }


    }
}//package deng.fzip

