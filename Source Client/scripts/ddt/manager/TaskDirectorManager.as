package ddt.manager
{
   import SingleDungeon.SingleDungeonManager;
   import SingleDungeon.model.MapSceneModel;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.utils.ClassUtils;
   import ddt.data.TaskDirectorType;
   import ddt.data.quest.QuestInfo;
   import ddt.events.TaskEvent;
   import ddt.states.StateType;
   import flash.display.DisplayObjectContainer;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.geom.Point;
   import flash.net.URLLoader;
   import flash.net.URLRequest;
   import flash.utils.Dictionary;
   import liveness.LivenessAwardManager;
   import liveness.LivenessModel;
   
   public class TaskDirectorManager
   {
      
      private static var _instance:TaskDirectorManager;
       
      
      private var _data:Dictionary;
      
      private var _singleMapList:Vector.<MapSceneModel>;
      
      private var _arrow:MovieClip;
      
      private var _currentTask:QuestInfo;
      
      private var _navigateState:String;
      
      private var _alert:BaseAlerFrame;
      
      public function TaskDirectorManager(param1:SingleEnforcer)
      {
         super();
         if(!param1)
         {
            throw new Error("无法初始化");
         }
      }
      
      public static function get instance() : TaskDirectorManager
      {
         if(!_instance)
         {
            _instance = new TaskDirectorManager(new SingleEnforcer());
         }
         return _instance;
      }
      
      public function setup() : void
      {
         var _loc1_:URLLoader = new URLLoader();
         _loc1_.addEventListener(Event.COMPLETE,this.__taskLoaded);
         _loc1_.load(new URLRequest(PathManager.getTaskDirectorPath()));
         this._singleMapList = SingleDungeonManager.Instance.mapSceneList;
         this._arrow = ClassUtils.CreatInstance("asset.trainer.TrainerArrowAsset");
         this._arrow.stop();
         this._arrow.mouseEnabled = false;
         this._arrow.mouseChildren = false;
         TaskManager.instance.addEventListener(TaskEvent.CHANGED,this.__taskFinished);
      }
      
      protected function __taskLoaded(param1:Event) : void
      {
         var _loc4_:XML = null;
         var _loc2_:URLLoader = param1.target as URLLoader;
         _loc2_.removeEventListener(Event.COMPLETE,this.__taskLoaded);
         var _loc3_:XML = new XML(_loc2_.data);
         this._data = new Dictionary();
         for each(_loc4_ in _loc3_.Director)
         {
            this._data[int(_loc4_.@id)] = _loc4_;
         }
      }
      
      protected function __taskFinished(param1:TaskEvent) : void
      {
         if(!this._currentTask || this._currentTask.QuestID == param1.info.QuestID && param1.data.isCompleted)
         {
            this._currentTask = null;
            this.removeArrow();
         }
      }
      
      public function update() : void
      {
         if(!this._currentTask || this._currentTask.isCompleted)
         {
            this._currentTask = null;
            this.removeArrow();
         }
      }
      
      public function showDirector(param1:String, param2:DisplayObjectContainer = null) : void
      {
         var _loc3_:MapSceneModel = null;
         var _loc4_:XML = null;
         var _loc5_:Point = null;
         var _loc6_:int = 0;
         var _loc7_:XMLList = null;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         this.removeArrow();
         if(this._currentTask && this._currentTask._conditions.length > 0 && this._currentTask._conditions[0].type == LivenessModel.SINGLE_DUNGEON)
         {
            for each(_loc3_ in SingleDungeonManager.Instance.mapSceneList)
            {
               if(_loc3_.ID == LivenessAwardManager.Instance.currentSingleDungeonId)
               {
                  SingleDungeonManager.Instance.maplistIndex = _loc3_.MapID - 1;
                  SingleDungeonManager.Instance._singleDungeonWalkMapModel._mapSceneModel = _loc3_;
                  SocketManager.Instance.out.sendEnterWalkScene(LivenessAwardManager.Instance.currentSingleDungeonId);
                  this._currentTask = null;
                  break;
               }
            }
         }
         else if(this._currentTask && !this._currentTask.isCompleted)
         {
            _loc4_ = this._data[this._currentTask.GuideType];
            if(this._currentTask.GuideType == 1 && param1 == TaskDirectorType.SINGLEDUNGEON)
            {
               if(_loc4_ && _loc4_[param1].length() > 0)
               {
                  _loc5_ = this.getSingleMissionPoint(this._currentTask.GuideSceneID);
                  if(_loc5_)
                  {
                     _loc6_ = 0;
                     _loc7_ = _loc4_[param1];
                     _loc8_ = LayerManager.GAME_DYNAMIC_LAYER;
                     _loc5_.x += int(_loc4_[param1][0].@diffX);
                     _loc5_.y += int(_loc4_[param1][0].@diffY);
                     _loc6_ = int(_loc4_[param1][0].@rotation);
                     _loc9_ = 0;
                     while(_loc9_ < _loc7_.length())
                     {
                        if(_loc7_.@id == this._currentTask.GuideSceneID)
                        {
                           _loc5_.x += int(_loc7_.@diffX);
                           _loc5_.y += int(_loc7_.@diffY);
                           _loc6_ = int(_loc7_.@rotation);
                           _loc8_ = int(_loc7_.@layerType);
                           break;
                        }
                        _loc9_++;
                     }
                     this.showArrow(_loc5_.x,_loc5_.y,_loc6_,_loc8_);
                  }
               }
            }
            else if(_loc4_ && _loc4_[param1].length() > 0)
            {
               this.showArrow(_loc4_[param1].@x,_loc4_[param1].@y,_loc4_[param1].@rotation,_loc4_[param1].@layerType,param2);
            }
         }
      }
      
      private function showArrow(param1:int, param2:int, param3:int = 0, param4:int = 3, param5:DisplayObjectContainer = null) : void
      {
         this._arrow.x = param1;
         this._arrow.y = param2;
         this._arrow.rotation = param3;
         this._arrow.play();
         if(param5)
         {
            param5.addChild(this._arrow);
         }
         else
         {
            LayerManager.Instance.addToLayer(this._arrow,param4);
         }
      }
      
      public function removeArrow() : void
      {
         if(this._arrow.parent)
         {
            this._arrow.parent.removeChild(this._arrow);
         }
         this._arrow.stop();
      }
      
      public function beginGuild(param1:QuestInfo) : void
      {
         var _loc2_:XML = null;
         this._currentTask = param1;
         if(this._currentTask && !this._currentTask.isCompleted)
         {
            _loc2_ = this._data[this._currentTask.GuideType];
            if(_loc2_)
            {
               if(this._currentTask._conditions[0].type == LivenessModel.SINGLE_DUNGEON)
               {
                  SingleDungeonManager.Instance.loadModule(this.toDungeon);
               }
               else if(StateManager.currentStateType == _loc2_.@firstState)
               {
                  if(TaskManager.instance.Model.taskViewIsShow)
                  {
                     TaskManager.instance.switchVisible();
                  }
                  StateManager.current.showDirect();
               }
               else
               {
                  this._navigateState = _loc2_.@firstState;
                  if(StateManager.currentStateType == StateType.MISSION_ROOM)
                  {
                     this.showAlert();
                  }
                  else if((_loc2_.@firstState == StateType.DUNGEON_LIST || _loc2_.@firstState == StateType.SINGLEDUNGEON) && PlayerManager.Instance.checkExpedition())
                  {
                     MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("singledungeon.expedition.doing"));
                  }
                  else if(_loc2_.@firstState == StateType.SINGLEDUNGEON)
                  {
                     SingleDungeonManager.Instance.loadModule(this.toDungeon);
                  }
                  else
                  {
                     StateManager.setState(_loc2_.@firstState);
                  }
               }
            }
         }
      }
      
      private function toDungeon() : void
      {
         StateManager.setState(StateType.SINGLEDUNGEON);
      }
      
      private function showAlert() : void
      {
         if(this._alert)
         {
            this._alert.removeEventListener(FrameEvent.RESPONSE,this.__onResponse);
            this._alert.dispose();
         }
         this._alert = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("tank.missionsettle.dungeon.leaveConfirm.contents"),"",LanguageMgr.GetTranslation("cancel"),true,true,false,LayerManager.BLCAK_BLOCKGOUND);
         this._alert.moveEnable = false;
         this._alert.addEventListener(FrameEvent.RESPONSE,this.__onResponse);
      }
      
      private function __onResponse(param1:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         this._alert.removeEventListener(FrameEvent.RESPONSE,this.__onResponse);
         this._alert.dispose();
         if(param1.responseCode == FrameEvent.ENTER_CLICK || param1.responseCode == FrameEvent.SUBMIT_CLICK)
         {
            StateManager.setState(this._navigateState);
            this._navigateState = null;
         }
      }
      
      public function initSingleIndex() : void
      {
         var _loc1_:MapSceneModel = null;
         if(this._currentTask && !this._currentTask.isCompleted)
         {
            for each(_loc1_ in this._singleMapList)
            {
               if(_loc1_.ID == this._currentTask.GuideSceneID)
               {
                  SingleDungeonManager.Instance.maplistIndex = _loc1_.MapID - 1;
                  break;
               }
            }
         }
      }
      
      private function getSingleMissionPoint(param1:int) : Point
      {
         var _loc2_:MapSceneModel = null;
         for each(_loc2_ in this._singleMapList)
         {
            if(_loc2_.ID == param1)
            {
               if(_loc2_.MapID == SingleDungeonManager.Instance.maplistIndex + 1)
               {
                  return new Point(_loc2_.MapX,_loc2_.MapY);
               }
            }
         }
         return null;
      }
   }
}

class SingleEnforcer
{
    
   
   function SingleEnforcer()
   {
      super();
   }
}
