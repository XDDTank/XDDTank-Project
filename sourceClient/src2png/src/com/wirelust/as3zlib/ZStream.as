// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//com.wirelust.as3zlib.ZStream

package com.wirelust.as3zlib
{
    import flash.utils.ByteArray;

    public final class ZStream 
    {

        private static var MAX_WBITS:int = 15;
        private static var DEF_WBITS:int = MAX_WBITS;
        private static var Z_NO_FLUSH:int = 0;
        private static var Z_PARTIAL_FLUSH:int = 1;
        private static var Z_SYNC_FLUSH:int = 2;
        private static var Z_FULL_FLUSH:int = 3;
        private static var Z_FINISH:int = 4;
        private static var MAX_MEM_LEVEL:int = 9;
        private static var Z_OK:int = 0;
        private static var Z_STREAM_END:int = 1;
        private static var Z_NEED_DICT:int = 2;
        private static var Z_ERRNO:int = -1;
        private static var Z_STREAM_ERROR:int = -2;
        private static var Z_DATA_ERROR:int = -3;
        private static var Z_MEM_ERROR:int = -4;
        private static var Z_BUF_ERROR:int = -5;
        private static var Z_VERSION_ERROR:int = -6;

        public var next_in:ByteArray;
        public var next_in_index:int;
        public var avail_in:int;
        public var total_in:Number;
        public var next_out:ByteArray;
        public var next_out_index:int;
        public var avail_out:int;
        public var total_out:Number;
        public var msg:String;
        public var dstate:Deflate;
        public var istate:Inflate;
        public var data_type:int;
        public var adler:Number;
        public var _adler:Adler32 = new Adler32();


        public function inflateInit():int
        {
            return (this.inflateInitWithWbits(DEF_WBITS));
        }

        public function inflateInitWithNoWrap(_arg_1:Boolean):int
        {
            return (this.inflateInitWithWbitsNoWrap(DEF_WBITS, _arg_1));
        }

        public function inflateInitWithWbits(_arg_1:int):int
        {
            return (this.inflateInitWithWbitsNoWrap(_arg_1, false));
        }

        public function inflateInitWithWbitsNoWrap(_arg_1:int, _arg_2:Boolean):int
        {
            this.istate = new Inflate();
            return (this.istate.inflateInit(this, ((_arg_2) ? -(_arg_1) : _arg_1)));
        }

        public function inflate(_arg_1:int):int
        {
            if (this.istate == null)
            {
                return (Z_STREAM_ERROR);
            };
            return (this.istate.inflate(this, _arg_1));
        }

        public function inflateEnd():int
        {
            if (this.istate == null)
            {
                return (Z_STREAM_ERROR);
            };
            var _local_1:int = this.istate.inflateEnd(this);
            this.istate = null;
            return (_local_1);
        }

        public function inflateSync():int
        {
            if (this.istate == null)
            {
                return (Z_STREAM_ERROR);
            };
            return (this.istate.inflateSync(this));
        }

        public function inflateSetDictionary(_arg_1:ByteArray, _arg_2:int):int
        {
            if (this.istate == null)
            {
                return (Z_STREAM_ERROR);
            };
            return (this.istate.inflateSetDictionary(this, _arg_1, _arg_2));
        }

        public function deflateInit(_arg_1:int):int
        {
            return (this.deflateInitWithIntInt(_arg_1, MAX_WBITS));
        }

        public function deflateInitWithBoolean(_arg_1:int, _arg_2:Boolean):int
        {
            return (this.deflateInitWithIntIntBoolean(_arg_1, MAX_WBITS, _arg_2));
        }

        public function deflateInitWithIntInt(_arg_1:int, _arg_2:int):int
        {
            return (this.deflateInitWithIntIntBoolean(_arg_1, _arg_2, false));
        }

        public function deflateInitWithIntIntBoolean(_arg_1:int, _arg_2:int, _arg_3:Boolean):int
        {
            this.dstate = new Deflate();
            return (this.dstate.deflateInitWithBits(this, _arg_1, ((_arg_3) ? -(_arg_2) : _arg_2)));
        }

        public function deflate(_arg_1:int):int
        {
            if (this.dstate == null)
            {
                return (Z_STREAM_ERROR);
            };
            return (this.dstate.deflate(this, _arg_1));
        }

        public function deflateEnd():int
        {
            if (this.dstate == null)
            {
                return (Z_STREAM_ERROR);
            };
            var _local_1:int = this.dstate.deflateEnd();
            this.dstate = null;
            return (_local_1);
        }

        public function deflateParams(_arg_1:int, _arg_2:int):int
        {
            if (this.dstate == null)
            {
                return (Z_STREAM_ERROR);
            };
            return (this.dstate.deflateParams(this, _arg_1, _arg_2));
        }

        public function deflateSetDictionary(_arg_1:ByteArray, _arg_2:int):int
        {
            if (this.dstate == null)
            {
                return (Z_STREAM_ERROR);
            };
            return (this.dstate.deflateSetDictionary(this, _arg_1, _arg_2));
        }

        public function flush_pending():void
        {
            var _local_1:int = this.dstate.pending;
            if (_local_1 > this.avail_out)
            {
                _local_1 = this.avail_out;
            };
            if (_local_1 == 0)
            {
                return;
            };
            if (((((this.dstate.pending_buf.length <= this.dstate.pending_out) || (this.next_out.length <= this.next_out_index)) || (this.dstate.pending_buf.length < (this.dstate.pending_out + _local_1))) || (this.next_out.length < (this.next_out_index + _local_1))))
            {
            };
            System.byteArrayCopy(this.dstate.pending_buf, this.dstate.pending_out, this.next_out, this.next_out_index, _local_1);
            this.next_out_index = (this.next_out_index + _local_1);
            this.dstate.pending_out = (this.dstate.pending_out + _local_1);
            this.total_out = (this.total_out + _local_1);
            this.avail_out = (this.avail_out - _local_1);
            this.dstate.pending = (this.dstate.pending - _local_1);
            if (this.dstate.pending == 0)
            {
                this.dstate.pending_out = 0;
                this.dstate.pending_buf = new ByteArray();
            };
        }

        public function read_buf(_arg_1:ByteArray, _arg_2:int, _arg_3:int):int
        {
            var _local_4:int = this.avail_in;
            if (_local_4 > _arg_3)
            {
                _local_4 = _arg_3;
            };
            if (_local_4 == 0)
            {
                return (0);
            };
            this.avail_in = (this.avail_in - _local_4);
            if (this.dstate.noheader == 0)
            {
                this.adler = this._adler.adler32(this.adler, this.next_in, this.next_in_index, _local_4);
            };
            System.byteArrayCopy(this.next_in, this.next_in_index, _arg_1, _arg_2, _local_4);
            this.next_in_index = (this.next_in_index + _local_4);
            this.total_in = (this.total_in + _local_4);
            return (_local_4);
        }

        public function free():void
        {
            this.next_in = null;
            this.next_out = null;
            this.msg = null;
            this._adler = null;
        }


    }
}//package com.wirelust.as3zlib

