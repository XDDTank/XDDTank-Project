package SingleDungeon.hardMode
{
   import SingleDungeon.SingleDungeonManager;
   import SingleDungeon.expedition.ExpeditionController;
   import SingleDungeon.expedition.ExpeditionHistory;
   import SingleDungeon.expedition.ExpeditionInfo;
   import SingleDungeon.model.MapSceneModel;
   import ddt.manager.PlayerManager;
   import ddt.manager.ServerConfigManager;
   import flash.events.EventDispatcher;
   import flash.utils.ByteArray;
   
   public class HardModeManager extends EventDispatcher
   {
      
      private static var _instance:HardModeManager;
       
      
      private var _hardModeSceneList:Vector.<int>;
      
      private var _hardModeChooseSceneList:Vector.<int>;
      
      public var baseNum:int = 101;
      
      public var enterDgCountArr:ByteArray;
      
      public function HardModeManager()
      {
         this._hardModeSceneList = new Vector.<int>();
         this._hardModeChooseSceneList = new Vector.<int>();
         super();
      }
      
      public static function get instance() : HardModeManager
      {
         if(!_instance)
         {
            _instance = new HardModeManager();
         }
         return _instance;
      }
      
      public function setup() : void
      {
      }
      
      public function getRemainFightCount(param1:int) : int
      {
         return ServerConfigManager.instance.getHardModeEnterLimit() - this.getEnterDgCount(param1);
      }
      
      public function getAllowEnter(param1:int) : Boolean
      {
         return this.getRemainFightCount(param1) > 0;
      }
      
      public function checkEnter(param1:int) : Boolean
      {
         return this.getEnterDgCount(param1) > 0;
      }
      
      public function getEnterDgCount(param1:int) : int
      {
         var _loc2_:int = param1 - this.baseNum;
         if(this.enterDgCountArr[_loc2_])
         {
            return this.enterDgCountArr[_loc2_];
         }
         return 0;
      }
      
      public function getCanExpeditionDungeon() : Vector.<MapSceneModel>
      {
         var _loc3_:MapSceneModel = null;
         var _loc1_:Vector.<MapSceneModel> = new Vector.<MapSceneModel>();
         var _loc2_:Vector.<MapSceneModel> = SingleDungeonManager.Instance.mapHardSceneList;
         for each(_loc3_ in _loc2_)
         {
            if(ExpeditionHistory.instance.get(_loc3_.MissionID) && this.getAllowEnter(_loc3_.ID))
            {
               _loc1_.push(_loc3_);
            }
         }
         _loc1_.sort(this.sortDungeonById);
         return _loc1_;
      }
      
      private function sortDungeonById(param1:MapSceneModel, param2:MapSceneModel) : int
      {
         if(param1.ID > param2.ID)
         {
            return -1;
         }
         return 1;
      }
      
      public function getNeedFatigue() : int
      {
         var _loc2_:int = 0;
         var _loc3_:ExpeditionInfo = null;
         var _loc1_:int = 0;
         for each(_loc2_ in this._hardModeSceneList)
         {
            _loc3_ = ExpeditionController.instance.model.expeditionInfoDic[_loc2_];
            _loc1_ += _loc3_.ExpeditionEnergy;
         }
         return _loc1_;
      }
      
      public function getNeedTime() : int
      {
         var _loc2_:int = 0;
         var _loc3_:ExpeditionInfo = null;
         var _loc1_:int = 0;
         for each(_loc2_ in this._hardModeSceneList)
         {
            _loc3_ = ExpeditionController.instance.model.expeditionInfoDic[_loc2_];
            _loc1_ += _loc3_.ExpeditionTime * 60 * 1000;
         }
         return _loc1_;
      }
      
      public function getNeedMoney() : int
      {
         var _loc3_:ExpeditionInfo = null;
         var _loc1_:int = 0;
         var _loc2_:uint = PlayerManager.Instance.Self.expeditionNumCur - 1;
         while(_loc2_ < this._hardModeSceneList.length)
         {
            _loc3_ = ExpeditionController.instance.model.expeditionInfoDic[this._hardModeSceneList[_loc2_]];
            _loc1_ += _loc3_.AccelerateMoney;
            _loc2_++;
         }
         return _loc1_;
      }
      
      public function getChooseNeedFatigue() : int
      {
         var _loc2_:int = 0;
         var _loc3_:ExpeditionInfo = null;
         var _loc1_:int = 0;
         for each(_loc2_ in this._hardModeChooseSceneList)
         {
            _loc3_ = ExpeditionController.instance.model.expeditionInfoDic[_loc2_];
            _loc1_ += _loc3_.ExpeditionEnergy;
         }
         return _loc1_;
      }
      
      public function getChooseNeedTime() : int
      {
         var _loc2_:int = 0;
         var _loc3_:ExpeditionInfo = null;
         var _loc1_:int = 0;
         for each(_loc2_ in this._hardModeChooseSceneList)
         {
            _loc3_ = ExpeditionController.instance.model.expeditionInfoDic[_loc2_];
            _loc1_ += _loc3_.ExpeditionTime * 60 * 1000;
         }
         return _loc1_;
      }
      
      public function getChooseNeedMoney() : int
      {
         var _loc2_:int = 0;
         var _loc3_:ExpeditionInfo = null;
         var _loc1_:int = 0;
         for each(_loc2_ in this._hardModeChooseSceneList)
         {
            _loc3_ = ExpeditionController.instance.model.expeditionInfoDic[_loc2_];
            _loc1_ += _loc3_.AccelerateMoney;
         }
         return _loc1_;
      }
      
      public function get hardModeSceneList() : Vector.<int>
      {
         return this._hardModeSceneList;
      }
      
      public function set hardModeSceneList(param1:Vector.<int>) : void
      {
         this._hardModeSceneList = param1;
      }
      
      public function get hardModeChooseSceneList() : Vector.<int>
      {
         return this._hardModeChooseSceneList;
      }
      
      public function set hardModeChooseSceneList(param1:Vector.<int>) : void
      {
         this._hardModeChooseSceneList = param1;
      }
      
      public function resetChooseSceneList() : void
      {
         this._hardModeChooseSceneList = new Vector.<int>();
      }
      
      public function resetHardModeSceneList() : void
      {
         this._hardModeSceneList = new Vector.<int>();
      }
   }
}
