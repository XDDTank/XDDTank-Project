package petsBag.view
{
   import flash.geom.Point;
   import pet.date.PetSkillTemplateInfo;
   
   public interface ISkillItem
   {
       
      
      function get templeteInfo() : PetSkillTemplateInfo;
      
      function set templeteInfo(param1:PetSkillTemplateInfo) : void;
      
      function get iconPos() : Point;
      
      function set iconPos(param1:Point) : void;
   }
}
