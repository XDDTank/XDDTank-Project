// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//bead.view.ExpBeadTip

package bead.view
{
    import com.pickgliss.ui.tip.BaseTip;
    import com.pickgliss.ui.image.ScaleBitmapImage;
    import com.pickgliss.ui.text.FilterFrameText;
    import com.pickgliss.ui.ComponentFactory;
    import ddt.data.goods.InventoryItemInfo;
    import ddt.manager.LanguageMgr;
    import ddt.data.goods.ItemTemplateInfo;
    import com.pickgliss.utils.ObjectUtils;

    public class ExpBeadTip extends BaseTip 
    {

        private var _bg:ScaleBitmapImage;
        private var _nameTxt:FilterFrameText;
        private var _discTxt:FilterFrameText;
        private var _beadTipData:Object;

        public function ExpBeadTip()
        {
            this.initView();
        }

        private function initView():void
        {
            this._bg = ComponentFactory.Instance.creatComponentByStylename("beadSystem.getBead.requestBtn.tip.bg");
            this._nameTxt = ComponentFactory.Instance.creatComponentByStylename("beadSystem.getBead.requestBtn.tip.name");
            this._discTxt = ComponentFactory.Instance.creatComponentByStylename("beadSystem.getBead.requestBtn.tip.disc");
            addChild(this._bg);
            addChild(this._nameTxt);
            addChild(this._discTxt);
        }

        override public function get tipData():Object
        {
            return (this._beadTipData);
        }

        override public function set tipData(_arg_1:Object):void
        {
            this._beadTipData = _arg_1;
            this._nameTxt.text = _arg_1.Name;
            if (((_arg_1 as InventoryItemInfo) && (InventoryItemInfo(_arg_1).beadExp > 0)))
            {
                this._discTxt.text = LanguageMgr.GetTranslation("beadSystem.bead.expBead.tip", InventoryItemInfo(_arg_1).beadExp.toString());
            }
            else
            {
                this._discTxt.text = LanguageMgr.GetTranslation("beadSystem.bead.expBead.tip", ItemTemplateInfo(_arg_1).Property5);
            };
            this.updateSize();
        }

        private function updateSize():void
        {
            this._bg.width = ((this._discTxt.x + this._discTxt.width) + 15);
            this._bg.height = ((this._discTxt.y + this._discTxt.height) + 10);
            _width = this._bg.width;
            _height = this._bg.height;
        }

        override public function dispose():void
        {
            this._beadTipData = null;
            if (this._bg)
            {
                ObjectUtils.disposeObject(this._bg);
            };
            this._bg = null;
            if (this._nameTxt)
            {
                ObjectUtils.disposeObject(this._nameTxt);
            };
            this._nameTxt = null;
            if (this._discTxt)
            {
                ObjectUtils.disposeObject(this._discTxt);
            };
            this._discTxt = null;
            super.dispose();
        }


    }
}//package bead.view

