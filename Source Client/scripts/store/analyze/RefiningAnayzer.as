package store.analyze
{
   import com.pickgliss.loader.DataAnalyzer;
   import com.pickgliss.utils.ObjectUtils;
   import road7th.data.DictionaryData;
   import store.data.RefiningConfigInfo;
   
   public class RefiningAnayzer extends DataAnalyzer
   {
       
      
      public var list:DictionaryData;
      
      private var _xml:XML;
      
      public function RefiningAnayzer(param1:Function)
      {
         super(param1);
      }
      
      override public function analyze(param1:*) : void
      {
         var _loc3_:RefiningConfigInfo = null;
         var _loc4_:int = 0;
         this._xml = new XML(param1);
         var _loc2_:XMLList = this._xml.Item;
         if(this._xml.@value == "true")
         {
            this.list = new DictionaryData();
            _loc4_ = 0;
            while(_loc4_ < _loc2_.length())
            {
               _loc3_ = new RefiningConfigInfo();
               ObjectUtils.copyPorpertiesByXML(_loc3_,_loc2_[_loc4_]);
               this.list.add(_loc3_.Level,_loc3_);
               _loc4_++;
            }
            onAnalyzeComplete();
         }
         else
         {
            message = this._xml.@message;
            onAnalyzeError();
            onAnalyzeComplete();
         }
      }
   }
}
