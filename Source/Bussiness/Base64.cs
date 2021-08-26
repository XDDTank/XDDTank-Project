using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Bussiness
{
    public class Base64
    {
        private static readonly string BASE64_CHARS = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=";

        public static string encodeByteArray(byte[] param1)
        {
            string _loc_2 = "";            
            byte[] _loc_4 = new byte[4];
            //int i = 0;
            //while (param1.Length > i)
            for (int i = 0; i < param1.Length; )//; i++)
            {

                byte[] _loc_3 = new byte[3];
                int _loc_5 = 0;
                //do
                for (_loc_5 = 0; _loc_5 < param1.Length; )
                {

                    if (_loc_5 < 3)
                    {
                        if (_loc_5 + i > param1.Length)
                        { break; }
                        _loc_3[_loc_5] = param1[_loc_5 + i];
                        //Console.WriteLine(param1[_loc_5 + i]);
                    }

                    _loc_5++;
                } //while (param1.Length > i);

                _loc_4[0] = (byte)((_loc_3[0] & 252) >> 2);
                _loc_4[1] = (byte)((_loc_3[0] & 3) << 4 | _loc_3[1] >> 4);
                _loc_4[2] = (byte)((_loc_3[1] & 15) << 2 | _loc_3[2] >> 6);
                _loc_4[3] = (byte)(_loc_3[2] & 63);

                int _loc_6 = _loc_3.Length;
                while (_loc_6 < 3)
                {

                    _loc_4[_loc_6 + 1] = 64;
                    _loc_6++;
                }
                int _loc_7 = 0;
                while (_loc_7 < _loc_4.Length)
                {

                    _loc_2 += BASE64_CHARS.Substring(_loc_4[_loc_7], 1);
                    //Console.WriteLine(_loc_4[_loc_7]);
                    _loc_7++;
                }
                i = i + 4;
            }
            _loc_2 = _loc_2.Substring(0, param1.Length - 1);
            _loc_2 += "=";
            return _loc_2;
        }

        public static byte[] decodeToByteArray2(String param1)
        {
            byte[] _loc_2 = new byte[param1.Length];
            byte[] _loc_3 = new byte[4];
            int _loc_5 = 0;
            while (_loc_5 < param1.Length)
            {

                int _loc_6 = 0;
                int index = 0;
                do
                {
                    index = _loc_5 + _loc_6;
                    if (_loc_6 < 4)
                    {
                        _loc_3[_loc_6] = (byte)BASE64_CHARS.IndexOf(param1.Substring(index, 1));
                        //_loc_6 = 0;
                        //break;
                    }
                    _loc_6++;
                } while (index < param1.Length);

                int _loc_7 = 0;
                while (_loc_7 < _loc_3.Length)
                {

                    if (_loc_3[(_loc_7)] == 64)
                    {
                        break;
                    }
                    _loc_2[_loc_5 + _loc_7] = _loc_3[_loc_7];
                    //Console.WriteLine("_loc_4[" + _loc_7 +"] = " + _loc_4[_loc_7]);
                    _loc_7++;
                }
                _loc_5 = _loc_5 + 4;
            }

            return _loc_2;
        }
        public static byte[] decodeToByteArray(String param1)
        {
            //Console.WriteLine("param1.Length: " + param1.Length);
            byte[] _loc_2 = new byte[param1.Length];
            byte[] _loc_3 = new byte[4];
            byte[] _loc_4 = new byte[3];
            int _loc_5 = 0;
            while (_loc_5 < param1.Length)
            {
                
                int _loc_6 = 0;
                int index = 0;
                do
                {
                    index = _loc_5 + _loc_6;
                    //Console.WriteLine("IndexOf: " + BASE64_CHARS.IndexOf(param1.Substring(index, 1))
                    if (_loc_6 < 4)
                    {
                        _loc_3[_loc_6] = (byte)BASE64_CHARS.IndexOf(param1.Substring(index, 1));
                        //_loc_6 = 0;
                        //break;
                    }
                    _loc_6++;
                } while (index < param1.Length);

                _loc_4[0] = (byte)((_loc_3[0] << 2) + ((_loc_3[1] & 48) >> 4));
                _loc_4[1] = (byte)(((_loc_3[1] & 15) << 4) + ((_loc_3[2] & 60) >> 2));
                _loc_4[2] = (byte)(((_loc_3[2] & 3) << 6) + _loc_3[3]);

                int _loc_7 = 0;
                while (_loc_7 < _loc_4.Length)
                {
                    
                    if (_loc_3[(_loc_7 + 1)] == 64)
                    {
                        break;
                    }
                    _loc_2[_loc_5 + _loc_7] = _loc_4[_loc_7];
                    //Console.WriteLine("_loc_4[" + _loc_7 +"] = " + _loc_4[_loc_7]);
                    _loc_7++;
                }
                _loc_5 = _loc_5 + 4;
            }
            
            return _loc_2;
        }
        /*        
        private static const BASE64_CHARS:String = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=";

        public function Base64()
        {
            throw new Error("Base64 class is static container only");
        }// end function

        public static function encode(param1:String) : String
        {
            var _loc_2:ByteArray = null;
            _loc_2 = new ByteArray();
            _loc_2.writeUTFBytes(param1);
            return encodeByteArray(_loc_2);
        }// end function

        public static function encodeByteArray(param1:ByteArray) : String
        {
            var _loc_2:String = null;
            var _loc_3:Array = null;
            var _loc_4:Array = null;
            var _loc_5:uint = 0;
            var _loc_6:uint = 0;
            var _loc_7:uint = 0;
            _loc_2 = "";
            _loc_4 = new Array(4);
            param1.position = 0;
            while (param1.bytesAvailable > 0)
            {
                
                _loc_3 = new Array();
                _loc_5 = 0;
                do
                {
                    
                    _loc_3[_loc_5] = param1.readUnsignedByte();
                    _loc_5 = _loc_5 + 1;
                    if (_loc_5 < 3)
                    {
                    }
                }while (param1.bytesAvailable > 0)
                _loc_4[0] = (_loc_3[0] & 252) >> 2;
                _loc_4[1] = (_loc_3[0] & 3) << 4 | _loc_3[1] >> 4;
                _loc_4[2] = (_loc_3[1] & 15) << 2 | _loc_3[2] >> 6;
                _loc_4[3] = _loc_3[2] & 63;
                _loc_6 = _loc_3.length;
                while (_loc_6 < 3)
                {
                    
                    _loc_4[(_loc_6 + 1)] = 64;
                    _loc_6 = _loc_6 + 1;
                }
                _loc_7 = 0;
                while (_loc_7 < _loc_4.length)
                {
                    
                    _loc_2 = _loc_2 + BASE64_CHARS.charAt(_loc_4[_loc_7]);
                    _loc_7 = _loc_7 + 1;
                }
            }
            return _loc_2;
        }// end function

        public static function decode(param1:String) : String
        {
            var _loc_2:ByteArray = null;
            _loc_2 = decodeToByteArray(param1);
            return _loc_2.readUTFBytes(_loc_2.length);
        }// end function

        public static function decodeToByteArray(param1:String) : ByteArray
        {
            var _loc_2:ByteArray = null;
            var _loc_3:Array = null;
            var _loc_4:Array = null;
            var _loc_5:uint = 0;
            var _loc_6:uint = 0;
            var _loc_7:uint = 0;
            _loc_2 = new ByteArray();
            _loc_3 = new Array(4);
            _loc_4 = new Array(3);
            _loc_5 = 0;
            while (_loc_5 < param1.length)
            {
                
                _loc_6 = 0;
                do
                {
                    
                    _loc_3[_loc_6] = BASE64_CHARS.indexOf(param1.charAt(_loc_5 + _loc_6));
                    _loc_6 = _loc_6 + 1;
                    if (_loc_6 < 4)
                    {
                    }
                }while (_loc_5 + _loc_6 < param1.length)
                _loc_4[0] = (_loc_3[0] << 2) + ((_loc_3[1] & 48) >> 4);
                _loc_4[1] = ((_loc_3[1] & 15) << 4) + ((_loc_3[2] & 60) >> 2);
                _loc_4[2] = ((_loc_3[2] & 3) << 6) + _loc_3[3];
                _loc_7 = 0;
                while (_loc_7 < _loc_4.length)
                {
                    
                    if (_loc_3[(_loc_7 + 1)] == 64)
                    {
                        break;
                    }
                    _loc_2.writeByte(_loc_4[_loc_7]);
                    _loc_7 = _loc_7 + 1;
                }
                _loc_5 = _loc_5 + 4;
            }
            _loc_2.position = 0;
            return _loc_2;
        }// end function
        */
    }
}
