package ddt.data.analyze
{
   import com.pickgliss.loader.DataAnalyzer;
   import flash.utils.Dictionary;
   
   public class PetSkillEliementAnalyzer extends DataAnalyzer
   {
       
      
      public var buffTemplateInfo:Dictionary;
      
      public function PetSkillEliementAnalyzer(param1:Function)
      {
         this.buffTemplateInfo = new Dictionary();
         super(param1);
      }
      
      override public function analyze(param1:*) : void
      {
         var _loc3_:XMLList = null;
         var _loc4_:XML = null;
         var _loc5_:BuffTemplateInfo = null;
         var _loc2_:XML = new XML(param1);
         if(_loc2_.@value == "true")
         {
            _loc3_ = _loc2_..Item;
            for each(_loc4_ in _loc3_)
            {
               _loc5_ = new BuffTemplateInfo();
               _loc5_.ID = _loc4_.@ID;
               _loc5_.Name = _loc4_.@Name;
               _loc5_.Description = _loc4_.@Description;
               _loc5_.EffectPic = _loc4_.@EffectPic;
               this.buffTemplateInfo[_loc5_.ID] = _loc5_;
            }
            onAnalyzeComplete();
         }
         else
         {
            message = _loc2_.@message;
            onAnalyzeError();
            onAnalyzeComplete();
         }
      }
   }
}

class BuffTemplateInfo
{
    
   
   public var ID:int;
   
   public var Name:String;
   
   public var Description:String;
   
   public var EffectPic:String;
   
   function BuffTemplateInfo()
   {
      super();
   }
}
