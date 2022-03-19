// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//ddt.manager.PathManager

package ddt.manager
{
    import ddt.data.PathInfo;
    import ddt.data.EquipType;
    import ddt.data.goods.ItemTemplateInfo;
    import com.pickgliss.loader.LoadResourceManager;

    public class PathManager 
    {

        private static var info:PathInfo;
        public static var SITE_MAIN:String = "";
        public static var SITE_WEEKLY:String = "";


        public static function setup(_arg_1:PathInfo):void
        {
            info = _arg_1;
            SITE_MAIN = info.SITE;
            SITE_WEEKLY = info.WEEKLY_SITE;
        }

        public static function solvePhpPath():String
        {
            return (info.PHP_PATH);
        }

        public static function solveOfficialSitePath():String
        {
            info.OFFICIAL_SITE = info.OFFICIAL_SITE.replace("{uid}", PlayerManager.Instance.Self.ID);
            return (info.OFFICIAL_SITE);
        }

        public static function solveGameForum():String
        {
            info.GAME_FORUM = info.GAME_FORUM.replace("{uid}", PlayerManager.Instance.Self.ID);
            return (info.GAME_FORUM);
        }

        public static function get solveCommunityFriend():String
        {
            return (info.COMMUNITY_FRIEND_PATH);
        }

        public static function solveClientDownloadPath():String
        {
            return (info.CLIENT_DOWNLOAD);
        }

        public static function solveWebPlayerInfoPath(_arg_1:String, _arg_2:String="", _arg_3:String=""):String
        {
            var _local_4:String = info.WEB_PLAYER_INFO_PATH.replace("{uid}", _arg_1);
            _local_4 = _local_4.replace("{code}", _arg_2);
            return (_local_4.replace("{key}", _arg_3));
        }

        public static function solveFlvSound(_arg_1:String):String
        {
            return (((info.SITE + "sound/") + _arg_1) + ".flv");
        }

        public static function solveFirstPage():String
        {
            return (info.FIRSTPAGE);
        }

        public static function get FirstPage():String
        {
            return (info.FIRSTPAGE);
        }

        public static function solveRegister():String
        {
            return (info.REGISTER);
        }

        public static function solveLogin():String
        {
            info.LOGIN_PATH = info.LOGIN_PATH.replace("{nickName}", PlayerManager.Instance.Self.NickName);
            info.LOGIN_PATH = info.LOGIN_PATH.replace("{uid}", PlayerManager.Instance.Self.ID);
            return (info.LOGIN_PATH);
        }

        public static function solveConfigSite():String
        {
            return (info.SITEII);
        }

        public static function solveFillPage():String
        {
            info.FILL_PATH = info.FILL_PATH.replace("{nickName}", PlayerManager.Instance.Self.NickName);
            info.FILL_PATH = info.FILL_PATH.replace("{uid}", PlayerManager.Instance.Self.ID);
            return (info.FILL_PATH);
        }

        public static function solveLoginPHP(_arg_1:String):String
        {
            return (info.PHP_PATH.replace("{id}", _arg_1));
        }

        public static function checkOpenPHP():Boolean
        {
            return (info.PHP_IMAGE_LINK);
        }

        public static function solveTrainerPage():String
        {
            return (info.TRAINER_PATH);
        }

        public static function solveWeeklyPath(_arg_1:String):String
        {
            return ((info.WEEKLY_SITE + "weekly/") + _arg_1);
        }

        public static function solveMapPath(_arg_1:int, _arg_2:String, _arg_3:String):String
        {
            return ((((((info.SITE + "image/map/") + _arg_1.toString()) + "/") + _arg_2) + ".") + _arg_3);
        }

        public static function solveMapSmallView(_arg_1:int):String
        {
            return (((info.SITE + "image/map/") + _arg_1.toString()) + "/small.png");
        }

        public static function solveRequestPath(_arg_1:String):String
        {
            return (info.REQUEST_PATH + _arg_1);
        }

        public static function solveRequestXMLPath(_arg_1:String):String
        {
            return ((info.REQUEST_PATH + "xml/") + _arg_1);
        }

        public static function getRequestPath():String
        {
            return (info.REQUEST_PATH);
        }

        public static function solvePropPath(_arg_1:String):String
        {
            return (((info.SITE + "image/tool/") + _arg_1) + ".png");
        }

        public static function solveMapIconPath(_arg_1:int, _arg_2:int, _arg_3:String="show1.jpg"):String
        {
            var _local_4:String = "";
            if (_arg_2 == 0)
            {
                _local_4 = (((info.SITE + "image/map/") + _arg_1.toString()) + "/icon.png");
            }
            else
            {
                if (_arg_2 == 1)
                {
                    _local_4 = (((info.SITE + "image/map/") + _arg_1.toString()) + "/samll_map.png");
                }
                else
                {
                    if (_arg_2 == 2)
                    {
                        _local_4 = ((((info.SITE + "image/map/") + _arg_1.toString()) + "/") + _arg_3);
                    }
                    else
                    {
                        if (_arg_2 == 3)
                        {
                            _local_4 = (((info.SITE + "image/map/") + _arg_1.toString()) + "/samll_map_s.jpg");
                        };
                    };
                };
            };
            return (_local_4);
        }

        public static function solveEffortIconPath(_arg_1:String):String
        {
            var _local_2:String = "";
            return (((info.SITE + "image/effort/") + _arg_1) + "/icon.png");
        }

        public static function solveFieldPlantPath(_arg_1:String, _arg_2:int):String
        {
            return (((info.SITE + "image/farm/Crops/") + _arg_1) + "/crop.swf");
        }

        public static function solveSeedPath(_arg_1:String):String
        {
            return (((info.SITE + "image/farm/Crops/") + _arg_1) + "/seed.png");
        }

        public static function solveCountPath():String
        {
            return (info.COUNT_PATH);
        }

        public static function solveParterId():String
        {
            return (info.PARTER_ID);
        }

        public static function solveStylePath(_arg_1:Boolean, _arg_2:String, _arg_3:String):String
        {
            return (((((((info.SITE + info.STYLE_PATH) + ((_arg_1) ? "m" : "f")) + "/") + _arg_2) + "/") + _arg_3) + ".png");
        }

        public static function solveArmPath(_arg_1:String, _arg_2:String):String
        {
            return (((((info.SITE + info.STYLE_PATH) + String(_arg_1)) + "/") + _arg_2) + ".png");
        }

        public static function solveGoodsPath(_arg_1:ItemTemplateInfo, _arg_2:String, _arg_3:Boolean=true, _arg_4:String="show", _arg_5:String="A", _arg_6:String="1", _arg_7:int=1, _arg_8:Boolean=false, _arg_9:int=0, _arg_10:String=""):String
        {
            var _local_11:String = "";
            var _local_12:String = "";
            var _local_13:String = "";
            var _local_14:String = "";
            var _local_15:String = "";
            var _local_16:String = "";
            var _local_17:String = "";
            var _local_18:String = (_arg_4 + ".png");
            if (((EquipType.isWeapon(_arg_1.TemplateID)) || (_arg_1.CategoryID == EquipType.TEMPWEAPON)))
            {
                _local_17 = ("/" + 1);
                _local_11 = "arm/";
                if (_arg_4.indexOf("icon") == -1)
                {
                    _local_14 = ((_arg_8) ? "/1" : "/0");
                };
                return ((((((info.SITE + "image/emboitement/") + _arg_2) + _local_17) + _local_14) + "/") + _local_18);
            };
            if (((_arg_1.CategoryID == EquipType.UNFRIGHTPROP) || (_arg_1.CategoryID == EquipType.SPACE_UPDATE)))
            {
                return ((((info.SITE + "image/unfrightprop/") + _arg_2) + "/") + _local_18);
            };
            if (_arg_1.CategoryID == EquipType.TASK)
            {
                return (((info.SITE + "image/task/") + _arg_2) + "/icon.png");
            };
            if (_arg_1.CategoryID == EquipType.CHATBALL)
            {
                return (((info.SITE + "image/specialprop/chatBall/") + _arg_2) + "/icon.png");
            };
            if ((((((_arg_1.CategoryID < 10) || (_arg_1.CategoryID == EquipType.SUITS)) || (_arg_1.CategoryID == EquipType.NECKLACE)) || (_arg_1.CategoryID == EquipType.TEMPARMLET)) || (_arg_1.CategoryID == EquipType.TEMPRING)))
            {
                if (_arg_1.CategoryID == EquipType.HAIR)
                {
                    if (_arg_4.indexOf("icon") == -1)
                    {
                        _local_15 = ("/" + _arg_5);
                    };
                };
                _local_11 = "equip/";
                _local_13 = (EquipType.TYPES[_arg_1.CategoryID] + "/");
                _local_12 = ((_arg_3) ? "m/" : "f/");
                if ((((((!(_arg_1.CategoryID == EquipType.ARMLET)) && (!(_arg_1.CategoryID == EquipType.RING))) && (!(_arg_1.CategoryID == EquipType.NECKLACE))) && (!(_arg_1.CategoryID == EquipType.TEMPARMLET))) && (!(_arg_1.CategoryID == EquipType.TEMPRING))))
                {
                    if (_arg_4 == "icon")
                    {
                        _arg_4 = ("icon_" + _arg_6);
                        _arg_6 = "";
                    }
                    else
                    {
                        _local_16 = ("/" + _arg_6);
                    };
                }
                else
                {
                    _local_12 = "";
                };
                _local_18 = ((_arg_4 + _arg_10) + ".png");
                if (_arg_1.CategoryID == EquipType.SUITS)
                {
                    return (((((((((((info.SITE + "image/") + _local_11) + "f/") + _local_13) + _arg_2) + _local_16) + _local_15) + _local_17) + _local_14) + "/") + _local_18);
                };
                return (((((((((((info.SITE + "image/") + _local_11) + _local_12) + _local_13) + _arg_2) + _local_16) + _local_15) + _local_17) + _local_14) + "/") + _local_18);
            };
            if (_arg_1.CategoryID == EquipType.WING)
            {
                return ((((info.SITE + "image/equip/wing/") + _arg_2) + "/") + _local_18);
            };
            if (_arg_1.CategoryID == EquipType.HEALSTONE)
            {
                return (((info.SITE + "image/equip/recover/") + _arg_2) + "/icon.png");
            };
            if ((((_arg_1.CategoryID == EquipType.TEXP) || (_arg_1.CategoryID == EquipType.TEXP_TASK)) || (_arg_1.CategoryID == EquipType.ACTIVE_TASK)))
            {
                return (((info.SITE + "image/unfrightprop/") + _arg_2) + "/icon.png");
            };
            if (((_arg_1.CategoryID == EquipType.SEED) || (_arg_1.CategoryID == EquipType.VEGETABLE)))
            {
                return (((info.SITE + "image/unfrightprop/") + _arg_2) + "/icon.png");
            };
            if (_arg_1.CategoryID == EquipType.MANURE)
            {
                return (((info.SITE + "image/farm/Fertilizer/") + _arg_2) + "/icon.png");
            };
            if (((_arg_1.CategoryID == EquipType.FOOD) || (_arg_1.CategoryID == EquipType.PET_EGG)))
            {
                return (((info.SITE + "image/unfrightprop/") + _arg_2) + "/icon.png");
            };
            if (_arg_1.CategoryID == EquipType.EQUIP)
            {
                return (((info.SITE + "image/emboitement/") + _arg_2) + "/icon.png");
            };
            if (_arg_1.CategoryID == EquipType.COMPOSE_MATERIAL)
            {
                return (((info.SITE + "image/unfrightprop/") + _arg_2) + "/icon.png");
            };
            if (_arg_1.CategoryID == EquipType.COMPOSE_SKILL)
            {
                return (((info.SITE + "image/unfrightprop/") + _arg_2) + "/icon.png");
            };
            return ((((info.SITE + "image/prop/") + _arg_2) + "/") + _local_18);
        }

        public static function soloveWingPath(_arg_1:String):String
        {
            return (((info.SITE + "image/equip/wing/") + _arg_1) + "/wings.swf");
        }

        public static function soloveSinpleLightPath(_arg_1:String):String
        {
            return (((info.SITE + "image/equip/sinplelight/") + _arg_1) + ".swf");
        }

        public static function soloveCircleLightPath(_arg_1:String):String
        {
            return (((info.SITE + "image/equip/circlelight/") + _arg_1) + ".swf");
        }

        public static function solveConsortiaIconPath(_arg_1:String):String
        {
            return (((info.SITE + "image/consortiaicon/") + _arg_1) + ".png");
        }

        public static function solveConsortiaMapPath(_arg_1:String):String
        {
            return (((info.SITE + "image/consortiamap/") + _arg_1) + ".png");
        }

        public static function solveWorldbossBuffPath():String
        {
            return (info.SITE + "image/worldboss/buff/");
        }

        public static function solveSceneCharacterLoaderPath(_arg_1:Number, _arg_2:String, _arg_3:Boolean=true, _arg_4:Boolean=true, _arg_5:String="1", _arg_6:int=1, _arg_7:String=""):String
        {
            var _local_8:String;
            switch (_arg_1)
            {
                case EquipType.HAIR:
                    _local_8 = "hair";
                    return (((((((((info.SITE + "image/virtual/") + ((_arg_3) ? "M" : "F")) + "/") + _local_8) + "/") + _arg_2) + "/") + _arg_5) + ".png");
                case EquipType.EFF:
                    _local_8 = "eff";
                    return (((((((((info.SITE + "image/virtual/") + ((_arg_3) ? "M" : "F")) + "/") + _local_8) + "/") + _arg_2) + "/") + _arg_5) + ".png");
                case EquipType.FACE:
                    _local_8 = "face";
                    return (((((((((info.SITE + "image/virtual/") + ((_arg_3) ? "M" : "F")) + "/") + _local_8) + "/") + _arg_2) + "/") + _arg_5) + ".png");
                case EquipType.CLOTH:
                    _local_8 = ((_arg_6 == 1) ? "clothF" : ((_arg_6 == 2) ? "cloth" : "clothF"));
                    _arg_2 = _arg_7;
                    if (_arg_7 == "")
                    {
                        _arg_2 = "default";
                    };
                    return (((((((((info.SITE + "image/virtual/") + ((_arg_3) ? "M" : "F")) + "/") + _local_8) + "/") + _arg_2) + "/") + _arg_5) + ".png");
            };
            return (((((((((info.SITE + "image/virtual/") + ((_arg_3) ? "M" : "F")) + "/") + _local_8) + "/") + _arg_2) + "/") + _arg_5) + ".png");
        }

        public static function solveLitteGameCharacterPath(_arg_1:Number, _arg_2:Boolean, _arg_3:int, _arg_4:int, _arg_5:String=""):String
        {
            var _local_7:String;
            var _local_8:String;
            var _local_6:String = (((info.SITE + "image/world/player/") + _arg_3) + "/");
            switch (_arg_1)
            {
                case EquipType.EFFECT:
                    _local_7 = "effect";
                    _local_8 = "default";
                    break;
                case EquipType.FACE:
                    _local_7 = "face";
                    _local_8 = _arg_5;
                    return ((((((((_local_6 + ((_arg_2) ? "M" : "F")) + "/") + _local_7) + "/") + _local_8) + "/") + _arg_4) + ".png");
                case EquipType.CLOTH:
                    _local_7 = "body";
                    _local_8 = "default";
                    return ((((((((_local_6 + ((_arg_2) ? "M" : "F")) + "/") + _local_7) + "/") + _local_8) + "/") + _arg_4) + ".png");
            };
            return ((((((((_local_6 + ((_arg_2) ? "M" : "F")) + "/") + _local_7) + "/") + _local_8) + "/") + _arg_4) + ".png");
        }

        public static function solveBlastPath(_arg_1:String):String
        {
            return (info.SITE + "swf/blast.swf");
        }

        public static function solveStyleFullPath(_arg_1:Boolean, _arg_2:String, _arg_3:String, _arg_4:String):String
        {
            return ((((((((info.SITE + info.STYLE_PATH) + ((_arg_1) ? "M" : "F")) + "/") + _arg_2) + "/") + _arg_3) + _arg_4) + "/all.png");
        }

        public static function solveStyleHeadPath(_arg_1:Boolean, _arg_2:String, _arg_3:String):String
        {
            return (((((((info.SITE + info.STYLE_PATH) + ((_arg_1) ? "M" : "F")) + "/") + _arg_2) + "/") + _arg_3) + "/head.png");
        }

        public static function solveStylePreviewPath(_arg_1:Boolean, _arg_2:String, _arg_3:String):String
        {
            return (((((((info.SITE + info.STYLE_PATH) + ((_arg_1) ? "M" : "F")) + "/") + _arg_2) + "/") + _arg_3) + "/pre.png");
        }

        public static function solvePath(_arg_1:String):String
        {
            return (info.SITE + _arg_1);
        }

        public static function solveWeaponSkillSwf(_arg_1:int):String
        {
            return (solveSkillSwf(_arg_1));
        }

        public static function solveSkillSwf(_arg_1:int):String
        {
            return (((info.SITE + "image/skill/") + _arg_1) + ".swf");
        }

        public static function solveBlastOut(_arg_1:int):String
        {
            return (((info.SITE + "image/bomb/blastOut/blastOut") + _arg_1) + ".swf");
        }

        public static function solveBullet(_arg_1:int):String
        {
            return (((info.SITE + "image/bomb/bullet/bullet") + _arg_1) + ".swf");
        }

        public static function solveParticle():String
        {
            return (info.SITE + "image/bomb/partical.xml");
        }

        public static function solveShape():String
        {
            return (info.SITE + "image/bome/shape.swf");
        }

        public static function solveCraterBrink(_arg_1:int):String
        {
            return (((info.SITE + "image/bomb/crater/") + _arg_1) + "/craterBrink.png");
        }

        public static function solveCrater(_arg_1:int):String
        {
            return (((info.SITE + "image/bomb/crater/") + _arg_1) + "/crater.png");
        }

        public static function solveBombSwf(_arg_1:int):String
        {
            return (((info.FLASHSITE + "bombs/") + _arg_1) + ".swf");
        }

        public static function solveSoundSwf():String
        {
            return (info.FLASHSITE + "audio.swf");
        }

        public static function solveSoundSwf2():String
        {
            return (info.FLASHSITE + "audioii.swf");
        }

        public static function solveParticalXml():String
        {
            return (info.FLASHSITE + "partical.xml");
        }

        public static function solveShapeSwf():String
        {
            return (info.FLASHSITE + "shape.swf");
        }

        public static function solveCatharineSwf():String
        {
            return (info.FLASHSITE + "Catharine.swf");
        }

        public static function solveChurchSceneSourcePath(_arg_1:String):String
        {
            return (((info.SITE + "image/church/scene/") + _arg_1) + ".swf");
        }

        public static function solveSingleDungeonSourcePath(_arg_1:String):String
        {
            return ((info.SITE + "image/world") + _arg_1);
        }

        public static function solveGameLivingPath(_arg_1:String):String
        {
            return (((info.SITE + "image/game/living/") + _arg_1) + ".swf");
        }

        public static function solveWeeklyImagePath(_arg_1:String):String
        {
            return ((info.WEEKLY_SITE + "weekly/") + _arg_1);
        }

        public static function solveNewHandBuild(_arg_1:String):String
        {
            return (((getUIPath() + "/img/trainer/") + _arg_1.slice(0, (_arg_1.length - 3))) + ".png");
        }

        public static function CommnuntyMicroBlog():Boolean
        {
            return (info.COMMUNITY_MICROBLOG);
        }

        public static function CommnuntySinaSecondMicroBlog():Boolean
        {
            return (info.COMMUNITY_SINA_SECOND_MICROBLOG);
        }

        public static function CommunityInvite():String
        {
            return (info.COMMUNITY_INVITE_PATH);
        }

        public static function CommunityFriendList():String
        {
            return (info.COMMUNITY_FRIEND_LIST_PATH);
        }

        public static function CommunityExist():Boolean
        {
            return (info.COMMUNITY_EXIST);
        }

        public static function CommunityFriendInvitedSwitch():Boolean
        {
            return (info.COMMUNITY_FRIEND_INVITED_SWITCH);
        }

        public static function CommunityFriendInvitedOnlineSwitch():Boolean
        {
            return (info.COMMUNITY_FRIEND_INVITED_ONLINE_SWITCH);
        }

        public static function isVisibleExistBtn():Boolean
        {
            return (info.IS_VISIBLE_EXISTBTN);
        }

        public static function getSnsPath():String
        {
            return (info.SNS_PATH);
        }

        public static function getMicrocobolPath():String
        {
            return (info.MICROCOBOL_PATH);
        }

        public static function CommunityIcon():String
        {
            return ("CMFriendIcon/icon.png");
        }

        public static function CommunitySinaWeibo(_arg_1:String):String
        {
            return (info.SITE + _arg_1);
        }

        public static function solveAllowPopupFavorite():Boolean
        {
            return (info.ALLOW_POPUP_FAVORITE);
        }

        public static function solveFillJSCommandEnable():Boolean
        {
            return (info.FILL_JS_COMMAND_ENABLE);
        }

        public static function solveFillJSCommandValue():String
        {
            return (info.FILL_JS_COMMAND_VALUE);
        }

        public static function solveServerListIndex():int
        {
            return (info.SERVERLISTINDEX);
        }

        public static function solveSPAEnable():Boolean
        {
            return (info.SPA_ENABLE);
        }

        public static function solveCivilEnable():Boolean
        {
            return (info.CIVIL_ENABLE);
        }

        public static function solveChurchEnable():Boolean
        {
            return (info.CHURCH_ENABLE);
        }

        public static function solveWeeklyEnable():Boolean
        {
            return (info.WEEKLY_ENABLE);
        }

        public static function solveAchieveEnable():Boolean
        {
            return (info.ACHIEVE_ENABLE);
        }

        public static function solveForthEnable():Boolean
        {
            return (info.FORTH_ENABLE);
        }

        public static function solveStrengthMax():int
        {
            return (info.STHRENTH_MAX);
        }

        public static function solveUserGuildEnable():Boolean
        {
            return (info.USER_GUILD_ENABLE);
        }

        public static function solveFrameTimeOverTag():int
        {
            return (info.FRAME_TIME_OVER_TAG);
        }

        public static function solveFrameOverCount():int
        {
            return (info.FRAME_OVER_COUNT_TAG);
        }

        public static function solveExternalInterfacePath():String
        {
            return (info.EXTERNAL_INTERFACE_PATH);
        }

        public static function ExternalInterface360Path():String
        {
            return (info.EXTERNAL_INTERFACE_PATH_360);
        }

        public static function ExternalInterface360Enabel():Boolean
        {
            return (info.EXTERNAL_INTERFACE_ENABLE_360);
        }

        public static function solveExternalInterfaceEnabel():Boolean
        {
            return (info.EXTERNAL_INTERFACE_ENABLE);
        }

        public static function solveFeedbackEnable():Boolean
        {
            return (info.FEEDBACK_ENABLE);
        }

        public static function solveFeedbackTelNumber():String
        {
            return (info.FEEDBACK_TEL_NUMBER);
        }

        public static function solveChatFaceDisabledList():Array
        {
            return (info.CHAT_FACE_DISABLED_LIST);
        }

        public static function solveASTPath(_arg_1:String):String
        {
            return (((info.SITE + "image/world/monster/") + _arg_1) + ".png");
        }

        public static function solveLittleGameConfigPath(_arg_1:int):String
        {
            return (((info.SITE + "image/tilemap/") + _arg_1) + "/map.bin");
        }

        public static function solveLittleGameResPath(_arg_1:int):String
        {
            return (((info.SITE + "image/world/map/") + _arg_1) + "/scene.swf");
        }

        public static function solveLittleGameObjectPath(_arg_1:String):String
        {
            return ((info.SITE + "image/world/") + _arg_1);
        }

        public static function solveLittleGameMapPreview(_arg_1:int):String
        {
            return (((info.SITE + "image/world/map/") + _arg_1) + "/preview.jpg");
        }

        public static function solveBadgePath(_arg_1:int):String
        {
            return (((info.SITE + "image/badge/") + _arg_1) + "/icon.png");
        }

        public static function solveLeagueRankPath(_arg_1:int):String
        {
            return (((info.SITE + "image/leagueRank/") + _arg_1) + "/icon.png");
        }

        public static function getUIPath():String
        {
            return ((info.FLASHSITE + "ui/") + PathInfo.LANGUAGE);
        }

        public static function getBackUpUIPath():String
        {
            return (info.BACKUP_FLASHSITE);
        }

        public static function getUIConfigPath(_arg_1:String):String
        {
            return (((getUIPath() + "/xml/") + _arg_1) + ".xml");
        }

        public static function getLanguagePath():String
        {
            return ((getUIPath() + "/") + "language.png");
        }

        public static function getDialogConfigPath():String
        {
            return ((getUIPath() + "/") + "dialogconfig.xml");
        }

        public static function getMovingNotificationPath():String
        {
            return ((getUIPath() + "/") + "movingNotification.txt");
        }

        public static function getLevelRewardPath():String
        {
            return ((getUIPath() + "/") + "levelReward.xml");
        }

        public static function getExpressionPath():String
        {
            return ((getUIPath() + "/swf/") + "expression.swf");
        }

        public static function getZhanPath():String
        {
            return (LoadResourceManager.instance.loadingUrl + "zhanCode.txt");
        }

        public static function getTaskDirectorPath():String
        {
            return (getUIPath() + "/TaskDirector.xml");
        }

        public static function getCardXMLPath(_arg_1:String):String
        {
            return (_arg_1);
        }

        public static function getFightAchieveEnable():Boolean
        {
            return (true);
        }

        public static function getFightLibEanble():Boolean
        {
            return (info.FIGHTLIB_ENABLE);
        }

        public static function getMonsterPath():String
        {
            return ("monster.swf");
        }

        public static function get FLASHSITE():String
        {
            return ((!(info == null)) ? info.FLASHSITE : null);
        }

        public static function get TRAINER_STANDALONE():Boolean
        {
            return ((!(info == null)) && (info.TRAINER_STANDALONE));
        }

        public static function get isStatistics():Boolean
        {
            return (info.STATISTICS);
        }

        public static function get DISABLE_TASK_ID():Array
        {
            var _local_1:Array = new Array();
            if (info == null)
            {
                return (_local_1);
            };
            return (info.DISABLE_TASK_ID.split(","));
        }

        public static function get LittleGameMinLv():int
        {
            return (info.LITTLEGAMEMINLV);
        }

        public static function solvePetGameAssetUrl(_arg_1:String):String
        {
            return (((info.SITE + "image/gameasset/") + _arg_1) + ".swf");
        }

        public static function solvePetFarmAssetUrl(_arg_1:String):String
        {
            return (((info.SITE + "image/") + _arg_1) + ".swf");
        }

        public static function solvePetAdvanceEffect(_arg_1:String):String
        {
            return (((info.SITE + "image/gameasset/advanceeffect/") + _arg_1) + ".swf");
        }

        public static function solveSkillPicUrl(_arg_1:String):String
        {
            return (((info.SITE + "image/petskill/") + _arg_1) + "/icon.png");
        }

        public static function solvePetSkillEffect(_arg_1:String):String
        {
            return (((info.SITE + "image/skilleffect/") + _arg_1) + ".swf");
        }

        public static function solvePetBuff(_arg_1:String):String
        {
            return (((info.SITE + "image/buff/") + _arg_1) + "/icon.png");
        }

        public static function solveConsortionBuff(_arg_1:String):String
        {
            return (((info.SITE + "image/") + _arg_1) + "/icon.png");
        }

        public static function solvePetIconUrl(_arg_1:String):String
        {
            return (((info.SITE + "image/pet/") + _arg_1) + ".png");
        }

        public static function solveMagicSoul():String
        {
            return (info.SITE + "image/world/missionselect/mapobjects/magicsoul.swf");
        }

        public static function solveGradeNotificationPath(_arg_1:int):String
        {
            return (info.GRADE_NOTIFICATION[_arg_1.toString()]);
        }

        public static function solveWorldBossMapSourcePath(_arg_1:String):String
        {
            return ((getUIPath() + "/") + "Map02.swf");
        }

        public static function callLoginInterface():String
        {
            return (info.CALL_LOGIN_INTERFAECE);
        }

        public static function userActionNotice():String
        {
            return (info.USER_ACTION_NOTICE);
        }

        public static function solveSingleDungeonWorldMapPath(_arg_1:String):String
        {
            return (((info.SITE + "image/world/missionselect/pagemap/") + _arg_1) + ".jpg");
        }

        public static function solveSingleDungeonSelectMisstionPath(_arg_1:String):String
        {
            return ((info.SITE + "image/world/missionselect/dungeon/") + _arg_1);
        }

        public static function solveWalkSceneMapPath(_arg_1:String):String
        {
            return (((info.SITE + "image/world/missionselect/walkscene/") + _arg_1) + ".swf");
        }

        public static function solveConsortionWalkSceneMapPath(_arg_1:String):String
        {
            return (((info.SITE + "image/world/missionselect/walkscene/") + _arg_1) + ".swf");
        }

        public static function solveWalkSceneMapobjectsPath(_arg_1:String):String
        {
            return (((info.SITE + "image/world/missionselect/mapobjects/") + _arg_1) + ".swf");
        }

        public static function solveConsortionMonsterPath(_arg_1:String):String
        {
            return (((info.SITE + "image/game/living/") + _arg_1) + ".swf");
        }

        public static function get isShowFavoriteAlert():Boolean
        {
            return (info.SHOW_FAVORITE);
        }

        public static function get isDebug():Boolean
        {
            return (info.ISDEBUG);
        }


    }
}//package ddt.manager

