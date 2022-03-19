// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//road7th.utils.StringHelper

package road7th.utils
{
    import flash.geom.Point;
    import flash.utils.ByteArray;
    import flash.text.TextField;
    import __AS3__.vec.Vector;
    import __AS3__.vec.*;

    public class StringHelper 
    {

        private static var blankSpaceType:Array = [9, 61656, 59349, 59350, 59351, 59352, 59353, 59354, 59355, 59355, 59356, 59357, 59358, 59359, 59360, 59361, 59362, 59363, 59364, 59365];
        private static const OFFSET:Number = 2000;
        private static const reg:RegExp = /[^\x00-\xff]{1,}/g;
        public static const _leftReg:RegExp = /</g;
        public static const _rightReg:RegExp = />/g;
        private static var idR1:RegExp = /^[1-9]\d{7}((0\d)|(1[0-2]))(([0|1|2]\d)|3[0-1])\d{3}$/;
        private static var idR2:RegExp = /^[1-9]\d{5}[1-9]\d{3}((0\d)|(1[0-2]))(([0|1|2]\d)|3[0-1])\d{3}(\d|x|X)$/;


        public static function trimLeft(_arg_1:String):String
        {
            if ((!(_arg_1)))
            {
                return (_arg_1);
            };
            return (_arg_1.replace(/^\s*/g, ""));
        }

        public static function trim(_arg_1:String):String
        {
            if ((!(_arg_1)))
            {
                return (_arg_1);
            };
            return (_arg_1.replace(/(^\s*)|(\s*$)/g, ""));
        }

        public static function trimTagname(_arg_1:String):String
        {
            if ((!(_arg_1)))
            {
                return (_arg_1);
            };
            return (_arg_1.replace(/"/g, ""));
        }

        public static function trimRight(_arg_1:String):String
        {
            return (_arg_1.replace(/\s*$/g, ""));
        }

        public static function trimAll(_arg_1:String):String
        {
            var _local_2:String = trim(_arg_1);
            var _local_3:String = "";
            var _local_4:uint;
            while (_local_4 < _local_2.length)
            {
                if (blankSpaceType.indexOf(_local_2.charCodeAt(_local_4)) <= -1)
                {
                    _local_3 = (_local_3 + _local_2.charAt(_local_4));
                };
                _local_4++;
            };
            return (_local_3);
        }

        public static function replaceStr(_arg_1:String, _arg_2:String, _arg_3:String):String
        {
            return (_arg_1.split(_arg_2).join(_arg_3));
        }

        public static function isNullOrEmpty(_arg_1:String):Boolean
        {
            return ((_arg_1 == null) || (_arg_1 == ""));
        }

        public static function stringToPath(_arg_1:String):Array
        {
            var _local_4:int;
            var _local_5:int;
            var _local_2:Array = new Array();
            var _local_3:int;
            while (_local_3 < _arg_1.length)
            {
                _local_4 = _arg_1.charCodeAt(_local_3);
                _local_5 = _arg_1.charCodeAt((_local_3 + 1));
                _local_2.push(new Point((_local_4 - OFFSET), (_local_5 - OFFSET)));
                _local_3 = (_local_3 + 2);
            };
            return (_local_2);
        }

        public static function stringToPoint(_arg_1:String):Point
        {
            return (new Point((_arg_1.charCodeAt(0) - OFFSET), (_arg_1.charCodeAt(1) - OFFSET)));
        }

        public static function pathToString(_arg_1:Array):String
        {
            if (((_arg_1 == null) || (_arg_1.length <= 0)))
            {
                return ("");
            };
            var _local_2:String = "";
            var _local_3:int;
            while (_local_3 < _arg_1.length)
            {
                _local_2 = (_local_2 + String.fromCharCode(Math.round((_arg_1[_local_3].x + OFFSET))));
                _local_2 = (_local_2 + String.fromCharCode(Math.round((_arg_1[_local_3].y + OFFSET))));
                _local_3++;
            };
            return (_local_2);
        }

        public static function pointToString(_arg_1:Point):String
        {
            var _local_2:String = "";
            _local_2 = (_local_2 + String.fromCharCode(Math.round((_arg_1.x + OFFSET))));
            return (_local_2 + String.fromCharCode(Math.round((_arg_1.y + OFFSET))));
        }

        public static function numberToString(_arg_1:Number):String
        {
            return (String.fromCharCode(Math.round((_arg_1 + OFFSET))));
        }

        public static function stringToNumber(_arg_1:String):Number
        {
            return (_arg_1.charCodeAt(0) - OFFSET);
        }

        public static function getIsBiggerMaxCHchar(_arg_1:String, _arg_2:uint):Boolean
        {
            var _local_3:ByteArray = new ByteArray();
            _local_3.writeUTF(trim(_arg_1));
            if (_local_3.length > ((_arg_2 * 3) + 2))
            {
                return (true);
            };
            return (false);
        }

        public static function getRandomNumber():String
        {
            var _local_1:uint = Math.round((Math.random() * 1000000));
            return (_local_1.toString());
        }

        public static function checkTextFieldLength(_arg_1:TextField, _arg_2:uint, _arg_3:String=null):void
        {
            var _local_4:uint = ((_arg_1.text) ? _arg_1.text.match(reg).join("").length : 0);
            var _local_5:uint = ((_arg_3) ? _arg_3.match(reg).join("").length : 0);
            _arg_1.maxChars = ((_arg_2 > (_local_4 + _local_5)) ? ((_arg_2 - _local_4) - _local_5) : ((_arg_2 > _local_5) ? (_arg_2 - _local_5) : int((_arg_2 / 2))));
        }

        public static function rePlaceHtmlTextField(_arg_1:String):String
        {
            _arg_1 = _arg_1.replace(_leftReg, "&lt;");
            return (_arg_1.replace(_rightReg, "&gt;"));
        }

        public static function parseTime(_arg_1:String, _arg_2:uint):String
        {
            var _local_3:String = _arg_1;
            var _local_4:Date = new Date(Number(_local_3.substr(0, 4)), (Number(_local_3.substr(5, 2)) - 1), Number(_local_3.substr(8, 2)));
            var _local_5:Date = new Date();
            _local_5.setTime((_local_4.getTime() + (((((_arg_2 + 1) * 24) * 60) * 60) * 1000)));
            return ((((String(_local_5.getUTCFullYear()) + "-") + (_local_5.getUTCMonth() + 1)) + "-") + _local_5.getUTCDate());
        }

        public static function cidCheck(_arg_1:String):Boolean
        {
            if (((idR1.test(_arg_1)) || (idR2.test(_arg_1))))
            {
                return (true);
            };
            return (false);
        }

        public static function replaceHtmlTag(_arg_1:String):String
        {
            return (_arg_1.replace(/<(\S*?)[^>]*>|<.*? \/>/g, ""));
        }

        public static function replaceToHtmlText(_arg_1:String):String
        {
            var _local_2:TextField = new TextField();
            _local_2.text = _arg_1;
            return (replaceHtmlTag(_local_2.htmlText));
        }

        public static function getConvertedHtmlArray(_arg_1:String):Array
        {
            return (_arg_1.match(/&[a-z]*?;/g));
        }

        public static function format(_arg_1:String, ... _args):String
        {
            if (((_args == null) || (_args.length <= 0)))
            {
                return (_arg_1);
            };
            var _local_3:uint;
            while (_local_3 < _args.length)
            {
                _arg_1 = replaceStr(_arg_1, (("{" + _local_3.toString()) + "}"), _args[_local_3]);
                _local_3++;
            };
            return (_arg_1);
        }

        public static function getConvertedLst(_arg_1:String):Array
        {
            return (_arg_1.match(/&[a-z]*?;/g));
        }

        public static function trimHtmlText(_arg_1:String):String
        {
            var _local_4:String;
            _arg_1 = trim(_arg_1);
            var _local_2:int;
            var _local_3:int;
            var _local_5:RegExp = /<[\S+]>/g;
            var _local_6:Object = _local_5.exec(_arg_1);
            var _local_7:Vector.<String> = new Vector.<String>();
            while (_local_6)
            {
                _local_3 = _local_6.index;
                _local_7.push(_arg_1.substring(_local_2, _local_3));
                _local_7.push(_local_6[0]);
                _local_2 = _local_5.lastIndex;
                _local_6 = _local_5.exec(_arg_1);
            };
            _local_7.push(_arg_1.substring(_local_2));
            _local_7[2] = trimLeft(_local_7[2]);
            _local_7[(_local_7.length - 2)] = trimRight(_local_7[(_local_7.length - 2)]);
            return (_local_7.join(""));
        }

        public static function getStringByteLength(_arg_1:String):int
        {
            var _local_5:String;
            var _local_2:uint;
            var _local_3:RegExp = /[^\x00-\xff]/;
            var _local_4:int;
            while (_local_4 < _arg_1.length)
            {
                _local_5 = _arg_1.charAt(_local_4);
                if (_local_3.test(_local_5))
                {
                    _local_2 = (_local_2 + 2);
                }
                else
                {
                    _local_2 = (_local_2 + 1);
                };
                _local_4++;
            };
            return (_local_2);
        }


    }
}//package road7th.utils

