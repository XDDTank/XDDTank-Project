// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//com.pickgliss.action.TickOrderQueueAction

package com.pickgliss.action
{
    import flash.utils.Timer;
    import flash.events.TimerEvent;

    public class TickOrderQueueAction extends OrderQueueAction 
    {

        private var _interval:uint;
        private var _tickTimer:Timer;
        private var _delay:uint;
        private var _delayTimer:Timer;

        public function TickOrderQueueAction(_arg_1:Array, _arg_2:uint=100, _arg_3:uint=0, _arg_4:uint=0)
        {
            this._interval = _arg_2;
            this._delay = _arg_3;
            super(_arg_1, _arg_4);
        }

        override public function act():void
        {
            if (this._delay > 0)
            {
                this._delayTimer = new Timer(this._delay, 1);
                this._delayTimer.addEventListener(TimerEvent.TIMER_COMPLETE, this.onDelayTimerComplete);
                this._delayTimer.start();
            }
            else
            {
                super.act();
            };
        }

        private function onDelayTimerComplete(_arg_1:TimerEvent):void
        {
            this.removeDelayTimer();
            super.act();
        }

        private function removeDelayTimer():void
        {
            if (this._delayTimer)
            {
                this._delayTimer.stop();
                this._delayTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, this.onDelayTimerComplete);
                this._delayTimer = null;
            };
        }

        override protected function actOne():void
        {
            var _local_1:IAction = (_actList[_count] as IAction);
            this.startTickTimer();
            _local_1.act();
        }

        private function startTickTimer():void
        {
            this._tickTimer = new Timer(this._interval, 1);
            this._tickTimer.addEventListener(TimerEvent.TIMER_COMPLETE, this.onTickTimerComplete);
            this._tickTimer.start();
        }

        private function onTickTimerComplete(_arg_1:TimerEvent):void
        {
            this.removeTickTimer();
            actNext();
        }

        private function removeTickTimer():void
        {
            if (this._tickTimer)
            {
                this._tickTimer.stop();
                this._tickTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, this.onTickTimerComplete);
                this._tickTimer = null;
            };
        }

        override protected function onLimitTimerComplete(_arg_1:TimerEvent):void
        {
            this.removeTickTimer();
            super.onLimitTimerComplete(_arg_1);
        }

        override public function cancel():void
        {
            this.removeTickTimer();
            this.removeDelayTimer();
            super.cancel();
        }


    }
}//package com.pickgliss.action

