// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//ddt.view.tips.SkillTipPanel

package ddt.view.tips
{
    import com.pickgliss.ui.tip.BaseTip;
    import com.pickgliss.ui.core.Disposeable;
    import com.pickgliss.ui.tip.ITip;
    import com.pickgliss.ui.image.ScaleBitmapImage;
    import com.pickgliss.ui.text.FilterFrameText;
    import __AS3__.vec.Vector;
    import consortion.data.ConsortionNewSkillInfo;
    import com.pickgliss.ui.ComponentFactory;
    import consortion.ConsortionModelControl;
    import com.pickgliss.utils.ObjectUtils;
    import __AS3__.vec.*;

    public class SkillTipPanel extends BaseTip implements Disposeable, ITip 
    {

        public static const THISWIDTH:int = 200;

        private var _bg:ScaleBitmapImage;
        private var _rule1:ScaleBitmapImage;
        private var _rule2:ScaleBitmapImage;
        private var _buffName:FilterFrameText;
        private var _descriptionTxt:FilterFrameText;
        private var _needsTxt:Vector.<FilterFrameText>;
        private var _info:ConsortionNewSkillInfo;
        private var _thisHeight:int;
        private var _needArr:Array;


        override protected function init():void
        {
            this._bg = ComponentFactory.Instance.creatComponentByStylename("core.GoodsTipBg");
            this._rule1 = ComponentFactory.Instance.creatComponentByStylename("HRuleAsset");
            this._rule2 = ComponentFactory.Instance.creatComponentByStylename("HRuleAsset");
            this._needArr = new Array();
            this._needsTxt = new Vector.<FilterFrameText>(4);
            var _local_1:int;
            while (_local_1 < 4)
            {
                this._needsTxt[_local_1] = ComponentFactory.Instance.creatComponentByStylename("SkillTip.NeedsTxt");
                _local_1++;
            };
            this._buffName = ComponentFactory.Instance.creatComponentByStylename("SkillTip.BuffnameTxt");
            this._descriptionTxt = ComponentFactory.Instance.creatComponentByStylename("SkillTip.DescriptionTxt");
            super.init();
            super.tipbackgound = this._bg;
        }

        override protected function addChildren():void
        {
            super.addChildren();
            var _local_1:int;
            while (_local_1 < 4)
            {
                addChild(this._needsTxt[_local_1]);
                _local_1++;
            };
            addChild(this._buffName);
            addChild(this._descriptionTxt);
            addChild(this._rule1);
            addChild(this._rule2);
            mouseChildren = false;
            mouseEnabled = false;
        }

        override public function get tipData():Object
        {
            return (_tipData);
        }

        override public function set tipData(_arg_1:Object):void
        {
            if ((_arg_1 is ConsortionNewSkillInfo))
            {
                this._info = (_arg_1 as ConsortionNewSkillInfo);
                this.visible = true;
                this.upView();
            }
            else
            {
                this.visible = false;
            };
        }

        private function upView():void
        {
            this._thisHeight = 0;
            this.showHeadPart();
            this.showMiddlePart();
            this.showButtomPart();
            this.upBackground();
        }

        private function showHeadPart():void
        {
            this._buffName.text = this._info.BuffName;
            this._rule1.x = this._buffName.x;
            this._rule1.y = ((this._buffName.y + this._buffName.textHeight) + 8);
            this._thisHeight = (this._rule1.y + this._rule1.height);
        }

        private function showMiddlePart():void
        {
            this._descriptionTxt.text = this._info.Description;
            this._descriptionTxt.y = (this._rule1.y + 8);
            this._thisHeight = (this._descriptionTxt.y + this._descriptionTxt.textHeight);
        }

        private function showButtomPart():void
        {
            var _local_2:Array;
            var _local_3:int;
            var _local_4:int;
            var _local_1:ConsortionNewSkillInfo = ConsortionModelControl.Instance.model.getInfoByBuffId((this._info.BuffID - 1));
            _local_2 = new Array();
            if (ConsortionModelControl.Instance.model.getisLearnByBuffId(this._info.BuffID))
            {
                while (_local_3 < 4)
                {
                    this._needsTxt[_local_3].visible = false;
                    _local_3++;
                };
                this._rule2.visible = false;
            }
            else
            {
                this._rule2.x = this._rule1.x;
                this._rule2.visible = true;
                this._rule2.y = ((this._descriptionTxt.y + this._descriptionTxt.textHeight) + 8);
                _local_2.push(("需要贡献度" + this._info.NeedDevote.toString()));
                if (ConsortionModelControl.Instance.model.getisUpgradeByType(0, this._info.BuffID))
                {
                    _local_2.push((("需要技能研究院" + this._info.BuildLevel.toString()) + "级"));
                };
                if (ConsortionModelControl.Instance.model.getisUpgradeByType(1, this._info.BuffID))
                {
                    _local_2.push((("需要人物" + this._info.NeedLevel.toString()) + "级"));
                };
                if (ConsortionModelControl.Instance.model.getisUpgradeByType(3, this._info.BuffID))
                {
                    _local_2.push(("需要已学会" + _local_1.BuffName));
                };
                _local_4 = 0;
                while (_local_4 < this._needsTxt.length)
                {
                    if (_local_4 < _local_2.length)
                    {
                        this._needsTxt[_local_4].text = _local_2[_local_4];
                        if (_local_4 == 0)
                        {
                            if ((!(ConsortionModelControl.Instance.model.getisUpgradeByType(2, this._info.BuffID))))
                            {
                                this._needsTxt[_local_4].textColor = 0xFFFFFF;
                            }
                            else
                            {
                                this._needsTxt[_local_4].textColor = 0xFF0000;
                            };
                        };
                        this._needsTxt[_local_4].visible = true;
                        this._needsTxt[_local_4].y = (((this._rule2.y + this._rule2.height) + 8) + (24 * _local_4));
                        this._thisHeight = (this._needsTxt[_local_4].y + this._needsTxt[_local_4].textHeight);
                    }
                    else
                    {
                        this._needsTxt[_local_4].visible = false;
                    };
                    _local_4++;
                };
            };
        }

        private function setVisible():void
        {
        }

        private function upBackground():void
        {
            this._bg.height = (this._thisHeight + 10);
            this._bg.width = THISWIDTH;
            _width = this._bg.width;
            _height = this._bg.height;
        }

        override public function dispose():void
        {
            super.dispose();
            ObjectUtils.disposeAllChildren(this);
            var _local_1:int;
            while (_local_1 < 4)
            {
                this._needsTxt[_local_1] = null;
                _local_1++;
            };
            this._needsTxt = null;
            this._needArr = null;
            this._rule1 = null;
            this._rule2 = null;
            this._info = null;
            if (this.parent)
            {
                this.parent.removeChild(this);
            };
        }


    }
}//package ddt.view.tips

