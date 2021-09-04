package activity.analyze
{
   import activity.data.ActivityConditionInfo;
   import com.pickgliss.loader.DataAnalyzer;
   import com.pickgliss.utils.ObjectUtils;
   
   public class ActivityConditionAnalyzer extends DataAnalyzer
   {
       
      
      private var _list:Array;
      
      private var _xml:XML;
      
      public function ActivityConditionAnalyzer(param1:Function)
      {
         super(param1);
      }
      
      public function get list() : Array
      {
         return this._list;
      }
      
      override public function analyze(param1:*) : void
      {
         var _loc3_:int = 0;
         var _loc4_:ActivityConditionInfo = null;
         this._xml = new XML(param1);
         this._list = new Array();
         var _loc2_:XMLList = this._xml..Item;
         if(this._xml.@value == "true")
         {
            _loc3_ = 0;
            while(_loc3_ < _loc2_.length())
            {
               _loc4_ = new ActivityConditionInfo();
               ObjectUtils.copyPorpertiesByXML(_loc4_,_loc2_[_loc3_]);
               this._list.push(_loc4_);
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
   }
}
