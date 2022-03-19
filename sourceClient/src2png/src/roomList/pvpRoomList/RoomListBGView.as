// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//roomList.pvpRoomList.RoomListBGView

package roomList.pvpRoomList
{
    import flash.display.Sprite;
    import com.pickgliss.ui.core.Disposeable;
    import ddt.manager.LanguageMgr;
    import flash.display.Bitmap;
    import com.pickgliss.ui.image.MutipleImage;
    import com.pickgliss.ui.image.ScaleLeftRightImage;
    import com.pickgliss.ui.controls.SimpleBitmapButton;
    import com.pickgliss.ui.controls.container.SimpleTileList;
    import com.pickgliss.ui.controls.ComboBox;
    import com.pickgliss.ui.image.Scale9CornerImage;
    import com.pickgliss.ui.controls.BaseButton;
    import com.pickgliss.ui.controls.TextButton;
    import roomList.LookupRoomView;
    import com.pickgliss.ui.controls.alert.BaseAlerFrame;
    import road7th.data.DictionaryData;
    import com.pickgliss.ui.ComponentFactory;
    import ddt.utils.PositionUtils;
    import ddt.manager.PlayerManager;
    import flash.events.MouseEvent;
    import road7th.data.DictionaryEvent;
    import com.pickgliss.events.ListItemEvent;
    import flash.events.Event;
    import ddt.manager.SoundManager;
    import com.pickgliss.ui.controls.list.VectorListModel;
    import ddt.manager.SocketManager;
    import roomList.LookupEnumerate;
    import room.model.RoomInfo;
    import ddt.manager.MessageTipManager;
    import __AS3__.vec.Vector;
    import flash.utils.getTimer;
    import ddt.manager.GameInSocketOut;
    import com.pickgliss.ui.AlertManager;
    import com.pickgliss.ui.LayerManager;
    import com.pickgliss.events.FrameEvent;
    import arena.ArenaManager;
    import com.pickgliss.utils.ObjectUtils;
    import __AS3__.vec.*;

    public class RoomListBGView extends Sprite implements Disposeable 
    {

        public static var PREWORD:Array = [LanguageMgr.GetTranslation("tank.roomlist.RoomListIICreatePveRoomView.tank"), LanguageMgr.GetTranslation("tank.roomlist.RoomListIICreatePveRoomView.go"), LanguageMgr.GetTranslation("tank.roomlist.RoomListIICreatePveRoomView.fire")];
        public static const FULL_MODE:int = 2;
        public static const ATHLETICS_MODE:int = 0;
        public static const CHALLENGE_MODE:int = 1;

        private var _roomListBG:Bitmap;
        private var _titleBg:Bitmap;
        private var _itemlistBg:MutipleImage;
        private var _itemlistBg2:ScaleLeftRightImage;
        private var _title:Bitmap;
        private var _listTitle:Bitmap;
        private var _nextBtn:SimpleBitmapButton;
        private var _preBtn:SimpleBitmapButton;
        private var _mutiBtn:SimpleBitmapButton;
        private var _singleBtn:SimpleBitmapButton;
        private var _lookUpBtn:SimpleBitmapButton;
        private var _itemList:SimpleTileList;
        private var _itemArray:Array;
        private var _model:RoomListModel;
        private var _controller:RoomListController;
        private var _tempDataList:Array;
        private var _modeMenu:ComboBox;
        private var _currentMode:int;
        private var _isPermissionEnter:Boolean;
        private var _modeArray:Array = ["ddt.roomList.roomListBG.Athletics", "ddt.roomList.roomListBG.challenge", "ddt.roomList.roomListBG.full"];
        private var _buttonBg:Scale9CornerImage;
        private var _createBtn:BaseButton;
        private var _arenaBtn:BaseButton;
        private var _refreshBtn:TextButton;
        private var _lookupRoom:LookupRoomView;
        private var _Verticalline:Bitmap;
        private var _expeditionAlert:BaseAlerFrame;
        private var _randomlist:DictionaryData = new DictionaryData();
        private var _selectItemPos:int;
        private var _selectItemID:int;
        private var _lastClick:Number;
        private var _lastCreatTime:int = 0;

        public function RoomListBGView(_arg_1:RoomListController, _arg_2:RoomListModel)
        {
            this._model = _arg_2;
            this._controller = _arg_1;
            super();
            this.init();
            this.initEvent();
        }

        private function init():void
        {
            this._roomListBG = ComponentFactory.Instance.creatBitmap("asset.ddtroomlist.Mainbg");
            this._Verticalline = ComponentFactory.Instance.creatBitmap("asset.ddtroomlist.line2");
            this._buttonBg = ComponentFactory.Instance.creatComponentByStylename("ddtroomlist.btnBg");
            this._itemlistBg = ComponentFactory.Instance.creatComponentByStylename("asset.ddtroomList.pvp.itemlistBg");
            this._itemlistBg2 = ComponentFactory.Instance.creatComponentByStylename("asset.ddtroomList.pvp.itemlistBg2");
            this._titleBg = ComponentFactory.Instance.creatBitmap("asset.ddtcivil.titleBg");
            PositionUtils.setPos(this._titleBg, "asset.ddtRoomlist.pvp.titlebgpos");
            this._title = ComponentFactory.Instance.creatBitmap("asset.ddtroomlist.right.title");
            this._listTitle = ComponentFactory.Instance.creatBitmap("asset.ddtroomlist.right.listtitle");
            this._modeMenu = ComponentFactory.Instance.creatComponentByStylename("asset.ddtRoomlist.pvp.modeMenu");
            this._modeMenu.textField.text = LanguageMgr.GetTranslation(this._modeArray[FULL_MODE]);
            this._lookupRoom = ComponentFactory.Instance.creatCustomObject("ddtroomlistLookupRoomView", [0]);
            this._model.currentType = FULL_MODE;
            this._itemArray = [];
            this._itemList = ComponentFactory.Instance.creat("asset.ddtRoomList.pvp.itemContainer", [3]);
            this.updateList();
            addChild(this._roomListBG);
            addChild(this._Verticalline);
            addChild(this._buttonBg);
            addChild(this._modeMenu);
            addChild(this._lookupRoom);
            addChild(this._itemList);
            this.initButton();
            this._isPermissionEnter = true;
        }

        private function initButton():void
        {
            this._createBtn = ComponentFactory.Instance.creatComponentByStylename("ddtroomList.openBtn");
            this._refreshBtn = ComponentFactory.Instance.creatComponentByStylename("ddtroomlist.roomRefresh_btn");
            this._refreshBtn.text = LanguageMgr.GetTranslation("ddt.roomList.refreshTxt");
            this._nextBtn = ComponentFactory.Instance.creatComponentByStylename("asset.ddtroomList.pvp.nextBtn");
            this._preBtn = ComponentFactory.Instance.creatComponentByStylename("asset.ddtroomList.pvp.preBtn");
            this._singleBtn = ComponentFactory.Instance.creatComponentByStylename("asset.ddtroomList.pvp.singleBtn");
            this._singleBtn.tipData = LanguageMgr.GetTranslation("tank.roomlist.joinSingleBattle");
            this._mutiBtn = ComponentFactory.Instance.creatComponentByStylename("asset.ddtroomList.pvp.mutiBtn");
            this._mutiBtn.tipData = LanguageMgr.GetTranslation("tank.roomlist.joinMutiBattle");
            this._lookUpBtn = ComponentFactory.Instance.creatComponentByStylename("asset.ddtroomList.pvp.searchBtn");
            this._lookUpBtn.tipData = LanguageMgr.GetTranslation("tank.roomlist.RoomListIIRoomBtnPanel.findRoom");
            this._arenaBtn = ComponentFactory.Instance.creatComponentByStylename("ddtroomList.arenaBtn");
            this.addTipPanel();
            addChild(this._createBtn);
            addChild(this._arenaBtn);
            addChild(this._refreshBtn);
            this._mutiBtn.mouseEnabled = false;
            this._mutiBtn.filters = ComponentFactory.Instance.creatFilters("grayFilter");
            if (PlayerManager.Instance.Self.Grade >= 13)
            {
                this._mutiBtn.mouseEnabled = true;
                this._mutiBtn.filters = null;
            };
        }

        private function initEvent():void
        {
            this._createBtn.addEventListener(MouseEvent.CLICK, this._mutiBtnClick);
            this._refreshBtn.addEventListener(MouseEvent.CLICK, this.__updateClick);
            this._singleBtn.addEventListener(MouseEvent.CLICK, this.__singleBtnClick);
            this._mutiBtn.addEventListener(MouseEvent.CLICK, this._mutiBtnClick);
            this._lookUpBtn.addEventListener(MouseEvent.CLICK, this.__lookupClick);
            this._nextBtn.addEventListener(MouseEvent.CLICK, this.__updateClick);
            this._preBtn.addEventListener(MouseEvent.CLICK, this.__updateClick);
            this._model.addEventListener(RoomListModel.ROOM_ITEM_UPDATE, this.__updateItem);
            this._model.getRoomList().addEventListener(DictionaryEvent.CLEAR, this.__clearRoom);
            this._modeMenu.listPanel.list.addEventListener(ListItemEvent.LIST_ITEM_CLICK, this.__onListClick);
            this._modeMenu.button.addEventListener(MouseEvent.CLICK, this.__clickMenuBtn);
            this._arenaBtn.addEventListener(MouseEvent.CLICK, this.__arenaClick);
        }

        private function removeEvent():void
        {
            this._createBtn.removeEventListener(MouseEvent.CLICK, this._mutiBtnClick);
            this._arenaBtn.removeEventListener(MouseEvent.CLICK, this.__arenaClick);
            this._refreshBtn.removeEventListener(MouseEvent.CLICK, this.__updateClick);
            this._singleBtn.removeEventListener(MouseEvent.CLICK, this.__singleBtnClick);
            this._mutiBtn.removeEventListener(MouseEvent.CLICK, this._mutiBtnClick);
            this._lookUpBtn.removeEventListener(MouseEvent.CLICK, this.__lookupClick);
            this._nextBtn.removeEventListener(MouseEvent.CLICK, this.__updateClick);
            this._preBtn.removeEventListener(MouseEvent.CLICK, this.__updateClick);
            this._model.removeEventListener(RoomListModel.ROOM_ITEM_UPDATE, this.__updateItem);
            this._modeMenu.listPanel.list.removeEventListener(ListItemEvent.LIST_ITEM_CLICK, this.__onListClick);
            this._modeMenu.button.removeEventListener(MouseEvent.CLICK, this.__clickMenuBtn);
            if (this._model.getRoomList())
            {
                this._model.getRoomList().removeEventListener(DictionaryEvent.CLEAR, this.__clearRoom);
            };
        }

        private function __updateItem(_arg_1:Event):void
        {
            this.upadteItemPos();
            this._isPermissionEnter = true;
        }

        private function __onListClick(_arg_1:ListItemEvent):void
        {
            SoundManager.instance.play("008");
            this._model.currentType = this.getCurrentMode(_arg_1.cellValue);
            this.addTipPanel();
        }

        private function __clickMenuBtn(_arg_1:MouseEvent):void
        {
            SoundManager.instance.play("008");
        }

        private function getCurrentMode(_arg_1:String):int
        {
            var _local_2:int;
            while (_local_2 < this._modeArray.length)
            {
                if (LanguageMgr.GetTranslation(this._modeArray[_local_2]) == _arg_1)
                {
                    return (_local_2);
                };
                _local_2++;
            };
            return (-1);
        }

        private function addTipPanel():void
        {
            var _local_1:VectorListModel = this._modeMenu.listPanel.vectorListModel;
            _local_1.clear();
            switch (this._model.currentType)
            {
                case FULL_MODE:
                    _local_1.append(LanguageMgr.GetTranslation(this._modeArray[ATHLETICS_MODE]));
                    _local_1.append(LanguageMgr.GetTranslation(this._modeArray[CHALLENGE_MODE]));
                    SocketManager.Instance.out.sendUpdateRoomList(LookupEnumerate.ROOM_LIST, LookupEnumerate.ROOMLIST_DEFAULT);
                    return;
                case ATHLETICS_MODE:
                    _local_1.append(LanguageMgr.GetTranslation(this._modeArray[FULL_MODE]));
                    _local_1.append(LanguageMgr.GetTranslation(this._modeArray[CHALLENGE_MODE]));
                    SocketManager.Instance.out.sendUpdateRoomList(LookupEnumerate.ROOM_LIST, LookupEnumerate.ROOMLIST_ATHLETICTICS);
                    return;
                case CHALLENGE_MODE:
                    _local_1.append(LanguageMgr.GetTranslation(this._modeArray[FULL_MODE]));
                    _local_1.append(LanguageMgr.GetTranslation(this._modeArray[ATHLETICS_MODE]));
                    SocketManager.Instance.out.sendUpdateRoomList(LookupEnumerate.ROOM_LIST, LookupEnumerate.ROOMLIST_DEFY);
                    return;
            };
        }

        private function __clearRoom(_arg_1:DictionaryEvent):void
        {
            this.cleanItem();
            this._isPermissionEnter = true;
        }

        private function updateList():void
        {
            var _local_1:int;
            var _local_2:RoomInfo;
            var _local_3:RoomListItemView;
            var _local_4:int;
            var _local_5:int;
            var _local_6:RoomInfo;
            var _local_7:RoomListItemView;
            this.cleanItem();
            if (this._model.getRoomList().length == 0)
            {
                this.randomRoomlist();
            }
            else
            {
                if (this._model.getRoomList().length < 6)
                {
                    _local_1 = 0;
                    for (;_local_1 < 6;_local_1++)
                    {
                        if (_local_1 < this._model.getRoomList().length)
                        {
                            _local_2 = this._model.getRoomList().list[_local_1];
                            if ((!(_local_2))) continue;
                            _local_3 = new RoomListItemView(_local_2);
                            _local_3.addEventListener(MouseEvent.CLICK, this.__itemClick);
                            this._itemList.addChild(_local_3);
                            this._itemArray.push(_local_3);
                        }
                        else
                        {
                            this.randomRoomlist();
                        };
                    };
                }
                else
                {
                    _local_5 = 0;
                    while (_local_5 < this._model.getPlayerList().length)
                    {
                        _local_4++;
                        if (_local_4 >= 7) break;
                        _local_6 = this._model.getRoomList().list[_local_1];
                        if (!(!(_local_6)))
                        {
                            _local_7 = new RoomListItemView(_local_6);
                            _local_7.addEventListener(MouseEvent.CLICK, this.__itemClick);
                            this._itemList.addChild(_local_7);
                            this._itemArray.push(_local_7);
                        };
                        _local_5++;
                    };
                };
            };
        }

        private function randomRoomlist():void
        {
            var _local_2:RoomInfo;
            var _local_3:RoomListItemView;
            this.randomList.clear();
            var _local_1:int;
            while (_local_1 < (6 - this._model.getRoomList().length))
            {
                _local_2 = new RoomInfo();
                _local_2.ID = this.randomRoomId();
                _local_2.type = this.randomRoomtype();
                if (_local_2.type == 1)
                {
                    _local_2.mapId = this.randomMapId();
                };
                _local_2.isPlaying = true;
                _local_2.totalPlayer = 3;
                _local_2.placeCount = 3;
                _local_3 = new RoomListItemView(_local_2);
                _local_3.addEventListener(MouseEvent.CLICK, this.__itemClickOne);
                this._itemList.addChild(_local_3);
                this._itemArray.push(_local_3);
                _local_1++;
            };
        }

        private function __itemClickOne(_arg_1:MouseEvent):void
        {
            SoundManager.instance.play("008");
            return (MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.roomlist.RoomIsStart")));
        }

        private function getAllRoomId():Vector.<int>
        {
            var _local_3:RoomInfo;
            var _local_1:Vector.<int> = new Vector.<int>();
            var _local_2:DictionaryData = this._model.getRoomList();
            for each (_local_3 in _local_2)
            {
                _local_1.push(_local_3.ID);
            };
            return (_local_1);
        }

        public function get randomList():DictionaryData
        {
            return (this._randomlist);
        }

        public function set randomList(_arg_1:DictionaryData):void
        {
            this._randomlist = _arg_1;
        }

        private function randomRoomId():int
        {
            var _local_1:int;
            while (true)
            {
                _local_1 = (int((Math.random() * 100)) + 1);
                if (((!(this._model.getRoomList().hasKey(_local_1))) && (!(this.randomList.hasKey(_local_1)))))
                {
                    this.randomList.add(_local_1, _local_1);
                    break;
                };
            };
            return (_local_1);
        }

        private function randomRoomtype():int
        {
            var _local_1:int;
            if (this._model.currentType == FULL_MODE)
            {
                _local_1 = (Math.random() * 2);
            }
            else
            {
                _local_1 = this._model.currentType;
            };
            return (_local_1);
        }

        private function randomMapId():int
        {
            var _local_1:Array = ["1001", "1002", "1003", "1004", "1005", "1006"];
            return (int(_local_1[Math.floor((Math.random() * _local_1.length))]));
        }

        private function cleanItem():void
        {
            var _local_1:int;
            while (_local_1 < this._itemArray.length)
            {
                (this._itemArray[_local_1] as RoomListItemView).removeEventListener(MouseEvent.CLICK, this.__itemClick);
                (this._itemArray[_local_1] as RoomListItemView).dispose();
                _local_1++;
            };
            this._itemList.disposeAllChildren();
            this._itemArray = [];
        }

        private function __itemClick(_arg_1:MouseEvent):void
        {
            if ((!(this._isPermissionEnter)))
            {
                return;
            };
            this.gotoIntoRoom((_arg_1.currentTarget as RoomListItemView).info);
            this.getSelectItemPos((_arg_1.currentTarget as RoomListItemView).id);
        }

        private function getSelectItemPos(_arg_1:int):int
        {
            if ((!(this._itemList)))
            {
                return (0);
            };
            var _local_2:int;
            while (_local_2 < this._itemArray.length)
            {
                if ((!(this._itemArray[_local_2] as RoomListItemView)))
                {
                    return (0);
                };
                if ((this._itemArray[_local_2] as RoomListItemView).id == _arg_1)
                {
                    this._selectItemPos = _local_2;
                    this._selectItemID = (this._itemArray[_local_2] as RoomListItemView).id;
                    return (_local_2);
                };
                _local_2++;
            };
            return (0);
        }

        public function get currentDataList():Array
        {
            if (this._model.roomShowMode == 1)
            {
                return (this._model.getRoomList().filter("isPlaying", false).concat(this._model.getRoomList().filter("isPlaying", true)));
            };
            return (this._model.getRoomList().list);
        }

        private function getInfosPos(_arg_1:int):int
        {
            this._tempDataList = this.currentDataList;
            if ((!(this._tempDataList)))
            {
                return (0);
            };
            var _local_2:int;
            while (_local_2 < this._tempDataList.length)
            {
                if ((this._tempDataList[_local_2] as RoomInfo).ID == _arg_1)
                {
                    return (_local_2);
                };
                _local_2++;
            };
            return (0);
        }

        private function upadteItemPos():void
        {
            var _local_1:int;
            var _local_2:RoomInfo;
            var _local_3:RoomListItemView;
            var _local_4:RoomInfo;
            var _local_5:RoomListItemView;
            var _local_6:int;
            var _local_7:RoomInfo;
            var _local_8:RoomListItemView;
            this.cleanItem();
            this.randomList.clear();
            this._tempDataList = this.currentDataList;
            if (this._tempDataList)
            {
                if (this._tempDataList.length < 6)
                {
                    _local_1 = 0;
                    for (;_local_1 < 6;_local_1++)
                    {
                        if (_local_1 < this._tempDataList.length)
                        {
                            _local_2 = this._tempDataList[_local_1];
                            if ((!(_local_2))) continue;
                            _local_3 = new RoomListItemView(_local_2);
                            _local_3.addEventListener(MouseEvent.CLICK, this.__itemClick);
                            this._itemList.addChild(_local_3);
                            this._itemArray.push(_local_3);
                        }
                        else
                        {
                            _local_4 = new RoomInfo();
                            _local_4.ID = this.randomRoomId();
                            _local_4.type = this.randomRoomtype();
                            if (_local_4.type == 1)
                            {
                                _local_4.mapId = this.randomMapId();
                            };
                            _local_4.isPlaying = true;
                            _local_4.totalPlayer = 3;
                            _local_4.placeCount = 3;
                            _local_5 = new RoomListItemView(_local_4);
                            _local_5.addEventListener(MouseEvent.CLICK, this.__itemClickOne);
                            this._itemList.addChild(_local_5);
                            this._itemArray.push(_local_5);
                        };
                    };
                }
                else
                {
                    _local_6 = 0;
                    for each (_local_7 in this._tempDataList)
                    {
                        _local_6++;
                        if (_local_6 >= 7) break;
                        if (!(!(_local_7)))
                        {
                            _local_8 = new RoomListItemView(_local_7);
                            _local_8.addEventListener(MouseEvent.CLICK, this.__itemClick);
                            this._itemList.addChild(_local_8);
                            this._itemArray.push(_local_8);
                        };
                    };
                };
            };
        }

        private function sortRooInfo(_arg_1:Array):Array
        {
            var _local_3:int;
            var _local_4:RoomInfo;
            var _local_2:Array = new Array();
            switch (this._model.currentType)
            {
                case ATHLETICS_MODE:
                    _local_3 = 0;
                    break;
                case CHALLENGE_MODE:
                    _local_3 = 1;
                    break;
            };
            for each (_local_4 in _arg_1)
            {
                if (!(!(_local_4)))
                {
                    if (((_local_4.type == _local_3) && (!(_local_4.isPlaying))))
                    {
                        _local_2.unshift(_local_4);
                    }
                    else
                    {
                        _local_2.push(_local_4);
                    };
                };
            };
            return (_local_2);
        }

        private function gotoTip(_arg_1:int):Boolean
        {
            if (_arg_1 == 0)
            {
                if (PlayerManager.Instance.Self.Grade < 13)
                {
                    MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.roomlist.notGotoIntoRoom", 13, LanguageMgr.GetTranslation("tank.view.chat.ChannelListSelectView.ream")));
                    return (true);
                };
            }
            else
            {
                if (_arg_1 == 1)
                {
                    if (PlayerManager.Instance.Self.Grade < 13)
                    {
                        MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.roomlist.notGotoIntoRoom", 13, LanguageMgr.GetTranslation("tank.roomlist.challenge")));
                        return (true);
                    };
                };
            };
            return (false);
        }

        public function gotoIntoRoom(_arg_1:RoomInfo):void
        {
            SoundManager.instance.play("008");
            if (this.gotoTip(_arg_1.type))
            {
                return;
            };
            SocketManager.Instance.out.sendGameLogin(1, -1, _arg_1.ID, "");
            this._isPermissionEnter = false;
        }

        private function __lookupClick(_arg_1:MouseEvent):void
        {
            SoundManager.instance.play("008");
            this._controller.showFindRoom();
        }

        private function __singleBtnClick(_arg_1:MouseEvent):void
        {
            SoundManager.instance.play("008");
            if ((!(this._isPermissionEnter)))
            {
                return;
            };
            if ((getTimer() - this._lastCreatTime) > 2000)
            {
                this._lastCreatTime = getTimer();
                SoundManager.instance.play("008");
                if (PlayerManager.Instance.Self.Bag.getItemAt(14))
                {
                    this._lastCreatTime = 0;
                    GameInSocketOut.sendCreateRoom(RoomListCreateRoomView.PREWORD[int((Math.random() * RoomListCreateRoomView.PREWORD.length))], RoomInfo.SINGLE_ROOM, 3, "");
                }
                else
                {
                    MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.room.RoomIIController.weapon"));
                };
            };
        }

        private function __updateClick(_arg_1:MouseEvent):void
        {
            SoundManager.instance.play("008");
            if (this._model.getRoomList().length == 0)
            {
                this.upadteItemPos();
                return;
            };
            this.sendUpdate();
        }

        private function __placeCountClick(_arg_1:MouseEvent):void
        {
            SoundManager.instance.play("008");
            this.sendUpdate();
        }

        private function __hardLevelClick(_arg_1:MouseEvent):void
        {
            SoundManager.instance.play("008");
            this.sendUpdate();
        }

        private function __roomModeClick(_arg_1:MouseEvent):void
        {
            SoundManager.instance.play("008");
            this.sendUpdate();
        }

        private function __roomNameClick(_arg_1:MouseEvent):void
        {
            SoundManager.instance.play("008");
            this.sendUpdate();
        }

        private function __idBtnClick(_arg_1:MouseEvent):void
        {
            SoundManager.instance.play("008");
            this.sendUpdate();
        }

        private function sendUpdate():void
        {
            switch (this._model.currentType)
            {
                case FULL_MODE:
                    SocketManager.Instance.out.sendUpdateRoomList(LookupEnumerate.ROOM_LIST, LookupEnumerate.ROOMLIST_DEFAULT);
                    return;
                case ATHLETICS_MODE:
                    SocketManager.Instance.out.sendUpdateRoomList(LookupEnumerate.ROOM_LIST, LookupEnumerate.ROOMLIST_ATHLETICTICS);
                    return;
                case CHALLENGE_MODE:
                    SocketManager.Instance.out.sendUpdateRoomList(LookupEnumerate.ROOM_LIST, LookupEnumerate.ROOMLIST_DEFY);
                    return;
            };
        }

        private function _mutiBtnClick(_arg_1:MouseEvent):void
        {
            SoundManager.instance.play("008");
            if ((getTimer() - this._lastCreatTime) > 2000)
            {
                this._lastCreatTime = getTimer();
                GameInSocketOut.sendCreateRoom(PREWORD[int((Math.random() * PREWORD.length))], RoomInfo.MATCH_ROOM, 3);
            };
        }

        private function cleanRoomList():void
        {
            this.randomList.clear();
            this.randomList = null;
        }

        private function __arenaClick(_arg_1:MouseEvent):void
        {
            SoundManager.instance.play("008");
            if (PlayerManager.Instance.checkExpedition())
            {
                this._expeditionAlert = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("tips"), LanguageMgr.GetTranslation("ddt.consortion.ConsortionTransport.stopExpedition"), LanguageMgr.GetTranslation("ok"), LanguageMgr.GetTranslation("cancel"), false, true, false, LayerManager.BLCAK_BLOCKGOUND);
                this._expeditionAlert.moveEnable = false;
                this._expeditionAlert.addEventListener(FrameEvent.RESPONSE, this.__expeditionConfirmResponse);
            }
            else
            {
                ArenaManager.instance.enter();
            };
        }

        private function __expeditionConfirmResponse(_arg_1:FrameEvent):void
        {
            var _local_2:BaseAlerFrame = (_arg_1.currentTarget as BaseAlerFrame);
            _local_2.removeEventListener(FrameEvent.RESPONSE, this.__expeditionConfirmResponse);
            if (((_arg_1.responseCode == FrameEvent.ENTER_CLICK) || (_arg_1.responseCode == FrameEvent.SUBMIT_CLICK)))
            {
                SocketManager.Instance.out.sendExpeditionCancle();
                ArenaManager.instance.enter();
            };
            ObjectUtils.disposeObject(_local_2);
        }

        public function dispose():void
        {
            this.removeEvent();
            this.cleanRoomList();
            this.cleanItem();
            if (this._Verticalline)
            {
                ObjectUtils.disposeObject(this._Verticalline);
            };
            this._Verticalline = null;
            if (this._itemlistBg2)
            {
                ObjectUtils.disposeObject(this._itemlistBg2);
            };
            this._itemlistBg2 = null;
            if (this._itemlistBg)
            {
                ObjectUtils.disposeObject(this._itemlistBg);
            };
            this._itemlistBg = null;
            if (this._roomListBG)
            {
                ObjectUtils.disposeObject(this._roomListBG);
            };
            this._roomListBG = null;
            if (this._buttonBg)
            {
                ObjectUtils.disposeObject(this._buttonBg);
            };
            this._buttonBg = null;
            if (this._title)
            {
                ObjectUtils.disposeObject(this._title);
            };
            this._title = null;
            if (this._listTitle)
            {
                ObjectUtils.disposeObject(this._listTitle);
            };
            this._listTitle = null;
            if (this._createBtn)
            {
                ObjectUtils.disposeObject(this._createBtn);
            };
            this._createBtn = null;
            ObjectUtils.disposeObject(this._titleBg);
            this._titleBg = null;
            this._nextBtn.dispose();
            this._nextBtn = null;
            this._preBtn.dispose();
            this._preBtn = null;
            this._singleBtn.dispose();
            this._singleBtn = null;
            this._mutiBtn.dispose();
            this._mutiBtn = null;
            this._lookUpBtn.dispose();
            this._lookUpBtn = null;
            this._lookupRoom.dispose();
            this._lookupRoom = null;
            this._refreshBtn.dispose();
            this._refreshBtn = null;
            if (this._itemList)
            {
                this._itemList.disposeAllChildren();
            };
            ObjectUtils.disposeObject(this._itemList);
            this._tempDataList = null;
            this._itemList = null;
            this._itemArray = null;
            this._arenaBtn.dispose();
            this._arenaBtn = null;
            if (this._expeditionAlert)
            {
                this._expeditionAlert.removeEventListener(FrameEvent.RESPONSE, this.__expeditionConfirmResponse);
                ObjectUtils.disposeObject(this._expeditionAlert);
                this._expeditionAlert = null;
            };
            if (this._modeMenu)
            {
                ObjectUtils.disposeObject(this._modeMenu);
                this._modeMenu = null;
            };
            if (this.parent)
            {
                this.parent.removeChild(this);
            };
        }


    }
}//package roomList.pvpRoomList

