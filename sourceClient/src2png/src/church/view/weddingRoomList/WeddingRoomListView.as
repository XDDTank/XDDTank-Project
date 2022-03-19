// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//church.view.weddingRoomList.WeddingRoomListView

package church.view.weddingRoomList
{
    import flash.display.Sprite;
    import com.pickgliss.ui.core.Disposeable;
    import church.controller.ChurchRoomListController;
    import church.model.ChurchRoomListModel;
    import flash.display.Bitmap;
    import com.pickgliss.ui.controls.BaseButton;
    import com.pickgliss.ui.text.FilterFrameText;
    import com.pickgliss.ui.controls.container.VBox;
    import church.view.weddingRoomList.frame.WeddingRoomEnterConfirmView;
    import com.pickgliss.ui.image.MutipleImage;
    import com.pickgliss.ui.image.ScaleLeftRightImage;
    import com.pickgliss.ui.ComponentFactory;
    import com.pickgliss.utils.ObjectUtils;
    import road7th.data.DictionaryEvent;
    import flash.events.MouseEvent;
    import ddt.manager.SoundManager;
    import ddt.data.ChurchRoomInfo;

    public class WeddingRoomListView extends Sprite implements Disposeable 
    {

        private var _controller:ChurchRoomListController;
        private var _model:ChurchRoomListModel;
        private var _rightBg:Bitmap;
        private var _bgJoinListAsset:Bitmap;
        private var _btnPageFirstAsset:BaseButton;
        private var _btnPageBackAsset:BaseButton;
        private var _btnPageNextAsset:BaseButton;
        private var _btnPageLastAsset:BaseButton;
        private var _pageInfoText:FilterFrameText;
        private var _pageCount:int;
        private var _pageIndex:int = 1;
        private var _pageSize:int = 8;
        private var _weddingRoomListBox:VBox;
        private var _enterConfirmView:WeddingRoomEnterConfirmView;
        private var _titleBG:Bitmap;
        private var _itemBG:MutipleImage;
        private var _idTxt:Bitmap;
        private var _roomNameTxt:Bitmap;
        private var _numberTxt:Bitmap;
        private var _lblPageInfoBG:ScaleLeftRightImage;

        public function WeddingRoomListView(_arg_1:ChurchRoomListController, _arg_2:ChurchRoomListModel)
        {
            this._controller = _arg_1;
            this._model = _arg_2;
            this.initialize();
        }

        protected function initialize():void
        {
            this.setView();
            this.setEvent();
            this.updateList();
        }

        private function setView():void
        {
            this._rightBg = ComponentFactory.Instance.creatBitmap("asset.ddtchurch.rightViewBg");
            addChild(this._rightBg);
            this._bgJoinListAsset = ComponentFactory.Instance.creatBitmap("asset.church.main.bgNavAsset");
            addChild(this._bgJoinListAsset);
            this._titleBG = ComponentFactory.Instance.creatBitmap("asset.church.main.bgJoinListAsset");
            addChild(this._titleBG);
            this._idTxt = ComponentFactory.Instance.creatBitmap("church.main.WeddingRoomList.idTxt");
            addChild(this._idTxt);
            this._roomNameTxt = ComponentFactory.Instance.creatBitmap("church.main.WeddingRoomList.roomNameTxt");
            addChild(this._roomNameTxt);
            this._numberTxt = ComponentFactory.Instance.creatBitmap("church.main.WeddingRoomList.numberTxt");
            addChild(this._numberTxt);
            this._itemBG = ComponentFactory.Instance.creatComponentByStylename("church.main.WeddingRoomListItem.BG");
            addChild(this._itemBG);
            this._weddingRoomListBox = ComponentFactory.Instance.creat("asset.church.main.WeddingRoomListBoxAsset");
            addChild(this._weddingRoomListBox);
            this._lblPageInfoBG = ComponentFactory.Instance.creatComponentByStylename("church.main.lblPageInfo.wordBG");
            addChild(this._lblPageInfoBG);
            this._btnPageFirstAsset = ComponentFactory.Instance.creat("church.main.btnPageFirstAsset");
            addChild(this._btnPageFirstAsset);
            this._btnPageBackAsset = ComponentFactory.Instance.creat("church.main.btnPageBackAsset");
            addChild(this._btnPageBackAsset);
            this._btnPageNextAsset = ComponentFactory.Instance.creat("church.main.btnPageNextAsset");
            addChild(this._btnPageNextAsset);
            this._btnPageLastAsset = ComponentFactory.Instance.creat("church.main.btnPageLastAsset");
            addChild(this._btnPageLastAsset);
            this._pageInfoText = ComponentFactory.Instance.creat("church.main.lblPageInfo");
            addChild(this._pageInfoText);
        }

        private function removeView():void
        {
            if (this._rightBg)
            {
                if (this._rightBg.parent)
                {
                    this._rightBg.parent.removeChild(this._rightBg);
                };
            };
            this._rightBg = null;
            if (this._bgJoinListAsset)
            {
                if (this._bgJoinListAsset.parent)
                {
                    this._bgJoinListAsset.parent.removeChild(this._bgJoinListAsset);
                };
            };
            this._bgJoinListAsset = null;
            if (this._titleBG)
            {
                if (this._titleBG.parent)
                {
                    this._titleBG.parent.removeChild(this._titleBG);
                };
                this._titleBG.bitmapData.dispose();
                this._titleBG.bitmapData = null;
            };
            this._titleBG = null;
            this._itemBG = null;
            this._lblPageInfoBG.dispose();
            this._lblPageInfoBG = null;
            this._idTxt = null;
            this._roomNameTxt = null;
            this._numberTxt = null;
            if (this._btnPageFirstAsset)
            {
                if (this._btnPageFirstAsset.parent)
                {
                    this._btnPageFirstAsset.parent.removeChild(this._btnPageFirstAsset);
                };
                this._btnPageFirstAsset.dispose();
            };
            this._btnPageFirstAsset = null;
            if (this._btnPageBackAsset)
            {
                if (this._btnPageBackAsset.parent)
                {
                    this._btnPageBackAsset.parent.removeChild(this._btnPageBackAsset);
                };
                this._btnPageBackAsset.dispose();
            };
            this._btnPageBackAsset = null;
            if (this._btnPageNextAsset)
            {
                if (this._btnPageNextAsset.parent)
                {
                    this._btnPageNextAsset.parent.removeChild(this._btnPageNextAsset);
                };
                this._btnPageNextAsset.dispose();
            };
            this._btnPageNextAsset = null;
            if (this._btnPageLastAsset)
            {
                if (this._btnPageLastAsset.parent)
                {
                    this._btnPageLastAsset.parent.removeChild(this._btnPageLastAsset);
                };
                this._btnPageLastAsset.dispose();
            };
            this._btnPageLastAsset = null;
            if (this._enterConfirmView)
            {
                if (this._enterConfirmView.parent)
                {
                    this._enterConfirmView.parent.removeChild(this._enterConfirmView);
                };
                this._enterConfirmView.dispose();
            };
            this._enterConfirmView = null;
            if (this._pageInfoText)
            {
                ObjectUtils.disposeObject(this._pageInfoText);
            };
            this._pageInfoText = null;
            if (this._weddingRoomListBox)
            {
                ObjectUtils.disposeObject(this._weddingRoomListBox);
            };
            this._weddingRoomListBox = null;
        }

        private function setEvent():void
        {
            this._model.roomList.addEventListener(DictionaryEvent.ADD, this.updateList);
            this._model.roomList.addEventListener(DictionaryEvent.REMOVE, this.updateList);
            this._model.roomList.addEventListener(DictionaryEvent.UPDATE, this.updateList);
            this._btnPageFirstAsset.addEventListener(MouseEvent.CLICK, this.getPageList);
            this._btnPageBackAsset.addEventListener(MouseEvent.CLICK, this.getPageList);
            this._btnPageNextAsset.addEventListener(MouseEvent.CLICK, this.getPageList);
            this._btnPageLastAsset.addEventListener(MouseEvent.CLICK, this.getPageList);
        }

        private function removeEvent():void
        {
            this._model.roomList.removeEventListener(DictionaryEvent.ADD, this.updateList);
            this._model.roomList.removeEventListener(DictionaryEvent.REMOVE, this.updateList);
            this._model.roomList.removeEventListener(DictionaryEvent.UPDATE, this.updateList);
            this._btnPageFirstAsset.removeEventListener(MouseEvent.CLICK, this.getPageList);
            this._btnPageBackAsset.removeEventListener(MouseEvent.CLICK, this.getPageList);
            this._btnPageNextAsset.removeEventListener(MouseEvent.CLICK, this.getPageList);
            this._btnPageLastAsset.removeEventListener(MouseEvent.CLICK, this.getPageList);
        }

        private function getPageList(_arg_1:MouseEvent):void
        {
            SoundManager.instance.play("008");
            switch (_arg_1.target)
            {
                case this._btnPageFirstAsset:
                    this.pageIndex = 1;
                    return;
                case this._btnPageBackAsset:
                    this.pageIndex = (((this.pageIndex - 1) > 0) ? (this.pageIndex - 1) : 1);
                    return;
                case this._btnPageNextAsset:
                    this.pageIndex = (((this.pageIndex + 1) <= this.pageCount) ? (this.pageIndex + 1) : this.pageCount);
                    return;
                case this._btnPageLastAsset:
                    this.pageIndex = this.pageCount;
                    return;
            };
        }

        public function updateList(_arg_1:DictionaryEvent=null):void
        {
            var _local_3:ChurchRoomInfo;
            var _local_4:WeddingRoomListItemView;
            this._weddingRoomListBox.disposeAllChildren();
            this._btnPageFirstAsset.enable = (this._btnPageBackAsset.enable = ((this.pageCount > 0) && (this.pageIndex > 1)));
            this._btnPageNextAsset.enable = (this._btnPageLastAsset.enable = ((this.pageCount > 0) && (this.pageIndex < this.pageCount)));
            this.updatePageText();
            if (((!(this.currentDataList)) || (this.currentDataList.length <= 0)))
            {
                return;
            };
            var _local_2:Array = this.currentDataList.slice(((this._pageIndex * this._pageSize) - this._pageSize), (((this._pageIndex * this._pageSize) <= this.currentDataList.length) ? (this._pageIndex * this._pageSize) : this.currentDataList.length));
            for each (_local_3 in _local_2)
            {
                _local_4 = ComponentFactory.Instance.creatCustomObject("church.view.WeddingRoomListItemView");
                _local_4.churchRoomInfo = _local_3;
                this._weddingRoomListBox.addChild(_local_4);
                _local_4.addEventListener(MouseEvent.CLICK, this.__itemClick);
            };
        }

        private function updatePageText():void
        {
            this._pageInfoText.text = ((this._pageIndex + "/") + this._pageCount);
        }

        private function __itemClick(_arg_1:MouseEvent):void
        {
            SoundManager.instance.play("008");
            _arg_1.stopImmediatePropagation();
            var _local_2:WeddingRoomListItemView = (_arg_1.currentTarget as WeddingRoomListItemView);
            this._enterConfirmView = ComponentFactory.Instance.creat("church.main.weddingRoomList.WeddingRoomEnterConfirmView");
            this._enterConfirmView.controller = this._controller;
            this._enterConfirmView.churchRoomInfo = _local_2.churchRoomInfo;
            this._enterConfirmView.show();
        }

        public function get currentDataList():Array
        {
            var _local_1:Array;
            if (((this._model) && (this._model.roomList)))
            {
                _local_1 = this._model.roomList.list;
                _local_1.sortOn("id", Array.NUMERIC);
                return (_local_1);
            };
            return (null);
        }

        public function get pageIndex():int
        {
            return (this._pageIndex);
        }

        public function set pageIndex(_arg_1:int):void
        {
            this._pageIndex = _arg_1;
            this.updateList();
        }

        public function get pageCount():int
        {
            this._pageCount = (this.currentDataList.length / this._pageSize);
            if ((this.currentDataList.length % this._pageSize) > 0)
            {
                this._pageCount = (this._pageCount + 1);
            };
            this._pageCount = ((this._pageCount == 0) ? 1 : this._pageCount);
            return (this._pageCount);
        }

        public function dispose():void
        {
            this.removeEvent();
            this.removeView();
        }


    }
}//package church.view.weddingRoomList

