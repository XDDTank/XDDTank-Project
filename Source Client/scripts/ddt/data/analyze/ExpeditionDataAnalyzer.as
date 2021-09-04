package ddt.data.analyze
{
   import SingleDungeon.expedition.ExpeditionInfo;
   import com.pickgliss.loader.DataAnalyzer;
   import com.pickgliss.utils.ObjectUtils;
   import road7th.data.DictionaryData;
   
   public class ExpeditionDataAnalyzer extends DataAnalyzer
   {
       
      
      private var _list:DictionaryData;
      
      public function ExpeditionDataAnalyzer(param1:Function)
      {
         super(param1);
      }
      
      public function get list() : DictionaryData
      {
         return this._list;
      }
      
      override public function analyze(param1:*) : void
      {
         var _loc3_:XMLList = null;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:ExpeditionInfo = null;
         this._list = new DictionaryData();
         var _loc2_:XML = new XML(param1);
         if(_loc2_.@value == "true")
         {
            _loc3_ = _loc2_..Item;
            _loc4_ = _loc3_.length();
            _loc5_ = 0;
            while(_loc5_ < _loc3_.length())
            {
               _loc6_ = new ExpeditionInfo();
               ObjectUtils.copyPorpertiesByXML(_loc6_,_loc3_[_loc5_]);
               this._list.add(_loc6_.SceneID,_loc6_);
               _loc5_++;
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
