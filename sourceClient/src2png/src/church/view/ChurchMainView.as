// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//church.view.ChurchMainView

package church.view
{
    import flash.display.Sprite;
    import com.pickgliss.ui.core.Disposeable;
    import church.controller.ChurchRoomListController;
    import church.model.ChurchRoomListModel;
    import flash.display.Bitmap;
    import com.pickgliss.ui.image.MutipleImage;
    import church.view.weddingRoomList.WeddingRoomListView;
    import church.view.weddingRoomList.WeddingRoomListNavView;
    import bagAndInfo.cell.BaseCell;
    import flash.display.DisplayObject;
    import flash.geom.Point;
    import com.pickgliss.ui.ComponentFactory;
    import ddt.manager.ItemManager;
    import ddt.manager.ChatManager;
    import ddt.view.MainToolBar;
    import ddt.manager.SocketManager;
    import com.pickgliss.utils.ObjectUtils;

    public class ChurchMainView extends Sprite implements Disposeable 
    {

        public static const NAV_PANEL:String = "btn panel";
        public static const ROOM_LIST:String = "room list";

        private var _controller:ChurchRoomListController;
        private var _model:ChurchRoomListModel;
        private var _titleMainAsset:Bitmap;
        private var _picPreviewAsset:MutipleImage;
        private var _chatFrame:Sprite;
        private var _weddingRoomListView:WeddingRoomListView;
        private var _weddingRoomListNavView:WeddingRoomListNavView;
        private var _currentState:String = "btn panel";
        private var _cell:BaseCell;
        private var _BG:DisplayObject;
        private var _bg:Bitmap;

        public function ChurchMainView(_arg_1:ChurchRoomListController, _arg_2:ChurchRoomListModel)
        {
            this._controller = _arg_1;
            this._model = _arg_2;
            this.initialize();
        }

        protected function initialize():void
        {
            var _local_1:Point;
            this._weddingRoomListNavView = new WeddingRoomListNavView(this._controller, this._model);
            this._weddingRoomListView = new WeddingRoomListView(this._controller, this._model);
            this._BG = ComponentFactory.Instance.creatCustomObject("background.churchroomlist.bg");
            addChild(this._BG);
            this._titleMainAsset = ComponentFactory.Instance.creatBitmap("asset.church.main.titleMainAsset");
            addChild(this._titleMainAsset);
            this._picPreviewAsset = ComponentFactory.Instance.creatComponentByStylename("church.main.picPreviewAsset");
            addChild(this._picPreviewAsset);
            this._bg = ComponentFactory.Instance.creatBitmap("equipretrieve.trieveCell0");
            this._cell = new BaseCell(this._bg, ItemManager.Instance.getTemplateById(405000));
            _local_1 = ComponentFactory.Instance.creatCustomObject("church.view.WeddingRoomListItemView.cellPos");
            this._cell.x = _local_1.x;
            this._cell.y = _local_1.y;
            this._cell.setContentSize(60, 60);
            addChild(this._cell);
            this.updateViewState();
            ChatManager.Instance.state = ChatManager.CHAT_WEDDINGLIST_STATE;
            this._chatFrame = ChatManager.Instance.view;
            addChild(this._chatFrame);
            ChatManager.Instance.setFocus();
        }

        public function changeState(_arg_1:String):void
        {
            if (this._currentState == _arg_1)
            {
                return;
            };
            this._currentState = _arg_1;
            this.updateViewState();
        }

        private function updateViewState():void
        {
            switch (this._currentState)
            {
                case NAV_PANEL:
                    addChild(this._weddingRoomListNavView);
                    MainToolBar.Instance.backFunction = null;
                    if (this._weddingRoomListView.parent)
                    {
                        removeChild(this._weddingRoomListView);
                        this._weddingRoomListView.updateList();
                    };
                    return;
                case ROOM_LIST:
                    SocketManager.Instance.out.sendMarryRoomLogin();
                    addChild(this._weddingRoomListView);
                    this._weddingRoomListView.updateList();
                    MainToolBar.Instance.backFunction = this.returnClick;
                    if (this._weddingRoomListNavView.parent)
                    {
                        removeChild(this._weddingRoomListNavView);
                    };
                    return;
            };
        }

        private function returnClick():void
        {
            this.changeState(NAV_PANEL);
        }

        public function show():void
        {
            this._controller.addChild(this);
        }

        public function dispose():void
        {
            this._controller = null;
            this._model = null;
            if (this._titleMainAsset)
            {
                if (this._titleMainAsset.bitmapData)
                {
                    this._titleMainAsset.bitmapData.dispose();
                };
                this._titleMainAsset.bitmapData = null;
            };
            this._titleMainAsset = null;
            this._BG = null;
            if (this._picPreviewAsset)
            {
                ObjectUtils.disposeObject(this._picPreviewAsset);
            };
            this._picPreviewAsset = null;
            if (this._chatFrame)
            {
                ObjectUtils.disposeObject(this._chatFrame);
            };
            this._chatFrame = null;
            if (this._weddingRoomListView)
            {
                ObjectUtils.disposeObject(this._weddingRoomListView);
            };
            this._weddingRoomListView = null;
            if (this._weddingRoomListNavView)
            {
                ObjectUtils.disposeObject(this._weddingRoomListNavView);
            };
            this._weddingRoomListNavView = null;
            if (this._cell)
            {
                ObjectUtils.disposeObject(this._cell);
            };
            this._cell = null;
        }


    }
}//package church.view

