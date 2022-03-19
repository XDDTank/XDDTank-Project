// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//store.view.strength.MySmithLevel

package store.view.strength
{
    import com.pickgliss.ui.core.Component;
    import com.pickgliss.ui.image.Image;
    import com.pickgliss.ui.text.FilterFrameText;
    import com.pickgliss.ui.ComponentFactory;
    import store.view.ConsortiaRateManager;
    import ddt.manager.LanguageMgr;
    import ddt.manager.PlayerManager;
    import flash.events.Event;
    import com.pickgliss.utils.ObjectUtils;

    public class MySmithLevel extends Component 
    {

        private var _bg:Image;
        private var _smithTxt:FilterFrameText;

        public function MySmithLevel()
        {
            this.initView();
            this.initEvents();
        }

        private function initView():void
        {
            this._bg = ComponentFactory.Instance.creatComponentByStylename("ddtstore.StoreIIStrengthBG.MySmithLevelBg");
            addChild(this._bg);
            this._smithTxt = ComponentFactory.Instance.creatComponentByStylename("ddtstore.StoreIIStrengthBG.MySmithLevelBgText");
            addChild(this._smithTxt);
            this._smithTxt.text = ("LV." + ConsortiaRateManager.instance.smithLevel);
            tipData = LanguageMgr.GetTranslation("store.StoreIIComposeBG.consortiaSimthLevel");
            if (PlayerManager.Instance.Self.ConsortiaID == 0)
            {
                visible = false;
            };
        }

        private function initEvents():void
        {
            ConsortiaRateManager.instance.addEventListener(ConsortiaRateManager.CHANGE_CONSORTIA, this._change);
        }

        private function removeEvents():void
        {
            ConsortiaRateManager.instance.removeEventListener(ConsortiaRateManager.CHANGE_CONSORTIA, this._change);
        }

        private function _change(_arg_1:Event):void
        {
            this._smithTxt.text = ("LV." + ConsortiaRateManager.instance.smithLevel);
            visible = ((PlayerManager.Instance.Self.ConsortiaID == 0) ? false : true);
        }

        override public function dispose():void
        {
            super.dispose();
            this.removeEvents();
            if (this._bg)
            {
                ObjectUtils.disposeObject(this._bg);
            };
            this._bg = null;
            if (this._smithTxt)
            {
                ObjectUtils.disposeObject(this._smithTxt);
            };
            this._smithTxt = null;
            if (parent)
            {
                parent.removeChild(this);
            };
        }


    }
}//package store.view.strength

