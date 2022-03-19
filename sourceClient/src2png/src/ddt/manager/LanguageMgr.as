// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//ddt.manager.LanguageMgr

package ddt.manager
{
    import flash.utils.Dictionary;
    import com.pickgliss.utils.StringUtils;

    public class LanguageMgr 
    {

        private static var _dic:Dictionary;
        private static var _reg:RegExp = new RegExp("\\{(\\d+)\\}");


        public static function setup(_arg_1:String):void
        {
            _dic = new Dictionary();
            analyze(_arg_1);
        }

        private static function analyze(_arg_1:String):void
        {
            var _local_4:String;
            var _local_5:int;
            var _local_6:String;
            var _local_7:String;
            var _local_2:Array = String(_arg_1).split("\r\n");
            var _local_3:int;
            while (_local_3 < _local_2.length)
            {
                _local_4 = _local_2[_local_3];
                if (_local_4.indexOf("#") != 0)
                {
                    _local_4 = _local_4.replace(/\\r/g, "\r");
                    _local_4 = _local_4.replace(/\\n/g, "\n");
                    _local_5 = _local_4.indexOf(":");
                    if (_local_5 != -1)
                    {
                        _local_6 = _local_4.substring(0, _local_5);
                        _local_7 = _local_4.substr((_local_5 + 1));
                        _local_7 = _local_7.split("##")[0];
                        _dic[_local_6] = StringUtils.trimRight(_local_7);
                    };
                };
                _local_3++;
            };
        }

        public static function GetTranslation(_arg_1:String, ... _args):String
        {
            var _local_5:int;
            var _local_6:String;
            var _local_7:int;
            var _local_3:String = ((_dic[_arg_1]) ? _dic[_arg_1] : "");
            var _local_4:Object = _reg.exec(_local_3);
            while (((_local_4) && (_args.length > 0)))
            {
                _local_5 = int(_local_4[1]);
                _local_6 = String(_args[_local_5]);
                if (((_local_5 >= 0) && (_local_5 < _args.length)))
                {
                    _local_7 = _local_6.indexOf("$");
                    if (_local_7 > -1)
                    {
                        _local_6 = ((_local_6.slice(0, _local_7) + "$") + _local_6.slice(_local_7));
                    };
                    _local_3 = _local_3.replace(_reg, _local_6);
                }
                else
                {
                    _local_3 = _local_3.replace(_reg, "{}");
                };
                _local_4 = _reg.exec(_local_3);
            };
            return (_local_3);
        }


    }
}//package ddt.manager

