package platformapi.tencent.model
{
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import platformapi.tencent.DiamondManager;
   import platformapi.tencent.DiamondType;
   import platformapi.tencent.TencentPlatformData;
   import road7th.data.DictionaryData;
   
   public class DiamondModel extends EventDispatcher
   {
       
      
      private var _yellowAwardList:DictionaryData;
      
      private var _yellowYearAwardList:DictionaryData;
      
      private var _yellowNewHandAwardList:DictionaryData;
      
      private var _blueAwardList:DictionaryData;
      
      private var _blueYearAwardList:DictionaryData;
      
      private var _blueNewHandAwardList:DictionaryData;
      
      private var _memberAwardList:DictionaryData;
      
      private var _memberYearAwardList:DictionaryData;
      
      private var _memberNewHandAwardList:DictionaryData;
      
      private var _bunAwardList:DictionaryData;
      
      private var _hasData:Boolean;
      
      private var _pfdata:TencentPlatformData;
      
      public function DiamondModel()
      {
         super();
      }
      
      public function setList(param1:DictionaryData, param2:DictionaryData, param3:DictionaryData, param4:DictionaryData, param5:DictionaryData, param6:DictionaryData, param7:DictionaryData, param8:DictionaryData, param9:DictionaryData, param10:DictionaryData) : void
      {
         this._yellowAwardList = param1;
         this._yellowYearAwardList = param2;
         this._yellowNewHandAwardList = param3;
         this._blueAwardList = param4;
         this._blueYearAwardList = param5;
         this._blueNewHandAwardList = param6;
         this._memberAwardList = param7;
         this._memberYearAwardList = param8;
         this._memberNewHandAwardList = param9;
         this._bunAwardList = param10;
         this._hasData = true;
      }
      
      public function get awardList() : DictionaryData
      {
         switch(DiamondManager.instance.model.pfdata.pfType)
         {
            case DiamondType.YELLOW_DIAMOND:
               return this._yellowAwardList;
            case DiamondType.BLUE_DIAMOND:
               return this._blueAwardList;
            case DiamondType.MEMBER_DIAMOND:
               return this._memberAwardList;
            default:
               return null;
         }
      }
      
      public function get yearAwardList() : DictionaryData
      {
         switch(DiamondManager.instance.model.pfdata.pfType)
         {
            case DiamondType.YELLOW_DIAMOND:
               return this._yellowYearAwardList;
            case DiamondType.BLUE_DIAMOND:
               return this._blueYearAwardList;
            case DiamondType.MEMBER_DIAMOND:
               return this._memberYearAwardList;
            default:
               return null;
         }
      }
      
      public function get newHandAwardList() : DictionaryData
      {
         switch(DiamondManager.instance.model.pfdata.pfType)
         {
            case DiamondType.YELLOW_DIAMOND:
               return this._yellowNewHandAwardList;
            case DiamondType.BLUE_DIAMOND:
               return this._blueNewHandAwardList;
            case DiamondType.MEMBER_DIAMOND:
               return this._memberNewHandAwardList;
            default:
               return null;
         }
      }
      
      public function get bunAwardList() : DictionaryData
      {
         return this._bunAwardList;
      }
      
      public function get pfdata() : TencentPlatformData
      {
         return this._pfdata = this._pfdata || new TencentPlatformData();
      }
      
      public function update() : void
      {
         dispatchEvent(new Event(Event.CHANGE));
      }
   }
}
