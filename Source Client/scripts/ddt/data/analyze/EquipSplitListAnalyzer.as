package ddt.data.analyze
{
   import com.pickgliss.loader.DataAnalyzer;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.goods.SpliteListInfo;
   import road7th.data.DictionaryData;
   
   public class EquipSplitListAnalyzer extends DataAnalyzer
   {
       
      
      private var _list:DictionaryData;
      
      public function EquipSplitListAnalyzer(param1:Function)
      {
         super(param1);
      }
      
      override public function analyze(param1:*) : void
      {
         var _loc2_:String = null;
         var _loc4_:XMLList = null;
         var _loc5_:int = 0;
         var _loc6_:SpliteListInfo = null;
         this._list = new DictionaryData();
         var _loc3_:XML = new XML(param1);
         if(_loc3_.@value == "true")
         {
            _loc4_ = _loc3_.item;
            _loc5_ = 0;
            while(_loc5_ < _loc4_.length())
            {
               _loc6_ = new SpliteListInfo();
               ObjectUtils.copyPorpertiesByXML(_loc6_,_loc4_[_loc5_]);
               this._list.add(_loc6_.TemplateID,_loc6_);
               _loc5_++;
            }
            onAnalyzeComplete();
         }
         else
         {
            message = _loc3_.@message;
            onAnalyzeError();
         }
      }
      
      public function get list() : DictionaryData
      {
         return this._list;
      }
   }
}
