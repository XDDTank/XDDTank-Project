package ddt.view.chat
{
   import ddt.data.EquipType;
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.data.goods.QualityType;
   import ddt.manager.ChatManager;
   import ddt.manager.ItemManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MapManager;
   import ddt.manager.PlayerManager;
   import ddt.utils.Helpers;
   import flash.text.StyleSheet;
   import flash.text.TextFormat;
   import flash.utils.Dictionary;
   import road7th.utils.StringHelper;
   import tofflist.TofflistModel;
   import tofflist.data.TofflistPlayerInfo;
   
   public class ChatFormats
   {
      
      public static const CHAT_COLORS:Array = [2358015,16751360,16740090,4970320,8423901,16777215,16776960,16776960,16776960,16777215,5035345,16724787,16777011,16777215,16711846,2358015,16777215,16777215,16777215,16777215,16777215,16777215,16748933,16711890,16751616,1297152,15925406,16777215,16777215,16777215,16776960];
      
      public static const BIG_BUGGLE_COLOR:Array = [11408476,16635586,15987916,16514727,12053748];
      
      public static const BIG_BUGGLE_TYPE_STRING:Array = ["初恋情怀","生日祝福","非诚勿扰","爆弹狂人","睥睨众生"];
      
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
         0:LanguageMgr.GetTranslation("tank.view.chat.ChannelListSelectView.big"),
         1:LanguageMgr.GetTranslation("tank.view.chat.ChannelListSelectView.small"),
         2:LanguageMgr.GetTranslation("tank.view.chat.ChannelListSelectView.private"),
         3:LanguageMgr.GetTranslation("tank.view.chat.ChannelListSelectView.consortia"),
         4:LanguageMgr.GetTranslation("tank.view.chat.ChannelListSelectView.ream"),
         5:LanguageMgr.GetTranslation("tank.view.chat.ChannelListSelectView.current"),
         9:LanguageMgr.GetTranslation("tank.view.chat.ChannelListSelectView.current"),
         12:LanguageMgr.GetTranslation("tank.view.chat.ChannelListSelectView.cross"),
         13:LanguageMgr.GetTranslation("tank.view.chat.ChannelListSelectView.current"),
         15:LanguageMgr.GetTranslation("tank.view.chat.ChannelListSelectView.big"),
         20:LanguageMgr.GetTranslation("tank.view.chat.ChannelListSelectView.current"),
         21:LanguageMgr.GetTranslation("tank.view.chat.ChannelListSelectView.current"),
         22:LanguageMgr.GetTranslation("tank.view.chat.ChannelListSelectView.invent")
      };
      
      public static const PREFIX_COLOR:Array = [16711890,16751616,1297152];
      
      public static const PREFIX_FILTER:Array = ["chat.prefix.filter1","chat.prefix.filter1","chat.prefix.filter1"];
      
      public static const PREFIX_NAME:Array = [LanguageMgr.GetTranslation("tank.view.chatFormat.prefix.name1"),LanguageMgr.GetTranslation("tank.view.chatFormat.prefix.name2"),LanguageMgr.GetTranslation("tank.view.chatFormat.prefix.name3")];
      
      public static var hasYaHei:Boolean;
      
      private static var _formats:Dictionary;
      
      private static var _styleSheet:StyleSheet;
      
      private static var _gameStyleSheet:StyleSheet;
      
      private static var _styleSheetData:Dictionary;
      
      private static var _chatData:ChatData;
      
      private static const unacceptableChar:Array = ["\"","\'","<",">"];
      
      private static const IN_GAME:uint = 1;
      
      private static const NORMAL:uint = 0;
       
      
      public function ChatFormats()
      {
         super();
      }
      
      public static function formatChatStyle(param1:ChatData) : void
      {
         if(param1.htmlMessage != "")
         {
            return;
         }
         param1.msg = StringHelper.rePlaceHtmlTextField(param1.msg);
         var _loc2_:Array = getTagsByChannel(param1.channel);
         var _loc3_:String = creatChannelTag(param1.channel,param1.bigBuggleType,param1);
         var _loc4_:String = creatSenderTag(param1);
         var _loc5_:String = creatContentTag(param1);
         param1.htmlMessage = _loc2_[0] + _loc3_ + _loc4_ + _loc5_ + _loc2_[1] + "<BR>";
      }
      
      public static function creatBracketsTag(param1:String, param2:int, param3:Array = null, param4:ChatData = null) : String
      {
         var _loc9_:String = null;
         var _loc5_:RegExp = /\[([^\]]*)]*/g;
         var _loc6_:Array = param1.match(_loc5_);
         var _loc7_:String = "";
         if(param3)
         {
            _loc7_ = param3.join("|");
         }
         var _loc8_:int = 0;
         while(_loc8_ < _loc6_.length)
         {
            _loc9_ = _loc6_[_loc8_].substr(1,_loc6_[_loc8_].length - 2);
            _loc9_ = StringHelper.trimTagname(_loc9_);
            if(param2 != CLICK_USERNAME || _loc9_ != PlayerManager.Instance.Self.NickName)
            {
               if(param4)
               {
                  _loc7_ = "channel:" + param4.channel;
                  ChatManager.Instance.reportMsg = param4.msg;
               }
               if(param4 && param4.channel == ChatInputView.CROSS_NOTICE)
               {
                  param1 = param1.replace("[" + _loc9_ + "]","<a href=\"event:" + "clicktype:" + param2.toString() + "|tagname:" + _loc9_ + "|zoneID:" + String(param4.zoneID) + "|" + _loc7_ + "\">" + Helpers.enCodeString("[" + _loc9_ + "]") + "</a>");
               }
               else if(_loc9_ == Channel_Set[12])
               {
                  param1 = "";
               }
               else
               {
                  param1 = param1.replace("[" + _loc9_ + "]","<a href=\"event:" + "clicktype:" + param2.toString() + "|tagname:" + _loc9_ + "|" + _loc7_ + "\">" + Helpers.enCodeString("[" + _loc9_ + "]") + "</a>");
               }
            }
            else
            {
               param1 = param1.replace("[" + _loc9_ + "]",Helpers.enCodeString("[" + _loc9_ + "]"));
            }
            _loc8_++;
         }
         return param1;
      }
      
      public static function creatGoodTag(param1:String, param2:int, param3:int, param4:int, param5:Boolean, param6:ChatData = null, param7:String = "") : String
      {
         var _loc9_:Array = null;
         var _loc14_:String = null;
         var _loc8_:ItemTemplateInfo = ItemManager.Instance.getTemplateById(param3);
         if(param2 == CLICK_BEAD_GOODS)
         {
            _loc9_ = getTagsByQuality(param4 + 13);
         }
         else if(_loc8_)
         {
            if(_loc8_.CategoryID != EquipType.EQUIP && _loc8_.CategoryID != EquipType.COMPOSE_SKILL)
            {
               _loc9_ = getTagsByQuality(param4 + 6);
            }
            else
            {
               _loc9_ = getTagsByQuality(param4);
            }
         }
         else
         {
            _loc9_ = getTagsByQuality(param4);
         }
         var _loc10_:RegExp = /\[([^\]]*)]*/g;
         var _loc11_:Array = param1.match(_loc10_);
         var _loc12_:int = param6.zoneID;
         var _loc13_:int = 0;
         while(_loc13_ < _loc11_.length)
         {
            _loc14_ = _loc11_[_loc13_].substr(1,_loc11_[_loc13_].length - 2);
            param1 = param1.replace("[" + _loc14_ + "]",_loc9_[0] + "<a href=\"event:" + "clicktype:" + param2.toString() + "|tagname:" + _loc14_ + "|isBind:" + param5.toString() + "|templeteIDorItemID:" + param3.toString() + "|key:" + param7 + "|zoneID:" + _loc12_ + "\">" + Helpers.enCodeString("[" + _loc14_ + "]") + "</a>" + _loc9_[1]);
            _loc13_++;
         }
         return param1;
      }
      
      public static function createDungeonTag(param1:String, param2:int, param3:int, param4:int, param5:String, param6:ChatData) : String
      {
         var _loc7_:int = param6.zoneID;
         return "<a href=\"event:" + "clicktype:" + param2.toString() + "|tagname:t" + "|roomID:" + param3.toString() + "|levelLimit:" + param4.toString() + "|roompass:" + param5.toString() + "|zoneID:" + _loc7_ + "\">" + Helpers.enCodeString(param1) + "</a>";
      }
      
      public static function createActivityTag(param1:String, param2:int, param3:String, param4:ChatData) : String
      {
         return "<a href=\"event:" + "clicktype:" + param2.toString() + "|tagname:t" + "|activityID:" + param3 + "\">" + Helpers.enCodeString(param1) + "</a>";
      }
      
      public static function getColorByChannel(param1:int) : int
      {
         return CHAT_COLORS[param1];
      }
      
      public static function getColorByBigBuggleType(param1:int) : int
      {
         return BIG_BUGGLE_COLOR[param1];
      }
      
      public static function getTagsByChannel(param1:int) : Array
      {
         return ["<CT" + param1.toString() + ">","</CT" + param1.toString() + ">"];
      }
      
      public static function getTagsByQuality(param1:int) : Array
      {
         return ["<QT" + param1.toString() + ">","</QT" + param1.toString() + ">"];
      }
      
      public static function getTextFormatByChannel(param1:int) : TextFormat
      {
         return _formats[param1];
      }
      
      public static function setup() : void
      {
         setupFormat();
         setupStyle();
      }
      
      public static function get styleSheet() : StyleSheet
      {
         return _styleSheet;
      }
      
      public static function get gameStyleSheet() : StyleSheet
      {
         return _gameStyleSheet;
      }
      
      public static function get beadStyleSheet() : StyleSheet
      {
         return _styleSheet;
      }
      
      private static function getBigBuggleTypeString(param1:int) : String
      {
         return BIG_BUGGLE_TYPE_STRING[param1 - 1];
      }
      
      private static function creatChannelTag(param1:int, param2:int = 0, param3:ChatData = null) : String
      {
         var _loc4_:String = "";
         if(Channel_Set[param1] && param1 != ChatInputView.PRIVATE)
         {
            if(param2 == 0)
            {
               if(param1 != 15)
               {
                  _loc4_ = creatBracketsTag("[" + Channel_Set[param1] + "]",CLICK_CHANNEL,["channel:" + param1.toString()]);
               }
               else if(param1 == 5)
               {
                  _loc4_ = "[" + Channel_Set[22] + "]";
               }
               else
               {
                  _loc4_ = creatBracketsTag("[" + Channel_Set[param1] + "]" + "&lt;" + param3.zoneName + "&gt;",CLICK_CHANNEL,["channel:" + param1.toString()]);
               }
            }
            else
            {
               _loc4_ = "[" + getBigBuggleTypeString(param2) + Channel_Set[param1] + "]";
            }
         }
         return _loc4_;
      }
      
      private static function creatContentTag(param1:ChatData) : String
      {
         var _loc4_:Object = null;
         var _loc5_:Number = NaN;
         var _loc6_:int = 0;
         var _loc7_:ItemTemplateInfo = null;
         var _loc8_:String = null;
         var _loc9_:uint = 0;
         var _loc10_:String = null;
         var _loc11_:String = null;
         var _loc12_:String = null;
         var _loc2_:String = param1.msg;
         var _loc3_:uint = 0;
         if(param1.link)
         {
            param1.link.sortOn("index");
            for each(_loc4_ in param1.link)
            {
               _loc5_ = _loc4_.ItemID;
               _loc6_ = _loc4_.TemplateID;
               _loc7_ = ItemManager.Instance.getTemplateById(_loc6_);
               _loc8_ = _loc4_.key;
               _loc9_ = _loc4_.index + _loc3_;
               if(_loc5_ <= 0)
               {
                  if(_loc7_.CategoryID == EquipType.BEAD && _loc7_.Property1 == "31")
                  {
                     _loc10_ = creatGoodTag("[" + _loc7_.Name + "]",CLICK_BEAD_GOODS,_loc7_.TemplateID,int(_loc7_.Property2),true,param1,_loc8_);
                  }
                  else if(_loc7_.CategoryID == 11 && _loc7_.Property1 == "6" || _loc6_ == EquipType.VIP_WEAPON_0 || _loc6_ == EquipType.VIP_WEAPON_1 || _loc6_ == EquipType.VIP_WEAPON_2)
                  {
                     _loc10_ = creatGoodTag("[" + _loc7_.Name + "]",CLICK_GOODS,_loc6_,_loc7_.Quality,true,param1,_loc8_);
                  }
                  else
                  {
                     _loc10_ = creatGoodTag("[" + _loc7_.Name + "]",CLICK_GOODS,_loc7_.TemplateID,_loc7_.Quality,true,param1);
                  }
               }
               else if(_loc7_.CategoryID == EquipType.BEAD && _loc7_.Property1 == "31")
               {
                  _loc10_ = creatGoodTag("[" + _loc7_.Name + "]",CLICK_BEAD_GOODS,_loc5_,int(_loc7_.Property2),true,param1,_loc8_);
               }
               else if(_loc7_.CategoryID == 11 && _loc7_.Property1 == "6" || _loc6_ == EquipType.VIP_WEAPON_0 || _loc6_ == EquipType.VIP_WEAPON_1 || _loc6_ == EquipType.VIP_WEAPON_2)
               {
                  _loc10_ = creatGoodTag("[" + _loc7_.Name + "]",CLICK_GOODS,_loc6_,_loc7_.Quality,true,param1,_loc8_);
               }
               else if(param1.type == 5 || param1.type == 18)
               {
                  _loc10_ = creatGoodTag("[" + _loc7_.Name + "]",CLICK_GOODS,_loc7_.TemplateID,_loc7_.Quality,true,param1);
               }
               else
               {
                  _loc10_ = creatGoodTag("[" + _loc7_.Name + "]",CLICK_INVENTORY_GOODS,_loc5_,_loc7_.Quality,true,param1,_loc8_);
               }
               _loc2_ = _loc2_.substring(0,_loc9_) + _loc10_ + _loc2_.substring(_loc9_);
               _loc3_ += _loc10_.length;
            }
         }
         if(param1.type == CLICK_EFFORT)
         {
            return creatBracketsTag(_loc2_,CLICK_EFFORT,null,param1);
         }
         if(param1.channel <= 5)
         {
            if(param1.type == CLICK_USERNAME || param1.type == CLICK_DIFF_ZONE)
            {
               return creatBracketsTag(_loc2_,CLICK_USERNAME,null,param1);
            }
            return _loc2_;
         }
         if(param1.channel == 22)
         {
            _loc11_ = createDungeonTag("<CT26>[" + MapManager.getMapName(param1.anyThing.dungeonID) + "·" + MapManager.getRoomHardLevel(param1.anyThing.hardLevel) + "][" + LanguageMgr.GetTranslation("tank.view.common.InviteAlertPanel.pass") + param1.anyThing.barrierNum + "]</CT26>" + _loc2_.substring(param1.anyThing.infoIndex),CLICK_DUNGEON_INFO,param1.anyThing.roomID,param1.anyThing.levelLimit,param1.anyThing.roompass,param1);
            return _loc11_;
         }
         if(param1.channel == ChatInputView.ACTIVITY)
         {
            _loc12_ = createActivityTag("<CT26>" + LanguageMgr.GetTranslation("tank.calendar.activityNotice") + "</CT26>",CLICK_ACTIVITY,param1.anyThing as String,param1);
            return param1.msg + _loc12_;
         }
         return creatBracketsTag(_loc2_,CLICK_USERNAME,null,param1);
      }
      
      private static function creatSenderTag(param1:ChatData) : String
      {
         var _loc2_:String = "";
         if(param1.sender == "")
         {
            return _loc2_;
         }
         if(param1.channel == ChatInputView.PRIVATE)
         {
            if(param1.sender == PlayerManager.Instance.Self.NickName)
            {
               _loc2_ = creatBracketsTag(LanguageMgr.GetTranslation("tank.view.chatsystem.sendTo") + "[" + param1.receiver + "]: ",CLICK_USERNAME,null,param1);
            }
            else
            {
               _loc2_ = creatBracketsTag("[" + param1.sender + "]" + LanguageMgr.GetTranslation("tank.view.chatsystem.privateSayToYou"),CLICK_USERNAME,null,param1);
               _loc2_ = creatPrefix(param1) + _loc2_;
            }
         }
         else
         {
            if(param1.zoneID == PlayerManager.Instance.Self.ZoneID || param1.zoneID <= 0)
            {
               _loc2_ = creatBracketsTag("[" + param1.sender + "]: ",CLICK_USERNAME,null,param1);
            }
            else
            {
               _loc2_ = creatBracketsTag("[" + param1.sender + "]: ",CLICK_DIFF_ZONE,null,param1);
            }
            if(param1.channel != ChatInputView.CROSS_BUGLE)
            {
               _loc2_ = creatPrefix(param1) + _loc2_;
            }
         }
         return _loc2_;
      }
      
      private static function creatPrefix(param1:ChatData) : String
      {
         return creatArenaPrefix(param1);
      }
      
      private static function creatArenaPrefix(param1:ChatData) : String
      {
         var _loc3_:TofflistPlayerInfo = null;
         var _loc5_:String = null;
         var _loc2_:Array = TofflistModel.Instance.arenaLocalScoreWeek.list;
         var _loc4_:int = 0;
         var _loc6_:int = 0;
         while(_loc6_ < _loc2_.length)
         {
            if(_loc6_ >= 10)
            {
               break;
            }
            _loc3_ = _loc2_[_loc6_];
            if(_loc3_.ID == param1.senderID && _loc3_.AddWeekMatchScore != 0)
            {
               _loc4_ = _loc6_ + 1;
               break;
            }
            _loc6_++;
         }
         switch(_loc4_)
         {
            case 0:
               _loc5_ = "";
               break;
            case 1:
               _loc5_ = "<CT23>" + PREFIX_NAME[0] + "</CT23>";
               break;
            case 2:
               _loc5_ = "<CT24>" + PREFIX_NAME[1] + "</CT24>";
               break;
            default:
               _loc5_ = "<CT25>" + PREFIX_NAME[2] + "</CT25>";
         }
         return _loc5_;
      }
      
      public static function replaceUnacceptableChar(param1:String) : String
      {
         var _loc2_:int = 0;
         while(_loc2_ < unacceptableChar.length)
         {
            param1 = param1.replace(unacceptableChar[_loc2_],"");
            _loc2_++;
         }
         return param1;
      }
      
      private static function creatStyleObject(param1:int, param2:uint = 0) : Object
      {
         var _loc3_:Object = null;
         var _loc4_:String = null;
         switch(param2)
         {
            case NORMAL:
               _loc4_ = "12";
               break;
            case IN_GAME:
               _loc4_ = "11";
         }
         return {
            "color":"#" + param1.toString(16),
            "leading":"8",
            "fontFamily":"Tahoma",
            "display":"inline",
            "fontSize":_loc4_
         };
      }
      
      private static function setupFormat() : void
      {
         var _loc2_:TextFormat = null;
         _formats = new Dictionary();
         var _loc1_:int = 0;
         while(_loc1_ < CHAT_COLORS.length)
         {
            _loc2_ = new TextFormat();
            _loc2_.font = "Tahoma";
            _loc2_.size = 12;
            _loc2_.color = CHAT_COLORS[_loc1_];
            _formats[_loc1_] = _loc2_;
            _loc1_++;
         }
      }
      
      private static function setupStyle() : void
      {
         var _loc3_:Object = null;
         var _loc4_:Object = null;
         var _loc5_:Object = null;
         var _loc6_:Object = null;
         _styleSheetData = new Dictionary();
         _styleSheet = new StyleSheet();
         _gameStyleSheet = new StyleSheet();
         var _loc1_:int = 0;
         while(_loc1_ < QualityType.EQUIP_QUALITY_COLOR.length)
         {
            _loc3_ = creatStyleObject(QualityType.EQUIP_QUALITY_COLOR[_loc1_]);
            _loc4_ = creatStyleObject(QualityType.EQUIP_QUALITY_COLOR[_loc1_],1);
            _styleSheetData["QT" + _loc1_] = _loc3_;
            _styleSheet.setStyle("QT" + _loc1_,_loc3_);
            _gameStyleSheet.setStyle("QT" + _loc1_,_loc4_);
            _loc1_++;
         }
         var _loc2_:int = 0;
         while(_loc2_ <= CHAT_COLORS.length)
         {
            _loc5_ = creatStyleObject(CHAT_COLORS[_loc2_]);
            _loc6_ = creatStyleObject(CHAT_COLORS[_loc2_],1);
            _styleSheetData["CT" + String(_loc2_)] = _loc5_;
            _styleSheet.setStyle("CT" + String(_loc2_),_loc5_);
            _gameStyleSheet.setStyle("CT" + String(_loc2_),_loc6_);
            _loc2_++;
         }
      }
   }
}
