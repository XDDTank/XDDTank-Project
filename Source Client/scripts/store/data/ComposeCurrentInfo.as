package store.data
{
   public class ComposeCurrentInfo
   {
       
      
      public var lastComposeTime:Date;
      
      public var composeNeedTime:int;
      
      public var templeteID:int;
      
      public var count:int;
      
      public var type:int = 40;
      
      private var _remainTime:int = 0;
      
      public function ComposeCurrentInfo()
      {
         super();
      }
      
      public function get remainTime() : int
      {
         return this._remainTime;
      }
      
      public function set remainTime(param1:int) : void
      {
         this._remainTime = param1;
      }
   }
}
