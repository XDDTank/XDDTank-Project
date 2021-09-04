package ddt.data.analyze
{
   import com.pickgliss.loader.DataAnalyzer;
   import com.pickgliss.utils.ObjectUtils;
   import flash.utils.Dictionary;
   import pet.date.PetEggInfo;
   
   public class PetEggInfoAnalyzer extends DataAnalyzer
   {
       
      
      public var list:Dictionary;
      
      public function PetEggInfoAnalyzer(param1:Function)
      {
         this.list = new Dictionary();
         super(param1);
      }
      
      override public function analyze(param1:*) : void
      {
         var _loc4_:XML = null;
         var _loc5_:PetEggInfo = null;
         var _loc2_:XML = XML(param1);
         var _loc3_:XMLList = _loc2_..Item;
         for each(_loc4_ in _loc3_)
         {
            _loc5_ = new PetEggInfo();
            ObjectUtils.copyPorpertiesByXML(_loc5_,_loc4_);
            if(!this.list[_loc5_.Kind])
            {
               this.list[_loc5_.Kind] = new Vector.<PetEggInfo>();
            }
            this.list[_loc5_.Kind].push(_loc5_);
         }
         onAnalyzeComplete();
      }
   }
}
