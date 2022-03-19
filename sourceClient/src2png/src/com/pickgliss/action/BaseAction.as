// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//com.pickgliss.action.BaseAction

package com.pickgliss.action
{
    import flash.utils.Timer;
    import flash.events.TimerEvent;

    public class BaseAction implements IAction 
    {

        protected var _completeFun:Function;
        protected var _acting:Boolean;
        private var _limitTimer:Timer;
        private var _timeOut:uint;

        public function BaseAction(_arg_1:uint=0)
        {
        }

        public function act():void
        {
            if (this._timeOut > 0)
            {
                this.startLimitTimer();
            };
        }

        public function setCompleteFun(_arg_1:Function):void
        {
            this._completeFun = _arg_1;
        }

        private function startLimitTimer():void
        {
            this.removeLimitTimer();
            this._limitTimer = new Timer(this._timeOut, 1);
            this._limitTimer.addEventListener(TimerEvent.TIMER_COMPLETE, this.onLimitTimerComplete);
            this._limitTimer.start();
        }

        protected function onLimitTimerComplete(_arg_1:TimerEvent):void
        {
            this.removeLimitTimer();
            if (this._acting)
            {
                this.cancel();
                this.execComplete();
            };
        }

        private function removeLimitTimer():void
        {
            if (this._limitTimer)
            {
                this._limitTimer.stop();
                this._limitTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, this.onLimitTimerComplete);
                this._limitTimer = null;
            };
        }

        public function get acting():Boolean
        {
            return (this._acting);
        }

        public function cancel():void
        {
            this.removeLimitTimer();
            this._acting = false;
        }

        protected function execComplete():void
        {
            this.removeLimitTimer();
            if ((this._completeFun is Function))
            {
                this._completeFun(this);
            };
        }


    }
}//package com.pickgliss.action

