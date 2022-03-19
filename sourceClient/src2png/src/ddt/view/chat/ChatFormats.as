// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//ddt.view.chat.ChatFormats

package ddt.view.chat
{
    import ddt.manager.LanguageMgr;
    import flash.utils.Dictionary;
    import flash.text.StyleSheet;
    import road7th.utils.StringHelper;
    import ddt.manager.PlayerManager;
    import ddt.manager.ChatManager;
    import ddt.utils.Helpers;
    import ddt.manager.ItemManager;
    import ddt.data.goods.ItemTemplateInfo;
    import ddt.data.EquipType;
    import flash.text.TextFormat;
    import ddt.manager.MapManager;
    import tofflist.data.TofflistPlayerInfo;
    import tofflist.TofflistModel;
    import ddt.data.goods.QualityType;

    public class ChatFormats 
    {

        public static const CHAT_COLORS:Array = [2358015, 0xFF9B00, 16740090, 4970320, 8423901, 0xFFFFFF, 0xFFFF00, 0xFFFF00, 0xFFFF00, 0xFFFFFF, 5035345, 16724787, 16777011, 0xFFFFFF, 0xFF00A6, 2358015, 0xFFFFFF, 0xFFFFFF, 0xFFFFFF, 0xFFFFFF, 0xFFFFFF, 0xFFFFFF, 16748933, 0xFF00D2, 0xFF9C00, 0x13CB00, 0xF3009E, 0xFFFFFF, 0xFFFFFF, 0xFFFFFF, 0xFFFF00];
        public static const BIG_BUGGLE_COLOR:Array = [11408476, 16635586, 15987916, 16514727, 12053748];
        public static const BIG_BUGGLE_TYPE_STRING:Array = ["初恋情怀", "生日祝福", "非诚勿扰", "爆弹狂人", "睥睨众生"];
        public static const CLICK_CHANNEL:int = 0;
        public static const CLICK_GOODS:int = 2;
        public static const CLICK_USERNAME:int = 1;
        public static const CLICK_DIFF_ZONE:int = 4;
        public static const CLICK_INVENTORY_GOODS:int = 3;
        public static const CLICK_BEAD_GOODS:int = 7;
        public static const CLICK_EFFORT:int = 100;
        public static const EQUIP:int = 5;
        public static const CLICK_CARD_INFO:int = 6;
        public static const CLICK_DUNGEON_INFO:int = 8;
        public static const CLICK_ACTIVITY:int = 30;
        public static const Channel_Set:Object = {
            "0":LanguageMgr.GetTranslation("tank.view.chat.ChannelListSelectView.big"),
            "1":LanguageMgr.GetTranslation("tank.view.chat.ChannelListSelectView.small"),
            "2":LanguageMgr.GetTranslation("tank.view.chat.ChannelListSelectView.private"),
            "3":LanguageMgr.GetTranslation("tank.view.chat.ChannelListSelectView.consortia"),
            "4":LanguageMgr.GetTranslation("tank.view.chat.ChannelListSelectView.ream"),
            "5":LanguageMgr.GetTranslation("tank.view.chat.ChannelListSelectView.current"),
            "9":LanguageMgr.GetTranslation("tank.view.chat.ChannelListSelectView.current"),
            "12":LanguageMgr.GetTranslation("tank.view.chat.ChannelListSelectView.cross"),
            "13":LanguageMgr.GetTranslation("tank.view.chat.ChannelListSelectView.current"),
            "15":LanguageMgr.GetTranslation("tank.view.chat.ChannelListSelectView.big"),
            "20":LanguageMgr.GetTranslation("tank.view.chat.ChannelListSelectView.current"),
            "21":LanguageMgr.GetTranslation("tank.view.chat.ChannelListSelectView.current"),
            "22":LanguageMgr.GetTranslation("tank.view.chat.ChannelListSelectView.invent")
        };
        public static const PREFIX_COLOR:Array = [0xFF00D2, 0xFF9C00, 0x13CB00];
        public static const PREFIX_FILTER:Array = ["chat.prefix.filter1", "chat.prefix.filter1", "chat.prefix.filter1"];
        public static const PREFIX_NAME:Array = [LanguageMgr.GetTranslation("tank.view.chatFormat.prefix.name1"), LanguageMgr.GetTranslation("tank.view.chatFormat.prefix.name2"), LanguageMgr.GetTranslation("tank.view.chatFormat.prefix.name3")];
        public static var hasYaHei:Boolean;
        private static var _formats:Dictionary;
        private static var _styleSheet:StyleSheet;
        private static var _gameStyleSheet:StyleSheet;
        private static var _styleSheetData:Dictionary;
        private static var _chatData:ChatData;
        private static const unacceptableChar:Array = ['"', "'", "<", ">"];
        private static const IN_GAME:uint = 1;
        private static const NORMAL:uint = 0;


        public static function formatChatStyle(_arg_1:ChatData):void
        {
            if (_arg_1.htmlMessage != "")
            {
                return;
            };
            _arg_1.msg = StringHelper.rePlaceHtmlTextField(_arg_1.msg);
            var _local_2:Array = getTagsByChannel(_arg_1.channel);
            var _local_3:String = creatChannelTag(_arg_1.channel, _arg_1.bigBuggleType, _arg_1);
            var _local_4:String = creatSenderTag(_arg_1);
            var _local_5:String = creatContentTag(_arg_1);
            _arg_1.htmlMessage = (((((_local_2[0] + _local_3) + _local_4) + _local_5) + _local_2[1]) + "<BR>");
        }

        public static function creatBracketsTag(_arg_1:String, _arg_2:int, _arg_3:Array=null, _arg_4:ChatData=null):String
        {
            var _local_9:String;
            var _local_5:RegExp = /\[([^\]]*)]*/g;
            var _local_6:Array = _arg_1.match(_local_5);
            var _local_7:String = "";
            if (_arg_3)
            {
                _local_7 = _arg_3.join("|");
            };
            var _local_8:int;
            for (;_local_8 < _local_6.length;_local_8++)
            {
                _local_9 = _local_6[_local_8].substr(1, (_local_6[_local_8].length - 2));
                _local_9 = StringHelper.trimTagname(_local_9);
                if (((!(_arg_2 == CLICK_USERNAME)) || (!(_local_9 == PlayerManager.Instance.Self.NickName))))
                {
                    if (_arg_4)
                    {
                        _local_7 = ("channel:" + _arg_4.channel);
                        ChatManager.Instance.reportMsg = _arg_4.msg;
                    };
                    if (((_arg_4) && (_arg_4.channel == ChatInputView.CROSS_NOTICE)))
                    {
                        _arg_1 = _arg_1.replace((("[" + _local_9) + "]"), ((((((((((('<a href="event:' + "clicktype:") + _arg_2.toString()) + "|tagname:") + _local_9) + "|zoneID:") + String(_arg_4.zoneID)) + "|") + _local_7) + '">') + Helpers.enCodeString((("[" + _local_9) + "]"))) + "</a>"));
                        continue;
                    };
                    if (_local_9 == Channel_Set[12])
                    {
                        _arg_1 = "";
                    }
                    else
                    {
                        _arg_1 = _arg_1.replace((("[" + _local_9) + "]"), ((((((((('<a href="event:' + "clicktype:") + _arg_2.toString()) + "|tagname:") + _local_9) + "|") + _local_7) + '">') + Helpers.enCodeString((("[" + _local_9) + "]"))) + "</a>"));
                    };
                }
                else
                {
                    _arg_1 = _arg_1.replace((("[" + _local_9) + "]"), Helpers.enCodeString((("[" + _local_9) + "]")));
                };
            };
            return (_arg_1);
        }

        public static function creatGoodTag(_arg_1:String, _arg_2:int, _arg_3:int, _arg_4:int, _arg_5:Boolean, _arg_6:ChatData=null, _arg_7:String=""):String
        {
            var _local_9:Array;
            var _local_14:String;
            var _local_8:ItemTemplateInfo = ItemManager.Instance.getTemplateById(_arg_3);
            if (_arg_2 == CLICK_BEAD_GOODS)
            {
                _local_9 = getTagsByQuality((_arg_4 + 13));
            }
            else
            {
                if (_local_8)
                {
                    if (((!(_local_8.CategoryID == EquipType.EQUIP)) && (!(_local_8.CategoryID == EquipType.COMPOSE_SKILL))))
                    {
                        _local_9 = getTagsByQuality((_arg_4 + 6));
                    }
                    else
                    {
                        _local_9 = getTagsByQuality(_arg_4);
                    };
                }
                else
                {
                    _local_9 = getTagsByQuality(_arg_4);
                };
            };
            var _local_10:RegExp = /\[([^\]]*)]*/g;
            var _local_11:Array = _arg_1.match(_local_10);
            var _local_12:int = _arg_6.zoneID;
            var _local_13:int;
            while (_local_13 < _local_11.length)
            {
                _local_14 = _local_11[_local_13].substr(1, (_local_11[_local_13].length - 2));
                _arg_1 = _arg_1.replace((("[" + _local_14) + "]"), (((((((((((((((((_local_9[0] + '<a href="event:') + "clicktype:") + _arg_2.toString()) + "|tagname:") + _local_14) + "|isBind:") + _arg_5.toString()) + "|templeteIDorItemID:") + _arg_3.toString()) + "|key:") + _arg_7) + "|zoneID:") + _local_12) + '">') + Helpers.enCodeString((("[" + _local_14) + "]"))) + "</a>") + _local_9[1]));
                _local_13++;
            };
            return (_arg_1);
        }

        public static function createDungeonTag(_arg_1:String, _arg_2:int, _arg_3:int, _arg_4:int, _arg_5:String, _arg_6:ChatData):String
        {
            var _local_7:int = _arg_6.zoneID;
            return (((((((((((((('<a href="event:' + "clicktype:") + _arg_2.toString()) + "|tagname:t") + "|roomID:") + _arg_3.toString()) + "|levelLimit:") + _arg_4.toString()) + "|roompass:") + _arg_5.toString()) + "|zoneID:") + _local_7) + '">') + Helpers.enCodeString(_arg_1)) + "</a>");
        }

        public static function createActivityTag(_arg_1:String, _arg_2:int, _arg_3:String, _arg_4:ChatData):String
        {
            return (((((((('<a href="event:' + "clicktype:") + _arg_2.toString()) + "|tagname:t") + "|activityID:") + _arg_3) + '">') + Helpers.enCodeString(_arg_1)) + "</a>");
        }

        public static function getColorByChannel(_arg_1:int):int
        {
            return (CHAT_COLORS[_arg_1]);
        }

        public static function getColorByBigBuggleType(_arg_1:int):int
        {
            return (BIG_BUGGLE_COLOR[_arg_1]);
        }

        public static function getTagsByChannel(_arg_1:int):Array
        {
            return ([(("<CT" + _arg_1.toString()) + ">"), (("</CT" + _arg_1.toString()) + ">")]);
        }

        public static function getTagsByQuality(_arg_1:int):Array
        {
            return ([(("<QT" + _arg_1.toString()) + ">"), (("</QT" + _arg_1.toString()) + ">")]);
        }

        public static function getTextFormatByChannel(_arg_1:int):TextFormat
        {
            return (_formats[_arg_1]);
        }

        public static function setup():void
        {
            setupFormat();
            setupStyle();
        }

        public static function get styleSheet():StyleSheet
        {
            return (_styleSheet);
        }

        public static function get gameStyleSheet():StyleSheet
        {
            return (_gameStyleSheet);
        }

        public static function get beadStyleSheet():StyleSheet
        {
            return (_styleSheet);
        }

        private static function getBigBuggleTypeString(_arg_1:int):String
        {
            return (BIG_BUGGLE_TYPE_STRING[(_arg_1 - 1)]);
        }

        private static function creatChannelTag(_arg_1:int, _arg_2:int=0, _arg_3:ChatData=null):String
        {
            var _local_4:String = "";
            if (((Channel_Set[_arg_1]) && (!(_arg_1 == ChatInputView.PRIVATE))))
            {
                if (_arg_2 == 0)
                {
                    if (_arg_1 != 15)
                    {
                        _local_4 = creatBracketsTag((("[" + Channel_Set[_arg_1]) + "]"), CLICK_CHANNEL, [("channel:" + _arg_1.toString())]);
                    }
                    else
                    {
                        if (_arg_1 == 5)
                        {
                            _local_4 = (("[" + Channel_Set[22]) + "]");
                        }
                        else
                        {
                            _local_4 = creatBracketsTag(((((("[" + Channel_Set[_arg_1]) + "]") + "&lt;") + _arg_3.zoneName) + "&gt;"), CLICK_CHANNEL, [("channel:" + _arg_1.toString())]);
                        };
                    };
                }
                else
                {
                    _local_4 = ((("[" + getBigBuggleTypeString(_arg_2)) + Channel_Set[_arg_1]) + "]");
                };
            };
            return (_local_4);
        }

        private static function creatContentTag(_arg_1:ChatData):String
        {
            var _local_4:Object;
            var _local_5:Number;
            var _local_6:int;
            var _local_7:ItemTemplateInfo;
            var _local_8:String;
            var _local_9:uint;
            var _local_10:String;
            var _local_11:String;
            var _local_12:String;
            var _local_2:String = _arg_1.msg;
            var _local_3:uint;
            if (_arg_1.link)
            {
                _arg_1.link.sortOn("index");
                for each (_local_4 in _arg_1.link)
                {
                    _local_5 = _local_4.ItemID;
                    _local_6 = _local_4.TemplateID;
                    _local_7 = ItemManager.Instance.getTemplateById(_local_6);
                    _local_8 = _local_4.key;
                    _local_9 = (_local_4.index + _local_3);
                    if (_local_5 <= 0)
                    {
                        if (((_local_7.CategoryID == EquipType.BEAD) && (_local_7.Property1 == "31")))
                        {
                            _local_10 = creatGoodTag((("[" + _local_7.Name) + "]"), CLICK_BEAD_GOODS, _local_7.TemplateID, int(_local_7.Property2), true, _arg_1, _local_8);
                        }
                        else
                        {
                            if ((((((_local_7.CategoryID == 11) && (_local_7.Property1 == "6")) || (_local_6 == EquipType.VIP_WEAPON_0)) || (_local_6 == EquipType.VIP_WEAPON_1)) || (_local_6 == EquipType.VIP_WEAPON_2)))
                            {
                                _local_10 = creatGoodTag((("[" + _local_7.Name) + "]"), CLICK_GOODS, _local_6, _local_7.Quality, true, _arg_1, _local_8);
                            }
                            else
                            {
                                _local_10 = creatGoodTag((("[" + _local_7.Name) + "]"), CLICK_GOODS, _local_7.TemplateID, _local_7.Quality, true, _arg_1);
                            };
                        };
                    }
                    else
                    {
                        if (((_local_7.CategoryID == EquipType.BEAD) && (_local_7.Property1 == "31")))
                        {
                            _local_10 = creatGoodTag((("[" + _local_7.Name) + "]"), CLICK_BEAD_GOODS, _local_5, int(_local_7.Property2), true, _arg_1, _local_8);
                        }
                        else
                        {
                            if ((((((_local_7.CategoryID == 11) && (_local_7.Property1 == "6")) || (_local_6 == EquipType.VIP_WEAPON_0)) || (_local_6 == EquipType.VIP_WEAPON_1)) || (_local_6 == EquipType.VIP_WEAPON_2)))
                            {
                                _local_10 = creatGoodTag((("[" + _local_7.Name) + "]"), CLICK_GOODS, _local_6, _local_7.Quality, true, _arg_1, _local_8);
                            }
                            else
                            {
                                if (((_arg_1.type == 5) || (_arg_1.type == 18)))
                                {
                                    _local_10 = creatGoodTag((("[" + _local_7.Name) + "]"), CLICK_GOODS, _local_7.TemplateID, _local_7.Quality, true, _arg_1);
                                }
                                else
                                {
                                    _local_10 = creatGoodTag((("[" + _local_7.Name) + "]"), CLICK_INVENTORY_GOODS, _local_5, _local_7.Quality, true, _arg_1, _local_8);
                                };
                            };
                        };
                    };
                    _local_2 = ((_local_2.substring(0, _local_9) + _local_10) + _local_2.substring(_local_9));
                    _local_3 = (_local_3 + _local_10.length);
                };
            };
            if (_arg_1.type == CLICK_EFFORT)
            {
                return (_local_2 = creatBracketsTag(_local_2, CLICK_EFFORT, null, _arg_1));
            };
            if (_arg_1.channel <= 5)
            {
                if (((_arg_1.type == CLICK_USERNAME) || (_arg_1.type == CLICK_DIFF_ZONE)))
                {
                    return (_local_2 = creatBracketsTag(_local_2, CLICK_USERNAME, null, _arg_1));
                };
            }
            else
            {
                if (_arg_1.channel == 22)
                {
                    _local_11 = createDungeonTag((((((((("<CT26>[" + MapManager.getMapName(_arg_1.anyThing.dungeonID)) + "·") + MapManager.getRoomHardLevel(_arg_1.anyThing.hardLevel)) + "][") + LanguageMgr.GetTranslation("tank.view.common.InviteAlertPanel.pass")) + _arg_1.anyThing.barrierNum) + "]</CT26>") + _local_2.substring(_arg_1.anyThing.infoIndex)), CLICK_DUNGEON_INFO, _arg_1.anyThing.roomID, _arg_1.anyThing.levelLimit, _arg_1.anyThing.roompass, _arg_1);
                    return (_local_2 = _local_11);
                };
                if (_arg_1.channel == ChatInputView.ACTIVITY)
                {
                    _local_12 = createActivityTag((("<CT26>" + LanguageMgr.GetTranslation("tank.calendar.activityNotice")) + "</CT26>"), CLICK_ACTIVITY, (_arg_1.anyThing as String), _arg_1);
                    return (_local_2 = (_arg_1.msg + _local_12));
                };
                return (_local_2 = creatBracketsTag(_local_2, CLICK_USERNAME, null, _arg_1));
            };
            return (_local_2);
        }

        private static function creatSenderTag(_arg_1:ChatData):String
        {
            var _local_2:String = "";
            if (_arg_1.sender == "")
            {
                return (_local_2);
            };
            if (_arg_1.channel == ChatInputView.PRIVATE)
            {
                if (_arg_1.sender == PlayerManager.Instance.Self.NickName)
                {
                    _local_2 = creatBracketsTag((((LanguageMgr.GetTranslation("tank.view.chatsystem.sendTo") + "[") + _arg_1.receiver) + "]: "), CLICK_USERNAME, null, _arg_1);
                }
                else
                {
                    _local_2 = creatBracketsTag(((("[" + _arg_1.sender) + "]") + LanguageMgr.GetTranslation("tank.view.chatsystem.privateSayToYou")), CLICK_USERNAME, null, _arg_1);
                    _local_2 = (creatPrefix(_arg_1) + _local_2);
                };
            }
            else
            {
                if (((_arg_1.zoneID == PlayerManager.Instance.Self.ZoneID) || (_arg_1.zoneID <= 0)))
                {
                    _local_2 = creatBracketsTag((("[" + _arg_1.sender) + "]: "), CLICK_USERNAME, null, _arg_1);
                }
                else
                {
                    _local_2 = creatBracketsTag((("[" + _arg_1.sender) + "]: "), CLICK_DIFF_ZONE, null, _arg_1);
                };
                if (_arg_1.channel != ChatInputView.CROSS_BUGLE)
                {
                    _local_2 = (creatPrefix(_arg_1) + _local_2);
                };
            };
            return (_local_2);
        }

        private static function creatPrefix(_arg_1:ChatData):String
        {
            return (creatArenaPrefix(_arg_1));
        }

        private static function creatArenaPrefix(_arg_1:ChatData):String
        {
            var _local_3:TofflistPlayerInfo;
            var _local_5:String;
            var _local_2:Array = TofflistModel.Instance.arenaLocalScoreWeek.list;
            var _local_4:int;
            var _local_6:int;
            while (_local_6 < _local_2.length)
            {
                if (_local_6 >= 10) break;
                _local_3 = _local_2[_local_6];
                if (((_local_3.ID == _arg_1.senderID) && (!(_local_3.AddWeekMatchScore == 0))))
                {
                    _local_4 = (_local_6 + 1);
                    break;
                };
                _local_6++;
            };
            switch (_local_4)
            {
                case 0:
                    _local_5 = "";
                    break;
                case 1:
                    _local_5 = (("<CT23>" + PREFIX_NAME[0]) + "</CT23>");
                    break;
                case 2:
                    _local_5 = (("<CT24>" + PREFIX_NAME[1]) + "</CT24>");
                    break;
                default:
                    _local_5 = (("<CT25>" + PREFIX_NAME[2]) + "</CT25>");
            };
            return (_local_5);
        }

        public static function replaceUnacceptableChar(_arg_1:String):String
        {
            var _local_2:int;
            while (_local_2 < unacceptableChar.length)
            {
                _arg_1 = _arg_1.replace(unacceptableChar[_local_2], "");
                _local_2++;
            };
            return (_arg_1);
        }

        private static function creatStyleObject(_arg_1:int, _arg_2:uint=0):Object
        {
            var _local_3:Object;
            var _local_4:String;
            switch (_arg_2)
            {
                case NORMAL:
                    _local_4 = "12";
                    break;
                case IN_GAME:
                    _local_4 = "11";
                    break;
            };
            return ({
                "color":("#" + _arg_1.toString(16)),
                "leading":"8",
                "fontFamily":"Tahoma",
                "display":"inline",
                "fontSize":_local_4
            });
        }

        private static function setupFormat():void
        {
            var _local_2:TextFormat;
            _formats = new Dictionary();
            var _local_1:int;
            while (_local_1 < CHAT_COLORS.length)
            {
                _local_2 = new TextFormat();
                _local_2.font = "Tahoma";
                _local_2.size = 12;
                _local_2.color = CHAT_COLORS[_local_1];
                _formats[_local_1] = _local_2;
                _local_1++;
            };
        }

        private static function setupStyle():void
        {
            var _local_3:Object;
            var _local_4:Object;
            var _local_5:Object;
            var _local_6:Object;
            _styleSheetData = new Dictionary();
            _styleSheet = new StyleSheet();
            _gameStyleSheet = new StyleSheet();
            var _local_1:int;
            while (_local_1 < QualityType.EQUIP_QUALITY_COLOR.length)
            {
                _local_3 = creatStyleObject(QualityType.EQUIP_QUALITY_COLOR[_local_1]);
                _local_4 = creatStyleObject(QualityType.EQUIP_QUALITY_COLOR[_local_1], 1);
                _styleSheetData[("QT" + _local_1)] = _local_3;
                _styleSheet.setStyle(("QT" + _local_1), _local_3);
                _gameStyleSheet.setStyle(("QT" + _local_1), _local_4);
                _local_1++;
            };
            var _local_2:int;
            while (_local_2 <= CHAT_COLORS.length)
            {
                _local_5 = creatStyleObject(CHAT_COLORS[_local_2]);
                _local_6 = creatStyleObject(CHAT_COLORS[_local_2], 1);
                _styleSheetData[("CT" + String(_local_2))] = _local_5;
                _styleSheet.setStyle(("CT" + String(_local_2)), _local_5);
                _gameStyleSheet.setStyle(("CT" + String(_local_2)), _local_6);
                _local_2++;
            };
        }


    }
}//package ddt.view.chat

