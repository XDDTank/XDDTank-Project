package farm.model
{
   import ddt.data.BagInfo;
   import ddt.data.EquipType;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.manager.PlayerManager;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import road7th.data.DictionaryData;
   
   public class FarmModel extends EventDispatcher
   {
       
      
      private var _currentFarmerId:int;
      
      public var currentFarmerName:String;
      
      public var fieldsInfo:DictionaryData;
      
      public var seedingFieldInfo:FieldVO;
      
      public var selfFieldsInfo:Vector.<FieldVO>;
      
      public var gainFieldId:int;
      
      public function FarmModel(param1:IEventDispatcher = null)
      {
         this.fieldsInfo = new DictionaryData();
         super(param1);
      }
      
      public function get currentFarmerId() : int
      {
         return this._currentFarmerId;
      }
      
      public function set currentFarmerId(param1:int) : void
      {
         this._currentFarmerId = param1;
      }
      
      public function getfieldInfoById(param1:int) : FieldVO
      {
         var _loc2_:FieldVO = null;
         for each(_loc2_ in this.fieldsInfo)
         {
            if(_loc2_.fieldID == param1)
            {
               return _loc2_;
            }
         }
         return null;
      }
      
      public function findItemInfo(param1:int, param2:int) : InventoryItemInfo
      {
         var _loc5_:InventoryItemInfo = null;
         var _loc3_:InventoryItemInfo = null;
         var _loc4_:Array = PlayerManager.Instance.Self.getBag(BagInfo.FARM).findItems(param1);
         for each(_loc5_ in _loc4_)
         {
            if(_loc5_.TemplateID == param2)
            {
               _loc3_ = _loc5_;
               break;
            }
         }
         return _loc3_;
      }
      
      public function getSeedCountByID(param1:int) : int
      {
         var _loc4_:InventoryItemInfo = null;
         var _loc2_:int = 0;
         var _loc3_:Array = PlayerManager.Instance.Self.getBag(BagInfo.FARM).findItems(EquipType.SEED);
         for each(_loc4_ in _loc3_)
         {
            if(_loc4_.TemplateID == param1)
            {
               _loc2_ += _loc4_.Count;
            }
         }
         return _loc2_;
      }
   }
}
