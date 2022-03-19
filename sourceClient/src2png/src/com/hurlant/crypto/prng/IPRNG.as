// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//com.hurlant.crypto.prng.IPRNG

package com.hurlant.crypto.prng
{
    import flash.utils.ByteArray;

    public interface IPRNG 
    {

        function init(_arg_1:ByteArray):void;
        function next():uint;
        function dispose():void;
        function getPoolSize():uint;
        function toString():String;

    }
}//package com.hurlant.crypto.prng

