package store.data
{
   import com.pickgliss.ui.ComponentFactory;
   import ddt.data.BagInfo;
   import ddt.data.EquipType;
   import ddt.data.goods.EquipmentTemplateInfo;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.data.player.PlayerInfo;
   import ddt.data.player.SelfInfo;
   import ddt.events.BagEvent;
   import ddt.manager.ItemManager;
   import flash.events.EventDispatcher;
   import flash.utils.Dictionary;
   import road7th.data.DictionaryData;
   import road7th.data.DictionaryEvent;
   import store.events.StoreBagEvent;
   import store.events.StoreIIEvent;
   import store.events.UpdateItemEvent;
   import store.view.Compose.ComposeController;
   
   public class StoreModel extends EventDispatcher
   {
      
      private static var _holeExpModel:HoleExpModel;
       
      
      private var _info:SelfInfo;
      
      private var _equipmentBag:DictionaryData;
      
      private var _canCpsEquipmentList:DictionaryData;
      
      private var _canCpsMaterialList:DictionaryData;
      
      private var _canCpsQewelryList:DictionaryData;
      
      private var _canStrthEqpmtList:DictionaryData;
      
      private var _canEmbedEquipmentList:DictionaryData;
      
      private var _strthList:DictionaryData;
      
      private var _canTransEquipmengtList:DictionaryData;
      
      private var _canSplitEquipList:DictionaryData;
      
      private var _canSplitPropList:DictionaryData;
      
      private var _canRefiningEquipList:DictionaryData;
      
      private var _currentPanel:int;
      
      private var _needAutoLink:int = 0;
      
      private var _weaponReady:Boolean;
      
      private var _transWeaponReady:Boolean;
      
      private var _refiningConfig:DictionaryData;
      
      private var _currentComposeItem:ComposeCurrentInfo;
      
      public function StoreModel(param1:PlayerInfo)
      {
         super();
         this._info = param1 as SelfInfo;
         this._equipmentBag = this._info.Bag.items;
         this.initData();
         this.initEvent();
      }
      
      public static function getHoleMaxOpLv() : int
      {
         if(_holeExpModel == null)
         {
            _holeExpModel = ComponentFactory.Instance.creatCustomObject("HoleExpModel");
         }
         return _holeExpModel.getMaxOpLv();
      }
      
      public static function getHoleExpByLv(param1:int) : int
      {
         if(_holeExpModel == null)
         {
            _holeExpModel = ComponentFactory.Instance.creatCustomObject("HoleExpModel");
         }
         return _holeExpModel.getExpByLevel(param1);
      }
      
      private function initData() : void
      {
         this._canStrthEqpmtList = new DictionaryData();
         this._canCpsEquipmentList = new DictionaryData();
         this._canEmbedEquipmentList = new DictionaryData();
         this._canCpsQewelryList = new DictionaryData();
         this._canCpsMaterialList = new DictionaryData();
         this._canTransEquipmengtList = new DictionaryData();
         this._canSplitEquipList = new DictionaryData();
         this._canRefiningEquipList = new DictionaryData();
         this._strthList = new DictionaryData();
         this.pickValidItemsOutOf(this._equipmentBag,true);
         this._canStrthEqpmtList = this.sortEquipList(this._canStrthEqpmtList);
         this._canEmbedEquipmentList = this.sortEquipList(this._canEmbedEquipmentList);
         this._canCpsEquipmentList = this.sortEquipList(this._canCpsEquipmentList);
         this._canCpsQewelryList = this.sortEquipList(this._canCpsQewelryList);
         this._canCpsMaterialList = this.sortEquipList(this._canCpsMaterialList);
         this._canTransEquipmengtList = this.sortEquipList(this._canTransEquipmengtList);
         this._canSplitEquipList = this.sortEquipList(this._canSplitEquipList);
         this._canRefiningEquipList = this.sortEquipList(this._canRefiningEquipList);
      }
      
      private function pickValidItemsOutOf(param1:DictionaryData, param2:Boolean) : void
      {
         var _loc3_:InventoryItemInfo = null;
         for each(_loc3_ in param1)
         {
            if(this.isProperTo_CanStrthEqpmtList(_loc3_))
            {
               this._canStrthEqpmtList.add(this._canStrthEqpmtList.length,_loc3_);
            }
            if(this.isProperTo_canEmbedEquipmentList(_loc3_))
            {
               this._canEmbedEquipmentList.add(this._canEmbedEquipmentList.length,_loc3_);
            }
            if(this.isProperTo_CanCpsEquipmentList(_loc3_))
            {
               this._canCpsEquipmentList.add(this._canCpsEquipmentList.length,_loc3_);
            }
            if(this.isProperTo_CanCpsQewelryList(_loc3_))
            {
               this._canCpsQewelryList.add(this._canCpsQewelryList.length,_loc3_);
            }
            if(this.isProperTo_CanCpsMaterialList(_loc3_))
            {
               this._canCpsMaterialList.add(this._canCpsMaterialList.length,_loc3_);
            }
            if(this.isProperTo_CanTransEquipmengtList(_loc3_))
            {
               this._canTransEquipmengtList.add(this._canTransEquipmengtList.length,_loc3_);
            }
            if(this.isProperTo_CanSplitEquipList(_loc3_))
            {
               this._canSplitEquipList.add(this._canSplitEquipList.length,_loc3_);
            }
            if(this.isProperTo_CanRefiningEquipList(_loc3_))
            {
               this._canRefiningEquipList.add(this._canRefiningEquipList.length,_loc3_);
            }
            if(this.isStrengthenStone(_loc3_))
            {
               this._strthList.add(this._strthList.length,_loc3_);
            }
         }
      }
      
      private function initEvent() : void
      {
         this._info.PropBag.addEventListener(BagEvent.UPDATE,this.updateBag);
         this._info.Bag.addEventListener(BagEvent.UPDATE,this.updateBag);
      }
      
      private function updateBag(param1:BagEvent) : void
      {
         var _loc4_:InventoryItemInfo = null;
         var _loc5_:InventoryItemInfo = null;
         var _loc2_:BagInfo = param1.target as BagInfo;
         var _loc3_:Dictionary = param1.changedSlots;
         for each(_loc4_ in _loc3_)
         {
            _loc5_ = _loc2_.getItemAt(_loc4_.Place);
            if(_loc5_)
            {
               this.__updateEquip(_loc5_);
            }
            else
            {
               this.removeFrom(_loc4_,this._canStrthEqpmtList);
               this.removeFrom(_loc4_,this._canEmbedEquipmentList);
               this.removeFrom(_loc4_,this._canCpsEquipmentList);
               this.removeFrom(_loc4_,this._canCpsQewelryList);
               this.removeFrom(_loc4_,this._canCpsMaterialList);
               this.removeFrom(_loc4_,this._canTransEquipmengtList);
               this.removeFrom(_loc4_,this._canSplitEquipList);
               this.removeFrom(_loc4_,this._canRefiningEquipList);
               this.removeFrom(_loc4_,this._strthList);
            }
         }
      }
      
      private function __updateEquip(param1:InventoryItemInfo) : void
      {
         if(this.isProperTo_CanStrthEqpmtList(param1))
         {
            this.updateDic(this._canStrthEqpmtList,param1);
         }
         else
         {
            this.removeFrom(param1,this._canStrthEqpmtList);
         }
         if(this.isProperTo_canEmbedEquipmentList(param1))
         {
            this.updateDic(this._canEmbedEquipmentList,param1);
         }
         else
         {
            this.removeFrom(param1,this._canEmbedEquipmentList);
         }
         if(this.isProperTo_CanCpsEquipmentList(param1))
         {
            this.updateDic(this._canCpsEquipmentList,param1);
         }
         else
         {
            this.removeFrom(param1,this._canCpsEquipmentList);
         }
         if(this.isProperTo_CanCpsQewelryList(param1))
         {
            this.updateDic(this._canCpsQewelryList,param1);
         }
         else
         {
            this.removeFrom(param1,this._canCpsQewelryList);
         }
         if(this.isProperTo_CanCpsMaterialList(param1))
         {
            this.updateDic(this._canCpsMaterialList,param1);
         }
         else
         {
            this.removeFrom(param1,this._canCpsMaterialList);
         }
         if(this.isProperTo_CanTransEquipmengtList(param1))
         {
            this.updateDic(this._canTransEquipmengtList,param1);
         }
         else
         {
            this.removeFrom(param1,this._canTransEquipmengtList);
         }
         if(this.isProperTo_CanSplitEquipList(param1))
         {
            this.updateDic(this._canSplitEquipList,param1);
         }
         else
         {
            this.removeFrom(param1,this._canSplitEquipList);
         }
         if(this.isProperTo_CanRefiningEquipList(param1))
         {
            this.updateDic(this._canRefiningEquipList,param1);
         }
         else
         {
            this.removeFrom(param1,this._canRefiningEquipList);
         }
         if(this.isStrengthenStone(param1))
         {
            this.updateDic(this._strthList,param1);
            dispatchEvent(new StoreIIEvent(StoreIIEvent.STONE_UPDATE));
         }
         else
         {
            this.removeFrom(param1,this._strthList);
         }
      }
      
      private function isStrengthenStone(param1:InventoryItemInfo) : Boolean
      {
         return param1.TemplateID == EquipType.STRENGTH_STONE_NEW;
      }
      
      private function isProperTo_CanCpsEquipmentList(param1:InventoryItemInfo) : Boolean
      {
         var _loc2_:EquipmentTemplateInfo = null;
         if(param1.CategoryID == EquipType.EQUIP)
         {
            _loc2_ = ItemManager.Instance.getEquipTemplateById(param1.TemplateID);
            if(_loc2_.TemplateType <= 6 && ComposeController.instance.model.composeItemInfoDic[param1.TemplateID])
            {
               return true;
            }
         }
         if(param1.CategoryID == EquipType.COMPOSE_MATERIAL)
         {
            return true;
         }
         return false;
      }
      
      private function isProperTo_CanCpsQewelryList(param1:InventoryItemInfo) : Boolean
      {
         return ItemManager.Instance.judgeJewelry(param1);
      }
      
      private function isProperTo_CanCpsMaterialList(param1:InventoryItemInfo) : Boolean
      {
         if(param1.CategoryID == EquipType.COMPOSE_MATERIAL)
         {
            return true;
         }
         return false;
      }
      
      private function isProperTo_CanStrthEqpmtList(param1:InventoryItemInfo) : Boolean
      {
         var _loc2_:EquipmentTemplateInfo = null;
         if(param1.CategoryID == EquipType.EQUIP)
         {
            _loc2_ = ItemManager.Instance.getEquipTemplateById(param1.TemplateID);
            if(_loc2_.TemplateType <= 6 && _loc2_.StrengthLimit > 0)
            {
               return true;
            }
         }
         return false;
      }
      
      private function isProperTo_canEmbedEquipmentList(param1:InventoryItemInfo) : Boolean
      {
         var _loc2_:EquipmentTemplateInfo = null;
         if(param1)
         {
            if(param1.TemplateID == EquipType.DIAMOND_DRIL)
            {
               return true;
            }
            _loc2_ = ItemManager.Instance.getEquipTemplateById(param1.TemplateID);
            if(_loc2_ && !EquipType.isHolyGrail(param1))
            {
               return true;
            }
         }
         return false;
      }
      
      private function isProperTo_CanTransEquipmengtList(param1:InventoryItemInfo) : Boolean
      {
         var _loc2_:EquipmentTemplateInfo = null;
         if(param1.CategoryID == 27)
         {
            return false;
         }
         if(param1.CategoryID == EquipType.EQUIP)
         {
            _loc2_ = ItemManager.Instance.getEquipTemplateById(param1.TemplateID);
            if(_loc2_.TemplateType <= 6 && _loc2_.StrengthLimit > 0)
            {
               return true;
            }
         }
         return false;
      }
      
      private function isProperTo_CanSplitEquipList(param1:InventoryItemInfo) : Boolean
      {
         if(ItemManager.Instance.getSpliteInfoByID(param1.TemplateID))
         {
            return true;
         }
         return false;
      }
      
      private function isProperTo_CanRefiningEquipList(param1:InventoryItemInfo) : Boolean
      {
         if(ItemManager.Instance.judgeOldJewelry(param1))
         {
            return false;
         }
         return ItemManager.Instance.judgeJewelry(param1);
      }
      
      private function updateDic(param1:DictionaryData, param2:InventoryItemInfo) : void
      {
         var _loc3_:int = 0;
         while(_loc3_ < param1.length)
         {
            if(param1[_loc3_] != null && param1[_loc3_].Place == param2.Place)
            {
               param1.add(_loc3_,param2);
               param1.dispatchEvent(new UpdateItemEvent(UpdateItemEvent.UPDATEITEMEVENT,_loc3_,param2));
               return;
            }
            _loc3_++;
         }
         this.addItemToTheFirstNullCell(param2,param1);
      }
      
      private function __removeEquip(param1:DictionaryEvent) : void
      {
         var _loc2_:InventoryItemInfo = param1.data as InventoryItemInfo;
         this.removeFrom(_loc2_,this._canCpsEquipmentList);
         this.removeFrom(_loc2_,this._canCpsQewelryList);
         this.removeFrom(_loc2_,this._canCpsMaterialList);
         this.removeFrom(_loc2_,this._canStrthEqpmtList);
         this.removeFrom(_loc2_,this._canEmbedEquipmentList);
         this.removeFrom(_loc2_,this._canTransEquipmengtList);
      }
      
      private function addItemToTheFirstNullCell(param1:InventoryItemInfo, param2:DictionaryData) : void
      {
         param2.add(this.findFirstNullCellID(param2),param1);
      }
      
      private function findFirstNullCellID(param1:DictionaryData) : int
      {
         var _loc2_:int = -1;
         var _loc3_:int = param1.length;
         var _loc4_:int = 0;
         while(_loc4_ <= _loc3_)
         {
            if(param1[_loc4_] == null)
            {
               _loc2_ = _loc4_;
               break;
            }
            _loc4_++;
         }
         return _loc2_;
      }
      
      private function removeFrom(param1:InventoryItemInfo, param2:DictionaryData) : void
      {
         var _loc3_:int = param2.length;
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_)
         {
            if(param2[_loc4_] && param2[_loc4_].Place == param1.Place)
            {
               param2[_loc4_] = null;
               param2.dispatchEvent(new StoreBagEvent(StoreBagEvent.REMOVE,_loc4_,param1));
               if(param1.TemplateID == EquipType.STRENGTH_STONE_NEW)
               {
                  dispatchEvent(new StoreIIEvent(StoreIIEvent.STONE_UPDATE));
               }
               break;
            }
            _loc4_++;
         }
      }
      
      public function sortEquipList(param1:DictionaryData) : DictionaryData
      {
         var _loc2_:DictionaryData = param1;
         param1 = new DictionaryData();
         this.fillByCategoryID(_loc2_,param1,EquipType.EQUIP);
         this.fillByCategoryID(_loc2_,param1,EquipType.COMPOSE_MATERIAL);
         this.fillByCategoryID(_loc2_,param1,11);
         return param1;
      }
      
      private function fillByCategoryID(param1:DictionaryData, param2:DictionaryData, param3:int) : void
      {
         var _loc4_:InventoryItemInfo = null;
         for each(_loc4_ in param1)
         {
            if(_loc4_.CategoryID == param3)
            {
               param2.add(param2.length,_loc4_);
            }
         }
      }
      
      private function fillByTemplateID(param1:DictionaryData, param2:DictionaryData, param3:int) : void
      {
         var _loc4_:InventoryItemInfo = null;
         for each(_loc4_ in param1)
         {
            if(_loc4_.TemplateID == param3)
            {
               param2.add(param2.length,_loc4_);
            }
         }
      }
      
      private function fillByProperty1(param1:DictionaryData, param2:DictionaryData, param3:String) : void
      {
         var _loc5_:InventoryItemInfo = null;
         var _loc4_:Array = [];
         for each(_loc5_ in param1)
         {
            if(_loc5_.Property1 == param3)
            {
               _loc4_.push(_loc5_);
            }
         }
         this.bubbleSort(_loc4_);
         for each(_loc5_ in _loc4_)
         {
            param2.add(param2.length,_loc5_);
         }
      }
      
      private function findByTemplateID(param1:DictionaryData, param2:DictionaryData, param3:int) : void
      {
         var _loc5_:InventoryItemInfo = null;
         var _loc4_:Array = [];
         for each(_loc5_ in param1)
         {
            if(_loc5_.TemplateID == param3)
            {
               _loc4_.push(_loc5_);
            }
         }
         this.bubbleSort(_loc4_);
         for each(_loc5_ in _loc4_)
         {
            param2.add(param2.length,_loc5_);
         }
      }
      
      private function bubbleSort(param1:Array) : void
      {
         var _loc4_:Boolean = false;
         var _loc5_:int = 0;
         var _loc6_:InventoryItemInfo = null;
         var _loc2_:int = param1.length;
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_)
         {
            _loc4_ = true;
            _loc5_ = 0;
            while(_loc5_ < _loc2_ - 1)
            {
               if(param1[_loc5_].Quality < param1[_loc5_ + 1].Quality)
               {
                  _loc6_ = param1[_loc5_];
                  param1[_loc5_] = param1[_loc5_ + 1];
                  param1[_loc5_ + 1] = _loc6_;
                  _loc4_ = false;
               }
               _loc5_++;
            }
            if(_loc4_)
            {
               return;
            }
            _loc3_++;
         }
      }
      
      public function get info() : PlayerInfo
      {
         return this._info;
      }
      
      public function set currentPanel(param1:int) : void
      {
         this._currentPanel = param1;
      }
      
      public function get currentPanel() : int
      {
         return this._currentPanel;
      }
      
      public function get canCpsEquipmentList() : DictionaryData
      {
         return this._canCpsEquipmentList;
      }
      
      public function get canCpsMaterialList() : DictionaryData
      {
         return this._canCpsMaterialList;
      }
      
      public function get canCpsQewelryList() : DictionaryData
      {
         return this._canCpsQewelryList;
      }
      
      public function get canSplitEquipList() : DictionaryData
      {
         return this._canSplitEquipList;
      }
      
      public function get canRefiningEquipList() : DictionaryData
      {
         return this._canRefiningEquipList;
      }
      
      public function get canStrthEqpmtList() : DictionaryData
      {
         return this._canStrthEqpmtList;
      }
      
      public function get canEmbedEquipmentList() : DictionaryData
      {
         return this._canEmbedEquipmentList;
      }
      
      public function get canTransEquipmengtList() : DictionaryData
      {
         return this._canTransEquipmengtList;
      }
      
      public function set NeedAutoLink(param1:int) : void
      {
         this._needAutoLink = param1;
      }
      
      public function get NeedAutoLink() : int
      {
         return this._needAutoLink;
      }
      
      public function loadBagData() : void
      {
         this.initData();
      }
      
      public function get currentComposeItem() : ComposeCurrentInfo
      {
         if(this._currentComposeItem == null)
         {
            this._currentComposeItem = new ComposeCurrentInfo();
         }
         return this._currentComposeItem;
      }
      
      public function set currentComposeItem(param1:ComposeCurrentInfo) : void
      {
         var _loc2_:EquipmentTemplateInfo = null;
         if(param1.type == EquipType.EQUIP)
         {
            _loc2_ = ItemManager.Instance.getEquipTemplateById(param1.templeteID);
            if(_loc2_.TemplateType > 6)
            {
               param1.type = EquipType.QEWELRY;
            }
         }
         this._currentComposeItem = param1;
      }
      
      public function get weaponReady() : Boolean
      {
         return this._weaponReady;
      }
      
      public function set weaponReady(param1:Boolean) : void
      {
         this._weaponReady = param1;
      }
      
      public function get transWeaponReady() : Boolean
      {
         return this._transWeaponReady;
      }
      
      public function set transWeaponReady(param1:Boolean) : void
      {
         this._transWeaponReady = param1;
      }
      
      public function clear() : void
      {
         this._info.PropBag.removeEventListener(BagEvent.UPDATE,this.updateBag);
         this._info.Bag.removeEventListener(BagEvent.UPDATE,this.updateBag);
         this._info = null;
         this._equipmentBag = null;
      }
      
      public function get refiningConfig() : DictionaryData
      {
         return this._refiningConfig;
      }
      
      public function set refiningConfig(param1:DictionaryData) : void
      {
         this._refiningConfig = param1;
      }
      
      public function getRefiningConfigByLevel(param1:int) : RefiningConfigInfo
      {
         return this._refiningConfig[param1];
      }
      
      public function judgeEmbedIn(param1:InventoryItemInfo) : Boolean
      {
         var _loc2_:int = 1;
         while(_loc2_ <= 4)
         {
            if(param1["Hole" + _loc2_] > 1)
            {
               return true;
            }
            _loc2_++;
         }
         return false;
      }
   }
}
