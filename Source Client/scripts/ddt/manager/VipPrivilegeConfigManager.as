package ddt.manager
{
   import ddt.data.VipConfigInfo;
   import ddt.data.analyze.VipPrivilegeConfigAnalyzer;
   import flash.events.EventDispatcher;
   import road7th.data.DictionaryData;
   
   public class VipPrivilegeConfigManager extends EventDispatcher
   {
      
      private static var _instance:VipPrivilegeConfigManager;
       
      
      private var _vipPrivilege:DictionaryData;
      
      public function VipPrivilegeConfigManager()
      {
         super();
      }
      
      public static function get Instance() : VipPrivilegeConfigManager
      {
         if(_instance == null)
         {
            _instance = new VipPrivilegeConfigManager();
         }
         return _instance;
      }
      
      public function setupVipList(param1:VipPrivilegeConfigAnalyzer) : void
      {
         this._vipPrivilege = param1.vipConfigInfoList;
      }
      
      public function getById(param1:int) : VipConfigInfo
      {
         if(this._vipPrivilege == null)
         {
            return null;
         }
         return this._vipPrivilege[param1];
      }
   }
}
