// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//com.pickgliss.utils.DoubleClickManager

package com.pickgliss.utils
{
    import flash.utils.Timer;
    import flash.display.InteractiveObject;
    import flash.events.MouseEvent;
    import flash.events.TimerEvent;
    import com.pickgliss.events.InteractiveEvent;

    public final class DoubleClickManager 
    {

        private static var _instance:DoubleClickManager;

        private const DoubleClickSpeed:uint = 350;

        private var _timer:Timer;
        private var _currentTarget:InteractiveObject;
        private var _ctrlKey:Boolean;
        private var _isMouseUp:Boolean;

        public function DoubleClickManager()
        {
            this.init();
        }

        public static function get Instance():DoubleClickManager
        {
            if ((!(_instance)))
            {
                _instance = new (DoubleClickManager)();
            };
            return (_instance);
        }


        public function enableDoubleClick(_arg_1:InteractiveObject):void
        {
            _arg_1.addEventListener(MouseEvent.MOUSE_DOWN, this.__mouseDownHandler);
            _arg_1.addEventListener(MouseEvent.MOUSE_UP, this.__mouseUpHandler);
        }

        public function disableDoubleClick(_arg_1:InteractiveObject):void
        {
            _arg_1.removeEventListener(MouseEvent.MOUSE_DOWN, this.__mouseDownHandler);
            _arg_1.removeEventListener(MouseEvent.MOUSE_UP, this.__mouseUpHandler);
        }

        private function init():void
        {
            this._timer = new Timer(this.DoubleClickSpeed, 1);
            this._timer.addEventListener(TimerEvent.TIMER_COMPLETE, this.__timerCompleteHandler);
        }

        private function getEvent(_arg_1:String):InteractiveEvent
        {
            var _local_2:InteractiveEvent = new InteractiveEvent(_arg_1);
            _local_2.ctrlKey = this._ctrlKey;
            return (_local_2);
        }

        private function __timerCompleteHandler(_arg_1:TimerEvent):void
        {
            if (this._isMouseUp)
            {
                this._currentTarget.dispatchEvent(this.getEvent(InteractiveEvent.CLICK));
            }
            else
            {
                this._currentTarget.dispatchEvent(this.getEvent(InteractiveEvent.MOUSE_DOWN));
            };
        }

        private function __mouseDownHandler(_arg_1:MouseEvent):void
        {
            this._ctrlKey = _arg_1.ctrlKey;
            this._isMouseUp = false;
            if (this._timer.running)
            {
                this._timer.stop();
                if (this._currentTarget != _arg_1.currentTarget)
                {
                    return;
                };
                _arg_1.stopImmediatePropagation();
                this._currentTarget.dispatchEvent(this.getEvent(InteractiveEvent.DOUBLE_CLICK));
            }
            else
            {
                this._timer.reset();
                this._timer.start();
                this._currentTarget = (_arg_1.currentTarget as InteractiveObject);
            };
        }

        protected function __mouseUpHandler(_arg_1:MouseEvent):void
        {
            this._isMouseUp = true;
        }

        public function clearTarget():void
        {
            if (this._timer)
            {
                this._timer.stop();
            };
            this._currentTarget = null;
        }


    }
}//package com.pickgliss.utils

