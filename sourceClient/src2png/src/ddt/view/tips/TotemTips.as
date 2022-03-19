// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//ddt.view.tips.TotemTips

package ddt.view.tips
{
    import com.pickgliss.ui.tip.BaseTip;
    import com.pickgliss.ui.tip.ITip;
    import com.pickgliss.ui.core.Disposeable;
    import com.pickgliss.ui.image.ScaleBitmapImage;
    import com.pickgliss.ui.text.FilterFrameText;
    import __AS3__.vec.Vector;
    import com.pickgliss.ui.ComponentFactory;
    import com.pickgliss.utils.ObjectUtils;
    import __AS3__.vec.*;

    public class TotemTips extends BaseTip implements ITip, Disposeable 
    {

        public static const THISWIDTH:int = 240;

        private var _bg:ScaleBitmapImage;
        private var _ActivationProperty:FilterFrameText;
        private var _ActivationPropertyValue:FilterFrameText;
        private var _ActivationRate:FilterFrameText;
        private var _ActivationRateVale:FilterFrameText;
        private var _needLevel:FilterFrameText;
        private var _ConsumeHonor:FilterFrameText;
        private var _ConsumeExp:FilterFrameText;
        private var _PropVec:Vector.<FilterFrameText>;
        private var _rule1:ScaleBitmapImage;
        private var _rule2:ScaleBitmapImage;
        private var _rule3:ScaleBitmapImage;
        private var _rule4:ScaleBitmapImage;
        private var _thisHeight:int;


        override protected function init():void
        {
            this._bg = ComponentFactory.Instance.creatComponentByStylename("core.GoodsTipBg");
            this._rule1 = ComponentFactory.Instance.creatComponentByStylename("HRuleAsset");
            this._rule2 = ComponentFactory.Instance.creatComponentByStylename("HRuleAsset");
            this._rule3 = ComponentFactory.Instance.creatComponentByStylename("HRuleAsset");
            this._rule4 = ComponentFactory.Instance.creatComponentByStylename("HRuleAsset");
            this._ActivationProperty = ComponentFactory.Instance.creatComponentByStylename("TotemTips.ActivationPropertyTxt");
            this._ActivationPropertyValue = ComponentFactory.Instance.creatComponentByStylename("TotemTips.ActivationPropertyValueTxt");
            this._ActivationRate = ComponentFactory.Instance.creatComponentByStylename("TotemTips.ActivationPropertyTxt");
            this._ActivationRateVale = ComponentFactory.Instance.creatComponentByStylename("TotemTips.ActivationRateValueTxt");
            this._needLevel = ComponentFactory.Instance.creatComponentByStylename("TotemTips.needLevelTxt");
            this._ConsumeHonor = ComponentFactory.Instance.creatComponentByStylename("TotemTips.ConsumeHonorTxt");
            this._ConsumeExp = ComponentFactory.Instance.creatComponentByStylename("TotemTips.ConsumeHonorTxt");
            this._PropVec = new Vector.<FilterFrameText>();
            var _local_1:int;
            while (_local_1 < 10)
            {
                this._PropVec[_local_1] = ComponentFactory.Instance.creatComponentByStylename("TotemTips.propTxt");
                _local_1++;
            };
            super.init();
            super.tipbackgound = this._bg;
        }

        override protected function addChildren():void
        {
            super.addChildren();
            addChild(this._ActivationProperty);
            addChild(this._ActivationPropertyValue);
            addChild(this._ActivationRate);
            addChild(this._ActivationRateVale);
            addChild(this._needLevel);
            addChild(this._ConsumeHonor);
            addChild(this._ConsumeExp);
            var _local_1:int;
            while (_local_1 < 10)
            {
                addChild(this._PropVec[_local_1]);
                _local_1++;
            };
            addChild(this._rule1);
            addChild(this._rule2);
            addChild(this._rule3);
            addChild(this._rule4);
            this._rule3.x = (this._rule4.x = 4);
            mouseChildren = false;
            mouseEnabled = false;
        }

        override public function get tipData():Object
        {
            return (_tipData);
        }

        override public function set tipData(_arg_1:Object):void
        {
            if (_arg_1)
            {
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
            this._ActivationProperty.text = "激活属性:";
            this._ActivationPropertyValue.text = "生命+15";
            this._ActivationPropertyValue.x = (this._ActivationProperty.textWidth + 10);
            this._rule1.x = (this._ActivationProperty.textWidth + 8);
            this._rule1.y = ((this._ActivationProperty.y + this._ActivationProperty.textHeight) + 2);
            this._rule1.width = 50;
            this._ActivationRate.text = "激活成功率:";
            this._ActivationRate.y = (this._rule1.y + 12);
            this._ActivationRateVale.text = "必成";
            this._ActivationRateVale.x = (this._ActivationRate.textWidth + 10);
            this._ActivationRateVale.y = this._ActivationRate.y;
            this._rule2.x = (this._ActivationRate.textWidth + 8);
            this._rule2.y = ((this._ActivationRate.y + this._ActivationRate.textHeight) + 2);
            this._rule2.width = 50;
            this._needLevel.text = "需要等级: 25级";
            this._needLevel.y = (this._rule2.y + 12);
            this._rule3.y = ((this._needLevel.y + this._needLevel.textHeight) + 12);
            this._thisHeight = (this._rule3.y + this._rule3.height);
        }

        private function showMiddlePart():void
        {
            this._ConsumeHonor.text = "消耗荣誉: 800";
            this._ConsumeHonor.y = ((this._rule3.y + this._rule3.height) + 12);
            this._ConsumeExp.text = "消耗经验: 500";
            this._ConsumeExp.y = ((this._ConsumeHonor.y + this._ConsumeHonor.textHeight) + 4);
            this._rule4.y = ((this._ConsumeExp.y + this._ConsumeExp.textHeight) + 12);
            this._thisHeight = (this._rule4.y + this._rule4.height);
        }

        private function showButtomPart():void
        {
            var _local_1:Array = ["Lv1. 攻击 +9", "Lv2. 攻击 +18", "Lv3. 攻击 +27", "Lv4. 攻击 +36", "Lv5. 攻击 +45", "Lv6. 攻击 +54", "Lv7. 攻击 +63", "Lv8. 攻击 +72", "Lv9. 攻击 +81", "Lv10. 攻击 +90"];
            var _local_2:int;
            while (_local_2 < 10)
            {
                if (_local_2 < 5)
                {
                    this._PropVec[_local_2].text = _local_1[_local_2];
                    this._PropVec[_local_2].y = (((this._rule4.y + this._rule4.height) + 8) + (20 * _local_2));
                }
                else
                {
                    this._PropVec[_local_2].text = _local_1[_local_2];
                    this._PropVec[_local_2].x = 124;
                    this._PropVec[_local_2].y = (((this._rule4.y + this._rule4.height) + 8) + (20 * (_local_2 - 5)));
                };
                this._thisHeight = (this._PropVec[_local_2].y + this._PropVec[_local_2].textHeight);
                _local_2++;
            };
        }

        private function upBackground():void
        {
            this._bg.height = (this._thisHeight + 13);
            this._bg.width = THISWIDTH;
            this.updateWH();
        }

        private function updateWH():void
        {
            _width = this._bg.width;
            _height = this._bg.height;
        }

        override public function dispose():void
        {
            super.dispose();
            ObjectUtils.disposeAllChildren(this);
            this._ActivationProperty = null;
            this._ActivationPropertyValue = null;
            this._ActivationRate = null;
            this._ActivationRateVale = null;
            this._ConsumeExp = null;
            this._ConsumeHonor = null;
            this._needLevel = null;
            var _local_1:int;
            while (_local_1 < this._PropVec.length)
            {
                this._PropVec[_local_1] = null;
                _local_1++;
            };
            this._PropVec = null;
            this._rule1 = null;
            this._rule2 = null;
            this._rule3 = null;
            this._rule4 = null;
            if (this.parent)
            {
                this.parent.removeChild(this);
            };
        }


    }
}//package ddt.view.tips

