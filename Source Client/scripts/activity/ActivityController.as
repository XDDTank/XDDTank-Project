package activity
{
   import activity.analyze.ActiveExchangeAnalyzer;
   import activity.analyze.ActivityConditionAnalyzer;
   import activity.analyze.ActivityGiftbagAnalyzer;
   import activity.analyze.ActivityInfoAnalyzer;
   import activity.analyze.ActivityRewardAnalyzer;
   import activity.data.ActivityChildTypes;
   import activity.data.ActivityConditionInfo;
   import activity.data.ActivityGiftbagInfo;
   import activity.data.ActivityGiftbagRecord;
   import activity.data.ActivityInfo;
   import activity.data.ActivityRewardInfo;
   import activity.data.ActivityTuanInfo;
   import activity.data.ActivityTypes;
   import activity.data.ConditionRecord;
   import activity.view.ActivityConditionType;
   import activity.view.ActivityFirstRechargeView;
   import activity.view.ActivityFrame;
   import com.pickgliss.events.UIModuleEvent;
   import com.pickgliss.loader.BaseLoader;
   import com.pickgliss.loader.LoadResourceManager;
   import com.pickgliss.loader.LoaderEvent;
   import com.pickgliss.loader.UIModuleLoader;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.AccountInfo;
   import ddt.data.UIModuleTypes;
   import ddt.data.player.SelfInfo;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PathManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.TimeManager;
   import ddt.utils.CrytoUtils;
   import ddt.utils.RequestVairableCreater;
   import ddt.view.UIModuleSmallLoading;
   import flash.events.Event;
   import flash.net.URLVariables;
   import flash.utils.ByteArray;
   import road7th.comm.PackageIn;
   import road7th.data.DictionaryData;
   
   public class ActivityController
   {
      
      private static var _instance:ActivityController;
       
      
      private var _model:ActivityModel;
      
      private var _frame:ActivityFrame;
      
      private var _firstRechargeView:ActivityFirstRechargeView;
      
      private var _complete:Boolean = false;
      
      private var _completeFun:Function;
      
      private var _reciveActive:ActivityInfo;
      
      public function ActivityController()
      {
         super();
         this._model = new ActivityModel();
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.ACTIVE_lOG,this.__activeLogUpdate);
      }
      
      public static function get instance() : ActivityController
      {
         if(!_instance)
         {
            _instance = new ActivityController();
         }
         return _instance;
      }
      
      public function checkCondition(param1:ActivityInfo) : Boolean
      {
         var _loc3_:Array = null;
         var _loc5_:ConditionRecord = null;
         var _loc6_:ActivityGiftbagInfo = null;
         var _loc7_:ActivityConditionInfo = null;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         var _loc10_:SelfInfo = null;
         var _loc2_:Array = ActivityController.instance.getAcitivityGiftBagByActID(param1.ActivityId);
         var _loc4_:DictionaryData = new DictionaryData();
         for each(_loc6_ in _loc2_)
         {
            _loc3_ = ActivityController.instance.getActivityConditionByGiftbagID(_loc6_.GiftbagId);
            for each(_loc7_ in _loc3_)
            {
               _loc5_ = ActivityController.instance.model.getConditionRecord(param1.ActivityId,_loc7_.ConditionIndex);
               if(_loc7_.Remain2 == ActivityConditionType.FREEDOM || _loc7_.Remain2 == ActivityConditionType.SPORTS || _loc7_.Remain2 == ActivityConditionType.CHALLENGE || _loc7_.Remain2 == ActivityConditionType.GUILD)
               {
                  if(!_loc5_ || _loc5_.record < int(_loc7_.ConditionValue))
                  {
                     return false;
                  }
                  continue;
               }
               if(_loc7_.Remain2 == ActivityConditionType.NPC)
               {
                  if(!_loc5_ || _loc5_.record != int(_loc7_.ConditionValue))
                  {
                     return false;
                  }
                  continue;
               }
               if(_loc7_.Remain2 == ActivityConditionType.COLLECTITEM)
               {
                  _loc8_ = _loc7_.Remain1;
                  _loc9_ = PlayerManager.Instance.Self.Bag.getItemCountByTemplateId(_loc8_);
                  if(_loc9_ < int(_loc7_.ConditionValue))
                  {
                     return false;
                  }
                  continue;
               }
               if(_loc7_.Remain2 == ActivityConditionType.USEITEM)
               {
                  if(!_loc5_ || _loc5_.record < int(_loc7_.ConditionValue))
                  {
                     return false;
                  }
                  continue;
               }
               if(_loc7_.Remain2 == ActivityConditionType.NUMBER)
               {
                  if(_loc7_.Remain1 == -2)
                  {
                     if(PlayerManager.Instance.Self.Grade < int(_loc7_.ConditionValue))
                     {
                        return false;
                     }
                  }
                  else if(_loc7_.Remain1 == -1)
                  {
                     if(!_loc5_ || _loc5_.record < int(_loc7_.ConditionValue))
                     {
                        return false;
                     }
                  }
                  continue;
               }
               if(!(_loc7_.Remain2 == ActivityConditionType.MINGRADELIMIT || _loc7_.Remain2 == ActivityConditionType.MAXGRADELIMIT || _loc7_.Remain2 == ActivityConditionType.RELATIONLIMIT))
               {
                  continue;
               }
               _loc10_ = PlayerManager.Instance.Self;
               if(_loc7_.Remain2 == ActivityConditionType.MINGRADELIMIT && _loc10_.Grade < int(_loc7_.ConditionValue))
               {
                  return false;
               }
               if(_loc7_.Remain2 == ActivityConditionType.MAXGRADELIMIT && _loc10_.Grade > int(_loc7_.ConditionValue))
               {
                  return false;
               }
               if(_loc7_.Remain2 != ActivityConditionType.RELATIONLIMIT)
               {
                  continue;
               }
               switch(_loc7_.ConditionValue)
               {
                  case 1:
                     if(!PlayerManager.Instance.Self.IsMarried)
                     {
                        return false;
                     }
                     break;
                  case 2:
                     if(PlayerManager.Instance.Self.ConsortiaID == 0)
                     {
                        return false;
                     }
                     break;
               }
            }
         }
         return true;
      }
      
      public function checkShowCondition(param1:ActivityInfo) : Boolean
      {
         var _loc3_:Array = null;
         var _loc5_:ActivityGiftbagInfo = null;
         var _loc6_:ActivityConditionInfo = null;
         var _loc7_:SelfInfo = null;
         var _loc2_:Array = ActivityController.instance.getAcitivityGiftBagByActID(param1.ActivityId);
         var _loc4_:DictionaryData = new DictionaryData();
         for each(_loc5_ in _loc2_)
         {
            _loc3_ = ActivityController.instance.getActivityConditionByGiftbagID(_loc5_.GiftbagId);
            for each(_loc6_ in _loc3_)
            {
               _loc7_ = PlayerManager.Instance.Self;
               if(_loc6_.Remain2 == ActivityConditionType.MINGRADELIMIT && _loc7_.Grade < int(_loc6_.ConditionValue))
               {
                  return false;
               }
               if(_loc6_.Remain2 == ActivityConditionType.MAXGRADELIMIT && _loc7_.Grade > int(_loc6_.ConditionValue))
               {
                  return false;
               }
               if(_loc6_.Remain2 != ActivityConditionType.RELATIONLIMIT)
               {
                  continue;
               }
               switch(int(_loc6_.ConditionValue))
               {
                  case 1:
                     if(!PlayerManager.Instance.Self.IsMarried)
                     {
                        return false;
                     }
                     break;
                  case 2:
                     if(PlayerManager.Instance.Self.ConsortiaID == 0)
                     {
                        return false;
                     }
                     break;
               }
            }
         }
         return true;
      }
      
      public function checkFinish(param1:ActivityInfo) : Boolean
      {
         if(param1.GetWay == 0)
         {
            return false;
         }
         return param1.receiveNum != 0 && param1.receiveNum >= param1.GetWay;
      }
      
      public function get model() : ActivityModel
      {
         return this._model;
      }
      
      public function sendAskForActiviLog(param1:ActivityInfo) : void
      {
         SocketManager.Instance.out.sendAskForActiviLog(param1.ActivityId,param1.ActivityType,param1.ActivityChildType);
      }
      
      public function setData(param1:ActivityInfo) : void
      {
         if(this._frame)
         {
            this._frame.setData(param1);
         }
      }
      
      private function updateData(param1:ActivityInfo = null) : void
      {
         if(this._frame && this._frame.parent)
         {
            this._frame.updateData(param1);
         }
      }
      
      public function showFrame() : void
      {
         if(this._complete)
         {
            if(!this._frame)
            {
               this._frame = ComponentFactory.Instance.creatCustomObject("ddtcalendar.ActivityFrame");
            }
            this._frame.show();
         }
         else
         {
            this._completeFun = this.showFrame;
            this.loadUI();
         }
      }
      
      public function hideFrame() : void
      {
         this.model.showID = "";
         ObjectUtils.disposeObject(this._frame);
         this._frame = null;
      }
      
      public function isInValidOpenDate(param1:ActivityInfo) : Boolean
      {
         var _loc2_:Date = TimeManager.Instance.Now();
         var _loc3_:Date = param1.beginDate;
         var _loc4_:Date = param1.endDate;
         if(_loc2_.getTime() >= _loc3_.getTime() && _loc2_.getTime() <= _loc4_.getTime())
         {
            return true;
         }
         return false;
      }
      
      public function isInValidShowDate(param1:ActivityInfo) : Boolean
      {
         var _loc2_:Date = TimeManager.Instance.Now();
         var _loc3_:Date = param1.beginShowDate;
         var _loc4_:Date = param1.endShowDate;
         if(_loc2_.getTime() >= _loc3_.getTime() && _loc2_.getTime() <= _loc4_.getTime())
         {
            return true;
         }
         return false;
      }
      
      public function getActivityAward(param1:ActivityInfo, param2:Object = null) : void
      {
         SocketManager.Instance.out.sendGetActivityAward(param1.ActivityId,param1.ActivityType,param2);
      }
      
      public function checkFirstCharge(param1:ActivityInfo) : Boolean
      {
         if(param1.ActivityType == ActivityTypes.CHARGE && param1.ActivityChildType == ActivityChildTypes.OPEN_FIRST_ONCE)
         {
            return true;
         }
         return false;
      }
      
      public function checkHasFirstCharge() : ActivityInfo
      {
         var _loc1_:ActivityInfo = null;
         for each(_loc1_ in this._model.activityInfoArr)
         {
            if(this.checkFirstCharge(_loc1_) && this.isInValidShowDate(_loc1_))
            {
               return _loc1_;
            }
         }
         return null;
      }
      
      public function checkHasOpenActivity() : Boolean
      {
         var _loc1_:ActivityInfo = null;
         for each(_loc1_ in this._model.activityInfoArr)
         {
            if(this.checkOpenActivity(_loc1_) && this.isInValidShowDate(_loc1_))
            {
               return true;
            }
         }
         return false;
      }
      
      public function checkOpenActivity(param1:ActivityInfo) : Boolean
      {
         if(this.checkTotalMoeny(param1))
         {
            return true;
         }
         if(this.checkOpenConsortiaLevel(param1))
         {
            return true;
         }
         if(this.checkOpenLove(param1))
         {
            return true;
         }
         if(this.checkOpenLevel(param1) || this.checkOpenFight(param1))
         {
            return true;
         }
         return false;
      }
      
      public function checkTotalMoeny(param1:ActivityInfo) : Boolean
      {
         if(param1.ActivityType == ActivityTypes.CHARGE && param1.ActivityChildType == ActivityChildTypes.OPEN_COMMON_ONCE)
         {
            return true;
         }
         return false;
      }
      
      public function checkOpenConsortiaLevel(param1:ActivityInfo) : Boolean
      {
         if(param1.ActivityType == ActivityTypes.CONSORTIA && param1.ActivityChildType == ActivityChildTypes.CONSORTIA_LEVEL)
         {
            return true;
         }
         return false;
      }
      
      public function checkOpenLove(param1:ActivityInfo) : Boolean
      {
         if(param1.ActivityType == ActivityTypes.MARRIED && param1.ActivityChildType == ActivityChildTypes.WEDDING_OPEN)
         {
            return true;
         }
         return false;
      }
      
      public function checkOpenLevel(param1:ActivityInfo) : Boolean
      {
         if(param1.ActivityType == ActivityTypes.CELEB && param1.ActivityChildType == ActivityChildTypes.LEVEL)
         {
            return true;
         }
         return false;
      }
      
      public function checkOpenFight(param1:ActivityInfo) : Boolean
      {
         if(param1.ActivityType == ActivityTypes.CELEB && param1.ActivityChildType == ActivityChildTypes.POWER)
         {
            return true;
         }
         return false;
      }
      
      public function checkMouthActivity(param1:ActivityInfo) : Boolean
      {
         if(param1.ActivityType == ActivityTypes.MONTH)
         {
            return true;
         }
         return false;
      }
      
      public function showFirstRechargeView() : void
      {
         if(this._complete)
         {
            if(!this._firstRechargeView)
            {
               this._firstRechargeView = ComponentFactory.Instance.creatCustomObject("ddtcalendar.ActivityFirstRechargeView");
            }
            this._firstRechargeView.show();
         }
         else
         {
            this._completeFun = this.showFirstRechargeView;
            this.loadUI();
         }
      }
      
      private function __onProgress(param1:UIModuleEvent) : void
      {
         UIModuleSmallLoading.Instance.progress = param1.loader.progress * 100;
      }
      
      public function setActivityExchange(param1:ActiveExchangeAnalyzer) : void
      {
         this._model.activeExchange = param1.list;
      }
      
      public function setActivityCondition(param1:ActivityConditionAnalyzer) : void
      {
         this._model.activityConditionArr = param1.list;
      }
      
      public function setActivityInfo(param1:ActivityInfoAnalyzer) : void
      {
         this._model.activityInfoArr = param1.list;
      }
      
      public function setActivityGiftbag(param1:ActivityGiftbagAnalyzer) : void
      {
         this._model.activityGiftbagArr = param1.list;
      }
      
      public function setActivityReward(param1:ActivityRewardAnalyzer) : void
      {
         this._model.activityRewards = param1.list;
      }
      
      public function getActivityInfoByID(param1:String) : ActivityInfo
      {
         var _loc2_:ActivityInfo = null;
         for each(_loc2_ in this._model.activityInfoArr)
         {
            if(_loc2_.ActivityId == param1)
            {
               return _loc2_;
            }
         }
         return null;
      }
      
      public function getActivityConditionByGiftbagID(param1:String) : Array
      {
         var _loc3_:ActivityConditionInfo = null;
         var _loc2_:Array = new Array();
         for each(_loc3_ in this._model.activityConditionArr)
         {
            if(_loc3_.GiftbagId == param1)
            {
               _loc2_.push(_loc3_);
            }
         }
         return _loc2_;
      }
      
      public function getAcitivityGiftBagByActID(param1:String) : Array
      {
         var _loc3_:ActivityGiftbagInfo = null;
         var _loc4_:Array = null;
         var _loc5_:ActivityGiftbagInfo = null;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc2_:Array = new Array();
         for each(_loc3_ in this._model.activityGiftbagArr)
         {
            if(_loc3_.ActivityId == param1)
            {
               _loc2_.push(_loc3_);
            }
         }
         _loc4_ = new Array();
         _loc6_ = 0;
         _loc7_ = 0;
         while(_loc7_ < _loc2_.length)
         {
            _loc8_ = _loc7_;
            while(_loc8_ < _loc2_.length)
            {
               if(_loc2_[_loc8_].GiftbagOrder < _loc2_[_loc7_].GiftbagOrder)
               {
                  _loc5_ = _loc2_[_loc7_];
                  _loc2_[_loc7_] = _loc2_[_loc8_];
                  _loc2_[_loc8_] = _loc5_;
               }
               _loc8_++;
            }
            _loc7_++;
         }
         return _loc2_;
      }
      
      public function getRewardsByGiftbagID(param1:String) : DictionaryData
      {
         var _loc3_:ActivityRewardInfo = null;
         var _loc2_:DictionaryData = new DictionaryData();
         for each(_loc3_ in this._model.activityRewards)
         {
            if(_loc3_.GiftbagId == param1)
            {
               _loc2_.add(_loc3_.TemplateId,_loc3_);
            }
         }
         return _loc2_;
      }
      
      public function getFirstRechargeAcitivty() : String
      {
         var _loc1_:String = null;
         var _loc2_:ActivityInfo = null;
         for each(_loc2_ in this._model.activityInfoArr)
         {
            if(_loc2_.ActivityType == ActivityTypes.CHARGE && _loc2_.ActivityChildType == ActivityChildTypes.OPEN_FIRST_ONCE)
            {
               _loc1_ = _loc2_.ActivityId;
            }
         }
         return _loc1_;
      }
      
      private function loadUI() : void
      {
         UIModuleSmallLoading.Instance.progress = 0;
         UIModuleSmallLoading.Instance.show();
         UIModuleSmallLoading.Instance.addEventListener(Event.CLOSE,this.__loadingClose);
         UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.__moduleComplete);
         UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.__onProgress);
         UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_ERROR,this.__moduleIOError);
         UIModuleLoader.Instance.addUIModuleImp(UIModuleTypes.ACTIVITY);
      }
      
      private function __moduleIOError(param1:UIModuleEvent) : void
      {
         if(param1.module == UIModuleTypes.ACTIVITY)
         {
            this._complete = true;
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.__moduleComplete);
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.__onProgress);
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_ERROR,this.__moduleIOError);
            UIModuleSmallLoading.Instance.removeEventListener(Event.CLOSE,this.__loadingClose);
            UIModuleSmallLoading.Instance.hide();
         }
      }
      
      private function __moduleComplete(param1:UIModuleEvent) : void
      {
         if(param1.module == UIModuleTypes.ACTIVITY)
         {
            this._complete = true;
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.__moduleComplete);
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.__onProgress);
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_ERROR,this.__moduleIOError);
            UIModuleSmallLoading.Instance.removeEventListener(Event.CLOSE,this.__loadingClose);
            UIModuleSmallLoading.Instance.hide();
            this._completeFun();
         }
      }
      
      private function __loadingClose(param1:Event) : void
      {
         UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.__moduleComplete);
         UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.__onProgress);
         UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_ERROR,this.__moduleIOError);
         UIModuleSmallLoading.Instance.removeEventListener(Event.CLOSE,this.__loadingClose);
         UIModuleSmallLoading.Instance.hide();
      }
      
      public function reciveActivityAward(param1:ActivityInfo, param2:String) : BaseLoader
      {
         this._reciveActive = param1;
         var _loc3_:ByteArray = new ByteArray();
         _loc3_.writeUTFBytes(param2);
         var _loc4_:URLVariables = RequestVairableCreater.creatWidthKey(true);
         var _loc5_:AccountInfo = PlayerManager.Instance.Account;
         var _loc6_:String = CrytoUtils.rsaEncry4(_loc5_.Key,_loc3_);
         _loc4_["activeKey"] = encodeURIComponent(_loc6_);
         _loc4_["activityId"] = this._reciveActive.ActivityId;
         var _loc7_:BaseLoader = LoadResourceManager.instance.createLoader(PathManager.solveRequestPath("ReleseActive.ashx"),BaseLoader.REQUEST_LOADER,_loc4_);
         _loc7_.addEventListener(LoaderEvent.LOAD_ERROR,this.__onLoadError);
         _loc7_.addEventListener(LoaderEvent.COMPLETE,this.__activityLoadComplete,false,99);
         LoadResourceManager.instance.startLoad(_loc7_,true);
         return _loc7_;
      }
      
      private function __activityLoadComplete(param1:LoaderEvent) : void
      {
         var _loc2_:BaseLoader = param1.currentTarget as BaseLoader;
         _loc2_.removeEventListener(LoaderEvent.LOAD_ERROR,this.__onLoadError);
         _loc2_.removeEventListener(LoaderEvent.COMPLETE,this.__activityLoadComplete);
         var _loc3_:XML = XML(param1.loader.content);
         if(String(_loc3_.@value) == "True")
         {
            if(this._reciveActive)
            {
               if(this._reciveActive.GetWay != 0)
               {
                  this._reciveActive.receiveNum = _loc3_.@receiveNum;
                  this.setData(this._reciveActive);
               }
            }
         }
         if(String(_loc3_.@message).length > 0)
         {
            MessageTipManager.getInstance().show(_loc3_.@message);
         }
      }
      
      private function __onLoadError(param1:LoaderEvent) : void
      {
         var _loc2_:BaseLoader = param1.currentTarget as BaseLoader;
         _loc2_.removeEventListener(LoaderEvent.LOAD_ERROR,this.__onLoadError);
         _loc2_.removeEventListener(LoaderEvent.COMPLETE,this.__activityLoadComplete);
      }
      
      private function __activeLogUpdate(param1:CrazyTankSocketEvent) : void
      {
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc10_:int = 0;
         var _loc11_:ActivityGiftbagRecord = null;
         var _loc12_:DictionaryData = null;
         var _loc13_:int = 0;
         var _loc14_:Boolean = false;
         var _loc15_:int = 0;
         var _loc16_:ActivityGiftbagRecord = null;
         var _loc17_:DictionaryData = null;
         var _loc18_:int = 0;
         var _loc19_:String = null;
         var _loc20_:ActivityTuanInfo = null;
         var _loc2_:PackageIn = param1.pkg;
         var _loc3_:String = _loc2_.readUTF();
         var _loc4_:int = _loc2_.readInt();
         var _loc5_:int = _loc2_.readInt();
         var _loc9_:ActivityInfo = this.getActivityInfoByID(_loc3_);
         if(this.checkOpenActivity(_loc9_) || this.checkFirstCharge(_loc9_))
         {
            if(_loc2_.readBoolean())
            {
               _loc6_ = _loc2_.readInt();
               _loc7_ = _loc2_.readInt();
               _loc8_ = _loc2_.readInt();
               this.model.addLog(_loc3_,_loc7_);
               this.model.addNowState(_loc3_,_loc8_);
               if(this.checkFirstCharge(_loc9_) || this.checkTotalMoeny(_loc9_))
               {
                  PlayerManager.Instance.Self.moneyOfCharge = _loc8_;
               }
            }
         }
         else if(_loc4_ == ActivityTypes.CHARGE)
         {
            if(_loc5_ == ActivityChildTypes.FISRT || _loc5_ == ActivityChildTypes.ONLY_ONE_TIME || this.checkChargeReward(_loc9_))
            {
               if(_loc2_.readBoolean())
               {
                  _loc6_ = _loc2_.readInt();
                  _loc7_ = _loc2_.readInt();
                  _loc8_ = _loc2_.readInt();
                  this.model.addLog(_loc3_,_loc7_);
                  this.model.addNowState(_loc3_,_loc8_);
                  PlayerManager.Instance.Self.moneyOfCharge = _loc8_;
                  _loc10_ = _loc2_.readInt();
                  _loc12_ = new DictionaryData();
                  _loc13_ = 0;
                  while(_loc13_ < _loc10_)
                  {
                     _loc11_ = new ActivityGiftbagRecord();
                     _loc11_.index = _loc2_.readInt();
                     _loc11_.value = _loc2_.readInt();
                     _loc12_.add(_loc11_.index,_loc11_);
                     _loc13_++;
                  }
                  this.model.addGiftbagRecord(_loc3_,_loc12_);
               }
            }
         }
         else if(_loc4_ == ActivityTypes.CONVERT)
         {
            _loc2_.readBoolean();
            _loc6_ = _loc2_.readInt();
         }
         else if(_loc4_ == ActivityTypes.COST)
         {
            _loc14_ = _loc2_.readBoolean();
            if(_loc5_ != ActivityChildTypes.TIMES)
            {
               if(_loc14_)
               {
                  _loc7_ = _loc2_.readInt();
                  _loc8_ = _loc2_.readInt();
                  this.model.addLog(_loc3_,_loc7_);
                  this.model.addNowState(_loc3_,_loc8_);
               }
            }
            else if(_loc5_ == ActivityChildTypes.TIMES)
            {
               if(_loc14_)
               {
                  _loc7_ = _loc2_.readInt();
               }
            }
            if(_loc14_)
            {
               _loc15_ = _loc2_.readInt();
               _loc17_ = new DictionaryData();
               _loc18_ = 0;
               while(_loc18_ < _loc15_)
               {
                  _loc16_ = new ActivityGiftbagRecord();
                  _loc16_.index = _loc2_.readInt();
                  _loc16_.value = _loc2_.readInt();
                  _loc17_.add(_loc16_.index,_loc16_);
                  _loc18_++;
               }
               this.model.addGiftbagRecord(_loc3_,_loc17_);
            }
         }
         else if(this.checkMouthActivity(_loc9_))
         {
            if(_loc2_.readBoolean())
            {
               _loc6_ = _loc2_.readInt();
               _loc19_ = _loc2_.readUTF();
            }
            this.model.addcondtionRecords(_loc3_,_loc19_);
         }
         else if(this.checkTuan(_loc9_))
         {
            _loc20_ = new ActivityTuanInfo();
            if(_loc2_.readBoolean())
            {
               _loc20_.activityID = _loc3_;
               _loc20_.alreadyMoney = _loc2_.readInt();
               _loc20_.alreadyCount = _loc2_.readInt();
               _loc20_.allCount = _loc2_.readInt();
               this.model.addTuanInfo(_loc3_,_loc20_);
            }
         }
         _loc9_.receiveNum = _loc6_;
         this.updateData(_loc9_);
      }
      
      public function checkCostReward(param1:ActivityInfo) : Boolean
      {
         if(param1.ActivityType == ActivityTypes.COST && (param1.ActivityChildType == ActivityChildTypes.COST_REWARD_TOTAL || param1.ActivityChildType == ActivityChildTypes.COST_REWARD_ONCE))
         {
            return true;
         }
         return false;
      }
      
      public function checkChargeReward(param1:ActivityInfo) : Boolean
      {
         if(param1.ActivityType == ActivityTypes.CHARGE && (param1.ActivityChildType == ActivityChildTypes.CHARGE_REWARD_TOTAL || param1.ActivityChildType == ActivityChildTypes.CHARGE_REWARD_ONCE))
         {
            return true;
         }
         return false;
      }
      
      public function checkTuan(param1:ActivityInfo) : Boolean
      {
         if(param1.ActivityType == ActivityTypes.TUAN)
         {
            return true;
         }
         return false;
      }
      
      public function sendBuyItem(param1:int, param2:String, param3:int, param4:int) : void
      {
         SocketManager.Instance.out.sendBuyItemInActivity(param1,param2,param3,param4);
      }
   }
}
