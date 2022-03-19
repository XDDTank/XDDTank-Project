// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//ddt.manager.InviteManager

package ddt.manager
{
    import flash.utils.Timer;
    import flash.events.TimerEvent;

    public class InviteManager 
    {

        private static var _ins:InviteManager;

        private var _timer:Timer;
        private var secCount:int = 62;
        private var _enabled:Boolean = true;

        public function InviteManager()
        {
            this._timer = new Timer(1000);
            this._timer.addEventListener(TimerEvent.TIMER, this.__onTimerRun);
        }

        public static function get Instance():InviteManager
        {
            return (_ins = ((_ins) || (new (InviteManager)())));
        }


        private function __onTimerRun(_arg_1:TimerEvent):void
        {
            this.secCount++;
            if (this.secCount > 61)
            {
                this._timer.stop();
            };
        }

        public function StartTimer():void
        {
            this.secCount = 0;
            this._timer.start();
        }

        public function get enabled():Boolean
        {
            return (this._enabled);
        }

        public function set enabled(_arg_1:Boolean):void
        {
            if (this._enabled == _arg_1)
            {
                return;
            };
            this._enabled = _arg_1;
        }

        public function get canUseDungeonBugle():Boolean
        {
            return (this.secCount > 60);
        }


    }
}//package ddt.manager

