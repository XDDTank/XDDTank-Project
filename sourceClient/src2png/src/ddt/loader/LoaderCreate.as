// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//ddt.loader.LoaderCreate

package ddt.loader
{
    import com.pickgliss.loader.LoadResourceManager;
    import ddt.manager.PathManager;
    import com.pickgliss.loader.BaseLoader;
    import ddt.manager.LanguageMgr;
    import com.pickgliss.loader.LoaderEvent;
    import com.pickgliss.loader.ModuleLoader;
    import ddt.data.analyze.BallInfoAnalyzer;
    import ddt.manager.BallManager;
    import ddt.data.analyze.BoxTempInfoAnalyzer;
    import ddt.manager.BossBoxManager;
    import ddt.data.analyze.DungeonAnalyzer;
    import ddt.manager.MapManager;
    import ddt.utils.RequestVairableCreater;
    import flash.net.URLVariables;
    import ddt.manager.PlayerManager;
    import ddt.data.analyze.FriendListAnalyzer;
    import ddt.data.analyze.GoodCategoryAnalyzer;
    import ddt.manager.ItemManager;
    import ddt.data.analyze.ItemTempleteAnalyzer;
    import ddt.data.analyze.EquipmentTemplateAnalyzer;
    import ddt.data.analyze.EquipPropertyListAnalyzer;
    import ddt.data.analyze.BagCellInfoListAnalyze;
    import com.pickgliss.loader.LoaderSavingManager;
    import com.pickgliss.loader.TextLoader;
    import ddt.data.analyze.BadgeInfoAnalyzer;
    import ddt.manager.BadgeInfoManager;
    import ddt.data.analyze.MovingNotificationAnalyzer;
    import roomList.movingNotification.MovingNotificationManager;
    import ddt.data.analyze.DaylyGiveAnalyzer;
    import liveness.LivenessAwardManager;
    import ddt.data.analyze.MapAnalyzer;
    import ddt.data.analyze.WeekOpenMapAnalyze;
    import ddt.data.analyze.QuestListAnalyzer;
    import ddt.manager.TaskManager;
    import flash.utils.getDefinitionByName;
    import com.pickgliss.loader.RequestLoader;
    import ddt.data.analyze.RegisterAnalyzer;
    import ddt.data.analyze.LoginSelectListAnalyzer;
    import ddt.manager.SelectListManager;
    import ddt.data.analyze.ServerListAnalyzer;
    import ddt.manager.ServerManager;
    import ddt.data.analyze.WorldBossRankAnalyzer;
    import worldboss.WorldBossRoomController;
    import ddt.data.analyze.WorldBossTimeAnalyzer;
    import ddt.data.analyze.ShopItemAnalyzer;
    import ddt.manager.ShopManager;
    import ddt.data.analyze.GoodsAdditionAnalyer;
    import ddt.data.GoodsAdditioner;
    import ddt.data.analyze.ShopItemSortAnalyzer;
    import ddt.data.analyze.UserBoxInfoAnalyzer;
    import ddt.data.analyze.FilterWordAnalyzer;
    import ddt.utils.FilterWordManager;
    import consortion.analyze.ConsortionMemberAnalyer;
    import consortion.ConsortionModelControl;
    import liveness.DailyReceiveManager;
    import consortion.analyze.ConsortionListAnalyzer;
    import feedback.analyze.LoadFeedbackReplyAnalyzer;
    import feedback.FeedbackManager;
    import ddt.data.analyze.ExpericenceAnalyze;
    import ddt.data.Experience;
    import ddt.data.analyze.PetExpericenceAnalyze;
    import ddt.data.PetExperienceManager;
    import ddt.data.analyze.WeaponBallInfoAnalyze;
    import ddt.manager.WeaponBallManager;
    import ddt.data.analyze.DailyLeagueAwardAnalyzer;
    import ddt.manager.DailyLeagueManager;
    import ddt.data.analyze.DailyLeagueLevelAnalyzer;
    import ddt.data.analyze.ServerConfigAnalyz;
    import ddt.manager.ServerConfigManager;
    import ddt.data.analyze.VoteSubmitAnalyzer;
    import store.analyze.StoreEquipExpericenceAnalyze;
    import store.data.StoreEquipExperience;
    import store.view.strength.analyzer.ItemStrengthenGoodsInfoAnalyzer;
    import store.view.strength.manager.ItemStrengthenGoodsInfoManager;
    import mainbutton.data.HallIconDataAnalyz;
    import mainbutton.data.MainButtonManager;
    import SingleDungeon.dataAnalyzer.MapSceneDataAnalyzer;
    import SingleDungeon.SingleDungeonManager;
    import SingleDungeon.dataAnalyzer.BigMapDataAnalyzer;
    import SingleDungeon.dataAnalyzer.MapSceneObjectsAnalyzer;
    import store.analyze.ComposeItemAnalyzer;
    import store.view.Compose.ComposeController;
    import ddt.data.analyze.ComposeConfigListAnalyzer;
    import ddt.data.analyze.EquipSplitListAnalyzer;
    import ddt.data.analyze.EquipStrengthListAnalyzer;
    import ddt.data.analyze.SuidTipsAnalyzer;
    import ddt.data.analyze.VoteInfoAnalyzer;
    import ddt.manager.VoteManager;
    import com.pickgliss.ui.AlertManager;
    import com.pickgliss.ui.controls.alert.BaseAlerFrame;
    import com.pickgliss.events.FrameEvent;
    import com.pickgliss.utils.ObjectUtils;
    import ddt.manager.LeavePageManager;
    import ddt.data.analyze.BeadDataAnalyzer;
    import bead.BeadManager;
    import totem.data.TotemDataAnalyz;
    import totem.TotemManager;
    import totem.data.HonorUpDataAnalyz;
    import totem.HonorUpManager;
    import ddt.data.analyze.ExpeditionDataAnalyzer;
    import SingleDungeon.expedition.ExpeditionController;
    import ddt.data.analyze.VipPrivilegeConfigAnalyzer;
    import ddt.manager.VipPrivilegeConfigManager;
    import activity.analyze.ActivityInfoAnalyzer;
    import activity.ActivityController;
    import activity.analyze.ActivityConditionAnalyzer;
    import activity.analyze.ActivityGiftbagAnalyzer;
    import activity.analyze.ActivityRewardAnalyzer;
    import ddt.data.analyze.InvitedFriendListAnalyzer;

    public class LoaderCreate 
    {

        private static var _instance:LoaderCreate;

        private var _reloadCount:int = 0;
        private var _reloadQuestCount:int = 0;


        public static function get Instance():LoaderCreate
        {
            if (_instance == null)
            {
                _instance = new (LoaderCreate)();
            };
            return (_instance);
        }


        public function createAudioILoader():BaseLoader
        {
            var _local_1:BaseLoader = LoadResourceManager.instance.createLoader(PathManager.solveSoundSwf(), BaseLoader.MODULE_LOADER);
            _local_1.loadErrorMessage = LanguageMgr.GetTranslation("ddt.loader.LoadingAudioIFail");
            _local_1.addEventListener(LoaderEvent.LOAD_ERROR, this.__onLoadError);
            return (_local_1);
        }

        public function createAudioIILoader():BaseLoader
        {
            var _local_1:BaseLoader = LoadResourceManager.instance.createLoader(PathManager.solveSoundSwf2(), BaseLoader.MODULE_LOADER);
            _local_1.loadErrorMessage = LanguageMgr.GetTranslation("ddt.loader.LoadingAudioIIFail");
            _local_1.addEventListener(LoaderEvent.LOAD_ERROR, this.__onLoadError);
            return (_local_1);
        }

        public function loadExppression(_arg_1:Function):void
        {
            var _local_2:ModuleLoader = LoadResourceManager.instance.createLoader(PathManager.getExpressionPath(), BaseLoader.MODULE_LOADER);
            _local_2.loadErrorMessage = LanguageMgr.GetTranslation("ddt.loader.LoadingExpressionResourcesFailure");
            _local_2.addEventListener(LoaderEvent.LOAD_ERROR, this.__onLoadError);
            _local_2.addEventListener(LoaderEvent.COMPLETE, _arg_1);
            LoadResourceManager.instance.startLoad(_local_2);
        }

        public function creatBallInfoLoader():BaseLoader
        {
            var _local_1:BaseLoader = LoadResourceManager.instance.createLoader(PathManager.solveRequestPath("BallList.xml"), BaseLoader.COMPRESS_TEXT_LOADER);
            _local_1.loadErrorMessage = LanguageMgr.GetTranslation("ddt.loader.LoadingBombMetadataFailure");
            _local_1.analyzer = new BallInfoAnalyzer(BallManager.setup);
            _local_1.addEventListener(LoaderEvent.LOAD_ERROR, this.__onLoadError);
            return (_local_1);
        }

        public function creatBoxTempInfoLoader():BaseLoader
        {
            var _local_1:BaseLoader = LoadResourceManager.instance.createLoader(PathManager.solveRequestPath("LoadBoxTemp.xml"), BaseLoader.COMPRESS_TEXT_LOADER);
            _local_1.loadErrorMessage = LanguageMgr.GetTranslation("ddt.loader.LoadingChestsListFailure");
            _local_1.analyzer = new BoxTempInfoAnalyzer(BossBoxManager.instance.setupBoxTempInfo);
            _local_1.addEventListener(LoaderEvent.LOAD_ERROR, this.__onLoadError);
            return (_local_1);
        }

        public function creatDungeonInfoLoader():BaseLoader
        {
            var _local_1:BaseLoader = LoadResourceManager.instance.createLoader(PathManager.solveRequestPath("LoadPVEItems.xml"), BaseLoader.COMPRESS_TEXT_LOADER);
            _local_1.loadErrorMessage = LanguageMgr.GetTranslation("ddt.loader.LoadingCopyMapsInformationFailure");
            _local_1.analyzer = new DungeonAnalyzer(MapManager.setupDungeonInfo);
            _local_1.addEventListener(LoaderEvent.LOAD_ERROR, this.__onLoadError);
            return (_local_1);
        }

        public function creatFriendListLoader():BaseLoader
        {
            var _local_1:URLVariables = RequestVairableCreater.creatWidthKey(true);
            _local_1["id"] = PlayerManager.Instance.Self.ID;
            _local_1["uname"] = PlayerManager.Instance.Account.Account;
            var _local_2:BaseLoader = LoadResourceManager.instance.createLoader(PathManager.solveRequestPath("IMListLoad.ashx"), BaseLoader.REQUEST_LOADER, _local_1);
            _local_2.loadErrorMessage = LanguageMgr.GetTranslation("ddt.loader.LoadingBuddyListFailure");
            _local_2.analyzer = new FriendListAnalyzer(PlayerManager.Instance.setupFriendList);
            _local_2.addEventListener(LoaderEvent.LOAD_ERROR, this.__onLoadError);
            return (_local_2);
        }

        public function creatGoodCategoryLoader():BaseLoader
        {
            var _local_1:BaseLoader = LoadResourceManager.instance.createLoader(PathManager.solveRequestPath("LoadItemsCategory.xml"), BaseLoader.COMPRESS_TEXT_LOADER);
            _local_1.loadErrorMessage = LanguageMgr.GetTranslation("ddt.loader.LoadingItemTypeFailure");
            _local_1.analyzer = new GoodCategoryAnalyzer(ItemManager.Instance.setupGoodsCategory);
            _local_1.addEventListener(LoaderEvent.LOAD_ERROR, this.__onLoadError);
            return (_local_1);
        }

        public function creatItemTempleteLoader():BaseLoader
        {
            var _local_1:BaseLoader = LoadResourceManager.instance.createLoader(PathManager.solveRequestPath("TemplateAllList.xml"), BaseLoader.COMPRESS_TEXT_LOADER);
            _local_1.loadErrorMessage = LanguageMgr.GetTranslation("ddt.loader.LoadingGoodsTemplateFailure");
            _local_1.analyzer = new ItemTempleteAnalyzer(ItemManager.Instance.setupGoodsTemplates);
            _local_1.addEventListener(LoaderEvent.LOAD_ERROR, this.__onLoadError);
            return (_local_1);
        }

        public function creatEquipTempleteLoader():BaseLoader
        {
            var _local_1:BaseLoader = LoadResourceManager.instance.createLoader(PathManager.solveRequestPath("EquipTemplateList.xml"), BaseLoader.COMPRESS_TEXT_LOADER);
            _local_1.loadErrorMessage = LanguageMgr.GetTranslation("ddt.loader.LoadingEquipTemplateFailure");
            _local_1.analyzer = new EquipmentTemplateAnalyzer(ItemManager.Instance.setupEquipsTemplates);
            _local_1.addEventListener(LoaderEvent.LOAD_ERROR, this.__onLoadError);
            return (_local_1);
        }

        public function creatEquipPropertyList():BaseLoader
        {
            var _local_1:BaseLoader = LoadResourceManager.instance.createLoader(PathManager.solveRequestPath("EquipPropertyList.xml"), BaseLoader.COMPRESS_TEXT_LOADER);
            _local_1.loadErrorMessage = LanguageMgr.GetTranslation("ddt.loader.LoadingEquipPropertyListFailuer");
            _local_1.analyzer = new EquipPropertyListAnalyzer(ItemManager.Instance.setupEquipPropertyList);
            _local_1.addEventListener(LoaderEvent.LOAD_ERROR, this.__onLoadError);
            return (_local_1);
        }

        public function creatBagCellInfoList():BaseLoader
        {
            var _local_1:BaseLoader = LoadResourceManager.instance.createLoader(PathManager.solveRequestPath("BagCellInfoList.xml"), BaseLoader.COMPRESS_TEXT_LOADER);
            _local_1.loadErrorMessage = LanguageMgr.GetTranslation("ddt.loader.LoadingBagCellListFailuer");
            _local_1.analyzer = new BagCellInfoListAnalyze(ItemManager.Instance.setupBagCellList);
            _local_1.addEventListener(LoaderEvent.LOAD_ERROR, this.__onLoadError);
            return (_local_1);
        }

        public function creatItemTempleteReload():BaseLoader
        {
            this._reloadCount = (this._reloadCount + 1);
            var _local_1:URLVariables = new URLVariables();
            _local_1["lv"] = (LoaderSavingManager.Version + this._reloadCount);
            _local_1["rnd"] = (TextLoader.TextLoaderKey + this._reloadCount.toString());
            var _local_2:BaseLoader = LoadResourceManager.instance.createLoader(PathManager.solveRequestPath("ShopBox.xml"), BaseLoader.TEXT_LOADER, _local_1);
            _local_2.loadErrorMessage = LanguageMgr.GetTranslation("ddt.loader.LoadingNewGoodsTemplateFailure");
            _local_2.analyzer = new ItemTempleteAnalyzer(ItemManager.Instance.addGoodsTemplates);
            _local_2.addEventListener(LoaderEvent.LOAD_ERROR, this.__onLoadError);
            return (_local_2);
        }

        public function creatBadgeInfoLoader():BaseLoader
        {
            var _local_1:BaseLoader = LoadResourceManager.instance.createLoader(PathManager.solveRequestPath("ConsortiaBadgeConfig.xml"), BaseLoader.COMPRESS_TEXT_LOADER);
            _local_1.loadErrorMessage = LanguageMgr.GetTranslation("ddt.loader.LoadingBadgeInfoFailure");
            _local_1.analyzer = new BadgeInfoAnalyzer(BadgeInfoManager.instance.setup);
            _local_1.addEventListener(LoaderEvent.LOAD_ERROR, this.__onLoadError);
            return (_local_1);
        }

        public function creatMovingNotificationLoader():BaseLoader
        {
            var _local_1:BaseLoader = LoadResourceManager.instance.createLoader(PathManager.getMovingNotificationPath(), BaseLoader.TEXT_LOADER);
            _local_1.loadErrorMessage = LanguageMgr.GetTranslation("ddt.loader.LoadingAnnouncementFailure");
            _local_1.analyzer = new MovingNotificationAnalyzer(MovingNotificationManager.Instance.setup);
            _local_1.addEventListener(LoaderEvent.LOAD_ERROR, this.__onLoadError);
            return (_local_1);
        }

        public function creatDailyInfoLoader():BaseLoader
        {
            var _local_1:BaseLoader = LoadResourceManager.instance.createLoader(PathManager.solveRequestPath("DailyAwardList.xml"), BaseLoader.COMPRESS_TEXT_LOADER);
            _local_1.loadErrorMessage = LanguageMgr.GetTranslation("ddt.loader.LoadingLoginFailedRewardInformation");
            _local_1.analyzer = new DaylyGiveAnalyzer(LivenessAwardManager.Instance.setDailyInfo);
            _local_1.addEventListener(LoaderEvent.LOAD_ERROR, this.__onLoadError);
            return (_local_1);
        }

        public function creatMapInfoLoader():BaseLoader
        {
            var _local_1:BaseLoader = LoadResourceManager.instance.createLoader(PathManager.solveRequestPath("LoadMapsItems.xml"), BaseLoader.COMPRESS_TEXT_LOADER);
            _local_1.loadErrorMessage = LanguageMgr.GetTranslation("ddt.loader.LoadMapInformationFailure");
            _local_1.analyzer = new MapAnalyzer(MapManager.setupMapInfo);
            _local_1.addEventListener(LoaderEvent.LOAD_ERROR, this.__onLoadError);
            return (_local_1);
        }

        public function creatOpenMapInfoLoader():BaseLoader
        {
            var _local_1:BaseLoader = LoadResourceManager.instance.createLoader(PathManager.solveRequestPath("MapServerList.xml"), BaseLoader.COMPRESS_TEXT_LOADER);
            _local_1.loadErrorMessage = LanguageMgr.GetTranslation("ddt.loader.LoadingOpenMapListFailure");
            _local_1.analyzer = new WeekOpenMapAnalyze(MapManager.setupOpenMapInfo);
            _local_1.addEventListener(LoaderEvent.LOAD_ERROR, this.__onLoadError);
            return (_local_1);
        }

        public function creatQuestTempleteLoader():BaseLoader
        {
            var _local_1:BaseLoader = LoadResourceManager.instance.createLoader(PathManager.solveRequestPath("QuestList.xml"), BaseLoader.COMPRESS_TEXT_LOADER);
            _local_1.loadErrorMessage = LanguageMgr.GetTranslation("ddt.loader.LoadingTaskListFailure");
            _local_1.analyzer = new QuestListAnalyzer(TaskManager.instance.setup);
            _local_1.addEventListener(LoaderEvent.LOAD_ERROR, this.__onLoadError);
            return (_local_1);
        }

        public function creatQuestTempleteReload():BaseLoader
        {
            this._reloadQuestCount = (this._reloadQuestCount + 1);
            var _local_1:URLVariables = new URLVariables();
            _local_1["lv"] = (LoaderSavingManager.Version + this._reloadQuestCount);
            _local_1["rnd"] = (TextLoader.TextLoaderKey + this._reloadQuestCount.toString());
            var _local_2:BaseLoader = LoadResourceManager.instance.createLoader(PathManager.solveRequestPath("QuestList.xml"), BaseLoader.COMPRESS_TEXT_LOADER, _local_1);
            _local_2.loadErrorMessage = LanguageMgr.GetTranslation("ddt.loader.LoadingTaskListFailure");
            _local_2.analyzer = new QuestListAnalyzer(TaskManager.instance.reloadNewQuest);
            _local_2.addEventListener(LoaderEvent.LOAD_ERROR, this.__onLoadError);
            return (_local_2);
        }

        public function creatRegisterLoader():BaseLoader
        {
            var _local_1:* = getDefinitionByName("register.RegisterState");
            var _local_2:URLVariables = RequestVairableCreater.creatWidthKey(true);
            _local_2["Sex"] = _local_1.SelectedSex;
            _local_2["NickName"] = _local_1.Nickname;
            _local_2["Name"] = PlayerManager.Instance.Account.Account;
            _local_2["Pass"] = PlayerManager.Instance.Account.Password;
            _local_2["site"] = "";
            var _local_3:RequestLoader = LoadResourceManager.instance.createLoader(PathManager.solveRequestPath("VisualizeRegister.ashx"), BaseLoader.REQUEST_LOADER, _local_2);
            _local_3.loadErrorMessage = LanguageMgr.GetTranslation("ddt.loader.FailedToRegister");
            _local_3.analyzer = new RegisterAnalyzer(null);
            _local_3.addEventListener(LoaderEvent.LOAD_ERROR, this.__onLoadError);
            return (_local_3);
        }

        public function creatSelectListLoader():BaseLoader
        {
            var _local_1:URLVariables = new URLVariables();
            _local_1["rnd"] = Math.random();
            _local_1["username"] = PlayerManager.Instance.Account.Account;
            var _local_2:BaseLoader = LoadResourceManager.instance.createLoader(PathManager.solveRequestPath("LoginSelectList.ashx"), BaseLoader.REQUEST_LOADER, _local_1);
            _local_2.loadErrorMessage = LanguageMgr.GetTranslation("ddt.loader.LoadingRoleListFailure");
            _local_2.analyzer = new LoginSelectListAnalyzer(SelectListManager.Instance.setup);
            _local_2.addEventListener(LoaderEvent.LOAD_ERROR, this.__onLoadError);
            return (_local_2);
        }

        public function creatServerListLoader():BaseLoader
        {
            var _local_1:URLVariables = new URLVariables();
            _local_1["rnd"] = Math.random();
            var _local_2:BaseLoader = LoadResourceManager.instance.createLoader(PathManager.solveRequestPath("ServerList.ashx"), BaseLoader.REQUEST_LOADER, _local_1);
            _local_2.loadErrorMessage = LanguageMgr.GetTranslation("ddt.loader.LoadingServerListFailure");
            _local_2.analyzer = new ServerListAnalyzer(ServerManager.Instance.setup);
            _local_2.addEventListener(LoaderEvent.LOAD_ERROR, this.__onLoadError);
            return (_local_2);
        }

        public function creatWorldBossRankLoader():BaseLoader
        {
            this._reloadCount = (this._reloadCount + 1);
            var _local_1:URLVariables = new URLVariables();
            _local_1["lv"] = (LoaderSavingManager.Version + this._reloadCount);
            _local_1["rnd"] = (TextLoader.TextLoaderKey + this._reloadCount.toString());
            var _local_2:BaseLoader = LoadResourceManager.instance.createLoader(PathManager.solveRequestPath("WorldBossRank.ashx"), BaseLoader.TEXT_LOADER, _local_1);
            _local_2.loadErrorMessage = LanguageMgr.GetTranslation("ddt.loader.LoadingWorldBossFail");
            _local_2.analyzer = new WorldBossRankAnalyzer(WorldBossRoomController.Instance.setup);
            _local_2.addEventListener(LoaderEvent.LOAD_ERROR, this.__onLoadError);
            return (_local_2);
        }

        public function creatWorldBossTimeLoader():BaseLoader
        {
            var _local_1:URLVariables = new URLVariables();
            _local_1["rnd"] = Math.random();
            var _local_2:BaseLoader = LoadResourceManager.instance.createLoader(PathManager.solveRequestPath("WorldBossActiveTimeInfo.xml"), BaseLoader.COMPRESS_TEXT_LOADER, _local_1);
            _local_2.loadErrorMessage = LanguageMgr.GetTranslation("ddt.loader.LoadingWorldBossTimeFail");
            _local_2.analyzer = new WorldBossTimeAnalyzer(WorldBossRoomController.Instance.timeSetup);
            _local_2.addEventListener(LoaderEvent.LOAD_ERROR, this.__onLoadError);
            return (_local_2);
        }

        public function creatShopTempleteLoader():BaseLoader
        {
            var _local_1:BaseLoader = LoadResourceManager.instance.createLoader(PathManager.solveRequestPath("ShopItemList.xml"), BaseLoader.COMPRESS_TEXT_LOADER);
            _local_1.loadErrorMessage = LanguageMgr.GetTranslation("ddt.loader.LoadingStoreItemsFail");
            _local_1.analyzer = new ShopItemAnalyzer(ShopManager.Instance.setup);
            _local_1.addEventListener(LoaderEvent.LOAD_ERROR, this.__onLoadError);
            return (_local_1);
        }

        public function creatGoodsAdditionLoader():BaseLoader
        {
            var _local_1:BaseLoader = LoadResourceManager.instance.createLoader(PathManager.solveRequestPath("ItemStrengthenPlusData.xml"), BaseLoader.COMPRESS_TEXT_LOADER);
            _local_1.loadErrorMessage = LanguageMgr.GetTranslation("ddt.loader.LoadingGoodsAdditionFail");
            _local_1.analyzer = new GoodsAdditionAnalyer(GoodsAdditioner.Instance.addGoodsAddition);
            _local_1.addEventListener(LoaderEvent.LOAD_ERROR, this.__onLoadError);
            return (_local_1);
        }

        public function creatShopSortLoader():BaseLoader
        {
            var _local_1:BaseLoader = LoadResourceManager.instance.createLoader(PathManager.solveRequestPath("ShopGoodsShowList.xml"), BaseLoader.COMPRESS_TEXT_LOADER);
            _local_1.loadErrorMessage = LanguageMgr.GetTranslation("ddt.loader.TheClassificationOfGoodsLoadingShopFailure");
            _local_1.analyzer = new ShopItemSortAnalyzer(ShopManager.Instance.sortShopItems);
            _local_1.addEventListener(LoaderEvent.LOAD_ERROR, this.__onLoadError);
            return (_local_1);
        }

        public function creatUserBoxInfoLoader():BaseLoader
        {
            var _local_1:BaseLoader = LoadResourceManager.instance.createLoader(PathManager.solveRequestPath("LoadUserBox.xml"), BaseLoader.COMPRESS_TEXT_LOADER);
            _local_1.loadErrorMessage = LanguageMgr.GetTranslation("ddt.loader.LoadingChestsInformationFailure");
            _local_1.analyzer = new UserBoxInfoAnalyzer(BossBoxManager.instance.setupBoxInfo);
            _local_1.addEventListener(LoaderEvent.LOAD_ERROR, this.__onLoadError);
            return (_local_1);
        }

        public function creatZhanLoader():BaseLoader
        {
            var _local_1:BaseLoader = LoadResourceManager.instance.createLoader(PathManager.getZhanPath(), BaseLoader.TEXT_LOADER);
            _local_1.loadErrorMessage = "LoadingDirtyCharacterSheetsFailure";
            _local_1.analyzer = new FilterWordAnalyzer(FilterWordManager.setup);
            _local_1.addEventListener(LoaderEvent.LOAD_ERROR, this.__onLoadError);
            return (_local_1);
        }

        public function createConsortiaLoader():BaseLoader
        {
            var _local_1:URLVariables = RequestVairableCreater.creatWidthKey(true);
            _local_1["id"] = PlayerManager.Instance.Self.ID;
            _local_1["page"] = 1;
            _local_1["size"] = 10000;
            _local_1["order"] = -1;
            _local_1["consortiaID"] = PlayerManager.Instance.Self.ConsortiaID;
            _local_1["userID"] = -1;
            _local_1["state"] = -1;
            var _local_2:BaseLoader = LoadResourceManager.instance.createLoader(PathManager.solveRequestPath("ConsortiaUsersList.ashx"), BaseLoader.REQUEST_LOADER, _local_1);
            _local_2.loadErrorMessage = LanguageMgr.GetTranslation("ddt.loader.LoadingGuildMembersListFailure");
            _local_2.analyzer = new ConsortionMemberAnalyer(ConsortionModelControl.Instance.memberListComplete);
            _local_2.addEventListener(LoaderEvent.LOAD_ERROR, this.__onLoadError);
            return (_local_2);
        }

        public function createCalendarRequest():BaseLoader
        {
            return (DailyReceiveManager.Instance.request());
        }

        public function getMyConsortiaData():BaseLoader
        {
            var _local_1:URLVariables = RequestVairableCreater.creatWidthKey(true);
            _local_1["page"] = 1;
            _local_1["size"] = 1;
            _local_1["name"] = "";
            _local_1["level"] = -1;
            _local_1["ConsortiaID"] = PlayerManager.Instance.Self.ConsortiaID;
            _local_1["order"] = -1;
            _local_1["openApply"] = -1;
            var _local_2:BaseLoader = LoadResourceManager.instance.createLoader(PathManager.solveRequestPath("ConsortiaList.ashx"), BaseLoader.COMPRESS_REQUEST_LOADER, _local_1);
            _local_2.loadErrorMessage = LanguageMgr.GetTranslation("tank.consortia.myconsortia.frame.LoadMyconsortiaInfoError");
            _local_2.analyzer = new ConsortionListAnalyzer(ConsortionModelControl.Instance.selfConsortionComplete);
            _local_2.addEventListener(LoaderEvent.LOAD_ERROR, this.__onLoadError);
            return (_local_2);
        }

        public function creatFeedbackInfoLoader():BaseLoader
        {
            var _local_1:URLVariables = RequestVairableCreater.creatWidthKey(true);
            _local_1["userid"] = PlayerManager.Instance.Self.ID;
            var _local_2:BaseLoader = LoadResourceManager.instance.createLoader(PathManager.solveRequestPath("AdvanceQuestionRead.ashx"), BaseLoader.REQUEST_LOADER, _local_1);
            _local_2.loadErrorMessage = LanguageMgr.GetTranslation("ddt.loader.LoadingComplainInformationFailure");
            _local_2.analyzer = new LoadFeedbackReplyAnalyzer(FeedbackManager.instance.setupFeedbackData);
            _local_2.addEventListener(LoaderEvent.LOAD_ERROR, this.__onLoadError);
            return (_local_2);
        }

        public function creatExpericenceAnalyzeLoader():BaseLoader
        {
            var _local_1:BaseLoader = LoadResourceManager.instance.createLoader(PathManager.solveRequestPath("LevelList.xml"), BaseLoader.COMPRESS_TEXT_LOADER);
            _local_1.loadErrorMessage = LanguageMgr.GetTranslation("ddt.loader.LoadingAchievementTemplateFormFailure");
            _local_1.analyzer = new ExpericenceAnalyze(Experience.setup);
            _local_1.addEventListener(LoaderEvent.LOAD_ERROR, this.__onLoadError);
            return (_local_1);
        }

        public function creatPetExpericenceAnalyzeLoader():BaseLoader
        {
            var _local_1:BaseLoader = LoadResourceManager.instance.createLoader(PathManager.solveRequestPath("PetLevelInfo.xml"), BaseLoader.TEXT_LOADER);
            _local_1.loadErrorMessage = LanguageMgr.GetTranslation("ddt.loader.LoadingPetExpirenceTemplateFormFailure");
            _local_1.analyzer = new PetExpericenceAnalyze(PetExperienceManager.setup);
            _local_1.addEventListener(LoaderEvent.LOAD_ERROR, this.__onLoadError);
            return (_local_1);
        }

        public function creatWeaponBallAnalyzeLoader():BaseLoader
        {
            var _local_1:BaseLoader = LoadResourceManager.instance.createLoader(PathManager.solveRequestPath("BombConfig.xml"), BaseLoader.COMPRESS_TEXT_LOADER);
            _local_1.loadErrorMessage = LanguageMgr.GetTranslation("ddt.loader.LoadingWeaponBallListFormFailure");
            _local_1.analyzer = new WeaponBallInfoAnalyze(WeaponBallManager.setup);
            _local_1.addEventListener(LoaderEvent.LOAD_ERROR, this.__onLoadError);
            return (_local_1);
        }

        public function creatDailyLeagueAwardLoader():BaseLoader
        {
            var _local_1:BaseLoader = LoadResourceManager.instance.createLoader(PathManager.solveRequestPath("DailyLeagueAward.xml"), BaseLoader.COMPRESS_TEXT_LOADER);
            _local_1.loadErrorMessage = LanguageMgr.GetTranslation("ddt.loader.LoadingDailyLeagueAwardFailure");
            _local_1.analyzer = new DailyLeagueAwardAnalyzer(DailyLeagueManager.Instance.setup);
            _local_1.addEventListener(LoaderEvent.LOAD_ERROR, this.__onLoadError);
            return (_local_1);
        }

        public function creatDailyLeagueLevelLoader():BaseLoader
        {
            var _local_1:BaseLoader = LoadResourceManager.instance.createLoader(PathManager.solveRequestPath("DailyLeagueLevel.xml"), BaseLoader.COMPRESS_TEXT_LOADER);
            _local_1.loadErrorMessage = LanguageMgr.GetTranslation("ddt.loader.LoadingDailyLeagueLevelFailure");
            _local_1.analyzer = new DailyLeagueLevelAnalyzer(DailyLeagueManager.Instance.setup);
            _local_1.addEventListener(LoaderEvent.LOAD_ERROR, this.__onLoadError);
            return (_local_1);
        }

        public function creatServerConfigLoader():BaseLoader
        {
            var _local_1:BaseLoader = LoadResourceManager.instance.createLoader(PathManager.solveRequestPath("ServerConfig.xml"), BaseLoader.TEXT_LOADER);
            _local_1.loadErrorMessage = LanguageMgr.GetTranslation("ddt.loader.LoadingDailyLeagueLevelFailure");
            _local_1.analyzer = new ServerConfigAnalyz(ServerConfigManager.instance.getserverConfigInfo);
            _local_1.addEventListener(LoaderEvent.LOAD_ERROR, this.__onLoadError);
            return (_local_1);
        }

        public function creatVoteSubmit():BaseLoader
        {
            var _local_1:URLVariables = new URLVariables();
            _local_1["userId"] = PlayerManager.Instance.Self.ID;
            var _local_2:BaseLoader = LoadResourceManager.instance.createLoader(PathManager.solveRequestPath("VoteSubmit.ashx"), BaseLoader.REQUEST_LOADER, _local_1);
            _local_2.loadErrorMessage = LanguageMgr.GetTranslation("ddt.vip.loadVip.error");
            _local_2.analyzer = new VoteSubmitAnalyzer(this.loadVoteXml);
            return (_local_2);
        }

        public function createStoreEquipConfigLoader():BaseLoader
        {
            var _local_1:BaseLoader = LoadResourceManager.instance.createLoader(PathManager.solveRequestPath("LoadStrengthExp.xml"), BaseLoader.TEXT_LOADER);
            _local_1.loadErrorMessage = LanguageMgr.GetTranslation("ddt.loader.loadStoreEquipExperienceAllFail");
            _local_1.analyzer = new StoreEquipExpericenceAnalyze(StoreEquipExperience.setup);
            _local_1.addEventListener(LoaderEvent.LOAD_ERROR, this.__onLoadError);
            return (_local_1);
        }

        public function creatItemStrengthenGoodsInfoLoader():BaseLoader
        {
            var _local_1:BaseLoader = LoadResourceManager.instance.createLoader(PathManager.solveRequestPath("ItemStrengthenGoodsInfo.xml"), BaseLoader.COMPRESS_TEXT_LOADER);
            _local_1.loadErrorMessage = LanguageMgr.GetTranslation("ddt.loader.loadItemStrengthenGoodsInfoListFail");
            _local_1.analyzer = new ItemStrengthenGoodsInfoAnalyzer(ItemStrengthenGoodsInfoManager.setup);
            _local_1.addEventListener(LoaderEvent.LOAD_ERROR, this.__onLoadError);
            return (_local_1);
        }

        public function creatHallIcon():BaseLoader
        {
            var _local_1:BaseLoader = LoadResourceManager.instance.createLoader(PathManager.solveRequestPath("ButtonConfig.xml"), BaseLoader.COMPRESS_TEXT_LOADER);
            _local_1.loadErrorMessage = LanguageMgr.GetTranslation("ddt.loader.loadHallIconFail");
            _local_1.analyzer = new HallIconDataAnalyz(MainButtonManager.instance.gethallIconInfo);
            _local_1.addEventListener(LoaderEvent.LOAD_ERROR, this.__onLoadError);
            return (_local_1);
        }

        public function createSingleDungeon():BaseLoader
        {
            var _local_1:BaseLoader = LoadResourceManager.instance.createLoader(PathManager.solveRequestPath("LoadSceneMapScene.xml"), BaseLoader.COMPRESS_TEXT_LOADER);
            _local_1.loadErrorMessage = LanguageMgr.GetTranslation("ddt.loader.loadHallIconFail");
            _local_1.analyzer = new MapSceneDataAnalyzer(SingleDungeonManager.Instance.DungeonListComplete);
            _local_1.addEventListener(LoaderEvent.LOAD_ERROR, this.__onLoadError);
            return (_local_1);
        }

        public function createDungeonMapList():BaseLoader
        {
            var _local_1:BaseLoader = LoadResourceManager.instance.createLoader(PathManager.solveRequestPath("LoadSceneMapMap.xml"), BaseLoader.COMPRESS_TEXT_LOADER);
            _local_1.loadErrorMessage = LanguageMgr.GetTranslation("ddt.loader.loadHallIconFail");
            _local_1.analyzer = new BigMapDataAnalyzer(SingleDungeonManager.Instance.mapListComplete);
            _local_1.addEventListener(LoaderEvent.LOAD_ERROR, this.__onLoadError);
            return (_local_1);
        }

        public function createDungeonMapObjList():BaseLoader
        {
            var _local_1:BaseLoader = LoadResourceManager.instance.createLoader(PathManager.solveRequestPath("LoadSceneMapObject.xml"), BaseLoader.COMPRESS_TEXT_LOADER);
            _local_1.loadErrorMessage = LanguageMgr.GetTranslation("ddt.loader.loadHallIconFail");
            _local_1.analyzer = new MapSceneObjectsAnalyzer(SingleDungeonManager.Instance.setMapObjList);
            _local_1.addEventListener(LoaderEvent.LOAD_ERROR, this.__onLoadError);
            return (_local_1);
        }

        public function creatEquipComposeXmlLoader():BaseLoader
        {
            var _local_1:BaseLoader = LoadResourceManager.instance.createLoader(PathManager.solveRequestPath("EquipComposeList.xml"), BaseLoader.COMPRESS_TEXT_LOADER);
            _local_1.loadErrorMessage = LanguageMgr.GetTranslation("ddt.loader.loadEquipComposeFail");
            _local_1.analyzer = new ComposeItemAnalyzer(ComposeController.instance.intComposeItemInfoDic);
            _local_1.addEventListener(LoaderEvent.LOAD_ERROR, this.__onLoadError);
            return (_local_1);
        }

        public function creatEquipSuitListXmlLoader():BaseLoader
        {
            var _local_1:BaseLoader = LoadResourceManager.instance.createLoader(PathManager.solveRequestPath("EquipComposeConfigList.xml"), BaseLoader.COMPRESS_TEXT_LOADER);
            _local_1.loadErrorMessage = LanguageMgr.GetTranslation("ddt.loader.loadEquipSuitListFail");
            _local_1.analyzer = new ComposeConfigListAnalyzer(ItemManager.Instance.setupComposeItemConfigList);
            _local_1.addEventListener(LoaderEvent.LOAD_ERROR, this.__onLoadError);
            return (_local_1);
        }

        public function creatEquipSplitListXmlLoader():BaseLoader
        {
            var _local_1:BaseLoader = LoadResourceManager.instance.createLoader(PathManager.solveRequestPath("EquipSplitList.xml"), BaseLoader.COMPRESS_TEXT_LOADER);
            _local_1.loadErrorMessage = LanguageMgr.GetTranslation("ddt.loader.loadEquipSpliteFail");
            _local_1.analyzer = new EquipSplitListAnalyzer(ItemManager.Instance.setupEquipComposeSplitList);
            _local_1.addEventListener(LoaderEvent.LOAD_ERROR, this.__onLoadError);
            return (_local_1);
        }

        public function creatEquipStrengthListXmlLoader():BaseLoader
        {
            var _local_1:BaseLoader = LoadResourceManager.instance.createLoader(PathManager.solveRequestPath("EquipStrengthList.xml"), BaseLoader.COMPRESS_TEXT_LOADER);
            _local_1.loadErrorMessage = LanguageMgr.GetTranslation("ddt.loader.loadEquipStrengthList");
            _local_1.analyzer = new EquipStrengthListAnalyzer(ItemManager.Instance.setupEquipStrengthList);
            _local_1.addEventListener(LoaderEvent.LOAD_ERROR, this.__onLoadError);
            return (_local_1);
        }

        public function creatSuipLevelListXmlLoader():BaseLoader
        {
            var _local_1:BaseLoader = LoadResourceManager.instance.createLoader(PathManager.solveRequestPath("EquipStrengthSuit.xml"), BaseLoader.TEXT_LOADER);
            _local_1.loadErrorMessage = LanguageMgr.GetTranslation("ddt.loader.loadSuidLevelList");
            _local_1.analyzer = new SuidTipsAnalyzer(ItemManager.Instance.setupSuidList);
            _local_1.addEventListener(LoaderEvent.LOAD_ERROR, this.__onLoadError);
            return (_local_1);
        }

        private function loadVoteXml(_arg_1:VoteSubmitAnalyzer):void
        {
            var _local_2:BaseLoader;
            if (_arg_1.result == VoteSubmitAnalyzer.FILENAME)
            {
                _local_2 = LoadResourceManager.instance.createLoader(PathManager.solveRequestPath(VoteSubmitAnalyzer.FILENAME), BaseLoader.TEXT_LOADER);
                _local_2.loadErrorMessage = LanguageMgr.GetTranslation("ddt.view.vote.loadXMLError");
                _local_2.analyzer = new VoteInfoAnalyzer(VoteManager.Instance.loadCompleted);
                LoadResourceManager.instance.startLoad(_local_2);
            };
        }

        public function __onLoadError(_arg_1:LoaderEvent):void
        {
            var _local_2:String = _arg_1.loader.loadErrorMessage;
            if (_arg_1.loader.analyzer)
            {
                if (_arg_1.loader.analyzer.message != null)
                {
                    _local_2 = ((_arg_1.loader.loadErrorMessage + "\n") + _arg_1.loader.analyzer.message);
                };
            };
            var _local_3:BaseAlerFrame = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("alert"), _local_2, LanguageMgr.GetTranslation("tank.room.RoomIIView2.affirm"));
            _local_3.addEventListener(FrameEvent.RESPONSE, this.__onAlertResponse);
        }

        private function __onAlertResponse(_arg_1:FrameEvent):void
        {
            _arg_1.currentTarget.removeEventListener(FrameEvent.RESPONSE, this.__onAlertResponse);
            ObjectUtils.disposeObject(_arg_1.currentTarget);
            LeavePageManager.leaveToLoginPath();
        }

        public function creatBeadDataAnalyzeLoader():BaseLoader
        {
            var _local_1:BaseLoader = LoadResourceManager.instance.createLoader(PathManager.solveRequestPath("GemConfig.xml"), BaseLoader.COMPRESS_TEXT_LOADER);
            _local_1.loadErrorMessage = LanguageMgr.GetTranslation("ddt.loader.LoadingBeadDataFailure");
            _local_1.analyzer = new BeadDataAnalyzer(BeadManager.instance.getConfigData);
            _local_1.addEventListener(LoaderEvent.LOAD_ERROR, this.__onLoadError);
            return (_local_1);
        }

        public function createTotemTemplateLoader():BaseLoader
        {
            var _local_1:BaseLoader = LoadResourceManager.instance.createLoader(PathManager.solveRequestPath("TotemInfo.xml"), BaseLoader.COMPRESS_TEXT_LOADER);
            _local_1.loadErrorMessage = LanguageMgr.GetTranslation("ddt.loader.loadTotemInfoFail");
            _local_1.analyzer = new TotemDataAnalyz(TotemManager.instance.setup);
            _local_1.addEventListener(LoaderEvent.LOAD_ERROR, this.__onLoadError);
            return (_local_1);
        }

        public function createHonorUpTemplateLoader():BaseLoader
        {
            var _local_1:BaseLoader = LoadResourceManager.instance.createLoader(PathManager.solveRequestPath("TotemHonorTemplate.xml"), BaseLoader.COMPRESS_TEXT_LOADER);
            _local_1.loadErrorMessage = LanguageMgr.GetTranslation("ddt.loader.loadHonorUpInfoFail");
            _local_1.analyzer = new HonorUpDataAnalyz(HonorUpManager.instance.setup);
            _local_1.addEventListener(LoaderEvent.LOAD_ERROR, this.__onLoadError);
            return (_local_1);
        }

        public function creatExpeditionInfoAnalyzeLoader():BaseLoader
        {
            var _local_1:BaseLoader = LoadResourceManager.instance.createLoader(PathManager.solveRequestPath("ExpeditionInfoList.xml"), BaseLoader.COMPRESS_TEXT_LOADER);
            _local_1.loadErrorMessage = LanguageMgr.GetTranslation("ddt.loader.loadingExpeditionInfoFailure");
            _local_1.analyzer = new ExpeditionDataAnalyzer(ExpeditionController.instance.setExpeditionInfoDic);
            _local_1.addEventListener(LoaderEvent.LOAD_ERROR, this.__onLoadError);
            return (_local_1);
        }

        public function createVipInfoAnalyzerLoader():BaseLoader
        {
            var _local_1:BaseLoader = LoadResourceManager.instance.createLoader(PathManager.solveRequestPath("VipPrivilegeConfigInfo.xml"), BaseLoader.COMPRESS_TEXT_LOADER);
            _local_1.loadErrorMessage = LanguageMgr.GetTranslation("ddt.loader.loadingVipditionInfoFailure");
            _local_1.analyzer = new VipPrivilegeConfigAnalyzer(VipPrivilegeConfigManager.Instance.setupVipList);
            _local_1.addEventListener(LoaderEvent.LOAD_ERROR, this.__onLoadError);
            return (_local_1);
        }

        public function creatActivityInfoListLoader():BaseLoader
        {
            var _local_1:BaseLoader = LoadResourceManager.instance.createLoader(PathManager.solveRequestXMLPath("ActivityInfoList.xml"), BaseLoader.COMPRESS_TEXT_LOADER);
            _local_1.loadErrorMessage = LanguageMgr.GetTranslation("ddt.loader.LoadingActivityInfoListFailure");
            _local_1.analyzer = new ActivityInfoAnalyzer(ActivityController.instance.setActivityInfo);
            _local_1.addEventListener(LoaderEvent.LOAD_ERROR, this.__onLoadError);
            return (_local_1);
        }

        public function creatActivityConditionListLoader():BaseLoader
        {
            var _local_1:BaseLoader = LoadResourceManager.instance.createLoader(PathManager.solveRequestXMLPath("ActivityConditionList.xml"), BaseLoader.COMPRESS_TEXT_LOADER);
            _local_1.loadErrorMessage = LanguageMgr.GetTranslation("ddt.loader.LoadingActivityConditionListFailure");
            _local_1.analyzer = new ActivityConditionAnalyzer(ActivityController.instance.setActivityCondition);
            _local_1.addEventListener(LoaderEvent.LOAD_ERROR, this.__onLoadError);
            return (_local_1);
        }

        public function creatActivityGiftbagListLoader():BaseLoader
        {
            var _local_1:BaseLoader = LoadResourceManager.instance.createLoader(PathManager.solveRequestXMLPath("ActivityGiftbagList.xml"), BaseLoader.COMPRESS_TEXT_LOADER);
            _local_1.loadErrorMessage = LanguageMgr.GetTranslation("ddt.loader.LoadingActivityGiftbagListFailure");
            _local_1.analyzer = new ActivityGiftbagAnalyzer(ActivityController.instance.setActivityGiftbag);
            _local_1.addEventListener(LoaderEvent.LOAD_ERROR, this.__onLoadError);
            return (_local_1);
        }

        public function creatActivityRewardListLoader():BaseLoader
        {
            var _local_1:BaseLoader = LoadResourceManager.instance.createLoader(PathManager.solveRequestXMLPath("ActivityRewardList.xml"), BaseLoader.COMPRESS_TEXT_LOADER);
            _local_1.loadErrorMessage = LanguageMgr.GetTranslation("ddt.loader.LoadingActivityRewardListFailure");
            _local_1.analyzer = new ActivityRewardAnalyzer(ActivityController.instance.setActivityReward);
            _local_1.addEventListener(LoaderEvent.LOAD_ERROR, this.__onLoadError);
            return (_local_1);
        }

        public function creatInvitedFriendListLoader():BaseLoader
        {
            var _local_1:URLVariables = RequestVairableCreater.creatWidthKey(true);
            _local_1["id"] = PlayerManager.Instance.Self.ID;
            _local_1["uname"] = PlayerManager.Instance.Account.Account;
            var _local_2:BaseLoader = LoadResourceManager.instance.createLoader(PathManager.solveRequestPath("CloseFriendsLoad.ashx"), BaseLoader.REQUEST_LOADER, _local_1);
            _local_2.loadErrorMessage = LanguageMgr.GetTranslation("ddt.loader.LoadingBuddyListFailure");
            _local_2.analyzer = new InvitedFriendListAnalyzer(PlayerManager.Instance.setupInvitedFriendList);
            _local_2.addEventListener(LoaderEvent.LOAD_ERROR, this.__onLoadError);
            return (_local_2);
        }


    }
}//package ddt.loader

