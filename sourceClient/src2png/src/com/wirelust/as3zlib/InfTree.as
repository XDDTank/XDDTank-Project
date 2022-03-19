// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//com.wirelust.as3zlib.InfTree

package com.wirelust.as3zlib
{
    import com.wirelust.as3zlib.ZStream;
    import com.wirelust.as3zlib.System;
    import com.wirelust.as3zlib.*;

    internal final class InfTree 
    {

        private static const MANY:int = 1440;
        private static const Z_OK:int = 0;
        private static const Z_STREAM_END:int = 1;
        private static const Z_NEED_DICT:int = 2;
        private static const Z_ERRNO:int = -1;
        private static const Z_STREAM_ERROR:int = -2;
        private static const Z_DATA_ERROR:int = -3;
        private static const Z_MEM_ERROR:int = -4;
        private static const Z_BUF_ERROR:int = -5;
        private static const Z_VERSION_ERROR:int = -6;
        private static const fixed_bl:int = 9;
        private static const fixed_bd:int = 5;
        public static const fixed_tl:Array = new Array(96, 7, 0x0100, 0, 8, 80, 0, 8, 16, 84, 8, 115, 82, 7, 31, 0, 8, 112, 0, 8, 48, 0, 9, 192, 80, 7, 10, 0, 8, 96, 0, 8, 32, 0, 9, 160, 0, 8, 0, 0, 8, 128, 0, 8, 64, 0, 9, 224, 80, 7, 6, 0, 8, 88, 0, 8, 24, 0, 9, 144, 83, 7, 59, 0, 8, 120, 0, 8, 56, 0, 9, 208, 81, 7, 17, 0, 8, 104, 0, 8, 40, 0, 9, 176, 0, 8, 8, 0, 8, 136, 0, 8, 72, 0, 9, 240, 80, 7, 4, 0, 8, 84, 0, 8, 20, 85, 8, 227, 83, 7, 43, 0, 8, 116, 0, 8, 52, 0, 9, 200, 81, 7, 13, 0, 8, 100, 0, 8, 36, 0, 9, 168, 0, 8, 4, 0, 8, 132, 0, 8, 68, 0, 9, 232, 80, 7, 8, 0, 8, 92, 0, 8, 28, 0, 9, 152, 84, 7, 83, 0, 8, 124, 0, 8, 60, 0, 9, 216, 82, 7, 23, 0, 8, 108, 0, 8, 44, 0, 9, 184, 0, 8, 12, 0, 8, 140, 0, 8, 76, 0, 9, 248, 80, 7, 3, 0, 8, 82, 0, 8, 18, 85, 8, 163, 83, 7, 35, 0, 8, 114, 0, 8, 50, 0, 9, 196, 81, 7, 11, 0, 8, 98, 0, 8, 34, 0, 9, 164, 0, 8, 2, 0, 8, 130, 0, 8, 66, 0, 9, 228, 80, 7, 7, 0, 8, 90, 0, 8, 26, 0, 9, 148, 84, 7, 67, 0, 8, 122, 0, 8, 58, 0, 9, 212, 82, 7, 19, 0, 8, 106, 0, 8, 42, 0, 9, 180, 0, 8, 10, 0, 8, 138, 0, 8, 74, 0, 9, 244, 80, 7, 5, 0, 8, 86, 0, 8, 22, 192, 8, 0, 83, 7, 51, 0, 8, 118, 0, 8, 54, 0, 9, 204, 81, 7, 15, 0, 8, 102, 0, 8, 38, 0, 9, 172, 0, 8, 6, 0, 8, 134, 0, 8, 70, 0, 9, 236, 80, 7, 9, 0, 8, 94, 0, 8, 30, 0, 9, 156, 84, 7, 99, 0, 8, 126, 0, 8, 62, 0, 9, 220, 82, 7, 27, 0, 8, 110, 0, 8, 46, 0, 9, 188, 0, 8, 14, 0, 8, 142, 0, 8, 78, 0, 9, 252, 96, 7, 0x0100, 0, 8, 81, 0, 8, 17, 85, 8, 131, 82, 7, 31, 0, 8, 113, 0, 8, 49, 0, 9, 194, 80, 7, 10, 0, 8, 97, 0, 8, 33, 0, 9, 162, 0, 8, 1, 0, 8, 129, 0, 8, 65, 0, 9, 226, 80, 7, 6, 0, 8, 89, 0, 8, 25, 0, 9, 146, 83, 7, 59, 0, 8, 121, 0, 8, 57, 0, 9, 210, 81, 7, 17, 0, 8, 105, 0, 8, 41, 0, 9, 178, 0, 8, 9, 0, 8, 137, 0, 8, 73, 0, 9, 242, 80, 7, 4, 0, 8, 85, 0, 8, 21, 80, 8, 258, 83, 7, 43, 0, 8, 117, 0, 8, 53, 0, 9, 202, 81, 7, 13, 0, 8, 101, 0, 8, 37, 0, 9, 170, 0, 8, 5, 0, 8, 133, 0, 8, 69, 0, 9, 234, 80, 7, 8, 0, 8, 93, 0, 8, 29, 0, 9, 154, 84, 7, 83, 0, 8, 125, 0, 8, 61, 0, 9, 218, 82, 7, 23, 0, 8, 109, 0, 8, 45, 0, 9, 186, 0, 8, 13, 0, 8, 141, 0, 8, 77, 0, 9, 250, 80, 7, 3, 0, 8, 83, 0, 8, 19, 85, 8, 195, 83, 7, 35, 0, 8, 115, 0, 8, 51, 0, 9, 198, 81, 7, 11, 0, 8, 99, 0, 8, 35, 0, 9, 166, 0, 8, 3, 0, 8, 131, 0, 8, 67, 0, 9, 230, 80, 7, 7, 0, 8, 91, 0, 8, 27, 0, 9, 150, 84, 7, 67, 0, 8, 123, 0, 8, 59, 0, 9, 214, 82, 7, 19, 0, 8, 107, 0, 8, 43, 0, 9, 182, 0, 8, 11, 0, 8, 139, 0, 8, 75, 0, 9, 246, 80, 7, 5, 0, 8, 87, 0, 8, 23, 192, 8, 0, 83, 7, 51, 0, 8, 119, 0, 8, 55, 0, 9, 206, 81, 7, 15, 0, 8, 103, 0, 8, 39, 0, 9, 174, 0, 8, 7, 0, 8, 135, 0, 8, 71, 0, 9, 238, 80, 7, 9, 0, 8, 95, 0, 8, 31, 0, 9, 158, 84, 7, 99, 0, 8, 127, 0, 8, 63, 0, 9, 222, 82, 7, 27, 0, 8, 111, 0, 8, 47, 0, 9, 190, 0, 8, 15, 0, 8, 143, 0, 8, 79, 0, 9, 254, 96, 7, 0x0100, 0, 8, 80, 0, 8, 16, 84, 8, 115, 82, 7, 31, 0, 8, 112, 0, 8, 48, 0, 9, 193, 80, 7, 10, 0, 8, 96, 0, 8, 32, 0, 9, 161, 0, 8, 0, 0, 8, 128, 0, 8, 64, 0, 9, 225, 80, 7, 6, 0, 8, 88, 0, 8, 24, 0, 9, 145, 83, 7, 59, 0, 8, 120, 0, 8, 56, 0, 9, 209, 81, 7, 17, 0, 8, 104, 0, 8, 40, 0, 9, 177, 0, 8, 8, 0, 8, 136, 0, 8, 72, 0, 9, 241, 80, 7, 4, 0, 8, 84, 0, 8, 20, 85, 8, 227, 83, 7, 43, 0, 8, 116, 0, 8, 52, 0, 9, 201, 81, 7, 13, 0, 8, 100, 0, 8, 36, 0, 9, 169, 0, 8, 4, 0, 8, 132, 0, 8, 68, 0, 9, 233, 80, 7, 8, 0, 8, 92, 0, 8, 28, 0, 9, 153, 84, 7, 83, 0, 8, 124, 0, 8, 60, 0, 9, 217, 82, 7, 23, 0, 8, 108, 0, 8, 44, 0, 9, 185, 0, 8, 12, 0, 8, 140, 0, 8, 76, 0, 9, 249, 80, 7, 3, 0, 8, 82, 0, 8, 18, 85, 8, 163, 83, 7, 35, 0, 8, 114, 0, 8, 50, 0, 9, 197, 81, 7, 11, 0, 8, 98, 0, 8, 34, 0, 9, 165, 0, 8, 2, 0, 8, 130, 0, 8, 66, 0, 9, 229, 80, 7, 7, 0, 8, 90, 0, 8, 26, 0, 9, 149, 84, 7, 67, 0, 8, 122, 0, 8, 58, 0, 9, 213, 82, 7, 19, 0, 8, 106, 0, 8, 42, 0, 9, 181, 0, 8, 10, 0, 8, 138, 0, 8, 74, 0, 9, 245, 80, 7, 5, 0, 8, 86, 0, 8, 22, 192, 8, 0, 83, 7, 51, 0, 8, 118, 0, 8, 54, 0, 9, 205, 81, 7, 15, 0, 8, 102, 0, 8, 38, 0, 9, 173, 0, 8, 6, 0, 8, 134, 0, 8, 70, 0, 9, 237, 80, 7, 9, 0, 8, 94, 0, 8, 30, 0, 9, 157, 84, 7, 99, 0, 8, 126, 0, 8, 62, 0, 9, 221, 82, 7, 27, 0, 8, 110, 0, 8, 46, 0, 9, 189, 0, 8, 14, 0, 8, 142, 0, 8, 78, 0, 9, 253, 96, 7, 0x0100, 0, 8, 81, 0, 8, 17, 85, 8, 131, 82, 7, 31, 0, 8, 113, 0, 8, 49, 0, 9, 195, 80, 7, 10, 0, 8, 97, 0, 8, 33, 0, 9, 163, 0, 8, 1, 0, 8, 129, 0, 8, 65, 0, 9, 227, 80, 7, 6, 0, 8, 89, 0, 8, 25, 0, 9, 147, 83, 7, 59, 0, 8, 121, 0, 8, 57, 0, 9, 211, 81, 7, 17, 0, 8, 105, 0, 8, 41, 0, 9, 179, 0, 8, 9, 0, 8, 137, 0, 8, 73, 0, 9, 243, 80, 7, 4, 0, 8, 85, 0, 8, 21, 80, 8, 258, 83, 7, 43, 0, 8, 117, 0, 8, 53, 0, 9, 203, 81, 7, 13, 0, 8, 101, 0, 8, 37, 0, 9, 171, 0, 8, 5, 0, 8, 133, 0, 8, 69, 0, 9, 235, 80, 7, 8, 0, 8, 93, 0, 8, 29, 0, 9, 155, 84, 7, 83, 0, 8, 125, 0, 8, 61, 0, 9, 219, 82, 7, 23, 0, 8, 109, 0, 8, 45, 0, 9, 187, 0, 8, 13, 0, 8, 141, 0, 8, 77, 0, 9, 251, 80, 7, 3, 0, 8, 83, 0, 8, 19, 85, 8, 195, 83, 7, 35, 0, 8, 115, 0, 8, 51, 0, 9, 199, 81, 7, 11, 0, 8, 99, 0, 8, 35, 0, 9, 167, 0, 8, 3, 0, 8, 131, 0, 8, 67, 0, 9, 231, 80, 7, 7, 0, 8, 91, 0, 8, 27, 0, 9, 151, 84, 7, 67, 0, 8, 123, 0, 8, 59, 0, 9, 215, 82, 7, 19, 0, 8, 107, 0, 8, 43, 0, 9, 183, 0, 8, 11, 0, 8, 139, 0, 8, 75, 0, 9, 247, 80, 7, 5, 0, 8, 87, 0, 8, 23, 192, 8, 0, 83, 7, 51, 0, 8, 119, 0, 8, 55, 0, 9, 207, 81, 7, 15, 0, 8, 103, 0, 8, 39, 0, 9, 175, 0, 8, 7, 0, 8, 135, 0, 8, 71, 0, 9, 239, 80, 7, 9, 0, 8, 95, 0, 8, 31, 0, 9, 159, 84, 7, 99, 0, 8, 127, 0, 8, 63, 0, 9, 223, 82, 7, 27, 0, 8, 111, 0, 8, 47, 0, 9, 191, 0, 8, 15, 0, 8, 143, 0, 8, 79, 0, 9, 0xFF);
        public static const fixed_td:Array = new Array(80, 5, 1, 87, 5, 0x0101, 83, 5, 17, 91, 5, 4097, 81, 5, 5, 89, 5, 1025, 85, 5, 65, 93, 5, 16385, 80, 5, 3, 88, 5, 513, 84, 5, 33, 92, 5, 8193, 82, 5, 9, 90, 5, 2049, 86, 5, 129, 192, 5, 24577, 80, 5, 2, 87, 5, 385, 83, 5, 25, 91, 5, 6145, 81, 5, 7, 89, 5, 1537, 85, 5, 97, 93, 5, 24577, 80, 5, 4, 88, 5, 769, 84, 5, 49, 92, 5, 12289, 82, 5, 13, 90, 5, 3073, 86, 5, 193, 192, 5, 24577);
        public static const cplens:Array = new Array(3, 4, 5, 6, 7, 8, 9, 10, 11, 13, 15, 17, 19, 23, 27, 31, 35, 43, 51, 59, 67, 83, 99, 115, 131, 163, 195, 227, 258, 0, 0);
        public static const cplext:Array = new Array(0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 2, 2, 2, 2, 3, 3, 3, 3, 4, 4, 4, 4, 5, 5, 5, 5, 0, 112, 112);
        public static const cpdist:Array = new Array(1, 2, 3, 4, 5, 7, 9, 13, 17, 25, 33, 49, 65, 97, 129, 193, 0x0101, 385, 513, 769, 1025, 1537, 2049, 3073, 4097, 6145, 8193, 12289, 16385, 24577);
        public static const cpdext:Array = new Array(0, 0, 0, 0, 1, 1, 2, 2, 3, 3, 4, 4, 5, 5, 6, 6, 7, 7, 8, 8, 9, 9, 10, 10, 11, 11, 12, 12, 13, 13);
        public static const BMAX:int = 15;

        public var hn:Array = null;
        public var v:Array = null;
        public var c:Array = null;
        public var r:Array = null;
        public var u:Array = null;
        public var x:Array = null;


        public static function inflate_trees_fixed(_arg_1:Array, _arg_2:Array, _arg_3:Array, _arg_4:Array, _arg_5:ZStream):int
        {
            _arg_1[0] = fixed_bl;
            _arg_2[0] = fixed_bd;
            _arg_3[0] = fixed_tl;
            _arg_4[0] = fixed_td;
            return (Z_OK);
        }


        private function huft_build(_arg_1:Array, _arg_2:int, _arg_3:int, _arg_4:int, _arg_5:Array, _arg_6:Array, _arg_7:Array, _arg_8:Array, _arg_9:Array, _arg_10:Array, _arg_11:Array):int
        {
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
            var _local_25:int;
            var _local_26:int;
            _local_21 = 0;
            _local_16 = _arg_3;
            do 
            {
                this.c[_arg_1[(_arg_2 + _local_21)]]++;
                _local_21++;
                _local_16--;
            } while (_local_16 != 0);
            if (this.c[0] == _arg_3)
            {
                _arg_7[0] = -1;
                _arg_8[0] = 0;
                return (Z_OK);
            };
            _local_19 = _arg_8[0];
            _local_17 = 1;
            while (_local_17 <= BMAX)
            {
                if (this.c[_local_17] != 0) break;
                _local_17++;
            };
            _local_18 = _local_17;
            if (_local_19 < _local_17)
            {
                _local_19 = _local_17;
            };
            _local_16 = BMAX;
            while (_local_16 != 0)
            {
                if (this.c[_local_16] != 0) break;
                _local_16--;
            };
            _local_14 = _local_16;
            if (_local_19 > _local_16)
            {
                _local_19 = _local_16;
            };
            _arg_8[0] = _local_19;
            _local_25 = (1 << _local_17);
            while (_local_17 < _local_16)
            {
                if ((_local_25 = (_local_25 - this.c[_local_17])) < 0)
                {
                    return (Z_DATA_ERROR);
                };
                _local_17++;
                _local_25 = (_local_25 << 1);
            };
            if ((_local_25 = (_local_25 - this.c[_local_16])) < 0)
            {
                return (Z_DATA_ERROR);
            };
            this.c[_local_16] = (this.c[_local_16] + _local_25);
            this.x[1] = (_local_17 = 0);
            _local_21 = 1;
            _local_24 = 2;
            while (--_local_16 != 0)
            {
                this.x[_local_24] = (_local_17 = (_local_17 + this.c[_local_21]));
                _local_24++;
                _local_21++;
            };
            _local_16 = 0;
            _local_21 = 0;
            do 
            {
                if ((_local_17 = _arg_1[(_arg_2 + _local_21)]) != 0)
                {
                    var _local_27:* = this.x[_local_17]++;
                    _arg_11[_local_27] = _local_16;
                };
                _local_21++;
            } while (++_local_16 < _arg_3);
            _arg_3 = this.x[_local_14];
            this.x[0] = (_local_16 = 0);
            _local_21 = 0;
            _local_15 = -1;
            _local_23 = -(_local_19);
            this.u[0] = 0;
            _local_22 = 0;
            _local_26 = 0;
            while (_local_18 <= _local_14)
            {
                _local_12 = this.c[_local_18];
                while (_local_12-- != 0)
                {
                    while (_local_18 > (_local_23 + _local_19))
                    {
                        _local_15++;
                        _local_23 = (_local_23 + _local_19);
                        _local_26 = (_local_14 - _local_23);
                        _local_26 = ((_local_26 > _local_19) ? _local_19 : _local_26);
                        if ((_local_13 = (1 << (_local_17 = (_local_18 - _local_23)))) > (_local_12 + 1))
                        {
                            _local_13 = (_local_13 - (_local_12 + 1));
                            _local_24 = _local_18;
                            if (_local_17 < _local_26)
                            {
                                while (++_local_17 < _local_26)
                                {
                                    if ((_local_13 = (_local_13 << 1)) <= this.c[++_local_24]) break;
                                    _local_13 = (_local_13 - this.c[_local_24]);
                                };
                            };
                        };
                        _local_26 = (1 << _local_17);
                        if ((_arg_10[0] + _local_26) > MANY)
                        {
                            return (Z_DATA_ERROR);
                        };
                        this.u[_local_15] = (_local_22 = _arg_10[0]);
                        _arg_10[0] = (_arg_10[0] + _local_26);
                        if (_local_15 != 0)
                        {
                            this.x[_local_15] = _local_16;
                            this.r[0] = _local_17;
                            this.r[1] = _local_19;
                            _local_17 = (_local_16 >>> (_local_23 - _local_19));
                            this.r[2] = int(((_local_22 - this.u[(_local_15 - 1)]) - _local_17));
                            System.arrayCopy(this.r, 0, _arg_9, ((this.u[(_local_15 - 1)] + _local_17) * 3), 3);
                        }
                        else
                        {
                            _arg_7[0] = _local_22;
                        };
                    };
                    this.r[1] = (_local_18 - _local_23);
                    if (_local_21 >= _arg_3)
                    {
                        this.r[0] = (128 + 64);
                    }
                    else
                    {
                        if (_arg_11[_local_21] < _arg_4)
                        {
                            this.r[0] = ((_arg_11[_local_21] < 0x0100) ? 0 : (32 + 64));
                            this.r[2] = _arg_11[_local_21++];
                        }
                        else
                        {
                            this.r[0] = ((_arg_6[(_arg_11[_local_21] - _arg_4)] + 16) + 64);
                            this.r[2] = _arg_5[(_arg_11[_local_21++] - _arg_4)];
                        };
                    };
                    _local_13 = (1 << (_local_18 - _local_23));
                    _local_17 = (_local_16 >>> _local_23);
                    while (_local_17 < _local_26)
                    {
                        System.arrayCopy(this.r, 0, _arg_9, ((_local_22 + _local_17) * 3), 3);
                        _local_17 = (_local_17 + _local_13);
                    };
                    _local_17 = (1 << (_local_18 - 1));
                    while ((_local_16 & _local_17) != 0)
                    {
                        _local_16 = (_local_16 ^ _local_17);
                        _local_17 = (_local_17 >>> 1);
                    };
                    _local_16 = (_local_16 ^ _local_17);
                    _local_20 = ((1 << _local_23) - 1);
                    while ((_local_16 & _local_20) != this.x[_local_15])
                    {
                        _local_15--;
                        _local_23 = (_local_23 - _local_19);
                        _local_20 = ((1 << _local_23) - 1);
                    };
                };
                _local_18++;
            };
            return (((!(_local_25 == 0)) && (!(_local_14 == 1))) ? Z_BUF_ERROR : Z_OK);
        }

        public function inflate_trees_bits(_arg_1:Array, _arg_2:Array, _arg_3:Array, _arg_4:Array, _arg_5:ZStream):int
        {
            var _local_6:int;
            this.initWorkArea(19);
            this.hn[0] = 0;
            _local_6 = this.huft_build(_arg_1, 0, 19, 19, null, null, _arg_3, _arg_2, _arg_4, this.hn, this.v);
            if (_local_6 == Z_DATA_ERROR)
            {
                _arg_5.msg = "oversubscribed dynamic bit lengths tree";
            }
            else
            {
                if (((_local_6 == Z_BUF_ERROR) || (_arg_2[0] == 0)))
                {
                    _arg_5.msg = "incomplete dynamic bit lengths tree";
                    _local_6 = Z_DATA_ERROR;
                };
            };
            return (_local_6);
        }

        public function inflate_trees_dynamic(_arg_1:int, _arg_2:int, _arg_3:Array, _arg_4:Array, _arg_5:Array, _arg_6:Array, _arg_7:Array, _arg_8:Array, _arg_9:ZStream):int
        {
            var _local_10:int;
            this.initWorkArea(288);
            this.hn[0] = 0;
            _local_10 = this.huft_build(_arg_3, 0, _arg_1, 0x0101, cplens, cplext, _arg_6, _arg_4, _arg_8, this.hn, this.v);
            if (((!(_local_10 == Z_OK)) || (_arg_4[0] == 0)))
            {
                if (_local_10 == Z_DATA_ERROR)
                {
                    _arg_9.msg = "oversubscribed literal/length tree";
                }
                else
                {
                    if (_local_10 != Z_MEM_ERROR)
                    {
                        _arg_9.msg = "incomplete literal/length tree";
                        _local_10 = Z_DATA_ERROR;
                    };
                };
                return (_local_10);
            };
            this.initWorkArea(288);
            _local_10 = this.huft_build(_arg_3, _arg_1, _arg_2, 0, cpdist, cpdext, _arg_7, _arg_5, _arg_8, this.hn, this.v);
            if (((!(_local_10 == Z_OK)) || ((_arg_5[0] == 0) && (_arg_1 > 0x0101))))
            {
                if (_local_10 == Z_DATA_ERROR)
                {
                    _arg_9.msg = "oversubscribed distance tree";
                }
                else
                {
                    if (_local_10 == Z_BUF_ERROR)
                    {
                        _arg_9.msg = "incomplete distance tree";
                        _local_10 = Z_DATA_ERROR;
                    }
                    else
                    {
                        if (_local_10 != Z_MEM_ERROR)
                        {
                            _arg_9.msg = "empty distance tree with lengths";
                            _local_10 = Z_DATA_ERROR;
                        };
                    };
                };
                return (_local_10);
            };
            return (Z_OK);
        }

        private function initWorkArea(_arg_1:int):void
        {
            var _local_2:int;
            if (this.hn == null)
            {
                this.hn = new Array();
                this.v = new Array();
                this.c = new Array();
                this.r = new Array();
                this.u = new Array();
                this.x = new Array();
            };
            if (this.v.length < _arg_1)
            {
                this.v = new Array();
            };
            _local_2 = 0;
            while (_local_2 < _arg_1)
            {
                this.v[_local_2] = 0;
                _local_2++;
            };
            _local_2 = 0;
            while (_local_2 < (BMAX + 1))
            {
                this.c[_local_2] = 0;
                _local_2++;
            };
            _local_2 = 0;
            while (_local_2 < 3)
            {
                this.r[_local_2] = 0;
                _local_2++;
            };
            System.arrayCopy(this.c, 0, this.u, 0, BMAX);
            System.arrayCopy(this.c, 0, this.x, 0, (BMAX + 1));
        }


    }
}//package com.wirelust.as3zlib

