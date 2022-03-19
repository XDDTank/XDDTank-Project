// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//com.wirelust.as3zlib.DeflateConfig

package com.wirelust.as3zlib
{
    public class DeflateConfig 
    {

        public var good_length:int;
        public var max_lazy:int;
        public var nice_length:int;
        public var max_chain:int;
        public var func:int;

        public function DeflateConfig(_arg_1:int, _arg_2:int, _arg_3:int, _arg_4:int, _arg_5:int)
        {
            this.good_length = _arg_1;
            this.max_lazy = _arg_2;
            this.nice_length = _arg_3;
            this.max_chain = _arg_4;
            this.func = _arg_5;
        }

    }
}//package com.wirelust.as3zlib

