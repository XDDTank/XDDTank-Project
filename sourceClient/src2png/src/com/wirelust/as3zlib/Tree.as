// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//com.wirelust.as3zlib.Tree

package com.wirelust.as3zlib
{
    import com.wirelust.util.Cast;

    public final class Tree 
    {

        private static const MAX_BITS:int = 15;
        private static const BL_CODES:int = 19;
        private static const D_CODES:int = 30;
        private static const LITERALS:int = 0x0100;
        private static const LENGTH_CODES:int = 29;
        private static const L_CODES:int = ((LITERALS + 1) + LENGTH_CODES);//286
        private static const HEAP_SIZE:int = ((2 * L_CODES) + 1);//573
        public static const MAX_BL_BITS:int = 7;
        public static const END_BLOCK:int = 0x0100;
        public static const REP_3_6:int = 16;
        public static const REPZ_3_10:int = 17;
        public static const REPZ_11_138:int = 18;
        public static const extra_lbits:Array = new Array(0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 2, 2, 2, 2, 3, 3, 3, 3, 4, 4, 4, 4, 5, 5, 5, 5, 0);
        public static const extra_dbits:Array = new Array(0, 0, 0, 0, 1, 1, 2, 2, 3, 3, 4, 4, 5, 5, 6, 6, 7, 7, 8, 8, 9, 9, 10, 10, 11, 11, 12, 12, 13, 13);
        public static const extra_blbits:Array = new Array(0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 3, 7);
        public static const bl_order:Array = new Array(16, 17, 18, 0, 8, 7, 9, 6, 10, 5, 11, 4, 12, 3, 13, 2, 14, 1, 15);
        public static const Buf_size:int = (8 * 2);//16
        public static const DIST_CODE_LEN:int = 0x0200;
        public static const _dist_code:Array = new Array(0, 1, 2, 3, 4, 4, 5, 5, 6, 6, 6, 6, 7, 7, 7, 7, 8, 8, 8, 8, 8, 8, 8, 8, 9, 9, 9, 9, 9, 9, 9, 9, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 13, 13, 13, 13, 13, 13, 13, 13, 13, 13, 13, 13, 13, 13, 13, 13, 13, 13, 13, 13, 13, 13, 13, 13, 13, 13, 13, 13, 13, 13, 13, 13, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 0, 0, 16, 17, 18, 18, 19, 19, 20, 20, 20, 20, 21, 21, 21, 21, 22, 22, 22, 22, 22, 22, 22, 22, 23, 23, 23, 23, 23, 23, 23, 23, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 25, 25, 25, 25, 25, 25, 25, 25, 25, 25, 25, 25, 25, 25, 25, 25, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 27, 27, 27, 27, 27, 27, 27, 27, 27, 27, 27, 27, 27, 27, 27, 27, 27, 27, 27, 27, 27, 27, 27, 27, 27, 27, 27, 27, 27, 27, 27, 27, 28, 28, 28, 28, 28, 28, 28, 28, 28, 28, 28, 28, 28, 28, 28, 28, 28, 28, 28, 28, 28, 28, 28, 28, 28, 28, 28, 28, 28, 28, 28, 28, 28, 28, 28, 28, 28, 28, 28, 28, 28, 28, 28, 28, 28, 28, 28, 28, 28, 28, 28, 28, 28, 28, 28, 28, 28, 28, 28, 28, 28, 28, 28, 28, 29, 29, 29, 29, 29, 29, 29, 29, 29, 29, 29, 29, 29, 29, 29, 29, 29, 29, 29, 29, 29, 29, 29, 29, 29, 29, 29, 29, 29, 29, 29, 29, 29, 29, 29, 29, 29, 29, 29, 29, 29, 29, 29, 29, 29, 29, 29, 29, 29, 29, 29, 29, 29, 29, 29, 29, 29, 29, 29, 29, 29, 29, 29, 29);
        public static const _length_code:Array = new Array(0, 1, 2, 3, 4, 5, 6, 7, 8, 8, 9, 9, 10, 10, 11, 11, 12, 12, 12, 12, 13, 13, 13, 13, 14, 14, 14, 14, 15, 15, 15, 15, 16, 16, 16, 16, 16, 16, 16, 16, 17, 17, 17, 17, 17, 17, 17, 17, 18, 18, 18, 18, 18, 18, 18, 18, 19, 19, 19, 19, 19, 19, 19, 19, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 21, 21, 21, 21, 21, 21, 21, 21, 21, 21, 21, 21, 21, 21, 21, 21, 22, 22, 22, 22, 22, 22, 22, 22, 22, 22, 22, 22, 22, 22, 22, 22, 23, 23, 23, 23, 23, 23, 23, 23, 23, 23, 23, 23, 23, 23, 23, 23, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 25, 25, 25, 25, 25, 25, 25, 25, 25, 25, 25, 25, 25, 25, 25, 25, 25, 25, 25, 25, 25, 25, 25, 25, 25, 25, 25, 25, 25, 25, 25, 25, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 27, 27, 27, 27, 27, 27, 27, 27, 27, 27, 27, 27, 27, 27, 27, 27, 27, 27, 27, 27, 27, 27, 27, 27, 27, 27, 27, 27, 27, 27, 27, 28);
        public static const base_length:Array = new Array(0, 1, 2, 3, 4, 5, 6, 7, 8, 10, 12, 14, 16, 20, 24, 28, 32, 40, 48, 56, 64, 80, 96, 112, 128, 160, 192, 224, 0);
        public static const base_dist:Array = new Array(0, 1, 2, 3, 4, 6, 8, 12, 16, 24, 32, 48, 64, 96, 128, 192, 0x0100, 384, 0x0200, 0x0300, 0x0400, 0x0600, 0x0800, 0x0C00, 0x1000, 0x1800, 0x2000, 0x3000, 0x4000, 0x6000);

        public var dyn_tree:Array;
        public var max_code:int;
        public var stat_desc:StaticTree;


        public static function d_code(_arg_1:int):int
        {
            return ((_arg_1 < 0x0100) ? _dist_code[_arg_1] : _dist_code[(0x0100 + (_arg_1 >>> 7))]);
        }

        public static function gen_codes(_arg_1:Array, _arg_2:int, _arg_3:Array):void
        {
            var _local_6:int;
            var _local_7:int;
            var _local_8:int;
            var _local_4:Array = new Array();
            var _local_5:Number = 0;
            _local_6 = 1;
            while (_local_6 <= MAX_BITS)
            {
                _local_4[_local_6] = (_local_5 = ((_local_5 + _arg_3[(_local_6 - 1)]) << 1));
                _local_6++;
            };
            _local_7 = 0;
            while (_local_7 <= _arg_2)
            {
                _local_8 = _arg_1[((_local_7 * 2) + 1)];
                if (_local_8 != 0)
                {
                    _arg_1[(_local_7 * 2)] = bi_reverse(_local_4[_local_8]++, _local_8);
                };
                _local_7++;
            };
        }

        public static function bi_reverse(_arg_1:int, _arg_2:int):int
        {
            var _local_3:int;
            do 
            {
                _local_3 = (_local_3 | (_arg_1 & 0x01));
                _arg_1 = (_arg_1 >>> 1);
                _local_3 = (_local_3 << 1);
            } while (--_arg_2 > 0);
            return (_local_3 >>> 1);
        }


        public function gen_bitlen(_arg_1:Deflate):void
        {
            var _local_7:int;
            var _local_8:int;
            var _local_9:int;
            var _local_10:int;
            var _local_11:int;
            var _local_12:Number;
            var _local_2:Array = this.dyn_tree;
            var _local_3:Array = this.stat_desc.static_tree;
            var _local_4:Array = this.stat_desc.extra_bits;
            var _local_5:int = this.stat_desc.extra_base;
            var _local_6:int = this.stat_desc.max_length;
            var _local_13:int;
            _local_10 = 0;
            while (_local_10 <= MAX_BITS)
            {
                _arg_1.bl_count[_local_10] = 0;
                _local_10++;
            };
            _local_2[((_arg_1.heap[_arg_1.heap_max] * 2) + 1)] = 0;
            _local_7 = (_arg_1.heap_max + 1);
            while (_local_7 < HEAP_SIZE)
            {
                _local_8 = _arg_1.heap[_local_7];
                _local_10 = (_local_2[((_local_2[((_local_8 * 2) + 1)] * 2) + 1)] + 1);
                if (_local_10 > _local_6)
                {
                    _local_10 = _local_6;
                    _local_13++;
                };
                _local_2[((_local_8 * 2) + 1)] = Cast.toShort(_local_10);
                if (_local_8 <= this.max_code)
                {
                    _arg_1.bl_count[_local_10]++;
                    _local_11 = 0;
                    if (_local_8 >= _local_5)
                    {
                        _local_11 = _local_4[(_local_8 - _local_5)];
                    };
                    _local_12 = _local_2[(_local_8 * 2)];
                    _arg_1.opt_len = (_arg_1.opt_len + (_local_12 * (_local_10 + _local_11)));
                    if (_local_3 != null)
                    {
                        _arg_1.static_len = (_arg_1.static_len + (_local_12 * (_local_3[((_local_8 * 2) + 1)] + _local_11)));
                    };
                };
                _local_7++;
            };
            if (_local_13 == 0)
            {
                return;
            };
            do 
            {
                _local_10 = (_local_6 - 1);
                while (_arg_1.bl_count[_local_10] == 0)
                {
                    _local_10--;
                };
                _arg_1.bl_count[_local_10]--;
                _arg_1.bl_count[(_local_10 + 1)] = (_arg_1.bl_count[(_local_10 + 1)] + 2);
                _arg_1.bl_count[_local_6]--;
                _local_13 = (_local_13 - 2);
            } while (_local_13 > 0);
            _local_10 = _local_6;
            while (_local_10 != 0)
            {
                _local_8 = _arg_1.bl_count[_local_10];
                while (_local_8 != 0)
                {
                    _local_9 = _arg_1.heap[--_local_7];
                    if (_local_9 <= this.max_code)
                    {
                        if (_local_2[((_local_9 * 2) + 1)] != _local_10)
                        {
                            _arg_1.opt_len = (_arg_1.opt_len + ((_local_10 - _local_2[((_local_9 * 2) + 1)]) * _local_2[(_local_9 * 2)]));
                            _local_2[((_local_9 * 2) + 1)] = Cast.toShort(_local_10);
                        };
                        _local_8--;
                    };
                };
                _local_10--;
            };
        }

        public function build_tree(_arg_1:Deflate):void
        {
            var _local_5:int;
            var _local_6:int;
            var _local_8:int;
            var _local_2:Array = this.dyn_tree;
            var _local_3:Array = this.stat_desc.static_tree;
            var _local_4:int = this.stat_desc.elems;
            var _local_7:int = -1;
            _arg_1.heap_len = 0;
            _arg_1.heap_max = HEAP_SIZE;
            _local_5 = 0;
            while (_local_5 < _local_4)
            {
                if (_local_2[(_local_5 * 2)] != 0)
                {
                    var _local_9:* = ++_arg_1.heap_len;
                    _arg_1.heap[_local_9] = (_local_7 = _local_5);
                    _arg_1.depth[_local_5] = 0;
                }
                else
                {
                    _local_2[((_local_5 * 2) + 1)] = 0;
                };
                _local_5++;
            };
            while (_arg_1.heap_len < 2)
            {
                _local_9 = ++_arg_1.heap_len;
                _local_8 = (_arg_1.heap[_local_9] = ((_local_7 < 2) ? ++_local_7 : 0));
                _local_2[(_local_8 * 2)] = 1;
                _arg_1.depth[_local_8] = 0;
                _arg_1.opt_len--;
                if (_local_3 != null)
                {
                    _arg_1.static_len = (_arg_1.static_len - _local_3[((_local_8 * 2) + 1)]);
                };
            };
            this.max_code = _local_7;
            _local_5 = int((_arg_1.heap_len / 2));
            while (_local_5 >= 1)
            {
                _arg_1.pqdownheap(_local_2, _local_5);
                _local_5--;
            };
            _local_8 = _local_4;
            do 
            {
                _local_5 = _arg_1.heap[1];
                _arg_1.heap[1] = _arg_1.heap[_arg_1.heap_len--];
                _arg_1.pqdownheap(_local_2, 1);
                _local_6 = _arg_1.heap[1];
                _local_9 = --_arg_1.heap_max;
                _arg_1.heap[_local_9] = _local_5;
                var _local_10:* = --_arg_1.heap_max;
                _arg_1.heap[_local_10] = _local_6;
                _local_2[(_local_8 * 2)] = (_local_2[(_local_5 * 2)] + _local_2[(_local_6 * 2)]);
                _arg_1.depth[_local_8] = (Math.max(_arg_1.depth[_local_5], _arg_1.depth[_local_6]) + 1);
                _local_2[((_local_5 * 2) + 1)] = (_local_2[((_local_6 * 2) + 1)] = _local_8);
                _arg_1.heap[1] = _local_8++;
                _arg_1.pqdownheap(_local_2, 1);
            } while (_arg_1.heap_len >= 2);
            _local_9 = --_arg_1.heap_max;
            _arg_1.heap[_local_9] = _arg_1.heap[1];
            this.gen_bitlen(_arg_1);
            gen_codes(_local_2, _local_7, _arg_1.bl_count);
        }


    }
}//package com.wirelust.as3zlib

