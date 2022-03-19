// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//petsBag.view.ISkillItem

package petsBag.view
{
    import pet.date.PetSkillTemplateInfo;
    import flash.geom.Point;

    public interface ISkillItem 
    {

        function get templeteInfo():PetSkillTemplateInfo;
        function set templeteInfo(_arg_1:PetSkillTemplateInfo):void;
        function get iconPos():Point;
        function set iconPos(_arg_1:Point):void;

    }
}//package petsBag.view

