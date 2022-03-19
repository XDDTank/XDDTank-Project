// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//im.IMListView

package im
{
    import flash.display.Sprite;
    import com.pickgliss.ui.core.Disposeable;
    import com.pickgliss.ui.controls.ListPanel;
    import __AS3__.vec.Vector;
    import ddt.data.player.FriendListPlayer;
    import flash.utils.Timer;
    import com.pickgliss.ui.ComponentFactory;
    import com.pickgliss.ui.controls.ScrollPanel;
    import com.pickgliss.events.ListItemEvent;
    import ddt.manager.PlayerManager;
    import road7th.data.DictionaryEvent;
    import ddt.manager.DragManager;
    import flash.events.TimerEvent;
    import flash.events.Event;
    import flash.geom.Point;
    import ddt.manager.StateManager;
    import ddt.states.StateType;
    import bagAndInfo.cell.DragEffect;
    import flash.display.Bitmap;
    import flash.display.BitmapData;
    import flash.geom.Matrix;
    import flash.display.DisplayObject;
    import im.info.CustomInfo;
    import ddt.manager.LanguageMgr;
    import ddt.manager.SoundManager;
    import com.pickgliss.geom.IntPoint;
    import ddt.data.player.PlayerState;
    import road7th.data.DictionaryData;
    import __AS3__.vec.*;

    public class IMListView extends Sprite implements Disposeable 
    {

        private var _listPanel:ListPanel;
        private var _playerArray:Array;
        private var _titleList:Vector.<FriendListPlayer>;
        private var _currentItemInfo:FriendListPlayer;
        private var _currentTitleInfo:FriendListPlayer;
        private var _pos:int;
        private var _timer:Timer;
        private var _responseR:Sprite;
        private var _currentItem:IMListItemView;

        public function IMListView()
        {
            this.init();
            this.initEvent();
        }

        private function init():void
        {
            this.initTitle();
            this._timer = new Timer(200);
            this._listPanel = ComponentFactory.Instance.creatComponentByStylename("IM.IMlistPanel");
            this._listPanel.vScrollProxy = ScrollPanel.AUTO;
            addChild(this._listPanel);
            this._listPanel.list.updateListView();
            this._listPanel.list.addEventListener(ListItemEvent.LIST_ITEM_CLICK, this.__itemClick);
            this._currentTitleInfo = this._titleList[1];
            this._responseR = new Sprite();
            this._responseR.graphics.beginFill(0xFFFFFF, 0);
            this._responseR.graphics.drawRect(0, 0, this._listPanel.width, this._listPanel.height);
            this._responseR.graphics.endFill();
            addChild(this._responseR);
            this._responseR.mouseChildren = false;
            this._responseR.mouseEnabled = false;
            this.updateList();
        }

        private function initEvent():void
        {
            PlayerManager.Instance.recentContacts.addEventListener(DictionaryEvent.REMOVE, this.__removeRecentContact);
            PlayerManager.Instance.friendList.addEventListener(DictionaryEvent.ADD, this.__addItem);
            PlayerManager.Instance.friendList.addEventListener(DictionaryEvent.REMOVE, this.__removeItem);
            PlayerManager.Instance.friendList.addEventListener(DictionaryEvent.UPDATE, this.__updateItem);
            PlayerManager.Instance.blackList.addEventListener(DictionaryEvent.REMOVE, this.__removeItem);
            PlayerManager.Instance.blackList.addEventListener(DictionaryEvent.UPDATE, this.__updateItem);
            PlayerManager.Instance.blackList.addEventListener(DictionaryEvent.ADD, this.__addBlackItem);
            this._listPanel.list.addEventListener(ListItemEvent.LIST_ITEM_CLICK, this.__itemClick);
            this._listPanel.list.addEventListener(ListItemEvent.LIST_ITEM_MOUSE_DOWN, this.__listItemDownHandler);
            this._listPanel.list.addEventListener(ListItemEvent.LIST_ITEM_MOUSE_UP, this.__listItemUpHandler);
            this._listPanel.list.addEventListener(ListItemEvent.LIST_ITEM_ROLL_OUT, this.__listItemOutHandler);
            this._responseR.addEventListener(DragManager.DRAG_IN_RANGE_TOP, this.__topRangeHandler);
            this._responseR.addEventListener(DragManager.DRAG_IN_RANGE_BUTTOM, this.__buttomRangeHandler);
            this._timer.addEventListener(TimerEvent.TIMER, this.__timerHandler);
            addEventListener(Event.ADDED_TO_STAGE, this.__addToStage);
            IMController.Instance.addEventListener(IMEvent.ADD_NEW_GROUP, this.__addNewGroup);
            IMController.Instance.addEventListener(IMEvent.UPDATE_GROUP, this.__updaetGroup);
            IMController.Instance.addEventListener(IMEvent.DELETE_GROUP, this.__deleteGroup);
        }

        protected function __deleteGroup(_arg_1:Event):void
        {
            var _local_2:int;
            while (_local_2 < this._titleList.length)
            {
                if (this._titleList[_local_2].titleType == IMController.Instance.deleteCustomID)
                {
                    this._titleList.splice(_local_2, 1);
                    break;
                };
                _local_2++;
            };
            this._currentTitleInfo.titleIsSelected = false;
            this.updateTitle();
            this.updateList();
        }

        protected function __updaetGroup(_arg_1:Event):void
        {
            var _local_2:int;
            while (_local_2 < this._titleList.length)
            {
                if (this._titleList[_local_2].titleType == IMController.Instance.customInfo.ID)
                {
                    this._titleList[_local_2].titleText = IMController.Instance.customInfo.Name;
                    break;
                };
                _local_2++;
            };
            this._currentTitleInfo.titleIsSelected = false;
            this.updateTitle();
            this.updateList();
        }

        protected function __addNewGroup(_arg_1:Event):void
        {
            var _local_3:int;
            var _local_2:FriendListPlayer = new FriendListPlayer();
            _local_2.type = 0;
            _local_2.titleType = IMController.Instance.customInfo.ID;
            _local_2.titleIsSelected = false;
            _local_2.titleText = IMController.Instance.customInfo.Name;
            if (this._titleList.length == 4)
            {
                this._titleList.splice(2, 0, _local_2);
                PlayerManager.Instance.customList.splice(1, 0, IMController.Instance.customInfo);
            }
            else
            {
                _local_3 = 2;
                while (_local_3 < (this._titleList.length - 2))
                {
                    if (IMController.Instance.customInfo.ID < this._titleList[_local_3].titleType)
                    {
                        this._titleList.splice(_local_3, 0, _local_2);
                        PlayerManager.Instance.customList.splice((_local_3 - 1), 0, IMController.Instance.customInfo);
                        break;
                    };
                    if (_local_3 == (this._titleList.length - 3))
                    {
                        this._titleList.splice((_local_3 + 1), 0, _local_2);
                        PlayerManager.Instance.customList.splice(_local_3, 0, IMController.Instance.customInfo);
                        break;
                    };
                    _local_3++;
                };
            };
            this.updateTitle();
            this.updateList();
        }

        private function removeEvent():void
        {
            PlayerManager.Instance.recentContacts.removeEventListener(DictionaryEvent.REMOVE, this.__removeRecentContact);
            PlayerManager.Instance.friendList.removeEventListener(DictionaryEvent.ADD, this.__addItem);
            PlayerManager.Instance.friendList.removeEventListener(DictionaryEvent.REMOVE, this.__removeItem);
            PlayerManager.Instance.friendList.removeEventListener(DictionaryEvent.UPDATE, this.__updateItem);
            PlayerManager.Instance.blackList.removeEventListener(DictionaryEvent.REMOVE, this.__removeItem);
            PlayerManager.Instance.blackList.removeEventListener(DictionaryEvent.UPDATE, this.__updateItem);
            PlayerManager.Instance.blackList.removeEventListener(DictionaryEvent.ADD, this.__addBlackItem);
            this._listPanel.list.removeEventListener(ListItemEvent.LIST_ITEM_CLICK, this.__itemClick);
            this._listPanel.list.removeEventListener(ListItemEvent.LIST_ITEM_MOUSE_DOWN, this.__listItemDownHandler);
            this._listPanel.list.removeEventListener(ListItemEvent.LIST_ITEM_MOUSE_UP, this.__listItemUpHandler);
            this._listPanel.list.removeEventListener(ListItemEvent.LIST_ITEM_ROLL_OUT, this.__listItemOutHandler);
            this._responseR.removeEventListener(DragManager.DRAG_IN_RANGE_TOP, this.__topRangeHandler);
            this._responseR.removeEventListener(DragManager.DRAG_IN_RANGE_BUTTOM, this.__buttomRangeHandler);
            this._timer.removeEventListener(TimerEvent.TIMER, this.__timerHandler);
            removeEventListener(Event.ADDED_TO_STAGE, this.__addToStage);
            IMController.Instance.removeEventListener(IMEvent.ADD_NEW_GROUP, this.__addNewGroup);
            IMController.Instance.removeEventListener(IMEvent.UPDATE_GROUP, this.__updaetGroup);
            IMController.Instance.removeEventListener(IMEvent.DELETE_GROUP, this.__deleteGroup);
        }

        protected function __addToStage(_arg_1:Event):void
        {
            var _local_2:Point;
            _local_2 = this._listPanel.localToGlobal(new Point(0, 0));
            this._responseR.x = _local_2.x;
            this._responseR.y = _local_2.y;
        }

        protected function __listItemOutHandler(_arg_1:ListItemEvent):void
        {
            this._timer.stop();
        }

        protected function __listItemUpHandler(_arg_1:ListItemEvent):void
        {
            this._timer.stop();
        }

        protected function __listItemDownHandler(_arg_1:ListItemEvent):void
        {
            this._currentItem = (_arg_1.cell as IMListItemView);
            var _local_2:FriendListPlayer = (this._currentItem.getCellValue() as FriendListPlayer);
            if ((((_local_2.type == 1) && (!(StateManager.isInFight))) && (!(StateManager.currentStateType == StateType.FIGHT_LIB_GAMEVIEW))))
            {
                this._timer.reset();
                this._timer.start();
            };
        }

        protected function __topRangeHandler(_arg_1:Event):void
        {
            this._listPanel.setViewPosition(-1);
        }

        protected function __buttomRangeHandler(_arg_1:Event):void
        {
            this._listPanel.setViewPosition(1);
        }

        protected function __timerHandler(_arg_1:TimerEvent):void
        {
            this._timer.stop();
            var _local_2:Point = this._listPanel.localToGlobal(new Point(0, 0));
            this._responseR.x = _local_2.x;
            this._responseR.y = _local_2.y;
            DragManager.startDrag(this._currentItem, this._currentItem.getCellValue(), this.createImg(), stage.mouseX, stage.mouseY, DragEffect.MOVE, true, false, false, true, true, this._responseR, (this._currentItem.height + 10));
            this.showTitle();
        }

        private function createImg():DisplayObject
        {
            var _local_1:Bitmap = new Bitmap(new BitmapData((this._currentItem.width - 6), (this._currentItem.height - 6), false, 0), "auto", true);
            var _local_2:Matrix = new Matrix(1, 0, 0, 1, -2, -2);
            _local_1.bitmapData.draw(this._currentItem, _local_2);
            return (_local_1);
        }

        private function initTitle():void
        {
            var _local_5:FriendListPlayer;
            this._titleList = new Vector.<FriendListPlayer>();
            var _local_1:Vector.<CustomInfo> = PlayerManager.Instance.customList;
            var _local_2:int;
            while (_local_2 < _local_1.length)
            {
                _local_5 = new FriendListPlayer();
                _local_5.type = 0;
                _local_5.titleType = _local_1[_local_2].ID;
                _local_5.titleIsSelected = false;
                if (_local_2 == (_local_1.length - 1))
                {
                    _local_5.titleNumText = ((("[" + "0/") + String(PlayerManager.Instance.blackList.length)) + "]");
                }
                else
                {
                    _local_5.titleNumText = (((("[" + String(PlayerManager.Instance.getOnlineFriendForCustom(_local_1[_local_2].ID).length)) + "/") + String(PlayerManager.Instance.getFriendForCustom(_local_1[_local_2].ID).length)) + "]");
                };
                _local_5.titleText = _local_1[_local_2].Name;
                this._titleList.push(_local_5);
                _local_2++;
            };
            var _local_3:FriendListPlayer = new FriendListPlayer();
            _local_3.type = 0;
            _local_3.titleType = 2;
            _local_3.titleIsSelected = false;
            _local_3.titleNumText = (((("[" + String(PlayerManager.Instance.onlineRecentContactList.length)) + "/") + String(PlayerManager.Instance.recentContacts.length)) + "]");
            _local_3.titleText = LanguageMgr.GetTranslation("tank.game.ToolStripView.recentContact");
            this._titleList.unshift(_local_3);
            var _local_4:FriendListPlayer = new FriendListPlayer();
            _local_4.type = 0;
            _local_4.titleType = 3;
            _local_4.titleText = LanguageMgr.GetTranslation("tank.game.IM.custom");
            this._titleList.push(_local_4);
            this._titleList[1].titleIsSelected = true;
        }

        private function __addBlackItem(_arg_1:DictionaryEvent):void
        {
            if (((((this._currentTitleInfo.titleType == 1) && (this._currentTitleInfo.titleIsSelected == true)) && (this._listPanel)) && (this._listPanel.vectorListModel)))
            {
                this._listPanel.vectorListModel.append(_arg_1.data, this.getInsertIndex((_arg_1.data as FriendListPlayer)));
                this.updateTitle();
                this._listPanel.list.updateListView();
            }
            else
            {
                this.updateTitle();
                this._listPanel.list.updateListView();
            };
        }

        private function __updateItem(_arg_1:DictionaryEvent):void
        {
            this.updateTitle();
            this.updateList();
        }

        private function __addItem(_arg_1:DictionaryEvent):void
        {
            if ((((((this._currentTitleInfo.titleType == 0) || (this._currentTitleInfo.titleType >= 10)) && (this._currentTitleInfo.titleIsSelected == true)) && (this._listPanel)) && (this._listPanel.vectorListModel)))
            {
                this._listPanel.vectorListModel.append(_arg_1.data, this.getInsertIndex((_arg_1.data as FriendListPlayer)));
                this.updateTitle();
                this.updateList();
                this._listPanel.list.updateListView();
            }
            else
            {
                this.updateTitle();
                this.updateList();
                this._listPanel.list.updateListView();
            };
        }

        private function __removeItem(_arg_1:DictionaryEvent):void
        {
            if (((this._listPanel) && (this._listPanel.vectorListModel)))
            {
                this._listPanel.vectorListModel.remove(_arg_1.data);
                this.updateTitle();
                this._listPanel.list.updateListView();
            };
        }

        private function getInsertIndex(_arg_1:FriendListPlayer):int
        {
            var _local_2:int;
            var _local_4:FriendListPlayer;
            var _local_5:int;
            var _local_7:int;
            var _local_8:int;
            var _local_9:int;
            var _local_3:Array = this._listPanel.vectorListModel.elements;
            var _local_6:int;
            while (_local_6 < this._titleList.length)
            {
                if (this._titleList[_local_6].titleIsSelected)
                {
                    _local_2 = (_local_6 + 1);
                };
                _local_6++;
            };
            if (_local_3.length == this._titleList.length)
            {
                return (_local_2);
            };
            if (((!(this._currentTitleInfo.titleType == 1)) && (this._currentTitleInfo.titleIsSelected)))
            {
                _local_5 = 0;
                if (_arg_1.playerState.StateID != 0)
                {
                    _local_5 = ((PlayerManager.Instance.getOnlineFriendForCustom(this._currentTitleInfo.titleType).length + _local_2) - 1);
                    if (_local_5 != 0)
                    {
                        _local_7 = _local_2;
                        while (_local_7 < _local_5)
                        {
                            _local_4 = (_local_3[_local_7] as FriendListPlayer);
                            if ((((_arg_1.IsVIP) && (_local_4.IsVIP)) && (_arg_1.Grade < _local_4.Grade)))
                            {
                                _local_2++;
                            };
                            if (((!(_arg_1.IsVIP)) && (_local_4.IsVIP)))
                            {
                                _local_2++;
                            };
                            if ((((!(_arg_1.IsVIP)) && (!(_local_4.IsVIP))) && (_arg_1.Grade < _local_4.Grade)))
                            {
                                _local_2++;
                            };
                            _local_7++;
                        };
                    };
                    return (_local_2);
                };
                _local_2 = (PlayerManager.Instance.getOnlineFriendForCustom(this._currentTitleInfo.titleType).length + _local_2);
                _local_5 = ((PlayerManager.Instance.getOfflineFriendForCustom(this._currentTitleInfo.titleType).length + _local_2) - 1);
                if (_local_5 != 0)
                {
                    _local_8 = _local_2;
                    while (_local_8 < _local_5)
                    {
                        _local_4 = (_local_3[_local_8] as FriendListPlayer);
                        if (_arg_1.Grade <= _local_4.Grade)
                        {
                            _local_2++;
                        }
                        else
                        {
                            break;
                        };
                        _local_8++;
                    };
                };
                return (_local_2);
            };
            _local_5 = ((PlayerManager.Instance.blackList.length + _local_2) - 1);
            if (_local_5 != 0)
            {
                _local_9 = _local_2;
                while (_local_9 < _local_5)
                {
                    _local_4 = (_local_3[_local_9] as FriendListPlayer);
                    if (_arg_1.Grade <= _local_4.Grade)
                    {
                        _local_2++;
                    }
                    else
                    {
                        break;
                    };
                    _local_9++;
                };
            };
            return (_local_2);
        }

        private function __removeRecentContact(_arg_1:DictionaryEvent):void
        {
            this.updateTitle();
            this.updateList();
        }

        private function updateTitle():void
        {
            var _local_1:int;
            var _local_2:int;
            var _local_3:int;
            if (PlayerManager.Instance.friendList)
            {
                _local_1 = 1;
                while (_local_1 < (this._titleList.length - 2))
                {
                    _local_2 = PlayerManager.Instance.getOnlineFriendForCustom(this._titleList[_local_1].titleType).length;
                    _local_3 = PlayerManager.Instance.getFriendForCustom(this._titleList[_local_1].titleType).length;
                    this._titleList[_local_1].titleNumText = (((("[" + String(_local_2)) + "/") + String(_local_3)) + "]");
                    _local_1++;
                };
            };
            if (PlayerManager.Instance.blackList)
            {
                this._titleList[(this._titleList.length - 2)].titleNumText = ((("[" + "0/") + String(PlayerManager.Instance.blackList.length)) + "]");
            };
            if (PlayerManager.Instance.recentContacts)
            {
                this._titleList[0].titleNumText = (((("[" + String(PlayerManager.Instance.onlineRecentContactList.length)) + "/") + String(PlayerManager.Instance.recentContacts.length)) + "]");
            };
        }

        private function __itemClick(_arg_1:ListItemEvent):void
        {
            var _local_2:int;
            if ((_arg_1.cellValue as FriendListPlayer).type == 1)
            {
                if ((!(this._currentItemInfo)))
                {
                    this._currentItemInfo = (_arg_1.cellValue as FriendListPlayer);
                    this._currentItemInfo.titleIsSelected = true;
                };
                if (this._currentItemInfo != (_arg_1.cellValue as FriendListPlayer))
                {
                    this._currentItemInfo.titleIsSelected = false;
                    this._currentItemInfo = (_arg_1.cellValue as FriendListPlayer);
                    this._currentItemInfo.titleIsSelected = true;
                };
            }
            else
            {
                if ((!(this._currentTitleInfo)))
                {
                    this._currentTitleInfo = (_arg_1.cellValue as FriendListPlayer);
                    this._currentTitleInfo.titleIsSelected = true;
                };
                if (this._currentTitleInfo != (_arg_1.cellValue as FriendListPlayer))
                {
                    this._currentTitleInfo.titleIsSelected = false;
                    this._currentTitleInfo = (_arg_1.cellValue as FriendListPlayer);
                    this._currentTitleInfo.titleIsSelected = true;
                }
                else
                {
                    this._currentTitleInfo.titleIsSelected = (!(this._currentTitleInfo.titleIsSelected));
                };
                _local_2 = 0;
                while (_local_2 < this._titleList.length)
                {
                    if (this._titleList[_local_2] != this._currentTitleInfo)
                    {
                        this._titleList[_local_2].titleIsSelected = false;
                    };
                    _local_2++;
                };
                this.updateList();
                SoundManager.instance.play("008");
            };
            this._listPanel.list.updateListView();
        }

        private function updateList():void
        {
            this._pos = this._listPanel.list.viewPosition.y;
            IMController.Instance.titleType = this._currentTitleInfo.titleType;
            if ((((!(this._currentTitleInfo.titleType == 1)) && (!(this._currentTitleInfo.titleType == 2))) && (this._currentTitleInfo.titleIsSelected)))
            {
                this.updateFriendList(this._currentTitleInfo.titleType);
            }
            else
            {
                if (((this._currentTitleInfo.titleType == 1) && (this._currentTitleInfo.titleIsSelected)))
                {
                    this.updateBlackList();
                }
                else
                {
                    if (((this._currentTitleInfo.titleType == 2) && (this._currentTitleInfo.titleIsSelected)))
                    {
                        this.updateRecentContactList();
                    }
                    else
                    {
                        if ((!(this._currentTitleInfo.titleIsSelected)))
                        {
                            this.showTitle();
                        };
                    };
                };
            };
            this.updateTitle();
            this._listPanel.list.updateListView();
            var _local_1:IntPoint = new IntPoint(0, this._pos);
            this._listPanel.list.viewPosition = _local_1;
        }

        private function showTitle():void
        {
            this._playerArray = [];
            var _local_1:int;
            while (_local_1 < this._titleList.length)
            {
                this._playerArray.push(this._titleList[_local_1]);
                this._titleList[_local_1].titleIsSelected = false;
                _local_1++;
            };
            this._listPanel.vectorListModel.clear();
            this._listPanel.vectorListModel.appendAll(this._playerArray);
            this._listPanel.list.updateListView();
        }

        private function updateFriendList(_arg_1:int=0):void
        {
            var _local_9:FriendListPlayer;
            this._playerArray = [];
            var _local_2:int;
            var _local_3:int;
            while (_local_3 < this._titleList.length)
            {
                this._playerArray.push(this._titleList[_local_3]);
                if (_arg_1 == this._titleList[_local_3].titleType)
                {
                    _local_2 = _local_3;
                    break;
                };
                _local_3++;
            };
            var _local_4:Array = PlayerManager.Instance.getOnlineFriendForCustom(_arg_1);
            var _local_5:Array = [];
            var _local_6:Array = [];
            var _local_7:int;
            while (_local_7 < _local_4.length)
            {
                _local_9 = (_local_4[_local_7] as FriendListPlayer);
                if (_local_9.IsVIP)
                {
                    _local_5.push(_local_9);
                }
                else
                {
                    _local_6.push(_local_9);
                };
                _local_7++;
            };
            _local_5 = this.sort(_local_5);
            _local_6 = this.sort(_local_6);
            _local_4 = _local_5.concat(_local_6);
            _local_4 = IMController.Instance.sortAcademyPlayer(_local_4);
            this._playerArray = this._playerArray.concat(_local_4);
            _local_4 = PlayerManager.Instance.getOfflineFriendForCustom(_arg_1);
            _local_4 = this.sort(_local_4);
            _local_4 = IMController.Instance.sortAcademyPlayer(_local_4);
            this._playerArray = this._playerArray.concat(_local_4);
            var _local_8:int = (_local_2 + 1);
            while (_local_8 < this._titleList.length)
            {
                this._playerArray.push(this._titleList[_local_8]);
                _local_8++;
            };
            this._listPanel.vectorListModel.clear();
            this._listPanel.vectorListModel.appendAll(this._playerArray);
            this._listPanel.list.updateListView();
        }

        private function updateBlackList():void
        {
            this._playerArray = [];
            var _local_1:int;
            while (_local_1 < (this._titleList.length - 1))
            {
                this._playerArray.push(this._titleList[_local_1]);
                _local_1++;
            };
            var _local_2:Array = PlayerManager.Instance.blackList.list;
            this._playerArray = this._playerArray.concat(_local_2);
            this._playerArray.push(this._titleList[(this._titleList.length - 1)]);
            this._listPanel.vectorListModel.clear();
            this._listPanel.vectorListModel.appendAll(this._playerArray);
            this._listPanel.list.updateListView();
        }

        private function updateRecentContactList():void
        {
            var _local_3:FriendListPlayer;
            var _local_6:int;
            var _local_7:PlayerState;
            this._playerArray = [];
            this._playerArray.unshift(this._titleList[0]);
            var _local_1:Array = [];
            var _local_2:DictionaryData = PlayerManager.Instance.recentContacts;
            var _local_4:Array = IMController.Instance.recentContactsList;
            if (_local_4)
            {
                _local_6 = 0;
                while (_local_6 < _local_4.length)
                {
                    if (_local_4[_local_6] != 0)
                    {
                        _local_3 = _local_2[_local_4[_local_6]];
                        if (((_local_3) && (_local_1.indexOf(_local_3) == -1)))
                        {
                            if (PlayerManager.Instance.findPlayer(_local_3.ID, PlayerManager.Instance.Self.ZoneID))
                            {
                                _local_7 = new PlayerState(PlayerManager.Instance.findPlayer(_local_3.ID, PlayerManager.Instance.Self.ZoneID).playerState.StateID);
                                _local_3.playerState = _local_7;
                            };
                            _local_1.push(_local_3);
                        };
                    };
                    _local_6++;
                };
            };
            this._playerArray = this._playerArray.concat(_local_1);
            var _local_5:int = 1;
            while (_local_5 < this._titleList.length)
            {
                this._playerArray.push(this._titleList[_local_5]);
                _local_5++;
            };
            this._listPanel.vectorListModel.clear();
            this._listPanel.vectorListModel.appendAll(this._playerArray);
            this._listPanel.list.updateListView();
        }

        private function sort(_arg_1:Array):Array
        {
            return (_arg_1.sortOn("Grade", (Array.NUMERIC | Array.DESCENDING)));
        }

        public function dispose():void
        {
            this.removeEvent();
            this._timer = null;
            if (((this._listPanel) && (this._listPanel.parent)))
            {
                this._listPanel.parent.removeChild(this._listPanel);
                this._listPanel.dispose();
                this._listPanel = null;
            };
            if (this._currentItemInfo)
            {
                this._currentItemInfo.titleIsSelected = false;
            };
        }


    }
}//package im

