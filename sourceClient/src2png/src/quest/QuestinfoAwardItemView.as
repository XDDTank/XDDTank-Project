// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//quest.QuestinfoAwardItemView

package quest
{
    import com.pickgliss.ui.controls.container.SimpleTileList;
    import __AS3__.vec.Vector;
    import com.pickgliss.ui.image.ScaleFrameImage;
    import com.pickgliss.ui.controls.BaseButton;
    import com.pickgliss.ui.text.FilterFrameText;
    import ddt.data.quest.QuestItemReward;
    import ddt.data.goods.InventoryItemInfo;
    import ddt.manager.ItemManager;
    import ddt.manager.PlayerManager;
    import ddt.manager.TaskManager;
    import ddt.data.quest.QuestInfo;
    import com.pickgliss.ui.ComponentFactory;
    import flash.events.MouseEvent;
    import ddt.data.quest.QuestImproveInfo;
    import ddt.manager.SoundManager;
    import baglocked.BaglockedManager;
    import ddt.manager.LeavePageManager;
    import com.pickgliss.ui.LayerManager;
    import com.pickgliss.utils.ObjectUtils;
    import ddt.data.BuffInfo;
    import ddt.manager.LanguageMgr;
    import com.pickgliss.utils.StringUtils;
    import ddt.utils.PositionUtils;
    import __AS3__.vec.*;

    public class QuestinfoAwardItemView extends QuestInfoItemView 
    {

        private const ROW_HEIGHT:int = 24;
        private const ROW_X:int = 18;
        private const REWARDCELL_HEIGHT:int = 55;

        private var _isOptional:Boolean;
        private var _list:SimpleTileList;
        private var _items:Vector.<QuestRewardCell>;
        private var cardAsset:ScaleFrameImage;
        private var _improveBtn:BaseButton;
        private var _isReward:Boolean;
        private var _improveFrame:QuestImproveFrame;
        private var _rewardTxtList:Vector.<FilterFrameText>;
        private var _first:Boolean;

        public function QuestinfoAwardItemView(_arg_1:Boolean)
        {
            this._isOptional = _arg_1;
            this._first = true;
            this._items = new Vector.<QuestRewardCell>();
            super();
        }

        public function set isReward(_arg_1:Boolean):void
        {
            this._isReward = _arg_1;
        }

        override public function set info(_arg_1:QuestInfo):void
        {
            var _local_2:QuestItemReward;
            var _local_5:InventoryItemInfo;
            var _local_6:QuestRewardCell;
            this._rewardTxtList = new Vector.<FilterFrameText>();
            _info = _arg_1;
            for each (_local_2 in _info.itemRewards)
            {
                _local_5 = new InventoryItemInfo();
                _local_5.TemplateID = _local_2.itemID;
                ItemManager.fill(_local_5);
                _local_5.ValidDate = _local_2.ValidateTime;
                _local_5.IsJudge = true;
                _local_5.IsBinds = _local_2.isBind;
                _local_5.AttackCompose = _local_2.AttackCompose;
                _local_5.DefendCompose = _local_2.DefendCompose;
                _local_5.AgilityCompose = _local_2.AgilityCompose;
                _local_5.LuckCompose = _local_2.LuckCompose;
                _local_5.StrengthenLevel = _local_2.StrengthenLevel;
                _local_5.Count = _local_2.count[(_info.QuestLevel - 1)];
                if (!((!(0 == _local_5.NeedSex)) && (!(this.getSexByInt(PlayerManager.Instance.Self.Sex) == _local_5.NeedSex))))
                {
                    if (_local_2.isOptional == this._isOptional)
                    {
                        _local_6 = new QuestRewardCell();
                        _local_6.info = _local_5;
                        if (_local_2.isOptional)
                        {
                            _local_6.canBeSelected();
                            _local_6.addEventListener(RewardSelectedEvent.ITEM_SELECTED, this.__chooseItemReward);
                        };
                        this._list.addChild(_local_6);
                        this._items.push(_local_6);
                    };
                };
            };
            _panel.invalidateViewport();
            if (this._isOptional)
            {
                return;
            };
            if ((!(_info.hasOtherAward())))
            {
                this._list.y = 5;
            };
            var _local_3:int;
            var _local_4:QuestInfo = this.newInfo(_info, (_info.QuestLevel - 2), TaskManager.instance.improve);
            if (_local_4.RewardGP > 0)
            {
                this.addReward("exp", _local_4.RewardGP, _local_3);
                _local_3++;
            };
            if (_local_4.RewardGold > 0)
            {
                this.addReward("gold", _local_4.RewardGold, _local_3);
                _local_3++;
            };
            if (_local_4.RewardMoney > 0)
            {
                this.addReward("coin", _local_4.RewardMoney, _local_3);
                _local_3++;
            };
            if (_local_4.RewardHonor > 0)
            {
                this.addReward("honor", _local_4.RewardHonor, _local_3);
                _local_3++;
            };
            if (_local_4.RewardMagicSoul > 0)
            {
                this.addReward("magicSoul", _local_4.RewardMagicSoul, _local_3);
                _local_3++;
            };
            if (_info.RewardDailyActivity > 0)
            {
                this.addReward("liveness", _info.RewardDailyActivity, _local_3);
                _local_3++;
            };
            if (_info.RewardBindMoney > 0)
            {
                this.addReward("gift", _info.RewardBindMoney, _local_3);
                _local_3++;
            };
            if (_info.Rank != "")
            {
                this.addReward("rank", 0, _local_3, true, _info.Rank);
                _local_3++;
            };
            if (_info.RewardOffer > 0)
            {
                this.addReward("RewardOffer", _info.RewardOffer, _local_3);
                _local_3++;
            };
            if (_info.RewardConsortiaGP > 0)
            {
                this.addReward("RewardConsortiaGP", _info.RewardConsortiaGP, _local_3);
                _local_3++;
            };
            if (_info.RewardConsortiaRiches > 0)
            {
                this.addReward("RewardConsortiaRiches", _info.RewardConsortiaRiches, _local_3);
                _local_3++;
            };
            if (((this._isReward) && (!(this.getNeedMoney(_info) == -1))))
            {
                this._improveBtn = ComponentFactory.Instance.creatComponentByStylename("quest.improve");
                if (height > 75)
                {
                    this._improveBtn.y = ((height / 2) - 40);
                }
                else
                {
                    this._improveBtn.y = 20;
                };
                _content.addChild(this._improveBtn);
                if (_info.QuestLevel >= 5)
                {
                    this._improveBtn.enable = false;
                };
                this._improveBtn.addEventListener(MouseEvent.CLICK, this._activeimproveBtnClick);
            };
        }

        private function getNeedMoney(_arg_1:QuestInfo):int
        {
            if (_arg_1.QuestLevel == 1)
            {
                return (_arg_1.Level2NeedMoney);
            };
            if (_arg_1.QuestLevel == 2)
            {
                return (_arg_1.Level3NeedMoney);
            };
            if (_arg_1.QuestLevel == 3)
            {
                return (_arg_1.Level4NeedMoney);
            };
            if (_arg_1.QuestLevel == 4)
            {
                return (_arg_1.Level5NeedMoney);
            };
            return (-1);
        }

        private function newInfo(_arg_1:QuestInfo, _arg_2:int, _arg_3:QuestImproveInfo):QuestInfo
        {
            var _local_4:QuestInfo;
            if (_arg_2 > -1)
            {
                _local_4 = new QuestInfo();
                _local_4.RewardMoney = (Number(_arg_3.bindMoneyRate[_arg_2]) * _arg_1.RewardMoney);
                _local_4.RewardGP = (Number(_arg_3.expRate[_arg_2]) * _arg_1.RewardGP);
                _local_4.RewardGold = (Number(_arg_3.goldRate[_arg_2]) * _arg_1.RewardGold);
                _local_4.RewardHonor = (Number(_arg_3.exploitRate[_arg_2]) * _arg_1.RewardHonor);
                _local_4.RewardHonor = _arg_1.RewardHonor;
                return (_local_4);
            };
            return (_arg_1);
        }

        private function _activeimproveBtnClick(_arg_1:MouseEvent):void
        {
            SoundManager.instance.play("008");
            if (PlayerManager.Instance.Self.bagLocked)
            {
                BaglockedManager.Instance.show();
                return;
            };
            if (this.getNeedMoney(_info) > PlayerManager.Instance.Self.Money)
            {
                LeavePageManager.showFillFrame();
                return;
            };
            this._improveFrame = ComponentFactory.Instance.creat("quest.improveFrame");
            this._improveFrame.isOptional = this._isOptional;
            this._improveFrame.spand = this.getNeedMoney(_info);
            this._improveFrame.questInfo = this.getImproveInfo(TaskManager.instance.improve, (_info.QuestLevel - 1));
            LayerManager.Instance.addToLayer(this._improveFrame, LayerManager.GAME_DYNAMIC_LAYER, true, LayerManager.BLCAK_BLOCKGOUND);
        }

        private function getImproveInfo(_arg_1:QuestImproveInfo, _arg_2:int):QuestInfo
        {
            var _local_4:QuestItemReward;
            var _local_3:QuestInfo = new QuestInfo();
            ObjectUtils.copyProperties(_local_3, _info);
            _local_3.data = _info.data;
            _local_3.RewardMoney = (_local_3.RewardMoney * Number(_arg_1.bindMoneyRate[_arg_2]));
            _local_3.RewardGP = (_local_3.RewardGP * Number(_arg_1.expRate[_arg_2]));
            _local_3.RewardGold = (_local_3.RewardGold * Number(_arg_1.goldRate[_arg_2]));
            _local_3.RewardOffer = (_local_3.RewardOffer * Number(_arg_1.exploitRate[_arg_2]));
            for each (_local_4 in _info.itemRewards)
            {
                _local_3.addReward(_local_4);
            };
            return (_local_3);
        }

        private function __chooseItemReward(_arg_1:RewardSelectedEvent):void
        {
            var _local_2:QuestRewardCell;
            for each (_local_2 in this._items)
            {
                _local_2.selected = false;
            };
            _arg_1.itemCell.selected = true;
        }

        private function getSexByInt(_arg_1:Boolean):int
        {
            return ((_arg_1) ? 1 : 2);
        }

        private function addReward(_arg_1:String, _arg_2:int, _arg_3:int, _arg_4:Boolean=false, _arg_5:String=""):void
        {
            var _local_7:FilterFrameText;
            var _local_8:BuffInfo;
            var _local_9:int;
            var _local_6:FilterFrameText = ComponentFactory.Instance.creat("core.quest.MCQuestRewardType");
            if (_arg_3 > 3)
            {
                _local_6.y = (_local_6.y + 20);
                if (this._first)
                {
                    this._list.y = (this._list.y + 20);
                    this._first = false;
                };
            };
            _local_7 = ComponentFactory.Instance.creat("core.quest.QuestItemRewardQuantity");
            if (_arg_4)
            {
                _local_7.text = _arg_5;
            }
            else
            {
                _local_7.text = String(_arg_2);
            };
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
                case "liveness":
                    _local_6.text = LanguageMgr.GetTranslation("ddt.liveness.livenessValueDesc.txt");
                    break;
                case "honor":
                    _local_6.text = StringUtils.trim(LanguageMgr.GetTranslation("ddt.quest.Honor"));
                    break;
                case "magicSoul":
                    _local_6.text = LanguageMgr.GetTranslation("magicSoul");
                    break;
                case "gift":
                    _local_6.text = LanguageMgr.GetTranslation("gift");
                    break;
                case "medal":
                    _local_6.text = LanguageMgr.GetTranslation("gift");
                    break;
                case "rank":
                    _local_6.text = LanguageMgr.GetTranslation("tank.view.effort.EffortRigthItemView.honorNameII");
                    break;
                case "RewardOffer":
                    _local_8 = PlayerManager.Instance.Self.buffInfo[BuffInfo.ADD_QUEST_RICHESOFFER];
                    _local_9 = 0;
                    if (_local_8)
                    {
                        _local_9 = _local_8.Value;
                        _local_7.text = (((((_local_7.text + " (") + LanguageMgr.GetTranslation("consortion.task.skillName")) + "+") + _local_9) + ")");
                    };
                    _local_6.text = LanguageMgr.GetTranslation("consortion.ConsortionCampaign.reward.contribution.text");
                    break;
                case "RewardConsortiaGP":
                    _local_6.text = LanguageMgr.GetTranslation("consortion.ConsortionCampaign.reward.Exp.text");
                    break;
                case "RewardConsortiaRiches":
                    _local_6.text = LanguageMgr.GetTranslation("consortion.ConsortionCampaign.reward.money.text");
                    break;
            };
            if (this._rewardTxtList.length > 0)
            {
                _local_6.x = ((this._rewardTxtList[(this._rewardTxtList.length - 1)].x + this._rewardTxtList[(this._rewardTxtList.length - 1)].textWidth) + this.ROW_X);
            }
            else
            {
                _local_6.x = this.ROW_X;
            };
            _local_7.x = ((_local_6.x + _local_6.textWidth) + 5);
            _local_7.y = _local_6.y;
            this._rewardTxtList.push(_local_6);
            this._rewardTxtList.push(_local_7);
            _content.addChildAt(_local_6, 0);
            _content.addChildAt(_local_7, 0);
        }

        override protected function initView():void
        {
            super.initView();
            _titleImg = ComponentFactory.Instance.creatComponentByStylename("core.quest.eligiblyWord");
            _titleImg.setFrame(((this._isOptional) ? 1 : 2));
            addChild(_titleImg);
            this._list = new SimpleTileList(2);
            if ((!(this._isOptional)))
            {
                PositionUtils.setPos(this._list, "quest.awardPanel.listpos");
            }
            else
            {
                PositionUtils.setPos(this._list, "quest.awardPanel.listpos1");
            };
            _content.addChild(this._list);
        }

        override public function dispose():void
        {
            var _local_1:QuestRewardCell;
            for each (_local_1 in this._items)
            {
                _local_1.removeEventListener(RewardSelectedEvent.ITEM_SELECTED, this.__chooseItemReward);
                _local_1.dispose();
            };
            this._items = null;
            ObjectUtils.disposeObject(this._list);
            if (this._improveBtn)
            {
                ObjectUtils.disposeObject(this._improveBtn);
            };
            this._improveBtn = null;
            this._list = null;
            ObjectUtils.disposeObject(this.cardAsset);
            this.cardAsset = null;
            ObjectUtils.disposeObject(this._improveFrame);
            this._improveFrame = null;
            ObjectUtils.disposeObject(this._rewardTxtList);
            this._rewardTxtList = null;
            super.dispose();
        }


    }
}//package quest

