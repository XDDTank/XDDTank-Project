// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//vip.view.GrowthRuleView

package vip.view
{
    import flash.display.Sprite;
    import com.pickgliss.ui.core.Disposeable;
    import flash.display.Bitmap;
    import com.pickgliss.ui.image.Image;
    import com.pickgliss.ui.text.FilterFrameText;
    import com.pickgliss.ui.ComponentFactory;
    import ddt.manager.LanguageMgr;
    import com.pickgliss.utils.ObjectUtils;

    public class GrowthRuleView extends Sprite implements Disposeable 
    {

        private var _bg:Bitmap;
        private var _descriptionItem1:Image;
        private var _descriptionItem2:Image;
        private var _descriptionItem3:Image;
        private var _descriptionTxt1:FilterFrameText;
        private var _descriptionTxt2:FilterFrameText;
        private var _descriptionTxt3:FilterFrameText;
        private var _ruleTitleTxt:FilterFrameText;
        private var _ruleTxt:FilterFrameText;

        public function GrowthRuleView()
        {
            this.initView();
        }

        private function initView():void
        {
            this._bg = ComponentFactory.Instance.creatBitmap("vip.VipPrivilegeFrameBg");
            addChild(this._bg);
            this._descriptionItem1 = ComponentFactory.Instance.creatComponentByStylename("vip.GrowthRuleView.DescItem1");
            this._descriptionItem2 = ComponentFactory.Instance.creatComponentByStylename("vip.GrowthRuleView.DescItem2");
            this._descriptionItem3 = ComponentFactory.Instance.creatComponentByStylename("vip.GrowthRuleView.DescItem3");
            this._descriptionTxt1 = ComponentFactory.Instance.creatComponentByStylename("vip.GrowthRuleView.DescTxt1");
            this._descriptionTxt1.text = LanguageMgr.GetTranslation("ddt.vip.GrowthRuleView.DescTxt1");
            this._descriptionTxt2 = ComponentFactory.Instance.creatComponentByStylename("vip.GrowthRuleView.DescTxt2");
            this._descriptionTxt2.text = LanguageMgr.GetTranslation("ddt.vip.GrowthRuleView.DescTxt2");
            this._descriptionTxt3 = ComponentFactory.Instance.creatComponentByStylename("vip.GrowthRuleView.DescTxt3");
            this._descriptionTxt3.text = LanguageMgr.GetTranslation("ddt.vip.GrowthRuleView.DescTxt3");
            this._ruleTitleTxt = ComponentFactory.Instance.creatComponentByStylename("vip.GrowthRuleView.RuleTxtTitle");
            this._ruleTitleTxt.text = LanguageMgr.GetTranslation("ddt.vip.GrowthRuleView.RuleTitleTxt");
            this._ruleTxt = ComponentFactory.Instance.creatComponentByStylename("vip.GrowthRuleView.RuleTxt");
            this._ruleTxt.text = ((((LanguageMgr.GetTranslation("ddt.vip.GrowthRuleView.RuleTxt1") + LanguageMgr.GetTranslation("ddt.vip.GrowthRuleView.RuleTxt2")) + LanguageMgr.GetTranslation("ddt.vip.GrowthRuleView.RuleTxt3")) + LanguageMgr.GetTranslation("ddt.vip.GrowthRuleView.RuleTxt4")) + LanguageMgr.GetTranslation("ddt.vip.GrowthRuleView.RuleTxt5"));
            addChild(this._descriptionItem1);
            addChild(this._descriptionItem2);
            addChild(this._descriptionItem3);
            addChild(this._descriptionTxt1);
            addChild(this._descriptionTxt2);
            addChild(this._descriptionTxt3);
            addChild(this._ruleTitleTxt);
            addChild(this._ruleTxt);
        }

        public function dispose():void
        {
            ObjectUtils.disposeObject(this._bg);
            ObjectUtils.disposeObject(this._descriptionItem1);
            ObjectUtils.disposeObject(this._descriptionItem2);
            ObjectUtils.disposeObject(this._descriptionItem3);
            ObjectUtils.disposeObject(this._descriptionTxt1);
            ObjectUtils.disposeObject(this._descriptionTxt2);
            ObjectUtils.disposeObject(this._descriptionTxt3);
            ObjectUtils.disposeObject(this._ruleTitleTxt);
            ObjectUtils.disposeObject(this._ruleTxt);
            this._bg = null;
            this._descriptionItem1 = null;
            this._descriptionItem2 = null;
            this._descriptionItem3 = null;
            this._descriptionTxt1 = null;
            this._descriptionTxt2 = null;
            this._descriptionTxt3 = null;
            this._ruleTitleTxt = null;
            this._ruleTxt = null;
        }


    }
}//package vip.view

