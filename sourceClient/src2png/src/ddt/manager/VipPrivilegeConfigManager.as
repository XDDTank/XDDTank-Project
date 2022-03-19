// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//ddt.manager.VipPrivilegeConfigManager

package ddt.manager
{
    import flash.events.EventDispatcher;
    import road7th.data.DictionaryData;
    import ddt.data.analyze.VipPrivilegeConfigAnalyzer;
    import ddt.data.VipConfigInfo;

    public class VipPrivilegeConfigManager extends EventDispatcher 
    {

        private static var _instance:VipPrivilegeConfigManager;

        private var _vipPrivilege:DictionaryData;


        public static function get Instance():VipPrivilegeConfigManager
        {
            if (_instance == null)
            {
                _instance = new (VipPrivilegeConfigManager)();
            };
            return (_instance);
        }


        public function setupVipList(_arg_1:VipPrivilegeConfigAnalyzer):void
        {
            this._vipPrivilege = _arg_1.vipConfigInfoList;
        }

        public function getById(_arg_1:int):VipConfigInfo
        {
            if (this._vipPrivilege == null)
            {
                return (null);
            };
            return (this._vipPrivilege[_arg_1]);
        }


    }
}//package ddt.manager

