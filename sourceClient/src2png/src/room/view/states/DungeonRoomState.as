// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//room.view.states.DungeonRoomState

package room.view.states
{
    import room.view.roomView.DungeonRoomView;
    import room.RoomManager;
    import ddt.utils.PositionUtils;
    import ddt.manager.ChatManager;
    import ddt.view.chat.ChatOutputView;
    import ddt.states.BaseStateView;
    import ddt.manager.GameInSocketOut;
    import room.model.RoomInfo;
    import ddt.states.StateType;

    public class DungeonRoomState extends BaseRoomState 
    {


        override public function enter(_arg_1:BaseStateView, _arg_2:Object=null):void
        {
            _roomView = new DungeonRoomView(RoomManager.Instance.current);
            PositionUtils.setPos(_roomView, "asset.ddtroom.matchroomstate.pos");
            addChild(_roomView);
            super.enter(_arg_1, _arg_2);
            ChatManager.Instance.output.channel = ChatOutputView.CHAT_OUPUT_CURRENT;
            ChatManager.Instance.view.bg = true;
        }

        override public function leaving(_arg_1:BaseStateView):void
        {
            ChatManager.Instance.view.bg = false;
            if (((_info) && (_info.selfRoomPlayer.isHost)))
            {
                if (RoomManager.Instance.current.isOpenBoss)
                {
                    GameInSocketOut.sendGameRoomSetUp(10000, RoomInfo.DUNGEON_ROOM, true, _info.roomPass, _info.roomName, 1, _info.hardLevel, 0, false, _info.mapId);
                }
                else
                {
                    GameInSocketOut.sendGameRoomSetUp(10000, RoomInfo.DUNGEON_ROOM, false, _info.roomPass, _info.roomName, 1, 0, 0, false, 0);
                };
            };
            super.leaving(_arg_1);
        }

        override public function getType():String
        {
            return (StateType.DUNGEON_ROOM);
        }

        override public function getBackType():String
        {
            return (StateType.MAIN);
        }


    }
}//package room.view.states

