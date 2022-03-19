// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//petsBag.view.PetInfoView

package petsBag.view
{
    import flash.display.Sprite;
    import com.pickgliss.ui.core.Disposeable;
    import com.pickgliss.ui.text.FilterFrameText;
    import com.pickgliss.ui.controls.TextButton;
    import petsBag.view.item.PetExpProgress;
    import flash.display.MovieClip;
    import petsBag.view.item.PetBigItem;
    import flash.display.Bitmap;
    import petsBag.view.item.PetBloodProgress;
    import com.pickgliss.ui.image.MutipleImage;
    import __AS3__.vec.Vector;
    import com.pickgliss.ui.image.Scale9CornerImage;
    import petsBag.view.item.SkillItem;
    import com.pickgliss.ui.controls.BaseButton;
    import pet.date.PetInfo;
    import com.pickgliss.ui.ComponentFactory;
    import ddt.manager.LanguageMgr;
    import flash.events.MouseEvent;
    import flash.events.Event;
    import ddt.manager.SoundManager;
    import com.pickgliss.events.FrameEvent;
    import com.pickgliss.utils.ObjectUtils;
    import ddt.manager.PlayerManager;
    import baglocked.BaglockedManager;
    import ddt.manager.SocketManager;
    import ddt.manager.PetBagManager;
    import ddt.manager.PetInfoManager;
    import ddt.data.PetExperienceManager;
    import ddt.manager.PetSkillManager;
    import com.pickgliss.ui.AlertManager;
    import __AS3__.vec.*;

    public class PetInfoView extends Sprite implements Disposeable 
    {

        private var _nameTxt:FilterFrameText;
        private var _levelTxt:FilterFrameText;
        private var _orderTxt:FilterFrameText;
        private var _changeNameBtn:TextButton;
        private var _expBar:PetExpProgress;
        private var _advanceBottom:MovieClip;
        private var _pet:PetBigItem;
        private var _advanceTop:MovieClip;
        private var _fightFlag:Bitmap;
        private var _bloodBar:PetBloodProgress;
        private var _attackLabel:FilterFrameText;
        private var _attackTxt:FilterFrameText;
        private var _defenceLabel:FilterFrameText;
        private var _defenceTxt:FilterFrameText;
        private var _agilityLabel:FilterFrameText;
        private var _agilityTxt:FilterFrameText;
        private var _luckLabel:FilterFrameText;
        private var _luckTxt:FilterFrameText;
        private var _attackBg:MutipleImage;
        private var _defenceBg:MutipleImage;
        private var _agilityBg:MutipleImage;
        private var _luckBg:MutipleImage;
        private var _reNameAlert:RePetNameFrame;
        private var _skillBgList:Vector.<Scale9CornerImage>;
        private var _skillList:Vector.<SkillItem>;
        private var _fightBtn:BaseButton;
        private var _unfightBtn:BaseButton;
        private var _info:PetInfo;
        private var _nextID:int;

        public function PetInfoView()
        {
            this.init();
            this.initEvent();
        }

        protected function init():void
        {
            var _local_2:Scale9CornerImage;
            var _local_3:SkillItem;
            this._nameTxt = ComponentFactory.Instance.creat("petsBag.view.infoView.nameTxt");
            addChild(this._nameTxt);
            this._levelTxt = ComponentFactory.Instance.creat("petsBag.view.infoView.levelTxt");
            addChild(this._levelTxt);
            this._orderTxt = ComponentFactory.Instance.creat("petsBag.view.infoView.orderTxt");
            addChild(this._orderTxt);
            this._changeNameBtn = ComponentFactory.Instance.creat("petsBag.view.infoView.changeNameBtn");
            this._changeNameBtn.text = LanguageMgr.GetTranslation("ddt.pets.rePetName");
            this._changeNameBtn.visible = true;
            addChild(this._changeNameBtn);
            this._expBar = ComponentFactory.Instance.creat("petsBag.view.infoView.petExpBar");
            addChild(this._expBar);
            this._advanceBottom = ComponentFactory.Instance.creat("petsBag.view.infoView.advanceBottom");
            this._advanceBottom.mouseEnabled = false;
            this._advanceBottom.mouseChildren = false;
            this._advanceBottom.stop();
            this._advanceBottom.visible = false;
            addChild(this._advanceBottom);
            this._pet = ComponentFactory.Instance.creat("petsBag.view.infoView.petItem");
            this._pet.showTip = true;
            addChild(this._pet);
            this._advanceTop = ComponentFactory.Instance.creat("petsBag.view.infoView.advanceTop");
            this._advanceTop.mouseEnabled = false;
            this._advanceTop.mouseChildren = false;
            this._advanceTop.stop();
            this._advanceTop.visible = false;
            addChild(this._advanceTop);
            this._fightFlag = ComponentFactory.Instance.creat("asset.petsBag.view.petInfoView.fightFlag");
            addChild(this._fightFlag);
            this._skillBgList = new Vector.<Scale9CornerImage>();
            this._skillList = new Vector.<SkillItem>();
            var _local_1:int;
            while (_local_1 < 4)
            {
                _local_2 = ComponentFactory.Instance.creat(("petsBag.view.skilBg" + _local_1));
                addChild(_local_2);
                this._skillBgList.push(_local_2);
                _local_3 = ComponentFactory.Instance.creat(("petsBag.petInfoView.skill" + _local_1));
                addChild(_local_3);
                this._skillList.push(_local_3);
                _local_1++;
            };
            this._bloodBar = ComponentFactory.Instance.creat("petsBag.view.infoView.bloodBar");
            addChild(this._bloodBar);
            this._attackBg = ComponentFactory.Instance.creatComponentByStylename("petsBag.view.infoView.attackBg");
            addChild(this._attackBg);
            this._defenceBg = ComponentFactory.Instance.creatComponentByStylename("petsBag.view.infoView.defenceBg");
            addChild(this._defenceBg);
            this._agilityBg = ComponentFactory.Instance.creatComponentByStylename("petsBag.view.infoView.agilityBg");
            addChild(this._agilityBg);
            this._luckBg = ComponentFactory.Instance.creatComponentByStylename("petsBag.view.infoView.luckBg");
            addChild(this._luckBg);
            this._attackLabel = ComponentFactory.Instance.creat("petsBag.view.infoView.attackLabel");
            this._attackLabel.text = LanguageMgr.GetTranslation("pets.bag.attack");
            addChild(this._attackLabel);
            this._attackTxt = ComponentFactory.Instance.creat("petsBag.view.infoView.attackTxt");
            addChild(this._attackTxt);
            this._defenceLabel = ComponentFactory.Instance.creat("petsBag.view.infoView.defenceLabel");
            this._defenceLabel.text = LanguageMgr.GetTranslation("pets.bag.defence");
            addChild(this._defenceLabel);
            this._defenceTxt = ComponentFactory.Instance.creat("petsBag.view.infoView.defenceTxt");
            addChild(this._defenceTxt);
            this._agilityLabel = ComponentFactory.Instance.creat("petsBag.view.infoView.agilityLabel");
            this._agilityLabel.text = LanguageMgr.GetTranslation("pets.bag.agility");
            addChild(this._agilityLabel);
            this._agilityTxt = ComponentFactory.Instance.creat("petsBag.view.infoView.agilityTxt");
            addChild(this._agilityTxt);
            this._luckLabel = ComponentFactory.Instance.creat("petsBag.view.infoView.luckLabel");
            this._luckLabel.text = LanguageMgr.GetTranslation("pets.bag.luck");
            addChild(this._luckLabel);
            this._luckTxt = ComponentFactory.Instance.creat("petsBag.view.infoView.luckTxt");
            addChild(this._luckTxt);
            this._fightBtn = ComponentFactory.Instance.creat("petsBag.view.infoView.fightBtn");
            addChild(this._fightBtn);
            this._unfightBtn = ComponentFactory.Instance.creat("petsBag.view.infoView.unfightBtn");
            this._unfightBtn.visible = false;
            addChild(this._unfightBtn);
        }

        private function initEvent():void
        {
            this._changeNameBtn.addEventListener(MouseEvent.CLICK, this.__changeName);
            this._fightBtn.addEventListener(MouseEvent.CLICK, this.__click);
            this._unfightBtn.addEventListener(MouseEvent.CLICK, this.__click);
            this._advanceTop.addEventListener(Event.COMPLETE, this.__advanceEnd);
        }

        private function removeEvent():void
        {
            this._changeNameBtn.removeEventListener(MouseEvent.CLICK, this.__changeName);
            this._fightBtn.removeEventListener(MouseEvent.CLICK, this.__click);
            this._unfightBtn.removeEventListener(MouseEvent.CLICK, this.__click);
            this._advanceTop.removeEventListener(Event.COMPLETE, this.__advanceEnd);
        }

        protected function __changeName(_arg_1:MouseEvent):void
        {
            SoundManager.instance.play("008");
            if ((!(this._info)))
            {
                return;
            };
            if (this._reNameAlert)
            {
                this._reNameAlert.removeEventListener(FrameEvent.RESPONSE, this.__AlertRePetNameResponse);
                ObjectUtils.disposeObject(this._reNameAlert);
            };
            this._reNameAlert = ComponentFactory.Instance.creat("petsBag.rePetNameFrame");
            this._reNameAlert.addEventListener(FrameEvent.RESPONSE, this.__AlertRePetNameResponse);
            this._reNameAlert.show();
        }

        protected function __AlertRePetNameResponse(_arg_1:FrameEvent):void
        {
            SoundManager.instance.play("008");
            switch (_arg_1.responseCode)
            {
                case FrameEvent.ENTER_CLICK:
                case FrameEvent.SUBMIT_CLICK:
                    if (PlayerManager.Instance.Self.bagLocked)
                    {
                        BaglockedManager.Instance.show();
                        return;
                    };
                    SocketManager.Instance.out.sendPetChangeName(this._reNameAlert.petName, this._info.Place);
                    break;
            };
            this._reNameAlert.removeEventListener(FrameEvent.RESPONSE, this.__AlertRePetNameResponse);
            ObjectUtils.disposeObject(this._reNameAlert);
            this._reNameAlert = null;
        }

        protected function __click(_arg_1:MouseEvent):void
        {
            SoundManager.instance.play("008");
            if (PlayerManager.Instance.Self.bagLocked)
            {
                BaglockedManager.Instance.show();
                return;
            };
            if (this._info)
            {
                switch (_arg_1.currentTarget)
                {
                    case this._fightBtn:
                        PetBagManager.instance().sendPetMove(this._info.Place, 0);
                        return;
                    case this._unfightBtn:
                        PetBagManager.instance().sendPetCall(this._info.Place);
                        return;
                };
            };
        }

        protected function __advanceEnd(_arg_1:Event):void
        {
            this._advanceTop.removeEventListener(Event.COMPLETE, this.__advanceEnd);
            this._advanceBottom.stop();
            this._advanceBottom.visible = false;
            this._advanceTop.stop();
            this._advanceTop.visible = false;
        }

        public function get info():PetInfo
        {
            return (this._info);
        }

        public function set info(_arg_1:PetInfo):void
        {
            this._info = _arg_1;
            this.update();
            this._nextID = ((this._info) ? PetInfoManager.instance.getPetInfoByTemplateID(this._info.TemplateID).MagicId : 0);
        }

        public function update():void
        {
            var _local_1:int;
            var _local_2:Vector.<int>;
            var _local_3:int;
            if (this._info)
            {
                this._nameTxt.text = this._info.Name;
                this._levelTxt.text = LanguageMgr.GetTranslation("petsBag.view.item.level", this._info.Level);
                this._orderTxt.text = LanguageMgr.GetTranslation("petsBag.view.item.order", this._info.OrderNumber);
                this._orderTxt.visible = (this._info.MagicLevel > 0);
                this._expBar.setProgress(PetExperienceManager.getCurrentExp(this._info.GP, this._info.Level), PetExperienceManager.getNextPetExp(this._info.Level));
                this._pet.info = this._info;
                this._bloodBar.setBlood(int((this._info.Blood / 100)), int((this._info.Blood / 100)));
                this._attackTxt.text = String(int((this._info.Attack / 100)));
                this._defenceTxt.text = String(int((this._info.Defence / 100)));
                this._agilityTxt.text = String(int((this._info.Agility / 100)));
                this._luckTxt.text = String(int((this._info.Luck / 100)));
                this._nameTxt.visible = (this._levelTxt.visible = (this._pet.visible = true));
                this._fightFlag.visible = (this._info.Place == 0);
                _local_1 = 0;
                _local_2 = this._info.fightSkills;
                _local_3 = 0;
                while (_local_3 < 4)
                {
                    if (_local_3 < _local_2.length)
                    {
                        this._skillList[_local_3].info = PetSkillManager.instance.getSkillByID(_local_2[_local_3]);
                    }
                    else
                    {
                        this._skillList[_local_3].info = null;
                    };
                    _local_3++;
                };
                if (this._nextID == this._info.TemplateID)
                {
                    this._advanceBottom.gotoAndPlay(1);
                    this._advanceBottom.visible = true;
                    this._advanceTop.gotoAndPlay(1);
                    this._advanceTop.visible = true;
                    AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"), LanguageMgr.GetTranslation("petsbag.frame.magicAlertData", this._info.Name), LanguageMgr.GetTranslation("ok"), "", true);
                };
                this._fightBtn.visible = (!(this._info.Place == 0));
                this._unfightBtn.visible = (this._info.Place == 0);
            }
            else
            {
                this._expBar.noPet();
                this._bloodBar.noPet();
                this._pet.info = null;
                this._nameTxt.visible = (this._levelTxt.visible = (this._pet.visible = false));
                this._attackTxt.text = (this._defenceTxt.text = (this._agilityTxt.text = (this._luckTxt.text = "0")));
                this._fightFlag.visible = false;
            };
        }

        public function setVisible(_arg_1:Boolean):void
        {
            this._changeNameBtn.visible = _arg_1;
        }

        public function dispose():void
        {
            this.removeEvent();
            ObjectUtils.disposeObject(this._nameTxt);
            this._nameTxt = null;
            ObjectUtils.disposeObject(this._levelTxt);
            this._levelTxt = null;
            ObjectUtils.disposeObject(this._orderTxt);
            this._orderTxt = null;
            ObjectUtils.disposeObject(this._changeNameBtn);
            this._changeNameBtn = null;
            ObjectUtils.disposeObject(this._expBar);
            this._expBar = null;
            ObjectUtils.disposeObject(this._advanceBottom);
            this._advanceBottom = null;
            ObjectUtils.disposeObject(this._pet);
            this._pet = null;
            ObjectUtils.disposeObject(this._advanceTop);
            this._advanceTop = null;
            ObjectUtils.disposeObject(this._fightFlag);
            this._fightFlag = null;
            ObjectUtils.disposeObject(this._bloodBar);
            this._bloodBar = null;
            ObjectUtils.disposeObject(this._attackBg);
            this._attackLabel = null;
            ObjectUtils.disposeObject(this._defenceBg);
            this._attackLabel = null;
            ObjectUtils.disposeObject(this._agilityBg);
            this._attackLabel = null;
            ObjectUtils.disposeObject(this._luckBg);
            this._attackLabel = null;
            ObjectUtils.disposeObject(this._attackLabel);
            this._attackLabel = null;
            ObjectUtils.disposeObject(this._attackTxt);
            this._attackTxt = null;
            ObjectUtils.disposeObject(this._defenceLabel);
            this._defenceLabel = null;
            ObjectUtils.disposeObject(this._defenceTxt);
            this._defenceTxt = null;
            ObjectUtils.disposeObject(this._agilityLabel);
            this._agilityLabel = null;
            ObjectUtils.disposeObject(this._agilityTxt);
            this._agilityTxt = null;
            ObjectUtils.disposeObject(this._luckLabel);
            this._luckLabel = null;
            ObjectUtils.disposeObject(this._luckTxt);
            this._luckTxt = null;
            while (this._skillBgList.length > 0)
            {
                this._skillBgList.shift().dispose();
            };
            this._skillBgList = null;
            while (this._skillList.length > 0)
            {
                this._skillList.shift().dispose();
            };
            this._skillList = null;
            ObjectUtils.disposeObject(this._fightBtn);
            this._fightBtn = null;
            ObjectUtils.disposeObject(this._unfightBtn);
            this._unfightBtn = null;
            this._info = null;
            if (parent)
            {
                parent.removeChild(this);
            };
        }


    }
}//package petsBag.view

