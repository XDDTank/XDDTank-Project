// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//quest.TaskModel

package quest
{
    import flash.events.EventDispatcher;
    import flash.utils.Dictionary;
    import ddt.data.quest.QuestInfo;
    import ddt.utils.BitArray;
    import __AS3__.vec.Vector;
    import ddt.events.TaskEvent;

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


        public function get taskViewIsShow():Boolean
        {
            return (this._taskViewIsShow);
        }

        public function set taskViewIsShow(_arg_1:Boolean):void
        {
            this._taskViewIsShow = _arg_1;
            dispatchEvent(new TaskEvent(TaskEvent.VIEW_SHOW_CHANGE));
        }


    }
}//package quest

