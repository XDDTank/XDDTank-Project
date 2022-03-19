// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//game.view.tool.DamageStasticView

package game.view.tool
{
    import flash.display.Sprite;
    import com.pickgliss.ui.core.Disposeable;
    import __AS3__.vec.Vector;
    import flash.events.Event;
    import com.greensock.TweenLite;
    import __AS3__.vec.*;

    public class DamageStasticView extends Sprite implements Disposeable 
    {

        private var _resultList:Vector.<DamageStrip>;
        private var _infoList:Array;
        private var _delay:int;
        private var _isShowed:Boolean;
        private var _currentIndex:int;

        public function DamageStasticView()
        {
            this._resultList = new Vector.<DamageStrip>();
            mouseEnabled = false;
            mouseChildren = false;
        }

        public function setInfoList(_arg_1:Array):void
        {
            var _local_2:Number;
            var _local_3:int;
            var _local_4:int;
            var _local_5:DamageStrip;
            this.reset();
            this._infoList = _arg_1;
            if (this._infoList.length == 0)
            {
                return;
            };
            this._isShowed = false;
            _local_4 = 0;
            while (_local_4 < this._infoList.length)
            {
                _local_5 = new DamageStrip();
                _local_5.y = (this._resultList.length * _local_5.height);
                _local_5.info = this._infoList[_local_4];
                this._resultList.push(_local_5);
                if (this._resultList[_local_3].width < _local_5.width)
                {
                    _local_3 = _local_4;
                };
                _local_4++;
            };
            _local_2 = this._resultList[_local_3].width;
            _local_4 = 0;
            while (_local_4 < this._infoList.length)
            {
                this._resultList[_local_4].width = _local_2;
                _local_4++;
            };
            this._currentIndex = 0;
        }

        public function start():void
        {
            if (this._isShowed)
            {
                return;
            };
            this._isShowed = true;
            if (((this._infoList) && (this._infoList.length > 0)))
            {
                addEventListener(Event.ENTER_FRAME, this.__onEnterFrame);
            };
        }

        protected function __onEnterFrame(_arg_1:Event):void
        {
            if (this._delay <= 0)
            {
                if (this._currentIndex < this._resultList.length)
                {
                    this._resultList[this._currentIndex].show();
                    addChild(this._resultList[this._currentIndex]);
                    if (this._currentIndex < (this._resultList.length - 1))
                    {
                        this._delay = 10;
                    }
                    else
                    {
                        this._delay = 50;
                    };
                    this._currentIndex++;
                }
                else
                {
                    removeEventListener(Event.ENTER_FRAME, this.__onEnterFrame);
                    TweenLite.to(this, 0.2, {
                        "alpha":0,
                        "onComplete":this.reset
                    });
                };
            };
            this._delay--;
        }

        public function reset():void
        {
            TweenLite.killTweensOf(this);
            while (this._resultList.length > 0)
            {
                this._resultList.shift().dispose();
            };
            this._resultList.length = 0;
            this._delay = 0;
            alpha = 1;
        }

        public function dispose():void
        {
            this.reset();
            removeEventListener(Event.ENTER_FRAME, this.__onEnterFrame);
            this._resultList = null;
            this._infoList = null;
            if (parent)
            {
                parent.removeChild(this);
            };
        }


    }
}//package game.view.tool

