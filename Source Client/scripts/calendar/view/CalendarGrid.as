package calendar.view
{
   import calendar.CalendarEvent;
   import calendar.CalendarModel;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import ddt.manager.SoundManager;
   import flash.display.DisplayObject;
   import flash.display.Shape;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import vip.VipController;
   
   public class CalendarGrid extends Sprite implements Disposeable
   {
       
      
      private var _dayCells:Vector.<DayCell>;
      
      private var _model:CalendarModel;
      
      private var _monthField:FilterFrameText;
      
      private var _enMonthField:FilterFrameText;
      
      private var _dateField:FilterFrameText;
      
      private var _todyField:FilterFrameText;
      
      private var _back:DisplayObject;
      
      private var _front:DisplayObject;
      
      private var _backGrid:Shape;
      
      private var _title:DisplayObject;
      
      private var _vipBtn:BaseButton;
      
      public function CalendarGrid(param1:CalendarModel)
      {
         this._dayCells = new Vector.<DayCell>();
         super();
         this._model = param1;
         this.configUI();
         this.addEvent();
      }
      
      private function configUI() : void
      {
         var _loc4_:int = 0;
         var _loc6_:Date = null;
         var _loc7_:DayCell = null;
         this._back = ComponentFactory.Instance.creatCustomObject("ddtcalendar.CalendarBackBg");
         addChild(this._back);
         this._front = ComponentFactory.Instance.creatCustomObject("ddtcalendar.CalendarFrontBg");
         addChild(this._front);
         this._title = ComponentFactory.Instance.creatBitmap("asset.ddtcalendar.CalendarGridTitleBg");
         addChild(this._title);
         var _loc1_:Date = this._model.today;
         this._monthField = ComponentFactory.Instance.creatComponentByStylename("ddtcalendar.CalendarGrid.NumMonthField");
         this._monthField.text = String(_loc1_.month + 1);
         addChild(this._monthField);
         this._enMonthField = ComponentFactory.Instance.creatComponentByStylename("ddtcalendar.CalendarGrid.EnMonthField");
         this._enMonthField.text = LanguageMgr.GetTranslation("tank.calendar.grid.month" + _loc1_.month);
         this._enMonthField.x = this._monthField.x + this._monthField.width;
         addChild(this._enMonthField);
         this._todyField = ComponentFactory.Instance.creatComponentByStylename("ddtcalendar.CalendarGrid.TodayField");
         this._todyField.text = LanguageMgr.GetTranslation("tank.calendar.grid.today",_loc1_.fullYear,_loc1_.month + 1,_loc1_.date);
         this._todyField.text += LanguageMgr.GetTranslation("tank.calendar.grid.week" + _loc1_.day);
         addChild(this._todyField);
         this._vipBtn = ComponentFactory.Instance.creatComponentByStylename("vipView.OpenBtn");
         var _loc2_:Point = ComponentFactory.Instance.creatCustomObject("ddtcalendar.CalendarGrid.TopLeft");
         var _loc3_:Date = new Date();
         _loc3_.time = _loc1_.time;
         _loc3_.setDate(1);
         if(_loc3_.day != 0)
         {
            if(_loc3_.month > 0)
            {
               _loc3_.setMonth(_loc1_.month - 1,CalendarModel.getMonthMaxDay(_loc1_.month - 1,_loc1_.fullYear) - _loc3_.day + 1);
            }
            else
            {
               _loc3_.setFullYear(_loc1_.fullYear - 1,11,31 - _loc3_.day + 1);
            }
         }
         _loc4_ = 0;
         while(_loc4_ < 42)
         {
            _loc6_ = new Date();
            _loc6_.time = _loc3_.time + _loc4_ * CalendarModel.MS_of_Day;
            _loc7_ = new DayCell(_loc6_,this._model);
            _loc7_.x = _loc2_.x + _loc4_ % 7 * 57;
            _loc7_.y = _loc2_.y + Math.floor(_loc4_ / 7) * 26;
            addChild(_loc7_);
            this._dayCells.push(_loc7_);
            _loc4_++;
         }
         var _loc5_:int = 0;
         while(_loc5_ < this._dayCells.length)
         {
            if(this._dayCells[_loc5_].date.fullYear == _loc1_.fullYear && this._dayCells[_loc5_].date.month == _loc1_.month && this._dayCells[_loc5_].date.date == _loc1_.date && !this._model.hasSigned(this._dayCells[_loc5_].date))
            {
               this._dayCells[_loc5_].AutomaticSign();
            }
            _loc5_++;
         }
      }
      
      private function drawLayer() : void
      {
      }
      
      private function addEvent() : void
      {
         this._model.addEventListener(CalendarEvent.TodayChanged,this.__todayChanged);
         this._vipBtn.addEventListener(MouseEvent.CLICK,this.__getVip);
      }
      
      private function __getVip(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         VipController.instance.show();
      }
      
      private function __signCountChanged(param1:Event) : void
      {
         var _loc2_:int = this._dayCells.length;
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_)
         {
            this._dayCells[_loc3_].signed = this._model.hasSigned(this._dayCells[_loc3_].date);
            _loc3_++;
         }
      }
      
      private function __todayChanged(param1:Event) : void
      {
         var _loc6_:Date = null;
         var _loc2_:Date = this._model.today;
         this._monthField.text = String(_loc2_.month + 1);
         this._enMonthField.text = LanguageMgr.GetTranslation("tank.calendar.grid.month" + _loc2_.month);
         this._enMonthField.x = this._monthField.x + this._monthField.width;
         this._todyField.text = LanguageMgr.GetTranslation("tank.calendar.grid.today",_loc2_.fullYear,_loc2_.month + 1,_loc2_.date);
         this._todyField.text += LanguageMgr.GetTranslation("tank.calendar.grid.week" + _loc2_.day);
         var _loc3_:Date = new Date();
         _loc3_.time = _loc2_.time;
         _loc3_.setDate(1);
         if(_loc3_.day != 0)
         {
            if(_loc3_.month > 0)
            {
               _loc3_.setMonth(_loc2_.month - 1,CalendarModel.getMonthMaxDay(_loc2_.month - 1,_loc2_.fullYear) - _loc3_.day + 1);
            }
            else
            {
               _loc3_.setUTCFullYear(_loc2_.fullYear - 1,11,31 - _loc3_.day + 1);
            }
         }
         var _loc4_:int = this._dayCells.length;
         var _loc5_:int = 0;
         while(_loc5_ < _loc4_)
         {
            _loc6_ = new Date();
            _loc6_.time = _loc3_.time + _loc5_ * CalendarModel.MS_of_Day;
            this._dayCells[_loc5_].date = _loc6_;
            this._dayCells[_loc5_].signed = this._model.hasSigned(this._dayCells[_loc5_].date);
            _loc5_++;
         }
      }
      
      private function removeEvent() : void
      {
         this._model.removeEventListener(CalendarEvent.TodayChanged,this.__todayChanged);
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         ObjectUtils.disposeObject(this._back);
         this._back = null;
         ObjectUtils.disposeObject(this._front);
         this._front = null;
         ObjectUtils.disposeObject(this._backGrid);
         this._backGrid = null;
         ObjectUtils.disposeObject(this._title);
         this._title = null;
         ObjectUtils.disposeObject(this._monthField);
         this._monthField = null;
         ObjectUtils.disposeObject(this._enMonthField);
         this._enMonthField = null;
         ObjectUtils.disposeObject(this._todyField);
         this._todyField = null;
         var _loc1_:DayCell = this._dayCells.shift();
         while(_loc1_ != null)
         {
            ObjectUtils.disposeObject(_loc1_);
            _loc1_ = this._dayCells.shift();
         }
         if(parent)
         {
            parent.removeChild(this);
         }
      }
   }
}
