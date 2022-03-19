// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//room.view.RoomTouchItem

package room.view
{
    import ddt.view.chat.ChatBasePanel;
    import com.pickgliss.ui.image.ScaleBitmapImage;
    import com.pickgliss.ui.text.FilterFrameText;
    import com.pickgliss.ui.text.GradientText;
    import com.pickgliss.ui.image.Scale9CornerImage;
    import com.pickgliss.ui.controls.IconButton;
    import com.pickgliss.ui.controls.container.VBox;
    import ddt.view.common.VipLevelIcon;
    import ddt.data.player.PlayerInfo;
    import room.model.RoomPlayer;
    import com.pickgliss.ui.ComponentFactory;
    import ddt.utils.PositionUtils;
    import com.pickgliss.utils.ObjectUtils;
    import ddt.manager.PlayerManager;
    import room.RoomManager;
    import vip.VipController;
    import flash.events.MouseEvent;
    import im.IMController;
    import bagAndInfo.info.PlayerInfoViewControl;
    import ddt.manager.SoundManager;
    import ddt.manager.GameInSocketOut;

    public class RoomTouchItem extends ChatBasePanel 
    {

        private var _rule:ScaleBitmapImage;
        public var playerName:String;
        public var _place:int;
        private var _guild:FilterFrameText;
        private var _nameTxt:FilterFrameText;
        private var _vipName:GradientText;
        public var id:int;
        private var _bg:Scale9CornerImage;
        private var _viewInfoBtn:IconButton;
        private var _addFriendBtn:IconButton;
        private var _kickedoutBtn:IconButton;
        private var _btnContainer:VBox;
        private var _vipIcon:VipLevelIcon;
        private var _info:PlayerInfo;
        private var _roomPlayer:RoomPlayer;


        override protected function init():void
        {
            super.init();
            this._bg = ComponentFactory.Instance.creatComponentByStylename("core.newScale9CornerImage.scale9CornerImage4");
            this._bg.width = 179;
            this._bg.height = 128;
            this._rule = ComponentFactory.Instance.creatComponentByStylename("HRuleAsset");
            this._rule.width = 162;
            PositionUtils.setPos(this._rule, "ddtroom.ClickTip.Pos1");
            this._btnContainer = ComponentFactory.Instance.creatComponentByStylename("chat.NamePanelList");
            PositionUtils.setPos(this._btnContainer, "ddtroom.ClickTip.Pos2");
            this._viewInfoBtn = ComponentFactory.Instance.creatComponentByStylename("room.ItemInfo");
            this._addFriendBtn = ComponentFactory.Instance.creatComponentByStylename("room.ItemMakeFriend");
            this._kickedoutBtn = ComponentFactory.Instance.creatComponentByStylename("room.roomKickedout");
            PositionUtils.setPos(this._kickedoutBtn, "ddtroom.ClickTip.Pos3");
            this._nameTxt = ComponentFactory.Instance.creatComponentByStylename("asset.ddroom.playerItem.NameTxt");
            this._guild = ComponentFactory.Instance.creatComponentByStylename("ddtroom.roomPlayerItemClickTips.gulidTxt");
            addChild(this._bg);
            addChild(this._rule);
            addChild(this._btnContainer);
            this._btnContainer.addChild(this._addFriendBtn);
            this._btnContainer.addChild(this._viewInfoBtn);
            this._btnContainer.addChild(this._kickedoutBtn);
        }

        public function set roomPlayer(_arg_1:RoomPlayer):void
        {
            this._roomPlayer = _arg_1;
        }

        public function get roomPlayer():RoomPlayer
        {
            return (this._roomPlayer);
        }

        public function set info(_arg_1:PlayerInfo):void
        {
            this._info = _arg_1;
            if (this._info)
            {
                if (this._vipIcon)
                {
                    ObjectUtils.disposeObject(this._vipIcon);
                    this._vipIcon = null;
                };
                this._vipIcon = ComponentFactory.Instance.creatCustomObject("asset.ddtroom.playerItem.VipIcon");
                this._vipIcon.setInfo(this._info);
                PositionUtils.setPos(this._vipIcon, "ddtroom.ClickTip.Pos4");
                addChild(this._vipIcon);
                if ((!(this._info.IsVIP)))
                {
                    this._vipIcon.filters = ComponentFactory.Instance.creatFilters("grayFilter");
                }
                else
                {
                    this._vipIcon.filters = null;
                };
                this.id = this._info.ID;
                if (PlayerManager.Instance.Self.ID == this.id)
                {
                    this._kickedoutBtn.enable = false;
                }
                else
                {
                    if ((!(RoomManager.Instance.current.selfRoomPlayer.isHost)))
                    {
                        this._kickedoutBtn.enable = false;
                    }
                    else
                    {
                        if (RoomManager.Instance.current.started)
                        {
                            this._kickedoutBtn.enable = false;
                        }
                        else
                        {
                            this._kickedoutBtn.enable = true;
                        };
                    };
                };
                this.playerName = this._info.NickName;
                this._nameTxt.text = this.playerName;
                PositionUtils.setPos(this._nameTxt, "ddtroom.ClickTip.Pos5");
                addChild(this._nameTxt);
                if (this._info.IsVIP)
                {
                    ObjectUtils.disposeObject(this._vipName);
                    this._vipName = VipController.instance.getVipNameTxt(106, this._info.VIPtype);
                    this._vipName.x = this._nameTxt.x;
                    this._vipName.y = this._nameTxt.y;
                    this._vipName.text = this._nameTxt.text;
                    addChild(this._vipName);
                };
                PositionUtils.adaptNameStyle(this._info, this._nameTxt, this._vipName);
                if (this._info.ConsortiaID == 0)
                {
                    this._guild.text = "公会: 无";
                    addChild(this._guild);
                }
                else
                {
                    this._guild.text = ("公会: " + this._info.ConsortiaName);
                    addChild(this._guild);
                };
            };
        }

        override protected function initEvent():void
        {
            super.initEvent();
            this._addFriendBtn.addEventListener(MouseEvent.CLICK, this.__onBtnClicked);
            this._viewInfoBtn.addEventListener(MouseEvent.CLICK, this.__onBtnClicked);
            this._kickedoutBtn.addEventListener(MouseEvent.CLICK, this.__onBtnClicked);
        }

        private function __onBtnClicked(_arg_1:MouseEvent):void
        {
            switch (_arg_1.currentTarget)
            {
                case this._addFriendBtn:
                    IMController.Instance.addFriend(this.playerName);
                    return;
                case this._viewInfoBtn:
                    PlayerInfoViewControl.viewByID(this.id);
                    PlayerInfoViewControl.isOpenFromBag = false;
                    return;
                case this._kickedoutBtn:
                    SoundManager.instance.play("008");
                    GameInSocketOut.sendGameRoomKick(this._place);
                    return;
            };
        }

        override protected function removeEvent():void
        {
            super.removeEvent();
            this._addFriendBtn.removeEventListener(MouseEvent.CLICK, this.__onBtnClicked);
            this._viewInfoBtn.removeEventListener(MouseEvent.CLICK, this.__onBtnClicked);
            this._kickedoutBtn.removeEventListener(MouseEvent.CLICK, this.__onBtnClicked);
        }


    }
}//package room.view

