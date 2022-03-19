// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//room.view.RoomPlayerItem

package room.view
{
    import flash.display.Sprite;
    import com.pickgliss.ui.core.Disposeable;
    import com.pickgliss.ui.image.ScaleFrameImage;
    import flash.display.Bitmap;
    import com.pickgliss.ui.text.FilterFrameText;
    import com.pickgliss.ui.text.GradientText;
    import flash.display.MovieClip;
    import ddt.view.FaceContainer;
    import ddt.view.chat.chatBall.ChatBallPlayer;
    import ddt.view.character.RoomCharacter;
    import ddt.view.common.LevelIcon;
    import ddt.view.common.VipLevelIcon;
    import militaryrank.view.MilitaryIcon;
    import platformapi.tencent.view.DiamondIcon;
    import consortion.view.selfConsortia.Badge;
    import com.pickgliss.ui.controls.container.VBox;
    import room.model.RoomPlayer;
    import petsBag.view.item.PetBigItem;
    import ddt.display.BitmapLoaderProxy;
    import flash.geom.Point;
    import com.pickgliss.ui.ComponentFactory;
    import ddt.utils.PositionUtils;
    import flash.geom.Rectangle;
    import room.RoomManager;
    import room.model.RoomInfo;
    import com.pickgliss.utils.ObjectUtils;
    import flash.events.MouseEvent;
    import ddt.events.RoomEvent;
    import ddt.manager.ChatManager;
    import ddt.view.chat.ChatEvent;
    import ddt.bagStore.BagStore;
    import room.events.RoomPlayerEvent;
    import flash.events.Event;
    import ddt.manager.PlayerManager;
    import ddt.manager.SocketManager;
    import ddt.events.PlayerPropertyEvent;
    import ddt.events.WebSpeedEvent;
    import ddt.manager.SoundManager;
    import ddt.manager.PlayerTipManager;
    import im.IMController;
    import ddt.manager.GameInSocketOut;
    import ddt.manager.MessageTipManager;
    import ddt.manager.LanguageMgr;
    import ddt.view.chat.ChatData;
    import ddt.view.chat.ChatInputView;
    import ddt.utils.Helpers;
    import game.model.GameInfo;
    import game.GameManager;
    import ddt.data.goods.ItemTemplateInfo;
    import ddt.manager.ItemManager;
    import ddt.manager.PathManager;
    import ddt.view.character.BaseLayer;
    import ddt.data.player.PlayerInfo;
    import com.pickgliss.utils.DisplayUtils;
    import platformapi.tencent.DiamondManager;
    import platformapi.tencent.DiamondType;
    import vip.VipController;
    import com.pickgliss.utils.ClassUtils;

    public class RoomPlayerItem extends Sprite implements Disposeable 
    {

        private var _bg:ScaleFrameImage;
        private var _bgSmall:Bitmap;
        private var _hitArea:RoomPlayerArea;
        private var _hostPic:Bitmap;
        private var _playerName:FilterFrameText;
        private var _playerNameBg:Bitmap;
        private var _vipName:GradientText;
        private var _signal:ScaleFrameImage;
        private var _signalExplain:ScaleFrameImage;
        private var _readyMc:MovieClip;
        private var _face:FaceContainer;
        private var _chatballview:ChatBallPlayer;
        private var _chracter:RoomCharacter;
        private var _levelIcon:LevelIcon;
        private var _vipIcon:VipLevelIcon;
        private var _militaryIcon:MilitaryIcon;
        private var _diamonIcon:DiamondIcon;
        private var _bunIcon:DiamondIcon;
        private var _badge:Badge;
        private var _iconContainer:VBox;
        private var _info:RoomPlayer;
        private var _opened:Boolean;
        private var _place:int;
        private var _roomPlayerItemPet:RoomPlayerItemPet;
        private var _petHeadFrameBg:Bitmap;
        private var _petItem:PetBigItem;
        private var _onClickPlayerTip:RoomTouchItem;
        private var _switchInEnabled:Boolean;
        private var _weapon:BitmapLoaderProxy;
        private var _characterContainer:Sprite;

        public function RoomPlayerItem(_arg_1:int)
        {
            this._place = _arg_1;
            this.initView();
            this.initEvents();
        }

        private function initView():void
        {
            var _local_2:Point;
            this._bg = ComponentFactory.Instance.creatComponentByStylename("asset.ddtroom.playerItemGBAsset");
            this._bg.setFrame(1);
            addChild(this._bg);
            this._chatballview = new ChatBallPlayer();
            PositionUtils.setPos(this._chatballview, "asset.ddtroom.playerItem.chatBallPos");
            this._playerName = ComponentFactory.Instance.creatComponentByStylename("asset.ddroom.playerItem.NameTxt");
            this._iconContainer = ComponentFactory.Instance.creatComponentByStylename("asset.ddtroom.PlayerItem.iconContainer");
            addChild(this._iconContainer);
            this._playerNameBg = ComponentFactory.Instance.creatBitmap("asset.ddtroom.playerBg");
            addChild(this._playerNameBg);
            this._playerNameBg.visible = false;
            this._hitArea = ComponentFactory.Instance.creatCustomObject("asset.ddtroom.playerItemClickArea");
            var _local_1:Rectangle = ComponentFactory.Instance.creatCustomObject("asset.ddtroom.PlayerItem.hitRect");
            this._hitArea.graphics.beginFill(0, 0);
            this._hitArea.graphics.drawRect(_local_1.x, _local_1.y, _local_1.width, _local_1.height);
            this._hitArea.graphics.endFill();
            this._hitArea.buttonMode = true;
            this._face = ComponentFactory.Instance.creatCustomObject("asset.ddtroom.playerItem.face");
            addChild(this._face);
            this._petItem = new PetBigItem();
            PositionUtils.setPos(this._petItem, "ddtroom.petMovie.Pos");
            this._petItem.mouseEnabled = false;
            this._petItem.mouseChildren = false;
            addChild(this._petItem);
            _local_2 = ComponentFactory.Instance.creatCustomObject("asset.ddtroom.playerItem.facePos");
            this._face.scaleX = 1;
            this._face.x = _local_2.x;
            this._face.y = _local_2.y;
            addChild(this._hitArea);
        }

        private function updatePet():void
        {
            if (((this._info) && (this._info.playerInfo)))
            {
                if (((!(RoomManager.Instance.current)) || (!(RoomManager.Instance.current.type == RoomInfo.CHANGE_DUNGEON))))
                {
                    this._info.playerInfo.currentPet = this._info.playerInfo.pets[0];
                    this._petItem.info = this._info.playerInfo.currentPet;
                };
            }
            else
            {
                this._petItem.info = null;
            };
        }

        private function removeWepon():void
        {
            if (this._weapon)
            {
                ObjectUtils.disposeObject(this._weapon);
                this._weapon = null;
            };
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
            ChatManager.Instance.model.addEventListener(ChatEvent.ADD_CHAT, this.__getChat);
            BagStore.instance.addEventListener(BagStore.OPEN_BAGSTORE, this.__openStoreHandler);
            BagStore.instance.addEventListener(BagStore.CLOSE_BAGSTORE, this.__closeStoreHandler);
            RoomManager.Instance.current.selfRoomPlayer.addEventListener(RoomPlayerEvent.IS_HOST_CHANGE, this.__updateButton);
            this._chatballview.addEventListener(Event.COMPLETE, this.onComplete);
            PlayerManager.Instance.addEventListener(PlayerManager.UPDATE_ROOMPLAYER, this.__updateRoomPlayer);
        }

        private function __updateRoomPlayer(_arg_1:Event):void
        {
            if (this._info == null)
            {
                return;
            };
            if (this._info.playerInfo.ID != PlayerManager.Instance.Self.ID)
            {
                SocketManager.Instance.out.sendItemEquip(this._info.playerInfo.ID);
            };
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
            if (this._hitArea)
            {
                this._hitArea.removeEventListener(MouseEvent.CLICK, this.__clickHandler);
            };
            RoomManager.Instance.current.removeEventListener(RoomEvent.STARTED_CHANGED, this.__startHandler);
            ChatManager.Instance.removeEventListener(ChatEvent.SHOW_FACE, this.__getFace);
            ChatManager.Instance.model.removeEventListener(ChatEvent.ADD_CHAT, this.__getChat);
            BagStore.instance.removeEventListener(BagStore.OPEN_BAGSTORE, this.__openStoreHandler);
            BagStore.instance.removeEventListener(BagStore.CLOSE_BAGSTORE, this.__closeStoreHandler);
            RoomManager.Instance.current.selfRoomPlayer.removeEventListener(RoomPlayerEvent.IS_HOST_CHANGE, this.__updateButton);
            if (this._info)
            {
                this._info.removeEventListener(RoomPlayerEvent.READY_CHANGE, this.__infoStateChange);
                this._info.removeEventListener(RoomPlayerEvent.IS_HOST_CHANGE, this.__infoStateChange);
                this._info.removeEventListener(RoomPlayerEvent.IS_START, this.__infoStateChange);
                this._info.playerInfo.removeEventListener(PlayerPropertyEvent.PROPERTY_CHANGE, this.__playerInfoChange);
                this._info.webSpeedInfo.removeEventListener(WebSpeedEvent.STATE_CHANE, this.__updateWebSpeed);
            };
            if (this._chatballview)
            {
                this._chatballview.removeEventListener(Event.COMPLETE, this.onComplete);
            };
            PlayerManager.Instance.removeEventListener(PlayerManager.UPDATE_ROOMPLAYER, this.__updateRoomPlayer);
        }

        private function __viewClickHandler(_arg_1:MouseEvent):void
        {
            SoundManager.instance.play("008");
            _arg_1.stopImmediatePropagation();
            PlayerTipManager.show(this._info.playerInfo, localToGlobal(new Point(0, 0)).y);
        }

        private function __addFriendHandler(_arg_1:MouseEvent):void
        {
            SoundManager.instance.play("008");
            _arg_1.stopImmediatePropagation();
            IMController.Instance.addFriend(this._info.playerInfo.NickName);
        }

        private function __kickOutHandler(_arg_1:MouseEvent):void
        {
            SoundManager.instance.play("008");
            _arg_1.stopImmediatePropagation();
            GameInSocketOut.sendGameRoomKick(this._place);
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
                        if (RoomManager.Instance.canCloseItem(this))
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

        private function onComplete(_arg_1:Event):void
        {
            if (this._chatballview.parent)
            {
                this._chatballview.parent.removeChild(this._chatballview);
            };
        }

        private function __infoStateChange(_arg_1:RoomPlayerEvent):void
        {
            this.updatePlayerState();
            this.updateButtons();
        }

        private function __playerInfoChange(_arg_1:PlayerPropertyEvent):void
        {
            this.updateInfoView();
            if (_arg_1.changedProperties["Pets"])
            {
                this.updatePet();
            };
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

        private function __getChat(_arg_1:ChatEvent):void
        {
            if (this._info == null)
            {
                return;
            };
            var _local_2:ChatData = ChatData(_arg_1.data).clone();
            if (((_local_2.senderID == this._info.playerInfo.ID) && ((_local_2.channel == ChatInputView.CURRENT) || (_local_2.channel == ChatInputView.TEAM))))
            {
                addChild(this._chatballview);
                _local_2.msg = Helpers.deCodeString(_local_2.msg);
                this._chatballview.setText(_local_2.msg, this._info.playerInfo.paopaoType);
            };
        }

        public function set info(_arg_1:RoomPlayer):void
        {
            var _local_2:GameInfo;
            if (this._info)
            {
                this._info.removeEventListener(RoomPlayerEvent.READY_CHANGE, this.__infoStateChange);
                this._info.removeEventListener(RoomPlayerEvent.IS_HOST_CHANGE, this.__infoStateChange);
                this._info.removeEventListener(RoomPlayerEvent.IS_START, this.__infoStateChange);
                this._info.playerInfo.removeEventListener(PlayerPropertyEvent.PROPERTY_CHANGE, this.__playerInfoChange);
                this._info.webSpeedInfo.removeEventListener(WebSpeedEvent.STATE_CHANE, this.__updateWebSpeed);
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
                if ((((!(_local_2 == null)) && (_local_2.hasNextMission)) && ((RoomManager.Instance.current.type == RoomInfo.DUNGEON_ROOM) || (RoomManager.Instance.current.type == RoomInfo.MULTI_DUNGEON))))
                {
                    _local_2.viewerToLiving(this._info.playerInfo.ID);
                };
                this._info.addEventListener(RoomPlayerEvent.READY_CHANGE, this.__infoStateChange);
                this._info.addEventListener(RoomPlayerEvent.IS_HOST_CHANGE, this.__infoStateChange);
                this._info.addEventListener(RoomPlayerEvent.IS_START, this.__infoStateChange);
                this._info.playerInfo.addEventListener(PlayerPropertyEvent.PROPERTY_CHANGE, this.__playerInfoChange);
                this._info.webSpeedInfo.addEventListener(WebSpeedEvent.STATE_CHANE, this.__updateWebSpeed);
                if (this._info.playerInfo.ID != PlayerManager.Instance.Self.ID)
                {
                };
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

        public function set place(_arg_1:int):void
        {
            this._place = _arg_1;
        }

        public function get place():int
        {
            return (this._place);
        }

        private function __updateWebSpeed(_arg_1:WebSpeedEvent):void
        {
        }

        private function updateView():void
        {
            this.updateBackground();
            this.updateInfoView();
            this.updateButtons();
            this.updatePlayerState();
            this.updatePet();
        }

        private function updateBackground():void
        {
            if (this._info)
            {
                if (RoomManager.Instance.current.isYellowBg())
                {
                    this._bg.setFrame(5);
                }
                else
                {
                    this._bg.setFrame(5);
                };
            }
            else
            {
                this._bg.setFrame(((this._opened) ? 1 : 2));
                if (this._chatballview.parent)
                {
                    this._chatballview.parent.removeChild(this._chatballview);
                };
            };
        }

        private function addWeapon(_arg_1:PlayerInfo):void
        {
            var _local_2:ItemTemplateInfo;
            var _local_3:String;
            var _local_4:Rectangle;
            if (_arg_1 == null)
            {
                return;
            };
            if (this._weapon)
            {
                ObjectUtils.disposeObject(this._weapon);
            };
            if (_arg_1.ID == PlayerManager.Instance.Self.ID)
            {
                _local_2 = ItemManager.Instance.getTemplateById(_arg_1.WeaponID);
            }
            else
            {
                if (((_arg_1.Bag.items.length > 0) && (!(_arg_1.Bag.items[14] == null))))
                {
                    _local_2 = ItemManager.Instance.getTemplateById(_arg_1.Bag.items[14].TemplateID);
                };
            };
            if (_local_2)
            {
                _local_3 = PathManager.solveGoodsPath(_local_2, _local_2.Pic, (this._info.playerInfo.Sex == 1), BaseLayer.SHOW, "A", "1", _local_2.Level);
                _local_4 = ComponentFactory.Instance.creatCustomObject("asset.ddtroom.WeaponSize");
                this._weapon = new BitmapLoaderProxy(_local_3, _local_4);
                this._weapon.scaleX = -1;
                this._weapon.mouseEnabled = false;
                this._weapon.mouseChildren = false;
                PositionUtils.setPos(this._weapon, "ddtroom.Weapon.Pos");
                addChild(this._weapon);
            };
        }

        private function updateInfoView():void
        {
            ObjectUtils.disposeObject(this._vipIcon);
            this._vipIcon = null;
            ObjectUtils.disposeObject(this._badge);
            this._badge = null;
            ObjectUtils.disposeObject(this._militaryIcon);
            this._militaryIcon = null;
            ObjectUtils.disposeObject(this._diamonIcon);
            this._diamonIcon = null;
            ObjectUtils.disposeObject(this._bunIcon);
            this._bunIcon = null;
            if (this._info)
            {
                if (this._chatballview.parent)
                {
                    this._chatballview.parent.removeChild(this._chatballview);
                };
                this.updateBigView();
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
                ObjectUtils.disposeObject(this._badge);
                this._badge = null;
                this._playerName.text = "";
                this._playerNameBg.visible = false;
                if (this._chatballview.parent)
                {
                    this._chatballview.parent.removeChild(this._chatballview);
                };
                if (this._hitArea)
                {
                    this._hitArea.tipData = null;
                };
                DisplayUtils.removeDisplay(this._vipName);
            };
        }

        private function updateBigView():void
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
                this._characterContainer.x = 125;
                this._characterContainer.y = -158;
                this._chracter.show(true, -1);
                this._chracter.setShowLight(true);
                this._chracter.scaleX = -1.25;
                this._chracter.scaleY = 1.25;
                this._chracter.playAnimation();
                addChildAt(this._characterContainer, 1);
            };
            if (this._levelIcon == null)
            {
                this._levelIcon = ComponentFactory.Instance.creatCustomObject("asset.ddtroom.playerItem.LevelIcon");
                addChild(this._levelIcon);
            };
            this._levelIcon.setInfo(this._info.playerInfo.Grade, this._info.playerInfo.Repute, this._info.playerInfo.WinCount, this._info.playerInfo.TotalCount, this._info.playerInfo.FightPower, this._info.playerInfo.Offer, true, false);
            if (this._info.isSelf)
            {
                this._levelIcon.allowClick();
            };
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
            if ((!(this._militaryIcon)))
            {
                this._militaryIcon = new MilitaryIcon(this._info.playerInfo);
                this._militaryIcon.setMilitary(this._info.playerInfo.MilitaryRankTotalScores);
                PositionUtils.setPos(this._militaryIcon, "rommPlayerItem.militaryrank.Icon.pos");
                this._iconContainer.addChild(this._militaryIcon);
            }
            else
            {
                this._militaryIcon.Info = this._info.playerInfo;
                this._militaryIcon.setMilitary(this._info.playerInfo.MilitaryRankTotalScores);
            };
            if (DiamondManager.instance.pfType > 0)
            {
                if (this._info.playerInfo.isYellowVip)
                {
                    if ((!(this._diamonIcon)))
                    {
                        this._diamonIcon = new DiamondIcon(0);
                        this._diamonIcon.x = -1;
                    };
                    this._diamonIcon.level = this._info.playerInfo.MemberDiamondLevel;
                    this._iconContainer.addChild(this._diamonIcon);
                }
                else
                {
                    ObjectUtils.disposeObject(this._diamonIcon);
                    this._diamonIcon = null;
                };
                if (DiamondManager.instance.model.pfdata.pfType == DiamondType.BLUE_DIAMOND)
                {
                    if ((!(this._bunIcon)))
                    {
                        this._bunIcon = new DiamondIcon(1);
                    };
                    this._bunIcon.level = this._info.playerInfo.Level3366;
                    this._iconContainer.addChild(this._bunIcon);
                }
                else
                {
                    ObjectUtils.disposeObject(this._bunIcon);
                    this._bunIcon = null;
                };
            }
            else
            {
                ObjectUtils.disposeObject(this._diamonIcon);
                this._diamonIcon = null;
                ObjectUtils.disposeObject(this._bunIcon);
                this._bunIcon = null;
            };
            this._playerName.text = this._info.playerInfo.NickName;
            if (this._playerName.text.length > 8)
            {
                this._playerName.text = (this._playerName.text.substr(0, 8) + ".");
            };
            addChild(this._playerName);
            this._playerNameBg.visible = true;
            if (this._info.playerInfo.IsVIP)
            {
                ObjectUtils.disposeObject(this._vipName);
                this._vipName = VipController.instance.getVipNameTxt(106, this._info.playerInfo.VIPtype);
                this._vipName.text = this._playerName.text;
                this._vipName.x = ((this._playerName.x + ((this._vipName.width - this._vipName.textWidth) / 2)) - 5);
                this._vipName.y = this._playerName.y;
                addChild(this._vipName);
            };
            PositionUtils.adaptNameStyle(this.info.playerInfo, this._playerName, this._vipName);
            if ((((this._info.isReady) || (this._info.isStarted)) || (((!(this._info.isSelf)) && (this._info.isHost)) && (this._info.isStarted))))
            {
                if ((!(this._readyMc)))
                {
                    this._readyMc = (ClassUtils.CreatInstance("asset.ddtroom.playerItem.ReadyMc") as MovieClip);
                };
                addChildAt(this._readyMc, 1);
                PositionUtils.setPos(this._readyMc, "asset.ddtroom.playerItem.ReadyMcPos");
                this._readyMc.visible = true;
            }
            else
            {
                if (((this._readyMc) && (this._readyMc.visible)))
                {
                    this._readyMc.visible = false;
                };
            };
            if (((this._info.playerInfo.ConsortiaID > 0) && (this._info.playerInfo.badgeID > 0)))
            {
                if (this._badge == null)
                {
                    this._badge = new Badge();
                    this._badge.buttonMode = true;
                    PositionUtils.setPos(this._badge, "asset.ddtroom.playerItem.badgePos");
                    this.addChild(this._badge);
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

        private function updatePlayerState():void
        {
            if (this._info)
            {
                if (((this._info.isReady) || (this._info.isStarted)))
                {
                    if ((!(this._readyMc)))
                    {
                        this._readyMc = (ClassUtils.CreatInstance("asset.ddtroom.playerItem.ReadyMc") as MovieClip);
                    };
                    PositionUtils.setPos(this._readyMc, "asset.ddtroom.playerItem.ReadyMcPos");
                    addChildAt(this._readyMc, 1);
                    this._readyMc.visible = true;
                }
                else
                {
                    if (((this._readyMc) && (this._readyMc.visible)))
                    {
                        this._readyMc.visible = false;
                    };
                };
                if (this._info.isHost)
                {
                    if ((!(this._hostPic)))
                    {
                        this._hostPic = ComponentFactory.Instance.creatBitmap("asset.ddtroom.playerItem.host");
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
                if (((this._hostPic) && (this._hostPic.visible)))
                {
                    this._hostPic.visible = false;
                };
                if (((this._readyMc) && (this._readyMc.visible)))
                {
                    this._readyMc.visible = false;
                };
            };
        }

        public function disposeCharacterContainer():void
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
        }

        public function dispose():void
        {
            this.removeEvents();
            this._bg.dispose();
            this._bg = null;
            if (this._hostPic)
            {
                if (this._hostPic.parent)
                {
                    this._hostPic.parent.removeChild(this._hostPic);
                };
                this._hostPic.bitmapData.dispose();
            };
            this._hostPic = null;
            if (this._playerNameBg)
            {
                ObjectUtils.disposeObject(this._playerNameBg);
            };
            this._playerNameBg = null;
            this._playerName.dispose();
            this._playerName = null;
            if (this._vipName)
            {
                ObjectUtils.disposeObject(this._vipName);
            };
            this._vipName = null;
            this._signal = null;
            this._signalExplain = null;
            if (this._readyMc)
            {
                ObjectUtils.disposeObject(this._readyMc);
                this._readyMc = null;
            };
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
            ObjectUtils.disposeObject(this._diamonIcon);
            this._diamonIcon = null;
            ObjectUtils.disposeObject(this._bunIcon);
            this._bunIcon = null;
            if (this._face)
            {
                this._face.dispose();
            };
            this._face = null;
            ObjectUtils.disposeObject(this._badge);
            this._badge = null;
            ObjectUtils.disposeObject(this._iconContainer);
            this._iconContainer = null;
            if (this._chatballview)
            {
                this._chatballview.dispose();
            };
            this._chatballview = null;
            this._info = null;
            ObjectUtils.disposeObject(this._petItem);
            this._petItem = null;
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

        public function get opened():Boolean
        {
            return (this._opened);
        }

        public function set opened(_arg_1:Boolean):void
        {
            this._opened = _arg_1;
            this.updateView();
        }


    }
}//package room.view

