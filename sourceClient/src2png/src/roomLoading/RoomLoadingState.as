// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//roomLoading.RoomLoadingState

package roomLoading
{
    import ddt.states.BaseStateView;
    import game.model.GameInfo;
    import roomLoading.view.RoomLoadingView;
    import ddt.manager.ChatManager;
    import ddt.view.MainToolBar;
    import room.RoomManager;
    import ddt.manager.GameInSocketOut;
    import ddt.manager.StateManager;
    import game.GameManager;
    import ddt.states.StateType;

    public class RoomLoadingState extends BaseStateView 
    {

        private var _current:GameInfo;
        private var _loadingView:RoomLoadingView;


        override public function enter(_arg_1:BaseStateView, _arg_2:Object=null):void
        {
            super.enter(_arg_1, _arg_2);
            this._current = (_arg_2 as GameInfo);
            this._loadingView = new RoomLoadingView(this._current);
            addChild(this._loadingView);
            ChatManager.Instance.state = ChatManager.CHAT_GAME_LOADING;
            ChatManager.Instance.view.bg = true;
            addChild(ChatManager.Instance.view);
            MainToolBar.Instance.hide();
            RoomManager.Instance.current.resetStates();
            if (RoomManager.Instance.current.selfRoomPlayer.isHost)
            {
                GameInSocketOut.sendPlayerState(2);
            }
            else
            {
                GameInSocketOut.sendPlayerState(0);
            };
            ChatManager.Instance.setFocus();
        }

        override public function leaving(_arg_1:BaseStateView):void
        {
            if (this._loadingView)
            {
                this._loadingView.dispose();
                this._loadingView = null;
            };
            this._current = null;
            if (StateManager.isExitRoom(_arg_1.getType()))
            {
                GameInSocketOut.sendGamePlayerExit();
                GameManager.Instance.reset();
                RoomManager.Instance.reset();
            };
            MainToolBar.Instance.enableAll();
            ChatManager.Instance.view.bg = false;
            super.leaving(_arg_1);
        }

        override public function getType():String
        {
            return (StateType.ROOM_LOADING);
        }


    }
}//package roomLoading

