// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//petsBag.event.PetSkillEvent

package petsBag.event
{
    import flash.events.Event;
    import pet.date.PetSkillTemplateInfo;

    public class PetSkillEvent extends Event 
    {

        public static const UPGRADE:String = "pet skill upgrade";

        public var data:PetSkillTemplateInfo;

        public function PetSkillEvent(_arg_1:String, _arg_2:PetSkillTemplateInfo)
        {
            super(_arg_1);
            this.data = _arg_2;
        }

    }
}//package petsBag.event

