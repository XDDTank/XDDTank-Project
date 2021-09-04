package totem
{
   import com.pickgliss.events.UIModuleEvent;
   import com.pickgliss.loader.UIModuleLoader;
   import ddt.data.Experience;
   import ddt.data.UIModuleTypes;
   import ddt.manager.LanguageMgr;
   import ddt.manager.PlayerManager;
   import ddt.view.UIModuleSmallLoading;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import road7th.data.DictionaryData;
   import totem.data.TotemAddInfo;
   import totem.data.TotemDataAnalyz;
   import totem.data.TotemDataVo;
   
   public class TotemManager extends EventDispatcher
   {
      
      private static var _instance:TotemManager;
       
      
      private var _dataList:Object;
      
      private var _dataList2:Object;
      
      private var _func:Function;
      
      private var _funcParams:Array;
      
      public var isUpgrade:Boolean = false;
      
      public var isLast:Boolean = false;
      
      public var isLastFail:Boolean = false;
      
      public function TotemManager(param1:IEventDispatcher = null)
      {
         super(param1);
      }
      
      public static function get instance() : TotemManager
      {
         if(_instance == null)
         {
            _instance = new TotemManager();
         }
         return _instance;
      }
      
      public function loadTotemModule(param1:Function = null, param2:Array = null) : void
      {
         this._func = param1;
         this._funcParams = param2;
         UIModuleSmallLoading.Instance.progress = 0;
         UIModuleSmallLoading.Instance.show();
         UIModuleSmallLoading.Instance.addEventListener(Event.CLOSE,this.__onClose);
         UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.loadCompleteHandler);
         UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.onUimoduleLoadProgress);
         UIModuleLoader.Instance.addUIModuleImp(UIModuleTypes.TOTEM);
      }
      
      private function onUimoduleLoadProgress(param1:UIModuleEvent) : void
      {
         if(param1.module == UIModuleTypes.TOTEM)
         {
            UIModuleSmallLoading.Instance.progress = param1.loader.progress * 100;
         }
      }
      
      private function loadCompleteHandler(param1:UIModuleEvent) : void
      {
         if(param1.module == UIModuleTypes.TOTEM)
         {
            UIModuleSmallLoading.Instance.hide();
            UIModuleSmallLoading.Instance.removeEventListener(Event.CLOSE,this.__onClose);
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.loadCompleteHandler);
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.onUimoduleLoadProgress);
            if(null != this._func)
            {
               this._func.apply(null,this._funcParams);
            }
            this._func = null;
            this._funcParams = null;
         }
      }
      
      private function __onClose(param1:Event) : void
      {
         UIModuleSmallLoading.Instance.hide();
         UIModuleSmallLoading.Instance.removeEventListener(Event.CLOSE,this.__onClose);
         UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.loadCompleteHandler);
         UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.onUimoduleLoadProgress);
      }
      
      public function setup(param1:TotemDataAnalyz) : void
      {
         this._dataList = param1.dataList;
         this._dataList2 = param1.dataList2;
      }
      
      public function getCurInfoByLevel(param1:int) : TotemDataVo
      {
         return this._dataList2[param1];
      }
      
      public function getCurInfoById(param1:int) : TotemDataVo
      {
         if(param1 == 0)
         {
            return new TotemDataVo();
         }
         return this._dataList[param1];
      }
      
      public function getNextInfoByLevel(param1:int) : TotemDataVo
      {
         return this._dataList2[param1 + 1];
      }
      
      public function getNextInfoById(param1:int) : TotemDataVo
      {
         var _loc2_:int = 0;
         if(param1 == 0)
         {
            _loc2_ = 0;
         }
         else
         {
            _loc2_ = this._dataList[param1].Point;
         }
         return this._dataList2[_loc2_ + 1];
      }
      
      public function getAddInfo(param1:int, param2:int = 1) : TotemAddInfo
      {
         var _loc4_:TotemDataVo = null;
         var _loc3_:TotemAddInfo = new TotemAddInfo();
         for each(_loc4_ in this._dataList)
         {
            if(_loc4_.Point <= param1 && _loc4_.Point >= param2)
            {
               _loc3_.Agility += _loc4_.AddAgility;
               _loc3_.Attack += _loc4_.AddAttack;
               _loc3_.Blood += _loc4_.AddBlood;
               _loc3_.Damage += _loc4_.AddDamage;
               _loc3_.Defence += _loc4_.AddDefence;
               _loc3_.Guard += _loc4_.AddGuard;
               _loc3_.Luck += _loc4_.AddLuck;
            }
         }
         return _loc3_;
      }
      
      public function getAddInfoNow(param1:int, param2:int = 0) : TotemAddInfo
      {
         var _loc4_:TotemDataVo = null;
         var _loc3_:TotemAddInfo = new TotemAddInfo();
         var _loc5_:int = Math.ceil((param1 - 10000) / 70);
         var _loc6_:int = 10000 + 70 * (param2 - 1) + 1;
         var _loc7_:int = 10000 + 70 * param2;
         var _loc8_:int = param1 < _loc7_ ? int(param1) : int(_loc7_);
         var _loc9_:int = _loc6_;
         while(_loc9_ <= _loc8_)
         {
            _loc4_ = this._dataList[_loc9_];
            _loc3_.Agility += _loc4_.AddAgility;
            _loc3_.Attack += _loc4_.AddAttack;
            _loc3_.Blood += _loc4_.AddBlood;
            _loc3_.Damage += _loc4_.AddDamage;
            _loc3_.Defence += _loc4_.AddDefence;
            _loc3_.Guard += _loc4_.AddGuard;
            _loc3_.Luck += _loc4_.AddLuck;
            _loc9_++;
         }
         return _loc3_;
      }
      
      public function getCurruntAddInfo(param1:TotemDataVo, param2:int = 0) : TotemAddInfo
      {
         var _loc3_:TotemAddInfo = null;
         if(param1)
         {
            _loc3_ = TotemManager.instance.getAddInfoNow(param1.ID - 1,param2);
         }
         else
         {
            _loc3_ = TotemManager.instance.getAddInfoNow(10350,param2);
         }
         return _loc3_;
      }
      
      public function getTotemPointLevel(param1:int) : int
      {
         if(param1 == 0)
         {
            return 0;
         }
         return this._dataList[param1].Point;
      }
      
      public function get usableGP() : int
      {
         return PlayerManager.Instance.Self.GP - Experience.expericence[PlayerManager.Instance.Self.Grade - 1];
      }
      
      public function getCurrentLv(param1:int) : int
      {
         return int(param1 / 7);
      }
      
      public function getCurrentLvList(param1:int, param2:int, param3:TotemDataVo = null) : Array
      {
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         var _loc10_:int = 0;
         var _loc11_:int = 0;
         var _loc4_:Array = [];
         if(Math.ceil(param1 / 70) == param2 || param1 == 0)
         {
            if(param1 % 7 == 0)
            {
               _loc5_ = param1 / 7;
               _loc6_ = 0;
               while(_loc6_ < 7)
               {
                  _loc4_.push(_loc5_);
                  _loc6_++;
               }
            }
            else
            {
               _loc7_ = param1 % 7;
               _loc8_ = Math.floor(param1 / 7);
               _loc9_ = 0;
               while(_loc9_ < 7)
               {
                  if(_loc9_ < _loc7_)
                  {
                     _loc4_.push(_loc8_ + 1);
                  }
                  else
                  {
                     _loc4_.push(_loc8_);
                  }
                  _loc9_++;
               }
            }
         }
         else
         {
            if(param3 && param3.Location == 1 && param3.Layers == 1)
            {
               _loc10_ = (param2 - 1) * 10;
            }
            else
            {
               _loc10_ = param2 * 10;
            }
            _loc11_ = 0;
            while(_loc11_ < 7)
            {
               _loc4_.push(_loc10_);
               _loc11_++;
            }
         }
         return _loc4_;
      }
      
      public function updatePropertyAddtion(param1:int, param2:DictionaryData) : void
      {
         if(!param2["Attack"])
         {
            return;
         }
         var _loc3_:TotemAddInfo = this.getAddInfo(this.getCurInfoById(param1).Point);
         param2["Attack"]["Totem"] = _loc3_.Attack;
         param2["Defence"]["Totem"] = _loc3_.Defence;
         param2["Agility"]["Totem"] = _loc3_.Agility;
         param2["Luck"]["Totem"] = _loc3_.Luck;
         param2["HP"]["Totem"] = _loc3_.Blood;
         param2["Damage"]["Totem"] = _loc3_.Damage;
         param2["Armor"]["Totem"] = _loc3_.Guard;
      }
      
      public function getSamePageLocationList(param1:int, param2:int) : Array
      {
         var _loc4_:TotemDataVo = null;
         var _loc3_:Array = [];
         for each(_loc4_ in this._dataList)
         {
            if(_loc4_.Page == param1 && _loc4_.Location == param2)
            {
               _loc3_.push(_loc4_);
            }
         }
         _loc3_.sortOn("Layers",Array.NUMERIC);
         return _loc3_;
      }
      
      public function getValueByIndex(param1:int, param2:TotemDataVo) : int
      {
         var _loc3_:int = 0;
         switch(param1)
         {
            case 0:
               _loc3_ = param2.AddAttack;
               break;
            case 1:
               _loc3_ = param2.AddDefence;
               break;
            case 2:
               _loc3_ = param2.AddAgility;
               break;
            case 3:
               _loc3_ = param2.AddLuck;
               break;
            case 4:
               _loc3_ = param2.AddBlood;
               break;
            case 5:
               _loc3_ = param2.AddDamage;
               break;
            case 6:
               _loc3_ = param2.AddGuard;
               break;
            default:
               _loc3_ = 0;
         }
         return _loc3_;
      }
      
      public function getAddValue(param1:int, param2:TotemAddInfo) : int
      {
         var _loc3_:int = 0;
         switch(param1)
         {
            case 1:
               _loc3_ = param2.Attack;
               break;
            case 2:
               _loc3_ = param2.Defence;
               break;
            case 3:
               _loc3_ = param2.Agility;
               break;
            case 4:
               _loc3_ = param2.Luck;
               break;
            case 5:
               _loc3_ = param2.Blood;
               break;
            case 6:
               _loc3_ = param2.Damage;
               break;
            case 7:
               _loc3_ = param2.Guard;
         }
         return _loc3_;
      }
      
      public function getDisplayNum(param1:int) : String
      {
         if(param1 >= 100000000)
         {
            return Math.floor(param1 / 100000000) + LanguageMgr.GetTranslation("yi");
         }
         if(param1 >= 100000)
         {
            return Math.floor(param1 / 10000) + LanguageMgr.GetTranslation("wan");
         }
         return param1.toString();
      }
   }
}
