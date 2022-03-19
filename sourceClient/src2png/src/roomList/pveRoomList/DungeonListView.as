// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//roomList.pveRoomList.DungeonListView

package roomList.pveRoomList
{
    import flash.display.Sprite;
    import com.pickgliss.ui.core.Disposeable;
    import flash.display.Bitmap;
    import ddt.utils.PositionUtils;
    import com.pickgliss.ui.ComponentFactory;
    import flash.geom.Point;
    import roomList.LookupEnumerate;
    import roomList.movingNotification.MovingNotificationManager;
    import ddt.manager.ChatManager;

    public class DungeonListView extends Sprite implements Disposeable 
    {

        private var _leaf1:Bitmap;
        private var _leaf2:Bitmap;
        private var _dungeonListBGView:DungeonListBGView;
        private var _chatView:Sprite;
        private var _playerList:DungeonRoomListPlayerListView;
        private var _model:DungeonListModel;
        private var _controlle:DungeonListController;

        public function DungeonListView(_arg_1:DungeonListController, _arg_2:DungeonListModel)
        {
            this._controlle = _arg_1;
            this._model = _arg_2;
            super();
            this.init();
        }

        private function init():void
        {
            this._dungeonListBGView = new DungeonListBGView(this._controlle, this._model);
            PositionUtils.setPos(this._dungeonListBGView, "asset.ddtdungeonList.bgview.pos");
            addChild(this._dungeonListBGView);
            var _local_1:Point = ComponentFactory.Instance.creatCustomObject("dungeonList.playerListPos");
            this._playerList = new DungeonRoomListPlayerListView(this._model.getPlayerList());
            this._playerList.type = LookupEnumerate.DUNGEON_LIST;
            this._playerList.x = _local_1.x;
            this._playerList.y = _local_1.y;
            addChild(this._playerList);
            MovingNotificationManager.Instance.showIn(this);
            PositionUtils.setPos(MovingNotificationManager.Instance.view, "asset.ddtroomList.MovingNotificationDungeonPos");
            ChatManager.Instance.state = ChatManager.CHAT_DUNGEONLIST_STATE;
            this._chatView = ChatManager.Instance.view;
            addChild(this._chatView);
            this._leaf1 = ComponentFactory.Instance.creatBitmap("asset.ddtroomlist.pve.leaf1");
            addChild(this._leaf1);
            this._leaf2 = ComponentFactory.Instance.creatBitmap("asset.ddtroomlist.pve.leaf2");
            addChild(this._leaf2);
        }

        public function dispose():void
        {
            MovingNotificationManager.Instance.hide();
            if (((this._dungeonListBGView) && (this._dungeonListBGView.parent)))
            {
                this._dungeonListBGView.parent.removeChild(this._dungeonListBGView);
                this._dungeonListBGView.dispose();
                this._dungeonListBGView = null;
            };
            if (((this._playerList) && (this._playerList.parent)))
            {
                this._playerList.parent.removeChild(this._playerList);
                this._playerList.dispose();
                this._playerList = null;
            };
            this._model = null;
            this._controlle = null;
            if (this.parent)
            {
                this.parent.removeChild(this);
            };
        }


    }
}//package roomList.pveRoomList

