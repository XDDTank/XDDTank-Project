package ddt.data.analyze
{
   import com.pickgliss.loader.DataAnalyzer;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.goods.EquipmentTemplateInfo;
   import road7th.data.DictionaryData;
   
   public class EquipmentTemplateAnalyzer extends DataAnalyzer
   {
       
      
      private var _list:DictionaryData;
      
      public function EquipmentTemplateAnalyzer(param1:Function)
      {
         super(param1);
      }
      
      override public function analyze(param1:*) : void
      {
         var _loc3_:XMLList = null;
         var _loc4_:int = 0;
         var _loc5_:EquipmentTemplateInfo = null;
         this._list = new DictionaryData();
         var _loc2_:XML = new XML(param1);
         if(_loc2_.@value == "true")
         {
            _loc3_ = _loc2_..item;
            _loc4_ = 0;
            while(_loc4_ < _loc3_.length())
            {
               _loc5_ = new EquipmentTemplateInfo();
               ObjectUtils.copyPorpertiesByXML(_loc5_,_loc3_[_loc4_]);
               this._list.add(_loc5_.TemplateID,_loc5_);
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
      
      public function get list() : DictionaryData
      {
         return this._list;
      }
   }
}
