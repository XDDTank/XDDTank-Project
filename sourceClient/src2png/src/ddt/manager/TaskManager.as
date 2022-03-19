// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//ddt.manager.TaskManager

package ddt.manager
{
    import flash.events.EventDispatcher;
    import ddt.data.quest.QuestImproveInfo;
    import quest.TaskMainFrame;
    import quest.TaskModel;
    import road7th.utils.MovieClipWrapper;
    import __AS3__.vec.Vector;
    import ddt.data.quest.QuestCondition;
    import com.pickgliss.action.ShowTipAction;
    import ddt.data.quest.QuestInfo;
    import com.pickgliss.ui.ComponentFactory;
    import tryonSystem.TryonSystemController;
    import ddt.events.TaskEvent;
    import flash.events.MouseEvent;
    import flash.events.Event;
    import com.pickgliss.utils.ObjectUtils;
    import ddt.states.StateType;
    import ddt.view.UIModuleSmallLoading;
    import com.pickgliss.loader.UIModuleLoader;
    import com.pickgliss.events.UIModuleEvent;
    import ddt.data.UIModuleTypes;
    import ddt.data.analyze.QuestListAnalyzer;
    import flash.utils.Dictionary;
    import ddt.events.CrazyTankSocketEvent;
    import consortion.ConsortionModel;
    import ddt.utils.BitArray;
    import flash.utils.ByteArray;
    import ddt.data.quest.QuestDataInfo;
    import ddt.data.quest.QuestCategory;
    import pet.date.PetInfo;
    import platformapi.tencent.DiamondManager;
    import platformapi.tencent.DiamondType;
    import road7th.comm.PackageIn;
    import ddt.data.player.SelfInfo;
    import ddt.data.BagInfo;
    import ddt.events.BagEvent;
    import ddt.data.goods.InventoryItemInfo;
    import ddt.events.PlayerPropertyEvent;
    import road7th.data.DictionaryEvent;
    import flash.net.URLVariables;
    import com.pickgliss.loader.BaseLoader;
    import ddt.utils.RequestVairableCreater;
    import com.pickgliss.loader.LoadResourceManager;
    import trainer.view.NewHandContainer;
    import trainer.data.ArrowType;
    import com.pickgliss.ui.LayerManager;
    import ddt.view.MainToolBar;
    import SingleDungeon.event.SingleDungeonEvent;
    import exitPrompt.ExitPromptManager;
    import ddt.data.quest.*;
    import __AS3__.vec.*;

    [Event(name="changed", type="tank.events.TaskEvent")]
    [Event(name="add", type="tank.events.TaskEvent")]
    [Event(name="remove", type="tank.events.TaskEvent")]
    public class TaskManager extends EventDispatcher 
    {

        public static const GUIDE_QUEST_ID:int = 339;
        public static const COLLECT_INFO_EMAIL:int = 544;
        public static const COLLECT_INFO_CELLPHONE:int = 263;
        private static var _instance:TaskManager;

        private var _questDataInited:Boolean;
        private var _improve:QuestImproveInfo;
        private var _mainFrame:TaskMainFrame;
        private var _model:TaskModel = new TaskModel();
        public var _getNewQuestMovie:MovieClipWrapper;
        private var _itemListenerArr:Vector.<int>;
        public var _friendListenerArr:Vector.<QuestCondition>;
        public var _annexListenerArr:Vector.<QuestCondition>;
        public var _desktopCond:QuestCondition;
        private var _showTipAction:ShowTipAction;
        private var _isPreLoadTask:Boolean;
        private var _preLoadCallBack:Function;
        private var _newTaskInfo:QuestInfo;


        public static function get instance():TaskManager
        {
            if (_instance == null)
            {
                _instance = new (TaskManager)();
            };
            return (_instance);
        }


        public function get improve():QuestImproveInfo
        {
            return (this._improve);
        }

        public function get MainFrame():TaskMainFrame
        {
            if ((!(this._mainFrame)))
            {
                this._mainFrame = ComponentFactory.Instance.creat("QuestFrame");
            };
            return (this._mainFrame);
        }

        public function get Model():TaskModel
        {
            return (this._model);
        }

        public function switchVisible():void
        {
            if (this._model.isFirstshowTask)
            {
                this._model.isOpenViewFromNewQuest = false;
                this.moduleLoad();
                return;
            };
            if ((!(this._model.taskViewIsShow)))
            {
                this.MainFrame.open();
                this._model.taskViewIsShow = true;
            }
            else
            {
                if (TryonSystemController.Instance.view != null)
                {
                    return;
                };
                this._mainFrame.dispose();
                this._mainFrame = null;
                this._model.taskViewIsShow = false;
                dispatchEvent(new TaskEvent(TaskEvent.TASK_FRAME_HIDE));
                this.checkNewHandTask();
            };
        }

        public function showGetNewQuest():void
        {
            if (this._getNewQuestMovie == null)
            {
                if (this._model.isFirstshowTask)
                {
                    this._model.isOpenViewFromNewQuest = true;
                    this.moduleLoad();
                    return;
                };
                this._getNewQuestMovie = new MovieClipWrapper(ComponentFactory.Instance.creatCustomObject("core.quest.GetNewQuestMovie"), false, true);
                this._getNewQuestMovie.movie.buttonMode = true;
                this._getNewQuestMovie.movie.addEventListener(MouseEvent.CLICK, this.__newQuestClickHandler);
                this._getNewQuestMovie.movie.addEventListener(Event.ADDED_TO_STAGE, this.__addNewQuestMovieToStage);
                this._getNewQuestMovie.addEventListener(Event.COMPLETE, this.removeNewQuestMovie);
            };
        }

        private function __addNewQuestMovieToStage(_arg_1:Event=null):void
        {
            if (this._getNewQuestMovie)
            {
                this._getNewQuestMovie.movie.removeEventListener(Event.ADDED_TO_STAGE, this.__addNewQuestMovieToStage);
                this._getNewQuestMovie.play();
            };
        }

        public function removeNewQuestMovie(_arg_1:Event=null):void
        {
            if (this._getNewQuestMovie)
            {
                this._getNewQuestMovie.movie.removeEventListener(MouseEvent.CLICK, this.__newQuestClickHandler);
                this._getNewQuestMovie.removeEventListener(Event.COMPLETE, this.removeNewQuestMovie);
                ObjectUtils.disposeObject(this._getNewQuestMovie.movie);
                ObjectUtils.disposeObject(this._getNewQuestMovie);
                this._getNewQuestMovie = null;
                this._model.newQuestMovieIsPlaying = false;
                dispatchEvent(new TaskEvent(TaskEvent.NEW_TASK_SHOW, this._newTaskInfo));
            };
        }

        private function __newQuestClickHandler(_arg_1:MouseEvent):void
        {
            this._getNewQuestMovie.movie.removeEventListener(MouseEvent.CLICK, this.__newQuestClickHandler);
            if (this._showTipAction)
            {
                this._showTipAction.dispatcher.removeEventListener(MouseEvent.CLICK, this.__newQuestClickHandler);
                this._showTipAction.dispose();
                this._showTipAction = null;
            };
            if ((((((StateManager.currentStateType == StateType.FIGHT_LIB_GAMEVIEW) || (StateManager.isInFight)) || (StateManager.currentStateType == StateType.TRAINER1)) || (StateManager.currentStateType == StateType.TRAINER2)) || (StateManager.currentStateType == StateType.GAME_LOADING)))
            {
                return;
            };
            if ((!(this._getNewQuestMovie.movie.visible)))
            {
                this.removeNewQuestMovie();
                return;
            };
            this._getNewQuestMovie.movie.visible = false;
            if ((!(this._model.taskViewIsShow)))
            {
                this.switchVisible();
            };
        }

        public function moduleLoad(_arg_1:Boolean=false, _arg_2:Function=null):void
        {
            this._isPreLoadTask = _arg_1;
            this._preLoadCallBack = _arg_2;
            UIModuleSmallLoading.Instance.progress = 0;
            if ((!(this._isPreLoadTask)))
            {
                UIModuleSmallLoading.Instance.show();
            };
            UIModuleSmallLoading.Instance.addEventListener(Event.CLOSE, this.__onClose);
            UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_PROGRESS, this.__onTaskLoadProgress);
            UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_COMPLETE, this.__onTaskLoadComplete);
            UIModuleLoader.Instance.addUIModuleImp(UIModuleTypes.QUEST);
        }

        private function __onTaskLoadComplete(_arg_1:UIModuleEvent):void
        {
            if (_arg_1.module == UIModuleTypes.QUEST)
            {
                this._model.isFirstshowTask = false;
                if ((!(this._isPreLoadTask)))
                {
                    if (this._model.isOpenViewFromNewQuest)
                    {
                        this.showGetNewQuest();
                    }
                    else
                    {
                        this.switchVisible();
                        if (this._model.showQuestInfo)
                        {
                            this.showQuest(this._model.showQuestInfo, this._model.showQuestType);
                        };
                    };
                };
                UIModuleSmallLoading.Instance.hide();
                UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE, this.__onTaskLoadComplete);
                UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_PROGRESS, this.__onTaskLoadProgress);
                UIModuleSmallLoading.Instance.removeEventListener(Event.CLOSE, this.__onClose);
                if (null != this._preLoadCallBack)
                {
                    this._preLoadCallBack();
                    this._isPreLoadTask = false;
                };
            };
        }

        private function __onTaskLoadProgress(_arg_1:UIModuleEvent):void
        {
            if (_arg_1.module == UIModuleTypes.QUEST)
            {
                UIModuleSmallLoading.Instance.progress = (_arg_1.loader.progress * 100);
            };
        }

        private function __onClose(_arg_1:Event):void
        {
            UIModuleSmallLoading.Instance.hide();
            UIModuleSmallLoading.Instance.removeEventListener(Event.CLOSE, this.__onClose);
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE, this.__onTaskLoadComplete);
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_PROGRESS, this.__onTaskLoadProgress);
        }

        public function setup(_arg_1:QuestListAnalyzer):void
        {
            this._model.allQuests = _arg_1.list;
            this.getConsortionTaskReward();
            this._questDataInited = false;
            this._improve = this.getImproveArray(_arg_1.improveXml);
            this.addEvents();
            this.setSavePointTask();
        }

        public function reloadNewQuest(_arg_1:QuestListAnalyzer):void
        {
            var _local_3:QuestInfo;
            var _local_2:Dictionary = _arg_1.list;
            for each (_local_3 in _local_2)
            {
                if (this.getQuestByID(_local_3.id) == null)
                {
                    this.addQuest(_local_3);
                };
            };
        }

        public function addQuest(_arg_1:QuestInfo):void
        {
            this.allQuests[_arg_1.Id] = _arg_1;
        }

        private function setSavePointTask():void
        {
            var _local_1:QuestInfo;
            for each (_local_1 in this.allQuests)
            {
                if (_local_1.LimitNodes > 0)
                {
                    this.savePointTask.push(_local_1);
                };
            };
        }

        private function addEvents():void
        {
            this._model.addEventListener(TaskEvent.VIEW_SHOW_CHANGE, this.__taskViewShowHandler);
            SocketManager.Instance.addEventListener(CrazyTankSocketEvent.QUEST_UPDATE, this.__updateAcceptedTask);
            SocketManager.Instance.addEventListener(CrazyTankSocketEvent.QUEST_FINISH, this.__questFinish);
        }

        private function getConsortionTaskReward():void
        {
            this.getConsortionTaskRewardByLevel(ConsortionModel.TASKLEVELI);
            this.getConsortionTaskRewardByLevel(ConsortionModel.TASKLEVELII);
            this.getConsortionTaskRewardByLevel(ConsortionModel.TASKLEVELIII);
            this.getConsortionTaskRewardByLevel(ConsortionModel.TASKLEVELIV);
        }

        private function getConsortionTaskRewardByLevel(_arg_1:int):void
        {
            var _local_2:QuestInfo;
            for each (_local_2 in this._model.allQuests)
            {
                if (_local_2.Type == 9)
                {
                    if (_local_2.otherCondition == _arg_1)
                    {
                        switch (_arg_1)
                        {
                            case ConsortionModel.TASKLEVELI:
                                ConsortionModel.TaskRewardSontribution1 = _local_2.RewardOffer;
                                ConsortionModel.TaskRewardExp1 = _local_2.RewardConsortiaGP;
                                break;
                            case ConsortionModel.TASKLEVELII:
                                ConsortionModel.TaskRewardSontribution2 = _local_2.RewardOffer;
                                ConsortionModel.TaskRewardExp2 = _local_2.RewardConsortiaGP;
                                break;
                            case ConsortionModel.TASKLEVELIII:
                                ConsortionModel.TaskRewardSontribution3 = _local_2.RewardOffer;
                                ConsortionModel.TaskRewardExp3 = _local_2.RewardConsortiaGP;
                                break;
                            case ConsortionModel.TASKLEVELIV:
                                ConsortionModel.TaskRewardSontribution4 = _local_2.RewardOffer;
                                ConsortionModel.TaskRewardExp4 = _local_2.RewardConsortiaGP;
                                break;
                        };
                        break;
                    };
                };
            };
        }

        private function __taskViewShowHandler(_arg_1:TaskEvent):void
        {
            if ((!(this._model.taskViewIsShow)))
            {
                this._mainFrame = null;
            };
        }

        private function getImproveArray(_arg_1:XML):QuestImproveInfo
        {
            var _local_2:QuestImproveInfo = new QuestImproveInfo();
            _local_2.bindMoneyRate = String(_arg_1.@BindMoneyRate).split("|");
            _local_2.expRate = String(_arg_1.@ExpRate).split("|");
            _local_2.goldRate = String(_arg_1.@GoldRate).split("|");
            _local_2.exploitRate = String(_arg_1.@ExploitRate).split("|");
            _local_2.canOneKeyFinishTime = Number(_arg_1.@CanOneKeyFinishTime);
            return (_local_2);
        }

        private function loadQuestLog(_arg_1:ByteArray):void
        {
            _arg_1.position = 0;
            if (this._model.questLog == null)
            {
                this._model.questLog = new BitArray();
            };
            var _local_2:int;
            while (_local_2 < _arg_1.length)
            {
                this._model.questLog.writeByte(_arg_1.readByte());
                _local_2++;
            };
        }

        private function IsQuestFinish(_arg_1:int):Boolean
        {
            if ((!(this._model.questLog)))
            {
                return (false);
            };
            if (((_arg_1 > (this._model.questLog.length * 8)) || (_arg_1 < 1)))
            {
                return (false);
            };
            _arg_1--;
            var _local_2:int = int((_arg_1 / 8));
            var _local_3:int = (_arg_1 % 8);
            var _local_4:int = (this._model.questLog[_local_2] & (1 << _local_3));
            return (!(_local_4 == 0));
        }

        public function get allQuests():Dictionary
        {
            if ((!(this._model.allQuests)))
            {
                this._model.allQuests = new Dictionary();
            };
            return (this._model.allQuests);
        }

        public function set allQuests(_arg_1:Dictionary):void
        {
            this._model.allQuests = _arg_1;
        }

        public function get savePointTask():Vector.<QuestInfo>
        {
            if ((!(this._model.savePointTask)))
            {
                this._model.savePointTask = new Vector.<QuestInfo>();
            };
            return (this._model.savePointTask);
        }

        public function getQuestByID(_arg_1:int):QuestInfo
        {
            if ((!(this.allQuests)))
            {
                return (null);
            };
            return (this.allQuests[_arg_1]);
        }

        public function getQuestDataByID(_arg_1:int):QuestDataInfo
        {
            if ((!(this.getQuestByID(_arg_1))))
            {
                return (null);
            };
            return (this.getQuestByID(_arg_1).data);
        }

        public function getAvailableQuests(_arg_1:int=-1, _arg_2:Boolean=true):QuestCategory
        {
            var _local_4:QuestInfo;
            var _local_3:QuestCategory = new QuestCategory();
            for each (_local_4 in this.allQuests)
            {
                if (_local_4.Type == 8)
                {
                };
                if (_local_4.id == 914)
                {
                };
                if (_arg_1 > -1)
                {
                    if (_arg_1 == 0)
                    {
                        if (_local_4.Type != 0) continue;
                    }
                    else
                    {
                        if (_arg_1 == 1)
                        {
                            if (((((!(_local_4.Type == 4)) && (!(_local_4.Type == 1))) && (!(_local_4.Type == 6))) && (!(_local_4.Type == 8)))) continue;
                        }
                        else
                        {
                            if (_arg_1 == 2)
                            {
                                if (_local_4.id == 901) continue;
                                if (((!(_local_4.Type == 2)) && (_local_4.Type < 100))) continue;
                            }
                            else
                            {
                                if (_arg_1 == 3)
                                {
                                    if (_local_4.Type != 3) continue;
                                }
                                else
                                {
                                    if (_arg_1 == 4)
                                    {
                                        if (_local_4.Type != 7) continue;
                                    }
                                    else
                                    {
                                        if (_arg_1 == 5)
                                        {
                                            if (((!(_local_4.data)) || (!(_local_4.Type == 9)))) continue;
                                        }
                                        else
                                        {
                                            if (_arg_1 == 8)
                                            {
                                                if (_local_4.Type != 8) continue;
                                            };
                                        };
                                    };
                                };
                            };
                        };
                    };
                };
                if (_local_4.LimitNodes > 0)
                {
                    if (PlayerManager.Instance.Self.Sex)
                    {
                        if (_local_4.QuestID > 100) continue;
                    }
                    else
                    {
                        if (_local_4.QuestID < 100) continue;
                    };
                };
                if ((((_arg_2) && (_local_4.data)) && (!(_local_4.data.isExist))))
                {
                    this.requestQuest(_local_4);
                }
                else
                {
                    if (this.isAvailableQuest(_local_4, true))
                    {
                        if (_local_4.isCompleted)
                        {
                            _local_3.addCompleted(_local_4);
                        }
                        else
                        {
                            if (((_local_4.data) && (_local_4.data.isNew)))
                            {
                                _local_3.addNew(_local_4);
                            }
                            else
                            {
                                _local_3.addQuest(_local_4);
                            };
                        };
                    };
                };
            };
            return (_local_3);
        }

        public function get allAvailableQuests():Array
        {
            return (this.getAvailableQuests(-1, false).list);
        }

        public function get allCurrentQuest():Array
        {
            return (this.getAvailableQuests(-1, true).list);
        }

        public function get mainQuests():Array
        {
            return (this.getAvailableQuests(0, true).list);
        }

        public function get sideQuests():Array
        {
            return (this.getAvailableQuests(1, true).list);
        }

        public function get dailyQuests():Array
        {
            return (this.getAvailableQuests(2, true).list);
        }

        public function get texpQuests():Array
        {
            var _local_2:QuestInfo;
            var _local_1:QuestCategory = new QuestCategory();
            for each (_local_2 in this.allQuests)
            {
                if (_local_2.Type >= 100)
                {
                    if (((_local_2.data) && (!(_local_2.data.isExist))))
                    {
                        this.requestQuest(_local_2);
                    }
                    else
                    {
                        if (this.isAvailableQuest(_local_2, true))
                        {
                            if (_local_2.isCompleted)
                            {
                                _local_1.addCompleted(_local_2);
                            }
                            else
                            {
                                if (((_local_2.data) && (_local_2.data.isNew)))
                                {
                                    _local_1.addNew(_local_2);
                                }
                                else
                                {
                                    _local_1.addQuest(_local_2);
                                };
                            };
                        };
                    };
                };
            };
            return (_local_1.list);
        }

        public function getPetMagicTask(_arg_1:PetInfo):QuestInfo
        {
            var _local_3:QuestInfo;
            var _local_2:Array = this.getAvailableQuests(8, true).list;
            for each (_local_3 in _local_2)
            {
                if ((_local_3.id % 10) == _arg_1.KindID)
                {
                    return (_local_3);
                };
            };
            return (null);
        }

        public function getTaskData(_arg_1:int):QuestDataInfo
        {
            if (this.getQuestByID(_arg_1))
            {
                return (this.getQuestByID(_arg_1).data);
            };
            return (null);
        }

        private function isAvailableQuest(_arg_1:QuestInfo, _arg_2:Boolean=false):Boolean
        {
            var _local_5:int;
            var _local_6:Array;
            var _local_7:int;
            var _local_8:QuestInfo;
            var _local_3:Array = PathManager.DISABLE_TASK_ID;
            var _local_4:int;
            while (_local_4 < _local_3.length)
            {
                if (_arg_1.id == parseInt(_local_3[_local_4]))
                {
                    return (false);
                };
                _local_4++;
            };
            if (_arg_1.disabled)
            {
                return (false);
            };
            if (_arg_1.Type <= 100)
            {
                _local_5 = PlayerManager.Instance.Self.Grade;
                if (((_arg_1.NeedMinLevel > _local_5) || (_arg_1.NeedMaxLevel < _local_5)))
                {
                    return (false);
                };
            };
            if (_arg_1.PreQuestID != "0,")
            {
                _local_6 = new Array();
                _local_6 = _arg_1.PreQuestID.split(",");
                for each (_local_7 in _local_6)
                {
                    if (_local_7 != 0)
                    {
                        if (this.getQuestByID(_local_7))
                        {
                            _local_8 = this.getQuestByID(_local_7);
                            if ((!(_local_8)))
                            {
                                return (false);
                            };
                            if ((!(this.isAchieved(_local_8))))
                            {
                                return (false);
                            };
                        };
                    };
                };
            };
            if ((!(((this.isValidateByDate(_arg_1)) && (this.isAvailableByGuild(_arg_1))) && (this.isAvailableByMarry(_arg_1)))))
            {
                return (false);
            };
            if (((_arg_1.Type <= 100) && (this.haveLog(_arg_1))))
            {
                return (false);
            };
            if ((!(_arg_1.isAvailable)))
            {
                return (false);
            };
            if (((_arg_1.data == null) || ((!(_arg_1.data.isExist)) && (_arg_1.CanRepeat))))
            {
                this.requestQuest(_arg_1);
                if (((_arg_2) && (!(_arg_1.Type == 4))))
                {
                    return (false);
                };
            };
            if (_arg_1.Type == 8)
            {
                return (this.checkPetMagic(_arg_1));
            };
            if (_arg_1.otherCondition == 100)
            {
                return (DiamondManager.instance.pfType == DiamondType.BLUE_DIAMOND);
            };
            return (true);
        }

        private function checkPetMagic(_arg_1:QuestInfo):Boolean
        {
            var _local_2:Array = PetInfoManager.instance.getNeedMagicPets();
            var _local_3:int = (_arg_1.id % 10);
            return (_local_2.indexOf(_local_3) > -1);
        }

        public function isAchieved(_arg_1:QuestInfo):Boolean
        {
            if (_arg_1.isAchieved)
            {
                return (true);
            };
            if ((!(_arg_1.CanRepeat)))
            {
                if (this.IsQuestFinish(_arg_1.Id))
                {
                    return (true);
                };
            };
            return (false);
        }

        public function isCompleted(_arg_1:QuestInfo):Boolean
        {
            if (_arg_1.isCompleted)
            {
                return (true);
            };
            return (false);
        }

        public function isAvailable(_arg_1:QuestInfo):Boolean
        {
            if ((!(_arg_1)))
            {
                return (false);
            };
            return ((this.isAvailableQuest(_arg_1)) && (!(_arg_1.isCompleted)));
        }

        private function haveLog(_arg_1:QuestInfo):Boolean
        {
            if (_arg_1.CanRepeat)
            {
                if (((_arg_1.data) && (_arg_1.data.repeatLeft == 0)))
                {
                    return (true);
                };
                return (false);
            };
            if (this.IsQuestFinish(_arg_1.Id))
            {
                return (true);
            };
            return (false);
        }

        public function isValidateByDate(_arg_1:QuestInfo):Boolean
        {
            if ((!(_arg_1)))
            {
                return (false);
            };
            return (!(_arg_1.isTimeOut()));
        }

        public function isAvailableByGuild(_arg_1:QuestInfo):Boolean
        {
            if ((!(_arg_1)))
            {
                return (false);
            };
            return ((!(_arg_1.otherCondition == 1)) || (!(PlayerManager.Instance.Self.ConsortiaID == 0)));
        }

        public function isAvailableByMarry(_arg_1:QuestInfo):Boolean
        {
            if ((!(_arg_1)))
            {
                return (false);
            };
            return ((!(_arg_1.otherCondition == 2)) || (PlayerManager.Instance.Self.IsMarried));
        }

        private function __updateAcceptedTask(_arg_1:CrazyTankSocketEvent):void
        {
            var _local_5:int;
            var _local_6:QuestInfo;
            var _local_7:QuestDataInfo;
            var _local_8:int;
            var _local_9:int;
            var _local_10:int;
            var _local_11:int;
            var _local_2:PackageIn = _arg_1.pkg;
            var _local_3:int = _local_2.readInt();
            var _local_4:int;
            for (;_local_4 < _local_3;_local_4++)
            {
                _local_5 = _local_2.readInt();
                _local_6 = new QuestInfo();
                if (this.getQuestByID(_local_5))
                {
                    _local_6 = this.getQuestByID(_local_5);
                }
                else
                {
                    continue;
                };
                if (_local_6.data)
                {
                    _local_7 = _local_6.data;
                }
                else
                {
                    _local_7 = new QuestDataInfo(_local_5);
                    if (_local_6.required)
                    {
                        _local_7.isNew = true;
                    };
                };
                _local_7.isAchieved = _local_2.readBoolean();
                _local_8 = _local_2.readInt();
                _local_9 = _local_2.readInt();
                _local_10 = _local_2.readInt();
                _local_11 = _local_2.readInt();
                _local_7.setProgress(_local_8, _local_9, _local_10, _local_11);
                _local_7.CompleteDate = _local_2.readDate();
                _local_7.repeatLeft = _local_2.readInt();
                _local_7.quality = _local_2.readInt();
                _local_7.isExist = _local_2.readBoolean();
                _local_6.QuestLevel = _local_2.readInt();
                _local_6.data = _local_7;
                if (_local_7.isNew)
                {
                    this.addNewQuest(_local_6);
                };
                dispatchEvent(new TaskEvent(TaskEvent.CHANGED, _local_6, _local_7));
            };
            this.loadQuestLog(_local_2.readByteArray());
            this._questDataInited = true;
            this.checkHighLight();
        }

        private function addNewQuest(_arg_1:QuestInfo):void
        {
            if ((!(this._model.newQuests)))
            {
                this._model.newQuests = new Vector.<QuestInfo>();
            };
            if (((this._model.newQuests.indexOf(_arg_1) == -1) && (!(this._model.newQuestMovieIsPlaying))))
            {
                this.showGetNewQuest();
                this._newTaskInfo = _arg_1;
            };
            this._model.newQuests.push(_arg_1);
        }

        private function __questFinish(_arg_1:CrazyTankSocketEvent):void
        {
            var _local_2:PackageIn = _arg_1.pkg;
            var _local_3:int = _local_2.readInt();
            this.onFinishQuest(_local_3);
        }

        private function onFinishQuest(_arg_1:int):void
        {
            var _local_2:QuestInfo = this.getQuestByID(_arg_1);
            if (((_local_2.isAvailable) || (_local_2.NextQuestID)))
            {
                this.requestCanAcceptTask();
            };
            dispatchEvent(new TaskEvent(TaskEvent.FINISH, _local_2, _local_2.data));
        }

        public function jumpToQuest(_arg_1:QuestInfo):void
        {
            this._model.selectedQuest = _arg_1;
            this.MainFrame.jumpToQuest(_arg_1);
        }

        public function showQuest(_arg_1:QuestInfo, _arg_2:int):void
        {
            this._model.showQuestInfo = _arg_1;
            if (this._model.isFirstshowTask)
            {
                this._model.isOpenViewFromNewQuest = false;
                this._model.showQuestType = _arg_2;
                this.moduleLoad();
                return;
            };
            if ((!(this._model.taskViewIsShow)))
            {
                this.MainFrame.open();
                this._model.taskViewIsShow = true;
            };
            this._model.selectedQuest = _arg_1;
            this.MainFrame.showQuestTask(_arg_1, _arg_2);
            this._model.showQuestInfo = null;
        }

        public function onGuildUpdate():void
        {
            this.checkHighLight();
        }

        public function finshMarriage():void
        {
            var _local_1:QuestInfo;
            var _local_2:QuestDataInfo;
            for each (_local_1 in this.allQuests)
            {
                _local_2 = _local_1.data;
                if (!(!(_local_2)))
                {
                    if ((!(_local_2.isAchieved)))
                    {
                        if (_local_1.Condition == 21)
                        {
                            this.showTaskHightLight();
                        };
                    };
                };
            };
            this.requestCanAcceptTask();
        }

        public function requestCanAcceptTask():void
        {
            var _local_2:Array;
            var _local_3:QuestInfo;
            var _local_1:Array = this.allAvailableQuests;
            if (_local_1.length != 0)
            {
                _local_2 = new Array();
                for each (_local_3 in _local_1)
                {
                    if (_local_3.Type <= 100)
                    {
                        if (!((_local_3.data) && (_local_3.data.isExist)))
                        {
                            _local_2.push(_local_3.QuestID);
                            if (this._questDataInited)
                            {
                                _local_3.required = true;
                            };
                        };
                    };
                };
                this.socketSendQuestAdd(_local_2);
            };
        }

        public function requestQuest(_arg_1:QuestInfo):void
        {
            if (_arg_1.Type == 9)
            {
                return;
            };
            if (StateManager.currentStateType == StateType.LOGIN)
            {
                return;
            };
            if (_arg_1.Type > 100)
            {
                return;
            };
            var _local_2:Array = new Array();
            _local_2.push(_arg_1.QuestID);
            if (this._questDataInited)
            {
                _arg_1.required = true;
            };
            this.socketSendQuestAdd(_local_2);
        }

        public function requestClubTask():void
        {
            var _local_2:QuestInfo;
            var _local_1:Array = new Array();
            for each (_local_2 in this.allAvailableQuests)
            {
                if (_local_2.otherCondition == 1)
                {
                    if (this.isAvailableQuest(_local_2))
                    {
                        _local_1.push(_local_2.QuestID);
                    };
                };
            };
            if (_local_1.length > 0)
            {
                this.socketSendQuestAdd(_local_1);
            };
        }

        public function addItemListener(_arg_1:int):void
        {
            if ((!(this._itemListenerArr)))
            {
                this._itemListenerArr = new Vector.<int>();
            };
            this._itemListenerArr.push(_arg_1);
            var _local_2:SelfInfo = PlayerManager.Instance.Self;
            _local_2.getBag(BagInfo.EQUIPBAG).addEventListener(BagEvent.UPDATE, this.__onBagUpdate);
            _local_2.getBag(BagInfo.PROPBAG).addEventListener(BagEvent.UPDATE, this.__onBagUpdate);
        }

        private function __onBagUpdate(_arg_1:BagEvent):void
        {
            var _local_2:InventoryItemInfo;
            var _local_3:int;
            for each (_local_2 in _arg_1.changedSlots)
            {
                for each (_local_3 in this._itemListenerArr)
                {
                    if (_local_3 == _local_2.TemplateID)
                    {
                        this.checkHighLight();
                    };
                };
            };
        }

        public function addGradeListener():void
        {
            PlayerManager.Instance.Self.addEventListener(PlayerPropertyEvent.PROPERTY_CHANGE, this.__onPlayerPropertyChange);
        }

        private function __onPlayerPropertyChange(_arg_1:PlayerPropertyEvent):void
        {
            if (_arg_1.changedProperties["Grade"])
            {
                this.checkHighLight();
            };
        }

        public function addAnnexListener(_arg_1:QuestCondition):void
        {
            if ((!(this._annexListenerArr)))
            {
                this._annexListenerArr = new Vector.<QuestCondition>();
            };
            this._annexListenerArr.push(_arg_1);
        }

        public function addDesktopListener(_arg_1:QuestCondition):void
        {
            this._desktopCond = _arg_1;
            if (DesktopManager.Instance.isDesktop)
            {
                this.checkQuest(this._desktopCond.questID, this._desktopCond.ConID, 0);
            };
        }

        public function onDesktopApp():void
        {
            if (this._desktopCond)
            {
                this.checkQuest(this._desktopCond.questID, this._desktopCond.ConID, 0);
            };
        }

        public function onSendAnnex(_arg_1:Array):void
        {
            var _local_2:InventoryItemInfo;
            var _local_3:QuestCondition;
            for each (_local_2 in _arg_1)
            {
                for each (_local_3 in this._annexListenerArr)
                {
                    if (_local_3.param2 == _local_2.TemplateID)
                    {
                        if (this.isAvailableQuest(this.getQuestByID(_local_3.questID), true))
                        {
                            this.checkQuest(_local_3.questID, _local_3.ConID, 0);
                        };
                    };
                };
            };
        }

        public function addFriendListener(_arg_1:QuestCondition):void
        {
            if ((!(this._friendListenerArr)))
            {
                this._friendListenerArr = new Vector.<QuestCondition>();
            };
            this._friendListenerArr.push(_arg_1);
            PlayerManager.Instance.addEventListener(PlayerManager.FRIENDLIST_COMPLETE, this.__onFriendListComplete);
            addEventListener(TaskEvent.CHANGED, this.__onQuestChange);
        }

        private function __onQuestChange(_arg_1:TaskEvent):void
        {
            var _local_2:QuestCondition;
            for each (_local_2 in this._friendListenerArr)
            {
                if (_arg_1.info.Id == _local_2.questID)
                {
                    this.checkQuest(_local_2.questID, _local_2.ConID, (_local_2.param2 - PlayerManager.Instance.friendList.length));
                };
            };
        }

        private function __onFriendListComplete(_arg_1:Event):void
        {
            var _local_2:QuestCondition;
            PlayerManager.Instance.friendList.addEventListener(DictionaryEvent.ADD, this.__onFriendListUpdated);
            PlayerManager.Instance.friendList.addEventListener(DictionaryEvent.REMOVE, this.__onFriendListUpdated);
            for each (_local_2 in this._friendListenerArr)
            {
                this.checkQuest(_local_2.questID, _local_2.ConID, (_local_2.param2 - PlayerManager.Instance.friendList.length));
            };
        }

        private function __onFriendListUpdated(_arg_1:DictionaryEvent):void
        {
            var _local_2:QuestCondition;
            for each (_local_2 in this._friendListenerArr)
            {
                this.checkQuest(_local_2.questID, _local_2.ConID, (_local_2.param2 - PlayerManager.Instance.friendList.length));
            };
        }

        public function sendQuestFinish(_arg_1:uint):void
        {
            SocketManager.Instance.out.sendQuestFinish(_arg_1, this._model.itemAwardSelected);
            this.questFinishHook(_arg_1);
        }

        private function questFinishHook(_arg_1:uint):void
        {
            var _local_2:Number;
            var _local_3:URLVariables;
            var _local_4:BaseLoader;
            switch (_arg_1)
            {
                case COLLECT_INFO_EMAIL:
                    _local_2 = PlayerManager.Instance.Self.ID;
                    _local_3 = RequestVairableCreater.creatWidthKey(true);
                    _local_3["selfid"] = _local_2;
                    _local_3["url"] = PathManager.solveLogin();
                    _local_3["nickname"] = PlayerManager.Instance.Self.NickName;
                    _local_3["rnd"] = Math.random();
                    _local_4 = LoadResourceManager.instance.createLoader(PathManager.solveRequestPath("SendMailGameUrl.ashx"), BaseLoader.REQUEST_LOADER, _local_3);
                    LoadResourceManager.instance.startLoad(_local_4);
                    return;
            };
        }

        public function checkQuest(_arg_1:int, _arg_2:int, _arg_3:int):void
        {
            SocketManager.Instance.out.sendQuestCheck(_arg_1, _arg_2, _arg_3);
        }

        private function socketSendQuestAdd(_arg_1:Array):void
        {
            var _local_4:QuestInfo;
            var _local_2:Array = new Array();
            var _local_3:uint;
            while (_local_3 < _arg_1.length)
            {
                _local_4 = this.getQuestByID(_arg_1[_local_3]);
                if (((_local_4.Type < 2) || (_local_4.Type == 8)))
                {
                    _local_2.push(_local_4.id);
                };
                _local_3++;
            };
            SocketManager.Instance.out.sendQuestAdd(_local_2);
        }

        public function checkNewHandTask():void
        {
            if (SavePointManager.Instance.isInSavePoint(32))
            {
                this.showDialog(43);
            };
            if (SavePointManager.Instance.isInSavePoint(36))
            {
                this.showDialog(15);
            };
            if (SavePointManager.Instance.isInSavePoint(38))
            {
                this.showDialog(22);
            };
            if (SavePointManager.Instance.isInSavePoint(39))
            {
                this.showDialog(23);
            };
            if (SavePointManager.Instance.isInSavePoint(40))
            {
                this.showDialog(24);
            };
            if (SavePointManager.Instance.isInSavePoint(41))
            {
                this.showDialog(44);
            };
            if (SavePointManager.Instance.isInSavePoint(42))
            {
                this.showDialog(25);
            };
            if (SavePointManager.Instance.isInSavePoint(24))
            {
                this.showDialog(28);
            };
            if (SavePointManager.Instance.isInSavePoint(43))
            {
                this.showDialog(45);
            };
            if (SavePointManager.Instance.isInSavePoint(49))
            {
                dispatchEvent(new TaskEvent(TaskEvent.BUILDING_REFLASH));
            };
            if (SavePointManager.Instance.isInSavePoint(20))
            {
                if (((TaskManager.instance.isNewHandTaskAchieved(15)) && (TaskManager.instance.isNewHandTaskAchieved(16))))
                {
                    this.showDialog(49);
                };
            };
            if (SavePointManager.Instance.isInSavePoint(51))
            {
                if (TaskManager.instance.isNewHandTaskAchieved(14))
                {
                    this.showDialog(48);
                };
            };
            if (SavePointManager.Instance.isInSavePoint(52))
            {
                if (TaskManager.instance.isNewHandTaskAchieved(17))
                {
                    this.showDialog(50);
                };
            };
            if (SavePointManager.Instance.isInSavePoint(53))
            {
                if (TaskManager.instance.isNewHandTaskAchieved(18))
                {
                    this.showDialog(51);
                };
            };
            if (SavePointManager.Instance.isInSavePoint(54))
            {
                if (TaskManager.instance.isNewHandTaskAchieved(22))
                {
                    this.showDialog(29);
                };
            };
            if (SavePointManager.Instance.isInSavePoint(63))
            {
                if (TaskManager.instance.isNewHandTaskAchieved(10))
                {
                    this.showDialog(18);
                };
            };
            if (SavePointManager.Instance.isInSavePoint(66))
            {
                this.showDialog(53);
            };
            if (((SavePointManager.Instance.isInSavePoint(10)) && (TaskManager.instance.isNewHandTaskAchieved(7))))
            {
                dispatchEvent(new TaskEvent(TaskEvent.BUILDING_REFLASH));
            };
            if (((TaskManager.instance.isNewHandTaskAchieved(10)) && (SavePointManager.Instance.isInSavePoint(15))))
            {
                if (StateManager.currentStateType == StateType.ROOM_LIST)
                {
                    TaskManager.instance.dispatchEvent(new TaskEvent(TaskEvent.SHOW_ARROW));
                };
            };
            if ((((TaskManager.instance.isNewHandTaskAchieved(14)) && (TaskManager.instance.isNewHandTaskAchieved(13))) && (SavePointManager.Instance.isInSavePoint(19))))
            {
                if (StateManager.currentStateType == StateType.ROOM_LIST)
                {
                    TaskManager.instance.dispatchEvent(new TaskEvent(TaskEvent.SHOW_ARROW));
                };
            };
            if (((TaskManager.instance.isNewHandTaskAchieved(22)) && (SavePointManager.Instance.isInSavePoint(26))))
            {
                if (StateManager.currentStateType == StateType.SINGLEDUNGEON)
                {
                    TaskManager.instance.dispatchEvent(new TaskEvent(TaskEvent.SHOW_ARROW));
                };
            };
            if (SavePointManager.Instance.isInSavePoint(73))
            {
                this.showDialog(52);
            };
            if (SavePointManager.Instance.isInSavePoint(74))
            {
                this.showDialog(56);
            };
            if (((((SavePointManager.Instance.isInSavePoint(15)) || (SavePointManager.Instance.isInSavePoint(19))) || (SavePointManager.Instance.isInSavePoint(26))) && (StateManager.currentStateType == StateType.MATCH_ROOM)))
            {
                NewHandContainer.Instance.showArrow(ArrowType.EXIT_MATCHROOM, -45, "trainer.exitMatchRoomArrowPos", "", "", LayerManager.Instance.getLayerByType(LayerManager.GAME_UI_LAYER));
            };
            if (((TaskManager.instance.isNewHandTaskAchieved(11)) && (SavePointManager.Instance.isInSavePoint(16))))
            {
                if (StateManager.currentStateType == StateType.SHOP)
                {
                    TaskManager.instance.dispatchEvent(new TaskEvent(TaskEvent.SHOW_ARROW));
                };
            };
            if (((TaskManager.instance.isNewHandTaskAchieved(21)) && (SavePointManager.Instance.isInSavePoint(25))))
            {
                if (StateManager.currentStateType == StateType.FARM)
                {
                    TaskManager.instance.dispatchEvent(new TaskEvent(TaskEvent.SHOW_ARROW));
                };
            };
            if (StateManager.currentStateType == StateType.MAIN)
            {
                TaskManager.instance.dispatchEvent(new TaskEvent(TaskEvent.TASK_FRAME_HIDE));
            };
        }

        private function showDialog(_arg_1:uint):void
        {
            LayerManager.Instance.addToLayer(DialogManager.Instance.DialogBox, LayerManager.STAGE_TOP_LAYER);
            DialogManager.Instance.addEventListener(Event.COMPLETE, this.__dialogEndCallBack);
            DialogManager.Instance.showDialog(_arg_1);
        }

        private function __dialogEndCallBack(_arg_1:Event):void
        {
            DialogManager.Instance.removeEventListener(Event.COMPLETE, this.__dialogEndCallBack);
            if (SavePointManager.Instance.isInSavePoint(32))
            {
                SavePointManager.Instance.setSavePoint(32);
                MainToolBar.Instance.tipTask();
            };
            if (SavePointManager.Instance.isInSavePoint(36))
            {
                SavePointManager.Instance.setSavePoint(36);
                SingleDungeonEvent.dispatcher.dispatchEvent(new SingleDungeonEvent(SingleDungeonEvent.FRAME_EXIT, "reflash"));
                dispatchEvent(new TaskEvent(TaskEvent.BUILDING_REFLASH));
            };
            if (SavePointManager.Instance.isInSavePoint(40))
            {
                SavePointManager.Instance.setSavePoint(40);
                SingleDungeonEvent.dispatcher.dispatchEvent(new SingleDungeonEvent(SingleDungeonEvent.FRAME_EXIT, "reflash"));
                dispatchEvent(new TaskEvent(TaskEvent.BUILDING_REFLASH));
            };
            if (SavePointManager.Instance.isInSavePoint(41))
            {
                SavePointManager.Instance.setSavePoint(41);
                SingleDungeonEvent.dispatcher.dispatchEvent(new SingleDungeonEvent(SingleDungeonEvent.FRAME_EXIT, "reflash"));
                dispatchEvent(new TaskEvent(TaskEvent.BUILDING_REFLASH));
            };
            if (SavePointManager.Instance.isInSavePoint(43))
            {
                SavePointManager.Instance.setSavePoint(43);
                SingleDungeonEvent.dispatcher.dispatchEvent(new SingleDungeonEvent(SingleDungeonEvent.FRAME_EXIT, "reflash"));
                dispatchEvent(new TaskEvent(TaskEvent.BUILDING_REFLASH));
            };
            if (SavePointManager.Instance.isInSavePoint(42))
            {
                SavePointManager.Instance.setSavePoint(42);
                SingleDungeonEvent.dispatcher.dispatchEvent(new SingleDungeonEvent(SingleDungeonEvent.FRAME_EXIT, "reflash"));
                dispatchEvent(new TaskEvent(TaskEvent.BUILDING_REFLASH));
            };
            if (SavePointManager.Instance.isInSavePoint(24))
            {
                SavePointManager.Instance.setSavePoint(24);
                dispatchEvent(new TaskEvent(TaskEvent.BUILDING_REFLASH));
                SingleDungeonEvent.dispatcher.dispatchEvent(new SingleDungeonEvent(SingleDungeonEvent.FRAME_EXIT, "reflash"));
            };
            if (SavePointManager.Instance.isInSavePoint(20))
            {
                SavePointManager.Instance.setSavePoint(20);
                SingleDungeonEvent.dispatcher.dispatchEvent(new SingleDungeonEvent(SingleDungeonEvent.FRAME_EXIT, "reflash"));
                dispatchEvent(new TaskEvent(TaskEvent.BUILDING_REFLASH));
                MainToolBar.Instance.tipTask();
            };
            if (SavePointManager.Instance.isInSavePoint(38))
            {
                SavePointManager.Instance.setSavePoint(38);
                SingleDungeonEvent.dispatcher.dispatchEvent(new SingleDungeonEvent(SingleDungeonEvent.FRAME_EXIT, "reflash"));
                dispatchEvent(new TaskEvent(TaskEvent.BUILDING_REFLASH));
            };
            if (SavePointManager.Instance.isInSavePoint(39))
            {
                SavePointManager.Instance.setSavePoint(39);
                SingleDungeonEvent.dispatcher.dispatchEvent(new SingleDungeonEvent(SingleDungeonEvent.FRAME_EXIT, "reflash"));
                dispatchEvent(new TaskEvent(TaskEvent.BUILDING_REFLASH));
            };
            if (SavePointManager.Instance.isInSavePoint(51))
            {
                SavePointManager.Instance.setSavePoint(51);
            };
            if (SavePointManager.Instance.isInSavePoint(52))
            {
                SavePointManager.Instance.setSavePoint(52);
                SingleDungeonEvent.dispatcher.dispatchEvent(new SingleDungeonEvent(SingleDungeonEvent.FRAME_EXIT, "reflash"));
                dispatchEvent(new TaskEvent(TaskEvent.BUILDING_REFLASH));
            };
            if (SavePointManager.Instance.isInSavePoint(53))
            {
                SavePointManager.Instance.setSavePoint(53);
                SingleDungeonEvent.dispatcher.dispatchEvent(new SingleDungeonEvent(SingleDungeonEvent.FRAME_EXIT, "reflash"));
                dispatchEvent(new TaskEvent(TaskEvent.BUILDING_REFLASH));
            };
            if (SavePointManager.Instance.isInSavePoint(54))
            {
                MainToolBar.Instance.showIconAppear(5);
                SavePointManager.Instance.setSavePoint(54);
                SingleDungeonEvent.dispatcher.dispatchEvent(new SingleDungeonEvent(SingleDungeonEvent.FRAME_EXIT, "reflash"));
                dispatchEvent(new TaskEvent(TaskEvent.BUILDING_REFLASH));
            };
            if (SavePointManager.Instance.isInSavePoint(63))
            {
                SavePointManager.Instance.setSavePoint(63);
            };
            if (SavePointManager.Instance.isInSavePoint(66))
            {
                SavePointManager.Instance.setSavePoint(66);
                if (StateManager.currentStateType == StateType.ROOM_LIST)
                {
                    TaskManager.instance.dispatchEvent(new TaskEvent(TaskEvent.SHOW_ARROW));
                };
            };
            if (SavePointManager.Instance.isInSavePoint(73))
            {
                SavePointManager.Instance.setSavePoint(73);
                dispatchEvent(new TaskEvent(TaskEvent.BUILDING_REFLASH));
            };
            if (SavePointManager.Instance.isInSavePoint(74))
            {
                SavePointManager.Instance.setSavePoint(74);
                NewHandContainer.Instance.showArrow(ArrowType.CLICK_LIVENESS, -90, "trainer.posClickLiveness", "", "", LayerManager.Instance.getLayerByType(LayerManager.GAME_UI_LAYER));
            };
        }

        public function isNewHandTaskAchieved(_arg_1:uint):Boolean
        {
            var _local_2:QuestInfo = this.getQuestByID(_arg_1);
            var _local_3:QuestInfo = this.getQuestByID((100 + _arg_1));
            if (((!(_local_2)) || (!(_local_3))))
            {
                return (false);
            };
            if (((_local_2.isAchieved) || (_local_3.isAchieved)))
            {
                return (true);
            };
            if (((!(_local_2.CanRepeat)) || (!(_local_3.CanRepeat))))
            {
                if (((this.IsQuestFinish(_local_2.Id)) || (this.IsQuestFinish(_local_3.Id))))
                {
                    return (true);
                };
            };
            return (false);
        }

        public function isNewHandTaskCompleted(_arg_1:uint):Boolean
        {
            var _local_2:QuestInfo = this.getQuestByID(_arg_1);
            var _local_3:QuestInfo = this.getQuestByID((100 + _arg_1));
            if (((!(_local_2)) || (!(_local_3))))
            {
                return (false);
            };
            if (((_local_2.isCompleted) || (_local_3.isCompleted)))
            {
                return (true);
            };
            return (false);
        }

        public function newHandRequestQuest(_arg_1:uint):void
        {
            if (StateManager.currentStateType == StateType.LOGIN)
            {
                return;
            };
            var _local_2:QuestInfo = this.getQuestByID(_arg_1);
            var _local_3:QuestInfo = this.getQuestByID((100 + _arg_1));
            if (((!(_local_2)) || (!(_local_3))))
            {
                return;
            };
            if (_local_2.Type > 100)
            {
                return;
            };
            var _local_4:Array = new Array();
            if (PlayerManager.Instance.Self.Sex)
            {
                _local_4.push(_local_2.QuestID);
            }
            else
            {
                _local_4.push(_local_3.QuestID);
            };
            if (this._questDataInited)
            {
                _local_2.required = true;
                _local_3.required = true;
            };
            this.socketSendQuestAdd(_local_4);
        }

        public function checkHighLight():void
        {
            var _local_2:QuestInfo;
            ExitPromptManager.Instance.changeJSQuestVar();
            var _local_1:int;
            for each (_local_2 in this.allCurrentQuest)
            {
                if (((!(_local_2.isAchieved)) || (_local_2.CanRepeat)))
                {
                    if (_local_2.isCompleted)
                    {
                        if ((!(_local_2.hadChecked)))
                        {
                            _local_1++;
                        };
                    };
                };
            };
            if (_local_1 > 0)
            {
                this.showTaskHightLight();
            }
            else
            {
                MainToolBar.Instance.hideTaskHightLight();
            };
        }

        private function showTaskHightLight():void
        {
            if (((StateManager.currentStateType == null) || (StateManager.currentStateType == StateType.LOGIN)))
            {
                return;
            };
            if ((!(this._model.taskViewIsShow)))
            {
                MainToolBar.Instance.showTaskHightLight();
            };
        }

        public function checkHasTaskById(_arg_1:int):Boolean
        {
            var _local_2:QuestInfo;
            for each (_local_2 in this.allCurrentQuest)
            {
                if (_local_2.id == _arg_1)
                {
                    return (true);
                };
            };
            return (false);
        }

        public function getQuestByConditionType(_arg_1:int):Vector.<QuestInfo>
        {
            var _local_3:QuestInfo;
            var _local_2:Vector.<QuestInfo> = new Vector.<QuestInfo>();
            for each (_local_3 in this._model.allQuests)
            {
                if (_local_3.Condition == _arg_1)
                {
                    _local_2.push(_local_3);
                };
            };
            return (_local_2);
        }


    }
}//package ddt.manager

