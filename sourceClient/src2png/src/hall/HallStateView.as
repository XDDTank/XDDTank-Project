// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//hall.HallStateView

package hall
{
    import ddt.states.BaseStateView;
    import com.pickgliss.ui.controls.container.VBox;
    import com.pickgliss.ui.controls.ScrollPanel;
    import com.pickgliss.ui.controls.alert.BaseAlerFrame;
    import flash.display.MovieClip;
    import com.pickgliss.ui.controls.BaseButton;
    import flash.geom.Point;
    import road7th.utils.MovieClipWrapper;
    import flash.display.Sprite;
    import LimitAward.ConostionGoldAwardButton;
    import quest.ClientDownloadFrame;
    import com.pickgliss.ui.controls.SimpleBitmapButton;
    import ddt.view.bossbox.SmallBoxButton;
    import ddt.events.TimeEvents;
    import trainer.view.NewHandContainer;
    import trainer.data.ArrowType;
    import flash.events.Event;
    import farm.FarmModelController;
    import ddt.manager.PlayerManager;
    import ddt.states.StateType;
    import com.pickgliss.toplevel.StageReferance;
    import flash.events.MouseEvent;
    import flash.events.KeyboardEvent;
    import ddt.manager.SocketManager;
    import ddt.manager.KeyboardShortcutsManager;
    import room.RoomManager;
    import ddt.view.BackgoundView;
    import com.pickgliss.loader.LoadResourceManager;
    import ddt.manager.PathManager;
    import ddt.manager.BallManager;
    import com.pickgliss.loader.BaseLoader;
    import ddt.manager.LoadBombManager;
    import ddt.manager.SavePointManager;
    import ddt.manager.TaskManager;
    import ddt.manager.TaskDirectorManager;
    import ddt.data.TaskDirectorType;
    import SingleDungeon.SingleDungeonManager;
    import ddt.manager.StateManager;
    import com.pickgliss.loader.QueueLoader;
    import com.pickgliss.utils.ClassUtils;
    import com.pickgliss.ui.ComponentFactory;
    import ddt.manager.LanguageMgr;
    import ddt.loader.StartupResourceLoader;
    import ddt.loader.LoaderCreate;
    import ddt.manager.SoundManager;
    import ddt.events.CrazyTankSocketEvent;
    import ddt.events.TaskEvent;
    import ddt.view.MainToolBar;
    import ddt.manager.ChatManager;
    import ddt.view.chat.ChatOutputView;
    import ddt.view.DailyButtunBar;
    import com.pickgliss.manager.CacheSysManager;
    import ddt.constants.CacheConsts;
    import store.StrengthDataManager;
    import im.IMController;
    import ddt.manager.SharedManager;
    import church.view.weddingRoomList.DivorcePromptFrame;
    import socialContact.friendBirthday.FriendBirthdayManager;
    import ddt.manager.EdictumManager;
    import activity.ActivityController;
    import activity.data.ActivityInfo;
    import ddt.events.PlayerEvent;
    import liveness.DailyReceiveManager;
    import ddt.manager.TimeManager;
    import weekend.WeekendEvent;
    import ddt.manager.TimerOpenManager;
    import ddt.manager.PetInfoManager;
    import CapabilityNoctice.CapabilityNocticeManager;
    import ddt.manager.BossBoxManager;
    import com.pickgliss.utils.ObjectUtils;
    import ddt.manager.MessageTipManager;
    import mainbutton.MainButton;
    import mainbutton.MainButtnController;
    import __AS3__.vec.Vector;
    import liveness.LivenessBubbleManager;
    import packagePurchaseBox.PackagePurchaseBoxController;
    import ddt.utils.PositionUtils;
    import ddt.manager.ShopManager;
    import packagePurchaseBox.view.PackagePurchaseBoxFrame;
    import activity.ActivityEvent;
    import turnplate.TurnPlateController;
    import ddt.events.LivenessEvent;
    import weekend.WeekendManager;
    import fightRobot.FightRobotFrame;
    import liveness.LivenessFrameView;
    import vip.VipController;
    import fightToolBox.FightToolBoxController;
    import com.pickgliss.loader.LoaderEvent;
    import ddt.manager.DialogManager;
    import flash.utils.setTimeout;
    import com.pickgliss.action.FunctionAction;
    import shop.view.ShopRechargeEquipServer;
    import shop.view.ShopRechargeEquipAlert;
    import ddt.data.goods.InventoryItemInfo;
    import road7th.comm.PackageIn;
    import com.pickgliss.ui.LayerManager;
    import com.pickgliss.ui.DialogManagerBase;
    import ddt.manager.VoteManager;
    import ddt.data.player.SelfInfo;
    import com.pickgliss.ui.AlertManager;
    import com.pickgliss.events.FrameEvent;
    import ddt.bagStore.BagStore;
    import ddt.manager.ServerConfigManager;
    import auctionHouse.controller.AuctionHouseManager;
    import auctionHouse.controller.AuctionHouseController;
    import ddt.data.UIModuleTypes;
    import com.pickgliss.ui.ComponentSetting;
    import ddt.manager.ChurchManager;
    import church.controller.ChurchRoomListController;
    import consortion.consortionsence.ConsortionManager;
    import consortion.ConsortionModelControl;
    import roomList.pvpRoomList.RoomListController;
    import roomList.pveRoomList.DungeonListController;
    import flash.net.URLVariables;
    import com.pickgliss.utils.MD5;
    import com.pickgliss.loader.RequestLoader;
    import flash.utils.clearTimeout;
    import ddt.manager.GameInSocketOut;
    import update.UpdateDescFrame;
    import com.pickgliss.loader.LoaderSavingManager;
    import ddt.manager.LeavePageManager;
    import ddt.manager.GradeExaltClewManager;
    import update.UpdateController;
    import game.view.stage.StageCurtain;
    import com.pickgliss.ui.ShowTipManager;
    import platformapi.tencent.DiamondManager;
    import platformapi.tencent.DiamondType;

    public class HallStateView extends BaseStateView 
    {

        public static const VIP_LEFT_DAY_TO_COMFIRM:int = 3;
        public static const VIP_LEFT_DAY_FIRST_PROMPT:int = 7;
        public static var SoundIILoaded:Boolean = false;
        public static var SoundILoaded:Boolean = false;
        private static var _firstLoadTimes:Boolean = true;
        private static var _firstLoadDefaultBomb:Boolean = true;

        private var _mainPanelContent:VBox;
        private var _mainBtnPanel:ScrollPanel;
        private var _isIMController:Boolean;
        private var _renewal:BaseAlerFrame;
        private var _isAddFrameComplete:Boolean = false;
        private var _vipIcon:MovieClip;
        private var _activityIcon:MovieClip;
        private var _goSignBtn:MovieClip;
        private var _awardBtn:MovieClip;
        private var _angelblessIcon:MovieClip;
        private var _fightBtn:MovieClip;
        private var _packagePurchaseBtn:MovieClip;
        private var _consortionCampaignBtn:MovieClip;
        private var _firstChargeBtn:MovieClip;
        private var _turnPlateBtn:MovieClip;
        private var _fightRobotBtn:MovieClip;
        private var _weekendBtn:MovieClip;
        private var _auctionButton:BaseButton;
        private var _churchButton:BaseButton;
        private var _consortiaButton:BaseButton;
        private var _dungeonButton:BaseButton;
        private var _tofflistButton:BaseButton;
        private var _roomListButton:BaseButton;
        private var _shopButton:BaseButton;
        private var _storeButton:BaseButton;
        private var _farmButton:BaseButton;
        private var _hallBG:MovieClip;
        private var _hallFatigueIconPoint:Point;
        private var buildingMovie:MovieClipWrapper;
        private var buildingMovieI:MovieClipWrapper;
        private var buildingMovieII:MovieClipWrapper;
        private var buildingMovieIII:MovieClipWrapper;
        private var _buildingMask:Sprite;
        private var _firstFlag:Boolean = true;
        private var _dailyReceiveIcon:MovieClip;
        private var _consortionAwardBtn:ConostionGoldAwardButton;
        private var _clientDownloadFrame:ClientDownloadFrame;
        private var _showDownloadClient:Boolean;
        private var _livenessDialogTimeout:uint;
        private var _webGiftBox:SimpleBitmapButton;
        private var _diamondNewHandBtn:SimpleBitmapButton;
        private var _diamondBtn:SimpleBitmapButton;
        private var _intimateFriend:SimpleBitmapButton;
        private var _timerBox:SmallBoxButton;
        private var _idleTime:int = 0;
        private var btnList:Array = new Array();
        private var _isFirst:Boolean;


        private function addpurchasepackageButtonList(_arg_1:TimeEvents):void
        {
            this.addButtonList();
        }

        private function __screenActive(_arg_1:Event):void
        {
            this._idleTime = 0;
            NewHandContainer.Instance.clearArrowByID(ArrowType.CLICK_LIVENESS);
        }

        private function __secondsCheck(_arg_1:TimeEvents):void
        {
            FarmModelController.instance.showFeildGain();
            this._idleTime++;
            if (((this._idleTime == 120) && (PlayerManager.Instance.Self.Grade >= 13)))
            {
                NewHandContainer.Instance.showArrow(ArrowType.CLICK_LIVENESS, -90, "trainer.posClickLiveness", "", "", this);
            };
        }

        override public function getType():String
        {
            return (StateType.MAIN);
        }

        override public function getBackType():String
        {
            return (StateType.MAIN);
        }

        override public function enter(_arg_1:BaseStateView, _arg_2:Object=null):void
        {
            super.enter(_arg_1, _arg_2);
            StageReferance.stage.addEventListener(MouseEvent.MOUSE_DOWN, this.__screenActive);
            StageReferance.stage.addEventListener(MouseEvent.MOUSE_UP, this.__screenActive);
            StageReferance.stage.addEventListener(KeyboardEvent.KEY_DOWN, this.__screenActive);
            StageReferance.stage.addEventListener(KeyboardEvent.KEY_UP, this.__screenActive);
            SocketManager.Instance.out.SendexitConsortion();
            KeyboardShortcutsManager.Instance.setup();
            if ((!(RoomManager.Instance.findLoginRoom)))
            {
                SocketManager.Instance.out.sendSceneLogin(1);
            };
            RoomManager.Instance.findLoginRoom = false;
            BackgoundView.Instance.show();
            if (_firstLoadDefaultBomb)
            {
                LoadResourceManager.instance.creatAndStartLoad(PathManager.solveBlastOut(BallManager.DEFAULT_BOMB_ID), BaseLoader.MODULE_LOADER);
                LoadResourceManager.instance.creatAndStartLoad(PathManager.solveBullet(BallManager.DEFAULT_BOMB_ID), BaseLoader.MODULE_LOADER);
                LoadBombManager.Instance.loadSpecialBomb();
                _firstLoadDefaultBomb = false;
            };
            this.initView();
            if ((!(SavePointManager.Instance.savePoints[1])))
            {
                this.showDialog(11);
                TaskManager.instance.moduleLoad(true, this.taskLoadComplete);
            };
            this._firstFlag = false;
            this.checkDiamond();
        }

        override public function showDirect():void
        {
            TaskDirectorManager.instance.showDirector(TaskDirectorType.MAIN);
        }

        private function taskLoadComplete():void
        {
            SingleDungeonManager.Instance.loadModule(this.singleDungeonLoadComplete, null, true);
        }

        private function singleDungeonLoadComplete():void
        {
            StateManager.createStateAsync(StateType.SINGLEDUNGEON, this.singleDungeonResComplete, true);
        }

        private function singleDungeonResComplete(_arg_1:BaseStateView=null):void
        {
        }

        private function sethallBg(_arg_1:Boolean):void
        {
            if (_arg_1)
            {
                this._hallBG.play();
            }
            else
            {
                this._hallBG.stop();
            };
            this._hallBG.visible = _arg_1;
        }

        private function initHall():void
        {
            var _local_10:QueueLoader;
            if (this._hallBG)
            {
                return;
            };
            this._hallBG = (ClassUtils.CreatInstance("asset.hall.bgView") as MovieClip);
            this._auctionButton = ComponentFactory.Instance.creatComponentByStylename("hall.auctionButton");
            this._churchButton = ComponentFactory.Instance.creatComponentByStylename("hall.churchButton");
            this._consortiaButton = ComponentFactory.Instance.creatComponentByStylename("hall.consortiaButton");
            this._dungeonButton = ComponentFactory.Instance.creatComponentByStylename("hall.dungeonButton");
            this._tofflistButton = ComponentFactory.Instance.creatComponentByStylename("hall.tofflistButton");
            this._roomListButton = ComponentFactory.Instance.creatComponentByStylename("hall.roomListButton");
            this._shopButton = ComponentFactory.Instance.creatComponentByStylename("hall.shopButton");
            this._storeButton = ComponentFactory.Instance.creatComponentByStylename("hall.storeButton");
            this._farmButton = ComponentFactory.Instance.creatComponentByStylename("hall.farmButton");
            addChild(this._hallBG);
            this._hallBG.addChild(this._auctionButton);
            this._hallBG.addChild(this._churchButton);
            this._hallBG.addChild(this._consortiaButton);
            this._hallBG.addChild(this._dungeonButton);
            this._hallBG.addChild(this._tofflistButton);
            this._hallBG.addChild(this._roomListButton);
            this._hallBG.addChild(this._shopButton);
            this._hallBG.addChild(this._storeButton);
            this._hallBG.addChild(this._farmButton);
            this._auctionButton.visible = false;
            this._churchButton.visible = false;
            this._consortiaButton.visible = false;
            this._dungeonButton.visible = false;
            this._tofflistButton.visible = false;
            this._roomListButton.visible = false;
            this._shopButton.visible = false;
            this._storeButton.visible = false;
            this._farmButton.visible = false;
            this._auctionButton.displacement = false;
            this._churchButton.displacement = false;
            this._consortiaButton.displacement = false;
            this._dungeonButton.displacement = false;
            this._tofflistButton.displacement = false;
            this._roomListButton.displacement = false;
            this._shopButton.displacement = false;
            this._storeButton.displacement = false;
            this._farmButton.displacement = false;
            this._auctionButton.addEventListener(MouseEvent.CLICK, this.__btnClick);
            this._churchButton.addEventListener(MouseEvent.CLICK, this.__btnClick);
            this._consortiaButton.addEventListener(MouseEvent.CLICK, this.__btnClick);
            this._dungeonButton.addEventListener(MouseEvent.CLICK, this.__btnClick);
            this._tofflistButton.addEventListener(MouseEvent.CLICK, this.__btnClick);
            this._roomListButton.addEventListener(MouseEvent.CLICK, this.__btnClick);
            this._shopButton.addEventListener(MouseEvent.CLICK, this.__btnClick);
            this._storeButton.addEventListener(MouseEvent.CLICK, this.__btnClick);
            this._farmButton.addEventListener(MouseEvent.CLICK, this.__btnClick);
            var _local_1:Object = new Object();
            _local_1["title"] = LanguageMgr.GetTranslation("ddt.hall.build.auctiontitle");
            _local_1["content"] = LanguageMgr.GetTranslation("ddt.HallStateView.auction");
            this._auctionButton.tipData = _local_1;
            var _local_2:Object = new Object();
            _local_2["title"] = LanguageMgr.GetTranslation("ddt.hall.build.roomtitle");
            _local_2["content"] = LanguageMgr.GetTranslation("ddt.HallStateView.game");
            this._roomListButton.tipData = _local_2;
            var _local_3:Object = new Object();
            _local_3["title"] = LanguageMgr.GetTranslation("ddt.hall.build.churchtitle");
            _local_3["content"] = LanguageMgr.GetTranslation("ddt.HallStateView.church");
            this._churchButton.tipData = _local_3;
            var _local_4:Object = new Object();
            _local_4["title"] = LanguageMgr.GetTranslation("ddt.hall.build.framtitle");
            _local_4["content"] = LanguageMgr.GetTranslation("ddt.HallStateView.farm");
            this._farmButton.tipData = _local_4;
            var _local_5:Object = new Object();
            _local_5["title"] = LanguageMgr.GetTranslation("ddt.hall.build.constriontitle");
            _local_5["content"] = LanguageMgr.GetTranslation("ddt.HallStateView.consortion");
            this._consortiaButton.tipData = _local_5;
            var _local_6:Object = new Object();
            _local_6["title"] = LanguageMgr.GetTranslation("ddt.hall.build.dungeontitle");
            _local_6["content"] = LanguageMgr.GetTranslation("ddt.HallStateView.Dungeon");
            this._dungeonButton.tipData = _local_6;
            var _local_7:Object = new Object();
            _local_7["title"] = LanguageMgr.GetTranslation("ddt.hall.build.storetitle");
            _local_7["content"] = LanguageMgr.GetTranslation("ddt.HallStateView.store");
            this._storeButton.tipData = _local_7;
            var _local_8:Object = new Object();
            _local_8["title"] = LanguageMgr.GetTranslation("ddt.hall.build.shoptitle");
            _local_8["content"] = LanguageMgr.GetTranslation("ddt.HallStateView.Shop");
            this._shopButton.tipData = _local_8;
            var _local_9:Object = new Object();
            _local_9["title"] = LanguageMgr.GetTranslation("ddt.hall.build.tofflisttitle");
            _local_9["content"] = LanguageMgr.GetTranslation("ddt.HallStateView.toffist");
            this._tofflistButton.tipData = _local_9;
            StartupResourceLoader.Instance.finishLoadingProgress();
            if (SavePointManager.Instance.savePoints[3])
            {
                StartupResourceLoader.Instance.addNotStartupNeededResource();
            };
            if ((!(SoundILoaded)))
            {
                _local_10 = new QueueLoader();
                _local_10.addLoader(LoaderCreate.Instance.createAudioILoader());
                _local_10.addLoader(LoaderCreate.Instance.createAudioIILoader());
                _local_10.addEventListener(Event.COMPLETE, this.__onAudioLoadComplete);
                _local_10.start();
            };
        }

        private function initView():void
        {
            SoundManager.instance.playMusic("062", true, false);
            SocketManager.Instance.addEventListener(CrazyTankSocketEvent.SHOW_DIALOG, this.__getDialogFromServer);
            TaskManager.instance.addEventListener(TaskEvent.BUILDING_REFLASH, this.setBuildState);
            this.initHall();
            this.sethallBg(true);
            this.setBuildState();
            MainToolBar.Instance.show();
            MainToolBar.Instance.state = StateType.MAIN;
            MainToolBar.Instance.btnOpen();
            MainToolBar.Instance.enabled = true;
            MainToolBar.Instance.setRoomStartState2(true);
            if ((!(this._isAddFrameComplete)))
            {
                TaskManager.instance.checkHighLight();
            };
            MainToolBar.Instance.updateReturnBtn(MainToolBar.ENTER_HALL);
            MainToolBar.Instance.ExitBtnVisible = true;
            ChatManager.Instance.output.channel = ChatOutputView.CHAT_OUPUT_CURRENT;
            ChatManager.Instance.state = ChatManager.CHAT_HALL_STATE;
            ChatManager.Instance.view.bg = false;
            ChatManager.Instance.view.visible = true;
            ChatManager.Instance.chatDisabled = false;
            addChild(ChatManager.Instance.view);
            DailyButtunBar.Insance.show();
            CacheSysManager.unlock(CacheConsts.ALERT_IN_MARRY);
            this.checkShowVote();
            CacheSysManager.unlock(CacheConsts.ALERT_IN_FIGHT);
            CacheSysManager.getInstance().release(CacheConsts.ALERT_IN_FIGHT, 1200);
            this.checkShowVipAlert_New();
            PlayerManager.Instance.addEventListener(PlayerManager.VIP_STATE_CHANGE, this.__isOpenBtn);
            this.checkShowStoreFromShop();
            StrengthDataManager.instance.setup();
            if (((!(this._isIMController)) && (PathManager.CommunityExist())))
            {
                this._isIMController = true;
                IMController.Instance.createConsortiaLoader();
            };
            if (SharedManager.Instance.divorceBoolean)
            {
                DivorcePromptFrame.Instance.show();
            };
            TaskManager.instance.addEventListener(TaskEvent.TASK_FRAME_HIDE, this.__taskFrameHide);
            this.loadWeakGuild();
            TaskManager.instance.checkNewHandTask();
            if ((!(this._isAddFrameComplete)))
            {
                this.addFrame();
            };
            CacheSysManager.getInstance().singleRelease(CacheConsts.ALERT_IN_HALL);
            FriendBirthdayManager.Instance.findFriendBirthday();
            EdictumManager.Instance.showEdictum();
            if ((!(this._mainBtnPanel)))
            {
                this._mainBtnPanel = ComponentFactory.Instance.creat("ddt.view.mainbtnpanel");
                this._mainBtnPanel.y = (DailyButtunBar.Insance.height + 20);
            };
            addChild(this._mainBtnPanel);
            if ((!(this._mainPanelContent)))
            {
                this._mainPanelContent = new VBox();
                this._mainPanelContent.strictSize = 75;
                this._mainPanelContent.height = this._mainBtnPanel.height;
            };
            var _local_1:ActivityInfo = ActivityController.instance.checkHasFirstCharge();
            if (_local_1)
            {
                ActivityController.instance.sendAskForActiviLog(_local_1);
                PlayerManager.Instance.Self.addEventListener(PlayerEvent.MONEY_CHARGE, this.__moneyChargeHandle);
            };
            this._mainBtnPanel.setView(this._mainPanelContent);
            this._mainBtnPanel.vUnitIncrement = 56;
            this.addButtonList();
            this._mainBtnPanel.invalidateViewport();
            DailyReceiveManager.Instance.addEventListener(DailyReceiveManager.CLOSE_ICON, this.__closeIcon);
            TimeManager.addEventListener(TimeEvents.SECONDS, this.__secondsCheck);
            TaskManager.instance.addEventListener(TaskEvent.SHOW_DOWNLOAD_FRAME, this.tryShowClientDownload);
            SocketManager.Instance.addEventListener(CrazyTankSocketEvent.ONLINE_REWADS, this.__closeAwardBtn);
            PlayerManager.Instance.Self.addEventListener(WeekendEvent.ENERGY_CHANGE, this.__weekendEnergyChange);
            if (this._firstFlag)
            {
                TimerOpenManager.Instance.firstLogin();
                PetInfoManager.instance.checkAllPetCanMagic();
            };
            CapabilityNocticeManager.instance.addNotice(CapabilityNocticeManager.ARENA_LEVEL, "ddt.view.CapabilityNocticeView.arenaPic", CapabilityNocticeManager.ARENA_NAME);
            CapabilityNocticeManager.instance.check();
            FightPowerAndFatigue.Instance.show();
            if (BossBoxManager.instance.isHaveBox())
            {
                if (this._timerBox == null)
                {
                    this._timerBox = new SmallBoxButton(1);
                };
                addChild(this._timerBox);
            };
            if (((!(PlayerManager.Instance.Self.isAward)) && (!(PlayerManager.Instance.Self.isFristShow))))
            {
                this.initDailyReceiveFrame();
            };
        }

        private function initDailyReceiveFrame():void
        {
            PlayerManager.Instance.Self.isFristShow = true;
            DailyReceiveManager.Instance.show();
        }

        private function __closeAwardBtn(_arg_1:CrazyTankSocketEvent):void
        {
            var _local_2:int = _arg_1.pkg.readInt();
            if (_local_2 == 1)
            {
                if (this._consortionAwardBtn)
                {
                    ObjectUtils.disposeObject(this._consortionAwardBtn);
                    this._consortionAwardBtn = null;
                };
                MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.consortion.AwardTips"));
                this.addButtonList();
            }
            else
            {
                if (_local_2 == 2)
                {
                    MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.consortion.AwardTipsI"));
                };
            };
        }

        private function __onEnterSingleClick(_arg_1:MouseEvent):void
        {
            StateManager.setState(StateType.SINGLEDUNGEON);
        }

        private function addButtonList():void
        {
            var _local_2:MainButton;
            var _local_3:Array;
            var _local_4:BaseButton;
            var _local_5:Sprite;
            var _local_6:Point;
            var _local_7:Point;
            if ((!(this._mainPanelContent)))
            {
                return;
            };
            this._mainPanelContent.disposeAllChildren();
            var _local_1:Vector.<MainButton> = MainButtnController.instance.test();
            if ((!(_local_1)))
            {
                return;
            };
            this.btnList = new Array();
            for each (_local_2 in _local_1)
            {
                if (_local_2.btnServerVisable == 1)
                {
                    if (_local_2.btnCompleteVisable == 1)
                    {
                        _local_5 = this.getButton(_local_2.btnMark);
                        if (_local_5)
                        {
                            this._mainPanelContent.addChild(_local_5);
                            this.btnList.push(_local_5);
                        };
                    };
                };
            };
            _local_3 = this.getDiamondButtons();
            for each (_local_4 in _local_3)
            {
                this._mainPanelContent.addChild(_local_4);
                this.btnList.push(_local_4);
            };
            if (this._mainPanelContent.numChildren <= 5)
            {
                this._mainBtnPanel.vScrollbar.increaseButton.visible = false;
                this._mainBtnPanel.vScrollbar.decreaseButton.visible = false;
            }
            else
            {
                this._mainBtnPanel.vScrollbar.increaseButton.visible = true;
                this._mainBtnPanel.vScrollbar.decreaseButton.visible = true;
                this._mainBtnPanel.vScrollbar.increaseButton.addEventListener(MouseEvent.CLICK, this.__soundPlay);
                this._mainBtnPanel.vScrollbar.decreaseButton.addEventListener(MouseEvent.CLICK, this.__soundPlay);
            };
            this._mainBtnPanel.invalidateViewport();
            if (this._goSignBtn)
            {
                _local_6 = this._mainBtnPanel.displayObjectViewport.localToGlobal(new Point(0, 0));
                _local_7 = new Point(((_local_6.x + this._goSignBtn.x) - 83), (_local_6.y + this._goSignBtn.y));
                LivenessBubbleManager.Instance.setPos(_local_7);
                LivenessBubbleManager.Instance.tryShowBubble();
            };
        }

        private function __soundPlay(_arg_1:MouseEvent):void
        {
            SoundManager.instance.play("008");
        }

        private function getButton(_arg_1:int):Sprite
        {
            var _local_2:Sprite;
            switch (_arg_1)
            {
                case 1:
                    this.initActivity();
                    this._activityIcon.buttonMode = true;
                    _local_2 = this._activityIcon;
                    break;
                case 2:
                    break;
                case 3:
                    if (((!(PlayerManager.Instance.Self.IsVIP)) || (PlayerManager.Instance.Self.VIPtype == 0)))
                    {
                        this.initVip();
                        this._vipIcon.buttonMode = true;
                        _local_2 = this._vipIcon;
                    };
                    break;
                case 5:
                    this.initGoSignBtn();
                    this._goSignBtn.buttonMode = true;
                    _local_2 = this._goSignBtn;
                    break;
                case 6:
                    this.initAward();
                    this._awardBtn.buttonMode = true;
                    _local_2 = this._awardBtn;
                    break;
                case 7:
                    break;
                case 8:
                    this.intFightBtn();
                    _local_2 = this._fightBtn;
                    break;
                case 9:
                    break;
                case 10:
                    if (this.checkpurchaseStone())
                    {
                        this.intPackagePurchaseBtn();
                        _local_2 = this._packagePurchaseBtn;
                    };
                    break;
                case 11:
                    this.initAwardBtn();
                    _local_2 = this._consortionAwardBtn;
                    break;
                case 12:
                    this.initFirstChargeBtn();
                    _local_2 = this._firstChargeBtn;
                    break;
                case 13:
                    this.initWeekendBtn();
                    _local_2 = this._weekendBtn;
                    break;
                case 14:
                    this.initTurnPlateBtn();
                    _local_2 = this._turnPlateBtn;
                    break;
                case 15:
                    this.initFightRobotBtn();
                    _local_2 = this._fightRobotBtn;
                    break;
                case 16:
                    this.initDailyReceiveBtn();
                    _local_2 = this._dailyReceiveIcon;
                    break;
            };
            return (_local_2);
        }

        private function intPackagePurchaseBtn():void
        {
            if ((!(this._packagePurchaseBtn)))
            {
                this._packagePurchaseBtn = ComponentFactory.Instance.creat("asset.hallView.packagePurchaseBtn");
                this._packagePurchaseBtn.addEventListener(MouseEvent.CLICK, this.__openPackagePurchaseBox);
            };
            this._packagePurchaseBtn.x = 3;
            this._packagePurchaseBtn.buttonMode = true;
        }

        private function __openPackagePurchaseBox(_arg_1:MouseEvent):void
        {
            SoundManager.instance.play("008");
            PackagePurchaseBoxController.instance.show();
        }

        private function intFightBtn():void
        {
            if ((!(this._fightBtn)))
            {
                this._fightBtn = ComponentFactory.Instance.creat("asset.hallView.fightBtn");
                this._fightBtn.addEventListener(MouseEvent.CLICK, this.__openFightToolBox);
            };
            PositionUtils.setPos(ComponentFactory.Instance.creatCustomObject("asset.hallView。btnPos.fighttoolbox"), this._fightBtn);
            this._fightBtn.x = 8;
            this._fightBtn.buttonMode = true;
        }

        private function checkpurchaseStone():Boolean
        {
            var _local_1:uint = PackagePurchaseBoxController.instance.measureList(ShopManager.Instance.getValidSortedGoodsByType(PackagePurchaseBoxFrame.PURCHASEPACKAGEBOX, 1)).length;
            if (_local_1 <= 0)
            {
                return (false);
            };
            return (true);
        }

        private function initVip():void
        {
            if ((!(this._vipIcon)))
            {
                this._vipIcon = ComponentFactory.Instance.creat("asset.hallView.VIPLvl");
                this._vipIcon.VIPCharge.buttonMode = true;
                this._vipIcon.buttonMode = true;
                this._vipIcon.addEventListener(MouseEvent.CLICK, this.__OpenVipView);
            };
            this.checkVipShine();
        }

        private function checkVipShine():void
        {
            this._vipIcon.movie.buttonMode = true;
            if (PlayerManager.Instance.geticonShine("_vipIcon"))
            {
                this._vipIcon.movie.visible = true;
            }
            else
            {
                this._vipIcon.movie.visible = false;
            };
        }

        private function initActivity():void
        {
            if ((!(this._activityIcon)))
            {
                this._activityIcon = (ClassUtils.CreatInstance("asset.hallView.activity") as MovieClip);
                this._activityIcon.addEventListener(MouseEvent.CLICK, this.__openActivityView);
                ActivityController.instance.model.addEventListener(ActivityEvent.ACTIVITY_UPDATE, this.__updateActivity);
            };
            this.checkAcitvityIconShine();
            this._activityIcon.image.buttonMode = true;
            this._activityIcon.buttonMode = true;
            this.checkActivityImage();
        }

        private function __updateActivity(_arg_1:ActivityEvent):void
        {
            this.checkActivityImage();
        }

        private function checkActivityImage():void
        {
            if (ActivityController.instance.checkHasOpenActivity())
            {
                this._activityIcon.image.gotoAndStop(2);
            }
            else
            {
                this._activityIcon.image.gotoAndStop(1);
            };
        }

        private function checkAcitvityIconShine():void
        {
            this._activityIcon.movie.buttonMode = true;
            if (PlayerManager.Instance.geticonShine("_activityIcon"))
            {
                this._activityIcon.movie.visible = true;
            }
            else
            {
                this._activityIcon.movie.visible = false;
            };
        }

        private function initFightRobotBtn():void
        {
            if ((!(this._fightRobotBtn)))
            {
                this._fightRobotBtn = (ClassUtils.CreatInstance("asset.hallView.fightRobot") as MovieClip);
                this._fightRobotBtn.addEventListener(MouseEvent.CLICK, this.__onFightRobotClick);
                this._fightRobotBtn.image.buttonMode = true;
                this._fightRobotBtn.movie.buttonMode = true;
                this.CheckFightRobotIconShine();
            };
        }

        private function CheckFightRobotIconShine():void
        {
            if (PlayerManager.Instance.geticonShine("_fightRobotBtn"))
            {
                this._fightRobotBtn.movie.visible = true;
            }
            else
            {
                this._fightRobotBtn.movie.visible = false;
            };
        }

        private function initTurnPlateBtn():void
        {
            if ((!(this._turnPlateBtn)))
            {
                this._turnPlateBtn = (ClassUtils.CreatInstance("asset.hallView.turnplateMovie") as MovieClip);
                this._turnPlateBtn.addEventListener(MouseEvent.CLICK, this.__onTurnPlateClick);
                this._turnPlateBtn.image.buttonMode = true;
                this._turnPlateBtn.movie.buttonMode = true;
                TurnPlateController.Instance.addEventListener(TurnPlateController.STATE_CHANGE, this.__turnPlateIconShine);
                this.__turnPlateIconShine();
            };
        }

        private function __turnPlateIconShine(_arg_1:Event=null):void
        {
            this._turnPlateBtn.movie.buttonMode = true;
            if (TurnPlateController.Instance.isOpen)
            {
                this._turnPlateBtn.movie.visible = true;
            }
            else
            {
                this._turnPlateBtn.movie.visible = false;
            };
        }

        private function initDailyReceiveBtn():void
        {
            if ((!(this._dailyReceiveIcon)))
            {
                this._dailyReceiveIcon = (ClassUtils.CreatInstance("asset.hallView.dailyMovie") as MovieClip);
                this._dailyReceiveIcon.addEventListener(MouseEvent.CLICK, this.__ondailyClick);
                this._dailyReceiveIcon.image.buttonMode = true;
                this._dailyReceiveIcon.movie.buttonMode = true;
                this.checkDailyReceiveShine();
            };
        }

        private function __closeIcon(_arg_1:Event):void
        {
            if (this._dailyReceiveIcon)
            {
                ObjectUtils.disposeObject(this._dailyReceiveIcon);
                this._dailyReceiveIcon = null;
                this.addButtonList();
            };
        }

        private function initGoSignBtn():void
        {
            if ((!(this._goSignBtn)))
            {
                this._goSignBtn = (ClassUtils.CreatInstance("asset.hallView.signMovie") as MovieClip);
                this._goSignBtn.addEventListener(MouseEvent.CLICK, this.__onSignClick);
                this._goSignBtn.image.buttonMode = true;
                this._goSignBtn.movie.buttonMode = true;
                LivenessBubbleManager.Instance.addEventListener(LivenessEvent.SHOW_SHINE, this.__signIconShine);
            };
            if (((LivenessBubbleManager.Instance.needShine) || (!(LivenessBubbleManager.Instance.hasClickIcon))))
            {
                this.__signIconShine(new LivenessEvent(LivenessEvent.SHOW_SHINE, true));
            }
            else
            {
                this.__signIconShine(new LivenessEvent(LivenessEvent.SHOW_SHINE, false));
            };
        }

        private function __signIconShine(_arg_1:LivenessEvent):void
        {
            this._goSignBtn.movie.buttonMode = true;
            if (Boolean(_arg_1.info))
            {
                this._goSignBtn.movie.visible = true;
            }
            else
            {
                this._goSignBtn.movie.visible = false;
            };
        }

        private function initAwardBtn():void
        {
            if (this._consortionAwardBtn)
            {
                ObjectUtils.disposeObject(this._consortionAwardBtn);
                this._consortionAwardBtn = null;
            };
            this._consortionAwardBtn = ComponentFactory.Instance.creatComponentByStylename("ddt.ConostionGoldAwardButton");
        }

        private function initFirstChargeBtn():void
        {
            if (((PlayerManager.Instance.Self.Grade < 1) || (PlayerManager.Instance.Self.Grade > 29)))
            {
                return;
            };
            var _local_1:ActivityInfo = ActivityController.instance.checkHasFirstCharge();
            if ((((_local_1) && (ActivityController.instance.model.getLog(_local_1.ActivityId) == 0)) && (!(this._firstChargeBtn))))
            {
                if ((!(this._firstChargeBtn)))
                {
                    this._firstChargeBtn = ComponentFactory.Instance.creat("asset.hallView.firstCharge");
                    this._firstChargeBtn.addEventListener(MouseEvent.CLICK, this.__firstChargeClick);
                    this._firstChargeBtn.buttonMode = true;
                    this._firstChargeBtn.firstChargeMC.buttonMode = true;
                };
                this.checkFirstOpenIconShine();
            };
        }

        private function checkFirstOpenIconShine():void
        {
            this._firstChargeBtn.movie.buttonMode = true;
            if (PlayerManager.Instance.geticonShine("_firstChargeBtn"))
            {
                this._firstChargeBtn.movie.visible = true;
            }
            else
            {
                this._firstChargeBtn.movie.visible = false;
            };
        }

        private function __firstChargeClick(_arg_1:MouseEvent):void
        {
            SoundManager.instance.play("008");
            PlayerManager.Instance.setIconShine("_firstChargeBtn", false);
            this.checkFirstOpenIconShine();
            ActivityController.instance.showFirstRechargeView();
        }

        private function initWeekendBtn():void
        {
            if ((!(this._weekendBtn)))
            {
                this._weekendBtn = (ComponentFactory.Instance.creat("asset.hallView.weekend") as MovieClip);
                this._weekendBtn.buttonMode = true;
                this._weekendBtn.addEventListener(MouseEvent.CLICK, this.__weekendClick);
                addChild(this._weekendBtn);
            };
            this.checkWeekendShine();
        }

        private function __weekendEnergyChange(_arg_1:WeekendEvent):void
        {
            this.addButtonList();
        }

        private function __weekendClick(_arg_1:MouseEvent):void
        {
            SoundManager.instance.play("008");
            WeekendManager.instance.show();
            PlayerManager.Instance.setIconShine("_weekendBtn", false);
            this.checkWeekendShine();
        }

        private function checkWeekendShine():void
        {
            this._weekendBtn.movie.buttonMode = true;
            if (PlayerManager.Instance.geticonShine("_weekendBtn"))
            {
                this._weekendBtn.movie.visible = true;
            }
            else
            {
                this._weekendBtn.movie.visible = false;
            };
        }

        private function __onTurnPlateClick(_arg_1:MouseEvent):void
        {
            SoundManager.instance.play("008");
            TurnPlateController.Instance.show();
        }

        private function __onFightRobotClick(_arg_1:MouseEvent):void
        {
            SoundManager.instance.play("008");
            var _local_2:FightRobotFrame = ComponentFactory.Instance.creatCustomObject("ddt.fightRobot.frame");
            _local_2.show();
            PlayerManager.Instance.setIconShine("_fightRobotBtn", false);
            this.CheckFightRobotIconShine();
        }

        private function __ondailyClick(_arg_1:MouseEvent):void
        {
            SoundManager.instance.play("008");
            DailyReceiveManager.Instance.show();
            PlayerManager.Instance.setIconShine("_dailyReceiveIcon", false);
            this.checkDailyReceiveShine();
        }

        private function checkDailyReceiveShine():void
        {
            if (PlayerManager.Instance.geticonShine("_dailyReceiveIcon"))
            {
                this._dailyReceiveIcon.movie.visible = true;
            }
            else
            {
                this._dailyReceiveIcon.movie.visible = false;
            };
        }

        private function __onSignClick(_arg_1:MouseEvent):void
        {
            SoundManager.instance.play("008");
            NewHandContainer.Instance.clearArrowByID(ArrowType.CLICK_LIVENESS);
            if (SavePointManager.Instance.isInSavePoint(75))
            {
                SavePointManager.Instance.setSavePoint(75);
            };
            LivenessBubbleManager.Instance.hasClickIcon = true;
            if ((!(LivenessBubbleManager.Instance.needShine)))
            {
                this.__signIconShine(new LivenessEvent(LivenessEvent.SHOW_SHINE, false));
            };
            var _local_2:LivenessFrameView = ComponentFactory.Instance.creatCustomObject("liveness.hall.livenessFrameView");
            _local_2.show();
        }

        private function initAward():void
        {
            if ((!(this._awardBtn)))
            {
                this._awardBtn = ComponentFactory.Instance.creat("asset.hallView.ActivityIcon");
            };
            this._awardBtn.x = 8;
            this._awardBtn.buttonMode = true;
            this._awardBtn.addEventListener(MouseEvent.CLICK, this.__OpenView);
        }

        private function __OpenView(_arg_1:MouseEvent):void
        {
            SoundManager.instance.play("008");
            MainButtnController.instance.show(MainButtnController.DDT_AWARD);
            MainButtnController.instance.addEventListener(MainButtnController.ICONCLOSE, this.__iconClose);
        }

        private function __openActivityView(_arg_1:Event):void
        {
            SoundManager.instance.play("008");
            ActivityController.instance.showFrame();
            PlayerManager.Instance.setIconShine("_activityIcon", false);
            this.checkAcitvityIconShine();
        }

        private function __isOpenBtn(_arg_1:Event):void
        {
            this.addButtonList();
            if (this._awardBtn)
            {
                this._awardBtn.visible = true;
            };
            this.initVip();
            if ((((VipController.instance.isShow) && (!(SharedManager.Instance.showVipCheckBtn))) && (VipController.instance.checkVipExpire())))
            {
                this.tryShowVip();
            };
        }

        private function __iconClose(_arg_1:Event):void
        {
            if (PlayerManager.Instance.Self.IsVIP)
            {
                if (((!(PlayerManager.Instance.Self.canTakeVipReward)) && (!(MainButtnController.instance.DailyAwardState))))
                {
                    this._awardBtn.visible = false;
                    this.addButtonList();
                };
            }
            else
            {
                if ((!(MainButtnController.instance.DailyAwardState)))
                {
                    this._awardBtn.visible = false;
                    this.addButtonList();
                };
            };
        }

        private function __OpenVipView(_arg_1:MouseEvent):void
        {
            SoundManager.instance.play("008");
            VipController.instance.show();
            PlayerManager.Instance.setIconShine("_vipIcon", false);
            this.checkVipShine();
        }

        private function __openFightToolBox(_arg_1:MouseEvent):void
        {
            SoundManager.instance.playButtonSound();
            FightToolBoxController.instance.show();
        }

        private function __onAudioIILoadComplete(_arg_1:LoaderEvent):void
        {
            _arg_1.loader.removeEventListener(LoaderEvent.COMPLETE, this.__onAudioIILoadComplete);
            SoundManager.instance.setupAudioResource(true);
            SoundIILoaded = true;
        }

        private function __onAudioLoadComplete(_arg_1:Event):void
        {
            _arg_1.currentTarget.removeEventListener(Event.COMPLETE, this.__onAudioLoadComplete);
            SoundManager.instance.setupAudioResource(false);
            SoundILoaded = true;
        }

        private function __OpenlittleGame(_arg_1:MouseEvent):void
        {
            StateManager.setState(StateType.LITTLEHALL);
        }

        private function setBuildState(_arg_1:TaskEvent=null):void
        {
            var _local_2:Array = SavePointManager.Instance.savePoints;
            this._dungeonButton.visible = true;
            if (_local_2[35])
            {
                if (SavePointManager.Instance.isInSavePoint(44))
                {
                    if (this._buildingMask)
                    {
                        return;
                    };
                    this.createBuildingMask();
                    this._hallBG.addChild(this._buildingMask);
                    this.buildingMovie = new MovieClipWrapper(ComponentFactory.Instance.creatCustomObject("asset.hall.storeHouseMovie"), true, true);
                    this._hallBG.addChild(this.buildingMovie.movie);
                    this.buildingMovie.addEventListener(Event.COMPLETE, this.buttonAppear(this._storeButton, 44));
                }
                else
                {
                    this._storeButton.visible = true;
                };
            };
            if (_local_2[13])
            {
                if (SavePointManager.Instance.isInSavePoint(45))
                {
                    if (this._buildingMask)
                    {
                        return;
                    };
                    this.createBuildingMask();
                    this._hallBG.addChild(this._buildingMask);
                    this.buildingMovie = new MovieClipWrapper(ComponentFactory.Instance.creatCustomObject("asset.hall.gameRoomHouseMovie"), true, true);
                    this._hallBG.addChild(this.buildingMovie.movie);
                    this.buildingMovie.addEventListener(Event.COMPLETE, this.buttonAppear(this._roomListButton, 45));
                }
                else
                {
                    this._roomListButton.visible = true;
                };
            };
            if (_local_2[14])
            {
                if (SavePointManager.Instance.isInSavePoint(46))
                {
                    if (this._buildingMask)
                    {
                        return;
                    };
                    this.createBuildingMask();
                    this._hallBG.addChild(this._buildingMask);
                    this.buildingMovie = new MovieClipWrapper(ComponentFactory.Instance.creatCustomObject("asset.hall.shopHouseMovie"), true, true);
                    this._hallBG.addChild(this.buildingMovie.movie);
                    this.buildingMovie.addEventListener(Event.COMPLETE, this.buttonAppear(this._shopButton, 46));
                }
                else
                {
                    this._shopButton.visible = true;
                };
            };
            if (_local_2[24])
            {
                if (SavePointManager.Instance.isInSavePoint(47))
                {
                    if (this._buildingMask)
                    {
                        return;
                    };
                    this.createBuildingMask();
                    this._hallBG.addChild(this._buildingMask);
                    this.buildingMovie = new MovieClipWrapper(ComponentFactory.Instance.creatCustomObject("asset.hall.framHouseMovie"), true, true);
                    this._hallBG.addChild(this.buildingMovie.movie);
                    this.buildingMovie.addEventListener(Event.COMPLETE, this.buttonAppear(this._farmButton, 47));
                }
                else
                {
                    this._farmButton.visible = true;
                };
            };
            if (_local_2[73])
            {
                if (SavePointManager.Instance.isInSavePoint(28))
                {
                    if (this._buildingMask)
                    {
                        return;
                    };
                    this.createBuildingMask();
                    this._hallBG.addChild(this._buildingMask);
                    this.buildingMovie = new MovieClipWrapper(ComponentFactory.Instance.creatCustomObject("asset.hall.auctionHouseMovie"), true, true);
                    this._hallBG.addChild(this.buildingMovie.movie);
                    this.buildingMovie.addEventListener(Event.COMPLETE, this.buttonAppear(this._auctionButton));
                    this.buildingMovieI = new MovieClipWrapper(ComponentFactory.Instance.creatCustomObject("asset.hall.churchHouseMovie"), true, true);
                    this._hallBG.addChild(this.buildingMovieI.movie);
                    this.buildingMovieI.addEventListener(Event.COMPLETE, this.buttonAppear(this._churchButton));
                    this.buildingMovieII = new MovieClipWrapper(ComponentFactory.Instance.creatCustomObject("asset.hall.tofflistHouseMovie"), true, true);
                    this._hallBG.addChild(this.buildingMovieII.movie);
                    this.buildingMovieII.addEventListener(Event.COMPLETE, this.buttonAppear(this._tofflistButton, 28));
                }
                else
                {
                    this._auctionButton.visible = true;
                    this._churchButton.visible = true;
                    this._tofflistButton.visible = true;
                    if (PlayerManager.Instance.Self.Grade >= 15)
                    {
                        this._consortiaButton.visible = true;
                    };
                };
            };
            this.loadUserGuide();
            this.loadWeakGuild();
        }

        private function createBuildingMask():void
        {
            this._buildingMask = new Sprite();
            this._buildingMask.graphics.beginFill(0, 0.5);
            this._buildingMask.graphics.drawRect(0, 0, 1000, 600);
            this._buildingMask.graphics.endFill();
        }

        private function buttonAppear(btn:BaseButton=null, savePoint:uint=0):Function
        {
            var fun:Function = function (_arg_1:Event):void
            {
                if (savePoint)
                {
                    SavePointManager.Instance.setSavePoint(savePoint);
                    checkLivenessDialog();
                };
                if (_buildingMask)
                {
                    _buildingMask.graphics.clear();
                    if (_buildingMask.parent)
                    {
                        _buildingMask.parent.removeChild(_buildingMask);
                    };
                    _buildingMask = null;
                };
                var _local_2:MovieClipWrapper = (_arg_1.currentTarget as MovieClipWrapper);
                _local_2.removeEventListener(Event.COMPLETE, buttonAppear(btn, savePoint));
                _local_2 = null;
                if ((!(_hallBG)))
                {
                    return;
                };
                btn.visible = true;
            };
            return (fun);
        }

        private function checkLivenessDialog():void
        {
            if (DialogManager.Instance.showing)
            {
                this._livenessDialogTimeout = setTimeout(this.checkLivenessDialog, 500);
            }
            else
            {
                if (SavePointManager.Instance.isInSavePoint(77))
                {
                    this.showDialog(58);
                };
            };
        }

        private function addFrame():void
        {
            if (this._isAddFrameComplete)
            {
                return;
            };
            if ((((TimeManager.Instance.TotalDaysToNow((PlayerManager.Instance.Self.LastDate as Date)) >= 30) && (PlayerManager.Instance.Self.isOldPlayerHasValidEquitAtLogin)) && (!(PlayerManager.Instance.Self.isOld))))
            {
                CacheSysManager.getInstance().cacheFunction(CacheConsts.ALERT_IN_HALL, new FunctionAction(new ShopRechargeEquipServer().show));
            }
            else
            {
                if (PlayerManager.Instance.Self.OvertimeListByBody.length > 0)
                {
                    CacheSysManager.getInstance().cacheFunction(CacheConsts.ALERT_IN_HALL, new FunctionAction(new ShopRechargeEquipAlert().show));
                }
                else
                {
                    InventoryItemInfo.startTimer();
                };
            };
            this._isAddFrameComplete = true;
        }

        private function loadWeakGuild():void
        {
            if ((((((SavePointManager.Instance.isInSavePoint(16)) && (!(TaskManager.instance.isNewHandTaskCompleted(12)))) || ((SavePointManager.Instance.isInSavePoint(26)) && (!(TaskManager.instance.isNewHandTaskCompleted(23))))) || ((SavePointManager.Instance.isInSavePoint(67)) && (!(TaskManager.instance.isNewHandTaskCompleted(28))))) || (((SavePointManager.Instance.savePoints[35]) && (!(SavePointManager.Instance.savePoints[9]))) && (!(TaskManager.instance.isNewHandTaskCompleted(7))))))
            {
                NewHandContainer.Instance.showArrow(ArrowType.HALL_BUILD, 135, "trainer.storeArrowPos", "asset.trainer.txtClickEnter", "trainer.storeTipPos", this);
            };
            if ((((((SavePointManager.Instance.isInSavePoint(14)) && (!(TaskManager.instance.isNewHandTaskCompleted(10)))) || ((SavePointManager.Instance.isInSavePoint(17)) && (!(TaskManager.instance.isNewHandTaskCompleted(13))))) || ((SavePointManager.Instance.isInSavePoint(18)) && (!(TaskManager.instance.isNewHandTaskCompleted(14))))) || ((SavePointManager.Instance.isInSavePoint(55)) && (!(TaskManager.instance.isNewHandTaskCompleted(27))))))
            {
                NewHandContainer.Instance.showArrow(ArrowType.HALL_BUILD, 135, "trainer.gameRoomArrowPos", "asset.trainer.txtClickEnter", "trainer.gameRoomTipPos", this);
            };
            if (((SavePointManager.Instance.isInSavePoint(15)) && (!(TaskManager.instance.isNewHandTaskCompleted(11)))))
            {
                NewHandContainer.Instance.showArrow(ArrowType.HALL_BUILD, 0, "trainer.shopArrowPos", "asset.trainer.txtClickEnter", "trainer.shopTipPos", this);
            };
            if ((((((((((((((((SavePointManager.Instance.isInSavePoint(4)) && (!(TaskManager.instance.isNewHandTaskCompleted(2)))) && (SavePointManager.Instance.savePoints[33])) && (SavePointManager.Instance.savePoints[64])) || ((SavePointManager.Instance.isInSavePoint(6)) && ((!(TaskManager.instance.isNewHandTaskCompleted(4))) || (!(TaskManager.instance.isNewHandTaskCompleted(5)))))) || ((SavePointManager.Instance.isInSavePoint(8)) && (!(TaskManager.instance.isNewHandTaskCompleted(26))))) || ((SavePointManager.Instance.isInSavePoint(10)) && (!(TaskManager.instance.isNewHandTaskCompleted(6))))) || ((SavePointManager.Instance.isInSavePoint(11)) && (!(TaskManager.instance.isNewHandTaskCompleted(3))))) || ((TaskManager.instance.isNewHandTaskAchieved(6)) && (SavePointManager.Instance.isInSavePoint(40)))) || ((SavePointManager.Instance.isInSavePoint(19)) && (!(TaskManager.instance.isNewHandTaskCompleted(15))))) || ((SavePointManager.Instance.isInSavePoint(22)) && (!(TaskManager.instance.isNewHandTaskCompleted(18))))) || ((SavePointManager.Instance.isInSavePoint(12)) && (((!(TaskManager.instance.isNewHandTaskCompleted(8))) && (!(TaskManager.instance.isNewHandTaskAchieved(8)))) || ((!(TaskManager.instance.isNewHandTaskCompleted(9))) && (!(TaskManager.instance.isNewHandTaskAchieved(9))))))) || ((SavePointManager.Instance.isInSavePoint(23)) && (((!(TaskManager.instance.isNewHandTaskCompleted(19))) && (!(TaskManager.instance.isNewHandTaskAchieved(19)))) || ((!(TaskManager.instance.isNewHandTaskCompleted(20))) && (!(TaskManager.instance.isNewHandTaskAchieved(20))))))) || ((SavePointManager.Instance.isInSavePoint(25)) && (!(TaskManager.instance.isNewHandTaskCompleted(22))))) || ((SavePointManager.Instance.isInSavePoint(27)) && (((!(TaskManager.instance.isNewHandTaskCompleted(24))) && (!(TaskManager.instance.isNewHandTaskAchieved(24)))) || ((!(TaskManager.instance.isNewHandTaskCompleted(25))) && (!(TaskManager.instance.isNewHandTaskAchieved(25))))))))
            {
                NewHandContainer.Instance.showArrow(ArrowType.HALL_BUILD, -45, "trainer.dungeonArrowPos", "asset.trainer.txtClickEnter", "trainer.dungeonTipPos", this);
            };
            if (((SavePointManager.Instance.isInSavePoint(47)) || ((SavePointManager.Instance.isInSavePoint(48)) && (!(TaskManager.instance.isNewHandTaskCompleted(21))))))
            {
                NewHandContainer.Instance.showArrow(ArrowType.IN_FARM, 45, "trainer.farmArrowPos", "asset.trainer.txtClickEnter", "trainer.farmTipPos", this);
            };
            if (SavePointManager.Instance.isInSavePoint(34))
            {
                this.showDialog(13);
            };
        }

        private function __taskFrameHide(_arg_1:TaskEvent):void
        {
            this.loadWeakGuild();
        }

        private function __getDialogFromServer(_arg_1:CrazyTankSocketEvent):void
        {
            var _local_2:PackageIn = _arg_1.pkg;
            var _local_3:int = _local_2.readInt();
            this.showDialog(_local_3);
        }

        private function showDialog(_arg_1:uint):void
        {
            this.hideBottomUI();
            LayerManager.Instance.addToLayer(DialogManager.Instance.DialogBox, LayerManager.STAGE_TOP_LAYER);
            DialogManager.Instance.addEventListener(Event.COMPLETE, this.__dialogEndCallBack);
            DialogManager.Instance.addEventListener(DialogManagerBase.READY_TO_CLOSE, this.__dialogReadyToClose);
            DialogManager.Instance.showDialog(_arg_1);
        }

        private function __dialogReadyToClose(_arg_1:Event):void
        {
            DialogManager.Instance.removeEventListener(DialogManagerBase.READY_TO_CLOSE, this.__dialogReadyToClose);
            this.showBottomUI();
        }

        private function __dialogEndCallBack(_arg_1:Event):void
        {
            DialogManager.Instance.removeEventListener(Event.COMPLETE, this.__dialogEndCallBack);
            if ((!(SavePointManager.Instance.savePoints[1])))
            {
                MainToolBar.Instance.showIconAppear(0);
                MainToolBar.Instance.showIconAppear(1);
                MainToolBar.Instance.showIconAppear(3);
            };
            if (SavePointManager.Instance.isInSavePoint(34))
            {
                SavePointManager.Instance.setSavePoint(34);
                NewHandContainer.Instance.showArrow(ArrowType.HALL_BUILD, -45, "trainer.dungeonArrowPos", "asset.trainer.txtClickEnter", "trainer.dungeonTipPos");
            };
            if (SavePointManager.Instance.isInSavePoint(40))
            {
                SavePointManager.Instance.setSavePoint(40);
                NewHandContainer.Instance.showArrow(ArrowType.HALL_BUILD, -45, "trainer.dungeonArrowPos", "asset.trainer.txtClickEnter", "trainer.dungeonTipPos", this);
            };
            if (this._showDownloadClient)
            {
                this._showDownloadClient = false;
                this._clientDownloadFrame = ComponentFactory.Instance.creatCustomObject("asset.quest.clientDownloadFrame");
                this._clientDownloadFrame.addEventListener(Event.COMPLETE, this.__closeClientDownloadFrame);
                this._clientDownloadFrame.show();
            };
            if (SavePointManager.Instance.isInSavePoint(77))
            {
                SavePointManager.Instance.setSavePoint(77);
                NewHandContainer.Instance.showArrow(ArrowType.CLICK_TASK, 0, "trainer.posClickTask", "asset.trainer.txtClickEnter", "trainer.posClickTaskTxt", MainToolBar.Instance);
            };
        }

        private function hideBottomUI():void
        {
            MainToolBar.Instance.hide();
            ChatManager.Instance.view.visible = false;
        }

        private function showBottomUI():void
        {
            MainToolBar.Instance.show();
            ChatManager.Instance.view.visible = true;
        }

        private function checkShowVote():void
        {
            if (VoteManager.Instance.showVote)
            {
                VoteManager.Instance.addEventListener(VoteManager.LOAD_COMPLETED, this.__vote);
                if (VoteManager.Instance.loadOver)
                {
                    VoteManager.Instance.removeEventListener(VoteManager.LOAD_COMPLETED, this.__vote);
                    VoteManager.Instance.openVote();
                };
            };
        }

        private function checkShowVipAlert():void
        {
            var _local_2:String;
            var _local_1:SelfInfo = PlayerManager.Instance.Self;
            if (((!(_local_1.isSameDay)) && (!(VipController.instance.isRechargePoped))))
            {
                VipController.instance.isRechargePoped = true;
                if (_local_1.IsVIP)
                {
                    if ((((_local_1.VIPLeftDays <= VIP_LEFT_DAY_TO_COMFIRM) && (_local_1.VIPLeftDays >= 0)) || (_local_1.VIPLeftDays == VIP_LEFT_DAY_FIRST_PROMPT)))
                    {
                        _local_2 = "";
                        if (_local_1.VIPLeftDays == 0)
                        {
                            if (_local_1.VipLeftHours > 0)
                            {
                                _local_2 = LanguageMgr.GetTranslation("ddt.vip.vipView.expiredToday", _local_1.VipLeftHours);
                            }
                            else
                            {
                                if (_local_1.VipLeftHours == 0)
                                {
                                    _local_2 = LanguageMgr.GetTranslation("ddt.vip.vipView.expiredHour");
                                }
                                else
                                {
                                    _local_2 = LanguageMgr.GetTranslation("ddt.vip.vipView.expiredTrue");
                                };
                            };
                        }
                        else
                        {
                            _local_2 = LanguageMgr.GetTranslation("ddt.vip.vipView.expired", _local_1.VIPLeftDays);
                        };
                        this._renewal = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"), _local_2, LanguageMgr.GetTranslation("ddt.vip.vipView.RenewalNow"), "", false, false, false, LayerManager.ALPHA_BLOCKGOUND);
                        this._renewal.moveEnable = false;
                        this._renewal.addEventListener(FrameEvent.RESPONSE, this.__goRenewal);
                    };
                }
                else
                {
                    if (_local_1.VIPExp > 0)
                    {
                        if (((_local_1.LastDate.valueOf() < _local_1.VIPExpireDay.valueOf()) && (_local_1.VIPExpireDay.valueOf() <= _local_1.systemDate.valueOf())))
                        {
                            this._renewal = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"), LanguageMgr.GetTranslation("ddt.vip.vipView.expiredTrue"), LanguageMgr.GetTranslation("ddt.vip.vipView.RenewalNow"), "", false, false, false, LayerManager.ALPHA_BLOCKGOUND);
                            this._renewal.moveEnable = false;
                            this._renewal.addEventListener(FrameEvent.RESPONSE, this.__goRenewal);
                        };
                    };
                };
            };
        }

        private function checkShowVipAlert_New():void
        {
            var _local_1:SelfInfo = PlayerManager.Instance.Self;
            if ((((!(_local_1.isSameDay)) && (!(VipController.instance.isRechargePoped))) && (!(PlayerManager.Instance.Self.openVipType))))
            {
                VipController.instance.isRechargePoped = true;
                if (_local_1.IsVIP)
                {
                    if ((((_local_1.VIPLeftDays <= VIP_LEFT_DAY_TO_COMFIRM) && (_local_1.VIPLeftDays >= 0)) || (_local_1.VIPLeftDays <= VIP_LEFT_DAY_FIRST_PROMPT)))
                    {
                        VipController.instance.showRechargeAlert();
                    };
                }
                else
                {
                    if (((!(_local_1.IsVIP)) && (_local_1.VIPLevel > 0)))
                    {
                        VipController.instance.showRechargeAlert();
                    };
                };
            };
        }

        private function checkShowFightVipAlert():void
        {
            FightToolBoxController.instance.showRechargeAlert();
        }

        private function __goRenewal(_arg_1:FrameEvent):void
        {
            switch (_arg_1.responseCode)
            {
                case FrameEvent.SUBMIT_CLICK:
                case FrameEvent.ENTER_CLICK:
                    VipController.instance.show();
                    break;
            };
            this._renewal.removeEventListener(FrameEvent.RESPONSE, this.__goRenewal);
            this._renewal.dispose();
            this._renewal = null;
        }

        private function __vote(_arg_1:Event):void
        {
            VoteManager.Instance.removeEventListener(VoteManager.LOAD_COMPLETED, this.__vote);
            VoteManager.Instance.openVote();
        }

        private function checkShowStoreFromShop():void
        {
            if (BagStore.instance.isFromShop)
            {
                BagStore.instance.isFromShop = false;
                BagStore.instance.show();
            };
        }

        private function __moneyChargeHandle(_arg_1:PlayerEvent):void
        {
            var _local_2:ActivityInfo = ActivityController.instance.checkHasFirstCharge();
            if ((((_local_2) && (ActivityController.instance.model.getLog(_local_2.ActivityId) > 0)) && (this._firstChargeBtn)))
            {
                this._firstChargeBtn.removeEventListener(MouseEvent.CLICK, this.__firstChargeClick);
                ObjectUtils.disposeObject(this._firstChargeBtn);
                this._firstChargeBtn = null;
            };
        }

        private function toDungeon():void
        {
            StateManager.setState(StateType.SINGLEDUNGEON);
        }

        private function toFarmSelf():void
        {
            if (PlayerManager.Instance.Self.Grade < int(ServerConfigManager.instance.findInfoByName(ServerConfigManager.FARM_OPEN_LEVEL).Value))
            {
                MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.goFarmTip"));
                return;
            };
            StateManager.setState(StateType.FARM);
        }

        private function __btnClick(_arg_1:MouseEvent):void
        {
            var _local_2:BaseAlerFrame;
            var _local_3:BaseAlerFrame;
            SoundManager.instance.play("047");
            switch ((_arg_1.currentTarget as BaseButton))
            {
                case this._auctionButton:
                    if (PlayerManager.Instance.Self.Grade < 13)
                    {
                        MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.invite.InvitePlayerItem.ActionCannot"));
                        return;
                    };
                    AuctionHouseManager.Instance.showToauction(AuctionHouseController.Instance.setup, UIModuleTypes.DDTAUCTION);
                    ComponentSetting.SEND_USELOG_ID(7);
                    return;
                case this._farmButton:
                    this.toFarmSelf();
                    return;
                case this._churchButton:
                    ChurchManager.instance.showChurchlist(ChurchRoomListController.Instance.setup, UIModuleTypes.DDTCHURCH_ROOM_LIST);
                    ComponentSetting.SEND_USELOG_ID(6);
                    return;
                case this._consortiaButton:
                    if (PlayerManager.Instance.Self.ConsortiaID != 0)
                    {
                        SocketManager.Instance.out.SendenterConsortion(true);
                    }
                    else
                    {
                        ConsortionManager.Instance.showClubFrame(ConsortionModelControl.Instance.initClub, ((UIModuleTypes.CONSORTIAII + ",") + UIModuleTypes.DDTCONSORTIA));
                    };
                    ComponentSetting.SEND_USELOG_ID(5);
                    return;
                case this._dungeonButton:
                    SingleDungeonManager.Instance.loadModule(this.toDungeon);
                    return;
                case this._roomListButton:
                    if (PlayerManager.Instance.checkExpedition())
                    {
                        _local_2 = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("tips"), LanguageMgr.GetTranslation("ddt.consortion.ConsortionTransport.stopExpedition"), LanguageMgr.GetTranslation("ok"), LanguageMgr.GetTranslation("cancel"), false, true, false, LayerManager.BLCAK_BLOCKGOUND);
                        _local_2.moveEnable = false;
                        _local_2.addEventListener(FrameEvent.RESPONSE, this.__expeditionRoomConfirmResponse);
                    }
                    else
                    {
                        RoomManager.Instance.showRoomList(RoomListController.Instance.setup, UIModuleTypes.DDTROOMLIST);
                        ComponentSetting.SEND_USELOG_ID(3);
                    };
                    return;
                case this._shopButton:
                    StateManager.setState(StateType.SHOP);
                    ComponentSetting.SEND_USELOG_ID(1);
                    return;
                case this._storeButton:
                    BagStore.instance.show();
                    ComponentSetting.SEND_USELOG_ID(2);
                    return;
                case this._tofflistButton:
                    if (PlayerManager.Instance.checkExpedition())
                    {
                        _local_3 = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("tips"), LanguageMgr.GetTranslation("ddt.consortion.ConsortionTransport.stopExpedition"), LanguageMgr.GetTranslation("ok"), LanguageMgr.GetTranslation("cancel"), false, true, false, LayerManager.BLCAK_BLOCKGOUND);
                        _local_3.moveEnable = false;
                        _local_3.addEventListener(FrameEvent.RESPONSE, this.__expeditionDungeonConfirmResponse);
                    }
                    else
                    {
                        RoomManager.Instance.showRoomList(DungeonListController.Instance.setup, UIModuleTypes.DDTROOMLIST);
                        ComponentSetting.SEND_USELOG_ID(8);
                    };
                    return;
            };
        }

        private function __expeditionRoomConfirmResponse(_arg_1:FrameEvent):void
        {
            var _local_2:BaseAlerFrame = (_arg_1.currentTarget as BaseAlerFrame);
            _local_2.removeEventListener(FrameEvent.RESPONSE, this.__expeditionRoomConfirmResponse);
            if (((_arg_1.responseCode == FrameEvent.ENTER_CLICK) || (_arg_1.responseCode == FrameEvent.SUBMIT_CLICK)))
            {
                SocketManager.Instance.out.sendExpeditionCancle();
                RoomManager.Instance.showRoomList(RoomListController.Instance.setup, UIModuleTypes.DDTROOMLIST);
                ComponentSetting.SEND_USELOG_ID(3);
            };
            ObjectUtils.disposeObject(_local_2);
        }

        private function __expeditionDungeonConfirmResponse(_arg_1:FrameEvent):void
        {
            var _local_2:BaseAlerFrame = (_arg_1.currentTarget as BaseAlerFrame);
            _local_2.removeEventListener(FrameEvent.RESPONSE, this.__expeditionDungeonConfirmResponse);
            if (((_arg_1.responseCode == FrameEvent.ENTER_CLICK) || (_arg_1.responseCode == FrameEvent.SUBMIT_CLICK)))
            {
                SocketManager.Instance.out.sendExpeditionCancle();
                RoomManager.Instance.showRoomList(DungeonListController.Instance.setup, UIModuleTypes.DDTROOMLIST);
                ComponentSetting.SEND_USELOG_ID(8);
            };
            ObjectUtils.disposeObject(_local_2);
        }

        private function loadUserGuide():void
        {
            MainToolBar.Instance.tipTask();
        }

        private function sendToLoginInterface():void
        {
            var _local_1:URLVariables = new URLVariables();
            var _local_2:String = PlayerManager.Instance.Self.ID.toString();
            _local_2 = encodeURI(_local_2);
            var _local_3:String = "sdkxccjlqaoehtdwjkdycdrw";
            _local_1["username"] = _local_2;
            _local_1["sign"] = MD5.hash((_local_2 + _local_3));
            var _local_4:String = PathManager.callLoginInterface();
            if ((!(_local_4)))
            {
                return;
            };
            var _local_5:RequestLoader = LoadResourceManager.instance.createLoader(_local_4, BaseLoader.REQUEST_LOADER, _local_1);
            LoadResourceManager.instance.startLoad(_local_5);
        }

        private function exePopWelcome():Boolean
        {
            return (!(RoomManager.Instance.current == null));
        }

        override public function leaving(_arg_1:BaseStateView):void
        {
            if (this._timerBox)
            {
                ObjectUtils.disposeObject(this._timerBox);
                this._timerBox = null;
            };
            if (this._buildingMask)
            {
                this._buildingMask.graphics.clear();
                if (this._buildingMask.parent)
                {
                    this._buildingMask.parent.removeChild(this._buildingMask);
                };
            };
            if (this.buildingMovie)
            {
                this.buildingMovie.removeEventListener(Event.COMPLETE, this.buttonAppear);
            };
            if (this.buildingMovieI)
            {
                this.buildingMovieI.removeEventListener(Event.COMPLETE, this.buttonAppear);
            };
            if (this.buildingMovieII)
            {
                this.buildingMovieII.removeEventListener(Event.COMPLETE, this.buttonAppear);
            };
            if (this.buildingMovieIII)
            {
                this.buildingMovieIII.removeEventListener(Event.COMPLETE, this.buttonAppear);
            };
            ObjectUtils.disposeObject(this.buildingMovie);
            this.buildingMovie = null;
            ObjectUtils.disposeObject(this.buildingMovieI);
            this.buildingMovieI = null;
            ObjectUtils.disposeObject(this.buildingMovieII);
            this.buildingMovieII = null;
            ObjectUtils.disposeObject(this.buildingMovieIII);
            this.buildingMovieIII = null;
            clearTimeout(this._livenessDialogTimeout);
            TaskDirectorManager.instance.removeArrow();
            TaskManager.instance.removeEventListener(TaskEvent.BUILDING_REFLASH, this.setBuildState);
            MainButtnController.instance.removeEventListener(MainButtnController.ICONCLOSE, this.__iconClose);
            VoteManager.Instance.removeEventListener(VoteManager.LOAD_COMPLETED, this.__vote);
            TaskManager.instance.removeEventListener(TaskEvent.TASK_FRAME_HIDE, this.__taskFrameHide);
            SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.SHOW_DIALOG, this.__getDialogFromServer);
            SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.ONLINE_REWADS, this.__closeAwardBtn);
            PlayerManager.Instance.Self.removeEventListener(PlayerEvent.MONEY_CHARGE, this.__moneyChargeHandle);
            TimeManager.removeEventListener(TimeEvents.SECONDS, this.__secondsCheck);
            TaskManager.instance.removeEventListener(TaskEvent.SHOW_DOWNLOAD_FRAME, this.tryShowClientDownload);
            LivenessBubbleManager.Instance.removeEventListener(LivenessEvent.SHOW_SHINE, this.__signIconShine);
            PlayerManager.Instance.Self.removeEventListener(WeekendEvent.ENERGY_CHANGE, this.__weekendEnergyChange);
            DailyReceiveManager.Instance.removeEventListener(DailyReceiveManager.CLOSE_ICON, this.__closeIcon);
            StageReferance.stage.removeEventListener(MouseEvent.MOUSE_DOWN, this.__screenActive);
            StageReferance.stage.removeEventListener(MouseEvent.MOUSE_UP, this.__screenActive);
            StageReferance.stage.removeEventListener(KeyboardEvent.KEY_DOWN, this.__screenActive);
            StageReferance.stage.removeEventListener(KeyboardEvent.KEY_UP, this.__screenActive);
            PlayerManager.Instance.removeEventListener(PlayerManager.VIP_STATE_CHANGE, this.__isOpenBtn);
            MainToolBar.Instance.hide();
            MainToolBar.Instance.updateReturnBtn(MainToolBar.LEAVE_HALL);
            DailyButtunBar.Insance.hide();
            FightPowerAndFatigue.Instance.hide();
            FarmModelController.instance.deleteGainPlant();
            NewHandContainer.Instance.clearArrowByID(ArrowType.CLICK_LIVENESS);
            CapabilityNocticeManager.instance.hide();
            ActivityController.instance.model.removeEventListener(ActivityEvent.ACTIVITY_UPDATE, this.__updateActivity);
            TurnPlateController.Instance.removeEventListener(TurnPlateController.STATE_CHANGE, this.__turnPlateIconShine);
            if (this._hallBG)
            {
                this.sethallBg(false);
            };
            if (this._vipIcon)
            {
                ObjectUtils.disposeObject(this._vipIcon);
            };
            this._vipIcon = null;
            if (this._activityIcon)
            {
                ObjectUtils.disposeObject(this._activityIcon);
                this._activityIcon.removeEventListener(MouseEvent.CLICK, this.__openActivityView);
                this._activityIcon = null;
            };
            if (this._goSignBtn)
            {
                this._goSignBtn.removeEventListener(MouseEvent.CLICK, this.__onSignClick);
                ObjectUtils.disposeObject(this._goSignBtn);
            };
            this._goSignBtn = null;
            if (this._dailyReceiveIcon)
            {
                this._dailyReceiveIcon.removeEventListener(MouseEvent.CLICK, this.__ondailyClick);
                ObjectUtils.disposeObject(this._dailyReceiveIcon);
            };
            this._dailyReceiveIcon = null;
            if (this._turnPlateBtn)
            {
                this._turnPlateBtn.addEventListener(MouseEvent.CLICK, this.__onTurnPlateClick);
                ObjectUtils.disposeObject(this._turnPlateBtn);
            };
            this._turnPlateBtn = null;
            if (this._awardBtn)
            {
                ObjectUtils.disposeObject(this._awardBtn);
            };
            this._awardBtn = null;
            if (this._angelblessIcon)
            {
                ObjectUtils.disposeObject(this._angelblessIcon);
            };
            this._angelblessIcon = null;
            if (this._consortionCampaignBtn)
            {
                ObjectUtils.disposeObject(this._consortionCampaignBtn);
            };
            this._consortionCampaignBtn = null;
            if (this._weekendBtn)
            {
                ObjectUtils.disposeObject(this._weekendBtn);
                this._weekendBtn.removeEventListener(MouseEvent.CLICK, this.__weekendClick);
                this._weekendBtn = null;
            };
            if (this._mainPanelContent)
            {
                ObjectUtils.disposeObject(this._mainPanelContent);
                this._mainPanelContent = null;
            };
            if (this._mainBtnPanel)
            {
                ObjectUtils.disposeObject(this._mainBtnPanel);
                this._mainBtnPanel = null;
            };
            if (((!(_arg_1.getType() == StateType.DUNGEON_LIST)) && (!(_arg_1.getType() == StateType.ROOM_LIST))))
            {
                GameInSocketOut.sendExitScene();
            };
            if (this._renewal)
            {
                this._renewal.removeEventListener(FrameEvent.RESPONSE, this.__goRenewal);
                this._renewal.dispose();
                this._renewal = null;
            };
            if (this._consortionAwardBtn)
            {
                ObjectUtils.disposeObject(this._consortionAwardBtn);
                this._consortionAwardBtn = null;
            };
            if (this._firstChargeBtn)
            {
                this._firstChargeBtn.removeEventListener(MouseEvent.CLICK, this.__firstChargeClick);
                ObjectUtils.disposeObject(this._firstChargeBtn);
                this._firstChargeBtn = null;
            };
            RoomListController.Instance.removeEvent();
            DungeonListController.Instance.removeEvent();
            this._hallFatigueIconPoint = null;
            LivenessBubbleManager.Instance.hideBubble();
            super.leaving(_arg_1);
        }

        override public function prepare():void
        {
            super.prepare();
            this._isFirst = true;
        }

        override public function fadingComplete():void
        {
            var _local_1:SaveFileWidow;
            var _local_2:UpdateDescFrame;
            var _local_3:AddFavoriteFrame;
            super.fadingComplete();
            if (this._isFirst)
            {
                this._isFirst = false;
                this.tryShowClientDownload();
                if (((LoaderSavingManager.cacheAble == false) && (PlayerManager.Instance.Self.IsFirst > 1)))
                {
                    _local_1 = ComponentFactory.Instance.creatComponentByStylename("hall.SaveFileWidow");
                    _local_1.show();
                };
                LeavePageManager.setFavorite((PlayerManager.Instance.Self.IsFirst <= 1));
            };
            if (GradeExaltClewManager.getInstance().needShowDownloadClient)
            {
                this.tryShowClientDownload();
            };
            if (((UpdateController.Instance.lastNoticeBase) && (!(UpdateController.Instance.lastNoticeBase.BeginTime == SharedManager.Instance.showUpdateFrameDate))))
            {
                if ((!(SharedManager.Instance.hasShowUpdateFrame)))
                {
                    _local_2 = ComponentFactory.Instance.creatComponentByStylename("ddt.update.descFrame");
                    _local_2.show();
                };
            };
            if ((((VipController.instance.isShow) && (!(SharedManager.Instance.showVipCheckBtn))) && (VipController.instance.checkVipExpire())))
            {
                this.tryShowVip();
            };
            if (((!(SharedManager.Instance.isAddedToFavorite)) && (PathManager.isShowFavoriteAlert)))
            {
                _local_3 = ComponentFactory.Instance.creatComponentByStylename("hall.AddFavoriteFrame");
                _local_3.show();
            };
            this.checkLivenessDialog();
            this.checkShowWebGiftBox();
        }

        private function tryShowVip():void
        {
            if (DialogManager.Instance.showing)
            {
                setTimeout(this.tryShowVip, 100);
                return;
            };
            VipController.instance.showWhenPass();
            this.showDialog(57);
        }

        private function tryShowClientDownload(_arg_1:TaskEvent=null):void
        {
            if (((((PlayerManager.Instance.Self.Grade >= 11) && (TaskManager.instance.checkHasTaskById(500))) && (!(TaskManager.instance.isCompleted(TaskManager.instance.getQuestByID(500))))) && (!(this._clientDownloadFrame))))
            {
                GradeExaltClewManager.getInstance().needShowDownloadClient = false;
                this._showDownloadClient = true;
                this.showDialog(55);
            };
        }

        private function __closeClientDownloadFrame(_arg_1:Event):void
        {
            this._clientDownloadFrame.removeEventListener(Event.COMPLETE, this.__closeClientDownloadFrame);
            this._clientDownloadFrame = null;
        }

        override public function refresh():void
        {
            var _local_1:StageCurtain = new StageCurtain();
            _local_1.play(25);
            LayerManager.Instance.clearnGameDynamic();
            ShowTipManager.Instance.removeAllTip();
            this.enter(null);
        }

        private function checkDiamond():void
        {
            if (DiamondManager.instance.isInTencent)
            {
                DiamondManager.instance.addEventListener(Event.COMPLETE, this.__initTencentUI);
                DiamondManager.instance.loadUIModule();
            };
        }

        protected function __initTencentUI(_arg_1:Event):void
        {
            DiamondManager.instance.removeEventListener(Event.COMPLETE, this.__initTencentUI);
            this.checkShowWebGiftBox();
            DiamondManager.instance.firstEnterOpen();
            this.addButtonList();
        }

        protected function __diamondClick(_arg_1:MouseEvent):void
        {
            switch (_arg_1.target)
            {
                case this._diamondBtn:
                    if (PlayerManager.Instance.Self.isGetNewHandPack)
                    {
                        DiamondManager.instance.openDiamond();
                    }
                    else
                    {
                        DiamondManager.instance.openNewHand();
                    };
                    return;
                case this._intimateFriend:
                    LayerManager.Instance.addToLayer(ComponentFactory.Instance.creat("hall.closefriend.CloseFriend"), LayerManager.GAME_DYNAMIC_LAYER, true, 1);
                    return;
            };
        }

        private function getDiamondButtons():Array
        {
            if (PlayerManager.Instance.Self.Grade > 9)
            {
                if (((DiamondManager.instance.isInTencent) && (DiamondManager.instance.hasUI)))
                {
                    switch (DiamondManager.instance.pfType)
                    {
                        case DiamondType.YELLOW_DIAMOND:
                            if (PlayerManager.Instance.Self.isGetNewHandPack)
                            {
                                this._diamondBtn = ComponentFactory.Instance.creat("hall.ddt.view.diamondBtnI");
                            }
                            else
                            {
                                this._diamondBtn = ComponentFactory.Instance.creat("hall.ddt.view.diamondNewHandBtnI");
                            };
                            break;
                        case DiamondType.BLUE_DIAMOND:
                            if (PlayerManager.Instance.Self.isGetNewHandPack)
                            {
                                this._diamondBtn = ComponentFactory.Instance.creat("hall.ddt.view.diamondBtnII");
                            }
                            else
                            {
                                this._diamondBtn = ComponentFactory.Instance.creat("hall.ddt.view.diamondNewHandBtnII");
                            };
                            break;
                        case DiamondType.MEMBER_DIAMOND:
                            if (PlayerManager.Instance.Self.isGetNewHandPack)
                            {
                                this._diamondBtn = ComponentFactory.Instance.creat("hall.ddt.view.privilegedII");
                            }
                            else
                            {
                                this._diamondBtn = ComponentFactory.Instance.creat("hall.ddt.view.privilegedNewHandII");
                            };
                            break;
                    };
                    this._intimateFriend = ComponentFactory.Instance.creat("hall.ddt.view.intimateFriend");
                    this._diamondBtn.addEventListener(MouseEvent.CLICK, this.__diamondClick);
                    this._intimateFriend.addEventListener(MouseEvent.CLICK, this.__diamondClick);
                    return ([this._diamondBtn, this._intimateFriend]);
                };
            };
            return ([]);
        }

        private function checkShowWebGiftBox():void
        {
            if (((DiamondManager.instance.pfType == 2) && (PlayerManager.Instance.Self.Grade >= 3)))
            {
                this._webGiftBox = ComponentFactory.Instance.creat("hall.ddt.view.WebGiftButton");
                this._webGiftBox.addEventListener(MouseEvent.CLICK, this.__webGiftBoxClick);
                addChild(this._webGiftBox);
            };
        }

        private function __webGiftBoxClick(_arg_1:MouseEvent):void
        {
            SoundManager.instance.play("008");
            DiamondManager.instance.openBunFrame();
        }


    }
}//package hall

