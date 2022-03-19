// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//com.pickgliss.utils.StringUtils

package com.pickgliss.utils
{
    import flash.utils.Dictionary;

    public final class StringUtils 
    {

        public static const BASE64:String = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
        private static var _reg:RegExp = new RegExp("\\{(\\d+)\\}");


        public static function afterFirst(_arg_1:String, _arg_2:String):String
        {
            if (_arg_1 == null)
            {
                return ("");
            };
            var _local_3:int = _arg_1.indexOf(_arg_2);
            if (_local_3 == -1)
            {
                return ("");
            };
            _local_3 = (_local_3 + _arg_2.length);
            return (_arg_1.substr(_local_3));
        }

        public static function afterLast(_arg_1:String, _arg_2:String):String
        {
            if (_arg_1 == null)
            {
                return ("");
            };
            var _local_3:int = _arg_1.lastIndexOf(_arg_2);
            if (_local_3 == -1)
            {
                return ("");
            };
            _local_3 = (_local_3 + _arg_2.length);
            return (_arg_1.substr(_local_3));
        }

        public static function beginsWith(_arg_1:String, _arg_2:String):Boolean
        {
            if (_arg_1 == null)
            {
                return (false);
            };
            return (_arg_1.indexOf(_arg_2) == 0);
        }

        public static function beforeFirst(_arg_1:String, _arg_2:String):String
        {
            if (_arg_1 == null)
            {
                return ("");
            };
            var _local_3:int = _arg_1.indexOf(_arg_2);
            if (_local_3 == -1)
            {
                return ("");
            };
            return (_arg_1.substr(0, _local_3));
        }

        public static function beforeLast(_arg_1:String, _arg_2:String):String
        {
            if (_arg_1 == null)
            {
                return ("");
            };
            var _local_3:int = _arg_1.lastIndexOf(_arg_2);
            if (_local_3 == -1)
            {
                return ("");
            };
            return (_arg_1.substr(0, _local_3));
        }

        public static function between(_arg_1:String, _arg_2:String, _arg_3:String):String
        {
            var _local_6:int;
            var _local_4:String = "";
            if (_arg_1 == null)
            {
                return (_local_4);
            };
            var _local_5:int = _arg_1.indexOf(_arg_2);
            if (_local_5 != -1)
            {
                _local_5 = (_local_5 + _arg_2.length);
                _local_6 = _arg_1.indexOf(_arg_3, _local_5);
                if (_local_6 != -1)
                {
                    _local_4 = _arg_1.substr(_local_5, (_local_6 - _local_5));
                };
            };
            return (_local_4);
        }

        public static function block(_arg_1:String, _arg_2:uint, _arg_3:String="."):Array
        {
            var _local_7:String;
            var _local_4:Array = new Array();
            if (((_arg_1 == null) || (!(contains(_arg_1, _arg_3)))))
            {
                return (_local_4);
            };
            var _local_5:uint;
            var _local_6:uint = _arg_1.length;
            while (_local_5 < _local_6)
            {
                _local_7 = _arg_1.substr(_local_5, _arg_2);
                if ((!(contains(_local_7, _arg_3))))
                {
                    _local_4.push(truncate(_local_7, _local_7.length));
                    _local_5 = (_local_5 + _local_7.length);
                };
                _local_7 = _local_7.replace(new RegExp((("[^" + _arg_3) + "]+$")), "");
                _local_4.push(_local_7);
                _local_5 = (_local_5 + _local_7.length);
            };
            return (_local_4);
        }

        public static function capitalize(_arg_1:String, ... _args):String
        {
            var _local_3:String = trimLeft(_arg_1);
            if (_args[0] === true)
            {
                return (_local_3.replace(/^.|\s+(.)/, _upperCase));
            };
            return (_local_3.replace(/(^\w)/, _upperCase));
        }

        public static function ljust(_arg_1:String, _arg_2:uint, _arg_3:String=" "):String
        {
            var _local_4:String = _arg_3.substr(0, 1);
            if (_arg_1.length < _arg_2)
            {
                return (_arg_1 + repeat(_local_4, (_arg_2 - _arg_1.length)));
            };
            return (_arg_1);
        }

        public static function rjust(_arg_1:String, _arg_2:uint, _arg_3:String=" "):String
        {
            var _local_4:String = _arg_3.substr(0, 1);
            if (_arg_1.length < _arg_2)
            {
                return (repeat(_local_4, (_arg_2 - _arg_1.length)) + _arg_1);
            };
            return (_arg_1);
        }

        public static function center(_arg_1:String, _arg_2:uint, _arg_3:String=" "):String
        {
            var _local_5:uint;
            var _local_6:String;
            var _local_7:String;
            var _local_4:String = _arg_3.substr(0, 1);
            if (_arg_1.length < _arg_2)
            {
                _local_5 = (_arg_2 - _arg_1.length);
                _local_6 = (((_local_5 % 2) == 0) ? "" : _local_4);
                _local_7 = repeat(_local_4, Math.round((_local_5 / 2)));
                return (((_local_7 + _arg_1) + _local_7) + _local_6);
            };
            return (_arg_1);
        }

        public static function repeat(_arg_1:String, _arg_2:uint=1):String
        {
            var _local_3:String = "";
            while (_arg_2--)
            {
                _local_3 = (_local_3 + _arg_1);
            };
            return (_local_3);
        }

        public static function base64Encode(_arg_1:String):String
        {
            var _local_5:Number;
            var _local_6:Number;
            var _local_7:Number;
            var _local_2:String = "";
            var _local_3:uint;
            var _local_4:uint = _arg_1.length;
            while (_local_3 < _local_4)
            {
                _local_5 = (_arg_1.charCodeAt(_local_3++) & 0xFF);
                if (_local_3 == _local_4)
                {
                    _local_2 = (_local_2 + ((BASE64.charAt((_local_5 >> 2)) + BASE64.charAt(((_local_5 & 0x03) << 4))) + "=="));
                    break;
                };
                _local_6 = _arg_1.charCodeAt(_local_3++);
                if (_local_3 == _local_4)
                {
                    _local_2 = (_local_2 + ((BASE64.charAt((_local_5 >> 2)) + BASE64.charAt((((_local_5 & 0x03) << 4) | ((_local_6 & 0xF0) >> 4)))) + "="));
                    break;
                };
                _local_7 = _arg_1.charCodeAt(_local_3++);
                _local_2 = (_local_2 + (((BASE64.charAt((_local_5 >> 2)) + BASE64.charAt((((_local_5 & 0x03) << 4) | ((_local_6 & 0xF0) >> 4)))) + BASE64.charAt((((_local_6 & 0x0F) << 2) | ((_local_7 & 0xC0) >> 6)))) + BASE64.charAt((_local_7 & 0x3F))));
            };
            return (_local_2);
        }

        public static function contains(_arg_1:String, _arg_2:String):Boolean
        {
            if (_arg_1 == null)
            {
                return (false);
            };
            return (!(_arg_1.indexOf(_arg_2) == -1));
        }

        public static function countOf(_arg_1:String, _arg_2:String, _arg_3:Boolean=true):uint
        {
            if (_arg_1 == null)
            {
                return (0);
            };
            var _local_4:String = escapePattern(_arg_2);
            var _local_5:String = ((!(_arg_3)) ? "ig" : "g");
            return (_arg_1.match(new RegExp(_local_4, _local_5)).length);
        }

        public static function editDistance(_arg_1:String, _arg_2:String):uint
        {
            var _local_4:uint;
            var _local_11:String;
            var _local_12:uint;
            var _local_13:String;
            if (_arg_1 == null)
            {
                _arg_1 = "";
            };
            if (_arg_2 == null)
            {
                _arg_2 = "";
            };
            if (_arg_1 == _arg_2)
            {
                return (0);
            };
            var _local_3:Array = new Array();
            var _local_5:uint = _arg_1.length;
            var _local_6:uint = _arg_2.length;
            if (_local_5 == 0)
            {
                return (_local_6);
            };
            if (_local_6 == 0)
            {
                return (_local_5);
            };
            var _local_7:uint;
            while (_local_7 <= _local_5)
            {
                _local_3[_local_7] = new Array();
                _local_7++;
            };
            var _local_8:uint;
            while (_local_8 <= _local_5)
            {
                _local_3[_local_8][0] = _local_8;
                _local_8++;
            };
            var _local_9:uint;
            while (_local_9 <= _local_6)
            {
                _local_3[0][_local_9] = _local_9;
                _local_9++;
            };
            var _local_10:uint = 1;
            while (_local_10 <= _local_5)
            {
                _local_11 = _arg_1.charAt((_local_10 - 1));
                _local_12 = 1;
                while (_local_12 <= _local_6)
                {
                    _local_13 = _arg_2.charAt((_local_12 - 1));
                    if (_local_11 == _local_13)
                    {
                        _local_4 = 0;
                    }
                    else
                    {
                        _local_4 = 1;
                    };
                    _local_3[_local_10][_local_12] = Math.min((_local_3[(_local_10 - 1)][_local_12] + 1), (_local_3[_local_10][(_local_12 - 1)] + 1), (_local_3[(_local_10 - 1)][(_local_12 - 1)] + _local_4));
                    _local_12++;
                };
                _local_10++;
            };
            return (_local_3[_local_5][_local_6]);
        }

        public static function endsWith(_arg_1:String, _arg_2:String):Boolean
        {
            return (new RegExp((_arg_2 + "$")).test(_arg_1));
        }

        public static function hasText(_arg_1:String):Boolean
        {
            var _local_2:String = removeExtraWhitespace(_arg_1);
            return (!(!(_local_2.length)));
        }

        public static function isEmpty(_arg_1:String):Boolean
        {
            if (_arg_1 == null)
            {
                return (true);
            };
            return (!(_arg_1.length));
        }

        public static function isNumeric(_arg_1:String):Boolean
        {
            if (_arg_1 == null)
            {
                return (false);
            };
            var _local_2:RegExp = /^[-+]?\d*\.?\d+(?:[eE][-+]?\d+)?$/;
            return (_local_2.test(_arg_1));
        }

        public static function padLeft(_arg_1:String, _arg_2:String, _arg_3:uint):String
        {
            var _local_4:String = _arg_1;
            while (_local_4.length < _arg_3)
            {
                _local_4 = (_arg_2 + _local_4);
            };
            return (_local_4);
        }

        public static function padRight(_arg_1:String, _arg_2:String, _arg_3:uint):String
        {
            var _local_4:String = _arg_1;
            while (_local_4.length < _arg_3)
            {
                _local_4 = (_local_4 + _arg_2);
            };
            return (_local_4);
        }

        public static function properCase(_arg_1:String):String
        {
            if (_arg_1 == null)
            {
                return ("");
            };
            var _local_2:String = _arg_1.toLowerCase().replace(/\b([^.?;!]+)/, capitalize);
            return (_local_2.replace(/\b[i]\b/, "I"));
        }

        public static function quote(_arg_1:String):String
        {
            var _local_2:RegExp = /[\\"\r\n]/g;
            return (('"' + _arg_1.replace(_local_2, _quote)) + '"');
        }

        public static function relativePath(_arg_1:String, _arg_2:String, _arg_3:String="/"):String
        {
            var _local_4:String = _arg_1;
            if (endsWith(_arg_1, "/"))
            {
                _local_4 = StringUtils.beforeLast(_arg_1, "/");
            };
            var _local_5:String = _arg_2;
            if (endsWith(_arg_2, "/"))
            {
                _local_5 = StringUtils.beforeLast(_arg_2, "/");
            };
            var _local_6:Array = _local_4.split(_arg_3);
            var _local_7:Array = _local_5.split(_arg_3);
            var _local_8:int = Math.min(_local_6.length, _local_7.length);
            var _local_9:int;
            var _local_10:int;
            while (_local_10 < _local_8)
            {
                if (_local_6[_local_10].toLowerCase() !== _local_7[_local_10].toLowerCase()) break;
                _local_9++;
                _local_10++;
            };
            if (_local_9 == 0)
            {
                return (_arg_2);
            };
            var _local_11:String = "";
            _local_8 = _local_6.length;
            _local_10 = _local_9;
            while (_local_10 < _local_8)
            {
                if (_local_10 > _local_9)
                {
                    _local_11 = (_local_11 + _arg_3);
                };
                _local_11 = (_local_11 + "..");
                _local_10++;
            };
            if (_local_11.length == 0)
            {
                _local_11 = ".";
            };
            _local_8 = _local_7.length;
            _local_10 = _local_9;
            while (_local_10 < _local_8)
            {
                _local_11 = (_local_11 + _arg_3);
                _local_11 = (_local_11 + _local_7[_local_10]);
                _local_10++;
            };
            return (_local_11);
        }

        public static function remove(_arg_1:String, _arg_2:String, _arg_3:Boolean=true):String
        {
            if (_arg_1 == null)
            {
                return ("");
            };
            var _local_4:String = escapePattern(_arg_2);
            var _local_5:String = ((!(_arg_3)) ? "ig" : "g");
            return (_arg_1.replace(new RegExp(_local_4, _local_5), ""));
        }

        public static function removeExtraWhitespace(_arg_1:String):String
        {
            if (_arg_1 == null)
            {
                return ("");
            };
            var _local_2:String = trim(_arg_1);
            return (_local_2.replace(/\s+/g, " "));
        }

        public static function reverse(_arg_1:String):String
        {
            if (_arg_1 == null)
            {
                return ("");
            };
            return (_arg_1.split("").reverse().join(""));
        }

        public static function reverseWords(_arg_1:String):String
        {
            if (_arg_1 == null)
            {
                return ("");
            };
            return (_arg_1.split(/\s+/).reverse().join(""));
        }

        public static function similarity(_arg_1:String, _arg_2:String):Number
        {
            var _local_3:uint = editDistance(_arg_1, _arg_2);
            var _local_4:uint = Math.max(_arg_1.length, _arg_2.length);
            if (_local_4 == 0)
            {
                return (1);
            };
            return (1 - (_local_3 / _local_4));
        }

        public static function stripTags(_arg_1:String):String
        {
            if (_arg_1 == null)
            {
                return ("");
            };
            return (_arg_1.replace(/<\/?[^>]+>/igm, ""));
        }

        public static function supplant(_arg_1:String, ... _args):String
        {
            var _local_4:String;
            var _local_5:int;
            var _local_6:int;
            var _local_3:String = _arg_1;
            if ((_args[0] is Object))
            {
                for (_local_4 in _args[0])
                {
                    _local_3 = _local_3.replace(new RegExp((("\\{" + _local_4) + "\\}"), "g"), _args[0][_local_4]);
                };
            }
            else
            {
                _local_5 = _args.length;
                _local_6 = 0;
                while (_local_6 < _local_5)
                {
                    _local_3 = _local_3.replace(new RegExp((("\\{" + _local_6) + "\\}"), "g"), _args[_local_6]);
                    _local_6++;
                };
            };
            return (_local_3);
        }

        public static function swapCase(_arg_1:String):String
        {
            if (_arg_1 == null)
            {
                return ("");
            };
            return (_arg_1.replace(/(\w)/, _swapCase));
        }

        public static function trim(_arg_1:String):String
        {
            if (_arg_1 == null)
            {
                return ("");
            };
            return (_arg_1.replace(/^\s+|\s+$/g, ""));
        }

        public static function trimLeft(_arg_1:String):String
        {
            if (_arg_1 == null)
            {
                return ("");
            };
            return (_arg_1.replace(/^\s+/, ""));
        }

        public static function trimRight(_arg_1:String):String
        {
            if (_arg_1 == null)
            {
                return ("");
            };
            return (_arg_1.replace(/\s+$/, ""));
        }

        public static function truncate(_arg_1:String, _arg_2:uint, _arg_3:String="..."):String
        {
            if (_arg_1 == null)
            {
                return ("");
            };
            if (_arg_2 == 0)
            {
                _arg_2 = _arg_1.length;
            };
            _arg_2 = (_arg_2 - _arg_3.length);
            var _local_4:String = _arg_1;
            if (_local_4.length > _arg_2)
            {
                _local_4 = _local_4.substr(0, _arg_2);
                if (/[^\s]/.test(_arg_1.charAt(_arg_2)))
                {
                    _local_4 = trimRight(_local_4.replace(/\w+$|\s+$/, ""));
                };
                _local_4 = (_local_4 + _arg_3);
            };
            return (_local_4);
        }

        public static function wordCount(_arg_1:String):uint
        {
            if (_arg_1 == null)
            {
                return (0);
            };
            return (_arg_1.match(/\b\w+\b/g).length);
        }

        private static function escapePattern(_arg_1:String):String
        {
            return (_arg_1.replace(/(\]|\[|\{|\}|\(|\)|\*|\+|\?|\.|\\)/g, "\\$1"));
        }

        private static function _quote(_arg_1:String, ... _args):String
        {
            switch (_arg_1)
            {
                case "\\":
                    return ("\\\\");
                case "\r":
                    return ("\\r");
                case "\n":
                    return ("\\n");
                case '"':
                    return ('\\"');
            };
            return (null);
        }

        private static function _upperCase(_arg_1:String, ... _args):String
        {
            return (_arg_1.toUpperCase());
        }

        private static function _swapCase(_arg_1:String, ... _args):String
        {
            var _local_3:String = _arg_1.toLowerCase();
            var _local_4:String = _arg_1.toUpperCase();
            switch (_arg_1)
            {
                case _local_3:
                    return (_local_4);
                case _local_4:
                    return (_local_3);
                default:
                    return (_arg_1);
            };
        }

        public static function converBoolean(_arg_1:String):Boolean
        {
            if (_arg_1.toLowerCase() == "true")
            {
                return (true);
            };
            return (false);
        }

        public static function dictionaryKeyToString(_arg_1:Dictionary):String
        {
            var _local_3:String;
            var _local_2:Array = [];
            for (_local_3 in _arg_1)
            {
                _local_2.push(_local_3);
            };
            return (_local_2.join(","));
        }

        public static function trimHtmlText(_arg_1:String):String
        {
            return (null);
        }

        public static function replaceValueByIndex(_arg_1:String, ... _args):String
        {
            var _local_4:int;
            var _local_5:String;
            var _local_6:int;
            var _local_3:Object = _reg.exec(_arg_1);
            while (((_local_3) && (_args.length > 0)))
            {
                _local_4 = int(_local_3[1]);
                _local_5 = String(_args[_local_4]);
                if (((_local_4 >= 0) && (_local_4 < _args.length)))
                {
                    _local_6 = _local_5.indexOf("$");
                    if (_local_6 > -1)
                    {
                        _local_5 = ((_local_5.slice(0, _local_6) + "$") + _local_5.slice(_local_6));
                    };
                    _arg_1 = _arg_1.replace(_reg, _local_5);
                }
                else
                {
                    _arg_1 = _arg_1.replace(_reg, "{}");
                };
                _local_3 = _reg.exec(_arg_1);
            };
            return (_arg_1);
        }

        public static function getTimeTick():String
        {
            var _local_1:Date = new Date();
            return (_local_1.time.toString());
        }


    }
}//package com.pickgliss.utils

