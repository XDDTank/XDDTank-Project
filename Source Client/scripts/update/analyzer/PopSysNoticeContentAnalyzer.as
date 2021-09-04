package update.analyzer
{
   import com.pickgliss.loader.DataAnalyzer;
   import com.pickgliss.utils.ObjectUtils;
   import update.data.PopSysNoticeContentInfo;
   
   public class PopSysNoticeContentAnalyzer extends DataAnalyzer
   {
       
      
      private var _list:Array;
      
      public function PopSysNoticeContentAnalyzer(param1:Function)
      {
         super(param1);
      }
      
      public function get list() : Array
      {
         return this._list;
      }
      
      override public function analyze(param1:*) : void
      {
         var _loc4_:int = 0;
         var _loc5_:PopSysNoticeContentInfo = null;
         var _loc2_:XML = new XML(param1);
         this._list = new Array();
         var _loc3_:XMLList = _loc2_..Item;
         if(_loc2_.@value == "true")
         {
            _loc4_ = 0;
            while(_loc4_ < _loc3_.length())
            {
               _loc5_ = new PopSysNoticeContentInfo();
               ObjectUtils.copyPorpertiesByXML(_loc5_,_loc3_[_loc4_]);
               this._list.push(_loc5_);
               _loc4_++;
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
