// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//room.view.states.MatchRoomState

package room.view.states
{
    import room.view.roomView.MatchRoomView;
    import room.RoomManager;
    import ddt.utils.PositionUtils;
    import ddt.manager.ChatManager;
    import ddt.view.chat.ChatOutputView;
    import ddt.states.BaseStateView;
    import flash.events.Event;
    import ddt.states.StateType;

    public class MatchRoomState extends BaseRoomState 
    {


        override public function enter(_arg_1:BaseStateView, _arg_2:Object=null):void
        {
            _roomView = new MatchRoomView(RoomManager.Instance.current);
            PositionUtils.setPos(_roomView, "asset.ddtroom.matchroomstate.pos");
            addChild(_roomView);
            super.enter(_arg_1, _arg_2);
            ChatManager.Instance.output.channel = ChatOutputView.CHAT_OUPUT_CURRENT;
            ChatManager.Instance.view.bg = true;
        }

        override protected function __startLoading(_arg_1:Event):void
        {
            super.__startLoading(_arg_1);
        }

        override public function getType():String
        {
            return (StateType.MATCH_ROOM);
        }

        override public function getBackType():String
        {
            return (StateType.MAIN);
        }

        override public function leaving(_arg_1:BaseStateView):void
        {
            ChatManager.Instance.view.bg = false;
            super.leaving(_arg_1);
        }


    }
}//package room.view.states

