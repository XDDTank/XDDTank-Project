package totem.data
{
   import com.pickgliss.loader.DataAnalyzer;
   
   public class HonorUpDataAnalyz extends DataAnalyzer
   {
       
      
      private var _dataList:Array;
      
      public function HonorUpDataAnalyz(param1:Function)
      {
         super(param1);
      }
      
      override public function analyze(param1:*) : void
      {
         var _loc3_:XMLList = null;
         var _loc4_:int = 0;
         var _loc5_:HonorUpDataVo = null;
         var _loc2_:XML = new XML(param1);
         this._dataList = [];
         if(_loc2_.@value == "true")
         {
            _loc3_ = _loc2_..item;
            _loc4_ = 0;
            while(_loc4_ < _loc3_.length())
            {
               _loc5_ = new HonorUpDataVo();
               _loc5_.index = _loc3_[_loc4_].@ID;
               _loc5_.honor = _loc3_[_loc4_].@AddHonor;
               _loc5_.money = _loc3_[_loc4_].@NeedMoney;
               this._dataList.push(_loc5_);
               _loc4_++;
            }
            this._dataList.sortOn("index",Array.NUMERIC);
            onAnalyzeComplete();
         }
         else
         {
            message = _loc2_.@message;
            onAnalyzeError();
            onAnalyzeError();
         }
      }
      
      public function get dataList() : Array
      {
         return this._dataList;
      }
   }
}
