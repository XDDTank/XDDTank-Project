// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//socialContact.copyBitmap.JPGEncoder

package socialContact.copyBitmap
{
    import flash.utils.ByteArray;
    import flash.display.BitmapData;
    import flash.display.*;
    import flash.utils.*;

    public class JPGEncoder 
    {

        private var ZigZag:Array = [0, 1, 5, 6, 14, 15, 27, 28, 2, 4, 7, 13, 16, 26, 29, 42, 3, 8, 12, 17, 25, 30, 41, 43, 9, 11, 18, 24, 31, 40, 44, 53, 10, 19, 23, 32, 39, 45, 52, 54, 20, 22, 33, 38, 46, 51, 55, 60, 21, 34, 37, 47, 50, 56, 59, 61, 35, 36, 48, 49, 57, 58, 62, 63];
        private var YTable:Array = new Array(64);
        private var UVTable:Array = new Array(64);
        private var fdtbl_Y:Array = new Array(64);
        private var fdtbl_UV:Array = new Array(64);
        private var YDC_HT:Array;
        private var UVDC_HT:Array;
        private var YAC_HT:Array;
        private var UVAC_HT:Array;
        private var std_dc_luminance_nrcodes:Array = [0, 0, 1, 5, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0];
        private var std_dc_luminance_values:Array = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11];
        private var std_ac_luminance_nrcodes:Array = [0, 0, 2, 1, 3, 3, 2, 4, 3, 5, 5, 4, 4, 0, 0, 1, 125];
        private var std_ac_luminance_values:Array = [1, 2, 3, 0, 4, 17, 5, 18, 33, 49, 65, 6, 19, 81, 97, 7, 34, 113, 20, 50, 129, 145, 161, 8, 35, 66, 177, 193, 21, 82, 209, 240, 36, 51, 98, 114, 130, 9, 10, 22, 23, 24, 25, 26, 37, 38, 39, 40, 41, 42, 52, 53, 54, 55, 56, 57, 58, 67, 68, 69, 70, 71, 72, 73, 74, 83, 84, 85, 86, 87, 88, 89, 90, 99, 100, 101, 102, 103, 104, 105, 106, 115, 116, 117, 118, 119, 120, 121, 122, 131, 132, 133, 134, 135, 136, 137, 138, 146, 147, 148, 149, 150, 151, 152, 153, 154, 162, 163, 164, 165, 166, 167, 168, 169, 170, 178, 179, 180, 181, 182, 183, 184, 185, 186, 194, 195, 196, 197, 198, 199, 200, 201, 202, 210, 211, 212, 213, 214, 215, 216, 217, 218, 225, 226, 227, 228, 229, 230, 231, 232, 233, 234, 241, 242, 243, 244, 245, 246, 247, 248, 249, 250];
        private var std_dc_chrominance_nrcodes:Array = [0, 0, 3, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0];
        private var std_dc_chrominance_values:Array = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11];
        private var std_ac_chrominance_nrcodes:Array = [0, 0, 2, 1, 2, 4, 4, 3, 4, 7, 5, 4, 4, 0, 1, 2, 119];
        private var std_ac_chrominance_values:Array = [0, 1, 2, 3, 17, 4, 5, 33, 49, 6, 18, 65, 81, 7, 97, 113, 19, 34, 50, 129, 8, 20, 66, 145, 161, 177, 193, 9, 35, 51, 82, 240, 21, 98, 114, 209, 10, 22, 36, 52, 225, 37, 241, 23, 24, 25, 26, 38, 39, 40, 41, 42, 53, 54, 55, 56, 57, 58, 67, 68, 69, 70, 71, 72, 73, 74, 83, 84, 85, 86, 87, 88, 89, 90, 99, 100, 101, 102, 103, 104, 105, 106, 115, 116, 117, 118, 119, 120, 121, 122, 130, 131, 132, 133, 134, 135, 136, 137, 138, 146, 147, 148, 149, 150, 151, 152, 153, 154, 162, 163, 164, 165, 166, 167, 168, 169, 170, 178, 179, 180, 181, 182, 183, 184, 185, 186, 194, 195, 196, 197, 198, 199, 200, 201, 202, 210, 211, 212, 213, 214, 215, 216, 217, 218, 226, 227, 228, 229, 230, 231, 232, 233, 234, 242, 243, 244, 245, 246, 247, 248, 249, 250];
        private var bitcode:Array = new Array(0xFFFF);
        private var category:Array = new Array(0xFFFF);
        private var byteout:ByteArray;
        private var bytenew:int = 0;
        private var bytepos:int = 7;
        private var DU:Array = new Array(64);
        private var YDU:Array = new Array(64);
        private var UDU:Array = new Array(64);
        private var VDU:Array = new Array(64);

        public function JPGEncoder(_arg_1:Number=50)
        {
            if (_arg_1 <= 0)
            {
                _arg_1 = 1;
            };
            if (_arg_1 > 100)
            {
                _arg_1 = 100;
            };
            var _local_2:int;
            if (_arg_1 < 50)
            {
                _local_2 = int(int((5000 / _arg_1)));
            }
            else
            {
                _local_2 = int((200 - (_arg_1 * 2)));
            };
            this.initHuffmanTbl();
            this.initCategoryNumber();
            this.initQuantTables(_local_2);
        }

        private function initQuantTables(_arg_1:int):void
        {
            var _local_2:int;
            var _local_3:Number;
            var _local_8:int;
            var _local_4:Array = [16, 11, 10, 16, 24, 40, 51, 61, 12, 12, 14, 19, 26, 58, 60, 55, 14, 13, 16, 24, 40, 57, 69, 56, 14, 17, 22, 29, 51, 87, 80, 62, 18, 22, 37, 56, 68, 109, 103, 77, 24, 35, 55, 64, 81, 104, 113, 92, 49, 64, 78, 87, 103, 121, 120, 101, 72, 92, 95, 98, 112, 100, 103, 99];
            _local_2 = 0;
            while (_local_2 < 64)
            {
                _local_3 = Math.floor((((_local_4[_local_2] * _arg_1) + 50) / 100));
                if (_local_3 < 1)
                {
                    _local_3 = 1;
                }
                else
                {
                    if (_local_3 > 0xFF)
                    {
                        _local_3 = 0xFF;
                    };
                };
                this.YTable[this.ZigZag[_local_2]] = _local_3;
                _local_2++;
            };
            var _local_5:Array = [17, 18, 24, 47, 99, 99, 99, 99, 18, 21, 26, 66, 99, 99, 99, 99, 24, 26, 56, 99, 99, 99, 99, 99, 47, 66, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99];
            _local_2 = 0;
            while (_local_2 < 64)
            {
                _local_3 = Math.floor((((_local_5[_local_2] * _arg_1) + 50) / 100));
                if (_local_3 < 1)
                {
                    _local_3 = 1;
                }
                else
                {
                    if (_local_3 > 0xFF)
                    {
                        _local_3 = 0xFF;
                    };
                };
                this.UVTable[this.ZigZag[_local_2]] = _local_3;
                _local_2++;
            };
            var _local_6:Array = [1, 1.387039845, 1.306562965, 1.175875602, 1, 0.785694958, 0.5411961, 0.275899379];
            _local_2 = 0;
            var _local_7:int;
            while (_local_7 < 8)
            {
                _local_8 = 0;
                while (_local_8 < 8)
                {
                    this.fdtbl_Y[_local_2] = (1 / (((this.YTable[this.ZigZag[_local_2]] * _local_6[_local_7]) * _local_6[_local_8]) * 8));
                    this.fdtbl_UV[_local_2] = (1 / (((this.UVTable[this.ZigZag[_local_2]] * _local_6[_local_7]) * _local_6[_local_8]) * 8));
                    _local_2++;
                    _local_8++;
                };
                _local_7++;
            };
        }

        private function computeHuffmanTbl(_arg_1:Array, _arg_2:Array):Array
        {
            var _local_7:int;
            var _local_3:int;
            var _local_4:int;
            var _local_5:Array = new Array();
            var _local_6:int = 1;
            while (_local_6 <= 16)
            {
                _local_7 = 1;
                while (_local_7 <= _arg_1[_local_6])
                {
                    _local_5[_arg_2[_local_4]] = new BitString();
                    _local_5[_arg_2[_local_4]].val = _local_3;
                    _local_5[_arg_2[_local_4]].len = _local_6;
                    _local_4++;
                    _local_3++;
                    _local_7++;
                };
                _local_3 = (_local_3 * 2);
                _local_6++;
            };
            return (_local_5);
        }

        private function initHuffmanTbl():void
        {
            this.YDC_HT = this.computeHuffmanTbl(this.std_dc_luminance_nrcodes, this.std_dc_luminance_values);
            this.UVDC_HT = this.computeHuffmanTbl(this.std_dc_chrominance_nrcodes, this.std_dc_chrominance_values);
            this.YAC_HT = this.computeHuffmanTbl(this.std_ac_luminance_nrcodes, this.std_ac_luminance_values);
            this.UVAC_HT = this.computeHuffmanTbl(this.std_ac_chrominance_nrcodes, this.std_ac_chrominance_values);
        }

        private function initCategoryNumber():void
        {
            var _local_3:int;
            var _local_1:int = 1;
            var _local_2:int = 2;
            var _local_4:int = 1;
            while (_local_4 <= 15)
            {
                _local_3 = _local_1;
                while (_local_3 < _local_2)
                {
                    this.category[(32767 + _local_3)] = _local_4;
                    this.bitcode[(32767 + _local_3)] = new BitString();
                    this.bitcode[(32767 + _local_3)].len = _local_4;
                    this.bitcode[(32767 + _local_3)].val = _local_3;
                    _local_3++;
                };
                _local_3 = -(_local_2 - 1);
                while (_local_3 <= -(_local_1))
                {
                    this.category[(32767 + _local_3)] = _local_4;
                    this.bitcode[(32767 + _local_3)] = new BitString();
                    this.bitcode[(32767 + _local_3)].len = _local_4;
                    this.bitcode[(32767 + _local_3)].val = ((_local_2 - 1) + _local_3);
                    _local_3++;
                };
                _local_1 = (_local_1 << 1);
                _local_2 = (_local_2 << 1);
                _local_4++;
            };
        }

        private function writeBits(_arg_1:BitString):void
        {
            var _local_2:int = _arg_1.val;
            var _local_3:int = (_arg_1.len - 1);
            while (_local_3 >= 0)
            {
                if ((_local_2 & uint((1 << _local_3))))
                {
                    this.bytenew = (this.bytenew | uint((1 << this.bytepos)));
                };
                _local_3--;
                this.bytepos--;
                if (this.bytepos < 0)
                {
                    if (this.bytenew == 0xFF)
                    {
                        this.writeByte(0xFF);
                        this.writeByte(0);
                    }
                    else
                    {
                        this.writeByte(this.bytenew);
                    };
                    this.bytepos = 7;
                    this.bytenew = 0;
                };
            };
        }

        private function writeByte(_arg_1:int):void
        {
            this.byteout.writeByte(_arg_1);
        }

        private function writeWord(_arg_1:int):void
        {
            this.writeByte(((_arg_1 >> 8) & 0xFF));
            this.writeByte((_arg_1 & 0xFF));
        }

        private function fDCTQuant(_arg_1:Array, _arg_2:Array):Array
        {
            var _local_3:Number;
            var _local_4:Number;
            var _local_5:Number;
            var _local_6:Number;
            var _local_7:Number;
            var _local_8:Number;
            var _local_9:Number;
            var _local_10:Number;
            var _local_11:Number;
            var _local_12:Number;
            var _local_13:Number;
            var _local_14:Number;
            var _local_15:Number;
            var _local_16:Number;
            var _local_17:Number;
            var _local_18:Number;
            var _local_19:Number;
            var _local_20:Number;
            var _local_21:Number;
            var _local_22:int;
            var _local_23:int;
            _local_22 = 0;
            while (_local_22 < 8)
            {
                _local_3 = (_arg_1[(_local_23 + 0)] + _arg_1[(_local_23 + 7)]);
                _local_10 = (_arg_1[(_local_23 + 0)] - _arg_1[(_local_23 + 7)]);
                _local_4 = (_arg_1[(_local_23 + 1)] + _arg_1[(_local_23 + 6)]);
                _local_9 = (_arg_1[(_local_23 + 1)] - _arg_1[(_local_23 + 6)]);
                _local_5 = (_arg_1[(_local_23 + 2)] + _arg_1[(_local_23 + 5)]);
                _local_8 = (_arg_1[(_local_23 + 2)] - _arg_1[(_local_23 + 5)]);
                _local_6 = (_arg_1[(_local_23 + 3)] + _arg_1[(_local_23 + 4)]);
                _local_7 = (_arg_1[(_local_23 + 3)] - _arg_1[(_local_23 + 4)]);
                _local_11 = (_local_3 + _local_6);
                _local_14 = (_local_3 - _local_6);
                _local_12 = (_local_4 + _local_5);
                _local_13 = (_local_4 - _local_5);
                _arg_1[(_local_23 + 0)] = (_local_11 + _local_12);
                _arg_1[(_local_23 + 4)] = (_local_11 - _local_12);
                _local_15 = ((_local_13 + _local_14) * 0.707106781);
                _arg_1[(_local_23 + 2)] = (_local_14 + _local_15);
                _arg_1[(_local_23 + 6)] = (_local_14 - _local_15);
                _local_11 = (_local_7 + _local_8);
                _local_12 = (_local_8 + _local_9);
                _local_13 = (_local_9 + _local_10);
                _local_19 = ((_local_11 - _local_13) * 0.382683433);
                _local_16 = ((0.5411961 * _local_11) + _local_19);
                _local_18 = ((1.306562965 * _local_13) + _local_19);
                _local_17 = (_local_12 * 0.707106781);
                _local_20 = (_local_10 + _local_17);
                _local_21 = (_local_10 - _local_17);
                _arg_1[(_local_23 + 5)] = (_local_21 + _local_16);
                _arg_1[(_local_23 + 3)] = (_local_21 - _local_16);
                _arg_1[(_local_23 + 1)] = (_local_20 + _local_18);
                _arg_1[(_local_23 + 7)] = (_local_20 - _local_18);
                _local_23 = (_local_23 + 8);
                _local_22++;
            };
            _local_23 = 0;
            _local_22 = 0;
            while (_local_22 < 8)
            {
                _local_3 = (_arg_1[(_local_23 + 0)] + _arg_1[(_local_23 + 56)]);
                _local_10 = (_arg_1[(_local_23 + 0)] - _arg_1[(_local_23 + 56)]);
                _local_4 = (_arg_1[(_local_23 + 8)] + _arg_1[(_local_23 + 48)]);
                _local_9 = (_arg_1[(_local_23 + 8)] - _arg_1[(_local_23 + 48)]);
                _local_5 = (_arg_1[(_local_23 + 16)] + _arg_1[(_local_23 + 40)]);
                _local_8 = (_arg_1[(_local_23 + 16)] - _arg_1[(_local_23 + 40)]);
                _local_6 = (_arg_1[(_local_23 + 24)] + _arg_1[(_local_23 + 32)]);
                _local_7 = (_arg_1[(_local_23 + 24)] - _arg_1[(_local_23 + 32)]);
                _local_11 = (_local_3 + _local_6);
                _local_14 = (_local_3 - _local_6);
                _local_12 = (_local_4 + _local_5);
                _local_13 = (_local_4 - _local_5);
                _arg_1[(_local_23 + 0)] = (_local_11 + _local_12);
                _arg_1[(_local_23 + 32)] = (_local_11 - _local_12);
                _local_15 = ((_local_13 + _local_14) * 0.707106781);
                _arg_1[(_local_23 + 16)] = (_local_14 + _local_15);
                _arg_1[(_local_23 + 48)] = (_local_14 - _local_15);
                _local_11 = (_local_7 + _local_8);
                _local_12 = (_local_8 + _local_9);
                _local_13 = (_local_9 + _local_10);
                _local_19 = ((_local_11 - _local_13) * 0.382683433);
                _local_16 = ((0.5411961 * _local_11) + _local_19);
                _local_18 = ((1.306562965 * _local_13) + _local_19);
                _local_17 = (_local_12 * 0.707106781);
                _local_20 = (_local_10 + _local_17);
                _local_21 = (_local_10 - _local_17);
                _arg_1[(_local_23 + 40)] = (_local_21 + _local_16);
                _arg_1[(_local_23 + 24)] = (_local_21 - _local_16);
                _arg_1[(_local_23 + 8)] = (_local_20 + _local_18);
                _arg_1[(_local_23 + 56)] = (_local_20 - _local_18);
                _local_23++;
                _local_22++;
            };
            _local_22 = 0;
            while (_local_22 < 64)
            {
                _arg_1[_local_22] = Math.round((_arg_1[_local_22] * _arg_2[_local_22]));
                _local_22++;
            };
            return (_arg_1);
        }

        private function writeAPP0():void
        {
            this.writeWord(65504);
            this.writeWord(16);
            this.writeByte(74);
            this.writeByte(70);
            this.writeByte(73);
            this.writeByte(70);
            this.writeByte(0);
            this.writeByte(1);
            this.writeByte(1);
            this.writeByte(0);
            this.writeWord(1);
            this.writeWord(1);
            this.writeByte(0);
            this.writeByte(0);
        }

        private function writeSOF0(_arg_1:int, _arg_2:int):void
        {
            this.writeWord(65472);
            this.writeWord(17);
            this.writeByte(8);
            this.writeWord(_arg_2);
            this.writeWord(_arg_1);
            this.writeByte(3);
            this.writeByte(1);
            this.writeByte(17);
            this.writeByte(0);
            this.writeByte(2);
            this.writeByte(17);
            this.writeByte(1);
            this.writeByte(3);
            this.writeByte(17);
            this.writeByte(1);
        }

        private function writeDQT():void
        {
            var _local_1:int;
            this.writeWord(65499);
            this.writeWord(132);
            this.writeByte(0);
            _local_1 = 0;
            while (_local_1 < 64)
            {
                this.writeByte(this.YTable[_local_1]);
                _local_1++;
            };
            this.writeByte(1);
            _local_1 = 0;
            while (_local_1 < 64)
            {
                this.writeByte(this.UVTable[_local_1]);
                _local_1++;
            };
        }

        private function writeDHT():void
        {
            var _local_1:int;
            this.writeWord(65476);
            this.writeWord(418);
            this.writeByte(0);
            _local_1 = 0;
            while (_local_1 < 16)
            {
                this.writeByte(this.std_dc_luminance_nrcodes[(_local_1 + 1)]);
                _local_1++;
            };
            _local_1 = 0;
            while (_local_1 <= 11)
            {
                this.writeByte(this.std_dc_luminance_values[_local_1]);
                _local_1++;
            };
            this.writeByte(16);
            _local_1 = 0;
            while (_local_1 < 16)
            {
                this.writeByte(this.std_ac_luminance_nrcodes[(_local_1 + 1)]);
                _local_1++;
            };
            _local_1 = 0;
            while (_local_1 <= 161)
            {
                this.writeByte(this.std_ac_luminance_values[_local_1]);
                _local_1++;
            };
            this.writeByte(1);
            _local_1 = 0;
            while (_local_1 < 16)
            {
                this.writeByte(this.std_dc_chrominance_nrcodes[(_local_1 + 1)]);
                _local_1++;
            };
            _local_1 = 0;
            while (_local_1 <= 11)
            {
                this.writeByte(this.std_dc_chrominance_values[_local_1]);
                _local_1++;
            };
            this.writeByte(17);
            _local_1 = 0;
            while (_local_1 < 16)
            {
                this.writeByte(this.std_ac_chrominance_nrcodes[(_local_1 + 1)]);
                _local_1++;
            };
            _local_1 = 0;
            while (_local_1 <= 161)
            {
                this.writeByte(this.std_ac_chrominance_values[_local_1]);
                _local_1++;
            };
        }

        private function writeSOS():void
        {
            this.writeWord(65498);
            this.writeWord(12);
            this.writeByte(3);
            this.writeByte(1);
            this.writeByte(0);
            this.writeByte(2);
            this.writeByte(17);
            this.writeByte(3);
            this.writeByte(17);
            this.writeByte(0);
            this.writeByte(63);
            this.writeByte(0);
        }

        private function processDU(_arg_1:Array, _arg_2:Array, _arg_3:Number, _arg_4:Array, _arg_5:Array):Number
        {
            var _local_8:int;
            var _local_12:int;
            var _local_13:int;
            var _local_14:int;
            var _local_6:BitString = _arg_5[0];
            var _local_7:BitString = _arg_5[240];
            var _local_9:Array = this.fDCTQuant(_arg_1, _arg_2);
            _local_8 = 0;
            while (_local_8 < 64)
            {
                this.DU[this.ZigZag[_local_8]] = _local_9[_local_8];
                _local_8++;
            };
            var _local_10:int = (this.DU[0] - _arg_3);
            _arg_3 = this.DU[0];
            if (_local_10 == 0)
            {
                this.writeBits(_arg_4[0]);
            }
            else
            {
                this.writeBits(_arg_4[this.category[(32767 + _local_10)]]);
                this.writeBits(this.bitcode[(32767 + _local_10)]);
            };
            var _local_11:int = 63;
            while (((_local_11 > 0) && (this.DU[_local_11] == 0)))
            {
                _local_11--;
            };
            if (_local_11 == 0)
            {
                this.writeBits(_local_6);
                return (_arg_3);
            };
            _local_8 = 1;
            while (_local_8 <= _local_11)
            {
                _local_12 = _local_8;
                while (((this.DU[_local_8] == 0) && (_local_8 <= _local_11)))
                {
                    _local_8++;
                };
                _local_13 = (_local_8 - _local_12);
                if (_local_13 >= 16)
                {
                    _local_14 = 1;
                    while (_local_14 <= (_local_13 / 16))
                    {
                        this.writeBits(_local_7);
                        _local_14++;
                    };
                    _local_13 = int((_local_13 & 0x0F));
                };
                this.writeBits(_arg_5[((_local_13 * 16) + this.category[(32767 + this.DU[_local_8])])]);
                this.writeBits(this.bitcode[(32767 + this.DU[_local_8])]);
                _local_8++;
            };
            if (_local_11 != 63)
            {
                this.writeBits(_local_6);
            };
            return (_arg_3);
        }

        private function RGB2YUV(_arg_1:BitmapData, _arg_2:int, _arg_3:int):void
        {
            var _local_6:int;
            var _local_7:uint;
            var _local_8:Number;
            var _local_9:Number;
            var _local_10:Number;
            var _local_4:int;
            var _local_5:int;
            while (_local_5 < 8)
            {
                _local_6 = 0;
                while (_local_6 < 8)
                {
                    _local_7 = _arg_1.getPixel32((_arg_2 + _local_6), (_arg_3 + _local_5));
                    _local_8 = Number(((_local_7 >> 16) & 0xFF));
                    _local_9 = Number(((_local_7 >> 8) & 0xFF));
                    _local_10 = Number((_local_7 & 0xFF));
                    this.YDU[_local_4] = ((((0.299 * _local_8) + (0.587 * _local_9)) + (0.114 * _local_10)) - 128);
                    this.UDU[_local_4] = (((-0.16874 * _local_8) + (-0.33126 * _local_9)) + (0.5 * _local_10));
                    this.VDU[_local_4] = (((0.5 * _local_8) + (-0.41869 * _local_9)) + (-0.08131 * _local_10));
                    _local_4++;
                    _local_6++;
                };
                _local_5++;
            };
        }

        public function encode(_arg_1:BitmapData):ByteArray
        {
            var _local_6:int;
            var _local_7:BitString;
            this.byteout = new ByteArray();
            this.bytenew = 0;
            this.bytepos = 7;
            this.writeWord(65496);
            this.writeAPP0();
            this.writeDQT();
            this.writeSOF0(_arg_1.width, _arg_1.height);
            this.writeDHT();
            this.writeSOS();
            var _local_2:Number = 0;
            var _local_3:Number = 0;
            var _local_4:Number = 0;
            this.bytenew = 0;
            this.bytepos = 7;
            var _local_5:int;
            while (_local_5 < _arg_1.height)
            {
                _local_6 = 0;
                while (_local_6 < _arg_1.width)
                {
                    this.RGB2YUV(_arg_1, _local_6, _local_5);
                    _local_2 = this.processDU(this.YDU, this.fdtbl_Y, _local_2, this.YDC_HT, this.YAC_HT);
                    _local_3 = this.processDU(this.UDU, this.fdtbl_UV, _local_3, this.UVDC_HT, this.UVAC_HT);
                    _local_4 = this.processDU(this.VDU, this.fdtbl_UV, _local_4, this.UVDC_HT, this.UVAC_HT);
                    _local_6 = (_local_6 + 8);
                };
                _local_5 = (_local_5 + 8);
            };
            if (this.bytepos >= 0)
            {
                _local_7 = new BitString();
                _local_7.len = (this.bytepos + 1);
                _local_7.val = ((1 << (this.bytepos + 1)) - 1);
                this.writeBits(_local_7);
            };
            this.writeWord(65497);
            return (this.byteout);
        }


    }
}//package socialContact.copyBitmap

