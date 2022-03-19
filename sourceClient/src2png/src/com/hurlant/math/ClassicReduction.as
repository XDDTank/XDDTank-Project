// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//com.hurlant.math.ClassicReduction

package com.hurlant.math
{
    import com.hurlant.math.BigInteger;
    import com.hurlant.math.bi_internal; 

    use namespace bi_internal;

    internal class ClassicReduction implements IReduction 
    {

        private var m:BigInteger;

        public function ClassicReduction(m:BigInteger)
        {
            this.m = m;
        }

        public function revert(x:BigInteger):BigInteger
        {
            return (x);
        }

        public function reduce(x:BigInteger):void
        {
            x.divRemTo(m, null, x);
        }

        public function convert(x:BigInteger):BigInteger
        {
            if (((x.s < 0) || (x.compareTo(m) >= 0)))
            {
                return (x.mod(m));
            };
            return (x);
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

