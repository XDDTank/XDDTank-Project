package SingleDungeon.expedition
{
   import road7th.data.DictionaryData;
   
   public class ExpeditionModel
   {
      
      public static const NORMAL_MODE:uint = 1;
      
      public static const HARD_MODE:uint = 2;
       
      
      private var _expeditionInfoDic:DictionaryData;
      
      private var _getItemsDic:DictionaryData;
      
      private var _scenceNameDic:DictionaryData;
      
      private var _lastScenceID:int = 0;
      
      private var _expeditionEndTime:Number;
      
      private var _currentMapId:int;
      
      public function ExpeditionModel()
      {
         this._getItemsDic = new DictionaryData();
         this._scenceNameDic = new DictionaryData();
         super();
      }
      
      public function get expeditionInfoDic() : DictionaryData
      {
         return this._expeditionInfoDic;
      }
      
      public function set expeditionInfoDic(param1:DictionaryData) : void
      {
         this._expeditionInfoDic = param1;
      }
      
      public function get getItemsDic() : DictionaryData
      {
         return this._getItemsDic;
      }
      
      public function set getItemsDic(param1:DictionaryData) : void
      {
         this._getItemsDic = param1;
      }
      
      public function clearGetItemsDic() : void
      {
         this._getItemsDic.clear();
      }
      
      public function getscenceNameByID(param1:int) : String
      {
         return this._scenceNameDic[param1];
      }
      
      public function addscenceNameDic(param1:int, param2:String) : void
      {
         this._scenceNameDic[param1] = param2;
      }
      
      public function get lastScenceID() : int
      {
         return this._lastScenceID;
      }
      
      public function set lastScenceID(param1:int) : void
      {
         this._lastScenceID = param1;
      }
      
      public function get expeditionEndTime() : Number
      {
         return this._expeditionEndTime;
      }
      
      public function set expeditionEndTime(param1:Number) : void
      {
         this._expeditionEndTime = param1;
      }
      
      public function get currentMapId() : int
      {
         return this._currentMapId;
      }
      
      public function set currentMapId(param1:int) : void
      {
         this._currentMapId = param1;
      }
   }
}
