// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//bead.view.BeadPowerTipPanel

package bead.view
{
    import com.pickgliss.ui.tip.BaseTip;
    import com.pickgliss.ui.image.ScaleBitmapImage;
    import com.pickgliss.ui.text.FilterFrameText;
    import com.pickgliss.ui.ComponentFactory;
    import com.pickgliss.utils.ObjectUtils;

    public class BeadPowerTipPanel extends BaseTip 
    {

        private var _bg:ScaleBitmapImage;
        private var _hLine:ScaleBitmapImage;
        private var _nameTxt:FilterFrameText;
        private var _contentTxt:FilterFrameText;
        private var _beadTipData:Object;

        public function BeadPowerTipPanel()
        {
            this.initView();
        }

        private function initView():void
        {
            this._bg = ComponentFactory.Instance.creatComponentByStylename("core.commonTipBg");
            this._hLine = ComponentFactory.Instance.creatComponentByStylename("beadSystem.beadInset.beadPower.tip.hLine");
            this._nameTxt = ComponentFactory.Instance.creatComponentByStylename("beadSystem.beadInset.beadPower.tip");
            this._contentTxt = ComponentFactory.Instance.creatComponentByStylename("beadSystem.beadInset.beadPower.tip2");
            addChild(this._bg);
            addChild(this._hLine);
            addChild(this._nameTxt);
            addChild(this._contentTxt);
        }

        override public function get tipData():Object
        {
            return (this._beadTipData);
        }

        override public function set tipData(_arg_1:Object):void
        {
            if (((_arg_1) && (!(this._beadTipData == _arg_1))))
            {
                this._beadTipData = _arg_1;
                this._nameTxt.text = _arg_1[0];
                if (_arg_1[1] == "")
                {
                    this._hLine.visible = false;
                    this._contentTxt.visible = false;
                    this._bg.width = ((this._nameTxt.x + this._nameTxt.textWidth) + 15);
                    this._bg.height = ((this._nameTxt.y + this._nameTxt.textHeight) + 10);
                }
                else
                {
                    this._hLine.visible = true;
                    this._contentTxt.visible = true;
                    this._contentTxt.htmlText = _arg_1[1];
                    this._hLine.width = ((this._contentTxt.x + this._contentTxt.textWidth) + 6);
                    this._bg.width = ((this._contentTxt.x + this._contentTxt.textWidth) + 30);
                    this._bg.height = ((this._contentTxt.y + this._contentTxt.textHeight) + 11);
                };
                _width = this._bg.width;
                _height = this._bg.height;
            };
        }

        override public function dispose():void
        {
            this._beadTipData = null;
            if (this._bg)
            {
                ObjectUtils.disposeObject(this._bg);
            };
            this._bg = null;
            if (this._hLine)
            {
                ObjectUtils.disposeObject(this._hLine);
            };
            this._hLine = null;
            if (this._nameTxt)
            {
                ObjectUtils.disposeObject(this._nameTxt);
            };
            this._nameTxt = null;
            if (this._contentTxt)
            {
                ObjectUtils.disposeObject(this._contentTxt);
            };
            this._contentTxt = null;
            super.dispose();
        }


    }
}//package bead.view

