// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//com.hurlant.crypto.prng.Random

package com.hurlant.crypto.prng
{
    import flash.utils.ByteArray;
    import com.hurlant.util.Memory;
    import flash.text.Font;
    import flash.system.System;
    import flash.system.Capabilities;
    import flash.utils.getTimer;

    public class Random 
    {

        private var psize:int;
        private var ready:Boolean = false;
        private var seeded:Boolean = false;
        private var state:IPRNG;
        private var pool:ByteArray;
        private var pptr:int;

        public function Random(prng:Class=null)
        {
            var t:uint;
            super();
            if (prng == null)
            {
                prng = ARC4;
            };
            state = (new (prng)() as IPRNG);
            psize = state.getPoolSize();
            pool = new ByteArray();
            pptr = 0;
            while (pptr < psize)
            {
                t = (0x10000 * Math.random());
                var _local_3:* = pptr++;
                pool[_local_3] = (t >>> 8);
                var _local_4:* = pptr++;
                pool[_local_4] = (t & 0xFF);
            };
            pptr = 0;
            seed();
        }

        public function seed(x:int=0):void
        {
            if (x == 0)
            {
                x = new Date().getTime();
            };
            var _local_2:* = pptr++;
            pool[_local_2] = (pool[_local_2] ^ (x & 0xFF));
            var _local_3:* = pptr++;
            pool[_local_3] = (pool[_local_3] ^ ((x >> 8) & 0xFF));
            var _local_4:* = pptr++;
            pool[_local_4] = (pool[_local_4] ^ ((x >> 16) & 0xFF));
            var _local_5:* = pptr++;
            pool[_local_5] = (pool[_local_5] ^ ((x >> 24) & 0xFF));
            pptr = (pptr % psize);
            seeded = true;
        }

        public function toString():String
        {
            return ("random-" + state.toString());
        }

        public function dispose():void
        {
            var i:uint;
            i = 0;
            while (i < pool.length)
            {
                pool[i] = (Math.random() * 0x0100);
                i++;
            };
            pool.length = 0;
            pool = null;
            state.dispose();
            state = null;
            psize = 0;
            pptr = 0;
            Memory.gc();
        }

        public function autoSeed():void
        {
            var b:ByteArray;
            var a:Array;
            var f:Font;
            b = new ByteArray();
            b.writeUnsignedInt(System.totalMemory);
            b.writeUTF(Capabilities.serverString);
            b.writeUnsignedInt(getTimer());
            b.writeUnsignedInt(new Date().getTime());
            a = Font.enumerateFonts(true);
            for each (f in a)
            {
                b.writeUTF(f.fontName);
                b.writeUTF(f.fontStyle);
                b.writeUTF(f.fontType);
            };
            b.position = 0;
            while (b.bytesAvailable >= 4)
            {
                seed(b.readUnsignedInt());
            };
        }

        public function nextByte():int
        {
            if ((!(ready)))
            {
                if ((!(seeded)))
                {
                    autoSeed();
                };
                state.init(pool);
                pool.length = 0;
                pptr = 0;
                ready = true;
            };
            return (state.next());
        }

        public function nextBytes(buffer:ByteArray, length:int):void
        {
            while (length--)
            {
                buffer.writeByte(nextByte());
            };
        }


    }
}//package com.hurlant.crypto.prng

