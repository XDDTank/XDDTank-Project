package ddt.manager
{
   import com.pickgliss.action.FunctionAction;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.manager.CacheSysManager;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.constants.CacheConsts;
   import ddt.data.analyze.PetAdvanceAnalyzer;
   import ddt.data.analyze.PetEggInfoAnalyzer;
   import ddt.data.analyze.PetInfoAnalyzer;
   import ddt.data.quest.QuestInfo;
   import ddt.view.MainToolBar;
   import flash.utils.Dictionary;
   import pet.date.PetAdvanceInfo;
   import pet.date.PetEggInfo;
   import pet.date.PetInfo;
   import pet.date.PetTemplateInfo;
   import road7th.data.DictionaryData;
   
   public class PetInfoManager
   {
      
      private static var _instance:PetInfoManager;
       
      
      private var _petAdvanceList:Dictionary;
      
      private var _petTempletelist:Dictionary;
      
      private var _petEggList:Dictionary;
      
      public var petTransformCheckBtn:Boolean = false;
      
      private var _hasShowList:Vector.<int>;
      
      public function PetInfoManager()
      {
         this._hasShowList = new Vector.<int>();
         super();
      }
      
      public static function get instance() : PetInfoManager
      {
         return _instance = _instance || new PetInfoManager();
      }
      
      public function setupAdvanceList(param1:PetAdvanceAnalyzer) : void
      {
         this._petAdvanceList = param1.list;
      }
      
      public function setupTemplete(param1:PetInfoAnalyzer) : void
      {
         this._petTempletelist = param1.list;
      }
      
      public function setupEgg(param1:PetEggInfoAnalyzer) : void
      {
         this._petEggList = param1.list;
      }
      
      public function getTransformPet(param1:PetInfo, param2:PetInfo) : PetInfo
      {
         if(!param1 || !param2)
         {
            return null;
         }
         var _loc3_:PetInfo = new PetInfo();
         ObjectUtils.copyProperties(_loc3_,param1);
         var _loc4_:PetTemplateInfo = PetInfoManager.instance.getPetInfoByTemplateID(param1.TemplateID);
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         var _loc10_:int = param1.OrderNumber;
         var _loc11_:int = param2.OrderNumber;
         var _loc12_:int = _loc10_ > _loc11_ ? int(_loc11_) : int(_loc10_);
         var _loc13_:int = _loc10_ > _loc11_ ? int(_loc10_) : int(_loc11_);
         var _loc14_:int = _loc12_;
         while(_loc14_ < _loc13_)
         {
            _loc5_ += Math.floor(_loc4_.VBloodGrow * PetBagManager.instance().petModel.getAddLife(_loc14_));
            _loc6_ += Math.floor(_loc4_.VAttackGrow * PetBagManager.instance().petModel.getAddProperty(_loc14_));
            _loc7_ += Math.floor(_loc4_.VDefenceGrow * PetBagManager.instance().petModel.getAddProperty(_loc14_));
            _loc8_ += Math.floor(_loc4_.VAgilityGrow * PetBagManager.instance().petModel.getAddProperty(_loc14_));
            _loc9_ += Math.floor(_loc4_.VLuckGrow * PetBagManager.instance().petModel.getAddProperty(_loc14_));
            _loc14_++;
         }
         if(_loc10_ > _loc11_)
         {
            _loc3_.Blood -= _loc5_;
            _loc3_.Attack -= _loc6_;
            _loc3_.Defence -= _loc7_;
            _loc3_.Agility -= _loc8_;
            _loc3_.Luck -= _loc9_;
         }
         else
         {
            _loc3_.Blood += _loc5_;
            _loc3_.Attack += _loc6_;
            _loc3_.Defence += _loc7_;
            _loc3_.Agility += _loc8_;
            _loc3_.Luck += _loc9_;
         }
         return _loc3_;
      }
      
      public function getBlessedPetInfo(param1:PetInfo) : PetInfo
      {
         var _loc2_:PetInfo = this.getPetInfoByTemplateID(param1.TemplateID);
         var _loc3_:PetInfo = this.getPetInfoByTemplateID(param1.TemplateID + 100);
         var _loc4_:PetInfo = new PetInfo();
         ObjectUtils.copyProperties(_loc4_,_loc3_);
         _loc4_.Level = param1.Level;
         _loc4_.OrderNumber = param1.OrderNumber;
         _loc4_.Attack = param1.Attack + _loc3_.Attack - _loc2_.Attack + (_loc4_.AttackGrow - _loc2_.AttackGrow) * (_loc4_.Level - 1) + (_loc4_.VAttackGrow - _loc2_.VAttackGrow) * (_loc4_.OrderNumber - 1);
         _loc4_.Defence = param1.Defence + _loc3_.Defence - _loc2_.Defence + (_loc4_.DefenceGrow - _loc2_.DefenceGrow) * (_loc4_.Level - 1) + (_loc4_.VDefenceGrow - _loc2_.VDefenceGrow) * (_loc4_.OrderNumber - 1);
         _loc4_.Agility = param1.Agility + _loc3_.Agility - _loc2_.Agility + (_loc4_.AgilityGrow - _loc2_.AgilityGrow) * (_loc4_.Level - 1) + (_loc4_.VAgilityGrow - _loc2_.VAgilityGrow) * (_loc4_.OrderNumber - 1);
         _loc4_.Luck = param1.Luck + _loc3_.Luck - _loc2_.Luck + (_loc4_.LuckGrow - _loc2_.LuckGrow) * (_loc4_.Level - 1) + (_loc4_.VLuckGrow - _loc2_.VLuckGrow) * (_loc4_.OrderNumber - 1);
         _loc4_.Blood = param1.Blood + _loc3_.Blood - _loc2_.Blood + (_loc4_.BloodGrow - _loc2_.BloodGrow) * (_loc4_.Level - 1) + (_loc4_.VBloodGrow - _loc2_.VBloodGrow) * (_loc4_.OrderNumber - 1);
         return _loc4_;
      }
      
      public function getAdvanceInfo(param1:int) : PetAdvanceInfo
      {
         var _loc3_:PetAdvanceInfo = null;
         var _loc2_:PetAdvanceInfo = this._petAdvanceList[param1];
         if(_loc2_)
         {
            _loc3_ = new PetAdvanceInfo();
            ObjectUtils.copyProperties(_loc3_,_loc2_);
            return _loc3_;
         }
         return null;
      }
      
      public function getpetListSorted(param1:DictionaryData) : Vector.<PetInfo>
      {
         var petInfo:PetInfo = null;
         var pets:DictionaryData = param1;
         var result:Vector.<PetInfo> = new Vector.<PetInfo>();
         var i:int = 0;
         for each(petInfo in pets)
         {
            result.push(petInfo);
         }
         result.sort(function(param1:PetInfo, param2:PetInfo):int
         {
            return param1.ID > param2.ID ? int(1) : int(-1);
         });
         return result;
      }
      
      public function getPetListAdvanced(param1:DictionaryData) : Vector.<PetInfo>
      {
         var _loc4_:PetInfo = null;
         var _loc2_:Vector.<PetInfo> = this.getpetListSorted(param1);
         var _loc3_:Vector.<PetInfo> = new Vector.<PetInfo>();
         for each(_loc4_ in _loc2_)
         {
            if(_loc4_.MagicLevel > 0)
            {
               _loc3_.push(_loc4_);
            }
         }
         return _loc3_;
      }
      
      public function getPetInfoByTemplateID(param1:int) : PetInfo
      {
         var _loc2_:PetInfo = new PetInfo();
         var _loc3_:PetTemplateInfo = this._petTempletelist[param1];
         ObjectUtils.copyProperties(_loc2_,_loc3_);
         return _loc2_;
      }
      
      public function getPetEggListByKind(param1:int) : Vector.<PetEggInfo>
      {
         return this._petEggList[param1];
      }
      
      public function fillPetInfo(param1:PetInfo) : void
      {
         var _loc2_:PetTemplateInfo = this._petTempletelist[param1.TemplateID];
         if(_loc2_)
         {
            ObjectUtils.copyProperties(param1,_loc2_);
         }
      }
      
      public function getPetByLevel(param1:int, param2:int) : PetInfo
      {
         var _loc3_:PetInfo = this.getPetInfoByTemplateID(param1);
         _loc3_.Level = param2;
         _loc3_.Attack += _loc3_.AttackGrow * (param2 - 1);
         _loc3_.Defence += _loc3_.DefenceGrow * (param2 - 1);
         _loc3_.Agility += _loc3_.AgilityGrow * (param2 - 1);
         _loc3_.Blood += _loc3_.BloodGrow * (param2 - 1);
         _loc3_.Luck += _loc3_.LuckGrow * (param2 - 1);
         return _loc3_;
      }
      
      public function checkIsSamePetBase(param1:int, param2:int) : Boolean
      {
         return int(param1 / 100) == int(param2 / 100);
      }
      
      public function getNeedMagicPets() : Array
      {
         var _loc4_:PetInfo = null;
         var _loc1_:Array = [];
         var _loc2_:DictionaryData = PlayerManager.Instance.Self.pets;
         var _loc3_:int = int(ServerConfigManager.instance.findInfoByName(ServerConfigManager.PET_MAGIC_LEVEL1).Value);
         for each(_loc4_ in _loc2_)
         {
            if(_loc4_.Level >= _loc3_)
            {
               _loc1_.push(_loc4_.KindID);
            }
         }
         return _loc1_;
      }
      
      public function getAdvanceEffectUrl(param1:PetInfo) : String
      {
         var _loc2_:int = param1.OrderNumber / 10 > 5 ? int(5) : int(param1.OrderNumber / 10);
         var _loc3_:int = Math.log(_loc2_) * Math.LOG10E + 1;
         var _loc4_:String = "";
         while(_loc3_ < 3)
         {
            _loc4_ += "0";
            _loc3_++;
         }
         return "advance" + _loc4_ + _loc2_;
      }
      
      public function checkAllPetCanMagic() : void
      {
         var _loc2_:PetInfo = null;
         var _loc1_:DictionaryData = PlayerManager.Instance.Self.pets;
         for each(_loc2_ in _loc1_)
         {
            this.checkPetCanMagic(_loc2_);
         }
      }
      
      public function checkPetCanMagic(param1:PetInfo) : void
      {
         var itemName:String = null;
         var questInfo:QuestInfo = null;
         var showFunc:Function = null;
         var info:PetInfo = param1;
         var petMagicLevel1:int = int(ServerConfigManager.instance.findInfoByName(ServerConfigManager.PET_MAGIC_LEVEL1).Value);
         itemName = ItemManager.Instance.getTemplateById(info.ItemId).Name;
         if(this._hasShowList.indexOf(info.ID) == -1)
         {
            if(info.Level >= petMagicLevel1)
            {
               questInfo = TaskManager.instance.getPetMagicTask(info);
               if(questInfo)
               {
                  showFunc = function():void
                  {
                     var _loc1_:BaseAlerFrame = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("ddt.pet.magicTipText",info.Name,itemName),LanguageMgr.GetTranslation("lookover"),"",false,true,true);
                     _loc1_.info.carryData = questInfo;
                     _loc1_.addEventListener(FrameEvent.RESPONSE,__alertSubmit);
                  };
                  if(!MainToolBar.Instance.canOpenBag())
                  {
                     CacheSysManager.getInstance().cacheFunction(CacheConsts.ALERT_IN_FIGHT,new FunctionAction(showFunc));
                  }
                  else
                  {
                     showFunc();
                  }
                  this._hasShowList.push(info.ID);
               }
            }
         }
      }
      
      public function checkPetCanBless(param1:PetInfo, param2:int) : Boolean
      {
         return param1 && int(param1.TemplateID % 100000 / 10000) + 1 == param2 && param1.TemplateID % 1000 / 100 < 2;
      }
      
      protected function __alertSubmit(param1:FrameEvent) : void
      {
         var _loc2_:BaseAlerFrame = param1.currentTarget as BaseAlerFrame;
         _loc2_.removeEventListener(FrameEvent.RESPONSE,this.__alertSubmit);
         switch(param1.responseCode)
         {
            case FrameEvent.ENTER_CLICK:
            case FrameEvent.SUBMIT_CLICK:
               if(_loc2_.info.carryData)
               {
                  TaskManager.instance.showQuest(QuestInfo(_loc2_.info.carryData),1);
               }
         }
         _loc2_.dispose();
      }
   }
}
