// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//ddt.utils.CrytoUtils

package ddt.utils
{
    import com.hurlant.util.Base64;
    import com.hurlant.math.BigInteger;
    import com.hurlant.crypto.rsa.RSAKey;
    import flash.utils.ByteArray;

    public class CrytoUtils 
    {


        public static function rsaEncry(_arg_1:String, _arg_2:String, _arg_3:String):String
        {
            return (rsaEncry2(Base64.decodeToByteArray(_arg_1), Base64.decodeToByteArray(_arg_2), _arg_3));
        }

        public static function rsaEncry2(_arg_1:ByteArray, _arg_2:ByteArray, _arg_3:String):String
        {
            var _local_4:BigInteger = new BigInteger(_arg_1);
            var _local_5:BigInteger = new BigInteger(_arg_2);
            var _local_6:RSAKey = new RSAKey(_local_4, _local_5.intValue());
            return (rsaEncry3(_local_6, _arg_3));
        }

        public static function generateRsaKey(_arg_1:String, _arg_2:String):RSAKey
        {
            return (generateRsaKey2(Base64.decodeToByteArray(_arg_1), Base64.decodeToByteArray(_arg_2)));
        }

        public static function generateRsaKey2(_arg_1:ByteArray, _arg_2:ByteArray):RSAKey
        {
            var _local_3:BigInteger = new BigInteger(_arg_1);
            var _local_4:BigInteger = new BigInteger(_arg_2);
            return (new RSAKey(_local_3, _local_4.intValue()));
        }

        public static function rsaEncry3(_arg_1:RSAKey, _arg_2:String):String
        {
            var _local_3:ByteArray = new ByteArray();
            _local_3.writeUTF(_arg_2);
            var _local_4:ByteArray = new ByteArray();
            _arg_1.encrypt(_local_3, _local_4, _local_3.length);
            return (Base64.encodeByteArray(_local_4));
        }

        public static function rsaEncry4(_arg_1:RSAKey, _arg_2:ByteArray):String
        {
            var _local_3:ByteArray = new ByteArray();
            _arg_1.encrypt(_arg_2, _local_3, _arg_2.length);
            return (Base64.encodeByteArray(_local_3));
        }

        public static function rsaEncry5(_arg_1:RSAKey, _arg_2:ByteArray):ByteArray
        {
            var _local_3:ByteArray = new ByteArray();
            _arg_1.encrypt(_arg_2, _local_3, _arg_2.length);
            return (_local_3);
        }


    }
}//package ddt.utils

