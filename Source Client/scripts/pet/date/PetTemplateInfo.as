package pet.date
{
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   
   public class PetTemplateInfo extends EventDispatcher
   {
       
      
      public var TemplateID:int;
      
      public var Name:String = "";
      
      public var KindID:int;
      
      public var Description:String;
      
      public var AdoptVipLevel:int;
      
      public var MagicId:int;
      
      public var ItemId:int;
      
      public var ItemNum:int;
      
      public var Pic:String;
      
      public var GameAssetUrl:String;
      
      public var Blood:int;
      
      public var BloodGrow:int;
      
      public var Attack:int;
      
      public var AttackGrow:int;
      
      public var Defence:int;
      
      public var DefenceGrow:int;
      
      public var Agility:int;
      
      public var AgilityGrow:int;
      
      public var Luck:int;
      
      public var LuckGrow:int;
      
      public var VAttackGrow:int;
      
      public var VDefenceGrow:int;
      
      public var VAgilityGrow:int;
      
      public var VLuckGrow:int;
      
      public var VBloodGrow:int;
      
      public var Charcacter:String;
      
      public var BestUseType:String;
      
      public function PetTemplateInfo(param1:IEventDispatcher = null)
      {
         super(param1);
      }
   }
}
