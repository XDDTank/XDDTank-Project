// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//ddt.view.tips.PetInfoTip

package ddt.view.tips
{
    import com.pickgliss.ui.tip.BaseTip;
    import com.pickgliss.ui.text.FilterFrameText;
    import com.pickgliss.ui.image.ScaleBitmapImage;
    import flash.display.Sprite;
    import pet.date.PetInfo;
    import com.pickgliss.ui.ComponentFactory;
    import flash.display.DisplayObject;
    import ddt.manager.LanguageMgr;
    import ddt.data.goods.QualityType;
    import com.pickgliss.utils.ObjectUtils;

    public class PetInfoTip extends BaseTip 
    {

        protected const LEADING:int = 5;

        protected var _name:FilterFrameText;
        protected var _level:FilterFrameText;
        protected var _descTxt:FilterFrameText;
        protected var _list:Array;
        protected var _splitImg:ScaleBitmapImage;
        protected var _splitImg2:ScaleBitmapImage;
        protected var _bg:ScaleBitmapImage;
        protected var _container:Sprite;
        protected var _info:PetInfo;


        override protected function init():void
        {
            this._name = ComponentFactory.Instance.creat("farm.text.PetName");
            this._descTxt = ComponentFactory.Instance.creat("farm.text.petDesc");
            this._bg = ComponentFactory.Instance.creat("core.GoodsTipBg");
            this._splitImg = ComponentFactory.Instance.creatComponentByStylename("petTips.line");
            this._splitImg2 = ComponentFactory.Instance.creatComponentByStylename("petTips.line");
            this._container = new Sprite();
            this.addPanel();
            this._level = ComponentFactory.Instance.creat("petTip.level");
            this._list = [];
            super.init();
            this.tipbackgound = this._bg;
        }

        protected function addPanel():void
        {
            this._container.addChild(this._name);
            this._container.addChild(this._descTxt);
            this._container.addChild(this._splitImg);
            this._container.addChild(this._splitImg2);
        }

        protected function fixPos():void
        {
            var _local_2:DisplayObject;
            this._splitImg.y = ((this._name.y + this._name.textHeight) + (this.LEADING * 1.5));
            var _local_1:DisplayObject = this._splitImg;
            for each (_local_2 in this._list)
            {
                _local_2.y = ((_local_1.y + _local_1.height) + this.LEADING);
                _local_1 = _local_2;
            };
            this._splitImg2.y = ((_local_1.y + _local_1.height) + (this.LEADING * 1.5));
            this._descTxt.y = ((this._splitImg2.y + this._splitImg2.height) + (this.LEADING * 1.5));
        }

        override protected function addChildren():void
        {
            super.addChildren();
            addChild(this._container);
            addChild(this._level);
            this.mouseChildren = false;
            this.mouseEnabled = false;
        }

        override public function get tipData():Object
        {
            return (this._info);
        }

        override public function set tipData(_arg_1:Object):void
        {
            this._info = (_arg_1 as PetInfo);
            if (this._info)
            {
                visible = true;
                this.updateView();
            }
            else
            {
                visible = false;
            };
        }

        protected function updateView():void
        {
            var _local_1:String = LanguageMgr.GetTranslation("ddt.pets.growthText");
            this._name.text = String(this._info.Name);
            this._name.textColor = this.getNameColor(this._info.OrderNumber);
            this._level.text = LanguageMgr.GetTranslation("petsBag.view.item.level", this._info.Level);
            this._level.x = ((this._name.x + this._name.textWidth) + 10);
            this._level.visible = (this._info.ID > 0);
            this.addList();
            this._descTxt.text = String(this._info.Description);
            this.fixPos();
            this._bg.width = (this._container.width + 10);
            this._bg.height = (this._container.height + 20);
            _width = this._bg.width;
            _height = this._bg.height;
        }

        private function getNameColor(_arg_1:int):int
        {
            if (_arg_1 < 20)
            {
                return (QualityType.PET_QUALITY_COLOR[0]);
            };
            if (_arg_1 < 50)
            {
                return (QualityType.PET_QUALITY_COLOR[1]);
            };
            return (QualityType.PET_QUALITY_COLOR[2]);
        }

        protected function addList():void
        {
            var _local_1:FilterFrameText;
            while (this._list.length > 0)
            {
                this._list.shift().dispose();
            };
            if (this._info.Blood > 0)
            {
                _local_1 = ComponentFactory.Instance.creat("farm.text.petTipValue");
                _local_1.text = this.getProperyText("MaxHp", this._info.Blood, this._info.BloodGrow);
                this._list.push(_local_1);
                this._container.addChild(_local_1);
            };
            if (this._info.Attack > 0)
            {
                _local_1 = ComponentFactory.Instance.creat("farm.text.petTipValue");
                _local_1.text = this.getProperyText("attack", this._info.Attack, this._info.AttackGrow);
                this._list.push(_local_1);
                this._container.addChild(_local_1);
            };
            if (this._info.Defence > 0)
            {
                _local_1 = ComponentFactory.Instance.creat("farm.text.petTipValue");
                _local_1.text = this.getProperyText("defence", this._info.Defence, this._info.DefenceGrow);
                this._list.push(_local_1);
                this._container.addChild(_local_1);
            };
            if (this._info.Agility > 0)
            {
                _local_1 = ComponentFactory.Instance.creat("farm.text.petTipValue");
                _local_1.text = this.getProperyText("agility", this._info.Agility, this._info.AgilityGrow);
                this._list.push(_local_1);
                this._container.addChild(_local_1);
            };
            if (this._info.Luck > 0)
            {
                _local_1 = ComponentFactory.Instance.creat("farm.text.petTipValue");
                _local_1.text = this.getProperyText("luck", this._info.Luck, this._info.LuckGrow);
                this._list.push(_local_1);
                this._container.addChild(_local_1);
            };
        }

        private function getProperyText(_arg_1:String, _arg_2:int, _arg_3:int):String
        {
            return (LanguageMgr.GetTranslation("petsBag.view.item.tip", LanguageMgr.GetTranslation(_arg_1), int((_arg_2 / 100))));
        }

        override public function dispose():void
        {
            this._info = null;
            if (this._bg)
            {
                ObjectUtils.disposeObject(this._bg);
                this._bg = null;
            };
            if (this._splitImg2)
            {
                ObjectUtils.disposeObject(this._splitImg2);
                this._splitImg2 = null;
            };
            if (this._splitImg)
            {
                ObjectUtils.disposeObject(this._splitImg);
                this._splitImg = null;
            };
            if (this._container)
            {
                ObjectUtils.disposeObject(this._container);
                this._container = null;
            };
            if (this._descTxt)
            {
                ObjectUtils.disposeObject(this._descTxt);
                this._descTxt = null;
            };
            if (this._name)
            {
                ObjectUtils.disposeObject(this._name);
                this._name = null;
            };
            ObjectUtils.disposeObject(this._level);
            this._level = null;
            super.dispose();
        }


    }
}//package ddt.view.tips

