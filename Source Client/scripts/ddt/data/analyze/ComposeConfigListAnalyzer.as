package ddt.data.analyze
{
   import com.pickgliss.loader.DataAnalyzer;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.goods.ComposeListInfo;
   import road7th.data.DictionaryData;
   
   public class ComposeConfigListAnalyzer extends DataAnalyzer
   {
       
      
      private var _list:DictionaryData;
      
      public function ComposeConfigListAnalyzer(param1:Function)
      {
         super(param1);
      }
      
      override public function analyze(param1:*) : void
      {
         var _loc2_:String = null;
         var _loc4_:XMLList = null;
         var _loc5_:int = 0;
         var _loc6_:ComposeListInfo = null;
         var _loc7_:Array = null;
         this._list = new DictionaryData();
         var _loc3_:XML = new XML(param1);
         if(_loc3_.@value == "true")
         {
            _loc4_ = _loc3_.item;
            _loc5_ = 0;
            while(_loc5_ < _loc4_.length())
            {
               _loc6_ = new ComposeListInfo();
               ObjectUtils.copyPorpertiesByXML(_loc6_,_loc4_[_loc5_]);
               if(_loc3_.item.@TemplateIDs)
               {
                  _loc2_ = _loc3_.item[_loc5_].@TemplateIDs;
                  if(_loc6_.Type != 1)
                  {
                     _loc6_.TemplateArray1 = _loc2_.split(",");
                  }
                  else
                  {
                     _loc7_ = _loc2_.split("|");
                     if(_loc7_[0])
                     {
                        _loc6_.TemplateArray1 = _loc7_[0].split(",");
                     }
                     if(_loc7_[1])
                     {
                        _loc6_.TemplateArray2 = _loc7_[1].split(",");
                     }
                     if(_loc7_[2])
                     {
                        _loc6_.TemplateArray3 = _loc7_[2].split(",");
                     }
                     if(_loc7_[3])
                     {
                        _loc6_.TemplateArray4 = _loc7_[3].split(",");
                     }
                     if(_loc7_[4])
                     {
                        _loc6_.TemplateArray5 = _loc7_[4].split(",");
                     }
                  }
               }
               this._list.add(_loc6_.ID,_loc6_);
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
