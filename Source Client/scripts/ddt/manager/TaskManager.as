package ddt.manager
{
   import SingleDungeon.event.SingleDungeonEvent;
   import com.pickgliss.action.ShowTipAction;
   import com.pickgliss.events.UIModuleEvent;
   import com.pickgliss.loader.BaseLoader;
   import com.pickgliss.loader.LoadResourceManager;
   import com.pickgliss.loader.UIModuleLoader;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.utils.ObjectUtils;
   import consortion.ConsortionModel;
   import ddt.data.BagInfo;
   import ddt.data.UIModuleTypes;
   import ddt.data.analyze.QuestListAnalyzer;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.data.player.SelfInfo;
   import ddt.data.quest.*;
   import ddt.events.BagEvent;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.events.PlayerPropertyEvent;
   import ddt.events.TaskEvent;
   import ddt.states.StateType;
   import ddt.utils.BitArray;
   import ddt.utils.RequestVairableCreater;
   import ddt.view.MainToolBar;
   import ddt.view.UIModuleSmallLoading;
   import exitPrompt.ExitPromptManager;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.MouseEvent;
   import flash.net.URLVariables;
   import flash.utils.ByteArray;
   import flash.utils.Dictionary;
   import pet.date.PetInfo;
   import platformapi.tencent.DiamondManager;
   import platformapi.tencent.DiamondType;
   import quest.TaskMainFrame;
   import quest.TaskModel;
   import road7th.comm.PackageIn;
   import road7th.data.DictionaryEvent;
   import road7th.utils.MovieClipWrapper;
   import trainer.data.ArrowType;
   import trainer.view.NewHandContainer;
   import tryonSystem.TryonSystemController;
   
   [Event(name="remove",type="tank.events.TaskEvent")]
   [Event(name="add",type="tank.events.TaskEvent")]
   [Event(name="changed",type="tank.events.TaskEvent")]
   public class TaskManager extends EventDispatcher
   {
      
      public static const GUIDE_QUEST_ID:int = 339;
      
      public static const COLLECT_INFO_EMAIL:int = 544;
      
      public static const COLLECT_INFO_CELLPHONE:int = 263;
      
      private static var _instance:TaskManager;
       
      
      private var _questDataInited:Boolean;
      
      private var _improve:QuestImproveInfo;
      
      private var _mainFrame:TaskMainFrame;
      
      private var _model:TaskModel;
      
      public var _getNewQuestMovie:MovieClipWrapper;
      
      private var _itemListenerArr:Vector.<int>;
      
      public var _friendListenerArr:Vector.<QuestCondition>;
      
      public var _annexListenerArr:Vector.<QuestCondition>;
      
      public var _desktopCond:QuestCondition;
      
      private var _showTipAction:ShowTipAction;
      
      private var _isPreLoadTask:Boolean;
      
      private var _preLoadCallBack:Function;
      
      private var _newTaskInfo:QuestInfo;
      
      public function TaskManager()
      {
         this._model = new TaskModel();
         super();
      }
      
      public static function get instance() : TaskManager
      {
         if(_instance == null)
         {
            _instance = new TaskManager();
         }
         return _instance;
      }
      
      public function get improve() : QuestImproveInfo
      {
         return this._improve;
      }
      
      public function get MainFrame() : TaskMainFrame
      {
         if(!this._mainFrame)
         {
            this._mainFrame = ComponentFactory.Instance.creat("QuestFrame");
         }
         return this._mainFrame;
      }
      
      public function get Model() : TaskModel
      {
         return this._model;
      }
      
      public function switchVisible() : void
      {
         if(this._model.isFirstshowTask)
         {
            this._model.isOpenViewFromNewQuest = false;
            this.moduleLoad();
            return;
         }
         if(!this._model.taskViewIsShow)
         {
            this.MainFrame.open();
            this._model.taskViewIsShow = true;
         }
         else
         {
            if(TryonSystemController.Instance.view != null)
            {
               return;
            }
            this._mainFrame.dispose();
            this._mainFrame = null;
            this._model.taskViewIsShow = false;
            dispatchEvent(new TaskEvent(TaskEvent.TASK_FRAME_HIDE));
            this.checkNewHandTask();
         }
      }
      
      public function showGetNewQuest() : void
      {
         if(this._getNewQuestMovie == null)
         {
            if(this._model.isFirstshowTask)
            {
               this._model.isOpenViewFromNewQuest = true;
               this.moduleLoad();
               return;
            }
            this._getNewQuestMovie = new MovieClipWrapper(ComponentFactory.Instance.creatCustomObject("core.quest.GetNewQuestMovie"),false,true);
            this._getNewQuestMovie.movie.buttonMode = true;
            this._getNewQuestMovie.movie.addEventListener(MouseEvent.CLICK,this.__newQuestClickHandler);
            this._getNewQuestMovie.movie.addEventListener(Event.ADDED_TO_STAGE,this.__addNewQuestMovieToStage);
            this._getNewQuestMovie.addEventListener(Event.COMPLETE,this.removeNewQuestMovie);
         }
      }
      
      private function __addNewQuestMovieToStage(param1:Event = null) : void
      {
         if(this._getNewQuestMovie)
         {
            this._getNewQuestMovie.movie.removeEventListener(Event.ADDED_TO_STAGE,this.__addNewQuestMovieToStage);
            this._getNewQuestMovie.play();
         }
      }
      
      public function removeNewQuestMovie(param1:Event = null) : void
      {
         if(this._getNewQuestMovie)
         {
            this._getNewQuestMovie.movie.removeEventListener(MouseEvent.CLICK,this.__newQuestClickHandler);
            this._getNewQuestMovie.removeEventListener(Event.COMPLETE,this.removeNewQuestMovie);
            ObjectUtils.disposeObject(this._getNewQuestMovie.movie);
            ObjectUtils.disposeObject(this._getNewQuestMovie);
            this._getNewQuestMovie = null;
            this._model.newQuestMovieIsPlaying = false;
            dispatchEvent(new TaskEvent(TaskEvent.NEW_TASK_SHOW,this._newTaskInfo));
         }
      }
      
      private function __newQuestClickHandler(param1:MouseEvent) : void
      {
         this._getNewQuestMovie.movie.removeEventListener(MouseEvent.CLICK,this.__newQuestClickHandler);
         if(this._showTipAction)
         {
            this._showTipAction.dispatcher.removeEventListener(MouseEvent.CLICK,this.__newQuestClickHandler);
            this._showTipAction.dispose();
            this._showTipAction = null;
         }
         if(StateManager.currentStateType == StateType.FIGHT_LIB_GAMEVIEW || StateManager.isInFight || StateManager.currentStateType == StateType.TRAINER1 || StateManager.currentStateType == StateType.TRAINER2 || StateManager.currentStateType == StateType.GAME_LOADING)
         {
            return;
         }
         if(!this._getNewQuestMovie.movie.visible)
         {
            this.removeNewQuestMovie();
            return;
         }
         this._getNewQuestMovie.movie.visible = false;
         if(!this._model.taskViewIsShow)
         {
            this.switchVisible();
         }
      }
      
      public function moduleLoad(param1:Boolean = false, param2:Function = null) : void
      {
         this._isPreLoadTask = param1;
         this._preLoadCallBack = param2;
         UIModuleSmallLoading.Instance.progress = 0;
         if(!this._isPreLoadTask)
         {
            UIModuleSmallLoading.Instance.show();
         }
         UIModuleSmallLoading.Instance.addEventListener(Event.CLOSE,this.__onClose);
         UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.__onTaskLoadProgress);
         UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.__onTaskLoadComplete);
         UIModuleLoader.Instance.addUIModuleImp(UIModuleTypes.QUEST);
      }
      
      private function __onTaskLoadComplete(param1:UIModuleEvent) : void
      {
         if(param1.module == UIModuleTypes.QUEST)
         {
            this._model.isFirstshowTask = false;
            if(!this._isPreLoadTask)
            {
               if(this._model.isOpenViewFromNewQuest)
               {
                  this.showGetNewQuest();
               }
               else
               {
                  this.switchVisible();
                  if(this._model.showQuestInfo)
                  {
                     this.showQuest(this._model.showQuestInfo,this._model.showQuestType);
                  }
               }
            }
            UIModuleSmallLoading.Instance.hide();
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.__onTaskLoadComplete);
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.__onTaskLoadProgress);
            UIModuleSmallLoading.Instance.removeEventListener(Event.CLOSE,this.__onClose);
            if(null != this._preLoadCallBack)
            {
               this._preLoadCallBack();
               this._isPreLoadTask = false;
            }
         }
      }
      
      private function __onTaskLoadProgress(param1:UIModuleEvent) : void
      {
         if(param1.module == UIModuleTypes.QUEST)
         {
            UIModuleSmallLoading.Instance.progress = param1.loader.progress * 100;
         }
      }
      
      private function __onClose(param1:Event) : void
      {
         UIModuleSmallLoading.Instance.hide();
         UIModuleSmallLoading.Instance.removeEventListener(Event.CLOSE,this.__onClose);
         UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.__onTaskLoadComplete);
         UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.__onTaskLoadProgress);
      }
      
      public function setup(param1:QuestListAnalyzer) : void
      {
         this._model.allQuests = param1.list;
         this.getConsortionTaskReward();
         this._questDataInited = false;
         this._improve = this.getImproveArray(param1.improveXml);
         this.addEvents();
         this.setSavePointTask();
      }
      
      public function reloadNewQuest(param1:QuestListAnalyzer) : void
      {
         var _loc3_:QuestInfo = null;
         var _loc2_:Dictionary = param1.list;
         for each(_loc3_ in _loc2_)
         {
            if(this.getQuestByID(_loc3_.id) == null)
            {
               this.addQuest(_loc3_);
            }
         }
      }
      
      public function addQuest(param1:QuestInfo) : void
      {
         this.allQuests[param1.Id] = param1;
      }
      
      private function setSavePointTask() : void
      {
         var _loc1_:QuestInfo = null;
         for each(_loc1_ in this.allQuests)
         {
            if(_loc1_.LimitNodes > 0)
            {
               this.savePointTask.push(_loc1_);
            }
         }
      }
      
      private function addEvents() : void
      {
         this._model.addEventListener(TaskEvent.VIEW_SHOW_CHANGE,this.__taskViewShowHandler);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.QUEST_UPDATE,this.__updateAcceptedTask);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.QUEST_FINISH,this.__questFinish);
      }
      
      private function getConsortionTaskReward() : void
      {
         this.getConsortionTaskRewardByLevel(ConsortionModel.TASKLEVELI);
         this.getConsortionTaskRewardByLevel(ConsortionModel.TASKLEVELII);
         this.getConsortionTaskRewardByLevel(ConsortionModel.TASKLEVELIII);
         this.getConsortionTaskRewardByLevel(ConsortionModel.TASKLEVELIV);
      }
      
      private function getConsortionTaskRewardByLevel(param1:int) : void
      {
         var _loc2_:QuestInfo = null;
         for each(_loc2_ in this._model.allQuests)
         {
            if(_loc2_.Type == 9)
            {
               if(_loc2_.otherCondition == param1)
               {
                  switch(param1)
                  {
                     case ConsortionModel.TASKLEVELI:
                        ConsortionModel.TaskRewardSontribution1 = _loc2_.RewardOffer;
                        ConsortionModel.TaskRewardExp1 = _loc2_.RewardConsortiaGP;
                        break;
                     case ConsortionModel.TASKLEVELII:
                        ConsortionModel.TaskRewardSontribution2 = _loc2_.RewardOffer;
                        ConsortionModel.TaskRewardExp2 = _loc2_.RewardConsortiaGP;
                        break;
                     case ConsortionModel.TASKLEVELIII:
                        ConsortionModel.TaskRewardSontribution3 = _loc2_.RewardOffer;
                        ConsortionModel.TaskRewardExp3 = _loc2_.RewardConsortiaGP;
                        break;
                     case ConsortionModel.TASKLEVELIV:
                        ConsortionModel.TaskRewardSontribution4 = _loc2_.RewardOffer;
                        ConsortionModel.TaskRewardExp4 = _loc2_.RewardConsortiaGP;
                  }
                  break;
               }
            }
         }
      }
      
      private function __taskViewShowHandler(param1:TaskEvent) : void
      {
         if(!this._model.taskViewIsShow)
         {
            this._mainFrame = null;
         }
      }
      
      private function getImproveArray(param1:XML) : QuestImproveInfo
      {
         var _loc2_:QuestImproveInfo = new QuestImproveInfo();
         _loc2_.bindMoneyRate = String(param1.@BindMoneyRate).split("|");
         _loc2_.expRate = String(param1.@ExpRate).split("|");
         _loc2_.goldRate = String(param1.@GoldRate).split("|");
         _loc2_.exploitRate = String(param1.@ExploitRate).split("|");
         _loc2_.canOneKeyFinishTime = Number(param1.@CanOneKeyFinishTime);
         return _loc2_;
      }
      
      private function loadQuestLog(param1:ByteArray) : void
      {
         param1.position = 0;
         if(this._model.questLog == null)
         {
            this._model.questLog = new BitArray();
         }
         var _loc2_:int = 0;
         while(_loc2_ < param1.length)
         {
            this._model.questLog.writeByte(param1.readByte());
            _loc2_++;
         }
      }
      
      private function IsQuestFinish(param1:int) : Boolean
      {
         if(!this._model.questLog)
         {
            return false;
         }
         if(param1 > this._model.questLog.length * 8 || param1 < 1)
         {
            return false;
         }
         param1--;
         var _loc2_:int = param1 / 8;
         var _loc3_:int = param1 % 8;
         var _loc4_:int = this._model.questLog[_loc2_] & 1 << _loc3_;
         return _loc4_ != 0;
      }
      
      public function get allQuests() : Dictionary
      {
         if(!this._model.allQuests)
         {
            this._model.allQuests = new Dictionary();
         }
         return this._model.allQuests;
      }
      
      public function set allQuests(param1:Dictionary) : void
      {
         this._model.allQuests = param1;
      }
      
      public function get savePointTask() : Vector.<QuestInfo>
      {
         if(!this._model.savePointTask)
         {
            this._model.savePointTask = new Vector.<QuestInfo>();
         }
         return this._model.savePointTask;
      }
      
      public function getQuestByID(param1:int) : QuestInfo
      {
         if(!this.allQuests)
         {
            return null;
         }
         return this.allQuests[param1];
      }
      
      public function getQuestDataByID(param1:int) : QuestDataInfo
      {
         if(!this.getQuestByID(param1))
         {
            return null;
         }
         return this.getQuestByID(param1).data;
      }
      
      public function getAvailableQuests(param1:int = -1, param2:Boolean = true) : QuestCategory
      {
         var _loc4_:QuestInfo = null;
         var _loc3_:QuestCategory = new QuestCategory();
         for each(_loc4_ in this.allQuests)
         {
            if(_loc4_.Type == 8)
            {
            }
            if(_loc4_.id == 914)
            {
            }
            if(param1 > -1)
            {
               if(param1 == 0)
               {
                  if(_loc4_.Type != 0)
                  {
                     continue;
                  }
               }
               else if(param1 == 1)
               {
                  if(_loc4_.Type != 4 && _loc4_.Type != 1 && _loc4_.Type != 6 && _loc4_.Type != 8)
                  {
                     continue;
                  }
               }
               else if(param1 == 2)
               {
                  if(_loc4_.id == 901)
                  {
                     continue;
                  }
                  if(_loc4_.Type != 2 && _loc4_.Type < 100)
                  {
                     continue;
                  }
               }
               else if(param1 == 3)
               {
                  if(_loc4_.Type != 3)
                  {
                     continue;
                  }
               }
               else if(param1 == 4)
               {
                  if(_loc4_.Type != 7)
                  {
                     continue;
                  }
               }
               else if(param1 == 5)
               {
                  if(!_loc4_.data || _loc4_.Type != 9)
                  {
                     continue;
                  }
               }
               else if(param1 == 8)
               {
                  if(_loc4_.Type != 8)
                  {
                     continue;
                  }
               }
            }
            if(_loc4_.LimitNodes > 0)
            {
               if(PlayerManager.Instance.Self.Sex)
               {
                  if(_loc4_.QuestID > 100)
                  {
                     continue;
                  }
               }
               else if(_loc4_.QuestID < 100)
               {
                  continue;
               }
            }
            if(param2 && _loc4_.data && !_loc4_.data.isExist)
            {
               this.requestQuest(_loc4_);
            }
            else if(this.isAvailableQuest(_loc4_,true))
            {
               if(_loc4_.isCompleted)
               {
                  _loc3_.addCompleted(_loc4_);
               }
               else if(_loc4_.data && _loc4_.data.isNew)
               {
                  _loc3_.addNew(_loc4_);
               }
               else
               {
                  _loc3_.addQuest(_loc4_);
               }
            }
         }
         return _loc3_;
      }
      
      public function get allAvailableQuests() : Array
      {
         return this.getAvailableQuests(-1,false).list;
      }
      
      public function get allCurrentQuest() : Array
      {
         return this.getAvailableQuests(-1,true).list;
      }
      
      public function get mainQuests() : Array
      {
         return this.getAvailableQuests(0,true).list;
      }
      
      public function get sideQuests() : Array
      {
         return this.getAvailableQuests(1,true).list;
      }
      
      public function get dailyQuests() : Array
      {
         return this.getAvailableQuests(2,true).list;
      }
      
      public function get texpQuests() : Array
      {
         var _loc2_:QuestInfo = null;
         var _loc1_:QuestCategory = new QuestCategory();
         for each(_loc2_ in this.allQuests)
         {
            if(_loc2_.Type >= 100)
            {
               if(_loc2_.data && !_loc2_.data.isExist)
               {
                  this.requestQuest(_loc2_);
               }
               else if(this.isAvailableQuest(_loc2_,true))
               {
                  if(_loc2_.isCompleted)
                  {
                     _loc1_.addCompleted(_loc2_);
                  }
                  else if(_loc2_.data && _loc2_.data.isNew)
                  {
                     _loc1_.addNew(_loc2_);
                  }
                  else
                  {
                     _loc1_.addQuest(_loc2_);
                  }
               }
            }
         }
         return _loc1_.list;
      }
      
      public function getPetMagicTask(param1:PetInfo) : QuestInfo
      {
         var _loc3_:QuestInfo = null;
         var _loc2_:Array = this.getAvailableQuests(8,true).list;
         for each(_loc3_ in _loc2_)
         {
            if(_loc3_.id % 10 == param1.KindID)
            {
               return _loc3_;
            }
         }
         return null;
      }
      
      public function getTaskData(param1:int) : QuestDataInfo
      {
         if(this.getQuestByID(param1))
         {
            return this.getQuestByID(param1).data;
         }
         return null;
      }
      
      private function isAvailableQuest(param1:QuestInfo, param2:Boolean = false) : Boolean
      {
         var _loc5_:int = 0;
         var _loc6_:Array = null;
         var _loc7_:int = 0;
         var _loc8_:QuestInfo = null;
         var _loc3_:Array = PathManager.DISABLE_TASK_ID;
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_.length)
         {
            if(param1.id == parseInt(_loc3_[_loc4_]))
            {
               return false;
            }
            _loc4_++;
         }
         if(param1.disabled)
         {
            return false;
         }
         if(param1.Type <= 100)
         {
            _loc5_ = PlayerManager.Instance.Self.Grade;
            if(param1.NeedMinLevel > _loc5_ || param1.NeedMaxLevel < _loc5_)
            {
               return false;
            }
         }
         if(param1.PreQuestID != "0,")
         {
            _loc6_ = new Array();
            _loc6_ = param1.PreQuestID.split(",");
            for each(_loc7_ in _loc6_)
            {
               if(_loc7_ != 0)
               {
                  if(this.getQuestByID(_loc7_))
                  {
                     _loc8_ = this.getQuestByID(_loc7_);
                     if(!_loc8_)
                     {
                        return false;
                     }
                     if(!this.isAchieved(_loc8_))
                     {
                        return false;
                     }
                  }
               }
            }
         }
         if(!(this.isValidateByDate(param1) && this.isAvailableByGuild(param1) && this.isAvailableByMarry(param1)))
         {
            return false;
         }
         if(param1.Type <= 100 && this.haveLog(param1))
         {
            return false;
         }
         if(!param1.isAvailable)
         {
            return false;
         }
         if(param1.data == null || !param1.data.isExist && param1.CanRepeat)
         {
            this.requestQuest(param1);
            if(param2 && param1.Type != 4)
            {
               return false;
            }
         }
         if(param1.Type == 8)
         {
            return this.checkPetMagic(param1);
         }
         if(param1.otherCondition == 100)
         {
            return DiamondManager.instance.pfType == DiamondType.BLUE_DIAMOND;
         }
         return true;
      }
      
      private function checkPetMagic(param1:QuestInfo) : Boolean
      {
         var _loc2_:Array = PetInfoManager.instance.getNeedMagicPets();
         var _loc3_:int = param1.id % 10;
         return _loc2_.indexOf(_loc3_) > -1;
      }
      
      public function isAchieved(param1:QuestInfo) : Boolean
      {
         if(param1.isAchieved)
         {
            return true;
         }
         if(!param1.CanRepeat)
         {
            if(this.IsQuestFinish(param1.Id))
            {
               return true;
            }
         }
         return false;
      }
      
      public function isCompleted(param1:QuestInfo) : Boolean
      {
         if(param1.isCompleted)
         {
            return true;
         }
         return false;
      }
      
      public function isAvailable(param1:QuestInfo) : Boolean
      {
         if(!param1)
         {
            return false;
         }
         return this.isAvailableQuest(param1) && !param1.isCompleted;
      }
      
      private function haveLog(param1:QuestInfo) : Boolean
      {
         if(param1.CanRepeat)
         {
            if(param1.data && param1.data.repeatLeft == 0)
            {
               return true;
            }
            return false;
         }
         if(this.IsQuestFinish(param1.Id))
         {
            return true;
         }
         return false;
      }
      
      public function isValidateByDate(param1:QuestInfo) : Boolean
      {
         if(!param1)
         {
            return false;
         }
         return !param1.isTimeOut();
      }
      
      public function isAvailableByGuild(param1:QuestInfo) : Boolean
      {
         if(!param1)
         {
            return false;
         }
         return param1.otherCondition != 1 || PlayerManager.Instance.Self.ConsortiaID != 0;
      }
      
      public function isAvailableByMarry(param1:QuestInfo) : Boolean
      {
         if(!param1)
         {
            return false;
         }
         return param1.otherCondition != 2 || PlayerManager.Instance.Self.IsMarried;
      }
      
      private function __updateAcceptedTask(param1:CrazyTankSocketEvent) : void
      {
         var _loc5_:int = 0;
         var _loc6_:QuestInfo = null;
         var _loc7_:QuestDataInfo = null;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         var _loc10_:int = 0;
         var _loc11_:int = 0;
         var _loc2_:PackageIn = param1.pkg;
         var _loc3_:int = _loc2_.readInt();
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_)
         {
            _loc5_ = _loc2_.readInt();
            _loc6_ = new QuestInfo();
            if(this.getQuestByID(_loc5_))
            {
               _loc6_ = this.getQuestByID(_loc5_);
               if(_loc6_.data)
               {
                  _loc7_ = _loc6_.data;
               }
               else
               {
                  _loc7_ = new QuestDataInfo(_loc5_);
                  if(_loc6_.required)
                  {
                     _loc7_.isNew = true;
                  }
               }
               _loc7_.isAchieved = _loc2_.readBoolean();
               _loc8_ = _loc2_.readInt();
               _loc9_ = _loc2_.readInt();
               _loc10_ = _loc2_.readInt();
               _loc11_ = _loc2_.readInt();
               _loc7_.setProgress(_loc8_,_loc9_,_loc10_,_loc11_);
               _loc7_.CompleteDate = _loc2_.readDate();
               _loc7_.repeatLeft = _loc2_.readInt();
               _loc7_.quality = _loc2_.readInt();
               _loc7_.isExist = _loc2_.readBoolean();
               _loc6_.QuestLevel = _loc2_.readInt();
               _loc6_.data = _loc7_;
               if(_loc7_.isNew)
               {
                  this.addNewQuest(_loc6_);
               }
               dispatchEvent(new TaskEvent(TaskEvent.CHANGED,_loc6_,_loc7_));
            }
            _loc4_++;
         }
         this.loadQuestLog(_loc2_.readByteArray());
         this._questDataInited = true;
         this.checkHighLight();
      }
      
      private function addNewQuest(param1:QuestInfo) : void
      {
         if(!this._model.newQuests)
         {
            this._model.newQuests = new Vector.<QuestInfo>();
         }
         if(this._model.newQuests.indexOf(param1) == -1 && !this._model.newQuestMovieIsPlaying)
         {
            this.showGetNewQuest();
            this._newTaskInfo = param1;
         }
         this._model.newQuests.push(param1);
      }
      
      private function __questFinish(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:PackageIn = param1.pkg;
         var _loc3_:int = _loc2_.readInt();
         this.onFinishQuest(_loc3_);
      }
      
      private function onFinishQuest(param1:int) : void
      {
         var _loc2_:QuestInfo = this.getQuestByID(param1);
         if(_loc2_.isAvailable || _loc2_.NextQuestID)
         {
            this.requestCanAcceptTask();
         }
         dispatchEvent(new TaskEvent(TaskEvent.FINISH,_loc2_,_loc2_.data));
      }
      
      public function jumpToQuest(param1:QuestInfo) : void
      {
         this._model.selectedQuest = param1;
         this.MainFrame.jumpToQuest(param1);
      }
      
      public function showQuest(param1:QuestInfo, param2:int) : void
      {
         this._model.showQuestInfo = param1;
         if(this._model.isFirstshowTask)
         {
            this._model.isOpenViewFromNewQuest = false;
            this._model.showQuestType = param2;
            this.moduleLoad();
            return;
         }
         if(!this._model.taskViewIsShow)
         {
            this.MainFrame.open();
            this._model.taskViewIsShow = true;
         }
         this._model.selectedQuest = param1;
         this.MainFrame.showQuestTask(param1,param2);
         this._model.showQuestInfo = null;
      }
      
      public function onGuildUpdate() : void
      {
         this.checkHighLight();
      }
      
      public function finshMarriage() : void
      {
         var _loc1_:QuestInfo = null;
         var _loc2_:QuestDataInfo = null;
         for each(_loc1_ in this.allQuests)
         {
            _loc2_ = _loc1_.data;
            if(_loc2_)
            {
               if(!_loc2_.isAchieved)
               {
                  if(_loc1_.Condition == 21)
                  {
                     this.showTaskHightLight();
                  }
               }
            }
         }
         this.requestCanAcceptTask();
      }
      
      public function requestCanAcceptTask() : void
      {
         var _loc2_:Array = null;
         var _loc3_:QuestInfo = null;
         var _loc1_:Array = this.allAvailableQuests;
         if(_loc1_.length != 0)
         {
            _loc2_ = new Array();
            for each(_loc3_ in _loc1_)
            {
               if(_loc3_.Type <= 100)
               {
                  if(!(_loc3_.data && _loc3_.data.isExist))
                  {
                     _loc2_.push(_loc3_.QuestID);
                     if(this._questDataInited)
                     {
                        _loc3_.required = true;
                     }
                  }
               }
            }
            this.socketSendQuestAdd(_loc2_);
         }
      }
      
      public function requestQuest(param1:QuestInfo) : void
      {
         if(param1.Type == 9)
         {
            return;
         }
         if(StateManager.currentStateType == StateType.LOGIN)
         {
            return;
         }
         if(param1.Type > 100)
         {
            return;
         }
         var _loc2_:Array = new Array();
         _loc2_.push(param1.QuestID);
         if(this._questDataInited)
         {
            param1.required = true;
         }
         this.socketSendQuestAdd(_loc2_);
      }
      
      public function requestClubTask() : void
      {
         var _loc2_:QuestInfo = null;
         var _loc1_:Array = new Array();
         for each(_loc2_ in this.allAvailableQuests)
         {
            if(_loc2_.otherCondition == 1)
            {
               if(this.isAvailableQuest(_loc2_))
               {
                  _loc1_.push(_loc2_.QuestID);
               }
            }
         }
         if(_loc1_.length > 0)
         {
            this.socketSendQuestAdd(_loc1_);
         }
      }
      
      public function addItemListener(param1:int) : void
      {
         if(!this._itemListenerArr)
         {
            this._itemListenerArr = new Vector.<int>();
         }
         this._itemListenerArr.push(param1);
         var _loc2_:SelfInfo = PlayerManager.Instance.Self;
         _loc2_.getBag(BagInfo.EQUIPBAG).addEventListener(BagEvent.UPDATE,this.__onBagUpdate);
         _loc2_.getBag(BagInfo.PROPBAG).addEventListener(BagEvent.UPDATE,this.__onBagUpdate);
      }
      
      private function __onBagUpdate(param1:BagEvent) : void
      {
         var _loc2_:InventoryItemInfo = null;
         var _loc3_:int = 0;
         for each(_loc2_ in param1.changedSlots)
         {
            for each(_loc3_ in this._itemListenerArr)
            {
               if(_loc3_ == _loc2_.TemplateID)
               {
                  this.checkHighLight();
               }
            }
         }
      }
      
      public function addGradeListener() : void
      {
         PlayerManager.Instance.Self.addEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,this.__onPlayerPropertyChange);
      }
      
      private function __onPlayerPropertyChange(param1:PlayerPropertyEvent) : void
      {
         if(param1.changedProperties["Grade"])
         {
            this.checkHighLight();
         }
      }
      
      public function addAnnexListener(param1:QuestCondition) : void
      {
         if(!this._annexListenerArr)
         {
            this._annexListenerArr = new Vector.<QuestCondition>();
         }
         this._annexListenerArr.push(param1);
      }
      
      public function addDesktopListener(param1:QuestCondition) : void
      {
         this._desktopCond = param1;
         if(DesktopManager.Instance.isDesktop)
         {
            this.checkQuest(this._desktopCond.questID,this._desktopCond.ConID,0);
         }
      }
      
      public function onDesktopApp() : void
      {
         if(this._desktopCond)
         {
            this.checkQuest(this._desktopCond.questID,this._desktopCond.ConID,0);
         }
      }
      
      public function onSendAnnex(param1:Array) : void
      {
         var _loc2_:InventoryItemInfo = null;
         var _loc3_:QuestCondition = null;
         for each(_loc2_ in param1)
         {
            for each(_loc3_ in this._annexListenerArr)
            {
               if(_loc3_.param2 == _loc2_.TemplateID)
               {
                  if(this.isAvailableQuest(this.getQuestByID(_loc3_.questID),true))
                  {
                     this.checkQuest(_loc3_.questID,_loc3_.ConID,0);
                  }
               }
            }
         }
      }
      
      public function addFriendListener(param1:QuestCondition) : void
      {
         if(!this._friendListenerArr)
         {
            this._friendListenerArr = new Vector.<QuestCondition>();
         }
         this._friendListenerArr.push(param1);
         PlayerManager.Instance.addEventListener(PlayerManager.FRIENDLIST_COMPLETE,this.__onFriendListComplete);
         addEventListener(TaskEvent.CHANGED,this.__onQuestChange);
      }
      
      private function __onQuestChange(param1:TaskEvent) : void
      {
         var _loc2_:QuestCondition = null;
         for each(_loc2_ in this._friendListenerArr)
         {
            if(param1.info.Id == _loc2_.questID)
            {
               this.checkQuest(_loc2_.questID,_loc2_.ConID,_loc2_.param2 - PlayerManager.Instance.friendList.length);
            }
         }
      }
      
      private function __onFriendListComplete(param1:Event) : void
      {
         var _loc2_:QuestCondition = null;
         PlayerManager.Instance.friendList.addEventListener(DictionaryEvent.ADD,this.__onFriendListUpdated);
         PlayerManager.Instance.friendList.addEventListener(DictionaryEvent.REMOVE,this.__onFriendListUpdated);
         for each(_loc2_ in this._friendListenerArr)
         {
            this.checkQuest(_loc2_.questID,_loc2_.ConID,_loc2_.param2 - PlayerManager.Instance.friendList.length);
         }
      }
      
      private function __onFriendListUpdated(param1:DictionaryEvent) : void
      {
         var _loc2_:QuestCondition = null;
         for each(_loc2_ in this._friendListenerArr)
         {
            this.checkQuest(_loc2_.questID,_loc2_.ConID,_loc2_.param2 - PlayerManager.Instance.friendList.length);
         }
      }
      
      public function sendQuestFinish(param1:uint) : void
      {
         SocketManager.Instance.out.sendQuestFinish(param1,this._model.itemAwardSelected);
         this.questFinishHook(param1);
      }
      
      private function questFinishHook(param1:uint) : void
      {
         var _loc2_:Number = NaN;
         var _loc3_:URLVariables = null;
         var _loc4_:BaseLoader = null;
         switch(param1)
         {
            case COLLECT_INFO_EMAIL:
               _loc2_ = PlayerManager.Instance.Self.ID;
               _loc3_ = RequestVairableCreater.creatWidthKey(true);
               _loc3_["selfid"] = _loc2_;
               _loc3_["url"] = PathManager.solveLogin();
               _loc3_["nickname"] = PlayerManager.Instance.Self.NickName;
               _loc3_["rnd"] = Math.random();
               _loc4_ = LoadResourceManager.instance.createLoader(PathManager.solveRequestPath("SendMailGameUrl.ashx"),BaseLoader.REQUEST_LOADER,_loc3_);
               LoadResourceManager.instance.startLoad(_loc4_);
         }
      }
      
      public function checkQuest(param1:int, param2:int, param3:int) : void
      {
         SocketManager.Instance.out.sendQuestCheck(param1,param2,param3);
      }
      
      private function socketSendQuestAdd(param1:Array) : void
      {
         var _loc4_:QuestInfo = null;
         var _loc2_:Array = new Array();
         var _loc3_:uint = 0;
         while(_loc3_ < param1.length)
         {
            _loc4_ = this.getQuestByID(param1[_loc3_]);
            if(_loc4_.Type < 2 || _loc4_.Type == 8)
            {
               _loc2_.push(_loc4_.id);
            }
            _loc3_++;
         }
         SocketManager.Instance.out.sendQuestAdd(_loc2_);
      }
      
      public function checkNewHandTask() : void
      {
         if(SavePointManager.Instance.isInSavePoint(32))
         {
            this.showDialog(43);
         }
         if(SavePointManager.Instance.isInSavePoint(36))
         {
            this.showDialog(15);
         }
         if(SavePointManager.Instance.isInSavePoint(38))
         {
            this.showDialog(22);
         }
         if(SavePointManager.Instance.isInSavePoint(39))
         {
            this.showDialog(23);
         }
         if(SavePointManager.Instance.isInSavePoint(40))
         {
            this.showDialog(24);
         }
         if(SavePointManager.Instance.isInSavePoint(41))
         {
            this.showDialog(44);
         }
         if(SavePointManager.Instance.isInSavePoint(42))
         {
            this.showDialog(25);
         }
         if(SavePointManager.Instance.isInSavePoint(24))
         {
            this.showDialog(28);
         }
         if(SavePointManager.Instance.isInSavePoint(43))
         {
            this.showDialog(45);
         }
         if(SavePointManager.Instance.isInSavePoint(49))
         {
            dispatchEvent(new TaskEvent(TaskEvent.BUILDING_REFLASH));
         }
         if(SavePointManager.Instance.isInSavePoint(20))
         {
            if(TaskManager.instance.isNewHandTaskAchieved(15) && TaskManager.instance.isNewHandTaskAchieved(16))
            {
               this.showDialog(49);
            }
         }
         if(SavePointManager.Instance.isInSavePoint(51))
         {
            if(TaskManager.instance.isNewHandTaskAchieved(14))
            {
               this.showDialog(48);
            }
         }
         if(SavePointManager.Instance.isInSavePoint(52))
         {
            if(TaskManager.instance.isNewHandTaskAchieved(17))
            {
               this.showDialog(50);
            }
         }
         if(SavePointManager.Instance.isInSavePoint(53))
         {
            if(TaskManager.instance.isNewHandTaskAchieved(18))
            {
               this.showDialog(51);
            }
         }
         if(SavePointManager.Instance.isInSavePoint(54))
         {
            if(TaskManager.instance.isNewHandTaskAchieved(22))
            {
               this.showDialog(29);
            }
         }
         if(SavePointManager.Instance.isInSavePoint(63))
         {
            if(TaskManager.instance.isNewHandTaskAchieved(10))
            {
               this.showDialog(18);
            }
         }
         if(SavePointManager.Instance.isInSavePoint(66))
         {
            this.showDialog(53);
         }
         if(SavePointManager.Instance.isInSavePoint(10) && TaskManager.instance.isNewHandTaskAchieved(7))
         {
            dispatchEvent(new TaskEvent(TaskEvent.BUILDING_REFLASH));
         }
         if(TaskManager.instance.isNewHandTaskAchieved(10) && SavePointManager.Instance.isInSavePoint(15))
         {
            if(StateManager.currentStateType == StateType.ROOM_LIST)
            {
               TaskManager.instance.dispatchEvent(new TaskEvent(TaskEvent.SHOW_ARROW));
            }
         }
         if(TaskManager.instance.isNewHandTaskAchieved(14) && TaskManager.instance.isNewHandTaskAchieved(13) && SavePointManager.Instance.isInSavePoint(19))
         {
            if(StateManager.currentStateType == StateType.ROOM_LIST)
            {
               TaskManager.instance.dispatchEvent(new TaskEvent(TaskEvent.SHOW_ARROW));
            }
         }
         if(TaskManager.instance.isNewHandTaskAchieved(22) && SavePointManager.Instance.isInSavePoint(26))
         {
            if(StateManager.currentStateType == StateType.SINGLEDUNGEON)
            {
               TaskManager.instance.dispatchEvent(new TaskEvent(TaskEvent.SHOW_ARROW));
            }
         }
         if(SavePointManager.Instance.isInSavePoint(73))
         {
            this.showDialog(52);
         }
         if(SavePointManager.Instance.isInSavePoint(74))
         {
            this.showDialog(56);
         }
         if((SavePointManager.Instance.isInSavePoint(15) || SavePointManager.Instance.isInSavePoint(19) || SavePointManager.Instance.isInSavePoint(26)) && StateManager.currentStateType == StateType.MATCH_ROOM)
         {
            NewHandContainer.Instance.showArrow(ArrowType.EXIT_MATCHROOM,-45,"trainer.exitMatchRoomArrowPos","","",LayerManager.Instance.getLayerByType(LayerManager.GAME_UI_LAYER));
         }
         if(TaskManager.instance.isNewHandTaskAchieved(11) && SavePointManager.Instance.isInSavePoint(16))
         {
            if(StateManager.currentStateType == StateType.SHOP)
            {
               TaskManager.instance.dispatchEvent(new TaskEvent(TaskEvent.SHOW_ARROW));
            }
         }
         if(TaskManager.instance.isNewHandTaskAchieved(21) && SavePointManager.Instance.isInSavePoint(25))
         {
            if(StateManager.currentStateType == StateType.FARM)
            {
               TaskManager.instance.dispatchEvent(new TaskEvent(TaskEvent.SHOW_ARROW));
            }
         }
         if(StateManager.currentStateType == StateType.MAIN)
         {
            TaskManager.instance.dispatchEvent(new TaskEvent(TaskEvent.TASK_FRAME_HIDE));
         }
      }
      
      private function showDialog(param1:uint) : void
      {
         LayerManager.Instance.addToLayer(DialogManager.Instance.DialogBox,LayerManager.STAGE_TOP_LAYER);
         DialogManager.Instance.addEventListener(Event.COMPLETE,this.__dialogEndCallBack);
         DialogManager.Instance.showDialog(param1);
      }
      
      private function __dialogEndCallBack(param1:Event) : void
      {
         DialogManager.Instance.removeEventListener(Event.COMPLETE,this.__dialogEndCallBack);
         if(SavePointManager.Instance.isInSavePoint(32))
         {
            SavePointManager.Instance.setSavePoint(32);
            MainToolBar.Instance.tipTask();
         }
         if(SavePointManager.Instance.isInSavePoint(36))
         {
            SavePointManager.Instance.setSavePoint(36);
            SingleDungeonEvent.dispatcher.dispatchEvent(new SingleDungeonEvent(SingleDungeonEvent.FRAME_EXIT,"reflash"));
            dispatchEvent(new TaskEvent(TaskEvent.BUILDING_REFLASH));
         }
         if(SavePointManager.Instance.isInSavePoint(40))
         {
            SavePointManager.Instance.setSavePoint(40);
            SingleDungeonEvent.dispatcher.dispatchEvent(new SingleDungeonEvent(SingleDungeonEvent.FRAME_EXIT,"reflash"));
            dispatchEvent(new TaskEvent(TaskEvent.BUILDING_REFLASH));
         }
         if(SavePointManager.Instance.isInSavePoint(41))
         {
            SavePointManager.Instance.setSavePoint(41);
            SingleDungeonEvent.dispatcher.dispatchEvent(new SingleDungeonEvent(SingleDungeonEvent.FRAME_EXIT,"reflash"));
            dispatchEvent(new TaskEvent(TaskEvent.BUILDING_REFLASH));
         }
         if(SavePointManager.Instance.isInSavePoint(43))
         {
            SavePointManager.Instance.setSavePoint(43);
            SingleDungeonEvent.dispatcher.dispatchEvent(new SingleDungeonEvent(SingleDungeonEvent.FRAME_EXIT,"reflash"));
            dispatchEvent(new TaskEvent(TaskEvent.BUILDING_REFLASH));
         }
         if(SavePointManager.Instance.isInSavePoint(42))
         {
            SavePointManager.Instance.setSavePoint(42);
            SingleDungeonEvent.dispatcher.dispatchEvent(new SingleDungeonEvent(SingleDungeonEvent.FRAME_EXIT,"reflash"));
            dispatchEvent(new TaskEvent(TaskEvent.BUILDING_REFLASH));
         }
         if(SavePointManager.Instance.isInSavePoint(24))
         {
            SavePointManager.Instance.setSavePoint(24);
            dispatchEvent(new TaskEvent(TaskEvent.BUILDING_REFLASH));
            SingleDungeonEvent.dispatcher.dispatchEvent(new SingleDungeonEvent(SingleDungeonEvent.FRAME_EXIT,"reflash"));
         }
         if(SavePointManager.Instance.isInSavePoint(20))
         {
            SavePointManager.Instance.setSavePoint(20);
            SingleDungeonEvent.dispatcher.dispatchEvent(new SingleDungeonEvent(SingleDungeonEvent.FRAME_EXIT,"reflash"));
            dispatchEvent(new TaskEvent(TaskEvent.BUILDING_REFLASH));
            MainToolBar.Instance.tipTask();
         }
         if(SavePointManager.Instance.isInSavePoint(38))
         {
            SavePointManager.Instance.setSavePoint(38);
            SingleDungeonEvent.dispatcher.dispatchEvent(new SingleDungeonEvent(SingleDungeonEvent.FRAME_EXIT,"reflash"));
            dispatchEvent(new TaskEvent(TaskEvent.BUILDING_REFLASH));
         }
         if(SavePointManager.Instance.isInSavePoint(39))
         {
            SavePointManager.Instance.setSavePoint(39);
            SingleDungeonEvent.dispatcher.dispatchEvent(new SingleDungeonEvent(SingleDungeonEvent.FRAME_EXIT,"reflash"));
            dispatchEvent(new TaskEvent(TaskEvent.BUILDING_REFLASH));
         }
         if(SavePointManager.Instance.isInSavePoint(51))
         {
            SavePointManager.Instance.setSavePoint(51);
         }
         if(SavePointManager.Instance.isInSavePoint(52))
         {
            SavePointManager.Instance.setSavePoint(52);
            SingleDungeonEvent.dispatcher.dispatchEvent(new SingleDungeonEvent(SingleDungeonEvent.FRAME_EXIT,"reflash"));
            dispatchEvent(new TaskEvent(TaskEvent.BUILDING_REFLASH));
         }
         if(SavePointManager.Instance.isInSavePoint(53))
         {
            SavePointManager.Instance.setSavePoint(53);
            SingleDungeonEvent.dispatcher.dispatchEvent(new SingleDungeonEvent(SingleDungeonEvent.FRAME_EXIT,"reflash"));
            dispatchEvent(new TaskEvent(TaskEvent.BUILDING_REFLASH));
         }
         if(SavePointManager.Instance.isInSavePoint(54))
         {
            MainToolBar.Instance.showIconAppear(5);
            SavePointManager.Instance.setSavePoint(54);
            SingleDungeonEvent.dispatcher.dispatchEvent(new SingleDungeonEvent(SingleDungeonEvent.FRAME_EXIT,"reflash"));
            dispatchEvent(new TaskEvent(TaskEvent.BUILDING_REFLASH));
         }
         if(SavePointManager.Instance.isInSavePoint(63))
         {
            SavePointManager.Instance.setSavePoint(63);
         }
         if(SavePointManager.Instance.isInSavePoint(66))
         {
            SavePointManager.Instance.setSavePoint(66);
            if(StateManager.currentStateType == StateType.ROOM_LIST)
            {
               TaskManager.instance.dispatchEvent(new TaskEvent(TaskEvent.SHOW_ARROW));
            }
         }
         if(SavePointManager.Instance.isInSavePoint(73))
         {
            SavePointManager.Instance.setSavePoint(73);
            dispatchEvent(new TaskEvent(TaskEvent.BUILDING_REFLASH));
         }
         if(SavePointManager.Instance.isInSavePoint(74))
         {
            SavePointManager.Instance.setSavePoint(74);
            NewHandContainer.Instance.showArrow(ArrowType.CLICK_LIVENESS,-90,"trainer.posClickLiveness","","",LayerManager.Instance.getLayerByType(LayerManager.GAME_UI_LAYER));
         }
      }
      
      public function isNewHandTaskAchieved(param1:uint) : Boolean
      {
         var _loc2_:QuestInfo = this.getQuestByID(param1);
         var _loc3_:QuestInfo = this.getQuestByID(100 + param1);
         if(!_loc2_ || !_loc3_)
         {
            return false;
         }
         if(_loc2_.isAchieved || _loc3_.isAchieved)
         {
            return true;
         }
         if(!_loc2_.CanRepeat || !_loc3_.CanRepeat)
         {
            if(this.IsQuestFinish(_loc2_.Id) || this.IsQuestFinish(_loc3_.Id))
            {
               return true;
            }
         }
         return false;
      }
      
      public function isNewHandTaskCompleted(param1:uint) : Boolean
      {
         var _loc2_:QuestInfo = this.getQuestByID(param1);
         var _loc3_:QuestInfo = this.getQuestByID(100 + param1);
         if(!_loc2_ || !_loc3_)
         {
            return false;
         }
         if(_loc2_.isCompleted || _loc3_.isCompleted)
         {
            return true;
         }
         return false;
      }
      
      public function newHandRequestQuest(param1:uint) : void
      {
         if(StateManager.currentStateType == StateType.LOGIN)
         {
            return;
         }
         var _loc2_:QuestInfo = this.getQuestByID(param1);
         var _loc3_:QuestInfo = this.getQuestByID(100 + param1);
         if(!_loc2_ || !_loc3_)
         {
            return;
         }
         if(_loc2_.Type > 100)
         {
            return;
         }
         var _loc4_:Array = new Array();
         if(PlayerManager.Instance.Self.Sex)
         {
            _loc4_.push(_loc2_.QuestID);
         }
         else
         {
            _loc4_.push(_loc3_.QuestID);
         }
         if(this._questDataInited)
         {
            _loc2_.required = true;
            _loc3_.required = true;
         }
         this.socketSendQuestAdd(_loc4_);
      }
      
      public function checkHighLight() : void
      {
         var _loc2_:QuestInfo = null;
         ExitPromptManager.Instance.changeJSQuestVar();
         var _loc1_:int = 0;
         for each(_loc2_ in this.allCurrentQuest)
         {
            if(!_loc2_.isAchieved || _loc2_.CanRepeat)
            {
               if(_loc2_.isCompleted)
               {
                  if(!_loc2_.hadChecked)
                  {
                     _loc1_++;
                  }
               }
            }
         }
         if(_loc1_ > 0)
         {
            this.showTaskHightLight();
         }
         else
         {
            MainToolBar.Instance.hideTaskHightLight();
         }
      }
      
      private function showTaskHightLight() : void
      {
         if(StateManager.currentStateType == null || StateManager.currentStateType == StateType.LOGIN)
         {
            return;
         }
         if(!this._model.taskViewIsShow)
         {
            MainToolBar.Instance.showTaskHightLight();
         }
      }
      
      public function checkHasTaskById(param1:int) : Boolean
      {
         var _loc2_:QuestInfo = null;
         for each(_loc2_ in this.allCurrentQuest)
         {
            if(_loc2_.id == param1)
            {
               return true;
            }
         }
         return false;
      }
      
      public function getQuestByConditionType(param1:int) : Vector.<QuestInfo>
      {
         var _loc3_:QuestInfo = null;
         var _loc2_:Vector.<QuestInfo> = new Vector.<QuestInfo>();
         for each(_loc3_ in this._model.allQuests)
         {
            if(_loc3_.Condition == param1)
            {
               _loc2_.push(_loc3_);
            }
         }
         return _loc2_;
      }
   }
}
