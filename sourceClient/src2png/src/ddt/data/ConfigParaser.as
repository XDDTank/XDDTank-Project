// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//ddt.data.ConfigParaser

package ddt.data
{
    import com.pickgliss.utils.StringUtils;
    import ddt.manager.StatisticManager;
    import ddt.manager.PlayerManager;
    import flash.system.Security;
    import game.GameManager;
    import ddt.manager.PathManager;
    import flash.display.LoaderInfo;

    public class ConfigParaser 
    {


        public static function paras(_arg_1:XML, _arg_2:LoaderInfo, _arg_3:String):void
        {
            var _local_8:XML;
            var _local_9:XMLList;
            var _local_10:XML;
            var _local_11:String;
            var _local_12:String;
            var _local_4:PathInfo = new PathInfo();
            _local_4.SITEII = String(_arg_2.parameters["site"]);
            if (_local_4.SITEII == "undefined")
            {
                _local_4.SITEII = "";
            };
            _local_4.SITE = _arg_1.SITE.@value;
            _local_4.WEEKLY_SITE = _arg_1.WEEKLYSITE.@value;
            _local_4.BACKUP_FLASHSITE = _arg_1.BACKUP_FLASHSITE.@value;
            _local_4.FLASHSITE = _arg_1.FLASHSITE.@value;
            _local_4.COMMUNITY_FRIEND_PATH = _arg_1.COMMUNITY_FRIEND_PATH.@value;
            if (_arg_1.COMMUNITY_MICROBLOG.hasOwnProperty("@value"))
            {
                _local_4.COMMUNITY_MICROBLOG = StringUtils.converBoolean(_arg_1.COMMUNITY_MICROBLOG.@value);
            };
            if (_arg_1.COMMUNITY_SINA_SECOND_MICROBLOG.hasOwnProperty("@value"))
            {
                _local_4.COMMUNITY_SINA_SECOND_MICROBLOG = StringUtils.converBoolean(_arg_1.COMMUNITY_SINA_SECOND_MICROBLOG.@value);
            };
            if (_arg_1.COMMUNITY_FRIEND_PATH.hasOwnProperty("@isUser"))
            {
                PathInfo.isUserAddFriend = StringUtils.converBoolean(_arg_1.COMMUNITY_FRIEND_PATH.@isUser);
            };
            _local_4.STYLE_PATH = _arg_1.STYLE_PATH.@value;
            _local_4.FIRSTPAGE = _arg_1.FIRSTPAGE.@value;
            _local_4.REGISTER = _arg_1.REGISTER.@value;
            _local_4.REQUEST_PATH = _arg_1.REQUEST_PATH.@value;
            _local_4.FILL_PATH = String(_arg_1.FILL_PATH.@value).replace("{user}", _arg_3);
            _local_4.FILL_PATH = _local_4.FILL_PATH.replace("{site}", _local_4.SITEII);
            _local_4.LOGIN_PATH = String(_arg_1.LOGIN_PATH.@value).replace("{user}", _arg_3);
            _local_4.LOGIN_PATH = _local_4.LOGIN_PATH.replace("{site}", _local_4.SITEII);
            _local_4.OFFICIAL_SITE = _arg_1.OFFICIAL_SITE.@value;
            _local_4.GAME_FORUM = _arg_1.GAME_FORUM.@value;
            _local_4.DISABLE_TASK_ID = _arg_1.DISABLE_TASK_ID.@value;
            _local_4.LITTLEGAMEMINLV = _arg_1.LITTLEGAMEMINLV.@value;
            if (_arg_1.LOGIN_PATH.hasOwnProperty("@siteName"))
            {
                StatisticManager.siteName = _arg_1.LOGIN_PATH.@siteName;
            };
            _local_4.TRAINER_STANDALONE = ((String(_arg_1.TRAINER_STANDALONE.@value) == "false") ? false : true);
            _local_4.TRAINER_PATH = _arg_1.TRAINER_PATH.@value;
            _local_4.COUNT_PATH = _arg_1.COUNT_PATH.@value;
            _local_4.PARTER_ID = _arg_1.PARTER_ID.@value;
            _local_4.CLIENT_DOWNLOAD = _arg_1.CLIENT_DOWNLOAD.@value;
            if (_arg_1.STATISTIC.hasOwnProperty("@value"))
            {
            };
            var _local_5:int = int(_arg_1.SUCIDE_TIME.@value);
            if (_local_5 > 0)
            {
                PathInfo.SUCIDE_TIME = (_local_5 * 1000);
            };
            var _local_6:int = int(_arg_1.BOX_STYLE.@value);
            if (_local_6 != 0)
            {
            };
            _local_4.PHP_PATH = _arg_1.PHP.@site;
            if (_arg_1.PHP.hasOwnProperty("@link"))
            {
                _local_4.PHP_IMAGE_LINK = StringUtils.converBoolean(_arg_1.PHP.@link);
            };
            _local_4.WEB_PLAYER_INFO_PATH = _arg_1.PHP.@infoPath;
            if (_arg_1.PHP.hasOwnProperty("@isShow"))
            {
                PlayerManager.isShowPHP = StringUtils.converBoolean(_arg_1.PHP.@isShow);
            };
            if (_arg_1.PHP.hasOwnProperty("@link"))
            {
                _local_4.PHP_IMAGE_LINK = StringUtils.converBoolean(_arg_1.PHP.@link);
            };
            PathInfo.MUSIC_LIST = String(_arg_1.MUSIC_LIST.@value).split(",");
            PathInfo.LANGUAGE = String(_arg_1.LANGUAGE.@value);
            var _local_7:XMLList = _arg_1.POLICY_FILES.file;
            for each (_local_8 in _local_7)
            {
                Security.loadPolicyFile(_local_8.@value);
            };
            if (_arg_1.GAME_BOXPIC.hasOwnProperty("@value"))
            {
                PathInfo.GAME_BOXPIC = _arg_1.GAME_BOXPIC.@value;
            };
            if (_arg_1.ISTOPDERIICT.hasOwnProperty("@value"))
            {
                PathInfo.ISTOPDERIICT = StringUtils.converBoolean(_arg_1.ISTOPDERIICT.@value);
            };
            _local_4.COMMUNITY_INVITE_PATH = _arg_1.COMMUNITY_INVITE_PATH.@value;
            _local_4.COMMUNITY_FRIEND_LIST_PATH = _arg_1.COMMUNITY_FRIEND_LIST_PATH.@value;
            _local_4.SNS_PATH = _arg_1.COMMUNITY_FRIEND_LIST_PATH.@snsPath;
            _local_4.MICROCOBOL_PATH = _arg_1.COMMUNITY_FRIEND_LIST_PATH.@microcobolPath;
            if (_arg_1.COMMUNITY_FRIEND_LIST_PATH.hasOwnProperty("@isexist"))
            {
                _local_4.COMMUNITY_EXIST = StringUtils.converBoolean(_arg_1.COMMUNITY_FRIEND_LIST_PATH.@isexist);
            };
            if (_arg_1.COMMUNITY_FRIEND_INVITED_SWITCH.hasOwnProperty("@value"))
            {
                _local_4.COMMUNITY_FRIEND_INVITED_SWITCH = StringUtils.converBoolean(_arg_1.COMMUNITY_FRIEND_INVITED_SWITCH.@value);
            };
            if (_arg_1.COMMUNITY_FRIEND_INVITED_SWITCH.hasOwnProperty("@invitedOnline"))
            {
                _local_4.COMMUNITY_FRIEND_INVITED_ONLINE_SWITCH = StringUtils.converBoolean(_arg_1.COMMUNITY_FRIEND_INVITED_SWITCH.@invitedOnline);
            };
            if (_arg_1.COMMUNITY_FRIEND_LIST_PATH.hasOwnProperty("@isexistBtnVisble"))
            {
                _local_4.IS_VISIBLE_EXISTBTN = StringUtils.converBoolean(_arg_1.COMMUNITY_FRIEND_LIST_PATH.@isexistBtnVisble);
            };
            _local_4.ALLOW_POPUP_FAVORITE = ((String(_arg_1.ALLOW_POPUP_FAVORITE.@value) == "true") ? true : false);
            if (_arg_1.FILL_JS_COMMAND.hasOwnProperty("@enable"))
            {
                _local_4.FILL_JS_COMMAND_ENABLE = StringUtils.converBoolean(_arg_1.FILL_JS_COMMAND.@enable);
            };
            if (_arg_1.FILL_JS_COMMAND.hasOwnProperty("@value"))
            {
                _local_4.FILL_JS_COMMAND_VALUE = _arg_1.FILL_JS_COMMAND.@value;
            };
            if (_arg_1.MINLEVELDUPLICATE.hasOwnProperty("@value"))
            {
                GameManager.MinLevelDuplicate = _arg_1.MINLEVELDUPLICATE.@value;
            };
            _local_4.FIGHTLIB_ENABLE = StringUtils.converBoolean(_arg_1.FIGHTLIB.@value);
            if (_arg_1.FEEDBACK)
            {
                if (_arg_1.FEEDBACK.hasOwnProperty("@enable"))
                {
                    _local_4.FEEDBACK_ENABLE = ((String(_arg_1.FEEDBACK.@enable) == "true") ? true : false);
                    _local_4.FEEDBACK_TEL_NUMBER = _arg_1.FEEDBACK.@telNumber;
                };
            };
            if ((((!(_arg_1.MODULE == null)) && (!(_arg_1.MODULE.SPA == null))) && (_arg_1.MODULE.SPA.hasOwnProperty("@enable"))))
            {
                _local_4.SPA_ENABLE = (!(_arg_1.MODULE.SPA.@enable == "false"));
            };
            if ((((!(_arg_1.MODULE == null)) && (!(_arg_1.MODULE.CIVIL == null))) && (_arg_1.MODULE.CIVIL.hasOwnProperty("@enable"))))
            {
                _local_4.CIVIL_ENABLE = (!(_arg_1.MODULE.CIVIL.@enable == "false"));
            };
            if ((((!(_arg_1.MODULE == null)) && (!(_arg_1.MODULE.CHURCH == null))) && (_arg_1.MODULE.CHURCH.hasOwnProperty("@enable"))))
            {
                _local_4.CHURCH_ENABLE = (!(_arg_1.MODULE.CHURCH.@enable == "false"));
            };
            if ((((!(_arg_1.MODULE == null)) && (!(_arg_1.MODULE.WEEKLY == null))) && (_arg_1.MODULE.WEEKLY.hasOwnProperty("@enable"))))
            {
                _local_4.WEEKLY_ENABLE = (!(_arg_1.MODULE.WEEKLY.@enable == "false"));
            };
            if (_arg_1.FORTH_ENABLE.hasOwnProperty("@value"))
            {
                _local_4.FORTH_ENABLE = (!(_arg_1.FORTH_ENABLE.@value == "false"));
            };
            if (_arg_1.STHRENTH_MAX.hasOwnProperty("@value"))
            {
                _local_4.STHRENTH_MAX = int(_arg_1.STHRENTH_MAX.@value);
            };
            if (_arg_1.USER_GUILD_ENABLE.hasOwnProperty("@value"))
            {
                _local_4.USER_GUILD_ENABLE = StringUtils.converBoolean(_arg_1.USER_GUILD_ENABLE.@value);
            };
            if (_arg_1.ACHIEVE_ENABLE.hasOwnProperty("@value"))
            {
                _local_4.ACHIEVE_ENABLE = (!(_arg_1.ACHIEVE_ENABLE.@value == "false"));
            };
            if ((((!(_arg_1.CHAT_FACE == null)) && (!(_arg_1.CHAT_FACE.DISABLED_LIST == null))) && (_arg_1.CHAT_FACE.DISABLED_LIST.hasOwnProperty("@list"))))
            {
                _local_4.CHAT_FACE_DISABLED_LIST = String(_arg_1.CHAT_FACE.DISABLED_LIST.@list).split(",");
            };
            if (_arg_1.STATISTICS.hasOwnProperty("@enable"))
            {
                _local_4.STATISTICS = (!(_arg_1.STATISTICS.@enable == "false"));
            };
            if (((_arg_1.USER_GUIDE.hasOwnProperty("@value")) || (true)))
            {
            };
            if ((((!(_arg_1.GAME_FRAME_CONFIG == null)) && (!(_arg_1.GAME_FRAME_CONFIG.FRAME_TIME_OVER_TAG == null))) && (_arg_1.GAME_FRAME_CONFIG.FRAME_TIME_OVER_TAG.hasOwnProperty("@value"))))
            {
                _local_4.FRAME_TIME_OVER_TAG = int(_arg_1.GAME_FRAME_CONFIG.FRAME_TIME_OVER_TAG.@value);
            };
            if ((((!(_arg_1.GAME_FRAME_CONFIG == null)) && (!(_arg_1.GAME_FRAME_CONFIG.FRAME_OVER_COUNT_TAG == null))) && (_arg_1.GAME_FRAME_CONFIG.FRAME_OVER_COUNT_TAG.hasOwnProperty("@value"))))
            {
                _local_4.FRAME_OVER_COUNT_TAG = int(_arg_1.GAME_FRAME_CONFIG.FRAME_OVER_COUNT_TAG.@value);
            };
            if (((!(_arg_1.EXTERNAL_INTERFACE_360 == null)) && (_arg_1.EXTERNAL_INTERFACE_360.hasOwnProperty("@value"))))
            {
                _local_4.EXTERNAL_INTERFACE_PATH_360 = String(_arg_1.EXTERNAL_INTERFACE_360.@value);
            };
            if (((!(_arg_1.EXTERNAL_INTERFACE_360 == null)) && (_arg_1.EXTERNAL_INTERFACE_360.hasOwnProperty("@enable"))))
            {
                _local_4.EXTERNAL_INTERFACE_ENABLE_360 = (!(_arg_1.EXTERNAL_INTERFACE_360.@enable == "false"));
            };
            if (((!(_arg_1.GRADE_NOTIFICATION == null)) && (!(_arg_1.GRADE_NOTIFICATION.NOTIFICATION == null))))
            {
                _local_9 = _arg_1.GRADE_NOTIFICATION.NOTIFICATION;
                for each (_local_10 in _local_9)
                {
                    if (!((!(_local_10.hasOwnProperty("@grade"))) || (!(_local_10.hasOwnProperty("@site")))))
                    {
                        _local_11 = _local_10.@grade;
                        _local_12 = _local_10.@site;
                        if (!((_local_11 == "") || (_local_12 == "")))
                        {
                            _local_4.GRADE_NOTIFICATION[_local_11] = _local_12;
                        };
                    };
                };
            };
            if (((!(_arg_1.CALL_PATH == null)) && (_arg_1.CALL_PATH.hasOwnProperty("@value"))))
            {
                _local_4.CALL_LOGIN_INTERFAECE = _arg_1.CALL_PATH.@value;
            };
            if (((!(_arg_1.USER_ACTION_NOTICE == null)) && (_arg_1.USER_ACTION_NOTICE.hasOwnProperty("@value"))))
            {
                _local_4.USER_ACTION_NOTICE = _arg_1.USER_ACTION_NOTICE.@value;
            };
            if (((!(_arg_1.SHOW_FAVORITE == null)) && (_arg_1.SHOW_FAVORITE.hasOwnProperty("@value"))))
            {
                _local_4.SHOW_FAVORITE = (_arg_1.SHOW_FAVORITE.@value == "true");
            };
            if (((!(_arg_1.ISDEBUG == null)) && (_arg_1.ISDEBUG.hasOwnProperty("@value"))))
            {
                _local_4.ISDEBUG = (_arg_1.ISDEBUG.@value == "true");
            };
            PathManager.setup(_local_4);
        }


    }
}//package ddt.data

