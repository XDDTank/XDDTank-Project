package petsBag.data
{
   import ddt.data.PetExperienceManager;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.data.player.SelfInfo;
   import ddt.manager.PetInfoManager;
   import ddt.manager.PlayerManager;
   import flash.events.EventDispatcher;
   import pet.date.PetInfo;
   
   public class PetBagModel extends EventDispatcher
   {
      
      public static const PET_BAG_START_INDEX:int = 10;
       
      
      private var _selfInfo:SelfInfo;
      
      private var _petsBagList:Array;
      
      public var petOpenLevel:int;
      
      public var PetMagicLevel1:int;
      
      public var PetMagicLevel2:int;
      
      public var AdvanceStoneTemplateId:int;
      
      public var petAddPropertyRate:Vector.<Number>;
      
      public var petAddLifeRate:Vector.<Number>;
      
      private var _spaceLevel:int = 1;
      
      public function PetBagModel()
      {
         super();
         this._selfInfo = PlayerManager.Instance.Self;
      }
      
      public function getAddProperty(param1:int) : Number
      {
         return this.petAddPropertyRate[int(param1 / 10)];
      }
      
      public function getAddLife(param1:int) : Number
      {
         var _loc2_:int = int(param1 / 10);
         if(_loc2_ < 0 || _loc2_ >= this.petAddLifeRate.length)
         {
            return 0;
         }
         return this.petAddLifeRate[int(param1 / 10)];
      }
      
      public function initPetPropertyRate(param1:String) : void
      {
         this.petAddPropertyRate = new Vector.<Number>();
         var _loc2_:Array = param1.split("|");
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_.length)
         {
            if(_loc2_[_loc3_].length > 0)
            {
               this.petAddPropertyRate.push(_loc2_[_loc3_]);
            }
            _loc3_++;
         }
      }
      
      public function initPetLifeRate(param1:String) : void
      {
         this.petAddLifeRate = new Vector.<Number>();
         var _loc2_:Array = param1.split("|");
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_.length)
         {
            if(_loc2_[_loc3_].length > 0)
            {
               this.petAddLifeRate.push(_loc2_[_loc3_]);
            }
            _loc3_++;
         }
      }
      
      public function getAdvanceStoneCount() : int
      {
         var _loc3_:InventoryItemInfo = null;
         var _loc1_:Array = this.selfInfo.Bag.findItemsByTempleteID(this.AdvanceStoneTemplateId);
         var _loc2_:int = 0;
         for each(_loc3_ in _loc1_)
         {
            _loc2_ += _loc3_.Count;
         }
         return _loc2_;
      }
      
      public function get spaceLevel() : int
      {
         return this._spaceLevel;
      }
      
      public function set spaceLevel(param1:int) : void
      {
         if(param1 < 1)
         {
            this._spaceLevel = 1;
         }
         else if(param1 > PetExperienceManager.MAX_LEVEL)
         {
            this._spaceLevel = PetExperienceManager.MAX_LEVEL;
         }
         else
         {
            this._spaceLevel = param1;
         }
      }
      
      public function checkHasPet(param1:int) : Boolean
      {
         var _loc2_:PetInfo = null;
         for each(_loc2_ in this._selfInfo.pets)
         {
            if(PetInfoManager.instance.checkIsSamePetBase(_loc2_.TemplateID,param1))
            {
               return true;
            }
         }
         return false;
      }
      
      public function get selfInfo() : SelfInfo
      {
         return this._selfInfo;
      }
      
      public function getPetInfoByID(param1:int) : PetInfo
      {
         var _loc2_:PetInfo = null;
         for each(_loc2_ in this._selfInfo.pets)
         {
            if(_loc2_.ID == param1)
            {
               return _loc2_;
            }
         }
         return null;
      }
      
      public function getpetListSorted() : Vector.<PetInfo>
      {
         var petInfo:PetInfo = null;
         var result:Vector.<PetInfo> = new Vector.<PetInfo>();
         var i:int = 0;
         for each(petInfo in this._selfInfo.pets)
         {
            result.push(petInfo);
         }
         result.sort(function(param1:PetInfo, param2:PetInfo):int
         {
            return param1.ID > param2.ID ? int(1) : int(-1);
         });
         return result;
      }
   }
}
