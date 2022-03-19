// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//calendar.view.CalendarGrid

package calendar.view
{
    import flash.display.Sprite;
    import com.pickgliss.ui.core.Disposeable;
    import __AS3__.vec.Vector;
    import calendar.CalendarModel;
    import com.pickgliss.ui.text.FilterFrameText;
    import flash.display.DisplayObject;
    import flash.display.Shape;
    import com.pickgliss.ui.controls.BaseButton;
    import com.pickgliss.ui.ComponentFactory;
    import ddt.manager.LanguageMgr;
    import flash.geom.Point;
    import calendar.CalendarEvent;
    import flash.events.MouseEvent;
    import ddt.manager.SoundManager;
    import vip.VipController;
    import flash.events.Event;
    import com.pickgliss.utils.ObjectUtils;
    import __AS3__.vec.*;

    public class CalendarGrid extends Sprite implements Disposeable 
    {

        private var _dayCells:Vector.<DayCell> = new Vector.<DayCell>();
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

        public function CalendarGrid(_arg_1:CalendarModel)
        {
            this._model = _arg_1;
            this.configUI();
            this.addEvent();
        }

        private function configUI():void
        {
            var _local_4:int;
            var _local_6:Date;
            var _local_7:DayCell;
            this._back = ComponentFactory.Instance.creatCustomObject("ddtcalendar.CalendarBackBg");
            addChild(this._back);
            this._front = ComponentFactory.Instance.creatCustomObject("ddtcalendar.CalendarFrontBg");
            addChild(this._front);
            this._title = ComponentFactory.Instance.creatBitmap("asset.ddtcalendar.CalendarGridTitleBg");
            addChild(this._title);
            var _local_1:Date = this._model.today;
            this._monthField = ComponentFactory.Instance.creatComponentByStylename("ddtcalendar.CalendarGrid.NumMonthField");
            this._monthField.text = String((_local_1.month + 1));
            addChild(this._monthField);
            this._enMonthField = ComponentFactory.Instance.creatComponentByStylename("ddtcalendar.CalendarGrid.EnMonthField");
            this._enMonthField.text = LanguageMgr.GetTranslation(("tank.calendar.grid.month" + _local_1.month));
            this._enMonthField.x = (this._monthField.x + this._monthField.width);
            addChild(this._enMonthField);
            this._todyField = ComponentFactory.Instance.creatComponentByStylename("ddtcalendar.CalendarGrid.TodayField");
            this._todyField.text = LanguageMgr.GetTranslation("tank.calendar.grid.today", _local_1.fullYear, (_local_1.month + 1), _local_1.date);
            this._todyField.text = (this._todyField.text + LanguageMgr.GetTranslation(("tank.calendar.grid.week" + _local_1.day)));
            addChild(this._todyField);
            this._vipBtn = ComponentFactory.Instance.creatComponentByStylename("vipView.OpenBtn");
            var _local_2:Point = ComponentFactory.Instance.creatCustomObject("ddtcalendar.CalendarGrid.TopLeft");
            var _local_3:Date = new Date();
            _local_3.time = _local_1.time;
            _local_3.setDate(1);
            if (_local_3.day != 0)
            {
                if (_local_3.month > 0)
                {
                    _local_3.setMonth((_local_1.month - 1), ((CalendarModel.getMonthMaxDay((_local_1.month - 1), _local_1.fullYear) - _local_3.day) + 1));
                }
                else
                {
                    _local_3.setFullYear((_local_1.fullYear - 1), 11, ((31 - _local_3.day) + 1));
                };
            };
            _local_4 = 0;
            while (_local_4 < 42)
            {
                _local_6 = new Date();
                _local_6.time = (_local_3.time + (_local_4 * CalendarModel.MS_of_Day));
                _local_7 = new DayCell(_local_6, this._model);
                _local_7.x = (_local_2.x + ((_local_4 % 7) * 57));
                _local_7.y = (_local_2.y + (Math.floor((_local_4 / 7)) * 26));
                addChild(_local_7);
                this._dayCells.push(_local_7);
                _local_4++;
            };
            var _local_5:int;
            while (_local_5 < this._dayCells.length)
            {
                if (((((this._dayCells[_local_5].date.fullYear == _local_1.fullYear) && (this._dayCells[_local_5].date.month == _local_1.month)) && (this._dayCells[_local_5].date.date == _local_1.date)) && (!(this._model.hasSigned(this._dayCells[_local_5].date)))))
                {
                    this._dayCells[_local_5].AutomaticSign();
                };
                _local_5++;
            };
        }

        private function drawLayer():void
        {
        }

        private function addEvent():void
        {
            this._model.addEventListener(CalendarEvent.TodayChanged, this.__todayChanged);
            this._vipBtn.addEventListener(MouseEvent.CLICK, this.__getVip);
        }

        private function __getVip(_arg_1:MouseEvent):void
        {
            SoundManager.instance.play("008");
            VipController.instance.show();
        }

        private function __signCountChanged(_arg_1:Event):void
        {
            var _local_2:int = this._dayCells.length;
            var _local_3:int;
            while (_local_3 < _local_2)
            {
                this._dayCells[_local_3].signed = this._model.hasSigned(this._dayCells[_local_3].date);
                _local_3++;
            };
        }

        private function __todayChanged(_arg_1:Event):void
        {
            var _local_6:Date;
            var _local_2:Date = this._model.today;
            this._monthField.text = String((_local_2.month + 1));
            this._enMonthField.text = LanguageMgr.GetTranslation(("tank.calendar.grid.month" + _local_2.month));
            this._enMonthField.x = (this._monthField.x + this._monthField.width);
            this._todyField.text = LanguageMgr.GetTranslation("tank.calendar.grid.today", _local_2.fullYear, (_local_2.month + 1), _local_2.date);
            this._todyField.text = (this._todyField.text + LanguageMgr.GetTranslation(("tank.calendar.grid.week" + _local_2.day)));
            var _local_3:Date = new Date();
            _local_3.time = _local_2.time;
            _local_3.setDate(1);
            if (_local_3.day != 0)
            {
                if (_local_3.month > 0)
                {
                    _local_3.setMonth((_local_2.month - 1), ((CalendarModel.getMonthMaxDay((_local_2.month - 1), _local_2.fullYear) - _local_3.day) + 1));
                }
                else
                {
                    _local_3.setUTCFullYear((_local_2.fullYear - 1), 11, ((31 - _local_3.day) + 1));
                };
            };
            var _local_4:int = this._dayCells.length;
            var _local_5:int;
            while (_local_5 < _local_4)
            {
                _local_6 = new Date();
                _local_6.time = (_local_3.time + (_local_5 * CalendarModel.MS_of_Day));
                this._dayCells[_local_5].date = _local_6;
                this._dayCells[_local_5].signed = this._model.hasSigned(this._dayCells[_local_5].date);
                _local_5++;
            };
        }

        private function removeEvent():void
        {
            this._model.removeEventListener(CalendarEvent.TodayChanged, this.__todayChanged);
        }

        public function dispose():void
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
            var _local_1:DayCell = this._dayCells.shift();
            while (_local_1 != null)
            {
                ObjectUtils.disposeObject(_local_1);
                _local_1 = this._dayCells.shift();
            };
            if (parent)
            {
                parent.removeChild(this);
            };
        }


    }
}//package calendar.view

