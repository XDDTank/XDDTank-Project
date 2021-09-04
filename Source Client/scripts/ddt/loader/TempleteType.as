package ddt.loader
{
   import SingleDungeon.SingleDungeonManager;
   import SingleDungeon.dataAnalyzer.BigMapDataAnalyzer;
   import SingleDungeon.dataAnalyzer.MapSceneDataAnalyzer;
   import SingleDungeon.dataAnalyzer.MapSceneObjectsAnalyzer;
   import SingleDungeon.expedition.ExpeditionController;
   import activity.ActivityController;
   import activity.analyze.ActiveExchangeAnalyzer;
   import activity.analyze.ActivityConditionAnalyzer;
   import activity.analyze.ActivityGiftbagAnalyzer;
   import activity.analyze.ActivityInfoAnalyzer;
   import activity.analyze.ActivityRewardAnalyzer;
   import bagAndInfo.fightPower.FightPowerController;
   import bagAndInfo.fightPower.FightPowerDescAnalyzer;
   import bead.BeadManager;
   import consortion.ConsortionModelControl;
   import consortion.analyze.ConsortiaShopListAnalyzer;
   import consortion.analyze.ConsortionLevelUpAnalyzer;
   import consortion.analyze.ConsortionNewSkillInfoAnalyzer;
   import ddt.data.Experience;
   import ddt.data.PetExperienceManager;
   import ddt.data.analyze.BadgeInfoAnalyzer;
   import ddt.data.analyze.BallInfoAnalyzer;
   import ddt.data.analyze.BeadDataAnalyzer;
   import ddt.data.analyze.BoxTempInfoAnalyzer;
   import ddt.data.analyze.ComposeConfigListAnalyzer;
   import ddt.data.analyze.DailyLeagueAwardAnalyzer;
   import ddt.data.analyze.DailyLeagueLevelAnalyzer;
   import ddt.data.analyze.DaylyGiveAnalyzer;
   import ddt.data.analyze.DungeonAnalyzer;
   import ddt.data.analyze.EquipPropertyListAnalyzer;
   import ddt.data.analyze.EquipStrengthListAnalyzer;
   import ddt.data.analyze.EquipmentTemplateAnalyzer;
   import ddt.data.analyze.ExpeditionDataAnalyzer;
   import ddt.data.analyze.ExpericenceAnalyze;
   import ddt.data.analyze.GoodCategoryAnalyzer;
   import ddt.data.analyze.ItemTempleteAnalyzer;
   import ddt.data.analyze.MapAnalyzer;
   import ddt.data.analyze.PetAdvanceAnalyzer;
   import ddt.data.analyze.PetCommonSkillAnalyzer;
   import ddt.data.analyze.PetEggInfoAnalyzer;
   import ddt.data.analyze.PetExpericenceAnalyze;
   import ddt.data.analyze.PetInfoAnalyzer;
   import ddt.data.analyze.PetSkillEliementAnalyzer;
   import ddt.data.analyze.PetSkillInfoAnalyzer;
   import ddt.data.analyze.PetSkillTemplateInfoAnalyzer;
   import ddt.data.analyze.QuestListAnalyzer;
   import ddt.data.analyze.RuneSuitAnalyzer;
   import ddt.data.analyze.ServerConfigAnalyz;
   import ddt.data.analyze.ShopItemAnalyzer;
   import ddt.data.analyze.ShopItemSortAnalyzer;
   import ddt.data.analyze.SuidTipsAnalyzer;
   import ddt.data.analyze.UserBoxInfoAnalyzer;
   import ddt.data.analyze.VipPrivilegeConfigAnalyzer;
   import ddt.data.analyze.WeaponBallInfoAnalyze;
   import ddt.data.analyze.WeekOpenMapAnalyze;
   import ddt.data.analyze.WorldBossTimeAnalyzer;
   import ddt.manager.BadgeInfoManager;
   import ddt.manager.BallManager;
   import ddt.manager.BossBoxManager;
   import ddt.manager.BuffManager;
   import ddt.manager.DailyLeagueManager;
   import ddt.manager.ItemManager;
   import ddt.manager.MapManager;
   import ddt.manager.PetInfoManager;
   import ddt.manager.PetSkillManager;
   import ddt.manager.ServerConfigManager;
   import ddt.manager.ShopManager;
   import ddt.manager.TaskManager;
   import ddt.manager.VipPrivilegeConfigManager;
   import ddt.manager.WeaponBallManager;
   import liveness.DailyReceiveManager;
   import mainbutton.data.HallIconDataAnalyz;
   import mainbutton.data.MainButtonManager;
   import store.StoreController;
   import store.StrengthDataManager;
   import store.analyze.ComposeItemAnalyzer;
   import store.analyze.RefiningAnayzer;
   import store.analyze.StoreEquipExpericenceAnalyze;
   import store.analyze.StrengthenDataAnalyzer;
   import store.data.StoreEquipExperience;
   import store.view.Compose.ComposeController;
   import tofflist.TofflistModel;
   import tofflist.analyze.TofflistListAnalyzer;
   import tofflist.analyze.TofflistListTwoAnalyzer;
   import tofflist.view.TofflistThirdClassMenu;
   import totem.HonorUpManager;
   import totem.TotemManager;
   import totem.data.HonorUpDataAnalyz;
   import totem.data.TotemDataAnalyz;
   import update.UpdateController;
   import update.analyzer.PopSysNoticeBaseAnalyzer;
   import update.analyzer.PopSysNoticeContentAnalyzer;
   import worldboss.WorldBossRoomController;
   
   public class TempleteType
   {
       
      
      private var _list:Vector.<TempleteObject>;
      
      public function TempleteType()
      {
         super();
         this.setup();
      }
      
      public function get Types() : Vector.<TempleteObject>
      {
         return this._list;
      }
      
      private function setup() : void
      {
         this._list = new Vector.<TempleteObject>();
         this._list.push(new TempleteObject("ServerConfig.xml",new ServerConfigAnalyz(ServerConfigManager.instance.getserverConfigInfo)));
         this._list.push(new TempleteObject("TemplateAllList.xml",new ItemTempleteAnalyzer(ItemManager.Instance.setupGoodsTemplates)));
         this._list.push(new TempleteObject("EquipPropertyList.xml",new EquipPropertyListAnalyzer(ItemManager.Instance.setupEquipPropertyList)));
         this._list.push(new TempleteObject("LoadItemsCategory.xml",new GoodCategoryAnalyzer(ItemManager.Instance.setupGoodsCategory)));
         this._list.push(new TempleteObject("EquipTemplateList.xml",new EquipmentTemplateAnalyzer(ItemManager.Instance.setupEquipsTemplates)));
         this._list.push(new TempleteObject("ShopItemList.xml",new ShopItemAnalyzer(ShopManager.Instance.setup)));
         this._list.push(new TempleteObject("ConsortiaBufferList.xml",new ConsortionNewSkillInfoAnalyzer(ConsortionModelControl.Instance.newSkillInfoListComplete)));
         this._list.push(new TempleteObject("ConsortiaShopList.xml",new ConsortiaShopListAnalyzer(ConsortionModelControl.Instance.consortionProbabilityInfoListComplete)));
         this._list.push(new TempleteObject("QuestList.xml",new QuestListAnalyzer(TaskManager.instance.setup)));
         this._list.push(new TempleteObject("LoadUserBox.xml",new UserBoxInfoAnalyzer(BossBoxManager.instance.setupBoxInfo)));
         this._list.push(new TempleteObject("LoadBoxTemp.xml",new BoxTempInfoAnalyzer(BossBoxManager.instance.setupBoxTempInfo)));
         this._list.push(new TempleteObject("DailyAwardList.xml",new DaylyGiveAnalyzer(DailyReceiveManager.Instance.setDailyReceiveInfo)));
         this._list.push(new TempleteObject("ShopGoodsShowList.xml",new ShopItemSortAnalyzer(ShopManager.Instance.sortShopItems)));
         this._list.push(new TempleteObject("LoadMapsItems.xml",new MapAnalyzer(MapManager.setupMapInfo)));
         this._list.push(new TempleteObject("LoadPVEItems.xml",new DungeonAnalyzer(MapManager.setupDungeonInfo)));
         this._list.push(new TempleteObject("MapServerList.xml",new WeekOpenMapAnalyze(MapManager.setupOpenMapInfo)));
         this._list.push(new TempleteObject("LevelList.xml",new ExpericenceAnalyze(Experience.setup)));
         this._list.push(new TempleteObject("PetLevelInfo.xml",new PetExpericenceAnalyze(PetExperienceManager.setup)));
         this._list.push(new TempleteObject("BombConfig.xml",new WeaponBallInfoAnalyze(WeaponBallManager.setup)));
         this._list.push(new TempleteObject("WorldBossActiveTimeInfo.xml",new WorldBossTimeAnalyzer(WorldBossRoomController.Instance.timeSetup)));
         this._list.push(new TempleteObject("ConsortiaBadgeConfig.xml",new BadgeInfoAnalyzer(BadgeInfoManager.instance.setup)));
         this._list.push(new TempleteObject("DailyLeagueAward.xml",new DailyLeagueAwardAnalyzer(DailyLeagueManager.Instance.setup)));
         this._list.push(new TempleteObject("DailyLeagueLevel.xml",new DailyLeagueLevelAnalyzer(DailyLeagueManager.Instance.setup)));
         this._list.push(new TempleteObject("VipPrivilegeConfigInfo.xml",new VipPrivilegeConfigAnalyzer(VipPrivilegeConfigManager.Instance.setupVipList)));
         this._list.push(new TempleteObject("PetAdvanceList.xml",new PetAdvanceAnalyzer(PetInfoManager.instance.setupAdvanceList)));
         this._list.push(new TempleteObject("PetTemplateInfo.xml",new PetInfoAnalyzer(PetInfoManager.instance.setupTemplete)));
         this._list.push(new TempleteObject("PetEggList.xml",new PetEggInfoAnalyzer(PetInfoManager.instance.setupEgg)));
         this._list.push(new TempleteObject("PetCommonSkillList.xml",new PetCommonSkillAnalyzer(PetSkillManager.instance.setupCommonSkillList)));
         this._list.push(new TempleteObject("Petskillinfo.xml",new PetSkillInfoAnalyzer(PetSkillManager.instance.setupInfoList)));
         this._list.push(new TempleteObject("PetSkillTemplateInfo.xml",new PetSkillTemplateInfoAnalyzer(PetSkillManager.instance.setupTemplatenfoList)));
         this._list.push(new TempleteObject("LoadStrengthExp.xml",new StoreEquipExpericenceAnalyze(StoreEquipExperience.setup)));
         this._list.push(new TempleteObject("ButtonConfig.xml",new HallIconDataAnalyz(MainButtonManager.instance.gethallIconInfo)));
         this._list.push(new TempleteObject("LoadSceneMapScene.xml",new MapSceneDataAnalyzer(SingleDungeonManager.Instance.DungeonListComplete)));
         this._list.push(new TempleteObject("LoadSceneMapMap.xml",new BigMapDataAnalyzer(SingleDungeonManager.Instance.mapListComplete)));
         this._list.push(new TempleteObject("LoadSceneMapObject.xml",new MapSceneObjectsAnalyzer(SingleDungeonManager.Instance.setMapObjList)));
         this._list.push(new TempleteObject("EquipComposeList.xml",new ComposeItemAnalyzer(ComposeController.instance.intComposeItemInfoDic)));
         this._list.push(new TempleteObject("EquipComposeConfigList.xml",new ComposeConfigListAnalyzer(ItemManager.Instance.setupComposeItemConfigList)));
         this._list.push(new TempleteObject("EquipStrengthList.xml",new EquipStrengthListAnalyzer(ItemManager.Instance.setupEquipStrengthList)));
         this._list.push(new TempleteObject("EquipStrengthSuit.xml",new SuidTipsAnalyzer(ItemManager.Instance.setupSuidList)));
         this._list.push(new TempleteObject("RuneSuit.xml",new RuneSuitAnalyzer(ItemManager.Instance.setupRuneList)));
         this._list.push(new TempleteObject("TotemInfo.xml",new TotemDataAnalyz(TotemManager.instance.setup)));
         this._list.push(new TempleteObject("TotemHonorTemplate.xml",new HonorUpDataAnalyz(HonorUpManager.instance.setup)));
         this._list.push(new TempleteObject("ItemStrengthenData.xml",new StrengthenDataAnalyzer(StrengthDataManager.instance.searchResult)));
         this._list.push(new TempleteObject("BallList.xml",new BallInfoAnalyzer(BallManager.setup)));
         this._list.push(new TempleteObject("ConsortiaLevelList.xml",new ConsortionLevelUpAnalyzer(ConsortionModelControl.Instance.levelUpInfoComplete)));
         this._list.push(new TempleteObject("GemConfig.xml",new BeadDataAnalyzer(BeadManager.instance.getConfigData)));
         this._list.push(new TempleteObject("ExpeditionInfoList.xml",new ExpeditionDataAnalyzer(ExpeditionController.instance.setExpeditionInfoDic)));
         this._list.push(new TempleteObject("PetSkillElementInfo.xml",new PetSkillEliementAnalyzer(BuffManager.setPetTemplate)));
         this._list.push(new TempleteObject("CelebByDayFightPowerList.xml",new TofflistListTwoAnalyzer(TofflistModel.Instance.personalResult,"personalBattleAccumulate")));
         this._list.push(new TempleteObject("CelebByDayGPList.xml",new TofflistListTwoAnalyzer(TofflistModel.Instance.personalResult,"individualGradeDay")));
         this._list.push(new TempleteObject("CelebByWeekGPList.xml",new TofflistListTwoAnalyzer(TofflistModel.Instance.personalResult,"individualGradeWeek")));
         this._list.push(new TempleteObject("CelebByGPList.xml",new TofflistListTwoAnalyzer(TofflistModel.Instance.personalResult,"individualGradeAccumulate")));
         this._list.push(new TempleteObject("CelebByRankScoresList.xml",new TofflistListTwoAnalyzer(TofflistModel.Instance.personalResult,"Person_local_military")));
         this._list.push(new TempleteObject("CeleByAddDayMatchScoreList.xml",new TofflistListTwoAnalyzer(TofflistModel.Instance.personalResult,TofflistThirdClassMenu.LOCAL_ARENA_SCORE_DAY)));
         this._list.push(new TempleteObject("CeleByAddWeekMatchScoreList.xml",new TofflistListTwoAnalyzer(TofflistModel.Instance.personalResult,TofflistThirdClassMenu.LOCAL_ARENA_SCORE_WEEK)));
         this._list.push(new TempleteObject("CelebByConsortiaFightPower.xml",new TofflistListAnalyzer(TofflistModel.Instance.sociatyResult,"consortiaBattleAccumulate")));
         this._list.push(new TempleteObject("CelebByConsortiaLevel.xml",new TofflistListAnalyzer(TofflistModel.Instance.sociatyResult,"consortiaGradeAccumulate")));
         this._list.push(new TempleteObject("AreaCelebByDayFightPowerList.xml",new TofflistListTwoAnalyzer(TofflistModel.Instance.personalResult,"crossServerPersonalBattleAccumulate")));
         this._list.push(new TempleteObject("AreaCelebByDayGPList.xml",new TofflistListTwoAnalyzer(TofflistModel.Instance.personalResult,"crossServerIndividualGradeDay")));
         this._list.push(new TempleteObject("AreaCelebByWeekGPList.xml",new TofflistListTwoAnalyzer(TofflistModel.Instance.personalResult,"crossServerIndividualGradeWeek")));
         this._list.push(new TempleteObject("AreaCelebByGPList.xml",new TofflistListTwoAnalyzer(TofflistModel.Instance.personalResult,"crossServerIndividualGradeAccumulate")));
         this._list.push(new TempleteObject("AreaCelebByDayMatchScoreList.xml",new TofflistListTwoAnalyzer(TofflistModel.Instance.personalResult,TofflistThirdClassMenu.CROSS_ARENA_SCORE_DAY)));
         this._list.push(new TempleteObject("AreaCelebByWeekMatchScoreList.xml",new TofflistListTwoAnalyzer(TofflistModel.Instance.personalResult,TofflistThirdClassMenu.CROSS_ARENA_SCORE_WEEK)));
         this._list.push(new TempleteObject("AreaCelebByConsortiaLevel.xml",new TofflistListAnalyzer(TofflistModel.Instance.sociatyResult,"crossServerConsortiaGradeAccumulate")));
         this._list.push(new TempleteObject("AreaCelebByConsortiaFightPower.xml",new TofflistListAnalyzer(TofflistModel.Instance.sociatyResult,"crossServerConsortiaBattleAccumulate")));
         this._list.push(new TempleteObject("ActiveConvertItemInfo.xml",new ActiveExchangeAnalyzer(ActivityController.instance.setActivityExchange)));
         this._list.push(new TempleteObject("ActivityInfoList.xml",new ActivityInfoAnalyzer(ActivityController.instance.setActivityInfo)));
         this._list.push(new TempleteObject("ActivityConditionList.xml",new ActivityConditionAnalyzer(ActivityController.instance.setActivityCondition)));
         this._list.push(new TempleteObject("ActivityGiftbagList.xml",new ActivityGiftbagAnalyzer(ActivityController.instance.setActivityGiftbag)));
         this._list.push(new TempleteObject("ActivityRewardList.xml",new ActivityRewardAnalyzer(ActivityController.instance.setActivityReward)));
         this._list.push(new TempleteObject("PopSysNoticeBaseList.xml",new PopSysNoticeBaseAnalyzer(UpdateController.Instance.setPopSysNoticeBase)));
         this._list.push(new TempleteObject("PopSysNoticeContentList.xml",new PopSysNoticeContentAnalyzer(UpdateController.Instance.setPopSysNoticeContent)));
         this._list.push(new TempleteObject("FightingEvalSystemList.xml",new FightPowerDescAnalyzer(FightPowerController.Instance.setFightPowerDesc)));
         this._list.push(new TempleteObject("JeweleryRefineList.xml",new RefiningAnayzer(StoreController.instance.setupRefining)));
      }
   }
}
