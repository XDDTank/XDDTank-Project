// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//consortion.view.CountDesTip

package consortion.view
{
    import com.pickgliss.ui.tip.BaseTip;
    import com.pickgliss.ui.text.FilterFrameText;
    import com.pickgliss.ui.image.ScaleBitmapImage;
    import ddt.data.ConsortiaInfo;
    import com.pickgliss.ui.ComponentFactory;
    import ddt.manager.LanguageMgr;
    import consortion.ConsortionModelControl;
    import com.pickgliss.utils.ObjectUtils;

    public class CountDesTip extends BaseTip 
    {

        private var _des:FilterFrameText;
        private var _desI:FilterFrameText;
        private var _bg:ScaleBitmapImage;
        private var _rule:ScaleBitmapImage;
        private var _info:ConsortiaInfo;


        override protected function init():void
        {
            this._bg = ComponentFactory.Instance.creatComponentByStylename("core.commonTipBg");
            this._rule = ComponentFactory.Instance.creatComponentByStylename("HRuleAsset");
            this._des = ComponentFactory.Instance.creatComponentByStylename("core.commonTipText");
            this._desI = ComponentFactory.Instance.creatComponentByStylename("core.commonTipText");
            super.init();
            this.tipbackgound = this._bg;
        }

        override protected function addChildren():void
        {
            super.addChildren();
            addChild(this._rule);
            addChild(this._des);
            addChild(this._desI);
            mouseChildren = false;
            mouseEnabled = false;
        }

        override public function get tipData():Object
        {
            return (_tipData);
        }

        override public function set tipData(_arg_1:Object):void
        {
            this._info = (_arg_1 as ConsortiaInfo);
            if (this._info)
            {
                this._des.text = LanguageMgr.GetTranslation("ddt.consortionSelfHallLeftView.countTip", String(this._info.Count), String(ConsortionModelControl.Instance.model.getLevelData(this._info.Level).Count));
                this._des.x = 8;
                this._des.y = 5;
                this._rule.x = this._des.x;
                this._rule.y = ((this._des.y + this._des.textHeight) + 4);
                this._desI.text = LanguageMgr.GetTranslation("ddt.consortionSelfHallLeftView.countTipI", String(ConsortionModelControl.Instance.model.getLevelData(((this._info.Level == 10) ? this._info.Level : (this._info.Level + 1))).Count));
                this._desI.x = this._rule.x;
                this._desI.y = ((this._rule.y + this._rule.height) + 4);
                this.drawBG();
            };
        }

        private function reset():void
        {
            this._bg.height = 0;
            this._bg.width = 0;
        }

        private function drawBG():void
        {
            this.reset();
            this._bg.width = (this._des.textWidth + 26);
            this._bg.height = (this._desI.y + 26);
            _width = this._bg.width;
            _height = this._bg.height;
        }

        override public function dispose():void
        {
            super.dispose();
            if (this._des)
            {
                ObjectUtils.disposeObject(this._des);
            };
            this._des = null;
            if (this._desI)
            {
                ObjectUtils.disposeObject(this._desI);
            };
            this._desI = null;
            if (this._rule)
            {
                ObjectUtils.disposeObject(this._rule);
            };
            this._rule = null;
            if (this.parent)
            {
                this.parent.removeChild(this);
            };
        }


    }
}//package consortion.view

