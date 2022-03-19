// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//church.view.weddingRoomList.WeddingRoomListNavView

package church.view.weddingRoomList
{
    import flash.display.Sprite;
    import com.pickgliss.ui.core.Disposeable;
    import church.controller.ChurchRoomListController;
    import church.model.ChurchRoomListModel;
    import com.pickgliss.ui.controls.BaseButton;
    import church.view.weddingRoomList.frame.WeddingRoomCreateView;
    import church.view.weddingRoomList.frame.WeddingUnmarryView;
    import com.pickgliss.ui.ComponentFactory;
    import flash.events.MouseEvent;
    import platformapi.tencent.DiamondManager;
    import flash.events.Event;
    import ddt.manager.SoundManager;
    import church.view.ChurchMainView;
    import ddt.manager.PlayerManager;
    import ddt.manager.MessageTipManager;
    import ddt.manager.LanguageMgr;
    import ddt.manager.SocketManager;
    import ddt.events.CrazyTankSocketEvent;
    import ddt.manager.TimeManager;
    import ddt.manager.ChurchManager;
    import baglocked.BaglockedManager;
    import ddt.view.UIModuleSmallLoading;

    public class WeddingRoomListNavView extends Sprite implements Disposeable 
    {

        private var _controller:ChurchRoomListController;
        private var _model:ChurchRoomListModel;
        private var _btnCreateAsset:BaseButton;
        private var _btnJoinAsset:BaseButton;
        private var _btnDivorceAsset:BaseButton;
        private var _createRoomFrame:WeddingRoomCreateView;
        private var _weddingUnmarryView:WeddingUnmarryView;

        public function WeddingRoomListNavView(_arg_1:ChurchRoomListController, _arg_2:ChurchRoomListModel)
        {
            this._controller = _arg_1;
            this._model = _arg_2;
            this.initialize();
        }

        protected function initialize():void
        {
            this.setView();
            this.addEvent();
        }

        private function setView():void
        {
            this._btnCreateAsset = ComponentFactory.Instance.creat("church.main.btnCreateAsset");
            addChild(this._btnCreateAsset);
            this._btnJoinAsset = ComponentFactory.Instance.creat("church.main.btnJoinAsset");
            addChild(this._btnJoinAsset);
            this._btnDivorceAsset = ComponentFactory.Instance.creat("church.main.btnDivorceAsset");
            addChild(this._btnDivorceAsset);
            if (DivorcePromptFrame.Instance.isOpenDivorce == true)
            {
                this._openDivorce();
                DivorcePromptFrame.Instance.isOpenDivorce = false;
            };
        }

        private function removeView():void
        {
            if (this._btnCreateAsset)
            {
                if (this._btnCreateAsset.parent)
                {
                    this._btnCreateAsset.parent.removeChild(this._btnCreateAsset);
                };
                this._btnCreateAsset.dispose();
            };
            this._btnCreateAsset = null;
            if (this._btnJoinAsset)
            {
                if (this._btnJoinAsset.parent)
                {
                    this._btnJoinAsset.parent.removeChild(this._btnJoinAsset);
                };
                this._btnJoinAsset.dispose();
            };
            this._btnJoinAsset = null;
            if (this._btnDivorceAsset)
            {
                if (this._btnDivorceAsset.parent)
                {
                    this._btnDivorceAsset.parent.removeChild(this._btnDivorceAsset);
                };
                this._btnDivorceAsset.dispose();
            };
            this._btnDivorceAsset = null;
            if (this._createRoomFrame)
            {
                if (this._createRoomFrame.parent)
                {
                    this._createRoomFrame.parent.removeChild(this._createRoomFrame);
                };
                this._createRoomFrame.dispose();
            };
            this._createRoomFrame = null;
        }

        private function addEvent():void
        {
            this._btnCreateAsset.addEventListener(MouseEvent.CLICK, this.onClickListener);
            this._btnJoinAsset.addEventListener(MouseEvent.CLICK, this.onClickListener);
            this._btnDivorceAsset.addEventListener(MouseEvent.CLICK, this.onClickListener);
        }

        private function removeEvent():void
        {
            this._btnCreateAsset.removeEventListener(MouseEvent.CLICK, this.onClickListener);
            this._btnJoinAsset.removeEventListener(MouseEvent.CLICK, this.onClickListener);
            this._btnDivorceAsset.removeEventListener(MouseEvent.CLICK, this.onClickListener);
            DiamondManager.instance.removeEventListener(Event.COMPLETE, this.__diamondComplete);
        }

        private function onClickListener(_arg_1:MouseEvent):void
        {
            SoundManager.instance.play("008");
            switch (_arg_1.currentTarget)
            {
                case this._btnCreateAsset:
                    this.showWeddingRoomCreateView();
                    return;
                case this._btnJoinAsset:
                    this._controller.changeViewState(ChurchMainView.ROOM_LIST);
                    return;
                case this._btnDivorceAsset:
                    if ((!(PlayerManager.Instance.Self.IsMarried)))
                    {
                        MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("church.weddingRoom.RoomListBtnPanel.clickListener"));
                        return;
                    };
                    this._openDivorce();
                    return;
            };
        }

        private function _openDivorce():void
        {
            SocketManager.Instance.addEventListener(CrazyTankSocketEvent.MATE_ONLINE_TIME, this.__mateTime);
            SocketManager.Instance.out.sendMateTime(PlayerManager.Instance.Self.SpouseID);
        }

        private function __mateTime(_arg_1:CrazyTankSocketEvent):void
        {
            SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.MATE_ONLINE_TIME, this.__mateTime);
            var _local_2:Date = _arg_1.pkg.readDate();
            if (_local_2.fullYear < 2013)
            {
                _local_2 = TimeManager.Instance.Now();
            };
            var _local_3:int = _arg_1.pkg.readInt();
            var _local_4:int = CalculateDate.needMoney(_local_2, _local_3);
            this.showUnmarryFrame(_local_2, _local_4, _local_3);
        }

        public function showWeddingRoomCreateView():void
        {
            if ((!(PlayerManager.Instance.Self.IsMarried)))
            {
                MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("church.weddingRoom.WeddingRoomControler.showCreateFrame"));
                return;
            };
            if (ChurchManager.instance.selfRoom)
            {
                SocketManager.Instance.out.sendEnterRoom(0, "");
                return;
            };
            if (PlayerManager.Instance.Self.bagLocked)
            {
                BaglockedManager.Instance.show();
                return;
            };
            if (((!(DiamondManager.instance.isInTencent)) || (DiamondManager.instance.hasUI)))
            {
                this._createRoomFrame = ComponentFactory.Instance.creat("church.main.weddingRoomList.weddingRoomCreateView");
                this._createRoomFrame.setController(this._controller, this._model);
                this._createRoomFrame.show();
            }
            else
            {
                UIModuleSmallLoading.Instance.show();
                UIModuleSmallLoading.Instance.addEventListener(Event.CLOSE, this.__onClose);
                DiamondManager.instance.addEventListener(Event.COMPLETE, this.__diamondComplete);
            };
        }

        protected function __onClose(_arg_1:Event):void
        {
            UIModuleSmallLoading.Instance.hide();
            UIModuleSmallLoading.Instance.removeEventListener(Event.CLOSE, this.__onClose);
            DiamondManager.instance.removeEventListener(Event.COMPLETE, this.__diamondComplete);
        }

        protected function __diamondComplete(_arg_1:Event):void
        {
            UIModuleSmallLoading.Instance.removeEventListener(Event.CLOSE, this.__onClose);
            DiamondManager.instance.removeEventListener(Event.COMPLETE, this.__diamondComplete);
            UIModuleSmallLoading.Instance.hide();
            this.showWeddingRoomCreateView();
        }

        public function showUnmarryFrame(_arg_1:Date, _arg_2:int, _arg_3:int):void
        {
            this._weddingUnmarryView = ComponentFactory.Instance.creat("church.weddingRoomList.frame.WeddingUnmarryView");
            this._weddingUnmarryView.controller = this._controller;
            var _local_4:Array = CalculateDate.start(_arg_1, _arg_3);
            this._weddingUnmarryView.setText(_local_4[0], _local_4[1]);
            this._weddingUnmarryView.show(_arg_2);
        }

        public function dispose():void
        {
            this.removeEvent();
            this.removeView();
            UIModuleSmallLoading.Instance.hide();
        }


    }
}//package church.view.weddingRoomList

