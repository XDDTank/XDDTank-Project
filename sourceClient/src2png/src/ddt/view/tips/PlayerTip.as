﻿// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//ddt.view.tips.PlayerTip

package ddt.view.tips
{
    import flash.display.Sprite;
    import com.pickgliss.ui.core.Disposeable;
    import com.pickgliss.ui.image.Scale9CornerImage;
    import com.pickgliss.ui.image.ScaleBitmapImage;
    import com.pickgliss.ui.controls.IconButton;
    import ddt.data.player.BasePlayer;
    import com.pickgliss.ui.controls.TextButton;
    import com.pickgliss.ui.controls.BaseButton;
    import com.pickgliss.ui.text.FilterFrameText;
    import com.pickgliss.ui.text.GradientText;
    import com.pickgliss.ui.controls.container.VBox;
    import flash.display.Bitmap;
    import ddt.view.common.VipLevelIcon;
    import im.IMFriendPhotoCell;
    import flash.utils.Timer;
    import com.pickgliss.ui.ComponentFactory;
    import ddt.utils.PositionUtils;
    import ddt.manager.LanguageMgr;
    import ddt.manager.PathManager;
    import flash.events.MouseEvent;
    import flash.events.TimerEvent;
    import flash.events.Event;
    import com.pickgliss.toplevel.StageReferance;
    import com.pickgliss.utils.ObjectUtils;
    import ddt.events.PlayerPropertyEvent;
    import ddt.manager.PlayerManager;
    import ddt.manager.StateManager;
    import ddt.states.StateType;
    import room.RoomManager;
    import com.pickgliss.ui.LayerManager;
    import flash.geom.Point;
    import vip.VipController;
    import com.pickgliss.utils.DisplayUtils;
    import ddt.manager.ConsortiaDutyManager;
    import ddt.data.ConsortiaDutyType;
    import consortion.ConsortionModelControl;
    import com.pickgliss.ui.controls.alert.BaseAlerFrame;
    import baglocked.BaglockedManager;
    import ddt.manager.SocketManager;
    import com.pickgliss.ui.AlertManager;
    import com.pickgliss.events.FrameEvent;
    import ddt.manager.MessageTipManager;
    import ddt.manager.ChurchManager;
    import ddt.manager.ChatManager;
    import bagAndInfo.info.PlayerInfoViewControl;
    import im.IMController;
    import flash.system.System;
    import ddt.manager.SoundManager;

    public class PlayerTip extends Sprite implements Disposeable 
    {

        public static const CHALLENGE:String = "challenge";
        public static const X_MARGINAL:int = 10;
        public static const Y_MARGINAL:int = 20;

        private var _bg:Scale9CornerImage;
        private var _line:ScaleBitmapImage;
        private var _lineI:ScaleBitmapImage;
        private var btnChallenge:IconButton;
        private var _chanllageEnable:Boolean = false;
        private var _info:BasePlayer;
        private var _btnAddFriend:IconButton;
        private var _btnCopyName:IconButton;
        private var _btnDemote:TextButton;
        private var _btnExpel:TextButton;
        private var _btnInvite:TextButton;
        private var _btnPromote:TextButton;
        private var _btnPrivateChat:IconButton;
        private var _btnPropose:BaseButton;
        private var _btnViewInfo:IconButton;
        private var _btnAcademy:IconButton;
        private var _One_one_chat:IconButton;
        private var _transferFriend:IconButton;
        private var _nameTxt:FilterFrameText;
        private var _vipName:GradientText;
        private var _clubTxt:FilterFrameText;
        private var _iconBtnsContainer:VBox;
        private var _bottomBtnsContainer:Sprite;
        private var _bottomBg:Bitmap;
        private var _vipIcon:VipLevelIcon;
        private var _photo:IMFriendPhotoCell;
        private var _friendGroup:FriendGroupTip;
        private var _timer:Timer;
        private var _friendOver:Boolean = false;

        public function PlayerTip()
        {
            this.init();
            this.initEvent();
        }

        private function init():void
        {
            this._bottomBtnsContainer = new Sprite();
            this._bg = ComponentFactory.Instance.creatComponentByStylename("playerTip.BG");
            this._line = ComponentFactory.Instance.creatComponentByStylename("playerTip.line");
            this._lineI = ComponentFactory.Instance.creatComponentByStylename("playerTip.line");
            this._lineI.visible = false;
            this._nameTxt = ComponentFactory.Instance.creatComponentByStylename("playerTip.NameTxt");
            this._vipIcon = ComponentFactory.Instance.creatCustomObject("playerTip.VipIcon");
            this._clubTxt = ComponentFactory.Instance.creatComponentByStylename("playerTip.ClubTxt");
            this._iconBtnsContainer = ComponentFactory.Instance.creatComponentByStylename("playerTip.ItemContainer");
            this.btnChallenge = ComponentFactory.Instance.creatComponentByStylename("playerTip.Challenge");
            this._btnAddFriend = ComponentFactory.Instance.creatComponentByStylename("playerTip.ItemMakeFriend");
            this._btnPrivateChat = ComponentFactory.Instance.creatComponentByStylename("playerTip.ItemPrivateChat");
            this._btnCopyName = ComponentFactory.Instance.creatComponentByStylename("playerTip.ItemCopyName");
            this._btnViewInfo = ComponentFactory.Instance.creatComponentByStylename("playerTip.ItemInfo");
            this._btnAcademy = ComponentFactory.Instance.creatComponentByStylename("playerTip.academyIcon");
            this._One_one_chat = ComponentFactory.Instance.creatComponentByStylename("playerTip.OneOnOneChat");
            this._transferFriend = ComponentFactory.Instance.creatComponentByStylename("PlayerTip.transferFriend");
            this._btnPropose = ComponentFactory.Instance.creatComponentByStylename("playerTip.ProposeBtn");
            this._bottomBg = ComponentFactory.Instance.creatBitmap("asset.playerTip.PlayerTipBottomBg");
            this._btnInvite = ComponentFactory.Instance.creatComponentByStylename("playerTip.PlayerTipInviteBtn");
            this._btnPromote = ComponentFactory.Instance.creatComponentByStylename("playerTip.PlayerTipPromoteBtn");
            this._btnDemote = ComponentFactory.Instance.creatComponentByStylename("playerTip.PlayerTipDemoteBtn");
            this._btnExpel = ComponentFactory.Instance.creatComponentByStylename("playerTip.PlayerTipExpelBtn");
            PositionUtils.setPos(this._bottomBtnsContainer, "playerTip.BottomPos");
            this._btnInvite.text = LanguageMgr.GetTranslation("tank.menu.Invite");
            this._btnPromote.text = LanguageMgr.GetTranslation("tank.menu.Up");
            this._btnDemote.text = LanguageMgr.GetTranslation("tank.menu.Down");
            this._btnExpel.text = LanguageMgr.GetTranslation("tank.menu.fire");
            graphics.beginFill(0, 0);
            graphics.drawRect(-3000, -3000, 6000, 6000);
            graphics.endFill();
            addChild(this._bg);
            addChild(this._line);
            addChild(this._lineI);
            addChild(this._clubTxt);
            this._iconBtnsContainer.addChild(this.btnChallenge);
            this._iconBtnsContainer.addChild(this._btnAddFriend);
            this._iconBtnsContainer.addChild(this._btnPrivateChat);
            this._iconBtnsContainer.addChild(this._btnCopyName);
            this._iconBtnsContainer.addChild(this._btnViewInfo);
            this._iconBtnsContainer.addChild(this._One_one_chat);
            this._iconBtnsContainer.addChild(this._transferFriend);
            addChild(this._iconBtnsContainer);
            if (PathManager.solveChurchEnable())
            {
                addChild(this._btnPropose);
            };
            this._bottomBtnsContainer.addChild(this._btnInvite);
            this._bottomBtnsContainer.addChild(this._btnPromote);
            this._bottomBtnsContainer.addChild(this._btnDemote);
            this._bottomBtnsContainer.addChild(this._btnExpel);
            addChild(this._bottomBtnsContainer);
            this._friendGroup = new FriendGroupTip();
            PositionUtils.setPos(this._friendGroup, "groupTip.pos");
            this._timer = new Timer(200);
        }

        private function initEvent():void
        {
            addEventListener(MouseEvent.CLICK, this.__mouseClick);
            this.btnChallenge.addEventListener(MouseEvent.CLICK, this.__buttonsClick);
            this._btnPropose.addEventListener(MouseEvent.CLICK, this.__buttonsClick);
            this._btnInvite.addEventListener(MouseEvent.CLICK, this.__buttonsClick);
            this._btnPromote.addEventListener(MouseEvent.CLICK, this.__buttonsClick);
            this._btnDemote.addEventListener(MouseEvent.CLICK, this.__buttonsClick);
            this._btnExpel.addEventListener(MouseEvent.CLICK, this.__buttonsClick);
            this._btnAddFriend.addEventListener(MouseEvent.CLICK, this.__buttonsClick);
            this._btnPrivateChat.addEventListener(MouseEvent.CLICK, this.__buttonsClick);
            this._btnCopyName.addEventListener(MouseEvent.CLICK, this.__buttonsClick);
            this._btnViewInfo.addEventListener(MouseEvent.CLICK, this.__buttonsClick);
            this._One_one_chat.addEventListener(MouseEvent.CLICK, this.__buttonsClick);
            this._transferFriend.addEventListener(MouseEvent.MOUSE_OVER, this.__overHandler);
            this._transferFriend.addEventListener(MouseEvent.MOUSE_OUT, this.__outHandler);
            this._friendGroup.addEventListener(MouseEvent.MOUSE_OVER, this.__friendOverHandler);
            this._friendGroup.addEventListener(MouseEvent.MOUSE_OUT, this.__friendOutHandler);
            this._friendGroup.addEventListener(MouseEvent.CLICK, this.__friendClickHandler);
            this._timer.addEventListener(TimerEvent.TIMER, this.__timerHandler);
            this._friendGroup.addEventListener(Event.ADDED_TO_STAGE, this.__groupAddToStage);
        }

        private function removeEvent():void
        {
            removeEventListener(MouseEvent.CLICK, this.__mouseClick);
            this.btnChallenge.removeEventListener(MouseEvent.CLICK, this.__buttonsClick);
            this._btnPropose.removeEventListener(MouseEvent.CLICK, this.__buttonsClick);
            this._btnInvite.removeEventListener(MouseEvent.CLICK, this.__buttonsClick);
            this._btnPromote.removeEventListener(MouseEvent.CLICK, this.__buttonsClick);
            this._btnDemote.removeEventListener(MouseEvent.CLICK, this.__buttonsClick);
            this._btnExpel.removeEventListener(MouseEvent.CLICK, this.__buttonsClick);
            this._btnAddFriend.removeEventListener(MouseEvent.CLICK, this.__buttonsClick);
            this._btnPrivateChat.removeEventListener(MouseEvent.CLICK, this.__buttonsClick);
            this._btnCopyName.removeEventListener(MouseEvent.CLICK, this.__buttonsClick);
            this._btnViewInfo.removeEventListener(MouseEvent.CLICK, this.__buttonsClick);
            this._One_one_chat.removeEventListener(MouseEvent.CLICK, this.__buttonsClick);
            this._transferFriend.removeEventListener(MouseEvent.MOUSE_OVER, this.__overHandler);
            this._transferFriend.removeEventListener(MouseEvent.MOUSE_OUT, this.__outHandler);
            this._friendGroup.removeEventListener(MouseEvent.MOUSE_OVER, this.__friendOverHandler);
            this._friendGroup.removeEventListener(MouseEvent.MOUSE_OUT, this.__friendOutHandler);
            this._friendGroup.removeEventListener(MouseEvent.CLICK, this.__friendClickHandler);
            this._timer.removeEventListener(TimerEvent.TIMER, this.__timerHandler);
            this._friendGroup.removeEventListener(Event.ADDED_TO_STAGE, this.__groupAddToStage);
        }

        protected function __groupAddToStage(_arg_1:Event):void
        {
            PositionUtils.setPos(this._friendGroup, "groupTip.pos");
            if (((this.y + 211) + this._friendGroup.height) > StageReferance.stageHeight)
            {
                this._friendGroup.y = ((StageReferance.stageHeight - this._friendGroup.height) - this.y);
            };
        }

        protected function __friendClickHandler(_arg_1:MouseEvent):void
        {
            removeChild(this._friendGroup);
            this._timer.stop();
            this.hide();
        }

        protected function __friendOverHandler(_arg_1:MouseEvent):void
        {
            this._friendOver = true;
        }

        protected function __friendOutHandler(_arg_1:MouseEvent):void
        {
            this._friendOver = false;
        }

        protected function __timerHandler(_arg_1:TimerEvent):void
        {
            if ((!(this._friendOver)))
            {
                removeChild(this._friendGroup);
                this._timer.stop();
            };
        }

        protected function __overHandler(_arg_1:MouseEvent):void
        {
            this._friendGroup.update(this._info.NickName);
            addChild(this._friendGroup);
            this._timer.stop();
        }

        protected function __outHandler(_arg_1:MouseEvent):void
        {
            this._timer.reset();
            this._timer.start();
        }

        public function dispose():void
        {
            this.removeEvent();
            ObjectUtils.disposeObject(this._bg);
            this._bg = null;
            ObjectUtils.disposeObject(this._line);
            this._line = null;
            ObjectUtils.disposeObject(this._lineI);
            this._lineI = null;
            ObjectUtils.disposeObject(this.btnChallenge);
            this.btnChallenge = null;
            ObjectUtils.disposeObject(this._btnAddFriend);
            this._btnAddFriend = null;
            ObjectUtils.disposeObject(this._btnCopyName);
            this._btnCopyName = null;
            ObjectUtils.disposeObject(this._btnDemote);
            this._btnDemote = null;
            ObjectUtils.disposeObject(this._btnExpel);
            this._btnExpel = null;
            ObjectUtils.disposeObject(this._btnInvite);
            this._btnInvite = null;
            ObjectUtils.disposeObject(this._btnPromote);
            this._btnPromote = null;
            ObjectUtils.disposeObject(this._btnPrivateChat);
            this._btnPrivateChat = null;
            ObjectUtils.disposeObject(this._btnPropose);
            this._btnPropose = null;
            ObjectUtils.disposeObject(this._btnViewInfo);
            this._btnViewInfo = null;
            ObjectUtils.disposeObject(this._btnAcademy);
            this._btnAcademy = null;
            ObjectUtils.disposeObject(this._One_one_chat);
            this._One_one_chat = null;
            ObjectUtils.disposeObject(this._transferFriend);
            this._transferFriend = null;
            ObjectUtils.disposeObject(this._vipName);
            this._vipName = null;
            ObjectUtils.disposeObject(this._clubTxt);
            this._clubTxt = null;
            ObjectUtils.disposeObject(this._bottomBtnsContainer);
            this._bottomBtnsContainer = null;
            ObjectUtils.disposeObject(this._bottomBg);
            this._bottomBg = null;
            ObjectUtils.disposeObject(this._vipIcon);
            this._vipIcon = null;
            ObjectUtils.disposeObject(this._photo);
            this._photo = null;
            ObjectUtils.disposeObject(this._friendGroup);
            this._friendGroup = null;
            ObjectUtils.disposeObject(this._iconBtnsContainer);
            this._iconBtnsContainer = null;
            this._timer.stop();
            this._timer = null;
            this._info = null;
            if (parent)
            {
                parent.removeChild(this);
            };
        }

        public function hide():void
        {
            if (parent)
            {
                parent.removeChild(this);
            };
        }

        public function get info():BasePlayer
        {
            return (this._info);
        }

        public function set playerInfo(_arg_1:BasePlayer):void
        {
            if (this._info)
            {
                this._info.removeEventListener(PlayerPropertyEvent.PROPERTY_CHANGE, this.__onPropChange);
            };
            this._info = _arg_1;
            this._info.addEventListener(PlayerPropertyEvent.PROPERTY_CHANGE, this.__onPropChange);
            this.update();
        }

        public function proposeEnable(_arg_1:Boolean):void
        {
            this._btnPropose.enable = _arg_1;
        }

        public function setSelfDisable(_arg_1:Boolean):void
        {
            if (_arg_1)
            {
                this._btnPrivateChat.enable = (this._btnAddFriend.enable = (this._btnPropose.enable = (this.btnChallenge.enable = false)));
                this._btnPrivateChat.alpha = (this._btnAddFriend.alpha = (this._btnPropose.alpha = (this.btnChallenge.alpha = 0.7)));
            }
            else
            {
                this._btnPrivateChat.enable = (this._btnAddFriend.enable = (this._btnPropose.enable = (this.btnChallenge.enable = true)));
                this._btnPrivateChat.alpha = (this._btnAddFriend.alpha = (this._btnPropose.alpha = (this.btnChallenge.alpha = 1)));
            };
        }

        private function checkShowPresent():Boolean
        {
            if (PlayerManager.Instance.Self.Grade < 16)
            {
                return (true);
            };
            if (((((StateManager.isInFight) || (StateManager.currentStateType == StateType.AUCTION)) || (StateManager.currentStateType == StateType.SHOP)) || (StateManager.currentStateType == StateType.FIGHT_LIB_GAMEVIEW)))
            {
                return (true);
            };
            if ((!(StateManager.isExitRoom(StateManager.currentStateType))))
            {
                if ((((RoomManager.Instance.findRoomPlayer(PlayerManager.Instance.Self.ID).isReady) || (RoomManager.Instance.findRoomPlayer(PlayerManager.Instance.Self.ID).isViewer)) || (RoomManager.Instance.current.started)))
                {
                    return (true);
                };
            };
            return (false);
        }

        public function show(_arg_1:int):void
        {
            LayerManager.Instance.addToLayer(this, LayerManager.GAME_DYNAMIC_LAYER);
            var _local_2:Point = new Point(StageReferance.stage.mouseX, StageReferance.stage.mouseY);
            x = (_local_2.x - this._bg.width);
            y = ((_arg_1 - this._bg.height) - ((this._bottomBtnsContainer.visible) ? this._bottomBg.height : 0));
            if (x < X_MARGINAL)
            {
                x = X_MARGINAL;
            };
            if (y < Y_MARGINAL)
            {
                y = Y_MARGINAL;
            };
            if (this._bottomBtnsContainer.visible)
            {
                this._lineI.visible = true;
                this._lineI.y = 200;
                this._bg.height = 240;
            }
            else
            {
                this._lineI.visible = false;
                this._bg.height = 203;
            };
            this._btnPropose.enable = (((!(PlayerManager.Instance.Self.IsMarried)) && (!(this._info.IsMarried))) && (!(PlayerManager.Instance.Self.Sex == this._info.Sex)));
        }

        public function update():void
        {
            var _local_1:BasePlayer;
            if (this._info)
            {
                this._nameTxt.text = this._info.NickName;
                if (this._info.ID == PlayerManager.Instance.Self.ID)
                {
                    _local_1 = PlayerManager.Instance.Self;
                }
                else
                {
                    _local_1 = this._info;
                };
                if (_local_1.IsVIP)
                {
                    ObjectUtils.disposeObject(this._vipName);
                    this._vipName = VipController.instance.getVipNameTxt(138, _local_1.VIPtype);
                    this._vipName.x = this._nameTxt.x;
                    this._vipName.y = this._nameTxt.y;
                    this._vipName.text = this._nameTxt.text;
                    addChild(this._vipName);
                    DisplayUtils.removeDisplay(this._nameTxt);
                }
                else
                {
                    addChild(this._nameTxt);
                    DisplayUtils.removeDisplay(this._vipName);
                };
                if (((_local_1.ID == PlayerManager.Instance.Self.ID) || (_local_1.IsVIP)))
                {
                    this._vipIcon.setInfo(_local_1);
                    if (((_local_1.IsVIP) || (PlayerManager.Instance.Self.IsVIP)))
                    {
                        this._vipIcon.filters = null;
                    }
                    else
                    {
                        this._vipIcon.filters = ComponentFactory.Instance.creatFilters("grayFilter");
                    };
                    addChild(this._vipIcon);
                }
                else
                {
                    if (contains(this._vipIcon))
                    {
                        removeChild(this._vipIcon);
                    };
                };
                this._clubTxt.text = (LanguageMgr.GetTranslation("tank.menu.ClubName") + ((_local_1.ConsortiaName) ? _local_1.ConsortiaName : ""));
                if (this._clubTxt.text.length > 9)
                {
                    this._clubTxt.text = (this._clubTxt.text.substr(0, 4) + "...");
                };
            }
            else
            {
                this._nameTxt.text = (this._vipName.text = (this._clubTxt.text = ""));
            };
            if ((((_local_1.ID == PlayerManager.Instance.Self.ID) || (_local_1.Grade < 5)) || (PlayerManager.Instance.Self.Grade < 5)))
            {
                this._One_one_chat.enable = false;
                this._One_one_chat.alpha = 0.7;
            }
            else
            {
                this._One_one_chat.enable = true;
                this._One_one_chat.alpha = 1;
            };
            if (_local_1.ID == PlayerManager.Instance.Self.ID)
            {
                this.btnChallenge.enable = false;
            }
            else
            {
                this.btnChallenge.enable = ((StateManager.currentStateType == StateType.MAIN) ? true : false);
                if (this.btnChallenge.enable)
                {
                    this.btnChallenge.enable = (PlayerManager.Instance.Self.Grade > 12);
                };
                if ((!(this.btnChallenge.enable)))
                {
                    this.btnChallenge.alpha = 0.7;
                }
                else
                {
                    this.btnChallenge.alpha = 1;
                };
            };
            if (((PlayerManager.Instance.hasInFriendList(this._info.ID)) && (!(this._info.ID == PlayerManager.Instance.Self.ID))))
            {
                this._transferFriend.enable = true;
                this._transferFriend.alpha = 1;
            }
            else
            {
                this._transferFriend.enable = false;
                this._transferFriend.alpha = 0.7;
            };
            if ((((_local_1) && (_local_1.DutyLevel > PlayerManager.Instance.Self.DutyLevel)) && (!(_local_1.ID == PlayerManager.Instance.Self.ID))))
            {
                if (((!(_local_1.ConsortiaID == 0)) && (_local_1.ConsortiaID == PlayerManager.Instance.Self.ConsortiaID)))
                {
                    this._btnExpel.enable = ConsortiaDutyManager.GetRight(PlayerManager.Instance.Self.Right, ConsortiaDutyType._6_Expel);
                    this._btnExpel.visible = true;
                    this._btnPromote.visible = (((ConsortiaDutyManager.GetRight(PlayerManager.Instance.Self.Right, ConsortiaDutyType._12_UpGrade)) && (!(_local_1.DutyLevel == 2))) && (ConsortionModelControl.Instance.model.ViceChairmanConsortiaMemberList.length < 3));
                    this._btnDemote.visible = ((ConsortiaDutyManager.GetRight(PlayerManager.Instance.Self.Right, ConsortiaDutyType._12_UpGrade)) && (!(_local_1.DutyLevel == 3)));
                    this._btnInvite.visible = false;
                }
                else
                {
                    this._btnPromote.visible = false;
                    this._btnDemote.visible = false;
                    this._btnExpel.visible = false;
                };
                this._bottomBtnsContainer.visible = ((((this._btnExpel.visible) || (this._btnInvite.visible)) || (this._btnPromote.visible)) || (this._btnDemote.visible));
            }
            else
            {
                this._btnPromote.visible = false;
                this._btnDemote.visible = false;
                this._btnExpel.visible = false;
                this._bottomBtnsContainer.visible = false;
                if (((((_local_1.ConsortiaID == 0) && (!(PlayerManager.Instance.Self.ConsortiaID == 0))) && (_local_1.ConsortiaName == "")) && (!(_local_1.ID == PlayerManager.Instance.Self.ID))))
                {
                    this._btnInvite.visible = (((ConsortiaDutyManager.GetRight(PlayerManager.Instance.Self.Right, ConsortiaDutyType._2_Invite)) && (_local_1.ConsortiaID == 0)) && (!(_local_1.playerState.StateID == 0)));
                    this._bottomBtnsContainer.visible = this._btnInvite.visible;
                };
            };
            if (PlayerManager.isShowPHP)
            {
                if ((!(this._photo)))
                {
                    this._photo = new IMFriendPhotoCell();
                    PositionUtils.setPos(this._photo, "playerTip.PhotoPos");
                    addChild(this._photo);
                };
                this._photo.userID = String(_local_1.LoginName);
            };
        }

        private function __buttonsClick(_arg_1:MouseEvent):void
        {
            var _local_2:BaseAlerFrame;
            if (this._info)
            {
                switch (_arg_1.currentTarget)
                {
                    case this._btnPromote:
                        if (PlayerManager.Instance.Self.bagLocked)
                        {
                            BaglockedManager.Instance.show();
                            return;
                        };
                        SocketManager.Instance.out.sendConsortiaMemberGrade(this._info.ID, true);
                        return;
                    case this._btnDemote:
                        if (PlayerManager.Instance.Self.bagLocked)
                        {
                            BaglockedManager.Instance.show();
                            return;
                        };
                        SocketManager.Instance.out.sendConsortiaMemberGrade(this._info.ID, false);
                        return;
                    case this._btnExpel:
                        if (PlayerManager.Instance.Self.bagLocked)
                        {
                            BaglockedManager.Instance.show();
                            return;
                        };
                        _local_2 = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("tank.consortia.myconsortia.frame.DeleteMemberFrame.titleText"), LanguageMgr.GetTranslation("tank.menu.fireConfirm", this._info.NickName), LanguageMgr.GetTranslation("ok"), LanguageMgr.GetTranslation("cancel"), false, true, false, LayerManager.ALPHA_BLOCKGOUND);
                        _local_2.addEventListener(FrameEvent.RESPONSE, this.__frameEventHandler);
                        return;
                    case this._btnInvite:
                        if (PlayerManager.Instance.Self.bagLocked)
                        {
                            BaglockedManager.Instance.show();
                            return;
                        };
                        if (this._info.Grade < 15)
                        {
                            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.consortion.playerTip.notInvite"));
                        }
                        else
                        {
                            SocketManager.Instance.out.sendConsortiaInvate(this._info.NickName);
                        };
                        return;
                    case this._btnPropose:
                        ChurchManager.instance.sendValidateMarry(this._info);
                        return;
                    case this.btnChallenge:
                        if (this._info.Grade < 13)
                        {
                            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.roomlist.cantBeChallenged"));
                        }
                        else
                        {
                            if (PlayerManager.Instance.checkExpedition())
                            {
                                MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("singledungeon.expedition.doing"));
                            }
                            else
                            {
                                dispatchEvent(new Event(CHALLENGE));
                            };
                        };
                        return;
                    case this._btnPrivateChat:
                        this.hide();
                        ChatManager.Instance.privateChatTo(this._info.NickName, this._info.ID);
                        return;
                    case this._btnViewInfo:
                        this.hide();
                        PlayerInfoViewControl.viewByID(this._info.ID);
                        PlayerInfoViewControl.isOpenFromBag = false;
                        return;
                    case this._btnAddFriend:
                        this.hide();
                        IMController.Instance.addFriend(this._info.NickName);
                        return;
                    case this._btnCopyName:
                        System.setClipboard(this._info.NickName);
                        return;
                    case this._One_one_chat:
                        this.hide();
                        IMController.Instance.alertPrivateFrame(this._info.ID);
                        return;
                };
            };
        }

        private function __frameEventHandler(_arg_1:FrameEvent):void
        {
            SoundManager.instance.play("008");
            var _local_2:BaseAlerFrame = (_arg_1.currentTarget as BaseAlerFrame);
            switch (_arg_1.responseCode)
            {
                case FrameEvent.SUBMIT_CLICK:
                case FrameEvent.ENTER_CLICK:
                    SocketManager.Instance.out.sendConsortiaOut(this._info.ID);
                    break;
            };
            _local_2.dispose();
            _local_2 = null;
        }

        private function __mouseClick(_arg_1:Event):void
        {
            this.hide();
            SoundManager.instance.play("008");
            _arg_1.stopImmediatePropagation();
        }

        private function __onPropChange(_arg_1:PlayerPropertyEvent):void
        {
            if (_arg_1.changedProperties["DutyLevel"])
            {
                this._btnPromote.enable = (!(this._info.DutyLevel == 2));
                this._btnDemote.enable = (!(this._info.DutyLevel == 5));
                this._btnExpel.enable = ConsortiaDutyManager.GetRight(PlayerManager.Instance.Self.Right, ConsortiaDutyType._6_Expel);
            };
        }

        private function __sendBandChat(_arg_1:MouseEvent):void
        {
            SocketManager.Instance.out.sendForbidSpeak(this._info.ID, true);
        }

        private function __sendNoBandChat(_arg_1:MouseEvent):void
        {
            SocketManager.Instance.out.sendForbidSpeak(this._info.ID, false);
        }

        private function ok():void
        {
            SocketManager.Instance.out.sendConsortiaOut(this._info.ID);
        }


    }
}//package ddt.view.tips
