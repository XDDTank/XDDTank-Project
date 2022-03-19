// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//church.view.weddingRoom.frame.WeddingRoomGuestListView

package church.view.weddingRoom.frame
{
    import flash.display.Sprite;
    import com.pickgliss.ui.core.Disposeable;
    import com.pickgliss.ui.image.Scale9CornerImage;
    import com.pickgliss.ui.image.MutipleImage;
    import church.controller.ChurchRoomController;
    import church.model.ChurchRoomModel;
    import com.pickgliss.ui.controls.BaseButton;
    import com.pickgliss.ui.controls.ListPanel;
    import road7th.data.DictionaryData;
    import com.pickgliss.ui.text.FilterFrameText;
    import com.pickgliss.ui.ComponentFactory;
    import ddt.manager.LanguageMgr;
    import com.pickgliss.events.ListItemEvent;
    import ddt.data.player.PlayerInfo;
    import church.vo.PlayerVO;
    import flash.events.MouseEvent;
    import road7th.data.DictionaryEvent;
    import ddt.manager.PlayerManager;
    import ddt.manager.SoundManager;
    import com.pickgliss.ui.LayerManager;
    import flash.events.Event;

    public class WeddingRoomGuestListView extends Sprite implements Disposeable 
    {

        private var _bg:Scale9CornerImage;
        private var _bg1:MutipleImage;
        private var _itemBg:MutipleImage;
        private var _controller:ChurchRoomController;
        private var _model:ChurchRoomModel;
        private var _btnGuestListClose:BaseButton;
        private var _listPanel:ListPanel;
        private var _data:DictionaryData;
        private var _currentItem:WeddingRoomGuestListItemView;
        private var _titleTxt:FilterFrameText;
        private var _gradeText:FilterFrameText;
        private var _nameText:FilterFrameText;
        private var _sexText:FilterFrameText;

        public function WeddingRoomGuestListView(_arg_1:ChurchRoomController, _arg_2:ChurchRoomModel)
        {
            this._controller = _arg_1;
            this._model = _arg_2;
            this.initialize();
        }

        protected function initialize():void
        {
            this._data = this._model.getPlayers();
            this.setView();
            this.setEvent();
            this.getGuestList();
        }

        private function setView():void
        {
            this._bg = ComponentFactory.Instance.creatComponentByStylename("church.weddingRoom.guestFrameBg");
            addChild(this._bg);
            this._titleTxt = ComponentFactory.Instance.creat("ddtchurchroomlist.frame.WeddingRoomGuestListView.titleText");
            this._titleTxt.text = LanguageMgr.GetTranslation("tank.ddtchurchroomlist.frame.WeddingRoomGuestListView.titleText");
            addChild(this._titleTxt);
            this._bg1 = ComponentFactory.Instance.creat("church.weddingRoom.guestListBg");
            addChild(this._bg1);
            this._itemBg = ComponentFactory.Instance.creatComponentByStylename("church.weddingRoom.frame.WeddingRoomGuestListView.listItemBG");
            addChild(this._itemBg);
            this._gradeText = ComponentFactory.Instance.creat("ddtchurchroomlist.frame.WeddingRoomGuestListView.gradeText");
            this._gradeText.text = LanguageMgr.GetTranslation("consortion.ConsortionTransport.carInfoTip.level.txt");
            addChild(this._gradeText);
            this._nameText = ComponentFactory.Instance.creat("ddtchurchroomlist.frame.WeddingRoomGuestListView.nameText");
            this._nameText.text = LanguageMgr.GetTranslation("itemview.listname");
            addChild(this._nameText);
            this._sexText = ComponentFactory.Instance.creat("ddtchurchroomlist.frame.WeddingRoomGuestListView.sexText");
            this._sexText.text = LanguageMgr.GetTranslation("ddt.roomlist.right.sex");
            addChild(this._sexText);
            this._btnGuestListClose = ComponentFactory.Instance.creat("church.room.guestListCloseAsset");
            addChild(this._btnGuestListClose);
            this._listPanel = ComponentFactory.Instance.creatComponentByStylename("church.room.listGuestListAsset");
            addChild(this._listPanel);
            this._listPanel.list.updateListView();
            this._listPanel.list.addEventListener(ListItemEvent.LIST_ITEM_CLICK, this.itemClick);
        }

        private function getGuestList():void
        {
            var _local_2:PlayerInfo;
            var _local_3:Object;
            this._data.list.sort(this.compareFunction);
            var _local_1:int;
            while (_local_1 < this._data.length)
            {
                _local_2 = (this._data.list[_local_1] as PlayerVO).playerInfo;
                _local_3 = this.changeData(_local_2, (_local_1 + 1));
                this._listPanel.vectorListModel.insertElementAt(_local_3, this.getInsertIndex(_local_2));
                _local_1++;
            };
            this.addSelfItem();
            this.upSelfItem();
        }

        private function compareFunction(_arg_1:PlayerVO, _arg_2:PlayerVO):int
        {
            if (_arg_1.playerInfo.Grade >= _arg_2.playerInfo.Grade)
            {
                return (-1);
            };
            return (1);
        }

        private function itemClick(_arg_1:ListItemEvent):void
        {
            if ((!(this._currentItem)))
            {
                this._currentItem = (_arg_1.cell as WeddingRoomGuestListItemView);
                this._currentItem.setListCellStatus(this._listPanel.list, true, _arg_1.index);
            };
            if (this._currentItem != (_arg_1.cell as WeddingRoomGuestListItemView))
            {
                this._currentItem.setListCellStatus(this._listPanel.list, false, _arg_1.index);
                this._currentItem = (_arg_1.cell as WeddingRoomGuestListItemView);
                this._currentItem.setListCellStatus(this._listPanel.list, true, _arg_1.index);
            };
        }

        private function setEvent():void
        {
            this._btnGuestListClose.addEventListener(MouseEvent.CLICK, this.closeView);
            this._data.addEventListener(DictionaryEvent.ADD, this.addGuest);
            this._data.addEventListener(DictionaryEvent.REMOVE, this.removeGuest);
        }

        private function addGuest(_arg_1:DictionaryEvent):void
        {
            this._listPanel.vectorListModel.clear();
            this.getGuestList();
        }

        private function getInsertIndex(_arg_1:PlayerInfo):int
        {
            var _local_2:int;
            var _local_3:Array = this._listPanel.vectorListModel.elements;
            if (_local_3.length == 0)
            {
                return (0);
            };
            var _local_4:int;
            while (_local_4 < _local_3.length)
            {
                if (_arg_1.Grade > (_local_3[_local_4].playerInfo as PlayerInfo).Grade)
                {
                    return (_local_2);
                };
                if (_arg_1.Grade <= (_local_3[_local_4].playerInfo as PlayerInfo).Grade)
                {
                    _local_2 = (_local_4 + 1);
                };
                _local_4++;
            };
            return (_local_2);
        }

        private function removeGuest(_arg_1:DictionaryEvent):void
        {
            this._listPanel.vectorListModel.clear();
            this.getGuestList();
        }

        private function addSelfItem():void
        {
            this._listPanel.vectorListModel.insertElementAt(this.changeData(PlayerManager.Instance.Self, 0), 0);
        }

        private function upSelfItem():void
        {
            var _local_1:PlayerInfo = this._data[PlayerManager.Instance.Self.ID];
            var _local_2:int = this._listPanel.vectorListModel.indexOf(this.changeData(_local_1, 0));
            if (((_local_2 == -1) || (_local_2 == 0)))
            {
                return;
            };
            this._listPanel.vectorListModel.removeAt(_local_2);
            this._listPanel.vectorListModel.insertElementAt(this.changeData(_local_1, 0), 0);
        }

        private function changeData(_arg_1:PlayerInfo, _arg_2:int):Object
        {
            var _local_3:Object = new Object();
            _local_3["playerInfo"] = _arg_1;
            _local_3["index"] = _arg_2;
            return (_local_3);
        }

        private function closeView(_arg_1:MouseEvent):void
        {
            SoundManager.instance.play("008");
            this.dispose();
        }

        public function show():void
        {
            LayerManager.Instance.addToLayer(this, LayerManager.GAME_TOP_LAYER);
        }

        private function removeView():void
        {
            if (this._bg)
            {
                if (this._bg.parent)
                {
                    this._bg.parent.removeChild(this._bg);
                };
                this._bg.dispose();
            };
            this._bg = null;
            if (this._itemBg)
            {
                if (this._itemBg.parent)
                {
                    this._itemBg.parent.removeChild(this._itemBg);
                };
                this._itemBg.dispose();
            };
            this._itemBg = null;
            if (this._bg1)
            {
                if (this._bg1.parent)
                {
                    this._bg1.parent.removeChild(this._bg1);
                };
                this._bg1.dispose();
            };
            this._bg1 = null;
            if (this._titleTxt)
            {
                if (this._titleTxt.parent)
                {
                    this._titleTxt.parent.removeChild(this._titleTxt);
                };
                this._titleTxt.dispose();
            };
            this._titleTxt = null;
            if (this._gradeText)
            {
                if (this._gradeText.parent)
                {
                    this._gradeText.parent.removeChild(this._gradeText);
                };
                this._gradeText.dispose();
            };
            this._gradeText = null;
            if (this._nameText)
            {
                if (this._nameText.parent)
                {
                    this._nameText.parent.removeChild(this._nameText);
                };
                this._nameText.dispose();
            };
            this._nameText = null;
            if (this._sexText)
            {
                if (this._sexText.parent)
                {
                    this._sexText.parent.removeChild(this._sexText);
                };
                this._sexText.dispose();
            };
            this._sexText = null;
            if (this._btnGuestListClose)
            {
                if (this._btnGuestListClose.parent)
                {
                    this._btnGuestListClose.parent.removeChild(this._btnGuestListClose);
                };
                this._btnGuestListClose.dispose();
            };
            this._btnGuestListClose = null;
            if (this._listPanel)
            {
                if (this._listPanel.parent)
                {
                    this._listPanel.parent.removeChild(this._listPanel);
                };
                this._listPanel.dispose();
            };
            this._listPanel = null;
            if (this._currentItem)
            {
                if (this._currentItem.parent)
                {
                    this._currentItem.parent.removeChild(this._currentItem);
                };
                this._currentItem.dispose();
            };
            this._currentItem = null;
            if (this.parent)
            {
                this.parent.removeChild(this);
            };
            dispatchEvent(new Event(Event.CLOSE));
        }

        private function removeEvent():void
        {
            if (this._btnGuestListClose)
            {
                this._btnGuestListClose.removeEventListener(MouseEvent.CLICK, this.closeView);
            };
            this._data.removeEventListener(DictionaryEvent.ADD, this.addGuest);
            this._data.removeEventListener(DictionaryEvent.REMOVE, this.removeGuest);
        }

        public function dispose():void
        {
            this.removeEvent();
            this.removeView();
        }


    }
}//package church.view.weddingRoom.frame

