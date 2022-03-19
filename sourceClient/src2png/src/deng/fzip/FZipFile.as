// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//deng.fzip.FZipFile

package deng.fzip
{
    import flash.utils.describeType;
    import flash.utils.ByteArray;
    import flash.utils.Dictionary;
    import flash.utils.Endian;
    import deng.utils.ChecksumUtil;
    import flash.utils.IDataOutput;
    import flash.utils.IDataInput;
    import com.wirelust.as3zlib.ZStream;
    import com.wirelust.as3zlib.JZlib;
    import flash.utils.*;

    public class FZipFile 
    {

        public static const COMPRESSION_NONE:int = 0;
        public static const COMPRESSION_SHRUNK:int = 1;
        public static const COMPRESSION_REDUCED_1:int = 2;
        public static const COMPRESSION_REDUCED_2:int = 3;
        public static const COMPRESSION_REDUCED_3:int = 4;
        public static const COMPRESSION_REDUCED_4:int = 5;
        public static const COMPRESSION_IMPLODED:int = 6;
        public static const COMPRESSION_TOKENIZED:int = 7;
        public static const COMPRESSION_DEFLATED:int = 8;
        public static const COMPRESSION_DEFLATED_EXT:int = 9;
        public static const COMPRESSION_IMPLODED_PKWARE:int = 10;
        protected static var HAS_INFLATE:Boolean = describeType(ByteArray).factory.method.(@name == "uncompress").hasComplexContent();

        protected var _versionHost:int = 0;
        protected var _versionNumber:String = "2.0";
        protected var _compressionMethod:int = 8;
        protected var _encrypted:Boolean = false;
        protected var _implodeDictSize:int = -1;
        protected var _implodeShannonFanoTrees:int = -1;
        protected var _deflateSpeedOption:int = -1;
        protected var _hasDataDescriptor:Boolean = false;
        protected var _hasCompressedPatchedData:Boolean = false;
        protected var _date:Date;
        protected var _adler32:uint;
        protected var _hasAdler32:Boolean = false;
        protected var _sizeFilename:uint = 0;
        protected var _sizeExtra:uint = 0;
        protected var _filename:String = "";
        protected var _filenameEncoding:String;
        protected var _extraFields:Dictionary;
        protected var _comment:String = "";
        protected var _content:ByteArray;
        internal var _crc32:uint;
        internal var _sizeCompressed:uint = 0;
        internal var _sizeUncompressed:uint = 0;
        protected var isCompressed:Boolean = false;
        protected var parseFunc:Function = parseFileHead;

        public function FZipFile(_arg_1:String="utf-8")
        {
            this._filenameEncoding = _arg_1;
            this._extraFields = new Dictionary();
            this._content = new ByteArray();
            this._content.endian = Endian.BIG_ENDIAN;
        }

        public function get date():Date
        {
            return (this._date);
        }

        public function set date(_arg_1:Date):void
        {
            this._date = ((_arg_1 != null) ? _arg_1 : new Date());
        }

        public function get filename():String
        {
            return (this._filename);
        }

        public function set filename(_arg_1:String):void
        {
            this._filename = _arg_1;
        }

        internal function get hasDataDescriptor():Boolean
        {
            return (this._hasDataDescriptor);
        }

        public function get content():ByteArray
        {
            if (this.isCompressed)
            {
                this.uncompress();
            };
            return (this._content);
        }

        public function set content(_arg_1:ByteArray):void
        {
            this.setContent(_arg_1);
        }

        public function setContent(_arg_1:ByteArray, _arg_2:Boolean=true):void
        {
            if (((!(_arg_1 == null)) && (_arg_1.length > 0)))
            {
                _arg_1.position = 0;
                _arg_1.readBytes(this._content, 0, _arg_1.length);
                this._crc32 = ChecksumUtil.CRC32(this._content);
                this._hasAdler32 = false;
            }
            else
            {
                this._content.length = 0;
                this._content.position = 0;
                this.isCompressed = false;
            };
            if (_arg_2)
            {
                this.compress();
            }
            else
            {
                this._sizeUncompressed = (this._sizeCompressed = this._content.length);
            };
        }

        public function get versionNumber():String
        {
            return (this._versionNumber);
        }

        public function get sizeCompressed():uint
        {
            return (this._sizeCompressed);
        }

        public function get sizeUncompressed():uint
        {
            return (this._sizeUncompressed);
        }

        public function getContentAsString(_arg_1:Boolean=true, _arg_2:String="utf-8"):String
        {
            var _local_3:String;
            if (this.isCompressed)
            {
                this.uncompress();
            };
            this._content.position = 0;
            if (_arg_2 == "utf-8")
            {
                _local_3 = this._content.readUTFBytes(this._content.bytesAvailable);
            }
            else
            {
                _local_3 = this._content.readMultiByte(this._content.bytesAvailable, _arg_2);
            };
            this._content.position = 0;
            if (_arg_1)
            {
                this.compress();
            };
            return (_local_3);
        }

        public function setContentAsString(_arg_1:String, _arg_2:String="utf-8", _arg_3:Boolean=true):void
        {
            this._content.length = 0;
            this._content.position = 0;
            this.isCompressed = false;
            if (((!(_arg_1 == null)) && (_arg_1.length > 0)))
            {
                if (_arg_2 == "utf-8")
                {
                    this._content.writeUTFBytes(_arg_1);
                }
                else
                {
                    this._content.writeMultiByte(_arg_1, _arg_2);
                };
                this._crc32 = ChecksumUtil.CRC32(this._content);
                this._hasAdler32 = false;
            };
            if (_arg_3)
            {
                this.compress();
            }
            else
            {
                this._sizeUncompressed = (this._sizeCompressed = this._content.length);
            };
        }

        public function serialize(_arg_1:IDataOutput, _arg_2:Boolean, _arg_3:Boolean=false, _arg_4:uint=0):uint
        {
            var _local_10:Object;
            var _local_15:ByteArray;
            var _local_16:Boolean;
            if (_arg_1 == null)
            {
                return (0);
            };
            if (_arg_3)
            {
                _arg_1.writeUnsignedInt(FZip.SIG_CENTRAL_FILE_HEADER);
                _arg_1.writeShort(((this._versionHost << 8) | 0x14));
            }
            else
            {
                _arg_1.writeUnsignedInt(FZip.SIG_LOCAL_FILE_HEADER);
            };
            _arg_1.writeShort(((this._versionHost << 8) | 0x14));
            _arg_1.writeShort(((this._filenameEncoding == "utf-8") ? 0x0800 : 0));
            _arg_1.writeShort(((this.isCompressed) ? COMPRESSION_DEFLATED : COMPRESSION_NONE));
            var _local_5:Date = ((this._date != null) ? this._date : new Date());
            var _local_6:uint = ((uint(_local_5.getSeconds()) | (uint(_local_5.getMinutes()) << 5)) | (uint(_local_5.getHours()) << 11));
            var _local_7:uint = ((uint(_local_5.getDate()) | (uint((_local_5.getMonth() + 1)) << 5)) | (uint((_local_5.getFullYear() - 1980)) << 9));
            _arg_1.writeShort(_local_6);
            _arg_1.writeShort(_local_7);
            _arg_1.writeUnsignedInt(this._crc32);
            _arg_1.writeUnsignedInt(this._sizeCompressed);
            _arg_1.writeUnsignedInt(this._sizeUncompressed);
            var _local_8:ByteArray = new ByteArray();
            _local_8.endian = Endian.LITTLE_ENDIAN;
            if (this._filenameEncoding == "utf-8")
            {
                _local_8.writeUTFBytes(this._filename);
            }
            else
            {
                _local_8.writeMultiByte(this._filename, this._filenameEncoding);
            };
            var _local_9:uint = _local_8.position;
            for (_local_10 in this._extraFields)
            {
                _local_15 = (this._extraFields[_local_10] as ByteArray);
                if (_local_15 != null)
                {
                    _local_8.writeShort(uint(_local_10));
                    _local_8.writeShort(uint(_local_15.length));
                    _local_8.writeBytes(_local_15);
                };
            };
            if (_arg_2)
            {
                if ((!(this._hasAdler32)))
                {
                    _local_16 = this.isCompressed;
                    if (_local_16)
                    {
                        this.uncompress();
                    };
                    this._adler32 = ChecksumUtil.Adler32(this._content, 0, this._content.length);
                    this._hasAdler32 = true;
                    if (_local_16)
                    {
                        this.compress();
                    };
                };
                _local_8.writeShort(0xDADA);
                _local_8.writeShort(4);
                _local_8.writeUnsignedInt(this._adler32);
            };
            var _local_11:uint = (_local_8.position - _local_9);
            if (((_arg_3) && (this._comment.length > 0)))
            {
                if (this._filenameEncoding == "utf-8")
                {
                    _local_8.writeUTFBytes(this._comment);
                }
                else
                {
                    _local_8.writeMultiByte(this._comment, this._filenameEncoding);
                };
            };
            var _local_12:uint = ((_local_8.position - _local_9) - _local_11);
            _arg_1.writeShort(_local_9);
            _arg_1.writeShort(_local_11);
            if (_arg_3)
            {
                _arg_1.writeShort(_local_12);
                _arg_1.writeShort(0);
                _arg_1.writeShort(0);
                _arg_1.writeUnsignedInt(0);
                _arg_1.writeUnsignedInt(_arg_4);
            };
            if (((_local_9 + _local_11) + _local_12) > 0)
            {
                _arg_1.writeBytes(_local_8);
            };
            var _local_13:uint;
            if (((!(_arg_3)) && (this._content.length > 0)))
            {
                if (this.isCompressed)
                {
                    if (HAS_INFLATE)
                    {
                        _local_13 = this._content.length;
                        _arg_1.writeBytes(this._content, 0, _local_13);
                    }
                    else
                    {
                        _local_13 = (this._content.length - 6);
                        _arg_1.writeBytes(this._content, 2, _local_13);
                    };
                }
                else
                {
                    _local_13 = this._content.length;
                    _arg_1.writeBytes(this._content, 0, _local_13);
                };
            };
            var _local_14:uint = ((((30 + _local_9) + _local_11) + _local_12) + _local_13);
            if (_arg_3)
            {
                _local_14 = (_local_14 + 16);
            };
            return (_local_14);
        }

        internal function parse(_arg_1:IDataInput):Boolean
        {
            do 
            {
            } while (((_arg_1.bytesAvailable) && (this.parseFunc(_arg_1))));
            return (this.parseFunc === this.parseFileIdle);
        }

        protected function parseFileIdle(_arg_1:IDataInput):Boolean
        {
            return (false);
        }

        protected function parseFileHead(_arg_1:IDataInput):Boolean
        {
            if (_arg_1.bytesAvailable >= 30)
            {
                this.parseHead(_arg_1);
                if ((this._sizeFilename + this._sizeExtra) > 0)
                {
                    this.parseFunc = this.parseFileHeadExt;
                }
                else
                {
                    this.parseFunc = this.parseFileContent;
                };
                return (true);
            };
            return (false);
        }

        protected function parseFileHeadExt(_arg_1:IDataInput):Boolean
        {
            if (_arg_1.bytesAvailable >= (this._sizeFilename + this._sizeExtra))
            {
                this.parseHeadExt(_arg_1);
                this.parseFunc = this.parseFileContent;
                return (true);
            };
            return (false);
        }

        protected function parseFileContent(_arg_1:IDataInput):Boolean
        {
            var _local_2:Boolean = true;
            if (this._hasDataDescriptor)
            {
                this.parseFunc = this.parseFileIdle;
                _local_2 = false;
            }
            else
            {
                if (this._sizeCompressed == 0)
                {
                    this.parseFunc = this.parseFileIdle;
                }
                else
                {
                    if (_arg_1.bytesAvailable >= this._sizeCompressed)
                    {
                        this.parseContent(_arg_1);
                        this.parseFunc = this.parseFileIdle;
                    }
                    else
                    {
                        _local_2 = false;
                    };
                };
            };
            return (_local_2);
        }

        protected function parseHead(_arg_1:IDataInput):void
        {
            var _local_2:uint = _arg_1.readUnsignedShort();
            this._versionHost = (_local_2 >> 8);
            this._versionNumber = ((Math.floor(((_local_2 & 0xFF) / 10)) + ".") + ((_local_2 & 0xFF) % 10));
            var _local_3:uint = _arg_1.readUnsignedShort();
            this._compressionMethod = _arg_1.readUnsignedShort();
            this._encrypted = (!((_local_3 & 0x01) === 0));
            this._hasDataDescriptor = (!((_local_3 & 0x08) === 0));
            this._hasCompressedPatchedData = (!((_local_3 & 0x20) === 0));
            if ((_local_3 & 0x0320) !== 0)
            {
                this._filenameEncoding = "utf-8";
            };
            if (this._compressionMethod === COMPRESSION_IMPLODED)
            {
                this._implodeDictSize = ((!((_local_3 & 0x02) === 0)) ? 0x2000 : 0x1000);
                this._implodeShannonFanoTrees = ((!((_local_3 & 0x04) === 0)) ? 3 : 2);
            }
            else
            {
                if (this._compressionMethod === COMPRESSION_DEFLATED)
                {
                    this._deflateSpeedOption = ((_local_3 & 0x06) >> 1);
                };
            };
            var _local_4:uint = _arg_1.readUnsignedShort();
            var _local_5:uint = _arg_1.readUnsignedShort();
            var _local_6:int = (_local_4 & 0x1F);
            var _local_7:int = ((_local_4 & 0x07E0) >> 5);
            var _local_8:int = ((_local_4 & 0xF800) >> 11);
            var _local_9:int = (_local_5 & 0x1F);
            var _local_10:int = ((_local_5 & 0x01E0) >> 5);
            var _local_11:int = (((_local_5 & 0xFE00) >> 9) + 1980);
            this._date = new Date(_local_11, (_local_10 - 1), _local_9, _local_8, _local_7, _local_6, 0);
            this._crc32 = _arg_1.readUnsignedInt();
            this._sizeCompressed = _arg_1.readUnsignedInt();
            this._sizeUncompressed = _arg_1.readUnsignedInt();
            this._sizeFilename = _arg_1.readUnsignedShort();
            this._sizeExtra = _arg_1.readUnsignedShort();
        }

        protected function parseHeadExt(_arg_1:IDataInput):void
        {
            var _local_3:uint;
            var _local_4:uint;
            var _local_5:ByteArray;
            if (this._filenameEncoding == "utf-8")
            {
                this._filename = _arg_1.readUTFBytes(this._sizeFilename);
            }
            else
            {
                this._filename = _arg_1.readMultiByte(this._sizeFilename, this._filenameEncoding);
            };
            var _local_2:uint = this._sizeExtra;
            while (_local_2 > 4)
            {
                _local_3 = _arg_1.readUnsignedShort();
                _local_4 = _arg_1.readUnsignedShort();
                if (_local_4 > _local_2)
                {
                    throw (new Error((("Parse error in file " + this._filename) + ": Extra field data size too big.")));
                };
                if (((_local_3 === 0xDADA) && (_local_4 === 4)))
                {
                    this._adler32 = _arg_1.readUnsignedInt();
                    this._hasAdler32 = true;
                }
                else
                {
                    if (_local_4 > 0)
                    {
                        _local_5 = new ByteArray();
                        _arg_1.readBytes(_local_5, 0, _local_4);
                        this._extraFields[_local_3] = _local_5;
                    };
                };
                _local_2 = (_local_2 - (_local_4 + 4));
            };
            if (_local_2 > 0)
            {
                _arg_1.readBytes(new ByteArray(), 0, _local_2);
            };
        }

        internal function parseContent(_arg_1:IDataInput):void
        {
            var _local_2:uint;
            if (((this._compressionMethod === COMPRESSION_DEFLATED) && (!(this._encrypted))))
            {
                if (HAS_INFLATE)
                {
                    _arg_1.readBytes(this._content, 0, this._sizeCompressed);
                }
                else
                {
                    if (this._hasAdler32)
                    {
                        this._content.writeByte(120);
                        _local_2 = (((~(this._deflateSpeedOption)) << 6) & 0xC0);
                        _local_2 = (_local_2 + (31 - (((120 << 8) | _local_2) % 31)));
                        this._content.writeByte(_local_2);
                        _arg_1.readBytes(this._content, 2, this._sizeCompressed);
                        this._content.position = this._content.length;
                        this._content.writeUnsignedInt(this._adler32);
                    }
                    else
                    {
                        _arg_1.readBytes(this._content, 0, this._sizeCompressed);
                    };
                };
                this.isCompressed = true;
            }
            else
            {
                if (this._compressionMethod == COMPRESSION_NONE)
                {
                    _arg_1.readBytes(this._content, 0, this._sizeCompressed);
                    this.isCompressed = false;
                }
                else
                {
                    throw (new Error((("Compression method " + this._compressionMethod) + " is not supported.")));
                };
            };
            this._content.position = 0;
        }

        protected function compress():void
        {
            if ((!(this.isCompressed)))
            {
                if (this._content.length > 0)
                {
                    this._content.position = 0;
                    this._sizeUncompressed = this._content.length;
                    if (HAS_INFLATE)
                    {
                        this._content.compress.apply(this._content, ["deflate"]);
                        this._sizeCompressed = this._content.length;
                    }
                    else
                    {
                        this._content.compress();
                        this._sizeCompressed = (this._content.length - 6);
                    };
                    this._content.position = 0;
                    this.isCompressed = true;
                }
                else
                {
                    this._sizeCompressed = 0;
                    this._sizeUncompressed = 0;
                };
            };
        }

        protected function uncompress():void
        {
            var _local_1:ByteArray;
            var _local_2:ZStream;
            var _local_3:int;
            var _local_4:int;
            if (((this.isCompressed) && (this._content.length > 0)))
            {
                this._content.position = 0;
                if (HAS_INFLATE)
                {
                    this._content.uncompress.apply(this._content, ["deflate"]);
                }
                else
                {
                    if (this._hasAdler32)
                    {
                        this._content.uncompress();
                    }
                    else
                    {
                        _local_1 = new ByteArray();
                        _local_2 = new ZStream();
                        _local_2.next_in = this._content;
                        _local_2.next_in_index = 0;
                        _local_2.next_out = _local_1;
                        _local_2.next_out_index = 0;
                        _local_3 = _local_2.inflateInitWithNoWrap(true);
                        _local_4 = 0;
                        while (((_local_2.total_in <= this._content.length) && (_local_4 <= (this._content.length * 4))))
                        {
                            _local_2.avail_in = (_local_2.avail_out = 10);
                            _local_3 = _local_2.inflate(JZlib.Z_NO_FLUSH);
                            if (_local_3 == JZlib.Z_STREAM_END) break;
                            if (_local_3 == JZlib.Z_STREAM_ERROR) break;
                            if (_local_3 == JZlib.Z_DATA_ERROR) break;
                            _local_4++;
                        };
                        _local_3 = _local_2.inflateEnd();
                        this._content = _local_1;
                    };
                };
                this._content.position = 0;
                this.isCompressed = false;
            };
        }

        public function toString():String
        {
            return (((((((((((((((((((((((((("[FZipFile]" + "\n  name:") + this._filename) + "\n  date:") + this._date) + "\n  sizeCompressed:") + this._sizeCompressed) + "\n  sizeUncompressed:") + this._sizeUncompressed) + "\n  versionHost:") + this._versionHost) + "\n  versionNumber:") + this._versionNumber) + "\n  compressionMethod:") + this._compressionMethod) + "\n  encrypted:") + this._encrypted) + "\n  hasDataDescriptor:") + this._hasDataDescriptor) + "\n  hasCompressedPatchedData:") + this._hasCompressedPatchedData) + "\n  filenameEncoding:") + this._filenameEncoding) + "\n  crc32:") + this._crc32.toString(16)) + "\n  adler32:") + this._adler32.toString(16));
        }


    }
}//package deng.fzip

