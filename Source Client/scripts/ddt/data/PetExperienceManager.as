package ddt.data
{
   import ddt.data.analyze.PetExpericenceAnalyze;
   import ddt.manager.ServerConfigManager;
   
   public class PetExperienceManager
   {
      
      public static var expericence:Vector.<PetExperience>;
      
      public static var MAX_LEVEL:int = 0;
       
      
      public function PetExperienceManager()
      {
         super();
      }
      
      public static function setup(param1:PetExpericenceAnalyze) : void
      {
         var analyzer:PetExpericenceAnalyze = param1;
         expericence = analyzer.expericence;
         expericence = expericence.sort(function(param1:PetExperience, param2:PetExperience):int
         {
            return param1.Level > param2.Level ? int(1) : int(-1);
         });
         MAX_LEVEL = int(ServerConfigManager.instance.findInfoByName(ServerConfigManager.PET_MAX_LEVEL).Value);
      }
      
      public static function getCurrentExp(param1:int, param2:int) : int
      {
         return param1 - expericence[param2 - 1].GP;
      }
      
      public static function getUpgradeExp(param1:int, param2:int) : int
      {
         var _loc3_:int = expericence[param2].GP - param1;
         return _loc3_ > 0 ? int(_loc3_) : int(0);
      }
      
      public static function getNextPetExp(param1:int) : int
      {
         if(param1 == 1)
         {
            return expericence[param1].GP;
         }
         if(param1 < MAX_LEVEL)
         {
            return expericence[param1].GP - expericence[param1 - 1].GP;
         }
         return 0;
      }
      
      public static function getCurrentSpaceExp(param1:int, param2:int) : int
      {
         if(param2 < MAX_LEVEL)
         {
            return param1 - expericence[param2 - 1].ZoneExp;
         }
         return 0;
      }
      
      public static function getNextSpaceExp(param1:int) : int
      {
         if(param1 == 1)
         {
            return expericence[param1].ZoneExp;
         }
         if(param1 < MAX_LEVEL)
         {
            return expericence[param1].ZoneExp - expericence[param1 - 1].ZoneExp;
         }
         return 0;
      }
      
      public static function getUpgradeSpaceExp(param1:int, param2:int) : int
      {
         if(param2 < MAX_LEVEL)
         {
            return expericence[param2].ZoneExp - param1;
         }
         return 0;
      }
      
      public static function getLevelByGP(param1:int) : PetExperience
      {
         var _loc2_:PetExperience = null;
         for each(_loc2_ in expericence)
         {
            if(_loc2_.GP >= param1)
            {
               return _loc2_;
            }
         }
         return null;
      }
   }
}
