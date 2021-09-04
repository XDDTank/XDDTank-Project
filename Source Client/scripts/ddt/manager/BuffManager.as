package ddt.manager
{
   import calendar.CalendarManager;
   import com.pickgliss.loader.BaseLoader;
   import com.pickgliss.loader.LoadResourceManager;
   import ddt.data.BuffInfo;
   import ddt.data.BuffType;
   import ddt.data.FightBuffInfo;
   import ddt.data.analyze.PetSkillEliementAnalyzer;
   import flash.utils.Dictionary;
   
   public class BuffManager
   {
      
      private static var _info:Dictionary;
       
      
      public function BuffManager()
      {
         super();
      }
      
      public static function creatBuff(param1:int) : FightBuffInfo
      {
         var _loc2_:FightBuffInfo = new FightBuffInfo(param1);
         if(BuffType.isCardBuff(_loc2_))
         {
            _loc2_.type = BuffType.CARD_BUFF;
            translateDisplayID(_loc2_);
         }
         else if(BuffType.isConsortiaBuff(_loc2_))
         {
            _loc2_.type = BuffType.CONSORTIA;
            translateDisplayID(_loc2_);
         }
         else if(BuffType.isLocalBuffByID(param1))
         {
            _loc2_.type = BuffType.Local;
            translateDisplayID(_loc2_);
            if(BuffType.isLuckyBuff(param1) && CalendarManager.getInstance().luckyNum >= 0)
            {
               _loc2_.displayid = CalendarManager.getInstance().luckyNum + 40;
            }
         }
         else if(BuffType.isMilitaryBuff(param1))
         {
            _loc2_.type = BuffType.MILITARY_BUFF;
            _loc2_.displayid = _loc2_.id;
         }
         else if(BuffType.isArenaBufferByID(param1))
         {
            _loc2_.type = BuffType.ARENA_BUFF;
            _loc2_.displayid = _loc2_.id;
         }
         else
         {
            _loc2_.displayid = _loc2_.id;
         }
         return _loc2_;
      }
      
      private static function translateDisplayID(param1:FightBuffInfo) : void
      {
         switch(param1.id)
         {
            case BuffType.AddPercentDamage:
               param1.displayid = BuffType.AddDamage;
               break;
            case BuffType.SetDefaultDander:
               param1.displayid = BuffType.TurnAddDander;
               break;
            case BuffType.AddDander:
               param1.displayid = BuffType.TurnAddDander;
               break;
            case BuffInfo.ADD_INVADE_ATTACK:
               param1.displayid = BuffInfo.ADD_INVADE_ATTACK;
               break;
            default:
               param1.displayid = param1.id;
         }
      }
      
      public static function setPetTemplate(param1:PetSkillEliementAnalyzer) : void
      {
         _info = param1.buffTemplateInfo;
      }
      
      public static function getResource(param1:String) : void
      {
         var _loc2_:Array = param1.split(",");
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_.length)
         {
            if(_loc2_[_loc3_] && _info[_loc2_[_loc3_]].EffectPic)
            {
               LoadResourceManager.instance.creatAndStartLoad(PathManager.solvePetSkillEffect(_info[_loc2_[_loc3_]].EffectPic),BaseLoader.MODULE_LOADER);
            }
            _loc3_++;
         }
      }
   }
}
