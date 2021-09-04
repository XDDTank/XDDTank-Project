package activity.view
{
   import activity.ActivityController;
   import activity.data.ActivityChildTypes;
   import activity.data.ActivityGiftbagInfo;
   import activity.data.ActivityInfo;
   import activity.data.ActivityRewardInfo;
   import activity.data.ActivityTypes;
   import activity.data.ConditionRecord;
   import activity.view.viewInDetail.open.ActivityOpenConsortiaLevel;
   import activity.view.viewInDetail.open.ActivityOpenDivoce;
   import activity.view.viewInDetail.open.ActivityOpenFight;
   import activity.view.viewInDetail.open.ActivityOpenLevel;
   import activity.view.viewInDetail.open.ActivityOpenTotalMoney;
   import activity.view.viewInDetail.reward.ActivityRewardView;
   import activity.view.viewInDetail.tuan.ActivityTuanView;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.ScrollPanel;
   import com.pickgliss.ui.controls.TextInput;
   import com.pickgliss.ui.controls.container.SimpleTileList;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.Scale9CornerImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.ItemManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.PlayerManager;
   import ddt.manager.TimeManager;
   import ddt.utils.PositionUtils;
   import flash.display.Bitmap;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.utils.Timer;
   import road7th.data.DictionaryData;
   
   public class ActivityDetail extends Sprite implements Disposeable
   {
       
      
      private var _discriptionField:FilterFrameText;
      
      private var _timeField:FilterFrameText;
      
      private var _awardField:FilterFrameText;
      
      private var _contentField:FilterFrameText;
      
      private var _countField:FilterFrameText;
      
      private var _timeTitle:Bitmap;
      
      private var _awardTitle:Bitmap;
      
      private var _contentTitle:Bitmap;
      
      private var _countTitle:Bitmap;
      
      private var _awardList:SimpleTileList;
      
      private var _awardPanel:ScrollPanel;
      
      private var _timeWidth:int;
      
      private var _awardWidth:int;
      
      private var _contentWidth:int;
      
      private var _countWidth:int;
      
      private var _time:DisplayObject;
      
      private var _award:DisplayObject;
      
      private var _content:DisplayObject;
      
      private var _input:DisplayObject;
      
      private var _count:DisplayObject;
      
      private var _lines:Vector.<DisplayObject>;
      
      private var _bg:Vector.<Scale9CornerImage>;
      
      private var _inputField:TextInput;
      
      private var _timer:Timer;
      
      private var _info:ActivityInfo;
      
      private var _openTotalMoney:ActivityOpenTotalMoney;
      
      private var _openLevel:ActivityOpenLevel;
      
      private var _openFight:ActivityOpenFight;
      
      private var _openConsrotialLevel:ActivityOpenConsortiaLevel;
      
      private var _openActivityDivorce:ActivityOpenDivoce;
      
      private var _rewardActivity:ActivityRewardView;
      
      private var _tuanActivity:ActivityTuanView;
      
      public function ActivityDetail()
      {
         this._lines = new Vector.<DisplayObject>();
         this._bg = new Vector.<Scale9CornerImage>();
         super();
         this.initView();
         this.initEvent();
      }
      
      private static function calculateLast(param1:Date, param2:Date) : String
      {
         var _loc3_:int = param1.time - param2.time;
         var _loc4_:String = "";
         if(_loc3_ >= TimeManager.DAY_TICKS)
         {
            _loc4_ += Math.floor(_loc3_ / TimeManager.DAY_TICKS) + LanguageMgr.GetTranslation("day");
            _loc3_ %= TimeManager.DAY_TICKS;
         }
         if(_loc3_ >= TimeManager.HOUR_TICKS)
         {
            _loc4_ += Math.floor(_loc3_ / TimeManager.HOUR_TICKS) + LanguageMgr.GetTranslation("hour");
            _loc3_ %= TimeManager.HOUR_TICKS;
         }
         else if(_loc4_.length > 0)
         {
            _loc4_ += "00" + LanguageMgr.GetTranslation("hour");
         }
         if(_loc3_ >= TimeManager.Minute_TICKS)
         {
            _loc4_ += Math.floor(_loc3_ / TimeManager.Minute_TICKS) + LanguageMgr.GetTranslation("minute");
            _loc3_ %= TimeManager.Minute_TICKS;
         }
         else if(_loc4_.length > 0)
         {
            _loc4_ += "00" + LanguageMgr.GetTranslation("minute");
         }
         if(_loc3_ >= TimeManager.Second_TICKS)
         {
            _loc4_ += Math.floor(_loc3_ / TimeManager.Second_TICKS) + LanguageMgr.GetTranslation("second");
         }
         else if(_loc4_.length > 0)
         {
            _loc4_ += "00" + LanguageMgr.GetTranslation("second");
         }
         return _loc4_;
      }
      
      public function setData(param1:ActivityInfo) : void
      {
         this.visible = true;
         this._info = param1;
         this._awardTitle.x = this._award.x + 44;
         this._awardTitle.y = this._award.y + 12;
         this._awardField.y = this._award.y + this._award.height - 4;
         this._awardField.autoSize = "none";
         this._awardField.width = this._awardWidth;
         this._awardField.text = param1.RewardDesc;
         this._awardField.autoSize = "left";
         if(param1.ActivityType == ActivityTypes.MONTH)
         {
            this.setAwardPanel();
            this._lines[0].y = this._awardPanel.y + this._awardPanel.height + 8;
            this._bg[0].y = this._award.y - 5;
            this._bg[0].height = this._awardPanel.height + 48;
            this._awardField.visible = false;
         }
         else
         {
            this._lines[0].y = this._awardField.y + this._awardField.height + 8;
            this._bg[0].y = this._award.y - 5;
            this._bg[0].height = this._awardField.height + 48;
         }
         this._content.y = this._lines[0].y + this._lines[0].height + 4;
         this._contentField.y = this._content.y + this._content.height - 2;
         this._contentField.autoSize = "none";
         this._contentField.width = this._contentWidth;
         if(ActivityController.instance.checkMouthActivity(this._info))
         {
            this._contentField.htmlText = this.getDesripe();
         }
         else
         {
            this._contentField.htmlText = this._info.Desc;
         }
         this._contentField.autoSize = "left";
         this._contentTitle.x = this._content.x + 44;
         this._contentTitle.y = this._content.y + 12;
         if(this._info.ActivityType == ActivityTypes.RELEASE && this._info.ActivityChildType == ActivityChildTypes.NUMBER_ACTIVE)
         {
            this._input.visible = this._inputField.visible = true;
            this._inputField.y = this._contentField.y + this._contentField.height + 20;
            this._input.y = this._inputField.y + 4;
            this._lines[1].y = this._input.y + this._input.height + 14;
            this._bg[1].y = this._contentTitle.y - 17;
            this._bg[1].height = this._input.y - 86;
         }
         else
         {
            this._input.visible = this._inputField.visible = false;
            this._lines[1].y = this._contentField.y + this._contentField.height + 8;
            this._bg[1].y = this._contentTitle.y - 17;
            this._bg[1].height = this._contentField.height + 51;
         }
         this._time.y = this._lines[1].y + this._lines[1].height + 14;
         this._timeField.y = this._time.y + 12;
         this._timeField.width = this._timeWidth;
         this._timeField.text = param1.activeTime();
         this._timeField.autoSize = "left";
         this._timeTitle.x = this._time.x + 44;
         this._timeTitle.y = this._time.y + 12;
         if(ActivityController.instance.checkMouthActivity(this._info) && this._info.GetWay != 0)
         {
            this._lines[2].visible = true;
            this._count.visible = true;
            this._countField.visible = true;
            this._countTitle.visible = true;
            this._lines[2].y = this._time.y + this._time.height + 10;
            this._count.x = this._time.x;
            this._count.y = this._time.y + this._time.height + 20;
            this._countTitle.x = this._count.x + 44;
            this._countTitle.y = this._count.y + 12;
            this._countField.x = this._countTitle.x + this._countTitle.width + 6;
            this._countField.y = this._countTitle.y + 1;
            this._countField.text = this._info.GetWay - this._info.receiveNum + LanguageMgr.GetTranslation("tank.calendar.award.NagivCount");
         }
         else
         {
            this._lines[2].visible = false;
            this._count.visible = false;
            this._countField.visible = false;
            this._countTitle.visible = false;
         }
         this.adaptByActivity();
      }
      
      private function getDesripe() : String
      {
         var _loc3_:Array = null;
         var _loc6_:Object = null;
         var _loc7_:ActivityGiftbagInfo = null;
         var _loc8_:int = 0;
         var _loc9_:Array = null;
         var _loc10_:ConditionRecord = null;
         var _loc11_:int = 0;
         var _loc12_:int = 0;
         var _loc13_:String = null;
         var _loc1_:RegExp = /\{(\d+)\}/;
         var _loc2_:Array = ActivityController.instance.getAcitivityGiftBagByActID(this._info.ActivityId);
         var _loc4_:DictionaryData = new DictionaryData();
         var _loc5_:String = "";
         for each(_loc7_ in _loc2_)
         {
            _loc3_ = ActivityController.instance.getActivityConditionByGiftbagID(_loc7_.GiftbagId);
            _loc8_ = 0;
            while(_loc8_ < _loc3_.length)
            {
               _loc9_ = _loc3_[_loc8_].Remain2.split("|");
               if(_loc9_[0] == "show")
               {
                  _loc10_ = ActivityController.instance.model.getConditionRecord(this._info.ActivityId,_loc3_[_loc8_ - 1].ConditionIndex);
                  if(_loc3_[_loc8_ - 1].Remain2 == ActivityConditionType.CHALLENGE || _loc3_[_loc8_ - 1].Remain2 == ActivityConditionType.FREEDOM || _loc3_[_loc8_ - 1].Remain2 == ActivityConditionType.SPORTS || _loc3_[_loc8_ - 1].Remain2 == ActivityConditionType.GUILD)
                  {
                     if(_loc3_[_loc8_ - 1].Remain1 == -3)
                     {
                        _loc9_[1] = _loc9_[1].replace(_loc1_,_loc3_[_loc8_ - 1].ConditionValue);
                     }
                     else if(_loc3_[_loc8_ - 1].Remain1 > 0)
                     {
                        _loc9_[1] = _loc9_[1].replace(_loc1_,_loc3_[_loc8_ - 1].ConditionValue);
                        _loc9_[1] = _loc9_[1].replace(_loc1_,_loc3_[_loc8_ - 1].Remain1);
                        _loc9_[1] = _loc9_[1].replace(_loc1_,_loc3_[_loc8_ - 1].Remain1);
                     }
                     _loc9_[1] = _loc9_[1].replace(_loc1_,_loc3_[_loc8_ - 1].ConditionValue);
                  }
                  else if(_loc3_[_loc8_ - 1].Remain2 == ActivityConditionType.NPC)
                  {
                     if(_loc3_[_loc8_ - 1].Remain1 == -1)
                     {
                        _loc9_[1] = _loc9_[1].replace(_loc1_,_loc9_[2]);
                     }
                  }
                  else if(_loc3_[_loc8_ - 1].Remain2 == ActivityConditionType.COLLECTITEM || _loc3_[_loc8_ - 1].Remain2 == ActivityConditionType.USEITEM)
                  {
                     _loc9_[1] = _loc9_[1].replace(_loc1_,_loc3_[_loc8_ - 1].ConditionValue);
                     _loc12_ = _loc3_[_loc8_ - 1].Remain1;
                     _loc13_ = ItemManager.Instance.getTemplateById(_loc12_).Name;
                     _loc9_[1] = _loc9_[1].replace(_loc1_,_loc13_);
                  }
                  else if(_loc3_[_loc8_ - 1].Remain2 == ActivityConditionType.NUMBER)
                  {
                     _loc9_[1] = _loc9_[1].replace(_loc1_,_loc3_[_loc8_ - 1].ConditionValue);
                  }
                  if(_loc3_[_loc8_ - 1].Remain2 == ActivityConditionType.NPC)
                  {
                     if(_loc10_ && _loc10_.record == int(_loc3_[_loc8_ - 1].ConditionValue))
                     {
                        _loc11_ = 1;
                     }
                     else
                     {
                        _loc11_ = 0;
                     }
                     _loc5_ += _loc9_[1] + "  (" + _loc11_ + "/1)\n";
                  }
                  else if(_loc3_[_loc8_ - 1].Remain2 == ActivityConditionType.NUMBER)
                  {
                     if(_loc3_[_loc8_ - 1].Remain1 == -2)
                     {
                        _loc11_ = PlayerManager.Instance.Self.Grade;
                     }
                     else if(_loc3_[_loc8_ - 1].Remain1 == -1)
                     {
                        _loc11_ = Boolean(_loc10_) ? int(_loc10_.record) : int(0);
                     }
                     _loc11_ = _loc11_ > _loc3_[_loc8_ - 1].ConditionValue ? int(_loc3_[_loc8_ - 1].ConditionValue) : int(_loc11_);
                     _loc5_ += _loc9_[1] + "  (" + _loc11_ + "/" + _loc3_[_loc8_ - 1].ConditionValue + ")\n";
                  }
                  else if(_loc3_[_loc8_ - 1].Remain2 == ActivityConditionType.COLLECTITEM)
                  {
                     _loc11_ = PlayerManager.Instance.Self.Bag.getItemCountByTemplateId(_loc3_[_loc8_ - 1].Remain1);
                     _loc11_ = _loc11_ > _loc3_[_loc8_ - 1].ConditionValue ? int(_loc3_[_loc8_ - 1].ConditionValue) : int(_loc11_);
                     _loc5_ += _loc9_[1] + "  (" + _loc11_ + "/" + _loc3_[_loc8_ - 1].ConditionValue + ")\n";
                  }
                  else if(_loc10_)
                  {
                     if(_loc10_.record <= int(_loc3_[_loc8_ - 1].ConditionValue))
                     {
                        _loc5_ += _loc9_[1] + "  (" + _loc10_.record + "/" + _loc3_[_loc8_ - 1].ConditionValue + ")\n";
                     }
                     else
                     {
                        _loc5_ += _loc9_[1] + "  (" + _loc3_[_loc8_ - 1].ConditionValue + "/" + _loc3_[_loc8_ - 1].ConditionValue + ")\n";
                     }
                  }
                  else
                  {
                     _loc5_ += _loc9_[1] + "  (" + "0" + "/" + _loc3_[_loc8_ - 1].ConditionValue + ")\n";
                  }
                  _loc10_ = null;
               }
               _loc8_++;
            }
         }
         return _loc5_;
      }
      
      private function setAwardPanel() : void
      {
         var _loc2_:DictionaryData = null;
         var _loc3_:ActivityCell = null;
         var _loc4_:ActivityGiftbagInfo = null;
         var _loc5_:ActivityRewardInfo = null;
         this._awardList.disposeAllChildren();
         var _loc1_:Array = ActivityController.instance.getAcitivityGiftBagByActID(this._info.ActivityId);
         for each(_loc4_ in _loc1_)
         {
            _loc2_ = ActivityController.instance.getRewardsByGiftbagID(_loc4_.GiftbagId);
            for each(_loc5_ in _loc2_)
            {
               _loc3_ = new ActivityCell(_loc5_);
               _loc3_.count = _loc5_.Count;
               this._awardList.addChild(_loc3_);
            }
         }
         this._awardPanel.vScrollProxy = this._awardList.numChildren > 6 ? int(0) : int(2);
      }
      
      private function adaptByActivity() : void
      {
         var _loc1_:DisplayObject = null;
         var _loc2_:Scale9CornerImage = null;
         this._openTotalMoney.visible = false;
         this._openLevel.visible = false;
         this._openFight.visible = false;
         this._openConsrotialLevel.visible = false;
         this._openActivityDivorce.visible = false;
         this._rewardActivity.visible = false;
         this._tuanActivity.visible = false;
         if(ActivityController.instance.checkOpenActivity(this._info) || ActivityController.instance.checkChargeReward(this._info) || ActivityController.instance.checkCostReward(this._info) || ActivityController.instance.checkTuan(this._info))
         {
            this._award.visible = this._awardTitle.visible = this._awardField.visible = this._awardPanel.visible = false;
            this._time.visible = this._timeTitle.visible = false;
            this._timeField.visible = true;
            this._content.visible = this._contentTitle.visible = this._contentField.visible = false;
            if(ActivityController.instance.checkChargeReward(this._info) || ActivityController.instance.checkCostReward(this._info))
            {
               this._contentField.visible = true;
            }
            for each(_loc1_ in this._lines)
            {
               _loc1_.visible = false;
            }
            for each(_loc2_ in this._bg)
            {
               _loc2_.visible = false;
            }
            if(ActivityController.instance.checkTotalMoeny(this._info))
            {
               this._openTotalMoney.visible = true;
               this._openTotalMoney.info = this._info;
            }
            else if(ActivityController.instance.checkOpenLevel(this._info))
            {
               this._openLevel.visible = true;
               this._openLevel.info = this._info;
            }
            else if(ActivityController.instance.checkOpenFight(this._info))
            {
               this._openFight.visible = true;
               this._openFight.info = this._info;
               this._contentField.visible = true;
            }
            else if(ActivityController.instance.checkOpenConsortiaLevel(this._info))
            {
               this._openConsrotialLevel.visible = true;
               this._openConsrotialLevel.info = this._info;
               this._contentField.visible = true;
            }
            else if(ActivityController.instance.checkOpenLove(this._info))
            {
               this._openActivityDivorce.visible = true;
               this._openActivityDivorce.info = this._info;
            }
            else if(ActivityController.instance.checkCostReward(this._info) || ActivityController.instance.checkChargeReward(this._info))
            {
               this._rewardActivity.visible = true;
               this._rewardActivity.info = this._info;
            }
            else if(ActivityController.instance.checkTuan(this._info))
            {
               this._tuanActivity.visible = true;
               this._tuanActivity.info = this._info;
               this._timeField.visible = false;
            }
         }
         else
         {
            if(this._info.ActivityType == ActivityTypes.MONTH)
            {
               this._awardField.visible = false;
               this._award.visible = this._awardTitle.visible = this._awardPanel.visible = true;
            }
            else
            {
               this._award.visible = this._awardTitle.visible = this._awardField.visible = this._info.RewardDesc == "" || this._info.RewardDesc == null ? Boolean(false) : Boolean(true);
               this._awardPanel.visible = false;
            }
            this._time.visible = this._timeTitle.visible = true;
            this._content.visible = this._contentTitle.visible = this._contentField.visible = true;
            this._lines[0].visible = true;
            this._lines[1].visible = true;
            this._bg[0].visible = true;
            this._bg[1].visible = true;
         }
         this.setTimeAndContentPos();
      }
      
      private function setTimeAndContentPos() : void
      {
         var _loc1_:String = "ddtcalendar.ActivityState.TimeFieldPos";
         var _loc2_:String = "ddtcalendar.ActivityState.ContentFieldPos";
         if(ActivityController.instance.checkTotalMoeny(this._info))
         {
            _loc1_ += ActivityState.MC_OPEN_COMMON_ONCE;
            _loc2_ += ActivityState.MC_OPEN_COMMON_ONCE;
         }
         else if(ActivityController.instance.checkOpenConsortiaLevel(this._info))
         {
            _loc1_ += ActivityState.MC_GUILD;
            _loc2_ += ActivityState.MC_GUILD;
         }
         else if(ActivityController.instance.checkOpenLove(this._info))
         {
            _loc1_ += ActivityState.MC_DIVORCE;
            _loc2_ += ActivityState.MC_DIVORCE;
         }
         else if(ActivityController.instance.checkOpenLevel(this._info))
         {
            _loc1_ += ActivityState.MC_LEVEL;
            _loc2_ += ActivityState.MC_LEVEL;
         }
         else if(ActivityController.instance.checkOpenFight(this._info))
         {
            _loc1_ += ActivityState.MC_POWER;
            _loc2_ += ActivityState.MC_POWER;
         }
         else if(ActivityController.instance.checkCostReward(this._info))
         {
            _loc1_ += ActivityState.MC_COST;
            _loc2_ += ActivityState.MC_COST;
         }
         else
         {
            if(!ActivityController.instance.checkChargeReward(this._info))
            {
               _loc1_ += ActivityState.MC_DEFAULT;
               _loc2_ += ActivityState.MC_DEFAULT;
               this._timeField.x = ComponentFactory.Instance.creatCustomObject(_loc1_).x;
               this._contentField.x = ComponentFactory.Instance.creatCustomObject(_loc2_).x;
               return;
            }
            _loc1_ += ActivityState.MC_CHARGE;
            _loc2_ += ActivityState.MC_CHARGE;
         }
         PositionUtils.setPos(this._timeField,_loc1_);
         PositionUtils.setPos(this._contentField,_loc2_);
      }
      
      private function initView() : void
      {
         var _loc1_:Scale9CornerImage = ComponentFactory.Instance.creatComponentByStylename("asset.ActivityDetail.Bg");
         PositionUtils.setPos(_loc1_,"ddtcalendar.ActivityState.BgPos" + this._bg.length);
         this._bg.push(_loc1_);
         addChild(_loc1_);
         _loc1_ = ComponentFactory.Instance.creatComponentByStylename("asset.ActivityDetail.Bg");
         PositionUtils.setPos(_loc1_,"ddtcalendar.ActivityState.BgPos" + this._bg.length);
         this._bg.push(_loc1_);
         addChild(_loc1_);
         this._time = ComponentFactory.Instance.creatBitmap("asset.ddtcalendar.ActivityState.TimeIcon");
         addChild(this._time);
         this._award = ComponentFactory.Instance.creatBitmap("asset.ddtcalendar.ActivityState.AwardIcon");
         addChild(this._award);
         this._content = ComponentFactory.Instance.creatBitmap("asset.ddtcalendar.ActivityState.ContentIcon");
         addChild(this._content);
         this._count = ComponentFactory.Instance.creatBitmap("asset.ddtcalendar.ActivityState.timesBitmap");
         addChild(this._count);
         this._timeField = ComponentFactory.Instance.creatComponentByStylename("ddtcalendar.ActivityState.TimeField");
         this._timeWidth = this._timeField.width;
         addChild(this._timeField);
         this._awardField = ComponentFactory.Instance.creatComponentByStylename("ddtcalendar.ActivityState.AwardField");
         this._awardWidth = this._awardField.width;
         addChild(this._awardField);
         this._awardList = ComponentFactory.Instance.creatCustomObject("ddtactivity.activitydetail.awardList",[6]);
         addChild(this._awardList);
         this._awardPanel = ComponentFactory.Instance.creatComponentByStylename("ddtactivity.activitydetail.awardPanel");
         addChild(this._awardPanel);
         this._awardPanel.setView(this._awardList);
         this._contentField = ComponentFactory.Instance.creatComponentByStylename("ddtcalendar.ActivityState.StateContentField");
         this._contentField.mouseEnabled = true;
         this._contentField.selectable = false;
         this._contentWidth = this._contentField.width;
         addChild(this._contentField);
         this._countField = ComponentFactory.Instance.creatComponentByStylename("ddtcalendar.ActivityState.StateCountField");
         this._countWidth = this._countField.width;
         addChild(this._countField);
         var _loc2_:DisplayObject = ComponentFactory.Instance.creatBitmap("asset.ddtcalendar.ActivityState.SeparatorLine");
         PositionUtils.setPos(_loc2_,"ddtcalendar.ActivityState.LinePos" + this._lines.length);
         this._lines.push(_loc2_);
         _loc2_ = ComponentFactory.Instance.creatBitmap("asset.ddtcalendar.ActivityState.SeparatorLine");
         PositionUtils.setPos(_loc2_,"ddtcalendar.ActivityState.LinePos" + this._lines.length);
         this._lines.push(_loc2_);
         _loc2_ = ComponentFactory.Instance.creatBitmap("asset.ddtcalendar.ActivityState.SeparatorLine");
         PositionUtils.setPos(_loc2_,"ddtcalendar.ActivityState.LinePos" + this._lines.length);
         this._lines.push(_loc2_);
         this._input = ComponentFactory.Instance.creatBitmap("aaset.ddtcalendar.ActivityState.Pwd");
         addChild(this._input);
         this._inputField = ComponentFactory.Instance.creatComponentByStylename("ddtcalendar.ActivityState.InputField");
         addChild(this._inputField);
         this._openTotalMoney = ComponentFactory.Instance.creatCustomObject("ddtactivity.ActivityOpenTotalMoney");
         addChild(this._openTotalMoney);
         this._openLevel = ComponentFactory.Instance.creatCustomObject("ddtactivity.ActivityOpenLevel");
         addChild(this._openLevel);
         this._openFight = ComponentFactory.Instance.creatCustomObject("ddtactivity.ActivityOpenFight");
         addChild(this._openFight);
         this._openConsrotialLevel = ComponentFactory.Instance.creatCustomObject("ddtactivity.ActivityOpenConsortiaLevel");
         addChild(this._openConsrotialLevel);
         this._openActivityDivorce = ComponentFactory.Instance.creatCustomObject("ddtactivity.ActivityOpenDivoce");
         addChild(this._openActivityDivorce);
         this._rewardActivity = ComponentFactory.Instance.creatCustomObject("ddtactivity.ActivityReward");
         addChild(this._rewardActivity);
         this._tuanActivity = ComponentFactory.Instance.creatCustomObject("ddtactivity.ActivityTuanView");
         addChild(this._tuanActivity);
         this._awardTitle = ComponentFactory.Instance.creatBitmap("ddtcalendar.ActivityState.AwardFieldTitle");
         addChild(this._awardTitle);
         this._contentTitle = ComponentFactory.Instance.creatBitmap("ddtcalendar.ActivityState.ContentFieldTitle");
         addChild(this._contentTitle);
         this._timeTitle = ComponentFactory.Instance.creatBitmap("ddtcalendar.ActivityState.TimeFieldTitle");
         addChild(this._timeTitle);
         this._countTitle = ComponentFactory.Instance.creatBitmap("ddtcalendar.ActivityState.CountFieldTitle");
         addChild(this._countTitle);
         this.visible = false;
      }
      
      private function initEvent() : void
      {
      }
      
      public function checkGetEnable() : Boolean
      {
         if(ActivityController.instance.checkTotalMoeny(this._info))
         {
            if(this._openTotalMoney.enable)
            {
               return true;
            }
         }
         else if(ActivityController.instance.checkOpenFight(this._info))
         {
            if(this._openFight.enable)
            {
               return true;
            }
         }
         else if(ActivityController.instance.checkOpenLevel(this._info))
         {
            if(this._openLevel.enable)
            {
               return true;
            }
         }
         else if(ActivityController.instance.checkOpenConsortiaLevel(this._info))
         {
            if(this._openConsrotialLevel.enable)
            {
               return true;
            }
         }
         else if(ActivityController.instance.checkOpenLove(this._info))
         {
            if(this._openActivityDivorce.enable)
            {
               return true;
            }
         }
         return false;
      }
      
      public function update() : void
      {
         if(ActivityController.instance.checkTotalMoeny(this._info))
         {
            this._openTotalMoney.update();
         }
      }
      
      override public function get height() : Number
      {
         var _loc1_:int = 0;
         return int(this._timeField.y + this._timeField.height + 10);
      }
      
      public function getInputField() : TextInput
      {
         return this._inputField;
      }
      
      public function removeEvent() : void
      {
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         if(this._timer)
         {
            this._timer.stop();
         }
         this._time = null;
         ObjectUtils.disposeObject(this._timeField);
         this._timeField = null;
         ObjectUtils.disposeObject(this._awardField);
         this._awardField = null;
         ObjectUtils.disposeObject(this._contentField);
         this._contentField = null;
         ObjectUtils.disposeObject(this._time);
         this._time = null;
         ObjectUtils.disposeObject(this._award);
         this._award = null;
         ObjectUtils.disposeObject(this._content);
         this._content = null;
         ObjectUtils.disposeObject(this._input);
         this._input = null;
         ObjectUtils.disposeObject(this._inputField);
         this._inputField = null;
         ObjectUtils.disposeObject(this._timeTitle);
         this._timeTitle = null;
         ObjectUtils.disposeObject(this._awardTitle);
         this._awardTitle = null;
         ObjectUtils.disposeObject(this._contentTitle);
         this._contentTitle = null;
         if(this._awardList)
         {
            this._awardList.disposeAllChildren();
         }
         ObjectUtils.disposeObject(this._awardList);
         this._awardList = null;
         ObjectUtils.disposeObject(this._awardPanel);
         this._awardPanel = null;
         var _loc1_:DisplayObject = this._lines.shift();
         while(_loc1_ != null)
         {
            ObjectUtils.disposeObject(_loc1_);
            _loc1_ = null;
            _loc1_ = this._lines.shift();
         }
         var _loc2_:DisplayObject = this._bg.shift();
         while(_loc2_ != null)
         {
            ObjectUtils.disposeObject(_loc2_);
            _loc2_ = null;
            _loc2_ = this._bg.shift();
         }
         ObjectUtils.disposeObject(this._openTotalMoney);
         this._openTotalMoney = null;
         ObjectUtils.disposeObject(this._openFight);
         this._openFight = null;
         ObjectUtils.disposeObject(this._openLevel);
         this._openLevel = null;
         ObjectUtils.disposeObject(this._openConsrotialLevel);
         this._openConsrotialLevel = null;
         ObjectUtils.disposeObject(this._openActivityDivorce);
         this._openActivityDivorce = null;
         ObjectUtils.disposeObject(this._count);
         this._count = null;
         ObjectUtils.disposeObject(this._countField);
         this._countField = null;
         ObjectUtils.disposeObject(this._countTitle);
         this._countTitle = null;
         ObjectUtils.disposeObject(this._rewardActivity);
         this._rewardActivity = null;
         ObjectUtils.disposeObject(this._tuanActivity);
         this._tuanActivity = null;
         if(parent)
         {
            parent.removeChild(this);
         }
      }
   }
}
