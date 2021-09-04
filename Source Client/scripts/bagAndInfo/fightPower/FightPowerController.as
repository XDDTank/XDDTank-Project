package bagAndInfo.fightPower
{
   import ddt.manager.PlayerManager;
   
   public class FightPowerController
   {
      
      public static const TOTAL_FIGHT_POWER:uint = 1;
      
      public static const EQUIP_FIGHT_POWER:uint = 2;
      
      public static const STRENG_FIGHT_POWER:uint = 3;
      
      public static const BEAD_FIGHT_POWER:uint = 4;
      
      public static const PET_FIGHT_POWER:uint = 5;
      
      public static const TOTEM_FIGHT_POWER:uint = 6;
      
      public static const RUNE_FIGHT_POWER:uint = 7;
      
      public static const PET_ADVANCE_FIGHT_POWER:uint = 8;
      
      public static const REFINING_FIGHT_POWER:uint = 9;
      
      private static var _instance:FightPowerController;
       
      
      private var _fightPowerDescList:Vector.<FightPowerDescInfo>;
      
      public function FightPowerController()
      {
         super();
      }
      
      public static function get Instance() : FightPowerController
      {
         if(!_instance)
         {
            _instance = new FightPowerController();
         }
         return _instance;
      }
      
      public function setFightPowerDesc(param1:FightPowerDescAnalyzer) : void
      {
         this._fightPowerDescList = param1.list;
      }
      
      public function getFightPowerByType(param1:int, param2:Boolean = false) : Vector.<FightPowerDescInfo>
      {
         var _loc4_:FightPowerDescInfo = null;
         var _loc3_:Vector.<FightPowerDescInfo> = new Vector.<FightPowerDescInfo>();
         for each(_loc4_ in this._fightPowerDescList)
         {
            if(_loc4_.Type == param1)
            {
               _loc3_.push(_loc4_);
            }
         }
         if(param2)
         {
            _loc3_.sort(this.sortList);
         }
         return _loc3_;
      }
      
      public function getCurrentLevelValueByType(param1:int) : FightPowerDescInfo
      {
         var _loc3_:FightPowerDescInfo = null;
         var _loc2_:Vector.<FightPowerDescInfo> = this.getFightPowerByType(param1);
         for each(_loc3_ in _loc2_)
         {
            if(_loc3_.Level == PlayerManager.Instance.Self.Grade)
            {
               return _loc3_;
            }
         }
         return null;
      }
      
      public function getMinLevelByType(param1:int) : int
      {
         var _loc2_:Vector.<FightPowerDescInfo> = this.getFightPowerByType(param1,true);
         if(_loc2_.length == 0)
         {
            return 999;
         }
         return _loc2_[0].Level;
      }
      
      private function sortList(param1:FightPowerDescInfo, param2:FightPowerDescInfo) : int
      {
         if(param1.Level > param2.Level)
         {
            return 1;
         }
         return -1;
      }
      
      public function get fightPowerDescList() : Vector.<FightPowerDescInfo>
      {
         return this._fightPowerDescList;
      }
   }
}
