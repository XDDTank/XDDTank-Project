// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//equipretrieve.effect.GlowFilterAnimation

package equipretrieve.effect
{
    import flash.events.EventDispatcher;
    import flash.filters.GlowFilter;
    import flash.display.DisplayObject;
    import flash.events.IEventDispatcher;
    import flash.events.Event;

    public dynamic class GlowFilterAnimation extends EventDispatcher 
    {

        private var _blurFilter:GlowFilter;
        private var _view:DisplayObject;
        private var _movieArr:Array;
        private var _nowMovieID:int = 0;
        private var _overHasFilter:Boolean;

        public function GlowFilterAnimation(_arg_1:IEventDispatcher=null)
        {
            super(_arg_1);
        }

        public function start(_arg_1:DisplayObject, _arg_2:Boolean=false, _arg_3:uint=0xFF0000, _arg_4:Number=1, _arg_5:Number=6, _arg_6:Number=6, _arg_7:Number=2, _arg_8:int=1, _arg_9:Boolean=false, _arg_10:Boolean=false):void
        {
            this._movieArr = new Array();
            this._blurFilter = new GlowFilter(_arg_3, _arg_4, _arg_5, _arg_6, _arg_7, _arg_8, _arg_9, _arg_10);
            this._view = _arg_1;
            this._overHasFilter = _arg_2;
        }

        public function addMovie(_arg_1:Number, _arg_2:Number, _arg_3:int, _arg_4:int=2):void
        {
            var _local_5:Object = new Object();
            _local_5.blurX = _arg_1;
            _local_5.blurY = _arg_2;
            _local_5.strength = _arg_4;
            _local_5.time = _arg_3;
            _local_5.blurSpeedX = 0;
            _local_5.blurSpeedY = 0;
            this._movieArr.push(_local_5);
        }

        public function movieStart():void
        {
            if ((((this._movieArr == null) || (this._movieArr.length < 1)) || (this._view == null)))
            {
                return;
            };
            this._nowMovieID = 0;
            this._refeshSpeed();
            this._view.addEventListener(Event.ENTER_FRAME, this._inframe);
        }

        private function _inframe(_arg_1:Event):void
        {
            this._blurFilter.blurX = (this._blurFilter.blurX + this._movieArr[this._nowMovieID].blurSpeedX);
            this._blurFilter.blurY = (this._blurFilter.blurY + this._movieArr[this._nowMovieID].blurSpeedY);
            this._view.filters = [this._blurFilter];
            this._movieArr[this._nowMovieID].time = (this._movieArr[this._nowMovieID].time - 1);
            if (this._movieArr[this._nowMovieID].time == 0)
            {
                if (this._nowMovieID < (this._movieArr.length - 1))
                {
                    this._nowMovieID = (this._nowMovieID + 1);
                    this._refeshSpeed();
                }
                else
                {
                    this._view.removeEventListener(Event.ENTER_FRAME, this._inframe);
                    this._movieOver();
                };
            };
        }

        private function _refeshSpeed():void
        {
            this._movieArr[this._nowMovieID].blurSpeedX = ((this._movieArr[this._nowMovieID].blurX - this._blurFilter.blurX) / this._movieArr[this._nowMovieID].time);
            this._movieArr[this._nowMovieID].blurSpeedY = ((this._movieArr[this._nowMovieID].blurY - this._blurFilter.blurY) / this._movieArr[this._nowMovieID].time);
        }

        private function _movieOver():void
        {
            if (this._overHasFilter == false)
            {
                this._view.filters = null;
            };
            this._blurFilter = null;
            this._view = null;
            this._movieArr = null;
            this._nowMovieID = 0;
            dispatchEvent(new Event(Event.COMPLETE));
        }


    }
}//package equipretrieve.effect

