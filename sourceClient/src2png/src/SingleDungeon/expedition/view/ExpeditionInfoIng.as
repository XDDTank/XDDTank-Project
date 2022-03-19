// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//SingleDungeon.expedition.view.ExpeditionInfoIng

package SingleDungeon.expedition.view
{
    import flash.display.Sprite;
    import com.pickgliss.ui.core.Disposeable;
    import com.pickgliss.ui.text.FilterFrameText;
    import flash.utils.Timer;
    import flash.display.Bitmap;
    import ddt.manager.PlayerManager;
    import com.pickgliss.ui.ComponentFactory;
    import com.pickgliss.utils.ObjectUtils;

    public class ExpeditionInfoIng extends Sprite implements Disposeable 
    {

        private var _currentPowerText:FilterFrameText;
        private var _currentTimesText:FilterFrameText;
        private var _remainTimeText:FilterFrameText;
        private var _timer:Timer;
        private var _minutes:int;
        private var _seconds:int;
        private var _fontBmp:Bitmap;

        public function ExpeditionInfoIng()
        {
            this.initView();
        }

        public function update():void
        {
            this._currentPowerText.text = PlayerManager.Instance.Self.Fatigue.toString();
            this._currentTimesText.text = ((PlayerManager.Instance.Self.expeditionNumCur + "/") + PlayerManager.Instance.Self.expeditionNumAll);
        }

        public function updateRemainTxt(_arg_1:String):void
        {
            this._remainTimeText.text = _arg_1;
        }

        private function initView():void
        {
            this._fontBmp = ComponentFactory.Instance.creatBitmap("asset.singleDungeon.expedition.begin");
            addChild(this._fontBmp);
            this._currentPowerText = ComponentFactory.Instance.creatComponentByStylename("singleDungeon.expedition.ExpeditionInfoIng.nowEnergy.text");
            addChild(this._currentPowerText);
            this._currentTimesText = ComponentFactory.Instance.creatComponentByStylename("singleDungeon.expedition.ExpeditionInfoIng.nowTimes.text");
            addChild(this._currentTimesText);
            this._remainTimeText = ComponentFactory.Instance.creatComponentByStylename("singleDungeon.expedition.ExpeditionInfoIng.remainTime.text");
            addChild(this._remainTimeText);
        }

        private function removeView():void
        {
            if (this._currentPowerText)
            {
                ObjectUtils.disposeObject(this._remainTimeText);
                this._remainTimeText = null;
            };
            if (this._currentTimesText)
            {
                ObjectUtils.disposeObject(this._currentTimesText);
                this._currentTimesText = null;
            };
            if (this._remainTimeText)
            {
                ObjectUtils.disposeObject(this._remainTimeText);
                this._remainTimeText = null;
            };
            ObjectUtils.disposeObject(this._fontBmp);
            this._fontBmp = null;
        }

        public function dispose():void
        {
            this.removeView();
        }


    }
}//package SingleDungeon.expedition.view

