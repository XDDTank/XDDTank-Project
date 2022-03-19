// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//ddt.manager.TaskDirectorManager

package ddt.manager
{
    import flash.utils.Dictionary;
    import __AS3__.vec.Vector;
    import SingleDungeon.model.MapSceneModel;
    import flash.display.MovieClip;
    import ddt.data.quest.QuestInfo;
    import com.pickgliss.ui.controls.alert.BaseAlerFrame;
    import flash.net.URLLoader;
    import flash.events.Event;
    import flash.net.URLRequest;
    import SingleDungeon.SingleDungeonManager;
    import com.pickgliss.utils.ClassUtils;
    import ddt.events.TaskEvent;
    import flash.geom.Point;
    import liveness.LivenessModel;
    import liveness.LivenessAwardManager;
    import ddt.data.TaskDirectorType;
    import com.pickgliss.ui.LayerManager;
    import flash.display.DisplayObjectContainer;
    import ddt.states.StateType;
    import com.pickgliss.events.FrameEvent;
    import com.pickgliss.ui.AlertManager;

    public class TaskDirectorManager 
    {

        private static var _instance:TaskDirectorManager;

        private var _data:Dictionary;
        private var _singleMapList:Vector.<MapSceneModel>;
        private var _arrow:MovieClip;
        private var _currentTask:QuestInfo;
        private var _navigateState:String;
        private var _alert:BaseAlerFrame;

        public function TaskDirectorManager(_arg_1:SingleEnforcer)
        {
            if ((!(_arg_1)))
            {
                throw (new Error("无法初始化"));
            };
        }

        public static function get instance():TaskDirectorManager
        {
            if ((!(_instance)))
            {
                _instance = new TaskDirectorManager(new SingleEnforcer());
            };
            return (_instance);
        }


        public function setup():void
        {
            var _local_1:URLLoader = new URLLoader();
            _local_1.addEventListener(Event.COMPLETE, this.__taskLoaded);
            _local_1.load(new URLRequest(PathManager.getTaskDirectorPath()));
            this._singleMapList = SingleDungeonManager.Instance.mapSceneList;
            this._arrow = ClassUtils.CreatInstance("asset.trainer.TrainerArrowAsset");
            this._arrow.stop();
            this._arrow.mouseEnabled = false;
            this._arrow.mouseChildren = false;
            TaskManager.instance.addEventListener(TaskEvent.CHANGED, this.__taskFinished);
        }

        protected function __taskLoaded(_arg_1:Event):void
        {
            var _local_4:XML;
            var _local_2:URLLoader = (_arg_1.target as URLLoader);
            _local_2.removeEventListener(Event.COMPLETE, this.__taskLoaded);
            var _local_3:XML = new XML(_local_2.data);
            this._data = new Dictionary();
            for each (_local_4 in _local_3.Director)
            {
                this._data[int(_local_4.@id)] = _local_4;
            };
        }

        protected function __taskFinished(_arg_1:TaskEvent):void
        {
            if (((!(this._currentTask)) || ((this._currentTask.QuestID == _arg_1.info.QuestID) && (_arg_1.data.isCompleted))))
            {
                this._currentTask = null;
                this.removeArrow();
            };
        }

        public function update():void
        {
            if (((!(this._currentTask)) || (this._currentTask.isCompleted)))
            {
                this._currentTask = null;
                this.removeArrow();
            };
        }

        public function showDirector(_arg_1:String, _arg_2:DisplayObjectContainer=null):void
        {
            var _local_3:MapSceneModel;
            var _local_4:XML;
            var _local_5:Point;
            var _local_6:int;
            var _local_7:XMLList;
            var _local_8:int;
            var _local_9:int;
            this.removeArrow();
            if ((((this._currentTask) && (this._currentTask._conditions.length > 0)) && (this._currentTask._conditions[0].type == LivenessModel.SINGLE_DUNGEON)))
            {
                for each (_local_3 in SingleDungeonManager.Instance.mapSceneList)
                {
                    if (_local_3.ID == LivenessAwardManager.Instance.currentSingleDungeonId)
                    {
                        SingleDungeonManager.Instance.maplistIndex = (_local_3.MapID - 1);
                        SingleDungeonManager.Instance._singleDungeonWalkMapModel._mapSceneModel = _local_3;
                        SocketManager.Instance.out.sendEnterWalkScene(LivenessAwardManager.Instance.currentSingleDungeonId);
                        this._currentTask = null;
                        break;
                    };
                };
            }
            else
            {
                if (((this._currentTask) && (!(this._currentTask.isCompleted))))
                {
                    _local_4 = this._data[this._currentTask.GuideType];
                    if (((this._currentTask.GuideType == 1) && (_arg_1 == TaskDirectorType.SINGLEDUNGEON)))
                    {
                        if (((_local_4) && (_local_4[_arg_1].length() > 0)))
                        {
                            _local_5 = this.getSingleMissionPoint(this._currentTask.GuideSceneID);
                            if (_local_5)
                            {
                                _local_6 = 0;
                                _local_7 = _local_4[_arg_1];
                                _local_8 = LayerManager.GAME_DYNAMIC_LAYER;
                                _local_5.x = (_local_5.x + int(_local_4[_arg_1][0].@diffX));
                                _local_5.y = (_local_5.y + int(_local_4[_arg_1][0].@diffY));
                                _local_6 = int(_local_4[_arg_1][0].@rotation);
                                _local_9 = 0;
                                while (_local_9 < _local_7.length())
                                {
                                    if (_local_7.@id == this._currentTask.GuideSceneID)
                                    {
                                        _local_5.x = (_local_5.x + int(_local_7.@diffX));
                                        _local_5.y = (_local_5.y + int(_local_7.@diffY));
                                        _local_6 = int(_local_7.@rotation);
                                        _local_8 = int(_local_7.@layerType);
                                        break;
                                    };
                                    _local_9++;
                                };
                                this.showArrow(_local_5.x, _local_5.y, _local_6, _local_8);
                            };
                        };
                    }
                    else
                    {
                        if (((_local_4) && (_local_4[_arg_1].length() > 0)))
                        {
                            this.showArrow(_local_4[_arg_1].@x, _local_4[_arg_1].@y, _local_4[_arg_1].@rotation, _local_4[_arg_1].@layerType, _arg_2);
                        };
                    };
                };
            };
        }

        private function showArrow(_arg_1:int, _arg_2:int, _arg_3:int=0, _arg_4:int=3, _arg_5:DisplayObjectContainer=null):void
        {
            this._arrow.x = _arg_1;
            this._arrow.y = _arg_2;
            this._arrow.rotation = _arg_3;
            this._arrow.play();
            if (_arg_5)
            {
                _arg_5.addChild(this._arrow);
            }
            else
            {
                LayerManager.Instance.addToLayer(this._arrow, _arg_4);
            };
        }

        public function removeArrow():void
        {
            if (this._arrow.parent)
            {
                this._arrow.parent.removeChild(this._arrow);
            };
            this._arrow.stop();
        }

        public function beginGuild(_arg_1:QuestInfo):void
        {
            var _local_2:XML;
            this._currentTask = _arg_1;
            if (((this._currentTask) && (!(this._currentTask.isCompleted))))
            {
                _local_2 = this._data[this._currentTask.GuideType];
                if (_local_2)
                {
                    if (this._currentTask._conditions[0].type == LivenessModel.SINGLE_DUNGEON)
                    {
                        SingleDungeonManager.Instance.loadModule(this.toDungeon);
                    }
                    else
                    {
                        if (StateManager.currentStateType == _local_2.@firstState)
                        {
                            if (TaskManager.instance.Model.taskViewIsShow)
                            {
                                TaskManager.instance.switchVisible();
                            };
                            StateManager.current.showDirect();
                        }
                        else
                        {
                            this._navigateState = _local_2.@firstState;
                            if (StateManager.currentStateType == StateType.MISSION_ROOM)
                            {
                                this.showAlert();
                            }
                            else
                            {
                                if ((((_local_2.@firstState == StateType.DUNGEON_LIST) || (_local_2.@firstState == StateType.SINGLEDUNGEON)) && (PlayerManager.Instance.checkExpedition())))
                                {
                                    MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("singledungeon.expedition.doing"));
                                }
                                else
                                {
                                    if (_local_2.@firstState == StateType.SINGLEDUNGEON)
                                    {
                                        SingleDungeonManager.Instance.loadModule(this.toDungeon);
                                    }
                                    else
                                    {
                                        StateManager.setState(_local_2.@firstState);
                                    };
                                };
                            };
                        };
                    };
                };
            };
        }

        private function toDungeon():void
        {
            StateManager.setState(StateType.SINGLEDUNGEON);
        }

        private function showAlert():void
        {
            if (this._alert)
            {
                this._alert.removeEventListener(FrameEvent.RESPONSE, this.__onResponse);
                this._alert.dispose();
            };
            this._alert = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"), LanguageMgr.GetTranslation("tank.missionsettle.dungeon.leaveConfirm.contents"), "", LanguageMgr.GetTranslation("cancel"), true, true, false, LayerManager.BLCAK_BLOCKGOUND);
            this._alert.moveEnable = false;
            this._alert.addEventListener(FrameEvent.RESPONSE, this.__onResponse);
        }

        private function __onResponse(_arg_1:FrameEvent):void
        {
            SoundManager.instance.play("008");
            this._alert.removeEventListener(FrameEvent.RESPONSE, this.__onResponse);
            this._alert.dispose();
            if (((_arg_1.responseCode == FrameEvent.ENTER_CLICK) || (_arg_1.responseCode == FrameEvent.SUBMIT_CLICK)))
            {
                StateManager.setState(this._navigateState);
                this._navigateState = null;
            };
        }

        public function initSingleIndex():void
        {
            var _local_1:MapSceneModel;
            if (((this._currentTask) && (!(this._currentTask.isCompleted))))
            {
                for each (_local_1 in this._singleMapList)
                {
                    if (_local_1.ID == this._currentTask.GuideSceneID)
                    {
                        SingleDungeonManager.Instance.maplistIndex = (_local_1.MapID - 1);
                        break;
                    };
                };
            };
        }

        private function getSingleMissionPoint(_arg_1:int):Point
        {
            var _local_2:MapSceneModel;
            for each (_local_2 in this._singleMapList)
            {
                if (_local_2.ID == _arg_1)
                {
                    if (_local_2.MapID == (SingleDungeonManager.Instance.maplistIndex + 1))
                    {
                        return (new Point(_local_2.MapX, _local_2.MapY));
                    };
                };
            };
            return (null);
        }


    }
}//package ddt.manager

class SingleEnforcer 
{


}


