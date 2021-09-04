package ddt.manager
{
   import com.pickgliss.loader.LoadResourceManager;
   import ddt.data.EquipType;
   import ddt.data.PathInfo;
   import ddt.data.goods.ItemTemplateInfo;
   
   public class PathManager
   {
      
      private static var info:PathInfo;
      
      public static var SITE_MAIN:String = "";
      
      public static var SITE_WEEKLY:String = "";
       
      
      public function PathManager()
      {
         super();
      }
      
      public static function setup(param1:PathInfo) : void
      {
         info = param1;
         SITE_MAIN = info.SITE;
         SITE_WEEKLY = info.WEEKLY_SITE;
      }
      
      public static function solvePhpPath() : String
      {
         return info.PHP_PATH;
      }
      
      public static function solveOfficialSitePath() : String
      {
         info.OFFICIAL_SITE = info.OFFICIAL_SITE.replace("{uid}",PlayerManager.Instance.Self.ID);
         return info.OFFICIAL_SITE;
      }
      
      public static function solveGameForum() : String
      {
         info.GAME_FORUM = info.GAME_FORUM.replace("{uid}",PlayerManager.Instance.Self.ID);
         return info.GAME_FORUM;
      }
      
      public static function get solveCommunityFriend() : String
      {
         return info.COMMUNITY_FRIEND_PATH;
      }
      
      public static function solveClientDownloadPath() : String
      {
         return info.CLIENT_DOWNLOAD;
      }
      
      public static function solveWebPlayerInfoPath(param1:String, param2:String = "", param3:String = "") : String
      {
         var _loc4_:String = info.WEB_PLAYER_INFO_PATH.replace("{uid}",param1);
         _loc4_ = _loc4_.replace("{code}",param2);
         return _loc4_.replace("{key}",param3);
      }
      
      public static function solveFlvSound(param1:String) : String
      {
         return info.SITE + "sound/" + param1 + ".flv";
      }
      
      public static function solveFirstPage() : String
      {
         return info.FIRSTPAGE;
      }
      
      public static function get FirstPage() : String
      {
         return info.FIRSTPAGE;
      }
      
      public static function solveRegister() : String
      {
         return info.REGISTER;
      }
      
      public static function solveLogin() : String
      {
         info.LOGIN_PATH = info.LOGIN_PATH.replace("{nickName}",PlayerManager.Instance.Self.NickName);
         info.LOGIN_PATH = info.LOGIN_PATH.replace("{uid}",PlayerManager.Instance.Self.ID);
         return info.LOGIN_PATH;
      }
      
      public static function solveConfigSite() : String
      {
         return info.SITEII;
      }
      
      public static function solveFillPage() : String
      {
         info.FILL_PATH = info.FILL_PATH.replace("{nickName}",PlayerManager.Instance.Self.NickName);
         info.FILL_PATH = info.FILL_PATH.replace("{uid}",PlayerManager.Instance.Self.ID);
         return info.FILL_PATH;
      }
      
      public static function solveLoginPHP(param1:String) : String
      {
         return info.PHP_PATH.replace("{id}",param1);
      }
      
      public static function checkOpenPHP() : Boolean
      {
         return info.PHP_IMAGE_LINK;
      }
      
      public static function solveTrainerPage() : String
      {
         return info.TRAINER_PATH;
      }
      
      public static function solveWeeklyPath(param1:String) : String
      {
         return info.WEEKLY_SITE + "weekly/" + param1;
      }
      
      public static function solveMapPath(param1:int, param2:String, param3:String) : String
      {
         return info.SITE + "image/map/" + param1.toString() + "/" + param2 + "." + param3;
      }
      
      public static function solveMapSmallView(param1:int) : String
      {
         return info.SITE + "image/map/" + param1.toString() + "/small.png";
      }
      
      public static function solveRequestPath(param1:String) : String
      {
         return info.REQUEST_PATH + param1;
      }
      
      public static function solveRequestXMLPath(param1:String) : String
      {
         return info.REQUEST_PATH + "xml/" + param1;
      }
      
      public static function getRequestPath() : String
      {
         return info.REQUEST_PATH;
      }
      
      public static function solvePropPath(param1:String) : String
      {
         return info.SITE + "image/tool/" + param1 + ".png";
      }
      
      public static function solveMapIconPath(param1:int, param2:int, param3:String = "show1.jpg") : String
      {
         var _loc4_:String = "";
         if(param2 == 0)
         {
            _loc4_ = info.SITE + "image/map/" + param1.toString() + "/icon.png";
         }
         else if(param2 == 1)
         {
            _loc4_ = info.SITE + "image/map/" + param1.toString() + "/samll_map.png";
         }
         else if(param2 == 2)
         {
            _loc4_ = info.SITE + "image/map/" + param1.toString() + "/" + param3;
         }
         else if(param2 == 3)
         {
            _loc4_ = info.SITE + "image/map/" + param1.toString() + "/samll_map_s.jpg";
         }
         return _loc4_;
      }
      
      public static function solveEffortIconPath(param1:String) : String
      {
         var _loc2_:String = "";
         return info.SITE + "image/effort/" + param1 + "/icon.png";
      }
      
      public static function solveFieldPlantPath(param1:String, param2:int) : String
      {
         return info.SITE + "image/farm/Crops/" + param1 + "/crop.swf";
      }
      
      public static function solveSeedPath(param1:String) : String
      {
         return info.SITE + "image/farm/Crops/" + param1 + "/seed.png";
      }
      
      public static function solveCountPath() : String
      {
         return info.COUNT_PATH;
      }
      
      public static function solveParterId() : String
      {
         return info.PARTER_ID;
      }
      
      public static function solveStylePath(param1:Boolean, param2:String, param3:String) : String
      {
         return info.SITE + info.STYLE_PATH + (!!param1 ? "m" : "f") + "/" + param2 + "/" + param3 + ".png";
      }
      
      public static function solveArmPath(param1:String, param2:String) : String
      {
         return info.SITE + info.STYLE_PATH + String(param1) + "/" + param2 + ".png";
      }
      
      public static function solveGoodsPath(param1:ItemTemplateInfo, param2:String, param3:Boolean = true, param4:String = "show", param5:String = "A", param6:String = "1", param7:int = 1, param8:Boolean = false, param9:int = 0, param10:String = "") : String
      {
         var _loc11_:String = "";
         var _loc12_:String = "";
         var _loc13_:String = "";
         var _loc14_:String = "";
         var _loc15_:String = "";
         var _loc16_:String = "";
         var _loc17_:String = "";
         var _loc18_:String = param4 + ".png";
         if(EquipType.isWeapon(param1.TemplateID) || param1.CategoryID == EquipType.TEMPWEAPON)
         {
            _loc17_ = "/" + 1;
            _loc11_ = "arm/";
            if(param4.indexOf("icon") == -1)
            {
               _loc14_ = !!param8 ? "/1" : "/0";
            }
            return info.SITE + "image/emboitement/" + param2 + _loc17_ + _loc14_ + "/" + _loc18_;
         }
         if(param1.CategoryID == EquipType.UNFRIGHTPROP || param1.CategoryID == EquipType.SPACE_UPDATE)
         {
            return info.SITE + "image/unfrightprop/" + param2 + "/" + _loc18_;
         }
         if(param1.CategoryID == EquipType.TASK)
         {
            return info.SITE + "image/task/" + param2 + "/icon.png";
         }
         if(param1.CategoryID == EquipType.CHATBALL)
         {
            return info.SITE + "image/specialprop/chatBall/" + param2 + "/icon.png";
         }
         if(param1.CategoryID < 10 || param1.CategoryID == EquipType.SUITS || param1.CategoryID == EquipType.NECKLACE || param1.CategoryID == EquipType.TEMPARMLET || param1.CategoryID == EquipType.TEMPRING)
         {
            if(param1.CategoryID == EquipType.HAIR)
            {
               if(param4.indexOf("icon") == -1)
               {
                  _loc15_ = "/" + param5;
               }
            }
            _loc11_ = "equip/";
            _loc13_ = EquipType.TYPES[param1.CategoryID] + "/";
            _loc12_ = !!param3 ? "m/" : "f/";
            if(param1.CategoryID != EquipType.ARMLET && param1.CategoryID != EquipType.RING && param1.CategoryID != EquipType.NECKLACE && param1.CategoryID != EquipType.TEMPARMLET && param1.CategoryID != EquipType.TEMPRING)
            {
               if(param4 == "icon")
               {
                  param4 = "icon_" + param6;
                  param6 = "";
               }
               else
               {
                  _loc16_ = "/" + param6;
               }
            }
            else
            {
               _loc12_ = "";
            }
            _loc18_ = param4 + param10 + ".png";
            if(param1.CategoryID == EquipType.SUITS)
            {
               return info.SITE + "image/" + _loc11_ + "f/" + _loc13_ + param2 + _loc16_ + _loc15_ + _loc17_ + _loc14_ + "/" + _loc18_;
            }
            return info.SITE + "image/" + _loc11_ + _loc12_ + _loc13_ + param2 + _loc16_ + _loc15_ + _loc17_ + _loc14_ + "/" + _loc18_;
         }
         if(param1.CategoryID == EquipType.WING)
         {
            return info.SITE + "image/equip/wing/" + param2 + "/" + _loc18_;
         }
         if(param1.CategoryID == EquipType.HEALSTONE)
         {
            return info.SITE + "image/equip/recover/" + param2 + "/icon.png";
         }
         if(param1.CategoryID == EquipType.TEXP || param1.CategoryID == EquipType.TEXP_TASK || param1.CategoryID == EquipType.ACTIVE_TASK)
         {
            return info.SITE + "image/unfrightprop/" + param2 + "/icon.png";
         }
         if(param1.CategoryID == EquipType.SEED || param1.CategoryID == EquipType.VEGETABLE)
         {
            return info.SITE + "image/unfrightprop/" + param2 + "/icon.png";
         }
         if(param1.CategoryID == EquipType.MANURE)
         {
            return info.SITE + "image/farm/Fertilizer/" + param2 + "/icon.png";
         }
         if(param1.CategoryID == EquipType.FOOD || param1.CategoryID == EquipType.PET_EGG)
         {
            return info.SITE + "image/unfrightprop/" + param2 + "/icon.png";
         }
         if(param1.CategoryID == EquipType.EQUIP)
         {
            return info.SITE + "image/emboitement/" + param2 + "/icon.png";
         }
         if(param1.CategoryID == EquipType.COMPOSE_MATERIAL)
         {
            return info.SITE + "image/unfrightprop/" + param2 + "/icon.png";
         }
         if(param1.CategoryID == EquipType.COMPOSE_SKILL)
         {
            return info.SITE + "image/unfrightprop/" + param2 + "/icon.png";
         }
         return info.SITE + "image/prop/" + param2 + "/" + _loc18_;
      }
      
      public static function soloveWingPath(param1:String) : String
      {
         return info.SITE + "image/equip/wing/" + param1 + "/wings.swf";
      }
      
      public static function soloveSinpleLightPath(param1:String) : String
      {
         return info.SITE + "image/equip/sinplelight/" + param1 + ".swf";
      }
      
      public static function soloveCircleLightPath(param1:String) : String
      {
         return info.SITE + "image/equip/circlelight/" + param1 + ".swf";
      }
      
      public static function solveConsortiaIconPath(param1:String) : String
      {
         return info.SITE + "image/consortiaicon/" + param1 + ".png";
      }
      
      public static function solveConsortiaMapPath(param1:String) : String
      {
         return info.SITE + "image/consortiamap/" + param1 + ".png";
      }
      
      public static function solveWorldbossBuffPath() : String
      {
         return info.SITE + "image/worldboss/buff/";
      }
      
      public static function solveSceneCharacterLoaderPath(param1:Number, param2:String, param3:Boolean = true, param4:Boolean = true, param5:String = "1", param6:int = 1, param7:String = "") : String
      {
         var _loc8_:String = null;
         switch(param1)
         {
            case EquipType.HAIR:
               _loc8_ = "hair";
               return info.SITE + "image/virtual/" + (!!param3 ? "M" : "F") + "/" + _loc8_ + "/" + param2 + "/" + param5 + ".png";
            case EquipType.EFF:
               _loc8_ = "eff";
               return info.SITE + "image/virtual/" + (!!param3 ? "M" : "F") + "/" + _loc8_ + "/" + param2 + "/" + param5 + ".png";
            case EquipType.FACE:
               _loc8_ = "face";
               return info.SITE + "image/virtual/" + (!!param3 ? "M" : "F") + "/" + _loc8_ + "/" + param2 + "/" + param5 + ".png";
            case EquipType.CLOTH:
               _loc8_ = param6 == 1 ? "clothF" : (param6 == 2 ? "cloth" : "clothF");
               param2 = param7;
               if(param7 == "")
               {
                  param2 = "default";
               }
               return info.SITE + "image/virtual/" + (!!param3 ? "M" : "F") + "/" + _loc8_ + "/" + param2 + "/" + param5 + ".png";
            default:
               return info.SITE + "image/virtual/" + (!!param3 ? "M" : "F") + "/" + _loc8_ + "/" + param2 + "/" + param5 + ".png";
         }
      }
      
      public static function solveLitteGameCharacterPath(param1:Number, param2:Boolean, param3:int, param4:int, param5:String = "") : String
      {
         var _loc7_:String = null;
         var _loc8_:String = null;
         var _loc6_:String = info.SITE + "image/world/player/" + param3 + "/";
         switch(param1)
         {
            case EquipType.EFFECT:
               _loc7_ = "effect";
               _loc8_ = "default";
               break;
            case EquipType.FACE:
               _loc7_ = "face";
               _loc8_ = param5;
               return _loc6_ + (!!param2 ? "M" : "F") + "/" + _loc7_ + "/" + _loc8_ + "/" + param4 + ".png";
            case EquipType.CLOTH:
               _loc7_ = "body";
               _loc8_ = "default";
               return _loc6_ + (!!param2 ? "M" : "F") + "/" + _loc7_ + "/" + _loc8_ + "/" + param4 + ".png";
         }
         return _loc6_ + (!!param2 ? "M" : "F") + "/" + _loc7_ + "/" + _loc8_ + "/" + param4 + ".png";
      }
      
      public static function solveBlastPath(param1:String) : String
      {
         return info.SITE + "swf/blast.swf";
      }
      
      public static function solveStyleFullPath(param1:Boolean, param2:String, param3:String, param4:String) : String
      {
         return info.SITE + info.STYLE_PATH + (!!param1 ? "M" : "F") + "/" + param2 + "/" + param3 + param4 + "/all.png";
      }
      
      public static function solveStyleHeadPath(param1:Boolean, param2:String, param3:String) : String
      {
         return info.SITE + info.STYLE_PATH + (!!param1 ? "M" : "F") + "/" + param2 + "/" + param3 + "/head.png";
      }
      
      public static function solveStylePreviewPath(param1:Boolean, param2:String, param3:String) : String
      {
         return info.SITE + info.STYLE_PATH + (!!param1 ? "M" : "F") + "/" + param2 + "/" + param3 + "/pre.png";
      }
      
      public static function solvePath(param1:String) : String
      {
         return info.SITE + param1;
      }
      
      public static function solveWeaponSkillSwf(param1:int) : String
      {
         return solveSkillSwf(param1);
      }
      
      public static function solveSkillSwf(param1:int) : String
      {
         return info.SITE + "image/skill/" + param1 + ".swf";
      }
      
      public static function solveBlastOut(param1:int) : String
      {
         return info.SITE + "image/bomb/blastOut/blastOut" + param1 + ".swf";
      }
      
      public static function solveBullet(param1:int) : String
      {
         return info.SITE + "image/bomb/bullet/bullet" + param1 + ".swf";
      }
      
      public static function solveParticle() : String
      {
         return info.SITE + "image/bomb/partical.xml";
      }
      
      public static function solveShape() : String
      {
         return info.SITE + "image/bome/shape.swf";
      }
      
      public static function solveCraterBrink(param1:int) : String
      {
         return info.SITE + "image/bomb/crater/" + param1 + "/craterBrink.png";
      }
      
      public static function solveCrater(param1:int) : String
      {
         return info.SITE + "image/bomb/crater/" + param1 + "/crater.png";
      }
      
      public static function solveBombSwf(param1:int) : String
      {
         return info.FLASHSITE + "bombs/" + param1 + ".swf";
      }
      
      public static function solveSoundSwf() : String
      {
         return info.FLASHSITE + "audio.swf";
      }
      
      public static function solveSoundSwf2() : String
      {
         return info.FLASHSITE + "audioii.swf";
      }
      
      public static function solveParticalXml() : String
      {
         return info.FLASHSITE + "partical.xml";
      }
      
      public static function solveShapeSwf() : String
      {
         return info.FLASHSITE + "shape.swf";
      }
      
      public static function solveCatharineSwf() : String
      {
         return info.FLASHSITE + "Catharine.swf";
      }
      
      public static function solveChurchSceneSourcePath(param1:String) : String
      {
         return info.SITE + "image/church/scene/" + param1 + ".swf";
      }
      
      public static function solveSingleDungeonSourcePath(param1:String) : String
      {
         return info.SITE + "image/world" + param1;
      }
      
      public static function solveGameLivingPath(param1:String) : String
      {
         return info.SITE + "image/game/living/" + param1 + ".swf";
      }
      
      public static function solveWeeklyImagePath(param1:String) : String
      {
         return info.WEEKLY_SITE + "weekly/" + param1;
      }
      
      public static function solveNewHandBuild(param1:String) : String
      {
         return getUIPath() + "/img/trainer/" + param1.slice(0,param1.length - 3) + ".png";
      }
      
      public static function CommnuntyMicroBlog() : Boolean
      {
         return info.COMMUNITY_MICROBLOG;
      }
      
      public static function CommnuntySinaSecondMicroBlog() : Boolean
      {
         return info.COMMUNITY_SINA_SECOND_MICROBLOG;
      }
      
      public static function CommunityInvite() : String
      {
         return info.COMMUNITY_INVITE_PATH;
      }
      
      public static function CommunityFriendList() : String
      {
         return info.COMMUNITY_FRIEND_LIST_PATH;
      }
      
      public static function CommunityExist() : Boolean
      {
         return info.COMMUNITY_EXIST;
      }
      
      public static function CommunityFriendInvitedSwitch() : Boolean
      {
         return info.COMMUNITY_FRIEND_INVITED_SWITCH;
      }
      
      public static function CommunityFriendInvitedOnlineSwitch() : Boolean
      {
         return info.COMMUNITY_FRIEND_INVITED_ONLINE_SWITCH;
      }
      
      public static function isVisibleExistBtn() : Boolean
      {
         return info.IS_VISIBLE_EXISTBTN;
      }
      
      public static function getSnsPath() : String
      {
         return info.SNS_PATH;
      }
      
      public static function getMicrocobolPath() : String
      {
         return info.MICROCOBOL_PATH;
      }
      
      public static function CommunityIcon() : String
      {
         return "CMFriendIcon/icon.png";
      }
      
      public static function CommunitySinaWeibo(param1:String) : String
      {
         return info.SITE + param1;
      }
      
      public static function solveAllowPopupFavorite() : Boolean
      {
         return info.ALLOW_POPUP_FAVORITE;
      }
      
      public static function solveFillJSCommandEnable() : Boolean
      {
         return info.FILL_JS_COMMAND_ENABLE;
      }
      
      public static function solveFillJSCommandValue() : String
      {
         return info.FILL_JS_COMMAND_VALUE;
      }
      
      public static function solveServerListIndex() : int
      {
         return info.SERVERLISTINDEX;
      }
      
      public static function solveSPAEnable() : Boolean
      {
         return info.SPA_ENABLE;
      }
      
      public static function solveCivilEnable() : Boolean
      {
         return info.CIVIL_ENABLE;
      }
      
      public static function solveChurchEnable() : Boolean
      {
         return info.CHURCH_ENABLE;
      }
      
      public static function solveWeeklyEnable() : Boolean
      {
         return info.WEEKLY_ENABLE;
      }
      
      public static function solveAchieveEnable() : Boolean
      {
         return info.ACHIEVE_ENABLE;
      }
      
      public static function solveForthEnable() : Boolean
      {
         return info.FORTH_ENABLE;
      }
      
      public static function solveStrengthMax() : int
      {
         return info.STHRENTH_MAX;
      }
      
      public static function solveUserGuildEnable() : Boolean
      {
         return info.USER_GUILD_ENABLE;
      }
      
      public static function solveFrameTimeOverTag() : int
      {
         return info.FRAME_TIME_OVER_TAG;
      }
      
      public static function solveFrameOverCount() : int
      {
         return info.FRAME_OVER_COUNT_TAG;
      }
      
      public static function solveExternalInterfacePath() : String
      {
         return info.EXTERNAL_INTERFACE_PATH;
      }
      
      public static function ExternalInterface360Path() : String
      {
         return info.EXTERNAL_INTERFACE_PATH_360;
      }
      
      public static function ExternalInterface360Enabel() : Boolean
      {
         return info.EXTERNAL_INTERFACE_ENABLE_360;
      }
      
      public static function solveExternalInterfaceEnabel() : Boolean
      {
         return info.EXTERNAL_INTERFACE_ENABLE;
      }
      
      public static function solveFeedbackEnable() : Boolean
      {
         return info.FEEDBACK_ENABLE;
      }
      
      public static function solveFeedbackTelNumber() : String
      {
         return info.FEEDBACK_TEL_NUMBER;
      }
      
      public static function solveChatFaceDisabledList() : Array
      {
         return info.CHAT_FACE_DISABLED_LIST;
      }
      
      public static function solveASTPath(param1:String) : String
      {
         return info.SITE + "image/world/monster/" + param1 + ".png";
      }
      
      public static function solveLittleGameConfigPath(param1:int) : String
      {
         return info.SITE + "image/tilemap/" + param1 + "/map.bin";
      }
      
      public static function solveLittleGameResPath(param1:int) : String
      {
         return info.SITE + "image/world/map/" + param1 + "/scene.swf";
      }
      
      public static function solveLittleGameObjectPath(param1:String) : String
      {
         return info.SITE + "image/world/" + param1;
      }
      
      public static function solveLittleGameMapPreview(param1:int) : String
      {
         return info.SITE + "image/world/map/" + param1 + "/preview.jpg";
      }
      
      public static function solveBadgePath(param1:int) : String
      {
         return info.SITE + "image/badge/" + param1 + "/icon.png";
      }
      
      public static function solveLeagueRankPath(param1:int) : String
      {
         return info.SITE + "image/leagueRank/" + param1 + "/icon.png";
      }
      
      public static function getUIPath() : String
      {
         return info.FLASHSITE + "ui/" + PathInfo.LANGUAGE;
      }
      
      public static function getBackUpUIPath() : String
      {
         return info.BACKUP_FLASHSITE;
      }
      
      public static function getUIConfigPath(param1:String) : String
      {
         return getUIPath() + "/xml/" + param1 + ".xml";
      }
      
      public static function getLanguagePath() : String
      {
         return getUIPath() + "/" + "language.png";
      }
      
      public static function getDialogConfigPath() : String
      {
         return getUIPath() + "/" + "dialogconfig.xml";
      }
      
      public static function getMovingNotificationPath() : String
      {
         return getUIPath() + "/" + "movingNotification.txt";
      }
      
      public static function getLevelRewardPath() : String
      {
         return getUIPath() + "/" + "levelReward.xml";
      }
      
      public static function getExpressionPath() : String
      {
         return getUIPath() + "/swf/" + "expression.swf";
      }
      
      public static function getZhanPath() : String
      {
         return LoadResourceManager.instance.loadingUrl + "zhanCode.txt";
      }
      
      public static function getTaskDirectorPath() : String
      {
         return getUIPath() + "/TaskDirector.xml";
      }
      
      public static function getCardXMLPath(param1:String) : String
      {
         return param1;
      }
      
      public static function getFightAchieveEnable() : Boolean
      {
         return true;
      }
      
      public static function getFightLibEanble() : Boolean
      {
         return info.FIGHTLIB_ENABLE;
      }
      
      public static function getMonsterPath() : String
      {
         return "monster.swf";
      }
      
      public static function get FLASHSITE() : String
      {
         return info != null ? info.FLASHSITE : null;
      }
      
      public static function get TRAINER_STANDALONE() : Boolean
      {
         return info != null && info.TRAINER_STANDALONE;
      }
      
      public static function get isStatistics() : Boolean
      {
         return info.STATISTICS;
      }
      
      public static function get DISABLE_TASK_ID() : Array
      {
         var _loc1_:Array = new Array();
         if(info == null)
         {
            return _loc1_;
         }
         return info.DISABLE_TASK_ID.split(",");
      }
      
      public static function get LittleGameMinLv() : int
      {
         return info.LITTLEGAMEMINLV;
      }
      
      public static function solvePetGameAssetUrl(param1:String) : String
      {
         return info.SITE + "image/gameasset/" + param1 + ".swf";
      }
      
      public static function solvePetFarmAssetUrl(param1:String) : String
      {
         return info.SITE + "image/" + param1 + ".swf";
      }
      
      public static function solvePetAdvanceEffect(param1:String) : String
      {
         return info.SITE + "image/gameasset/advanceeffect/" + param1 + ".swf";
      }
      
      public static function solveSkillPicUrl(param1:String) : String
      {
         return info.SITE + "image/petskill/" + param1 + "/icon.png";
      }
      
      public static function solvePetSkillEffect(param1:String) : String
      {
         return info.SITE + "image/skilleffect/" + param1 + ".swf";
      }
      
      public static function solvePetBuff(param1:String) : String
      {
         return info.SITE + "image/buff/" + param1 + "/icon.png";
      }
      
      public static function solveConsortionBuff(param1:String) : String
      {
         return info.SITE + "image/" + param1 + "/icon.png";
      }
      
      public static function solvePetIconUrl(param1:String) : String
      {
         return info.SITE + "image/pet/" + param1 + ".png";
      }
      
      public static function solveMagicSoul() : String
      {
         return info.SITE + "image/world/missionselect/mapobjects/magicsoul.swf";
      }
      
      public static function solveGradeNotificationPath(param1:int) : String
      {
         return info.GRADE_NOTIFICATION[param1.toString()];
      }
      
      public static function solveWorldBossMapSourcePath(param1:String) : String
      {
         return getUIPath() + "/" + "Map02.swf";
      }
      
      public static function callLoginInterface() : String
      {
         return info.CALL_LOGIN_INTERFAECE;
      }
      
      public static function userActionNotice() : String
      {
         return info.USER_ACTION_NOTICE;
      }
      
      public static function solveSingleDungeonWorldMapPath(param1:String) : String
      {
         return info.SITE + "image/world/missionselect/pagemap/" + param1 + ".jpg";
      }
      
      public static function solveSingleDungeonSelectMisstionPath(param1:String) : String
      {
         return info.SITE + "image/world/missionselect/dungeon/" + param1;
      }
      
      public static function solveWalkSceneMapPath(param1:String) : String
      {
         return info.SITE + "image/world/missionselect/walkscene/" + param1 + ".swf";
      }
      
      public static function solveConsortionWalkSceneMapPath(param1:String) : String
      {
         return info.SITE + "image/world/missionselect/walkscene/" + param1 + ".swf";
      }
      
      public static function solveWalkSceneMapobjectsPath(param1:String) : String
      {
         return info.SITE + "image/world/missionselect/mapobjects/" + param1 + ".swf";
      }
      
      public static function solveConsortionMonsterPath(param1:String) : String
      {
         return info.SITE + "image/game/living/" + param1 + ".swf";
      }
      
      public static function get isShowFavoriteAlert() : Boolean
      {
         return info.SHOW_FAVORITE;
      }
      
      public static function get isDebug() : Boolean
      {
         return info.ISDEBUG;
      }
   }
}
