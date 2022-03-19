// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//invite.InviteFrame

package invite
{
    import com.pickgliss.ui.controls.Frame;
    import com.pickgliss.ui.image.MutipleImage;
    import com.pickgliss.ui.controls.TextButton;
    import com.pickgliss.ui.controls.container.HBox;
    import com.pickgliss.ui.controls.SelectedButtonGroup;
    import com.pickgliss.ui.controls.SelectedButton;
    import com.pickgliss.ui.controls.ListPanel;
    import shop.view.NewShopBugleView;
    import ddt.manager.StateManager;
    import ddt.states.StateType;
    import ddt.manager.PlayerManager;
    import ddt.manager.LanguageMgr;
    import com.pickgliss.ui.ComponentFactory;
    import im.IMController;
    import flash.events.Event;
    import flash.events.MouseEvent;
    import ddt.manager.SocketManager;
    import ddt.events.CrazyTankSocketEvent;
    import com.pickgliss.events.FrameEvent;
    import ddt.manager.SoundManager;
    import ddt.manager.MessageTipManager;
    import com.pickgliss.ui.controls.alert.BaseAlerFrame;
    import room.RoomManager;
    import ddt.manager.InviteManager;
    import ddt.data.EquipType;
    import ddt.manager.GameInSocketOut;
    import com.pickgliss.ui.AlertManager;
    import com.pickgliss.ui.LayerManager;
    import com.pickgliss.utils.ObjectUtils;
    import ddt.data.player.PlayerInfo;
    import road7th.comm.PackageIn;
    import invite.data.InvitePlayerInfo;
    import ddt.data.player.BasePlayer;
    import com.pickgliss.loader.UIModuleLoader;
    import com.pickgliss.events.UIModuleEvent;
    import ddt.data.UIModuleTypes;
    import consortion.ConsortionModelControl;
    import ddt.data.player.FriendListPlayer;
    import ddt.data.player.PlayerState;
    import road7th.data.DictionaryData;

    public class InviteFrame extends Frame 
    {

        public static const RECENT:int = 0;
        public static const Brotherhood:int = 1;
        public static const Friend:int = 2;
        public static const Hall:int = 3;

        private var _visible:Boolean = true;
        private var _resState:String;
        private var _listBack:MutipleImage;
        private var _refreshButton:TextButton;
        private var _inviteButton:TextButton;
        private var _hbox:HBox;
        private var _btnGroup:SelectedButtonGroup;
        private var _hallButton:SelectedButton;
        private var _frientButton:SelectedButton;
        private var _brotherhoodButton:SelectedButton;
        private var _recentContactBtn:SelectedButton;
        private var _list:ListPanel;
        private var _changeComplete:Boolean = false;
        private var _refleshCount:int = 0;
        private var _invitePlayerInfos:Array;
        public var roomType:int;
        private var _shopBugle:NewShopBugleView;
        private var _oldSelected:int;

        public function InviteFrame()
        {
            this.configUi();
            if (((!(StateManager.currentStateType == StateType.DUNGEON_ROOM)) && (!(StateManager.currentStateType == StateType.MISSION_ROOM))))
            {
                this._inviteButton.enable = false;
            };
            this.addEvent();
            if (PlayerManager.Instance.Self.ConsortiaID != 0)
            {
                this.refleshList(Brotherhood);
            }
            else
            {
                this.refleshList(Friend);
            };
        }

        private function configUi():void
        {
            titleText = LanguageMgr.GetTranslation("tank.invite.InviteView.request");
            this._listBack = ComponentFactory.Instance.creatComponentByStylename("asset.ddtInviteFrame.bg");
            addToContent(this._listBack);
            this._refreshButton = ComponentFactory.Instance.creatComponentByStylename("asset.ddtinvite.RefreshButton");
            this._refreshButton.text = LanguageMgr.GetTranslation("tank.invite.InviteView.list");
            addToContent(this._refreshButton);
            this._inviteButton = ComponentFactory.Instance.creatComponentByStylename("asset.ddtinvite.InviteButton");
            this._inviteButton.text = LanguageMgr.GetTranslation("im.InviteDialogFrame.inviteBu");
            addToContent(this._inviteButton);
            this._hbox = ComponentFactory.Instance.creatComponentByStylename("asset.ddtinvite.hbox");
            addToContent(this._hbox);
            this._btnGroup = new SelectedButtonGroup();
            this._recentContactBtn = ComponentFactory.Instance.creatComponentByStylename("asset.ddtinvite.recentButton");
            this._btnGroup.addSelectItem(this._recentContactBtn);
            this._brotherhoodButton = ComponentFactory.Instance.creatComponentByStylename("asset.ddtinvite.consortiaButton");
            this._btnGroup.addSelectItem(this._brotherhoodButton);
            this._frientButton = ComponentFactory.Instance.creatComponentByStylename("asset.ddtinvite.friendButton");
            this._btnGroup.addSelectItem(this._frientButton);
            this._hallButton = ComponentFactory.Instance.creatComponentByStylename("asset.ddtinvite.HallButton");
            this._btnGroup.addSelectItem(this._hallButton);
            if (PlayerManager.Instance.Self.ConsortiaID == 0)
            {
                this._hbox.addChild(this._recentContactBtn);
                this._hbox.addChild(this._frientButton);
                this._hbox.addChild(this._hallButton);
                this._hbox.addChild(this._brotherhoodButton);
            }
            else
            {
                this._hbox.addChild(this._recentContactBtn);
                this._hbox.addChild(this._brotherhoodButton);
                this._hbox.addChild(this._frientButton);
                this._hbox.addChild(this._hallButton);
            };
            this._list = ComponentFactory.Instance.creatComponentByStylename("asset.ddtinvite.List");
            addToContent(this._list);
            IMController.Instance.loadRecentContacts();
        }

        private function addEvent():void
        {
            this._btnGroup.addEventListener(Event.CHANGE, this.__btnChangeHandler);
            this._refreshButton.addEventListener(MouseEvent.CLICK, this.__onRefreshClick);
            this._inviteButton.addEventListener(MouseEvent.CLICK, this.__onInviteClick);
            SocketManager.Instance.addEventListener(CrazyTankSocketEvent.SCENE_USERS_LIST, this.__onGetList);
            addEventListener(FrameEvent.RESPONSE, this.__response);
        }

        private function __btnChangeHandler(_arg_1:Event):void
        {
            SoundManager.instance.play("008");
            this._hbox.arrange();
            if (this._changeComplete)
            {
                this._changeComplete = false;
                switch (this._btnGroup.selectIndex)
                {
                    case RECENT:
                        this.refleshList(RECENT);
                        break;
                    case Brotherhood:
                        if (PlayerManager.Instance.Self.ConsortiaID != 0)
                        {
                            this.refleshList(Brotherhood);
                        }
                        else
                        {
                            this._changeComplete = true;
                            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.view.store.consortiaRateI"));
                            this._btnGroup.selectIndex = this._oldSelected;
                        };
                        break;
                    case Friend:
                        this.refleshList(Friend);
                        break;
                    case Hall:
                        this.refleshList(Hall);
                        break;
                };
                this._oldSelected = this._btnGroup.selectIndex;
            };
        }

        private function __response(_arg_1:FrameEvent):void
        {
            switch (_arg_1.responseCode)
            {
                case FrameEvent.CANCEL_CLICK:
                case FrameEvent.CLOSE_CLICK:
                case FrameEvent.ESC_CLICK:
                    this.__onCloseClick(null);
                    return;
                case FrameEvent.ENTER_CLICK:
                case FrameEvent.SUBMIT_CLICK:
                    this.__onRefreshClick(null);
                    return;
            };
        }

        private function removeEvent():void
        {
            this._btnGroup.removeEventListener(Event.CHANGE, this.__btnChangeHandler);
            if (this._refreshButton)
            {
                this._refreshButton.removeEventListener(MouseEvent.CLICK, this.__onRefreshClick);
            };
            if (this._inviteButton)
            {
                this._inviteButton.removeEventListener(MouseEvent.CLICK, this.__onInviteClick);
            };
            SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.SCENE_USERS_LIST, this.__onGetList);
            removeEventListener(FrameEvent.RESPONSE, this.__response);
        }

        private function __onInviteClick(_arg_1:MouseEvent):void
        {
            var _local_2:BaseAlerFrame;
            if (((RoomManager.Instance.current.mapId == 0) || (RoomManager.Instance.current.mapId == 10000)))
            {
                MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.dungeonInvite.noChooseDungeon"));
                return;
            };
            if ((!(InviteManager.Instance.canUseDungeonBugle)))
            {
                MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.dungeonInvite.tooQuiklyToInvite"));
                return;
            };
            if (PlayerManager.Instance.Self.Bag.getItemCountByTemplateId(EquipType.DUNGEON_BUGLE) > 0)
            {
                GameInSocketOut.sendInviteDungeon();
                InviteManager.Instance.StartTimer();
            }
            else
            {
                if (PlayerManager.Instance.Self.Bag.getItemCountByTemplateId(EquipType.T_BBUGLE) <= 0)
                {
                    MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.dungeonInvite.noBugles"));
                    this._shopBugle = new NewShopBugleView(EquipType.T_BBUGLE);
                }
                else
                {
                    _local_2 = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("tips"), LanguageMgr.GetTranslation("ddt.dungeonInvite.bigBuglesAlert"), LanguageMgr.GetTranslation("ok"), LanguageMgr.GetTranslation("cancel"), false, true, false, LayerManager.BLCAK_BLOCKGOUND);
                    _local_2.moveEnable = false;
                    _local_2.addEventListener(FrameEvent.RESPONSE, this.__confirmResponse);
                };
            };
        }

        private function __confirmResponse(_arg_1:FrameEvent):void
        {
            var _local_2:BaseAlerFrame = (_arg_1.currentTarget as BaseAlerFrame);
            _local_2.removeEventListener(FrameEvent.RESPONSE, this.__confirmResponse);
            if (((_arg_1.responseCode == FrameEvent.ENTER_CLICK) || (_arg_1.responseCode == FrameEvent.SUBMIT_CLICK)))
            {
                GameInSocketOut.sendInviteDungeon();
                InviteManager.Instance.StartTimer();
            };
            ObjectUtils.disposeObject(_local_2);
        }

        private function __onRefreshClick(_arg_1:MouseEvent):void
        {
            SoundManager.instance.play("008");
            if (this._changeComplete)
            {
                if (this._btnGroup.selectIndex == Hall)
                {
                    this.refleshList(Hall, ++this._refleshCount);
                }
                else
                {
                    this.refleshList(this._btnGroup.selectIndex);
                };
            };
        }

        private function __onGetList(_arg_1:CrazyTankSocketEvent):void
        {
            var _local_6:PlayerInfo;
            var _local_2:PackageIn = _arg_1.pkg;
            var _local_3:Array = [];
            var _local_4:int = _local_2.readByte();
            var _local_5:uint;
            while (_local_5 < _local_4)
            {
                _local_6 = new PlayerInfo();
                _local_6.ID = _local_2.readInt();
                _local_6.NickName = _local_2.readUTF();
                _local_6.VIPtype = _local_2.readByte();
                _local_6.VIPLevel = _local_2.readInt();
                _local_6.Sex = _local_2.readBoolean();
                _local_6.Grade = _local_2.readInt();
                _local_6.ConsortiaID = _local_2.readInt();
                _local_6.ConsortiaName = _local_2.readUTF();
                _local_6.Offer = _local_2.readInt();
                _local_6.WinCount = _local_2.readInt();
                _local_6.TotalCount = _local_2.readInt();
                _local_6.EscapeCount = _local_2.readInt();
                _local_6.Repute = _local_2.readInt();
                _local_6.FightPower = _local_2.readInt();
                _local_6.isOld = _local_2.readBoolean();
                _local_3.push(_local_6);
                _local_5++;
            };
            this.updateList(Hall, _local_3);
        }

        override protected function __onCloseClick(_arg_1:MouseEvent):void
        {
            SoundManager.instance.play("008");
            dispatchEvent(new Event(Event.COMPLETE));
        }

        private function updateList(_arg_1:int, _arg_2:Array):void
        {
            var _local_3:InvitePlayerInfo;
            var _local_5:BasePlayer;
            var _local_6:Array;
            this._changeComplete = true;
            this.clearList();
            this._invitePlayerInfos = [];
            var _local_4:int;
            while (_local_4 < _arg_2.length)
            {
                _local_5 = (_arg_2[_local_4] as BasePlayer);
                if (_local_5.ID != PlayerManager.Instance.Self.ID)
                {
                    _local_3 = new InvitePlayerInfo();
                    _local_3.NickName = _local_5.NickName;
                    _local_3.VIPtype = _local_5.VIPtype;
                    _local_3.Sex = _local_5.Sex;
                    _local_3.Grade = _local_5.Grade;
                    _local_3.Repute = _local_5.Repute;
                    _local_3.WinCount = _local_5.WinCount;
                    _local_3.TotalCount = _local_5.TotalCount;
                    _local_3.FightPower = _local_5.FightPower;
                    _local_3.ID = _local_5.ID;
                    _local_3.Offer = _local_5.Offer;
                    _local_3.isOld = _local_5.isOld;
                    this._list.vectorListModel.insertElementAt(_local_3, this.getInsertIndex(_local_5));
                    this._invitePlayerInfos.push(_local_3);
                };
                _local_4++;
            };
            if (_arg_1 == Friend)
            {
                _local_6 = this._invitePlayerInfos;
                _local_6 = IMController.Instance.sortAcademyPlayer(_local_6);
                this._list.vectorListModel.clear();
                this._list.vectorListModel.appendAll(_local_6);
            };
            this._list.list.updateListView();
        }

        private function clearList():void
        {
            this._list.vectorListModel.clear();
        }

        private function getInsertIndex(_arg_1:BasePlayer):int
        {
            var _local_2:int;
            var _local_5:PlayerInfo;
            var _local_3:Array = this._list.vectorListModel.elements;
            if (_local_3.length == 0)
            {
                return (0);
            };
            var _local_4:int = (_local_3.length - 1);
            while (_local_4 >= 0)
            {
                _local_5 = (_local_3[_local_4] as PlayerInfo);
                if (!((_arg_1.IsVIP) && (!(_local_5.IsVIP))))
                {
                    if (((!(_arg_1.IsVIP)) && (_local_5.IsVIP)))
                    {
                        return (_local_4 + 1);
                    };
                };
                _local_4--;
            };
            return (_local_2);
        }

        private function __onResError(_arg_1:UIModuleEvent):void
        {
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE, this.__onResComplete);
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_ERROR, this.__onResError);
        }

        private function __onResComplete(_arg_1:UIModuleEvent):void
        {
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE, this.__onResComplete);
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_ERROR, this.__onResError);
            if (((_arg_1.module == UIModuleTypes.DDTINVITE) && (this._visible)))
            {
                this._resState = "complete";
                this.configUi();
                this.addEvent();
                if (PlayerManager.Instance.Self.ConsortiaID != 0)
                {
                    this.refleshList(Brotherhood);
                }
                else
                {
                    this.refleshList(Friend);
                };
            };
        }

        private function refleshList(_arg_1:int, _arg_2:int=0):void
        {
            this._btnGroup.selectIndex = _arg_1;
            this._oldSelected = _arg_1;
            if (_arg_1 == Hall)
            {
                GameInSocketOut.sendGetScenePlayer(_arg_2);
            }
            else
            {
                if (_arg_1 == Friend)
                {
                    this.updateList(Friend, PlayerManager.Instance.onlineFriendList);
                }
                else
                {
                    if (_arg_1 == Brotherhood)
                    {
                        this.updateList(Brotherhood, ConsortionModelControl.Instance.model.onlineConsortiaMemberList);
                    }
                    else
                    {
                        if (_arg_1 == RECENT)
                        {
                            this.updateList(RECENT, this.rerecentContactList);
                        };
                    };
                };
            };
        }

        private function get rerecentContactList():Array
        {
            var _local_3:FriendListPlayer;
            var _local_5:int;
            var _local_6:PlayerState;
            var _local_1:DictionaryData = PlayerManager.Instance.recentContacts;
            var _local_2:Array = IMController.Instance.recentContactsList;
            var _local_4:Array = [];
            if (_local_2)
            {
                _local_5 = 0;
                while (_local_5 < _local_2.length)
                {
                    if (_local_2[_local_5] != 0)
                    {
                        _local_3 = _local_1[_local_2[_local_5]];
                        if (((_local_3) && (_local_4.indexOf(_local_3) == -1)))
                        {
                            if (PlayerManager.Instance.findPlayer(_local_3.ID, PlayerManager.Instance.Self.ZoneID))
                            {
                                _local_6 = new PlayerState(PlayerManager.Instance.findPlayer(_local_3.ID, PlayerManager.Instance.Self.ZoneID).playerState.StateID);
                                _local_3.playerState = _local_6;
                            };
                            if (_local_3.playerState.StateID != PlayerState.OFFLINE)
                            {
                                _local_4.push(_local_3);
                            };
                        };
                    };
                    _local_5++;
                };
            };
            return (_local_4);
        }

        override public function dispose():void
        {
            this._visible = false;
            if (this._resState == "loading")
            {
                UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE, this.__onResComplete);
                UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_ERROR, this.__onResError);
            }
            else
            {
                this.removeEvent();
                if (this._list)
                {
                    ObjectUtils.disposeObject(this._list);
                    this._list = null;
                };
                if (this._hbox)
                {
                    ObjectUtils.disposeObject(this._hbox);
                    this._hbox = null;
                };
                if (this._brotherhoodButton)
                {
                    ObjectUtils.disposeObject(this._brotherhoodButton);
                    this._brotherhoodButton = null;
                };
                if (this._frientButton)
                {
                    ObjectUtils.disposeObject(this._frientButton);
                    this._frientButton = null;
                };
                if (this._hallButton)
                {
                    ObjectUtils.disposeObject(this._hallButton);
                    this._hallButton = null;
                };
                if (this._refreshButton)
                {
                    ObjectUtils.disposeObject(this._refreshButton);
                    this._refreshButton = null;
                };
                if (this._inviteButton)
                {
                    ObjectUtils.disposeObject(this._inviteButton);
                };
                if (this._listBack)
                {
                    ObjectUtils.disposeObject(this._listBack);
                    this._listBack = null;
                };
                if (this._recentContactBtn)
                {
                    ObjectUtils.disposeObject(this._recentContactBtn);
                    this._recentContactBtn = null;
                };
            };
            super.dispose();
        }


    }
}//package invite

