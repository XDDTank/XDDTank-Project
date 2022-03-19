// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//game.view.smallMap.GameTurnButton

package game.view.smallMap
{
    import com.pickgliss.ui.controls.TextButton;
    import road7th.utils.MovieClipWrapper;
    import flash.display.DisplayObjectContainer;
    import flash.display.MovieClip;
    import com.pickgliss.ui.ComponentFactory;
    import flash.events.Event;
    import com.pickgliss.utils.ObjectUtils;

    public class GameTurnButton extends TextButton 
    {

        private var _turnShine:MovieClipWrapper;
        private var _container:DisplayObjectContainer;
        public var isFirst:Boolean = true;

        public function GameTurnButton(_arg_1:DisplayObjectContainer)
        {
            this._container = _arg_1;
            super();
        }

        override protected function init():void
        {
            var _local_1:MovieClip;
            super.init();
            _local_1 = ComponentFactory.Instance.creat("asset.game.smallmap.TurnShine");
            _local_1.x = 27;
            _local_1.y = 7;
            this._turnShine = new MovieClipWrapper(_local_1);
        }

        public function shine():void
        {
            if (((parent == null) && (this._container)))
            {
                this._container.addChild(this);
            };
            if (((this._turnShine) && (this._turnShine.movie)))
            {
                addChildAt(this._turnShine.movie, 0);
                this._turnShine.addEventListener(Event.COMPLETE, this.__shineComplete);
                this._turnShine.gotoAndPlay(1);
            };
        }

        private function __shineComplete(_arg_1:Event):void
        {
            this._turnShine.removeEventListener(Event.COMPLETE, this.__shineComplete);
            if (this._turnShine.movie.parent)
            {
                this._turnShine.movie.parent.removeChild(this._turnShine.movie);
            };
        }

        override public function get width():Number
        {
            if (_back)
            {
                return (_back.width);
            };
            return (60);
        }

        override public function dispose():void
        {
            this._container = null;
            if (this._turnShine)
            {
                this._turnShine.removeEventListener(Event.COMPLETE, this.__shineComplete);
                ObjectUtils.disposeObject(this._turnShine);
                this._turnShine = null;
            };
            super.dispose();
        }


    }
}//package game.view.smallMap

