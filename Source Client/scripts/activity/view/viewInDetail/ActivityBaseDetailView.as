package activity.view.viewInDetail
{
   import activity.ActivityController;
   import activity.data.ActivityConditionInfo;
   import activity.data.ActivityGiftbagInfo;
   import activity.data.ActivityInfo;
   import activity.data.ActivityRewardInfo;
   import activity.view.ActivityCell;
   import com.pickgliss.ui.controls.ScrollPanel;
   import com.pickgliss.ui.controls.container.SimpleTileList;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.PlayerManager;
   import flash.display.Sprite;
   import road7th.data.DictionaryData;
   
   public class ActivityBaseDetailView extends Sprite implements Disposeable
   {
       
      
      protected var _panel:ScrollPanel;
      
      protected var _cellList:SimpleTileList;
      
      protected var _giftBags:DictionaryData;
      
      protected var _conditions:Vector.<ActivityConditionInfo>;
      
      protected var _rewars:DictionaryData;
      
      protected var _cellNumInRow:int = 0;
      
      protected var _info:ActivityInfo;
      
      public function ActivityBaseDetailView()
      {
         super();
         this.initView();
         this.initEvent();
      }
      
      public function get log() : int
      {
         return ActivityController.instance.model.getLog(this.info.ActivityId);
      }
      
      public function get nowState() : int
      {
         if(ActivityController.instance.checkOpenFight(this._info))
         {
            return PlayerManager.Instance.Self.FightPower;
         }
         if(ActivityController.instance.checkOpenLevel(this._info))
         {
            return PlayerManager.Instance.Self.Grade;
         }
         if(ActivityController.instance.checkOpenConsortiaLevel(this._info))
         {
            return PlayerManager.Instance.Self.consortiaInfo.Level;
         }
         return int(ActivityController.instance.model.getState(this.info.ActivityId));
      }
      
      public function get info() : ActivityInfo
      {
         return this._info;
      }
      
      public function setCellFilter(param1:ActivityCell, param2:int) : void
      {
         if(param2 <= ActivityController.instance.model.getLog(this._info.ActivityId))
         {
            param1.canGet = false;
            param1.hasGet = true;
         }
      }
      
      public function get enable() : Boolean
      {
         var _loc1_:String = null;
         if(this.canAcceptByRecieveNum)
         {
            for each(_loc1_ in this.conditions)
            {
               if(this.nowState >= int(_loc1_) && int(_loc1_) > this.log)
               {
                  return true;
               }
            }
         }
         return false;
      }
      
      public function get canAcceptByRecieveNum() : Boolean
      {
         if(this.info.GetWay == 0 || this.info.receiveNum < this.info.GetWay)
         {
            return true;
         }
         return false;
      }
      
      public function get conditions() : Array
      {
         var _loc2_:ActivityConditionInfo = null;
         var _loc1_:Array = new Array();
         for each(_loc2_ in this._conditions)
         {
            if(_loc2_.ConditionIndex == 0)
            {
               _loc1_.push(_loc2_.ConditionValue);
            }
            if(ActivityController.instance.checkTotalMoeny(this._info) && _loc1_.length >= 6)
            {
               break;
            }
         }
         return _loc1_;
      }
      
      public function set info(param1:ActivityInfo) : void
      {
         var _loc3_:ActivityGiftbagInfo = null;
         var _loc4_:Array = null;
         var _loc5_:ActivityConditionInfo = null;
         var _loc6_:DictionaryData = null;
         var _loc7_:ActivityRewardInfo = null;
         this._info = param1;
         this._rewars = new DictionaryData();
         this._giftBags = new DictionaryData();
         this._conditions = new Vector.<ActivityConditionInfo>();
         if(this._cellList)
         {
            this._cellList.disposeAllChildren();
         }
         var _loc2_:Array = ActivityController.instance.getAcitivityGiftBagByActID(this.info.ActivityId);
         for each(_loc3_ in _loc2_)
         {
            if(!this._giftBags[_loc3_.GiftbagOrder])
            {
               this._giftBags[_loc3_.GiftbagOrder] = new DictionaryData();
            }
            this._giftBags[_loc3_.GiftbagOrder].add(_loc3_.GiftbagId,_loc3_);
            _loc4_ = ActivityController.instance.getActivityConditionByGiftbagID(_loc3_.GiftbagId);
            for each(_loc5_ in _loc4_)
            {
               this._conditions.push(_loc5_);
            }
            _loc6_ = ActivityController.instance.getRewardsByGiftbagID(_loc3_.GiftbagId);
            for each(_loc7_ in _loc6_)
            {
               this._rewars.add(_loc7_.TemplateId,_loc7_);
            }
         }
         this.initCells();
      }
      
      protected function initCells() : void
      {
         var _loc1_:ActivityCell = null;
         var _loc2_:int = 0;
         while(_loc2_ < this._rewars.length)
         {
            _loc1_ = new ActivityCell(this._rewars.list[_loc2_]);
            _loc1_.count = this._rewars.list[_loc2_].Count;
            this._cellList.addChild(_loc1_);
            if(_loc2_ >= this.conditions.length)
            {
               this.setCellFilter(_loc1_,this.conditions[0]);
            }
            else
            {
               this.setCellFilter(_loc1_,this.conditions[_loc2_]);
            }
            _loc2_++;
         }
         this._panel.vScrollProxy = this._cellList.numChildren > this._cellNumInRow ? int(0) : int(2);
      }
      
      protected function initView() : void
      {
      }
      
      protected function initEvent() : void
      {
      }
      
      protected function removeEvent() : void
      {
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         if(this._cellList)
         {
            this._cellList.disposeAllChildren();
            ObjectUtils.disposeObject(this._cellList);
            this._cellList = null;
         }
         ObjectUtils.disposeObject(this._panel);
         this._panel = null;
         this._giftBags = null;
      }
   }
}
