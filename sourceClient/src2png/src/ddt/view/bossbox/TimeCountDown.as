// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//ddt.view.bossbox.TimeCountDown

package ddt.view.bossbox
{
    import flash.events.EventDispatcher;
    import flash.utils.Timer;
    import flash.events.TimerEvent;
    import flash.events.Event;

    public class TimeCountDown extends EventDispatcher 
    {

        public static const COUNTDOWN_COMPLETE:String = "TIME_countdown_complete";
        public static const COUNTDOWN_ONE:String = "countdown_one";

        private var _time:Timer;
        private var _count:int;
        private var _stepSecond:int;

        public function TimeCountDown(_arg_1:int)
        {
            this._stepSecond = _arg_1;
            this._time = new Timer(this._stepSecond);
            this._time.stop();
        }

        public function setTimeOnMinute(_arg_1:int):void
        {
            this._count = (((_arg_1 * 60) * 1000) / this._stepSecond);
            this._time.repeatCount = this._count;
            this._time.reset();
            this._time.start();
            this._time.addEventListener(TimerEvent.TIMER, this._timer);
            this._time.addEventListener(TimerEvent.TIMER_COMPLETE, this._timerComplete);
        }

        private function _timer(_arg_1:TimerEvent):void
        {
            dispatchEvent(new Event(TimeCountDown.COUNTDOWN_ONE));
        }

        private function _timerComplete(_arg_1:TimerEvent):void
        {
            dispatchEvent(new Event(TimeCountDown.COUNTDOWN_COMPLETE));
        }

        public function dispose():void
        {
            if (this._time)
            {
                this._time.stop();
                this._time.removeEventListener(TimerEvent.TIMER, this._timer);
                this._time.removeEventListener(TimerEvent.TIMER_COMPLETE, this._timerComplete);
            };
            this._time = null;
        }


    }
}//package ddt.view.bossbox

