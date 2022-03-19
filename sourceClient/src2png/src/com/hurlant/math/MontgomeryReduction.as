// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//com.hurlant.math.MontgomeryReduction

package com.hurlant.math
{
    import com.hurlant.math.BigInteger;
    import com.hurlant.math.bi_internal; 

    use namespace bi_internal;

    internal class MontgomeryReduction implements IReduction 
    {

        private var um:int;
        private var mp:int;
        private var mph:int;
        private var mpl:int;
        private var mt2:int;
        private var m:BigInteger;

        public function MontgomeryReduction(m:BigInteger)
        {
            this.m = m;
            mp = m.invDigit();
            mpl = (mp & 0x7FFF);
            mph = (mp >> 15);
            um = ((1 << (BigInteger.DB - 15)) - 1);
            mt2 = (2 * m.t);
        }

        public function mulTo(x:BigInteger, y:BigInteger, r:BigInteger):void
        {
            x.multiplyTo(y, r);
            reduce(r);
        }

        public function revert(x:BigInteger):BigInteger
        {
            var r:BigInteger;
            r = new BigInteger();
            x.copyTo(r);
            reduce(r);
            return (r);
        }

        public function convert(x:BigInteger):BigInteger
        {
            var r:BigInteger;
            r = new BigInteger();
            x.abs().dlShiftTo(m.t, r);
            r.divRemTo(m, null, r);
            if (((x.s < 0) && (r.compareTo(BigInteger.ZERO) > 0)))
            {
                m.subTo(r, r);
            };
            return (r);
        }

        public function reduce(x:BigInteger):void
        {
            var i:int;
            var j:int;
            var u0:int;
            while (x.t <= mt2)
            {
                var _local_5:* = x.t++;
                x.a[_local_5] = 0;
            };
            i = 0;
            while (i < m.t)
            {
                j = (x.a[i] & 0x7FFF);
                u0 = (((j * mpl) + ((((j * mph) + ((x.a[i] >> 15) * mpl)) & um) << 15)) & BigInteger.DM);
                j = (i + m.t);
                x.a[j] = (x.a[j] + m.am(0, u0, x, i, 0, m.t));
                while (x.a[j] >= BigInteger.DV)
                {
                    x.a[j] = (x.a[j] - BigInteger.DV);
                    x.a[++j]++;
                };
                i++;
            };
            x.clamp();
            x.drShiftTo(m.t, x);
            if (x.compareTo(m) >= 0)
            {
                x.subTo(m, x);
            };
        }

        public function sqrTo(x:BigInteger, r:BigInteger):void
        {
            x.squareTo(r);
            reduce(r);
        }


    }
}//package com.hurlant.math

