// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//consortion.transportSence.TransportHijackWaitTime

package consortion.transportSence
{
    import flash.display.Sprite;
    import com.pickgliss.ui.core.Disposeable;
    import flash.display.Shape;
    import flash.display.Bitmap;
    import flash.display.MovieClip;
    import com.pickgliss.ui.ComponentFactory;
    import ddt.manager.TimeManager;
    import ddt.events.TimeEvents;
    import com.pickgliss.utils.ObjectUtils;

    public class TransportHijackWaitTime extends Sprite implements Disposeable 
    {

        private var _bgShape:Shape;
        private var _timeBG:Bitmap;
        private var _timeBgTxt:Bitmap;
        private var _timeCD:MovieClip;
        private var _totalTime:uint = 10;

        public function TransportHijackWaitTime()
        {
            this.initView();
            this.addEvent();
        }

        private function initView():void
        {
            this._bgShape = new Shape();
            this._bgShape.graphics.beginFill(1, 0);
            this._bgShape.graphics.drawRect(0, 0, 1000, 600);
            this._bgShape.graphics.endFill();
            this._timeBG = ComponentFactory.Instance.creatBitmap("asset.consortiontransport.hijack.waitTime");
            this._timeBgTxt = ComponentFactory.Instance.creatBitmap("asset.consortiontransport.hijack.waitTime.txt");
            this._timeCD = ComponentFactory.Instance.creat("asset.consortionConvoy.hijack.timeCD");
            addChild(this._bgShape);
            addChild(this._timeBG);
            addChild(this._timeBgTxt);
            addChild(this._timeCD);
            (this._timeCD["timeSecond2"] as MovieClip).gotoAndStop("num_1");
            (this._timeCD["timeSecond"] as MovieClip).gotoAndStop("num_0");
        }

        private function addEvent():void
        {
            TimeManager.addEventListener(TimeEvents.SECONDS, this.__timeCount);
        }

        private function removeEvent():void
        {
            TimeManager.removeEventListener(TimeEvents.SECONDS, this.__timeCount);
        }

        private function __timeCount(_arg_1:TimeEvents):void
        {
            if (this._totalTime <= 0)
            {
                this.dispose();
                return;
            };
            var _local_2:String = this.setFormat(this._totalTime);
            (this._timeCD["timeSecond2"] as MovieClip).gotoAndStop(("num_" + _local_2.charAt(0)));
            (this._timeCD["timeSecond"] as MovieClip).gotoAndStop(("num_" + _local_2.charAt(1)));
            this._totalTime--;
        }

        private function setFormat(_arg_1:int):String
        {
            var _local_2:String;
            if (_arg_1 >= 10)
            {
                _local_2 = String(_arg_1);
            }
            else
            {
                _local_2 = ("0" + _arg_1);
            };
            return (_local_2);
        }

        public function dispose():void
        {
            this.removeEvent();
            ObjectUtils.disposeObject(this._bgShape);
            this._bgShape = null;
            ObjectUtils.disposeObject(this._timeBG);
            this._timeBG = null;
            ObjectUtils.disposeObject(this._timeBgTxt);
            this._timeBgTxt = null;
            ObjectUtils.disposeObject(this._timeCD);
            this._timeCD = null;
            if (this.parent)
            {
                this.parent.removeChild(this);
            };
        }


    }
}//package consortion.transportSence

