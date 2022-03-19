// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//room.view.roomView.DungeonRoomView

package room.view.roomView
{
    import flash.display.Bitmap;
    import room.view.bigMapInfoPanel.DungeonBigMapInfoPanel;
    import room.view.smallMapInfoPanel.DungeonSmallMapInfoPanel;
    import com.pickgliss.ui.controls.BaseButton;
    import com.pickgliss.ui.controls.alert.BaseAlerFrame;
    import room.model.RoomInfo;
    import com.pickgliss.ui.ComponentFactory;
    import ddt.utils.PositionUtils;
    import flash.events.Event;
    import ddt.manager.PlayerManager;
    import ddt.manager.MessageTipManager;
    import ddt.manager.LanguageMgr;
    import ddt.manager.ChatManager;
    import flash.events.MouseEvent;
    import room.view.RoomPlayerItem;
    import ddt.manager.SoundManager;
    import room.view.chooseMap.DungeonChooseMapFrame;
    import ddt.manager.MapManager;
    import ddt.data.map.DungeonInfo;
    import com.pickgliss.ui.AlertManager;
    import com.pickgliss.ui.LayerManager;
    import com.pickgliss.events.FrameEvent;
    import ddt.events.RoomEvent;
    import room.RoomManager;
    import ddt.manager.GameInSocketOut;
    import room.view.RoomDupSimpleTipFram;

    public class DungeonRoomView extends BaseRoomView 
    {

        private var _bg:Bitmap;
        private var _bigMapInfoPanel:DungeonBigMapInfoPanel;
        private var _smallMapInfoPanel:DungeonSmallMapInfoPanel;
        private var _btnSwitchTeam:BaseButton;
        private var _ItemArr:Array;
        private var _singleAlsert:BaseAlerFrame;

        public function DungeonRoomView(_arg_1:RoomInfo)
        {
            super(_arg_1);
        }

        override protected function initView():void
        {
            this._bg = ComponentFactory.Instance.creatBitmap("asset.background.dungeonroom.rightBg");
            PositionUtils.setPos(this._bg, "asset.ddtmatchroom.bgPos");
            addChild(this._bg);
            this._bigMapInfoPanel = ComponentFactory.Instance.creatCustomObject("ddt.dungeonRoom.BigMapInfoPanel");
            this._smallMapInfoPanel = ComponentFactory.Instance.creatCustomObject("ddt.dungeonRoom.SmallMapInfoPanel");
            this._smallMapInfoPanel.info = _info;
            this._btnSwitchTeam = ComponentFactory.Instance.creatComponentByStylename("asset.ddtChallengeRoom.switchTeamBtn");
            addChild(this._btnSwitchTeam);
            this._btnSwitchTeam.visible = false;
            this.updateItemPos();
            super.initView();
            addChild(this._bigMapInfoPanel);
            addChild(this._smallMapInfoPanel);
        }

        override protected function initEvents():void
        {
            super.initEvents();
            addEventListener(Event.ADDED_TO_STAGE, this.__loadWeakGuild);
        }

        override protected function __prepareClick(_arg_1:MouseEvent):void
        {
            super.__prepareClick(_arg_1);
            if (((PlayerManager.Instance.Self.dungeonFlag[_info.mapId]) && (PlayerManager.Instance.Self.dungeonFlag[_info.mapId] == 0)))
            {
                MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.room.RoomIIController.reduceGains"));
                ChatManager.Instance.sysChatYellow(LanguageMgr.GetTranslation("tank.room.RoomIIController.reduceGains"));
            };
        }

        override protected function removeEvents():void
        {
            super.removeEvents();
            removeEventListener(Event.ADDED_TO_STAGE, this.__loadWeakGuild);
        }

        private function __loadWeakGuild(_arg_1:Event):void
        {
            removeEventListener(Event.ADDED_TO_STAGE, this.__loadWeakGuild);
        }

        private function updateItemPos():void
        {
            this._ItemArr = [ComponentFactory.Instance.creatCustomObject("asset.ddtroomPlayerItem.Pos1"), ComponentFactory.Instance.creatCustomObject("asset.ddtroomPlayerItem.Pos2"), ComponentFactory.Instance.creatCustomObject("asset.ddtroomPlayerItem.Pos3")];
        }

        override protected function initTileList():void
        {
            var _local_2:RoomPlayerItem;
            super.initTileList();
            var _local_1:int;
            while (_local_1 < 3)
            {
                _local_2 = new RoomPlayerItem(_local_1);
                _local_2.x = this._ItemArr[_local_1].x;
                _local_2.y = this._ItemArr[_local_1].y;
                addChild(_local_2);
                _playerItems.push(_local_2);
                _local_1++;
            };
            if (isViewerRoom)
            {
                PositionUtils.setPos(_viewerItems[0], "asset.ddtchallengeroom.ViewerItemPos_0");
                PositionUtils.setPos(_viewerItems[1], "asset.ddtchallengeroom.ViewerItemPos_1");
                addChild(_viewerItems[0]);
                addChild(_viewerItems[1]);
            };
        }

        override protected function __startClick(_arg_1:MouseEvent):void
        {
            if ((!(_info.isAllReady())))
            {
                return;
            };
            SoundManager.instance.play("008");
            if (this.checkCanStartGame())
            {
                startGame();
            };
        }

        override protected function checkCanStartGame():Boolean
        {
            var _local_2:DungeonChooseMapFrame;
            var _local_1:DungeonInfo = MapManager.getDungeonInfo(_info.mapId);
            if (super.checkCanStartGame())
            {
                if (_info.type == RoomInfo.FRESHMAN_ROOM)
                {
                    return (true);
                };
                if (_info.mapId == 17)
                {
                    this._singleAlsert = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"), LanguageMgr.GetTranslation("tank.room.RoomIIView2.randomConfirm"), "", LanguageMgr.GetTranslation("cancel"), true, true, true, LayerManager.BLCAK_BLOCKGOUND);
                    this._singleAlsert.moveEnable = false;
                    this._singleAlsert.addEventListener(FrameEvent.RESPONSE, this.__onResponse);
                    return (false);
                };
                if (((_info.mapId == 0) || (_info.mapId == 10000)))
                {
                    _local_2 = new DungeonChooseMapFrame();
                    _local_2.show();
                    dispatchEvent(new RoomEvent(RoomEvent.OPEN_DUNGEON_CHOOSER));
                    return (false);
                };
                if ((((_local_1) && (_local_1.Type == MapManager.PVE_CHANGE_MAP)) && ((RoomManager.Instance.current.players.length - RoomManager.Instance.current.currentViewerCnt) < 3)))
                {
                    MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.room.RoomIIView2.clewContent.change"));
                    return (false);
                };
                if ((((_local_1) && (_local_1.Type == MapManager.PVE_MULTISHOOT)) && ((RoomManager.Instance.current.players.length - RoomManager.Instance.current.currentViewerCnt) < 3)))
                {
                    MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.room.RoomIIView2.clewContent.change"));
                    return (false);
                };
                if ((((RoomManager.Instance.current.players.length - RoomManager.Instance.current.currentViewerCnt) == 1) && (!(_local_1.Type == MapManager.PVE_ACADEMY_MAP))))
                {
                    this._singleAlsert = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"), LanguageMgr.GetTranslation("tank.room.RoomIIView2.clewContent"), "", LanguageMgr.GetTranslation("cancel"), true, true, true, LayerManager.BLCAK_BLOCKGOUND);
                    this._singleAlsert.moveEnable = false;
                    this._singleAlsert.addEventListener(FrameEvent.RESPONSE, this.__onResponse);
                    return (false);
                };
                if (((_local_1.Type == MapManager.PVE_ACADEMY_MAP) && (!(super.academyDungeonAllow()))))
                {
                    return (false);
                };
                return (true);
            };
            return (false);
        }

        private function __onResponse(_arg_1:FrameEvent):void
        {
            this._singleAlsert.removeEventListener(FrameEvent.RESPONSE, this.__onResponse);
            this._singleAlsert.dispose();
            this._singleAlsert = null;
            if (((_arg_1.responseCode == FrameEvent.ENTER_CLICK) || (_arg_1.responseCode == FrameEvent.SUBMIT_CLICK)))
            {
                startGame();
            };
        }

        override protected function kickHandler():void
        {
            GameInSocketOut.sendGameRoomSetUp(10000, RoomInfo.DUNGEON_ROOM, false, _info.roomPass, _info.roomName, 1, 0, 0, false, 0);
            super.kickHandler();
        }

        override public function dispose():void
        {
            super.dispose();
            if (this._singleAlsert)
            {
                this._singleAlsert.removeEventListener(FrameEvent.RESPONSE, this.__onResponse);
                this._singleAlsert.dispose();
                this._singleAlsert = null;
            };
            this._bigMapInfoPanel.dispose();
            this._bigMapInfoPanel = null;
            this._smallMapInfoPanel.dispose();
            this._smallMapInfoPanel = null;
            this._btnSwitchTeam.dispose();
            this._btnSwitchTeam = null;
        }

        private function sendStartGame():void
        {
            this.__startClick(null);
            SoundManager.instance.play("008");
        }

        private function _showBoGuTip():void
        {
            var _local_1:RoomDupSimpleTipFram;
            if (PlayerManager.Instance.Self._isDupSimpleTip)
            {
                PlayerManager.Instance.Self._isDupSimpleTip = false;
                _local_1 = ComponentFactory.Instance.creatComponentByStylename("room.RoomDupSimpleTipFram");
                _local_1.show();
            };
        }


    }
}//package room.view.roomView

