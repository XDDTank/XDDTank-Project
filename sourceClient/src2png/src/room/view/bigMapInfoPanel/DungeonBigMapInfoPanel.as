// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//room.view.bigMapInfoPanel.DungeonBigMapInfoPanel

package room.view.bigMapInfoPanel
{
    import ddt.events.RoomEvent;
    import com.pickgliss.ui.ComponentFactory;
    import room.RoomManager;
    import ddt.view.MainToolBar;
    import ddt.manager.StateManager;
    import ddt.states.StateType;
    import com.pickgliss.ui.AlertManager;
    import ddt.manager.LanguageMgr;
    import com.pickgliss.ui.LayerManager;
    import com.pickgliss.ui.controls.alert.BaseAlerFrame;
    import com.pickgliss.events.FrameEvent;
    import ddt.manager.SoundManager;
    import ddt.manager.GameInSocketOut;
    import ddt.manager.PathManager;

    public class DungeonBigMapInfoPanel extends MissionRoomBigMapInfoPanel 
    {


        override protected function initEvents():void
        {
            super.initEvents();
            _info.addEventListener(RoomEvent.STARTED_CHANGED, this.__onGameStarted);
            _info.addEventListener(RoomEvent.PLAYER_STATE_CHANGED, this.__playerStateChange);
            _info.addEventListener(RoomEvent.OPEN_BOSS_CHANGED, this.__openBossChange);
        }

        override protected function removeEvents():void
        {
            super.removeEvents();
            _info.removeEventListener(RoomEvent.STARTED_CHANGED, this.__onGameStarted);
            _info.removeEventListener(RoomEvent.PLAYER_STATE_CHANGED, this.__playerStateChange);
            _info.removeEventListener(RoomEvent.OPEN_BOSS_CHANGED, this.__openBossChange);
        }

        override protected function initView():void
        {
            _pos1 = ComponentFactory.Instance.creatCustomObject("asset.ddtroom.dropListPos1");
            _pos2 = ComponentFactory.Instance.creatCustomObject("asset.ddtroom.dropListPos2");
            _dropList = new DropList();
            _dropList.x = _pos1.x;
            _dropList.y = _pos1.y;
            addChild(_dropList);
            _dropList.visible = true;
            _info = RoomManager.Instance.current;
            if (_info)
            {
                _info.addEventListener(RoomEvent.MAP_CHANGED, this.__onMapChanged);
                _info.addEventListener(RoomEvent.HARD_LEVEL_CHANGED, this.__updateHard);
                updateMap();
                updateDropList();
            };
            MainToolBar.Instance.backFunction = this.leaveAlert;
        }

        private function leaveAlert():void
        {
            if (((RoomManager.Instance.current.isOpenBoss) && (!(RoomManager.Instance.current.selfRoomPlayer.isViewer))))
            {
                this.showAlert();
            }
            else
            {
                StateManager.setState(StateType.MAIN);
            };
        }

        private function showAlert():void
        {
            var _local_1:BaseAlerFrame = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"), LanguageMgr.GetTranslation("tank.missionsettle.dungeon.leaveConfirm.contents"), "", LanguageMgr.GetTranslation("cancel"), true, true, false, LayerManager.BLCAK_BLOCKGOUND);
            _local_1.moveEnable = false;
            _local_1.addEventListener(FrameEvent.RESPONSE, this.__onResponse);
        }

        private function __onResponse(_arg_1:FrameEvent):void
        {
            SoundManager.instance.play("008");
            var _local_2:BaseAlerFrame = (_arg_1.target as BaseAlerFrame);
            _local_2.removeEventListener(FrameEvent.RESPONSE, this.__onResponse);
            _local_2.dispose();
            _local_2 = null;
            if (((_arg_1.responseCode == FrameEvent.ENTER_CLICK) || (_arg_1.responseCode == FrameEvent.SUBMIT_CLICK)))
            {
                StateManager.setState(StateType.DUNGEON_LIST);
            };
        }

        private function __onGameStarted(_arg_1:RoomEvent):void
        {
        }

        override protected function __onMapChanged(_arg_1:RoomEvent):void
        {
            this.resetReadyState();
            super.__onMapChanged(_arg_1);
        }

        override protected function __updateHard(_arg_1:RoomEvent):void
        {
            this.resetReadyState();
            super.__updateHard(_arg_1);
        }

        private function resetReadyState():void
        {
            if (((!(RoomManager.Instance.current.selfRoomPlayer.isHost)) && (StateManager.currentStateType == StateType.DUNGEON_ROOM)))
            {
                GameInSocketOut.sendPlayerState(0);
            };
        }

        private function __playerStateChange(_arg_1:RoomEvent):void
        {
        }

        private function __openBossChange(_arg_1:RoomEvent):void
        {
            updateMap();
            updateDropList();
        }

        override protected function solvePath():String
        {
            var _local_1:String = (PathManager.SITE_MAIN + "image/map/");
            if (((_info) && (_info.mapId > 0)))
            {
                if (_info.isOpenBoss)
                {
                    if (((_info.pic) && (_info.pic.length > 0)))
                    {
                        _local_1 = (_local_1 + ((_info.mapId + "/") + _info.pic));
                    };
                }
                else
                {
                    _local_1 = (_local_1 + (_info.mapId + "/show1.jpg"));
                };
            }
            else
            {
                _local_1 = (_local_1 + "10000/show1.jpg");
            };
            return (_local_1);
        }

        override public function dispose():void
        {
            super.dispose();
            MainToolBar.Instance.backFunction = null;
        }


    }
}//package room.view.bigMapInfoPanel

