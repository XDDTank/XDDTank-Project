// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//church.view.weddingRoom.WeddingRoomToolView

package church.view.weddingRoom
{
    import flash.display.Sprite;
    import com.pickgliss.ui.core.Disposeable;
    import church.controller.ChurchRoomController;
    import church.model.ChurchRoomModel;
    import flash.display.Bitmap;
    import com.pickgliss.ui.controls.BaseButton;
    import com.pickgliss.ui.controls.alert.BaseAlerFrame;
    import com.pickgliss.loader.BaseLoader;
    import church.view.churchFire.ChurchFireView;
    import church.view.weddingRoom.frame.WeddingRoomGiftFrameForGuest;
    import church.view.weddingRoom.frame.WeddingRoomConfigView;
    import church.view.weddingRoom.frame.WeddingRoomContinuationView;
    import church.view.weddingRoom.frame.WeddingRoomGuestListView;
    import church.view.invite.ChurchInviteController;
    import com.greensock.TweenLite;
    import com.pickgliss.ui.ComponentFactory;
    import ddt.manager.ChurchManager;
    import ddt.manager.PlayerManager;
    import flash.events.MouseEvent;
    import church.events.WeddingRoomEvent;
    import ddt.data.ChurchRoomInfo;
    import com.greensock.easing.Sine;
    import ddt.manager.SoundManager;
    import ddt.manager.LeavePageManager;
    import com.pickgliss.ui.AlertManager;
    import ddt.manager.LanguageMgr;
    import com.pickgliss.ui.LayerManager;
    import com.pickgliss.events.FrameEvent;
    import baglocked.BaglockedManager;
    import ddt.manager.SocketManager;
    import ddt.view.chat.ChatData;
    import ddt.view.chat.ChatInputView;
    import ddt.manager.ChatManager;
    import flash.events.Event;
    import com.pickgliss.utils.ObjectUtils;
    import ddt.manager.StateManager;
    import ddt.states.StateType;
    import com.pickgliss.loader.LoadResourceManager;
    import ddt.manager.PathManager;
    import com.pickgliss.utils.ClassUtils;

    public class WeddingRoomToolView extends Sprite implements Disposeable 
    {

        private static const LEAST_GIFT_MONEY:int = 100;

        private var _controller:ChurchRoomController;
        private var _model:ChurchRoomModel;
        private var _churchRoomControler:ChurchRoomController;
        private var _toolBg:Bitmap;
        private var _toolSwitchBg:BaseButton;
        private var _toolSwitch:Bitmap;
        private var _switchEnable:Boolean = true;
        private var _toolBtnRoomAdmin:BaseButton;
        private var _toolBtnInviteGuest:BaseButton;
        private var _toolBtnFire:BaseButton;
        private var _toolBtnFill:BaseButton;
        private var _toolBtnExit:BaseButton;
        private var _toolBtnBack:BaseButton;
        private var _alertExit:BaseAlerFrame;
        private var _alertStartWedding:BaseAlerFrame;
        private var _fireLoader:BaseLoader;
        private var _churchFireView:ChurchFireView;
        private var _toolAdminBg:Bitmap;
        private var _startWeddingTip:Bitmap;
        private var _startWeddingTip2:Bitmap;
        private var _toolBtnStartWedding:BaseButton;
        private var _toolBtnAdminInviteGuest:BaseButton;
        private var _toolBtnGuestList:BaseButton;
        private var _toolBtnContinuation:BaseButton;
        private var _toolBtnModify:BaseButton;
        private var _adminToolVisible:Boolean = true;
        private var _sendGifeToolVisible:Boolean = false;
        private var _weddingRoomGiftFrameViewForGuest:WeddingRoomGiftFrameForGuest;
        private var _weddingRoomConfigView:WeddingRoomConfigView;
        private var _weddingRoomContinuationView:WeddingRoomContinuationView;
        private var _weddingRoomGuestListView:WeddingRoomGuestListView;
        private var _churchInviteController:ChurchInviteController;
        private var _startTipTween:TweenLite;
        private var _switchTween:TweenLite;
        private var _sendGiftToolBg:Bitmap;
        public var _toolSendCashBtn:BaseButton;
        public var _toolSendCashBtnForGuest:BaseButton;
        private var _isplayerStartTipMovieState:int = 0;

        public function WeddingRoomToolView()
        {
            this.initialize();
        }

        public function get controller():ChurchRoomController
        {
            return (this._controller);
        }

        public function set controller(_arg_1:ChurchRoomController):void
        {
            this._controller = _arg_1;
        }

        public function set churchRoomModel(_arg_1:ChurchRoomModel):void
        {
            this._model = _arg_1;
        }

        public function set churchRoomControler(_arg_1:ChurchRoomController):void
        {
            this._churchRoomControler = _arg_1;
        }

        public function set inventBtnEnabled(_arg_1:Boolean):void
        {
            this._toolBtnInviteGuest.enable = _arg_1;
        }

        private function initialize():void
        {
            this.setView();
            this.setEvent();
        }

        private function setView():void
        {
            this.loadFire();
            this._toolBg = ComponentFactory.Instance.creat("asset.church.room.toolBgAsset");
            addChild(this._toolBg);
            this._toolSwitchBg = ComponentFactory.Instance.creat("church.room.toolSwitchBgAsset");
            addChild(this._toolSwitchBg);
            this._toolSwitch = ComponentFactory.Instance.creat("asset.church.room.toolSwitchAsset");
            addChild(this._toolSwitch);
            this._toolBtnFire = ComponentFactory.Instance.creat("church.room.toolBtnFireBtnAsset");
            addChild(this._toolBtnFire);
            this._toolBtnFill = ComponentFactory.Instance.creat("church.room.toolBtnFillBtnAsset");
            addChild(this._toolBtnFill);
            this._toolBtnExit = ComponentFactory.Instance.creat("church.room.toolBtnExitBtnAsset");
            addChild(this._toolBtnExit);
            this._toolBtnBack = ComponentFactory.Instance.creat("church.room.toolBtnBackBtnAsset");
            this._toolBtnBack.visible = false;
            addChild(this._toolBtnBack);
            if (ChurchManager.instance.isAdmin(PlayerManager.Instance.Self))
            {
                this.showAdminToolView();
            }
            else
            {
                this._toolBtnInviteGuest = ComponentFactory.Instance.creat("church.room.toolBtnInviteGuestBtnAsset");
                addChild(this._toolBtnInviteGuest);
                if ((!(ChurchManager.instance.isAdmin(PlayerManager.Instance.Self))))
                {
                    if (this._toolBtnInviteGuest)
                    {
                        this._toolBtnInviteGuest.enable = ChurchManager.instance.currentRoom.canInvite;
                    };
                };
            };
            this.showGiftToolView();
            this.GiftToolVisible = this._sendGifeToolVisible;
        }

        private function setEvent():void
        {
            this._toolSwitchBg.addEventListener(MouseEvent.CLICK, this.toolSwitch);
            this._toolBtnFire.addEventListener(MouseEvent.CLICK, this.onToolMenuClick);
            this._toolBtnFill.addEventListener(MouseEvent.CLICK, this.onToolMenuClick);
            this._toolBtnExit.addEventListener(MouseEvent.CLICK, this.onToolMenuClick);
            this._toolBtnBack.addEventListener(MouseEvent.CLICK, this.onToolMenuClick);
            this._toolSendCashBtn.addEventListener(MouseEvent.CLICK, this.onToolMenuClick);
            this._toolSendCashBtnForGuest.addEventListener(MouseEvent.CLICK, this.onToolMenuClick);
            if (ChurchManager.instance.isAdmin(PlayerManager.Instance.Self))
            {
                this._toolBtnGuestList.addEventListener(MouseEvent.CLICK, this.onToolMenuClick);
                this._toolBtnContinuation.addEventListener(MouseEvent.CLICK, this.onToolMenuClick);
                this._toolBtnModify.addEventListener(MouseEvent.CLICK, this.onToolMenuClick);
                this._toolBtnRoomAdmin.addEventListener(MouseEvent.CLICK, this.onToolMenuClick);
                this._toolBtnAdminInviteGuest.addEventListener(MouseEvent.CLICK, this.onToolMenuClick);
                this._toolBtnStartWedding.addEventListener(MouseEvent.CLICK, this.onToolMenuClick);
            }
            else
            {
                this._toolBtnInviteGuest.addEventListener(MouseEvent.CLICK, this.onToolMenuClick);
            };
            ChurchManager.instance.currentRoom.addEventListener(WeddingRoomEvent.WEDDING_STATUS_CHANGE, this.__weddingStatusChange);
            ChurchManager.instance.addEventListener(WeddingRoomEvent.SCENE_CHANGE, this.__updateBtn);
            ChurchManager.instance.addEventListener(WeddingRoomEvent.SCENE_CHANGE, this.__updateBtn);
        }

        public function resetView():void
        {
            if (ChurchManager.instance.currentScene)
            {
                if (ChurchManager.instance.isAdmin(PlayerManager.Instance.Self))
                {
                    this._toolBtnStartWedding.enable = false;
                    this._startWeddingTip.visible = false;
                    this._startWeddingTip2.visible = false;
                    if (this._startWeddingTip)
                    {
                        this._startWeddingTip.visible = false;
                    };
                    if (this._startWeddingTip2)
                    {
                        this._startWeddingTip2.visible = false;
                    };
                };
                this._toolBtnBack.visible = true;
                this._toolBtnExit.visible = false;
            }
            else
            {
                if (ChurchManager.instance.isAdmin(PlayerManager.Instance.Self))
                {
                    this._toolBtnStartWedding.enable = true;
                    this._startWeddingTip.visible = true;
                    this._startWeddingTip2.visible = true;
                    if (this._adminToolVisible)
                    {
                        if (this._startWeddingTip)
                        {
                            this._startWeddingTip.visible = true;
                        };
                        if (this._startWeddingTip2)
                        {
                            this._startWeddingTip2.visible = true;
                        };
                    }
                    else
                    {
                        if (this._startWeddingTip)
                        {
                            this._startWeddingTip.visible = false;
                        };
                        if (this._startWeddingTip2)
                        {
                            this._startWeddingTip2.visible = false;
                        };
                    };
                };
                this._toolBtnBack.visible = false;
                this._toolBtnExit.visible = true;
            };
        }

        private function __weddingStatusChange(_arg_1:WeddingRoomEvent):void
        {
            if (ChurchManager.instance.currentScene)
            {
                return;
            };
            if (this._startWeddingTip)
            {
                if (this._startWeddingTip.parent)
                {
                    this._startWeddingTip.parent.removeChild(this._startWeddingTip);
                };
            };
            if (this._startWeddingTip2)
            {
                if (this._startWeddingTip2.parent)
                {
                    this._startWeddingTip2.parent.removeChild(this._startWeddingTip2);
                };
            };
            this._startTipTween = null;
            var _local_2:String = ChurchManager.instance.currentRoom.status;
            if ((!(ChurchManager.instance.isAdmin(PlayerManager.Instance.Self))))
            {
                if (this._toolBtnInviteGuest)
                {
                    this._toolBtnInviteGuest.enable = ChurchManager.instance.currentRoom.canInvite;
                };
            };
            if (_local_2 == ChurchRoomInfo.WEDDING_ING)
            {
                if (this._toolBtnStartWedding)
                {
                    this._toolBtnStartWedding.enable = false;
                };
                if (this._toolBtnAdminInviteGuest)
                {
                    this._toolBtnAdminInviteGuest.enable = false;
                };
                if (this._toolBtnInviteGuest)
                {
                    this._toolBtnInviteGuest.enable = false;
                };
                if (this._toolBtnFire)
                {
                    this._toolBtnFire.enable = false;
                };
                if (((this._churchFireView) && (this._churchFireView.parent)))
                {
                    this._churchFireView.parent.removeChild(this._churchFireView);
                };
            }
            else
            {
                if (this._toolBtnStartWedding)
                {
                    this._toolBtnStartWedding.enable = true;
                };
                if (this._toolBtnAdminInviteGuest)
                {
                    this._toolBtnAdminInviteGuest.enable = true;
                };
                if (this._toolBtnInviteGuest)
                {
                    this._toolBtnInviteGuest.enable = ChurchManager.instance.currentRoom.canInvite;
                };
                if (this._toolBtnFire)
                {
                    this._toolBtnFire.enable = true;
                };
                if (this._toolBtnExit)
                {
                    this._toolBtnExit.enable = true;
                };
                if (this._toolBtnBack)
                {
                    this._toolBtnBack.enable = true;
                };
            };
        }

        private function __updateBtn(_arg_1:WeddingRoomEvent):void
        {
            if (this._churchInviteController)
            {
                this._churchInviteController.hide();
            };
            if (ChurchManager.instance.currentScene)
            {
                this._toolBtnBack.visible = false;
                this._toolBtnExit.visible = true;
            }
            else
            {
                this._toolBtnBack.visible = true;
                this._toolBtnExit.visible = false;
            };
        }

        private function showAdminToolView():void
        {
            this._toolAdminBg = ComponentFactory.Instance.creat("asset.church.room.toolAdminBgAsset");
            addChild(this._toolAdminBg);
            this._toolBtnStartWedding = ComponentFactory.Instance.creat("church.room.toolBtnStartWeddingBtnAsset");
            addChild(this._toolBtnStartWedding);
            this._toolBtnRoomAdmin = ComponentFactory.Instance.creat("church.room.toolBtnRoomAdminBtnAsset");
            addChild(this._toolBtnRoomAdmin);
            this._toolBtnGuestList = ComponentFactory.Instance.creat("church.room.toolBtnGuestListBtnAsset");
            addChild(this._toolBtnGuestList);
            this._toolBtnContinuation = ComponentFactory.Instance.creat("church.room.toolBtnContinuationBtnAsset");
            addChild(this._toolBtnContinuation);
            this._toolBtnAdminInviteGuest = ComponentFactory.Instance.creat("church.room.toolBtnAdminInviteGuestBtnAsset");
            addChild(this._toolBtnAdminInviteGuest);
            if ((!(ChurchManager.instance.isAdmin(PlayerManager.Instance.Self))))
            {
                if (this._toolBtnInviteGuest)
                {
                    this._toolBtnInviteGuest.enable = ChurchManager.instance.currentRoom.canInvite;
                };
            };
            this._toolBtnModify = ComponentFactory.Instance.creat("church.room.toolBtnModifyBtnAsset");
            addChild(this._toolBtnModify);
            if (PlayerManager.Instance.Self.ID != ChurchManager.instance.currentRoom.createID)
            {
                this._toolBtnModify.enable = false;
            };
            if ((!(this._startWeddingTip)))
            {
                this._startWeddingTip = ComponentFactory.Instance.creatBitmap("asset.church.room.startWeddingTipAsset");
            };
            addChild(this._startWeddingTip);
            if ((!(this._startWeddingTip2)))
            {
                this._startWeddingTip2 = ComponentFactory.Instance.creatBitmap("asset.church.room.startWeddingTip2Asset");
            };
            addChild(this._startWeddingTip2);
            this.playerStartTipMovie();
        }

        private function set adminToolVisible(_arg_1:Boolean):void
        {
            if (this._toolAdminBg)
            {
                this._toolAdminBg.visible = _arg_1;
            };
            if (this._toolBtnStartWedding)
            {
                this._toolBtnStartWedding.visible = _arg_1;
            };
            if (this._toolBtnGuestList)
            {
                this._toolBtnGuestList.visible = _arg_1;
            };
            if (this._toolBtnContinuation)
            {
                this._toolBtnContinuation.visible = _arg_1;
            };
            if (this._toolBtnAdminInviteGuest)
            {
                this._toolBtnAdminInviteGuest.visible = _arg_1;
            };
            if (this._toolBtnModify)
            {
                this._toolBtnModify.visible = _arg_1;
            };
            if (this._startWeddingTip)
            {
                this._startWeddingTip.visible = _arg_1;
            };
            if (this._startWeddingTip2)
            {
                this._startWeddingTip2.visible = _arg_1;
            };
            if (ChurchManager.instance.currentScene == true)
            {
                if (this._startWeddingTip)
                {
                    this._startWeddingTip.visible = false;
                };
                if (this._startWeddingTip2)
                {
                    this._startWeddingTip2.visible = false;
                };
            };
        }

        private function showGiftToolView():void
        {
            this._sendGiftToolBg = ComponentFactory.Instance.creat("asset.church.room.toolAdminBgAsset");
            this._sendGiftToolBg.width = 120;
            this._sendGiftToolBg.x = 60;
            addChild(this._sendGiftToolBg);
            this._toolSendCashBtn = ComponentFactory.Instance.creat("asset.church.room.adminToGuest");
            this._toolSendCashBtn.enable = false;
            addChild(this._toolSendCashBtn);
            this._toolSendCashBtn.visible = false;
            this._toolSendCashBtnForGuest = ComponentFactory.Instance.creat("church.room.toolBtnSendCashAsset");
            this.addChild(this._toolSendCashBtnForGuest);
            this._toolSendCashBtnForGuest.visible = false;
        }

        private function set GiftToolVisible(_arg_1:Boolean):void
        {
            if (this._sendGiftToolBg)
            {
                this._sendGiftToolBg.visible = _arg_1;
            };
            if ((!(_arg_1)))
            {
                this._toolSendCashBtn.visible = (this._toolSendCashBtnForGuest.visible = false);
            }
            else
            {
                if (this.isGuest())
                {
                    this._toolSendCashBtnForGuest.visible = true;
                    this._toolSendCashBtn.visible = false;
                }
                else
                {
                    this._toolSendCashBtnForGuest.visible = false;
                    this._toolSendCashBtn.visible = true;
                };
            };
        }

        private function playerStartTipMovie():void
        {
            if (this._isplayerStartTipMovieState == 1)
            {
                this._isplayerStartTipMovieState = 0;
                this._startTipTween = TweenLite.to(this._startWeddingTip2, 0.3, {
                    "y":(this._startWeddingTip2.y - 10),
                    "ease":Sine.easeInOut,
                    "onComplete":this.playerStartTipMovie
                });
            }
            else
            {
                this._isplayerStartTipMovieState = 1;
                this._startTipTween = TweenLite.to(this._startWeddingTip2, 0.3, {
                    "y":(this._startWeddingTip2.y + 10),
                    "ease":Sine.easeInOut,
                    "onComplete":this.playerStartTipMovie
                });
            };
        }

        private function isGuest():Boolean
        {
            var _local_1:Array = [ChurchManager.instance.currentRoom.groomName, ChurchManager.instance.currentRoom.brideName];
            var _local_2:int = _local_1.indexOf(PlayerManager.Instance.Self.NickName);
            return ((_local_2 >= 0) ? false : true);
        }

        private function onToolMenuClick(_arg_1:MouseEvent):void
        {
            switch (_arg_1.currentTarget)
            {
                case this._toolBtnFire:
                    if (this._toolBtnFire.enable == true)
                    {
                        SoundManager.instance.play("008");
                    };
                    this.openFireList();
                    return;
                case this._toolBtnFill:
                    LeavePageManager.leaveToFillPath();
                    return;
                case this._toolBtnBack:
                    if (this._toolBtnBack.enable == true)
                    {
                        SoundManager.instance.play("008");
                    };
                    this.exitRoom();
                    return;
                case this._toolBtnExit:
                    if (this._toolBtnExit.enable == true)
                    {
                        SoundManager.instance.play("008");
                    };
                    if ((!(this._alertExit)))
                    {
                        this._alertExit = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"), LanguageMgr.GetTranslation("church.weddingRoom.WeddingRoomControler.leaveRoom"), LanguageMgr.GetTranslation("ok"), LanguageMgr.GetTranslation("cancel"), false, false, false, LayerManager.ALPHA_BLOCKGOUND);
                        this._alertExit.addEventListener(FrameEvent.RESPONSE, this.exitResponse);
                    };
                    return;
                case this._toolBtnRoomAdmin:
                    SoundManager.instance.play("008");
                    this._sendGifeToolVisible = (this.GiftToolVisible = false);
                    this.adminToolVisible = (!(this._adminToolVisible));
                    this._adminToolVisible = (!(this._adminToolVisible));
                    return;
                case this._toolBtnModify:
                    SoundManager.instance.play("008");
                    this.openRoomConfig();
                    return;
                case this._toolBtnContinuation:
                    if (PlayerManager.Instance.Self.bagLocked)
                    {
                        BaglockedManager.Instance.show();
                        SoundManager.instance.play("008");
                        return;
                    };
                    SoundManager.instance.play("008");
                    this.openRoomContinuation();
                    return;
                case this._toolBtnGuestList:
                    SoundManager.instance.play("008");
                    this.openGuestList();
                    return;
                case this._toolBtnInviteGuest:
                case this._toolBtnAdminInviteGuest:
                    SoundManager.instance.play("008");
                    this.openInviteGuest();
                    return;
                case this._toolBtnStartWedding:
                    SoundManager.instance.play("008");
                    this.openStartWedding();
                    return;
                case this._toolSendCashBtn:
                    SoundManager.instance.play("008");
                    this.giftViewForGuest();
                    return;
                case this._toolSendCashBtnForGuest:
                    SoundManager.instance.play("008");
                    this.giftView();
            };
        }

        public function giftViewForGuest():void
        {
            if (PlayerManager.Instance.Self.bagLocked)
            {
                BaglockedManager.Instance.show();
                return;
            };
            SocketManager.Instance.out.requestRefund();
        }

        public function giftView():void
        {
            var _local_1:ChatData;
            if (PlayerManager.Instance.Self.bagLocked)
            {
                BaglockedManager.Instance.show();
                return;
            };
            if (PlayerManager.Instance.Self.Money < LEAST_GIFT_MONEY)
            {
                _local_1 = new ChatData();
                _local_1.channel = ChatInputView.SYS_NOTICE;
                _local_1.msg = LanguageMgr.GetTranslation("church.churchScene.SceneControler.startWedding.Money", LEAST_GIFT_MONEY);
                ChatManager.Instance.chat(_local_1);
                return;
            };
            if (this._weddingRoomGiftFrameViewForGuest)
            {
                if (this._weddingRoomGiftFrameViewForGuest.parent)
                {
                    this._weddingRoomGiftFrameViewForGuest.parent.removeChild(this._weddingRoomGiftFrameViewForGuest);
                };
                this._weddingRoomGiftFrameViewForGuest.removeEventListener(Event.CLOSE, this.closeRoomGift);
                this._weddingRoomGiftFrameViewForGuest.dispose();
                this._weddingRoomGiftFrameViewForGuest = null;
            }
            else
            {
                this._weddingRoomGiftFrameViewForGuest = ComponentFactory.Instance.creat("church.weddingRoom.frame.WeddingRoomGiftFrameViewForGuest");
                this._weddingRoomGiftFrameViewForGuest.addEventListener(Event.CLOSE, this.closeRoomGift);
                this._weddingRoomGiftFrameViewForGuest.controller = this._controller;
                this._weddingRoomGiftFrameViewForGuest.show();
            };
        }

        private function exitResponse(_arg_1:FrameEvent):void
        {
            SoundManager.instance.play("008");
            switch (_arg_1.responseCode)
            {
                case FrameEvent.SUBMIT_CLICK:
                case FrameEvent.ENTER_CLICK:
                    this.exitRoom();
                    break;
                case FrameEvent.CANCEL_CLICK:
                case FrameEvent.CLOSE_CLICK:
                case FrameEvent.ESC_CLICK:
                    if (this._alertExit)
                    {
                        if (this._alertExit.parent)
                        {
                            this._alertExit.parent.removeChild(this._alertExit);
                        };
                        this._alertExit.dispose();
                    };
                    this._alertExit = null;
                    break;
            };
            ObjectUtils.disposeObject(_arg_1.target);
        }

        private function exitRoom():void
        {
            if (((ChurchManager.instance.currentScene) && (ChurchManager.instance.currentRoom.status == ChurchRoomInfo.WEDDING_NONE)))
            {
                ChurchManager.instance.currentScene = false;
            }
            else
            {
                StateManager.setState(StateType.MAIN);
            };
        }

        private function toolSwitch(_arg_1:MouseEvent):void
        {
            var _local_2:int;
            SoundManager.instance.play("008");
            if (this._switchEnable)
            {
                this._switchTween = null;
                this._switchTween = TweenLite.to(this, 0.5, {
                    "x":(stage.stageWidth - 34),
                    "ease":Sine.easeInOut
                });
                this._switchEnable = false;
                if (this._adminToolVisible)
                {
                    this.adminToolVisible = false;
                };
            }
            else
            {
                this._switchTween = null;
                _local_2 = ((this.isGuest()) ? 0 : 41);
                this._switchTween = TweenLite.to(this, 0.5, {
                    "x":(stage.stageWidth - ((this.isGuest()) ? this.width : 274)),
                    "ease":Sine.easeInOut
                });
                this._switchEnable = true;
                if (this._adminToolVisible)
                {
                    this.adminToolVisible = true;
                };
            };
        }

        public function loadFire():void
        {
            this._fireLoader = LoadResourceManager.instance.createLoader(PathManager.solveCatharineSwf(), BaseLoader.MODULE_LOADER);
            LoadResourceManager.instance.startLoad(this._fireLoader);
        }

        private function get isFireLoaded():Boolean
        {
            var fireClass:Class;
            try
            {
                fireClass = (ClassUtils.uiSourceDomain.getDefinition("tank.church.fireAcect.FireItemAccect02") as Class);
                if (fireClass)
                {
                    return (true);
                };
                return (false);
            }
            catch(e:Error)
            {
                return (false);
            };
            return (false);
        }

        private function openFireList():void
        {
            this.closeRoomGuestList();
            this.closeInviteGuest();
            if ((!(this.isFireLoaded)))
            {
                AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"), LanguageMgr.GetTranslation("church.churchScene.SceneUI.switchVisibleFireList"), LanguageMgr.GetTranslation("ok"), LanguageMgr.GetTranslation("cancel"), true, false, false, LayerManager.ALPHA_BLOCKGOUND);
                return;
            };
            if ((!(this._churchFireView)))
            {
                this._churchFireView = ComponentFactory.Instance.creatCustomObject("church.churchFire.ChurchFireView", [this._controller, this._model]);
            };
            if (this._churchFireView.parent)
            {
                this._churchFireView.parent.removeChild(this._churchFireView);
            }
            else
            {
                LayerManager.Instance.addToLayer(this._churchFireView, LayerManager.GAME_TOP_LAYER);
            };
        }

        private function openRoomConfig():void
        {
            if (this._weddingRoomConfigView)
            {
                if (this._weddingRoomConfigView.parent)
                {
                    this._weddingRoomConfigView.parent.removeChild(this._weddingRoomConfigView);
                };
                this._weddingRoomConfigView.removeEventListener(Event.CLOSE, this.closeRoomConfig);
                this._weddingRoomConfigView.dispose();
                this._weddingRoomConfigView = null;
            }
            else
            {
                this._weddingRoomConfigView = ComponentFactory.Instance.creat("church.weddingRoom.frame.WeddingRoomConfigView");
                this._weddingRoomConfigView.addEventListener(Event.CLOSE, this.closeRoomConfig);
                this._weddingRoomConfigView.controller = this._controller;
                this._weddingRoomConfigView.show();
            };
        }

        private function openRoomContinuation():void
        {
            if (this._weddingRoomContinuationView)
            {
                if (this._weddingRoomContinuationView.parent)
                {
                    this._weddingRoomContinuationView.parent.removeChild(this._weddingRoomContinuationView);
                };
                this._weddingRoomContinuationView.removeEventListener(Event.CLOSE, this.closeRoomContinuation);
                this._weddingRoomContinuationView.dispose();
                this._weddingRoomContinuationView = null;
            }
            else
            {
                this._weddingRoomContinuationView = ComponentFactory.Instance.creat("church.weddingRoom.frame.WeddingRoomContinuationView");
                this._weddingRoomContinuationView.addEventListener(Event.CLOSE, this.closeRoomContinuation);
                this._weddingRoomContinuationView.controller = this._controller;
                this._weddingRoomContinuationView.show();
            };
        }

        private function openGuestList():void
        {
            this.closeFireList();
            this.closeInviteGuest();
            if (this._weddingRoomGuestListView)
            {
                if (this._weddingRoomGuestListView.parent)
                {
                    this._weddingRoomGuestListView.parent.removeChild(this._weddingRoomGuestListView);
                };
                this._weddingRoomGuestListView.removeEventListener(Event.CLOSE, this.closeRoomGuestList);
                this._weddingRoomGuestListView.dispose();
                this._weddingRoomGuestListView = null;
            }
            else
            {
                this._weddingRoomGuestListView = ComponentFactory.Instance.creatCustomObject("church.weddingRoom.frame.WeddingRoomGuestListView", [this._controller, this._model]);
                this._weddingRoomGuestListView.addEventListener(Event.CLOSE, this.closeRoomGuestList);
                this._weddingRoomGuestListView.show();
            };
        }

        private function openInviteGuest():void
        {
            this.closeFireList();
            this.closeRoomGuestList();
            if (this._churchInviteController == null)
            {
                this._churchInviteController = new ChurchInviteController();
            };
            if (this._churchInviteController.getView().parent)
            {
                this._churchInviteController.getView().parent.removeChild(this._churchInviteController.getView());
            }
            else
            {
                this._churchInviteController.refleshList(0);
                this._churchInviteController.showView();
            };
        }

        private function openStartWedding():void
        {
            if (this._toolBtnStartWedding.enable == true)
            {
                SoundManager.instance.play("008");
            };
            this._alertStartWedding = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("tank.view.task.TaskCatalogContentView.tip"), LanguageMgr.GetTranslation("are.you.sure.to.marry"), LanguageMgr.GetTranslation("ok"), LanguageMgr.GetTranslation("cancel"), true, false, false, LayerManager.ALPHA_BLOCKGOUND);
            this._alertStartWedding.addEventListener(FrameEvent.RESPONSE, this.startWeddingResponse);
        }

        private function startWeddingResponse(_arg_1:FrameEvent):void
        {
            SoundManager.instance.play("008");
            switch (_arg_1.responseCode)
            {
                case FrameEvent.SUBMIT_CLICK:
                case FrameEvent.ENTER_CLICK:
                    this._controller.startWedding();
                    this.closeStartWedding();
                    break;
                case FrameEvent.CANCEL_CLICK:
                case FrameEvent.CLOSE_CLICK:
                case FrameEvent.ESC_CLICK:
                    this.closeStartWedding();
                    break;
            };
            ObjectUtils.disposeObject(_arg_1.target);
        }

        private function closeStartWedding():void
        {
            if (this._alertStartWedding)
            {
                if (this._alertStartWedding.parent)
                {
                    this._alertStartWedding.parent.removeChild(this._alertStartWedding);
                };
                this._alertStartWedding.dispose();
            };
            this._alertStartWedding = null;
        }

        private function closeFireList():void
        {
            if (((this._churchFireView) && (this._churchFireView.parent)))
            {
                this._churchFireView.parent.removeChild(this._churchFireView);
            };
        }

        private function closeRoomGift(_arg_1:Event=null):void
        {
            if (this._weddingRoomGiftFrameViewForGuest)
            {
                this._weddingRoomGiftFrameViewForGuest.removeEventListener(Event.CLOSE, this.closeRoomGift);
                if (this._weddingRoomGiftFrameViewForGuest.parent)
                {
                    this._weddingRoomGiftFrameViewForGuest.parent.removeChild(this._weddingRoomGiftFrameViewForGuest);
                };
                this._weddingRoomGiftFrameViewForGuest.dispose();
            };
            this._weddingRoomGiftFrameViewForGuest = null;
        }

        private function closeRoomConfig(_arg_1:Event=null):void
        {
            if (this._weddingRoomConfigView)
            {
                this._weddingRoomConfigView.removeEventListener(Event.CLOSE, this.closeRoomConfig);
                if (this._weddingRoomConfigView.parent)
                {
                    this._weddingRoomConfigView.parent.removeChild(this._weddingRoomConfigView);
                };
                this._weddingRoomConfigView.dispose();
            };
            this._weddingRoomConfigView = null;
        }

        private function closeRoomContinuation(_arg_1:Event=null):void
        {
            if (this._weddingRoomContinuationView)
            {
                this._weddingRoomContinuationView.removeEventListener(Event.CLOSE, this.closeRoomContinuation);
                if (this._weddingRoomContinuationView.parent)
                {
                    this._weddingRoomContinuationView.parent.removeChild(this._weddingRoomContinuationView);
                };
                this._weddingRoomContinuationView.dispose();
            };
            this._weddingRoomContinuationView = null;
        }

        private function closeRoomGuestList(_arg_1:Event=null):void
        {
            if (this._weddingRoomGuestListView)
            {
                this._weddingRoomGuestListView.removeEventListener(Event.CLOSE, this.closeRoomGuestList);
                if (this._weddingRoomGuestListView.parent)
                {
                    this._weddingRoomGuestListView.parent.removeChild(this._weddingRoomGuestListView);
                };
                this._weddingRoomGuestListView.dispose();
            };
            this._weddingRoomGuestListView = null;
        }

        private function closeInviteGuest(_arg_1:Event=null):void
        {
            if ((((this._churchInviteController) && (this._churchInviteController.getView())) && (this._churchInviteController.getView().parent)))
            {
                this._churchInviteController.getView().parent.removeChild(this._churchInviteController.getView());
            };
        }

        private function removeView():void
        {
            if (this._toolBg)
            {
                if (this._toolBg.parent)
                {
                    this._toolBg.parent.removeChild(this._toolBg);
                };
                this._toolBg.bitmapData.dispose();
                this._toolBg.bitmapData = null;
            };
            this._toolBg = null;
            if (this._startWeddingTip2)
            {
                if (this._startWeddingTip2.parent)
                {
                    this._startWeddingTip2.parent.removeChild(this._startWeddingTip2);
                };
                this._startWeddingTip2.bitmapData.dispose();
                this._startWeddingTip2.bitmapData = null;
            };
            this._startWeddingTip2 = null;
            if (this._toolSwitchBg)
            {
                if (this._toolSwitchBg.parent)
                {
                    this._toolSwitchBg.parent.removeChild(this._toolSwitchBg);
                };
                this._toolSwitchBg.dispose();
            };
            this._toolSwitchBg = null;
            if (this._toolSwitch)
            {
                if (this._toolSwitch.parent)
                {
                    this._toolSwitch.parent.removeChild(this._toolSwitch);
                };
                this._toolSwitch.bitmapData.dispose();
                this._toolSwitch.bitmapData = null;
            };
            this._toolSwitch = null;
            if (this._toolAdminBg)
            {
                if (this._toolAdminBg.parent)
                {
                    this._toolAdminBg.parent.removeChild(this._toolAdminBg);
                };
                this._toolAdminBg.bitmapData.dispose();
                this._toolAdminBg.bitmapData = null;
            };
            this._toolAdminBg = null;
            if (this._startWeddingTip)
            {
                if (this._startWeddingTip.parent)
                {
                    this._startWeddingTip.parent.removeChild(this._startWeddingTip);
                };
                this._startWeddingTip.bitmapData.dispose();
                this._startWeddingTip.bitmapData = null;
            };
            this._startWeddingTip = null;
            if (this._toolBtnRoomAdmin)
            {
                if (this._toolBtnRoomAdmin.parent)
                {
                    this._toolBtnRoomAdmin.parent.removeChild(this._toolBtnRoomAdmin);
                };
                this._toolBtnRoomAdmin.dispose();
            };
            this._toolBtnRoomAdmin = null;
            if (this._toolBtnFire)
            {
                if (this._toolBtnFire.parent)
                {
                    this._toolBtnFire.parent.removeChild(this._toolBtnFire);
                };
                this._toolBtnFire.dispose();
            };
            this._toolBtnFire = null;
            if (this._toolBtnFill)
            {
                if (this._toolBtnFill.parent)
                {
                    this._toolBtnFill.parent.removeChild(this._toolBtnFill);
                };
                this._toolBtnFill.dispose();
            };
            this._toolBtnFill = null;
            if (this._toolBtnExit)
            {
                if (this._toolBtnExit.parent)
                {
                    this._toolBtnExit.parent.removeChild(this._toolBtnExit);
                };
                this._toolBtnExit.dispose();
            };
            this._toolBtnExit = null;
            if (this._toolBtnBack)
            {
                if (this._toolBtnBack.parent)
                {
                    this._toolBtnBack.parent.removeChild(this._toolBtnBack);
                };
                this._toolBtnBack.dispose();
            };
            this._toolBtnBack = null;
            if (this._toolBtnStartWedding)
            {
                if (this._toolBtnStartWedding.parent)
                {
                    this._toolBtnStartWedding.parent.removeChild(this._toolBtnStartWedding);
                };
                this._toolBtnStartWedding.dispose();
            };
            this._toolBtnStartWedding = null;
            if (this._toolBtnAdminInviteGuest)
            {
                if (this._toolBtnAdminInviteGuest.parent)
                {
                    this._toolBtnAdminInviteGuest.parent.removeChild(this._toolBtnAdminInviteGuest);
                };
                this._toolBtnAdminInviteGuest.dispose();
            };
            this._toolBtnAdminInviteGuest = null;
            if (this._toolBtnGuestList)
            {
                if (this._toolBtnGuestList.parent)
                {
                    this._toolBtnGuestList.parent.removeChild(this._toolBtnGuestList);
                };
                this._toolBtnGuestList.dispose();
            };
            this._toolBtnGuestList = null;
            if (this._toolBtnContinuation)
            {
                if (this._toolBtnContinuation.parent)
                {
                    this._toolBtnContinuation.parent.removeChild(this._toolBtnContinuation);
                };
                this._toolBtnContinuation.dispose();
            };
            this._toolBtnContinuation = null;
            if (this._toolBtnModify)
            {
                if (this._toolBtnModify.parent)
                {
                    this._toolBtnModify.parent.removeChild(this._toolBtnModify);
                };
                this._toolBtnModify.dispose();
            };
            this._toolBtnModify = null;
            if (this._alertExit)
            {
                if (this._alertExit.parent)
                {
                    this._alertExit.parent.removeChild(this._alertExit);
                };
                this._alertExit.dispose();
            };
            this._alertExit = null;
            this._fireLoader = null;
            if (this._churchFireView)
            {
                if (this._churchFireView.parent)
                {
                    this._churchFireView.parent.removeChild(this._churchFireView);
                };
                this._churchFireView.dispose();
            };
            this._churchFireView = null;
            if (this._weddingRoomGiftFrameViewForGuest)
            {
                if (this._weddingRoomGiftFrameViewForGuest.parent)
                {
                    this._weddingRoomGiftFrameViewForGuest.parent.removeChild(this._weddingRoomGiftFrameViewForGuest);
                };
                this._weddingRoomGiftFrameViewForGuest.dispose();
            };
            this._weddingRoomGiftFrameViewForGuest = null;
            if (this._weddingRoomConfigView)
            {
                if (this._weddingRoomConfigView.parent)
                {
                    this._weddingRoomConfigView.parent.removeChild(this._weddingRoomConfigView);
                };
                this._weddingRoomConfigView.dispose();
            };
            this._weddingRoomConfigView = null;
            if (this._weddingRoomContinuationView)
            {
                if (this._weddingRoomContinuationView.parent)
                {
                    this._weddingRoomContinuationView.parent.removeChild(this._weddingRoomContinuationView);
                };
                this._weddingRoomContinuationView.dispose();
            };
            this._weddingRoomContinuationView = null;
            if (this._weddingRoomGuestListView)
            {
                if (this._weddingRoomGuestListView.parent)
                {
                    this._weddingRoomGuestListView.parent.removeChild(this._weddingRoomGuestListView);
                };
                this._weddingRoomGuestListView.dispose();
            };
            this._weddingRoomGuestListView = null;
            if (this._toolBtnInviteGuest)
            {
                if (this._toolBtnInviteGuest.parent)
                {
                    this._toolBtnInviteGuest.parent.removeChild(this._toolBtnInviteGuest);
                };
                this._toolBtnInviteGuest.dispose();
            };
            this._toolBtnInviteGuest = null;
            if (this._alertStartWedding)
            {
                if (this._alertStartWedding.parent)
                {
                    this._alertStartWedding.parent.removeChild(this._alertStartWedding);
                };
                this._alertStartWedding.dispose();
            };
            this._alertStartWedding = null;
            if (this._sendGiftToolBg)
            {
                if (this._sendGiftToolBg.parent)
                {
                    this._sendGiftToolBg.parent.removeChild(this._sendGiftToolBg);
                };
                ObjectUtils.disposeObject(this._sendGiftToolBg);
            };
            this._sendGiftToolBg = null;
            if (this._toolSendCashBtn)
            {
                if (this._toolSendCashBtn.parent)
                {
                    this._toolSendCashBtn.parent.removeChild(this._toolSendCashBtn);
                };
                ObjectUtils.disposeObject(this._toolSendCashBtn);
            };
            this._toolSendCashBtn = null;
            if (this._toolSendCashBtnForGuest)
            {
                if (this._toolSendCashBtnForGuest.parent)
                {
                    this._toolSendCashBtnForGuest.parent.removeChild(this._toolSendCashBtnForGuest);
                };
                ObjectUtils.disposeObject(this._toolSendCashBtnForGuest);
            };
            this._toolSendCashBtnForGuest = null;
            if (this._churchInviteController)
            {
                this._churchInviteController.dispose();
            };
            this._churchInviteController = null;
            if (this._switchTween)
            {
                this._switchTween.kill();
            };
            this._switchTween = null;
            if (this._startTipTween)
            {
                this._startTipTween.kill();
            };
            this._startTipTween = null;
            if (parent)
            {
                parent.removeChild(this);
            };
        }

        private function removeEvent():void
        {
            ChurchManager.instance.currentRoom.removeEventListener(WeddingRoomEvent.WEDDING_STATUS_CHANGE, this.__weddingStatusChange);
            ChurchManager.instance.removeEventListener(WeddingRoomEvent.SCENE_CHANGE, this.__updateBtn);
            ChurchManager.instance.removeEventListener(WeddingRoomEvent.SCENE_CHANGE, this.__updateBtn);
            this._toolSwitchBg.removeEventListener(MouseEvent.CLICK, this.toolSwitch);
            this._toolBtnFire.removeEventListener(MouseEvent.CLICK, this.onToolMenuClick);
            this._toolBtnFill.removeEventListener(MouseEvent.CLICK, this.onToolMenuClick);
            this._toolBtnExit.removeEventListener(MouseEvent.CLICK, this.onToolMenuClick);
            this._toolSendCashBtn.removeEventListener(MouseEvent.CLICK, this.onToolMenuClick);
            this._toolSendCashBtnForGuest.removeEventListener(MouseEvent.CLICK, this.onToolMenuClick);
            if (this._toolBtnRoomAdmin)
            {
                this._toolBtnRoomAdmin.removeEventListener(MouseEvent.CLICK, this.onToolMenuClick);
            };
            if (this._toolBtnModify)
            {
                this._toolBtnModify.removeEventListener(MouseEvent.CLICK, this.onToolMenuClick);
            };
            if (this._toolBtnContinuation)
            {
                this._toolBtnContinuation.removeEventListener(MouseEvent.CLICK, this.onToolMenuClick);
            };
            if (this._toolBtnGuestList)
            {
                this._toolBtnGuestList.removeEventListener(MouseEvent.CLICK, this.onToolMenuClick);
            };
            if (this._toolBtnStartWedding)
            {
                this._toolBtnStartWedding.removeEventListener(MouseEvent.CLICK, this.onToolMenuClick);
            };
            if (this._toolBtnAdminInviteGuest)
            {
                this._toolBtnAdminInviteGuest.removeEventListener(MouseEvent.CLICK, this.onToolMenuClick);
            };
            if (this._weddingRoomGiftFrameViewForGuest)
            {
                this._weddingRoomGiftFrameViewForGuest.removeEventListener(Event.CLOSE, this.closeRoomGift);
            };
            if (this._weddingRoomConfigView)
            {
                this._weddingRoomConfigView.removeEventListener(Event.CLOSE, this.closeRoomConfig);
            };
            if (this._weddingRoomContinuationView)
            {
                this._weddingRoomContinuationView.removeEventListener(Event.CLOSE, this.closeRoomContinuation);
            };
            if (this._weddingRoomGuestListView)
            {
                this._weddingRoomGuestListView.removeEventListener(Event.CLOSE, this.closeRoomGuestList);
            };
            if (this._alertExit)
            {
                this._alertExit.removeEventListener(FrameEvent.RESPONSE, this.exitResponse);
            };
            if (this._alertStartWedding)
            {
                this._alertStartWedding.removeEventListener(FrameEvent.RESPONSE, this.startWeddingResponse);
            };
        }

        public function dispose():void
        {
            this.removeEvent();
            this.removeView();
        }


    }
}//package church.view.weddingRoom

