// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//room.view.roomView.MissionRoomView

package room.view.roomView
{
    import flash.display.Bitmap;
    import room.view.bigMapInfoPanel.MissionRoomBigMapInfoPanel;
    import room.view.smallMapInfoPanel.MissionRoomSmallMapInfoPanel;
    import com.pickgliss.ui.controls.BaseButton;
    import room.model.RoomInfo;
    import com.pickgliss.ui.ComponentFactory;
    import ddt.utils.PositionUtils;
    import com.pickgliss.ui.AlertManager;
    import ddt.manager.LanguageMgr;
    import com.pickgliss.ui.LayerManager;
    import com.pickgliss.ui.controls.alert.BaseAlerFrame;
    import com.pickgliss.events.FrameEvent;
    import flash.events.MouseEvent;
    import ddt.manager.SoundManager;
    import ddt.manager.MapManager;
    import ddt.data.map.DungeonInfo;
    import room.RoomManager;
    import ddt.manager.MessageTipManager;
    import room.view.RoomPlayerItem;
    import ddt.manager.GameInSocketOut;
    import ddt.manager.TaskManager;
    import flash.events.TimerEvent;
    import com.pickgliss.utils.ObjectUtils;

    public class MissionRoomView extends BaseRoomView 
    {

        private var _bg:Bitmap;
        private var _bigMapInfoPanel:MissionRoomBigMapInfoPanel;
        private var _smallMapInfoPanel:MissionRoomSmallMapInfoPanel;
        private var _btnSwitchTeam:BaseButton;
        private var _ItemArr:Array;

        public function MissionRoomView(_arg_1:RoomInfo)
        {
            super(_arg_1);
            _info.started = false;
        }

        override protected function initView():void
        {
            this._bg = ComponentFactory.Instance.creatBitmap("asset.background.room.rightBg");
            PositionUtils.setPos(this._bg, "asset.ddtmissionroom.bgPos");
            addChild(this._bg);
            this.initPanel();
            this._btnSwitchTeam = ComponentFactory.Instance.creatComponentByStylename("asset.ddtChallengeRoom.switchTeamBtn");
            addChild(this._btnSwitchTeam);
            this._btnSwitchTeam.visible = false;
            super.initView();
            addChild(this._bigMapInfoPanel);
            addChild(this._smallMapInfoPanel);
        }

        override protected function __findClick(_arg_1:MouseEvent):void
        {
            var _local_2:BaseAlerFrame = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"), LanguageMgr.GetTranslation("tank.missionsettle.dungeon.leaveConfirm.contents"), "", LanguageMgr.GetTranslation("cancel"), true, true, false, LayerManager.BLCAK_BLOCKGOUND);
            _local_2.moveEnable = false;
            _local_2.addEventListener(FrameEvent.RESPONSE, this.__onResponse);
        }

        private function __onResponse(_arg_1:FrameEvent):void
        {
            SoundManager.instance.play("008");
            if (((_arg_1.responseCode == FrameEvent.ENTER_CLICK) || (_arg_1.responseCode == FrameEvent.SUBMIT_CLICK)))
            {
                if (_findRoom)
                {
                    _findRoom.dispose();
                };
                _findRoom = null;
                _findRoom = ComponentFactory.Instance.creatCustomObject("asset.ddtroomList.LookupRoomFrame", [_info.ID]);
                LayerManager.Instance.addToLayer(_findRoom, LayerManager.GAME_DYNAMIC_LAYER);
            };
        }

        override protected function checkCanStartGame():Boolean
        {
            var _local_1:DungeonInfo = MapManager.getDungeonInfo(_info.mapId);
            if (super.checkCanStartGame())
            {
                if (_info.type == RoomInfo.FRESHMAN_ROOM)
                {
                    return (true);
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
                if (((_local_1.Type == MapManager.PVE_ACADEMY_MAP) && (!(super.academyDungeonAllow()))))
                {
                    return (false);
                };
                return (true);
            };
            return (false);
        }

        protected function initPanel():void
        {
            this._bigMapInfoPanel = ComponentFactory.Instance.creatCustomObject("ddt.room.missionBigMapInfoPanel");
            this._smallMapInfoPanel = ComponentFactory.Instance.creatCustomObject("ddt.room.missionSmallMapInfoPanel");
            this._smallMapInfoPanel.info = _info;
        }

        override protected function initTileList():void
        {
            var _local_2:RoomPlayerItem;
            super.initTileList();
            this._ItemArr = [ComponentFactory.Instance.creatCustomObject("asset.ddtroomPlayerItem.Pos1"), ComponentFactory.Instance.creatCustomObject("asset.ddtroomPlayerItem.Pos2"), ComponentFactory.Instance.creatCustomObject("asset.ddtroomPlayerItem.Pos3")];
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
            PositionUtils.setPos(_viewerItems[0], "asset.ddtchallengeroom.ViewerItemPos_0");
            PositionUtils.setPos(_viewerItems[1], "asset.ddtchallengeroom.ViewerItemPos_1");
            addChild(_viewerItems[0]);
            addChild(_viewerItems[1]);
        }

        override protected function prepareGame():void
        {
            GameInSocketOut.sendGameMissionPrepare(_info.selfRoomPlayer.place, true);
            GameInSocketOut.sendPlayerState(1);
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
                this.startGame();
            };
        }

        override protected function startGame():void
        {
            _info.started = false;
            GameInSocketOut.sendGameMissionStart(true);
        }

        override protected function __onHostTimer(_arg_1:TimerEvent):void
        {
            if (_info.selfRoomPlayer.isHost)
            {
                if (((_hostTimer.currentCount >= KICK_TIMEIII) && ((_info.players.length - _info.currentViewerCnt) > 1)))
                {
                    this.kickHandler();
                }
                else
                {
                    if (((_hostTimer.currentCount >= KICK_TIMEII) && ((_info.players.length - _info.currentViewerCnt) == 1)))
                    {
                        this.kickHandler();
                    }
                    else
                    {
                        if (((((_hostTimer.currentCount >= KICK_TIME) && ((_info.players.length - _info.currentViewerCnt) > 1)) && (_info.currentViewerCnt == 0)) && (_info.isAllReady())))
                        {
                            this.kickHandler();
                        }
                        else
                        {
                            if (((_hostTimer.currentCount >= HURRY_UP_TIME) && (_info.isAllReady())))
                            {
                                if ((!(TaskManager.instance.Model.taskViewIsShow)))
                                {
                                    if ((!(SoundManager.instance.isPlaying("007"))))
                                    {
                                        SoundManager.instance.play("007", false, true);
                                    };
                                }
                                else
                                {
                                    SoundManager.instance.stop("007");
                                };
                            };
                        };
                    };
                };
            };
        }

        override protected function kickHandler():void
        {
        }

        override protected function __cancelClick(_arg_1:MouseEvent):void
        {
            SoundManager.instance.play("008");
            if ((!(RoomManager.Instance.current.selfRoomPlayer.isHost)))
            {
                GameInSocketOut.sendGameMissionPrepare(_info.selfRoomPlayer.place, false);
                GameInSocketOut.sendPlayerState(0);
            };
        }

        override public function dispose():void
        {
            if (this._bigMapInfoPanel)
            {
                ObjectUtils.disposeObject(this._bigMapInfoPanel);
            };
            this._bigMapInfoPanel = null;
            if (this._smallMapInfoPanel)
            {
                ObjectUtils.disposeObject(this._smallMapInfoPanel);
            };
            this._smallMapInfoPanel = null;
            if (this._btnSwitchTeam)
            {
                ObjectUtils.disposeObject(this._btnSwitchTeam);
            };
            this._btnSwitchTeam = null;
            super.dispose();
        }


    }
}//package room.view.roomView

