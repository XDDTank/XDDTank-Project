package activity
{
   import activity.data.ActivityGiftbagRecord;
   import activity.data.ActivityTuanInfo;
   import activity.data.ConditionRecord;
   import flash.events.EventDispatcher;
   import flash.utils.Dictionary;
   import road7th.data.DictionaryData;
   
   public class ActivityModel extends EventDispatcher
   {
       
      
      private var _eventActives:Array;
      
      private var _activeExchange:Array;
      
      private var _activityInfoArr:Array;
      
      private var _activityConditionArr:Array;
      
      private var _activityGiftbagArr:Array;
      
      private var _activityRewards:Array;
      
      private var _nowState:Dictionary;
      
      private var _condtionRecords:DictionaryData;
      
      private var _log:Dictionary;
      
      private var _giftbagRecordDic:DictionaryData;
      
      private var _tuanInfoDic:DictionaryData;
      
      private var _showID:String = "";
      
      public function ActivityModel()
      {
         this._nowState = new Dictionary();
         this._condtionRecords = new DictionaryData();
         this._log = new Dictionary();
         this._giftbagRecordDic = new DictionaryData();
         this._tuanInfoDic = new DictionaryData();
         super();
      }
      
      public function get eventActives() : Array
      {
         return this._eventActives;
      }
      
      public function set eventActives(param1:Array) : void
      {
         this._eventActives = param1;
      }
      
      public function get activeExchange() : Array
      {
         return this._activeExchange;
      }
      
      public function set activeExchange(param1:Array) : void
      {
         this._activeExchange = param1;
      }
      
      public function get activityInfoArr() : Array
      {
         return this._activityInfoArr;
      }
      
      public function set activityInfoArr(param1:Array) : void
      {
         this._activityInfoArr = param1;
         dispatchEvent(new ActivityEvent(ActivityEvent.ACTIVITY_UPDATE));
      }
      
      public function get activityConditionArr() : Array
      {
         return this._activityConditionArr;
      }
      
      public function set activityConditionArr(param1:Array) : void
      {
         this._activityConditionArr = param1;
      }
      
      public function get activityGiftbagArr() : Array
      {
         return this._activityGiftbagArr;
      }
      
      public function set activityGiftbagArr(param1:Array) : void
      {
         this._activityGiftbagArr = param1;
      }
      
      public function get activityRewards() : Array
      {
         return this._activityRewards;
      }
      
      public function set activityRewards(param1:Array) : void
      {
         this._activityRewards = param1;
      }
      
      public function getState(param1:String) : int
      {
         if(!this._nowState[param1])
         {
            this._nowState[param1] = 0;
         }
         return this._nowState[param1];
      }
      
      public function addNowState(param1:String, param2:int) : void
      {
         this._nowState[param1] = param2;
      }
      
      public function addcondtionRecords(param1:String, param2:String) : void
      {
         var _loc4_:Array = null;
         var _loc5_:ConditionRecord = null;
         var _loc7_:String = null;
         param2 = param2 == null ? "" : param2;
         var _loc3_:Array = param2.split(",");
         var _loc6_:Array = new Array();
         for each(_loc7_ in _loc3_)
         {
            _loc4_ = _loc7_.split("|");
            _loc5_ = new ConditionRecord(_loc4_[0],_loc4_[1],_loc4_[2]);
            _loc6_.push(_loc5_);
         }
         this._condtionRecords.add(param1,_loc6_);
      }
      
      public function getConditionRecord(param1:String, param2:int) : ConditionRecord
      {
         var _loc4_:ConditionRecord = null;
         var _loc3_:Array = this._condtionRecords[param1];
         for each(_loc4_ in _loc3_)
         {
            if(_loc4_.conditionIndex == param2)
            {
               return _loc4_;
            }
         }
         return null;
      }
      
      public function getLog(param1:String) : int
      {
         if(!this._log[param1])
         {
            this._log[param1] = 0;
         }
         return this._log[param1];
      }
      
      public function addLog(param1:String, param2:int) : void
      {
         this._log[param1] = param2;
      }
      
      public function addGiftbagRecord(param1:String, param2:DictionaryData) : void
      {
         this._giftbagRecordDic.add(param1,param2);
      }
      
      public function getGiftbagRecordByID(param1:String, param2:int) : ActivityGiftbagRecord
      {
         var _loc3_:ActivityGiftbagRecord = null;
         if(this._giftbagRecordDic[param1] == null || this._giftbagRecordDic[param1][param2] == null)
         {
            _loc3_ = new ActivityGiftbagRecord();
            _loc3_.index = param2;
            _loc3_.value = 0;
            return _loc3_;
         }
         return this._giftbagRecordDic[param1][param2];
      }
      
      public function addTuanInfo(param1:String, param2:ActivityTuanInfo) : void
      {
         this._tuanInfoDic.add(param1,param2);
      }
      
      public function getTuanInfoByID(param1:String) : ActivityTuanInfo
      {
         return this._tuanInfoDic[param1];
      }
      
      public function get showID() : String
      {
         return this._showID;
      }
      
      public function set showID(param1:String) : void
      {
         this._showID = param1;
      }
   }
}
