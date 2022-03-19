﻿// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//hall.CountDownShow

package hall
{
    import flash.display.Sprite;
    import flash.display.Bitmap;
    import com.pickgliss.ui.controls.BaseButton;
    import com.pickgliss.ui.text.FilterFrameText;
    import flash.utils.Timer;
    import store.data.ComposeCurrentInfo;
    import store.data.ComposeItemInfo;
    import com.pickgliss.ui.ComponentFactory;
    import ddt.manager.LanguageMgr;
    import flash.events.MouseEvent;
    import com.greensock.TweenMax;
    import store.StoreController;
    import store.events.StoreIIEvent;
    import ddt.manager.PlayerManager;
    import ddt.manager.SoundManager;
    import store.view.Compose.ComposeController;
    import com.pickgliss.ui.AlertManager;
    import com.pickgliss.ui.LayerManager;
    import com.pickgliss.ui.controls.alert.BaseAlerFrame;
    import com.pickgliss.events.FrameEvent;
    import ddt.manager.LeavePageManager;
    import ddt.manager.SocketManager;
    import com.pickgliss.utils.ObjectUtils;
    import flash.events.TimerEvent;

    public class CountDownShow extends Sprite 
    {

        public var START_COMPOSE:int = 0;
        public var COMPLETE_COMPOSE:int = 3;
        public var ACCELERATE_COMPOSE:int = 1;
        public var GET_ITEM:int = 2;
        private var _timeBg:Bitmap;
        private var _timeBtn:BaseButton;
        private var _timeText:FilterFrameText;
        private var _getBtn:BaseButton;
        private var _type:int = 40;
        private var _remainTime:int;
        private var _timer:Timer;
        private var _info:ComposeCurrentInfo;
        private var _equipComposeInfo:ComposeItemInfo;

        public function CountDownShow()
        {
            this.intView();
            this.intEvent();
        }

        private function intView():void
        {
            this._timeBg = ComponentFactory.Instance.creatBitmap("asset.hall.countDonwShow.timeBg");
            addChild(this._timeBg);
            this._timeBtn = ComponentFactory.Instance.creatComponentByStylename("hall.countDonwShow.timeBtn");
            addChild(this._timeBtn);
            this._getBtn = ComponentFactory.Instance.creatComponentByStylename("hall.countDonwShow.getBtn");
            this._getBtn.visible = false;
            addChild(this._getBtn);
            this._timeText = ComponentFactory.Instance.creatComponentByStylename("hall.countDonwShow.timeText");
            this._timeText.text = LanguageMgr.GetTranslation("store.StoreIIComposeBG.showTimeText");
            addChild(this._timeText);
        }

        public function setType(_arg_1:int):void
        {
            this._type = _arg_1;
        }

        private function intEvent():void
        {
            this._timeBtn.addEventListener(MouseEvent.CLICK, this.__accelerate);
            this._getBtn.addEventListener(MouseEvent.CLICK, this.__getItem);
        }

        private function showEffect():void
        {
            TweenMax.to(this, 0.5, {
                "repeat":-1,
                "yoyo":true,
                "glowFilter":{
                    "color":16777011,
                    "alpha":1,
                    "blurX":8,
                    "blurY":8,
                    "strength":3,
                    "inner":true
                }
            });
        }

        private function hideEffect():void
        {
            TweenMax.killChildTweensOf(this.parent, false);
            this.filters = null;
        }

        private function __composeStart(_arg_1:StoreIIEvent):void
        {
            if (this._type != StoreController.instance.Model.currentComposeItem.type)
            {
                return;
            };
            this.startTimer();
        }

        private function __getItemsComplete(_arg_1:StoreIIEvent):void
        {
            if ((!(PlayerManager.Instance.Self.getCurComposeInfoByType(this._type))))
            {
                this.hide();
                this.hideEffect();
            };
        }

        private function __accelerateDone(_arg_1:StoreIIEvent):void
        {
            this.removeTime();
            this.showEffect();
            this._getBtn.visible = true;
            this._timeBtn.visible = false;
            this._timeText.text = LanguageMgr.GetTranslation("store.StoreIIComposeBG.timeComplete");
        }

        private function __accelerate(_arg_1:MouseEvent):void
        {
            SoundManager.instance.play("008");
            this._equipComposeInfo = ComposeController.instance.model.composeItemInfoDic[this._info.templeteID];
            var _local_2:BaseAlerFrame = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("tips"), LanguageMgr.GetTranslation("store.StoreIIcompose.composeItemView.accelerateAlert", this._equipComposeInfo.TimeNeedMoney), LanguageMgr.GetTranslation("ok"), LanguageMgr.GetTranslation("cancel"), false, true, false, LayerManager.ALPHA_BLOCKGOUND);
            _local_2.addEventListener(FrameEvent.RESPONSE, this.__onFeedResponse);
        }

        private function __onFeedResponse(_arg_1:FrameEvent):void
        {
            SoundManager.instance.play("008");
            switch (_arg_1.responseCode)
            {
                case FrameEvent.ESC_CLICK:
                case FrameEvent.CLOSE_CLICK:
                case FrameEvent.CANCEL_CLICK:
                    break;
                case FrameEvent.SUBMIT_CLICK:
                case FrameEvent.ENTER_CLICK:
                    if (PlayerManager.Instance.Self.Money < Number(this._equipComposeInfo.TimeNeedMoney))
                    {
                        LeavePageManager.showFillFrame();
                        return;
                    };
                    SocketManager.Instance.out.sendItemCompose(this.ACCELERATE_COMPOSE, this._info.templeteID, this._info.count);
                    break;
            };
            _arg_1.currentTarget.removeEventListener(FrameEvent.RESPONSE, this.__onFeedResponse);
            ObjectUtils.disposeObject(_arg_1.currentTarget);
        }

        private function __getItem(_arg_1:MouseEvent):void
        {
            SoundManager.instance.play("008");
            SocketManager.Instance.out.sendItemCompose(this.GET_ITEM, this._info.templeteID, this._info.count);
        }

        public function show():void
        {
            this._getBtn.visible = false;
            this._timeBtn.visible = true;
            this.visible = true;
        }

        public function hide():void
        {
            this.visible = false;
        }

        public function startTimer():void
        {
            if (this._timer)
            {
                this._timer.stop();
                this._timer.removeEventListener(TimerEvent.TIMER, this.__tick);
                this._timer.removeEventListener(TimerEvent.TIMER_COMPLETE, this.__tickComplete);
                this._timer = null;
            };
            this._info = PlayerManager.Instance.Self.getCurComposeInfoByType(this._type);
            this._remainTime = this._info.remainTime;
            if (this._remainTime <= 0)
            {
                this._getBtn.visible = true;
                this._timeBtn.visible = false;
                this._timeText.text = LanguageMgr.GetTranslation("store.StoreIIComposeBG.timeComplete");
                this.visible = true;
            }
            else
            {
                this.show();
                this.__tick(null);
                this._timer = new Timer(1000, this._remainTime);
                this._timer.addEventListener(TimerEvent.TIMER, this.__tick);
                this._timer.addEventListener(TimerEvent.TIMER_COMPLETE, this.__tickComplete);
                this._timer.start();
            };
        }

        private function __tick(_arg_1:TimerEvent):void
        {
            this._remainTime = (this._remainTime - 1);
            PlayerManager.Instance.Self.lastComposeDic[this._info.templeteID].remainTime = this._remainTime;
            this._timeText.text = (LanguageMgr.GetTranslation("store.StoreIIComposeBG.showTimeText") + this.getTimeDiff(this._remainTime));
        }

        private function __tickComplete(_arg_1:TimerEvent):void
        {
            this.removeTime();
            this.showEffect();
            this._getBtn.visible = true;
            this._timeBtn.visible = false;
            this._timeText.text = LanguageMgr.GetTranslation("store.StoreIIComposeBG.timeComplete");
        }

        private function getTimeDiff(_arg_1:int):String
        {
            var _local_2:uint;
            var _local_3:uint;
            var _local_4:uint;
            if (_arg_1 >= 0)
            {
                _local_2 = uint(Math.floor(((_arg_1 / 60) / 60)));
                _arg_1 = (_arg_1 % (60 * 60));
                _local_3 = uint(Math.floor((_arg_1 / 60)));
                _arg_1 = (_arg_1 % 60);
                _local_4 = _arg_1;
            };
            return ((((this.fixZero(_local_2) + ":") + this.fixZero(_local_3)) + ":") + this.fixZero(_local_4));
        }

        private function fixZero(_arg_1:uint):String
        {
            return ((_arg_1 < 10) ? ("0" + String(_arg_1)) : String(_arg_1));
        }

        private function removeTime():void
        {
            if ((!(this._timer)))
            {
                return;
            };
            this._timer.stop();
            this._timer.removeEventListener(TimerEvent.TIMER, this.__tick);
            this._timer.removeEventListener(TimerEvent.TIMER_COMPLETE, this.__tickComplete);
            this._timer = null;
        }

        public function dispose():void
        {
            this.removeTime();
            this._timeBtn.removeEventListener(MouseEvent.CLICK, this.__accelerate);
            this._getBtn.removeEventListener(MouseEvent.CLICK, this.__getItem);
            if (this._timeBg)
            {
                ObjectUtils.disposeObject(this._timeBg);
            };
            this._timeBg = null;
            if (this._timeBtn)
            {
                ObjectUtils.disposeObject(this._timeBtn);
            };
            this._timeBtn = null;
            if (this._getBtn)
            {
                ObjectUtils.disposeObject(this._getBtn);
            };
            this._getBtn = null;
            if (this._timeText)
            {
                ObjectUtils.disposeObject(this._timeText);
            };
            this._timeText = null;
        }


    }
}//package hall
