// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//ddt.view.tips.PetSkillCellTip

package ddt.view.tips
{
    import com.pickgliss.ui.tip.BaseTip;
    import com.pickgliss.ui.image.ScaleBitmapImage;
    import com.pickgliss.ui.text.FilterFrameText;
    import pet.date.PetSkillInfo;
    import flash.display.Sprite;
    import com.pickgliss.ui.ComponentFactory;
    import ddt.manager.LanguageMgr;
    import road7th.utils.StringHelper;
    import com.pickgliss.utils.ObjectUtils;

    public class PetSkillCellTip extends BaseTip 
    {

        private var _bg:ScaleBitmapImage;
        private var name_txt:FilterFrameText;
        private var ballType_txt:FilterFrameText;
        private var _descLbl:FilterFrameText;
        private var _descTxt:FilterFrameText;
        private var _coolDownTxt:FilterFrameText;
        private var _splitImg:ScaleBitmapImage;
        private var _splitImg2:ScaleBitmapImage;
        private var _tempData:PetSkillInfo;
        private var _container:Sprite;
        private var LEADING:int = 5;


        override protected function init():void
        {
            this.name_txt = ComponentFactory.Instance.creat("petsBag.PetSkillCellTip.name");
            this.ballType_txt = ComponentFactory.Instance.creat("core.petskillTip.ballTypeTxt");
            this._descLbl = ComponentFactory.Instance.creat("petsBag.PetSkillCellTip.descLbl");
            this._descLbl.text = LanguageMgr.GetTranslation("ddt.pets.skillTipDesc");
            this._descTxt = ComponentFactory.Instance.creat("petsBag.PetSkillCellTip.descTxt");
            this._bg = ComponentFactory.Instance.creat("core.GoodsTipBg");
            this._splitImg = ComponentFactory.Instance.creatComponentByStylename("petTips.line");
            this._container = new Sprite();
            this._container.addChild(this.name_txt);
            this._container.addChild(this.ballType_txt);
            this._container.addChild(this._descLbl);
            this._container.addChild(this._descTxt);
            this._container.addChild(this._splitImg);
            super.init();
            this.tipbackgound = this._bg;
        }

        override protected function addChildren():void
        {
            super.addChildren();
            addChild(this._container);
            this._container.mouseEnabled = false;
            this._container.mouseChildren = false;
            this.mouseChildren = false;
            this.mouseEnabled = false;
        }

        override public function get tipData():Object
        {
            return (this._tempData);
        }

        override public function set tipData(_arg_1:Object):void
        {
            this._tempData = (_arg_1 as PetSkillInfo);
            if ((!(this._tempData)))
            {
                return;
            };
            this.updateView();
        }

        private function updateView():void
        {
            this.name_txt.text = StringHelper.trim(this._tempData.Name);
            if (this._tempData.isActiveSkill)
            {
                this.ballType_txt.text = LanguageMgr.GetTranslation(("core.petskillTip.balltype" + this._tempData.BallType));
                if ((!(this._coolDownTxt)))
                {
                    this._coolDownTxt = ComponentFactory.Instance.creat("petsBag.PetSkillCellTip.coolDownTxt");
                    this._container.addChild(this._coolDownTxt);
                };
                this._coolDownTxt.text = (((LanguageMgr.GetTranslation("tank.game.actions.cooldown") + ": ") + this._tempData.ColdDown) + LanguageMgr.GetTranslation("tank.game.actions.turn"));
            }
            else
            {
                this.ballType_txt.text = "";
            };
            this._descTxt.text = this._tempData.Description;
            this.fixPos();
            this._bg.width = (this._container.width + 15);
            this._bg.height = (this._container.height + 15);
            _width = this._bg.width;
            _height = this._bg.height;
        }

        private function fixPos():void
        {
            this.ballType_txt.x = this.name_txt.x;
            this.ballType_txt.y = ((this.name_txt.y + this.name_txt.textHeight) + (this.LEADING * 2));
            this._splitImg.y = ((this.ballType_txt.y + this.ballType_txt.textHeight) + this.LEADING);
            this._descLbl.x = this.ballType_txt.x;
            this._descLbl.y = ((this._splitImg.y + this._splitImg.height) + this.LEADING);
            this._descTxt.x = ((this._descLbl.x + this._descLbl.textWidth) + this.LEADING);
            this._descTxt.y = this._descLbl.y;
            if (this._tempData.isActiveSkill)
            {
                if ((!(this._coolDownTxt)))
                {
                    this._coolDownTxt = ComponentFactory.Instance.creat("petsBag.PetSkillCellTip.coolDownTxt");
                    this._container.addChild(this._coolDownTxt);
                };
                if ((!(this._splitImg2)))
                {
                    this._splitImg2 = ComponentFactory.Instance.creatComponentByStylename("petTips.line");
                    this._container.addChild(this._splitImg2);
                };
                this._splitImg2.y = ((this._descTxt.y + this._descTxt.textHeight) + (this.LEADING * 2));
                this._coolDownTxt.x = this.ballType_txt.x;
                this._coolDownTxt.y = ((this._splitImg2.y + this._splitImg2.height) + this.LEADING);
            }
            else
            {
                if (this._coolDownTxt)
                {
                    ObjectUtils.disposeObject(this._coolDownTxt);
                    this._coolDownTxt = null;
                };
                if (this._splitImg2)
                {
                    ObjectUtils.disposeObject(this._splitImg2);
                    this._splitImg2 = null;
                };
            };
        }

        override public function dispose():void
        {
            this._tempData = null;
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
            if (this._descTxt)
            {
                ObjectUtils.disposeObject(this._descTxt);
                this._descTxt = null;
            };
            if (this._coolDownTxt)
            {
                ObjectUtils.disposeObject(this._coolDownTxt);
                this._coolDownTxt = null;
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
            if (this._descLbl)
            {
                ObjectUtils.disposeObject(this._descLbl);
                this._descLbl = null;
            };
            if (this.ballType_txt)
            {
                ObjectUtils.disposeObject(this.ballType_txt);
                this.ballType_txt = null;
            };
        }


    }
}//package ddt.view.tips

