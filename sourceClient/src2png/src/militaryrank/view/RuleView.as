// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//militaryrank.view.RuleView

package militaryrank.view
{
    import flash.display.Sprite;
    import com.pickgliss.ui.core.Disposeable;
    import com.pickgliss.ui.image.Scale9CornerImage;
    import flash.display.MovieClip;
    import com.pickgliss.ui.controls.ScrollPanel;
    import com.pickgliss.ui.ComponentFactory;
    import com.pickgliss.utils.ClassUtils;
    import com.pickgliss.utils.ObjectUtils;

    public class RuleView extends Sprite implements Disposeable 
    {

        private var _ruleFrameBg:Scale9CornerImage;
        private var _helpText:MovieClip;
        private var _scrollView:ScrollPanel;

        public function RuleView()
        {
            this.init();
        }

        protected function init():void
        {
            this._ruleFrameBg = ComponentFactory.Instance.creatComponentByStylename("militaryrank.ruleFrameBg");
            addChild(this._ruleFrameBg);
            this._helpText = ClassUtils.CreatInstance("militaryrank.ruleText");
            this._scrollView = ComponentFactory.Instance.creat("militaryrank.ruleView.scrollPanel");
            this._scrollView.setView(this._helpText);
            addChild(this._scrollView);
        }

        public function dispose():void
        {
            ObjectUtils.disposeObject(this._ruleFrameBg);
            this._ruleFrameBg = null;
            ObjectUtils.disposeObject(this._helpText);
            this._helpText = null;
            ObjectUtils.disposeObject(this._scrollView);
            this._scrollView = null;
            if (parent)
            {
                parent.removeChild(this);
            };
        }


    }
}//package militaryrank.view

