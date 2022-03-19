// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//roomList.pvpRoomList.RoomListPlayerListView

package roomList.pvpRoomList
{
    import flash.display.Sprite;
    import com.pickgliss.ui.core.Disposeable;
    import ddt.data.player.SelfInfo;
    import flash.display.MovieClip;
    import flash.display.Bitmap;
    import com.pickgliss.ui.controls.container.VBox;
    import com.pickgliss.ui.text.FilterFrameText;
    import com.pickgliss.ui.controls.ListPanel;
    import road7th.data.DictionaryData;
    import __AS3__.vec.Vector;
    import com.pickgliss.ui.text.GradientText;
    import ddt.manager.PlayerManager;
    import flash.geom.Point;
    import com.pickgliss.utils.ClassUtils;
    import ddt.utils.PositionUtils;
    import com.pickgliss.ui.ComponentFactory;
    import ddt.manager.LanguageMgr;
    import com.pickgliss.events.ListItemEvent;
    import road7th.data.DictionaryEvent;
    import ddt.events.PlayerPropertyEvent;
    import ddt.data.player.PlayerInfo;
    import ddt.manager.SoundManager;
    import com.pickgliss.utils.ObjectUtils;
    import __AS3__.vec.*;

    public class RoomListPlayerListView extends Sprite implements Disposeable 
    {

        private var _selfInfo:SelfInfo;
        protected var _playerListBG:MovieClip;
        protected var _title:Bitmap;
        protected var _characterBg:MovieClip;
        protected var _propbg:MovieClip;
        protected var _listbg2:Bitmap;
        private var _iconContainer:VBox;
        protected var _level:FilterFrameText;
        protected var _sex:FilterFrameText;
        protected var _playerList:ListPanel;
        private var _data:DictionaryData;
        private var _currentItem:RoomListPlayerItem;
        protected var _buffbgVec:Vector.<Bitmap>;
        private var _vipName:GradientText;

        public function RoomListPlayerListView(_arg_1:DictionaryData)
        {
            this._data = _arg_1;
            super();
            this._selfInfo = PlayerManager.Instance.Self;
            this.initbg();
            this.initView();
            this.initEvent();
        }

        public function set type(_arg_1:int):void
        {
        }

        protected function initbg():void
        {
            var _local_1:Point;
            var _local_2:int;
            this._playerListBG = (ClassUtils.CreatInstance("asset.background.roomlist.left") as MovieClip);
            PositionUtils.setPos(this._playerListBG, "asset.ddtRoomlist.pvp.leftbgpos");
            this._title = ComponentFactory.Instance.creatBitmap("asset.ddtroomlist.left.title");
            this._characterBg = (ClassUtils.CreatInstance("asset.ddtroomlist.characterbg") as MovieClip);
            PositionUtils.setPos(this._characterBg, "asset.ddtRoomlist.pvp.left.characterbgpos");
            this._propbg = (ClassUtils.CreatInstance("asset.ddtroomlist.proprbg") as MovieClip);
            PositionUtils.setPos(this._propbg, "asset.ddtRoomlist.pvp.left.propbgpos");
            this._listbg2 = ComponentFactory.Instance.creatBitmap("asset.ddrroomlist.PlayerBg");
            addChild(this._listbg2);
            this._buffbgVec = new Vector.<Bitmap>(6);
            _local_1 = ComponentFactory.Instance.creatCustomObject("asset.ddtRoomlist.pvp.buffbgpos");
            _local_2 = 0;
            while (_local_2 < 6)
            {
                this._buffbgVec[_local_2] = ComponentFactory.Instance.creatBitmap("asset.core.buff.buffTiledBg");
                this._buffbgVec[_local_2].x = (_local_1.x + ((this._buffbgVec[_local_2].width - 1) * _local_2));
                this._buffbgVec[_local_2].y = _local_1.y;
                _local_2++;
            };
            this._level = ComponentFactory.Instance.creatComponentByStylename("asset.ddtroomList.pvp.left.levelText");
            this._level.text = LanguageMgr.GetTranslation("tank.ddtauctionHouse.text.name");
            addChild(this._level);
            this._sex = ComponentFactory.Instance.creatComponentByStylename("asset.ddtroomList.pvp.left.sexText");
            this._sex.text = LanguageMgr.GetTranslation("ddt.roomlist.right.sex");
            addChild(this._sex);
        }

        protected function initView():void
        {
            this._iconContainer = ComponentFactory.Instance.creatComponentByStylename("asset.ddtroomList.pvp.left.iconContainer");
            addChild(this._iconContainer);
            this._playerList = ComponentFactory.Instance.creatComponentByStylename("asset.ddtroomList.pvp.left.playerlistII");
            addChild(this._playerList);
            this._playerList.list.updateListView();
            this._playerList.list.addEventListener(ListItemEvent.LIST_ITEM_CLICK, this.__itemClick);
        }

        private function initEvent():void
        {
            this._data.addEventListener(DictionaryEvent.ADD, this.__addPlayer);
            this._data.addEventListener(DictionaryEvent.REMOVE, this.__removePlayer);
            this._data.addEventListener(DictionaryEvent.UPDATE, this.__updatePlayer);
            PlayerManager.Instance.Self.addEventListener(PlayerPropertyEvent.PROPERTY_CHANGE, this.__updateEverything);
        }

        private function __updateEverything(_arg_1:PlayerPropertyEvent):void
        {
        }

        private function __updatePlayer(_arg_1:DictionaryEvent):void
        {
            var _local_2:PlayerInfo = (_arg_1.data as PlayerInfo);
            this._playerList.vectorListModel.remove(_local_2);
            this._playerList.vectorListModel.insertElementAt(_local_2, this.getInsertIndex(_local_2));
            this._playerList.list.updateListView();
            this.upSelfItem();
        }

        private function __addPlayer(_arg_1:DictionaryEvent):void
        {
            var _local_2:PlayerInfo = (_arg_1.data as PlayerInfo);
            this._playerList.vectorListModel.insertElementAt(_local_2, this.getInsertIndex(_local_2));
            this.upSelfItem();
        }

        private function __removePlayer(_arg_1:DictionaryEvent):void
        {
            var _local_2:PlayerInfo = (_arg_1.data as PlayerInfo);
            this._playerList.vectorListModel.remove(_local_2);
            this.upSelfItem();
        }

        private function upSelfItem():void
        {
            var _local_1:PlayerInfo = this._data[PlayerManager.Instance.Self.ID];
            var _local_2:int = this._playerList.vectorListModel.indexOf(_local_1);
            if (((_local_2 == -1) || (_local_2 == 0)))
            {
                return;
            };
            this._playerList.vectorListModel.removeAt(_local_2);
            this._playerList.vectorListModel.append(_local_1, 0);
        }

        private function __itemClick(_arg_1:ListItemEvent):void
        {
            SoundManager.instance.play("008");
            if ((!(this._currentItem)))
            {
                this._currentItem = (_arg_1.cell as RoomListPlayerItem);
                this._currentItem.setListCellStatus(this._playerList.list, true, _arg_1.index);
            };
            if (this._currentItem != (_arg_1.cell as RoomListPlayerItem))
            {
                this._currentItem.setListCellStatus(this._playerList.list, false, _arg_1.index);
                this._currentItem = (_arg_1.cell as RoomListPlayerItem);
                this._currentItem.setListCellStatus(this._playerList.list, true, _arg_1.index);
            };
        }

        private function getInsertIndex(_arg_1:PlayerInfo):int
        {
            var _local_4:PlayerInfo;
            var _local_2:int;
            var _local_3:Array = this._playerList.vectorListModel.elements;
            if (_local_3.length == 0)
            {
                return (0);
            };
            var _local_5:int = (_local_3.length - 1);
            while (_local_5 >= 0)
            {
                _local_4 = (_local_3[_local_5] as PlayerInfo);
                if (!((_arg_1.IsVIP) && (!(_local_4.IsVIP))))
                {
                    if (((!(_arg_1.IsVIP)) && (_local_4.IsVIP)))
                    {
                        return (_local_5 + 1);
                    };
                    if (_arg_1.IsVIP == _local_4.IsVIP)
                    {
                        if (_arg_1.Grade > _local_4.Grade)
                        {
                            _local_2 = (_local_5 - 1);
                        }
                        else
                        {
                            return (_local_5 + 1);
                        };
                    };
                };
                _local_5--;
            };
            return ((_local_2 < 0) ? 0 : _local_2);
        }

        public function dispose():void
        {
            var _local_1:int;
            this._data.removeEventListener(DictionaryEvent.ADD, this.__addPlayer);
            this._data.removeEventListener(DictionaryEvent.REMOVE, this.__removePlayer);
            this._data.removeEventListener(DictionaryEvent.UPDATE, this.__updatePlayer);
            PlayerManager.Instance.Self.removeEventListener(PlayerPropertyEvent.PROPERTY_CHANGE, this.__updateEverything);
            this._playerList.list.removeEventListener(ListItemEvent.LIST_ITEM_CLICK, this.__itemClick);
            ObjectUtils.disposeObject(this._playerListBG);
            this._playerListBG = null;
            if (this._listbg2)
            {
                ObjectUtils.disposeObject(this._listbg2);
            };
            this._listbg2 = null;
            if (this._title)
            {
                ObjectUtils.disposeObject(this._title);
            };
            this._title = null;
            if (this._characterBg)
            {
                ObjectUtils.disposeObject(this._characterBg);
            };
            this._characterBg = null;
            if (this._propbg)
            {
                ObjectUtils.disposeObject(this._propbg);
            };
            this._propbg = null;
            if (this._level)
            {
                ObjectUtils.disposeObject(this._level);
            };
            this._level = null;
            if (this._sex)
            {
                ObjectUtils.disposeObject(this._sex);
            };
            this._sex = null;
            if (this._buffbgVec)
            {
                _local_1 = 0;
                while (_local_1 < this._buffbgVec.length)
                {
                    ObjectUtils.disposeObject(this._buffbgVec[_local_1]);
                    this._buffbgVec[_local_1] = null;
                    _local_1++;
                };
                this._buffbgVec = null;
            };
            this._playerList.vectorListModel.clear();
            this._playerList.dispose();
            this._playerList = null;
            this._data = null;
            if (this._currentItem)
            {
                this._currentItem.dispose();
            };
            this._currentItem = null;
            if (this.parent)
            {
                this.parent.removeChild(this);
            };
        }


    }
}//package roomList.pvpRoomList

