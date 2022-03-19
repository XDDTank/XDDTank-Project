// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//game.view.card.CardCountDown

package game.view.card
{
    import flash.display.Sprite;
    import com.pickgliss.ui.core.Disposeable;
    import __AS3__.vec.Vector;
    import flash.display.BitmapData;
    import flash.utils.Timer;
    import flash.display.Bitmap;
    import flash.events.TimerEvent;
    import com.pickgliss.ui.ComponentFactory;
    import ddt.manager.SoundManager;
    import flash.events.Event;
    import __AS3__.vec.*;

    public class CardCountDown extends Sprite implements Disposeable 
    {

        private var _bitmapDatas:Vector.<BitmapData>;
        private var _timer:Timer;
        private var _totalSeconds:uint;
        private var _digit:Bitmap;
        private var _tenDigit:Bitmap;
        private var _isPlaySound:Boolean;

        public function CardCountDown()
        {
            this.init();
        }

        public function tick(_arg_1:uint, _arg_2:Boolean=true):void
        {
            this._totalSeconds = _arg_1;
            this._isPlaySound = _arg_2;
            this._timer.repeatCount = this._totalSeconds;
            this.__updateView();
            this._timer.start();
        }

        private function init():void
        {
            this._digit = new Bitmap();
            this._tenDigit = new Bitmap();
            this._bitmapDatas = new Vector.<BitmapData>();
            this._timer = new Timer(1000);
            this._timer.addEventListener(TimerEvent.TIMER, this.__updateView);
            this._timer.addEventListener(TimerEvent.TIMER_COMPLETE, this.__onTimerComplete);
            var _local_1:int;
            while (_local_1 < 10)
            {
                this._bitmapDatas.push(ComponentFactory.Instance.creatBitmapData(("asset.takeoutCard.CountDownNum_" + String(_local_1))));
                _local_1++;
            };
        }

        private function __updateView(_arg_1:TimerEvent=null):void
        {
            var _local_2:int = (this._timer.repeatCount - this._timer.currentCount);
            if (_local_2 <= 4)
            {
                if (this._isPlaySound)
                {
                    SoundManager.instance.stop("067");
                    SoundManager.instance.play("067");
                };
            }
            else
            {
                if (this._isPlaySound)
                {
                    SoundManager.instance.play("014");
                };
            };
            this._tenDigit.bitmapData = this._bitmapDatas[int((_local_2 / 10))];
            this._digit.bitmapData = this._bitmapDatas[(_local_2 % 10)];
            this._digit.x = (this._tenDigit.width - 14);
            addChild(this._digit);
            addChild(this._tenDigit);
        }

        private function __onTimerComplete(_arg_1:TimerEvent):void
        {
            dispatchEvent(new Event(Event.COMPLETE));
        }

        public function dispose():void
        {
            var _local_1:BitmapData;
            this._timer.removeEventListener(TimerEvent.TIMER, this.__updateView);
            this._timer.removeEventListener(TimerEvent.TIMER_COMPLETE, this.__onTimerComplete);
            this._timer.stop();
            this._timer = null;
            for each (_local_1 in this._bitmapDatas)
            {
                _local_1.dispose();
                _local_1 = null;
            };
            if (((this._digit) && (this._digit.parent)))
            {
                this._digit.parent.removeChild(this._digit);
            };
            if (((this._tenDigit) && (this._tenDigit.parent)))
            {
                this._tenDigit.parent.removeChild(this._tenDigit);
            };
            this._digit = null;
            this._tenDigit = null;
            if (this.parent)
            {
                parent.removeChild(this);
            };
        }


    }
}//package game.view.card

