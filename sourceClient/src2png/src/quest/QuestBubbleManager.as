// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//quest.QuestBubbleManager

package quest
{
    import flash.events.EventDispatcher;
    import flash.events.Event;
    import com.pickgliss.utils.ObjectUtils;

    public class QuestBubbleManager extends EventDispatcher 
    {

        private static var _instance:QuestBubbleManager;

        public const SHOWTASKTIP:String = "show_task_tip";

        private var _view:QuestBubble;
        private var _model:QuestBubbleMode;


        public static function get Instance():QuestBubbleManager
        {
            if (_instance == null)
            {
                _instance = new (QuestBubbleManager)();
            };
            return (_instance);
        }


        public function get view():QuestBubble
        {
            return (this._view);
        }

        public function show():void
        {
            if (this._view)
            {
                return;
            };
            this._model = new QuestBubbleMode();
            if (this._model.questsInfo.length <= 0)
            {
                this._model = null;
                dispatchEvent(new Event(this.SHOWTASKTIP));
                return;
            };
            this._view = new QuestBubble();
            this._view.start(this._model.questsInfo);
            this._view.show();
        }

        public function dispose(_arg_1:Boolean=false):void
        {
            ObjectUtils.disposeObject(this._view);
            this._view = null;
        }


    }
}//package quest

