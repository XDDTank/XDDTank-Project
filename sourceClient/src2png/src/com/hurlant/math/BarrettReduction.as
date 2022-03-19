// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//com.hurlant.math.BarrettReduction

package com.hurlant.math
{
    import com.hurlant.math.BigInteger;
    import com.hurlant.math.bi_internal; 

    use namespace bi_internal;

    internal class BarrettReduction implements IReduction 
    {

        private var r2:BigInteger;
        private var q3:BigInteger;
        private var mu:BigInteger;
        private var m:BigInteger;

        public function BarrettReduction(m:BigInteger)
        {
            r2 = new BigInteger();
            q3 = new BigInteger();
            BigInteger.ONE.dlShiftTo((2 * m.t), r2);
            mu = r2.divide(m);
            this.m = m;
        }

        public function reduce(lx:BigInteger):void
        {
            var x:BigInteger;
            x = (lx as BigInteger);
            x.drShiftTo((m.t - 1), r2);
            if (x.t > (m.t + 1))
            {
                x.t = (m.t + 1);
                x.clamp();
            };
            mu.multiplyUpperTo(r2, (m.t + 1), q3);
            m.multiplyLowerTo(q3, (m.t + 1), r2);
            while (x.compareTo(r2) < 0)
            {
                x.dAddOffset(1, (m.t + 1));
            };
            x.subTo(r2, x);
            while (x.compareTo(m) >= 0)
            {
                x.subTo(m, x);
            };
        }

        public function revert(x:BigInteger):BigInteger
        {
            return (x);
        }

        public function convert(x:BigInteger):BigInteger
        {
            var r:BigInteger;
            if (((x.s < 0) || (x.t > (2 * m.t))))
            {
                return (x.mod(m));
            };
            if (x.compareTo(m) < 0)
            {
                return (x);
            };
            r = new BigInteger();
            x.copyTo(r);
            reduce(r);
            return (r);
        }

        public function sqrTo(x:BigInteger, r:BigInteger):void
        {
            x.squareTo(r);
            reduce(r);
        }

        public function mulTo(x:BigInteger, y:BigInteger, r:BigInteger):void
        {
            x.multiplyTo(y, r);
            reduce(r);
        }


    }
}//package com.hurlant.math

