package ddt.data.analyze
{
   import com.pickgliss.loader.DataAnalyzer;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.PetExperience;
   
   public class PetExpericenceAnalyze extends DataAnalyzer
   {
       
      
      public var expericence:Vector.<PetExperience>;
      
      public function PetExpericenceAnalyze(param1:Function)
      {
         super(param1);
      }
      
      override public function analyze(param1:*) : void
      {
         var _loc3_:XMLList = null;
         var _loc4_:XML = null;
         var _loc5_:PetExperience = null;
         var _loc2_:XML = new XML(param1);
         if(_loc2_.@value == "true")
         {
            _loc3_ = _loc2_..Item;
            this.expericence = new Vector.<PetExperience>();
            for each(_loc4_ in _loc3_)
            {
               _loc5_ = new PetExperience();
               ObjectUtils.copyPorpertiesByXML(_loc5_,_loc4_);
               this.expericence.push(_loc5_);
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
