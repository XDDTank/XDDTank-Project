// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//com.wirelust.as3zlib.InfBlocks

package com.wirelust.as3zlib
{
    import flash.utils.ByteArray;
    import com.wirelust.util.Cast;

    public final class InfBlocks 
    {

        private static const MANY:int = 1440;
        private static const inflate_mask:Array = new Array(0, 1, 3, 7, 15, 31, 63, 127, 0xFF, 511, 1023, 2047, 4095, 8191, 16383, 32767, 0xFFFF);
        public static const border:Array = new Array(16, 17, 18, 0, 8, 7, 9, 6, 10, 5, 11, 4, 12, 3, 13, 2, 14, 1, 15);
        private static const Z_OK:int = 0;
        private static const Z_STREAM_END:int = 1;
        private static const Z_NEED_DICT:int = 2;
        private static const Z_ERRNO:int = -1;
        private static const Z_STREAM_ERROR:int = -2;
        private static const Z_DATA_ERROR:int = -3;
        private static const Z_MEM_ERROR:int = -4;
        private static const Z_BUF_ERROR:int = -5;
        private static const Z_VERSION_ERROR:int = -6;
        private static const TYPE:int = 0;
        private static const LENS:int = 1;
        private static const STORED:int = 2;
        private static const TABLE:int = 3;
        private static const BTREE:int = 4;
        private static const DTREE:int = 5;
        private static const CODES:int = 6;
        private static const DRY:int = 7;
        private static const DONE:int = 8;
        private static const BAD:int = 9;

        public var mode:int;
        public var left:int;
        public var table:int;
        public var index:int;
        public var blens:Array;
        public var bb:Array = new Array();
        public var tb:Array = new Array();
        public var codes:InfCodes = new InfCodes();
        public var last:int;
        public var bitk:int;
        public var bitb:int;
        public var hufts:Array;
        public var window:ByteArray;
        public var end:int;
        public var read:int;
        public var write:int;
        public var checkfn:Object;
        public var check:Number;
        public var inftree:InfTree = new InfTree();

        public function InfBlocks(_arg_1:ZStream, _arg_2:Object, _arg_3:int)
        {
            this.hufts = new Array();
            this.window = new ByteArray();
            this.end = _arg_3;
            this.checkfn = _arg_2;
            this.mode = TYPE;
            this.reset(_arg_1, null);
        }

        public function reset(_arg_1:ZStream, _arg_2:Array):void
        {
            if (_arg_2 != null)
            {
                _arg_2[0] = this.check;
            };
            if (((this.mode == BTREE) || (this.mode == DTREE)))
            {
            };
            if (this.mode == CODES)
            {
                this.codes.free(_arg_1);
            };
            this.mode = TYPE;
            this.bitk = 0;
            this.bitb = 0;
            this.read = (this.write = 0);
            if (this.checkfn != null)
            {
                _arg_1.adler = (this.check = _arg_1._adler.adler32(0, null, 0, 0));
            };
        }

        public function proc(_arg_1:ZStream, _arg_2:int):int
        {
            var _local_3:int;
            var _local_4:int;
            var _local_5:int;
            var _local_6:int;
            var _local_7:int;
            var _local_8:int;
            var _local_9:int;
            var _local_10:Array;
            var _local_11:Array;
            var _local_12:Array;
            var _local_13:Array;
            var _local_14:Array;
            var _local_15:int;
            var _local_16:int;
            var _local_17:int;
            var _local_18:int;
            _local_6 = _arg_1.next_in_index;
            _local_7 = _arg_1.avail_in;
            _local_4 = this.bitb;
            _local_5 = this.bitk;
            _local_8 = this.write;
            _local_9 = int(((_local_8 < this.read) ? ((this.read - _local_8) - 1) : (this.end - _local_8)));
            while (true)
            {
                switch (this.mode)
                {
                    case TYPE:
                        while (_local_5 < 3)
                        {
                            if (_local_7 != 0)
                            {
                                _arg_2 = Z_OK;
                            }
                            else
                            {
                                this.bitb = _local_4;
                                this.bitk = _local_5;
                                _arg_1.avail_in = _local_7;
                                _arg_1.total_in = (_arg_1.total_in + (_local_6 - _arg_1.next_in_index));
                                _arg_1.next_in_index = _local_6;
                                this.write = _local_8;
                                return (this.inflate_flush(_arg_1, _arg_2));
                            };
                            _local_7--;
                            _arg_1.next_in.position = _local_6++;
                            _local_18 = Cast.toByte(_arg_1.next_in.readByte());
                            _local_4 = (_local_4 | ((_local_18 & 0xFF) << _local_5));
                            _local_5 = (_local_5 + 8);
                        };
                        _local_3 = int((_local_4 & 0x07));
                        this.last = (_local_3 & 0x01);
                        switch ((_local_3 >>> 1))
                        {
                            case 0:
                                _local_4 = (_local_4 >>> 3);
                                _local_5 = (_local_5 - 3);
                                _local_3 = (_local_5 & 0x07);
                                _local_4 = (_local_4 >>> _local_3);
                                _local_5 = (_local_5 - _local_3);
                                this.mode = LENS;
                                break;
                            case 1:
                                _local_10 = new Array(1);
                                _local_11 = new Array(1);
                                _local_12 = new Array();
                                _local_12[0] = new Array();
                                _local_13 = new Array();
                                _local_13[0] = new Array();
                                InfTree.inflate_trees_fixed(_local_10, _local_11, _local_12, _local_13, _arg_1);
                                this.codes.init(_local_10[0], _local_11[0], _local_12[0], 0, _local_13[0], 0, _arg_1);
                                _local_4 = (_local_4 >>> 3);
                                _local_5 = (_local_5 - 3);
                                this.mode = CODES;
                                break;
                            case 2:
                                _local_4 = (_local_4 >>> 3);
                                _local_5 = (_local_5 - 3);
                                this.mode = TABLE;
                                break;
                            case 3:
                                _local_4 = (_local_4 >>> 3);
                                _local_5 = (_local_5 - 3);
                                this.mode = BAD;
                                _arg_1.msg = "invalid block type";
                                _arg_2 = Z_DATA_ERROR;
                                this.bitb = _local_4;
                                this.bitk = _local_5;
                                _arg_1.avail_in = _local_7;
                                _arg_1.total_in = (_arg_1.total_in + (_local_6 - _arg_1.next_in_index));
                                _arg_1.next_in_index = _local_6;
                                this.write = _local_8;
                                return (this.inflate_flush(_arg_1, _arg_2));
                        };
                        break;
                    case LENS:
                        while (_local_5 < 32)
                        {
                            if (_local_7 != 0)
                            {
                                _arg_2 = Z_OK;
                            }
                            else
                            {
                                this.bitb = _local_4;
                                this.bitk = _local_5;
                                _arg_1.avail_in = _local_7;
                                _arg_1.total_in = (_arg_1.total_in + (_local_6 - _arg_1.next_in_index));
                                _arg_1.next_in_index = _local_6;
                                this.write = _local_8;
                                return (this.inflate_flush(_arg_1, _arg_2));
                            };
                            _local_7--;
                            _local_4 = (_local_4 | ((_arg_1.next_in[_local_6++] & 0xFF) << _local_5));
                            _local_5 = (_local_5 + 8);
                        };
                        if ((((~(_local_4)) >>> 16) & 0xFFFF) != (_local_4 & 0xFFFF))
                        {
                            this.mode = BAD;
                            _arg_1.msg = "invalid stored block lengths";
                            _arg_2 = Z_DATA_ERROR;
                            this.bitb = _local_4;
                            this.bitk = _local_5;
                            _arg_1.avail_in = _local_7;
                            _arg_1.total_in = (_arg_1.total_in + (_local_6 - _arg_1.next_in_index));
                            _arg_1.next_in_index = _local_6;
                            this.write = _local_8;
                            return (this.inflate_flush(_arg_1, _arg_2));
                        };
                        this.left = (_local_4 & 0xFFFF);
                        _local_4 = (_local_5 = 0);
                        this.mode = ((!(this.left == 0)) ? STORED : ((!(this.last == 0)) ? DRY : TYPE));
                        break;
                    case STORED:
                        if (_local_7 == 0)
                        {
                            this.bitb = _local_4;
                            this.bitk = _local_5;
                            _arg_1.avail_in = _local_7;
                            _arg_1.total_in = (_arg_1.total_in + (_local_6 - _arg_1.next_in_index));
                            _arg_1.next_in_index = _local_6;
                            this.write = _local_8;
                            return (this.inflate_flush(_arg_1, _arg_2));
                        };
                        if (_local_9 == 0)
                        {
                            if (((_local_8 == this.end) && (!(this.read == 0))))
                            {
                                _local_8 = 0;
                                _local_9 = int(((_local_8 < this.read) ? ((this.read - _local_8) - 1) : (this.end - _local_8)));
                            };
                            if (_local_9 == 0)
                            {
                                this.write = _local_8;
                                _arg_2 = this.inflate_flush(_arg_1, _arg_2);
                                _local_8 = this.write;
                                _local_9 = int(((_local_8 < this.read) ? ((this.read - _local_8) - 1) : (this.end - _local_8)));
                                if (((_local_8 == this.end) && (!(this.read == 0))))
                                {
                                    _local_8 = 0;
                                    _local_9 = int(((_local_8 < this.read) ? ((this.read - _local_8) - 1) : (this.end - _local_8)));
                                };
                                if (_local_9 == 0)
                                {
                                    this.bitb = _local_4;
                                    this.bitk = _local_5;
                                    _arg_1.avail_in = _local_7;
                                    _arg_1.total_in = (_arg_1.total_in + (_local_6 - _arg_1.next_in_index));
                                    _arg_1.next_in_index = _local_6;
                                    this.write = _local_8;
                                    return (this.inflate_flush(_arg_1, _arg_2));
                                };
                            };
                        };
                        _arg_2 = Z_OK;
                        _local_3 = this.left;
                        if (_local_3 > _local_7)
                        {
                            _local_3 = _local_7;
                        };
                        if (_local_3 > _local_9)
                        {
                            _local_3 = _local_9;
                        };
                        System.byteArrayCopy(_arg_1.next_in, _local_6, this.window, _local_8, _local_3);
                        _local_6 = (_local_6 + _local_3);
                        _local_7 = (_local_7 - _local_3);
                        _local_8 = (_local_8 + _local_3);
                        _local_9 = (_local_9 - _local_3);
                        if ((this.left = (this.left - _local_3)) != 0) break;
                        this.mode = ((!(this.last == 0)) ? DRY : TYPE);
                        break;
                    case TABLE:
                        while (_local_5 < 14)
                        {
                            if (_local_7 != 0)
                            {
                                _arg_2 = Z_OK;
                            }
                            else
                            {
                                this.bitb = _local_4;
                                this.bitk = _local_5;
                                _arg_1.avail_in = _local_7;
                                _arg_1.total_in = (_arg_1.total_in + (_local_6 - _arg_1.next_in_index));
                                _arg_1.next_in_index = _local_6;
                                this.write = _local_8;
                                return (this.inflate_flush(_arg_1, _arg_2));
                            };
                            _local_7--;
                            _local_4 = (_local_4 | ((_arg_1.next_in[_local_6++] & 0xFF) << _local_5));
                            _local_5 = (_local_5 + 8);
                        };
                        this.table = (_local_3 = (_local_4 & 0x3FFF));
                        if ((((_local_3 & 0x1F) > 29) || (((_local_3 >> 5) & 0x1F) > 29)))
                        {
                            this.mode = BAD;
                            _arg_1.msg = "too many length or distance symbols";
                            _arg_2 = Z_DATA_ERROR;
                            this.bitb = _local_4;
                            this.bitk = _local_5;
                            _arg_1.avail_in = _local_7;
                            _arg_1.total_in = (_arg_1.total_in + (_local_6 - _arg_1.next_in_index));
                            _arg_1.next_in_index = _local_6;
                            this.write = _local_8;
                            return (this.inflate_flush(_arg_1, _arg_2));
                        };
                        _local_3 = ((258 + (_local_3 & 0x1F)) + ((_local_3 >> 5) & 0x1F));
                        if (((this.blens == null) || (this.blens.length < _local_3)))
                        {
                            this.blens = new Array();
                        }
                        else
                        {
                            _local_15 = 0;
                            while (_local_15 < _local_3)
                            {
                                this.blens[_local_15] = 0;
                                _local_15++;
                            };
                        };
                        _local_4 = (_local_4 >>> 14);
                        _local_5 = (_local_5 - 14);
                        this.index = 0;
                        this.mode = BTREE;
                    case BTREE:
                        while (this.index < (4 + (this.table >>> 10)))
                        {
                            while (_local_5 < 3)
                            {
                                if (_local_7 != 0)
                                {
                                    _arg_2 = Z_OK;
                                }
                                else
                                {
                                    this.bitb = _local_4;
                                    this.bitk = _local_5;
                                    _arg_1.avail_in = _local_7;
                                    _arg_1.total_in = (_arg_1.total_in + (_local_6 - _arg_1.next_in_index));
                                    _arg_1.next_in_index = _local_6;
                                    this.write = _local_8;
                                    return (this.inflate_flush(_arg_1, _arg_2));
                                };
                                _local_7--;
                                _local_4 = (_local_4 | ((_arg_1.next_in[_local_6++] & 0xFF) << _local_5));
                                _local_5 = (_local_5 + 8);
                            };
                            this.blens[border[this.index++]] = (_local_4 & 0x07);
                            _local_4 = (_local_4 >>> 3);
                            _local_5 = (_local_5 - 3);
                        };
                        while (this.index < 19)
                        {
                            this.blens[border[this.index++]] = 0;
                        };
                        this.bb[0] = 7;
                        _local_3 = this.inftree.inflate_trees_bits(this.blens, this.bb, this.tb, this.hufts, _arg_1);
                        if (_local_3 != Z_OK)
                        {
                            _arg_2 = _local_3;
                            if (_arg_2 == Z_DATA_ERROR)
                            {
                                this.blens = null;
                                this.mode = BAD;
                            };
                            this.bitb = _local_4;
                            this.bitk = _local_5;
                            _arg_1.avail_in = _local_7;
                            _arg_1.total_in = (_arg_1.total_in + (_local_6 - _arg_1.next_in_index));
                            _arg_1.next_in_index = _local_6;
                            this.write = _local_8;
                            return (this.inflate_flush(_arg_1, _arg_2));
                        };
                        this.index = 0;
                        this.mode = DTREE;
                    case DTREE:
                        while (true)
                        {
                            _local_3 = this.table;
                            if ((!(this.index < ((258 + (_local_3 & 0x1F)) + ((_local_3 >> 5) & 0x1F))))) break;
                            _local_3 = this.bb[0];
                            while (_local_5 < _local_3)
                            {
                                if (_local_7 != 0)
                                {
                                    _arg_2 = Z_OK;
                                }
                                else
                                {
                                    this.bitb = _local_4;
                                    this.bitk = _local_5;
                                    _arg_1.avail_in = _local_7;
                                    _arg_1.total_in = (_arg_1.total_in + (_local_6 - _arg_1.next_in_index));
                                    _arg_1.next_in_index = _local_6;
                                    this.write = _local_8;
                                    return (this.inflate_flush(_arg_1, _arg_2));
                                };
                                _local_7--;
                                _local_4 = (_local_4 | ((_arg_1.next_in[_local_6++] & 0xFF) << _local_5));
                                _local_5 = (_local_5 + 8);
                            };
                            if (this.tb[0] == -1)
                            {
                            };
                            _local_3 = this.hufts[(((this.tb[0] + (_local_4 & inflate_mask[_local_3])) * 3) + 1)];
                            _local_17 = this.hufts[(((this.tb[0] + (_local_4 & inflate_mask[_local_3])) * 3) + 2)];
                            if (_local_17 < 16)
                            {
                                _local_4 = (_local_4 >>> _local_3);
                                _local_5 = (_local_5 - _local_3);
                                var _local_19:* = this.index++;
                                this.blens[_local_19] = _local_17;
                            }
                            else
                            {
                                _local_15 = ((_local_17 == 18) ? 7 : (_local_17 - 14));
                                _local_16 = ((_local_17 == 18) ? 11 : 3);
                                while (_local_5 < (_local_3 + _local_15))
                                {
                                    if (_local_7 != 0)
                                    {
                                        _arg_2 = Z_OK;
                                    }
                                    else
                                    {
                                        this.bitb = _local_4;
                                        this.bitk = _local_5;
                                        _arg_1.avail_in = _local_7;
                                        _arg_1.total_in = (_arg_1.total_in + (_local_6 - _arg_1.next_in_index));
                                        _arg_1.next_in_index = _local_6;
                                        this.write = _local_8;
                                        return (this.inflate_flush(_arg_1, _arg_2));
                                    };
                                    _local_7--;
                                    _local_4 = (_local_4 | ((_arg_1.next_in[_local_6++] & 0xFF) << _local_5));
                                    _local_5 = (_local_5 + 8);
                                };
                                _local_4 = (_local_4 >>> _local_3);
                                _local_5 = (_local_5 - _local_3);
                                _local_16 = (_local_16 + (_local_4 & inflate_mask[_local_15]));
                                _local_4 = (_local_4 >>> _local_15);
                                _local_5 = (_local_5 - _local_15);
                                _local_15 = this.index;
                                _local_3 = this.table;
                                if ((((_local_15 + _local_16) > ((258 + (_local_3 & 0x1F)) + ((_local_3 >> 5) & 0x1F))) || ((_local_17 == 16) && (_local_15 < 1))))
                                {
                                    this.blens = null;
                                    this.mode = BAD;
                                    _arg_1.msg = "invalid bit length repeat";
                                    _arg_2 = Z_DATA_ERROR;
                                    this.bitb = _local_4;
                                    this.bitk = _local_5;
                                    _arg_1.avail_in = _local_7;
                                    _arg_1.total_in = (_arg_1.total_in + (_local_6 - _arg_1.next_in_index));
                                    _arg_1.next_in_index = _local_6;
                                    this.write = _local_8;
                                    return (this.inflate_flush(_arg_1, _arg_2));
                                };
                                _local_17 = ((_local_17 == 16) ? this.blens[(_local_15 - 1)] : 0);
                                do 
                                {
                                    _local_19 = _local_15++;
                                    this.blens[_local_19] = _local_17;
                                } while (--_local_16 != 0);
                                this.index = _local_15;
                            };
                        };
                        this.tb[0] = -1;
                        _local_10 = new Array();
                        _local_11 = new Array();
                        _local_12 = new Array();
                        _local_13 = new Array();
                        _local_10[0] = 9;
                        _local_11[0] = 6;
                        _local_3 = this.table;
                        _local_3 = this.inftree.inflate_trees_dynamic((0x0101 + (_local_3 & 0x1F)), (1 + ((_local_3 >> 5) & 0x1F)), this.blens, _local_10, _local_11, _local_12, _local_13, this.hufts, _arg_1);
                        if (_local_3 != Z_OK)
                        {
                            if (_local_3 == Z_DATA_ERROR)
                            {
                                this.blens = null;
                                this.mode = BAD;
                            };
                            _arg_2 = _local_3;
                            this.bitb = _local_4;
                            this.bitk = _local_5;
                            _arg_1.avail_in = _local_7;
                            _arg_1.total_in = (_arg_1.total_in + (_local_6 - _arg_1.next_in_index));
                            _arg_1.next_in_index = _local_6;
                            this.write = _local_8;
                            return (this.inflate_flush(_arg_1, _arg_2));
                        };
                        this.codes.init(_local_10[0], _local_11[0], this.hufts, _local_12[0], this.hufts, _local_13[0], _arg_1);
                        this.mode = CODES;
                    case CODES:
                        this.bitb = _local_4;
                        this.bitk = _local_5;
                        _arg_1.avail_in = _local_7;
                        _arg_1.total_in = (_arg_1.total_in + (_local_6 - _arg_1.next_in_index));
                        _arg_1.next_in_index = _local_6;
                        this.write = _local_8;
                        if ((_arg_2 = this.codes.proc(this, _arg_1, _arg_2)) != Z_STREAM_END)
                        {
                            return (this.inflate_flush(_arg_1, _arg_2));
                        };
                        _arg_2 = Z_OK;
                        this.codes.free(_arg_1);
                        _local_6 = _arg_1.next_in_index;
                        _local_7 = _arg_1.avail_in;
                        _local_4 = this.bitb;
                        _local_5 = this.bitk;
                        _local_8 = this.write;
                        _local_9 = int(((_local_8 < this.read) ? ((this.read - _local_8) - 1) : (this.end - _local_8)));
                        if (this.last == 0)
                        {
                            this.mode = TYPE;
                            break;
                        };
                        this.mode = DRY;
                    case DRY:
                        this.write = _local_8;
                        _arg_2 = this.inflate_flush(_arg_1, _arg_2);
                        _local_8 = this.write;
                        _local_9 = int(((_local_8 < this.read) ? ((this.read - _local_8) - 1) : (this.end - _local_8)));
                        if (this.read != this.write)
                        {
                            this.bitb = _local_4;
                            this.bitk = _local_5;
                            _arg_1.avail_in = _local_7;
                            _arg_1.total_in = (_arg_1.total_in + (_local_6 - _arg_1.next_in_index));
                            _arg_1.next_in_index = _local_6;
                            this.write = _local_8;
                            return (this.inflate_flush(_arg_1, _arg_2));
                        };
                        this.mode = DONE;
                    case DONE:
                        _arg_2 = Z_STREAM_END;
                        this.bitb = _local_4;
                        this.bitk = _local_5;
                        _arg_1.avail_in = _local_7;
                        _arg_1.total_in = (_arg_1.total_in + (_local_6 - _arg_1.next_in_index));
                        _arg_1.next_in_index = _local_6;
                        this.write = _local_8;
                        return (this.inflate_flush(_arg_1, _arg_2));
                    case BAD:
                        _arg_2 = Z_DATA_ERROR;
                        this.bitb = _local_4;
                        this.bitk = _local_5;
                        _arg_1.avail_in = _local_7;
                        _arg_1.total_in = (_arg_1.total_in + (_local_6 - _arg_1.next_in_index));
                        _arg_1.next_in_index = _local_6;
                        this.write = _local_8;
                        return (this.inflate_flush(_arg_1, _arg_2));
                    default:
                        _arg_2 = Z_STREAM_ERROR;
                        this.bitb = _local_4;
                        this.bitk = _local_5;
                        _arg_1.avail_in = _local_7;
                        _arg_1.total_in = (_arg_1.total_in + (_local_6 - _arg_1.next_in_index));
                        _arg_1.next_in_index = _local_6;
                        this.write = _local_8;
                        return (this.inflate_flush(_arg_1, _arg_2));
                };
            };
            _arg_2 = Z_STREAM_ERROR;
            this.bitb = _local_4;
            this.bitk = _local_5;
            _arg_1.avail_in = _local_7;
            _arg_1.total_in = (_arg_1.total_in + (_local_6 - _arg_1.next_in_index));
            _arg_1.next_in_index = _local_6;
            this.write = _local_8;
            return (this.inflate_flush(_arg_1, _arg_2));
        }

        public function free(_arg_1:ZStream):void
        {
            this.reset(_arg_1, null);
            this.window = null;
            this.hufts = null;
        }

        public function set_dictionary(_arg_1:ByteArray, _arg_2:int, _arg_3:int):void
        {
            System.byteArrayCopy(_arg_1, _arg_2, this.window, 0, _arg_3);
            this.read = (this.write = _arg_3);
        }

        public function sync_point():int
        {
            return ((this.mode == LENS) ? 1 : 0);
        }

        public function inflate_flush(_arg_1:ZStream, _arg_2:int):int
        {
            var _local_3:int;
            var _local_4:int;
            var _local_5:int;
            _local_4 = _arg_1.next_out_index;
            _local_5 = this.read;
            _local_3 = int((((_local_5 <= this.write) ? this.write : this.end) - _local_5));
            if (_local_3 > _arg_1.avail_out)
            {
                _local_3 = _arg_1.avail_out;
            };
            if (((!(_local_3 == 0)) && (_arg_2 == Z_BUF_ERROR)))
            {
                _arg_2 = Z_OK;
            };
            _arg_1.avail_out = (_arg_1.avail_out - _local_3);
            _arg_1.total_out = (_arg_1.total_out + _local_3);
            if (this.checkfn != null)
            {
                _arg_1.adler = (this.check = _arg_1._adler.adler32(this.check, this.window, _local_5, _local_3));
            };
            System.byteArrayCopy(this.window, _local_5, _arg_1.next_out, _local_4, _local_3);
            _local_4 = (_local_4 + _local_3);
            _local_5 = (_local_5 + _local_3);
            if (_local_5 == this.end)
            {
                _local_5 = 0;
                if (this.write == this.end)
                {
                    this.write = 0;
                };
                _local_3 = (this.write - _local_5);
                if (_local_3 > _arg_1.avail_out)
                {
                    _local_3 = _arg_1.avail_out;
                };
                if (((!(_local_3 == 0)) && (_arg_2 == Z_BUF_ERROR)))
                {
                    _arg_2 = Z_OK;
                };
                _arg_1.avail_out = (_arg_1.avail_out - _local_3);
                _arg_1.total_out = (_arg_1.total_out + _local_3);
                if (this.checkfn != null)
                {
                    _arg_1.adler = (this.check = _arg_1._adler.adler32(this.check, this.window, _local_5, _local_3));
                };
                System.byteArrayCopy(this.window, _local_5, _arg_1.next_out, _local_4, _local_3);
                _local_4 = (_local_4 + _local_3);
                _local_5 = (_local_5 + _local_3);
            };
            _arg_1.next_out_index = _local_4;
            this.read = _local_5;
            return (_arg_2);
        }


    }
}//package com.wirelust.as3zlib

