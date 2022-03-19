// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//farm.view.FarmGainFram

package farm.view
{
    import com.pickgliss.ui.controls.alert.BaseAlerFrame;
    import com.pickgliss.ui.text.FilterFrameText;
    import ddt.manager.LanguageMgr;
    import com.pickgliss.ui.vo.AlertInfo;
    import com.pickgliss.ui.ComponentFactory;
    import com.pickgliss.utils.ObjectUtils;

    public class FarmGainFram extends BaseAlerFrame 
    {

        private var submitLabel:String;
        private var tipTest:FilterFrameText;
        private var getTest:String;

        public function FarmGainFram()
        {
            this.submitLabel = LanguageMgr.GetTranslation("ddt.farms.goToField");
            info = new AlertInfo();
            info.bottomGap = 20;
            info.title = LanguageMgr.GetTranslation("AlertDialog.Info");
            info.showCancel = false;
            if ((!(this.submitLabel)))
            {
                info.submitLabel = LanguageMgr.GetTranslation("shop.PresentFrame.OkBtnText");
            }
            else
            {
                info.submitLabel = this.submitLabel;
            };
        }

        override protected function init():void
        {
            super.init();
            this.getTest = LanguageMgr.GetTranslation("ddt.farms.fieldHasGain");
            this.tipTest = ComponentFactory.Instance.creatComponentByStylename("farm.gain.field");
            this.tipTest.text = this.getTest;
            addToContent(this.tipTest);
        }

        override public function dispose():void
        {
            ObjectUtils.disposeObject(this.tipTest);
            this.tipTest = null;
            super.dispose();
        }


    }
}//package farm.view

