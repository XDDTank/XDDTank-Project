package SingleDungeon.dataAnalyzer
{
   import SingleDungeon.model.BigMapModel;
   import com.pickgliss.loader.DataAnalyzer;
   import com.pickgliss.utils.ObjectUtils;
   
   public class BigMapDataAnalyzer extends DataAnalyzer
   {
       
      
      public var bigMapList:Vector.<BigMapModel>;
      
      public function BigMapDataAnalyzer(param1:Function)
      {
         super(param1);
      }
      
      override public function analyze(param1:*) : void
      {
         var _loc3_:XMLList = null;
         var _loc4_:int = 0;
         var _loc5_:BigMapModel = null;
         this.bigMapList = new Vector.<BigMapModel>();
         var _loc2_:XML = new XML(param1);
         if(_loc2_.@value == "true")
         {
            _loc3_ = _loc2_..item;
            _loc4_ = 0;
            while(_loc4_ < _loc3_.length())
            {
               _loc5_ = new BigMapModel();
               ObjectUtils.copyPorpertiesByXML(_loc5_,_loc3_[_loc4_]);
               this.bigMapList.push(_loc5_);
               _loc4_++;
            }
            onAnalyzeComplete();
         }
         else
         {
            onAnalyzeError();
         }
      }
   }
}
