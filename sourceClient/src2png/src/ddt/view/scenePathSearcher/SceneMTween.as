// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//ddt.view.scenePathSearcher.SceneMTween

package ddt.view.scenePathSearcher
{
    import flash.events.EventDispatcher;
    import flash.display.DisplayObject;
    import flash.events.Event;

    public class SceneMTween extends EventDispatcher 
    {

        public static const FINISH:String = "finish";
        public static const CHANGE:String = "change";
        public static const START:String = "start";
        public static const STOP:String = "stop";

        private var _obj:DisplayObject;
        private var _prop:String;
        private var _prop2:String;
        private var _isPlaying:Boolean;
        private var _finish:Number;
        private var _finish2:Number;
        private var vectors:Number;
        private var vectors2:Number;
        private var currentCount:Number;
        private var repeatCount:Number;
        private var _time:Number;

        public function SceneMTween(_arg_1:DisplayObject)
        {
            this._obj = _arg_1;
        }

        private function onEnterFrame(_arg_1:Event):void
        {
            this._obj[this._prop] = (this._obj[this._prop] + (this.vectors / this.repeatCount));
            if (this._prop2)
            {
                this._obj[this._prop2] = (this._obj[this._prop2] + (this.vectors2 / this.repeatCount));
            };
            this.currentCount++;
            if (this.currentCount >= this.repeatCount)
            {
                this.stop();
                this._obj[this._prop] = this._finish;
                if (this._prop2)
                {
                    this._obj[this._prop2] = this._finish2;
                };
                dispatchEvent(new Event(FINISH));
            };
            dispatchEvent(new Event(CHANGE));
        }

        public function start(_arg_1:Number, _arg_2:String, _arg_3:Number, _arg_4:String=null, _arg_5:Number=0):void
        {
            if (this._isPlaying)
            {
                this.stop();
            };
            this._time = _arg_1;
            this._prop = _arg_2;
            this._finish = _arg_3;
            this._finish2 = _arg_5;
            this._prop2 = _arg_4;
            this.currentCount = 0;
            this.vectors = (this._finish - this._obj[this._prop]);
            if (this._prop2)
            {
                this.vectors2 = (this._finish2 - this._obj[this._prop2]);
            }
            else
            {
                this._finish2 = 0;
            };
            this.startGo();
        }

        public function startGo():void
        {
            if (this._isPlaying)
            {
                this.stop();
            };
            this.repeatCount = ((this._time / 1000) * 25);
            if ((!(this._obj.hasEventListener(Event.ENTER_FRAME))))
            {
                this._obj.addEventListener(Event.ENTER_FRAME, this.onEnterFrame);
            };
            this._isPlaying = true;
            dispatchEvent(new Event(START));
        }

        public function stop():void
        {
            this._obj.removeEventListener(Event.ENTER_FRAME, this.onEnterFrame);
            this._isPlaying = false;
            dispatchEvent(new Event(STOP));
        }

        public function dispose():void
        {
            this.stop();
            this._obj = null;
        }

        public function get isPlaying():Boolean
        {
            return (this._isPlaying);
        }

        public function set time(_arg_1:Number):void
        {
            this._time = _arg_1;
        }


    }
}//package ddt.view.scenePathSearcher

