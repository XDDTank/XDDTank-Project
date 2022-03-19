// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//roomList.pvpRoomList.RoomListViewFrame

package roomList.pvpRoomList
{
    import com.pickgliss.ui.controls.Frame;
    import flash.display.Bitmap;
    import com.pickgliss.ui.ComponentFactory;
    import flash.geom.Point;
    import com.pickgliss.events.FrameEvent;
    import ddt.manager.SoundManager;
    import com.pickgliss.ui.LayerManager;
    import ddt.manager.TaskDirectorManager;
    import ddt.data.TaskDirectorType;
    import trainer.view.NewHandContainer;
    import trainer.data.ArrowType;
    import com.pickgliss.utils.ObjectUtils;

    public class RoomListViewFrame extends Frame 
    {

        private var _model:RoomListModel;
        private var _controller:RoomListController;
        private var _roomListBg:RoomListBGView;
        private var _playerList:RoomListPlayerListView;
        private var _titleBmp:Bitmap;

        public function RoomListViewFrame(_arg_1:RoomListController, _arg_2:RoomListModel)
        {
            this._controller = _arg_1;
            this._model = _arg_2;
            super();
            escEnable = true;
            this.initView();
            this.initEvent();
        }

        private function initView():void
        {
            this._roomListBg = new RoomListBGView(this._controller, this._model);
            this._playerList = new RoomListPlayerListView(this._model.getPlayerList());
            var _local_1:Point = ComponentFactory.Instance.creatCustomObject("roomList.playerListPos");
            this._playerList.x = _local_1.x;
            this._playerList.y = _local_1.y;
            this._titleBmp = ComponentFactory.Instance.creatBitmap("asset.fightRoom.title");
            addToContent(this._titleBmp);
            addToContent(this._roomListBg);
            addToContent(this._playerList);
        }

        private function initEvent():void
        {
            addEventListener(FrameEvent.RESPONSE, this.__responseHandler);
        }

        private function removeEvent():void
        {
            removeEventListener(FrameEvent.RESPONSE, this.__responseHandler);
        }

        private function __responseHandler(_arg_1:FrameEvent):void
        {
            if (((_arg_1.responseCode == FrameEvent.CLOSE_CLICK) || (_arg_1.responseCode == FrameEvent.ESC_CLICK)))
            {
                SoundManager.instance.play("008");
                this.dispose();
            };
        }

        public function show():void
        {
            LayerManager.Instance.addToLayer(this, LayerManager.GAME_DYNAMIC_LAYER, true, LayerManager.BLCAK_BLOCKGOUND);
            TaskDirectorManager.instance.showDirector(TaskDirectorType.ROOM_LIST, this);
        }

        override public function dispose():void
        {
            TaskDirectorManager.instance.showDirector(TaskDirectorType.MAIN);
            this.removeEvent();
            NewHandContainer.Instance.clearArrowByID(ArrowType.CREAT_ROOM);
            if (NewHandContainer.Instance.hasArrow(ArrowType.BACK_GUILDE))
            {
                NewHandContainer.Instance.clearArrowByID(ArrowType.BACK_GUILDE);
            };
            if (this._roomListBg)
            {
                this._roomListBg.dispose();
                this._roomListBg = null;
            };
            if (this._playerList)
            {
                this._playerList.dispose();
                this._playerList = null;
            };
            RoomListController.Instance.removeEvent();
            if (this.parent)
            {
                this.parent.removeChild(this);
            };
            if (this._titleBmp)
            {
                ObjectUtils.disposeObject(this._titleBmp);
            };
            this._titleBmp = null;
            super.dispose();
        }


    }
}//package roomList.pvpRoomList

