package pet.date
{
   import com.pickgliss.loader.ModuleLoader;
   import ddt.manager.PlayerManager;
   import flash.events.Event;
   import flash.utils.describeType;
   import game.GameManager;
   import road7th.data.DictionaryData;
   
   public class PetInfo extends PetTemplateInfo
   {
      
      public static const HUNGER_CHANGED:String = "hunger";
      
      public static const GP_CHANGED:String = "gp";
      
      public static const SKILL_COUNT:int = 6;
      
      public static const FULL_MAX_VALUE:int = 10000;
       
      
      public var ID:int;
      
      public var UserID:int;
      
      private var _skills:DictionaryData;
      
      public var Bless:int;
      
      public var OrderNumber:int;
      
      public var Level:int;
      
      private var _gp:int;
      
      public var MaxGP:int;
      
      private var _hunger:int;
      
      public var MaxActiveSkillCount:int;
      
      public var MaxStaticSkillCount:int;
      
      public var MaxSkillCount:int;
      
      public var PaySkillCount:int;
      
      public var Place:int;
      
      public var FightPower:int = 100;
      
      public var ActivationPlace:int;
      
      public var MagicLevel:int;
      
      public var PetHappyStar:int;
      
      public function PetInfo()
      {
         super();
         this._skills = new DictionaryData();
      }
      
      public function set GP(param1:int) : void
      {
         if(this._gp == param1)
         {
            return;
         }
         this._gp = param1;
         dispatchEvent(new Event(GP_CHANGED));
      }
      
      public function get GP() : int
      {
         return this._gp;
      }
      
      public function set Hunger(param1:int) : void
      {
         if(param1 == this._hunger)
         {
            return;
         }
         this._hunger = param1;
         dispatchEvent(new Event(HUNGER_CHANGED));
      }
      
      public function get Hunger() : int
      {
         return this._hunger;
      }
      
      public function get IsEquip() : Boolean
      {
         return this.Place == 0;
      }
      
      public function get IsActive() : Boolean
      {
         return this.Place > 0 && this.Place < 5;
      }
      
      public function get skills() : DictionaryData
      {
         return this._skills;
      }
      
      public function addSkill(param1:int, param2:int) : void
      {
         this._skills.add(param1,param2);
         if(PlayerManager.Instance.Self.ID == this.UserID)
         {
         }
      }
      
      public function clearSkills() : void
      {
         this._skills.clear();
         if(PlayerManager.Instance.Self.ID == this.UserID)
         {
         }
      }
      
      public function removeSkillByID(param1:int) : void
      {
         this._skills.remove(param1);
         if(PlayerManager.Instance.Self.ID == this.UserID)
         {
         }
      }
      
      public function hasSkill(param1:int) : Boolean
      {
         return Boolean(this._skills[param1]);
      }
      
      public function get actionMovieName() : String
      {
         return "pet.asset.game." + GameAssetUrl;
      }
      
      public function get assetReady() : Boolean
      {
         return ModuleLoader.hasDefinition(this.actionMovieName) || GameManager.Instance.Current.selfGamePlayer.isBoss;
      }
      
      public function get fightSkills() : Vector.<int>
      {
         var skillID:int = 0;
         var list:Vector.<int> = new Vector.<int>();
         for each(skillID in this.skills)
         {
            if(skillID > 0 && skillID < 1000)
            {
               list.push(skillID);
            }
         }
         list.sort(function(param1:int, param2:int):Number
         {
            return param1 < param2 ? Number(-1) : Number(1);
         });
         return list;
      }
      
      public function equal(param1:PetInfo) : Boolean
      {
         var _loc3_:XML = null;
         var _loc4_:String = null;
         if(!param1)
         {
            return false;
         }
         var _loc2_:XML = describeType(this);
         for each(_loc3_ in _loc2_.variable)
         {
            _loc4_ = _loc3_.@name;
            if(_loc4_ != "Place" && this[_loc4_] != param1[_loc4_])
            {
               return false;
            }
         }
         return true;
      }
   }
}
