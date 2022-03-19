// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//calendar.view.CalendarState

package calendar.view
{
    import flash.display.Sprite;
    import calendar.CalendarModel;
    import com.pickgliss.ui.ComponentFactory;
    import com.pickgliss.utils.ObjectUtils;

    public class CalendarState extends Sprite implements ICalendar 
    {

        private var _calendarGrid:CalendarGrid;
        private var _awardBar:SignAwardBar;
        private var _model:CalendarModel;

        public function CalendarState(_arg_1:CalendarModel)
        {
            this._model = _arg_1;
            this.configUI();
        }

        private function configUI():void
        {
            this._calendarGrid = ComponentFactory.Instance.creatCustomObject("ddtcalendar.CalendarGrid", [this._model]);
            addChild(this._calendarGrid);
            this._awardBar = ComponentFactory.Instance.creatCustomObject("ddtcalendar.SignAwardBar", [this._model]);
            addChild(this._awardBar);
        }

        public function setData(_arg_1:*=null):void
        {
        }

        public function dispose():void
        {
            ObjectUtils.disposeObject(this._calendarGrid);
            this._calendarGrid = null;
            ObjectUtils.disposeObject(this._awardBar);
            this._awardBar = null;
            this._model = null;
            if (parent)
            {
                parent.removeChild(this);
            };
        }


    }
}//package calendar.view

