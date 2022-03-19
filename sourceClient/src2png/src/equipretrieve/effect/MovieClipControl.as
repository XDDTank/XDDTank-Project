// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//equipretrieve.effect.MovieClipControl

package equipretrieve.effect
{
    import flash.events.EventDispatcher;
    import flash.display.Sprite;
    import flash.display.MovieClip;
    import flash.events.Event;

    public class MovieClipControl extends EventDispatcher 
    {

        private var _movieArr:Array = new Array();
        private var _evtSprite:Sprite = new Sprite();
        private var _total:int;
        private var _currentInt:int;
        private var _arrInt:int;

        public function MovieClipControl(_arg_1:int)
        {
            this._total = _arg_1;
        }

        public function addMovies(_arg_1:MovieClip, _arg_2:int, _arg_3:int):void
        {
            var _local_4:Object;
            _local_4 = new Object();
            _arg_1.visible = false;
            _arg_1.stop();
            _local_4.view = _arg_1;
            _local_4.goInt = _arg_2;
            _local_4.totalInt = (_arg_3 + _arg_2);
            this._movieArr.push(_local_4);
        }

        public function startMovie():void
        {
            this._currentInt = 0;
            this._arrInt = this._movieArr.length;
            this._evtSprite.addEventListener(Event.ENTER_FRAME, this._inFrame);
        }

        private function _inFrame(_arg_1:Event):void
        {
            this._currentInt = (this._currentInt + 1);
            if (this._currentInt >= this._total)
            {
                this._allMovieClipOver();
                return;
            };
            var _local_2:int;
            while (_local_2 < this._arrInt)
            {
                if (this._movieArr[_local_2].goInt == this._currentInt)
                {
                    this._movieArr[_local_2].view.visible = true;
                    this._movieArr[_local_2].view.play();
                }
                else
                {
                    if (this._movieArr[_local_2].totalInt == this._currentInt)
                    {
                        this._movieArr[_local_2].view.visible = false;
                        this._movieArr[_local_2].view.stop();
                    };
                };
                _local_2++;
            };
        }

        private function _allMovieClipOver():void
        {
            dispatchEvent(new Event(Event.COMPLETE));
            this._evtSprite.removeEventListener(Event.ENTER_FRAME, this._inFrame);
            var _local_1:int;
            while (_local_1 < this._arrInt)
            {
                this._movieArr[_local_1].view.visible = false;
                this._movieArr[_local_1].view.stop();
                _local_1++;
            };
            this._removeAllView();
        }

        private function _removeAllView():void
        {
            this._evtSprite = null;
            this._movieArr = null;
        }


    }
}//package equipretrieve.effect

