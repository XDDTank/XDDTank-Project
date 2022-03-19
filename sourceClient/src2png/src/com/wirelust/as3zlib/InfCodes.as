// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//com.wirelust.as3zlib.InfCodes

package com.wirelust.as3zlib
{
    import com.wirelust.as3zlib.ZStream;
    import com.wirelust.as3zlib.System;
    import com.wirelust.as3zlib.InfBlocks;
    import com.wirelust.as3zlib.*;

    internal final class InfCodes 
    {

        private static const BADCODE:int = 9;
        private static const COPY:int = 5;
        private static const DIST:int = 3;
        private static const DISTEXT:int = 4;
        private static const END:int = 8;
        private static const LEN:int = 1;
        private static const LENEXT:int = 2;
        private static const LIT:int = 6;
        private static const START:int = 0;
        private static const WASH:int = 7;
        private static const Z_BUF_ERROR:int = -5;
        private static const Z_DATA_ERROR:int = -3;
        private static const Z_ERRNO:int = -1;
        private static const Z_MEM_ERROR:int = -4;
        private static const Z_NEED_DICT:int = 2;
        private static const Z_OK:int = 0;
        private static const Z_STREAM_END:int = 1;
        private static const Z_STREAM_ERROR:int = -2;
        private static const Z_VERSION_ERROR:int = -6;
        private static const inflate_mask:Array = new Array(0, 1, 3, 7, 15, 31, 63, 127, 0xFF, 511, 1023, 2047, 4095, 8191, 16383, 32767, 0xFFFF);

        public var dbits:uint;
        public var dist:int;
        public var dtree:Array;
        public var dtree_index:int;
        public var getBits:int;
        public var lbits:uint;
        public var len:int;
        public var lit:int;
        public var ltree:Array;
        public var ltree_index:int;
        public var mode:int;
        public var need:int;
        public var tree:Array;
        public var tree_index:int = 0;


        public function free(_arg_1:ZStream):void
        {
        }

        public function inflate_fast(_arg_1:int, _arg_2:int, _arg_3:Array, _arg_4:int, _arg_5:Array, _arg_6:int, _arg_7:InfBlocks, _arg_8:ZStream):int
        {
            var _local_9:int;
            var _local_10:Array;
            var _local_11:int;
            var _local_12:int;
            var _local_13:int;
            var _local_14:int;
            var _local_15:int;
            var _local_16:int;
            var _local_17:int;
            var _local_18:int;
            var _local_19:int;
            var _local_20:int;
            var _local_21:int;
            var _local_22:int;
            var _local_23:int;
            var _local_24:int;
            _local_15 = _arg_8.next_in_index;
            _local_16 = _arg_8.avail_in;
            _local_13 = _arg_7.bitb;
            _local_14 = _arg_7.bitk;
            _local_17 = _arg_7.write;
            _local_18 = ((_local_17 < _arg_7.read) ? ((_arg_7.read - _local_17) - 1) : (_arg_7.end - _local_17));
            _local_19 = inflate_mask[_arg_1];
            _local_20 = inflate_mask[_arg_2];
            do 
            {
                while (_local_14 < 20)
                {
                    _local_16--;
                    _local_13 = (_local_13 | ((_arg_8.next_in[_local_15++] & 0xFF) << _local_14));
                    _local_14 = (_local_14 + 8);
                };
                _local_9 = (_local_13 & _local_19);
                _local_10 = _arg_3;
                _local_11 = _arg_4;
                _local_24 = ((_local_11 + _local_9) * 3);
                if ((_local_12 = _local_10[_local_24]) == 0)
                {
                    _local_13 = (_local_13 >> _local_10[(_local_24 + 1)]);
                    _local_14 = (_local_14 - _local_10[(_local_24 + 1)]);
                    var _local_25:* = _local_17++;
                    _arg_7.window[_local_25] = _local_10[(_local_24 + 2)];
                    _local_18--;
                }
                else
                {
                    do 
                    {
                        _local_13 = (_local_13 >> _local_10[(_local_24 + 1)]);
                        _local_14 = (_local_14 - _local_10[(_local_24 + 1)]);
                        if ((_local_12 & 0x10) != 0)
                        {
                            _local_12 = (_local_12 & 0x0F);
                            _local_21 = (_local_10[(_local_24 + 2)] + (int(_local_13) & inflate_mask[_local_12]));
                            _local_13 = (_local_13 >> _local_12);
                            _local_14 = (_local_14 - _local_12);
                            while (_local_14 < 15)
                            {
                                _local_16--;
                                _local_13 = (_local_13 | ((_arg_8.next_in[_local_15++] & 0xFF) << _local_14));
                                _local_14 = (_local_14 + 8);
                            };
                            _local_9 = (_local_13 & _local_20);
                            _local_10 = _arg_5;
                            _local_11 = _arg_6;
                            _local_24 = ((_local_11 + _local_9) * 3);
                            _local_12 = _local_10[_local_24];
                            do 
                            {
                                _local_13 = (_local_13 >> _local_10[(_local_24 + 1)]);
                                _local_14 = (_local_14 - _local_10[(_local_24 + 1)]);
                                if ((_local_12 & 0x10) != 0)
                                {
                                    _local_12 = (_local_12 & 0x0F);
                                    while (_local_14 < _local_12)
                                    {
                                        _local_16--;
                                        _local_13 = (_local_13 | ((_arg_8.next_in[_local_15++] & 0xFF) << _local_14));
                                        _local_14 = (_local_14 + 8);
                                    };
                                    _local_22 = (_local_10[(_local_24 + 2)] + (_local_13 & inflate_mask[_local_12]));
                                    _local_13 = (_local_13 >> _local_12);
                                    _local_14 = (_local_14 - _local_12);
                                    _local_18 = (_local_18 - _local_21);
                                    if (_local_17 >= _local_22)
                                    {
                                        _local_23 = (_local_17 - _local_22);
                                        if ((((_local_17 - _local_23) > 0) && (2 > (_local_17 - _local_23))))
                                        {
                                            _local_25 = _local_17++;
                                            _arg_7.window[_local_25] = _arg_7.window[_local_23++];
                                            var _local_26:* = _local_17++;
                                            _arg_7.window[_local_26] = _arg_7.window[_local_23++];
                                            _local_21 = (_local_21 - 2);
                                        }
                                        else
                                        {
                                            System.byteArrayCopy(_arg_7.window, _local_23, _arg_7.window, _local_17, 2);
                                            _local_17 = (_local_17 + 2);
                                            _local_23 = (_local_23 + 2);
                                            _local_21 = (_local_21 - 2);
                                        };
                                    }
                                    else
                                    {
                                        _local_23 = (_local_17 - _local_22);
                                        do 
                                        {
                                            _local_23 = (_local_23 + _arg_7.end);
                                        } while (_local_23 < 0);
                                        _local_12 = (_arg_7.end - _local_23);
                                        if (_local_21 > _local_12)
                                        {
                                            _local_21 = (_local_21 - _local_12);
                                            if ((((_local_17 - _local_23) > 0) && (_local_12 > (_local_17 - _local_23))))
                                            {
                                                do 
                                                {
                                                    _local_25 = _local_17++;
                                                    _arg_7.window[_local_25] = _arg_7.window[_local_23++];
                                                } while (--_local_12 != 0);
                                            }
                                            else
                                            {
                                                System.byteArrayCopy(_arg_7.window, _local_23, _arg_7.window, _local_17, _local_12);
                                                _local_17 = (_local_17 + _local_12);
                                                _local_23 = (_local_23 + _local_12);
                                                _local_12 = 0;
                                            };
                                            _local_23 = 0;
                                        };
                                    };
                                    if ((((_local_17 - _local_23) > 0) && (_local_21 > (_local_17 - _local_23))))
                                    {
                                        do 
                                        {
                                            _local_25 = _local_17++;
                                            _arg_7.window[_local_25] = _arg_7.window[_local_23++];
                                        } while (--_local_21 != 0);
                                    }
                                    else
                                    {
                                        System.byteArrayCopy(_arg_7.window, _local_23, _arg_7.window, _local_17, _local_21);
                                        _local_17 = (_local_17 + _local_21);
                                        _local_23 = (_local_23 + _local_21);
                                        _local_21 = 0;
                                    };
                                    break;
                                };
                                if ((_local_12 & 0x40) == 0)
                                {
                                    _local_9 = (_local_9 + _local_10[(_local_24 + 2)]);
                                    _local_9 = (_local_9 + (_local_13 & inflate_mask[_local_12]));
                                    _local_24 = ((_local_11 + _local_9) * 3);
                                    _local_12 = _local_10[_local_24];
                                }
                                else
                                {
                                    _arg_8.msg = "invalid distance code";
                                    _local_21 = (_arg_8.avail_in - _local_16);
                                    _local_21 = (((_local_14 >> 3) < _local_21) ? (_local_14 >> 3) : _local_21);
                                    _local_16 = (_local_16 + _local_21);
                                    _local_15 = (_local_15 - _local_21);
                                    _local_14 = (_local_14 - (_local_21 << 3));
                                    _arg_7.bitb = _local_13;
                                    _arg_7.bitk = _local_14;
                                    _arg_8.avail_in = _local_16;
                                    _arg_8.total_in = (_arg_8.total_in + (_local_15 - _arg_8.next_in_index));
                                    _arg_8.next_in_index = _local_15;
                                    _arg_7.write = _local_17;
                                    return (Z_DATA_ERROR);
                                };
                            } while (true);
                            break;
                        };
                        if ((_local_12 & 0x40) == 0)
                        {
                            _local_9 = (_local_9 + _local_10[(_local_24 + 2)]);
                            _local_9 = (_local_9 + (_local_13 & inflate_mask[_local_12]));
                            _local_24 = ((_local_11 + _local_9) * 3);
                            if ((_local_12 = _local_10[_local_24]) == 0)
                            {
                                _local_13 = (_local_13 >> _local_10[(_local_24 + 1)]);
                                _local_14 = (_local_14 - _local_10[(_local_24 + 1)]);
                                _local_25 = _local_17++;
                                _arg_7.window[_local_25] = _local_10[(_local_24 + 2)];
                                _local_18--;
                                break;
                            };
                        }
                        else
                        {
                            if ((_local_12 & 0x20) != 0)
                            {
                                _local_21 = (_arg_8.avail_in - _local_16);
                                _local_21 = (((_local_14 >> 3) < _local_21) ? (_local_14 >> 3) : _local_21);
                                _local_16 = (_local_16 + _local_21);
                                _local_15 = (_local_15 - _local_21);
                                _local_14 = (_local_14 - (_local_21 << 3));
                                _arg_7.bitb = _local_13;
                                _arg_7.bitk = _local_14;
                                _arg_8.avail_in = _local_16;
                                _arg_8.total_in = (_arg_8.total_in + (_local_15 - _arg_8.next_in_index));
                                _arg_8.next_in_index = _local_15;
                                _arg_7.write = _local_17;
                                return (Z_STREAM_END);
                            };
                            _arg_8.msg = "invalid literal/length code";
                            _local_21 = (_arg_8.avail_in - _local_16);
                            _local_21 = (((_local_14 >> 3) < _local_21) ? (_local_14 >> 3) : _local_21);
                            _local_16 = (_local_16 + _local_21);
                            _local_15 = (_local_15 - _local_21);
                            _local_14 = (_local_14 - (_local_21 << 3));
                            _arg_7.bitb = _local_13;
                            _arg_7.bitk = _local_14;
                            _arg_8.avail_in = _local_16;
                            _arg_8.total_in = (_arg_8.total_in + (_local_15 - _arg_8.next_in_index));
                            _arg_8.next_in_index = _local_15;
                            _arg_7.write = _local_17;
                            return (Z_DATA_ERROR);
                        };
                    } while (true);
                };
            } while (((_local_18 >= 258) && (_local_16 >= 10)));
            _local_21 = (_arg_8.avail_in - _local_16);
            _local_21 = (((_local_14 >> 3) < _local_21) ? (_local_14 >> 3) : _local_21);
            _local_16 = (_local_16 + _local_21);
            _local_15 = (_local_15 - _local_21);
            _local_14 = (_local_14 - (_local_21 << 3));
            _arg_7.bitb = _local_13;
            _arg_7.bitk = _local_14;
            _arg_8.avail_in = _local_16;
            _arg_8.total_in = (_arg_8.total_in + (_local_15 - _arg_8.next_in_index));
            _arg_8.next_in_index = _local_15;
            _arg_7.write = _local_17;
            return (Z_OK);
        }

        public function init(_arg_1:int, _arg_2:int, _arg_3:Array, _arg_4:int, _arg_5:Array, _arg_6:int, _arg_7:ZStream):void
        {
            this.mode = START;
            this.lbits = _arg_1;
            this.dbits = _arg_2;
            this.ltree = _arg_3;
            this.ltree_index = _arg_4;
            this.dtree = _arg_5;
            this.dtree_index = _arg_6;
            this.tree = null;
        }

        internal function proc(_arg_1:InfBlocks, _arg_2:ZStream, _arg_3:int):int
        {
            var _local_4:int;
            var _local_5:Array;
            var _local_6:int;
            var _local_7:int;
            var _local_11:int;
            var _local_12:int;
            var _local_13:int;
            var _local_14:int;
            var _local_8:int;
            var _local_9:int;
            var _local_10:int;
            _local_10 = _arg_2.next_in_index;
            _local_11 = _arg_2.avail_in;
            _local_8 = _arg_1.bitb;
            _local_9 = _arg_1.bitk;
            _local_12 = _arg_1.write;
            _local_13 = ((_local_12 < _arg_1.read) ? ((_arg_1.read - _local_12) - 1) : (_arg_1.end - _local_12));
            while (true)
            {
                switch (this.mode)
                {
                    case START:
                        if (((_local_13 >= 258) && (_local_11 >= 10)))
                        {
                            _arg_1.bitb = _local_8;
                            _arg_1.bitk = _local_9;
                            _arg_2.avail_in = _local_11;
                            _arg_2.total_in = (_arg_2.total_in + (_local_10 - _arg_2.next_in_index));
                            _arg_2.next_in_index = _local_10;
                            _arg_1.write = _local_12;
                            _arg_3 = this.inflate_fast(this.lbits, this.dbits, this.ltree, this.ltree_index, this.dtree, this.dtree_index, _arg_1, _arg_2);
                            _local_10 = _arg_2.next_in_index;
                            _local_11 = _arg_2.avail_in;
                            _local_8 = _arg_1.bitb;
                            _local_9 = _arg_1.bitk;
                            _local_12 = _arg_1.write;
                            _local_13 = ((_local_12 < _arg_1.read) ? ((_arg_1.read - _local_12) - 1) : (_arg_1.end - _local_12));
                            if (_arg_3 != Z_OK)
                            {
                                this.mode = ((_arg_3 == Z_STREAM_END) ? WASH : BADCODE);
                                break;
                            };
                        };
                        this.need = this.lbits;
                        this.tree = this.ltree;
                        this.tree_index = this.ltree_index;
                        this.mode = LEN;
                    case LEN:
                        _local_4 = this.need;
                        while (_local_9 < _local_4)
                        {
                            if (_local_11 != 0)
                            {
                                _arg_3 = Z_OK;
                            }
                            else
                            {
                                _arg_1.bitb = _local_8;
                                _arg_1.bitk = _local_9;
                                _arg_2.avail_in = _local_11;
                                _arg_2.total_in = (_arg_2.total_in + (_local_10 - _arg_2.next_in_index));
                                _arg_2.next_in_index = _local_10;
                                _arg_1.write = _local_12;
                                return (_arg_1.inflate_flush(_arg_2, _arg_3));
                            };
                            _local_11--;
                            _local_8 = (_local_8 | ((_arg_2.next_in[_local_10++] & 0xFF) << _local_9));
                            _local_9 = (_local_9 + 8);
                        };
                        _local_6 = ((this.tree_index + (_local_8 & inflate_mask[_local_4])) * 3);
                        _local_8 = (_local_8 >>> this.tree[(_local_6 + 1)]);
                        _local_9 = (_local_9 - this.tree[(_local_6 + 1)]);
                        _local_7 = this.tree[_local_6];
                        if (_local_7 == 0)
                        {
                            this.lit = this.tree[(_local_6 + 2)];
                            this.mode = LIT;
                            break;
                        };
                        if ((_local_7 & 0x10) != 0)
                        {
                            this.getBits = (_local_7 & 0x0F);
                            this.len = this.tree[(_local_6 + 2)];
                            this.mode = LENEXT;
                            break;
                        };
                        if ((_local_7 & 0x40) == 0)
                        {
                            this.need = _local_7;
                            this.tree_index = ((_local_6 / 3) + this.tree[(_local_6 + 2)]);
                            break;
                        };
                        if ((_local_7 & 0x20) != 0)
                        {
                            this.mode = WASH;
                            break;
                        };
                        this.mode = BADCODE;
                        _arg_2.msg = "invalid literal/length code";
                        _arg_3 = Z_DATA_ERROR;
                        _arg_1.bitb = _local_8;
                        _arg_1.bitk = _local_9;
                        _arg_2.avail_in = _local_11;
                        _arg_2.total_in = (_arg_2.total_in + (_local_10 - _arg_2.next_in_index));
                        _arg_2.next_in_index = _local_10;
                        _arg_1.write = _local_12;
                        return (_arg_1.inflate_flush(_arg_2, _arg_3));
                    case LENEXT:
                        _local_4 = this.getBits;
                        while (_local_9 < _local_4)
                        {
                            if (_local_11 != 0)
                            {
                                _arg_3 = Z_OK;
                            }
                            else
                            {
                                _arg_1.bitb = _local_8;
                                _arg_1.bitk = _local_9;
                                _arg_2.avail_in = _local_11;
                                _arg_2.total_in = (_arg_2.total_in + (_local_10 - _arg_2.next_in_index));
                                _arg_2.next_in_index = _local_10;
                                _arg_1.write = _local_12;
                                return (_arg_1.inflate_flush(_arg_2, _arg_3));
                            };
                            _local_11--;
                            _local_8 = (_local_8 | ((_arg_2.next_in[_local_10++] & 0xFF) << _local_9));
                            _local_9 = (_local_9 + 8);
                        };
                        this.len = (this.len + (_local_8 & inflate_mask[_local_4]));
                        _local_8 = (_local_8 >> _local_4);
                        _local_9 = (_local_9 - _local_4);
                        this.need = this.dbits;
                        this.tree = this.dtree;
                        this.tree_index = this.dtree_index;
                        this.mode = DIST;
                    case DIST:
                        _local_4 = this.need;
                        while (_local_9 < _local_4)
                        {
                            if (_local_11 != 0)
                            {
                                _arg_3 = Z_OK;
                            }
                            else
                            {
                                _arg_1.bitb = _local_8;
                                _arg_1.bitk = _local_9;
                                _arg_2.avail_in = _local_11;
                                _arg_2.total_in = (_arg_2.total_in + (_local_10 - _arg_2.next_in_index));
                                _arg_2.next_in_index = _local_10;
                                _arg_1.write = _local_12;
                                return (_arg_1.inflate_flush(_arg_2, _arg_3));
                            };
                            _local_11--;
                            _local_8 = (_local_8 | ((_arg_2.next_in[_local_10++] & 0xFF) << _local_9));
                            _local_9 = (_local_9 + 8);
                        };
                        _local_6 = ((this.tree_index + (_local_8 & inflate_mask[_local_4])) * 3);
                        _local_8 = (_local_8 >> this.tree[(_local_6 + 1)]);
                        _local_9 = (_local_9 - this.tree[(_local_6 + 1)]);
                        _local_7 = this.tree[_local_6];
                        if ((_local_7 & 0x10) != 0)
                        {
                            this.getBits = (_local_7 & 0x0F);
                            this.dist = this.tree[(_local_6 + 2)];
                            this.mode = DISTEXT;
                            break;
                        };
                        if ((_local_7 & 0x40) == 0)
                        {
                            this.need = _local_7;
                            this.tree_index = ((_local_6 / 3) + this.tree[(_local_6 + 2)]);
                            break;
                        };
                        this.mode = BADCODE;
                        _arg_2.msg = "invalid distance code";
                        _arg_3 = Z_DATA_ERROR;
                        _arg_1.bitb = _local_8;
                        _arg_1.bitk = _local_9;
                        _arg_2.avail_in = _local_11;
                        _arg_2.total_in = (_arg_2.total_in + (_local_10 - _arg_2.next_in_index));
                        _arg_2.next_in_index = _local_10;
                        _arg_1.write = _local_12;
                        return (_arg_1.inflate_flush(_arg_2, _arg_3));
                    case DISTEXT:
                        _local_4 = this.getBits;
                        while (_local_9 < _local_4)
                        {
                            if (_local_11 != 0)
                            {
                                _arg_3 = Z_OK;
                            }
                            else
                            {
                                _arg_1.bitb = _local_8;
                                _arg_1.bitk = _local_9;
                                _arg_2.avail_in = _local_11;
                                _arg_2.total_in = (_arg_2.total_in + (_local_10 - _arg_2.next_in_index));
                                _arg_2.next_in_index = _local_10;
                                _arg_1.write = _local_12;
                                return (_arg_1.inflate_flush(_arg_2, _arg_3));
                            };
                            _local_11--;
                            _local_8 = (_local_8 | ((_arg_2.next_in[_local_10++] & 0xFF) << _local_9));
                            _local_9 = (_local_9 + 8);
                        };
                        this.dist = (this.dist + (_local_8 & inflate_mask[_local_4]));
                        _local_8 = (_local_8 >> _local_4);
                        _local_9 = (_local_9 - _local_4);
                        this.mode = COPY;
                    case COPY:
                        _local_14 = (_local_12 - this.dist);
                        while (_local_14 < 0)
                        {
                            _local_14 = (_local_14 + _arg_1.end);
                        };
                        while (this.len != 0)
                        {
                            if (_local_13 == 0)
                            {
                                if (((_local_12 == _arg_1.end) && (!(_arg_1.read == 0))))
                                {
                                    _local_12 = 0;
                                    _local_13 = ((_local_12 < _arg_1.read) ? ((_arg_1.read - _local_12) - 1) : (_arg_1.end - _local_12));
                                };
                                if (_local_13 == 0)
                                {
                                    _arg_1.write = _local_12;
                                    _arg_3 = _arg_1.inflate_flush(_arg_2, _arg_3);
                                    _local_12 = _arg_1.write;
                                    _local_13 = ((_local_12 < _arg_1.read) ? ((_arg_1.read - _local_12) - 1) : (_arg_1.end - _local_12));
                                    if (((_local_12 == _arg_1.end) && (!(_arg_1.read == 0))))
                                    {
                                        _local_12 = 0;
                                        _local_13 = ((_local_12 < _arg_1.read) ? ((_arg_1.read - _local_12) - 1) : (_arg_1.end - _local_12));
                                    };
                                    if (_local_13 == 0)
                                    {
                                        _arg_1.bitb = _local_8;
                                        _arg_1.bitk = _local_9;
                                        _arg_2.avail_in = _local_11;
                                        _arg_2.total_in = (_arg_2.total_in + (_local_10 - _arg_2.next_in_index));
                                        _arg_2.next_in_index = _local_10;
                                        _arg_1.write = _local_12;
                                        return (_arg_1.inflate_flush(_arg_2, _arg_3));
                                    };
                                };
                            };
                            var _local_15:* = _local_12++;
                            _arg_1.window[_local_15] = _arg_1.window[_local_14++];
                            _local_13--;
                            if (_local_14 == _arg_1.end)
                            {
                                _local_14 = 0;
                            };
                            this.len--;
                        };
                        this.mode = START;
                        break;
                    case LIT:
                        if (_local_13 == 0)
                        {
                            if (((_local_12 == _arg_1.end) && (!(_arg_1.read == 0))))
                            {
                                _local_12 = 0;
                                _local_13 = ((_local_12 < _arg_1.read) ? ((_arg_1.read - _local_12) - 1) : (_arg_1.end - _local_12));
                            };
                            if (_local_13 == 0)
                            {
                                _arg_1.write = _local_12;
                                _arg_3 = _arg_1.inflate_flush(_arg_2, _arg_3);
                                _local_12 = _arg_1.write;
                                _local_13 = ((_local_12 < _arg_1.read) ? ((_arg_1.read - _local_12) - 1) : (_arg_1.end - _local_12));
                                if (((_local_12 == _arg_1.end) && (!(_arg_1.read == 0))))
                                {
                                    _local_12 = 0;
                                    _local_13 = ((_local_12 < _arg_1.read) ? ((_arg_1.read - _local_12) - 1) : (_arg_1.end - _local_12));
                                };
                                if (_local_13 == 0)
                                {
                                    _arg_1.bitb = _local_8;
                                    _arg_1.bitk = _local_9;
                                    _arg_2.avail_in = _local_11;
                                    _arg_2.total_in = (_arg_2.total_in + (_local_10 - _arg_2.next_in_index));
                                    _arg_2.next_in_index = _local_10;
                                    _arg_1.write = _local_12;
                                    return (_arg_1.inflate_flush(_arg_2, _arg_3));
                                };
                            };
                        };
                        _arg_3 = Z_OK;
                        _local_15 = _local_12++;
                        _arg_1.window[_local_15] = this.lit;
                        _local_13--;
                        this.mode = START;
                        break;
                    case WASH:
                        if (_local_9 > 7)
                        {
                            _local_9 = (_local_9 - 8);
                            _local_11++;
                            _local_10--;
                        };
                        _arg_1.write = _local_12;
                        _arg_3 = _arg_1.inflate_flush(_arg_2, _arg_3);
                        _local_12 = _arg_1.write;
                        _local_13 = ((_local_12 < _arg_1.read) ? ((_arg_1.read - _local_12) - 1) : (_arg_1.end - _local_12));
                        if (_arg_1.read != _arg_1.write)
                        {
                            _arg_1.bitb = _local_8;
                            _arg_1.bitk = _local_9;
                            _arg_2.avail_in = _local_11;
                            _arg_2.total_in = (_arg_2.total_in + (_local_10 - _arg_2.next_in_index));
                            _arg_2.next_in_index = _local_10;
                            _arg_1.write = _local_12;
                            return (_arg_1.inflate_flush(_arg_2, _arg_3));
                        };
                        this.mode = END;
                    case END:
                        _arg_3 = Z_STREAM_END;
                        _arg_1.bitb = _local_8;
                        _arg_1.bitk = _local_9;
                        _arg_2.avail_in = _local_11;
                        _arg_2.total_in = (_arg_2.total_in + (_local_10 - _arg_2.next_in_index));
                        _arg_2.next_in_index = _local_10;
                        _arg_1.write = _local_12;
                        return (_arg_1.inflate_flush(_arg_2, _arg_3));
                    case BADCODE:
                        _arg_3 = Z_DATA_ERROR;
                        _arg_1.bitb = _local_8;
                        _arg_1.bitk = _local_9;
                        _arg_2.avail_in = _local_11;
                        _arg_2.total_in = (_arg_2.total_in + (_local_10 - _arg_2.next_in_index));
                        _arg_2.next_in_index = _local_10;
                        _arg_1.write = _local_12;
                        return (_arg_1.inflate_flush(_arg_2, _arg_3));
                    default:
                        _arg_3 = Z_STREAM_ERROR;
                        _arg_1.bitb = _local_8;
                        _arg_1.bitk = _local_9;
                        _arg_2.avail_in = _local_11;
                        _arg_2.total_in = (_arg_2.total_in + (_local_10 - _arg_2.next_in_index));
                        _arg_2.next_in_index = _local_10;
                        _arg_1.write = _local_12;
                        return (_arg_1.inflate_flush(_arg_2, _arg_3));
                };
            };
            _arg_3 = Z_STREAM_ERROR;
            _arg_1.bitb = _local_8;
            _arg_1.bitk = _local_9;
            _arg_2.avail_in = _local_11;
            _arg_2.total_in = (_arg_2.total_in + (_local_10 - _arg_2.next_in_index));
            _arg_2.next_in_index = _local_10;
            _arg_1.write = _local_12;
            return (_arg_1.inflate_flush(_arg_2, _arg_3));
        }


    }
}//package com.wirelust.as3zlib

