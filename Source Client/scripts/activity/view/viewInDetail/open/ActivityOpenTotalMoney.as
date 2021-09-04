package activity.view.viewInDetail.open
{
   import activity.ActivityController;
   import activity.ActivityEvent;
   import activity.data.ActivityGiftbagInfo;
   import activity.data.ActivityInfo;
   import activity.view.ActivityCell;
   import activity.view.viewInDetail.ActivityBaseDetailView;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.SelectedButtonGroup;
   import com.pickgliss.ui.controls.SelectedTextButton;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.utils.PositionUtils;
   import flash.display.Bitmap;
   import flash.display.Shape;
   import flash.events.Event;
   import flash.geom.Point;
   
   public class ActivityOpenTotalMoney extends ActivityBaseDetailView
   {
      
      public static const SHOW_NUM:int = 6;
       
      
      private var _processMask:Shape;
      
      private var _processBit:Bitmap;
      
      private var _point:Bitmap;
      
      private var _pointPos:Point;
      
      private var _btnGroup:SelectedButtonGroup;
      
      private var _currentIndex:int = 0;
      
      public function ActivityOpenTotalMoney()
      {
         super();
      }
      
      public function update() : void
      {
         this.info = info;
      }
      
      override public function set info(param1:ActivityInfo) : void
      {
         super.info = param1;
         this.initBtnText();
         this.setData();
      }
      
      override public function get enable() : Boolean
      {
         if(canAcceptByRecieveNum)
         {
            if(conditions[this._currentIndex] > log && nowState >= conditions[this._currentIndex])
            {
               return true;
            }
         }
         return false;
      }
      
      private function initBtnText() : void
      {
         var _loc1_:SelectedTextButton = null;
         var _loc2_:int = 0;
         while(_loc2_ < this._btnGroup.itemCount)
         {
            _loc1_ = this._btnGroup.getItemByIndex(_loc2_) as SelectedTextButton;
            if(conditions[_loc2_])
            {
               _loc1_.text = conditions[_loc2_];
            }
            _loc2_++;
         }
      }
      
      override protected function initCells() : void
      {
         var _loc1_:ActivityCell = null;
         var _loc2_:ActivityGiftbagInfo = null;
         var _loc3_:int = 0;
         for each(_loc2_ in _giftBags[this._currentIndex])
         {
            _rewars = ActivityController.instance.getRewardsByGiftbagID(_loc2_.GiftbagId);
            _loc3_ = 0;
            while(_loc3_ < _rewars.length)
            {
               _loc1_ = new ActivityCell(_rewars.list[_loc3_]);
               _loc1_.count = _rewars.list[_loc3_].Count;
               _cellList.addChild(_loc1_);
               setCellFilter(_loc1_,conditions[this._currentIndex]);
               _loc3_++;
            }
         }
         _panel.vScrollProxy = _cellList.numChildren > _cellNumInRow ? int(0) : int(2);
      }
      
      private function setData() : void
      {
         var _loc7_:Point = null;
         var _loc1_:int = int(ActivityController.instance.model.getState(info.ActivityId));
         var _loc2_:int = 0;
         var _loc3_:Number = 0;
         var _loc4_:int = 0;
         while(_loc4_ <= conditions.length)
         {
            if(_loc4_ == 0)
            {
               if(_loc1_ < int(conditions[_loc4_]))
               {
                  _loc2_ = _loc4_;
                  _loc3_ = _loc1_ / int(conditions[_loc4_]);
                  break;
               }
            }
            else if(_loc4_ < conditions.length)
            {
               if(int(conditions[_loc4_ - 1]) <= _loc1_ && _loc1_ < int(conditions[_loc4_]))
               {
                  _loc2_ = _loc4_;
                  _loc3_ = (_loc1_ - int(conditions[_loc4_ - 1])) / (int(conditions[_loc4_]) - int(conditions[_loc4_ - 1]));
                  break;
               }
            }
            else
            {
               _loc2_ = _loc4_;
            }
            _loc4_++;
         }
         var _loc5_:Point = new Point();
         var _loc6_:Point = ComponentFactory.Instance.creatCustomObject("ddtactivity.ActivityOpenTotalMoney.pointPos" + _loc2_);
         if(_loc2_ < conditions.length)
         {
            _loc7_ = ComponentFactory.Instance.creatCustomObject("ddtactivity.ActivityOpenTotalMoney.pointPos" + (_loc2_ + 1));
         }
         else
         {
            _loc7_ = _loc6_;
         }
         _loc5_.y = _loc6_.y;
         _loc5_.x = _loc6_.x + (_loc7_.x - _loc6_.x) * _loc3_;
         this._processMask.graphics.beginFill(16711680,1);
         this._processMask.graphics.drawRect(this._processBit.x,this._processBit.y,_loc5_.x - this._processMask.x,this._processBit.height);
         this._processMask.graphics.endFill();
         this._btnGroup.selectIndex = _loc2_ - 1;
         _loc5_.x -= this._point.width / 2;
         _loc5_.x += this._pointPos.x;
         _loc5_.y += this._pointPos.y;
         PositionUtils.setPos(this._point,_loc5_);
      }
      
      override protected function initView() : void
      {
         var _loc2_:SelectedTextButton = null;
         _cellNumInRow = 6;
         this._processBit = ComponentFactory.Instance.creatBitmap("ddtactivity.activitystate.open.moneyProcessBit");
         addChild(this._processBit);
         this._processMask = new Shape();
         this._processMask.graphics.beginFill(16711680,1);
         this._processMask.graphics.drawRect(this._processBit.x,this._processBit.y,0,this._processBit.height);
         this._processMask.graphics.endFill();
         addChild(this._processMask);
         this._processBit.mask = this._processMask;
         this._point = ComponentFactory.Instance.creatBitmap("ddtactivity.activitystate.open.moneyProcessPoint");
         this._pointPos = ComponentFactory.Instance.creatCustomObject("ddtactivity.ActivityOpenTotalMoney.point");
         this._btnGroup = new SelectedButtonGroup();
         var _loc1_:int = 0;
         while(_loc1_ < SHOW_NUM)
         {
            _loc2_ = ComponentFactory.Instance.creatComponentByStylename("ddtactivity.activitystate.open.ActivityOpenTotalMoney.btn" + (_loc1_ + 1));
            addChild(_loc2_);
            this._btnGroup.addSelectItem(_loc2_);
            _loc1_++;
         }
         this._btnGroup.selectIndex = 0;
         this._btnGroup.addEventListener(Event.CHANGE,this.__selectedChange);
         _cellList = ComponentFactory.Instance.creatCustomObject("ddtactivity.ActivityOpenTotalMoney.cellList",[_cellNumInRow]);
         addChild(_cellList);
         _panel = ComponentFactory.Instance.creatComponentByStylename("ddtactivity.ActivityOpenTotalMoney.cellPanel");
         addChild(_panel);
         _panel.setView(_cellList);
         super.initView();
      }
      
      private function __selectedChange(param1:Event) : void
      {
         this._currentIndex = this._btnGroup.selectIndex;
         _cellList.disposeAllChildren();
         this.initCells();
         ActivityController.instance.model.dispatchEvent(new ActivityEvent(ActivityEvent.BUTTON_CHANGE));
      }
      
      override public function dispose() : void
      {
         this._btnGroup.removeEventListener(Event.CHANGE,this.__selectedChange);
         ObjectUtils.disposeObject(this._processBit);
         this._processBit = null;
         ObjectUtils.disposeObject(this._processMask);
         this._processMask = null;
         ObjectUtils.disposeObject(this._point);
         this._point = null;
         ObjectUtils.disposeObject(this._pointPos);
         this._pointPos = null;
         ObjectUtils.disposeObject(this._btnGroup);
         this._btnGroup = null;
         super.dispose();
      }
   }
}
