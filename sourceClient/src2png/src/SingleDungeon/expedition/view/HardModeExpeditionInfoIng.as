// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//SingleDungeon.expedition.view.HardModeExpeditionInfoIng

package SingleDungeon.expedition.view
{
    import flash.display.Sprite;
    import com.pickgliss.ui.core.Disposeable;
    import com.pickgliss.ui.text.FilterFrameText;
    import flash.display.Bitmap;
    import SingleDungeon.expedition.ExpeditionInfo;
    import ddt.manager.PlayerManager;
    import com.pickgliss.ui.ComponentFactory;
    import com.pickgliss.utils.ObjectUtils;

    public class HardModeExpeditionInfoIng extends Sprite implements Disposeable 
    {

        private var _currentTimesText:FilterFrameText;
        private var _remainTimeText:FilterFrameText;
        private var _finishTime:Number;
        private var _fontBmp:Bitmap;
        private var _timerIsRunning:Boolean;
        private var _expeditionInfo:ExpeditionInfo;

        public function HardModeExpeditionInfoIng()
        {
            this.initView();
            this.initEvent();
        }

        public function update():void
        {
            this._currentTimesText.text = String(((PlayerManager.Instance.Self.expeditionNumAll - PlayerManager.Instance.Self.expeditionNumCur) + 1));
        }

        public function updateRemainTxt(_arg_1:String):void
        {
            this._remainTimeText.text = _arg_1;
        }

        private function initView():void
        {
            this._fontBmp = ComponentFactory.Instance.creatBitmap("asset.singleDungeon.hardMode.ingInfo");
            addChild(this._fontBmp);
            this._currentTimesText = ComponentFactory.Instance.creatComponentByStylename("singleDungeon.expedition.ExpeditionInfoIng.hardModeNowTimes.text");
            addChild(this._currentTimesText);
            this._remainTimeText = ComponentFactory.Instance.creatComponentByStylename("singleDungeon.expedition.ExpeditionInfoIng.hardModeRemainTime.text");
            addChild(this._remainTimeText);
        }

        private function removeView():void
        {
            ObjectUtils.disposeObject(this._remainTimeText);
            this._remainTimeText = null;
            ObjectUtils.disposeObject(this._currentTimesText);
            this._currentTimesText = null;
            ObjectUtils.disposeObject(this._remainTimeText);
            this._remainTimeText = null;
            ObjectUtils.disposeObject(this._fontBmp);
            this._fontBmp = null;
        }

        private function initEvent():void
        {
        }

        private function removeEvent():void
        {
        }

        public function dispose():void
        {
            this.removeEvent();
            this.removeView();
        }


    }
}//package SingleDungeon.expedition.view

