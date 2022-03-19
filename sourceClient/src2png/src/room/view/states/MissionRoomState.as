// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//room.view.states.MissionRoomState

package room.view.states
{
    import room.view.roomView.MissionRoomView;
    import room.RoomManager;
    import ddt.view.MainToolBar;
    import ddt.states.BaseStateView;
    import com.pickgliss.ui.controls.alert.BaseAlerFrame;
    import ddt.manager.StateManager;
    import ddt.states.StateType;
    import com.pickgliss.ui.AlertManager;
    import ddt.manager.LanguageMgr;
    import com.pickgliss.ui.LayerManager;
    import com.pickgliss.events.FrameEvent;
    import ddt.manager.SoundManager;

    public class MissionRoomState extends BaseRoomState 
    {


        override public function enter(_arg_1:BaseStateView, _arg_2:Object=null):void
        {
            _roomView = new MissionRoomView(RoomManager.Instance.current);
            addChild(_roomView);
            MainToolBar.Instance.backFunction = this.leaveAlert;
            super.enter(_arg_1, _arg_2);
        }

        private function leaveAlert():void
        {
            var _local_1:BaseAlerFrame;
            if (RoomManager.Instance.current.selfRoomPlayer.isViewer)
            {
                StateManager.setState(StateType.MAIN);
            }
            else
            {
                _local_1 = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"), LanguageMgr.GetTranslation("tank.missionsettle.dungeon.leaveConfirm.contents"), "", LanguageMgr.GetTranslation("cancel"), true, true, false, LayerManager.BLCAK_BLOCKGOUND);
                _local_1.moveEnable = false;
                _local_1.addEventListener(FrameEvent.RESPONSE, this.__onResponse);
            };
        }

        private function __onResponse(_arg_1:FrameEvent):void
        {
            SoundManager.instance.play("008");
            if (((_arg_1.responseCode == FrameEvent.ENTER_CLICK) || (_arg_1.responseCode == FrameEvent.SUBMIT_CLICK)))
            {
                StateManager.setState(StateType.MAIN);
            };
        }

        override public function getType():String
        {
            return (StateType.MISSION_ROOM);
        }

        override public function leaving(_arg_1:BaseStateView):void
        {
            MainToolBar.Instance.backFunction = null;
            super.leaving(_arg_1);
        }

        override public function getBackType():String
        {
            return (StateType.DUNGEON_LIST);
        }


    }
}//package room.view.states

