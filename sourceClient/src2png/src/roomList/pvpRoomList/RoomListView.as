// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//roomList.pvpRoomList.RoomListView

package roomList.pvpRoomList
{
    import flash.display.Sprite;
    import com.pickgliss.ui.core.Disposeable;
    import roomList.movingNotification.MovingNotificationManager;
    import ddt.utils.PositionUtils;
    import ddt.manager.ChatManager;
    import com.pickgliss.ui.ComponentFactory;
    import flash.geom.Point;

    public class RoomListView extends Sprite implements Disposeable 
    {

        private var _roomListBg:RoomListBGView;
        private var _playerList:RoomListPlayerListView;
        private var _chatView:Sprite;
        private var _model:RoomListModel;
        private var _controller:RoomListController;

        public function RoomListView(_arg_1:RoomListController, _arg_2:RoomListModel)
        {
            this._model = _arg_2;
            this._controller = _arg_1;
            super();
            this._roomListBg = new RoomListBGView(this._controller, this._model);
            addChild(this._roomListBg);
            MovingNotificationManager.Instance.showIn(this);
            PositionUtils.setPos(MovingNotificationManager.Instance.view, "asset.ddtroomList.MovingNotificationRoomPos");
            ChatManager.Instance.state = ChatManager.CHAT_ROOMLIST_STATE;
            this._chatView = ChatManager.Instance.view;
            addChild(this._chatView);
            this._playerList = new RoomListPlayerListView(this._model.getPlayerList());
            var _local_3:Point = ComponentFactory.Instance.creatCustomObject("roomList.playerListPos");
            this._playerList.x = _local_3.x;
            this._playerList.y = _local_3.y;
            addChild(this._playerList);
        }

        public function dispose():void
        {
            if (this._roomListBg)
            {
                this._roomListBg.dispose();
            };
            this._roomListBg = null;
            MovingNotificationManager.Instance.hide();
            if (((this._chatView) && (this._chatView.parent)))
            {
                this._chatView.parent.removeChild(this._chatView);
            };
            if (this._playerList)
            {
                this._playerList.dispose();
            };
            this._playerList = null;
            if (parent)
            {
                this.parent.removeChild(this);
            };
        }


    }
}//package roomList.pvpRoomList

