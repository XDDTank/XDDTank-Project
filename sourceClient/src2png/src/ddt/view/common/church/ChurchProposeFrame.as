// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//ddt.view.common.church.ChurchProposeFrame

package ddt.view.common.church
{
    import com.pickgliss.ui.controls.alert.BaseAlerFrame;
    import com.pickgliss.ui.image.MutipleImage;
    import com.pickgliss.ui.vo.AlertInfo;
    import com.pickgliss.ui.text.TextArea;
    import com.pickgliss.ui.controls.SelectedIconButton;
    import com.pickgliss.ui.text.FilterFrameText;
    import ddt.manager.LanguageMgr;
    import com.pickgliss.ui.ComponentFactory;
    import com.pickgliss.events.FrameEvent;
    import flash.events.Event;
    import flash.events.MouseEvent;
    import ddt.manager.SoundManager;
    import ddt.manager.PathManager;
    import ddt.manager.PlayerManager;
    import ddt.data.BagInfo;
    import ddt.utils.FilterWordManager;
    import ddt.manager.SocketManager;
    import com.pickgliss.ui.LayerManager;

    public class ChurchProposeFrame extends BaseAlerFrame 
    {

        private var _bg:MutipleImage;
        private var _alertInfo:AlertInfo;
        private var _txtInfo:TextArea;
        private var _chkSysMsg:SelectedIconButton;
        private var _buyRingFrame:ChurchBuyRingFrame;
        private var _spouseID:int;
        private var useBugle:Boolean;
        private var _noticeText:FilterFrameText;
        private var _blessingText:FilterFrameText;

        public function ChurchProposeFrame()
        {
            this.initialize();
            this.addEvent();
        }

        public function get spouseID():int
        {
            return (this._spouseID);
        }

        public function set spouseID(_arg_1:int):void
        {
            this._spouseID = _arg_1;
        }

        private function initialize():void
        {
            this._alertInfo = new AlertInfo();
            this._alertInfo.title = LanguageMgr.GetTranslation("tank.view.common.church.ProposeResponseFrame.titleText");
            this._alertInfo.moveEnable = false;
            info = this._alertInfo;
            this.escEnable = true;
            this._bg = ComponentFactory.Instance.creatComponentByStylename("church.ChurchProposeFrame.bg");
            addToContent(this._bg);
            this._noticeText = ComponentFactory.Instance.creat("church.ChurchProposeFrame.noticeText");
            this._noticeText.text = LanguageMgr.GetTranslation("church.ChurchProposeFrame.noticeText.text");
            addToContent(this._noticeText);
            this._blessingText = ComponentFactory.Instance.creat("church.ChurchProposeFrame.blessingText");
            this._blessingText.text = LanguageMgr.GetTranslation("church.ChurchProposeFrame.blessingText.text");
            addToContent(this._blessingText);
            this._txtInfo = ComponentFactory.Instance.creat("common.church.txtChurchProposeFrameAsset");
            this._txtInfo.maxChars = 300;
            addToContent(this._txtInfo);
            this._chkSysMsg = ComponentFactory.Instance.creat("common.church.chkChurchProposeFrameAsset");
            this._chkSysMsg.selected = true;
            addToContent(this._chkSysMsg);
            this.useBugle = this._chkSysMsg.selected;
        }

        private function addEvent():void
        {
            addEventListener(FrameEvent.RESPONSE, this.onFrameResponse);
            this._chkSysMsg.addEventListener(Event.SELECT, this.__checkClick);
            this._chkSysMsg.addEventListener(MouseEvent.CLICK, this.getFocus);
            this._txtInfo.addEventListener(Event.CHANGE, this.__input);
            this._txtInfo.addEventListener(Event.ADDED_TO_STAGE, this.__addToStages);
        }

        private function onFrameResponse(_arg_1:FrameEvent):void
        {
            switch (_arg_1.responseCode)
            {
                case FrameEvent.CANCEL_CLICK:
                case FrameEvent.CLOSE_CLICK:
                case FrameEvent.ESC_CLICK:
                    SoundManager.instance.play("008");
                    this.dispose();
                    return;
                case FrameEvent.ENTER_CLICK:
                case FrameEvent.SUBMIT_CLICK:
                    SoundManager.instance.play("008");
                    if (PathManager.solveChurchEnable())
                    {
                        this.confirmSubmit();
                    };
                    return;
            };
        }

        private function removeEvent():void
        {
            removeEventListener(FrameEvent.RESPONSE, this.onFrameResponse);
            this._chkSysMsg.removeEventListener(Event.CHANGE, this.__checkClick);
            this._chkSysMsg.removeEventListener(MouseEvent.CLICK, this.getFocus);
            this._txtInfo.removeEventListener(Event.CHANGE, this.__input);
            this._txtInfo.removeEventListener(Event.ADDED_TO_STAGE, this.__addToStages);
        }

        private function __checkClick(_arg_1:Event):void
        {
            SoundManager.instance.play("008");
            this.useBugle = this._chkSysMsg.selected;
        }

        private function getFocus(_arg_1:MouseEvent):void
        {
            SoundManager.instance.play("008");
            if (stage)
            {
                stage.focus = this;
            };
        }

        private function __addToStages(_arg_1:Event):void
        {
            this._txtInfo.stage.focus = this._txtInfo;
            this._txtInfo.text = "";
        }

        private function __input(_arg_1:Event):void
        {
            var _local_2:int = this._txtInfo.text.length;
        }

        private function confirmSubmit():void
        {
            var _local_1:String;
            if ((!(PlayerManager.Instance.Self.getBag(BagInfo.EQUIPBAG).findFistItemByTemplateId(11103))))
            {
                _local_1 = FilterWordManager.filterWrod(this._txtInfo.text);
                this._buyRingFrame = ComponentFactory.Instance.creat("common.church.ChurchBuyRingFrame");
                this._buyRingFrame.addEventListener(Event.CLOSE, this.buyRingFrameClose);
                this._buyRingFrame.spouseID = this.spouseID;
                this._buyRingFrame.proposeStr = _local_1;
                this._buyRingFrame.useBugle = this._chkSysMsg.selected;
                this._buyRingFrame.titleText = "提示";
                this._buyRingFrame.show();
                this.dispose();
                return;
            };
            this.sendPropose();
        }

        private function sendPropose():void
        {
            var _local_1:String = FilterWordManager.filterWrod(this._txtInfo.text);
            SocketManager.Instance.out.sendPropose(this._spouseID, _local_1, this.useBugle);
            this.dispose();
        }

        public function show():void
        {
            LayerManager.Instance.addToLayer(this, LayerManager.GAME_TOP_LAYER, true, LayerManager.BLCAK_BLOCKGOUND);
        }

        private function buyRingFrameClose(_arg_1:Event):void
        {
            if (this._buyRingFrame)
            {
                this._buyRingFrame.removeEventListener(Event.CLOSE, this.buyRingFrameClose);
                if (this._buyRingFrame.parent)
                {
                    this._buyRingFrame.parent.removeChild(this._buyRingFrame);
                };
                this._buyRingFrame.dispose();
            };
            this._buyRingFrame = null;
        }

        override public function dispose():void
        {
            super.dispose();
            this.removeEvent();
            if (this._bg)
            {
                if (this._bg.parent)
                {
                    this._bg.parent.removeChild(this._bg);
                };
            };
            this._bg = null;
            this._noticeText = null;
            this._blessingText = null;
            this._txtInfo = null;
            if (this._chkSysMsg)
            {
                if (this._chkSysMsg.parent)
                {
                    this._chkSysMsg.parent.removeChild(this._chkSysMsg);
                };
                this._chkSysMsg.dispose();
            };
            this._chkSysMsg = null;
            if (parent)
            {
                parent.removeChild(this);
            };
            dispatchEvent(new Event(Event.CLOSE));
        }


    }
}//package ddt.view.common.church

