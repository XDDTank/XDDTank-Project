package room.view.states
{
   import ddt.manager.ChatManager;
   import ddt.states.BaseStateView;
   import ddt.states.StateType;
   import ddt.utils.PositionUtils;
   import ddt.view.chat.ChatOutputView;
   import flash.events.Event;
   import room.RoomManager;
   import room.view.roomView.MatchRoomView;
   
   public class MatchRoomState extends BaseRoomState
   {
       
      
      public function MatchRoomState()
      {
         super();
      }
      
      override public function enter(param1:BaseStateView, param2:Object = null) : void
      {
         _roomView = new MatchRoomView(RoomManager.Instance.current);
         PositionUtils.setPos(_roomView,"asset.ddtroom.matchroomstate.pos");
         addChild(_roomView);
         super.enter(param1,param2);
         ChatManager.Instance.output.channel = ChatOutputView.CHAT_OUPUT_CURRENT;
         ChatManager.Instance.view.bg = true;
      }
      
      override protected function __startLoading(param1:Event) : void
      {
         super.__startLoading(param1);
      }
      
      override public function getType() : String
      {
         return StateType.MATCH_ROOM;
      }
      
      override public function getBackType() : String
      {
         return StateType.MAIN;
      }
      
      override public function leaving(param1:BaseStateView) : void
      {
         ChatManager.Instance.view.bg = false;
         super.leaving(param1);
      }
   }
}
