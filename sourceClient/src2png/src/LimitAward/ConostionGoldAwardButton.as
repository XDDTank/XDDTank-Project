// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//LimitAward.ConostionGoldAwardButton

package LimitAward
{
    import com.pickgliss.ui.core.Component;
    import flash.display.Bitmap;
    import com.pickgliss.ui.image.ScaleFrameImage;
    import com.pickgliss.ui.text.FilterFrameText;
    import ddt.view.tips.OneLineTip;
    import ddt.data.BuffInfo;
    import com.pickgliss.ui.ComponentFactory;
    import ddt.manager.PlayerManager;
    import ddt.manager.TimeManager;
    import ddt.events.TimeEvents;
    import flash.events.MouseEvent;
    import ddt.manager.SoundManager;
    import flash.geom.Point;
    import consortion.ConosrtionTimerManager;
    import ddt.manager.LanguageMgr;
    import com.pickgliss.ui.LayerManager;
    import com.pickgliss.utils.ObjectUtils;

    public class ConostionGoldAwardButton extends Component 
    {

        private var _timeBg:Bitmap;
        private var _btnBg:ScaleFrameImage;
        private var _timerTxt:FilterFrameText;
        private var _tips:OneLineTip;
        private var _tipsTxt:FilterFrameText;
        private var _buffinfo:BuffInfo;

        public function ConostionGoldAwardButton()
        {
            this.initView();
            this.initEvent();
        }

        private function initView():void
        {
            buttonMode = true;
            this._btnBg = ComponentFactory.Instance.creatComponentByStylename("ddtconsortion.GoldBtn");
            this._timeBg = ComponentFactory.Instance.creatBitmap("asset.ddthall.goldBox.timeBG");
            this._btnBg.setFrame(1);
            this._timerTxt = ComponentFactory.Instance.creatComponentByStylename("Consorionshop.goldtimerTxt");
            this._tipsTxt = ComponentFactory.Instance.creatComponentByStylename("Consorionshop.goldtimerTxt");
            this._tips = new OneLineTip();
            this._tips.visible = false;
            this._buffinfo = PlayerManager.Instance.Self.buffInfo[BuffInfo.GET_ONLINE_REWARS];
            this._btnBg.buttonMode = true;
            addChild(this._btnBg);
            addChild(this._timeBg);
            addChild(this._timerTxt);
        }

        private function initEvent():void
        {
            TimeManager.addEventListener(TimeEvents.SECONDS, this.__upTimer);
            addEventListener(MouseEvent.CLICK, this.__openAwardFrame);
            addEventListener(MouseEvent.MOUSE_OVER, this.__mouseOver);
            addEventListener(MouseEvent.MOUSE_OUT, this.__mouseOut);
        }

        private function removeEvent():void
        {
            TimeManager.removeEventListener(TimeEvents.SECONDS, this.__upTimer);
            removeEventListener(MouseEvent.CLICK, this.__openAwardFrame);
            removeEventListener(MouseEvent.MOUSE_OVER, this.__mouseOver);
            removeEventListener(MouseEvent.MOUSE_OUT, this.__mouseOut);
        }

        private function __openAwardFrame(_arg_1:MouseEvent):void
        {
            SoundManager.instance.play("008");
            if (this._tips)
            {
                this._tips.visible = false;
            };
            var _local_2:ConsortionAwardFrame = ComponentFactory.Instance.creatComponentByStylename("ConsortionAwardFrame");
            _local_2.show();
        }

        private function __mouseOver(_arg_1:MouseEvent):void
        {
            var _local_2:String;
            var _local_3:Array;
            var _local_4:int;
            var _local_5:Point;
            if (this._tips)
            {
                _local_2 = TimeManager.Instance.formatTimeToString1((ConosrtionTimerManager.Instance.count * 1000), false);
                _local_3 = _local_2.split(":");
                this._tipsTxt.htmlText = LanguageMgr.GetTranslation("ddt.consortionGold.awardTips", _local_3[0], _local_3[1], this._buffinfo.Value);
                _local_4 = (ConosrtionTimerManager.Instance.count * 1000);
                if (((this._buffinfo) && (_local_4 > 0)))
                {
                    this._tips.tipData = this._tipsTxt.text;
                }
                else
                {
                    this._tips.tipData = "你今日累积在线满1小时,请领取奖励";
                };
                this._tips.visible = true;
                LayerManager.Instance.addToLayer(this._tips, LayerManager.GAME_TOP_LAYER);
                _local_5 = this._btnBg.localToGlobal(new Point(0, 0));
                this._tips.x = (_local_5.x - 168);
                this._tips.y = (_local_5.y + 60);
            };
        }

        private function __mouseOut(_arg_1:MouseEvent):void
        {
            if (this._tips)
            {
                this._tips.visible = false;
            };
        }

        private function __upTimer(_arg_1:TimeEvents):void
        {
            var _local_2:String = TimeManager.Instance.formatTimeToString1((ConosrtionTimerManager.Instance.count * 1000), false);
            var _local_3:int = (ConosrtionTimerManager.Instance.count * 1000);
            this._timerTxt.text = _local_2;
            if (_local_3 <= 0)
            {
                this._btnBg.setFrame(2);
                this._timerTxt.visible = false;
                this._timeBg.visible = false;
                TimeManager.removeEventListener(TimeEvents.SECONDS, this.__upTimer);
            };
        }

        override public function dispose():void
        {
            this.removeEvent();
            ObjectUtils.disposeAllChildren(this);
            this._btnBg = null;
            this._timeBg = null;
            if (this._tips)
            {
                if (this._tips.parent)
                {
                    this._tips.parent.removeChild(this._tips);
                    ObjectUtils.disposeObject(this._tips);
                };
            };
            this._tips = null;
            if (this.parent)
            {
                this.parent.removeChild(this);
            };
        }


    }
}//package LimitAward

