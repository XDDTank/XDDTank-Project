package activity.view
{
   import activity.ActivityController;
   import activity.ActivityModel;
   import activity.data.ActivityInfo;
   import activity.data.ActivityTypes;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.SoundManager;
   import ddt.manager.TimeManager;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class ActivityMenu extends Sprite implements Disposeable
   {
      
      public static const MENU_REFRESH:String = "activitymenu_refresh";
       
      
      private var _cell:Vector.<ActivityItem>;
      
      private var _model:ActivityModel;
      
      private var _contentHolder:ActivityContentHolder;
      
      private var _selectedItemNew:ActivityItem;
      
      private var _askCellVec:Vector.<ActivityItem>;
      
      public function ActivityMenu()
      {
         this._cell = new Vector.<ActivityItem>();
         super();
         this._model = ActivityController.instance.model;
         this.configUI();
      }
      
      private function cleanCells() : void
      {
         var _loc1_:ActivityItem = this._cell.shift();
         while(_loc1_ != null)
         {
            ObjectUtils.disposeObject(_loc1_);
            _loc1_.removeEventListener(MouseEvent.CLICK,this.__cellClick);
            _loc1_ = this._cell.shift();
         }
      }
      
      public function setActivityDate(param1:Date) : void
      {
         var _loc2_:ActivityItem = null;
         var _loc3_:ActivityInfo = null;
         var _loc4_:ActivityItem = null;
         this.cleanCells();
         this._askCellVec = new Vector.<ActivityItem>();
         for each(_loc3_ in this._model.activityInfoArr)
         {
            if(_loc3_.ActivityType >= 0 && ActivityController.instance.isInValidShowDate(_loc3_))
            {
               if(ActivityController.instance.checkOpenActivity(_loc3_))
               {
                  _loc2_ = new ActivityItemOpen(_loc3_);
               }
               else
               {
                  _loc2_ = new ActivityItem(_loc3_);
               }
               _loc2_.addEventListener(MouseEvent.CLICK,this.__cellClick);
               this._askCellVec.push(_loc2_);
            }
         }
         for each(_loc4_ in this._askCellVec)
         {
            ActivityController.instance.sendAskForActiviLog(_loc4_.info);
         }
      }
      
      public function updateData(param1:ActivityInfo) : void
      {
         var _loc2_:ActivityItem = null;
         var _loc3_:ActivityItem = null;
         var _loc4_:Vector.<ActivityItem> = null;
         var _loc5_:Vector.<ActivityItem> = null;
         var _loc6_:Vector.<ActivityItem> = null;
         var _loc7_:Vector.<ActivityItem> = null;
         var _loc8_:ActivityItem = null;
         var _loc9_:ActivityItem = null;
         var _loc10_:ActivityItem = null;
         var _loc11_:ActivityItem = null;
         var _loc12_:Vector.<ActivityItem> = null;
         if(this._askCellVec)
         {
            for each(_loc2_ in this._askCellVec)
            {
               if(_loc2_.info.ActivityId == param1.ActivityId)
               {
                  this._cell.push(_loc2_);
               }
            }
         }
         else
         {
            for each(_loc3_ in this._cell)
            {
               if(_loc3_.parent)
               {
                  removeChild(_loc3_);
               }
               if(_loc3_.info.ActivityId == param1.ActivityId)
               {
                  _loc3_.info = param1;
               }
            }
         }
         if(!this._askCellVec || this._askCellVec.length == this._cell.length)
         {
            _loc4_ = new Vector.<ActivityItem>();
            _loc5_ = new Vector.<ActivityItem>();
            _loc6_ = new Vector.<ActivityItem>();
            _loc7_ = new Vector.<ActivityItem>();
            this._askCellVec = null;
            if(this._cell.length > 0)
            {
               for each(_loc9_ in this._cell)
               {
                  if(ActivityController.instance.checkOpenActivity(_loc9_.info) && !ActivityController.instance.checkFinish(_loc9_.info))
                  {
                     addChild(_loc9_);
                     _loc5_.push(_loc9_);
                  }
                  if(!_loc8_ && ActivityController.instance.model.showID != "" && ActivityController.instance.model.showID == _loc9_.info.ActivityId)
                  {
                     _loc8_ = _loc9_;
                  }
               }
               for each(_loc10_ in this._cell)
               {
                  if(!ActivityController.instance.checkOpenActivity(_loc10_.info) && !ActivityController.instance.checkFirstCharge(_loc10_.info) && !ActivityController.instance.checkMouthActivity(_loc10_.info) && !ActivityController.instance.checkFinish(_loc10_.info))
                  {
                     addChild(_loc10_);
                     _loc6_.push(_loc10_);
                  }
                  if(!_loc8_ && ActivityController.instance.model.showID != "" && ActivityController.instance.model.showID == _loc10_.info.ActivityId)
                  {
                     _loc8_ = _loc10_;
                  }
               }
               if(_loc6_.length > 2)
               {
                  _loc6_.sort(this.compareFunction);
               }
               for each(_loc11_ in this._cell)
               {
                  if(ActivityController.instance.checkMouthActivity(_loc11_.info) && ActivityController.instance.checkShowCondition(_loc11_.info) && !ActivityController.instance.checkFinish(_loc11_.info))
                  {
                     addChild(_loc11_);
                     _loc7_.push(_loc11_);
                  }
                  if(!_loc8_ && ActivityController.instance.model.showID != "" && ActivityController.instance.model.showID == _loc11_.info.ActivityId)
                  {
                     _loc8_ = _loc11_;
                  }
               }
               _loc12_ = _loc5_.concat(_loc6_);
               _loc4_ = _loc12_.concat(_loc7_);
               this._cell = _loc4_;
               if(this._cell.length > 0)
               {
                  if(this._selectedItemNew && param1.ActivityId == this._selectedItemNew.info.ActivityId && !ActivityController.instance.checkFinish(param1))
                  {
                     this.setSelectedItemNew(this._selectedItemNew);
                  }
                  else
                  {
                     if(!_loc8_)
                     {
                        _loc8_ = this._cell[0];
                     }
                     this.setSelectedItemNew(_loc8_);
                     ActivityController.instance.setData(_loc8_.info);
                  }
                  this._contentHolder.visible = true;
               }
               else
               {
                  ActivityController.instance.setData(null);
                  this._contentHolder.visible = false;
               }
            }
            else
            {
               this._contentHolder.visible = false;
            }
         }
      }
      
      private function compareFunction(param1:ActivityItem, param2:ActivityItem) : Number
      {
         if(this.getLevel(param1.info) < this.getLevel(param2.info))
         {
            return -1;
         }
         if(this.getLevel(param1.info) == this.getLevel(param2.info))
         {
            return 0;
         }
         return 1;
      }
      
      private function getLevel(param1:ActivityInfo) : int
      {
         var _loc2_:int = 0;
         switch(param1.ActivityType)
         {
            case ActivityTypes.CHARGE:
               _loc2_ = 1;
               break;
            case ActivityTypes.COST:
               _loc2_ = 2;
               break;
            case ActivityTypes.MARRIED:
               _loc2_ = 3;
               break;
            case ActivityTypes.BEAD:
            case ActivityTypes.PET:
               _loc2_ = 4;
               break;
            case ActivityTypes.RELEASE:
               _loc2_ = 5;
               break;
            case ActivityTypes.CONVERT:
               _loc2_ = 6;
               break;
            default:
               _loc2_ = 7;
         }
         return _loc2_;
      }
      
      private function isBeforeToday(param1:Date) : Boolean
      {
         var _loc2_:Date = new Date(param1.fullYear,param1.month,param1.date);
         return _loc2_ <= TimeManager.Instance.Now();
      }
      
      private function isAfterToday(param1:Date) : Boolean
      {
         var _loc2_:Date = new Date(param1.fullYear,param1.month,param1.date);
         return _loc2_ > TimeManager.Instance.Now();
      }
      
      private function configUI() : void
      {
         this._contentHolder = ComponentFactory.Instance.creatCustomObject("ddtcalendar.ActivityContentHolder");
      }
      
      public function setSelectedItemNew(param1:ActivityItem) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         if(param1 != this._selectedItemNew)
         {
            if(this._selectedItemNew)
            {
               this._selectedItemNew.selected = false;
            }
            this._selectedItemNew = param1;
            this._selectedItemNew.selected = true;
            addChildAt(this._contentHolder,0);
            _loc2_ = this._cell.indexOf(this._selectedItemNew);
            _loc3_ = this._cell.length;
            _loc4_ = 0;
            while(_loc4_ < _loc3_)
            {
               if(_loc4_ <= _loc2_)
               {
                  this._cell[_loc4_].y = _loc4_ * 55;
               }
               else
               {
                  this._cell[_loc4_].y = _loc4_ * 55 + this._contentHolder.height - 53;
               }
               _loc4_++;
            }
            this._contentHolder.y = this._selectedItemNew.y + 35;
            dispatchEvent(new Event(MENU_REFRESH));
         }
      }
      
      private function __cellClick(param1:MouseEvent) : void
      {
         var _loc2_:ActivityItem = param1.currentTarget as ActivityItem;
         this.setSelectedItemNew(_loc2_);
         ActivityController.instance.setData(_loc2_.info);
         SoundManager.instance.play("008");
      }
      
      override public function get height() : Number
      {
         var _loc1_:int = 0;
         if(this._cell.length == 1)
         {
            _loc1_ = this._contentHolder.y + this._contentHolder.height;
         }
         else if(this._cell.length > 0)
         {
            _loc1_ = 55 * this._cell.length + this._contentHolder.height - 53;
         }
         return _loc1_;
      }
      
      public function dispose() : void
      {
         var _loc1_:ActivityItem = this._cell.shift();
         while(_loc1_ != null)
         {
            ObjectUtils.disposeObject(_loc1_);
            _loc1_.removeEventListener(MouseEvent.CLICK,this.__cellClick);
            _loc1_ = this._cell.shift();
         }
         ObjectUtils.disposeObject(this._contentHolder);
         this._contentHolder = null;
         if(parent)
         {
            parent.removeChild(this);
         }
      }
   }
}
