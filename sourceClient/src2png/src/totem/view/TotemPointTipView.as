// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//totem.view.TotemPointTipView

package totem.view
{
    import flash.display.Sprite;
    import com.pickgliss.ui.core.Disposeable;
    import com.pickgliss.ui.image.Image;
    import com.pickgliss.ui.text.FilterFrameText;
    import __AS3__.vec.Vector;
    import flash.text.TextFormat;
    import flash.filters.GlowFilter;
    import flash.geom.Point;
    import com.pickgliss.ui.ComponentFactory;
    import ddt.manager.LanguageMgr;
    import totem.TotemManager;
    import ddt.manager.PlayerManager;
    import totem.data.TotemDataVo;
    import com.pickgliss.utils.DisplayUtils;
    import com.pickgliss.utils.ObjectUtils;
    import __AS3__.vec.*;

    public class TotemPointTipView extends Sprite implements Disposeable 
    {

        private var _bg:Image;
        private var _seperateLine1:Image;
        private var _propertyNameTxt:FilterFrameText;
        private var _propertyValueTxt:FilterFrameText;
        private var _possibleNameTxt:FilterFrameText;
        private var _possibleValueTxt:FilterFrameText;
        private var _needGradeTxt:FilterFrameText;
        private var _propertyValueList:Array;
        private var _possibleValeList:Array;
        private var _propertyValueTextFormatList:Vector.<TextFormat>;
        private var _propertyValueGlowFilterList:Vector.<GlowFilter>;
        private var _possibleValueTxtColorList:Array = [16752450, 9634815, 35314, 9035310, 16727331];
        private var _honorExpSprite:Sprite;
        private var _honorTxt:FilterFrameText;
        private var _expTxt:FilterFrameText;
        private var _statusValueList:Array;
        private var _tipPosFix:Point;
        private var _seperateLine1Pos1:Point;

        public function TotemPointTipView()
        {
            this.mouseChildren = false;
            this.mouseEnabled = false;
            this.initData();
            this.initView();
        }

        private function initData():void
        {
            this._propertyValueTextFormatList = new Vector.<TextFormat>();
            this._propertyValueGlowFilterList = new Vector.<GlowFilter>();
            var _local_1:int = 1;
            while (_local_1 <= 7)
            {
                this._propertyValueTextFormatList.push(ComponentFactory.Instance.model.getSet((("totem.totemWindow.propertyName" + _local_1) + ".tf")));
                this._propertyValueGlowFilterList.push(ComponentFactory.Instance.model.getSet((("totem.totemWindow.propertyName" + _local_1) + ".gf")));
                _local_1++;
            };
            this._propertyValueList = LanguageMgr.GetTranslation("ddt.totem.sevenProperty").split(",");
            this._possibleValeList = LanguageMgr.GetTranslation("ddt.totem.totemPointTip.possibleValueTxt").split(",");
            this._statusValueList = LanguageMgr.GetTranslation("ddt.totem.totemPointTip.statusValueTxt").split(",");
        }

        private function initView():void
        {
            this._bg = ComponentFactory.Instance.creat("core.GoodsTipBg");
            this._seperateLine1 = ComponentFactory.Instance.creatComponentByStylename("totemTIPSeprateLine");
            this._propertyNameTxt = ComponentFactory.Instance.creatComponentByStylename("totem.totemPointTip.propertyNameTxt");
            this._propertyNameTxt.text = LanguageMgr.GetTranslation("ddt.totem.totemPointTip.propertyNameTxt");
            this._propertyValueTxt = ComponentFactory.Instance.creatComponentByStylename("totem.totemPointTip.propertyValueTxt");
            this._possibleNameTxt = ComponentFactory.Instance.creatComponentByStylename("totem.totemPointTip.possibleNameTxt");
            this._possibleNameTxt.text = LanguageMgr.GetTranslation("ddt.totem.totemPointTip.possibleNameTxt");
            this._possibleValueTxt = ComponentFactory.Instance.creatComponentByStylename("totem.totemPointTip.possibleValueTxt");
            this._needGradeTxt = ComponentFactory.Instance.creatComponentByStylename("totem.totemPointTip.needGradeTxt");
            this._honorExpSprite = ComponentFactory.Instance.creatCustomObject("totem.totemPointTip.honorExpSprite");
            this._honorTxt = ComponentFactory.Instance.creatComponentByStylename("totem.totemPointTip.honor");
            this._expTxt = ComponentFactory.Instance.creatComponentByStylename("totem.totemPointTip.exp");
            this._honorExpSprite.addChild(this._needGradeTxt);
            this._honorExpSprite.addChild(this._honorTxt);
            this._honorExpSprite.addChild(this._expTxt);
            this._tipPosFix = ComponentFactory.Instance.creatCustomObject("totem.totemTipAreaFix");
            this._seperateLine1Pos1 = ComponentFactory.Instance.creatCustomObject("totem.totemTip.seperateLine1Pos1");
            addChild(this._bg);
            addChild(this._seperateLine1);
            addChild(this._propertyNameTxt);
            addChild(this._propertyValueTxt);
            addChild(this._possibleNameTxt);
            addChild(this._possibleValueTxt);
            addChild(this._honorExpSprite);
        }

        public function show(_arg_1:TotemDataVo, _arg_2:Boolean, _arg_3:Boolean):void
        {
            this.showStatus1();
            var _local_4:int = _arg_1.Location;
            var _local_5:int = TotemManager.instance.getAddValue(_local_4, TotemManager.instance.getAddInfo((TotemManager.instance.getTotemPointLevel(PlayerManager.Instance.Self.totemId) + 7)));
            this._propertyValueTxt.text = ((this._propertyValueList[(_local_4 - 1)] + "+") + _local_5);
            this._propertyValueTxt.setTextFormat(this._propertyValueTextFormatList[(_local_4 - 1)]);
            this._propertyValueTxt.filters = [this._propertyValueGlowFilterList[(_local_4 - 1)]];
            var _local_6:int = _arg_1.Random;
            if (_local_6 >= 100)
            {
                _local_4 = 0;
            }
            else
            {
                if (((_local_6 >= 80) && (_local_6 < 100)))
                {
                    _local_4 = 1;
                }
                else
                {
                    if (((_local_6 >= 40) && (_local_6 < 80)))
                    {
                        _local_4 = 2;
                    }
                    else
                    {
                        if (((_local_6 >= 20) && (_local_6 < 40)))
                        {
                            _local_4 = 3;
                        }
                        else
                        {
                            _local_4 = 4;
                        };
                    };
                };
            };
            this._possibleValueTxt.text = this._possibleValeList[_local_4];
            this._possibleValueTxt.setTextFormat(new TextFormat(null, null, this._possibleValueTxtColorList[_local_4]));
            this._honorTxt.text = LanguageMgr.GetTranslation("ddt.totem.totemPointTip.honorTxt", _arg_1.ConsumeHonor);
            this._expTxt.text = LanguageMgr.GetTranslation("ddt.totem.totemPointTip.expTxt", _arg_1.ConsumeExp);
            this._needGradeTxt.text = LanguageMgr.GetTranslation("ddt.totem.needGradeTxt", _arg_1.needGrade);
            if (PlayerManager.Instance.Self.Grade < _arg_1.needGrade)
            {
                this._needGradeTxt.setTextFormat(new TextFormat(null, null, 0xFF0000));
            };
            if (PlayerManager.Instance.Self.totemScores < _arg_1.ConsumeHonor)
            {
                this._honorTxt.setTextFormat(new TextFormat(null, null, 0xFF0000));
            };
            if (TotemManager.instance.usableGP < _arg_1.ConsumeExp)
            {
                this._expTxt.setTextFormat(new TextFormat(null, null, 0xFF0000));
            };
            this._bg.width = ((this._seperateLine1.x + this._seperateLine1.width) + this._tipPosFix.x);
            this._bg.height = ((this._honorExpSprite.y + this._honorExpSprite.height) + this._tipPosFix.y);
        }

        private function showStatus1():void
        {
            this._possibleNameTxt.text = LanguageMgr.GetTranslation("ddt.totem.totemPointTip.possibleNameTxt");
            this._honorExpSprite.visible = true;
            this._needGradeTxt.visible = true;
            DisplayUtils.setDisplayPos(this._seperateLine1, this._seperateLine1Pos1);
        }

        public function dispose():void
        {
            ObjectUtils.disposeAllChildren(this);
            this._bg = null;
            this._needGradeTxt = null;
            this._propertyNameTxt = null;
            this._propertyValueTxt = null;
            this._possibleNameTxt = null;
            this._possibleValueTxt = null;
            this._propertyValueList = null;
            this._possibleValeList = null;
            this._propertyValueTextFormatList = null;
            this._propertyValueGlowFilterList = null;
            ObjectUtils.disposeObject(this._honorTxt);
            this._honorTxt = null;
            ObjectUtils.disposeObject(this._expTxt);
            this._expTxt = null;
            this._honorExpSprite = null;
            this._statusValueList = null;
            this._possibleValueTxtColorList = null;
            if (parent)
            {
                parent.removeChild(this);
            };
        }


    }
}//package totem.view

