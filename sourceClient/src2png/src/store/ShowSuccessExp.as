﻿// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//store.ShowSuccessExp

package store
{
    import flash.display.Sprite;
    import com.pickgliss.ui.core.Disposeable;
    import com.pickgliss.ui.text.FilterFrameText;
    import ddt.command.StripTip;
    import com.pickgliss.ui.ComponentFactory;
    import ddt.manager.LanguageMgr;
    import ddt.utils.PositionUtils;
    import com.pickgliss.utils.ObjectUtils;

    public class ShowSuccessExp extends Sprite implements Disposeable 
    {

        private var _showTxtI:FilterFrameText;
        private var _showTxtIII:FilterFrameText;
        private var _showTxtIV:FilterFrameText;
        private var _showTxtVIP:FilterFrameText;
        private var _showTxtILabel:FilterFrameText;
        private var _showTxtIIILabel:FilterFrameText;
        private var _showTxtIVLabel:FilterFrameText;
        private var _showTxtVipLabel:FilterFrameText;
        private var _showStripI:StripTip;
        private var _showStripIII:StripTip;
        private var _showStripIV:StripTip;
        private var _showStripVIP:StripTip;

        public function ShowSuccessExp()
        {
            this._init();
        }

        private function _init():void
        {
            this._showTxtI = ComponentFactory.Instance.creatComponentByStylename("ddtstore.StoreIIStrengthBg.SuccessExpTextBasic");
            this._showTxtI.text = "0";
            this._showTxtIII = ComponentFactory.Instance.creatComponentByStylename("ddtstore.StoreIIStrengthBg.SuccessExpTextGuild");
            this._showTxtIII.text = "0";
            this._showTxtIV = ComponentFactory.Instance.creatComponentByStylename("ddtstore.StoreIIStrengthBg.SuccessExpTextTotal");
            this._showTxtIV.text = "0";
            this._showTxtILabel = ComponentFactory.Instance.creatComponentByStylename("ddtstore.StoreIIStrengthBg.SuccessExpTextBasicLabel");
            this._showTxtILabel.text = LanguageMgr.GetTranslation("store.Strength.SuccessExp.BasicText");
            this._showTxtIIILabel = ComponentFactory.Instance.creatComponentByStylename("ddtstore.StoreIIStrengthBg.SuccessExpTextGuildLabel");
            this._showTxtIIILabel.text = LanguageMgr.GetTranslation("store.Strength.SuccessExp.GuildText");
            this._showTxtIVLabel = ComponentFactory.Instance.creatComponentByStylename("ddtstore.StoreIIStrengthBg.SuccessExpTextTotalLabel");
            this._showTxtIVLabel.text = LanguageMgr.GetTranslation("store.Strength.SuccessExp.TotalText");
            this._showStripI = ComponentFactory.Instance.creatCustomObject("ddtstore.view.basallevelStrip");
            this._showStripIII = ComponentFactory.Instance.creatCustomObject("ddtstore.view.consortiaStrip");
            this._showStripIV = ComponentFactory.Instance.creatCustomObject("ddtstore.view.percentageStrip");
            addChild(this._showTxtI);
            addChild(this._showTxtIV);
            addChild(this._showTxtILabel);
            addChild(this._showTxtIVLabel);
            addChild(this._showStripI);
            addChild(this._showStripIV);
        }

        public function showVIPRate():void
        {
            this._showTxtVIP = ComponentFactory.Instance.creatComponentByStylename("ddtstore.StoreIIStrengthBg.SuccessExpTextVip");
            this._showTxtVIP.text = "0";
            this._showTxtVipLabel = ComponentFactory.Instance.creatComponentByStylename("ddtstore.StoreIIStrengthBg.SuccessExpTextVipLabel");
            this._showTxtVipLabel.text = LanguageMgr.GetTranslation("store.Strength.SuccessExp.VipText");
            this._showStripVIP = ComponentFactory.Instance.creatCustomObject("ddtstore.view.VIPStrip");
            PositionUtils.setPos(this._showStripI, "ddtstore.view.showStripIExpPos");
            this._showStripI.width = (this._showStripI.width - 10);
            PositionUtils.setPos(this._showStripIII, "ddtstore.view.showStripIIIExpPos");
            this._showStripIII.width = (this._showStripIII.width - 10);
            PositionUtils.setPos(this._showStripIV, "ddtstore.view.showStripIVExpPos");
            this._showStripIV.width = (this._showStripIV.width - 10);
            PositionUtils.setPos(this._showStripVIP, "ddtstore.view.showStripVIPExpPos");
            this._showStripVIP.width = (this._showStripVIP.width - 10);
            addChild(this._showTxtVIP);
            addChild(this._showTxtVipLabel);
            addChild(this._showStripVIP);
        }

        public function showAllTips(_arg_1:String, _arg_2:String, _arg_3:String):void
        {
            this._showStripI.tipData = _arg_1;
            this._showStripIII.tipData = _arg_2;
            this._showStripIV.tipData = _arg_3;
        }

        public function showVIPTip(_arg_1:String):void
        {
            this._showStripVIP.tipData = _arg_1;
        }

        public function showAllNum(_arg_1:Number, _arg_2:Number, _arg_3:Number, _arg_4:Number):void
        {
            this._showTxtI.text = String(_arg_1);
            this._showTxtIII.text = String(_arg_2);
            this._showTxtVIP.text = String(_arg_3);
            this._showTxtIV.text = String(_arg_4);
        }

        public function dispose():void
        {
            if (this._showTxtI)
            {
                ObjectUtils.disposeObject(this._showTxtI);
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
            this._showTxtI = null;
            this._showTxtIII = null;
            this._showTxtIV = null;
            this._showTxtVIP = null;
            this._showStripI = null;
            this._showStripIII = null;
            this._showStripIV = null;
            this._showStripVIP = null;
            this._showTxtILabel = null;
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
