package game.actions
{
   import game.model.GameInfo;
   import game.view.map.MapView;
   
   public class MultiShootAction extends BaseAction
   {
       
      
      private var _actionList:Vector.<ShootBombAction>;
      
      private var _map:MapView;
      
      private var _needBombComplete:Boolean;
      
      private var _completeCount:int;
      
      private var _totalCount:int;
      
      private var _gameInfo:GameInfo;
      
      public function MultiShootAction(param1:Vector.<ShootBombAction>, param2:MapView, param3:GameInfo, param4:Boolean = false)
      {
         super();
         this._actionList = param1;
         this._map = param2;
         this._gameInfo = param3;
         this._needBombComplete = param4;
         this._totalCount = this._actionList.length;
      }
      
      override public function prepare() : void
      {
         if(!this._actionList)
         {
            this.finish();
            return;
         }
         var _loc1_:int = 0;
         while(_loc1_ < this._actionList.length)
         {
            this._actionList[_loc1_].completeCall = this.checkComplete;
            this._actionList[_loc1_].prepare();
            _loc1_++;
         }
      }
      
      private function checkComplete() : void
      {
         ++this._completeCount;
      }
      
      override public function execute() : void
      {
         var _loc1_:int = 0;
         if(this.checkFinished())
         {
            if(!this._needBombComplete || this._completeCount == this._totalCount)
            {
               this.finish();
            }
         }
         else
         {
            _loc1_ = 0;
            while(_loc1_ < this._actionList.length)
            {
               this._actionList[_loc1_].execute();
               _loc1_++;
            }
         }
      }
      
      private function checkFinished() : Boolean
      {
         var _loc1_:Boolean = true;
         var _loc2_:int = 0;
         while(_loc2_ < this._actionList.length)
         {
            _loc1_ = _loc1_ && this._actionList[_loc2_].isFinished;
            _loc2_++;
         }
         return _loc1_;
      }
      
      private function finish() : void
      {
         if(this._gameInfo && this._needBombComplete)
         {
            this._gameInfo.bombComplete();
         }
         this._gameInfo = null;
         _isFinished = true;
         if(this._actionList)
         {
            this._actionList.length = 0;
         }
         this._actionList = null;
      }
      
      override public function executeAtOnce() : void
      {
         var _loc1_:int = 0;
         if(this._actionList)
         {
            _loc1_ = 0;
            while(_loc1_ < this._actionList.length)
            {
               this._actionList[_loc1_].executeAtOnce();
               _loc1_++;
            }
         }
         super.executeAtOnce();
      }
   }
}
