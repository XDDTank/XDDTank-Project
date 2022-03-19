// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//church.view.weddingRoom.frame.WeddingRoomContinuationView

package church.view.weddingRoom.frame
{
    import com.pickgliss.ui.controls.alert.BaseAlerFrame;
    import ddt.manager.ServerConfigManager;
    import com.pickgliss.ui.image.ScaleBitmapImage;
    import church.controller.ChurchRoomController;
    import com.pickgliss.ui.vo.AlertInfo;
    import com.pickgliss.ui.controls.SelectedButton;
    import com.pickgliss.ui.controls.SelectedButtonGroup;
    import ddt.manager.LanguageMgr;
    import com.pickgliss.ui.ComponentFactory;
    import platformapi.tencent.DiamondManager;
    import com.pickgliss.events.FrameEvent;
    import flash.events.MouseEvent;
    import ddt.manager.SoundManager;
    import ddt.manager.ChurchManager;
    import ddt.manager.PlayerManager;
    import ddt.manager.LeavePageManager;
    import com.pickgliss.ui.LayerManager;
    import flash.events.Event;

    public class WeddingRoomContinuationView extends BaseAlerFrame 
    {

        private static var _roomMoney:Array = ServerConfigManager.instance.findInfoByName(ServerConfigManager.MARRT_ROOM_CREATE_MONET).Value.split(",");

        private var _bg:ScaleBitmapImage;
        private var _controller:ChurchRoomController;
        private var _alertInfo:AlertInfo;
        private var _roomContinuationTime1SelectedBtn:SelectedButton;
        private var _roomContinuationTime2SelectedBtn:SelectedButton;
        private var _roomContinuationTime3SelectedBtn:SelectedButton;
        private var _roomContinuationTimeGroup:SelectedButtonGroup;
        private var _alert:BaseAlerFrame;

        public function WeddingRoomContinuationView()
        {
            this.initialize();
        }

        public function get controller():ChurchRoomController
        {
            return (this._controller);
        }

        public function set controller(_arg_1:ChurchRoomController):void
        {
            this._controller = _arg_1;
        }

        protected function initialize():void
        {
            this.setView();
            this.setEvent();
        }

        private function setView():void
        {
            this._alertInfo = new AlertInfo("", LanguageMgr.GetTranslation("ok"), LanguageMgr.GetTranslation("cancel"));
            this._alertInfo.moveEnable = false;
            this._alertInfo.title = LanguageMgr.GetTranslation("church.room.WeddingRoomContinuationView.title");
            info = this._alertInfo;
            this.escEnable = true;
            this._bg = ComponentFactory.Instance.creatComponentByStylename("church.room.continuationRoomFrameBgAsset");
            addToContent(this._bg);
            if (DiamondManager.instance.isInTencent)
            {
                this._roomContinuationTime1SelectedBtn = ComponentFactory.Instance.creat("asset.diamond.church.roomContinuationTime1SelectedBtn");
                this._roomContinuationTime2SelectedBtn = ComponentFactory.Instance.creat("asset.diamond.church.roomContinuationTime2SelectedBtn");
                this._roomContinuationTime3SelectedBtn = ComponentFactory.Instance.creat("asset.diamond.church.roomContinuationTime3SelectedBtn");
            }
            else
            {
                this._roomContinuationTime1SelectedBtn = ComponentFactory.Instance.creat("asset.church.roomContinuationTime1SelectedBtn");
                this._roomContinuationTime2SelectedBtn = ComponentFactory.Instance.creat("asset.church.roomContinuationTime2SelectedBtn");
                this._roomContinuationTime3SelectedBtn = ComponentFactory.Instance.creat("asset.church.roomContinuationTime3SelectedBtn");
            };
            addToContent(this._roomContinuationTime1SelectedBtn);
            addToContent(this._roomContinuationTime2SelectedBtn);
            addToContent(this._roomContinuationTime3SelectedBtn);
            this._roomContinuationTimeGroup = new SelectedButtonGroup(false);
            this._roomContinuationTimeGroup.addSelectItem(this._roomContinuationTime1SelectedBtn);
            this._roomContinuationTimeGroup.addSelectItem(this._roomContinuationTime2SelectedBtn);
            this._roomContinuationTimeGroup.addSelectItem(this._roomContinuationTime3SelectedBtn);
            this._roomContinuationTimeGroup.selectIndex = 0;
            this._roomContinuationTime1SelectedBtn.filters = ComponentFactory.Instance.creatFilters("lightFilter");
            this._roomContinuationTime2SelectedBtn.filters = ComponentFactory.Instance.creatFilters("grayFilter");
            this._roomContinuationTime3SelectedBtn.filters = ComponentFactory.Instance.creatFilters("grayFilter");
        }

        private function setEvent():void
        {
            addEventListener(FrameEvent.RESPONSE, this.onFrameResponse);
            this._roomContinuationTime1SelectedBtn.addEventListener(MouseEvent.CLICK, this.onBtnClick1);
            this._roomContinuationTime2SelectedBtn.addEventListener(MouseEvent.CLICK, this.onBtnClick2);
            this._roomContinuationTime3SelectedBtn.addEventListener(MouseEvent.CLICK, this.onBtnClick3);
        }

        private function onBtnClick1(_arg_1:MouseEvent):void
        {
            SoundManager.instance.play("008");
            this._roomContinuationTime1SelectedBtn.filters = ComponentFactory.Instance.creatFilters("lightFilter");
            this._roomContinuationTime2SelectedBtn.filters = ComponentFactory.Instance.creatFilters("grayFilter");
            this._roomContinuationTime3SelectedBtn.filters = ComponentFactory.Instance.creatFilters("grayFilter");
        }

        private function onBtnClick2(_arg_1:MouseEvent):void
        {
            SoundManager.instance.play("008");
            this._roomContinuationTime1SelectedBtn.filters = ComponentFactory.Instance.creatFilters("grayFilter");
            this._roomContinuationTime2SelectedBtn.filters = ComponentFactory.Instance.creatFilters("lightFilter");
            this._roomContinuationTime3SelectedBtn.filters = ComponentFactory.Instance.creatFilters("grayFilter");
        }

        private function onBtnClick3(_arg_1:MouseEvent):void
        {
            SoundManager.instance.play("008");
            this._roomContinuationTime1SelectedBtn.filters = ComponentFactory.Instance.creatFilters("grayFilter");
            this._roomContinuationTime2SelectedBtn.filters = ComponentFactory.Instance.creatFilters("grayFilter");
            this._roomContinuationTime3SelectedBtn.filters = ComponentFactory.Instance.creatFilters("lightFilter");
        }

        private function onFrameResponse(_arg_1:FrameEvent):void
        {
            SoundManager.instance.play("008");
            switch (_arg_1.responseCode)
            {
                case FrameEvent.CANCEL_CLICK:
                case FrameEvent.CLOSE_CLICK:
                case FrameEvent.ESC_CLICK:
                    this.dispose();
                    return;
                case FrameEvent.ENTER_CLICK:
                case FrameEvent.SUBMIT_CLICK:
                    this.confirmSubmit();
                    return;
            };
        }

        private function confirmSubmit():void
        {
            if (((this.checkMoney()) && (ChurchManager.instance.currentRoom)))
            {
                this._controller.roomContinuation((this._roomContinuationTimeGroup.selectIndex + 2));
            };
            this.dispose();
        }

        private function checkMoney():Boolean
        {
            var _local_1:Array = _roomMoney;
            if (PlayerManager.Instance.Self.totalMoney < _local_1[this._roomContinuationTimeGroup.selectIndex])
            {
                LeavePageManager.showFillFrame();
                this.dispose();
                return (false);
            };
            return (true);
        }

        public function show():void
        {
            LayerManager.Instance.addToLayer(this, LayerManager.GAME_DYNAMIC_LAYER, true, LayerManager.BLCAK_BLOCKGOUND);
        }

        private function removeView():void
        {
            this._alertInfo = null;
            if (this._alert)
            {
                if (this._alert.parent)
                {
                    this._alert.parent.removeChild(this._alert);
                };
                this._alert.dispose();
            };
            this._alert = null;
            if (this._bg)
            {
                if (this._bg.parent)
                {
                    this._bg.parent.removeChild(this._bg);
                };
            };
            this._bg = null;
            if (this._roomContinuationTime1SelectedBtn)
            {
                if (this._roomContinuationTime1SelectedBtn.parent)
                {
                    this._roomContinuationTime1SelectedBtn.parent.removeChild(this._roomContinuationTime1SelectedBtn);
                };
                this._roomContinuationTime1SelectedBtn.dispose();
            };
            this._roomContinuationTime1SelectedBtn = null;
            if (this._roomContinuationTime2SelectedBtn)
            {
                if (this._roomContinuationTime2SelectedBtn.parent)
                {
                    this._roomContinuationTime2SelectedBtn.parent.removeChild(this._roomContinuationTime2SelectedBtn);
                };
                this._roomContinuationTime2SelectedBtn.dispose();
            };
            this._roomContinuationTime2SelectedBtn = null;
            if (this._roomContinuationTime3SelectedBtn)
            {
                if (this._roomContinuationTime3SelectedBtn.parent)
                {
                    this._roomContinuationTime3SelectedBtn.parent.removeChild(this._roomContinuationTime3SelectedBtn);
                };
                this._roomContinuationTime3SelectedBtn.dispose();
            };
            this._roomContinuationTime3SelectedBtn = null;
            if (this._roomContinuationTimeGroup)
            {
                this._roomContinuationTimeGroup.dispose();
            };
            this._roomContinuationTimeGroup = null;
            if (this.parent)
            {
                this.parent.removeChild(this);
            };
            dispatchEvent(new Event(Event.CLOSE));
        }

        private function removeEvent():void
        {
            removeEventListener(FrameEvent.RESPONSE, this.onFrameResponse);
            if (this._roomContinuationTime1SelectedBtn)
            {
                this._roomContinuationTime1SelectedBtn.removeEventListener(MouseEvent.CLICK, this.onBtnClick1);
            };
            if (this._roomContinuationTime2SelectedBtn)
            {
                this._roomContinuationTime2SelectedBtn.removeEventListener(MouseEvent.CLICK, this.onBtnClick2);
            };
            if (this._roomContinuationTime3SelectedBtn)
            {
                this._roomContinuationTime3SelectedBtn.removeEventListener(MouseEvent.CLICK, this.onBtnClick3);
            };
        }

        override public function dispose():void
        {
            this.removeEvent();
            super.dispose();
            this.removeView();
        }


    }
}//package church.view.weddingRoom.frame

