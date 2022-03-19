// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//petsBag.view.tip.PetBlessTip

package petsBag.view.tip
{
    import com.pickgliss.ui.tip.BaseTip;
    import com.pickgliss.ui.image.ScaleBitmapImage;
    import com.pickgliss.ui.text.FilterFrameText;
    import com.pickgliss.ui.ComponentFactory;
    import ddt.manager.LanguageMgr;

    public class PetBlessTip extends BaseTip 
    {

        private var _bg:ScaleBitmapImage;
        private var _nameTxt:FilterFrameText;
        private var _splitImg1:ScaleBitmapImage;
        private var _description:FilterFrameText;


        override protected function init():void
        {
            super.init();
            this._bg = ComponentFactory.Instance.creat("petsBag.view.blessTip.bg");
            _width = this._bg.width;
            _height = this._bg.height;
            addChild(this._bg);
            this._nameTxt = ComponentFactory.Instance.creat("petsBag.view.blessTip.nametxt");
            this._nameTxt.text = LanguageMgr.GetTranslation("petsbag.tips.blessTip.name");
            addChild(this._nameTxt);
            this._splitImg1 = ComponentFactory.Instance.creatComponentByStylename("petsBag.view.blessTip.splitImg1");
            addChild(this._splitImg1);
            this._description = ComponentFactory.Instance.creat("petsBag.view.blessTip.descriptionTxt");
            this._description.htmlText = LanguageMgr.GetTranslation("petsbag.tips.blessTip.description");
            addChild(this._description);
        }


    }
}//package petsBag.view.tip

