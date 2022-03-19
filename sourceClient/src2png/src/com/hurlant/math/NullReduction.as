// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//com.hurlant.math.NullReduction

package com.hurlant.math
{
    import com.hurlant.math.bi_internal; 

    use namespace bi_internal;

    public class NullReduction implements IReduction 
    {


        public function reduce(x:BigInteger):void
        {
        }

        public function revert(x:BigInteger):BigInteger
        {
            return (x);
        }

        public function mulTo(x:BigInteger, y:BigInteger, r:BigInteger):void
        {
            x.multiplyTo(y, r);
        }

        public function convert(x:BigInteger):BigInteger
        {
            return (x);
        }

        public function sqrTo(x:BigInteger, r:BigInteger):void
        {
            x.squareTo(r);
        }


    }
}//package com.hurlant.math

