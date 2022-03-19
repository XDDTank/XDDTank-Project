// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//worldboss.view.WorldBossCountDownView

package worldboss.view
{
    import flash.display.Sprite;
    import com.pickgliss.ui.core.Disposeable;
    import com.pickgliss.ui.image.ScaleBitmapImage;
    import flash.display.MovieClip;
    import flash.utils.Timer;
    import com.pickgliss.ui.ComponentFactory;
    import ddt.manager.TimeManager;
    import ddt.events.TimeEvents;
    import worldboss.WorldBossManager;
    import com.pickgliss.utils.ObjectUtils;

    public class WorldBossCountDownView extends Sprite implements Disposeable 
    {

        private var _bg:ScaleBitmapImage;
        private var _timeCD:MovieClip;
        private var timer:Timer;
        private var _beginTime:Date;

        public function WorldBossCountDownView(_arg_1:Date)
        {
            this.init();
            this.intEvent();
            this._beginTime = _arg_1;
        }

        private function init():void
        {
            this._bg = ComponentFactory.Instance.creat("worldBossCountDownBg");
            addChild(this._bg);
            this._timeCD = ComponentFactory.Instance.creat("asset.worldboosCountDown.timeCD");
            addChild(this._timeCD);
        }

        private function intEvent():void
        {
            TimeManager.addEventListener(TimeEvents.SECONDS, this.__startCount);
        }

        public function __startCount(_arg_1:TimeEvents):void
        {
            if (WorldBossManager.Instance.isOpen)
            {
                this.dispose();
                return;
            };
            var _local_2:Date = TimeManager.Instance.Now();
            var _local_3:Date = new Date(_local_2.fullYear, _local_2.month, _local_2.date, this._beginTime.hours, this._beginTime.minutes, this._beginTime.seconds, this._beginTime.milliseconds);
            var _local_4:Number = (_local_3.time - _local_2.time);
            var _local_5:int = int(((_local_4 % TimeManager.HOUR_TICKS) / TimeManager.Minute_TICKS));
            var _local_6:int = int(((_local_4 % TimeManager.Minute_TICKS) / TimeManager.Second_TICKS));
            if (_local_4 <= 0)
            {
                this.dispose();
                return;
            };
            var _local_7:String = ((this.setFormat(_local_5) + ":") + this.setFormat(_local_6));
            (this._timeCD["timeMint2"] as MovieClip).gotoAndStop(("num_" + _local_7.charAt(0)));
            (this._timeCD["timeMint"] as MovieClip).gotoAndStop(("num_" + _local_7.charAt(1)));
            (this._timeCD["timeSecond2"] as MovieClip).gotoAndStop(("num_" + _local_7.charAt(3)));
            (this._timeCD["timeSecond"] as MovieClip).gotoAndStop(("num_" + _local_7.charAt(4)));
        }

        private function setFormat(_arg_1:int):String
        {
            var _local_2:String = _arg_1.toString();
            if (_arg_1 < 10)
            {
                _local_2 = ("0" + _local_2);
            };
            return (_local_2);
        }

        private function removeEvent():void
        {
            TimeManager.removeEventListener(TimeEvents.SECONDS, this.__startCount);
        }

        public function dispose():void
        {
            this.removeEvent();
            if (this._bg)
            {
                ObjectUtils.disposeObject(this._bg);
                this._bg = null;
            };
            if (this._timeCD)
            {
                ObjectUtils.disposeObject(this._timeCD);
                this._timeCD = null;
            };
        }


    }
}//package worldboss.view

