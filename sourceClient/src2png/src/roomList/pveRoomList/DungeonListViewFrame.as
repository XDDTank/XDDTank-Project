// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//roomList.pveRoomList.DungeonListViewFrame

package roomList.pveRoomList
{
    import com.pickgliss.ui.controls.Frame;
    import flash.display.Bitmap;
    import flash.geom.Point;
    import com.pickgliss.ui.ComponentFactory;
    import roomList.LookupEnumerate;
    import com.pickgliss.events.FrameEvent;
    import ddt.manager.SoundManager;
    import com.pickgliss.ui.LayerManager;
    import ddt.manager.TaskDirectorManager;
    import ddt.data.TaskDirectorType;
    import com.pickgliss.utils.ObjectUtils;

    public class DungeonListViewFrame extends Frame 
    {

        private var _model:DungeonListModel;
        private var _controller:DungeonListController;
        private var _DungeonListBg:DungeonListBGView;
        private var _leaf:Bitmap;
        private var _playerList:DungeonRoomListPlayerListView;
        private var _titleBmp:Bitmap;

        public function DungeonListViewFrame(_arg_1:DungeonListController, _arg_2:DungeonListModel)
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
            var _local_1:Point;
            this._DungeonListBg = new DungeonListBGView(this._controller, this._model);
            _local_1 = ComponentFactory.Instance.creatCustomObject("dungeonList.playerListPos");
            this._playerList = new DungeonRoomListPlayerListView(this._model.getPlayerList());
            this._playerList.type = LookupEnumerate.DUNGEON_LIST;
            this._playerList.x = _local_1.x;
            this._playerList.y = _local_1.y;
            addToContent(this._playerList);
            this._leaf = ComponentFactory.Instance.creatBitmap("asset.ddtroomlist.pve.leaf3");
            addToContent(this._DungeonListBg);
            addToContent(this._leaf);
            this._titleBmp = ComponentFactory.Instance.creatBitmap("asset.dungeon.title");
            addToContent(this._titleBmp);
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
            TaskDirectorManager.instance.showDirector(TaskDirectorType.DUNGEON_LIST, this);
        }

        override public function dispose():void
        {
            TaskDirectorManager.instance.showDirector(TaskDirectorType.MAIN);
            this.removeEvent();
            if (this._DungeonListBg)
            {
                this._DungeonListBg.dispose();
                this._DungeonListBg = null;
            };
            if (((this._playerList) && (this._playerList.parent)))
            {
                this._playerList.parent.removeChild(this._playerList);
                this._playerList.dispose();
                this._playerList = null;
            };
            if (this._leaf)
            {
                ObjectUtils.disposeObject(this._leaf);
                this._leaf = null;
            };
            DungeonListController.Instance.removeEvent();
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
}//package roomList.pveRoomList

