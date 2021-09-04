package ddt.data
{
   import ddt.data.goods.EquipmentTemplateInfo;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.events.BagEvent;
   import ddt.manager.ItemManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.ShopManager;
   import ddt.manager.SocketManager;
   import ddt.manager.StateManager;
   import flash.events.EventDispatcher;
   import flash.utils.ByteArray;
   import flash.utils.Dictionary;
   import road7th.data.DictionaryData;
   
   [Event(name="update",type="ddt.events.BagEvent")]
   public class BagInfo extends EventDispatcher
   {
      
      public static const EQUIPBAG:int = 0;
      
      public static const PROPBAG:int = 1;
      
      public static const TASKBAG:int = 2;
      
      public static const FIGHTBAG:int = 3;
      
      public static const TEMPBAG:int = 4;
      
      public static const CADDYBAG:int = 5;
      
      public static const CONSORTIA:int = 11;
      
      public static const FARM:int = 13;
      
      public static const VEGETABLE:int = 14;
      
      public static const FOOD_OLD:int = 32;
      
      public static const FOOD:int = 34;
      
      public static const PETEGG:int = 35;
      
      public static const UNBIND:int = 36;
      
      public static const BEADBAG:int = 21;
      
      public static const MAXPROPCOUNT:int = 48;
      
      public static const STOREBAG:int = 12;
      
      public static const PERSONAL_EQUIP_COUNT:int = 30;
       
      
      private var _type:int;
      
      private var _capability:int;
      
      private var _items:DictionaryData;
      
      private var _texpList:DictionaryData;
      
      private var _changedCount:int = 0;
      
      private var _changedSlots:Dictionary;
      
      public const NUMBER:Number = 1.0;
      
      private var _overtimeItems:Array;
      
      public function BagInfo(param1:int, param2:int)
      {
         this._changedSlots = new Dictionary();
         this._overtimeItems = new Array();
         super();
         this._type = param1;
         this._items = new DictionaryData();
         this._capability = param2;
      }
      
      public function get BagType() : int
      {
         return this._type;
      }
      
      public function getItemAt(param1:int) : InventoryItemInfo
      {
         return this._items[param1];
      }
      
      public function get items() : DictionaryData
      {
         return this._items;
      }
      
      public function get itemNumber() : int
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         while(_loc2_ < 56)
         {
            if(this._items[_loc2_] != null)
            {
               _loc1_++;
            }
            _loc2_++;
         }
         return _loc1_;
      }
      
      public function get itemBagNumber() : int
      {
         var _loc1_:int = 0;
         var _loc2_:int = 31;
         while(_loc2_ < 175)
         {
            if(this._items[_loc2_] != null)
            {
               _loc1_++;
            }
            _loc2_++;
         }
         return _loc1_;
      }
      
      public function itemBagFull() : Boolean
      {
         var _loc4_:int = 0;
         var _loc1_:int = PlayerManager.Instance.Self.Grade;
         var _loc2_:int = 0;
         var _loc3_:int = 31;
         if(_loc1_ < 20)
         {
            _loc4_ = 79;
         }
         else if(_loc1_ < 30)
         {
            _loc4_ = 127;
         }
         else
         {
            _loc4_ = 175;
         }
         var _loc5_:int = _loc3_;
         while(_loc5_ < _loc4_)
         {
            if(this._items[_loc5_] != null)
            {
               _loc2_++;
            }
            _loc5_++;
         }
         if(_loc2_ >= _loc4_ - _loc3_)
         {
            return true;
         }
         return false;
      }
      
      public function set items(param1:DictionaryData) : void
      {
         this._items = param1;
      }
      
      public function get TexpItems() : DictionaryData
      {
         var _loc1_:InventoryItemInfo = null;
         this._texpList = new DictionaryData();
         for each(_loc1_ in this.items)
         {
            if(this.isTexpLvGoods(_loc1_))
            {
               this._texpList.add(this._texpList.length,_loc1_);
            }
         }
         return this._texpList;
      }
      
      private function isTexpLvGoods(param1:InventoryItemInfo) : Boolean
      {
         if(param1.TemplateID == EquipType.TEXP_LV_II || param1.TemplateID == EquipType.TEXP_LV_I)
         {
            return true;
         }
         return false;
      }
      
      public function addItem(param1:InventoryItemInfo) : void
      {
         param1.BagType = this._type;
         this._items.add(param1.Place,param1);
         this.onItemChanged(param1.Place,param1);
      }
      
      public function addItemIntoFightBag(param1:int, param2:int = 1) : void
      {
         var _loc3_:InventoryItemInfo = new InventoryItemInfo();
         _loc3_.BagType = FIGHTBAG;
         _loc3_.Place = this.findFirstPlace();
         _loc3_.Count = param2;
         _loc3_.TemplateID = param1;
         ItemManager.fill(_loc3_);
         this.addItem(_loc3_);
      }
      
      private function findFirstPlace() : int
      {
         var _loc1_:int = 0;
         while(_loc1_ < 3)
         {
            if(this.getItemAt(_loc1_) == null)
            {
               return _loc1_;
            }
            _loc1_++;
         }
         return -1;
      }
      
      public function removeItemAt(param1:int) : void
      {
         var _loc2_:InventoryItemInfo = this._items[param1];
         if(_loc2_)
         {
            this._items.remove(param1);
            if(this._type == TEMPBAG && StateManager.isInFight)
            {
               return;
            }
            this.onItemChanged(param1,_loc2_);
         }
      }
      
      public function updateItem(param1:InventoryItemInfo) : void
      {
         if(param1.BagType == this._type)
         {
            this.onItemChanged(param1.Place,param1);
         }
      }
      
      public function beginChanges() : void
      {
         ++this._changedCount;
      }
      
      public function commiteChanges() : void
      {
         --this._changedCount;
         if(this._changedCount <= 0)
         {
            this._changedCount = 0;
            this.updateChanged();
         }
      }
      
      protected function onItemChanged(param1:int, param2:InventoryItemInfo) : void
      {
         this._changedSlots[param1] = param2;
         if(this._changedCount <= 0)
         {
            this._changedCount = 0;
            this.updateChanged();
         }
      }
      
      protected function updateChanged() : void
      {
         dispatchEvent(new BagEvent(BagEvent.UPDATE,this._changedSlots));
         this._changedSlots = new Dictionary();
      }
      
      public function findItems(param1:int, param2:Boolean = true) : Array
      {
         var _loc4_:InventoryItemInfo = null;
         var _loc3_:Array = new Array();
         for each(_loc4_ in this._items)
         {
            if(_loc4_.CategoryID == param1)
            {
               if(!param2 || _loc4_.getRemainDate() > 0)
               {
                  _loc3_.push(_loc4_);
               }
            }
         }
         return _loc3_;
      }
      
      public function findFirstItem(param1:int, param2:Boolean = true) : InventoryItemInfo
      {
         var _loc3_:InventoryItemInfo = null;
         for each(_loc3_ in this._items)
         {
            if(_loc3_.CategoryID == param1)
            {
               if(!param2 || _loc3_.getRemainDate() > 0)
               {
                  return _loc3_;
               }
            }
         }
         return null;
      }
      
      public function findEquipedItemByTemplateId(param1:int, param2:Boolean = true) : InventoryItemInfo
      {
         var _loc3_:InventoryItemInfo = null;
         for each(_loc3_ in this._items)
         {
            if(_loc3_.TemplateID == param1)
            {
               if(_loc3_.Place <= 30)
               {
                  if(!param2 || _loc3_.getRemainDate() > 0)
                  {
                     return _loc3_;
                  }
               }
            }
         }
         return null;
      }
      
      public function findItemsByTemplateType(param1:int) : DictionaryData
      {
         var _loc3_:InventoryItemInfo = null;
         var _loc4_:EquipmentTemplateInfo = null;
         var _loc2_:DictionaryData = new DictionaryData();
         for each(_loc3_ in this._items)
         {
            _loc4_ = ItemManager.Instance.getEquipTemplateById(_loc3_.TemplateID);
            if(_loc4_ && _loc4_.TemplateType == param1)
            {
               _loc2_[_loc3_.ItemID] = _loc3_;
            }
         }
         return _loc2_;
      }
      
      public function findOvertimeItems(param1:Number = 0) : Array
      {
         var _loc3_:InventoryItemInfo = null;
         var _loc4_:Number = NaN;
         var _loc2_:Array = new Array();
         for each(_loc3_ in this._items)
         {
            _loc4_ = _loc3_.getRemainDate();
            if(_loc4_ > param1 && _loc4_ < this.NUMBER)
            {
               _loc2_.push(_loc3_);
            }
         }
         return _loc2_;
      }
      
      public function set overTimeItems(param1:Array) : void
      {
         this._overtimeItems = param1;
      }
      
      public function get overTimeItems() : Array
      {
         return this._overtimeItems;
      }
      
      public function findOvertimeItemsByBody() : Array
      {
         var _loc3_:Number = NaN;
         var _loc1_:Array = [];
         var _loc2_:uint = 0;
         while(_loc2_ < 30)
         {
            if(this._items[_loc2_] as InventoryItemInfo)
            {
               _loc3_ = (this._items[_loc2_] as InventoryItemInfo).getRemainDate();
               if(_loc3_ <= 0 && ShopManager.Instance.canAddPrice((this._items[_loc2_] as InventoryItemInfo).TemplateID))
               {
                  _loc1_.push(this._items[_loc2_]);
               }
            }
            _loc2_++;
         }
         return _loc1_;
      }
      
      public function findOvertimeItemsByBodyII() : Array
      {
         var _loc3_:Number = NaN;
         var _loc1_:Array = [];
         var _loc2_:uint = 0;
         while(_loc2_ < 80)
         {
            if(this._items[_loc2_] as InventoryItemInfo)
            {
               if(_loc2_ < 30)
               {
                  _loc3_ = (this._items[_loc2_] as InventoryItemInfo).getRemainDate();
               }
               if((this._items[_loc2_] as InventoryItemInfo).isGold)
               {
                  _loc3_ = (this._items[_loc2_] as InventoryItemInfo).getGoldRemainDate();
               }
               if(_loc3_ <= 0)
               {
                  _loc1_.push(this._items[_loc2_]);
               }
            }
            _loc2_++;
         }
         return _loc1_;
      }
      
      public function findItemsForEach(param1:int, param2:Boolean = true) : Array
      {
         var _loc4_:InventoryItemInfo = null;
         var _loc5_:EquipmentTemplateInfo = null;
         var _loc3_:Array = new Array();
         for each(_loc4_ in this._items)
         {
            if(_loc4_.CategoryID == EquipType.EQUIP)
            {
               _loc5_ = ItemManager.Instance.getEquipTemplateById(_loc4_.TemplateID);
               if(_loc5_.TemplateType == param1)
               {
                  if(!param2 || _loc4_.getRemainDate() > 0)
                  {
                     _loc3_.push(_loc4_);
                  }
               }
            }
         }
         return _loc3_;
      }
      
      public function findSuitsForEach(param1:int) : Array
      {
         var _loc3_:InventoryItemInfo = null;
         var _loc4_:ItemTemplateInfo = null;
         var _loc5_:EquipmentTemplateInfo = null;
         var _loc2_:Array = new Array();
         for each(_loc3_ in this._items)
         {
            if(_loc3_.CategoryID == EquipType.EQUIP)
            {
               _loc4_ = ItemManager.Instance.getTemplateById(_loc3_.TemplateID);
               if(int(_loc4_.Property1) == param1)
               {
                  _loc5_ = ItemManager.Instance.getEquipTemplateById(_loc3_.TemplateID);
                  _loc2_.push(_loc5_);
               }
            }
         }
         return _loc2_;
      }
      
      public function findFistItemByTemplateId(param1:int, param2:Boolean = true, param3:Boolean = false) : InventoryItemInfo
      {
         var _loc6_:InventoryItemInfo = null;
         var _loc4_:InventoryItemInfo = null;
         var _loc5_:InventoryItemInfo = null;
         for each(_loc6_ in this._items)
         {
            if(_loc6_.TemplateID == param1 && (!param2 || _loc6_.getRemainDate() > 0))
            {
               if(!param3)
               {
                  return _loc6_;
               }
               if(_loc6_.IsUsed)
               {
                  if(_loc4_ == null)
                  {
                     _loc4_ = _loc6_;
                  }
               }
               else if(_loc5_ == null)
               {
                  _loc5_ = _loc6_;
               }
            }
         }
         return Boolean(_loc4_) ? _loc4_ : _loc5_;
      }
      
      public function findBodyThingByCategory(param1:int) : Array
      {
         var _loc4_:InventoryItemInfo = null;
         var _loc2_:Array = new Array();
         var _loc3_:int = 0;
         while(_loc3_ < 30)
         {
            _loc4_ = this._items[_loc3_] as InventoryItemInfo;
            if(_loc4_ != null)
            {
               if(_loc4_.CategoryID == param1)
               {
                  _loc2_.push(_loc4_);
               }
            }
            _loc3_++;
         }
         return _loc2_;
      }
      
      public function getItemCountByTemplateId(param1:int, param2:Boolean = true) : int
      {
         var _loc4_:InventoryItemInfo = null;
         var _loc3_:int = 0;
         for each(_loc4_ in this._items)
         {
            if(_loc4_.TemplateID == param1 && (!param2 || _loc4_.getRemainDate() > 0))
            {
               _loc3_ += _loc4_.Count;
            }
         }
         return _loc3_;
      }
      
      public function getItemsByTempleteID(param1:int, param2:Boolean = true) : Array
      {
         var _loc4_:InventoryItemInfo = null;
         var _loc3_:Array = [];
         for each(_loc4_ in this._items)
         {
            if(_loc4_.TemplateID == param1 && (!param2 || _loc4_.getRemainDate() > 0))
            {
               _loc3_.push(_loc4_);
            }
         }
         return _loc3_;
      }
      
      public function getItemBindsByTemplateID(param1:int) : Boolean
      {
         var _loc2_:InventoryItemInfo = null;
         for each(_loc2_ in this._items)
         {
            if(_loc2_.TemplateID == param1 && _loc2_.IsBinds == false)
            {
               return true;
            }
         }
         return false;
      }
      
      public function findItemsByTempleteID(param1:int, param2:Boolean = true) : Array
      {
         var _loc4_:InventoryItemInfo = null;
         var _loc3_:DictionaryData = new DictionaryData();
         for each(_loc4_ in this._items)
         {
            if(_loc4_.TemplateID == param1)
            {
               if(!param2 || _loc4_.getRemainDate() > 0)
               {
                  _loc3_.add(_loc4_.ItemID,_loc4_);
               }
            }
         }
         return _loc3_.list;
      }
      
      public function findCellsByTempleteID(param1:int, param2:Boolean = true) : Array
      {
         var _loc4_:InventoryItemInfo = null;
         var _loc3_:Array = new Array();
         for each(_loc4_ in this._items)
         {
            if(_loc4_.TemplateID == param1 && (!param2 || _loc4_.getRemainDate() > 0))
            {
               _loc3_.push(_loc4_);
            }
         }
         return _loc3_;
      }
      
      public function clearnAll() : void
      {
         var _loc1_:int = 0;
         while(_loc1_ < 49)
         {
            this.removeItemAt(_loc1_);
            _loc1_++;
         }
      }
      
      public function unlockItem(param1:InventoryItemInfo) : void
      {
         param1.lock = false;
         this.onItemChanged(param1.Place,param1);
      }
      
      public function unLockAll() : void
      {
         var _loc1_:InventoryItemInfo = null;
         this.beginChanges();
         for each(_loc1_ in this._items)
         {
            if(_loc1_.lock)
            {
               this.onItemChanged(_loc1_.Place,_loc1_);
            }
            _loc1_.lock = false;
         }
         this.commiteChanges();
      }
      
      public function sortBag(param1:int, param2:BagInfo, param3:int, param4:int, param5:Boolean = false) : void
      {
         var _loc6_:DictionaryData = null;
         var _loc7_:Array = null;
         var _loc8_:Array = null;
         var _loc9_:DictionaryData = null;
         var _loc10_:int = 0;
         var _loc11_:int = 0;
         var _loc12_:int = 0;
         var _loc13_:int = 0;
         var _loc14_:ByteArray = null;
         if(param1 != 21)
         {
            _loc6_ = param2.items;
            _loc7_ = [];
            _loc8_ = [];
            _loc9_ = new DictionaryData();
            _loc10_ = 0;
            _loc11_ = _loc6_.list.length;
            _loc12_ = 0;
            if(param2 == PlayerManager.Instance.Self.Bag)
            {
               _loc12_ = 31;
            }
            while(_loc13_ < _loc11_)
            {
               if(int(_loc6_.list[_loc13_].Place) >= _loc12_)
               {
                  _loc7_.push({
                     "TemplateID":_loc6_.list[_loc13_].TemplateID,
                     "ItemID":_loc6_.list[_loc13_].ItemID,
                     "CategoryIDSort":this.getBagGoodsCategoryIDSort(uint(_loc6_.list[_loc13_].CategoryID)),
                     "Place":_loc6_.list[_loc13_].Place,
                     "RemainDate":_loc6_.list[_loc13_].getRemainDate() > 0,
                     "CanStrengthen":_loc6_.list[_loc13_].CanStrengthen,
                     "StrengthenLevel":_loc6_.list[_loc13_].StrengthenLevel,
                     "IsBinds":_loc6_.list[_loc13_].IsBinds
                  });
               }
               _loc13_++;
            }
            _loc14_ = new ByteArray();
            _loc14_.writeObject(_loc7_);
            _loc14_.position = 0;
            _loc8_ = _loc14_.readObject() as Array;
            _loc7_.sortOn(["RemainDate","CategoryIDSort","TemplateID","CanStrengthen","IsBinds","StrengthenLevel","Place"],[Array.DESCENDING,Array.NUMERIC,Array.NUMERIC | Array.DESCENDING,Array.DESCENDING,Array.DESCENDING,Array.NUMERIC | Array.DESCENDING,Array.NUMERIC]);
            if(this.bagComparison(_loc7_,_loc8_,_loc12_) && !param5)
            {
               return;
            }
            SocketManager.Instance.out.sendMoveGoodsAll(param2.BagType,_loc7_,_loc12_,param5);
         }
         else if(param1 == 21)
         {
            this.sortBead(param2,param3,param4,param5);
         }
      }
      
      private function sortBead(param1:BagInfo, param2:int, param3:int, param4:Boolean) : void
      {
         var _loc5_:DictionaryData = param1.items;
         var _loc6_:Array = [];
         var _loc7_:Array = [];
         var _loc8_:int = 0;
         var _loc9_:int = _loc5_.list.length;
         var _loc10_:int = 0;
         while(_loc10_ < _loc9_)
         {
            if(int(_loc5_.list[_loc10_].Place) >= param2 && int(_loc5_.list[_loc10_].Place) <= param3)
            {
               _loc6_.push({
                  "Type":_loc5_.list[_loc10_].Property2,
                  "TemplateID":_loc5_.list[_loc10_].TemplateID,
                  "Level":_loc5_.list[_loc10_].Hole1,
                  "Exp":_loc5_.list[_loc10_].Hole2,
                  "Place":_loc5_.list[_loc10_].Place
               });
            }
            _loc10_++;
         }
         var _loc11_:ByteArray = new ByteArray();
         _loc11_.writeObject(_loc6_);
         _loc11_.position = 0;
         _loc7_ = _loc11_.readObject() as Array;
         _loc6_.sortOn(["Type","TemplateID","Level","Exp","Place"],[Array.NUMERIC,Array.DESCENDING,Array.DESCENDING,Array.DESCENDING,Array.NUMERIC]);
         if(this.bagComparison(_loc6_,_loc7_,param2) && !param4)
         {
            return;
         }
         SocketManager.Instance.out.sendMoveGoodsAll(param1.BagType,_loc6_,param2,param4);
      }
      
      public function getBagGoodsCategoryIDSort(param1:uint) : int
      {
         var _loc2_:Array = [EquipType.ARM,EquipType.HOLYGRAIL,EquipType.HEAD,EquipType.CLOTH,EquipType.ARMLET,EquipType.RING,EquipType.GLASS,EquipType.NECKLACE,EquipType.SUITS,EquipType.WING,EquipType.HAIR,EquipType.FACE,EquipType.EFF,EquipType.CHATBALL,EquipType.ATACCKT,EquipType.DEFENT,EquipType.ATTRIBUTE];
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_.length)
         {
            if(param1 == _loc2_[_loc3_])
            {
               return _loc3_;
            }
            _loc3_++;
         }
         return 9999;
      }
      
      private function bagComparison(param1:Array, param2:Array, param3:int) : Boolean
      {
         if(param1.length < param2.length)
         {
            return false;
         }
         var _loc4_:int = param1.length;
         var _loc5_:int = 0;
         while(_loc5_ < _loc4_)
         {
            if(_loc5_ + param3 != param2[_loc5_].Place || param1[_loc5_].ItemID != param2[_loc5_].ItemID || param1[_loc5_].TemplateID != param2[_loc5_].TemplateID)
            {
               return false;
            }
            _loc5_++;
         }
         return true;
      }
      
      public function itemBgNumber(param1:int, param2:int) : int
      {
         var _loc3_:int = 0;
         var _loc4_:int = param1;
         while(_loc4_ <= param2)
         {
            if(this._items[_loc4_] != null)
            {
               _loc3_++;
            }
            _loc4_++;
         }
         return _loc3_;
      }
   }
}
