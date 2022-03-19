// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//store.ShowSuccessRate

package store
{
    import flash.display.Sprite;
    import com.pickgliss.ui.image.ScaleFrameImage;
    import com.pickgliss.ui.text.FilterFrameText;
    import com.pickgliss.ui.image.Image;
    import ddt.command.StripTip;
    import com.pickgliss.ui.ComponentFactory;
    import ddt.manager.LanguageMgr;
    import ddt.utils.PositionUtils;
    import com.pickgliss.utils.ObjectUtils;

    public class ShowSuccessRate extends Sprite 
    {

        private var _bg:ScaleFrameImage;
        private var _showTxtI:FilterFrameText;
        private var _showTxtII:FilterFrameText;
        private var _showTxtIII:FilterFrameText;
        private var _showTxtIV:FilterFrameText;
        private var _showTxtVIP:FilterFrameText;
        private var _showTxtILabel:FilterFrameText;
        private var _showTxtIILabel:FilterFrameText;
        private var _showTxtIIILabel:FilterFrameText;
        private var _showTxtIVLabel:Image;
        private var _showTxtVipLabel:FilterFrameText;
        private var _showStripI:StripTip;
        private var _showStripII:StripTip;
        private var _showStripIII:StripTip;
        private var _showStripIV:StripTip;
        private var _showStripVIP:StripTip;

        public function ShowSuccessRate()
        {
            this._init();
        }

        private function _init():void
        {
            this._bg = ComponentFactory.Instance.creatComponentByStylename("ddtstore.StoreIIStrengthBg.ShowSuccessRateBg");
            this._bg.setFrame(1);
            this._showTxtI = ComponentFactory.Instance.creatComponentByStylename("ddtstore.StoreIIStrengthBg.SuccessRateTextBasic");
            this._showTxtI.text = "0%";
            this._showTxtII = ComponentFactory.Instance.creatComponentByStylename("ddtstore.StoreIIStrengthBg.SuccessRateTextLucky");
            this._showTxtII.text = "0%";
            this._showTxtIII = ComponentFactory.Instance.creatComponentByStylename("ddtstore.StoreIIStrengthBg.SuccessRateTextGuild");
            this._showTxtIII.text = "0%";
            this._showTxtIV = ComponentFactory.Instance.creatComponentByStylename("ddtstore.StoreIIStrengthBg.SuccessRateTextTotal");
            this._showTxtIV.text = "0%";
            this._showTxtILabel = ComponentFactory.Instance.creatComponentByStylename("ddtstore.StoreIIStrengthBg.SuccessRateTextBasicLabel");
            this._showTxtILabel.text = LanguageMgr.GetTranslation("store.Strength.SuccessRate.BasicText");
            this._showTxtIILabel = ComponentFactory.Instance.creatComponentByStylename("ddtstore.StoreIIStrengthBg.SuccessRateTextLuckyLabel");
            this._showTxtIILabel.text = LanguageMgr.GetTranslation("store.Strength.SuccessRate.LuckyText");
            this._showTxtIIILabel = ComponentFactory.Instance.creatComponentByStylename("ddtstore.StoreIIStrengthBg.SuccessRateTextGuildLabel");
            this._showTxtIIILabel.text = LanguageMgr.GetTranslation("store.Strength.SuccessRate.GuildText");
            this._showTxtIVLabel = ComponentFactory.Instance.creatComponentByStylename("ddtstore.StoreIIStrengthBg.SuccessRateTextTotalLabel");
            this._showStripI = ComponentFactory.Instance.creatCustomObject("ddtstore.view.basallevelStrip");
            this._showStripII = ComponentFactory.Instance.creatCustomObject("ddtstore.view.luckyStrip");
            this._showStripIII = ComponentFactory.Instance.creatCustomObject("ddtstore.view.consortiaStrip");
            this._showStripIV = ComponentFactory.Instance.creatCustomObject("ddtstore.view.percentageStrip");
            addChild(this._bg);
            addChild(this._showTxtI);
            addChild(this._showTxtII);
            addChild(this._showTxtIII);
            addChild(this._showTxtIV);
            addChild(this._showTxtILabel);
            addChild(this._showTxtIILabel);
            addChild(this._showTxtIIILabel);
            addChild(this._showTxtIVLabel);
            addChild(this._showStripI);
            addChild(this._showStripII);
            addChild(this._showStripIII);
            addChild(this._showStripIV);
        }

        public function showVIPRate():void
        {
            this._bg.setFrame(2);
            this._showTxtVIP = ComponentFactory.Instance.creatComponentByStylename("ddtstore.StoreIIStrengthBg.SuccessRateTextVip");
            this._showTxtVIP.text = "0%";
            this._showTxtVipLabel = ComponentFactory.Instance.creatComponentByStylename("ddtstore.StoreIIStrengthBg.SuccessRateTextVipLabel");
            this._showTxtVipLabel.text = LanguageMgr.GetTranslation("store.Strength.SuccessRate.VipText");
            this._showStripVIP = ComponentFactory.Instance.creatCustomObject("ddtstore.view.VIPStrip");
            PositionUtils.setPos(this._showTxtI, "ddtstore.showSuccessRateTxtIPos");
            PositionUtils.setPos(this._showTxtII, "ddtstore.showSuccessRateTxtIIPos");
            PositionUtils.setPos(this._showTxtIII, "ddtstore.showSuccessRateTxtIIIPos");
            PositionUtils.setPos(this._showTxtIV, "ddtstore.showSuccessRateTxtIVPos");
            PositionUtils.setPos(this._showTxtILabel, "ddtstore.showSuccessRateTxtILabelPos");
            PositionUtils.setPos(this._showTxtIILabel, "ddtstore.showSuccessRateTxtIILabelPos");
            PositionUtils.setPos(this._showTxtIIILabel, "ddtstore.showSuccessRateTxtIIILabelPos");
            PositionUtils.setPos(this._showTxtIVLabel, "ddtstore.showSuccessRateTxtIVLabelPos");
            PositionUtils.setPos(this._showStripI, "ddtstore.view.showStripIPos");
            this._showStripI.width = (this._showStripI.width - 10);
            PositionUtils.setPos(this._showStripII, "ddtstore.view.showStripIIPos");
            this._showStripII.width = (this._showStripII.width - 10);
            PositionUtils.setPos(this._showStripIII, "ddtstore.view.showStripIIIPos");
            this._showStripIII.width = (this._showStripIII.width - 10);
            PositionUtils.setPos(this._showStripIV, "ddtstore.view.showStripIVPos");
            this._showStripIV.width = (this._showStripIV.width - 10);
            addChild(this._showTxtVIP);
            addChild(this._showTxtVipLabel);
            addChild(this._showStripVIP);
        }

        public function showAllTips(_arg_1:String, _arg_2:String, _arg_3:String, _arg_4:String):void
        {
            this._showStripI.tipData = _arg_1;
            this._showStripII.tipData = _arg_2;
            this._showStripIII.tipData = _arg_3;
            this._showStripIV.tipData = _arg_4;
        }

        public function showVIPTip(_arg_1:String):void
        {
            this._showStripVIP.tipData = _arg_1;
        }

        public function showAllNum(_arg_1:Number, _arg_2:Number, _arg_3:Number, _arg_4:Number):void
        {
            this._showTxtI.text = (String(_arg_1) + "%");
            this._showTxtII.text = (String(_arg_2) + "%");
            this._showTxtIII.text = (String(_arg_3) + "%");
            this._showTxtIV.text = (String(_arg_4) + "%");
        }

        public function showVIPNum(_arg_1:Number):void
        {
            this._showTxtVIP.text = (String(_arg_1) + "%");
        }

        public function dispose():void
        {
            if (this._bg)
            {
                ObjectUtils.disposeObject(this._bg);
            };
            if (this._showTxtI)
            {
                ObjectUtils.disposeObject(this._showTxtI);
            };
            if (this._showTxtII)
            {
                ObjectUtils.disposeObject(this._showTxtII);
            };
            if (this._showTxtIII)
            {
                ObjectUtils.disposeObject(this._showTxtIII);
            };
            if (this._showTxtIV)
            {
                ObjectUtils.disposeObject(this._showTxtIV);
            };
            if (this._showTxtVIP)
            {
                ObjectUtils.disposeObject(this._showTxtVIP);
            };
            if (this._showStripI)
            {
                ObjectUtils.disposeObject(this._showStripI);
            };
            if (this._showStripII)
            {
                ObjectUtils.disposeObject(this._showStripII);
            };
            if (this._showStripIII)
            {
                ObjectUtils.disposeObject(this._showStripIII);
            };
            if (this._showStripIV)
            {
                ObjectUtils.disposeObject(this._showStripIV);
            };
            if (this._showStripVIP)
            {
                ObjectUtils.disposeObject(this._showStripVIP);
            };
            if (this._showTxtILabel)
            {
                ObjectUtils.disposeObject(this._showTxtILabel);
            };
            if (this._showTxtIILabel)
            {
                ObjectUtils.disposeObject(this._showTxtIILabel);
            };
            if (this._showTxtIIILabel)
            {
                ObjectUtils.disposeObject(this._showTxtIIILabel);
            };
            if (this._showTxtIVLabel)
            {
                ObjectUtils.disposeObject(this._showTxtIVLabel);
            };
            if (this._showTxtVipLabel)
            {
                ObjectUtils.disposeObject(this._showTxtVipLabel);
            };
            this._bg = null;
            this._showTxtI = null;
            this._showTxtII = null;
            this._showTxtIII = null;
            this._showTxtIV = null;
            this._showTxtVIP = null;
            this._showStripI = null;
            this._showStripII = null;
            this._showStripIII = null;
            this._showStripIV = null;
            this._showStripVIP = null;
            this._showTxtILabel = null;
            this._showTxtIILabel = null;
            this._showTxtIIILabel = null;
            this._showTxtIVLabel = null;
            this._showTxtVipLabel = null;
            if (parent)
            {
                parent.removeChild(this);
            };
        }


    }
}//package store

