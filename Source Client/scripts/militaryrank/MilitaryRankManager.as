package militaryrank
{
   import com.pickgliss.events.UIModuleEvent;
   import com.pickgliss.loader.UIModuleLoader;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import ddt.data.UIModuleTypes;
   import ddt.manager.PlayerManager;
   import ddt.manager.ServerConfigManager;
   import ddt.view.UIModuleSmallLoading;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import militaryrank.model.MilitaryLevelModel;
   import militaryrank.view.MilitaryFrameView;
   import road7th.comm.PackageIn;
   import road7th.data.DictionaryData;
   
   public class MilitaryRankManager extends EventDispatcher
   {
      
      public static const GET_RECORD:String = "getRecord";
      
      private static var _instance:MilitaryRankManager;
       
      
      private var _func:Function;
      
      private var _funcParams:Array;
      
      private var _loadComplete:Boolean = false;
      
      private var _rankDataDic:DictionaryData;
      
      private var _rankShopRecord:DictionaryData;
      
      public function MilitaryRankManager()
      {
         super();
         this._rankDataDic = new DictionaryData();
         this._rankShopRecord = new DictionaryData();
         this.initRankData();
      }
      
      public static function get Instance() : MilitaryRankManager
      {
         if(_instance == null)
         {
            _instance = new MilitaryRankManager();
         }
         return _instance;
      }
      
      public function get loadComplete() : Boolean
      {
         return this._loadComplete;
      }
      
      public function setRankShopRecord(param1:PackageIn) : void
      {
         var _loc2_:int = param1.readInt();
         this._rankShopRecord = new DictionaryData();
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_)
         {
            this._rankShopRecord[param1.readInt()] = param1.readInt();
            _loc3_++;
         }
         dispatchEvent(new Event(GET_RECORD));
      }
      
      public function getRankShopRecordByID(param1:int) : int
      {
         return this._rankShopRecord[param1];
      }
      
      public function getRankShopItemCount(param1:int) : int
      {
         var _loc2_:MilitaryLevelModel = MilitaryRankManager.Instance.getMilitaryRankInfo(PlayerManager.Instance.Self.MilitaryRankTotalScores);
         var _loc3_:int = ServerConfigManager.instance.getRankShopLimitByIDandLevel(param1,_loc2_.CurrKey);
         var _loc4_:int = this.getRankShopRecordByID(param1);
         return _loc3_ - _loc4_;
      }
      
      public function show() : void
      {
         if(this.loadComplete)
         {
            this.showMilitaryFrame();
         }
         else
         {
            this.loadModule(this.show);
         }
      }
      
      private function showMilitaryFrame() : void
      {
         var _loc1_:MilitaryFrameView = ComponentFactory.Instance.creatComponentByStylename("militaryrank.MilitaryFrame");
         LayerManager.Instance.addToLayer(_loc1_,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.ALPHA_BLOCKGOUND);
      }
      
      public function loadModule(param1:Function = null, param2:Array = null) : void
      {
         this._func = param1;
         this._funcParams = param2;
         if(this.loadComplete)
         {
            if(null != this._func)
            {
               this._func.apply(null,this._funcParams);
            }
            this._func = null;
            this._funcParams = null;
         }
         else
         {
            UIModuleSmallLoading.Instance.progress = 0;
            UIModuleSmallLoading.Instance.show();
            UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.loadCompleteHandler);
            UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.onUimoduleLoadProgress);
            UIModuleLoader.Instance.addUIModuleImp(UIModuleTypes.MILITARY_RANK);
         }
      }
      
      private function onUimoduleLoadProgress(param1:UIModuleEvent) : void
      {
         if(param1.module == UIModuleTypes.MILITARY_RANK)
         {
            UIModuleSmallLoading.Instance.progress = param1.loader.progress * 100;
         }
      }
      
      private function loadCompleteHandler(param1:UIModuleEvent) : void
      {
         if(param1.module == UIModuleTypes.MILITARY_RANK)
         {
            this._loadComplete = true;
            UIModuleSmallLoading.Instance.hide();
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
      
      private function initRankData() : void
      {
         var _loc5_:MilitaryLevelModel = null;
         var _loc1_:Array = ServerConfigManager.instance.getMilitaryData();
         var _loc2_:Array = ServerConfigManager.instance.getMilitaryName();
         var _loc3_:int = 0;
         while(_loc3_ < _loc1_.length - 1)
         {
            _loc5_ = new MilitaryLevelModel();
            _loc5_.MinScore = int(_loc1_[_loc3_]);
            _loc5_.MaxScore = int(_loc1_[_loc3_ + 1]);
            _loc5_.Name = _loc2_[_loc3_];
            _loc5_.CurrKey = _loc3_;
            this._rankDataDic.add(_loc3_,_loc5_);
            _loc3_++;
         }
         var _loc4_:MilitaryLevelModel = new MilitaryLevelModel();
         _loc4_.MinScore = int(_loc1_[_loc1_.length - 1]);
         _loc4_.MaxScore = int.MAX_VALUE;
         _loc4_.Name = _loc2_[_loc1_.length - 1];
         _loc4_.CurrKey = _loc1_.length - 1;
         this._rankDataDic.add(_loc1_.length - 1,_loc4_);
      }
      
      public function getMilitaryRankInfo(param1:int) : MilitaryLevelModel
      {
         var _loc2_:MilitaryLevelModel = null;
         var _loc3_:MilitaryLevelModel = null;
         for each(_loc3_ in this._rankDataDic)
         {
            if(_loc3_.isThisLevel(param1))
            {
               _loc2_ = _loc3_;
               break;
            }
         }
         return _loc2_;
      }
      
      public function getMilitaryFrameNum(param1:int) : int
      {
         var _loc2_:int = 0;
         var _loc3_:MilitaryLevelModel = null;
         for each(_loc3_ in this._rankDataDic)
         {
            if(_loc3_.isThisLevel(param1))
            {
               _loc2_ = _loc3_.CurrKey + 1;
               break;
            }
         }
         return _loc2_;
      }
      
      public function getMilitaryInfoByLevel(param1:int) : MilitaryLevelModel
      {
         return this._rankDataDic[param1];
      }
      
      public function getOtherMilitaryName(param1:int) : Array
      {
         var _loc2_:Array = [];
         switch(param1)
         {
            case 1:
               _loc2_.push(ServerConfigManager.instance.getMilitaryName()[15]);
               _loc2_.push(16);
               break;
            case 2:
               _loc2_.push(ServerConfigManager.instance.getMilitaryName()[14]);
               _loc2_.push(15);
               break;
            case 3:
               _loc2_.push(ServerConfigManager.instance.getMilitaryName()[13]);
               _loc2_.push(14);
         }
         return _loc2_;
      }
   }
}
