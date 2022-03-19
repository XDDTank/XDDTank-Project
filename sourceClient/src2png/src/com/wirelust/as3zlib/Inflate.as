// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//com.wirelust.as3zlib.Inflate

package com.wirelust.as3zlib
{
    import flash.utils.ByteArray;

    public final class Inflate 
    {

        private static const MAX_WBITS:int = 15;
        private static const PRESET_DICT:int = 32;
        public static const Z_NO_FLUSH:int = 0;
        public static const Z_PARTIAL_FLUSH:int = 1;
        public static const Z_SYNC_FLUSH:int = 2;
        public static const Z_FULL_FLUSH:int = 3;
        public static const Z_FINISH:int = 4;
        private static const Z_DEFLATED:int = 8;
        private static const Z_OK:int = 0;
        private static const Z_STREAM_END:int = 1;
        private static const Z_NEED_DICT:int = 2;
        private static const Z_ERRNO:int = -1;
        private static const Z_STREAM_ERROR:int = -2;
        private static const Z_DATA_ERROR:int = -3;
        private static const Z_MEM_ERROR:int = -4;
        private static const Z_BUF_ERROR:int = -5;
        private static const Z_VERSION_ERROR:int = -6;
        public static const METHOD:int = 0;
        public static const FLAG:int = 1;
        public static const DICT4:int = 2;
        public static const DICT3:int = 3;
        public static const DICT2:int = 4;
        public static const DICT1:int = 5;
        public static const DICT0:int = 6;
        public static const BLOCKS:int = 7;
        public static const CHECK4:int = 8;
        public static const CHECK3:int = 9;
        public static const CHECK2:int = 10;
        public static const CHECK1:int = 11;
        public static const DONE:int = 12;
        public static const BAD:int = 13;
        private static var mark:Array = new Array(0, 0, 0xFF, 0xFF);

        public var mode:int;
        public var method:int;
        public var was:Array = new Array();
        public var need:Number;
        public var marker:int;
        public var nowrap:int;
        public var wbits:int;
        public var blocks:InfBlocks;


        public function inflateReset(_arg_1:ZStream):int
        {
            if (((_arg_1 == null) || (_arg_1.istate == null)))
            {
                return (Z_STREAM_ERROR);
            };
            _arg_1.total_in = (_arg_1.total_out = 0);
            _arg_1.msg = null;
            _arg_1.istate.mode = ((!(_arg_1.istate.nowrap == 0)) ? BLOCKS : METHOD);
            _arg_1.istate.blocks.reset(_arg_1, null);
            return (Z_OK);
        }

        public function inflateEnd(_arg_1:ZStream):int
        {
            if (this.blocks != null)
            {
                this.blocks.free(_arg_1);
            };
            this.blocks = null;
            return (Z_OK);
        }

        public function inflateInit(_arg_1:ZStream, _arg_2:int):int
        {
            _arg_1.msg = null;
            this.blocks = null;
            this.nowrap = 0;
            if (_arg_2 < 0)
            {
                _arg_2 = -(_arg_2);
                this.nowrap = 1;
            };
            if (((_arg_2 < 8) || (_arg_2 > 15)))
            {
                this.inflateEnd(_arg_1);
                return (Z_STREAM_ERROR);
            };
            this.wbits = _arg_2;
            _arg_1.istate.blocks = new InfBlocks(_arg_1, ((!(_arg_1.istate.nowrap == 0)) ? null : this), (1 << _arg_2));
            this.inflateReset(_arg_1);
            return (Z_OK);
        }

        public function inflate(_arg_1:ZStream, _arg_2:int):int
        {
            var _local_3:int;
            var _local_4:int;
            var _local_5:int;
            if ((((_arg_1 == null) || (_arg_1.istate == null)) || (_arg_1.next_in == null)))
            {
                return (Z_STREAM_ERROR);
            };
            _arg_2 = ((_arg_2 == Z_FINISH) ? Z_BUF_ERROR : Z_OK);
            _local_3 = Z_BUF_ERROR;
            while (true)
            {
                switch (_arg_1.istate.mode)
                {
                    case METHOD:
                        if (_arg_1.avail_in == 0)
                        {
                            return (_local_3);
                        };
                        _local_3 = _arg_2;
                        _arg_1.avail_in--;
                        _arg_1.total_in++;
                        if (((_arg_1.istate.method = _arg_1.next_in[_arg_1.next_in_index++]) & 0x0F) != Z_DEFLATED)
                        {
                            _arg_1.istate.mode = BAD;
                            _arg_1.msg = "unknown compression method";
                            _arg_1.istate.marker = 5;
                            break;
                        };
                        if (((_arg_1.istate.method >> 4) + 8) > _arg_1.istate.wbits)
                        {
                            _arg_1.istate.mode = BAD;
                            _arg_1.msg = "invalid window size";
                            _arg_1.istate.marker = 5;
                            break;
                        };
                        _arg_1.istate.mode = FLAG;
                    case FLAG:
                        if (_arg_1.avail_in == 0)
                        {
                            return (_local_3);
                        };
                        _local_3 = _arg_2;
                        _arg_1.avail_in--;
                        _arg_1.total_in++;
                        _local_4 = (_arg_1.next_in[_arg_1.next_in_index++] & 0xFF);
                        _local_5 = (((_arg_1.istate.method << 8) + _local_4) % 31);
                        if (_local_5 != 0)
                        {
                            _arg_1.istate.mode = BAD;
                            _arg_1.msg = "incorrect header check";
                            _arg_1.istate.marker = 5;
                            break;
                        };
                        if ((_local_4 & PRESET_DICT) == 0)
                        {
                            _arg_1.istate.mode = BLOCKS;
                            break;
                        };
                        _arg_1.istate.mode = DICT4;
                    case DICT4:
                        if (_arg_1.avail_in == 0)
                        {
                            return (_local_3);
                        };
                        _local_3 = _arg_2;
                        _arg_1.avail_in--;
                        _arg_1.total_in++;
                        _arg_1.istate.need = (((_arg_1.next_in[_arg_1.next_in_index++] & 0xFF) << 24) & 0xFF000000);
                        _arg_1.istate.mode = DICT3;
                    case DICT3:
                        if (_arg_1.avail_in == 0)
                        {
                            return (_local_3);
                        };
                        _local_3 = _arg_2;
                        _arg_1.avail_in--;
                        _arg_1.total_in++;
                        _arg_1.istate.need = (_arg_1.istate.need + (((_arg_1.next_in[_arg_1.next_in_index++] & 0xFF) << 16) & 0xFF0000));
                        _arg_1.istate.mode = DICT2;
                    case DICT2:
                        if (_arg_1.avail_in == 0)
                        {
                            return (_local_3);
                        };
                        _local_3 = _arg_2;
                        _arg_1.avail_in--;
                        _arg_1.total_in++;
                        _arg_1.istate.need = (_arg_1.istate.need + (((_arg_1.next_in[_arg_1.next_in_index++] & 0xFF) << 8) & 0xFF00));
                        _arg_1.istate.mode = DICT1;
                    case DICT1:
                        if (_arg_1.avail_in == 0)
                        {
                            return (_local_3);
                        };
                        _local_3 = _arg_2;
                        _arg_1.avail_in--;
                        _arg_1.total_in++;
                        _arg_1.istate.need = (_arg_1.istate.need + (_arg_1.next_in[_arg_1.next_in_index++] & 0xFF));
                        _arg_1.adler = _arg_1.istate.need;
                        _arg_1.istate.mode = DICT0;
                        return (Z_NEED_DICT);
                    case DICT0:
                        _arg_1.istate.mode = BAD;
                        _arg_1.msg = "need dictionary";
                        _arg_1.istate.marker = 0;
                        return (Z_STREAM_ERROR);
                    case BLOCKS:
                        _local_3 = _arg_1.istate.blocks.proc(_arg_1, _local_3);
                        if (_local_3 == Z_DATA_ERROR)
                        {
                            _arg_1.istate.mode = BAD;
                            _arg_1.istate.marker = 0;
                            break;
                        };
                        if (_local_3 == Z_OK)
                        {
                            _local_3 = _arg_2;
                        };
                        if (_local_3 != Z_STREAM_END)
                        {
                            return (_local_3);
                        };
                        _local_3 = _arg_2;
                        _arg_1.istate.blocks.reset(_arg_1, _arg_1.istate.was);
                        if (_arg_1.istate.nowrap != 0)
                        {
                            _arg_1.istate.mode = DONE;
                            break;
                        };
                        _arg_1.istate.mode = CHECK4;
                    case CHECK4:
                        if (_arg_1.avail_in == 0)
                        {
                            return (_local_3);
                        };
                        _local_3 = _arg_2;
                        _arg_1.avail_in--;
                        _arg_1.total_in++;
                        _arg_1.istate.need = (((_arg_1.next_in[_arg_1.next_in_index++] & 0xFF) << 24) & 0xFF000000);
                        _arg_1.istate.mode = CHECK3;
                    case CHECK3:
                        if (_arg_1.avail_in == 0)
                        {
                            return (_local_3);
                        };
                        _local_3 = _arg_2;
                        _arg_1.avail_in--;
                        _arg_1.total_in++;
                        _arg_1.istate.need = (_arg_1.istate.need + (((_arg_1.next_in[_arg_1.next_in_index++] & 0xFF) << 16) & 0xFF0000));
                        _arg_1.istate.mode = CHECK2;
                    case CHECK2:
                        if (_arg_1.avail_in == 0)
                        {
                            return (_local_3);
                        };
                        _local_3 = _arg_2;
                        _arg_1.avail_in--;
                        _arg_1.total_in++;
                        _arg_1.istate.need = (_arg_1.istate.need + (((_arg_1.next_in[_arg_1.next_in_index++] & 0xFF) << 8) & 0xFF00));
                        _arg_1.istate.mode = CHECK1;
                    case CHECK1:
                        if (_arg_1.avail_in == 0)
                        {
                            return (_local_3);
                        };
                        _local_3 = _arg_2;
                        _arg_1.avail_in--;
                        _arg_1.total_in++;
                        _arg_1.istate.need = (_arg_1.istate.need + (_arg_1.next_in[_arg_1.next_in_index++] & 0xFF));
                        if (int(_arg_1.istate.was[0]) != int(_arg_1.istate.need))
                        {
                            _arg_1.istate.mode = BAD;
                            _arg_1.msg = "incorrect data check";
                            _arg_1.istate.marker = 5;
                            break;
                        };
                        _arg_1.istate.mode = DONE;
                    case DONE:
                        return (Z_STREAM_END);
                    case BAD:
                        return (Z_DATA_ERROR);
                    default:
                        return (Z_STREAM_ERROR);
                };
            };
            return (Z_STREAM_ERROR);
        }

        public function inflateSetDictionary(_arg_1:ZStream, _arg_2:ByteArray, _arg_3:int):int
        {
            var _local_4:int;
            var _local_5:int = _arg_3;
            if ((((_arg_1 == null) || (_arg_1.istate == null)) || (!(_arg_1.istate.mode == DICT0))))
            {
                return (Z_STREAM_ERROR);
            };
            if (_arg_1._adler.adler32(1, _arg_2, 0, _arg_3) != _arg_1.adler)
            {
                return (Z_DATA_ERROR);
            };
            _arg_1.adler = _arg_1._adler.adler32(0, null, 0, 0);
            if (_local_5 >= (1 << _arg_1.istate.wbits))
            {
                _local_5 = ((1 << _arg_1.istate.wbits) - 1);
                _local_4 = (_arg_3 - _local_5);
            };
            _arg_1.istate.blocks.set_dictionary(_arg_2, _local_4, _local_5);
            _arg_1.istate.mode = BLOCKS;
            return (Z_OK);
        }

        public function inflateSync(_arg_1:ZStream):int
        {
            var _local_2:int;
            var _local_3:int;
            var _local_4:int;
            var _local_5:Number;
            var _local_6:Number;
            if (((_arg_1 == null) || (_arg_1.istate == null)))
            {
                return (Z_STREAM_ERROR);
            };
            if (_arg_1.istate.mode != BAD)
            {
                _arg_1.istate.mode = BAD;
                _arg_1.istate.marker = 0;
            };
            if ((_local_2 = _arg_1.avail_in) == 0)
            {
                return (Z_BUF_ERROR);
            };
            _local_3 = _arg_1.next_in_index;
            _local_4 = _arg_1.istate.marker;
            while (((!(_local_2 == 0)) && (_local_4 < 4)))
            {
                if (_arg_1.next_in[_local_3] == mark[_local_4])
                {
                    _local_4++;
                }
                else
                {
                    if (_arg_1.next_in[_local_3] != 0)
                    {
                        _local_4 = 0;
                    }
                    else
                    {
                        _local_4 = (4 - _local_4);
                    };
                };
                _local_3++;
                _local_2--;
            };
            _arg_1.total_in = (_arg_1.total_in + (_local_3 - _arg_1.next_in_index));
            _arg_1.next_in_index = _local_3;
            _arg_1.avail_in = _local_2;
            _arg_1.istate.marker = _local_4;
            if (_local_4 != 4)
            {
                return (Z_DATA_ERROR);
            };
            _local_5 = _arg_1.total_in;
            _local_6 = _arg_1.total_out;
            this.inflateReset(_arg_1);
            _arg_1.total_in = _local_5;
            _arg_1.total_out = _local_6;
            _arg_1.istate.mode = BLOCKS;
            return (Z_OK);
        }

        public function inflateSyncPoint(_arg_1:ZStream):int
        {
            if ((((_arg_1 == null) || (_arg_1.istate == null)) || (_arg_1.istate.blocks == null)))
            {
                return (Z_STREAM_ERROR);
            };
            return (_arg_1.istate.blocks.sync_point());
        }


    }
}//package com.wirelust.as3zlib

