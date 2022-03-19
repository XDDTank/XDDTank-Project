// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//road7th.utils.MovieClipWrapper

package road7th.utils
{
    import flash.events.EventDispatcher;
    import com.pickgliss.ui.core.Disposeable;
    import flash.display.MovieClip;
    import flash.events.Event;

    [Event(name="complete", type="flash.events.Event")]
    public class MovieClipWrapper extends EventDispatcher implements Disposeable 
    {

        private var _movie:MovieClip;
        public var repeat:Boolean;
        public var autoDisappear:Boolean;
        private var _isDispose:Boolean = false;
        private var _endFrame:int = -1;

        public function MovieClipWrapper(_arg_1:MovieClip, _arg_2:Boolean=false, _arg_3:Boolean=false, _arg_4:Boolean=false)
        {
            this._movie = _arg_1;
            this.repeat = _arg_4;
            this.autoDisappear = _arg_3;
            if ((!(_arg_2)))
            {
                this._movie.stop();
                this._movie.addEventListener(Event.ADDED_TO_STAGE, this.__onAddStage);
            }
            else
            {
                this._movie.addEventListener(Event.ENTER_FRAME, this.__frameHandler);
            };
        }

        public function set endFrame(_arg_1:int):void
        {
            this._endFrame = _arg_1;
        }

        private function __onAddStage(_arg_1:Event):void
        {
            this._movie.gotoAndStop(1);
        }

        public function gotoAndPlay(_arg_1:Object):void
        {
            this._movie.addEventListener(Event.ENTER_FRAME, this.__frameHandler);
            this._movie.gotoAndPlay(_arg_1);
        }

        public function gotoAndStop(_arg_1:Object):void
        {
            this._movie.addEventListener(Event.ENTER_FRAME, this.__frameHandler);
            this._movie.gotoAndStop(_arg_1);
        }

        public function addFrameScriptAt(_arg_1:Number, _arg_2:Function):void
        {
            if (_arg_1 == this._movie.framesLoaded)
            {
                throw (new Error("You can't add scprit at that frame,The MovieClipWrapper used for COMPLETE event!"));
            };
            this._movie.addFrameScript(_arg_1, _arg_2);
        }

        public function play():void
        {
            this._movie.addEventListener(Event.ENTER_FRAME, this.__frameHandler);
            this._movie.play();
            if (this._movie.framesLoaded <= 1)
            {
                this.stop();
            };
        }

        public function get movie():MovieClip
        {
            return (this._movie);
        }

        public function stop():void
        {
            dispatchEvent(new Event(Event.COMPLETE));
            if (this.autoDisappear)
            {
                this.dispose();
            };
        }

        private function __frameHandler(_arg_1:Event):void
        {
            if (((this._movie.currentFrame == this._endFrame) || (this._movie.currentFrame == this._movie.totalFrames)))
            {
                this.__endFrame();
            };
        }

        private function __endFrame():void
        {
            if (this.repeat)
            {
                this._movie.gotoAndPlay(1);
            }
            else
            {
                this._movie.removeEventListener(Event.ENTER_FRAME, this.__frameHandler);
                this.stop();
            };
        }

        public function dispose():void
        {
            if ((!(this._isDispose)))
            {
                this._movie.removeEventListener(Event.ENTER_FRAME, this.__frameHandler);
                this._movie.removeEventListener(Event.ADDED_TO_STAGE, this.__onAddStage);
                if (this._movie.parent)
                {
                    this._movie.parent.removeChild(this._movie);
                };
                this._movie.stop();
                this._movie = null;
                this._isDispose = true;
            };
        }


    }
}//package road7th.utils

