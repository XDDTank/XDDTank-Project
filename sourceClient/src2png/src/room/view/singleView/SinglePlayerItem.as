// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//room.view.singleView.SinglePlayerItem

package room.view.singleView
{
    import flash.display.Sprite;
    import com.pickgliss.ui.core.Disposeable;
    import com.pickgliss.ui.image.MutipleImage;
    import room.view.RoomPlayerArea;
    import com.pickgliss.ui.text.FilterFrameText;
    import com.pickgliss.ui.text.GradientText;
    import com.pickgliss.ui.image.ScaleFrameImage;
    import ddt.view.character.RoomCharacter;
    import ddt.view.common.LevelIcon;
    import ddt.view.common.VipLevelIcon;
    import consortion.view.selfConsortia.Badge;
    import com.pickgliss.ui.controls.container.VBox;
    import militaryrank.view.MilitaryIcon;
    import room.model.RoomPlayer;
    import room.view.RoomPlayerItemPet;
    import flash.display.Bitmap;
    import com.pickgliss.ui.ComponentFactory;
    import flash.geom.Rectangle;
    import ddt.utils.PositionUtils;
    import com.pickgliss.utils.ObjectUtils;
    import flash.events.MouseEvent;
    import room.RoomManager;
    import ddt.events.RoomEvent;
    import ddt.bagStore.BagStore;
    import flash.events.Event;
    import room.events.RoomPlayerEvent;
    import ddt.events.PlayerPropertyEvent;
    import ddt.events.WebSpeedEvent;
    import ddt.manager.SoundManager;
    import ddt.manager.PlayerTipManager;
    import flash.geom.Point;
    import bagAndInfo.info.PlayerInfoViewControl;
    import game.model.GameInfo;
    import game.GameManager;
    import room.model.RoomInfo;
    import ddt.manager.PlayerManager;
    import vip.VipController;
    import com.pickgliss.utils.DisplayUtils;

    public class SinglePlayerItem extends Sprite implements Disposeable 
    {

        private var _bg:MutipleImage;
        private var _hitArea:RoomPlayerArea;
        private var _guildTxt:FilterFrameText;
        private var _guildName:FilterFrameText;
        private var _playerName:FilterFrameText;
        private var _vipName:GradientText;
        private var _signal:ScaleFrameImage;
        private var _signalExplain:ScaleFrameImage;
        private var _chracter:RoomCharacter;
        private var _levelIcon:LevelIcon;
        private var _vipIcon:VipLevelIcon;
        private var _badge:Badge;
        private var _iconContainer:VBox;
        private var _militaryIcon:MilitaryIcon;
        private var _info:RoomPlayer;
        private var _roomPlayerItemPet:RoomPlayerItemPet;
        private var _petHeadFrameBg:Bitmap;
        private var _characterContainer:Sprite;

        public function SinglePlayerItem()
        {
            this.initView();
            this.initEvents();
        }

        private function initView():void
        {
            this._bg = ComponentFactory.Instance.creatComponentByStylename("asset.ddtroomList.RoomList.SingleRoomView.playerView.bg");
            addChild(this._bg);
            this._hitArea = ComponentFactory.Instance.creatCustomObject("asset.ddtroomlist.singleRoom.playerItemClickArea");
            var _local_1:Rectangle = ComponentFactory.Instance.creatCustomObject("asset.ddtroomlist.singleRoom.playerItem.hitRect");
            this._hitArea.graphics.beginFill(0, 0);
            this._hitArea.graphics.drawRect(_local_1.x, _local_1.y, _local_1.width, _local_1.height);
            this._hitArea.graphics.endFill();
            this._hitArea.buttonMode = true;
            addChild(this._hitArea);
            this._playerName = ComponentFactory.Instance.creatComponentByStylename("asset.ddtroomList.Single.playerView.NameTxt");
            this._iconContainer = ComponentFactory.Instance.creatComponentByStylename("asset.ddtroomList.Single.playerView.iconContainer");
            addChild(this._iconContainer);
            this._guildTxt = ComponentFactory.Instance.creatComponentByStylename("asset.ddtroomList.single.GuildTxt");
            this._guildTxt.text = "公会:";
            addChild(this._guildTxt);
            this._guildName = ComponentFactory.Instance.creatComponentByStylename("asset.ddtroomList.single.GuildName");
            addChild(this._guildName);
        }

        private function updatePet():void
        {
            if (((((this._info) && (this._info.playerInfo)) && (this._info.playerInfo.currentPet)) && (this._info.playerInfo.currentPet.IsEquip)))
            {
                if ((!(this._roomPlayerItemPet)))
                {
                    this._petHeadFrameBg = ComponentFactory.Instance.creatBitmap("asset.ddtroom.playerItem.petHeadFrame");
                    PositionUtils.setPos(this._petHeadFrameBg, "asset.ddtroom.playerItem.petHeadFramePos2");
                    addChild(this._petHeadFrameBg);
                    this._roomPlayerItemPet = new RoomPlayerItemPet(this._petHeadFrameBg.width, this._petHeadFrameBg.height);
                    PositionUtils.setPos(this._roomPlayerItemPet, "asset.ddtroomList.Single.playerView.PetPos");
                    this._roomPlayerItemPet.mouseChildren = false;
                    this._roomPlayerItemPet.mouseEnabled = false;
                    addChild(this._roomPlayerItemPet);
                };
                this._roomPlayerItemPet.updateView(this._info.playerInfo.currentPet);
            }
            else
            {
                this.removePet();
            };
        }

        private function removePet():void
        {
            if (this._petHeadFrameBg)
            {
                ObjectUtils.disposeObject(this._petHeadFrameBg);
            };
            this._petHeadFrameBg = null;
            if (this._roomPlayerItemPet)
            {
                ObjectUtils.disposeObject(this._roomPlayerItemPet);
            };
            this._roomPlayerItemPet = null;
        }

        private function initEvents():void
        {
            this._hitArea.addEventListener(MouseEvent.CLICK, this.__clickHandler);
            RoomManager.Instance.current.addEventListener(RoomEvent.STARTED_CHANGED, this.__startHandler);
            BagStore.instance.addEventListener(BagStore.OPEN_BAGSTORE, this.__openStoreHandler);
            BagStore.instance.addEventListener(BagStore.CLOSE_BAGSTORE, this.__closeStoreHandler);
        }

        private function __showExplain(_arg_1:MouseEvent):void
        {
            this._signalExplain.visible = true;
            this._signalExplain.setFrame(this._signal.getFrame);
        }

        private function __hideExplain(_arg_1:MouseEvent):void
        {
            this._signalExplain.visible = false;
        }

        private function __closeStoreHandler(_arg_1:Event):void
        {
            if (this._chracter)
            {
                this._chracter.playAnimation();
            };
        }

        private function __openStoreHandler(_arg_1:Event):void
        {
            if (this._chracter)
            {
                this._chracter.stopAnimation();
            };
        }

        private function removeEvents():void
        {
            this._hitArea.removeEventListener(MouseEvent.CLICK, this.__clickHandler);
            RoomManager.Instance.current.removeEventListener(RoomEvent.STARTED_CHANGED, this.__startHandler);
            BagStore.instance.removeEventListener(BagStore.OPEN_BAGSTORE, this.__openStoreHandler);
            BagStore.instance.removeEventListener(BagStore.CLOSE_BAGSTORE, this.__closeStoreHandler);
            if (this._info)
            {
                this._info.removeEventListener(RoomPlayerEvent.READY_CHANGE, this.__infoStateChange);
                this._info.removeEventListener(RoomPlayerEvent.IS_HOST_CHANGE, this.__infoStateChange);
                this._info.playerInfo.removeEventListener(PlayerPropertyEvent.PROPERTY_CHANGE, this.__playerInfoChange);
                this._info.webSpeedInfo.removeEventListener(WebSpeedEvent.STATE_CHANE, this.__updateWebSpeed);
            };
        }

        private function __viewClickHandler(_arg_1:MouseEvent):void
        {
            SoundManager.instance.play("008");
            _arg_1.stopImmediatePropagation();
            PlayerTipManager.show(this._info.playerInfo, localToGlobal(new Point(0, 0)).y);
        }

        private function __clickHandler(_arg_1:MouseEvent):void
        {
            SoundManager.instance.play("008");
            PlayerInfoViewControl.view(this._info.playerInfo);
        }

        private function __startHandler(_arg_1:RoomEvent):void
        {
        }

        private function __infoStateChange(_arg_1:RoomPlayerEvent):void
        {
        }

        private function __playerInfoChange(_arg_1:PlayerPropertyEvent):void
        {
            this.updateInfoView();
        }

        public function set info(_arg_1:RoomPlayer):void
        {
            var _local_2:GameInfo;
            if (this._info)
            {
                this._info.removeEventListener(RoomPlayerEvent.READY_CHANGE, this.__infoStateChange);
                this._info.removeEventListener(RoomPlayerEvent.IS_HOST_CHANGE, this.__infoStateChange);
                this._info.playerInfo.removeEventListener(PlayerPropertyEvent.PROPERTY_CHANGE, this.__playerInfoChange);
                this._info.webSpeedInfo.removeEventListener(WebSpeedEvent.STATE_CHANE, this.__updateWebSpeed);
                this._info = null;
            };
            this._info = _arg_1;
            if (this._info)
            {
                _local_2 = GameManager.Instance.Current;
                if ((((!(_local_2 == null)) && (_local_2.hasNextMission)) && (RoomManager.Instance.current.type == RoomInfo.DUNGEON_ROOM)))
                {
                    _local_2.viewerToLiving(this._info.playerInfo.ID);
                };
                this._info.addEventListener(RoomPlayerEvent.READY_CHANGE, this.__infoStateChange);
                this._info.addEventListener(RoomPlayerEvent.IS_HOST_CHANGE, this.__infoStateChange);
                this._info.playerInfo.addEventListener(PlayerPropertyEvent.PROPERTY_CHANGE, this.__playerInfoChange);
                this._info.webSpeedInfo.addEventListener(WebSpeedEvent.STATE_CHANE, this.__updateWebSpeed);
            };
            if (((this._info) && (this._info.isSelf)))
            {
                if (((PlayerManager.Instance.Self.isUpGradeInGame) && (PlayerManager.Instance.Self.Grade > 15)))
                {
                    PlayerManager.Instance.Self.isUpGradeInGame = false;
                };
            };
            this.updateView();
        }

        public function get info():RoomPlayer
        {
            return (this._info);
        }

        private function __updateWebSpeed(_arg_1:WebSpeedEvent):void
        {
        }

        private function updateView():void
        {
            this.updateInfoView();
            if (this._info)
            {
                this._hitArea.tipData = this._info.playerInfo;
            };
        }

        private function updateInfoView():void
        {
            ObjectUtils.disposeObject(this._vipIcon);
            this._vipIcon = null;
            ObjectUtils.disposeObject(this._militaryIcon);
            this._militaryIcon = null;
            ObjectUtils.disposeObject(this._badge);
            this._badge = null;
            if (this._info)
            {
                if (this._characterContainer == null)
                {
                    if (this._chracter == null)
                    {
                        this._chracter = this._info.roomCharater;
                    };
                    this._info.resetCharacter();
                    this._chracter.x = 20;
                    this._characterContainer = new Sprite();
                    this._characterContainer.addChild(this._chracter);
                    this._characterContainer.x = 173;
                    this._characterContainer.y = 50;
                    this._characterContainer.scaleX = 1.3;
                    this._characterContainer.scaleY = 1.3;
                    this._chracter.show(false, -1);
                    this._chracter.setShowLight(true);
                    this._chracter.showGun = true;
                    this._chracter.playAnimation();
                    addChildAt(this._characterContainer, 1);
                };
                if (this._levelIcon == null)
                {
                    this._levelIcon = ComponentFactory.Instance.creatCustomObject("asset.ddtroomList.Single.playerView.LevelIcon");
                    addChild(this._levelIcon);
                };
                this._levelIcon.setInfo(this._info.playerInfo.Grade, this._info.playerInfo.Repute, this._info.playerInfo.WinCount, this._info.playerInfo.TotalCount, this._info.playerInfo.FightPower, this._info.playerInfo.Offer, true, false);
                if (this._info.isSelf)
                {
                    this._levelIcon.allowClick();
                };
                if (((this._info.playerInfo.ID == PlayerManager.Instance.Self.ID) || (this._info.playerInfo.IsVIP)))
                {
                    if (this._vipIcon == null)
                    {
                        this._vipIcon = ComponentFactory.Instance.creatCustomObject("asset.ddtroom.playerItem.VipIcon");
                        this._vipIcon.setInfo(this._info.playerInfo);
                        this._iconContainer.addChild(this._vipIcon);
                        if ((!(this._info.playerInfo.IsVIP)))
                        {
                            this._vipIcon.filters = ComponentFactory.Instance.creatFilters("grayFilter");
                        }
                        else
                        {
                            this._vipIcon.filters = null;
                        };
                    };
                }
                else
                {
                    if (this._vipIcon)
                    {
                        this._vipIcon.dispose();
                        this._vipIcon = null;
                    };
                };
                if ((!(this._militaryIcon)))
                {
                    this._militaryIcon = new MilitaryIcon(this._info.playerInfo);
                    this._militaryIcon.setMilitary(this._info.playerInfo.MilitaryRankTotalScores);
                    this._iconContainer.addChild(this._militaryIcon);
                }
                else
                {
                    this._militaryIcon.Info = this._info.playerInfo;
                    this._militaryIcon.setMilitary(this._info.playerInfo.MilitaryRankTotalScores);
                };
                this._playerName.text = this._info.playerInfo.NickName;
                addChild(this._playerName);
                if (this._info.playerInfo.IsVIP)
                {
                    ObjectUtils.disposeObject(this._vipName);
                    this._vipName = VipController.instance.getVipNameTxt(106, this._info.playerInfo.VIPtype);
                    this._vipName.x = this._playerName.x;
                    this._vipName.y = this._playerName.y;
                    this._vipName.text = this._playerName.text;
                    addChild(this._vipName);
                };
                PositionUtils.adaptNameStyle(this.info.playerInfo, this._playerName, this._vipName);
                this._guildName.text = ((this._info.playerInfo.ConsortiaName) ? this._info.playerInfo.ConsortiaName : "");
                if (this._guildName.text.length > 7)
                {
                    this._guildName.text = (this._guildName.text.substr(0, 4) + "...");
                };
                if (((this._info.playerInfo.ConsortiaID > 0) && (this._info.playerInfo.badgeID > 0)))
                {
                    if (this._badge == null)
                    {
                        this._badge = new Badge();
                        this._badge.buttonMode = true;
                        PositionUtils.setPos(this._badge, "asset.ddtroom.playerItem.badgePos");
                        this.addChild(this._badge);
                        PositionUtils.setPos(this._guildName, "asset.ddtroom.playerItem.guildNamePos");
                    };
                    this._badge.badgeID = this._info.playerInfo.badgeID;
                }
                else
                {
                    if (this._badge)
                    {
                        this._badge.dispose();
                    };
                    this._badge = null;
                };
                this.updatePet();
            }
            else
            {
                if (this._characterContainer)
                {
                    removeChild(this._characterContainer);
                };
                if (((!(this._chracter == null)) && (this._characterContainer.contains(this._chracter))))
                {
                    this._characterContainer.removeChild(this._chracter);
                };
                this._characterContainer = null;
                this._chracter = null;
                ObjectUtils.disposeObject(this._levelIcon);
                this._levelIcon = null;
                ObjectUtils.disposeObject(this._vipIcon);
                this._vipIcon = null;
                ObjectUtils.disposeObject(this._militaryIcon);
                this._militaryIcon = null;
                ObjectUtils.disposeObject(this._badge);
                this._badge = null;
                this._guildName.text = "";
                this._playerName.text = "";
                this.removePet();
                if (this._hitArea)
                {
                    this._hitArea.tipData = null;
                };
                DisplayUtils.removeDisplay(this._vipName);
            };
        }

        public function dispose():void
        {
            this.removeEvents();
            this._bg.dispose();
            this._bg = null;
            ObjectUtils.disposeObject(this._guildTxt);
            this._guildTxt = null;
            this._guildName.dispose();
            this._guildName = null;
            this._playerName.dispose();
            this._playerName = null;
            if (this._vipName)
            {
                ObjectUtils.disposeObject(this._vipName);
            };
            this._vipName = null;
            this._signal = null;
            this._signalExplain = null;
            if (this._characterContainer)
            {
                removeChild(this._characterContainer);
            };
            if (((!(this._chracter == null)) && (this._characterContainer.contains(this._chracter))))
            {
                this._characterContainer.removeChild(this._chracter);
            };
            this._characterContainer = null;
            this._chracter = null;
            if (this._levelIcon)
            {
                this._levelIcon.dispose();
            };
            this._levelIcon = null;
            if (this._vipIcon)
            {
                this._vipIcon.dispose();
            };
            this._vipIcon = null;
            if (this._militaryIcon)
            {
                ObjectUtils.disposeObject(this._militaryIcon);
                this._militaryIcon = null;
            };
            ObjectUtils.disposeObject(this._badge);
            this._badge = null;
            ObjectUtils.disposeObject(this._iconContainer);
            this._iconContainer = null;
            this._info = null;
            this.removePet();
            if (this._hitArea)
            {
                ObjectUtils.disposeObject(this._hitArea);
            };
            this._hitArea = null;
            if (parent)
            {
                parent.removeChild(this);
            };
        }


    }
}//package room.view.singleView

