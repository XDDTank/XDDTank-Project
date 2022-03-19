// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//room.view.smallMapInfoPanel.DungeonSmallMapInfoPanel

package room.view.smallMapInfoPanel
{
    import com.pickgliss.ui.controls.SimpleBitmapButton;
    import room.events.RoomPlayerEvent;
    import flash.events.MouseEvent;
    import com.pickgliss.ui.ComponentFactory;
    import ddt.manager.LanguageMgr;
    import ddt.manager.SoundManager;
    import room.RoomManager;
    import room.view.chooseMap.DungeonChooseMapFrame;
    import com.pickgliss.ui.AlertManager;
    import com.pickgliss.ui.LayerManager;
    import com.pickgliss.ui.controls.alert.BaseAlerFrame;
    import com.pickgliss.events.FrameEvent;
    import ddt.manager.StateManager;
    import ddt.states.StateType;
    import room.model.RoomInfo;

    public class DungeonSmallMapInfoPanel extends MissionRoomSmallMapInfoPanel 
    {

        private var _btn:SimpleBitmapButton;


        private function removeEvents():void
        {
            _info.selfRoomPlayer.removeEventListener(RoomPlayerEvent.IS_HOST_CHANGE, this.__update);
            removeEventListener(MouseEvent.CLICK, this.__onClick);
        }

        override protected function initView():void
        {
            super.initView();
            this._btn = ComponentFactory.Instance.creatComponentByStylename("asset.ddtroom.smallMapInfo.btn");
            this._btn.tipData = LanguageMgr.GetTranslation("tank.room.RoomIIMapSet.room2");
            addChild(this._btn);
        }

        private function __onClick(_arg_1:MouseEvent):void
        {
            SoundManager.instance.play("008");
            if (((RoomManager.Instance.current.isOpenBoss) && (!(RoomManager.Instance.current.selfRoomPlayer.isViewer))))
            {
                this.showAlert();
                return;
            };
            var _local_2:DungeonChooseMapFrame = new DungeonChooseMapFrame();
            _local_2.show();
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

        override public function set info(_arg_1:RoomInfo):void
        {
            super.info = _arg_1;
            if (_info)
            {
                _info.selfRoomPlayer.addEventListener(RoomPlayerEvent.IS_HOST_CHANGE, this.__update);
            };
            if (((_info) && (_info.selfRoomPlayer.isHost)))
            {
                this._btn.visible = (buttonMode = true);
                addEventListener(MouseEvent.CLICK, this.__onClick);
            }
            else
            {
                this._btn.visible = (buttonMode = false);
                removeEventListener(MouseEvent.CLICK, this.__onClick);
            };
        }

        private function __update(_arg_1:RoomPlayerEvent):void
        {
            if (_info.selfRoomPlayer.isHost)
            {
                this._btn.visible = (buttonMode = true);
                addEventListener(MouseEvent.CLICK, this.__onClick);
            }
            else
            {
                this._btn.visible = (buttonMode = false);
                removeEventListener(MouseEvent.CLICK, this.__onClick);
            };
        }

        override public function dispose():void
        {
            this.removeEvents();
            this._btn.dispose();
            this._btn = null;
            super.dispose();
        }


    }
}//package room.view.smallMapInfoPanel

