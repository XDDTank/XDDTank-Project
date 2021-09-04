package liveness
{
   import ddt.data.analyze.DaylyGiveAnalyzer;
   import flash.events.EventDispatcher;
   
   public class LivenessAwardManager extends EventDispatcher
   {
      
      private static var _instance:LivenessAwardManager;
       
      
      private var _today:Date;
      
      private var _model:LivenessModel;
      
      private var _todayIndex:uint;
      
      private var _signAwards:Array;
      
      private var _currentSingleDungeonId:int;
      
      public function LivenessAwardManager()
      {
         super();
         this._model = new LivenessModel();
      }
      
      public static function get Instance() : LivenessAwardManager
      {
         if(!_instance)
         {
            _instance = new LivenessAwardManager();
         }
         return _instance;
      }
      
      private function changeToBoolean(param1:Array) : void
      {
         var _loc2_:uint = 0;
         while(_loc2_ < param1.length)
         {
            param1[_loc2_] = param1[_loc2_] != "0";
            _loc2_++;
         }
      }
      
      public function signToday() : void
      {
         this._model.statusList[this._todayIndex - 1] = LivenessModel.NOT_GET_AWARD;
         this.checkBigStar();
      }
      
      public function checkBigStar() : Boolean
      {
         var _loc1_:Boolean = true;
         var _loc2_:uint = 0;
         while(_loc2_ < this._model.statusList.length - 1)
         {
            if(this._model.statusList[_loc2_] == LivenessModel.DAY_PASS || this._model.statusList[_loc2_] == LivenessModel.NOT_THE_TIME)
            {
               _loc1_ = false;
            }
            _loc2_++;
         }
         return _loc1_;
      }
      
      public function getRewardByIndex(param1:uint) : void
      {
         this._model.statusList[param1] = LivenessModel.HAS_GET_AWARD;
      }
      
      public function setDailyInfo(param1:DaylyGiveAnalyzer) : void
      {
         this._signAwards = param1.signAwardList;
      }
      
      public function get model() : LivenessModel
      {
         return this._model;
      }
      
      public function get todayIndex() : uint
      {
         return this._todayIndex;
      }
      
      public function get currentSingleDungeonId() : int
      {
         return this._currentSingleDungeonId;
      }
      
      public function set currentSingleDungeonId(param1:int) : void
      {
         this._currentSingleDungeonId = param1;
      }
   }
}
