package petsBag.event
{
   import flash.events.Event;
   import pet.date.PetSkillTemplateInfo;
   
   public class PetSkillEvent extends Event
   {
      
      public static const UPGRADE:String = "pet skill upgrade";
       
      
      public var data:PetSkillTemplateInfo;
      
      public function PetSkillEvent(param1:String, param2:PetSkillTemplateInfo)
      {
         super(param1);
         this.data = param2;
      }
   }
}
