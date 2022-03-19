// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//com.wirelust.as3zlib.Deflate

package com.wirelust.as3zlib
{
    import flash.utils.ByteArray;
    import com.wirelust.util.Cast;
    import com.wirelust.as3zlib.Tree;

    public class Deflate 
    {

        private static var MAX_MEM_LEVEL:int = 9;
        private static var Z_DEFAULT_COMPRESSION:int = -1;
        private static var MAX_WBITS:int = 15;
        private static var DEF_MEM_LEVEL:int = 8;
        private static var STORED:int = 0;
        private static var FAST:int = 1;
        private static var SLOW:int = 2;
        private static var config_table:Array = new Array(new DeflateConfig(0, 0, 0, 0, STORED), new DeflateConfig(4, 4, 8, 4, FAST), new DeflateConfig(4, 5, 16, 8, FAST), new DeflateConfig(4, 6, 32, 32, FAST), new DeflateConfig(4, 4, 16, 16, SLOW), new DeflateConfig(8, 16, 32, 32, SLOW), new DeflateConfig(8, 16, 128, 128, SLOW), new DeflateConfig(8, 32, 128, 0x0100, SLOW), new DeflateConfig(32, 128, 258, 0x0400, SLOW), new DeflateConfig(32, 258, 258, 0x1000, SLOW));
        private static var NeedMore:int = 0;
        private static var BlockDone:int = 1;
        private static const FinishStarted:int = 2;
        private static const FinishDone:int = 3;
        private static const PRESET_DICT:int = 32;
        private static const Z_FILTERED:int = 1;
        private static const Z_HUFFMAN_ONLY:int = 2;
        private static const Z_DEFAULT_STRATEGY:int = 0;
        private static const Z_NO_FLUSH:int = 0;
        private static const Z_PARTIAL_FLUSH:int = 1;
        private static const Z_SYNC_FLUSH:int = 2;
        private static const Z_FULL_FLUSH:int = 3;
        private static const Z_FINISH:int = 4;
        private static const Z_OK:int = 0;
        private static const Z_STREAM_END:int = 1;
        private static const Z_NEED_DICT:int = 2;
        private static const Z_ERRNO:int = -1;
        private static const Z_STREAM_ERROR:int = -2;
        private static const Z_DATA_ERROR:int = -3;
        private static const Z_MEM_ERROR:int = -4;
        private static const Z_BUF_ERROR:int = -5;
        private static const Z_VERSION_ERROR:int = -6;
        private static const INIT_STATE:int = 42;
        private static const BUSY_STATE:int = 113;
        private static const FINISH_STATE:int = 666;
        private static var Z_DEFLATED:int = 8;
        private static const STORED_BLOCK:int = 0;
        private static const STATIC_TREES:int = 1;
        private static const DYN_TREES:int = 2;
        private static const Z_BINARY:int = 0;
        private static const Z_ASCII:int = 1;
        private static const Z_UNKNOWN:int = 2;
        private static const Buf_size:int = (8 * 2);//16
        private static const REP_3_6:int = 16;
        private static const REPZ_3_10:int = 17;
        private static const REPZ_11_138:int = 18;
        private static const MIN_MATCH:int = 3;
        private static const MAX_MATCH:int = 258;
        private static const MIN_LOOKAHEAD:int = ((MAX_MATCH + MIN_MATCH) + 1);//262
        private static const MAX_BITS:int = 15;
        private static const D_CODES:int = 30;
        private static const BL_CODES:int = 19;
        private static const LENGTH_CODES:int = 29;
        private static const LITERALS:int = 0x0100;
        private static const L_CODES:int = ((LITERALS + 1) + LENGTH_CODES);//286
        private static const HEAP_SIZE:int = ((2 * L_CODES) + 1);//573
        private static const END_BLOCK:int = 0x0100;

        private var z_errmsg:Array = new Array("need dictionary", "stream end", "", "file error", "stream error", "data error", "insufficient memory", "buffer error", "incompatible version", "");
        public var strm:ZStream;
        public var status:int;
        public var pending_buf:ByteArray;
        public var pending_buf_size:int;
        public var pending_out:int;
        public var pending:int;
        public var noheader:int;
        public var data_type:uint;
        public var method:uint;
        public var last_flush:int;
        public var w_size:int;
        public var w_bits:int;
        public var w_mask:int;
        public var window:ByteArray;
        public var window_size:int;
        public var prev:Array;
        public var head:Array;
        public var ins_h:int;
        public var hash_size:int;
        public var hash_bits:int;
        public var hash_mask:int;
        public var hash_shift:int;
        public var block_start:int;
        public var match_length:int;
        public var prev_match:int;
        public var match_available:int;
        public var strstart:int;
        public var match_start:int;
        public var lookahead:int;
        public var prev_length:int;
        public var max_chain_length:int;
        public var max_lazy_match:int;
        public var level:int;
        public var strategy:int;
        public var good_match:int;
        public var nice_match:int;
        internal var dyn_ltree:Array;
        internal var dyn_dtree:Array;
        internal var bl_tree:Array;
        internal var l_desc:Tree = new Tree();
        internal var d_desc:Tree = new Tree();
        internal var bl_desc:Tree = new Tree();
        internal var bl_count:Array = new Array();
        internal var heap:Array = new Array();
        internal var heap_len:int;
        internal var heap_max:int;
        internal var depth:Array = new Array();
        internal var l_buf:int;
        internal var lit_bufsize:int;
        internal var last_lit:int;
        internal var d_buf:int;
        internal var opt_len:int;
        internal var static_len:int;
        internal var matches:int;
        internal var last_eob_len:int;
        internal var bi_buf:Number;
        internal var bi_valid:int;

        public function Deflate():void
        {
            this.dyn_ltree = new Array();
            this.dyn_dtree = new Array();
            this.bl_tree = new Array();
        }

        internal static function smaller(_arg_1:Array, _arg_2:int, _arg_3:int, _arg_4:Array):Boolean
        {
            var _local_5:Number = _arg_1[(_arg_2 * 2)];
            var _local_6:Number = _arg_1[(_arg_3 * 2)];
            return ((_local_5 < _local_6) || ((_local_5 == _local_6) && (_arg_4[_arg_2] <= _arg_4[_arg_3])));
        }


        internal function lm_init():void
        {
            this.window_size = (2 * this.w_size);
            this.head[(this.hash_size - 1)] = 0;
            var _local_1:int;
            while (_local_1 < (this.hash_size - 1))
            {
                this.head[_local_1] = 0;
                _local_1++;
            };
            this.max_lazy_match = Deflate.config_table[this.level].max_lazy;
            this.good_match = Deflate.config_table[this.level].good_length;
            this.nice_match = Deflate.config_table[this.level].nice_length;
            this.max_chain_length = Deflate.config_table[this.level].max_chain;
            this.strstart = 0;
            this.block_start = 0;
            this.lookahead = 0;
            this.match_length = (this.prev_length = (MIN_MATCH - 1));
            this.match_available = 0;
            this.ins_h = 0;
        }

        internal function tr_init():void
        {
            this.l_desc.dyn_tree = this.dyn_ltree;
            this.l_desc.stat_desc = StaticTree.static_l_desc;
            this.d_desc.dyn_tree = this.dyn_dtree;
            this.d_desc.stat_desc = StaticTree.static_d_desc;
            this.bl_desc.dyn_tree = this.bl_tree;
            this.bl_desc.stat_desc = StaticTree.static_bl_desc;
            this.bi_buf = 0;
            this.bi_valid = 0;
            this.last_eob_len = 8;
            this.init_block();
        }

        internal function init_block():void
        {
            var _local_1:int;
            _local_1 = 0;
            while (_local_1 < L_CODES)
            {
                this.dyn_ltree[(_local_1 * 2)] = 0;
                _local_1++;
            };
            _local_1 = 0;
            while (_local_1 < D_CODES)
            {
                this.dyn_dtree[(_local_1 * 2)] = 0;
                _local_1++;
            };
            _local_1 = 0;
            while (_local_1 < BL_CODES)
            {
                this.bl_tree[(_local_1 * 2)] = 0;
                _local_1++;
            };
            this.dyn_ltree[(END_BLOCK * 2)] = 1;
            this.opt_len = (this.static_len = 0);
            this.last_lit = (this.matches = 0);
        }

        internal function pqdownheap(_arg_1:Array, _arg_2:int):void
        {
            var _local_3:int = this.heap[_arg_2];
            var _local_4:int = (_arg_2 << 1);
            while (_local_4 <= this.heap_len)
            {
                if (((_local_4 < this.heap_len) && (smaller(_arg_1, this.heap[(_local_4 + 1)], this.heap[_local_4], this.depth))))
                {
                    _local_4++;
                };
                if (smaller(_arg_1, _local_3, this.heap[_local_4], this.depth)) break;
                this.heap[_arg_2] = this.heap[_local_4];
                _arg_2 = _local_4;
                _local_4 = (_local_4 << 1);
            };
            this.heap[_arg_2] = _local_3;
        }

        internal function scan_tree(_arg_1:Array, _arg_2:int):void
        {
            var _local_3:int;
            var _local_5:int;
            var _local_4:int = -1;
            var _local_6:int = _arg_1[((0 * 2) + 1)];
            var _local_7:int;
            var _local_8:int = 7;
            var _local_9:int = 4;
            if (_local_6 == 0)
            {
                _local_8 = 138;
                _local_9 = 3;
            };
            _arg_1[(((_arg_2 + 1) * 2) + 1)] = 0xFFFF;
            _local_3 = 0;
            while (_local_3 <= _arg_2)
            {
                _local_5 = _local_6;
                _local_6 = _arg_1[(((_local_3 + 1) * 2) + 1)];
                if (!((++_local_7 < _local_8) && (_local_5 == _local_6)))
                {
                    if (_local_7 < _local_9)
                    {
                        this.bl_tree[(_local_5 * 2)] = (this.bl_tree[(_local_5 * 2)] + _local_7);
                    }
                    else
                    {
                        if (_local_5 != 0)
                        {
                            if (_local_5 != _local_4)
                            {
                                this.bl_tree[(_local_5 * 2)]++;
                            };
                            this.bl_tree[(REP_3_6 * 2)]++;
                        }
                        else
                        {
                            if (_local_7 <= 10)
                            {
                                this.bl_tree[(REPZ_3_10 * 2)]++;
                            }
                            else
                            {
                                this.bl_tree[(REPZ_11_138 * 2)]++;
                            };
                        };
                    };
                    _local_7 = 0;
                    _local_4 = _local_5;
                    if (_local_6 == 0)
                    {
                        _local_8 = 138;
                        _local_9 = 3;
                    }
                    else
                    {
                        if (_local_5 == _local_6)
                        {
                            _local_8 = 6;
                            _local_9 = 3;
                        }
                        else
                        {
                            _local_8 = 7;
                            _local_9 = 4;
                        };
                    };
                };
                _local_3++;
            };
        }

        public function build_bl_tree():int
        {
            var _local_1:int;
            this.scan_tree(this.dyn_ltree, this.l_desc.max_code);
            this.scan_tree(this.dyn_dtree, this.d_desc.max_code);
            this.bl_desc.build_tree(this);
            _local_1 = (BL_CODES - 1);
            while (_local_1 >= 3)
            {
                if (this.bl_tree[((Tree.bl_order[_local_1] * 2) + 1)] != 0) break;
                _local_1--;
            };
            this.opt_len = (this.opt_len + ((((3 * (_local_1 + 1)) + 5) + 5) + 4));
            return (_local_1);
        }

        public function send_all_trees(_arg_1:int, _arg_2:int, _arg_3:int):void
        {
            var _local_4:int;
            this.send_bits((_arg_1 - 0x0101), 5);
            this.send_bits((_arg_2 - 1), 5);
            this.send_bits((_arg_3 - 4), 4);
            _local_4 = 0;
            while (_local_4 < _arg_3)
            {
                this.send_bits(this.bl_tree[((Tree.bl_order[_local_4] * 2) + 1)], 3);
                _local_4++;
            };
            this.send_tree(this.dyn_ltree, (_arg_1 - 1));
            this.send_tree(this.dyn_dtree, (_arg_2 - 1));
        }

        public function send_tree(_arg_1:Array, _arg_2:int):void
        {
            var _local_3:int;
            var _local_5:int;
            var _local_4:int = -1;
            var _local_6:int = _arg_1[((0 * 2) + 1)];
            var _local_7:int;
            var _local_8:int = 7;
            var _local_9:int = 4;
            if (_local_6 == 0)
            {
                _local_8 = 138;
                _local_9 = 3;
            };
            _local_3 = 0;
            while (_local_3 <= _arg_2)
            {
                _local_5 = _local_6;
                _local_6 = _arg_1[(((_local_3 + 1) * 2) + 1)];
                if (!((++_local_7 < _local_8) && (_local_5 == _local_6)))
                {
                    if (_local_7 < _local_9)
                    {
                        do 
                        {
                            this.send_code(_local_5, this.bl_tree);
                        } while (--_local_7 != 0);
                    }
                    else
                    {
                        if (_local_5 != 0)
                        {
                            if (_local_5 != _local_4)
                            {
                                this.send_code(_local_5, this.bl_tree);
                                _local_7--;
                            };
                            this.send_code(REP_3_6, this.bl_tree);
                            this.send_bits((_local_7 - 3), 2);
                        }
                        else
                        {
                            if (_local_7 <= 10)
                            {
                                this.send_code(REPZ_3_10, this.bl_tree);
                                this.send_bits((_local_7 - 3), 3);
                            }
                            else
                            {
                                this.send_code(REPZ_11_138, this.bl_tree);
                                this.send_bits((_local_7 - 11), 7);
                            };
                        };
                    };
                    _local_7 = 0;
                    _local_4 = _local_5;
                    if (_local_6 == 0)
                    {
                        _local_8 = 138;
                        _local_9 = 3;
                    }
                    else
                    {
                        if (_local_5 == _local_6)
                        {
                            _local_8 = 6;
                            _local_9 = 3;
                        }
                        else
                        {
                            _local_8 = 7;
                            _local_9 = 4;
                        };
                    };
                };
                _local_3++;
            };
        }

        final public function put_byte(_arg_1:ByteArray, _arg_2:int, _arg_3:int):void
        {
            System.byteArrayCopy(_arg_1, _arg_2, this.pending_buf, this.pending, _arg_3);
            this.pending = (this.pending + _arg_3);
        }

        public function put_byte_withInt(_arg_1:int):void
        {
            this.pending_buf.writeByte(_arg_1);
            this.pending++;
        }

        public function put_short(_arg_1:int):void
        {
            this.put_byte_withInt(_arg_1);
            this.put_byte_withInt((_arg_1 >>> 8));
        }

        final public function putShortMSB(_arg_1:int):void
        {
            this.put_byte_withInt((_arg_1 >> 8));
            this.put_byte_withInt((_arg_1 & 0xFF));
        }

        final public function send_code(_arg_1:int, _arg_2:Array):void
        {
            var _local_3:int = (_arg_1 * 2);
            this.send_bits((_arg_2[_local_3] & 0xFFFF), (_arg_2[(_local_3 + 1)] & 0xFFFF));
        }

        public function send_bits(_arg_1:int, _arg_2:int):void
        {
            var _local_4:int;
            var _local_3:int = _arg_2;
            if (this.bi_valid > (int(Buf_size) - _local_3))
            {
                _local_4 = _arg_1;
                this.bi_buf = (this.bi_buf | ((_local_4 << this.bi_valid) & 0xFFFF));
                this.put_short(this.bi_buf);
                this.bi_buf = (_local_4 >>> (Buf_size - this.bi_valid));
                this.bi_buf = Cast.toShort((_local_4 >>> (Buf_size - this.bi_valid)));
                this.bi_valid = (this.bi_valid + (_local_3 - Buf_size));
            }
            else
            {
                this.bi_buf = (this.bi_buf | ((_arg_1 << this.bi_valid) & 0xFFFF));
                this.bi_valid = (this.bi_valid + _local_3);
            };
        }

        public function _tr_align():void
        {
            this.send_bits((STATIC_TREES << 1), 3);
            this.send_code(END_BLOCK, StaticTree.static_ltree);
            this.bi_flush();
            if ((((1 + this.last_eob_len) + 10) - this.bi_valid) < 9)
            {
                this.send_bits((STATIC_TREES << 1), 3);
                this.send_code(END_BLOCK, StaticTree.static_ltree);
                this.bi_flush();
            };
            this.last_eob_len = 7;
        }

        public function _tr_tally(_arg_1:int, _arg_2:int):Boolean
        {
            var _local_3:int;
            var _local_4:int;
            var _local_5:int;
            this.pending_buf[(this.d_buf + (this.last_lit * 2))] = Cast.toByte((_arg_1 >>> 8));
            this.pending_buf[((this.d_buf + (this.last_lit * 2)) + 1)] = Cast.toByte(_arg_1);
            this.pending_buf[(this.l_buf + this.last_lit)] = _arg_2;
            this.last_lit++;
            if (_arg_1 == 0)
            {
                this.dyn_ltree[(_arg_2 * 2)]++;
            }
            else
            {
                this.matches++;
                _arg_1--;
                this.dyn_ltree[(((Tree._length_code[_arg_2] + LITERALS) + 1) * 2)]++;
                this.dyn_dtree[(Tree.d_code(_arg_1) * 2)]++;
            };
            if ((((this.last_lit & 0x01) == 0) && (this.level > 2)))
            {
                _local_3 = (this.last_lit * 8);
                _local_4 = (this.strstart - this.block_start);
                _local_5 = 0;
                while (_local_5 < D_CODES)
                {
                    _local_3 = (_local_3 + (int(this.dyn_dtree[(_local_5 * 2)]) * (5 + Tree.extra_dbits[_local_5])));
                    _local_5++;
                };
                _local_3 = (_local_3 >>> 3);
                if (((this.matches < (this.last_lit / 2)) && (_local_3 < (_local_4 / 2))))
                {
                    return (true);
                };
            };
            return (this.last_lit == (this.lit_bufsize - 1));
        }

        public function compress_block(_arg_1:Array, _arg_2:Array):void
        {
            var _local_3:int;
            var _local_4:int;
            var _local_6:int;
            var _local_7:int;
            var _local_5:int;
            if (this.last_lit != 0)
            {
                do 
                {
                    _local_3 = (((this.pending_buf[(this.d_buf + (_local_5 * 2))] << 8) & 0xFF00) | (this.pending_buf[((this.d_buf + (_local_5 * 2)) + 1)] & 0xFF));
                    _local_4 = (this.pending_buf[(this.l_buf + _local_5)] & 0xFF);
                    _local_5++;
                    if (_local_3 == 0)
                    {
                        this.send_code(_local_4, _arg_1);
                    }
                    else
                    {
                        _local_6 = Tree._length_code[_local_4];
                        this.send_code(((_local_6 + LITERALS) + 1), _arg_1);
                        _local_7 = Tree.extra_lbits[_local_6];
                        if (_local_7 != 0)
                        {
                            _local_4 = (_local_4 - Tree.base_length[_local_6]);
                            this.send_bits(_local_4, _local_7);
                        };
                        _local_3--;
                        _local_6 = Tree.d_code(_local_3);
                        this.send_code(_local_6, _arg_2);
                        _local_7 = Tree.extra_dbits[_local_6];
                        if (_local_7 != 0)
                        {
                            _local_3 = (_local_3 - Tree.base_dist[_local_6]);
                            this.send_bits(_local_3, _local_7);
                        };
                    };
                } while (_local_5 < this.last_lit);
            };
            this.send_code(END_BLOCK, _arg_1);
            this.last_eob_len = _arg_1[((END_BLOCK * 2) + 1)];
        }

        internal function set_data_type():void
        {
            var _local_1:int;
            var _local_2:int;
            var _local_3:int;
            while (_local_1 < 7)
            {
                _local_3 = (_local_3 + this.dyn_ltree[(_local_1 * 2)]);
                _local_1++;
            };
            while (_local_1 < 128)
            {
                _local_2 = (_local_2 + this.dyn_ltree[(_local_1 * 2)]);
                _local_1++;
            };
            while (_local_1 < LITERALS)
            {
                _local_3 = (_local_3 + this.dyn_ltree[(_local_1 * 2)]);
                _local_1++;
            };
            this.data_type = ((_local_3 > (_local_2 >>> 2)) ? Z_BINARY : Z_ASCII);
        }

        public function bi_flush():void
        {
            if (this.bi_valid == 16)
            {
                this.put_short(this.bi_buf);
                this.bi_buf = 0;
                this.bi_valid = 0;
            }
            else
            {
                if (this.bi_valid >= 8)
                {
                    this.put_byte_withInt(this.bi_buf);
                    this.bi_buf = (this.bi_buf >>> 8);
                    this.bi_valid = (this.bi_valid - 8);
                };
            };
        }

        public function bi_windup():void
        {
            if (this.bi_valid > 8)
            {
                this.put_short(this.bi_buf);
            }
            else
            {
                if (this.bi_valid > 0)
                {
                    this.put_byte_withInt(this.bi_buf);
                };
            };
            this.bi_buf = 0;
            this.bi_valid = 0;
        }

        internal function copy_block(_arg_1:int, _arg_2:int, _arg_3:Boolean):void
        {
            var _local_4:int;
            this.bi_windup();
            this.last_eob_len = 8;
            if (_arg_3)
            {
                this.put_short(_arg_2);
                this.put_short(((~(_arg_2)) & 0xFFFF));
            };
            this.put_byte(this.window, _arg_1, _arg_2);
        }

        internal function flush_block_only(_arg_1:Boolean):void
        {
            this._tr_flush_block(((this.block_start >= 0) ? this.block_start : -1), (this.strstart - this.block_start), _arg_1);
            this.block_start = this.strstart;
            this.strm.flush_pending();
        }

        public function deflate_stored(_arg_1:int):int
        {
            var _local_3:int;
            var _local_2:int;
            if (_local_2 > (this.pending_buf_size - 5))
            {
                _local_2 = (this.pending_buf_size - 5);
            };
            while (true)
            {
                if (this.lookahead <= 1)
                {
                    this.fill_window();
                    if (((this.lookahead == 0) && (_arg_1 == Z_NO_FLUSH)))
                    {
                        return (NeedMore);
                    };
                    if (this.lookahead == 0) break;
                };
                this.strstart = (this.strstart + this.lookahead);
                this.lookahead = 0;
                _local_3 = (this.block_start + _local_2);
                if (((this.strstart == 0) || (this.strstart >= _local_3)))
                {
                    this.lookahead = int((this.strstart - _local_3));
                    this.strstart = int(_local_3);
                    this.flush_block_only(false);
                    if (this.strm.avail_out == 0)
                    {
                        return (NeedMore);
                    };
                };
                if ((this.strstart - this.block_start) >= (this.w_size - MIN_LOOKAHEAD))
                {
                    this.flush_block_only(false);
                    if (this.strm.avail_out == 0)
                    {
                        return (NeedMore);
                    };
                };
            };
            this.flush_block_only((_arg_1 == Z_FINISH));
            if (this.strm.avail_out == 0)
            {
                return ((_arg_1 == Z_FINISH) ? FinishStarted : NeedMore);
            };
            return ((_arg_1 == Z_FINISH) ? FinishDone : BlockDone);
        }

        public function _tr_stored_block(_arg_1:int, _arg_2:int, _arg_3:Boolean):void
        {
            this.send_bits(((STORED_BLOCK << 1) + ((_arg_3) ? 1 : 0)), 3);
            this.copy_block(_arg_1, _arg_2, true);
        }

        internal function _tr_flush_block(_arg_1:int, _arg_2:int, _arg_3:Boolean):void
        {
            var _local_4:int;
            var _local_5:int;
            var _local_6:int;
            if (this.level > 0)
            {
                if (this.data_type == Z_UNKNOWN)
                {
                    this.set_data_type();
                };
                this.l_desc.build_tree(this);
                this.d_desc.build_tree(this);
                _local_6 = this.build_bl_tree();
                _local_4 = (((this.opt_len + 3) + 7) >>> 3);
                _local_5 = (((this.static_len + 3) + 7) >>> 3);
                if (_local_5 <= _local_4)
                {
                    _local_4 = _local_5;
                };
            }
            else
            {
                _local_4 = (_local_5 = (_arg_2 + 5));
            };
            if ((((_arg_2 + 4) <= _local_4) && (!(_arg_1 == -1))))
            {
                this._tr_stored_block(_arg_1, _arg_2, _arg_3);
            }
            else
            {
                if (_local_5 == _local_4)
                {
                    this.send_bits(((STATIC_TREES << 1) + ((_arg_3) ? 1 : 0)), 3);
                    this.compress_block(StaticTree.static_ltree, StaticTree.static_dtree);
                }
                else
                {
                    this.send_bits(((DYN_TREES << 1) + ((_arg_3) ? 1 : 0)), 3);
                    this.send_all_trees((this.l_desc.max_code + 1), (this.d_desc.max_code + 1), (_local_6 + 1));
                    this.compress_block(this.dyn_ltree, this.dyn_dtree);
                };
            };
            this.init_block();
            if (_arg_3)
            {
                this.bi_windup();
            };
        }

        internal function fill_window():void
        {
            var _local_1:int;
            var _local_2:int;
            var _local_3:int;
            var _local_4:int;
            do 
            {
                _local_4 = ((this.window_size - this.lookahead) - this.strstart);
                if ((((_local_4 == 0) && (this.strstart == 0)) && (this.lookahead == 0)))
                {
                    _local_4 = this.w_size;
                }
                else
                {
                    if (_local_4 == -1)
                    {
                        _local_4--;
                    }
                    else
                    {
                        if (this.strstart >= ((this.w_size + this.w_size) - MIN_LOOKAHEAD))
                        {
                            System.byteArrayCopy(this.window, this.w_size, this.window, 0, this.w_size);
                            this.match_start = (this.match_start - this.w_size);
                            this.strstart = (this.strstart - this.w_size);
                            this.block_start = (this.block_start - this.w_size);
                            _local_1 = this.hash_size;
                            _local_3 = _local_1;
                            do 
                            {
                                _local_2 = (this.head[--_local_3] & 0xFFFF);
                                this.head[_local_3] = ((_local_2 >= this.w_size) ? Cast.toShort((_local_2 - this.w_size)) : 0);
                            } while (--_local_1 != 0);
                            _local_1 = this.w_size;
                            _local_3 = _local_1;
                            do 
                            {
                                _local_2 = (this.prev[--_local_3] & 0xFFFF);
                                this.prev[_local_3] = ((_local_2 >= this.w_size) ? Cast.toShort((_local_2 - this.w_size)) : 0);
                            } while (--_local_1 != 0);
                            _local_4 = (_local_4 + this.w_size);
                        };
                    };
                };
                if (this.strm.avail_in == 0)
                {
                    return;
                };
                _local_1 = this.strm.read_buf(this.window, (this.strstart + this.lookahead), _local_4);
                this.lookahead = (this.lookahead + _local_1);
                if (this.lookahead >= MIN_MATCH)
                {
                    this.ins_h = (this.window[this.strstart] & 0xFF);
                    this.ins_h = (((this.ins_h << this.hash_shift) ^ (this.window[(this.strstart + 1)] & 0xFF)) & this.hash_mask);
                };
            } while (((this.lookahead < MIN_LOOKAHEAD) && (!(this.strm.avail_in == 0))));
        }

        public function deflate_fast(_arg_1:int):int
        {
            var _local_3:Boolean;
            var _local_2:int;
            while (true)
            {
                if (this.lookahead < MIN_LOOKAHEAD)
                {
                    this.fill_window();
                    if (((this.lookahead < MIN_LOOKAHEAD) && (_arg_1 == Z_NO_FLUSH)))
                    {
                        return (NeedMore);
                    };
                    if (this.lookahead == 0) break;
                };
                if (this.lookahead >= MIN_MATCH)
                {
                    this.ins_h = (((this.ins_h << this.hash_shift) ^ (this.window[(this.strstart + (MIN_MATCH - 1))] & 0xFF)) & this.hash_mask);
                    _local_2 = this.head[this.ins_h];
                    this.prev[(this.strstart & this.w_mask)] = this.head[this.ins_h];
                    this.head[this.ins_h] = Cast.toShort(this.strstart);
                };
                if (((!(_local_2 == 0)) && ((this.strstart - _local_2) <= (this.w_size - MIN_LOOKAHEAD))))
                {
                    if (this.strategy != Z_HUFFMAN_ONLY)
                    {
                        this.match_length = this.longest_match(_local_2);
                    };
                };
                if (this.match_length >= MIN_MATCH)
                {
                    _local_3 = this._tr_tally((this.strstart - this.match_start), (this.match_length - MIN_MATCH));
                    this.lookahead = (this.lookahead - this.match_length);
                    if (((this.match_length <= this.max_lazy_match) && (this.lookahead >= MIN_MATCH)))
                    {
                        this.match_length--;
                        do 
                        {
                            this.strstart++;
                            this.ins_h = (((this.ins_h << this.hash_shift) ^ (this.window[(this.strstart + (MIN_MATCH - 1))] & 0xFF)) & this.hash_mask);
                            _local_2 = (this.head[this.ins_h] & 0xFFFF);
                            this.prev[(this.strstart & this.w_mask)] = this.head[this.ins_h];
                            this.head[this.ins_h] = Cast.toShort(this.strstart);
                        } while (--this.match_length != 0);
                        this.strstart++;
                    }
                    else
                    {
                        this.strstart = (this.strstart + this.match_length);
                        this.match_length = 0;
                        this.ins_h = this.window[this.strstart];
                        this.ins_h = (((this.ins_h << this.hash_shift) ^ (this.window[(this.strstart + 1)] & 0xFF)) & this.hash_mask);
                    };
                }
                else
                {
                    _local_3 = this._tr_tally(0, (this.window[this.strstart] & 0xFF));
                    this.lookahead--;
                    this.strstart++;
                };
                if (_local_3)
                {
                    this.flush_block_only(false);
                    if (this.strm.avail_out == 0)
                    {
                        return (NeedMore);
                    };
                };
            };
            this.flush_block_only((_arg_1 == Z_FINISH));
            if (this.strm.avail_out == 0)
            {
                if (_arg_1 == Z_FINISH)
                {
                    return (FinishStarted);
                };
                return (NeedMore);
            };
            return ((_arg_1 == Z_FINISH) ? FinishDone : BlockDone);
        }

        public function deflate_slow(_arg_1:int):int
        {
            var _local_3:Boolean;
            var _local_4:int;
            var _local_2:int;
            while (true)
            {
                if (this.lookahead < MIN_LOOKAHEAD)
                {
                    this.fill_window();
                    if (((this.lookahead < MIN_LOOKAHEAD) && (_arg_1 == Z_NO_FLUSH)))
                    {
                        return (NeedMore);
                    };
                    if (this.lookahead == 0) break;
                };
                if (this.lookahead >= MIN_MATCH)
                {
                    this.ins_h = (((this.ins_h << this.hash_shift) ^ (this.window[(this.strstart + (MIN_MATCH - 1))] & 0xFF)) & this.hash_mask);
                    _local_2 = (this.head[this.ins_h] & 0xFFFF);
                    this.prev[(this.strstart & this.w_mask)] = this.head[this.ins_h];
                    this.head[this.ins_h] = Cast.toShort(this.strstart);
                };
                this.prev_length = this.match_length;
                this.prev_match = this.match_start;
                this.match_length = (MIN_MATCH - 1);
                if ((((!(_local_2 == 0)) && (this.prev_length < this.max_lazy_match)) && (((this.strstart - _local_2) & 0xFFFF) <= (this.w_size - MIN_LOOKAHEAD))))
                {
                    if (this.strategy != Z_HUFFMAN_ONLY)
                    {
                        this.match_length = this.longest_match(_local_2);
                    };
                    if (((this.match_length <= 5) && ((this.strategy == Z_FILTERED) || ((this.match_length == MIN_MATCH) && ((this.strstart - this.match_start) > 0x1000)))))
                    {
                        this.match_length = (MIN_MATCH - 1);
                    };
                };
                if (((this.prev_length >= MIN_MATCH) && (this.match_length <= this.prev_length)))
                {
                    _local_4 = ((this.strstart + this.lookahead) - MIN_MATCH);
                    _local_3 = this._tr_tally(((this.strstart - 1) - this.prev_match), (this.prev_length - MIN_MATCH));
                    this.lookahead = (this.lookahead - (this.prev_length - 1));
                    this.prev_length = (this.prev_length - 2);
                    do 
                    {
                        if (++this.strstart <= _local_4)
                        {
                            this.ins_h = (((this.ins_h << this.hash_shift) ^ (this.window[(this.strstart + (MIN_MATCH - 1))] & 0xFF)) & this.hash_mask);
                            _local_2 = (this.head[this.ins_h] & 0xFFFF);
                            this.prev[(this.strstart & this.w_mask)] = this.head[this.ins_h];
                            this.head[this.ins_h] = Cast.toShort(this.strstart);
                        };
                    } while (--this.prev_length != 0);
                    this.match_available = 0;
                    this.match_length = (MIN_MATCH - 1);
                    this.strstart++;
                    if (_local_3)
                    {
                        this.flush_block_only(false);
                        if (this.strm.avail_out == 0)
                        {
                            return (NeedMore);
                        };
                    };
                }
                else
                {
                    if (this.match_available != 0)
                    {
                        _local_3 = this._tr_tally(0, (this.window[(this.strstart - 1)] & 0xFF));
                        if (_local_3)
                        {
                            this.flush_block_only(false);
                        };
                        this.strstart++;
                        this.lookahead--;
                        if (this.strm.avail_out == 0)
                        {
                            return (NeedMore);
                        };
                    }
                    else
                    {
                        this.match_available = 1;
                        this.strstart++;
                        this.lookahead--;
                    };
                };
            };
            if (this.match_available != 0)
            {
                _local_3 = this._tr_tally(0, (this.window[(this.strstart - 1)] & 0xFF));
                this.match_available = 0;
            };
            this.flush_block_only((_arg_1 == Z_FINISH));
            if (this.strm.avail_out == 0)
            {
                if (_arg_1 == Z_FINISH)
                {
                    return (FinishStarted);
                };
                return (NeedMore);
            };
            return ((_arg_1 == Z_FINISH) ? FinishDone : BlockDone);
        }

        internal function longest_match(_arg_1:int):int
        {
            var _local_4:int;
            var _local_5:int;
            var _local_2:int = this.max_chain_length;
            var _local_3:int = this.strstart;
            var _local_6:int = this.prev_length;
            var _local_7:int = ((this.strstart > (this.w_size - MIN_LOOKAHEAD)) ? (this.strstart - (this.w_size - MIN_LOOKAHEAD)) : 0);
            var _local_8:int = this.nice_match;
            var _local_9:int = this.w_mask;
            var _local_10:int = (this.strstart + MAX_MATCH);
            var _local_11:uint = this.window[((_local_3 + _local_6) - 1)];
            var _local_12:uint = this.window[(_local_3 + _local_6)];
            if (this.prev_length >= this.good_match)
            {
                _local_2 = (_local_2 >> 2);
            };
            if (_local_8 > this.lookahead)
            {
                _local_8 = this.lookahead;
            };
            do 
            {
                _local_4 = _arg_1;
                if (!((((!(this.window[(_local_4 + _local_6)] == _local_12)) || (!(this.window[((_local_4 + _local_6) - 1)] == _local_11))) || (!(this.window[_local_4] == this.window[_local_3]))) || (!(this.window[++_local_4] == this.window[(_local_3 + 1)]))))
                {
                    _local_3 = (_local_3 + 2);
                    _local_4++;
                    do 
                    {
                    } while ((((((((((this.window[++_local_3] == this.window[++_local_4]) && (this.window[++_local_3] == this.window[++_local_4])) && (this.window[++_local_3] == this.window[++_local_4])) && (this.window[++_local_3] == this.window[++_local_4])) && (this.window[++_local_3] == this.window[++_local_4])) && (this.window[++_local_3] == this.window[++_local_4])) && (this.window[++_local_3] == this.window[++_local_4])) && (this.window[++_local_3] == this.window[++_local_4])) && (_local_3 < _local_10)));
                    _local_5 = (MAX_MATCH - int((_local_10 - _local_3)));
                    _local_3 = (_local_10 - MAX_MATCH);
                    if (_local_5 > _local_6)
                    {
                        this.match_start = _arg_1;
                        _local_6 = _local_5;
                        if (_local_5 >= _local_8) break;
                        _local_11 = this.window[((_local_3 + _local_6) - 1)];
                        _local_12 = this.window[(_local_3 + _local_6)];
                    };
                };
            } while ((((_arg_1 = (this.prev[(_arg_1 & _local_9)] & 0xFFFF)) > _local_7) && (!(--_local_2 == 0))));
            if (_local_6 <= this.lookahead)
            {
                return (_local_6);
            };
            return (this.lookahead);
        }

        public function deflateInitWithBits(_arg_1:ZStream, _arg_2:int, _arg_3:int):int
        {
            return (this.deflateInit2(_arg_1, _arg_2, Z_DEFLATED, _arg_3, DEF_MEM_LEVEL, Z_DEFAULT_STRATEGY));
        }

        public function deflateInit(_arg_1:ZStream, _arg_2:int):int
        {
            return (this.deflateInitWithBits(_arg_1, _arg_2, MAX_WBITS));
        }

        public function deflateInit2(_arg_1:ZStream, _arg_2:int, _arg_3:int, _arg_4:int, _arg_5:int, _arg_6:int):int
        {
            var _local_7:int;
            _arg_1.msg = null;
            if (_arg_2 == Z_DEFAULT_COMPRESSION)
            {
                _arg_2 = 6;
            };
            if (_arg_4 < 0)
            {
                _local_7 = 1;
                _arg_4 = -(_arg_4);
            };
            if ((((((((((_arg_5 < 1) || (_arg_5 > MAX_MEM_LEVEL)) || (!(_arg_3 == Z_DEFLATED))) || (_arg_4 < 9)) || (_arg_4 > 15)) || (_arg_2 < 0)) || (_arg_2 > 9)) || (_arg_6 < 0)) || (_arg_6 > Z_HUFFMAN_ONLY)))
            {
                return (Z_STREAM_ERROR);
            };
            _arg_1.dstate = Deflate(this);
            this.noheader = _local_7;
            this.w_bits = _arg_4;
            this.w_size = (1 << this.w_bits);
            this.w_mask = (this.w_size - 1);
            this.hash_bits = (_arg_5 + 7);
            this.hash_size = (1 << this.hash_bits);
            this.hash_mask = (this.hash_size - 1);
            this.hash_shift = (((this.hash_bits + MIN_MATCH) - 1) / MIN_MATCH);
            this.window = new ByteArray();
            this.prev = new Array();
            this.head = new Array();
            this.lit_bufsize = (1 << (_arg_5 + 6));
            this.pending_buf = new ByteArray();
            this.pending_buf_size = (this.lit_bufsize * 4);
            this.d_buf = (this.lit_bufsize / 2);
            this.l_buf = ((1 + 2) * this.lit_bufsize);
            this.level = _arg_2;
            this.strategy = _arg_6;
            this.method = _arg_3;
            return (this.deflateReset(_arg_1));
        }

        internal function deflateReset(_arg_1:ZStream):int
        {
            _arg_1.total_in = (_arg_1.total_out = 0);
            _arg_1.msg = null;
            _arg_1.data_type = Z_UNKNOWN;
            this.pending = 0;
            this.pending_out = 0;
            this.pending_buf = new ByteArray();
            if (this.noheader < 0)
            {
                this.noheader = 0;
            };
            this.status = ((this.noheader != 0) ? BUSY_STATE : INIT_STATE);
            _arg_1.adler = _arg_1._adler.adler32(0, null, 0, 0);
            this.last_flush = Z_NO_FLUSH;
            this.tr_init();
            this.lm_init();
            return (Z_OK);
        }

        internal function deflateEnd():int
        {
            if ((((!(this.status == INIT_STATE)) && (!(this.status == BUSY_STATE))) && (!(this.status == FINISH_STATE))))
            {
                return (Z_STREAM_ERROR);
            };
            this.pending_buf = null;
            this.head = null;
            this.prev = null;
            this.window = null;
            return ((this.status == BUSY_STATE) ? Z_DATA_ERROR : Z_OK);
        }

        internal function deflateParams(_arg_1:ZStream, _arg_2:int, _arg_3:int):int
        {
            var _local_4:int = Z_OK;
            if (_arg_2 == Z_DEFAULT_COMPRESSION)
            {
                _arg_2 = 6;
            };
            if (((((_arg_2 < 0) || (_arg_2 > 9)) || (_arg_3 < 0)) || (_arg_3 > Z_HUFFMAN_ONLY)))
            {
                return (Z_STREAM_ERROR);
            };
            if (((!(config_table[this.level].func == config_table[_arg_2].func)) && (!(_arg_1.total_in == 0))))
            {
                _local_4 = _arg_1.deflate(Z_PARTIAL_FLUSH);
            };
            if (this.level != _arg_2)
            {
                this.level = _arg_2;
                this.max_lazy_match = config_table[this.level].max_lazy;
                this.good_match = config_table[this.level].good_length;
                this.nice_match = config_table[this.level].nice_length;
                this.max_chain_length = config_table[this.level].max_chain;
            };
            this.strategy = _arg_3;
            return (_local_4);
        }

        internal function deflateSetDictionary(_arg_1:ZStream, _arg_2:ByteArray, _arg_3:int):int
        {
            var _local_4:int = _arg_3;
            var _local_5:int;
            if (((_arg_2 == null) || (!(this.status == INIT_STATE))))
            {
                return (Z_STREAM_ERROR);
            };
            _arg_1.adler = _arg_1._adler.adler32(_arg_1.adler, _arg_2, 0, _arg_3);
            if (_local_4 < MIN_MATCH)
            {
                return (Z_OK);
            };
            if (_local_4 > (this.w_size - MIN_LOOKAHEAD))
            {
                _local_4 = (this.w_size - MIN_LOOKAHEAD);
                _local_5 = (_arg_3 - _local_4);
            };
            System.byteArrayCopy(_arg_2, _local_5, this.window, 0, _local_4);
            this.strstart = _local_4;
            this.block_start = _local_4;
            this.ins_h = (this.window[0] & 0xFF);
            this.ins_h = (((this.ins_h << this.hash_shift) ^ (this.window[1] & 0xFF)) & this.hash_mask);
            var _local_6:int;
            while (_local_6 <= (_local_4 - MIN_MATCH))
            {
                this.ins_h = (((this.ins_h << this.hash_shift) ^ (this.window[(_local_6 + (MIN_MATCH - 1))] & 0xFF)) & this.hash_mask);
                this.prev[(_local_6 & this.w_mask)] = this.head[this.ins_h];
                this.head[this.ins_h] = Cast.toShort(_local_6);
                _local_6++;
            };
            return (Z_OK);
        }

        public function deflate(_arg_1:ZStream, _arg_2:int):int
        {
            var _local_3:int;
            var _local_4:int;
            var _local_5:int;
            var _local_6:int;
            var _local_7:int;
            if (((_arg_2 > Z_FINISH) || (_arg_2 < 0)))
            {
                return (Z_STREAM_ERROR);
            };
            if ((((_arg_1.next_out == null) || ((_arg_1.next_in == null) && (!(_arg_1.avail_in == 0)))) || ((this.status == FINISH_STATE) && (!(_arg_2 == Z_FINISH)))))
            {
                _arg_1.msg = this.z_errmsg[(Z_NEED_DICT - Z_STREAM_ERROR)];
                return (Z_STREAM_ERROR);
            };
            if (_arg_1.avail_out == 0)
            {
                _arg_1.msg = this.z_errmsg[(Z_NEED_DICT - Z_BUF_ERROR)];
                return (Z_BUF_ERROR);
            };
            this.strm = _arg_1;
            _local_3 = this.last_flush;
            this.last_flush = _arg_2;
            if (this.status == INIT_STATE)
            {
                _local_4 = ((Z_DEFLATED + ((this.w_bits - 8) << 4)) << 8);
                _local_5 = (((this.level - 1) & 0xFF) >> 1);
                if (_local_5 > 3)
                {
                    _local_5 = 3;
                };
                _local_4 = (_local_4 | (_local_5 << 6));
                if (this.strstart != 0)
                {
                    _local_4 = (_local_4 | PRESET_DICT);
                };
                _local_4 = (_local_4 + (31 - (_local_4 % 31)));
                this.status = BUSY_STATE;
                this.putShortMSB(_local_4);
                if (this.strstart != 0)
                {
                    this.putShortMSB(int((_arg_1.adler >>> 16)));
                    this.putShortMSB(int((_arg_1.adler & 0xFFFF)));
                };
                _arg_1.adler = _arg_1._adler.adler32(0, null, 0, 0);
            };
            if (this.pending != 0)
            {
                _arg_1.flush_pending();
                if (_arg_1.avail_out == 0)
                {
                    this.last_flush = -1;
                    return (Z_OK);
                };
            }
            else
            {
                if ((((_arg_1.avail_in == 0) && (_arg_2 <= _local_3)) && (!(_arg_2 == Z_FINISH))))
                {
                    _arg_1.msg = this.z_errmsg[(Z_NEED_DICT - Z_BUF_ERROR)];
                    return (Z_BUF_ERROR);
                };
            };
            if (((this.status == FINISH_STATE) && (!(_arg_1.avail_in == 0))))
            {
                _arg_1.msg = this.z_errmsg[(Z_NEED_DICT - Z_BUF_ERROR)];
                return (Z_BUF_ERROR);
            };
            if ((((!(_arg_1.avail_in == 0)) || (!(this.lookahead == 0))) || ((!(_arg_2 == Z_NO_FLUSH)) && (!(this.status == FINISH_STATE)))))
            {
                _local_6 = -1;
                switch (config_table[this.level].func)
                {
                    case STORED:
                        _local_6 = this.deflate_stored(_arg_2);
                        break;
                    case FAST:
                        _local_6 = this.deflate_fast(_arg_2);
                        break;
                    case SLOW:
                        _local_6 = this.deflate_slow(_arg_2);
                        break;
                };
                if (((_local_6 == FinishStarted) || (_local_6 == FinishDone)))
                {
                    this.status = FINISH_STATE;
                };
                if (((_local_6 == NeedMore) || (_local_6 == FinishStarted)))
                {
                    if (_arg_1.avail_out == 0)
                    {
                        this.last_flush = -1;
                    };
                    return (Z_OK);
                };
                if (_local_6 == BlockDone)
                {
                    if (_arg_2 == Z_PARTIAL_FLUSH)
                    {
                        this._tr_align();
                    }
                    else
                    {
                        this._tr_stored_block(0, 0, false);
                        if (_arg_2 == Z_FULL_FLUSH)
                        {
                            _local_7 = 0;
                            while (_local_7 < this.hash_size)
                            {
                                this.head[_local_7] = 0;
                                _local_7++;
                            };
                        };
                    };
                    _arg_1.flush_pending();
                    if (_arg_1.avail_out == 0)
                    {
                        this.last_flush = -1;
                        return (Z_OK);
                    };
                };
            };
            if (_arg_2 != Z_FINISH)
            {
                return (Z_OK);
            };
            if (this.noheader != 0)
            {
                return (Z_STREAM_END);
            };
            this.putShortMSB(int((_arg_1.adler >>> 16)));
            this.putShortMSB(int((_arg_1.adler & 0xFFFF)));
            _arg_1.flush_pending();
            this.noheader = -1;
            return ((!(this.pending == 0)) ? Z_OK : Z_STREAM_END);
        }


    }
}//package com.wirelust.as3zlib

