package hall
{
   import CapabilityNoctice.CapabilityNocticeManager;
   import LimitAward.ConostionGoldAwardButton;
   import SingleDungeon.SingleDungeonManager;
   import activity.ActivityController;
   import activity.ActivityEvent;
   import activity.data.ActivityInfo;
   import auctionHouse.controller.AuctionHouseController;
   import auctionHouse.controller.AuctionHouseManager;
   import church.controller.ChurchRoomListController;
   import church.view.weddingRoomList.DivorcePromptFrame;
   import com.pickgliss.action.FunctionAction;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.loader.BaseLoader;
   import com.pickgliss.loader.LoadResourceManager;
   import com.pickgliss.loader.LoaderEvent;
   import com.pickgliss.loader.LoaderSavingManager;
   import com.pickgliss.loader.QueueLoader;
   import com.pickgliss.loader.RequestLoader;
   import com.pickgliss.manager.CacheSysManager;
   import com.pickgliss.toplevel.StageReferance;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.ComponentSetting;
   import com.pickgliss.ui.DialogManagerBase;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.ShowTipManager;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.controls.ScrollPanel;
   import com.pickgliss.ui.controls.SimpleBitmapButton;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.controls.container.VBox;
   import com.pickgliss.utils.ClassUtils;
   import com.pickgliss.utils.MD5;
   import com.pickgliss.utils.ObjectUtils;
   import consortion.ConsortionModelControl;
   import consortion.consortionsence.ConsortionManager;
   import ddt.bagStore.BagStore;
   import ddt.constants.CacheConsts;
   import ddt.data.TaskDirectorType;
   import ddt.data.UIModuleTypes;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.data.player.SelfInfo;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.events.LivenessEvent;
   import ddt.events.PlayerEvent;
   import ddt.events.TaskEvent;
   import ddt.events.TimeEvents;
   import ddt.loader.LoaderCreate;
   import ddt.loader.StartupResourceLoader;
   import ddt.manager.BallManager;
   import ddt.manager.BossBoxManager;
   import ddt.manager.ChatManager;
   import ddt.manager.ChurchManager;
   import ddt.manager.DialogManager;
   import ddt.manager.EdictumManager;
   import ddt.manager.GameInSocketOut;
   import ddt.manager.GradeExaltClewManager;
   import ddt.manager.KeyboardShortcutsManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.LeavePageManager;
   import ddt.manager.LoadBombManager;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PathManager;
   import ddt.manager.PetInfoManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SavePointManager;
   import ddt.manager.ServerConfigManager;
   import ddt.manager.SharedManager;
   import ddt.manager.ShopManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.manager.StateManager;
   import ddt.manager.TaskDirectorManager;
   import ddt.manager.TaskManager;
   import ddt.manager.TimeManager;
   import ddt.manager.TimerOpenManager;
   import ddt.manager.VoteManager;
   import ddt.states.BaseStateView;
   import ddt.states.StateType;
   import ddt.utils.PositionUtils;
   import ddt.view.BackgoundView;
   import ddt.view.DailyButtunBar;
   import ddt.view.MainToolBar;
   import ddt.view.bossbox.SmallBoxButton;
   import ddt.view.chat.ChatOutputView;
   import farm.FarmModelController;
   import fightRobot.FightRobotFrame;
   import fightToolBox.FightToolBoxController;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.net.URLVariables;
   import flash.utils.clearTimeout;
   import flash.utils.setTimeout;
   import game.view.stage.StageCurtain;
   import im.IMController;
   import liveness.DailyReceiveManager;
   import liveness.LivenessBubbleManager;
   import liveness.LivenessFrameView;
   import mainbutton.MainButtnController;
   import mainbutton.MainButton;
   import packagePurchaseBox.PackagePurchaseBoxController;
   import packagePurchaseBox.view.PackagePurchaseBoxFrame;
   import platformapi.tencent.DiamondManager;
   import platformapi.tencent.DiamondType;
   import quest.ClientDownloadFrame;
   import road7th.comm.PackageIn;
   import road7th.utils.MovieClipWrapper;
   import room.RoomManager;
   import roomList.pveRoomList.DungeonListController;
   import roomList.pvpRoomList.RoomListController;
   import shop.view.ShopRechargeEquipAlert;
   import shop.view.ShopRechargeEquipServer;
   import socialContact.friendBirthday.FriendBirthdayManager;
   import store.StrengthDataManager;
   import trainer.data.ArrowType;
   import trainer.view.NewHandContainer;
   import turnplate.TurnPlateController;
   import update.UpdateController;
   import update.UpdateDescFrame;
   import vip.VipController;
   import weekend.WeekendEvent;
   import weekend.WeekendManager;
   
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
      
      private var btnList:Array;
      
      private var _isFirst:Boolean;
      
      public function HallStateView()
      {
         this.btnList = new Array();
         super();
      }
      
      private function addpurchasepackageButtonList(param1:TimeEvents) : void
      {
         this.addButtonList();
      }
      
      private function __screenActive(param1:Event) : void
      {
         this._idleTime = 0;
         NewHandContainer.Instance.clearArrowByID(ArrowType.CLICK_LIVENESS);
      }
      
      private function __secondsCheck(param1:TimeEvents) : void
      {
         FarmModelController.instance.showFeildGain();
         ++this._idleTime;
         if(this._idleTime == 120 && PlayerManager.Instance.Self.Grade >= 13)
         {
            NewHandContainer.Instance.showArrow(ArrowType.CLICK_LIVENESS,-90,"trainer.posClickLiveness","","",this);
         }
      }
      
      override public function getType() : String
      {
         return StateType.MAIN;
      }
      
      override public function getBackType() : String
      {
         return StateType.MAIN;
      }
      
      override public function enter(param1:BaseStateView, param2:Object = null) : void
      {
         super.enter(param1,param2);
         StageReferance.stage.addEventListener(MouseEvent.MOUSE_DOWN,this.__screenActive);
         StageReferance.stage.addEventListener(MouseEvent.MOUSE_UP,this.__screenActive);
         StageReferance.stage.addEventListener(KeyboardEvent.KEY_DOWN,this.__screenActive);
         StageReferance.stage.addEventListener(KeyboardEvent.KEY_UP,this.__screenActive);
         SocketManager.Instance.out.SendexitConsortion();
         KeyboardShortcutsManager.Instance.setup();
         if(!RoomManager.Instance.findLoginRoom)
         {
            SocketManager.Instance.out.sendSceneLogin(1);
         }
         RoomManager.Instance.findLoginRoom = false;
         BackgoundView.Instance.show();
         if(_firstLoadDefaultBomb)
         {
            LoadResourceManager.instance.creatAndStartLoad(PathManager.solveBlastOut(BallManager.DEFAULT_BOMB_ID),BaseLoader.MODULE_LOADER);
            LoadResourceManager.instance.creatAndStartLoad(PathManager.solveBullet(BallManager.DEFAULT_BOMB_ID),BaseLoader.MODULE_LOADER);
            LoadBombManager.Instance.loadSpecialBomb();
            _firstLoadDefaultBomb = false;
         }
         this.initView();
         if(!SavePointManager.Instance.savePoints[1])
         {
            this.showDialog(11);
            TaskManager.instance.moduleLoad(true,this.taskLoadComplete);
         }
         this._firstFlag = false;
         this.checkDiamond();
      }
      
      override public function showDirect() : void
      {
         TaskDirectorManager.instance.showDirector(TaskDirectorType.MAIN);
      }
      
      private function taskLoadComplete() : void
      {
         SingleDungeonManager.Instance.loadModule(this.singleDungeonLoadComplete,null,true);
      }
      
      private function singleDungeonLoadComplete() : void
      {
         StateManager.createStateAsync(StateType.SINGLEDUNGEON,this.singleDungeonResComplete,true);
      }
      
      private function singleDungeonResComplete(param1:BaseStateView = null) : void
      {
      }
      
      private function sethallBg(param1:Boolean) : void
      {
         if(param1)
         {
            this._hallBG.play();
         }
         else
         {
            this._hallBG.stop();
         }
         this._hallBG.visible = param1;
      }
      
      private function initHall() : void
      {
         var _loc10_:QueueLoader = null;
         if(this._hallBG)
         {
            return;
         }
         this._hallBG = ClassUtils.CreatInstance("asset.hall.bgView") as MovieClip;
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
         this._auctionButton.addEventListener(MouseEvent.CLICK,this.__btnClick);
         this._churchButton.addEventListener(MouseEvent.CLICK,this.__btnClick);
         this._consortiaButton.addEventListener(MouseEvent.CLICK,this.__btnClick);
         this._dungeonButton.addEventListener(MouseEvent.CLICK,this.__btnClick);
         this._tofflistButton.addEventListener(MouseEvent.CLICK,this.__btnClick);
         this._roomListButton.addEventListener(MouseEvent.CLICK,this.__btnClick);
         this._shopButton.addEventListener(MouseEvent.CLICK,this.__btnClick);
         this._storeButton.addEventListener(MouseEvent.CLICK,this.__btnClick);
         this._farmButton.addEventListener(MouseEvent.CLICK,this.__btnClick);
         var _loc1_:Object = new Object();
         _loc1_["title"] = LanguageMgr.GetTranslation("ddt.hall.build.auctiontitle");
         _loc1_["content"] = LanguageMgr.GetTranslation("ddt.HallStateView.auction");
         this._auctionButton.tipData = _loc1_;
         var _loc2_:Object = new Object();
         _loc2_["title"] = LanguageMgr.GetTranslation("ddt.hall.build.roomtitle");
         _loc2_["content"] = LanguageMgr.GetTranslation("ddt.HallStateView.game");
         this._roomListButton.tipData = _loc2_;
         var _loc3_:Object = new Object();
         _loc3_["title"] = LanguageMgr.GetTranslation("ddt.hall.build.churchtitle");
         _loc3_["content"] = LanguageMgr.GetTranslation("ddt.HallStateView.church");
         this._churchButton.tipData = _loc3_;
         var _loc4_:Object = new Object();
         _loc4_["title"] = LanguageMgr.GetTranslation("ddt.hall.build.framtitle");
         _loc4_["content"] = LanguageMgr.GetTranslation("ddt.HallStateView.farm");
         this._farmButton.tipData = _loc4_;
         var _loc5_:Object = new Object();
         _loc5_["title"] = LanguageMgr.GetTranslation("ddt.hall.build.constriontitle");
         _loc5_["content"] = LanguageMgr.GetTranslation("ddt.HallStateView.consortion");
         this._consortiaButton.tipData = _loc5_;
         var _loc6_:Object = new Object();
         _loc6_["title"] = LanguageMgr.GetTranslation("ddt.hall.build.dungeontitle");
         _loc6_["content"] = LanguageMgr.GetTranslation("ddt.HallStateView.Dungeon");
         this._dungeonButton.tipData = _loc6_;
         var _loc7_:Object = new Object();
         _loc7_["title"] = LanguageMgr.GetTranslation("ddt.hall.build.storetitle");
         _loc7_["content"] = LanguageMgr.GetTranslation("ddt.HallStateView.store");
         this._storeButton.tipData = _loc7_;
         var _loc8_:Object = new Object();
         _loc8_["title"] = LanguageMgr.GetTranslation("ddt.hall.build.shoptitle");
         _loc8_["content"] = LanguageMgr.GetTranslation("ddt.HallStateView.Shop");
         this._shopButton.tipData = _loc8_;
         var _loc9_:Object = new Object();
         _loc9_["title"] = LanguageMgr.GetTranslation("ddt.hall.build.tofflisttitle");
         _loc9_["content"] = LanguageMgr.GetTranslation("ddt.HallStateView.toffist");
         this._tofflistButton.tipData = _loc9_;
         StartupResourceLoader.Instance.finishLoadingProgress();
         if(SavePointManager.Instance.savePoints[3])
         {
            StartupResourceLoader.Instance.addNotStartupNeededResource();
         }
         if(!SoundILoaded)
         {
            _loc10_ = new QueueLoader();
            _loc10_.addLoader(LoaderCreate.Instance.createAudioILoader());
            _loc10_.addLoader(LoaderCreate.Instance.createAudioIILoader());
            _loc10_.addEventListener(Event.COMPLETE,this.__onAudioLoadComplete);
            _loc10_.start();
         }
      }
      
      private function initView() : void
      {
         SoundManager.instance.playMusic("062",true,false);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.SHOW_DIALOG,this.__getDialogFromServer);
         TaskManager.instance.addEventListener(TaskEvent.BUILDING_REFLASH,this.setBuildState);
         this.initHall();
         this.sethallBg(true);
         this.setBuildState();
         MainToolBar.Instance.show();
         MainToolBar.Instance.state = StateType.MAIN;
         MainToolBar.Instance.btnOpen();
         MainToolBar.Instance.enabled = true;
         MainToolBar.Instance.setRoomStartState2(true);
         if(!this._isAddFrameComplete)
         {
            TaskManager.instance.checkHighLight();
         }
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
         CacheSysManager.getInstance().release(CacheConsts.ALERT_IN_FIGHT,1200);
         this.checkShowVipAlert_New();
         PlayerManager.Instance.addEventListener(PlayerManager.VIP_STATE_CHANGE,this.__isOpenBtn);
         this.checkShowStoreFromShop();
         StrengthDataManager.instance.setup();
         if(!this._isIMController && PathManager.CommunityExist())
         {
            this._isIMController = true;
            IMController.Instance.createConsortiaLoader();
         }
         if(SharedManager.Instance.divorceBoolean)
         {
            DivorcePromptFrame.Instance.show();
         }
         TaskManager.instance.addEventListener(TaskEvent.TASK_FRAME_HIDE,this.__taskFrameHide);
         this.loadWeakGuild();
         TaskManager.instance.checkNewHandTask();
         if(!this._isAddFrameComplete)
         {
            this.addFrame();
         }
         CacheSysManager.getInstance().singleRelease(CacheConsts.ALERT_IN_HALL);
         FriendBirthdayManager.Instance.findFriendBirthday();
         EdictumManager.Instance.showEdictum();
         if(!this._mainBtnPanel)
         {
            this._mainBtnPanel = ComponentFactory.Instance.creat("ddt.view.mainbtnpanel");
            this._mainBtnPanel.y = DailyButtunBar.Insance.height + 20;
         }
         addChild(this._mainBtnPanel);
         if(!this._mainPanelContent)
         {
            this._mainPanelContent = new VBox();
            this._mainPanelContent.strictSize = 75;
            this._mainPanelContent.height = this._mainBtnPanel.height;
         }
         var _loc1_:ActivityInfo = ActivityController.instance.checkHasFirstCharge();
         if(_loc1_)
         {
            ActivityController.instance.sendAskForActiviLog(_loc1_);
            PlayerManager.Instance.Self.addEventListener(PlayerEvent.MONEY_CHARGE,this.__moneyChargeHandle);
         }
         this._mainBtnPanel.setView(this._mainPanelContent);
         this._mainBtnPanel.vUnitIncrement = 56;
         this.addButtonList();
         this._mainBtnPanel.invalidateViewport();
         DailyReceiveManager.Instance.addEventListener(DailyReceiveManager.CLOSE_ICON,this.__closeIcon);
         TimeManager.addEventListener(TimeEvents.SECONDS,this.__secondsCheck);
         TaskManager.instance.addEventListener(TaskEvent.SHOW_DOWNLOAD_FRAME,this.tryShowClientDownload);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.ONLINE_REWADS,this.__closeAwardBtn);
         PlayerManager.Instance.Self.addEventListener(WeekendEvent.ENERGY_CHANGE,this.__weekendEnergyChange);
         if(this._firstFlag)
         {
            TimerOpenManager.Instance.firstLogin();
            PetInfoManager.instance.checkAllPetCanMagic();
         }
         CapabilityNocticeManager.instance.addNotice(CapabilityNocticeManager.ARENA_LEVEL,"ddt.view.CapabilityNocticeView.arenaPic",CapabilityNocticeManager.ARENA_NAME);
         CapabilityNocticeManager.instance.check();
         FightPowerAndFatigue.Instance.show();
         if(BossBoxManager.instance.isHaveBox())
         {
            if(this._timerBox == null)
            {
               this._timerBox = new SmallBoxButton(1);
            }
            addChild(this._timerBox);
         }
         if(!PlayerManager.Instance.Self.isAward && !PlayerManager.Instance.Self.isFristShow)
         {
            this.initDailyReceiveFrame();
         }
      }
      
      private function initDailyReceiveFrame() : void
      {
         PlayerManager.Instance.Self.isFristShow = true;
         DailyReceiveManager.Instance.show();
      }
      
      private function __closeAwardBtn(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:int = param1.pkg.readInt();
         if(_loc2_ == 1)
         {
            if(this._consortionAwardBtn)
            {
               ObjectUtils.disposeObject(this._consortionAwardBtn);
               this._consortionAwardBtn = null;
            }
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.consortion.AwardTips"));
            this.addButtonList();
         }
         else if(_loc2_ == 2)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.consortion.AwardTipsI"));
         }
      }
      
      private function __onEnterSingleClick(param1:MouseEvent) : void
      {
         StateManager.setState(StateType.SINGLEDUNGEON);
      }
      
      private function addButtonList() : void
      {
         var _loc2_:MainButton = null;
         var _loc3_:Array = null;
         var _loc4_:BaseButton = null;
         var _loc5_:Sprite = null;
         var _loc6_:Point = null;
         var _loc7_:Point = null;
         if(!this._mainPanelContent)
         {
            return;
         }
         this._mainPanelContent.disposeAllChildren();
         var _loc1_:Vector.<MainButton> = MainButtnController.instance.test();
         if(!_loc1_)
         {
            return;
         }
         this.btnList = new Array();
         for each(_loc2_ in _loc1_)
         {
            if(_loc2_.btnServerVisable == 1)
            {
               if(_loc2_.btnCompleteVisable == 1)
               {
                  _loc5_ = this.getButton(_loc2_.btnMark);
                  if(_loc5_)
                  {
                     this._mainPanelContent.addChild(_loc5_);
                     this.btnList.push(_loc5_);
                  }
               }
            }
         }
         _loc3_ = this.getDiamondButtons();
         for each(_loc4_ in _loc3_)
         {
            this._mainPanelContent.addChild(_loc4_);
            this.btnList.push(_loc4_);
         }
         if(this._mainPanelContent.numChildren <= 5)
         {
            this._mainBtnPanel.vScrollbar.increaseButton.visible = false;
            this._mainBtnPanel.vScrollbar.decreaseButton.visible = false;
         }
         else
         {
            this._mainBtnPanel.vScrollbar.increaseButton.visible = true;
            this._mainBtnPanel.vScrollbar.decreaseButton.visible = true;
            this._mainBtnPanel.vScrollbar.increaseButton.addEventListener(MouseEvent.CLICK,this.__soundPlay);
            this._mainBtnPanel.vScrollbar.decreaseButton.addEventListener(MouseEvent.CLICK,this.__soundPlay);
         }
         this._mainBtnPanel.invalidateViewport();
         if(this._goSignBtn)
         {
            _loc6_ = this._mainBtnPanel.displayObjectViewport.localToGlobal(new Point(0,0));
            _loc7_ = new Point(_loc6_.x + this._goSignBtn.x - 83,_loc6_.y + this._goSignBtn.y);
            LivenessBubbleManager.Instance.setPos(_loc7_);
            LivenessBubbleManager.Instance.tryShowBubble();
         }
      }
      
      private function __soundPlay(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
      }
      
      private function getButton(param1:int) : Sprite
      {
         var _loc2_:Sprite = null;
         switch(param1)
         {
            case 1:
               this.initActivity();
               this._activityIcon.buttonMode = true;
               _loc2_ = this._activityIcon;
               break;
            case 2:
               break;
            case 3:
               if(!PlayerManager.Instance.Self.IsVIP || PlayerManager.Instance.Self.VIPtype == 0)
               {
                  this.initVip();
                  this._vipIcon.buttonMode = true;
                  _loc2_ = this._vipIcon;
               }
               break;
            case 5:
               this.initGoSignBtn();
               this._goSignBtn.buttonMode = true;
               _loc2_ = this._goSignBtn;
               break;
            case 6:
               this.initAward();
               this._awardBtn.buttonMode = true;
               _loc2_ = this._awardBtn;
               break;
            case 7:
               break;
            case 8:
               this.intFightBtn();
               _loc2_ = this._fightBtn;
               break;
            case 9:
               break;
            case 10:
               if(this.checkpurchaseStone())
               {
                  this.intPackagePurchaseBtn();
                  _loc2_ = this._packagePurchaseBtn;
               }
               break;
            case 11:
               this.initAwardBtn();
               _loc2_ = this._consortionAwardBtn;
               break;
            case 12:
               this.initFirstChargeBtn();
               _loc2_ = this._firstChargeBtn;
               break;
            case 13:
               this.initWeekendBtn();
               _loc2_ = this._weekendBtn;
               break;
            case 14:
               this.initTurnPlateBtn();
               _loc2_ = this._turnPlateBtn;
               break;
            case 15:
               this.initFightRobotBtn();
               _loc2_ = this._fightRobotBtn;
               break;
            case 16:
               this.initDailyReceiveBtn();
               _loc2_ = this._dailyReceiveIcon;
         }
         return _loc2_;
      }
      
      private function intPackagePurchaseBtn() : void
      {
         if(!this._packagePurchaseBtn)
         {
            this._packagePurchaseBtn = ComponentFactory.Instance.creat("asset.hallView.packagePurchaseBtn");
            this._packagePurchaseBtn.addEventListener(MouseEvent.CLICK,this.__openPackagePurchaseBox);
         }
         this._packagePurchaseBtn.x = 3;
         this._packagePurchaseBtn.buttonMode = true;
      }
      
      private function __openPackagePurchaseBox(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         PackagePurchaseBoxController.instance.show();
      }
      
      private function intFightBtn() : void
      {
         if(!this._fightBtn)
         {
            this._fightBtn = ComponentFactory.Instance.creat("asset.hallView.fightBtn");
            this._fightBtn.addEventListener(MouseEvent.CLICK,this.__openFightToolBox);
         }
         PositionUtils.setPos(ComponentFactory.Instance.creatCustomObject("asset.hallView。btnPos.fighttoolbox"),this._fightBtn);
         this._fightBtn.x = 8;
         this._fightBtn.buttonMode = true;
      }
      
      private function checkpurchaseStone() : Boolean
      {
         var _loc1_:uint = PackagePurchaseBoxController.instance.measureList(ShopManager.Instance.getValidSortedGoodsByType(PackagePurchaseBoxFrame.PURCHASEPACKAGEBOX,1)).length;
         if(_loc1_ <= 0)
         {
            return false;
         }
         return true;
      }
      
      private function initVip() : void
      {
         if(!this._vipIcon)
         {
            this._vipIcon = ComponentFactory.Instance.creat("asset.hallView.VIPLvl");
            this._vipIcon.VIPCharge.buttonMode = true;
            this._vipIcon.buttonMode = true;
            this._vipIcon.addEventListener(MouseEvent.CLICK,this.__OpenVipView);
         }
         this.checkVipShine();
      }
      
      private function checkVipShine() : void
      {
         this._vipIcon.movie.buttonMode = true;
         if(PlayerManager.Instance.geticonShine("_vipIcon"))
         {
            this._vipIcon.movie.visible = true;
         }
         else
         {
            this._vipIcon.movie.visible = false;
         }
      }
      
      private function initActivity() : void
      {
         if(!this._activityIcon)
         {
            this._activityIcon = ClassUtils.CreatInstance("asset.hallView.activity") as MovieClip;
            this._activityIcon.addEventListener(MouseEvent.CLICK,this.__openActivityView);
            ActivityController.instance.model.addEventListener(ActivityEvent.ACTIVITY_UPDATE,this.__updateActivity);
         }
         this.checkAcitvityIconShine();
         this._activityIcon.image.buttonMode = true;
         this._activityIcon.buttonMode = true;
         this.checkActivityImage();
      }
      
      private function __updateActivity(param1:ActivityEvent) : void
      {
         this.checkActivityImage();
      }
      
      private function checkActivityImage() : void
      {
         if(ActivityController.instance.checkHasOpenActivity())
         {
            this._activityIcon.image.gotoAndStop(2);
         }
         else
         {
            this._activityIcon.image.gotoAndStop(1);
         }
      }
      
      private function checkAcitvityIconShine() : void
      {
         this._activityIcon.movie.buttonMode = true;
         if(PlayerManager.Instance.geticonShine("_activityIcon"))
         {
            this._activityIcon.movie.visible = true;
         }
         else
         {
            this._activityIcon.movie.visible = false;
         }
      }
      
      private function initFightRobotBtn() : void
      {
         if(!this._fightRobotBtn)
         {
            this._fightRobotBtn = ClassUtils.CreatInstance("asset.hallView.fightRobot") as MovieClip;
            this._fightRobotBtn.addEventListener(MouseEvent.CLICK,this.__onFightRobotClick);
            this._fightRobotBtn.image.buttonMode = true;
            this._fightRobotBtn.movie.buttonMode = true;
            this.CheckFightRobotIconShine();
         }
      }
      
      private function CheckFightRobotIconShine() : void
      {
         if(PlayerManager.Instance.geticonShine("_fightRobotBtn"))
         {
            this._fightRobotBtn.movie.visible = true;
         }
         else
         {
            this._fightRobotBtn.movie.visible = false;
         }
      }
      
      private function initTurnPlateBtn() : void
      {
         if(!this._turnPlateBtn)
         {
            this._turnPlateBtn = ClassUtils.CreatInstance("asset.hallView.turnplateMovie") as MovieClip;
            this._turnPlateBtn.addEventListener(MouseEvent.CLICK,this.__onTurnPlateClick);
            this._turnPlateBtn.image.buttonMode = true;
            this._turnPlateBtn.movie.buttonMode = true;
            TurnPlateController.Instance.addEventListener(TurnPlateController.STATE_CHANGE,this.__turnPlateIconShine);
            this.__turnPlateIconShine();
         }
      }
      
      private function __turnPlateIconShine(param1:Event = null) : void
      {
         this._turnPlateBtn.movie.buttonMode = true;
         if(TurnPlateController.Instance.isOpen)
         {
            this._turnPlateBtn.movie.visible = true;
         }
         else
         {
            this._turnPlateBtn.movie.visible = false;
         }
      }
      
      private function initDailyReceiveBtn() : void
      {
         if(!this._dailyReceiveIcon)
         {
            this._dailyReceiveIcon = ClassUtils.CreatInstance("asset.hallView.dailyMovie") as MovieClip;
            this._dailyReceiveIcon.addEventListener(MouseEvent.CLICK,this.__ondailyClick);
            this._dailyReceiveIcon.image.buttonMode = true;
            this._dailyReceiveIcon.movie.buttonMode = true;
            this.checkDailyReceiveShine();
         }
      }
      
      private function __closeIcon(param1:Event) : void
      {
         if(this._dailyReceiveIcon)
         {
            ObjectUtils.disposeObject(this._dailyReceiveIcon);
            this._dailyReceiveIcon = null;
            this.addButtonList();
         }
      }
      
      private function initGoSignBtn() : void
      {
         if(!this._goSignBtn)
         {
            this._goSignBtn = ClassUtils.CreatInstance("asset.hallView.signMovie") as MovieClip;
            this._goSignBtn.addEventListener(MouseEvent.CLICK,this.__onSignClick);
            this._goSignBtn.image.buttonMode = true;
            this._goSignBtn.movie.buttonMode = true;
            LivenessBubbleManager.Instance.addEventListener(LivenessEvent.SHOW_SHINE,this.__signIconShine);
         }
         if(LivenessBubbleManager.Instance.needShine || !LivenessBubbleManager.Instance.hasClickIcon)
         {
            this.__signIconShine(new LivenessEvent(LivenessEvent.SHOW_SHINE,true));
         }
         else
         {
            this.__signIconShine(new LivenessEvent(LivenessEvent.SHOW_SHINE,false));
         }
      }
      
      private function __signIconShine(param1:LivenessEvent) : void
      {
         this._goSignBtn.movie.buttonMode = true;
         if(Boolean(param1.info))
         {
            this._goSignBtn.movie.visible = true;
         }
         else
         {
            this._goSignBtn.movie.visible = false;
         }
      }
      
      private function initAwardBtn() : void
      {
         if(this._consortionAwardBtn)
         {
            ObjectUtils.disposeObject(this._consortionAwardBtn);
            this._consortionAwardBtn = null;
         }
         this._consortionAwardBtn = ComponentFactory.Instance.creatComponentByStylename("ddt.ConostionGoldAwardButton");
      }
      
      private function initFirstChargeBtn() : void
      {
         if(PlayerManager.Instance.Self.Grade < 1 || PlayerManager.Instance.Self.Grade > 29)
         {
            return;
         }
         var _loc1_:ActivityInfo = ActivityController.instance.checkHasFirstCharge();
         if(_loc1_ && ActivityController.instance.model.getLog(_loc1_.ActivityId) == 0 && !this._firstChargeBtn)
         {
            if(!this._firstChargeBtn)
            {
               this._firstChargeBtn = ComponentFactory.Instance.creat("asset.hallView.firstCharge");
               this._firstChargeBtn.addEventListener(MouseEvent.CLICK,this.__firstChargeClick);
               this._firstChargeBtn.buttonMode = true;
               this._firstChargeBtn.firstChargeMC.buttonMode = true;
            }
            this.checkFirstOpenIconShine();
         }
      }
      
      private function checkFirstOpenIconShine() : void
      {
         this._firstChargeBtn.movie.buttonMode = true;
         if(PlayerManager.Instance.geticonShine("_firstChargeBtn"))
         {
            this._firstChargeBtn.movie.visible = true;
         }
         else
         {
            this._firstChargeBtn.movie.visible = false;
         }
      }
      
      private function __firstChargeClick(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         PlayerManager.Instance.setIconShine("_firstChargeBtn",false);
         this.checkFirstOpenIconShine();
         ActivityController.instance.showFirstRechargeView();
      }
      
      private function initWeekendBtn() : void
      {
         if(!this._weekendBtn)
         {
            this._weekendBtn = ComponentFactory.Instance.creat("asset.hallView.weekend") as MovieClip;
            this._weekendBtn.buttonMode = true;
            this._weekendBtn.addEventListener(MouseEvent.CLICK,this.__weekendClick);
            addChild(this._weekendBtn);
         }
         this.checkWeekendShine();
      }
      
      private function __weekendEnergyChange(param1:WeekendEvent) : void
      {
         this.addButtonList();
      }
      
      private function __weekendClick(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         WeekendManager.instance.show();
         PlayerManager.Instance.setIconShine("_weekendBtn",false);
         this.checkWeekendShine();
      }
      
      private function checkWeekendShine() : void
      {
         this._weekendBtn.movie.buttonMode = true;
         if(PlayerManager.Instance.geticonShine("_weekendBtn"))
         {
            this._weekendBtn.movie.visible = true;
         }
         else
         {
            this._weekendBtn.movie.visible = false;
         }
      }
      
      private function __onTurnPlateClick(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         TurnPlateController.Instance.show();
      }
      
      private function __onFightRobotClick(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         var _loc2_:FightRobotFrame = ComponentFactory.Instance.creatCustomObject("ddt.fightRobot.frame");
         _loc2_.show();
         PlayerManager.Instance.setIconShine("_fightRobotBtn",false);
         this.CheckFightRobotIconShine();
      }
      
      private function __ondailyClick(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         DailyReceiveManager.Instance.show();
         PlayerManager.Instance.setIconShine("_dailyReceiveIcon",false);
         this.checkDailyReceiveShine();
      }
      
      private function checkDailyReceiveShine() : void
      {
         if(PlayerManager.Instance.geticonShine("_dailyReceiveIcon"))
         {
            this._dailyReceiveIcon.movie.visible = true;
         }
         else
         {
            this._dailyReceiveIcon.movie.visible = false;
         }
      }
      
      private function __onSignClick(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         NewHandContainer.Instance.clearArrowByID(ArrowType.CLICK_LIVENESS);
         if(SavePointManager.Instance.isInSavePoint(75))
         {
            SavePointManager.Instance.setSavePoint(75);
         }
         LivenessBubbleManager.Instance.hasClickIcon = true;
         if(!LivenessBubbleManager.Instance.needShine)
         {
            this.__signIconShine(new LivenessEvent(LivenessEvent.SHOW_SHINE,false));
         }
         var _loc2_:LivenessFrameView = ComponentFactory.Instance.creatCustomObject("liveness.hall.livenessFrameView");
         _loc2_.show();
      }
      
      private function initAward() : void
      {
         if(!this._awardBtn)
         {
            this._awardBtn = ComponentFactory.Instance.creat("asset.hallView.ActivityIcon");
         }
         this._awardBtn.x = 8;
         this._awardBtn.buttonMode = true;
         this._awardBtn.addEventListener(MouseEvent.CLICK,this.__OpenView);
      }
      
      private function __OpenView(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         MainButtnController.instance.show(MainButtnController.DDT_AWARD);
         MainButtnController.instance.addEventListener(MainButtnController.ICONCLOSE,this.__iconClose);
      }
      
      private function __openActivityView(param1:Event) : void
      {
         SoundManager.instance.play("008");
         ActivityController.instance.showFrame();
         PlayerManager.Instance.setIconShine("_activityIcon",false);
         this.checkAcitvityIconShine();
      }
      
      private function __isOpenBtn(param1:Event) : void
      {
         this.addButtonList();
         if(this._awardBtn)
         {
            this._awardBtn.visible = true;
         }
         this.initVip();
         if(VipController.instance.isShow && !SharedManager.Instance.showVipCheckBtn && VipController.instance.checkVipExpire())
         {
            this.tryShowVip();
         }
      }
      
      private function __iconClose(param1:Event) : void
      {
         if(PlayerManager.Instance.Self.IsVIP)
         {
            if(!PlayerManager.Instance.Self.canTakeVipReward && !MainButtnController.instance.DailyAwardState)
            {
               this._awardBtn.visible = false;
               this.addButtonList();
            }
         }
         else if(!MainButtnController.instance.DailyAwardState)
         {
            this._awardBtn.visible = false;
            this.addButtonList();
         }
      }
      
      private function __OpenVipView(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         VipController.instance.show();
         PlayerManager.Instance.setIconShine("_vipIcon",false);
         this.checkVipShine();
      }
      
      private function __openFightToolBox(param1:MouseEvent) : void
      {
         SoundManager.instance.playButtonSound();
         FightToolBoxController.instance.show();
      }
      
      private function __onAudioIILoadComplete(param1:LoaderEvent) : void
      {
         param1.loader.removeEventListener(LoaderEvent.COMPLETE,this.__onAudioIILoadComplete);
         SoundManager.instance.setupAudioResource(true);
         SoundIILoaded = true;
      }
      
      private function __onAudioLoadComplete(param1:Event) : void
      {
         param1.currentTarget.removeEventListener(Event.COMPLETE,this.__onAudioLoadComplete);
         SoundManager.instance.setupAudioResource(false);
         SoundILoaded = true;
      }
      
      private function __OpenlittleGame(param1:MouseEvent) : void
      {
         StateManager.setState(StateType.LITTLEHALL);
      }
      
      private function setBuildState(param1:TaskEvent = null) : void
      {
         var _loc2_:Array = SavePointManager.Instance.savePoints;
         this._dungeonButton.visible = true;
         if(_loc2_[35])
         {
            if(SavePointManager.Instance.isInSavePoint(44))
            {
               if(this._buildingMask)
               {
                  return;
               }
               this.createBuildingMask();
               this._hallBG.addChild(this._buildingMask);
               this.buildingMovie = new MovieClipWrapper(ComponentFactory.Instance.creatCustomObject("asset.hall.storeHouseMovie"),true,true);
               this._hallBG.addChild(this.buildingMovie.movie);
               this.buildingMovie.addEventListener(Event.COMPLETE,this.buttonAppear(this._storeButton,44));
            }
            else
            {
               this._storeButton.visible = true;
            }
         }
         if(_loc2_[13])
         {
            if(SavePointManager.Instance.isInSavePoint(45))
            {
               if(this._buildingMask)
               {
                  return;
               }
               this.createBuildingMask();
               this._hallBG.addChild(this._buildingMask);
               this.buildingMovie = new MovieClipWrapper(ComponentFactory.Instance.creatCustomObject("asset.hall.gameRoomHouseMovie"),true,true);
               this._hallBG.addChild(this.buildingMovie.movie);
               this.buildingMovie.addEventListener(Event.COMPLETE,this.buttonAppear(this._roomListButton,45));
            }
            else
            {
               this._roomListButton.visible = true;
            }
         }
         if(_loc2_[14])
         {
            if(SavePointManager.Instance.isInSavePoint(46))
            {
               if(this._buildingMask)
               {
                  return;
               }
               this.createBuildingMask();
               this._hallBG.addChild(this._buildingMask);
               this.buildingMovie = new MovieClipWrapper(ComponentFactory.Instance.creatCustomObject("asset.hall.shopHouseMovie"),true,true);
               this._hallBG.addChild(this.buildingMovie.movie);
               this.buildingMovie.addEventListener(Event.COMPLETE,this.buttonAppear(this._shopButton,46));
            }
            else
            {
               this._shopButton.visible = true;
            }
         }
         if(_loc2_[24])
         {
            if(SavePointManager.Instance.isInSavePoint(47))
            {
               if(this._buildingMask)
               {
                  return;
               }
               this.createBuildingMask();
               this._hallBG.addChild(this._buildingMask);
               this.buildingMovie = new MovieClipWrapper(ComponentFactory.Instance.creatCustomObject("asset.hall.framHouseMovie"),true,true);
               this._hallBG.addChild(this.buildingMovie.movie);
               this.buildingMovie.addEventListener(Event.COMPLETE,this.buttonAppear(this._farmButton,47));
            }
            else
            {
               this._farmButton.visible = true;
            }
         }
         if(_loc2_[73])
         {
            if(SavePointManager.Instance.isInSavePoint(28))
            {
               if(this._buildingMask)
               {
                  return;
               }
               this.createBuildingMask();
               this._hallBG.addChild(this._buildingMask);
               this.buildingMovie = new MovieClipWrapper(ComponentFactory.Instance.creatCustomObject("asset.hall.auctionHouseMovie"),true,true);
               this._hallBG.addChild(this.buildingMovie.movie);
               this.buildingMovie.addEventListener(Event.COMPLETE,this.buttonAppear(this._auctionButton));
               this.buildingMovieI = new MovieClipWrapper(ComponentFactory.Instance.creatCustomObject("asset.hall.churchHouseMovie"),true,true);
               this._hallBG.addChild(this.buildingMovieI.movie);
               this.buildingMovieI.addEventListener(Event.COMPLETE,this.buttonAppear(this._churchButton));
               this.buildingMovieII = new MovieClipWrapper(ComponentFactory.Instance.creatCustomObject("asset.hall.tofflistHouseMovie"),true,true);
               this._hallBG.addChild(this.buildingMovieII.movie);
               this.buildingMovieII.addEventListener(Event.COMPLETE,this.buttonAppear(this._tofflistButton,28));
            }
            else
            {
               this._auctionButton.visible = true;
               this._churchButton.visible = true;
               this._tofflistButton.visible = true;
               if(PlayerManager.Instance.Self.Grade >= 15)
               {
                  this._consortiaButton.visible = true;
               }
            }
         }
         this.loadUserGuide();
         this.loadWeakGuild();
      }
      
      private function createBuildingMask() : void
      {
         this._buildingMask = new Sprite();
         this._buildingMask.graphics.beginFill(0,0.5);
         this._buildingMask.graphics.drawRect(0,0,1000,600);
         this._buildingMask.graphics.endFill();
      }
      
      private function buttonAppear(param1:BaseButton = null, param2:uint = 0.0) : Function
      {
         var btn:BaseButton = param1;
         var savePoint:uint = param2;
         var fun:Function = function(param1:Event):void
         {
            if(savePoint)
            {
               SavePointManager.Instance.setSavePoint(savePoint);
               checkLivenessDialog();
            }
            if(_buildingMask)
            {
               _buildingMask.graphics.clear();
               if(_buildingMask.parent)
               {
                  _buildingMask.parent.removeChild(_buildingMask);
               }
               _buildingMask = null;
            }
            var _loc2_:MovieClipWrapper = param1.currentTarget as MovieClipWrapper;
            _loc2_.removeEventListener(Event.COMPLETE,buttonAppear(btn,savePoint));
            _loc2_ = null;
            if(!_hallBG)
            {
               return;
            }
            btn.visible = true;
         };
         return fun;
      }
      
      private function checkLivenessDialog() : void
      {
         if(DialogManager.Instance.showing)
         {
            this._livenessDialogTimeout = setTimeout(this.checkLivenessDialog,500);
         }
         else if(SavePointManager.Instance.isInSavePoint(77))
         {
            this.showDialog(58);
         }
      }
      
      private function addFrame() : void
      {
         if(this._isAddFrameComplete)
         {
            return;
         }
         if(TimeManager.Instance.TotalDaysToNow(PlayerManager.Instance.Self.LastDate as Date) >= 30 && PlayerManager.Instance.Self.isOldPlayerHasValidEquitAtLogin && !PlayerManager.Instance.Self.isOld)
         {
            CacheSysManager.getInstance().cacheFunction(CacheConsts.ALERT_IN_HALL,new FunctionAction(new ShopRechargeEquipServer().show));
         }
         else if(PlayerManager.Instance.Self.OvertimeListByBody.length > 0)
         {
            CacheSysManager.getInstance().cacheFunction(CacheConsts.ALERT_IN_HALL,new FunctionAction(new ShopRechargeEquipAlert().show));
         }
         else
         {
            InventoryItemInfo.startTimer();
         }
         this._isAddFrameComplete = true;
      }
      
      private function loadWeakGuild() : void
      {
         if(SavePointManager.Instance.isInSavePoint(16) && !TaskManager.instance.isNewHandTaskCompleted(12) || SavePointManager.Instance.isInSavePoint(26) && !TaskManager.instance.isNewHandTaskCompleted(23) || SavePointManager.Instance.isInSavePoint(67) && !TaskManager.instance.isNewHandTaskCompleted(28) || SavePointManager.Instance.savePoints[35] && !SavePointManager.Instance.savePoints[9] && !TaskManager.instance.isNewHandTaskCompleted(7))
         {
            NewHandContainer.Instance.showArrow(ArrowType.HALL_BUILD,135,"trainer.storeArrowPos","asset.trainer.txtClickEnter","trainer.storeTipPos",this);
         }
         if(SavePointManager.Instance.isInSavePoint(14) && !TaskManager.instance.isNewHandTaskCompleted(10) || SavePointManager.Instance.isInSavePoint(17) && !TaskManager.instance.isNewHandTaskCompleted(13) || SavePointManager.Instance.isInSavePoint(18) && !TaskManager.instance.isNewHandTaskCompleted(14) || SavePointManager.Instance.isInSavePoint(55) && !TaskManager.instance.isNewHandTaskCompleted(27))
         {
            NewHandContainer.Instance.showArrow(ArrowType.HALL_BUILD,135,"trainer.gameRoomArrowPos","asset.trainer.txtClickEnter","trainer.gameRoomTipPos",this);
         }
         if(SavePointManager.Instance.isInSavePoint(15) && !TaskManager.instance.isNewHandTaskCompleted(11))
         {
            NewHandContainer.Instance.showArrow(ArrowType.HALL_BUILD,0,"trainer.shopArrowPos","asset.trainer.txtClickEnter","trainer.shopTipPos",this);
         }
         if(SavePointManager.Instance.isInSavePoint(4) && !TaskManager.instance.isNewHandTaskCompleted(2) && SavePointManager.Instance.savePoints[33] && SavePointManager.Instance.savePoints[64] || SavePointManager.Instance.isInSavePoint(6) && (!TaskManager.instance.isNewHandTaskCompleted(4) || !TaskManager.instance.isNewHandTaskCompleted(5)) || SavePointManager.Instance.isInSavePoint(8) && !TaskManager.instance.isNewHandTaskCompleted(26) || SavePointManager.Instance.isInSavePoint(10) && !TaskManager.instance.isNewHandTaskCompleted(6) || SavePointManager.Instance.isInSavePoint(11) && !TaskManager.instance.isNewHandTaskCompleted(3) || TaskManager.instance.isNewHandTaskAchieved(6) && SavePointManager.Instance.isInSavePoint(40) || SavePointManager.Instance.isInSavePoint(19) && !TaskManager.instance.isNewHandTaskCompleted(15) || SavePointManager.Instance.isInSavePoint(22) && !TaskManager.instance.isNewHandTaskCompleted(18) || SavePointManager.Instance.isInSavePoint(12) && (!TaskManager.instance.isNewHandTaskCompleted(8) && !TaskManager.instance.isNewHandTaskAchieved(8) || !TaskManager.instance.isNewHandTaskCompleted(9) && !TaskManager.instance.isNewHandTaskAchieved(9)) || SavePointManager.Instance.isInSavePoint(23) && (!TaskManager.instance.isNewHandTaskCompleted(19) && !TaskManager.instance.isNewHandTaskAchieved(19) || !TaskManager.instance.isNewHandTaskCompleted(20) && !TaskManager.instance.isNewHandTaskAchieved(20)) || SavePointManager.Instance.isInSavePoint(25) && !TaskManager.instance.isNewHandTaskCompleted(22) || SavePointManager.Instance.isInSavePoint(27) && (!TaskManager.instance.isNewHandTaskCompleted(24) && !TaskManager.instance.isNewHandTaskAchieved(24) || !TaskManager.instance.isNewHandTaskCompleted(25) && !TaskManager.instance.isNewHandTaskAchieved(25)))
         {
            NewHandContainer.Instance.showArrow(ArrowType.HALL_BUILD,-45,"trainer.dungeonArrowPos","asset.trainer.txtClickEnter","trainer.dungeonTipPos",this);
         }
         if(SavePointManager.Instance.isInSavePoint(47) || SavePointManager.Instance.isInSavePoint(48) && !TaskManager.instance.isNewHandTaskCompleted(21))
         {
            NewHandContainer.Instance.showArrow(ArrowType.IN_FARM,45,"trainer.farmArrowPos","asset.trainer.txtClickEnter","trainer.farmTipPos",this);
         }
         if(SavePointManager.Instance.isInSavePoint(34))
         {
            this.showDialog(13);
         }
      }
      
      private function __taskFrameHide(param1:TaskEvent) : void
      {
         this.loadWeakGuild();
      }
      
      private function __getDialogFromServer(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:PackageIn = param1.pkg;
         var _loc3_:int = _loc2_.readInt();
         this.showDialog(_loc3_);
      }
      
      private function showDialog(param1:uint) : void
      {
         this.hideBottomUI();
         LayerManager.Instance.addToLayer(DialogManager.Instance.DialogBox,LayerManager.STAGE_TOP_LAYER);
         DialogManager.Instance.addEventListener(Event.COMPLETE,this.__dialogEndCallBack);
         DialogManager.Instance.addEventListener(DialogManagerBase.READY_TO_CLOSE,this.__dialogReadyToClose);
         DialogManager.Instance.showDialog(param1);
      }
      
      private function __dialogReadyToClose(param1:Event) : void
      {
         DialogManager.Instance.removeEventListener(DialogManagerBase.READY_TO_CLOSE,this.__dialogReadyToClose);
         this.showBottomUI();
      }
      
      private function __dialogEndCallBack(param1:Event) : void
      {
         DialogManager.Instance.removeEventListener(Event.COMPLETE,this.__dialogEndCallBack);
         if(!SavePointManager.Instance.savePoints[1])
         {
            MainToolBar.Instance.showIconAppear(0);
            MainToolBar.Instance.showIconAppear(1);
            MainToolBar.Instance.showIconAppear(3);
         }
         if(SavePointManager.Instance.isInSavePoint(34))
         {
            SavePointManager.Instance.setSavePoint(34);
            NewHandContainer.Instance.showArrow(ArrowType.HALL_BUILD,-45,"trainer.dungeonArrowPos","asset.trainer.txtClickEnter","trainer.dungeonTipPos");
         }
         if(SavePointManager.Instance.isInSavePoint(40))
         {
            SavePointManager.Instance.setSavePoint(40);
            NewHandContainer.Instance.showArrow(ArrowType.HALL_BUILD,-45,"trainer.dungeonArrowPos","asset.trainer.txtClickEnter","trainer.dungeonTipPos",this);
         }
         if(this._showDownloadClient)
         {
            this._showDownloadClient = false;
            this._clientDownloadFrame = ComponentFactory.Instance.creatCustomObject("asset.quest.clientDownloadFrame");
            this._clientDownloadFrame.addEventListener(Event.COMPLETE,this.__closeClientDownloadFrame);
            this._clientDownloadFrame.show();
         }
         if(SavePointManager.Instance.isInSavePoint(77))
         {
            SavePointManager.Instance.setSavePoint(77);
            NewHandContainer.Instance.showArrow(ArrowType.CLICK_TASK,0,"trainer.posClickTask","asset.trainer.txtClickEnter","trainer.posClickTaskTxt",MainToolBar.Instance);
         }
      }
      
      private function hideBottomUI() : void
      {
         MainToolBar.Instance.hide();
         ChatManager.Instance.view.visible = false;
      }
      
      private function showBottomUI() : void
      {
         MainToolBar.Instance.show();
         ChatManager.Instance.view.visible = true;
      }
      
      private function checkShowVote() : void
      {
         if(VoteManager.Instance.showVote)
         {
            VoteManager.Instance.addEventListener(VoteManager.LOAD_COMPLETED,this.__vote);
            if(VoteManager.Instance.loadOver)
            {
               VoteManager.Instance.removeEventListener(VoteManager.LOAD_COMPLETED,this.__vote);
               VoteManager.Instance.openVote();
            }
         }
      }
      
      private function checkShowVipAlert() : void
      {
         var _loc2_:String = null;
         var _loc1_:SelfInfo = PlayerManager.Instance.Self;
         if(!_loc1_.isSameDay && !VipController.instance.isRechargePoped)
         {
            VipController.instance.isRechargePoped = true;
            if(_loc1_.IsVIP)
            {
               if(_loc1_.VIPLeftDays <= VIP_LEFT_DAY_TO_COMFIRM && _loc1_.VIPLeftDays >= 0 || _loc1_.VIPLeftDays == VIP_LEFT_DAY_FIRST_PROMPT)
               {
                  _loc2_ = "";
                  if(_loc1_.VIPLeftDays == 0)
                  {
                     if(_loc1_.VipLeftHours > 0)
                     {
                        _loc2_ = LanguageMgr.GetTranslation("ddt.vip.vipView.expiredToday",_loc1_.VipLeftHours);
                     }
                     else if(_loc1_.VipLeftHours == 0)
                     {
                        _loc2_ = LanguageMgr.GetTranslation("ddt.vip.vipView.expiredHour");
                     }
                     else
                     {
                        _loc2_ = LanguageMgr.GetTranslation("ddt.vip.vipView.expiredTrue");
                     }
                  }
                  else
                  {
                     _loc2_ = LanguageMgr.GetTranslation("ddt.vip.vipView.expired",_loc1_.VIPLeftDays);
                  }
                  this._renewal = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),_loc2_,LanguageMgr.GetTranslation("ddt.vip.vipView.RenewalNow"),"",false,false,false,LayerManager.ALPHA_BLOCKGOUND);
                  this._renewal.moveEnable = false;
                  this._renewal.addEventListener(FrameEvent.RESPONSE,this.__goRenewal);
               }
            }
            else if(_loc1_.VIPExp > 0)
            {
               if(_loc1_.LastDate.valueOf() < _loc1_.VIPExpireDay.valueOf() && _loc1_.VIPExpireDay.valueOf() <= _loc1_.systemDate.valueOf())
               {
                  this._renewal = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("ddt.vip.vipView.expiredTrue"),LanguageMgr.GetTranslation("ddt.vip.vipView.RenewalNow"),"",false,false,false,LayerManager.ALPHA_BLOCKGOUND);
                  this._renewal.moveEnable = false;
                  this._renewal.addEventListener(FrameEvent.RESPONSE,this.__goRenewal);
               }
            }
         }
      }
      
      private function checkShowVipAlert_New() : void
      {
         var _loc1_:SelfInfo = PlayerManager.Instance.Self;
         if(!_loc1_.isSameDay && !VipController.instance.isRechargePoped && !PlayerManager.Instance.Self.openVipType)
         {
            VipController.instance.isRechargePoped = true;
            if(_loc1_.IsVIP)
            {
               if(_loc1_.VIPLeftDays <= VIP_LEFT_DAY_TO_COMFIRM && _loc1_.VIPLeftDays >= 0 || _loc1_.VIPLeftDays <= VIP_LEFT_DAY_FIRST_PROMPT)
               {
                  VipController.instance.showRechargeAlert();
               }
            }
            else if(!_loc1_.IsVIP && _loc1_.VIPLevel > 0)
            {
               VipController.instance.showRechargeAlert();
            }
         }
      }
      
      private function checkShowFightVipAlert() : void
      {
         FightToolBoxController.instance.showRechargeAlert();
      }
      
      private function __goRenewal(param1:FrameEvent) : void
      {
         switch(param1.responseCode)
         {
            case FrameEvent.SUBMIT_CLICK:
            case FrameEvent.ENTER_CLICK:
               VipController.instance.show();
         }
         this._renewal.removeEventListener(FrameEvent.RESPONSE,this.__goRenewal);
         this._renewal.dispose();
         this._renewal = null;
      }
      
      private function __vote(param1:Event) : void
      {
         VoteManager.Instance.removeEventListener(VoteManager.LOAD_COMPLETED,this.__vote);
         VoteManager.Instance.openVote();
      }
      
      private function checkShowStoreFromShop() : void
      {
         if(BagStore.instance.isFromShop)
         {
            BagStore.instance.isFromShop = false;
            BagStore.instance.show();
         }
      }
      
      private function __moneyChargeHandle(param1:PlayerEvent) : void
      {
         var _loc2_:ActivityInfo = ActivityController.instance.checkHasFirstCharge();
         if(_loc2_ && ActivityController.instance.model.getLog(_loc2_.ActivityId) > 0 && this._firstChargeBtn)
         {
            this._firstChargeBtn.removeEventListener(MouseEvent.CLICK,this.__firstChargeClick);
            ObjectUtils.disposeObject(this._firstChargeBtn);
            this._firstChargeBtn = null;
         }
      }
      
      private function toDungeon() : void
      {
         StateManager.setState(StateType.SINGLEDUNGEON);
      }
      
      private function toFarmSelf() : void
      {
         if(PlayerManager.Instance.Self.Grade < int(ServerConfigManager.instance.findInfoByName(ServerConfigManager.FARM_OPEN_LEVEL).Value))
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.goFarmTip"));
            return;
         }
         StateManager.setState(StateType.FARM);
      }
      
      private function __btnClick(param1:MouseEvent) : void
      {
         var _loc2_:BaseAlerFrame = null;
         var _loc3_:BaseAlerFrame = null;
         SoundManager.instance.play("047");
         switch(param1.currentTarget as BaseButton)
         {
            case this._auctionButton:
               if(PlayerManager.Instance.Self.Grade < 13)
               {
                  MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.invite.InvitePlayerItem.ActionCannot"));
                  return;
               }
               AuctionHouseManager.Instance.showToauction(AuctionHouseController.Instance.setup,UIModuleTypes.DDTAUCTION);
               ComponentSetting.SEND_USELOG_ID(7);
               break;
            case this._farmButton:
               this.toFarmSelf();
               break;
            case this._churchButton:
               ChurchManager.instance.showChurchlist(ChurchRoomListController.Instance.setup,UIModuleTypes.DDTCHURCH_ROOM_LIST);
               ComponentSetting.SEND_USELOG_ID(6);
               break;
            case this._consortiaButton:
               if(PlayerManager.Instance.Self.ConsortiaID != 0)
               {
                  SocketManager.Instance.out.SendenterConsortion(true);
               }
               else
               {
                  ConsortionManager.Instance.showClubFrame(ConsortionModelControl.Instance.initClub,UIModuleTypes.CONSORTIAII + "," + UIModuleTypes.DDTCONSORTIA);
               }
               ComponentSetting.SEND_USELOG_ID(5);
               break;
            case this._dungeonButton:
               SingleDungeonManager.Instance.loadModule(this.toDungeon);
               break;
            case this._roomListButton:
               if(PlayerManager.Instance.checkExpedition())
               {
                  _loc2_ = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("tips"),LanguageMgr.GetTranslation("ddt.consortion.ConsortionTransport.stopExpedition"),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),false,true,false,LayerManager.BLCAK_BLOCKGOUND);
                  _loc2_.moveEnable = false;
                  _loc2_.addEventListener(FrameEvent.RESPONSE,this.__expeditionRoomConfirmResponse);
               }
               else
               {
                  RoomManager.Instance.showRoomList(RoomListController.Instance.setup,UIModuleTypes.DDTROOMLIST);
                  ComponentSetting.SEND_USELOG_ID(3);
               }
               break;
            case this._shopButton:
               StateManager.setState(StateType.SHOP);
               ComponentSetting.SEND_USELOG_ID(1);
               break;
            case this._storeButton:
               BagStore.instance.show();
               ComponentSetting.SEND_USELOG_ID(2);
               break;
            case this._tofflistButton:
               if(PlayerManager.Instance.checkExpedition())
               {
                  _loc3_ = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("tips"),LanguageMgr.GetTranslation("ddt.consortion.ConsortionTransport.stopExpedition"),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),false,true,false,LayerManager.BLCAK_BLOCKGOUND);
                  _loc3_.moveEnable = false;
                  _loc3_.addEventListener(FrameEvent.RESPONSE,this.__expeditionDungeonConfirmResponse);
               }
               else
               {
                  RoomManager.Instance.showRoomList(DungeonListController.Instance.setup,UIModuleTypes.DDTROOMLIST);
                  ComponentSetting.SEND_USELOG_ID(8);
               }
         }
      }
      
      private function __expeditionRoomConfirmResponse(param1:FrameEvent) : void
      {
         var _loc2_:BaseAlerFrame = param1.currentTarget as BaseAlerFrame;
         _loc2_.removeEventListener(FrameEvent.RESPONSE,this.__expeditionRoomConfirmResponse);
         if(param1.responseCode == FrameEvent.ENTER_CLICK || param1.responseCode == FrameEvent.SUBMIT_CLICK)
         {
            SocketManager.Instance.out.sendExpeditionCancle();
            RoomManager.Instance.showRoomList(RoomListController.Instance.setup,UIModuleTypes.DDTROOMLIST);
            ComponentSetting.SEND_USELOG_ID(3);
         }
         ObjectUtils.disposeObject(_loc2_);
      }
      
      private function __expeditionDungeonConfirmResponse(param1:FrameEvent) : void
      {
         var _loc2_:BaseAlerFrame = param1.currentTarget as BaseAlerFrame;
         _loc2_.removeEventListener(FrameEvent.RESPONSE,this.__expeditionDungeonConfirmResponse);
         if(param1.responseCode == FrameEvent.ENTER_CLICK || param1.responseCode == FrameEvent.SUBMIT_CLICK)
         {
            SocketManager.Instance.out.sendExpeditionCancle();
            RoomManager.Instance.showRoomList(DungeonListController.Instance.setup,UIModuleTypes.DDTROOMLIST);
            ComponentSetting.SEND_USELOG_ID(8);
         }
         ObjectUtils.disposeObject(_loc2_);
      }
      
      private function loadUserGuide() : void
      {
         MainToolBar.Instance.tipTask();
      }
      
      private function sendToLoginInterface() : void
      {
         var _loc1_:URLVariables = new URLVariables();
         var _loc2_:String = PlayerManager.Instance.Self.ID.toString();
         _loc2_ = encodeURI(_loc2_);
         var _loc3_:String = "sdkxccjlqaoehtdwjkdycdrw";
         _loc1_["username"] = _loc2_;
         _loc1_["sign"] = MD5.hash(_loc2_ + _loc3_);
         var _loc4_:String = PathManager.callLoginInterface();
         if(!_loc4_)
         {
            return;
         }
         var _loc5_:RequestLoader = LoadResourceManager.instance.createLoader(_loc4_,BaseLoader.REQUEST_LOADER,_loc1_);
         LoadResourceManager.instance.startLoad(_loc5_);
      }
      
      private function exePopWelcome() : Boolean
      {
         return RoomManager.Instance.current != null;
      }
      
      override public function leaving(param1:BaseStateView) : void
      {
         if(this._timerBox)
         {
            ObjectUtils.disposeObject(this._timerBox);
            this._timerBox = null;
         }
         if(this._buildingMask)
         {
            this._buildingMask.graphics.clear();
            if(this._buildingMask.parent)
            {
               this._buildingMask.parent.removeChild(this._buildingMask);
            }
         }
         if(this.buildingMovie)
         {
            this.buildingMovie.removeEventListener(Event.COMPLETE,this.buttonAppear);
         }
         if(this.buildingMovieI)
         {
            this.buildingMovieI.removeEventListener(Event.COMPLETE,this.buttonAppear);
         }
         if(this.buildingMovieII)
         {
            this.buildingMovieII.removeEventListener(Event.COMPLETE,this.buttonAppear);
         }
         if(this.buildingMovieIII)
         {
            this.buildingMovieIII.removeEventListener(Event.COMPLETE,this.buttonAppear);
         }
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
         TaskManager.instance.removeEventListener(TaskEvent.BUILDING_REFLASH,this.setBuildState);
         MainButtnController.instance.removeEventListener(MainButtnController.ICONCLOSE,this.__iconClose);
         VoteManager.Instance.removeEventListener(VoteManager.LOAD_COMPLETED,this.__vote);
         TaskManager.instance.removeEventListener(TaskEvent.TASK_FRAME_HIDE,this.__taskFrameHide);
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.SHOW_DIALOG,this.__getDialogFromServer);
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.ONLINE_REWADS,this.__closeAwardBtn);
         PlayerManager.Instance.Self.removeEventListener(PlayerEvent.MONEY_CHARGE,this.__moneyChargeHandle);
         TimeManager.removeEventListener(TimeEvents.SECONDS,this.__secondsCheck);
         TaskManager.instance.removeEventListener(TaskEvent.SHOW_DOWNLOAD_FRAME,this.tryShowClientDownload);
         LivenessBubbleManager.Instance.removeEventListener(LivenessEvent.SHOW_SHINE,this.__signIconShine);
         PlayerManager.Instance.Self.removeEventListener(WeekendEvent.ENERGY_CHANGE,this.__weekendEnergyChange);
         DailyReceiveManager.Instance.removeEventListener(DailyReceiveManager.CLOSE_ICON,this.__closeIcon);
         StageReferance.stage.removeEventListener(MouseEvent.MOUSE_DOWN,this.__screenActive);
         StageReferance.stage.removeEventListener(MouseEvent.MOUSE_UP,this.__screenActive);
         StageReferance.stage.removeEventListener(KeyboardEvent.KEY_DOWN,this.__screenActive);
         StageReferance.stage.removeEventListener(KeyboardEvent.KEY_UP,this.__screenActive);
         PlayerManager.Instance.removeEventListener(PlayerManager.VIP_STATE_CHANGE,this.__isOpenBtn);
         MainToolBar.Instance.hide();
         MainToolBar.Instance.updateReturnBtn(MainToolBar.LEAVE_HALL);
         DailyButtunBar.Insance.hide();
         FightPowerAndFatigue.Instance.hide();
         FarmModelController.instance.deleteGainPlant();
         NewHandContainer.Instance.clearArrowByID(ArrowType.CLICK_LIVENESS);
         CapabilityNocticeManager.instance.hide();
         ActivityController.instance.model.removeEventListener(ActivityEvent.ACTIVITY_UPDATE,this.__updateActivity);
         TurnPlateController.Instance.removeEventListener(TurnPlateController.STATE_CHANGE,this.__turnPlateIconShine);
         if(this._hallBG)
         {
            this.sethallBg(false);
         }
         if(this._vipIcon)
         {
            ObjectUtils.disposeObject(this._vipIcon);
         }
         this._vipIcon = null;
         if(this._activityIcon)
         {
            ObjectUtils.disposeObject(this._activityIcon);
            this._activityIcon.removeEventListener(MouseEvent.CLICK,this.__openActivityView);
            this._activityIcon = null;
         }
         if(this._goSignBtn)
         {
            this._goSignBtn.removeEventListener(MouseEvent.CLICK,this.__onSignClick);
            ObjectUtils.disposeObject(this._goSignBtn);
         }
         this._goSignBtn = null;
         if(this._dailyReceiveIcon)
         {
            this._dailyReceiveIcon.removeEventListener(MouseEvent.CLICK,this.__ondailyClick);
            ObjectUtils.disposeObject(this._dailyReceiveIcon);
         }
         this._dailyReceiveIcon = null;
         if(this._turnPlateBtn)
         {
            this._turnPlateBtn.addEventListener(MouseEvent.CLICK,this.__onTurnPlateClick);
            ObjectUtils.disposeObject(this._turnPlateBtn);
         }
         this._turnPlateBtn = null;
         if(this._awardBtn)
         {
            ObjectUtils.disposeObject(this._awardBtn);
         }
         this._awardBtn = null;
         if(this._angelblessIcon)
         {
            ObjectUtils.disposeObject(this._angelblessIcon);
         }
         this._angelblessIcon = null;
         if(this._consortionCampaignBtn)
         {
            ObjectUtils.disposeObject(this._consortionCampaignBtn);
         }
         this._consortionCampaignBtn = null;
         if(this._weekendBtn)
         {
            ObjectUtils.disposeObject(this._weekendBtn);
            this._weekendBtn.removeEventListener(MouseEvent.CLICK,this.__weekendClick);
            this._weekendBtn = null;
         }
         if(this._mainPanelContent)
         {
            ObjectUtils.disposeObject(this._mainPanelContent);
            this._mainPanelContent = null;
         }
         if(this._mainBtnPanel)
         {
            ObjectUtils.disposeObject(this._mainBtnPanel);
            this._mainBtnPanel = null;
         }
         if(param1.getType() != StateType.DUNGEON_LIST && param1.getType() != StateType.ROOM_LIST)
         {
            GameInSocketOut.sendExitScene();
         }
         if(this._renewal)
         {
            this._renewal.removeEventListener(FrameEvent.RESPONSE,this.__goRenewal);
            this._renewal.dispose();
            this._renewal = null;
         }
         if(this._consortionAwardBtn)
         {
            ObjectUtils.disposeObject(this._consortionAwardBtn);
            this._consortionAwardBtn = null;
         }
         if(this._firstChargeBtn)
         {
            this._firstChargeBtn.removeEventListener(MouseEvent.CLICK,this.__firstChargeClick);
            ObjectUtils.disposeObject(this._firstChargeBtn);
            this._firstChargeBtn = null;
         }
         RoomListController.Instance.removeEvent();
         DungeonListController.Instance.removeEvent();
         this._hallFatigueIconPoint = null;
         LivenessBubbleManager.Instance.hideBubble();
         super.leaving(param1);
      }
      
      override public function prepare() : void
      {
         super.prepare();
         this._isFirst = true;
      }
      
      override public function fadingComplete() : void
      {
         var _loc1_:SaveFileWidow = null;
         var _loc2_:UpdateDescFrame = null;
         var _loc3_:AddFavoriteFrame = null;
         super.fadingComplete();
         if(this._isFirst)
         {
            this._isFirst = false;
            this.tryShowClientDownload();
            if(LoaderSavingManager.cacheAble == false && PlayerManager.Instance.Self.IsFirst > 1)
            {
               _loc1_ = ComponentFactory.Instance.creatComponentByStylename("hall.SaveFileWidow");
               _loc1_.show();
            }
            LeavePageManager.setFavorite(PlayerManager.Instance.Self.IsFirst <= 1);
         }
         if(GradeExaltClewManager.getInstance().needShowDownloadClient)
         {
            this.tryShowClientDownload();
         }
         if(UpdateController.Instance.lastNoticeBase && UpdateController.Instance.lastNoticeBase.BeginTime != SharedManager.Instance.showUpdateFrameDate)
         {
            if(!SharedManager.Instance.hasShowUpdateFrame)
            {
               _loc2_ = ComponentFactory.Instance.creatComponentByStylename("ddt.update.descFrame");
               _loc2_.show();
            }
         }
         if(VipController.instance.isShow && !SharedManager.Instance.showVipCheckBtn && VipController.instance.checkVipExpire())
         {
            this.tryShowVip();
         }
         if(!SharedManager.Instance.isAddedToFavorite && PathManager.isShowFavoriteAlert)
         {
            _loc3_ = ComponentFactory.Instance.creatComponentByStylename("hall.AddFavoriteFrame");
            _loc3_.show();
         }
         this.checkLivenessDialog();
         this.checkShowWebGiftBox();
      }
      
      private function tryShowVip() : void
      {
         if(DialogManager.Instance.showing)
         {
            setTimeout(this.tryShowVip,100);
            return;
         }
         VipController.instance.showWhenPass();
         this.showDialog(57);
      }
      
      private function tryShowClientDownload(param1:TaskEvent = null) : void
      {
         if(PlayerManager.Instance.Self.Grade >= 11 && TaskManager.instance.checkHasTaskById(500) && !TaskManager.instance.isCompleted(TaskManager.instance.getQuestByID(500)) && !this._clientDownloadFrame)
         {
            GradeExaltClewManager.getInstance().needShowDownloadClient = false;
            this._showDownloadClient = true;
            this.showDialog(55);
         }
      }
      
      private function __closeClientDownloadFrame(param1:Event) : void
      {
         this._clientDownloadFrame.removeEventListener(Event.COMPLETE,this.__closeClientDownloadFrame);
         this._clientDownloadFrame = null;
      }
      
      override public function refresh() : void
      {
         var _loc1_:StageCurtain = new StageCurtain();
         _loc1_.play(25);
         LayerManager.Instance.clearnGameDynamic();
         ShowTipManager.Instance.removeAllTip();
         this.enter(null);
      }
      
      private function checkDiamond() : void
      {
         if(DiamondManager.instance.isInTencent)
         {
            DiamondManager.instance.addEventListener(Event.COMPLETE,this.__initTencentUI);
            DiamondManager.instance.loadUIModule();
         }
      }
      
      protected function __initTencentUI(param1:Event) : void
      {
         DiamondManager.instance.removeEventListener(Event.COMPLETE,this.__initTencentUI);
         this.checkShowWebGiftBox();
         DiamondManager.instance.firstEnterOpen();
         this.addButtonList();
      }
      
      protected function __diamondClick(param1:MouseEvent) : void
      {
         switch(param1.target)
         {
            case this._diamondBtn:
               if(PlayerManager.Instance.Self.isGetNewHandPack)
               {
                  DiamondManager.instance.openDiamond();
               }
               else
               {
                  DiamondManager.instance.openNewHand();
               }
               break;
            case this._intimateFriend:
               LayerManager.Instance.addToLayer(ComponentFactory.Instance.creat("hall.closefriend.CloseFriend"),LayerManager.GAME_DYNAMIC_LAYER,true,1);
         }
      }
      
      private function getDiamondButtons() : Array
      {
         if(PlayerManager.Instance.Self.Grade > 9)
         {
            if(DiamondManager.instance.isInTencent && DiamondManager.instance.hasUI)
            {
               switch(DiamondManager.instance.pfType)
               {
                  case DiamondType.YELLOW_DIAMOND:
                     if(PlayerManager.Instance.Self.isGetNewHandPack)
                     {
                        this._diamondBtn = ComponentFactory.Instance.creat("hall.ddt.view.diamondBtnI");
                     }
                     else
                     {
                        this._diamondBtn = ComponentFactory.Instance.creat("hall.ddt.view.diamondNewHandBtnI");
                     }
                     break;
                  case DiamondType.BLUE_DIAMOND:
                     if(PlayerManager.Instance.Self.isGetNewHandPack)
                     {
                        this._diamondBtn = ComponentFactory.Instance.creat("hall.ddt.view.diamondBtnII");
                     }
                     else
                     {
                        this._diamondBtn = ComponentFactory.Instance.creat("hall.ddt.view.diamondNewHandBtnII");
                     }
                     break;
                  case DiamondType.MEMBER_DIAMOND:
                     if(PlayerManager.Instance.Self.isGetNewHandPack)
                     {
                        this._diamondBtn = ComponentFactory.Instance.creat("hall.ddt.view.privilegedII");
                     }
                     else
                     {
                        this._diamondBtn = ComponentFactory.Instance.creat("hall.ddt.view.privilegedNewHandII");
                     }
               }
               this._intimateFriend = ComponentFactory.Instance.creat("hall.ddt.view.intimateFriend");
               this._diamondBtn.addEventListener(MouseEvent.CLICK,this.__diamondClick);
               this._intimateFriend.addEventListener(MouseEvent.CLICK,this.__diamondClick);
               return [this._diamondBtn,this._intimateFriend];
            }
         }
         return [];
      }
      
      private function checkShowWebGiftBox() : void
      {
         if(DiamondManager.instance.pfType == 2 && PlayerManager.Instance.Self.Grade >= 3)
         {
            this._webGiftBox = ComponentFactory.Instance.creat("hall.ddt.view.WebGiftButton");
            this._webGiftBox.addEventListener(MouseEvent.CLICK,this.__webGiftBoxClick);
            addChild(this._webGiftBox);
         }
      }
      
      private function __webGiftBoxClick(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         DiamondManager.instance.openBunFrame();
      }
   }
}
