// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//consortion.view.selfConsortia.ConsortionSkillItenBtn

package consortion.view.selfConsortia
{
    import flash.display.Sprite;
    import com.pickgliss.ui.core.Disposeable;
    import flash.display.Bitmap;
    import com.pickgliss.ui.text.FilterFrameText;
    import com.pickgliss.ui.ComponentFactory;
    import com.pickgliss.utils.ObjectUtils;

    public class ConsortionSkillItenBtn extends Sprite implements Disposeable 
    {

        private var _bg:Bitmap;
        private var _day:FilterFrameText;
        private var _pay:FilterFrameText;

        public function ConsortionSkillItenBtn()
        {
            this.initView();
        }

        private function initView():void
        {
            buttonMode = true;
            this._bg = ComponentFactory.Instance.creatBitmap("asset.consortion.shopItem.btn");
            this._day = ComponentFactory.Instance.creatComponentByStylename("consortion.SkillItemBtn.day");
            this._pay = ComponentFactory.Instance.creatComponentByStylename("consortion.SkillItemBtn.Pay");
            addChild(this._bg);
            addChild(this._day);
            addChild(this._pay);
        }

        public function setValue(_arg_1:String, _arg_2:String):void
        {
            this._day.text = _arg_1;
            this._pay.text = _arg_2;
        }

        public function dispose():void
        {
            ObjectUtils.disposeAllChildren(this);
            this._bg = null;
            this._day = null;
            this._pay = null;
            if (this.parent)
            {
                this.parent.removeChild(this);
            };
        }


    }
}//package consortion.view.selfConsortia

