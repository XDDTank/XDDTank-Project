package consortion.analyze
{
   import com.pickgliss.loader.DataAnalyzer;
   import com.pickgliss.utils.ObjectUtils;
   import consortion.data.ConsortionProbabilityInfo;
   
   public class ConsortiaShopListAnalyzer extends DataAnalyzer
   {
       
      
      public var ProbabilityInfoList:Vector.<ConsortionProbabilityInfo>;
      
      public function ConsortiaShopListAnalyzer(param1:Function)
      {
         super(param1);
      }
      
      override public function analyze(param1:*) : void
      {
         var _loc3_:XMLList = null;
         var _loc4_:int = 0;
         var _loc5_:ConsortionProbabilityInfo = null;
         this.ProbabilityInfoList = new Vector.<ConsortionProbabilityInfo>();
         var _loc2_:XML = new XML(param1);
         if(_loc2_.@value == "true")
         {
            _loc3_ = XML(_loc2_)..Item;
            _loc4_ = 0;
            while(_loc4_ < _loc3_.length())
            {
               _loc5_ = new ConsortionProbabilityInfo();
               ObjectUtils.copyPorpertiesByXML(_loc5_,_loc3_[_loc4_]);
               this.ProbabilityInfoList.push(_loc5_);
               _loc4_++;
            }
            onAnalyzeComplete();
         }
         else
         {
            message = _loc2_.@message;
            onAnalyzeError();
         }
      }
   }
}
