package ddt.data.analyze
{
   import com.pickgliss.loader.DataAnalyzer;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.DaylyGiveInfo;
   
   public class DailyReceiveAnalyzer extends DataAnalyzer
   {
       
      
      private var _xml:XML;
      
      private var _awardDic:Array;
      
      public function DailyReceiveAnalyzer(param1:Function)
      {
         super(param1);
      }
      
      override public function analyze(param1:*) : void
      {
         var _loc2_:XMLList = null;
         var _loc3_:int = 0;
         var _loc4_:DaylyGiveInfo = null;
         this._xml = new XML(param1);
         this._awardDic = new Array();
         if(this._xml.@value == "true")
         {
            _loc2_ = this._xml..Item;
            _loc3_ = 0;
            while(_loc3_ < _loc2_.length())
            {
               _loc4_ = new DaylyGiveInfo();
               ObjectUtils.copyPorpertiesByXML(_loc4_,_loc2_[_loc3_]);
               this._awardDic.push(_loc4_);
               _loc3_++;
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
      
      public function get awardList() : Array
      {
         return this._awardDic;
      }
   }
}
