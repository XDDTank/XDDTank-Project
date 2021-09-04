package consortion
{
   import consortion.data.ConsortiaApplyInfo;
   import consortion.data.ConsortiaAssetLevelOffer;
   import consortion.data.ConsortiaDutyInfo;
   import consortion.data.ConsortiaInventData;
   import consortion.data.ConsortiaLevelInfo;
   import consortion.data.ConsortionNewSkillInfo;
   import consortion.data.ConsortionPollInfo;
   import consortion.data.ConsortionProbabilityInfo;
   import consortion.data.ConsortionSkillInfo;
   import consortion.event.ConsortionEvent;
   import consortion.transportSence.TransportCar;
   import consortion.transportSence.TransportCarInfo;
   import ddt.data.BuffInfo;
   import ddt.data.ConsortiaEventInfo;
   import ddt.data.ConsortiaInfo;
   import ddt.data.player.ConsortiaPlayerInfo;
   import ddt.data.player.PlayerState;
   import ddt.manager.LanguageMgr;
   import ddt.manager.PlayerManager;
   import ddt.manager.ServerConfigManager;
   import ddt.manager.TimeManager;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import road7th.data.DictionaryData;
   
   public class ConsortionModel extends EventDispatcher
   {
      
      public static const CONSORTION_MAX_LEVEL:int = 10;
      
      public static const SHOP_MAX_LEVEL:int = 10;
      
      public static const STORE_MAX_LEVEL:int = 10;
      
      public static const BANK_MAX_LEVEL:int = 10;
      
      public static const SKILL_MAX_LEVEL:int = 10;
      
      public static const LEVEL:int = 0;
      
      public static const SHOP:int = 1;
      
      public static const SKILL:int = 2;
      
      public static const TASKLEVELI:int = 11;
      
      public static const TASKLEVELII:int = 12;
      
      public static const TASKLEVELIII:int = 13;
      
      public static const TASKLEVELIV:int = 14;
      
      public static const CONSORTION_TASK:int = 1;
      
      public static const CONSORTION_CONVOY:int = 2;
      
      public static const MONSTER_REFLASH:int = 3;
      
      public static const CONSORTION_SENCE:int = 0;
      
      public static const CONSORTION_TRANSPORT:int = 1;
      
      public static const CONSORTION_SKILL:int = 1;
      
      public static const PERSONAL_SKILL:int = 2;
      
      public static const CLUB:String = "consortiaClub";
      
      public static const SELF_CONSORTIA:String = "selfConsortia";
      
      public static const ConsortionListEachPageNum:int = 6;
      
      public static var TaskRewardSontribution1:int;
      
      public static var TaskRewardExp1:int;
      
      public static var TaskRewardSontribution2:int;
      
      public static var TaskRewardExp2:int;
      
      public static var TaskRewardSontribution3:int;
      
      public static var TaskRewardExp3:int;
      
      public static var TaskRewardSontribution4:int;
      
      public static var TaskRewardExp4:int;
      
      public static var REMAIN_CONVOY_TIME:int = 0;
      
      public static var REMAIN_GUARD_TIME:int = 0;
      
      public static var REMAIN_HIJACK_TIME:int = 0;
      
      public static var TASK_CAN_ACCEPT_TIME:int = 86400000;
       
      
      public var systemDate:String;
      
      private var _memberList:DictionaryData;
      
      private var _consortionList:Vector.<ConsortiaInfo>;
      
      public var consortionsListTotalCount:int;
      
      private var _readyApplyList:Vector.<ConsortiaInfo>;
      
      private var _myApplyList:Vector.<ConsortiaApplyInfo>;
      
      public var applyListTotalCount:int;
      
      private var _inventList:Vector.<ConsortiaInventData>;
      
      public var inventListTotalCount:int;
      
      private var _eventList:Vector.<ConsortiaEventInfo>;
      
      private var _useConditionList:Vector.<ConsortiaAssetLevelOffer>;
      
      private var _dutyList:Vector.<ConsortiaDutyInfo>;
      
      private var _pollList:Vector.<ConsortionPollInfo>;
      
      private var _skillInfoList:Vector.<ConsortionSkillInfo>;
      
      private var _newSkillInfo:Vector.<ConsortionNewSkillInfo>;
      
      private var _probabiliInfo:Vector.<ConsortionProbabilityInfo>;
      
      private var _levelUpData:Vector.<ConsortiaLevelInfo>;
      
      private var _currentTaskLevel:int = 11;
      
      private var _remainPublishTime:int;
      
      private var _lastPublishDate:Date;
      
      private var _canAcceptTask:Boolean;
      
      private var _isMaster:Boolean;
      
      private var _receivedQuestCount:int;
      
      private var _consortiaQuestCount:int;
      
      private var _shinePlay:Boolean = false;
      
      public function ConsortionModel(param1:IEventDispatcher = null)
      {
         super(param1);
      }
      
      public function get memberList() : DictionaryData
      {
         if(this._memberList == null)
         {
            this._memberList = new DictionaryData();
         }
         return this._memberList;
      }
      
      public function set memberList(param1:DictionaryData) : void
      {
         if(this._memberList == param1)
         {
            return;
         }
         this._memberList = param1;
         dispatchEvent(new ConsortionEvent(ConsortionEvent.MEMBERLIST_COMPLETE));
      }
      
      public function addMember(param1:ConsortiaPlayerInfo) : void
      {
         this._memberList.add(param1.ID,param1);
         dispatchEvent(new ConsortionEvent(ConsortionEvent.MEMBER_ADD,param1));
      }
      
      public function removeMember(param1:ConsortiaPlayerInfo) : void
      {
         this._memberList.remove(param1.ID);
         dispatchEvent(new ConsortionEvent(ConsortionEvent.MEMBER_REMOVE,param1));
      }
      
      public function updataMember(param1:ConsortiaPlayerInfo) : void
      {
         this._memberList.add(param1.ID,param1);
         dispatchEvent(new ConsortionEvent(ConsortionEvent.MEMBER_UPDATA,param1));
      }
      
      public function get onlineConsortiaMemberList() : Array
      {
         var _loc2_:ConsortiaPlayerInfo = null;
         var _loc1_:Array = [];
         for each(_loc2_ in this.memberList)
         {
            if(_loc2_.playerState.StateID != PlayerState.OFFLINE)
            {
               _loc1_.push(_loc2_);
            }
         }
         return _loc1_;
      }
      
      public function getConsortiaMemberInfo(param1:int) : ConsortiaPlayerInfo
      {
         var _loc2_:ConsortiaPlayerInfo = null;
         for each(_loc2_ in this.memberList)
         {
            if(_loc2_.ID == param1)
            {
               return _loc2_;
            }
         }
         return null;
      }
      
      public function get offlineConsortiaMemberList() : Array
      {
         var _loc2_:ConsortiaPlayerInfo = null;
         var _loc1_:Array = [];
         for each(_loc2_ in this.memberList)
         {
            if(_loc2_.playerState.StateID == PlayerState.OFFLINE)
            {
               _loc1_.push(_loc2_);
            }
         }
         return _loc1_;
      }
      
      public function get ViceChairmanConsortiaMemberList() : Vector.<ConsortiaPlayerInfo>
      {
         var _loc2_:ConsortiaPlayerInfo = null;
         var _loc1_:Vector.<ConsortiaPlayerInfo> = new Vector.<ConsortiaPlayerInfo>();
         for each(_loc2_ in this.memberList)
         {
            if(_loc2_.DutyLevel == 2)
            {
               _loc1_.push(_loc2_);
            }
         }
         return _loc1_;
      }
      
      public function consortiaPlayerStateChange(param1:int, param2:int) : void
      {
         var _loc4_:PlayerState = null;
         var _loc3_:ConsortiaPlayerInfo = this.getConsortiaMemberInfo(param1);
         if(_loc3_ == null)
         {
            return;
         }
         if(_loc3_)
         {
            _loc4_ = new PlayerState(param2);
            _loc3_.playerState = _loc4_;
            this.updataMember(_loc3_);
         }
      }
      
      public function set consortionList(param1:Vector.<ConsortiaInfo>) : void
      {
         if(this._consortionList == param1)
         {
            return;
         }
         this._consortionList = param1;
         dispatchEvent(new ConsortionEvent(ConsortionEvent.CONSORTIONLIST_IS_CHANGE));
      }
      
      public function get consortionList() : Vector.<ConsortiaInfo>
      {
         return this._consortionList;
      }
      
      public function set readyApplyList(param1:Vector.<ConsortiaInfo>) : void
      {
         if(this._readyApplyList == param1)
         {
            return;
         }
         this._readyApplyList = param1;
      }
      
      public function get readyApplyList() : Vector.<ConsortiaInfo>
      {
         return this._readyApplyList;
      }
      
      public function set myApplyList(param1:Vector.<ConsortiaApplyInfo>) : void
      {
         var _loc2_:Vector.<ConsortiaInfo> = null;
         var _loc3_:int = 0;
         var _loc4_:ConsortiaInfo = null;
         if(this._myApplyList == param1)
         {
            return;
         }
         this._myApplyList = param1;
         if(this.consortionList)
         {
            _loc2_ = new Vector.<ConsortiaInfo>();
            while(_loc3_ < param1.length)
            {
               _loc4_ = this.getConosrionByID(param1[_loc3_].ConsortiaID);
               _loc2_.push(_loc4_);
               _loc3_++;
            }
            this.readyApplyList = _loc2_;
         }
         dispatchEvent(new ConsortionEvent(ConsortionEvent.MY_APPLY_LIST_IS_CHANGE));
      }
      
      public function get myApplyList() : Vector.<ConsortiaApplyInfo>
      {
         return this._myApplyList;
      }
      
      public function getapplyListWithPage(param1:int, param2:int = 10) : Vector.<ConsortiaApplyInfo>
      {
         param1 = param1 < 0 ? int(1) : (param1 > Math.ceil(this._myApplyList.length / param2) ? int(Math.ceil(this._myApplyList.length / param2)) : int(param1));
         return this.myApplyList.slice((param1 - 1) * param2,param1 * param2);
      }
      
      public function getconsrotionListWithPage(param1:int, param2:int = 10) : Vector.<ConsortiaInfo>
      {
         param1 = param1 < 0 ? int(1) : (param1 > Math.ceil(this._consortionList.length / param2) ? int(Math.ceil(this._consortionList.length / param2)) : int(param1));
         return this._consortionList.slice((param1 - 1) * param2,param1 * param2);
      }
      
      public function getreadApplyconsrotionListWithPage(param1:int, param2:int = 10) : Vector.<ConsortiaInfo>
      {
         param1 = param1 < 0 ? int(1) : (param1 > Math.ceil(this._readyApplyList.length / param2) ? int(Math.ceil(this._readyApplyList.length / param2)) : int(param1));
         return this._readyApplyList.slice((param1 - 1) * param2,param1 * param2);
      }
      
      public function deleteOneApplyRecord(param1:int) : void
      {
         var _loc2_:int = this.myApplyList.length;
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_)
         {
            if(this.myApplyList[_loc3_].ID == param1)
            {
               if(this.readyApplyList)
               {
                  this.readyApplyList.splice(_loc3_,1);
               }
               this.myApplyList.splice(_loc3_,1);
               dispatchEvent(new ConsortionEvent(ConsortionEvent.MY_APPLY_LIST_IS_CHANGE));
               break;
            }
            _loc3_++;
         }
      }
      
      public function deleteOneConsortion(param1:int) : void
      {
         if(this.consortionList == null)
         {
            return;
         }
         var _loc2_:int = this.consortionList.length;
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_)
         {
            if(this.consortionList[_loc3_].ConsortiaID == param1)
            {
               this.consortionList.splice(_loc3_,1);
               dispatchEvent(new ConsortionEvent(ConsortionEvent.CONSORTIONLIST_IS_CHANGE));
               break;
            }
            _loc3_++;
         }
      }
      
      public function set inventList(param1:Vector.<ConsortiaInventData>) : void
      {
         if(this._inventList == param1)
         {
            return;
         }
         this._inventList = param1;
         dispatchEvent(new ConsortionEvent(ConsortionEvent.INVENT_LIST_IS_CHANGE));
      }
      
      public function get inventList() : Vector.<ConsortiaInventData>
      {
         return this._inventList;
      }
      
      public function get eventList() : Vector.<ConsortiaEventInfo>
      {
         return this._eventList;
      }
      
      public function set eventList(param1:Vector.<ConsortiaEventInfo>) : void
      {
         if(this._eventList == param1)
         {
            return;
         }
         this._eventList = param1;
         dispatchEvent(new ConsortionEvent(ConsortionEvent.EVENT_LIST_CHANGE));
      }
      
      public function get useConditionList() : Vector.<ConsortiaAssetLevelOffer>
      {
         return this._useConditionList;
      }
      
      public function set useConditionList(param1:Vector.<ConsortiaAssetLevelOffer>) : void
      {
         if(this._useConditionList == param1)
         {
            return;
         }
         this._useConditionList = param1;
         dispatchEvent(new ConsortionEvent(ConsortionEvent.USE_CONDITION_CHANGE));
      }
      
      public function get dutyList() : Vector.<ConsortiaDutyInfo>
      {
         return this._dutyList;
      }
      
      public function set dutyList(param1:Vector.<ConsortiaDutyInfo>) : void
      {
         if(this._dutyList == param1)
         {
            return;
         }
         this._dutyList = param1;
         dispatchEvent(new ConsortionEvent(ConsortionEvent.DUTY_LIST_CHANGE));
      }
      
      public function changeDutyListName(param1:int, param2:String) : void
      {
         var _loc3_:int = 0;
         while(_loc3_ < this._dutyList.length)
         {
            if(this._dutyList[_loc3_].DutyID == param1)
            {
               this._dutyList[_loc3_].DutyName = param2;
               break;
            }
            _loc3_++;
         }
      }
      
      public function get pollList() : Vector.<ConsortionPollInfo>
      {
         return this._pollList;
      }
      
      public function set pollList(param1:Vector.<ConsortionPollInfo>) : void
      {
         if(this._pollList == param1)
         {
            return;
         }
         this._pollList = param1;
         dispatchEvent(new ConsortionEvent(ConsortionEvent.POLL_LIST_CHANGE));
      }
      
      public function get skillInfoList() : Vector.<ConsortionSkillInfo>
      {
         return this._skillInfoList;
      }
      
      public function set skillInfoList(param1:Vector.<ConsortionSkillInfo>) : void
      {
         if(this._skillInfoList == param1)
         {
            return;
         }
         this._skillInfoList = param1;
      }
      
      public function get newSkillInfoList() : Vector.<ConsortionNewSkillInfo>
      {
         return this._newSkillInfo;
      }
      
      public function set newSkillInfoList(param1:Vector.<ConsortionNewSkillInfo>) : void
      {
         if(this._newSkillInfo == param1)
         {
            return;
         }
         this._newSkillInfo = param1;
         dispatchEvent(new ConsortionEvent(ConsortionEvent.SKILL_LIST_CHANGE));
      }
      
      public function set proBabiliInfoList(param1:Vector.<ConsortionProbabilityInfo>) : void
      {
         if(this._probabiliInfo == param1)
         {
            return;
         }
         this._probabiliInfo = param1;
      }
      
      public function get proBabiliInfoList() : Vector.<ConsortionProbabilityInfo>
      {
         return this._probabiliInfo;
      }
      
      public function getskillInfoWithTypeAndLevel(param1:int) : Vector.<ConsortionNewSkillInfo>
      {
         var _loc2_:Vector.<ConsortionNewSkillInfo> = new Vector.<ConsortionNewSkillInfo>();
         var _loc3_:int = this.newSkillInfoList.length;
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_)
         {
            if(this.newSkillInfoList[_loc4_].BuildLevel == param1)
            {
               _loc2_.push(this.newSkillInfoList[_loc4_]);
            }
            _loc4_++;
         }
         return _loc2_;
      }
      
      public function getSkillInfoByID(param1:int) : ConsortionSkillInfo
      {
         var _loc2_:ConsortionSkillInfo = null;
         var _loc3_:int = 0;
         while(_loc3_ < this.skillInfoList.length)
         {
            if(this.skillInfoList[_loc3_].id == param1)
            {
               _loc2_ = this.skillInfoList[_loc3_];
            }
            _loc3_++;
         }
         return _loc2_;
      }
      
      public function updateSkillInfo(param1:int, param2:Boolean, param3:Date, param4:int) : void
      {
         var _loc5_:int = this.skillInfoList.length;
         var _loc6_:int = 0;
         while(_loc6_ < _loc5_)
         {
            if(this.skillInfoList[_loc6_].id == param1)
            {
               this.skillInfoList[_loc6_].isOpen = param2;
               this.skillInfoList[_loc6_].beginDate = param3;
               this.skillInfoList[_loc6_].validDate = param4;
               break;
            }
            _loc6_++;
         }
      }
      
      public function hasSomeGroupSkill(param1:int, param2:int) : Boolean
      {
         var _loc3_:int = this.skillInfoList.length;
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_)
         {
            if(this.skillInfoList[_loc4_].group == param1 && this.skillInfoList[_loc4_].isOpen && this.skillInfoList[_loc4_].id != param2)
            {
               return true;
            }
            _loc4_++;
         }
         return false;
      }
      
      public function set levelUpData(param1:Vector.<ConsortiaLevelInfo>) : void
      {
         if(this._levelUpData == param1)
         {
            return;
         }
         this._levelUpData = param1;
         dispatchEvent(new ConsortionEvent(ConsortionEvent.LEVEL_UP_RULE_CHANGE));
      }
      
      public function get levelUpData() : Vector.<ConsortiaLevelInfo>
      {
         return this._levelUpData;
      }
      
      public function getLevelData(param1:int) : ConsortiaLevelInfo
      {
         if(this.levelUpData == null)
         {
            return null;
         }
         var _loc2_:uint = 0;
         while(_loc2_ < this.levelUpData.length)
         {
            if(this.levelUpData[_loc2_]["Level"] == param1)
            {
               return this.levelUpData[_loc2_];
            }
            _loc2_++;
         }
         return null;
      }
      
      public function getQuestType(param1:int) : String
      {
         var _loc2_:String = LanguageMgr.GetTranslation("consortion.ConsortionTask.level1");
         if(param1 == 11)
         {
            return LanguageMgr.GetTranslation("consortion.ConsortionTask.level1");
         }
         if(param1 == 12)
         {
            return LanguageMgr.GetTranslation("consortion.ConsortionTask.level2");
         }
         if(param1 == 13)
         {
            return LanguageMgr.GetTranslation("consortion.ConsortionTask.level3");
         }
         if(param1 == 14)
         {
            return LanguageMgr.GetTranslation("consortion.ConsortionTask.level4");
         }
         return _loc2_;
      }
      
      public function getLevelString(param1:int, param2:int) : Vector.<String>
      {
         var _loc3_:Vector.<String> = new Vector.<String>(4);
         switch(param1)
         {
            case LEVEL:
               if(param2 >= CONSORTION_MAX_LEVEL)
               {
                  _loc3_[0] = LanguageMgr.GetTranslation("tank.consortia.myconsortia.frame.MyConsortiaUpgrade.explainTxt");
                  _loc3_[1] = LanguageMgr.GetTranslation("tank.consortia.myconsortia.frame.MyConsortiaUpgrade.null");
                  _loc3_[2] = LanguageMgr.GetTranslation("tank.consortia.myconsortia.frame.MyConsortiaUpgrade.null");
                  _loc3_[3] = LanguageMgr.GetTranslation("tank.consortia.myconsortia.frame.MyConsortiaUpgrade.null");
               }
               else
               {
                  _loc3_[0] = LanguageMgr.GetTranslation("tank.consortia.myconsortia.frame.MyConsortiaUpgrade.upgradeI");
                  _loc3_[1] = LanguageMgr.GetTranslation("tank.consortia.myconsortia.frame.MyConsortiaUpgrade.nextLevel",param2 + 1);
                  _loc3_[2] = LanguageMgr.GetTranslation("tank.consortia.myconsortia.frame.MyConsortiaUpgrade.nextLevelI",param2 + 1);
                  if(this.getLevelData(param2 + 1))
                  {
                     _loc3_[3] = this.getLevelData(param2 + 1).StoreRiches + LanguageMgr.GetTranslation("consortia.Money") + this.checkRiches(this.getLevelData(param2 + 1).StoreRiches);
                  }
               }
               break;
            case SHOP:
               if(param2 >= SHOP_MAX_LEVEL)
               {
                  _loc3_[0] = LanguageMgr.GetTranslation("tank.consortia.myconsortia.frame.MyConsortiaUpgrade.consortiaShopLevel");
                  _loc3_[1] = LanguageMgr.GetTranslation("tank.consortia.myconsortia.frame.MyConsortiaUpgrade.null");
                  _loc3_[2] = LanguageMgr.GetTranslation("tank.consortia.myconsortia.frame.MyConsortiaUpgrade.null");
                  _loc3_[3] = LanguageMgr.GetTranslation("tank.consortia.myconsortia.frame.MyConsortiaUpgrade.null");
               }
               else
               {
                  _loc3_[0] = LanguageMgr.GetTranslation("tank.consortia.myconsortia.frame.MyConsortiaUpgrade.CONSORTIASHOPGRADE.explainTxt");
                  _loc3_[1] = LanguageMgr.GetTranslation("tank.consortia.consortiashop.ConsortiaShopView.titleText") + (param2 + 1) + LanguageMgr.GetTranslation("grade");
                  _loc3_[2] = LanguageMgr.GetTranslation("consortia.upgrade") + (param2 + 1) + LanguageMgr.GetTranslation("grade");
                  if(this.getLevelData(param2 + 1))
                  {
                     _loc3_[3] = this.getLevelData(param2 + 1).ShopRiches + LanguageMgr.GetTranslation("consortia.Money") + this.checkRiches(this.getLevelData(param2 + 1).ShopRiches);
                  }
               }
               break;
            case SKILL:
               if(param2 >= SKILL_MAX_LEVEL)
               {
                  _loc3_[0] = LanguageMgr.GetTranslation("tank.consortia.myconsortia.frame.MyConsortiaUpgrade.skill");
                  _loc3_[1] = LanguageMgr.GetTranslation("tank.consortia.myconsortia.frame.MyConsortiaUpgrade.null");
                  _loc3_[2] = LanguageMgr.GetTranslation("tank.consortia.myconsortia.frame.MyConsortiaUpgrade.null");
                  _loc3_[3] = LanguageMgr.GetTranslation("tank.consortia.myconsortia.frame.MyConsortiaUpgrade.null");
               }
               else
               {
                  _loc3_[0] = LanguageMgr.GetTranslation("tank.consortia.myconsortia.frame.MyConsortiaUpgrade.skill.explainTxt");
                  _loc3_[1] = LanguageMgr.GetTranslation("tank.consortia.consortiashop.ConsortiaShopView.skill",param2 + 1);
                  _loc3_[2] = LanguageMgr.GetTranslation("consortia.upgrade") + (param2 + 1) + LanguageMgr.GetTranslation("grade");
                  if(this.getLevelData(param2 + 1))
                  {
                     _loc3_[3] = this.getLevelData(param2 + 1).SmithRiches + LanguageMgr.GetTranslation("consortia.Money") + this.checkRiches(this.getLevelData(param2 + 1).SmithRiches);
                  }
               }
         }
         return _loc3_;
      }
      
      public function getTaskLevelString(param1:int) : Vector.<String>
      {
         var _loc2_:int = this.getLevelData(PlayerManager.Instance.Self.consortiaInfo.Level).Count;
         var _loc3_:Vector.<String> = new Vector.<String>(2);
         switch(param1)
         {
            case TASKLEVELI:
               _loc3_[0] = String(ConsortionModel.TaskRewardSontribution1 * _loc2_ * 5);
               _loc3_[1] = String(ConsortionModel.TaskRewardExp1 * _loc2_ * 5);
               _loc3_[2] = String(this.getConsortionLevelByTaskLevel(TASKLEVELI));
               break;
            case TASKLEVELII:
               _loc3_[0] = String(ConsortionModel.TaskRewardSontribution2 * _loc2_ * 5);
               _loc3_[1] = String(ConsortionModel.TaskRewardExp2 * _loc2_ * 5);
               _loc3_[2] = String(this.getConsortionLevelByTaskLevel(TASKLEVELII));
               break;
            case TASKLEVELIII:
               _loc3_[0] = String(ConsortionModel.TaskRewardSontribution3 * _loc2_ * 5);
               _loc3_[1] = String(ConsortionModel.TaskRewardExp3 * _loc2_ * 5);
               _loc3_[2] = String(this.getConsortionLevelByTaskLevel(TASKLEVELIII));
               break;
            case TASKLEVELIV:
               _loc3_[0] = String(ConsortionModel.TaskRewardSontribution4 * _loc2_ * 5);
               _loc3_[1] = String(ConsortionModel.TaskRewardExp4 * _loc2_ * 5);
               _loc3_[2] = String(this.getConsortionLevelByTaskLevel(TASKLEVELIV));
         }
         return _loc3_;
      }
      
      private function getConsortionLevelByTaskLevel(param1:int) : int
      {
         var _loc3_:ConsortiaLevelInfo = null;
         var _loc2_:uint = 0;
         while(_loc2_ < CONSORTION_MAX_LEVEL)
         {
            _loc3_ = this.getLevelData(_loc2_ + 1);
            if(_loc3_.QuestLevel == param1)
            {
               return _loc3_.Level;
            }
            _loc2_++;
         }
         return 1;
      }
      
      public function getCarCostString(param1:int) : Vector.<String>
      {
         var _loc3_:TransportCarInfo = null;
         var _loc2_:Vector.<String> = new Vector.<String>(2);
         switch(param1)
         {
            case TransportCar.CARI:
               _loc3_ = new TransportCarInfo(TransportCar.CARI);
               _loc3_.ownerLevel = PlayerManager.Instance.Self.Grade;
               _loc2_[0] = LanguageMgr.GetTranslation("consortion.ConsortionComfirm.normalCarName.text");
               _loc2_[1] = "";
               _loc2_[2] = "";
               _loc2_[3] = LanguageMgr.GetTranslation("consortion.ConsortionComfirm.summomCost.gold.txt") + ":";
               _loc2_[4] = String(_loc3_.cost);
               break;
            case TransportCar.CARII:
               _loc3_ = new TransportCarInfo(TransportCar.CARII);
               _loc3_.ownerLevel = PlayerManager.Instance.Self.Grade;
               _loc2_[0] = LanguageMgr.GetTranslation("consortion.ConsortionComfirm.highClassCarName.text");
               _loc2_[1] = "";
               _loc2_[2] = "";
               _loc2_[3] = LanguageMgr.GetTranslation("tank.auctionHouse.view.AuctionBrowseView.stipple") + ":";
               _loc2_[4] = String(_loc3_.cost);
         }
         var _loc4_:int = int(_loc3_.rewardContribution);
         var _loc5_:int = int(_loc3_.rewardGold);
         if(this.isRewardPlusTime)
         {
            _loc4_ = int(_loc4_ * 1.5);
            _loc5_ = int(_loc5_ * 1.5);
         }
         _loc2_[1] = String(_loc4_);
         _loc2_[2] = String(_loc5_);
         return _loc2_;
      }
      
      public function getCarInfoTip(param1:TransportCarInfo) : Vector.<String>
      {
         var _loc2_:BuffInfo = PlayerManager.Instance.Self.buffInfo[BuffInfo.ADD_HIJACK_COUNT];
         var _loc3_:int = 0;
         if(_loc2_)
         {
            _loc3_ = _loc2_.Value;
         }
         var _loc4_:Vector.<String> = new Vector.<String>(8);
         _loc4_[0] = String(param1.ownerName);
         _loc4_[1] = "Lv." + String(param1.ownerLevel);
         _loc4_[2] = LanguageMgr.GetTranslation("consortion.ConsortionTransport.carInfoTip.consortion.txt") + ":" + param1.consortionName;
         _loc4_[3] = LanguageMgr.GetTranslation("consortion.ConsortionTransport.carInfoTip.guarderName.txt") + ":" + param1.nickName;
         _loc4_[4] = LanguageMgr.GetTranslation("consortion.ConsortionTransport.carInfoTip.hijackTimes.txt") + ":" + param1.hijackTimes + "/" + (TransportCarInfo.MAX_HIJACKED_TIMES + _loc3_);
         _loc4_[5] = String(param1.startDate.valueOf());
         _loc4_[6] = String(param1.speed);
         _loc4_[7] = LanguageMgr.GetTranslation("consortion.ConsortionTransport.carInfoTip.remainTime.txt") + ":" + param1.guarderName;
         var _loc5_:Number = 1;
         var _loc6_:int = PlayerManager.Instance.Self.Grade - param1.ownerLevel;
         if(_loc6_ > 0)
         {
            if(_loc6_ >= 9)
            {
               _loc5_ = 0.1;
            }
            else
            {
               _loc5_ = 1 - _loc6_ / 10;
            }
         }
         var _loc7_:int = int(param1.rewardGold * param1.hijackPercent / 100 * _loc5_);
         if(_loc7_ < 1)
         {
            _loc7_ = 1;
         }
         var _loc8_:int = int(param1.rewardContribution * param1.hijackPercent / 100 * _loc5_);
         if(_loc8_ < 1)
         {
            _loc8_ = 1;
         }
         if(this.isRewardPlusTime)
         {
            _loc7_ = int(_loc7_ * 1.5);
            _loc8_ = int(_loc8_ * 1.5);
         }
         _loc4_[8] = _loc7_ + " " + LanguageMgr.GetTranslation("consortion.skillFrame.richesText1");
         _loc4_[9] = _loc8_ + " " + LanguageMgr.GetTranslation("consortion.ConsortionCampaign.reward.contribution.text");
         return _loc4_;
      }
      
      private function get isRewardPlusTime() : Boolean
      {
         var _loc1_:Date = TimeManager.Instance.Now();
         var _loc2_:Number = _loc1_.getHours();
         var _loc3_:Number = _loc1_.getMinutes();
         if(_loc2_ == 17)
         {
            if(_loc3_ >= 30)
            {
               return true;
            }
         }
         if(_loc2_ == 18)
         {
            return true;
         }
         return false;
      }
      
      public function getTaskCost(param1:int) : uint
      {
         var _loc2_:uint = 0;
         switch(param1)
         {
            case TASKLEVELI:
               _loc2_ = ServerConfigManager.instance.getConsortiaTaskCost()[0];
               break;
            case TASKLEVELII:
               _loc2_ = ServerConfigManager.instance.getConsortiaTaskCost()[1];
               break;
            case TASKLEVELIII:
               _loc2_ = ServerConfigManager.instance.getConsortiaTaskCost()[2];
               break;
            case TASKLEVELIV:
               _loc2_ = ServerConfigManager.instance.getConsortiaTaskCost()[3];
         }
         return _loc2_;
      }
      
      public function checkConsortiaRichesForUpGrade(param1:int) : Boolean
      {
         var _loc2_:int = PlayerManager.Instance.Self.consortiaInfo.Riches;
         switch(param1)
         {
            case 0:
               if(PlayerManager.Instance.Self.consortiaInfo.StoreLevel < CONSORTION_MAX_LEVEL)
               {
                  if(_loc2_ < this.getLevelData(PlayerManager.Instance.Self.consortiaInfo.StoreLevel + 1).StoreRiches)
                  {
                     return false;
                  }
               }
               break;
            case 1:
               if(PlayerManager.Instance.Self.consortiaInfo.ShopLevel < SHOP_MAX_LEVEL)
               {
                  if(_loc2_ < this.getLevelData(PlayerManager.Instance.Self.consortiaInfo.ShopLevel + 1).ShopRiches)
                  {
                     return false;
                  }
               }
               break;
            case 2:
               if(PlayerManager.Instance.Self.consortiaInfo.SmithLevel < SKILL_MAX_LEVEL)
               {
                  if(_loc2_ < this.getLevelData(PlayerManager.Instance.Self.consortiaInfo.SmithLevel + 1).SmithRiches)
                  {
                     return false;
                  }
               }
         }
         return true;
      }
      
      private function checkRiches(param1:int) : String
      {
         var _loc2_:String = "";
         if(PlayerManager.Instance.Self.consortiaInfo.Riches < param1)
         {
            _loc2_ = LanguageMgr.GetTranslation("tank.consortia.myconsortia.frame.MyConsortiaUpgrade.condition");
         }
         return _loc2_;
      }
      
      private function checkGold(param1:int) : String
      {
         var _loc2_:String = "";
         if(PlayerManager.Instance.Self.Gold < param1)
         {
            _loc2_ = LanguageMgr.GetTranslation("tank.consortia.myconsortia.frame.MyConsortiaUpgrade.condition");
         }
         return _loc2_;
      }
      
      public function get currentTaskLevel() : int
      {
         return this._currentTaskLevel;
      }
      
      public function set currentTaskLevel(param1:int) : void
      {
         this._currentTaskLevel = param1;
      }
      
      public function get remainPublishTime() : int
      {
         return this._remainPublishTime;
      }
      
      public function set remainPublishTime(param1:int) : void
      {
         this._remainPublishTime = param1;
      }
      
      public function get lastPublishDate() : Date
      {
         return this._lastPublishDate;
      }
      
      public function set lastPublishDate(param1:Date) : void
      {
         this._lastPublishDate = param1;
      }
      
      public function get canAcceptTask() : Boolean
      {
         return this._canAcceptTask;
      }
      
      public function set canAcceptTask(param1:Boolean) : void
      {
         this._canAcceptTask = param1;
      }
      
      public function get isMaster() : Boolean
      {
         return this._isMaster;
      }
      
      public function set isMaster(param1:Boolean) : void
      {
         this._isMaster = param1;
      }
      
      public function get receivedQuestCount() : int
      {
         return this._receivedQuestCount;
      }
      
      public function set receivedQuestCount(param1:int) : void
      {
         this._receivedQuestCount = param1;
      }
      
      public function get consortiaQuestCount() : int
      {
         return this._consortiaQuestCount;
      }
      
      public function set consortiaQuestCount(param1:int) : void
      {
         this._consortiaQuestCount = param1;
      }
      
      public function getConosrionByID(param1:int) : ConsortiaInfo
      {
         var _loc2_:ConsortiaInfo = null;
         var _loc3_:int = 0;
         while(_loc3_ < this.consortionList.length)
         {
            if(this.consortionList[_loc3_].ConsortiaID == param1)
            {
               _loc2_ = this.consortionList[_loc3_];
            }
            _loc3_++;
         }
         return _loc2_;
      }
      
      public function getisLearnByBuffId(param1:int) : Boolean
      {
         var _loc2_:Boolean = false;
         var _loc3_:DictionaryData = PlayerManager.Instance.Self.isLearnSkill;
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_.length)
         {
            if(_loc3_[_loc4_] == param1.toString())
            {
               _loc2_ = true;
            }
            _loc4_++;
         }
         return _loc2_;
      }
      
      public function getInfoByBuffId(param1:int) : ConsortionNewSkillInfo
      {
         var _loc2_:ConsortionNewSkillInfo = null;
         var _loc3_:int = 0;
         while(_loc3_ < this.newSkillInfoList.length)
         {
            if(this.newSkillInfoList[_loc3_].BuffID == param1)
            {
               _loc2_ = this.newSkillInfoList[_loc3_];
            }
            _loc3_++;
         }
         return _loc2_;
      }
      
      public function getInfoByType(param1:int) : ConsortionNewSkillInfo
      {
         var _loc2_:ConsortionNewSkillInfo = null;
         var _loc3_:int = 0;
         while(_loc3_ < this.newSkillInfoList.length)
         {
            if(this.newSkillInfoList[_loc3_].BuffType == param1)
            {
               _loc2_ = this.newSkillInfoList[_loc3_];
            }
            _loc3_++;
         }
         return _loc2_;
      }
      
      public function getInfoByTypeAndData(param1:int, param2:int) : ConsortionNewSkillInfo
      {
         var _loc3_:ConsortionNewSkillInfo = null;
         var _loc4_:int = 0;
         while(_loc4_ < this.newSkillInfoList.length)
         {
            if(this.newSkillInfoList[_loc4_].BuffType == param1)
            {
               if(int(this.newSkillInfoList[_loc4_].BuffValue) == param2)
               {
                  _loc3_ = this.newSkillInfoList[_loc4_];
               }
            }
            _loc4_++;
         }
         return _loc3_;
      }
      
      public function getisUpgradeByBuffId(param1:int) : Boolean
      {
         var _loc2_:Boolean = true;
         var _loc3_:ConsortionNewSkillInfo = this.getInfoByBuffId(param1);
         var _loc4_:ConsortionNewSkillInfo = this.getInfoByBuffId(param1 - 1);
         if(_loc3_.BuildLevel > PlayerManager.Instance.Self.consortiaInfo.SmithLevel)
         {
            return false;
         }
         if(_loc3_.NeedLevel > PlayerManager.Instance.Self.Grade)
         {
            return false;
         }
         if(_loc3_.NeedDevote > PlayerManager.Instance.Self.RichesOffer)
         {
            return false;
         }
         if(!this.getisLearnByBuffId(param1))
         {
            return false;
         }
         return _loc2_;
      }
      
      public function getisUpgradeByType(param1:int, param2:int) : Boolean
      {
         var _loc3_:Boolean = false;
         var _loc4_:ConsortionNewSkillInfo = this.getInfoByBuffId(param2);
         switch(param1)
         {
            case 0:
               if(_loc4_.BuildLevel > PlayerManager.Instance.Self.consortiaInfo.SmithLevel)
               {
                  return true;
               }
               break;
            case 1:
               if(_loc4_.NeedLevel > PlayerManager.Instance.Self.Grade)
               {
                  return true;
               }
               break;
            case 2:
               if(_loc4_.NeedDevote > PlayerManager.Instance.Self.RichesOffer)
               {
                  return true;
               }
               break;
            case 3:
               if(param2 != 1 && !this.getisLearnByBuffId(param2 - 1))
               {
                  return true;
               }
               break;
         }
         return _loc3_;
      }
      
      public function set shinePlay(param1:Boolean) : void
      {
         this._shinePlay = param1;
      }
      
      public function get shinePlay() : Boolean
      {
         return this._shinePlay;
      }
   }
}
