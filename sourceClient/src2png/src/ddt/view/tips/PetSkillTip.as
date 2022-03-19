// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//ddt.view.tips.PetSkillTip

package ddt.view.tips
{
    import com.pickgliss.ui.tip.BaseTip;
    import com.pickgliss.ui.image.ScaleBitmapImage;
    import com.pickgliss.ui.text.FilterFrameText;
    import com.pickgliss.ui.controls.container.VBox;
    import com.pickgliss.ui.controls.container.HBox;
    import petsBag.data.PetSkillItemInfo;
    import com.pickgliss.ui.ComponentFactory;
    import pet.date.PetBaseSkillInfo;
    import ddt.manager.PetSkillManager;
    import ddt.manager.LanguageMgr;
    import pet.date.PetSkillTemplateInfo;
    import ddt.manager.PlayerManager;
    import flash.display.DisplayObject;
    import com.pickgliss.utils.ObjectUtils;

    public class PetSkillTip extends BaseTip 
    {

        public static const ALERT_COLOR:String = "#ff0000";
        public static const NORMAL_COLOR:String = "#ffffff";

        private var _bg:ScaleBitmapImage;
        private var name_txt:FilterFrameText;
        private var ballType_txt:FilterFrameText;
        private var _container:VBox;
        private var _list:Array;
        private var _current:HBox;
        private var _next:HBox;
        private var _needLevel:FilterFrameText;
        private var _needSoul:FilterFrameText;
        private var _needPreSkill:FilterFrameText;
        private var _splitImg:ScaleBitmapImage;
        private var _splitImg2:ScaleBitmapImage;
        private var _skillInfo:PetSkillItemInfo;


        override protected function init():void
        {
            super.init();
            this._bg = ComponentFactory.Instance.creat("core.GoodsTipBg");
            this._list = [];
            addChild(this._bg);
            mouseEnabled = false;
            mouseChildren = false;
        }

        override public function get tipData():Object
        {
            return (this._skillInfo);
        }

        override public function set tipData(_arg_1:Object):void
        {
            this._skillInfo = (_arg_1 as PetSkillItemInfo);
            if ((!(this._skillInfo)))
            {
                return;
            };
            this.updateView();
        }

        private function createDescribe(_arg_1:PetSkillItemInfo):void
        {
            var _local_3:FilterFrameText;
            var _local_4:FilterFrameText;
            var _local_7:PetBaseSkillInfo;
            var _local_2:PetBaseSkillInfo = PetSkillManager.instance.getSkillBaseInfo(_arg_1.skillID);
            var _local_5:Boolean = Boolean(_arg_1.petInfo.skills[PetSkillManager.instance.getTemplateInfoByID(_arg_1.skillID).SkillPlace]);
            if (_local_5)
            {
                this._current = new HBox();
                _local_3 = ComponentFactory.Instance.creat("petsBag.petSkillTip.currentleftTxt");
                _local_3.htmlText = LanguageMgr.GetTranslation("ddt.view.tips.petSkillTip.current");
                this._current.addChild(_local_3);
                _local_4 = ComponentFactory.Instance.creat("petsBag.petSkillTip.currentrightTxt");
                _local_4.htmlText = _local_2.Decription;
                _local_4.height = (_local_4.textWidth + 10);
                this._current.addChild(_local_4);
                this._list.push(this._current);
            };
            this._next = new HBox();
            _local_3 = ComponentFactory.Instance.creat("petsBag.petSkillTip.nextTxtLeft");
            _local_3.htmlText = LanguageMgr.GetTranslation("ddt.view.tips.petSkillTip.next");
            this._next.addChild(_local_3);
            _local_4 = ComponentFactory.Instance.creat("petsBag.petSkillTip.nextRightTxt");
            var _local_6:int = ((_local_5) ? PetSkillManager.instance.getTemplateInfoByID(_arg_1.skillID).NextSkillId : _arg_1.skillID);
            if (_local_6 < 0)
            {
                _local_4.htmlText = LanguageMgr.GetTranslation("ddt.view.tips.petSkillTip.nextMAX");
            }
            else
            {
                _local_7 = PetSkillManager.instance.getSkillBaseInfo(_local_6);
                _local_4.htmlText = _local_7.Decription;
            };
            _local_4.height = (_local_4.textWidth + 10);
            this._next.addChild(_local_4);
            this._list.push(this._next);
        }

        private function createCondition(_arg_1:PetSkillItemInfo):void
        {
            var _local_2:PetSkillTemplateInfo;
            var _local_4:Boolean;
            var _local_7:String;
            var _local_3:PetSkillTemplateInfo = PetSkillManager.instance.getTemplateInfoByID(_arg_1.skillID);
            if (this._skillInfo.petInfo.skills[_local_3.SkillPlace])
            {
                _local_2 = PetSkillManager.instance.getTemplateInfoByID(_local_3.NextSkillId);
            }
            else
            {
                _local_2 = _local_3;
            };
            if ((!(_local_2)))
            {
                return;
            };
            this._splitImg2 = ComponentFactory.Instance.creatComponentByStylename("petsBag.petSkillTip.line");
            this._list.push(this._splitImg2);
            _local_4 = (_local_2.MinLevel > _arg_1.petInfo.Level);
            this._needLevel = ComponentFactory.Instance.creat("petsBag.petSkillTip.normalTxt");
            this._needLevel.htmlText = LanguageMgr.GetTranslation("ddt.view.tips.petSkillTip.needLevel", ((_local_4) ? ALERT_COLOR : NORMAL_COLOR), _local_2.MinLevel);
            this._list.push(this._needLevel);
            _local_4 = (_local_2.MagicSoul > PlayerManager.Instance.Self.magicSoul);
            this._needSoul = ComponentFactory.Instance.creat("petsBag.petSkillTip.normalTxt");
            this._needSoul.htmlText = LanguageMgr.GetTranslation("ddt.view.tips.petSkillTip.needSoul", ((_local_4) ? ALERT_COLOR : NORMAL_COLOR), _local_2.MagicSoul);
            this._list.push(this._needSoul);
            var _local_5:Array = _local_2.BeforeSkillId.split(",");
            var _local_6:int = int.MAX_VALUE;
            for each (_local_7 in _local_5)
            {
                if (_local_7.length != 0)
                {
                    if (_local_6 > int(_local_7))
                    {
                        _local_6 = int(_local_7);
                    };
                };
            };
            if (_local_6 > 0)
            {
                _local_4 = (!(PetSkillManager.instance.checkBeforeSkill(_local_2, this._skillInfo.petInfo)));
                this._needPreSkill = ComponentFactory.Instance.creat("petsBag.petSkillTip.normalTxt");
                this._needPreSkill.htmlText = LanguageMgr.GetTranslation("ddt.view.tips.petSkillTip.needSkill", ((_local_4) ? ALERT_COLOR : NORMAL_COLOR), PetSkillManager.instance.getSkillBaseInfo(_local_6).Name);
                this._list.push(this._needPreSkill);
            };
        }

        private function updateView():void
        {
            var _local_3:DisplayObject;
            while (this._list.length > 0)
            {
                this._list.shift().dispose();
            };
            this._list = [];
            ObjectUtils.disposeObject(this._container);
            var _local_1:PetBaseSkillInfo = PetSkillManager.instance.getSkillBaseInfo(this._skillInfo.skillID);
            this.name_txt = ComponentFactory.Instance.creat("petsBag.petSkillTip.nameTxt");
            this.name_txt.text = _local_1.Name;
            this._list.push(this.name_txt);
            this.ballType_txt = ComponentFactory.Instance.creat("petsBag.petSkillTip.normalTxt");
            this.ballType_txt.text = LanguageMgr.GetTranslation(("ddt.view.tips.petSkillTip.skillType" + ((this._skillInfo.skillID < 1000) ? 0 : 1)));
            this._list.push(this.ballType_txt);
            this._splitImg = ComponentFactory.Instance.creatComponentByStylename("petsBag.petSkillTip.line");
            this._list.push(this._splitImg);
            this.createDescribe(this._skillInfo);
            this.createCondition(this._skillInfo);
            this._container = ComponentFactory.Instance.creat("petsBag.petSkillTip.vbox");
            addChild(this._container);
            var _local_2:int;
            while (_local_2 < this._list.length)
            {
                _local_3 = this._list[_local_2];
                this._container.addChild(_local_3);
                _local_2++;
            };
            this._bg.width = (this._container.width + 20);
            this._bg.height = (this._container.height + 20);
            _width = this._bg.width;
            _height = this._bg.height;
        }

        override public function dispose():void
        {
            if (this._bg)
            {
                ObjectUtils.disposeObject(this._bg);
                this._bg = null;
            };
            if (this._container)
            {
                ObjectUtils.disposeObject(this._container);
                this._container = null;
            };
            if (this._splitImg)
            {
                ObjectUtils.disposeObject(this._splitImg);
                this._splitImg = null;
            };
            if (this.name_txt)
            {
                ObjectUtils.disposeObject(this.name_txt);
                this.name_txt = null;
            };
            if (this._splitImg2)
            {
                ObjectUtils.disposeObject(this._splitImg2);
                this._splitImg2 = null;
            };
            if (this.ballType_txt)
            {
                ObjectUtils.disposeObject(this.ballType_txt);
                this.ballType_txt = null;
            };
        }


    }
}//package ddt.view.tips

