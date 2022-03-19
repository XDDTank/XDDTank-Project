// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//ddt.view.bossbox.PetAwardView

package ddt.view.bossbox
{
    import com.pickgliss.ui.controls.alert.BaseAlerFrame;
    import com.pickgliss.ui.image.MutipleImage;
    import com.pickgliss.ui.text.FilterFrameText;
    import petsBag.view.item.PetBigItem;
    import __AS3__.vec.Vector;
    import com.pickgliss.ui.controls.container.VBox;
    import com.pickgliss.ui.controls.container.HBox;
    import pet.date.PetInfo;
    import ddt.manager.LanguageMgr;
    import com.pickgliss.ui.ComponentFactory;
    import com.pickgliss.events.FrameEvent;
    import petsBag.view.item.PetSmallItem;
    import ddt.manager.SoundManager;
    import ddt.manager.DropGoodsManager;
    import bagAndInfo.BagAndInfoManager;
    import ddt.manager.PetInfoManager;
    import pet.date.PetEggInfo;
    import com.pickgliss.ui.vo.AlertInfo;
    import com.pickgliss.ui.LayerManager;
    import com.pickgliss.utils.ObjectUtils;
    import __AS3__.vec.*;

    public class PetAwardView extends BaseAlerFrame 
    {

        private var _bg:MutipleImage;
        private var _petbg:MutipleImage;
        private var _typeTip:FilterFrameText;
        private var _bestWayTip:FilterFrameText;
        private var _typeTxt:FilterFrameText;
        private var _bestWayTxt:FilterFrameText;
        private var _nameTxt:FilterFrameText;
        private var _petSkillListTxt:FilterFrameText;
        private var _properBaseTitle:FilterFrameText;
        private var _properGrowTitle:FilterFrameText;
        private var _petItem:PetBigItem;
        private var _propertyList:Vector.<PetPropertyItem>;
        private var _propertyView:VBox;
        private var _skillList:Vector.<PetAwardSkillItem>;
        private var _skillBox:HBox;
        private var _petInfo:PetInfo;

        public function PetAwardView()
        {
            this.initEvent();
        }

        override protected function init():void
        {
            super.init();
            titleText = LanguageMgr.GetTranslation("bossbox.petAwardView.title");
            this._bg = ComponentFactory.Instance.creat("bossbox.petAwardView.bg");
            addToContent(this._bg);
            this._petbg = ComponentFactory.Instance.creat("bossbox.petAwardView.petbg");
            addToContent(this._petbg);
            this._typeTip = ComponentFactory.Instance.creat("bossbox.petAwardView.typeTip");
            this._typeTip.text = LanguageMgr.GetTranslation("bossbox.petAwardView.typeTxt");
            addToContent(this._typeTip);
            this._bestWayTip = ComponentFactory.Instance.creat("bossbox.petAwardView.bestWayTip");
            this._bestWayTip.text = LanguageMgr.GetTranslation("bossbox.petAwardView.bestWayTxt");
            addToContent(this._bestWayTip);
            this._typeTxt = ComponentFactory.Instance.creat("bossbox.petAwardView.typeTxt");
            addToContent(this._typeTxt);
            this._bestWayTxt = ComponentFactory.Instance.creat("bossbox.petAwardView.bestWayTxt");
            addToContent(this._bestWayTxt);
            this._nameTxt = ComponentFactory.Instance.creat("bossbox.petAwardView.nameTxt");
            addToContent(this._nameTxt);
            this._petItem = ComponentFactory.Instance.creat("bossbox.petAwardView.petItem");
            addToContent(this._petItem);
            this._properBaseTitle = ComponentFactory.Instance.creat("bossbox.petAwardView.propertyBaseTitle");
            this._properBaseTitle.text = "初始值";
            addToContent(this._properBaseTitle);
            this._properGrowTitle = ComponentFactory.Instance.creat("bossbox.petAwardView.propertyGrowTitle");
            this._properGrowTitle.text = "成长值";
            addToContent(this._properGrowTitle);
            this.createProperty();
            this.createSkill();
            this._petSkillListTxt = ComponentFactory.Instance.creat("bossbox.petAwardView.skillListTxt");
            this._petSkillListTxt.text = LanguageMgr.GetTranslation("bossbox.petAwardView.skillListTxt");
            addToContent(this._petSkillListTxt);
        }

        private function createProperty():void
        {
            var _local_2:PetPropertyItem;
            this._propertyList = new Vector.<PetPropertyItem>();
            this._propertyView = ComponentFactory.Instance.creat("bossbox.petAwardView.propertyView");
            this._propertyView.beginChanges();
            var _local_1:int;
            while (_local_1 < 5)
            {
                _local_2 = new PetPropertyItem(_local_1);
                _local_2.setValue(0, 0);
                this._propertyList.push(_local_2);
                this._propertyView.addChild(_local_2);
                _local_1++;
            };
            this._propertyView.commitChanges();
            addToContent(this._propertyView);
        }

        private function createSkill():void
        {
            var _local_2:PetAwardSkillItem;
            this._skillList = new Vector.<PetAwardSkillItem>();
            this._skillBox = ComponentFactory.Instance.creat("bossbox.petAwardView.skillListView");
            this._skillBox.beginChanges();
            var _local_1:int;
            while (_local_1 < 5)
            {
                _local_2 = new PetAwardSkillItem();
                this._skillList.push(_local_2);
                this._skillBox.addChild(_local_2);
                _local_1++;
            };
            this._skillBox.commitChanges();
            addToContent(this._skillBox);
        }

        protected function initEvent():void
        {
            addEventListener(FrameEvent.RESPONSE, this.__response);
        }

        protected function removeEvent():void
        {
            removeEventListener(FrameEvent.RESPONSE, this.__response);
        }

        protected function __response(_arg_1:FrameEvent):void
        {
            var _local_2:PetSmallItem;
            SoundManager.instance.play("008");
            _local_2 = new PetSmallItem(null, this._petInfo);
            _local_2.mouseEnabled = false;
            _local_2.mouseChildren = false;
            DropGoodsManager.petPlay(_local_2);
            switch (_arg_1.responseCode)
            {
                case FrameEvent.ENTER_CLICK:
                case FrameEvent.SUBMIT_CLICK:
                    BagAndInfoManager.Instance.hideBagAndInfo();
                    break;
                case FrameEvent.CANCEL_CLICK:
                case FrameEvent.CLOSE_CLICK:
                case FrameEvent.ESC_CLICK:
                    break;
            };
            this.dispose();
        }

        override public function set info(_arg_1:AlertInfo):void
        {
            var _local_3:int;
            super.info = _arg_1;
            this._petInfo = PetInfoManager.instance.getPetInfoByTemplateID(int(info.data));
            this._petItem.info = this._petInfo;
            if ((!(this._petInfo)))
            {
                return;
            };
            this._typeTxt.text = this._petInfo.Charcacter;
            this._bestWayTxt.text = this._petInfo.BestUseType;
            this._nameTxt.text = LanguageMgr.GetTranslation("bossbox.petAwardView.nameTxt", this._petInfo.Name);
            this.setProperyText(this._propertyList[0], this._petInfo.Blood, this._petInfo.BloodGrow);
            this.setProperyText(this._propertyList[1], this._petInfo.Attack, this._petInfo.AttackGrow);
            this.setProperyText(this._propertyList[2], this._petInfo.Defence, this._petInfo.DefenceGrow);
            this.setProperyText(this._propertyList[3], this._petInfo.Agility, this._petInfo.AgilityGrow);
            this.setProperyText(this._propertyList[4], this._petInfo.Luck, this._petInfo.LuckGrow);
            var _local_2:int = this.getMaxPropertyIndex(this._petInfo);
            _local_3 = 1;
            while (_local_3 < 5)
            {
                this._propertyList[_local_3].setHighLight((_local_3 == _local_2));
                _local_3++;
            };
            var _local_4:Vector.<PetEggInfo> = PetInfoManager.instance.getPetEggListByKind(this._petInfo.KindID);
            if (_local_4)
            {
                _local_3 = 0;
                while (_local_3 < _local_4.length)
                {
                    this._skillList[_local_3].eggInfo = _local_4[_local_3];
                    _local_3++;
                };
            };
        }

        private function setProperyText(_arg_1:PetPropertyItem, _arg_2:int, _arg_3:int):void
        {
            _arg_1.setValue(int((_arg_2 / 100)), (_arg_3 / 100));
        }

        private function getMaxPropertyIndex(_arg_1:PetInfo):int
        {
            var _local_2:int = 1;
            var _local_3:int = _arg_1.Attack;
            if (_local_3 < _arg_1.Defence)
            {
                _local_2 = 2;
                _local_3 = _arg_1.Defence;
            };
            if (_local_3 < _arg_1.Agility)
            {
                _local_2 = 3;
                _local_3 = _arg_1.Agility;
            };
            if (_local_3 < _arg_1.Luck)
            {
                _local_2 = 4;
                _local_3 = _arg_1.Luck;
            };
            return (_local_2);
        }

        public function show():void
        {
            LayerManager.Instance.addToLayer(this, LayerManager.GAME_DYNAMIC_LAYER, true, LayerManager.BLCAK_BLOCKGOUND);
        }

        override public function dispose():void
        {
            this.removeEvent();
            ObjectUtils.disposeObject(this._bg);
            this._bg = null;
            ObjectUtils.disposeObject(this._petbg);
            this._petbg = null;
            ObjectUtils.disposeObject(this._typeTip);
            this._typeTip = null;
            ObjectUtils.disposeObject(this._bestWayTip);
            this._bestWayTip = null;
            ObjectUtils.disposeObject(this._typeTxt);
            this._typeTxt = null;
            ObjectUtils.disposeObject(this._bestWayTxt);
            this._bestWayTxt = null;
            ObjectUtils.disposeObject(this._nameTxt);
            this._nameTxt = null;
            ObjectUtils.disposeObject(this._petSkillListTxt);
            this._petSkillListTxt = null;
            ObjectUtils.disposeObject(this._petItem);
            this._petItem = null;
            ObjectUtils.disposeObject(this._propertyList);
            this._propertyList = null;
            ObjectUtils.disposeObject(this._propertyView);
            this._propertyView = null;
            while (this._skillList.length > 0)
            {
                this._skillList.shift().dispose();
            };
            this._skillList = null;
            ObjectUtils.disposeObject(this._skillBox);
            this._skillBox = null;
            this._petInfo = null;
            super.dispose();
        }


    }
}//package ddt.view.bossbox

