// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//equipretrieve.effect.AnimationControl

package equipretrieve.effect
{
    import flash.events.EventDispatcher;
    import flash.events.IEventDispatcher;
    import flash.events.Event;

    public class AnimationControl extends EventDispatcher 
    {

        private var _movieArr:Array = new Array();
        private var _movieokNum:int = 0;
        private var _movieokTotal:int = 0;

        public function AnimationControl(_arg_1:IEventDispatcher=null)
        {
            super(_arg_1);
        }

        public function addMovies(_arg_1:EventDispatcher):void
        {
            this._movieArr.push(_arg_1);
        }

        public function startMovie():void
        {
            this._movieokTotal = this._movieArr.length;
            var _local_1:int;
            while (_local_1 < this._movieokTotal)
            {
                this._movieArr[_local_1].movieStart();
                this._movieArr[_local_1].addEventListener(Event.COMPLETE, this._movieArrComplete);
                _local_1++;
            };
        }

        private function _movieArrComplete(_arg_1:Event):void
        {
            _arg_1.currentTarget.removeEventListener(Event.COMPLETE, this._movieArrComplete);
            this._movieokNum = (this._movieokNum + 1);
            if (this._movieokNum == this._movieokTotal)
            {
                this._movieArr = null;
                this._movieokNum = 0;
                dispatchEvent(new Event(Event.COMPLETE));
            };
        }


    }
}//package equipretrieve.effect

