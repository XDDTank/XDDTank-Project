package activity.data
{
   import road7th.data.DictionaryData;
   
   public class ActivityTuanInfo
   {
       
      
      public var activityID:String;
      
      public var itemID:int;
      
      public var itemPrice:int;
      
      public var backRate:DictionaryData;
      
      public var adjustTime:DictionaryData;
      
      public var priceType:int;
      
      public var alreadyMoney:int;
      
      public var alreadyCount:int;
      
      public var allCount:int;
      
      public function ActivityTuanInfo()
      {
         this.backRate = new DictionaryData();
         this.adjustTime = new DictionaryData();
         super();
      }
   }
}
