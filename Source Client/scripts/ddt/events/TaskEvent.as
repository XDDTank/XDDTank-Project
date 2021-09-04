package ddt.events
{
   import ddt.data.quest.QuestDataInfo;
   import ddt.data.quest.QuestInfo;
   import flash.events.Event;
   
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
      
      public function TaskEvent(param1:String, param2:QuestInfo = null, param3:QuestDataInfo = null)
      {
         if(param2)
         {
            this._info = param2;
         }
         if(param3)
         {
            this._data = param3;
         }
         super(param1,false,false);
      }
      
      public function get info() : QuestInfo
      {
         return this._info;
      }
      
      public function get data() : QuestDataInfo
      {
         return this._data;
      }
   }
}
