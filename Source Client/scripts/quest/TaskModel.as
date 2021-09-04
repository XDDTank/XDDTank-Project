package quest
{
   import ddt.data.quest.QuestInfo;
   import ddt.events.TaskEvent;
   import ddt.utils.BitArray;
   import flash.events.EventDispatcher;
   import flash.utils.Dictionary;
   
   public class TaskModel extends EventDispatcher
   {
       
      
      public var allQuests:Dictionary;
      
      public var guideId:int;
      
      public var isFirstshowTask:Boolean = true;
      
      public var isOpenViewFromNewQuest:Boolean;
      
      public var newQuestMovieIsPlaying:Boolean;
      
      public var showQuestType:int;
      
      public var showQuestInfo:QuestInfo;
      
      public var questLog:BitArray;
      
      public var newQuests:Vector.<QuestInfo>;
      
      public var selectedQuest:QuestInfo;
      
      public var itemAwardSelected:int;
      
      public var savePointTask:Vector.<QuestInfo>;
      
      private var _taskViewIsShow:Boolean;
      
      public function TaskModel()
      {
         super();
      }
      
      public function get taskViewIsShow() : Boolean
      {
         return this._taskViewIsShow;
      }
      
      public function set taskViewIsShow(param1:Boolean) : void
      {
         this._taskViewIsShow = param1;
         dispatchEvent(new TaskEvent(TaskEvent.VIEW_SHOW_CHANGE));
      }
   }
}
