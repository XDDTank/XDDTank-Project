package ddt.manager
{
   import ddt.data.ServerConfigInfo;
   import ddt.data.analyze.ServerConfigAnalyz;
   import flash.utils.Dictionary;
   import road7th.data.DictionaryData;
   
   public class ServerConfigManager
   {
      
      private static var _instance:ServerConfigManager;
      
      public static const MARRT_ROOM_CREATE_MONET:String = "MarryRoomCreateMoney";
      
      public static const MISSION_RICHES:String = "MissionRiches";
      
      public static const VIP_RATE_FOR_GP:String = "VIPRateForGP";
      
      public static const VIP_QUEST_STAR:String = "VIPQuestStar";
      
      public static const VIP_LOTTERY_COUNT_MAX_PER_DAY:String = "VIPLotteryCountMaxPerDay";
      
      public static const VIP_TAKE_CARD_DISCOUNT:String = "VIPTakeCardDisCount";
      
      public static const VIP_EXP_NEEDEDFOREACHLV:String = "VIPExpForEachLv";
      
      public static const HOT_SPRING_EXP:String = "HotSpringExp";
      
      public static const VIP_STRENGTHEN_EX:String = "VIPStrengthenEx";
      
      public static const CONSORTIA_STRENGTHEN_EX:String = "ConsortiaStrengthenEx";
      
      public static const VIPEXTTRA_BIND_MOMEYUPPER:String = "VIPExtraBindMoneyUpper";
      
      public static const AWARD_MAX_MONEY:String = "AwardMaxMoney";
      
      public static const VIP_RENEWAL_PRIZE:String = "VIPRenewalPrize";
      
      public static const VIP_DAILY_PACK:String = "VIPDailyPackID";
      
      public static const VIP_PRIVILEGE:String = "VIPPrivilege";
      
      public static const VIP_PAYAIMENERGY:String = "VIPPayAimEnergy";
      
      public static const PAYAIMENERGY:String = "PayAimEnergy";
      
      public static const VIP_QUEST_FINISH_DIRECT:String = "VIPQuestFinishDirect";
      
      public static const CARD_RESETSOUL_VALUE_CARD:String = "CardResetSoulValue";
      
      public static const PLAYER_MIN_LEVEL:String = "PlayerMinLevel";
      
      public static const BEAD_UPGRADE_EXP:String = "RuneLevelUpExp";
      
      public static const REQUEST_BEAD_PRICE:String = "OpenRunePackageMoney";
      
      public static const BEAD_HOLE_UP_EXP:String = "HoleLevelUpExpList";
      
      public static const STRENGTHEN_NEED_MONEY:String = "MustStrengthenGold";
      
      public static const COMPOSE_NEED_MONEY:String = "MustComposeGold";
      
      public static const CONSORTIA_TASK_COST:String = "ConsortiaQuestCost";
      
      public static const CONSORTIA_TASK_ACCEPT_MAX:String = "ConsortiaQuestMax";
      
      public static const PET_OPEN_LEVEL:String = "PetOpenLevel";
      
      public static const PET_MAX_LEVEL:String = "PetMaxLevel";
      
      public static const PET_MAGIC_LEVEL1:String = "PetMagicLevel1";
      
      public static const PET_MAGIC_LEVEL2:String = "PetMagicLevel2";
      
      public static const PET_ADD_PROPERTY_RATE:String = "PetAddPropertyRate";
      
      public static const PET_ADD_LIFE_RATE:String = "PetAddLifeRate";
      
      public static const ADVANCE_STONE_TEMPLETEID:String = "AdvanceStoneTemplateId";
      
      public static const FARM_OPEN_LEVEL:String = "FarmOpenLevel";
      
      public static const FARM_REFRESH_MONEY:String = "FarmRefreshMoney";
      
      public static const FARM_ADD_FIELD_LEVEL:String = "AddFieldLevel";
      
      public static const FARM_FIELD_COUNT:String = "FarmFieldCount";
      
      public static const FIGHT_VIP_LEVELS:String = "FightingKitLevel";
      
      public static const FIGHT_VIP_PRICES:String = "FightingKitPrice";
      
      public static const FIGHT_VIP_TIME:String = "FightingKitTime";
      
      public static const GUIDE_DAMAGE_RATIO:String = "GuideDamageRatio";
      
      public static const POWER_DAMAGE_RATIO:String = "StormDamageRatio";
      
      public static const POWER_DAMAGE_INCREASE:String = "StormDamageIncrease";
      
      public static const GUIDE_DAMAGE_INCREASE:String = "GuideDamageIncrease";
      
      public static const HEADSHOT_DAMAGE_RATIO:String = "HeadshotDamageRatio";
      
      public static const FIGHT_VIP_DAMAGE:String = "FightingKitPVEDamage";
      
      public static const BUY_ENERGY_COST_MONEY:String = "BuyEnergyCostMoney";
      
      public static const WORLDBOSS_MIN_OPEN_LEVEL:String = "WorldBossBattleMinPlayerLevel";
      
      public static const EXPEDITION_LIMIT_LEVEL:String = "ExpeditionLimitLevel";
      
      public static const PRIVILEGE_CANBUYFERT:String = "8";
      
      public static const PRIVILEGE_LOTTERYNOTIME:String = "13";
      
      public static const CELLPHONE_QUEST:String = "CellphoneQuestID";
      
      public static const EMAIL_QUEST:String = "EmailQuestID";
      
      public static const MILITARY_RANK_DATA:String = "RankScores";
      
      public static const MILITARY_RANK_NAME:String = "MilitaryRank";
      
      public static const CONSORTA_CONVOY_CONFIG:String = "ConsortiaConvoyConfig";
      
      public static const CONSORTA_QUEST_VALID_TIME:String = "ConsortiaQuestValidTime";
      
      public static const REMOVAL_RUNE_NEED_GOLD:String = "RemovalRuneNeedGold";
      
      public static const RUNE_OPEN_LEVEL:String = "RuneOpenLevel";
      
      public static const SIGN_STAR:String = "SignStar";
      
      public static const MEDALS_LIMIT:String = "MedalsLimit";
      
      public static const DAILY_ACTIVITY_REWARD:String = "DailyActivityReward";
      
      public static const MARCH_SCENE_START_LEVEL:String = "MatchSceneStartLevel";
      
      public static const MARCH_SCENE_BEGIN_TIME:String = "MatchSceneBeginTime";
      
      public static const RANK_SHOP_LIMIT:String = "RankShopLimit";
      
      public static const PET_TRANSFORM_MONEY:String = "PetAdvanceChangeCost";
      
      public static const HARD_MODE_ENTER_COUNT:String = "SceneMapHardEnterCount";
      
      public static const RANDOM_BOX_QUILITY_AND_PRICE:String = "RandomBoxQuilityAndPrice";
      
      public static const RANDOM_BOX_REFRESH_GOLD:String = "RandomBoxRefreshGold";
      
      public static const RANDOM_BOX_KEY_PRICE:String = "RandomBoxKeyPrice";
      
      public static const SHADOW_NPC_CD:String = "ShadowNpcCD";
      
      public static const SHADOW_NPC_CLEAR_CD_PRICE:String = "ShadowNpcClearCDPrice";
      
      public static const SHADOW_NPC_LIMIT:String = "ShadowNpcLimit";
      
      private static var privileges:Dictionary;
      
      public static const RETURN_ENERGY_INFO:String = "EnergyReturnInfo";
       
      
      private var _serverConfigInfoList:DictionaryData;
      
      private var _BindMoneyMax:Array;
      
      private var _VIPExtraBindMoneyUpper:Array;
      
      public function ServerConfigManager()
      {
         super();
      }
      
      public static function get instance() : ServerConfigManager
      {
         if(_instance == null)
         {
            _instance = new ServerConfigManager();
         }
         return _instance;
      }
      
      public function getserverConfigInfo(param1:ServerConfigAnalyz) : void
      {
         this._serverConfigInfoList = param1.serverConfigInfoList;
         PetBagManager.instance().setPetConfig();
      }
      
      public function get serverConfigInfo() : DictionaryData
      {
         return this._serverConfigInfoList;
      }
      
      public function get petTransformMoeny() : int
      {
         return int(this.findInfoByName(ServerConfigManager.PET_TRANSFORM_MONEY).Value);
      }
      
      public function get rankShopLimit() : DictionaryData
      {
         var _loc5_:int = 0;
         var _loc6_:String = null;
         var _loc1_:String = String(this.findInfoByName(ServerConfigManager.RANK_SHOP_LIMIT).Value);
         var _loc2_:DictionaryData = new DictionaryData();
         var _loc3_:Array = _loc1_.split("|");
         var _loc4_:Array = new Array();
         for each(_loc6_ in _loc3_)
         {
            _loc4_ = _loc6_.split(",");
            _loc5_ = _loc4_[0];
            _loc2_[_loc5_] = _loc4_;
         }
         return _loc2_;
      }
      
      public function getRankShopLimitByIDandLevel(param1:int, param2:int) : int
      {
         var _loc4_:Array = null;
         var _loc3_:DictionaryData = this.rankShopLimit;
         for each(_loc4_ in _loc3_)
         {
            if(_loc4_[0] == param1)
            {
               return int(_loc4_[param2 + 1]);
            }
         }
         return -1000;
      }
      
      public function getFarmFieldCount(param1:int) : int
      {
         var _loc2_:Array = this.findInfoByName(FARM_ADD_FIELD_LEVEL).Value.split("|");
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_.length)
         {
            if(param1 < _loc2_[_loc3_])
            {
               return int(this.findInfoByName(FARM_FIELD_COUNT).Value) + _loc3_;
            }
            _loc3_++;
         }
         return int(this.findInfoByName(FARM_FIELD_COUNT).Value) + _loc2_.length;
      }
      
      public function getFarmOpenLevel(param1:int) : int
      {
         var _loc2_:Array = this.findInfoByName(FARM_ADD_FIELD_LEVEL).Value.split("|");
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_.length)
         {
            if(param1 < _loc2_[_loc3_])
            {
               return _loc2_[_loc3_];
            }
            _loc3_++;
         }
         return 0;
      }
      
      public function getBindBidLimit(param1:int, param2:int) : int
      {
         var _loc3_:int = param1 % 10 == 0 ? int(int(this._BindMoneyMax[int(param1 / 10) - 1])) : int(int(this._BindMoneyMax[int(param1 / 10)]));
         var _loc4_:int = int(this._VIPExtraBindMoneyUpper[param2 - 1]);
         return _loc3_ + _loc4_;
      }
      
      public function get PayAimEnergy() : int
      {
         return int(this.findInfoByName(ServerConfigManager.PAYAIMENERGY).Value);
      }
      
      public function get VIPPayAimEnergy() : Array
      {
         return this.findInfoByName(ServerConfigManager.VIP_PAYAIMENERGY).Value.split("|");
      }
      
      public function get weddingMoney() : Array
      {
         return this.findInfoByName(ServerConfigManager.MARRT_ROOM_CREATE_MONET).Value.split(",");
      }
      
      public function get MissionRiches() : Array
      {
         return this.findInfoByName(ServerConfigManager.MISSION_RICHES).Value.split("|");
      }
      
      public function get VIPExpNeededForEachLv() : Array
      {
         return this.findInfoByName(ServerConfigManager.VIP_EXP_NEEDEDFOREACHLV).Value.split("|");
      }
      
      public function get CardRestSoulValue() : String
      {
         return this.findInfoByName(ServerConfigManager.CARD_RESETSOUL_VALUE_CARD).Value;
      }
      
      public function get StrengthenNeedMoney() : String
      {
         return this.findInfoByName(ServerConfigManager.STRENGTHEN_NEED_MONEY).Value;
      }
      
      public function get ComposeNeedMoney() : String
      {
         return this.findInfoByName(ServerConfigManager.COMPOSE_NEED_MONEY).Value;
      }
      
      public function get VIPExtraBindMoneyUpper() : Array
      {
         return this.findInfoByName(ServerConfigManager.VIPEXTTRA_BIND_MOMEYUPPER).Value.split("|");
      }
      
      public function get HotSpringExp() : Array
      {
         return this.findInfoByName(ServerConfigManager.HOT_SPRING_EXP).Value.split(",");
      }
      
      public function findInfoByName(param1:String) : ServerConfigInfo
      {
         var _loc2_:ServerConfigInfo = null;
         if(this._serverConfigInfoList[param1])
         {
            return this._serverConfigInfoList[param1];
         }
         _loc2_ = new ServerConfigInfo();
         _loc2_.Name = param1;
         return _loc2_;
      }
      
      public function get VIPStrengthenEx() : Array
      {
         var _loc1_:Object = this.findInfoByName(VIP_STRENGTHEN_EX);
         if(_loc1_)
         {
            return this.findInfoByName(VIP_STRENGTHEN_EX).Value.split("|");
         }
         return null;
      }
      
      public function ConsortiaStrengthenEx() : Array
      {
         var _loc1_:Object = this.findInfoByName(CONSORTIA_STRENGTHEN_EX);
         if(_loc1_)
         {
            return this.findInfoByName(CONSORTIA_STRENGTHEN_EX).Value.split("|");
         }
         return null;
      }
      
      public function get RouletteMaxTicket() : String
      {
         return this.findInfoByName(ServerConfigManager.AWARD_MAX_MONEY).Value;
      }
      
      public function get VIPRenewalPrice() : Array
      {
         var _loc1_:Object = this.findInfoByName(VIP_RENEWAL_PRIZE);
         if(_loc1_)
         {
            return String(_loc1_.Value).split(",");
         }
         return null;
      }
      
      public function get VIPRateForGP() : Array
      {
         var _loc1_:Object = this.findInfoByName(VIP_RATE_FOR_GP);
         if(_loc1_)
         {
            return String(_loc1_.Value).split("|");
         }
         return null;
      }
      
      public function get VIPQuestStar() : Array
      {
         var _loc1_:Object = this.findInfoByName(VIP_QUEST_STAR);
         if(_loc1_)
         {
            return String(_loc1_.Value).split("|");
         }
         return null;
      }
      
      public function get VIPLotteryCountMaxPerDay() : Array
      {
         var _loc1_:Object = this.findInfoByName(VIP_LOTTERY_COUNT_MAX_PER_DAY);
         if(_loc1_)
         {
            return String(_loc1_.Value).split("|");
         }
         return null;
      }
      
      public function get VIPTakeCardDisCount() : Array
      {
         var _loc1_:Object = this.findInfoByName(VIP_TAKE_CARD_DISCOUNT);
         if(_loc1_)
         {
            return String(_loc1_.Value).split("|");
         }
         return null;
      }
      
      public function get VIPQuestFinishDirect() : Array
      {
         return this.analyzeData(VIP_QUEST_FINISH_DIRECT);
      }
      
      public function analyzeData(param1:String) : Array
      {
         var _loc2_:Object = this.findInfoByName(param1);
         if(_loc2_)
         {
            return String(_loc2_.Value).split("|");
         }
         return null;
      }
      
      public function getPrivilegeString(param1:int) : String
      {
         var _loc2_:Object = this.findInfoByName(VIP_PRIVILEGE);
         if(_loc2_)
         {
            return String(_loc2_.Value);
         }
         return null;
      }
      
      public function get VIPDailyPack() : Array
      {
         return this.findInfoByName(ServerConfigManager.VIP_DAILY_PACK).Value.split("|");
      }
      
      public function getPrivilegeMinLevel(param1:String) : int
      {
         var _loc2_:Object = null;
         var _loc3_:int = 0;
         var _loc4_:Array = null;
         var _loc5_:String = null;
         var _loc6_:String = null;
         if(privileges == null)
         {
            _loc2_ = this.findInfoByName(VIP_PRIVILEGE);
            _loc3_ = 1;
            _loc4_ = String(_loc2_.Value).split("|");
            privileges = new Dictionary();
            for each(_loc5_ in _loc4_)
            {
               for each(_loc6_ in _loc5_.split(","))
               {
                  privileges[_loc6_] = _loc3_;
               }
               _loc3_++;
            }
         }
         return int(privileges[param1]);
      }
      
      public function getBeadUpgradeExp() : DictionaryData
      {
         var _loc4_:int = 0;
         var _loc1_:DictionaryData = new DictionaryData();
         var _loc2_:Array = this.findInfoByName(BEAD_UPGRADE_EXP).Value.split("|");
         var _loc3_:int = 1;
         for each(_loc4_ in _loc2_)
         {
            _loc1_.add(_loc3_,_loc4_);
            _loc3_++;
         }
         return _loc1_;
      }
      
      public function getRequestBeadPrice() : Array
      {
         return this.findInfoByName(REQUEST_BEAD_PRICE).Value.split("|");
      }
      
      public function getBeadHoleUpExp() : Array
      {
         return this.findInfoByName(BEAD_HOLE_UP_EXP).Value.split("|");
      }
      
      public function get minOpenPetSystemLevel() : int
      {
         var _loc1_:Object = this.findInfoByName(PLAYER_MIN_LEVEL);
         return int(_loc1_.Value);
      }
      
      public function get fightVipLevels() : Array
      {
         return this.findInfoByName(FIGHT_VIP_LEVELS).Value.split("|");
      }
      
      public function get fightVipTime() : int
      {
         return int(this.findInfoByName(FIGHT_VIP_TIME).Value);
      }
      
      public function get fightVipPrices() : int
      {
         return int(this.findInfoByName(FIGHT_VIP_PRICES).Value);
      }
      
      public function get fightVipDamage() : Array
      {
         return this.findInfoByName(FIGHT_VIP_DAMAGE).Value.split("|");
      }
      
      public function get fightVipGuideDamageRatio() : Number
      {
         return Number(this.findInfoByName(GUIDE_DAMAGE_RATIO).Value);
      }
      
      public function get fightVipPowerDamageRatio() : Number
      {
         return Number(this.findInfoByName(POWER_DAMAGE_RATIO).Value);
      }
      
      public function get fightVipPowerDamageIncrease() : Number
      {
         return Number(this.findInfoByName(POWER_DAMAGE_INCREASE).Value);
      }
      
      public function get fightVipGuideDamageIncrease() : Number
      {
         return Number(this.findInfoByName(GUIDE_DAMAGE_INCREASE).Value);
      }
      
      public function get fightVipheadShotDamageRatio() : Number
      {
         return Number(this.findInfoByName(HEADSHOT_DAMAGE_RATIO).Value);
      }
      
      public function getBuyFatigueCostMoney(param1:Boolean) : Array
      {
         return this.findInfoByName(BUY_ENERGY_COST_MONEY).Value.split("|")[!!param1 ? 1 : 0].split(",");
      }
      
      public function getWorldBossMinEnterLevel() : int
      {
         return int(this.findInfoByName(WORLDBOSS_MIN_OPEN_LEVEL).Value);
      }
      
      public function getFarmRefreshMoney() : int
      {
         return int(this.findInfoByName(FARM_REFRESH_MONEY).Value);
      }
      
      public function getExpeditionLimitLevel() : int
      {
         return int(this.findInfoByName(EXPEDITION_LIMIT_LEVEL).Value);
      }
      
      public function getCellphoneQuestID() : int
      {
         return int(this.findInfoByName(CELLPHONE_QUEST).Value);
      }
      
      public function getEmailQuestID() : int
      {
         return int(this.findInfoByName(EMAIL_QUEST).Value);
      }
      
      public function getMilitaryData() : Array
      {
         return this.findInfoByName(MILITARY_RANK_DATA).Value.split("|");
      }
      
      public function getMilitaryName() : Array
      {
         return this.findInfoByName(MILITARY_RANK_NAME).Value.split("|");
      }
      
      public function getTransportCarInfo() : Array
      {
         return this.findInfoByName(CONSORTA_CONVOY_CONFIG).Value.split("|");
      }
      
      public function getConsortiaTaskCost() : Array
      {
         return this.findInfoByName(CONSORTIA_TASK_COST).Value.split("|");
      }
      
      public function getConsortiaTaskVaildTime() : int
      {
         return int(this.findInfoByName(CONSORTA_QUEST_VALID_TIME).Value);
      }
      
      public function getConsortiaTaskAcceptMax() : int
      {
         return int(this.findInfoByName(CONSORTIA_TASK_ACCEPT_MAX).Value);
      }
      
      public function getReliveStarCost() : int
      {
         return int(this.findInfoByName(SIGN_STAR).Value);
      }
      
      public function getMedalsLimit() : Array
      {
         var result:Array = [];
         try
         {
            result = this.findInfoByName(MEDALS_LIMIT).Value.split(",");
         }
         catch(e:Error)
         {
         }
         return result;
      }
      
      public function getLivenessAward() : Array
      {
         return this.findInfoByName(DAILY_ACTIVITY_REWARD).Value.split("|");
      }
      
      public function getArenaOpenLevel() : int
      {
         return int(this.findInfoByName(MARCH_SCENE_START_LEVEL).Value);
      }
      
      public function getArenaBeginTime() : String
      {
         return this.findInfoByName(MARCH_SCENE_BEGIN_TIME).Value;
      }
      
      public function getHardModeEnterLimit() : int
      {
         return int(this.findInfoByName(HARD_MODE_ENTER_COUNT).Value);
      }
      
      public function getTurnPlateCost() : Array
      {
         return this.findInfoByName(RANDOM_BOX_QUILITY_AND_PRICE).Value.split("|");
      }
      
      public function getReturnEnergyInfo() : String
      {
         return String(this.findInfoByName(RETURN_ENERGY_INFO).Value);
      }
      
      public function getTurnPlateRefreshGold() : int
      {
         return int(this.findInfoByName(RANDOM_BOX_REFRESH_GOLD).Value);
      }
      
      public function getBoguCoinPrice() : int
      {
         return int(this.findInfoByName(RANDOM_BOX_KEY_PRICE).Value);
      }
      
      public function getShadowNpcCd() : int
      {
         return int(this.findInfoByName(SHADOW_NPC_CD).Value);
      }
      
      public function getShadowNpcClearCdPrice() : int
      {
         return int(this.findInfoByName(SHADOW_NPC_CLEAR_CD_PRICE).Value);
      }
      
      public function getShadowNpcLimit() : int
      {
         return int(this.findInfoByName(SHADOW_NPC_LIMIT).Value);
      }
   }
}
