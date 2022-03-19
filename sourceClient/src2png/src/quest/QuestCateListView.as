// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//quest.QuestCateListView

package quest
{
    import com.pickgliss.ui.controls.ScrollPanel;
    import com.pickgliss.ui.controls.container.VBox;
    import flash.events.MouseEvent;
    import flash.events.Event;
    import ddt.manager.TaskManager;
    import com.pickgliss.utils.ObjectUtils;

    public class QuestCateListView extends ScrollPanel 
    {

        public static var MAX_LIST_LENGTH:int = 4;

        private var _content:VBox;
        private var _stripArr:Array;
        private var _currentStrip:TaskPannelStripView;

        public function QuestCateListView()
        {
            this._stripArr = new Array();
            this.initView();
        }

        private function initView():void
        {
        }

        public function set dataProvider(_arg_1:Array):void
        {
            var _local_4:TaskPannelStripView;
            if (_arg_1.length == 0)
            {
                return;
            };
            this.height = 0;
            this.clear();
            this._content = new VBox();
            var _local_2:Boolean;
            if (_arg_1.length > QuestCateListView.MAX_LIST_LENGTH)
            {
                _local_2 = true;
            };
            var _local_3:int;
            while (_arg_1[_local_3])
            {
                _local_4 = new TaskPannelStripView(_arg_1[_local_3]);
                _local_4.addEventListener(MouseEvent.CLICK, this.__onStripClicked);
                this._content.addChild(_local_4);
                this._stripArr.push(_local_4);
                _local_3++;
            };
            setView(this._content);
            dispatchEvent(new Event(Event.CHANGE));
        }

        public function active():void
        {
            var _local_1:TaskPannelStripView;
            for each (_local_1 in this._stripArr)
            {
                if (_local_1.info == TaskManager.instance.Model.selectedQuest)
                {
                    this.gotoStrip(_local_1);
                    _local_1.active();
                    return;
                };
            };
            if (this._stripArr[0])
            {
                this.gotoStrip(this._stripArr[0]);
                this._stripArr[0].active();
                return;
            };
        }

        private function gotoStrip(_arg_1:TaskPannelStripView):void
        {
            if (this._currentStrip == _arg_1)
            {
                return;
            };
            if (this._currentStrip)
            {
                this._currentStrip.deactive();
            };
            this._currentStrip = _arg_1;
            TaskManager.instance.jumpToQuest(this._currentStrip.info);
            dispatchEvent(new Event(Event.CHANGE));
        }

        private function __onStripClicked(_arg_1:MouseEvent):void
        {
            this.gotoStrip((_arg_1.target as TaskPannelStripView));
        }

        private function clear():void
        {
            var _local_1:TaskPannelStripView;
            if (this._content)
            {
                ObjectUtils.disposeObject(this._content);
                this._content = null;
            };
            for each (_local_1 in this._stripArr)
            {
                _local_1.removeEventListener(MouseEvent.CLICK, this.__onStripClicked);
                _local_1.dispose();
                this._stripArr = new Array();
            };
        }

        override public function dispose():void
        {
            this.clear();
            this._currentStrip.dispose();
            this._currentStrip = null;
            if (this.parent)
            {
                this.parent.removeChild(this);
            };
        }


    }
}//package quest

