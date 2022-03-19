// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//quest.QuestCateView

package quest
{
    import flash.display.Sprite;
    import com.pickgliss.ui.core.Disposeable;
    import ddt.data.quest.QuestCategory;
    import com.pickgliss.ui.controls.ScrollPanel;
    import com.pickgliss.ui.controls.container.VBox;
    import com.pickgliss.ui.ComponentFactory;
    import flash.events.MouseEvent;
    import flash.events.Event;
    import ddt.manager.TaskManager;
    import ddt.events.TaskEvent;
    import ddt.manager.SoundManager;
    import ddt.manager.PlayerManager;
    import liveness.LivenessModel;
    import com.pickgliss.utils.ObjectUtils;

    public class QuestCateView extends Sprite implements Disposeable 
    {

        public static var TITLECLICKED:String = "titleClicked";
        public static var EXPANDED:String = "expanded";
        public static var COLLAPSED:String = "collapsed";
        public static const ENABLE_CHANGE:String = "enableChange";

        private const ITEM_HEIGHT:int = 38;
        private const LIST_SPACE:int = 0;
        private const LIST_PADDING:int = 10;

        private var _data:QuestCategory;
        private var _titleView:QuestCateTitleView;
        private var _listView:ScrollPanel;
        private var _itemList:VBox;
        private var _itemArr:Array;
        private var _isExpanded:Boolean;
        public var questType:int;

        public function QuestCateView(_arg_1:int=-1)
        {
            this._itemArr = new Array();
            this.questType = _arg_1;
            this.initView();
            this.initEvent();
            this.collapse();
        }

        override public function get height():Number
        {
            if (this._isExpanded)
            {
                return (210);
            };
            return (57);
        }

        public function get contentHeight():int
        {
            var _local_1:int = this._titleView.height;
            if ((!(this._isExpanded)))
            {
                return (_local_1);
            };
            if (this._data.list.length <= QuestCateListView.MAX_LIST_LENGTH)
            {
                return (_local_1 + (QuestCateListView.MAX_LIST_LENGTH * this.ITEM_HEIGHT));
            };
            return (_local_1 + this._listView.height);
        }

        public function get length():int
        {
            if (((this.data) && (this.data.list)))
            {
                return (this.data.list.length);
            };
            return (0);
        }

        public function get data():QuestCategory
        {
            return (this._data);
        }

        private function initView():void
        {
            this._titleView = new QuestCateTitleView(this.questType);
            this._titleView.x = 0;
            this._titleView.y = 0;
            addChild(this._titleView);
            this._itemList = new VBox();
            this._itemList.spacing = this.LIST_SPACE;
            this._listView = ComponentFactory.Instance.creat("core.quest.QuestItemList");
            this._listView.setView(this._itemList);
            this._listView.vScrollProxy = ScrollPanel.AUTO;
            this._listView.hScrollProxy = ScrollPanel.OFF;
            addChild(this._listView);
            this.updateData();
        }

        public function set taskStyle(_arg_1:int):void
        {
            this._titleView.taskStyle = _arg_1;
            var _local_2:int;
            while (_local_2 < this._itemArr.length)
            {
                (this._itemArr[_local_2] as TaskPannelStripView).taskStyle = _arg_1;
                _local_2++;
            };
        }

        override public function set y(_arg_1:Number):void
        {
            super.y = _arg_1;
        }

        private function initEvent():void
        {
            this._titleView.addEventListener(MouseEvent.CLICK, this.__onTitleClicked);
            this._listView.addEventListener(Event.CHANGE, this.__onListChange);
            TaskManager.instance.addEventListener(TaskEvent.CHANGED, this.__onQuestData);
        }

        private function removeEvent():void
        {
            this._titleView.removeEventListener(MouseEvent.CLICK, this.__onTitleClicked);
            this._listView.removeEventListener(Event.CHANGE, this.__onListChange);
            TaskManager.instance.removeEventListener(TaskEvent.CHANGED, this.__onQuestData);
        }

        public function initData():void
        {
            this.updateData();
        }

        public function active():Boolean
        {
            if (this._data.list.length == 0)
            {
                return (false);
            };
            this.expand();
            this.updateView();
            dispatchEvent(new Event(TITLECLICKED));
            return (true);
        }

        private function __onQuestData(_arg_1:TaskEvent):void
        {
            if ((!(TaskManager.instance.MainFrame)))
            {
                return;
            };
            this.updateData();
            if (this.isExpanded)
            {
                dispatchEvent(new Event(TITLECLICKED));
            };
        }

        private function __onTitleClicked(_arg_1:MouseEvent):void
        {
            SoundManager.instance.play("008");
            TaskManager.instance.MainFrame.currentNewCateView = null;
            if ((!(this._isExpanded)))
            {
                this.active();
            };
        }

        private function __onListChange(_arg_1:Event):void
        {
            this.updateView();
        }

        public function set dataProvider(_arg_1:Array):void
        {
        }

        private function updateView():void
        {
            this.updateTitleView();
            dispatchEvent(new Event(Event.CHANGE));
        }

        public function get isExpanded():Boolean
        {
            return (this._isExpanded);
        }

        public function collapse():void
        {
            if (this._isExpanded == false)
            {
                return;
            };
            this._isExpanded = false;
            this._titleView.isExpanded = this._isExpanded;
            this._listView.visible = false;
            if (this._listView.parent == this)
            {
                removeChild(this._listView);
            };
            this.updateTitleView();
            dispatchEvent(new Event(COLLAPSED));
        }

        public function expand():void
        {
            var _local_1:TaskPannelStripView;
            this._isExpanded = true;
            this.updateData();
            this._titleView.isExpanded = this._isExpanded;
            this._listView.visible = true;
            addChild(this._listView);
            for each (_local_1 in this._itemArr)
            {
                _local_1.onShow();
            };
            this.updateTitleView();
            dispatchEvent(new Event(EXPANDED));
        }

        private function set enable(_arg_1:Boolean):void
        {
            if (_arg_1)
            {
                this._titleView.enable = true;
            }
            else
            {
                this._titleView.haveNoTag();
                this._titleView.enable = false;
                this.collapse();
            };
            if (visible != _arg_1)
            {
                visible = _arg_1;
                dispatchEvent(new Event(ENABLE_CHANGE));
            };
        }

        private function updateData():void
        {
            var _local_1:TaskPannelStripView;
            var _local_2:Boolean;
            var _local_3:uint;
            var _local_4:Boolean;
            var _local_5:TaskPannelStripView;
            this._data = TaskManager.instance.getAvailableQuests(this.questType);
            if (((this._data.list.length == 0) || ((this.questType == 4) && (PlayerManager.Instance.Self.Grade < 3))))
            {
                this.enable = false;
                return;
            };
            this.enable = true;
            this.updateTitleView();
            if ((!(this.isExpanded)))
            {
                return;
            };
            if (this._data.list.length > QuestCateListView.MAX_LIST_LENGTH)
            {
                _local_4 = true;
            };
            for each (_local_1 in this._itemArr)
            {
                _local_1.dispose();
            };
            this._itemList.disposeAllChildren();
            this._itemArr = new Array();
            _local_2 = false;
            _local_3 = 0;
            for (;_local_3 < this._data.list.length;_local_3++)
            {
                _local_5 = new TaskPannelStripView(this._data.list[_local_3]);
                _local_5.addEventListener(TaskEvent.CHANGED, this.__onItemActived);
                if (_local_4)
                {
                    _local_5.x = 3;
                }
                else
                {
                    _local_5.x = this.LIST_PADDING;
                };
                if (TaskManager.instance.Model.showQuestInfo)
                {
                    if (_local_5.info.id == TaskManager.instance.Model.showQuestInfo.id)
                    {
                        _local_5.active();
                        _local_2 = true;
                    };
                }
                else
                {
                    if (TaskManager.instance.Model.selectedQuest)
                    {
                        if ((((_local_5.info.id == 363) || (_local_5.info.id == TaskManager.instance.Model.selectedQuest.id)) || (_local_5.info.isCompleted)))
                        {
                            _local_5.active();
                            _local_2 = true;
                        };
                    };
                };
                if (_local_5.info.Condition != LivenessModel.CONSORTION_TASK)
                {
                    if (_local_5.info.Condition == 5)
                    {
                        if (_local_5.info._conditions[0].param == LivenessModel.MONSTER_REFLASH)
                        {
                            if (PlayerManager.Instance.Self.ConsortiaID == 0) continue;
                        };
                    };
                    if (_local_5.info.Condition == LivenessModel.CONSORTION_CONVOY)
                    {
                        if (PlayerManager.Instance.Self.ConsortiaID == 0) continue;
                    };
                    this._itemArr.push(_local_5);
                    this._itemList.addChild(_local_5);
                };
            };
            if ((!(_local_2)))
            {
                (this._itemArr[0] as TaskPannelStripView).active();
            };
            this._listView.invalidateViewport();
        }

        private function __onItemActived(_arg_1:TaskEvent):void
        {
            var _local_2:int;
            while (_local_2 < this._itemList.numChildren)
            {
                if ((this._itemList.getChildAt(_local_2) as TaskPannelStripView).info != _arg_1.info)
                {
                    (this._itemList.getChildAt(_local_2) as TaskPannelStripView).status = "normal";
                };
                (this._itemList.getChildAt(_local_2) as TaskPannelStripView).update();
                _local_2++;
            };
        }

        private function updateTitleView():void
        {
            if (this._isExpanded)
            {
                this._titleView.haveNoTag();
                return;
            };
            if (this._data.haveCompleted)
            {
                this._titleView.haveCompleted();
            }
            else
            {
                if (this._data.haveRecommend)
                {
                    this._titleView.haveRecommond();
                }
                else
                {
                    if (this._data.haveNew)
                    {
                        this._titleView.haveNew();
                    }
                    else
                    {
                        this._titleView.haveNoTag();
                    };
                };
            };
            if (this._isExpanded)
            {
            };
        }

        public function dispose():void
        {
            var _local_1:TaskPannelStripView;
            this.removeEvent();
            this._data = null;
            if (this._titleView)
            {
                ObjectUtils.disposeObject(this._titleView);
            };
            this._titleView = null;
            if (this._itemList)
            {
                this._itemList.disposeAllChildren();
                ObjectUtils.disposeObject(this._itemList);
                this._itemList = null;
            };
            if (this._listView)
            {
                ObjectUtils.disposeObject(this._listView);
            };
            this._listView = null;
            while ((_local_1 = this._itemArr.pop()))
            {
                if (_local_1)
                {
                    _local_1.removeEventListener(TaskEvent.CHANGED, this.__onItemActived);
                    _local_1.dispose();
                };
                _local_1 = null;
            };
            this._itemArr = null;
            if (this.parent)
            {
                this.parent.removeChild(this);
            };
        }


    }
}//package quest

