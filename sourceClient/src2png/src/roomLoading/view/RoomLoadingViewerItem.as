// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//roomLoading.view.RoomLoadingViewerItem

package roomLoading.view
{
    import flash.display.Sprite;
    import com.pickgliss.ui.core.Disposeable;
    import __AS3__.vec.Vector;
    import room.view.RoomViewerItem;
    import flash.display.Bitmap;
    import room.model.RoomPlayer;
    import ddt.utils.PositionUtils;
    import com.pickgliss.ui.ComponentFactory;
    import game.GameManager;
    import __AS3__.vec.*;

    public class RoomLoadingViewerItem extends Sprite implements Disposeable 
    {

        private static const MAX_VIEWER:int = 2;

        private var _viewerItems:Vector.<RoomViewerItem>;

        public function RoomLoadingViewerItem()
        {
            this.init();
        }

        public function init():void
        {
            var _local_2:int;
            var _local_4:RoomViewerItem;
            var _local_5:Bitmap;
            this._viewerItems = new Vector.<RoomViewerItem>();
            var _local_1:Vector.<RoomPlayer> = this.findViewers();
            _local_2 = 0;
            while (_local_2 < _local_1.length)
            {
                _local_4 = new RoomViewerItem(_local_1[_local_2].place);
                _local_4.changeBg();
                this._viewerItems.push(_local_4);
                this._viewerItems[_local_2].loadingMode = true;
                this._viewerItems[_local_2].info = _local_1[_local_2];
                this._viewerItems[_local_2].mouseEnabled = (this._viewerItems[_local_2].mouseChildren = false);
                PositionUtils.setPos(this._viewerItems[_local_2], ("asset.roomLoading.ViewerItemPos_" + String(_local_2)));
                addChild(this._viewerItems[_local_2]);
                _local_2++;
            };
            var _local_3:int = MAX_VIEWER;
            while (_local_3 > _local_1.length)
            {
                _local_5 = ComponentFactory.Instance.creatBitmap("asset.roomloading.noViewer");
                PositionUtils.setPos(_local_5, ("asset.roomLoading.ViewerItemPos_" + (_local_3 - 1).toString()));
                addChild(_local_5);
                _local_3--;
            };
        }

        private function findViewers():Vector.<RoomPlayer>
        {
            var _local_3:RoomPlayer;
            var _local_1:Array = new Array();
            if (GameManager.Instance.Current)
            {
                _local_1 = GameManager.Instance.Current.roomPlayers;
            };
            var _local_2:Vector.<RoomPlayer> = new Vector.<RoomPlayer>();
            for each (_local_3 in _local_1)
            {
                if (_local_3.isViewer)
                {
                    _local_2.push(_local_3);
                };
            };
            return (_local_2);
        }

        public function dispose():void
        {
            var _local_1:RoomViewerItem;
            for each (_local_1 in this._viewerItems)
            {
                _local_1.dispose();
                _local_1 = null;
            };
            this._viewerItems = null;
            if (parent)
            {
                parent.removeChild(this);
            };
        }


    }
}//package roomLoading.view

