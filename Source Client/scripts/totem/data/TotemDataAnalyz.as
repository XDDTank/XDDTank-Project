package totem.data
{
   import com.pickgliss.loader.DataAnalyzer;
   import com.pickgliss.utils.ObjectUtils;
   
   public class TotemDataAnalyz extends DataAnalyzer
   {
       
      
      private var _dataList:Object;
      
      private var _dataList2:Object;
      
      public function TotemDataAnalyz(param1:Function)
      {
         super(param1);
      }
      
      override public function analyze(param1:*) : void
      {
         var _loc3_:XMLList = null;
         var _loc4_:int = 0;
         var _loc5_:TotemDataVo = null;
         this._dataList = {};
         this._dataList2 = {};
         var _loc2_:XML = new XML(param1);
         if(_loc2_.@value == "true")
         {
            _loc3_ = _loc2_..item;
            _loc4_ = 0;
            while(_loc4_ < _loc3_.length())
            {
               _loc5_ = new TotemDataVo();
               ObjectUtils.copyPorpertiesByXML(_loc5_,_loc3_[_loc4_]);
               this._dataList[_loc5_.ID] = _loc5_;
               this._dataList2[_loc5_.Point] = _loc5_;
               _loc4_++;
            }
            onAnalyzeComplete();
         }
         else
         {
            message = _loc2_.@message;
            onAnalyzeError();
            onAnalyzeError();
         }
      }
      
      public function get dataList() : Object
      {
         return this._dataList;
      }
      
      public function get dataList2() : Object
      {
         return this._dataList2;
      }
   }
}
