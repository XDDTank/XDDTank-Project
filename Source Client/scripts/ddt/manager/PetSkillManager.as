package ddt.manager
{
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.analyze.PetCommonSkillAnalyzer;
   import ddt.data.analyze.PetSkillInfoAnalyzer;
   import ddt.data.analyze.PetSkillTemplateInfoAnalyzer;
   import flash.utils.Dictionary;
   import pet.date.PetBaseSkillInfo;
   import pet.date.PetCommonSkill;
   import pet.date.PetInfo;
   import pet.date.PetSkillInfo;
   import pet.date.PetSkillTemplateInfo;
   
   public class PetSkillManager
   {
      
      private static var _instance:PetSkillManager;
       
      
      private var _commonSkillList:Dictionary;
      
      private var _infoList:Dictionary;
      
      private var _templateInfoList:Dictionary;
      
      private var _defaultSkillList:Dictionary;
      
      public function PetSkillManager()
      {
         super();
      }
      
      public static function get instance() : PetSkillManager
      {
         return _instance = _instance || new PetSkillManager();
      }
      
      public function setupCommonSkillList(param1:PetCommonSkillAnalyzer) : void
      {
         this._commonSkillList = param1.list;
      }
      
      public function setupInfoList(param1:PetSkillInfoAnalyzer) : void
      {
         this._infoList = param1.list;
      }
      
      public function setupTemplatenfoList(param1:PetSkillTemplateInfoAnalyzer) : void
      {
         this._templateInfoList = param1.list;
         this.initDefaultList();
      }
      
      private function initDefaultList() : void
      {
         var _loc1_:PetSkillTemplateInfo = null;
         this._defaultSkillList = new Dictionary();
         for each(_loc1_ in this._templateInfoList)
         {
            if(_loc1_.SkillLevel == 1)
            {
               this._defaultSkillList[_loc1_.SkillPlace * 100 + _loc1_.KindID] = _loc1_;
            }
         }
      }
      
      public function getCommonSkillByID(param1:int) : PetCommonSkill
      {
         var _loc3_:PetCommonSkill = null;
         var _loc2_:PetCommonSkill = this._commonSkillList[param1];
         if(_loc2_)
         {
            _loc3_ = new PetCommonSkill();
            ObjectUtils.copyProperties(_loc3_,_loc2_);
            return _loc3_;
         }
         return null;
      }
      
      public function getSkillBaseInfo(param1:int) : PetBaseSkillInfo
      {
         var _loc3_:PetSkillInfo = null;
         var _loc4_:PetCommonSkill = null;
         var _loc2_:PetBaseSkillInfo = new PetBaseSkillInfo();
         if(param1 < 1000)
         {
            _loc3_ = this.getSkillByID(param1);
            _loc2_.SkillID = _loc3_.ID;
            _loc2_.Name = _loc3_.Name;
            _loc2_.Decription = _loc3_.Description;
            _loc2_.Pic = _loc3_.Pic;
         }
         else
         {
            _loc4_ = this.getCommonSkillByID(param1);
            _loc2_.SkillID = _loc4_.SkillID;
            _loc2_.Name = _loc4_.Name;
            _loc2_.Decription = _loc4_.SkillLable;
            _loc2_.Pic = _loc4_.Pic;
         }
         return _loc2_;
      }
      
      public function getSkillByID(param1:int) : PetSkillInfo
      {
         var _loc3_:PetSkillInfo = null;
         var _loc2_:PetSkillInfo = this._infoList[param1];
         if(_loc2_)
         {
            _loc3_ = new PetSkillInfo();
            ObjectUtils.copyProperties(_loc3_,_loc2_);
            return _loc3_;
         }
         return null;
      }
      
      public function getTemplateInfoByID(param1:int) : PetSkillTemplateInfo
      {
         var _loc3_:PetSkillTemplateInfo = null;
         var _loc2_:PetSkillTemplateInfo = this._templateInfoList[param1];
         if(_loc2_)
         {
            _loc3_ = new PetSkillTemplateInfo();
            ObjectUtils.copyProperties(_loc3_,_loc2_);
            return _loc3_;
         }
         return null;
      }
      
      public function getPreSkill(param1:PetSkillTemplateInfo) : Dictionary
      {
         var _loc6_:Array = null;
         var _loc7_:Array = null;
         var _loc8_:String = null;
         var _loc2_:Dictionary = new Dictionary();
         var _loc3_:int = param1.SkillID;
         if(_loc3_ < 1000)
         {
            _loc2_["name"] = this.getSkillByID(_loc3_).Name;
         }
         else
         {
            _loc2_["name"] = this.getCommonSkillByID(_loc3_).Name;
         }
         var _loc4_:PetSkillTemplateInfo = this.getTemplateInfoByID(_loc3_);
         var _loc5_:PetSkillTemplateInfo = this.getTemplateInfoByID(_loc4_.NextSkillId);
         _loc6_ = _loc4_.BeforeSkillId.split(",");
         _loc7_ = [];
         for each(_loc8_ in _loc6_)
         {
            _loc3_ = int(_loc8_);
            if(_loc3_ < 0)
            {
               _loc7_.push("都可以");
            }
            else if(_loc3_ > 0)
            {
               _loc7_.push(this.getSkillBaseInfo(_loc3_));
            }
         }
         _loc2_["c"] = _loc7_;
         _loc6_ = _loc5_.BeforeSkillId.split(",");
         _loc7_ = [];
         for each(_loc8_ in _loc6_)
         {
            _loc3_ = int(_loc8_);
            if(_loc3_ < 0)
            {
               _loc7_.push("都可以");
            }
            else if(_loc3_ > 0)
            {
               _loc7_.push(this.getSkillBaseInfo(_loc3_));
            }
         }
         _loc2_["n"] = _loc7_;
         return _loc2_;
      }
      
      public function checkCanUpgrade(param1:int, param2:PetInfo) : Boolean
      {
         var _loc3_:PetSkillTemplateInfo = this.getTemplateInfoByID(param1);
         if(!_loc3_)
         {
            return false;
         }
         var _loc4_:PetSkillTemplateInfo = this.getTemplateInfoByID(_loc3_.NextSkillId);
         if(!_loc4_)
         {
            return false;
         }
         var _loc5_:PetSkillTemplateInfo = Boolean(param2.skills[_loc3_.SkillPlace]) ? _loc4_ : _loc3_;
         if(_loc5_.MinLevel > param2.Level)
         {
            return false;
         }
         if(_loc5_.SkillLevel > _loc5_.SkillMaxLevel)
         {
            return false;
         }
         if(_loc5_.MagicSoul > PlayerManager.Instance.Self.magicSoul)
         {
            return false;
         }
         return this.checkBeforeSkill(_loc5_,param2);
      }
      
      public function checkBeforeSkill(param1:PetSkillTemplateInfo, param2:PetInfo) : Boolean
      {
         var _loc3_:Boolean = false;
         var _loc5_:int = 0;
         var _loc4_:Array = param1.BeforeSkillId.split(",");
         if(_loc4_[0] != -1)
         {
            for each(_loc5_ in param2.skills)
            {
               if(_loc4_.indexOf(String(_loc5_)) != -1)
               {
                  _loc3_ = true;
                  break;
               }
            }
            return _loc3_;
         }
         return Boolean(true);
      }
      
      public function getSkillID(param1:int, param2:int) : int
      {
         var _loc3_:PetSkillInfo = null;
         var _loc4_:PetSkillTemplateInfo = this._defaultSkillList[param1 * 100 + param2];
         if(_loc4_)
         {
            return _loc4_.SkillID;
         }
         return -1;
      }
   }
}
