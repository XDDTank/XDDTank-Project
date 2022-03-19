// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//ddt.utils.FilterWordManager

package ddt.utils
{
    import ddt.data.analyze.FilterWordAnalyzer;
    import road7th.utils.StringHelper;

    public class FilterWordManager 
    {

        private static var unableChar:String = "";
        private static var CHANNEL_WORDS:Array = ["当前", "公会", "组队", "私聊", "小喇叭", "大喇叭", "跨区大喇叭"];
        private static var WORDS:Array = [];
        private static var SERVER_WORDS:Array = [];
        private static var REPLACEWORD:String = "~!@#$@#$%~!@#$@#%^&@~!@#$@##$%*~!@#$$@#%^&@~!@#$@#@#";
        private static const FILTER_TYPE_ALL:String = "all";
        private static const FILTER_TYPE_CHAT:String = "chat";
        private static const FILTER_TYPE_NAME:String = "name";
        private static const FILTER_TYPE_SERVER:String = "server";


        public static function setup(_arg_1:FilterWordAnalyzer):void
        {
            WORDS = _arg_1.words;
            SERVER_WORDS = _arg_1.serverWords;
            unableChar = _arg_1.unableChar;
            clearnUpNaN_Char(WORDS);
            clearnUpNaN_Char(SERVER_WORDS);
        }

        private static function clearnUpNaN_Char(_arg_1:Array):void
        {
            var _local_2:int;
            while (_local_2 < _arg_1.length)
            {
                if (StringHelper.trim(_arg_1[_local_2]).length == 0)
                {
                    _arg_1.splice(_local_2, 1);
                }
                else
                {
                    _local_2++;
                };
            };
        }

        public static function containUnableChar(_arg_1:String):Boolean
        {
            var _local_2:int = _arg_1.length;
            var _local_3:int;
            while (_local_3 < _local_2)
            {
                if (unableChar.indexOf(_arg_1.charAt(_local_3)) > -1)
                {
                    return (true);
                };
                _local_3++;
            };
            return (false);
        }

        public static function isGotForbiddenWords(_arg_1:String, _arg_2:String="chat"):Boolean
        {
            var _local_5:int;
            var _local_3:String = StringHelper.trimAll(_arg_1.toLocaleLowerCase());
            var _local_4:uint = WORDS.length;
            if ((((_arg_2 == FILTER_TYPE_NAME) || (_arg_2 == FILTER_TYPE_CHAT)) || (_arg_2 == FILTER_TYPE_ALL)))
            {
                _local_5 = 0;
                while (_local_5 < _local_4)
                {
                    if (_local_3.indexOf(WORDS[_local_5]) > -1)
                    {
                        return (true);
                    };
                    _local_5++;
                };
            };
            if (_arg_2 == FILTER_TYPE_SERVER)
            {
                _local_4 = SERVER_WORDS.length;
                _local_5 = 0;
                while (_local_5 < _local_4)
                {
                    if (_local_3.indexOf(SERVER_WORDS[_local_5]) > -1)
                    {
                        return (true);
                    };
                    _local_5++;
                };
            };
            return (false);
        }

        private static function formatForbiddenWords(_arg_1:String, _arg_2:Array):String
        {
            var _local_3:String;
            var _local_7:Object;
            if (_arg_2 != SERVER_WORDS)
            {
                _local_3 = StringHelper.trimAll(_arg_1.toLocaleLowerCase());
            }
            else
            {
                _local_3 = _arg_1;
            };
            var _local_4:int = _arg_2.length;
            var _local_5:Boolean;
            var _local_6:int;
            while (_local_6 < _local_4)
            {
                if (_local_3.indexOf(_arg_2[_local_6]) > -1)
                {
                    _local_5 = true;
                    _local_7 = new Object();
                    _local_7["word"] = _arg_2[_local_6];
                    _local_7["idx"] = _local_3.indexOf(_arg_2[_local_6]);
                    _local_7["length"] = _local_7["word"].length;
                    _local_3 = replaceUpperOrLowerCase(_local_3, _local_7);
                    _arg_1 = replaceUpperOrLowerCase(_arg_1, _local_7);
                    _local_6 = 0;
                };
                _local_6++;
            };
            return (_arg_1);
        }

        private static function formatChannelWords(_arg_1:String):String
        {
            var _local_5:uint;
            var _local_6:uint;
            var _local_7:uint;
            if ((!(_arg_1)))
            {
                return (undefined);
            };
            var _local_2:int = CHANNEL_WORDS.length;
            var _local_3:Boolean;
            var _local_4:int;
            while (_local_4 < _local_2)
            {
                _local_5 = _arg_1.indexOf(CHANNEL_WORDS[_local_4]);
                _local_6 = (_local_5 - 1);
                _local_7 = (_local_5 + CHANNEL_WORDS[_local_4].length);
                if (_local_5 > -1)
                {
                    if (((_local_6 > -1) && (_local_7 <= (_arg_1.length - 1))))
                    {
                        if (((_arg_1.slice(_local_6, (_local_6 + 1)) == "[") && (_arg_1.slice(_local_7, (_local_7 + 1)) == "]")))
                        {
                            _local_3 = true;
                            _arg_1 = ((_arg_1.slice(0, _local_5) + getXXX(CHANNEL_WORDS[_local_4].length)) + _arg_1.slice(_local_7));
                        };
                    };
                };
                _local_4++;
            };
            if (((_local_3) && (_arg_1)))
            {
                return (_arg_1);
            };
            return (undefined);
        }

        private static function replaceUpperOrLowerCase(_arg_1:String, _arg_2:Object):String
        {
            var _local_5:String;
            var _local_3:int = _arg_2["idx"];
            var _local_4:int = _arg_2["length"];
            if ((_local_3 + _local_4) >= _arg_1.length)
            {
                _local_5 = _arg_1.slice(_local_3);
            }
            else
            {
                _local_5 = _arg_1.slice(_local_3, (_local_3 + _local_4));
            };
            return (_arg_1.replace(_local_5, getXXX(_local_4)));
        }

        public static function filterWrod(_arg_1:String):String
        {
            var _local_4:String;
            var _local_5:String;
            var _local_2:String = StringHelper.trimAll(_arg_1);
            var _local_3:String = formatChannelWords(_local_2);
            if (_local_3)
            {
                _local_4 = formatForbiddenWords(_local_3, WORDS);
            }
            else
            {
                _local_4 = formatForbiddenWords(_local_2, WORDS);
            };
            if (_local_5)
            {
                return (_local_5);
            };
            if (_local_4)
            {
                return (_local_4);
            };
            if (_local_3)
            {
                return (_local_3);
            };
            return (_local_2);
        }

        public static function filterWrodFromServer(_arg_1:String):String
        {
            if (isGotForbiddenWords(_arg_1, FILTER_TYPE_SERVER))
            {
                _arg_1 = formatForbiddenWords(_arg_1, SERVER_WORDS);
            };
            return (_arg_1);
        }

        public static function IsNullorEmpty(_arg_1:String):Boolean
        {
            _arg_1 = StringHelper.trim(_arg_1);
            return (StringHelper.isNullOrEmpty(_arg_1));
        }

        private static function getXXX(_arg_1:int):String
        {
            var _local_2:uint = uint(Math.round((Math.random() * (REPLACEWORD.length / 4))));
            return (REPLACEWORD.slice(_local_2, (_local_2 + _arg_1)));
        }


    }
}//package ddt.utils

