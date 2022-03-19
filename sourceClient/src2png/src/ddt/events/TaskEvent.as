// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//ddt.events.TaskEvent

package ddt.events
{
    import flash.events.Event;
    import ddt.data.quest.QuestInfo;
    import ddt.data.quest.QuestDataInfo;

    public class TaskEvent extends Event 
    {

        public static const INIT:String = "init";
        public static const CHANGED:String = "changed";
        public static const ADD:String = "add";
        public static const REMOVE:String = "remove";
        public static const FINISH:String = "finish";
        public static const UPDATE_TASK:String = "update_task";
        public static const VIEW_SHOW_CHANGE:String = "view_show_change";
        public static const TASK_FRAME_HIDE:String = "task_frame_hide";
        public static const BUILDING_REFLASH:String = "building_reflash";
        public static const SHOW_ARROW:String = "show_arrow";
        public static const ROOMLIST_REFLASH:String = "roomlist_reflash";
        public static const NEW_TASK_SHOW:String = "new_task_show";
        public static const SHOW_DOWNLOAD_FRAME:String = "show_download_frame";

        private var _info:QuestInfo;
        private var _data:QuestDataInfo;

        public function TaskEvent(_arg_1:String, _arg_2:QuestInfo=null, _arg_3:QuestDataInfo=null)
        {
            if (_arg_2)
            {
                this._info = _arg_2;
            };
            if (_arg_3)
            {
                this._data = _arg_3;
            };
            super(_arg_1, false, false);
        }

        public function get info():QuestInfo
        {
            return (this._info);
        }

        public function get data():QuestDataInfo
        {
            return (this._data);
        }


    }
}//package ddt.events

