package tofflist.view
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.Image;
   import com.pickgliss.ui.image.ScaleFrameImage;
   import com.pickgliss.ui.image.ScaleLeftRightImage;
   import com.pickgliss.ui.text.GradientText;
   import com.pickgliss.utils.ObjectUtils;
   import consortion.view.selfConsortia.Badge;
   import ddt.data.ConsortiaInfo;
   import ddt.data.player.PlayerInfo;
   import ddt.events.PlayerPropertyEvent;
   import ddt.manager.PlayerManager;
   import ddt.manager.ServerConfigManager;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import ddt.view.common.LevelIcon;
   import flash.display.Bitmap;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.text.TextFormat;
   import militaryrank.MilitaryRankManager;
   import tofflist.TofflistEvent;
   import tofflist.TofflistModel;
   import tofflist.data.TofflistConsortiaData;
   import tofflist.data.TofflistConsortiaInfo;
   import tofflist.data.TofflistPlayerInfo;
   import vip.VipController;
   
   public class TofflistOrderItem extends Sprite implements Disposeable
   {
       
      
      private var _consortiaInfo:TofflistConsortiaInfo;
      
      private var _badge:Badge;
      
      private var _index:int;
      
      private var _info:TofflistPlayerInfo;
      
      private var _isSelect:Boolean;
      
      private var _bg:Image;
      
      private var _shine:ScaleLeftRightImage;
      
      private var _level:LevelIcon;
      
      private var _vipName:GradientText;
      
      private var _topThreeRink:ScaleFrameImage;
      
      private var _resourceArr:Array;
      
      private var _styleLinkArr:Array;
      
      private var hLines:Array;
      
      public function TofflistOrderItem()
      {
         super();
         this.init();
         this.addEvent();
      }
      
      public function get currentText() : String
      {
         return this._resourceArr[2].dis["text"];
      }
      
      public function dispose() : void
      {
         var _loc1_:Bitmap = null;
         var _loc2_:DisplayObject = null;
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         this.removeEvent();
         if(this.hLines)
         {
            for each(_loc1_ in this.hLines)
            {
               ObjectUtils.disposeObject(_loc1_);
            }
         }
         if(this._resourceArr)
         {
            _loc3_ = 0;
            _loc4_ = this._resourceArr.length;
            while(_loc3_ < _loc4_)
            {
               _loc2_ = this._resourceArr[_loc3_].dis;
               ObjectUtils.disposeObject(_loc2_);
               _loc2_ = null;
               this._resourceArr[_loc3_] = null;
               _loc3_++;
            }
            this._resourceArr = null;
         }
         this._styleLinkArr = null;
         this._badge.dispose();
         this._badge = null;
         this._bg.dispose();
         this._bg = null;
         ObjectUtils.disposeAllChildren(this);
         this._shine = null;
         if(this._topThreeRink)
         {
            this._topThreeRink.dispose();
         }
         this._topThreeRink = null;
         if(parent)
         {
            parent.removeChild(this);
         }
      }
      
      public function get index() : int
      {
         return this._index;
      }
      
      public function set index(param1:int) : void
      {
         this._index = param1;
         this._bg.setFrame(this._index % 2 + 1);
      }
      
      public function showHLine(param1:Vector.<Point>) : void
      {
         var _loc2_:Point = null;
         var _loc3_:Bitmap = null;
         if(this.hLines)
         {
            for each(_loc3_ in this.hLines)
            {
               ObjectUtils.disposeObject(_loc3_);
            }
         }
         this.hLines = [];
         for each(_loc2_ in param1)
         {
            _loc3_ = ComponentFactory.Instance.creatBitmap("asset.formTop.Line");
            this.hLines.push(_loc3_);
            PositionUtils.setPos(_loc3_,new Point(_loc2_.x - parent.parent.x,_loc2_.y));
         }
      }
      
      public function get info() : Object
      {
         return this._info;
      }
      
      public function set info(param1:Object) : void
      {
         var _loc2_:TofflistConsortiaData = null;
         if(param1 is PlayerInfo)
         {
            this._info = param1 as TofflistPlayerInfo;
         }
         else if(param1 is TofflistConsortiaData)
         {
            _loc2_ = param1 as TofflistConsortiaData;
            if(_loc2_)
            {
               this._info = _loc2_.playerInfo;
               this._consortiaInfo = _loc2_.consortiaInfo;
            }
         }
         if(this._info)
         {
            this.upView();
         }
      }
      
      public function set isSelect(param1:Boolean) : void
      {
         this._shine.visible = this._isSelect = param1;
         if(param1)
         {
            this.dispatchEvent(new TofflistEvent(TofflistEvent.TOFFLIST_ITEM_SELECT,this));
         }
      }
      
      public function set resourceLink(param1:String) : void
      {
         var _loc2_:DisplayObject = null;
         var _loc6_:Object = null;
         this._resourceArr = [];
         var _loc3_:Array = param1.replace(/(\s*)|(\s*$)/g,"").split("|");
         var _loc4_:uint = 0;
         var _loc5_:uint = _loc3_.length;
         while(_loc4_ < _loc5_)
         {
            _loc6_ = {};
            _loc6_.id = _loc3_[_loc4_].split("#")[0];
            _loc6_.className = _loc3_[_loc4_].split("#")[1];
            _loc2_ = ComponentFactory.Instance.creat(_loc6_.className);
            addChild(_loc2_);
            _loc6_.dis = _loc2_;
            this._resourceArr.push(_loc6_);
            _loc4_++;
         }
      }
      
      public function set setAllStyleXY(param1:String) : void
      {
         this._styleLinkArr = param1.replace(/(\s*)|(\s*$)/g,"").split("~");
         this.updateStyleXY();
      }
      
      public function updateStyleXY(param1:int = 0) : void
      {
         var _loc2_:DisplayObject = null;
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         var _loc6_:Array = null;
         var _loc7_:int = 0;
         var _loc8_:Point = null;
         var _loc5_:uint = this._resourceArr.length;
         _loc6_ = this._styleLinkArr[param1].split("|");
         _loc5_ = _loc6_.length;
         _loc3_ = 0;
         while(_loc3_ < _loc5_)
         {
            _loc2_ = null;
            _loc7_ = _loc6_[_loc3_].split("#")[0];
            _loc4_ = 0;
            while(_loc4_ < this._resourceArr.length)
            {
               if(_loc7_ == this._resourceArr[_loc4_].id)
               {
                  _loc2_ = this._resourceArr[_loc4_].dis;
                  break;
               }
               _loc4_++;
            }
            if(_loc2_)
            {
               _loc8_ = new Point();
               _loc8_.x = _loc6_[_loc3_].split("#")[1].split(",")[0];
               _loc8_.y = _loc6_[_loc3_].split("#")[1].split(",")[1];
               _loc2_.x = _loc8_.x;
               _loc2_.y = _loc8_.y;
               if(_loc6_[_loc3_].split("#")[1].split(",")[2])
               {
                  _loc2_.width = _loc6_[_loc3_].split("#")[1].split(",")[2];
               }
               if(_loc6_[_loc3_].split("#")[1].split(",")[3])
               {
                  _loc2_.height = _loc6_[_loc3_].split("#")[1].split(",")[3];
               }
               _loc2_["text"] = _loc2_["text"];
               _loc2_.visible = true;
            }
            _loc3_++;
         }
         if(this._index < 4)
         {
            this._topThreeRink.x = this._resourceArr[0].dis.x - 9;
            this._topThreeRink.y = this._resourceArr[0].dis.y - 2;
            this._topThreeRink.visible = true;
            this._topThreeRink.setFrame(this._index);
            this._resourceArr[0].dis.visible = false;
         }
      }
      
      private function get NO_ID() : String
      {
         var _loc1_:String = "";
         switch(this._index)
         {
            case 1:
               _loc1_ = 1 + "st";
               break;
            case 2:
               _loc1_ = 2 + "nd";
               break;
            case 3:
               _loc1_ = 3 + "rd";
               break;
            default:
               _loc1_ = this._index + "th";
         }
         return _loc1_;
      }
      
      private function __itemClickHandler(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(!this._isSelect)
         {
            this.isSelect = true;
         }
      }
      
      private function __itemMouseOutHandler(param1:MouseEvent) : void
      {
         if(this._isSelect)
         {
            return;
         }
         this._shine.visible = false;
      }
      
      private function __itemMouseOverHandler(param1:MouseEvent) : void
      {
         this._shine.visible = true;
      }
      
      private function addEvent() : void
      {
         addEventListener(MouseEvent.CLICK,this.__itemClickHandler);
         addEventListener(MouseEvent.MOUSE_OVER,this.__itemMouseOverHandler);
         addEventListener(MouseEvent.MOUSE_OUT,this.__itemMouseOutHandler);
         PlayerManager.Instance.Self.addEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,this.__offerChange);
      }
      
      private function __offerChange(param1:PlayerPropertyEvent) : void
      {
         if(param1.changedProperties["isVip"])
         {
            this.upView();
         }
      }
      
      private function init() : void
      {
         this.graphics.beginFill(0,0);
         this.graphics.drawRect(0,0,495,30);
         this.graphics.endFill();
         this.buttonMode = true;
         this._bg = ComponentFactory.Instance.creatComponentByStylename("tofflist.gridItemBg");
         this._bg.setFrame(this._index % 2 + 1);
         addChild(this._bg);
         this._shine = ComponentFactory.Instance.creat("tofflist.orderlistitem.shine");
         this._shine.visible = false;
         addChild(this._shine);
         this._badge = new Badge();
         this._badge.visible = false;
         addChild(this._badge);
         PositionUtils.setPos(this._badge,"tofflist.item.badgePos");
         this._level = new LevelIcon();
         this._level.setSize(LevelIcon.SIZE_SMALL);
         addChild(this._level);
         this._level.visible = false;
         this._topThreeRink = ComponentFactory.Instance.creat("toffilist.topThreeRink");
         addChild(this._topThreeRink);
         this._topThreeRink.visible = false;
      }
      
      private function removeEvent() : void
      {
         removeEventListener(MouseEvent.CLICK,this.__itemClickHandler);
         removeEventListener(MouseEvent.MOUSE_OVER,this.__itemMouseOverHandler);
         removeEventListener(MouseEvent.MOUSE_OUT,this.__itemMouseOutHandler);
         PlayerManager.Instance.Self.removeEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,this.__offerChange);
      }
      
      private function upView() : void
      {
         var _loc1_:DisplayObject = null;
         var _loc2_:uint = 0;
         var _loc4_:int = 0;
         var _loc5_:Array = null;
         var _loc6_:TextFormat = null;
         var _loc7_:TextFormat = null;
         var _loc3_:uint = this._resourceArr.length;
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc1_ = this._resourceArr[_loc2_].dis;
            _loc1_["text"] = "";
            _loc1_.visible = false;
            _loc2_++;
         }
         this._resourceArr[0].dis["text"] = this.NO_ID;
         switch(TofflistModel.firstMenuType)
         {
            case TofflistStairMenu.PERSONAL:
               this._resourceArr[1].dis["text"] = this._info.NickName;
               switch(TofflistModel.secondMenuType)
               {
                  case TofflistTwoGradeMenu.BATTLE:
                     this.updateStyleXY(0);
                     switch(TofflistModel.thirdMenuType)
                     {
                        case TofflistThirdClassMenu.TOTAL:
                           this._resourceArr[2].dis["text"] = this._info.FightPower;
                     }
                     break;
                  case TofflistTwoGradeMenu.LEVEL:
                     this.updateStyleXY(1);
                     if(this._vipName)
                     {
                        this._vipName.x = this._resourceArr[1].dis.x - this._vipName.width / 2;
                     }
                     this._level.x = 227;
                     this._level.y = 3;
                     this._level.setInfo(this._info.Grade,this._info.Repute,this._info.WinCount,this._info.TotalCount,this._info.FightPower,this._info.Offer,true,false);
                     this._level.visible = true;
                     switch(TofflistModel.thirdMenuType)
                     {
                        case TofflistThirdClassMenu.DAY:
                           this._resourceArr[2].dis["text"] = this._info.AddDayGP;
                           break;
                        case TofflistThirdClassMenu.WEEK:
                           this._resourceArr[2].dis["text"] = this._info.AddWeekGP;
                           break;
                        case TofflistThirdClassMenu.TOTAL:
                           this._resourceArr[2].dis["text"] = this._info.GP;
                     }
                     break;
                  case TofflistTwoGradeMenu.ACHIEVEMENTPOINT:
                     this.updateStyleXY(2);
                     switch(TofflistModel.thirdMenuType)
                     {
                        case TofflistThirdClassMenu.DAY:
                           this._resourceArr[2].dis["text"] = this._info.AddDayAchievementPoint;
                           break;
                        case TofflistThirdClassMenu.WEEK:
                           this._resourceArr[2].dis["text"] = this._info.AddWeekAchievementPoint;
                           break;
                        case TofflistThirdClassMenu.TOTAL:
                           this._resourceArr[2].dis["text"] = this._info.AchievementPoint;
                     }
                     break;
                  case TofflistTwoGradeMenu.MATCHES:
                     this.updateStyleXY(4);
                     switch(TofflistModel.thirdMenuType)
                     {
                        case TofflistThirdClassMenu.WEEK:
                           this._resourceArr[2].dis["text"] = this._info.AddWeekLeagueScore;
                     }
                     break;
                  case TofflistTwoGradeMenu.MILITARY:
                     this.updateStyleXY(17);
                     this._resourceArr[2].dis["text"] = this._info.RankScores;
                     _loc4_ = ServerConfigManager.instance.getMilitaryData().length;
                     _loc5_ = ServerConfigManager.instance.getMilitaryData();
                     this._resourceArr[3].dis["text"] = this._index <= 3 && this._info.RankScores > _loc5_[_loc4_ - 1] ? MilitaryRankManager.Instance.getOtherMilitaryName(this._index)[0] : MilitaryRankManager.Instance.getMilitaryRankInfo(this._info.RankScores).Name;
                     break;
                  case TofflistTwoGradeMenu.ARENA:
                     this.updateStyleXY(18);
                     switch(TofflistModel.thirdMenuType)
                     {
                        case TofflistThirdClassMenu.DAY:
                           this._resourceArr[2].dis["text"] = this._info.AddDayMatchScore;
                           break;
                        case TofflistThirdClassMenu.WEEK:
                           this._resourceArr[2].dis["text"] = this._info.AddWeekMatchScore;
                     }
               }
               if(this._info.IsVIP)
               {
                  if(this._vipName)
                  {
                     ObjectUtils.disposeObject(this._vipName);
                  }
                  this._vipName = VipController.instance.getVipNameTxt(1,this._info.VIPtype);
                  _loc6_ = new TextFormat();
                  _loc6_.align = "center";
                  _loc6_.bold = true;
                  this._vipName.textField.defaultTextFormat = _loc6_;
                  this._vipName.textSize = 16;
                  this._vipName.textField.width = this._resourceArr[1].dis.width;
                  this._vipName.x = this._resourceArr[1].dis.x;
                  this._vipName.y = this._resourceArr[1].dis.y;
                  this._vipName.text = this._info.NickName;
               }
               PositionUtils.adaptNameStyle(this._info,this._resourceArr[1].dis,this._vipName);
               break;
            case TofflistStairMenu.CROSS_SERVER_PERSONAL:
               this._resourceArr[1].dis["text"] = this._info.NickName;
               this._resourceArr[3].dis["text"] = Boolean(this._info.AreaName) ? this._info.AreaName : "";
               switch(TofflistModel.secondMenuType)
               {
                  case TofflistTwoGradeMenu.BATTLE:
                     this.updateStyleXY(9);
                     switch(TofflistModel.thirdMenuType)
                     {
                        case TofflistThirdClassMenu.TOTAL:
                           this._resourceArr[2].dis["text"] = this._info.FightPower;
                     }
                     break;
                  case TofflistTwoGradeMenu.LEVEL:
                     this.updateStyleXY(10);
                     if(this._vipName)
                     {
                        this._vipName.x = this._resourceArr[1].dis.x - this._vipName.width / 2;
                     }
                     this._level.x = 208;
                     this._level.y = 3;
                     this._level.setInfo(this._info.Grade,this._info.Repute,this._info.WinCount,this._info.TotalCount,this._info.FightPower,this._info.Offer,true,false);
                     this._level.visible = true;
                     switch(TofflistModel.thirdMenuType)
                     {
                        case TofflistThirdClassMenu.DAY:
                           this._resourceArr[2].dis["text"] = this._info.AddDayGP;
                           break;
                        case TofflistThirdClassMenu.WEEK:
                           this._resourceArr[2].dis["text"] = this._info.AddWeekGP;
                           break;
                        case TofflistThirdClassMenu.TOTAL:
                           this._resourceArr[2].dis["text"] = this._info.GP;
                     }
                     break;
                  case TofflistTwoGradeMenu.ACHIEVEMENTPOINT:
                     this.updateStyleXY(11);
                     switch(TofflistModel.thirdMenuType)
                     {
                        case TofflistThirdClassMenu.DAY:
                           this._resourceArr[2].dis["text"] = this._info.AddDayAchievementPoint;
                           break;
                        case TofflistThirdClassMenu.WEEK:
                           this._resourceArr[2].dis["text"] = this._info.AddWeekAchievementPoint;
                           break;
                        case TofflistThirdClassMenu.TOTAL:
                           this._resourceArr[2].dis["text"] = this._info.AchievementPoint;
                     }
                     break;
                  case TofflistTwoGradeMenu.ARENA:
                     this.updateStyleXY(18);
                     switch(TofflistModel.thirdMenuType)
                     {
                        case TofflistThirdClassMenu.DAY:
                           this._resourceArr[2].dis["text"] = this._info.AddDayMatchScore;
                           break;
                        case TofflistThirdClassMenu.WEEK:
                           this._resourceArr[2].dis["text"] = this._info.AddWeekMatchScore;
                     }
               }
               if(this._info.IsVIP)
               {
                  if(this._vipName)
                  {
                     ObjectUtils.disposeObject(this._vipName);
                  }
                  this._vipName = VipController.instance.getVipNameTxt(1,this._info.VIPtype);
                  _loc7_ = new TextFormat();
                  _loc7_.align = "center";
                  _loc7_.bold = true;
                  this._vipName.textField.defaultTextFormat = _loc7_;
                  this._vipName.textSize = 16;
                  this._vipName.textField.width = this._resourceArr[1].dis.width;
                  this._vipName.x = this._resourceArr[1].dis.x;
                  this._vipName.y = this._resourceArr[1].dis.y;
                  this._vipName.text = this._info.NickName;
                  addChild(this._vipName);
               }
               PositionUtils.adaptNameStyle(this._info,this._resourceArr[1].dis,this._vipName);
               break;
            case TofflistStairMenu.CONSORTIA:
               if(!this._consortiaInfo)
               {
                  break;
               }
               this._badge.visible = this._consortiaInfo.BadgeID > 0;
               this._badge.badgeID = this._consortiaInfo.BadgeID;
               this._resourceArr[1].dis["text"] = this._consortiaInfo.ConsortiaName;
               switch(TofflistModel.secondMenuType)
               {
                  case TofflistTwoGradeMenu.BATTLE:
                     this.updateStyleXY(5);
                     switch(TofflistModel.thirdMenuType)
                     {
                        case TofflistThirdClassMenu.TOTAL:
                           this._resourceArr[2].dis["text"] = this._consortiaInfo.FightPower;
                     }
                     break;
                  case TofflistTwoGradeMenu.LEVEL:
                     this.updateStyleXY(6);
                     switch(TofflistModel.thirdMenuType)
                     {
                        case TofflistThirdClassMenu.TOTAL:
                           this._resourceArr[2].dis["text"] = this._consortiaInfo.Experience;
                           this._resourceArr[3].dis["text"] = this._consortiaInfo.Level;
                     }
                     break;
                  case TofflistTwoGradeMenu.ASSETS:
                     this.updateStyleXY(7);
                     switch(TofflistModel.thirdMenuType)
                     {
                        case TofflistThirdClassMenu.DAY:
                           this._resourceArr[2].dis["text"] = this._consortiaInfo.AddDayRiches;
                           break;
                        case TofflistThirdClassMenu.WEEK:
                           this._resourceArr[2].dis["text"] = this._consortiaInfo.AddWeekRiches;
                           break;
                        case TofflistThirdClassMenu.TOTAL:
                           this._resourceArr[2].dis["text"] = this._consortiaInfo.LastDayRiches;
                     }
               }
               break;
            case TofflistStairMenu.CROSS_SERVER_CONSORTIA:
               if(!this._consortiaInfo)
               {
                  break;
               }
               this._badge.visible = this._consortiaInfo.BadgeID > 0;
               this._badge.badgeID = this._consortiaInfo.BadgeID;
               this._resourceArr[1].dis["text"] = this._consortiaInfo.ConsortiaName;
               if(this._consortiaInfo.AreaName)
               {
                  this._resourceArr[3].dis["text"] = this._consortiaInfo.AreaName;
               }
               switch(TofflistModel.secondMenuType)
               {
                  case TofflistTwoGradeMenu.BATTLE:
                     this.updateStyleXY(13);
                     switch(TofflistModel.thirdMenuType)
                     {
                        case TofflistThirdClassMenu.TOTAL:
                           this._resourceArr[2].dis["text"] = this._consortiaInfo.FightPower;
                     }
                     break;
                  case TofflistTwoGradeMenu.LEVEL:
                     this.updateStyleXY(14);
                     switch(TofflistModel.thirdMenuType)
                     {
                        case TofflistThirdClassMenu.TOTAL:
                           this._resourceArr[2].dis["text"] = this._consortiaInfo.Experience;
                           this._resourceArr[4].dis["text"] = this._consortiaInfo.Level;
                     }
                     break;
                  case TofflistTwoGradeMenu.ASSETS:
                     this.updateStyleXY(15);
                     switch(TofflistModel.thirdMenuType)
                     {
                        case TofflistThirdClassMenu.DAY:
                           this._resourceArr[2].dis["text"] = this._consortiaInfo.AddDayRiches;
                           break;
                        case TofflistThirdClassMenu.WEEK:
                           this._resourceArr[2].dis["text"] = this._consortiaInfo.AddWeekRiches;
                           break;
                        case TofflistThirdClassMenu.TOTAL:
                           this._resourceArr[2].dis["text"] = this._consortiaInfo.LastDayRiches;
                     }
               }
               break;
         }
         if(this._vipName)
         {
            addChild(this._vipName);
         }
      }
      
      public function get consortiaInfo() : ConsortiaInfo
      {
         return this._consortiaInfo;
      }
   }
}
