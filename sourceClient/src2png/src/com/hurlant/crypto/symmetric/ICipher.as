// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//com.hurlant.crypto.symmetric.ICipher

package com.hurlant.crypto.symmetric
{
    import flash.utils.ByteArray;

    public interface ICipher 
    {

        function encrypt(_arg_1:ByteArray):void;
        function dispose():void;
        function getBlockSize():uint;
        function toString():String;
        function decrypt(_arg_1:ByteArray):void;

    }
}//package com.hurlant.crypto.symmetric

