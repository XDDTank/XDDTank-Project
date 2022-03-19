// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//ddt.manager.ExternalInterfaceManager

package ddt.manager
{
    import flash.net.URLLoader;
    import flash.net.URLRequest;
    import flash.net.URLVariables;
    import flash.net.sendToURL;
    import flash.external.ExternalInterface;

    public class ExternalInterfaceManager 
    {

        private static var loader:URLLoader;
        private static var _clientType:int;


        public static function sendToAgent(_arg_1:int, _arg_2:int=-1, _arg_3:String="", _arg_4:String="", _arg_5:int=-1, _arg_6:String="", _arg_7:String=""):void
        {
            var _local_8:URLRequest = new URLRequest(PathManager.solveExternalInterfacePath());
            var _local_9:URLVariables = new URLVariables();
            _local_9["op"] = _arg_1;
            if (_arg_2 > -1)
            {
                _local_9["uid"] = _arg_2;
            };
            if (_arg_3 != "")
            {
                _local_9["role"] = _arg_3;
            };
            if (_arg_4 != "")
            {
                _local_9["ser"] = _arg_4;
            };
            if (_arg_5 > -1)
            {
                _local_9["num"] = _arg_5;
            };
            if (_arg_6 != "")
            {
                _local_9["pn"] = _arg_6;
            };
            if (_arg_7 != "")
            {
                _local_9["role2"] = _arg_7;
            };
            _local_8.data = _local_9;
            sendToURL(_local_8);
        }

        public static function sendTo360Agent(_arg_1:int):void
        {
            var _local_6:URLRequest;
            var _local_7:URLVariables;
            var _local_2:String = PathManager.solveFillPage();
            var _local_3:Number = (_local_2.indexOf("server_id=") + 10);
            var _local_4:Number = _local_2.indexOf("&uid");
            var _local_5:String = _local_2.slice(_local_3, _local_4);
            if (PathManager.ExternalInterface360Enabel())
            {
                _local_6 = new URLRequest(PathManager.ExternalInterface360Path());
                _local_7 = new URLVariables();
                _local_7["game"] = "ddt";
                _local_7["server"] = _local_5;
                _local_7["qid"] = PlayerManager.Instance.Account.Account;
                _local_7["event"] = getEvent(_arg_1);
                _local_7["time"] = new Date().getTime();
                _local_6.data = _local_7;
                sendToURL(_local_6);
            };
        }

        private static function getEvent(_arg_1:int):String
        {
            switch (_arg_1)
            {
                case 0:
                    return ("pageload");
                case 1:
                    return ("beforeloadflash");
                case 2:
                    return ("flashloaded");
                case 3:
                    return ("playercreated");
                case 4:
                    return ("entergame");
                default:
                    return ("");
            };
        }

        public static function traceToBrowser(_arg_1:String):void
        {
            if (ExternalInterface.available)
            {
                ExternalInterface.call("debugTrace", _arg_1);
            };
        }


    }
}//package ddt.manager

