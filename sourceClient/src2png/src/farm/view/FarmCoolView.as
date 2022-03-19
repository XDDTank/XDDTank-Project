// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//farm.view.FarmCoolView

package farm.view
{
    import flash.display.Sprite;
    import com.pickgliss.ui.core.Disposeable;
    import ddt.manager.ServerConfigManager;
    import com.pickgliss.ui.image.ScaleBitmapImage;
    import com.pickgliss.ui.controls.BaseButton;
    import flash.display.MovieClip;
    import com.pickgliss.ui.text.FilterFrameText;
    import flash.utils.Timer;
    import com.pickgliss.ui.controls.alert.BaseAlerFrame;
    import com.pickgliss.ui.ComponentFactory;
    import ddt.manager.LanguageMgr;
    import flash.events.TimerEvent;
    import flash.events.MouseEvent;
    import ddt.manager.SoundManager;
    import ddt.manager.PlayerManager;
    import baglocked.BaglockedManager;
    import com.pickgliss.ui.vo.AlertInfo;
    import com.pickgliss.ui.AlertManager;
    import com.pickgliss.ui.LayerManager;
    import com.pickgliss.events.FrameEvent;
    import farm.FarmModelController;
    import ddt.manager.LeavePageManager;
    import com.pickgliss.utils.ObjectUtils;
    import flash.events.Event;

    public class FarmCoolView extends Sprite implements Disposeable 
    {

        public const COST:int = int(ServerConfigManager.instance.findInfoByName(ServerConfigManager.FARM_REFRESH_MONEY).Value);

        private var _bg:ScaleBitmapImage;
        private var _resurrectBtn:BaseButton;
        private var _timeCD:MovieClip;
        private var _txtProp:FilterFrameText;
        private var _totalCount:int;
        private var timer:Timer;
        private var alert:BaseAlerFrame;

        public function FarmCoolView(_arg_1:int)
        {
            this._totalCount = _arg_1;
            this.init();
            this.addEvent();
        }

        private function init():void
        {
            this._bg = ComponentFactory.Instance.creat("farm.coolView.bg");
            addChild(this._bg);
            this._txtProp = ComponentFactory.Instance.creat("farm.coolView.timeTxt");
            addChild(this._txtProp);
            this._txtProp.text = LanguageMgr.GetTranslation("ddt.farms.coolView.prop");
            this._resurrectBtn = ComponentFactory.Instance.creat("farm.coolView.coolBtn");
            addChild(this._resurrectBtn);
            this._timeCD = ComponentFactory.Instance.creat("farm.coolView.timeCD");
            addChild(this._timeCD);
            this.__startCount(null);
            this.timer = new Timer(1000, (this._totalCount + 1));
            this.timer.addEventListener(TimerEvent.TIMER, this.__startCount);
            this.timer.addEventListener(TimerEvent.TIMER_COMPLETE, this.__timerComplete);
            this.timer.start();
        }

        private function addEvent():void
        {
            this._resurrectBtn.addEventListener(MouseEvent.CLICK, this.__coolDown);
        }

        private function getCostMoney():int
        {
            return (0);
        }

        private function __coolDown(_arg_1:MouseEvent):void
        {
            SoundManager.instance.play("008");
            if (PlayerManager.Instance.Self.bagLocked)
            {
                BaglockedManager.Instance.show();
                return;
            };
            var _local_2:AlertInfo = new AlertInfo();
            _local_2.title = LanguageMgr.GetTranslation("AlertDialog.Info");
            _local_2.data = LanguageMgr.GetTranslation("ddt.farms.coolView.propMoney", this.getCostMoney());
            _local_2.enableHtml = true;
            _local_2.moveEnable = false;
            this.alert = AlertManager.Instance.alert("SimpleAlert", _local_2, LayerManager.ALPHA_BLOCKGOUND);
            this.alert.addEventListener(FrameEvent.RESPONSE, this.__onAlertResponse);
        }

        private function __startCount(_arg_1:TimerEvent):void
        {
            if (this._totalCount < 0)
            {
                this.__timerComplete();
                return;
            };
            if ((this._totalCount % 60) == 0)
            {
                FarmModelController.instance.refreshFarm();
            };
            var _local_2:String = ((((this.setFormat(int((this._totalCount / 3600))) + ":") + this.setFormat(int(((this._totalCount / 60) % 60)))) + ":") + this.setFormat(int((this._totalCount % 60))));
            (this._timeCD["timeHour2"] as MovieClip).gotoAndStop(("num_" + _local_2.charAt(0)));
            (this._timeCD["timeHour"] as MovieClip).gotoAndStop(("num_" + _local_2.charAt(1)));
            (this._timeCD["timeMint2"] as MovieClip).gotoAndStop(("num_" + _local_2.charAt(3)));
            (this._timeCD["timeMint"] as MovieClip).gotoAndStop(("num_" + _local_2.charAt(4)));
            (this._timeCD["timeSecond2"] as MovieClip).gotoAndStop(("num_" + _local_2.charAt(6)));
            (this._timeCD["timeSecond"] as MovieClip).gotoAndStop(("num_" + _local_2.charAt(7)));
            this._totalCount--;
        }

        private function removeEvent():void
        {
            this._resurrectBtn.removeEventListener(MouseEvent.CLICK, this.__coolDown);
        }

        private function __onAlertResponse(_arg_1:FrameEvent):void
        {
            var _local_2:BaseAlerFrame;
            SoundManager.instance.play("008");
            this.alert.removeEventListener(FrameEvent.RESPONSE, this.__onAlertResponse);
            this.alert.dispose();
            switch (_arg_1.responseCode)
            {
                case FrameEvent.ENTER_CLICK:
                case FrameEvent.SUBMIT_CLICK:
                    if (PlayerManager.Instance.Self.totalMoney < this.getCostMoney())
                    {
                        _local_2 = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"), LanguageMgr.GetTranslation("tank.view.comon.lack"), LanguageMgr.GetTranslation("ok"), LanguageMgr.GetTranslation("cancel"), false, false, false, LayerManager.ALPHA_BLOCKGOUND);
                        _local_2.moveEnable = false;
                        _local_2.addEventListener(FrameEvent.RESPONSE, this._responseI);
                    };
                    return;
                case FrameEvent.CANCEL_CLICK:
                case FrameEvent.CLOSE_CLICK:
                case FrameEvent.ESC_CLICK:
                    return;
            };
        }

        private function _responseI(_arg_1:FrameEvent):void
        {
            SoundManager.instance.play("008");
            if (_arg_1.responseCode == FrameEvent.SUBMIT_CLICK)
            {
                LeavePageManager.leaveToFillPath();
            };
            ObjectUtils.disposeObject(_arg_1.target);
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

        private function __timerComplete(_arg_1:TimerEvent=null):void
        {
            dispatchEvent(new Event(Event.COMPLETE));
        }

        public function dispose():void
        {
            this.removeEvent();
            this.timer.stop();
            this.timer.removeEventListener(TimerEvent.TIMER, this.__startCount);
            this.timer.removeEventListener(TimerEvent.TIMER_COMPLETE, this.__timerComplete);
            this.timer = null;
            if (this.alert)
            {
                this.alert.dispose();
            };
            ObjectUtils.disposeAllChildren(this);
            if (parent)
            {
                this.parent.removeChild(this);
            };
            this._bg = null;
            this._txtProp = null;
            this._resurrectBtn = null;
            this._timeCD = null;
        }


    }
}//package farm.view

