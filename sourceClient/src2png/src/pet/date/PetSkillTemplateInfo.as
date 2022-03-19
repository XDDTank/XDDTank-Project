// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//pet.date.PetSkillTemplateInfo

package pet.date
{
    import flash.events.EventDispatcher;
    import ddt.manager.PetSkillManager;

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


        public function get skillInfo():PetBaseSkillInfo
        {
            return (this._skillInfo = ((this._skillInfo) || (PetSkillManager.instance.getSkillBaseInfo(this.SkillID))));
        }


    }
}//package pet.date

