// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//roomList.pveRoomList.DungeonListBGView

package roomList.pveRoomList
{
    import flash.display.Sprite;
    import com.pickgliss.ui.core.Disposeable;
    import ddt.manager.LanguageMgr;
    import flash.display.Bitmap;
    import com.pickgliss.ui.controls.TextButton;
    import com.pickgliss.ui.controls.BaseButton;
    import com.pickgliss.ui.text.FilterFrameText;
    import com.pickgliss.ui.controls.SimpleBitmapButton;
    import com.pickgliss.ui.controls.container.SimpleTileList;
    import roomList.RoomListTipPanel;
    import roomList.RoomListMapTipPanel;
    import com.pickgliss.ui.image.Scale9CornerImage;
    import roomList.LookupRoomView;
    import road7th.data.DictionaryData;
    import com.pickgliss.ui.ComponentFactory;
    import ddt.utils.PositionUtils;
    import ddt.manager.ServerManager;
    import flash.events.MouseEvent;
    import road7th.data.DictionaryEvent;
    import com.pickgliss.toplevel.StageReferance;
    import room.RoomManager;
    import room.model.RoomInfo;
    import ddt.manager.SoundManager;
    import ddt.manager.MessageTipManager;
    import __AS3__.vec.Vector;
    import flash.events.Event;
    import ddt.manager.SocketManager;
    import roomList.LookupEnumerate;
    import flash.display.DisplayObject;
    import com.pickgliss.ui.controls.Scrollbar;
    import com.pickgliss.ui.image.ScaleBitmapImage;
    import com.pickgliss.utils.DisplayUtils;
    import ddt.manager.MapManager;
    import flash.geom.Point;
    import flash.utils.getTimer;
    import ddt.manager.GameInSocketOut;
    import com.pickgliss.ui.controls.alert.BaseAlerFrame;
    import ddt.manager.PlayerManager;
    import com.pickgliss.events.FrameEvent;
    import baglocked.BaglockedManager;
    import com.pickgliss.ui.AlertManager;
    import com.pickgliss.ui.LayerManager;
    import ddt.manager.LeavePageManager;
    import com.pickgliss.utils.ObjectUtils;
    import __AS3__.vec.*;

    public class DungeonListBGView extends Sprite implements Disposeable 
    {

        public static var PREWORD:Array = [LanguageMgr.GetTranslation("tank.roomlist.RoomListIICreatePveRoomView.tank"), LanguageMgr.GetTranslation("tank.roomlist.RoomListIICreatePveRoomView.go"), LanguageMgr.GetTranslation("tank.roomlist.RoomListIICreatePveRoomView.fire")];

        private var _movieBg:Bitmap;
        private var _model:DungeonListModel;
        private var _btnSiftReset:TextButton;
        private var _bmpCbFb:BaseButton;
        private var _txtCbFb:FilterFrameText;
        private var _iconBtnII:SimpleBitmapButton;
        private var _nextBtn:SimpleBitmapButton;
        private var _preBtn:SimpleBitmapButton;
        private var _rivalshipBtn:SimpleBitmapButton;
        private var _lookUpBtn:SimpleBitmapButton;
        private var _itemList:SimpleTileList;
        private var _itemArray:Array;
        private var _pveHardLeveRoomListTipPanel:RoomListTipPanel;
        private var _pveMapRoomListTipPanel:RoomListMapTipPanel;
        private var _controlle:DungeonListController;
        private var _tempDataList:Array;
        private var _isPermissionEnter:Boolean;
        private var _btnBg:Scale9CornerImage;
        private var _lookupRoom:LookupRoomView;
        private var _createBtn:BaseButton;
        private var _findBg:Bitmap;
        private var _Verticalline:Bitmap;
        private var _randomlist:DictionaryData = new DictionaryData();
        private var _selectItemPos:int;
        private var _selectItemID:int;
        private var _last_creat:uint;

        public function DungeonListBGView(_arg_1:DungeonListController, _arg_2:DungeonListModel)
        {
            this._controlle = _arg_1;
            this._model = _arg_2;
            super();
            this.init();
            this.initEvent();
        }

        private function init():void
        {
            this._itemArray = [];
            this._movieBg = ComponentFactory.Instance.creatBitmap("asset.ddtroomlist.pve.moviebg");
            PositionUtils.setPos(this._movieBg, "asset.ddtRoomlist.pve.moviebgPos");
            addChild(this._movieBg);
            this._Verticalline = ComponentFactory.Instance.creatBitmap("asset.ddtroomlist.line2");
            addChild(this._Verticalline);
            this._btnSiftReset = ComponentFactory.Instance.creatComponentByStylename("ddtroomlist.roomRefresh_btn");
            this._btnSiftReset.text = LanguageMgr.GetTranslation("ddt.roomList.refreshTxt");
            PositionUtils.setPos(this._btnSiftReset, "asset.ddtdungeonroomList.roomRefreshBtnPos");
            addChild(this._btnSiftReset);
            this._bmpCbFb = ComponentFactory.Instance.creatComponentByStylename("asset.ddtroomList.pvp.itemlist.bmpCbFb");
            addChild(this._bmpCbFb);
            this._txtCbFb = ComponentFactory.Instance.creatComponentByStylename("asset.ddtroomList.pvp.itemlist.txtCbFb");
            this._txtCbFb.mouseEnabled = false;
            addChild(this._txtCbFb);
            this._nextBtn = ComponentFactory.Instance.creatComponentByStylename("asset.ddtroomList.pvp.itemlist.nextBtn");
            this._preBtn = ComponentFactory.Instance.creatComponentByStylename("asset.ddtroomList.pvp.itemlist.preBtn");
            this._rivalshipBtn = ComponentFactory.Instance.creatComponentByStylename("asset.ddtroomList.pvp.quickBtn");
            this._rivalshipBtn.tipData = LanguageMgr.GetTranslation("tank.roomlist.joinDuplicateQuickly");
            this._lookUpBtn = ComponentFactory.Instance.creatComponentByStylename("asset.ddtroomList.pvp.searchBtn");
            this._lookUpBtn.tipData = LanguageMgr.GetTranslation("tank.roomlist.RoomListIIRoomBtnPanel.findRoom");
            this._iconBtnII = ComponentFactory.Instance.creatComponentByStylename("asset.ddtroomList.pvp.itemlist.iconbtn2");
            addChild(this._iconBtnII);
            this._lookupRoom = ComponentFactory.Instance.creatCustomObject("ddtroomlistLookupRoomView", [1]);
            addChild(this._lookupRoom);
            PositionUtils.setPos(this._lookupRoom, "asset.ddtdungeonroomList.lookupRoomPos");
            var _local_1:String = String(ServerManager.Instance.current.Name);
            var _local_2:int = _local_1.indexOf("(");
            _local_2 = ((_local_2 == -1) ? _local_1.length : _local_2);
            this._itemList = ComponentFactory.Instance.creat("asset.ddtroomList.DungeonList.ItemList", [3]);
            addChild(this._itemList);
            this.updateList();
            this.addTipPanel();
            this.resetSift();
            this._isPermissionEnter = true;
            this._btnBg = ComponentFactory.Instance.creatComponentByStylename("asset.ddtdungeonroolist.btnBG");
            addChild(this._btnBg);
            this._createBtn = ComponentFactory.Instance.creatComponentByStylename("ddtroomList.openBtn");
            addChild(this._createBtn);
            PositionUtils.setPos(this._createBtn, "asset.ddtdungeonroomList.createBtnPos");
        }

        private function initEvent():void
        {
            this._createBtn.addEventListener(MouseEvent.CLICK, this.__createClick);
            this._rivalshipBtn.addEventListener(MouseEvent.CLICK, this.__rivalshipBtnClick);
            this._iconBtnII.addEventListener(MouseEvent.CLICK, this.__iconBtnIIClick);
            this._bmpCbFb.addEventListener(MouseEvent.CLICK, this.__iconBtnIIClick);
            this._btnSiftReset.addEventListener(MouseEvent.CLICK, this.__siftReset);
            this._pveMapRoomListTipPanel.addEventListener(RoomListMapTipPanel.FB_CHANGE, this.__fbChange);
            this._pveHardLeveRoomListTipPanel.addEventListener(RoomListTipPanel.HARD_LV_CHANGE, this.__hardLvChange);
            this._nextBtn.addEventListener(MouseEvent.CLICK, this.__updateClick);
            this._preBtn.addEventListener(MouseEvent.CLICK, this.__updateClick);
            this._lookUpBtn.addEventListener(MouseEvent.CLICK, this.__lookupClick);
            this._model.addEventListener(DungeonListModel.DUNGEON_LIST_UPDATE, this.__addRoom);
            this._model.getRoomList().addEventListener(DictionaryEvent.CLEAR, this.__clearRoom);
            StageReferance.stage.addEventListener(MouseEvent.CLICK, this.__stageClick);
            RoomManager.Instance.addEventListener(RoomManager.LOGIN_ROOM_RESULT, this.__loginRoomRes);
        }

        private function removeEvent():void
        {
            this._createBtn.removeEventListener(MouseEvent.CLICK, this.__createClick);
            this._rivalshipBtn.removeEventListener(MouseEvent.CLICK, this.__rivalshipBtnClick);
            this._iconBtnII.removeEventListener(MouseEvent.CLICK, this.__iconBtnIIClick);
            this._bmpCbFb.removeEventListener(MouseEvent.CLICK, this.__iconBtnIIClick);
            this._btnSiftReset.removeEventListener(MouseEvent.CLICK, this.__siftReset);
            this._pveMapRoomListTipPanel.removeEventListener(RoomListMapTipPanel.FB_CHANGE, this.__fbChange);
            this._pveHardLeveRoomListTipPanel.removeEventListener(RoomListTipPanel.HARD_LV_CHANGE, this.__hardLvChange);
            this._nextBtn.removeEventListener(MouseEvent.CLICK, this.__updateClick);
            this._preBtn.removeEventListener(MouseEvent.CLICK, this.__updateClick);
            this._lookUpBtn.removeEventListener(MouseEvent.CLICK, this.__lookupClick);
            this._model.removeEventListener(DungeonListModel.DUNGEON_LIST_UPDATE, this.__addRoom);
            this._model.getRoomList().removeEventListener(DictionaryEvent.CLEAR, this.__clearRoom);
            StageReferance.stage.removeEventListener(MouseEvent.CLICK, this.__stageClick);
            RoomManager.Instance.removeEventListener(RoomManager.LOGIN_ROOM_RESULT, this.__loginRoomRes);
        }

        private function updateList():void
        {
            var _local_1:int;
            var _local_2:RoomInfo;
            var _local_3:DungeonListItemView;
            var _local_4:int;
            var _local_5:int;
            var _local_6:RoomInfo;
            var _local_7:DungeonListItemView;
            this.randomList.clear();
            if (this._model.getRoomList().length == 0)
            {
                this.randomDungeonRooms();
            }
            else
            {
                if (this._model.getRoomList().length < 6)
                {
                    _local_1 = 0;
                    while (_local_1 < 6)
                    {
                        if (_local_1 < this._model.getRoomList().length)
                        {
                            _local_2 = this._model.getRoomList().list[_local_1];
                            _local_3 = new DungeonListItemView(_local_2);
                            _local_3.addEventListener(MouseEvent.CLICK, this.__itemClick, false, 0, true);
                            this._itemList.addChild(_local_3);
                            this._itemArray.push(_local_3);
                        }
                        else
                        {
                            this.randomDungeonRooms();
                        };
                        _local_1++;
                    };
                }
                else
                {
                    _local_5 = 0;
                    while (_local_5 < this._model.getRoomList().length)
                    {
                        _local_4++;
                        if (_local_4 == 7) break;
                        _local_6 = this._model.getRoomList().list[_local_1];
                        _local_7 = new DungeonListItemView(_local_6);
                        _local_7.addEventListener(MouseEvent.CLICK, this.__itemClick, false, 0, true);
                        this._itemList.addChild(_local_7);
                        this._itemArray.push(_local_7);
                        _local_5++;
                    };
                };
            };
        }

        private function randomDungeonRooms():void
        {
            var _local_2:RoomInfo;
            var _local_3:DungeonListItemView;
            var _local_1:int;
            while (_local_1 < (6 - this._model.getRoomList().length))
            {
                _local_2 = new RoomInfo();
                _local_2.ID = this.randomRoomId();
                _local_2.mapId = this.randomMapId();
                _local_2.isPlaying = true;
                _local_2.totalPlayer = 3;
                _local_2.placeCount = 3;
                _local_3 = new DungeonListItemView(_local_2);
                _local_3.addEventListener(MouseEvent.CLICK, this.__itemClickOne, false, 0, true);
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
            return (Math.random() * 2);
        }

        private function randomMapId():int
        {
            var _local_1:Array = ["1", "2", "7", "3", "4", "5"];
            return (int(_local_1[Math.floor((Math.random() * _local_1.length))]));
        }

        private function __loginRoomRes(_arg_1:Event):void
        {
            this._isPermissionEnter = true;
        }

        private function __rivalshipBtnClick(_arg_1:MouseEvent):void
        {
            SoundManager.instance.play("008");
            if ((!(this._isPermissionEnter)))
            {
                return;
            };
            SocketManager.Instance.out.sendGameLogin(LookupEnumerate.DUNGEON_LIST, 4);
            this._isPermissionEnter = false;
        }

        private function __stageClick(_arg_1:MouseEvent):void
        {
            if (((((!(DisplayUtils.isTargetOrContain((_arg_1.target as DisplayObject), this._iconBtnII))) && (!(DisplayUtils.isTargetOrContain((_arg_1.target as DisplayObject), this._bmpCbFb)))) && (!(_arg_1.target is BaseButton))) && (!((_arg_1.target is ScaleBitmapImage) && ((_arg_1.target as DisplayObject).parent is Scrollbar)))))
            {
                this._pveMapRoomListTipPanel.visible = false;
                this._pveHardLeveRoomListTipPanel.visible = false;
            };
        }

        private function __lookupClick(_arg_1:MouseEvent):void
        {
            SoundManager.instance.play("008");
            this._controlle.showFindRoom();
        }

        private function __fbChange(_arg_1:Event):void
        {
            this.sendSift();
            if (this._pveMapRoomListTipPanel.value == 10000)
            {
                this.setTxtCbFb(LanguageMgr.GetTranslation("tank.roomlist.siftAllFb"));
            }
            else
            {
                this.setTxtCbFb(MapManager.getMapName(this._pveMapRoomListTipPanel.value));
            };
        }

        private function __hardLvChange(_arg_1:Event):void
        {
            this.sendSift();
            this.setTxtCbHardLv(this.getHardLvTxt(this._pveHardLeveRoomListTipPanel.value));
        }

        private function __siftReset(_arg_1:MouseEvent):void
        {
            SoundManager.instance.playButtonSound();
            if (this._model.getRoomList().length == 0)
            {
                this.upadteItemPos();
            };
            this.resetSift();
            this.sendSift();
        }

        private function sendSift():void
        {
            SocketManager.Instance.out.sendUpdateRoomList(LookupEnumerate.DUNGEON_LIST, -2, this._pveMapRoomListTipPanel.value, this._pveHardLeveRoomListTipPanel.value);
        }

        private function resetSift():void
        {
            this._pveMapRoomListTipPanel.resetValue();
            this._pveHardLeveRoomListTipPanel.resetValue();
            this.setTxtCbFb(LanguageMgr.GetTranslation("tank.roomlist.siftAllFb"));
            this.setTxtCbHardLv("tank.room.difficulty.all");
        }

        private function setTxtCbFb(_arg_1:String):void
        {
            this._txtCbFb.text = _arg_1;
            this._txtCbFb.x = (this._bmpCbFb.x + (((this._bmpCbFb.width - this._iconBtnII.width) - this._txtCbFb.width) / 2));
        }

        private function setTxtCbHardLv(_arg_1:String):void
        {
        }

        private function getHardLvTxt(_arg_1:int):String
        {
            switch (_arg_1)
            {
                case LookupEnumerate.DUNGEON_LIST_SIMPLE:
                    return ("tank.room.difficulty.simple");
                case LookupEnumerate.DUNGEON_LIST_COMMON:
                    return ("tank.room.difficulty.normal");
                case LookupEnumerate.DUNGEON_LIST_STRAIT:
                    return ("tank.room.difficulty.hard");
                case LookupEnumerate.DUNGEON_LIST_HERO:
                    return ("tank.room.difficulty.hero");
            };
            return ("tank.room.difficulty.all");
        }

        private function addTipPanel():void
        {
            var _local_1:Bitmap = ComponentFactory.Instance.creatBitmap("asset.ddtroomList.hardLevel_01");
            var _local_2:Bitmap = ComponentFactory.Instance.creatBitmap("asset.ddtroomList.hardLevel_02");
            var _local_3:Bitmap = ComponentFactory.Instance.creatBitmap("asset.ddtroomList.hardLevel_03");
            var _local_4:Bitmap = ComponentFactory.Instance.creatBitmap("asset.ddtroomList.hardLevel_04");
            var _local_5:Bitmap = ComponentFactory.Instance.creatBitmap("asset.ddtroomList.hardLevel_05");
            var _local_6:Point = ComponentFactory.Instance.creatCustomObject("asset.ddtroomList.pve.DungeonListTipPanelSizeII");
            this._pveHardLeveRoomListTipPanel = new RoomListTipPanel(_local_6.x, _local_6.y);
            this._pveHardLeveRoomListTipPanel.addItem(_local_5, LookupEnumerate.DUNGEON_LIST_ALL);
            this._pveHardLeveRoomListTipPanel.addItem(_local_1, LookupEnumerate.DUNGEON_LIST_SIMPLE);
            this._pveHardLeveRoomListTipPanel.addItem(_local_2, LookupEnumerate.DUNGEON_LIST_COMMON);
            this._pveHardLeveRoomListTipPanel.addItem(_local_3, LookupEnumerate.DUNGEON_LIST_STRAIT);
            this._pveHardLeveRoomListTipPanel.addItem(_local_4, LookupEnumerate.DUNGEON_LIST_HERO);
            var _local_7:Point = ComponentFactory.Instance.creatCustomObject("asset.ddtroomList.pve.pveHardLeveRoomListTipPanelPos");
            this._pveHardLeveRoomListTipPanel.x = _local_7.x;
            this._pveHardLeveRoomListTipPanel.y = _local_7.y;
            this._pveHardLeveRoomListTipPanel.visible = false;
            addChild(this._pveHardLeveRoomListTipPanel);
            var _local_8:Point = ComponentFactory.Instance.creatCustomObject("asset.ddtroomList.pve.pveMapPanelPos");
            var _local_9:Point = ComponentFactory.Instance.creatCustomObject("roomList.DungeonList.DungeonListTipPanelSizeIII");
            this._pveMapRoomListTipPanel = new RoomListMapTipPanel(_local_9.x, _local_9.y);
            this._pveMapRoomListTipPanel.x = _local_8.x;
            this._pveMapRoomListTipPanel.y = _local_8.y;
            this._pveMapRoomListTipPanel.addItem(10000);
            var _local_10:int;
            while (_local_10 < MapManager.pveMapCount)
            {
                if (MapManager.getByOrderingDungeonInfo(_local_10))
                {
                    this._pveMapRoomListTipPanel.addItem(MapManager.getByOrderingDungeonInfo(_local_10).ID);
                };
                _local_10++;
            };
            var _local_11:int;
            while (_local_11 < MapManager.pveMapCount)
            {
                if (MapManager.getByOrderingSpecialDungeonInfo(_local_11))
                {
                    this._pveMapRoomListTipPanel.addItem(MapManager.getByOrderingSpecialDungeonInfo(_local_11).ID);
                };
                _local_11++;
            };
            this._pveMapRoomListTipPanel.visible = false;
            addChild(this._pveMapRoomListTipPanel);
        }

        private function __clearRoom(_arg_1:DictionaryEvent):void
        {
            this._isPermissionEnter = true;
        }

        private function __addRoom(_arg_1:Event):void
        {
            this.upadteItemPos();
            this._isPermissionEnter = true;
        }

        private function upadteItemPos():void
        {
            var _local_1:int;
            var _local_2:RoomInfo;
            var _local_3:DungeonListItemView;
            var _local_4:RoomInfo;
            var _local_5:DungeonListItemView;
            var _local_6:RoomInfo;
            var _local_7:int;
            var _local_8:int;
            var _local_9:RoomInfo;
            var _local_10:DungeonListItemView;
            this._tempDataList = this.currentDataList;
            this.randomList.clear();
            this.cleanItem();
            if (this._tempDataList)
            {
                if (this._tempDataList.length < 6)
                {
                    _local_1 = 0;
                    while (_local_1 < 6)
                    {
                        if (_local_1 < this._tempDataList.length)
                        {
                            _local_2 = this._tempDataList[_local_1];
                            _local_3 = new DungeonListItemView(_local_2);
                            _local_3.addEventListener(MouseEvent.CLICK, this.__itemClick, false, 0, true);
                            this._itemList.addChild(_local_3);
                            this._itemArray.push(_local_3);
                        }
                        else
                        {
                            _local_4 = new RoomInfo();
                            _local_4.ID = this.randomRoomId();
                            _local_4.mapId = this.randomMapId();
                            _local_4.type = this.randomRoomtype();
                            _local_4.isPlaying = true;
                            _local_4.totalPlayer = 3;
                            _local_4.placeCount = 3;
                            _local_5 = new DungeonListItemView(_local_4);
                            _local_5.addEventListener(MouseEvent.CLICK, this.__itemClickOne, false, 0, true);
                            this._itemList.addChild(_local_5);
                            this._itemArray.push(_local_5);
                        };
                        _local_1++;
                    };
                }
                else
                {
                    _local_6 = this._tempDataList[this._selectItemPos];
                    _local_7 = this.getInfosPos(this._selectItemID);
                    this._tempDataList[this._selectItemPos] = this._tempDataList[_local_7];
                    this._tempDataList[_local_7] = _local_6;
                    for each (_local_9 in this._tempDataList)
                    {
                        if (!(!(_local_9)))
                        {
                            _local_8++;
                            if (_local_8 == 7) break;
                            _local_10 = new DungeonListItemView(_local_9);
                            _local_10.addEventListener(MouseEvent.CLICK, this.__itemClick, false, 0, true);
                            this._itemList.addChild(_local_10);
                            this._itemArray.push(_local_10);
                        };
                    };
                };
            };
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
                if ((!(this._itemArray[_local_2] as DungeonListItemView)))
                {
                    return (0);
                };
                if ((this._itemArray[_local_2] as DungeonListItemView).id == _arg_1)
                {
                    this._selectItemPos = _local_2;
                    this._selectItemID = (this._itemArray[_local_2] as DungeonListItemView).id;
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

        private function __iconBtnIIClick(_arg_1:MouseEvent):void
        {
            SoundManager.instance.play("008");
            this._pveMapRoomListTipPanel.visible = (!(this._pveMapRoomListTipPanel.visible));
            this._pveHardLeveRoomListTipPanel.visible = false;
        }

        private function __iconBtnIIIClick(_arg_1:MouseEvent):void
        {
            SoundManager.instance.play("008");
            this._pveHardLeveRoomListTipPanel.visible = (!(this._pveHardLeveRoomListTipPanel.visible));
            this._pveMapRoomListTipPanel.visible = false;
        }

        private function __updateClick(_arg_1:MouseEvent):void
        {
            SoundManager.instance.play("008");
            this.sendSift();
        }

        private function __itemClick(_arg_1:MouseEvent):void
        {
            if ((!(this._isPermissionEnter)))
            {
                return;
            };
            this.gotoIntoRoom((_arg_1.currentTarget as DungeonListItemView).info);
            this.getSelectItemPos((_arg_1.currentTarget as DungeonListItemView).id);
        }

        public function gotoIntoRoom(_arg_1:RoomInfo):void
        {
            SoundManager.instance.play("008");
            SocketManager.Instance.out.sendGameLogin(2, -1, _arg_1.ID, "");
            this._isPermissionEnter = false;
        }

        private function __createClick(_arg_1:MouseEvent):void
        {
            SoundManager.instance.play("008");
            if ((getTimer() - this._last_creat) >= 2000)
            {
                this._last_creat = getTimer();
                GameInSocketOut.sendCreateRoom(PREWORD[int((Math.random() * PREWORD.length))], 4, 3);
            };
        }

        private function cleanItem():void
        {
            var _local_1:int;
            while (_local_1 < this._itemArray.length)
            {
                (this._itemArray[_local_1] as DungeonListItemView).removeEventListener(MouseEvent.CLICK, this.__itemClick);
                (this._itemArray[_local_1] as DungeonListItemView).dispose();
                _local_1++;
            };
            this._itemList.disposeAllChildren();
            this._itemArray = [];
        }

        private function __frameEvent(_arg_1:FrameEvent):void
        {
            var _local_4:BaseAlerFrame;
            var _local_2:int = PlayerManager.Instance.Self.getBuyFatigueMoney();
            var _local_3:BaseAlerFrame = (_arg_1.target as BaseAlerFrame);
            _local_3.removeEventListener(FrameEvent.RESPONSE, this.__frameEvent);
            _local_3.dispose();
            if (((_arg_1.responseCode == FrameEvent.ENTER_CLICK) || (_arg_1.responseCode == FrameEvent.SUBMIT_CLICK)))
            {
                if (PlayerManager.Instance.Self.bagLocked)
                {
                    BaglockedManager.Instance.show();
                    return;
                };
                if (((PlayerManager.Instance.Self.DDTMoney == 0) && (_local_2 > PlayerManager.Instance.Self.Money)))
                {
                    _local_4 = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"), LanguageMgr.GetTranslation("poorNote"), LanguageMgr.GetTranslation("ok"), LanguageMgr.GetTranslation("cancel"), false, false, false, LayerManager.BLCAK_BLOCKGOUND);
                    _local_4.moveEnable = false;
                    _local_4.addEventListener(FrameEvent.RESPONSE, this.__poorManResponse);
                }
                else
                {
                    SocketManager.Instance.out.sendBuyFatigue();
                };
            };
        }

        private function __poorManResponse(_arg_1:FrameEvent):void
        {
            var _local_2:BaseAlerFrame = (_arg_1.currentTarget as BaseAlerFrame);
            _local_2.removeEventListener(FrameEvent.RESPONSE, this.__poorManResponse);
            if (((_arg_1.responseCode == FrameEvent.ENTER_CLICK) || (_arg_1.responseCode == FrameEvent.SUBMIT_CLICK)))
            {
                LeavePageManager.leaveToFillPath();
            };
            ObjectUtils.disposeObject(_local_2);
        }

        private function cleanRoomList():void
        {
            this.randomList.clear();
            this.randomList = null;
        }

        public function dispose():void
        {
            this.removeEvent();
            this.cleanRoomList();
            this.cleanItem();
            this._itemList.dispose();
            this._itemList = null;
            this._iconBtnII.dispose();
            this._iconBtnII = null;
            if (this._movieBg)
            {
                ObjectUtils.disposeObject(this._movieBg);
            };
            this._movieBg = null;
            if (this._btnBg)
            {
                ObjectUtils.disposeObject(this._btnBg);
            };
            this._btnBg = null;
            ObjectUtils.disposeObject(this._bmpCbFb);
            this._bmpCbFb = null;
            ObjectUtils.disposeObject(this._txtCbFb);
            this._txtCbFb = null;
            if (this._Verticalline)
            {
                ObjectUtils.disposeObject(this._Verticalline);
            };
            this._Verticalline = null;
            ObjectUtils.disposeObject(this._btnSiftReset);
            this._btnSiftReset = null;
            this._nextBtn.dispose();
            this._nextBtn = null;
            this._preBtn.dispose();
            this._preBtn = null;
            this._createBtn.dispose();
            this._createBtn = null;
            this._rivalshipBtn.dispose();
            this._rivalshipBtn = null;
            this._lookUpBtn.dispose();
            this._lookUpBtn = null;
            this._lookupRoom.dispose();
            this._lookupRoom = null;
            if (((this._pveHardLeveRoomListTipPanel) && (this._pveHardLeveRoomListTipPanel.parent)))
            {
                this._pveHardLeveRoomListTipPanel.parent.removeChild(this._pveHardLeveRoomListTipPanel);
            };
            this._pveHardLeveRoomListTipPanel.dispose();
            this._pveHardLeveRoomListTipPanel = null;
            if (((this._pveMapRoomListTipPanel) && (this._pveMapRoomListTipPanel.parent)))
            {
                this._pveMapRoomListTipPanel.parent.removeChild(this._pveMapRoomListTipPanel);
            };
            this._pveMapRoomListTipPanel.dispose();
            this._pveMapRoomListTipPanel = null;
            if (this.parent)
            {
                this.parent.removeChild(this);
            };
        }


    }
}//package roomList.pveRoomList

