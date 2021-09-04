package store.view.Compose
{
   import ddt.data.goods.ItemTemplateInfo;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import road7th.data.DictionaryData;
   
   public class ComposeModel extends EventDispatcher
   {
       
      
      private var _composeItemInfoDic:DictionaryData;
      
      private var _composeBigDic:DictionaryData;
      
      private var _composeMiddelDic:DictionaryData;
      
      private var _composeSmallDic:DictionaryData;
      
      private var _currentItem:ItemTemplateInfo;
      
      private var _seletectedPage:DictionaryData;
      
      private var _composeSuccess:Boolean;
      
      public function ComposeModel(param1:IEventDispatcher = null)
      {
         this._composeBigDic = new DictionaryData();
         this._composeMiddelDic = new DictionaryData();
         this._composeSmallDic = new DictionaryData();
         this._seletectedPage = new DictionaryData();
         super(param1);
      }
      
      public function get composeItemInfoDic() : DictionaryData
      {
         return this._composeItemInfoDic;
      }
      
      public function set composeItemInfoDic(param1:DictionaryData) : void
      {
         this._composeItemInfoDic = param1;
      }
      
      public function get composeBigDic() : DictionaryData
      {
         return this._composeBigDic;
      }
      
      public function set composeBigDic(param1:DictionaryData) : void
      {
         this._composeBigDic = param1;
      }
      
      public function get composeMiddelDic() : DictionaryData
      {
         return this._composeMiddelDic;
      }
      
      public function set composeMiddelDic(param1:DictionaryData) : void
      {
         this._composeMiddelDic = param1;
      }
      
      public function get composeSmallDic() : DictionaryData
      {
         return this._composeSmallDic;
      }
      
      public function set composeSmallDic(param1:DictionaryData) : void
      {
         this._composeSmallDic = param1;
      }
      
      public function set currentItem(param1:ItemTemplateInfo) : void
      {
         this._currentItem = param1;
         dispatchEvent(new ComposeEvents(ComposeEvents.CLICK_SMALL_ITEM));
      }
      
      public function get currentItem() : ItemTemplateInfo
      {
         return this._currentItem;
      }
      
      public function saveSelectedPageSmall(param1:int, param2:int) : void
      {
         var _loc3_:Array = null;
         for each(_loc3_ in this._seletectedPage)
         {
            _loc3_[1] = -2;
         }
         this.getseletectedPageByBigType(param1)[1] = param2;
         this.getseletectedPageByBigType(param1)[2] = this.getSeletedPageMiddle(param1);
      }
      
      public function getSelectedPageSmallToMiddle(param1:int) : int
      {
         return this.getseletectedPageByBigType(param1)[2];
      }
      
      public function getSelectedPageSmall(param1:int) : int
      {
         return this.getseletectedPageByBigType(param1)[1];
      }
      
      public function saveSeletedPageMiddle(param1:int, param2:int) : void
      {
         this.getseletectedPageByBigType(param1)[0] = param2;
      }
      
      public function getSeletedPageMiddle(param1:int) : int
      {
         return this.getseletectedPageByBigType(param1)[0];
      }
      
      private function getseletectedPageByBigType(param1:int) : Array
      {
         var _loc2_:Array = null;
         if(!this._seletectedPage[this._composeBigDic[param1]])
         {
            _loc2_ = new Array();
            _loc2_[0] = -1;
            _loc2_[1] = -1;
            _loc2_[2] = -1;
            this._seletectedPage[this._composeBigDic[param1]] = _loc2_;
         }
         return this._seletectedPage[this._composeBigDic[param1]];
      }
      
      public function resetseletectedPage() : void
      {
         this._seletectedPage = new DictionaryData();
      }
      
      public function get composeSuccess() : Boolean
      {
         return this._composeSuccess;
      }
      
      public function set composeSuccess(param1:Boolean) : void
      {
         this._composeSuccess = param1;
      }
   }
}
