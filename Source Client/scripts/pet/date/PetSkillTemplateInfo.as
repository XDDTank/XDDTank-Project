package pet.date
{
   import ddt.manager.PetSkillManager;
   import flash.events.EventDispatcher;
   
   public class PetSkillTemplateInfo extends EventDispatcher
   {
       
      
      public var PetTemplateID:int;
      
      public var KindID:int;
      
      public var SkillLevel:int;
      
      public var SkillMaxLevel:int;
      
      public var SkillID:int;
      
      public var MinLevel:int;
      
      public var MagicSoul:int;
      
      public var BeforeSkillId:String;
      
      public var NextSkillId:int;
      
      public var SkillPlace:int;
      
      public var isLearing:Boolean;
      
      private var _skillInfo:PetBaseSkillInfo;
      
      public function PetSkillTemplateInfo()
      {
         super();
      }
      
      public function get skillInfo() : PetBaseSkillInfo
      {
         return this._skillInfo = this._skillInfo || PetSkillManager.instance.getSkillBaseInfo(this.SkillID);
      }
   }
}
