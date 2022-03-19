// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//room.view.states.ChallengeRoomState

package room.view.states
{
    import room.view.roomView.ChallengeRoomView;
    import room.RoomManager;
    import ddt.manager.ChatManager;
    import ddt.view.chat.ChatOutputView;
    import ddt.manager.GameInSocketOut;
    import ddt.states.BaseStateView;
    import ddt.states.StateType;

    public class ChallengeRoomState extends BaseRoomState 
    {


        override public function enter(_arg_1:BaseStateView, _arg_2:Object=null):void
        {
            _roomView = new ChallengeRoomView(RoomManager.Instance.current);
            addChild(_roomView);
            ChatManager.Instance.output.channel = ChatOutputView.CHAT_OUPUT_CURRENT;
            ChatManager.Instance.view.bg = true;
            ChatManager.Instance.state = ChatManager.CHAT_ROOM_STATE;
            if (RoomManager.Instance.haveTempInventPlayer())
            {
                GameInSocketOut.sendInviteGame(RoomManager.Instance.tempInventPlayerID);
                RoomManager.Instance.tempInventPlayerID = -1;
            };
            super.enter(_arg_1, _arg_2);
        }

        override public function getType():String
        {
            return (StateType.CHALLENGE_ROOM);
        }

        override public function getBackType():String
        {
            return (StateType.MAIN);
        }


    }
}//package room.view.states

