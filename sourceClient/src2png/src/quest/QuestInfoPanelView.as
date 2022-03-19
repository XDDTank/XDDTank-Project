// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//quest.QuestInfoPanelView

package quest
{
    import flash.display.Sprite;
    import com.pickgliss.ui.core.Disposeable;
    import ddt.data.quest.QuestInfo;
    import com.pickgliss.ui.controls.TextButton;
    import com.pickgliss.ui.controls.container.VBox;
    import com.pickgliss.ui.controls.ScrollPanel;
    import __AS3__.vec.Vector;
    import com.pickgliss.ui.ComponentFactory;
    import ddt.data.quest.QuestItemReward;
    import ddt.data.quest.QuestCondition;
    import ddt.data.goods.InventoryItemInfo;
    import ddt.manager.TaskManager;
    import ddt.manager.ItemManager;
    import ddt.manager.PlayerManager;
    import ddt.manager.SoundManager;
    import flash.events.MouseEvent;
    import ddt.manager.StateManager;
    import ddt.states.StateType;
    import ddt.manager.LanguageMgr;
    import com.pickgliss.utils.ObjectUtils;
    import __AS3__.vec.*;

    public class QuestInfoPanelView extends Sprite implements Disposeable 
    {

        private const CONDITION_HEIGHT:int = 32;
        private const CONDITION_Y:int = 0;
        private const PADDING_Y:int = 8;

        private var _info:QuestInfo;
        private var gotoCMoive:TextButton;
        private var container:VBox;
        private var panel:ScrollPanel;
        private var _extraFrame:Sprite;
        private var _items:Vector.<QuestInfoItemView>;
        private var _starLevel:int;
        private var _complete:Boolean;
        private var _isImprove:Boolean;
        private var _lastId:int;

        public function QuestInfoPanelView()
        {
            this._items = new Vector.<QuestInfoItemView>();
            this._isImprove = false;
            this.initView();
        }

        private function initView():void
        {
            this.container = ComponentFactory.Instance.creatComponentByStylename("quest.questinfoPanelView.vbox");
            this.panel = ComponentFactory.Instance.creatComponentByStylename("core.quest.QuestInfoPanel");
            this.panel.setView(this.container);
            addChild(this.panel);
        }

        public function set info(_arg_1:QuestInfo):void
        {
            var _local_2:QuestInfoItemView;
            var _local_3:Boolean;
            var _local_4:Boolean;
            var _local_5:Boolean;
            var _local_6:Boolean;
            var _local_7:int;
            var _local_8:QuestItemReward;
            var _local_10:QuestCondition;
            var _local_11:InventoryItemInfo;
            var _local_12:QuestinfoTargetItemView;
            var _local_13:QuestinfoTargetItemView;
            var _local_14:QuestinfoAwardItemView;
            var _local_15:QuestinfoAwardItemView;
            if ((((this._info == _arg_1) && (_arg_1.QuestLevel == this._starLevel)) && (_arg_1.isCompleted == this._complete)))
            {
                return;
            };
            TaskManager.instance.Model.itemAwardSelected = 0;
            this._isImprove = false;
            this._info = _arg_1;
            if (this._starLevel != this._info.QuestLevel)
            {
                this._starLevel = this._info.QuestLevel;
                if (this._lastId == this._info.QuestID)
                {
                    this._isImprove = true;
                };
            };
            this._lastId = this._info.QuestID;
            this._complete = this._info.isCompleted;
            for each (_local_2 in this._items)
            {
                _local_2.dispose();
            };
            this._items = new Vector.<QuestInfoItemView>();
            _local_3 = false;
            _local_4 = false;
            _local_5 = false;
            _local_6 = false;
            _local_7 = 0;
            while (this._info._conditions[_local_7])
            {
                _local_10 = this._info._conditions[_local_7];
                if ((!(_local_10.isOpitional)))
                {
                    _local_3 = true;
                }
                else
                {
                    _local_4 = true;
                };
                _local_7++;
            };
            if ((!(_local_5)))
            {
                _local_5 = this.info.hasOtherAward();
            };
            for each (_local_8 in this._info.itemRewards)
            {
                _local_11 = new InventoryItemInfo();
                _local_11.TemplateID = _local_8.itemID;
                ItemManager.fill(_local_11);
                if (!((!(0 == _local_11.NeedSex)) && (!(this.getSexByInt(PlayerManager.Instance.Self.Sex) == _local_11.NeedSex))))
                {
                    if (_local_8.isOptional == 0)
                    {
                        _local_5 = true;
                    }
                    else
                    {
                        if (_local_8.isOptional == 1)
                        {
                            _local_6 = true;
                        };
                    };
                };
            };
            if (_local_3)
            {
                _local_12 = new QuestinfoTargetItemView(false);
                _local_12.isImprove = this._isImprove;
                this._items.push(_local_12);
            };
            if (_local_4)
            {
                _local_13 = new QuestinfoTargetItemView(true);
                this._items.push(_local_13);
            };
            if (_local_5)
            {
                _local_14 = new QuestinfoAwardItemView(false);
                _local_14.isReward = true;
                this._items.push(_local_14);
            };
            if (_local_6)
            {
                _local_15 = new QuestinfoAwardItemView(true);
                TaskManager.instance.Model.itemAwardSelected = -1;
                this._items.push(_local_15);
            };
            var _local_9:QuestinfoDescriptionItemView = new QuestinfoDescriptionItemView();
            this._items.push(_local_9);
            for each (_local_2 in this._items)
            {
                _local_2.info = this._info;
                this.container.addChild(_local_2);
            };
            if (this.info.QuestID == TaskManager.GUIDE_QUEST_ID)
            {
                this.canGotoConsortia(true);
            }
            else
            {
                this.canGotoConsortia(false);
            };
            this.panel.invalidateViewport();
        }

        private function __onGoToConsortia(_arg_1:MouseEvent):void
        {
            SoundManager.instance.play("008");
            this.gotoCMoive.removeEventListener(MouseEvent.CLICK, this.__onGoToConsortia);
            StateManager.setState(StateType.CONSORTIA);
        }

        private function getSexByInt(_arg_1:Boolean):int
        {
            return ((_arg_1) ? 1 : 2);
        }

        public function canGotoConsortia(_arg_1:Boolean):void
        {
            if (_arg_1)
            {
                if (this.gotoCMoive == null)
                {
                    this.gotoCMoive = ComponentFactory.Instance.creatComponentByStylename("core.quest.GoToConsortiaBtn");
                    this.gotoCMoive.text = LanguageMgr.GetTranslation("tank.manager.TaskManager.GoToConsortia");
                    this.gotoCMoive.addEventListener(MouseEvent.CLICK, this.__onGoToConsortia);
                    addChild(this.gotoCMoive);
                };
            }
            else
            {
                if (this.gotoCMoive)
                {
                    this.gotoCMoive.removeEventListener(MouseEvent.CLICK, this.__onGoToConsortia);
                    removeChild(this.gotoCMoive);
                    this.gotoCMoive = null;
                };
            };
        }

        public function get info():QuestInfo
        {
            return (this._info);
        }

        public function dispose():void
        {
            while (this._items.length > 0)
            {
                this._items.shift().dispose();
            };
            this._items = null;
            ObjectUtils.disposeObject(this.gotoCMoive);
            this.gotoCMoive = null;
            ObjectUtils.disposeObject(this.container);
            this.container = null;
            ObjectUtils.disposeObject(this.panel);
            this.panel = null;
            ObjectUtils.disposeObject(this._extraFrame);
            this._extraFrame = null;
            this._info = null;
            if (parent)
            {
                parent.removeChild(this);
            };
        }


    }
}//package quest

