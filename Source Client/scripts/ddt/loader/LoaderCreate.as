package ddt.loader
{
   import SingleDungeon.SingleDungeonManager;
   import SingleDungeon.dataAnalyzer.BigMapDataAnalyzer;
   import SingleDungeon.dataAnalyzer.MapSceneDataAnalyzer;
   import SingleDungeon.dataAnalyzer.MapSceneObjectsAnalyzer;
   import SingleDungeon.expedition.ExpeditionController;
   import activity.ActivityController;
   import activity.analyze.ActivityConditionAnalyzer;
   import activity.analyze.ActivityGiftbagAnalyzer;
   import activity.analyze.ActivityInfoAnalyzer;
   import activity.analyze.ActivityRewardAnalyzer;
   import bead.BeadManager;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.loader.BaseLoader;
   import com.pickgliss.loader.LoadResourceManager;
   import com.pickgliss.loader.LoaderEvent;
   import com.pickgliss.loader.LoaderSavingManager;
   import com.pickgliss.loader.ModuleLoader;
   import com.pickgliss.loader.RequestLoader;
   import com.pickgliss.loader.TextLoader;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.utils.ObjectUtils;
   import consortion.ConsortionModelControl;
   import consortion.analyze.ConsortionListAnalyzer;
   import consortion.analyze.ConsortionMemberAnalyer;
   import ddt.data.Experience;
   import ddt.data.GoodsAdditioner;
   import ddt.data.PetExperienceManager;
   import ddt.data.analyze.BadgeInfoAnalyzer;
   import ddt.data.analyze.BagCellInfoListAnalyze;
   import ddt.data.analyze.BallInfoAnalyzer;
   import ddt.data.analyze.BeadDataAnalyzer;
   import ddt.data.analyze.BoxTempInfoAnalyzer;
   import ddt.data.analyze.ComposeConfigListAnalyzer;
   import ddt.data.analyze.DailyLeagueAwardAnalyzer;
   import ddt.data.analyze.DailyLeagueLevelAnalyzer;
   import ddt.data.analyze.DaylyGiveAnalyzer;
   import ddt.data.analyze.DungeonAnalyzer;
   import ddt.data.analyze.EquipPropertyListAnalyzer;
   import ddt.data.analyze.EquipSplitListAnalyzer;
   import ddt.data.analyze.EquipStrengthListAnalyzer;
   import ddt.data.analyze.EquipmentTemplateAnalyzer;
   import ddt.data.analyze.ExpeditionDataAnalyzer;
   import ddt.data.analyze.ExpericenceAnalyze;
   import ddt.data.analyze.FilterWordAnalyzer;
   import ddt.data.analyze.FriendListAnalyzer;
   import ddt.data.analyze.GoodCategoryAnalyzer;
   import ddt.data.analyze.GoodsAdditionAnalyer;
   import ddt.data.analyze.InvitedFriendListAnalyzer;
   import ddt.data.analyze.ItemTempleteAnalyzer;
   import ddt.data.analyze.LoginSelectListAnalyzer;
   import ddt.data.analyze.MapAnalyzer;
   import ddt.data.analyze.MovingNotificationAnalyzer;
   import ddt.data.analyze.PetExpericenceAnalyze;
   import ddt.data.analyze.QuestListAnalyzer;
   import ddt.data.analyze.RegisterAnalyzer;
   import ddt.data.analyze.ServerConfigAnalyz;
   import ddt.data.analyze.ServerListAnalyzer;
   import ddt.data.analyze.ShopItemAnalyzer;
   import ddt.data.analyze.ShopItemSortAnalyzer;
   import ddt.data.analyze.SuidTipsAnalyzer;
   import ddt.data.analyze.UserBoxInfoAnalyzer;
   import ddt.data.analyze.VipPrivilegeConfigAnalyzer;
   import ddt.data.analyze.VoteInfoAnalyzer;
   import ddt.data.analyze.VoteSubmitAnalyzer;
   import ddt.data.analyze.WeaponBallInfoAnalyze;
   import ddt.data.analyze.WeekOpenMapAnalyze;
   import ddt.data.analyze.WorldBossRankAnalyzer;
   import ddt.data.analyze.WorldBossTimeAnalyzer;
   import ddt.manager.BadgeInfoManager;
   import ddt.manager.BallManager;
   import ddt.manager.BossBoxManager;
   import ddt.manager.DailyLeagueManager;
   import ddt.manager.ItemManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.LeavePageManager;
   import ddt.manager.MapManager;
   import ddt.manager.PathManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SelectListManager;
   import ddt.manager.ServerConfigManager;
   import ddt.manager.ServerManager;
   import ddt.manager.ShopManager;
   import ddt.manager.TaskManager;
   import ddt.manager.VipPrivilegeConfigManager;
   import ddt.manager.VoteManager;
   import ddt.manager.WeaponBallManager;
   import ddt.utils.FilterWordManager;
   import ddt.utils.RequestVairableCreater;
   import feedback.FeedbackManager;
   import feedback.analyze.LoadFeedbackReplyAnalyzer;
   import flash.net.URLVariables;
   import flash.utils.getDefinitionByName;
   import liveness.DailyReceiveManager;
   import liveness.LivenessAwardManager;
   import mainbutton.data.HallIconDataAnalyz;
   import mainbutton.data.MainButtonManager;
   import roomList.movingNotification.MovingNotificationManager;
   import store.analyze.ComposeItemAnalyzer;
   import store.analyze.StoreEquipExpericenceAnalyze;
   import store.data.StoreEquipExperience;
   import store.view.Compose.ComposeController;
   import store.view.strength.analyzer.ItemStrengthenGoodsInfoAnalyzer;
   import store.view.strength.manager.ItemStrengthenGoodsInfoManager;
   import totem.HonorUpManager;
   import totem.TotemManager;
   import totem.data.HonorUpDataAnalyz;
   import totem.data.TotemDataAnalyz;
   import worldboss.WorldBossRoomController;
   
   public class LoaderCreate
   {
      
      private static var _instance:LoaderCreate;
       
      
      private var _reloadCount:int = 0;
      
      private var _reloadQuestCount:int = 0;
      
      public function LoaderCreate()
      {
         super();
      }
      
      public static function get Instance() : LoaderCreate
      {
         if(_instance == null)
         {
            _instance = new LoaderCreate();
         }
         return _instance;
      }
      
      public function createAudioILoader() : BaseLoader
      {
         var _loc1_:BaseLoader = LoadResourceManager.instance.createLoader(PathManager.solveSoundSwf(),BaseLoader.MODULE_LOADER);
         _loc1_.loadErrorMessage = LanguageMgr.GetTranslation("ddt.loader.LoadingAudioIFail");
         _loc1_.addEventListener(LoaderEvent.LOAD_ERROR,this.__onLoadError);
         return _loc1_;
      }
      
      public function createAudioIILoader() : BaseLoader
      {
         var _loc1_:BaseLoader = LoadResourceManager.instance.createLoader(PathManager.solveSoundSwf2(),BaseLoader.MODULE_LOADER);
         _loc1_.loadErrorMessage = LanguageMgr.GetTranslation("ddt.loader.LoadingAudioIIFail");
         _loc1_.addEventListener(LoaderEvent.LOAD_ERROR,this.__onLoadError);
         return _loc1_;
      }
      
      public function loadExppression(param1:Function) : void
      {
         var _loc2_:ModuleLoader = LoadResourceManager.instance.createLoader(PathManager.getExpressionPath(),BaseLoader.MODULE_LOADER);
         _loc2_.loadErrorMessage = LanguageMgr.GetTranslation("ddt.loader.LoadingExpressionResourcesFailure");
         _loc2_.addEventListener(LoaderEvent.LOAD_ERROR,this.__onLoadError);
         _loc2_.addEventListener(LoaderEvent.COMPLETE,param1);
         LoadResourceManager.instance.startLoad(_loc2_);
      }
      
      public function creatBallInfoLoader() : BaseLoader
      {
         var _loc1_:BaseLoader = LoadResourceManager.instance.createLoader(PathManager.solveRequestPath("BallList.xml"),BaseLoader.COMPRESS_TEXT_LOADER);
         _loc1_.loadErrorMessage = LanguageMgr.GetTranslation("ddt.loader.LoadingBombMetadataFailure");
         _loc1_.analyzer = new BallInfoAnalyzer(BallManager.setup);
         _loc1_.addEventListener(LoaderEvent.LOAD_ERROR,this.__onLoadError);
         return _loc1_;
      }
      
      public function creatBoxTempInfoLoader() : BaseLoader
      {
         var _loc1_:BaseLoader = LoadResourceManager.instance.createLoader(PathManager.solveRequestPath("LoadBoxTemp.xml"),BaseLoader.COMPRESS_TEXT_LOADER);
         _loc1_.loadErrorMessage = LanguageMgr.GetTranslation("ddt.loader.LoadingChestsListFailure");
         _loc1_.analyzer = new BoxTempInfoAnalyzer(BossBoxManager.instance.setupBoxTempInfo);
         _loc1_.addEventListener(LoaderEvent.LOAD_ERROR,this.__onLoadError);
         return _loc1_;
      }
      
      public function creatDungeonInfoLoader() : BaseLoader
      {
         var _loc1_:BaseLoader = LoadResourceManager.instance.createLoader(PathManager.solveRequestPath("LoadPVEItems.xml"),BaseLoader.COMPRESS_TEXT_LOADER);
         _loc1_.loadErrorMessage = LanguageMgr.GetTranslation("ddt.loader.LoadingCopyMapsInformationFailure");
         _loc1_.analyzer = new DungeonAnalyzer(MapManager.setupDungeonInfo);
         _loc1_.addEventListener(LoaderEvent.LOAD_ERROR,this.__onLoadError);
         return _loc1_;
      }
      
      public function creatFriendListLoader() : BaseLoader
      {
         var _loc1_:URLVariables = RequestVairableCreater.creatWidthKey(true);
         _loc1_["id"] = PlayerManager.Instance.Self.ID;
         _loc1_["uname"] = PlayerManager.Instance.Account.Account;
         var _loc2_:BaseLoader = LoadResourceManager.instance.createLoader(PathManager.solveRequestPath("IMListLoad.ashx"),BaseLoader.REQUEST_LOADER,_loc1_);
         _loc2_.loadErrorMessage = LanguageMgr.GetTranslation("ddt.loader.LoadingBuddyListFailure");
         _loc2_.analyzer = new FriendListAnalyzer(PlayerManager.Instance.setupFriendList);
         _loc2_.addEventListener(LoaderEvent.LOAD_ERROR,this.__onLoadError);
         return _loc2_;
      }
      
      public function creatGoodCategoryLoader() : BaseLoader
      {
         var _loc1_:BaseLoader = LoadResourceManager.instance.createLoader(PathManager.solveRequestPath("LoadItemsCategory.xml"),BaseLoader.COMPRESS_TEXT_LOADER);
         _loc1_.loadErrorMessage = LanguageMgr.GetTranslation("ddt.loader.LoadingItemTypeFailure");
         _loc1_.analyzer = new GoodCategoryAnalyzer(ItemManager.Instance.setupGoodsCategory);
         _loc1_.addEventListener(LoaderEvent.LOAD_ERROR,this.__onLoadError);
         return _loc1_;
      }
      
      public function creatItemTempleteLoader() : BaseLoader
      {
         var _loc1_:BaseLoader = LoadResourceManager.instance.createLoader(PathManager.solveRequestPath("TemplateAllList.xml"),BaseLoader.COMPRESS_TEXT_LOADER);
         _loc1_.loadErrorMessage = LanguageMgr.GetTranslation("ddt.loader.LoadingGoodsTemplateFailure");
         _loc1_.analyzer = new ItemTempleteAnalyzer(ItemManager.Instance.setupGoodsTemplates);
         _loc1_.addEventListener(LoaderEvent.LOAD_ERROR,this.__onLoadError);
         return _loc1_;
      }
      
      public function creatEquipTempleteLoader() : BaseLoader
      {
         var _loc1_:BaseLoader = LoadResourceManager.instance.createLoader(PathManager.solveRequestPath("EquipTemplateList.xml"),BaseLoader.COMPRESS_TEXT_LOADER);
         _loc1_.loadErrorMessage = LanguageMgr.GetTranslation("ddt.loader.LoadingEquipTemplateFailure");
         _loc1_.analyzer = new EquipmentTemplateAnalyzer(ItemManager.Instance.setupEquipsTemplates);
         _loc1_.addEventListener(LoaderEvent.LOAD_ERROR,this.__onLoadError);
         return _loc1_;
      }
      
      public function creatEquipPropertyList() : BaseLoader
      {
         var _loc1_:BaseLoader = LoadResourceManager.instance.createLoader(PathManager.solveRequestPath("EquipPropertyList.xml"),BaseLoader.COMPRESS_TEXT_LOADER);
         _loc1_.loadErrorMessage = LanguageMgr.GetTranslation("ddt.loader.LoadingEquipPropertyListFailuer");
         _loc1_.analyzer = new EquipPropertyListAnalyzer(ItemManager.Instance.setupEquipPropertyList);
         _loc1_.addEventListener(LoaderEvent.LOAD_ERROR,this.__onLoadError);
         return _loc1_;
      }
      
      public function creatBagCellInfoList() : BaseLoader
      {
         var _loc1_:BaseLoader = LoadResourceManager.instance.createLoader(PathManager.solveRequestPath("BagCellInfoList.xml"),BaseLoader.COMPRESS_TEXT_LOADER);
         _loc1_.loadErrorMessage = LanguageMgr.GetTranslation("ddt.loader.LoadingBagCellListFailuer");
         _loc1_.analyzer = new BagCellInfoListAnalyze(ItemManager.Instance.setupBagCellList);
         _loc1_.addEventListener(LoaderEvent.LOAD_ERROR,this.__onLoadError);
         return _loc1_;
      }
      
      public function creatItemTempleteReload() : BaseLoader
      {
         this._reloadCount += 1;
         var _loc1_:URLVariables = new URLVariables();
         _loc1_["lv"] = LoaderSavingManager.Version + this._reloadCount;
         _loc1_["rnd"] = TextLoader.TextLoaderKey + this._reloadCount.toString();
         var _loc2_:BaseLoader = LoadResourceManager.instance.createLoader(PathManager.solveRequestPath("ShopBox.xml"),BaseLoader.TEXT_LOADER,_loc1_);
         _loc2_.loadErrorMessage = LanguageMgr.GetTranslation("ddt.loader.LoadingNewGoodsTemplateFailure");
         _loc2_.analyzer = new ItemTempleteAnalyzer(ItemManager.Instance.addGoodsTemplates);
         _loc2_.addEventListener(LoaderEvent.LOAD_ERROR,this.__onLoadError);
         return _loc2_;
      }
      
      public function creatBadgeInfoLoader() : BaseLoader
      {
         var _loc1_:BaseLoader = LoadResourceManager.instance.createLoader(PathManager.solveRequestPath("ConsortiaBadgeConfig.xml"),BaseLoader.COMPRESS_TEXT_LOADER);
         _loc1_.loadErrorMessage = LanguageMgr.GetTranslation("ddt.loader.LoadingBadgeInfoFailure");
         _loc1_.analyzer = new BadgeInfoAnalyzer(BadgeInfoManager.instance.setup);
         _loc1_.addEventListener(LoaderEvent.LOAD_ERROR,this.__onLoadError);
         return _loc1_;
      }
      
      public function creatMovingNotificationLoader() : BaseLoader
      {
         var _loc1_:BaseLoader = LoadResourceManager.instance.createLoader(PathManager.getMovingNotificationPath(),BaseLoader.TEXT_LOADER);
         _loc1_.loadErrorMessage = LanguageMgr.GetTranslation("ddt.loader.LoadingAnnouncementFailure");
         _loc1_.analyzer = new MovingNotificationAnalyzer(MovingNotificationManager.Instance.setup);
         _loc1_.addEventListener(LoaderEvent.LOAD_ERROR,this.__onLoadError);
         return _loc1_;
      }
      
      public function creatDailyInfoLoader() : BaseLoader
      {
         var _loc1_:BaseLoader = LoadResourceManager.instance.createLoader(PathManager.solveRequestPath("DailyAwardList.xml"),BaseLoader.COMPRESS_TEXT_LOADER);
         _loc1_.loadErrorMessage = LanguageMgr.GetTranslation("ddt.loader.LoadingLoginFailedRewardInformation");
         _loc1_.analyzer = new DaylyGiveAnalyzer(LivenessAwardManager.Instance.setDailyInfo);
         _loc1_.addEventListener(LoaderEvent.LOAD_ERROR,this.__onLoadError);
         return _loc1_;
      }
      
      public function creatMapInfoLoader() : BaseLoader
      {
         var _loc1_:BaseLoader = LoadResourceManager.instance.createLoader(PathManager.solveRequestPath("LoadMapsItems.xml"),BaseLoader.COMPRESS_TEXT_LOADER);
         _loc1_.loadErrorMessage = LanguageMgr.GetTranslation("ddt.loader.LoadMapInformationFailure");
         _loc1_.analyzer = new MapAnalyzer(MapManager.setupMapInfo);
         _loc1_.addEventListener(LoaderEvent.LOAD_ERROR,this.__onLoadError);
         return _loc1_;
      }
      
      public function creatOpenMapInfoLoader() : BaseLoader
      {
         var _loc1_:BaseLoader = LoadResourceManager.instance.createLoader(PathManager.solveRequestPath("MapServerList.xml"),BaseLoader.COMPRESS_TEXT_LOADER);
         _loc1_.loadErrorMessage = LanguageMgr.GetTranslation("ddt.loader.LoadingOpenMapListFailure");
         _loc1_.analyzer = new WeekOpenMapAnalyze(MapManager.setupOpenMapInfo);
         _loc1_.addEventListener(LoaderEvent.LOAD_ERROR,this.__onLoadError);
         return _loc1_;
      }
      
      public function creatQuestTempleteLoader() : BaseLoader
      {
         var _loc1_:BaseLoader = LoadResourceManager.instance.createLoader(PathManager.solveRequestPath("QuestList.xml"),BaseLoader.COMPRESS_TEXT_LOADER);
         _loc1_.loadErrorMessage = LanguageMgr.GetTranslation("ddt.loader.LoadingTaskListFailure");
         _loc1_.analyzer = new QuestListAnalyzer(TaskManager.instance.setup);
         _loc1_.addEventListener(LoaderEvent.LOAD_ERROR,this.__onLoadError);
         return _loc1_;
      }
      
      public function creatQuestTempleteReload() : BaseLoader
      {
         this._reloadQuestCount += 1;
         var _loc1_:URLVariables = new URLVariables();
         _loc1_["lv"] = LoaderSavingManager.Version + this._reloadQuestCount;
         _loc1_["rnd"] = TextLoader.TextLoaderKey + this._reloadQuestCount.toString();
         var _loc2_:BaseLoader = LoadResourceManager.instance.createLoader(PathManager.solveRequestPath("QuestList.xml"),BaseLoader.COMPRESS_TEXT_LOADER,_loc1_);
         _loc2_.loadErrorMessage = LanguageMgr.GetTranslation("ddt.loader.LoadingTaskListFailure");
         _loc2_.analyzer = new QuestListAnalyzer(TaskManager.instance.reloadNewQuest);
         _loc2_.addEventListener(LoaderEvent.LOAD_ERROR,this.__onLoadError);
         return _loc2_;
      }
      
      public function creatRegisterLoader() : BaseLoader
      {
         var _loc1_:* = getDefinitionByName("register.RegisterState");
         var _loc2_:URLVariables = RequestVairableCreater.creatWidthKey(true);
         _loc2_["Sex"] = _loc1_.SelectedSex;
         _loc2_["NickName"] = _loc1_.Nickname;
         _loc2_["Name"] = PlayerManager.Instance.Account.Account;
         _loc2_["Pass"] = PlayerManager.Instance.Account.Password;
         _loc2_["site"] = "";
         var _loc3_:RequestLoader = LoadResourceManager.instance.createLoader(PathManager.solveRequestPath("VisualizeRegister.ashx"),BaseLoader.REQUEST_LOADER,_loc2_);
         _loc3_.loadErrorMessage = LanguageMgr.GetTranslation("ddt.loader.FailedToRegister");
         _loc3_.analyzer = new RegisterAnalyzer(null);
         _loc3_.addEventListener(LoaderEvent.LOAD_ERROR,this.__onLoadError);
         return _loc3_;
      }
      
      public function creatSelectListLoader() : BaseLoader
      {
         var _loc1_:URLVariables = new URLVariables();
         _loc1_["rnd"] = Math.random();
         _loc1_["username"] = PlayerManager.Instance.Account.Account;
         var _loc2_:BaseLoader = LoadResourceManager.instance.createLoader(PathManager.solveRequestPath("LoginSelectList.ashx"),BaseLoader.REQUEST_LOADER,_loc1_);
         _loc2_.loadErrorMessage = LanguageMgr.GetTranslation("ddt.loader.LoadingRoleListFailure");
         _loc2_.analyzer = new LoginSelectListAnalyzer(SelectListManager.Instance.setup);
         _loc2_.addEventListener(LoaderEvent.LOAD_ERROR,this.__onLoadError);
         return _loc2_;
      }
      
      public function creatServerListLoader() : BaseLoader
      {
         var _loc1_:URLVariables = new URLVariables();
         _loc1_["rnd"] = Math.random();
         var _loc2_:BaseLoader = LoadResourceManager.instance.createLoader(PathManager.solveRequestPath("ServerList.ashx"),BaseLoader.REQUEST_LOADER,_loc1_);
         _loc2_.loadErrorMessage = LanguageMgr.GetTranslation("ddt.loader.LoadingServerListFailure");
         _loc2_.analyzer = new ServerListAnalyzer(ServerManager.Instance.setup);
         _loc2_.addEventListener(LoaderEvent.LOAD_ERROR,this.__onLoadError);
         return _loc2_;
      }
      
      public function creatWorldBossRankLoader() : BaseLoader
      {
         this._reloadCount += 1;
         var _loc1_:URLVariables = new URLVariables();
         _loc1_["lv"] = LoaderSavingManager.Version + this._reloadCount;
         _loc1_["rnd"] = TextLoader.TextLoaderKey + this._reloadCount.toString();
         var _loc2_:BaseLoader = LoadResourceManager.instance.createLoader(PathManager.solveRequestPath("WorldBossRank.ashx"),BaseLoader.TEXT_LOADER,_loc1_);
         _loc2_.loadErrorMessage = LanguageMgr.GetTranslation("ddt.loader.LoadingWorldBossFail");
         _loc2_.analyzer = new WorldBossRankAnalyzer(WorldBossRoomController.Instance.setup);
         _loc2_.addEventListener(LoaderEvent.LOAD_ERROR,this.__onLoadError);
         return _loc2_;
      }
      
      public function creatWorldBossTimeLoader() : BaseLoader
      {
         var _loc1_:URLVariables = new URLVariables();
         _loc1_["rnd"] = Math.random();
         var _loc2_:BaseLoader = LoadResourceManager.instance.createLoader(PathManager.solveRequestPath("WorldBossActiveTimeInfo.xml"),BaseLoader.COMPRESS_TEXT_LOADER,_loc1_);
         _loc2_.loadErrorMessage = LanguageMgr.GetTranslation("ddt.loader.LoadingWorldBossTimeFail");
         _loc2_.analyzer = new WorldBossTimeAnalyzer(WorldBossRoomController.Instance.timeSetup);
         _loc2_.addEventListener(LoaderEvent.LOAD_ERROR,this.__onLoadError);
         return _loc2_;
      }
      
      public function creatShopTempleteLoader() : BaseLoader
      {
         var _loc1_:BaseLoader = LoadResourceManager.instance.createLoader(PathManager.solveRequestPath("ShopItemList.xml"),BaseLoader.COMPRESS_TEXT_LOADER);
         _loc1_.loadErrorMessage = LanguageMgr.GetTranslation("ddt.loader.LoadingStoreItemsFail");
         _loc1_.analyzer = new ShopItemAnalyzer(ShopManager.Instance.setup);
         _loc1_.addEventListener(LoaderEvent.LOAD_ERROR,this.__onLoadError);
         return _loc1_;
      }
      
      public function creatGoodsAdditionLoader() : BaseLoader
      {
         var _loc1_:BaseLoader = LoadResourceManager.instance.createLoader(PathManager.solveRequestPath("ItemStrengthenPlusData.xml"),BaseLoader.COMPRESS_TEXT_LOADER);
         _loc1_.loadErrorMessage = LanguageMgr.GetTranslation("ddt.loader.LoadingGoodsAdditionFail");
         _loc1_.analyzer = new GoodsAdditionAnalyer(GoodsAdditioner.Instance.addGoodsAddition);
         _loc1_.addEventListener(LoaderEvent.LOAD_ERROR,this.__onLoadError);
         return _loc1_;
      }
      
      public function creatShopSortLoader() : BaseLoader
      {
         var _loc1_:BaseLoader = LoadResourceManager.instance.createLoader(PathManager.solveRequestPath("ShopGoodsShowList.xml"),BaseLoader.COMPRESS_TEXT_LOADER);
         _loc1_.loadErrorMessage = LanguageMgr.GetTranslation("ddt.loader.TheClassificationOfGoodsLoadingShopFailure");
         _loc1_.analyzer = new ShopItemSortAnalyzer(ShopManager.Instance.sortShopItems);
         _loc1_.addEventListener(LoaderEvent.LOAD_ERROR,this.__onLoadError);
         return _loc1_;
      }
      
      public function creatUserBoxInfoLoader() : BaseLoader
      {
         var _loc1_:BaseLoader = LoadResourceManager.instance.createLoader(PathManager.solveRequestPath("LoadUserBox.xml"),BaseLoader.COMPRESS_TEXT_LOADER);
         _loc1_.loadErrorMessage = LanguageMgr.GetTranslation("ddt.loader.LoadingChestsInformationFailure");
         _loc1_.analyzer = new UserBoxInfoAnalyzer(BossBoxManager.instance.setupBoxInfo);
         _loc1_.addEventListener(LoaderEvent.LOAD_ERROR,this.__onLoadError);
         return _loc1_;
      }
      
      public function creatZhanLoader() : BaseLoader
      {
         var _loc1_:BaseLoader = LoadResourceManager.instance.createLoader(PathManager.getZhanPath(),BaseLoader.TEXT_LOADER);
         _loc1_.loadErrorMessage = "LoadingDirtyCharacterSheetsFailure";
         _loc1_.analyzer = new FilterWordAnalyzer(FilterWordManager.setup);
         _loc1_.addEventListener(LoaderEvent.LOAD_ERROR,this.__onLoadError);
         return _loc1_;
      }
      
      public function createConsortiaLoader() : BaseLoader
      {
         var _loc1_:URLVariables = RequestVairableCreater.creatWidthKey(true);
         _loc1_["id"] = PlayerManager.Instance.Self.ID;
         _loc1_["page"] = 1;
         _loc1_["size"] = 10000;
         _loc1_["order"] = -1;
         _loc1_["consortiaID"] = PlayerManager.Instance.Self.ConsortiaID;
         _loc1_["userID"] = -1;
         _loc1_["state"] = -1;
         var _loc2_:BaseLoader = LoadResourceManager.instance.createLoader(PathManager.solveRequestPath("ConsortiaUsersList.ashx"),BaseLoader.REQUEST_LOADER,_loc1_);
         _loc2_.loadErrorMessage = LanguageMgr.GetTranslation("ddt.loader.LoadingGuildMembersListFailure");
         _loc2_.analyzer = new ConsortionMemberAnalyer(ConsortionModelControl.Instance.memberListComplete);
         _loc2_.addEventListener(LoaderEvent.LOAD_ERROR,this.__onLoadError);
         return _loc2_;
      }
      
      public function createCalendarRequest() : BaseLoader
      {
         return DailyReceiveManager.Instance.request();
      }
      
      public function getMyConsortiaData() : BaseLoader
      {
         var _loc1_:URLVariables = RequestVairableCreater.creatWidthKey(true);
         _loc1_["page"] = 1;
         _loc1_["size"] = 1;
         _loc1_["name"] = "";
         _loc1_["level"] = -1;
         _loc1_["ConsortiaID"] = PlayerManager.Instance.Self.ConsortiaID;
         _loc1_["order"] = -1;
         _loc1_["openApply"] = -1;
         var _loc2_:BaseLoader = LoadResourceManager.instance.createLoader(PathManager.solveRequestPath("ConsortiaList.ashx"),BaseLoader.COMPRESS_REQUEST_LOADER,_loc1_);
         _loc2_.loadErrorMessage = LanguageMgr.GetTranslation("tank.consortia.myconsortia.frame.LoadMyconsortiaInfoError");
         _loc2_.analyzer = new ConsortionListAnalyzer(ConsortionModelControl.Instance.selfConsortionComplete);
         _loc2_.addEventListener(LoaderEvent.LOAD_ERROR,this.__onLoadError);
         return _loc2_;
      }
      
      public function creatFeedbackInfoLoader() : BaseLoader
      {
         var _loc1_:URLVariables = RequestVairableCreater.creatWidthKey(true);
         _loc1_["userid"] = PlayerManager.Instance.Self.ID;
         var _loc2_:BaseLoader = LoadResourceManager.instance.createLoader(PathManager.solveRequestPath("AdvanceQuestionRead.ashx"),BaseLoader.REQUEST_LOADER,_loc1_);
         _loc2_.loadErrorMessage = LanguageMgr.GetTranslation("ddt.loader.LoadingComplainInformationFailure");
         _loc2_.analyzer = new LoadFeedbackReplyAnalyzer(FeedbackManager.instance.setupFeedbackData);
         _loc2_.addEventListener(LoaderEvent.LOAD_ERROR,this.__onLoadError);
         return _loc2_;
      }
      
      public function creatExpericenceAnalyzeLoader() : BaseLoader
      {
         var _loc1_:BaseLoader = LoadResourceManager.instance.createLoader(PathManager.solveRequestPath("LevelList.xml"),BaseLoader.COMPRESS_TEXT_LOADER);
         _loc1_.loadErrorMessage = LanguageMgr.GetTranslation("ddt.loader.LoadingAchievementTemplateFormFailure");
         _loc1_.analyzer = new ExpericenceAnalyze(Experience.setup);
         _loc1_.addEventListener(LoaderEvent.LOAD_ERROR,this.__onLoadError);
         return _loc1_;
      }
      
      public function creatPetExpericenceAnalyzeLoader() : BaseLoader
      {
         var _loc1_:BaseLoader = LoadResourceManager.instance.createLoader(PathManager.solveRequestPath("PetLevelInfo.xml"),BaseLoader.TEXT_LOADER);
         _loc1_.loadErrorMessage = LanguageMgr.GetTranslation("ddt.loader.LoadingPetExpirenceTemplateFormFailure");
         _loc1_.analyzer = new PetExpericenceAnalyze(PetExperienceManager.setup);
         _loc1_.addEventListener(LoaderEvent.LOAD_ERROR,this.__onLoadError);
         return _loc1_;
      }
      
      public function creatWeaponBallAnalyzeLoader() : BaseLoader
      {
         var _loc1_:BaseLoader = LoadResourceManager.instance.createLoader(PathManager.solveRequestPath("BombConfig.xml"),BaseLoader.COMPRESS_TEXT_LOADER);
         _loc1_.loadErrorMessage = LanguageMgr.GetTranslation("ddt.loader.LoadingWeaponBallListFormFailure");
         _loc1_.analyzer = new WeaponBallInfoAnalyze(WeaponBallManager.setup);
         _loc1_.addEventListener(LoaderEvent.LOAD_ERROR,this.__onLoadError);
         return _loc1_;
      }
      
      public function creatDailyLeagueAwardLoader() : BaseLoader
      {
         var _loc1_:BaseLoader = LoadResourceManager.instance.createLoader(PathManager.solveRequestPath("DailyLeagueAward.xml"),BaseLoader.COMPRESS_TEXT_LOADER);
         _loc1_.loadErrorMessage = LanguageMgr.GetTranslation("ddt.loader.LoadingDailyLeagueAwardFailure");
         _loc1_.analyzer = new DailyLeagueAwardAnalyzer(DailyLeagueManager.Instance.setup);
         _loc1_.addEventListener(LoaderEvent.LOAD_ERROR,this.__onLoadError);
         return _loc1_;
      }
      
      public function creatDailyLeagueLevelLoader() : BaseLoader
      {
         var _loc1_:BaseLoader = LoadResourceManager.instance.createLoader(PathManager.solveRequestPath("DailyLeagueLevel.xml"),BaseLoader.COMPRESS_TEXT_LOADER);
         _loc1_.loadErrorMessage = LanguageMgr.GetTranslation("ddt.loader.LoadingDailyLeagueLevelFailure");
         _loc1_.analyzer = new DailyLeagueLevelAnalyzer(DailyLeagueManager.Instance.setup);
         _loc1_.addEventListener(LoaderEvent.LOAD_ERROR,this.__onLoadError);
         return _loc1_;
      }
      
      public function creatServerConfigLoader() : BaseLoader
      {
         var _loc1_:BaseLoader = LoadResourceManager.instance.createLoader(PathManager.solveRequestPath("ServerConfig.xml"),BaseLoader.TEXT_LOADER);
         _loc1_.loadErrorMessage = LanguageMgr.GetTranslation("ddt.loader.LoadingDailyLeagueLevelFailure");
         _loc1_.analyzer = new ServerConfigAnalyz(ServerConfigManager.instance.getserverConfigInfo);
         _loc1_.addEventListener(LoaderEvent.LOAD_ERROR,this.__onLoadError);
         return _loc1_;
      }
      
      public function creatVoteSubmit() : BaseLoader
      {
         var _loc1_:URLVariables = new URLVariables();
         _loc1_["userId"] = PlayerManager.Instance.Self.ID;
         var _loc2_:BaseLoader = LoadResourceManager.instance.createLoader(PathManager.solveRequestPath("VoteSubmit.ashx"),BaseLoader.REQUEST_LOADER,_loc1_);
         _loc2_.loadErrorMessage = LanguageMgr.GetTranslation("ddt.vip.loadVip.error");
         _loc2_.analyzer = new VoteSubmitAnalyzer(this.loadVoteXml);
         return _loc2_;
      }
      
      public function createStoreEquipConfigLoader() : BaseLoader
      {
         var _loc1_:BaseLoader = LoadResourceManager.instance.createLoader(PathManager.solveRequestPath("LoadStrengthExp.xml"),BaseLoader.TEXT_LOADER);
         _loc1_.loadErrorMessage = LanguageMgr.GetTranslation("ddt.loader.loadStoreEquipExperienceAllFail");
         _loc1_.analyzer = new StoreEquipExpericenceAnalyze(StoreEquipExperience.setup);
         _loc1_.addEventListener(LoaderEvent.LOAD_ERROR,this.__onLoadError);
         return _loc1_;
      }
      
      public function creatItemStrengthenGoodsInfoLoader() : BaseLoader
      {
         var _loc1_:BaseLoader = LoadResourceManager.instance.createLoader(PathManager.solveRequestPath("ItemStrengthenGoodsInfo.xml"),BaseLoader.COMPRESS_TEXT_LOADER);
         _loc1_.loadErrorMessage = LanguageMgr.GetTranslation("ddt.loader.loadItemStrengthenGoodsInfoListFail");
         _loc1_.analyzer = new ItemStrengthenGoodsInfoAnalyzer(ItemStrengthenGoodsInfoManager.setup);
         _loc1_.addEventListener(LoaderEvent.LOAD_ERROR,this.__onLoadError);
         return _loc1_;
      }
      
      public function creatHallIcon() : BaseLoader
      {
         var _loc1_:BaseLoader = LoadResourceManager.instance.createLoader(PathManager.solveRequestPath("ButtonConfig.xml"),BaseLoader.COMPRESS_TEXT_LOADER);
         _loc1_.loadErrorMessage = LanguageMgr.GetTranslation("ddt.loader.loadHallIconFail");
         _loc1_.analyzer = new HallIconDataAnalyz(MainButtonManager.instance.gethallIconInfo);
         _loc1_.addEventListener(LoaderEvent.LOAD_ERROR,this.__onLoadError);
         return _loc1_;
      }
      
      public function createSingleDungeon() : BaseLoader
      {
         var _loc1_:BaseLoader = LoadResourceManager.instance.createLoader(PathManager.solveRequestPath("LoadSceneMapScene.xml"),BaseLoader.COMPRESS_TEXT_LOADER);
         _loc1_.loadErrorMessage = LanguageMgr.GetTranslation("ddt.loader.loadHallIconFail");
         _loc1_.analyzer = new MapSceneDataAnalyzer(SingleDungeonManager.Instance.DungeonListComplete);
         _loc1_.addEventListener(LoaderEvent.LOAD_ERROR,this.__onLoadError);
         return _loc1_;
      }
      
      public function createDungeonMapList() : BaseLoader
      {
         var _loc1_:BaseLoader = LoadResourceManager.instance.createLoader(PathManager.solveRequestPath("LoadSceneMapMap.xml"),BaseLoader.COMPRESS_TEXT_LOADER);
         _loc1_.loadErrorMessage = LanguageMgr.GetTranslation("ddt.loader.loadHallIconFail");
         _loc1_.analyzer = new BigMapDataAnalyzer(SingleDungeonManager.Instance.mapListComplete);
         _loc1_.addEventListener(LoaderEvent.LOAD_ERROR,this.__onLoadError);
         return _loc1_;
      }
      
      public function createDungeonMapObjList() : BaseLoader
      {
         var _loc1_:BaseLoader = LoadResourceManager.instance.createLoader(PathManager.solveRequestPath("LoadSceneMapObject.xml"),BaseLoader.COMPRESS_TEXT_LOADER);
         _loc1_.loadErrorMessage = LanguageMgr.GetTranslation("ddt.loader.loadHallIconFail");
         _loc1_.analyzer = new MapSceneObjectsAnalyzer(SingleDungeonManager.Instance.setMapObjList);
         _loc1_.addEventListener(LoaderEvent.LOAD_ERROR,this.__onLoadError);
         return _loc1_;
      }
      
      public function creatEquipComposeXmlLoader() : BaseLoader
      {
         var _loc1_:BaseLoader = LoadResourceManager.instance.createLoader(PathManager.solveRequestPath("EquipComposeList.xml"),BaseLoader.COMPRESS_TEXT_LOADER);
         _loc1_.loadErrorMessage = LanguageMgr.GetTranslation("ddt.loader.loadEquipComposeFail");
         _loc1_.analyzer = new ComposeItemAnalyzer(ComposeController.instance.intComposeItemInfoDic);
         _loc1_.addEventListener(LoaderEvent.LOAD_ERROR,this.__onLoadError);
         return _loc1_;
      }
      
      public function creatEquipSuitListXmlLoader() : BaseLoader
      {
         var _loc1_:BaseLoader = LoadResourceManager.instance.createLoader(PathManager.solveRequestPath("EquipComposeConfigList.xml"),BaseLoader.COMPRESS_TEXT_LOADER);
         _loc1_.loadErrorMessage = LanguageMgr.GetTranslation("ddt.loader.loadEquipSuitListFail");
         _loc1_.analyzer = new ComposeConfigListAnalyzer(ItemManager.Instance.setupComposeItemConfigList);
         _loc1_.addEventListener(LoaderEvent.LOAD_ERROR,this.__onLoadError);
         return _loc1_;
      }
      
      public function creatEquipSplitListXmlLoader() : BaseLoader
      {
         var _loc1_:BaseLoader = LoadResourceManager.instance.createLoader(PathManager.solveRequestPath("EquipSplitList.xml"),BaseLoader.COMPRESS_TEXT_LOADER);
         _loc1_.loadErrorMessage = LanguageMgr.GetTranslation("ddt.loader.loadEquipSpliteFail");
         _loc1_.analyzer = new EquipSplitListAnalyzer(ItemManager.Instance.setupEquipComposeSplitList);
         _loc1_.addEventListener(LoaderEvent.LOAD_ERROR,this.__onLoadError);
         return _loc1_;
      }
      
      public function creatEquipStrengthListXmlLoader() : BaseLoader
      {
         var _loc1_:BaseLoader = LoadResourceManager.instance.createLoader(PathManager.solveRequestPath("EquipStrengthList.xml"),BaseLoader.COMPRESS_TEXT_LOADER);
         _loc1_.loadErrorMessage = LanguageMgr.GetTranslation("ddt.loader.loadEquipStrengthList");
         _loc1_.analyzer = new EquipStrengthListAnalyzer(ItemManager.Instance.setupEquipStrengthList);
         _loc1_.addEventListener(LoaderEvent.LOAD_ERROR,this.__onLoadError);
         return _loc1_;
      }
      
      public function creatSuipLevelListXmlLoader() : BaseLoader
      {
         var _loc1_:BaseLoader = LoadResourceManager.instance.createLoader(PathManager.solveRequestPath("EquipStrengthSuit.xml"),BaseLoader.TEXT_LOADER);
         _loc1_.loadErrorMessage = LanguageMgr.GetTranslation("ddt.loader.loadSuidLevelList");
         _loc1_.analyzer = new SuidTipsAnalyzer(ItemManager.Instance.setupSuidList);
         _loc1_.addEventListener(LoaderEvent.LOAD_ERROR,this.__onLoadError);
         return _loc1_;
      }
      
      private function loadVoteXml(param1:VoteSubmitAnalyzer) : void
      {
         var _loc2_:BaseLoader = null;
         if(param1.result == VoteSubmitAnalyzer.FILENAME)
         {
            _loc2_ = LoadResourceManager.instance.createLoader(PathManager.solveRequestPath(VoteSubmitAnalyzer.FILENAME),BaseLoader.TEXT_LOADER);
            _loc2_.loadErrorMessage = LanguageMgr.GetTranslation("ddt.view.vote.loadXMLError");
            _loc2_.analyzer = new VoteInfoAnalyzer(VoteManager.Instance.loadCompleted);
            LoadResourceManager.instance.startLoad(_loc2_);
         }
      }
      
      public function __onLoadError(param1:LoaderEvent) : void
      {
         var _loc2_:String = param1.loader.loadErrorMessage;
         if(param1.loader.analyzer)
         {
            if(param1.loader.analyzer.message != null)
            {
               _loc2_ = param1.loader.loadErrorMessage + "\n" + param1.loader.analyzer.message;
            }
         }
         var _loc3_:BaseAlerFrame = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("alert"),_loc2_,LanguageMgr.GetTranslation("tank.room.RoomIIView2.affirm"));
         _loc3_.addEventListener(FrameEvent.RESPONSE,this.__onAlertResponse);
      }
      
      private function __onAlertResponse(param1:FrameEvent) : void
      {
         param1.currentTarget.removeEventListener(FrameEvent.RESPONSE,this.__onAlertResponse);
         ObjectUtils.disposeObject(param1.currentTarget);
         LeavePageManager.leaveToLoginPath();
      }
      
      public function creatBeadDataAnalyzeLoader() : BaseLoader
      {
         var _loc1_:BaseLoader = LoadResourceManager.instance.createLoader(PathManager.solveRequestPath("GemConfig.xml"),BaseLoader.COMPRESS_TEXT_LOADER);
         _loc1_.loadErrorMessage = LanguageMgr.GetTranslation("ddt.loader.LoadingBeadDataFailure");
         _loc1_.analyzer = new BeadDataAnalyzer(BeadManager.instance.getConfigData);
         _loc1_.addEventListener(LoaderEvent.LOAD_ERROR,this.__onLoadError);
         return _loc1_;
      }
      
      public function createTotemTemplateLoader() : BaseLoader
      {
         var _loc1_:BaseLoader = LoadResourceManager.instance.createLoader(PathManager.solveRequestPath("TotemInfo.xml"),BaseLoader.COMPRESS_TEXT_LOADER);
         _loc1_.loadErrorMessage = LanguageMgr.GetTranslation("ddt.loader.loadTotemInfoFail");
         _loc1_.analyzer = new TotemDataAnalyz(TotemManager.instance.setup);
         _loc1_.addEventListener(LoaderEvent.LOAD_ERROR,this.__onLoadError);
         return _loc1_;
      }
      
      public function createHonorUpTemplateLoader() : BaseLoader
      {
         var _loc1_:BaseLoader = LoadResourceManager.instance.createLoader(PathManager.solveRequestPath("TotemHonorTemplate.xml"),BaseLoader.COMPRESS_TEXT_LOADER);
         _loc1_.loadErrorMessage = LanguageMgr.GetTranslation("ddt.loader.loadHonorUpInfoFail");
         _loc1_.analyzer = new HonorUpDataAnalyz(HonorUpManager.instance.setup);
         _loc1_.addEventListener(LoaderEvent.LOAD_ERROR,this.__onLoadError);
         return _loc1_;
      }
      
      public function creatExpeditionInfoAnalyzeLoader() : BaseLoader
      {
         var _loc1_:BaseLoader = LoadResourceManager.instance.createLoader(PathManager.solveRequestPath("ExpeditionInfoList.xml"),BaseLoader.COMPRESS_TEXT_LOADER);
         _loc1_.loadErrorMessage = LanguageMgr.GetTranslation("ddt.loader.loadingExpeditionInfoFailure");
         _loc1_.analyzer = new ExpeditionDataAnalyzer(ExpeditionController.instance.setExpeditionInfoDic);
         _loc1_.addEventListener(LoaderEvent.LOAD_ERROR,this.__onLoadError);
         return _loc1_;
      }
      
      public function createVipInfoAnalyzerLoader() : BaseLoader
      {
         var _loc1_:BaseLoader = LoadResourceManager.instance.createLoader(PathManager.solveRequestPath("VipPrivilegeConfigInfo.xml"),BaseLoader.COMPRESS_TEXT_LOADER);
         _loc1_.loadErrorMessage = LanguageMgr.GetTranslation("ddt.loader.loadingVipditionInfoFailure");
         _loc1_.analyzer = new VipPrivilegeConfigAnalyzer(VipPrivilegeConfigManager.Instance.setupVipList);
         _loc1_.addEventListener(LoaderEvent.LOAD_ERROR,this.__onLoadError);
         return _loc1_;
      }
      
      public function creatActivityInfoListLoader() : BaseLoader
      {
         var _loc1_:BaseLoader = LoadResourceManager.instance.createLoader(PathManager.solveRequestXMLPath("ActivityInfoList.xml"),BaseLoader.COMPRESS_TEXT_LOADER);
         _loc1_.loadErrorMessage = LanguageMgr.GetTranslation("ddt.loader.LoadingActivityInfoListFailure");
         _loc1_.analyzer = new ActivityInfoAnalyzer(ActivityController.instance.setActivityInfo);
         _loc1_.addEventListener(LoaderEvent.LOAD_ERROR,this.__onLoadError);
         return _loc1_;
      }
      
      public function creatActivityConditionListLoader() : BaseLoader
      {
         var _loc1_:BaseLoader = LoadResourceManager.instance.createLoader(PathManager.solveRequestXMLPath("ActivityConditionList.xml"),BaseLoader.COMPRESS_TEXT_LOADER);
         _loc1_.loadErrorMessage = LanguageMgr.GetTranslation("ddt.loader.LoadingActivityConditionListFailure");
         _loc1_.analyzer = new ActivityConditionAnalyzer(ActivityController.instance.setActivityCondition);
         _loc1_.addEventListener(LoaderEvent.LOAD_ERROR,this.__onLoadError);
         return _loc1_;
      }
      
      public function creatActivityGiftbagListLoader() : BaseLoader
      {
         var _loc1_:BaseLoader = LoadResourceManager.instance.createLoader(PathManager.solveRequestXMLPath("ActivityGiftbagList.xml"),BaseLoader.COMPRESS_TEXT_LOADER);
         _loc1_.loadErrorMessage = LanguageMgr.GetTranslation("ddt.loader.LoadingActivityGiftbagListFailure");
         _loc1_.analyzer = new ActivityGiftbagAnalyzer(ActivityController.instance.setActivityGiftbag);
         _loc1_.addEventListener(LoaderEvent.LOAD_ERROR,this.__onLoadError);
         return _loc1_;
      }
      
      public function creatActivityRewardListLoader() : BaseLoader
      {
         var _loc1_:BaseLoader = LoadResourceManager.instance.createLoader(PathManager.solveRequestXMLPath("ActivityRewardList.xml"),BaseLoader.COMPRESS_TEXT_LOADER);
         _loc1_.loadErrorMessage = LanguageMgr.GetTranslation("ddt.loader.LoadingActivityRewardListFailure");
         _loc1_.analyzer = new ActivityRewardAnalyzer(ActivityController.instance.setActivityReward);
         _loc1_.addEventListener(LoaderEvent.LOAD_ERROR,this.__onLoadError);
         return _loc1_;
      }
      
      public function creatInvitedFriendListLoader() : BaseLoader
      {
         var _loc1_:URLVariables = RequestVairableCreater.creatWidthKey(true);
         _loc1_["id"] = PlayerManager.Instance.Self.ID;
         _loc1_["uname"] = PlayerManager.Instance.Account.Account;
         var _loc2_:BaseLoader = LoadResourceManager.instance.createLoader(PathManager.solveRequestPath("CloseFriendsLoad.ashx"),BaseLoader.REQUEST_LOADER,_loc1_);
         _loc2_.loadErrorMessage = LanguageMgr.GetTranslation("ddt.loader.LoadingBuddyListFailure");
         _loc2_.analyzer = new InvitedFriendListAnalyzer(PlayerManager.Instance.setupInvitedFriendList);
         _loc2_.addEventListener(LoaderEvent.LOAD_ERROR,this.__onLoadError);
         return _loc2_;
      }
   }
}
