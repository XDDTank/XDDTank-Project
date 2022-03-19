// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//roomList.pvpRoomList.RoomListItemView

package roomList.pvpRoomList
{
    import flash.display.Sprite;
    import com.pickgliss.ui.core.Disposeable;
    import room.model.RoomInfo;
    import com.pickgliss.ui.image.ScaleFrameImage;
    import flash.display.Bitmap;
    import com.pickgliss.ui.text.FilterFrameText;
    import com.pickgliss.loader.DisplayLoader;
    import flash.filters.ColorMatrixFilter;
    import __AS3__.vec.Vector;
    import com.pickgliss.ui.ComponentFactory;
    import flash.geom.Rectangle;
    import ddt.utils.PositionUtils;
    import flash.geom.Point;
    import com.pickgliss.loader.LoaderEvent;
    import com.pickgliss.loader.LoadResourceManager;
    import ddt.manager.PathManager;
    import com.pickgliss.loader.BaseLoader;
    import com.pickgliss.utils.ObjectUtils;
    import __AS3__.vec.*;

    public class RoomListItemView extends Sprite implements Disposeable 
    {

        private var _info:RoomInfo;
        private var _itemBg:ScaleFrameImage;
        private var _lock:Bitmap;
        private var _nameText:FilterFrameText;
        private var _placeCountText:FilterFrameText;
        private var _watchPlaceCountText:FilterFrameText;
        private var _mapShowLoader:DisplayLoader;
        private var _simpMapLoader:DisplayLoader;
        private var _mapShowContainer:Sprite;
        private var _simpMapShow:Bitmap;
        private var _mapShow:Bitmap;
        private var _mask:Sprite;
        private var _myMatrixFilter:ColorMatrixFilter = new ColorMatrixFilter([0.58516, 0.36563, 0.0492, 0, 0, 0.18516, 0.76564, 0.0492, 0, 0, 0.18516, 0.36563, 0.4492, 0, 0, 0, 0, 0, 1, 0]);
        private var _roomIdVec:Vector.<Bitmap>;

        public function RoomListItemView(_arg_1:RoomInfo)
        {
            this._info = _arg_1;
            super();
            this.init();
        }

        private function init():void
        {
            this.buttonMode = true;
            this._mapShowContainer = new Sprite();
            this._mapShowContainer.graphics.beginFill(0, 0);
            this._mapShowContainer.graphics.drawRect(30, 0, 120, 69);
            this._mapShowContainer.graphics.endFill();
            addChild(this._mapShowContainer);
            this._itemBg = ComponentFactory.Instance.creatComponentByStylename("asset.ddtroomList.pvp.itembg");
            this._itemBg.setFrame(1);
            addChild(this._itemBg);
            this._nameText = ComponentFactory.Instance.creat("asset.ddtroomList.pvp.nameText");
            this._placeCountText = ComponentFactory.Instance.creat("asset.ddtroomList.pvp.placeCountText");
            addChild(this._placeCountText);
            this._lock = ComponentFactory.Instance.creatBitmap("asset.ddtroomlist.item.lock");
            addChild(this._lock);
            var _local_1:Rectangle = ComponentFactory.Instance.creatCustomObject("asset.ddtroomList.item.maskRectangle");
            this._mask = new Sprite();
            this._mask.graphics.beginFill(0, 0);
            this._mask.graphics.drawRoundRect(0, 0, _local_1.width, _local_1.height, _local_1.y);
            this._mask.graphics.endFill();
            PositionUtils.setPos(this._mask, "asset.ddtroomList.item.maskPos");
            addChild(this._mask);
            this.upadte();
        }

        private function upadte():void
        {
            if (this._info.isPlaying)
            {
                this._itemBg.filters = ComponentFactory.Instance.creatFilters("grayFilter");
                this._nameText.setFrame(2);
                this._placeCountText.setFrame(2);
            }
            else
            {
                this._itemBg.filters = null;
                this._nameText.setFrame(1);
                this._placeCountText.setFrame(1);
            };
            if (this._info.type == RoomInfo.MULTI_MATCH)
            {
                this._itemBg.setFrame(1);
            }
            else
            {
                this._itemBg.setFrame((this._info.type + 1));
            };
            this._nameText.text = this._info.Name;
            this.updateRoomId();
            this._lock.visible = this._info.IsLocked;
            var _local_1:String = ((this._info.maxViewerCnt == 0) ? "-" : String(this._info.viewerCnt));
            this._placeCountText.text = ((String(this._info.totalPlayer) + "/") + String(this._info.placeCount));
            this.loadIcon();
        }

        private function updateRoomId():void
        {
            var _local_2:Point;
            var _local_3:int;
            var _local_1:String = this._info.ID.toString();
            this._roomIdVec = new Vector.<Bitmap>(_local_1.length);
            _local_2 = PositionUtils.creatPoint(("asset.ddtroomList.idPos" + _local_1.length));
            _local_3 = 0;
            while (_local_3 < _local_1.length)
            {
                this._roomIdVec[_local_3] = ComponentFactory.Instance.creatBitmap(("asset.ddtroomlist.roomNumber" + _local_1.charAt(_local_3)));
                this._roomIdVec[_local_3].x = (_local_2.x + ((this._roomIdVec[_local_3].width - 2) * _local_3));
                this._roomIdVec[_local_3].y = _local_2.y;
                addChild(this._roomIdVec[_local_3]);
                _local_3++;
            };
        }

        private function loadIcon():void
        {
            if (this._mapShowLoader)
            {
                this._mapShowLoader.removeEventListener(LoaderEvent.COMPLETE, this.__showMap);
            };
            this._mapShowLoader = LoadResourceManager.instance.createLoader(PathManager.solveMapIconPath(this._info.mapId, 1), BaseLoader.BITMAP_LOADER);
            this._mapShowLoader.addEventListener(LoaderEvent.COMPLETE, this.__showMap);
            LoadResourceManager.instance.startLoad(this._mapShowLoader);
            if (this._simpMapLoader)
            {
                this._simpMapLoader.removeEventListener(LoaderEvent.COMPLETE, this.__showSimpMap);
            };
            this._simpMapLoader = LoadResourceManager.instance.createLoader(PathManager.solveMapIconPath(this._info.mapId, 0), BaseLoader.BITMAP_LOADER);
            this._simpMapLoader.addEventListener(LoaderEvent.COMPLETE, this.__showSimpMap);
            LoadResourceManager.instance.startLoad(this._simpMapLoader);
        }

        private function __showMap(_arg_1:LoaderEvent):void
        {
            if (_arg_1.loader.isSuccess)
            {
                ObjectUtils.disposeAllChildren(this._mapShowContainer);
                if (this._mapShow)
                {
                    ObjectUtils.disposeObject(this._mapShow);
                };
                _arg_1.loader.removeEventListener(LoaderEvent.COMPLETE, this.__showMap);
                this._mapShow = (_arg_1.loader.content as Bitmap);
                this._mapShow.scaleX = (75 / this._mapShow.height);
                this._mapShow.scaleY = (75 / this._mapShow.height);
                this._mapShow.smoothing = true;
                if (this._info.isPlaying)
                {
                    this._mapShow.filters = ComponentFactory.Instance.creatFilters("grayFilter");
                }
                else
                {
                    this._mapShow.filters = null;
                };
                PositionUtils.setPos(this._mapShow, "asset.ddtroomList.MapShowPos");
                this._mapShowContainer.addChild(this._mapShow);
                this._mapShowContainer.mask = this._mask;
            };
        }

        private function __showSimpMap(_arg_1:LoaderEvent):void
        {
            if (_arg_1.loader.isSuccess)
            {
                _arg_1.loader.removeEventListener(LoaderEvent.COMPLETE, this.__showSimpMap);
                if (this._simpMapShow)
                {
                    ObjectUtils.disposeObject(this._simpMapShow);
                    this._simpMapShow = null;
                };
                this._simpMapShow = (_arg_1.loader.content as Bitmap);
                if (this._info.isPlaying)
                {
                    this._simpMapShow.filters = ComponentFactory.Instance.creatFilters("grayFilter");
                }
                else
                {
                    this._simpMapShow.filters = null;
                };
                PositionUtils.setPos(this._simpMapShow, "asset.ddtroomList.simpMapPos");
                addChild(this._simpMapShow);
            };
        }

        public function get info():RoomInfo
        {
            return (this._info);
        }

        public function get id():int
        {
            return (this._info.ID);
        }

        public function dispose():void
        {
            var _local_1:int;
            this._info = null;
            ObjectUtils.disposeObject(this._itemBg);
            this._itemBg = null;
            ObjectUtils.disposeObject(this._mapShow);
            this._mapShow = null;
            this._nameText.dispose();
            this._nameText = null;
            this._placeCountText.dispose();
            this._placeCountText = null;
            ObjectUtils.disposeObject(this._lock);
            ObjectUtils.disposeObject(this._simpMapShow);
            this._simpMapShow = null;
            this._lock = null;
            if (this._mapShowContainer)
            {
                if (this._mapShowContainer.parent)
                {
                    this._mapShowContainer.parent.removeChild(this._mapShowContainer);
                };
                ObjectUtils.disposeAllChildren(this._mapShowContainer);
                this._mapShowContainer = null;
            };
            if (this._mapShowLoader != null)
            {
                this._mapShowLoader.removeEventListener(LoaderEvent.COMPLETE, this.__showMap);
                this._mapShowLoader = null;
            };
            if (this._simpMapLoader)
            {
                this._simpMapLoader.removeEventListener(LoaderEvent.COMPLETE, this.__showSimpMap);
                this._simpMapLoader = null;
            };
            if (((this._mask) && (this._mask.parent)))
            {
                ObjectUtils.disposeAllChildren(this._mask);
                this._mask.parent.removeChild(this._mask);
                this._mask = null;
            };
            if (this._roomIdVec)
            {
                _local_1 = 0;
                while (_local_1 < this._roomIdVec.length)
                {
                    ObjectUtils.disposeObject(this._roomIdVec[_local_1]);
                    this._roomIdVec[_local_1] = null;
                    _local_1++;
                };
                this._roomIdVec = null;
            };
            if (parent)
            {
                parent.removeChild(this);
            };
        }


    }
}//package roomList.pvpRoomList

