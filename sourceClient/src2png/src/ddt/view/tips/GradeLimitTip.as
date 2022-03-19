// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//ddt.view.tips.GradeLimitTip

package ddt.view.tips
{
    import com.pickgliss.ui.ComponentFactory;

    public class GradeLimitTip extends OneLineTip 
    {


        override protected function init():void
        {
            _bg = ComponentFactory.Instance.creatComponentByStylename("core.commonTipBg");
            _contentTxt = ComponentFactory.Instance.creatComponentByStylename("core.goodTip.LimitGradeTxt");
            addChild(_bg);
            addChild(_contentTxt);
        }


    }
}//package ddt.view.tips

