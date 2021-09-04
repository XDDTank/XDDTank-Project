package ddt.manager
{
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.EquipType;
   import ddt.data.analyze.BagCellInfoListAnalyze;
   import ddt.data.analyze.ComposeConfigListAnalyzer;
   import ddt.data.analyze.EquipPropertyListAnalyzer;
   import ddt.data.analyze.EquipSplitListAnalyzer;
   import ddt.data.analyze.EquipStrengthListAnalyzer;
   import ddt.data.analyze.EquipmentTemplateAnalyzer;
   import ddt.data.analyze.GoodCategoryAnalyzer;
   import ddt.data.analyze.ItemTempleteAnalyzer;
   import ddt.data.analyze.RuneSuitAnalyzer;
   import ddt.data.analyze.SuidTipsAnalyzer;
   import ddt.data.goods.BagCellInfo;
   import ddt.data.goods.CateCoryInfo;
   import ddt.data.goods.ComposeListInfo;
   import ddt.data.goods.EquipStrengthInfo;
   import ddt.data.goods.EquipmentTemplateInfo;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.data.goods.RuneSuitInfo;
   import ddt.data.goods.SpliteListInfo;
   import ddt.data.goods.SuidTipInfo;
   import flash.events.EventDispatcher;
   import road7th.data.DictionaryData;
   import store.view.Compose.ComposeType;
   
   [Event(name="templateReady",type="flash.events.Event")]
   public class ItemManager extends EventDispatcher
   {
      
      private static var _instance:ItemManager;
       
      
      private var _categorys:Vector.<CateCoryInfo>;
      
      private var _goodsTemplates:DictionaryData;
      
      private var _equipTemplates:DictionaryData;
      
      private var _EquipPropertyList:DictionaryData;
      
      private var _composeList:DictionaryData;
      
      private var _spliteList:DictionaryData;
      
      private var _equipStrengthList:DictionaryData;
      
      private var _bagCellList:DictionaryData;
      
      private var _suidList:DictionaryData;
      
      private var _runeList:DictionaryData;
      
      private var _storeCateCory:Array;
      
      private var _equipComposeList:DictionaryData;
      
      private var _materialComposeList:DictionaryData;
      
      private var _jewelryComposeList:DictionaryData;
      
      private var _embedStoneComposeList:DictionaryData;
      
      private var _composeSuitInfoList:DictionaryData;
      
      private var _composeMaterialInfoList:DictionaryData;
      
      private var _composeEmbedInfoList:DictionaryData;
      
      private var _composeJewelryInfoList:DictionaryData;
      
      public function ItemManager()
      {
         super();
      }
      
      public static function fill(param1:InventoryItemInfo) : InventoryItemInfo
      {
         var _loc3_:int = 0;
         var _loc4_:Array = null;
         var _loc2_:ItemTemplateInfo = ItemManager.Instance.getTemplateById(param1.TemplateID);
         ObjectUtils.copyProperties(param1,_loc2_);
         if(_loc2_)
         {
            _loc3_ = 0;
            while(_loc3_ < 4)
            {
               _loc4_ = EquipType.getEmbedHoleInfo(_loc2_,_loc3_);
               if(_loc4_[0] == "-1" && _loc4_[1] == "0")
               {
                  param1["Hole" + (_loc3_ + 1)] = 1;
               }
               else
               {
                  param1["Hole" + (_loc3_ + 1)] = _loc4_[0];
               }
               _loc3_++;
            }
         }
         return param1;
      }
      
      public static function get Instance() : ItemManager
      {
         if(_instance == null)
         {
            _instance = new ItemManager();
         }
         return _instance;
      }
      
      public function setupGoodsTemplates(param1:ItemTempleteAnalyzer) : void
      {
         this._goodsTemplates = param1.list;
      }
      
      public function setupGoodsCategory(param1:GoodCategoryAnalyzer) : void
      {
         this._categorys = param1.list;
      }
      
      public function setupEquipsTemplates(param1:EquipmentTemplateAnalyzer) : void
      {
         this._equipTemplates = param1.list;
      }
      
      public function setupEquipPropertyList(param1:EquipPropertyListAnalyzer) : void
      {
         this._EquipPropertyList = param1.list;
      }
      
      public function setupComposeItemConfigList(param1:ComposeConfigListAnalyzer) : void
      {
         this._composeList = param1.list;
      }
      
      public function setupEquipComposeSplitList(param1:EquipSplitListAnalyzer) : void
      {
         this._spliteList = param1.list;
      }
      
      public function setupEquipStrengthList(param1:EquipStrengthListAnalyzer) : void
      {
         this._equipStrengthList = param1.list;
      }
      
      public function setupBagCellList(param1:BagCellInfoListAnalyze) : void
      {
         this._bagCellList = param1.list;
      }
      
      public function addGoodsTemplates(param1:ItemTempleteAnalyzer) : void
      {
         var _loc2_:ItemTemplateInfo = null;
         for each(_loc2_ in param1.list)
         {
            if(!this._goodsTemplates.hasKey(_loc2_.TemplateID))
            {
               this._goodsTemplates.add(_loc2_.TemplateID,_loc2_);
            }
            else
            {
               this._goodsTemplates[_loc2_.TemplateID] = _loc2_;
            }
         }
      }
      
      public function setupSuidList(param1:SuidTipsAnalyzer) : void
      {
         this._suidList = param1.list;
      }
      
      public function setupRuneList(param1:RuneSuitAnalyzer) : void
      {
         this._runeList = param1.list;
      }
      
      public function getTemplateById(param1:int) : ItemTemplateInfo
      {
         return this._goodsTemplates[param1];
      }
      
      public function getEquipTemplateById(param1:int) : EquipmentTemplateInfo
      {
         return this._equipTemplates[param1];
      }
      
      public function getEquipPropertyListById(param1:int) : EquipmentTemplateInfo
      {
         return this._EquipPropertyList[param1];
      }
      
      public function getEquipLimitLevel(param1:int) : int
      {
         return this._equipTemplates[param1].StrengthLimit;
      }
      
      public function getBagCellByPlace(param1:int) : BagCellInfo
      {
         return this._bagCellList[param1];
      }
      
      public function getEquipTemplateBySuitID(param1:int) : DictionaryData
      {
         var _loc3_:EquipmentTemplateInfo = null;
         var _loc2_:DictionaryData = new DictionaryData();
         for each(_loc3_ in this._equipTemplates)
         {
            if(_loc3_.SuitID == param1)
            {
               _loc2_.add(_loc3_.TemplateID,_loc3_);
            }
         }
         return _loc2_;
      }
      
      public function get categorys() : Vector.<CateCoryInfo>
      {
         return this._categorys.slice(0);
      }
      
      public function get storeCateCory() : Array
      {
         return this._storeCateCory;
      }
      
      public function set storeCateCory(param1:Array) : void
      {
         this._storeCateCory = param1;
      }
      
      public function get goodsTemplates() : DictionaryData
      {
         return this._goodsTemplates;
      }
      
      public function getFreeTemplateByCategoryId(param1:int, param2:int = 0) : ItemTemplateInfo
      {
         if(param1 != EquipType.ARM)
         {
            return this.getTemplateById(Number(String(param1) + String(param2) + "01"));
         }
         return this.getTemplateById(Number(String(param1) + "00" + String(param2)));
      }
      
      public function searchGoodsNameByStr(param1:String) : Array
      {
         var _loc3_:ItemTemplateInfo = null;
         var _loc4_:int = 0;
         var _loc2_:Array = new Array();
         for each(_loc3_ in this._goodsTemplates)
         {
            if(_loc3_.Name.indexOf(param1) > -1)
            {
               if(_loc2_.length == 0)
               {
                  _loc2_.push(_loc3_.Name);
               }
               else
               {
                  _loc4_ = 0;
                  while(_loc4_ < _loc2_.length)
                  {
                     if(_loc2_[_loc4_] == _loc3_.Name)
                     {
                        break;
                     }
                     if(_loc4_ == _loc2_.length - 1)
                     {
                        _loc2_.push(_loc3_.Name);
                     }
                     _loc4_++;
                  }
               }
            }
         }
         return _loc2_;
      }
      
      public function getComposeList(param1:int = 0) : DictionaryData
      {
         var _loc2_:DictionaryData = new DictionaryData();
         if(param1 == 0)
         {
            _loc2_ = this._composeList;
         }
         else if(param1 == 1)
         {
            _loc2_ = this.getEquipComposeList();
         }
         else if(param1 == 2)
         {
            _loc2_ = this.getJewelryComposeList();
         }
         else if(param1 == 3)
         {
            _loc2_ = this.getMaterialComposeList();
         }
         else if(param1 == 4)
         {
            _loc2_ = this.getEmbedStoneComposeList();
         }
         return _loc2_;
      }
      
      private function getEquipComposeList() : DictionaryData
      {
         var _loc1_:ComposeListInfo = null;
         if(this._equipComposeList == null)
         {
            this._equipComposeList = new DictionaryData();
            for each(_loc1_ in this._composeList)
            {
               if(_loc1_.Type == ComposeType.EQUIP)
               {
                  this._equipComposeList.add(_loc1_.ID,_loc1_);
               }
            }
         }
         return this._equipComposeList;
      }
      
      private function getMaterialComposeList() : DictionaryData
      {
         var _loc1_:ComposeListInfo = null;
         if(this._materialComposeList == null)
         {
            this._materialComposeList = new DictionaryData();
            for each(_loc1_ in this._composeList)
            {
               if(_loc1_.Type == ComposeType.MATERIAL)
               {
                  this._materialComposeList.add(_loc1_.ID,_loc1_);
               }
            }
         }
         return this._materialComposeList;
      }
      
      private function getJewelryComposeList() : DictionaryData
      {
         var _loc1_:ComposeListInfo = null;
         if(this._jewelryComposeList == null)
         {
            this._jewelryComposeList = new DictionaryData();
            for each(_loc1_ in this._composeList)
            {
               if(_loc1_.Type == ComposeType.JEWELRY)
               {
                  this._jewelryComposeList.add(_loc1_.ID,_loc1_);
               }
            }
         }
         return this._jewelryComposeList;
      }
      
      private function getEmbedStoneComposeList() : DictionaryData
      {
         var _loc1_:ComposeListInfo = null;
         if(this._embedStoneComposeList == null)
         {
            this._embedStoneComposeList = new DictionaryData();
            for each(_loc1_ in this._composeList)
            {
               if(_loc1_.Type == ComposeType.EMBED_STONE)
               {
                  this._embedStoneComposeList.add(_loc1_.ID,_loc1_);
               }
            }
         }
         return this._embedStoneComposeList;
      }
      
      public function getComposeInfoList(param1:int, param2:int = 0) : DictionaryData
      {
         var _loc3_:DictionaryData = new DictionaryData();
         if(param1 == 1)
         {
            _loc3_ = this.getComposeSuitInfoList(param2);
         }
         if(param1 == 2)
         {
            _loc3_ = this.getComposeJewelryInfoList();
         }
         if(param1 == 3)
         {
            _loc3_ = this.getComposeMaterialInfoList();
         }
         if(param1 == 4)
         {
            _loc3_ = this.getComposeEmbedInfoList();
         }
         return _loc3_;
      }
      
      public function judgeSuitQuality(param1:int, param2:int) : Boolean
      {
         var _loc3_:Array = new Array();
         switch(param2)
         {
            case 0:
               _loc3_ = this._equipComposeList[param1].TemplateArray1;
               break;
            case 1:
               _loc3_ = this._equipComposeList[param1].TemplateArray2;
               break;
            case 2:
               _loc3_ = this._equipComposeList[param1].TemplateArray3;
               break;
            case 3:
               _loc3_ = this._equipComposeList[param1].TemplateArray4;
               break;
            case 4:
               _loc3_ = this._equipComposeList[param1].TemplateArray5;
         }
         if(_loc3_[0] != 0)
         {
            return true;
         }
         return false;
      }
      
      private function getComposeSuitInfoList(param1:int) : DictionaryData
      {
         var _loc3_:ComposeListInfo = null;
         var _loc4_:Array = null;
         var _loc5_:int = 0;
         var _loc6_:Array = null;
         var _loc7_:int = 0;
         var _loc2_:ItemTemplateInfo = new ItemTemplateInfo();
         this._composeSuitInfoList = new DictionaryData();
         for each(_loc3_ in this._equipComposeList)
         {
            _loc4_ = new Array();
            _loc5_ = 0;
            _loc6_ = new Array();
            switch(param1)
            {
               case 0:
                  _loc6_ = _loc3_.TemplateArray1;
                  break;
               case 1:
                  _loc6_ = _loc3_.TemplateArray2;
                  break;
               case 2:
                  _loc6_ = _loc3_.TemplateArray3;
                  break;
               case 3:
                  _loc6_ = _loc3_.TemplateArray4;
                  break;
               case 4:
                  _loc6_ = _loc3_.TemplateArray5;
            }
            if(_loc6_[0] != 0)
            {
               for each(_loc7_ in _loc6_)
               {
                  _loc2_ = this.getTemplateById(_loc7_);
                  _loc4_[_loc5_] = _loc2_;
                  _loc5_++;
               }
               this._composeSuitInfoList.add(_loc3_.ID,_loc4_);
            }
         }
         return this._composeSuitInfoList;
      }
      
      private function getComposeMaterialInfoList() : DictionaryData
      {
         var _loc3_:ComposeListInfo = null;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc1_:Array = new Array();
         var _loc2_:ItemTemplateInfo = new ItemTemplateInfo();
         if(this._composeMaterialInfoList == null)
         {
            this._composeMaterialInfoList = new DictionaryData();
            for each(_loc3_ in this._materialComposeList)
            {
               _loc1_ = new Array();
               _loc4_ = 0;
               for each(_loc5_ in _loc3_.TemplateArray1)
               {
                  _loc2_ = this.getTemplateById(_loc5_);
                  _loc1_[_loc4_] = _loc2_;
                  _loc4_++;
               }
               this._composeMaterialInfoList.add(_loc3_.ID,_loc1_);
            }
         }
         return this._composeMaterialInfoList;
      }
      
      private function getComposeEmbedInfoList() : DictionaryData
      {
         var _loc3_:ComposeListInfo = null;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc1_:Array = new Array();
         var _loc2_:ItemTemplateInfo = new ItemTemplateInfo();
         if(this._composeEmbedInfoList == null)
         {
            this._composeEmbedInfoList = new DictionaryData();
            for each(_loc3_ in this._embedStoneComposeList)
            {
               _loc1_ = new Array();
               _loc4_ = 0;
               for each(_loc5_ in _loc3_.TemplateArray1)
               {
                  _loc2_ = this.getTemplateById(_loc5_);
                  _loc1_[_loc4_] = _loc2_;
                  _loc4_++;
               }
               this._composeEmbedInfoList.add(_loc3_.ID,_loc1_);
            }
         }
         return this._composeEmbedInfoList;
      }
      
      private function getComposeJewelryInfoList() : DictionaryData
      {
         var _loc3_:ComposeListInfo = null;
         var _loc4_:int = 0;
         var _loc1_:Array = new Array();
         var _loc2_:ItemTemplateInfo = new ItemTemplateInfo();
         if(this._composeJewelryInfoList == null)
         {
            this._composeJewelryInfoList = new DictionaryData();
            for each(_loc3_ in this._jewelryComposeList)
            {
               _loc1_ = new Array();
               for each(_loc4_ in _loc3_.TemplateArray1)
               {
                  _loc2_ = this.getTemplateById(_loc4_);
                  _loc1_[_loc4_] = _loc2_;
               }
               this._composeJewelryInfoList.add(_loc3_.ID,_loc1_);
            }
         }
         return this._composeJewelryInfoList;
      }
      
      public function getSpliteInfoByID(param1:int) : SpliteListInfo
      {
         if(this._spliteList)
         {
            return this._spliteList[param1];
         }
         return null;
      }
      
      public function getSuidListByLevle(param1:int) : SuidTipInfo
      {
         return this._suidList[param1];
      }
      
      public function getRuneListByLevel(param1:int) : RuneSuitInfo
      {
         return this._runeList[param1];
      }
      
      public function getRuneMaxLevel() : int
      {
         return this._runeList[this._runeList.length].ID;
      }
      
      public function getEquipStrengthInfoByLevel(param1:int, param2:int) : EquipStrengthInfo
      {
         var _loc3_:String = param1.toString() + param2.toString();
         if(this._equipStrengthList)
         {
            return this._equipStrengthList[_loc3_];
         }
         return null;
      }
      
      public function getAddMinorProperty(param1:ItemTemplateInfo, param2:InventoryItemInfo) : int
      {
         var _loc3_:int = 0;
         var _loc4_:InventoryItemInfo = param2;
         var _loc5_:EquipmentTemplateInfo = ItemManager.Instance.getEquipTemplateById(param1.TemplateID);
         var _loc6_:EquipStrengthInfo = ItemManager.Instance.getEquipStrengthInfoByLevel(_loc4_.StrengthenLevel + 1,_loc5_.QualityID);
         if(_loc5_.MainProperty1ID == 1)
         {
            _loc3_ = _loc6_.Attack;
         }
         else if(_loc5_.MainProperty1ID == 2)
         {
            _loc3_ = _loc6_.Defence;
         }
         else if(_loc5_.MainProperty1ID == 3)
         {
            _loc3_ = _loc6_.Agility;
         }
         else if(_loc5_.MainProperty1ID == 4)
         {
            _loc3_ = _loc6_.Lucky;
         }
         else if(_loc5_.MainProperty1ID == 5)
         {
            _loc3_ = _loc6_.Damage;
         }
         else if(_loc5_.MainProperty1ID == 6)
         {
            _loc3_ = _loc6_.Guard;
         }
         else if(_loc5_.MainProperty1ID == 7)
         {
            _loc3_ = _loc6_.Blood;
         }
         else if(_loc5_.MainProperty1ID == 8)
         {
            _loc3_ = _loc6_.Energy;
         }
         else if(_loc5_.MainProperty1ID == 9)
         {
            _loc3_ = _loc6_.ReplayBlood;
         }
         else if(_loc5_.MainProperty1ID == 10)
         {
            _loc3_ = _loc6_.CritDamage;
         }
         else if(_loc5_.MainProperty1ID == 11)
         {
            _loc3_ = _loc6_.RepelCrit;
         }
         else if(_loc5_.MainProperty1ID == 12)
         {
            _loc3_ = _loc6_.RepelCritDamage;
         }
         return _loc3_;
      }
      
      public function getAddTwoMinorProperty(param1:ItemTemplateInfo, param2:InventoryItemInfo) : int
      {
         var _loc3_:int = 0;
         var _loc4_:InventoryItemInfo = param2;
         var _loc5_:EquipmentTemplateInfo = ItemManager.Instance.getEquipTemplateById(param1.TemplateID);
         var _loc6_:EquipStrengthInfo = ItemManager.Instance.getEquipStrengthInfoByLevel(_loc4_.StrengthenLevel + 1,_loc5_.QualityID);
         if(_loc5_.MainProperty2ID == 1)
         {
            _loc3_ = _loc6_.Attack;
         }
         else if(_loc5_.MainProperty2ID == 2)
         {
            _loc3_ = _loc6_.Defence;
         }
         else if(_loc5_.MainProperty2ID == 3)
         {
            _loc3_ = _loc6_.Agility;
         }
         else if(_loc5_.MainProperty2ID == 4)
         {
            _loc3_ = _loc6_.Lucky;
         }
         else if(_loc5_.MainProperty2ID == 5)
         {
            _loc3_ = _loc6_.Damage;
         }
         else if(_loc5_.MainProperty2ID == 6)
         {
            _loc3_ = _loc6_.Guard;
         }
         else if(_loc5_.MainProperty2ID == 7)
         {
            _loc3_ = _loc6_.Blood;
         }
         else if(_loc5_.MainProperty2ID == 8)
         {
            _loc3_ = _loc6_.Energy;
         }
         else if(_loc5_.MainProperty2ID == 9)
         {
            _loc3_ = _loc6_.Crit;
         }
         else if(_loc5_.MainProperty2ID == 10)
         {
            _loc3_ = _loc6_.CritDamage;
         }
         else if(_loc5_.MainProperty2ID == 11)
         {
            _loc3_ = _loc6_.RepelCrit;
         }
         else if(_loc5_.MainProperty2ID == 12)
         {
            _loc3_ = _loc6_.RepelCritDamage;
         }
         return _loc3_;
      }
      
      public function getMinorProperty(param1:ItemTemplateInfo, param2:InventoryItemInfo) : int
      {
         var _loc3_:int = 0;
         var _loc4_:InventoryItemInfo = param2;
         var _loc5_:EquipmentTemplateInfo = ItemManager.Instance.getEquipTemplateById(param1.TemplateID);
         var _loc6_:EquipStrengthInfo = ItemManager.Instance.getEquipStrengthInfoByLevel(_loc4_.StrengthenLevel,_loc5_.QualityID);
         if(_loc5_.MainProperty1ID == 1)
         {
            _loc3_ = _loc6_.Attack;
         }
         else if(_loc5_.MainProperty1ID == 2)
         {
            _loc3_ = _loc6_.Defence;
         }
         else if(_loc5_.MainProperty1ID == 3)
         {
            _loc3_ = _loc6_.Agility;
         }
         else if(_loc5_.MainProperty1ID == 4)
         {
            _loc3_ = _loc6_.Lucky;
         }
         else if(_loc5_.MainProperty1ID == 5)
         {
            _loc3_ = _loc6_.Damage;
         }
         else if(_loc5_.MainProperty1ID == 6)
         {
            _loc3_ = _loc6_.Guard;
         }
         else if(_loc5_.MainProperty1ID == 7)
         {
            _loc3_ = _loc6_.Blood;
         }
         else if(_loc5_.MainProperty1ID == 8)
         {
            _loc3_ = _loc6_.Energy;
         }
         else if(_loc5_.MainProperty1ID == 9)
         {
            _loc3_ = _loc6_.ReplayBlood;
         }
         else if(_loc5_.MainProperty1ID == 10)
         {
            _loc3_ = _loc6_.CritDamage;
         }
         else if(_loc5_.MainProperty1ID == 11)
         {
            _loc3_ = _loc6_.RepelCrit;
         }
         else if(_loc5_.MainProperty1ID == 12)
         {
            _loc3_ = _loc6_.RepelCritDamage;
         }
         return _loc3_;
      }
      
      public function getTwoMinorProperty(param1:ItemTemplateInfo, param2:InventoryItemInfo) : int
      {
         var _loc3_:int = 0;
         var _loc4_:InventoryItemInfo = param2;
         var _loc5_:EquipmentTemplateInfo = ItemManager.Instance.getEquipTemplateById(param1.TemplateID);
         var _loc6_:EquipStrengthInfo = ItemManager.Instance.getEquipStrengthInfoByLevel(_loc4_.StrengthenLevel,_loc5_.QualityID);
         if(_loc5_.MainProperty2ID == 1)
         {
            _loc3_ = _loc6_.Attack;
         }
         else if(_loc5_.MainProperty2ID == 2)
         {
            _loc3_ = _loc6_.Defence;
         }
         else if(_loc5_.MainProperty2ID == 3)
         {
            _loc3_ = _loc6_.Agility;
         }
         else if(_loc5_.MainProperty2ID == 4)
         {
            _loc3_ = _loc6_.Lucky;
         }
         else if(_loc5_.MainProperty2ID == 5)
         {
            _loc3_ = _loc6_.Damage;
         }
         else if(_loc5_.MainProperty2ID == 6)
         {
            _loc3_ = _loc6_.Guard;
         }
         else if(_loc5_.MainProperty2ID == 7)
         {
            _loc3_ = _loc6_.Blood;
         }
         else if(_loc5_.MainProperty2ID == 8)
         {
            _loc3_ = _loc6_.Energy;
         }
         else if(_loc5_.MainProperty2ID == 9)
         {
            _loc3_ = _loc6_.Crit;
         }
         else if(_loc5_.MainProperty2ID == 10)
         {
            _loc3_ = _loc6_.CritDamage;
         }
         else if(_loc5_.MainProperty2ID == 11)
         {
            _loc3_ = _loc6_.RepelCrit;
         }
         else if(_loc5_.MainProperty2ID == 12)
         {
            _loc3_ = _loc6_.RepelCritDamage;
         }
         return _loc3_;
      }
      
      public function judgeJewelry(param1:ItemTemplateInfo) : Boolean
      {
         var _loc2_:EquipmentTemplateInfo = null;
         if(param1.CategoryID == EquipType.EQUIP)
         {
            _loc2_ = this.getEquipTemplateById(param1.TemplateID);
            if(_loc2_.TemplateType > 6 && _loc2_.TemplateType < 11)
            {
               return true;
            }
         }
         return false;
      }
      
      public function judgeOldJewelry(param1:ItemTemplateInfo) : Boolean
      {
         if(param1.CategoryID == EquipType.EQUIP)
         {
            if(param1.TemplateID > 40499 && param1.TemplateID < 405309)
            {
               return true;
            }
         }
         return false;
      }
   }
}
