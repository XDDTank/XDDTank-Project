// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//bead.view.BeadComposeTipPanel

package bead.view
{
    import com.pickgliss.ui.image.ScaleBitmapImage;
    import com.pickgliss.ui.text.FilterFrameText;
    import com.pickgliss.ui.ComponentFactory;
    import ddt.manager.LanguageMgr;
    import bead.BeadManager;
    import ddt.data.goods.InventoryItemInfo;
    import com.pickgliss.utils.ObjectUtils;

    public class BeadComposeTipPanel extends BeadTipPanel 
    {

        protected var _hLine3:ScaleBitmapImage;
        protected var _nextTxt:FilterFrameText;
        protected var _nextDic:FilterFrameText;


        override protected function initView():void
        {
            super.initView();
            this._hLine3 = ComponentFactory.Instance.creatComponentByStylename("beadSystem.beadTip.hLine3");
            this._nextTxt = ComponentFactory.Instance.creatComponentByStylename("beadSystem.beadTip.nextTxt");
            this._nextDic = ComponentFactory.Instance.creatComponentByStylename("beadSystem.beadTip.nextDic");
            _container.addChild(this._hLine3);
            _container.addChild(this._nextTxt);
            _container.addChild(this._nextDic);
        }

        override protected function setTxt(_arg_1:Object):void
        {
            super.setTxt(_arg_1);
            if (_arg_1.beadLevel < 30)
            {
                this._nextTxt.text = LanguageMgr.GetTranslation("beadSystem.bead.nextTxt");
                this._nextDic.htmlText = BeadManager.instance.getNextDescriptionStr((_arg_1 as InventoryItemInfo));
                MAX_H = 155;
                this._hLine3.visible = true;
                this._nextTxt.visible = true;
                this._nextDic.visible = true;
            }
            else
            {
                this._hLine3.visible = false;
                this._nextTxt.visible = false;
                this._nextDic.visible = false;
                MAX_H = 99;
            };
        }

        override public function dispose():void
        {
            ObjectUtils.disposeObject(this._hLine3);
            this._hLine3 = null;
            ObjectUtils.disposeObject(_nameTxt);
            _nameTxt = null;
            super.dispose();
        }


    }
}//package bead.view

