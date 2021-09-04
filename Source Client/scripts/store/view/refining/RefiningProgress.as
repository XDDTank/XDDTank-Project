package store.view.refining
{
   import ddt.data.goods.InventoryItemInfo;
   import flash.events.Event;
   import flash.utils.Dictionary;
   import store.StoreController;
   import store.view.strength.StoreStrengthProgress;
   
   public class RefiningProgress extends StoreStrengthProgress
   {
       
      
      private var _infoID:int;
      
      public function RefiningProgress()
      {
         super();
      }
      
      public function get infoID() : int
      {
         return this._infoID;
      }
      
      override public function initProgress(param1:InventoryItemInfo) : void
      {
         var _loc2_:Number = NaN;
         var _loc3_:int = 0;
         this._infoID = param1.ItemID;
         _currentFrame = 0;
         _strengthenExp = param1.StrengthenExp;
         _strengthenLevel = param1.StrengthenLevel;
         if(StoreController.instance.Model.getRefiningConfigByLevel(_strengthenLevel + 1))
         {
            _max = StoreController.instance.Model.getRefiningConfigByLevel(_strengthenLevel + 1).Exp;
         }
         else
         {
            _max = 0;
         }
         if(_max > 0 && _strengthenExp < _max)
         {
            _loc2_ = _strengthenExp / _max;
            _loc3_ = Math.floor(_loc2_ * _total);
            if(_loc3_ < 1 && _loc2_ > 0)
            {
               _loc3_ = 1;
            }
            _currentFrame = _loc3_;
         }
         setMask(_currentFrame);
         this.setExpPercent(param1);
         _taskFrames = new Dictionary();
         if(this.hasEventListener(Event.ENTER_FRAME))
         {
            this.removeEventListener(Event.ENTER_FRAME,__startFrame);
         }
         setStarVisible(false);
      }
      
      override public function setProgress(param1:InventoryItemInfo) : void
      {
         this._infoID = param1.ItemID;
         if(_strengthenLevel != param1.StrengthenLevel)
         {
            _taskFrames[0] = _total;
            _strengthenLevel = param1.StrengthenLevel;
         }
         _strengthenExp = param1.StrengthenExp;
         if(StoreController.instance.Model.getRefiningConfigByLevel(_strengthenLevel + 1))
         {
            _max = StoreController.instance.Model.getRefiningConfigByLevel(_strengthenLevel + 1).Exp;
         }
         else
         {
            _max = 0;
         }
         var _loc2_:Number = _strengthenExp / _max;
         var _loc3_:int = Math.floor(_loc2_ * _total);
         if(_loc3_ < 1 && _loc2_ > 0)
         {
            _loc3_ = 1;
         }
         if(_currentFrame == _loc3_)
         {
            if(_taskFrames[0] && int(_taskFrames[0]) != 0)
            {
               setStarVisible(true);
               _taskFrames[1] = _loc3_;
               startProgress();
            }
         }
         else
         {
            setStarVisible(true);
            _taskFrames[1] = _loc3_;
            startProgress();
         }
         this.setExpPercent(param1);
      }
      
      override public function setExpPercent(param1:InventoryItemInfo = null) : void
      {
         var _loc2_:Number = NaN;
         this._infoID = param1.ItemID;
         if(_strengthenExp == 0)
         {
            _progressLabel.text = "0%";
         }
         else
         {
            _loc2_ = Math.floor(_strengthenExp / _max * 10000) / 100;
            if(isNaN(_loc2_) || _max == 0)
            {
               _loc2_ = 0;
            }
            _progressLabel.text = _loc2_ + "%";
         }
         if(param1 && !StoreController.instance.Model.getRefiningConfigByLevel(_strengthenLevel))
         {
            tipData = "0/0";
         }
         else
         {
            if(isNaN(_strengthenExp) || _max == 0)
            {
               _strengthenExp = 0;
            }
            if(isNaN(_max))
            {
               _max = 0;
            }
            tipData = _strengthenExp + "/" + _max;
         }
      }
      
      override public function resetProgress() : void
      {
         this._infoID = 0;
         super.resetProgress();
      }
   }
}
