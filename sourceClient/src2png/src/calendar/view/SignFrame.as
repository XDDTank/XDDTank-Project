// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//calendar.view.SignFrame

package calendar.view
{
    import com.pickgliss.ui.controls.Frame;
    import calendar.CalendarModel;
    import com.pickgliss.ui.ComponentFactory;
    import flash.display.DisplayObject;
    import com.pickgliss.events.FrameEvent;
    import flash.events.Event;
    import ddt.manager.SoundManager;
    import calendar.CalendarManager;
    import com.pickgliss.toplevel.StageReferance;
    import com.pickgliss.utils.ObjectUtils;

    public class SignFrame extends Frame 
    {

        private var _signCalendar:ICalendar;
        private var _model:CalendarModel;

        public function SignFrame(_arg_1:CalendarModel, _arg_2:*=null)
        {
            this.initView(_arg_1, _arg_2);
            this.addEvent();
        }

        private function initView(_arg_1:*, _arg_2:*):void
        {
            this._signCalendar = ComponentFactory.Instance.creatCustomObject("ddtcalendar.CalendarState", [_arg_1]);
            addToContent((this._signCalendar as DisplayObject));
            if (this._signCalendar)
            {
                this._signCalendar.setData(_arg_2);
            };
        }

        private function addEvent():void
        {
            addEventListener(FrameEvent.RESPONSE, this.__response);
            addEventListener(Event.ADDED_TO_STAGE, this.__getFocus);
        }

        private function __response(_arg_1:FrameEvent):void
        {
            SoundManager.instance.play("008");
            switch (_arg_1.responseCode)
            {
                case FrameEvent.CANCEL_CLICK:
                case FrameEvent.ESC_CLICK:
                case FrameEvent.CLOSE_CLICK:
                    CalendarManager.getInstance().close();
                    this.dispose();
                    return;
            };
        }

        private function __getFocus(_arg_1:Event):void
        {
            removeEventListener(Event.ADDED_TO_STAGE, this.__getFocus);
            StageReferance.stage.focus = this;
        }

        override public function dispose():void
        {
            ObjectUtils.disposeObject(this._signCalendar);
            this._signCalendar = null;
            super.dispose();
        }


    }
}//package calendar.view

