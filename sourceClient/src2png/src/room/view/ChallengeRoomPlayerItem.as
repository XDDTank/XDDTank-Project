// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//room.view.ChallengeRoomPlayerItem

package room.view
{
    import flash.display.Sprite;
    import com.pickgliss.ui.core.Disposeable;
    import com.pickgliss.ui.image.ScaleFrameImage;
    import flash.display.Bitmap;
    import com.pickgliss.ui.text.FilterFrameText;
    import com.pickgliss.ui.text.GradientText;
    import ddt.view.common.LevelIcon;
    import ddt.view.PlayerPortraitView;
    import ddt.view.FaceContainer;
    import room.model.RoomPlayer;
    import com.pickgliss.ui.ComponentFactory;
    import flash.geom.Point;
    import flash.geom.Rectangle;
    import flash.events.MouseEvent;
    import room.RoomManager;
    import ddt.events.RoomEvent;
    import ddt.manager.ChatManager;
    import ddt.view.chat.ChatEvent;
    import room.events.RoomPlayerEvent;
    import ddt.manager.SoundManager;
    import ddt.manager.GameInSocketOut;
    import room.model.RoomInfo;
    import ddt.manager.MessageTipManager;
    import ddt.manager.LanguageMgr;
    import ddt.manager.PlayerManager;
    import ddt.events.PlayerPropertyEvent;
    import game.model.GameInfo;
    import game.GameManager;
    import com.pickgliss.utils.ObjectUtils;
    import ddt.utils.PositionUtils;
    import vip.VipController;
    import com.pickgliss.utils.DisplayUtils;

    public class ChallengeRoomPlayerItem extends Sprite implements Disposeable 
    {

        private var _bg:ScaleFrameImage;
        private var _ready:Bitmap;
        private var _nameTxt:FilterFrameText;
        private var _vipName:GradientText;
        private var _levelIcon:LevelIcon;
        private var _portrait:PlayerPortraitView;
        private var _place:int;
        private var _face:FaceContainer;
        private var _info:RoomPlayer;
        private var _opened:Boolean;
        private var _hostPic:Bitmap;
        private var _hitArea:RoomPlayerArea;
        private var _switchInEnabled:Boolean;
        private var _onClickPlayerTip:RoomTouchItem;

        public function ChallengeRoomPlayerItem(_arg_1:int)
        {
            this._place = _arg_1;
            this.initView();
            this.initEvents();
        }

        private function initView():void
        {
            this._bg = ComponentFactory.Instance.creatComponentByStylename("asset.ddtroom.smallPlayerItemGBAsset");
            this._bg.setFrame(3);
            addChild(this._bg);
            this._face = ComponentFactory.Instance.creatCustomObject("asset.ddtroom.playerItem.face");
            addChild(this._face);
            var _local_1:Point = ComponentFactory.Instance.creatCustomObject("asset.ddtroom.smallPlayerItem.facePos");
            this._face.x = _local_1.x;
            this._face.y = _local_1.y;
            this._nameTxt = ComponentFactory.Instance.creatComponentByStylename("asset.ddroom.playerItem.NameTxt");
            this._hitArea = ComponentFactory.Instance.creatCustomObject("asset.ddtroom.smallplayerItemClickArea");
            var _local_2:Rectangle = ComponentFactory.Instance.creatCustomObject("asset.ddtroom.smallPlayerItem.hitRect");
            this._hitArea.graphics.beginFill(0, 0);
            this._hitArea.graphics.drawRect(_local_2.x, _local_2.y, _local_2.width, _local_2.height);
            this._hitArea.graphics.endFill();
            this._hitArea.buttonMode = true;
            addChild(this._hitArea);
        }

        public function set switchInEnabled(_arg_1:Boolean):void
        {
            this._switchInEnabled = _arg_1;
            if (((this._switchInEnabled) && (this._opened)))
            {
                this._hitArea.visible = this._switchInEnabled;
            };
        }

        private function initEvents():void
        {
            this._hitArea.addEventListener(MouseEvent.CLICK, this.__clickHandler);
            RoomManager.Instance.current.addEventListener(RoomEvent.STARTED_CHANGED, this.__startHandler);
            ChatManager.Instance.addEventListener(ChatEvent.SHOW_FACE, this.__getFace);
            RoomManager.Instance.current.selfRoomPlayer.addEventListener(RoomPlayerEvent.IS_HOST_CHANGE, this.__updateButton);
        }

        private function __clickHandler(_arg_1:MouseEvent):void
        {
            var _local_2:Point;
            SoundManager.instance.play("008");
            if (this._info)
            {
                if (this._onClickPlayerTip == null)
                {
                    this._onClickPlayerTip = ComponentFactory.Instance.creatCustomObject("ddtroom.ClickTip");
                };
                this._onClickPlayerTip._place = this._info.place;
                this._onClickPlayerTip.roomPlayer = this._info;
                this._onClickPlayerTip.info = this._info.playerInfo;
                _local_2 = this.localToGlobal(new Point(mouseX, mouseY));
                this._onClickPlayerTip.x = _local_2.x;
                this._onClickPlayerTip.y = _local_2.y;
                this._onClickPlayerTip.setVisible = true;
            }
            else
            {
                if (((this._switchInEnabled) && (!(RoomManager.Instance.current.selfRoomPlayer.isHost))))
                {
                    GameInSocketOut.sendGameRoomPlaceState(RoomManager.Instance.current.selfRoomPlayer.place, -1, true, this._place);
                    return;
                };
                if (this._opened)
                {
                    if (RoomManager.Instance.current.type == RoomInfo.CHALLENGE_ROOM)
                    {
                        if (RoomManager.Instance.canSmallCloseItem(this))
                        {
                            GameInSocketOut.sendGameRoomPlaceState(this._place, ((this._opened) ? 0 : -1));
                        }
                        else
                        {
                            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.room.RoomIIPlayerItem.position"));
                        };
                    }
                    else
                    {
                        GameInSocketOut.sendGameRoomPlaceState(this._place, ((this._opened) ? 0 : -1));
                    };
                }
                else
                {
                    if (PlayerManager.Instance.Self.Grade >= 6)
                    {
                        GameInSocketOut.sendGameRoomPlaceState(this._place, ((this._opened) ? 0 : -1));
                    }
                    else
                    {
                        MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.room.cantOpenMuti"));
                    };
                };
            };
        }

        private function __startHandler(_arg_1:RoomEvent):void
        {
            this.updateButtons();
        }

        private function __updateButton(_arg_1:RoomPlayerEvent):void
        {
            this.updateButtons();
        }

        private function __infoStateChange(_arg_1:RoomPlayerEvent):void
        {
            this.updatePlayerState();
            this.updateButtons();
        }

        private function __playerInfoChange(_arg_1:PlayerPropertyEvent):void
        {
            this._info.playerInfo.currentPet = this._info.playerInfo.pets[0];
            this.updateInfoView();
        }

        private function __getFace(_arg_1:ChatEvent):void
        {
            if (this._info == null)
            {
                return;
            };
            var _local_2:Object = _arg_1.data;
            if (_local_2["playerid"] == this._info.playerInfo.ID)
            {
                this._face.setFace(_local_2["faceid"]);
            };
            addChild(this._face);
        }

        public function get info():RoomPlayer
        {
            return (this._info);
        }

        public function set place(_arg_1:int):void
        {
            this._place = _arg_1;
        }

        public function get place():int
        {
            return (this._place);
        }

        public function set info(_arg_1:RoomPlayer):void
        {
            var _local_2:GameInfo;
            if (this._info)
            {
                this._info.removeEventListener(RoomPlayerEvent.READY_CHANGE, this.__infoStateChange);
                this._info.removeEventListener(RoomPlayerEvent.IS_HOST_CHANGE, this.__infoStateChange);
                this._info.playerInfo.removeEventListener(PlayerPropertyEvent.PROPERTY_CHANGE, this.__playerInfoChange);
                this._info = null;
                this._face.clearFace();
            };
            this._info = _arg_1;
            if (this._info == null)
            {
                if (RoomManager.Instance.current.selfRoomPlayer.isViewer)
                {
                    this.switchInEnabled = true;
                };
            };
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

        private function headMask():Sprite
        {
            var _local_1:Sprite = new Sprite();
            _local_1.graphics.beginFill(0);
            _local_1.graphics.drawRect(7, 29, 69, 56);
            _local_1.graphics.endFill();
            return (_local_1);
        }

        private function updateView():void
        {
            this.updateBackground();
            this.updateInfoView();
            this.updateButtons();
            this.updatePlayerState();
            if (this._info)
            {
            };
        }

        private function updateBackground():void
        {
            if (this._info)
            {
                this._bg.setFrame(3);
            }
            else
            {
                this._bg.setFrame(((this._opened) ? 1 : 2));
            };
        }

        private function updateInfoView():void
        {
            var _local_1:Sprite;
            if (((this._ready) && (this._ready.visible)))
            {
                this._ready.visible = false;
            };
            if (this._info)
            {
                if (this._portrait)
                {
                    ObjectUtils.disposeObject(this._portrait);
                    this._portrait = null;
                };
                if (this._portrait == null)
                {
                    _local_1 = this.headMask();
                    this._portrait = ComponentFactory.Instance.creatCustomObject("ddtChallengeRoom.PortraitView", ["left", 1]);
                    this._portrait.info = this._info.playerInfo;
                    this._portrait.isShowFrame = false;
                    addChild(this._portrait);
                };
                if (this._levelIcon == null)
                {
                    this._levelIcon = ComponentFactory.Instance.creatCustomObject("asset.ddtroom.playerItem.LevelIcon");
                    PositionUtils.setPos(this._levelIcon, "asset.ddtChallengeSmallItemLevel.pos");
                    addChild(this._levelIcon);
                };
                this._levelIcon.setInfo(this._info.playerInfo.Grade, this._info.playerInfo.Repute, this._info.playerInfo.WinCount, this._info.playerInfo.TotalCount, this._info.playerInfo.FightPower, this._info.playerInfo.Offer, true, false);
                if (this._info.isSelf)
                {
                    this._levelIcon.allowClick();
                };
                this._nameTxt.text = this._info.playerInfo.NickName;
                if (this._nameTxt.text.length > 5)
                {
                    this._nameTxt.text = (this._nameTxt.text.substr(0, 4) + ".");
                };
                PositionUtils.setPos(this._nameTxt, "asset.ddtChallengeSmallItemNameTxt.pos");
                addChild(this._nameTxt);
                if (this._info.playerInfo.IsVIP)
                {
                    ObjectUtils.disposeObject(this._vipName);
                    this._vipName = VipController.instance.getVipNameTxt(106, this._info.playerInfo.VIPtype);
                    this._vipName.x = this._nameTxt.x;
                    this._vipName.y = this._nameTxt.y;
                    this._vipName.text = this._nameTxt.text;
                    addChild(this._vipName);
                };
                PositionUtils.adaptNameStyle(this.info.playerInfo, this._nameTxt, this._vipName);
                if (this._info.isReady)
                {
                    if ((!(this._ready)))
                    {
                        this._ready = ComponentFactory.Instance.creatBitmap("asset.ddchallengeSmallPlayerItem.ready");
                    };
                    addChild(this._ready);
                    this._ready.visible = true;
                }
                else
                {
                    if (((this._ready) && (this._ready.visible)))
                    {
                        this._ready.visible = false;
                    };
                };
            }
            else
            {
                if (this._portrait)
                {
                    ObjectUtils.disposeObject(this._portrait);
                    this._portrait = null;
                };
                ObjectUtils.disposeObject(this._levelIcon);
                this._levelIcon = null;
                this._nameTxt.text = "";
                DisplayUtils.removeDisplay(this._vipName);
            };
        }

        public function updateButtons():void
        {
            if (this._info)
            {
                this._hitArea.visible = true;
            }
            else
            {
                if (RoomManager.Instance.current.started)
                {
                    this._hitArea.visible = false;
                }
                else
                {
                    if ((((RoomManager.Instance.current.selfRoomPlayer.isViewer) && (this._switchInEnabled)) && (this._opened)))
                    {
                        this._hitArea.visible = true;
                    }
                    else
                    {
                        this._hitArea.visible = RoomManager.Instance.current.selfRoomPlayer.isHost;
                    };
                };
            };
        }

        public function updatePlayerState():void
        {
            if (this._info)
            {
                if (this._info.isReady)
                {
                    if ((!(this._ready)))
                    {
                        this._ready = ComponentFactory.Instance.creatBitmap("asset.ddchallengeSmallPlayerItem.ready");
                    };
                    addChild(this._ready);
                    this._ready.visible = true;
                }
                else
                {
                    if (((this._ready) && (this._ready.visible)))
                    {
                        this._ready.visible = false;
                    };
                };
                if (this._info.isHost)
                {
                    if ((!(this._hostPic)))
                    {
                        this._hostPic = ComponentFactory.Instance.creatBitmap("asset.ddtroom.SmallplayerItem.host");
                    };
                    addChild(this._hostPic);
                    this._hostPic.visible = true;
                }
                else
                {
                    if (((this._hostPic) && (this._hostPic.visible)))
                    {
                        this._hostPic.visible = false;
                    };
                };
            }
            else
            {
                if (((this._ready) && (this._ready.visible)))
                {
                    this._ready.visible = false;
                };
                if (((this._hostPic) && (this._hostPic.visible)))
                {
                    this._hostPic.visible = false;
                };
            };
        }

        private function removeEvents():void
        {
            RoomManager.Instance.current.removeEventListener(RoomEvent.STARTED_CHANGED, this.__startHandler);
            ChatManager.Instance.removeEventListener(ChatEvent.SHOW_FACE, this.__getFace);
            if (this._info)
            {
                this._info.removeEventListener(RoomPlayerEvent.READY_CHANGE, this.__infoStateChange);
                this._info.removeEventListener(RoomPlayerEvent.IS_HOST_CHANGE, this.__infoStateChange);
                this._info.playerInfo.removeEventListener(PlayerPropertyEvent.PROPERTY_CHANGE, this.__playerInfoChange);
            };
            RoomManager.Instance.current.selfRoomPlayer.removeEventListener(RoomPlayerEvent.IS_HOST_CHANGE, this.__updateButton);
        }

        public function set opened(_arg_1:Boolean):void
        {
            this._opened = _arg_1;
            this.updateView();
        }

        public function dispose():void
        {
            this.removeEvents();
            if (this._bg)
            {
                ObjectUtils.disposeObject(this._bg);
                (this._bg == null);
            };
            if (this._vipName)
            {
                ObjectUtils.disposeObject(this._vipName);
            };
            this._vipName = null;
            if (this._levelIcon)
            {
                this._levelIcon.dispose();
            };
            this._levelIcon = null;
            if (this._face)
            {
                this._face.dispose();
            };
            this._face = null;
            ObjectUtils.disposeObject(this._portrait);
            if (this._hitArea)
            {
                ObjectUtils.disposeObject(this._hitArea);
            };
            this._hitArea = null;
            this._info = null;
            if (parent)
            {
                parent.removeChild(this);
            };
        }


    }
}//package room.view

