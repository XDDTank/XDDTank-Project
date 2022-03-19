// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//quest.QuestImproveFrame

package quest
{
    import com.pickgliss.ui.controls.alert.BaseAlerFrame;
    import com.pickgliss.ui.image.ScaleBitmapImage;
    import com.pickgliss.ui.text.FilterFrameText;
    import flash.display.Sprite;
    import ddt.data.quest.QuestInfo;
    import com.pickgliss.ui.controls.container.SimpleTileList;
    import __AS3__.vec.Vector;
    import com.pickgliss.ui.vo.AlertInfo;
    import ddt.manager.LanguageMgr;
    import com.pickgliss.events.FrameEvent;
    import com.pickgliss.ui.ComponentFactory;
    import ddt.utils.PositionUtils;
    import ddt.data.quest.QuestItemReward;
    import ddt.data.goods.InventoryItemInfo;
    import ddt.manager.ItemManager;
    import ddt.manager.PlayerManager;
    import com.pickgliss.utils.StringUtils;
    import ddt.manager.SoundManager;
    import ddt.manager.SocketManager;
    import com.pickgliss.utils.ObjectUtils;
    import __AS3__.vec.*;

    public class QuestImproveFrame extends BaseAlerFrame 
    {

        private var _bg:ScaleBitmapImage;
        private var _textFieldStyle:String;
        protected var _textField:FilterFrameText;
        private var _contian:Sprite;
        private var _questInfo:QuestInfo;
        private var _isOptional:Boolean;
        private var _list:SimpleTileList;
        private var _items:Vector.<QuestRewardCell>;
        private var _spand:int;
        private var _first:Boolean;

        public function QuestImproveFrame()
        {
            var _local_1:AlertInfo = new AlertInfo(LanguageMgr.GetTranslation("tank.view.task.TaskCatalogContentView.tip"));
            _local_1.submitLabel = LanguageMgr.GetTranslation("ok");
            _local_1.moveEnable = false;
            info = _local_1;
            this._first = true;
            this._items = new Vector.<QuestRewardCell>();
            addEventListener(FrameEvent.RESPONSE, this.__confirmResponse);
            this.initView();
        }

        public function set spand(_arg_1:int):void
        {
            this._spand = _arg_1;
            this._textField.htmlText = LanguageMgr.GetTranslation("tank.manager.TaskManager.improveText", this._spand);
        }

        public function set isOptional(_arg_1:Boolean):void
        {
            this._isOptional = _arg_1;
        }

        private function initView():void
        {
            this._contian = new Sprite();
            this._contian.y = 40;
            addToContent(this._contian);
            this._textField = ComponentFactory.Instance.creat("core.quest.QuestSpandText");
            addToContent(this._textField);
            this._bg = ComponentFactory.Instance.creatComponentByStylename("core.questBack.bg");
            this._contian.addChild(this._bg);
            this._list = new SimpleTileList(2);
            if ((!(this._isOptional)))
            {
                PositionUtils.setPos(this._list, "quest.awardPanel.listposr");
            }
            else
            {
                PositionUtils.setPos(this._list, "quest.awardPanel.listposr1");
            };
            this._contian.addChild(this._list);
        }

        public function set questInfo(_arg_1:QuestInfo):void
        {
            var _local_2:QuestItemReward;
            var _local_4:InventoryItemInfo;
            var _local_5:int;
            var _local_6:QuestRewardCell;
            this._questInfo = _arg_1;
            for each (_local_2 in this._questInfo.itemRewards)
            {
                _local_4 = new InventoryItemInfo();
                _local_4.TemplateID = _local_2.itemID;
                ItemManager.fill(_local_4);
                _local_4.ValidDate = _local_2.ValidateTime;
                _local_4.IsJudge = true;
                _local_4.IsBinds = _local_2.isBind;
                _local_4.AttackCompose = _local_2.AttackCompose;
                _local_4.DefendCompose = _local_2.DefendCompose;
                _local_4.AgilityCompose = _local_2.AgilityCompose;
                _local_4.LuckCompose = _local_2.LuckCompose;
                _local_4.StrengthenLevel = _local_2.StrengthenLevel;
                if (this._questInfo.QuestLevel > 4)
                {
                    _local_5 = 4;
                }
                else
                {
                    _local_5 = this._questInfo.QuestLevel;
                };
                _local_4.Count = _local_2.count[_local_5];
                if (!((!(0 == _local_4.NeedSex)) && (!(this.getSexByInt(PlayerManager.Instance.Self.Sex) == _local_4.NeedSex))))
                {
                    if (_local_2.isOptional == this._isOptional)
                    {
                        _local_6 = new QuestRewardCell();
                        _local_6.info = _local_4;
                        if (_local_2.isOptional)
                        {
                            _local_6.canBeSelected();
                        };
                        this._list.addChild(_local_6);
                        this._items.push(_local_6);
                    };
                };
            };
            if (this._isOptional)
            {
                return;
            };
            if ((!(this._questInfo.hasOtherAward())))
            {
                this._list.y = 5;
            };
            var _local_3:int;
            if (this._questInfo.RewardGP > 0)
            {
                this.addReward("exp", this._questInfo.RewardGP, _local_3);
                _local_3++;
            };
            if (this._questInfo.RewardGold > 0)
            {
                this.addReward("gold", this._questInfo.RewardGold, _local_3);
                _local_3++;
            };
            if (this._questInfo.RewardMoney > 0)
            {
                this.addReward("coin", this._questInfo.RewardMoney, _local_3);
                _local_3++;
            };
            if (this._questInfo.RewardHonor > 0)
            {
                this.addReward("honor", this._questInfo.RewardHonor, _local_3);
                _local_3++;
            };
            if (this._questInfo.RewardBindMoney > 0)
            {
                this.addReward("gift", this._questInfo.RewardBindMoney, _local_3);
                _local_3++;
            };
            if (this._questInfo.Rank != "")
            {
                this.addReward("rank", 0, _local_3, true, this._questInfo.Rank);
                _local_3++;
            };
            this._textField.x = ((this._contian.width - this._textField.width) / 2);
            this._bg.height = (this._contian.height + 12);
            height = (140 + this._contian.height);
        }

        private function getSexByInt(_arg_1:Boolean):int
        {
            return ((_arg_1) ? 1 : 2);
        }

        private function addReward(_arg_1:String, _arg_2:int, _arg_3:int, _arg_4:Boolean=false, _arg_5:String=""):void
        {
            var _local_6:FilterFrameText = ComponentFactory.Instance.creat("core.quest.MCQuestRewardImprove");
            if (_arg_3 > 2)
            {
                _local_6.y = (_local_6.y + 20);
                if (this._first)
                {
                    this._list.y = (this._list.y + 20);
                    this._first = false;
                };
            };
            var _local_7:FilterFrameText = ComponentFactory.Instance.creat("core.quest.QuestItemRewardQuantity");
            switch (_arg_1)
            {
                case "exp":
                    _local_6.text = LanguageMgr.GetTranslation("exp");
                    break;
                case "gold":
                    _local_6.text = LanguageMgr.GetTranslation("gold");
                    break;
                case "coin":
                    _local_6.text = LanguageMgr.GetTranslation("money");
                    break;
                case "rich":
                    _local_6.text = LanguageMgr.GetTranslation("consortia.Money");
                    break;
                case "honor":
                    _local_6.text = StringUtils.trim(LanguageMgr.GetTranslation("ddt.quest.Honor"));
                    break;
                case "gift":
                    _local_6.text = LanguageMgr.GetTranslation("gift");
                    break;
                case "medal":
                    _local_6.text = LanguageMgr.GetTranslation("consortion.skillFrame.richesText3");
                    break;
                case "rank":
                    _local_6.text = LanguageMgr.GetTranslation("tank.view.effort.EffortRigthItemView.honorNameII");
                    break;
            };
            _local_6.x = (((_arg_3 % 3) * 90) + 18);
            _local_7.x = ((_local_6.x + _local_6.textWidth) + 5);
            _local_7.y = _local_6.y;
            if (_arg_4)
            {
                _local_7.text = _arg_5;
            }
            else
            {
                _local_7.text = String(_arg_2);
            };
            this._contian.addChild(_local_6);
            this._contian.addChild(_local_7);
        }

        private function __confirmResponse(_arg_1:FrameEvent):void
        {
            SoundManager.instance.play("008");
            removeEventListener(FrameEvent.RESPONSE, this.__confirmResponse);
            switch (_arg_1.responseCode)
            {
                case FrameEvent.CLOSE_CLICK:
                    this.dispose();
                    return;
                case FrameEvent.CANCEL_CLICK:
                    this.dispose();
                    return;
                case FrameEvent.ESC_CLICK:
                    this.dispose();
                    return;
                case FrameEvent.ENTER_CLICK:
                    SocketManager.Instance.out.sendImproveQuest(this._questInfo.id);
                    this.dispose();
                    return;
                case FrameEvent.SUBMIT_CLICK:
                    SocketManager.Instance.out.sendImproveQuest(this._questInfo.id);
                    this.dispose();
                    return;
            };
        }

        override public function dispose():void
        {
            if (this._bg)
            {
                ObjectUtils.disposeObject(this._bg);
            };
            this._bg = null;
            ObjectUtils.disposeObject(this._textField);
            this._textField = null;
            if (this._contian)
            {
                ObjectUtils.disposeObject(this._contian);
            };
            this._contian = null;
            if (this._list)
            {
                ObjectUtils.disposeObject(this._list);
            };
            this._list = null;
            super.dispose();
        }


    }
}//package quest

