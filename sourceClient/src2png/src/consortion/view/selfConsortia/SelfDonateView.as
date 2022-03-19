// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//consortion.view.selfConsortia.SelfDonateView

package consortion.view.selfConsortia
{
    import com.pickgliss.ui.core.Component;
    import com.pickgliss.ui.core.Disposeable;
    import flash.display.Bitmap;
    import com.pickgliss.ui.controls.BaseButton;
    import com.pickgliss.ui.text.FilterFrameText;
    import com.pickgliss.ui.controls.TextButton;
    import com.pickgliss.ui.ComponentFactory;
    import ddt.manager.PlayerManager;
    import ddt.manager.LanguageMgr;
    import ddt.utils.PositionUtils;
    import ddt.manager.ConsortiaDutyManager;
    import ddt.data.ConsortiaDutyType;
    import flash.events.MouseEvent;
    import ddt.events.PlayerPropertyEvent;
    import consortion.ConsortionModelControl;
    import consortion.event.ConsortionEvent;
    import ddt.manager.SoundManager;
    import com.pickgliss.utils.ObjectUtils;

    public class SelfDonateView extends Component implements Disposeable 
    {

        private var _donateAsset:Bitmap;
        private var _donateBtn:BaseButton;
        private var _mydonateTxt:FilterFrameText;
        private var _extBtn:TextButton;

        public function SelfDonateView()
        {
            this.initView();
            this.initEvent();
        }

        private function initView():void
        {
            this._donateAsset = ComponentFactory.Instance.creatBitmap("asset.consortion.Mydonate");
            this._donateBtn = ComponentFactory.Instance.creatComponentByStylename("ddtconsortion.donateBtn");
            this._mydonateTxt = ComponentFactory.Instance.creatComponentByStylename("ddtconsortion.donateText");
            this._mydonateTxt.text = String(PlayerManager.Instance.Self.RichesOffer);
            this._extBtn = ComponentFactory.Instance.creatComponentByStylename("buildingManager.exit");
            this._extBtn.text = LanguageMgr.GetTranslation("consortia.BuildingManager.BtnText4");
            PositionUtils.setPos(this._extBtn, "asset.extBtn.pos");
            addChild(this._donateAsset);
            addChild(this._donateBtn);
            addChild(this._mydonateTxt);
            addChild(this._extBtn);
            this.initRight();
        }

        private function initRight():void
        {
            var _local_1:int = PlayerManager.Instance.Self.Right;
            this._extBtn.visible = (!(ConsortiaDutyManager.GetRight(_local_1, ConsortiaDutyType._13_Exit)));
        }

        private function initEvent():void
        {
            this._donateBtn.addEventListener(MouseEvent.CLICK, this.__mouseClickHandler);
            this._extBtn.addEventListener(MouseEvent.CLICK, this.__ext);
            PlayerManager.Instance.Self.addEventListener(PlayerPropertyEvent.PROPERTY_CHANGE, this.__offerChangeHandler);
            ConsortionModelControl.Instance.addEventListener(ConsortionEvent.CHARMAN_CHANGE, this.__charmanChange);
        }

        private function __charmanChange(_arg_1:ConsortionEvent):void
        {
            this.initRight();
        }

        private function removeEvent():void
        {
            this._donateBtn.removeEventListener(MouseEvent.CLICK, this.__mouseClickHandler);
            this._extBtn.removeEventListener(MouseEvent.CLICK, this.__ext);
            PlayerManager.Instance.Self.removeEventListener(PlayerPropertyEvent.PROPERTY_CHANGE, this.__offerChangeHandler);
            ConsortionModelControl.Instance.removeEventListener(ConsortionEvent.CHARMAN_CHANGE, this.__charmanChange);
        }

        private function __offerChangeHandler(_arg_1:PlayerPropertyEvent):void
        {
            if (((_arg_1.changedProperties["RichesRob"]) || (_arg_1.changedProperties["RichesOffer"])))
            {
                this._mydonateTxt.text = String(PlayerManager.Instance.Self.RichesOffer);
            };
        }

        private function __mouseClickHandler(_arg_1:MouseEvent):void
        {
            SoundManager.instance.play("008");
            ConsortionModelControl.Instance.alertTaxFrame();
        }

        private function __ext(_arg_1:MouseEvent):void
        {
            ConsortionModelControl.Instance.alertQuitFrame();
        }

        override public function dispose():void
        {
            this.removeEvent();
            if (this._donateAsset)
            {
                ObjectUtils.disposeObject(this._donateAsset);
            };
            this._donateAsset = null;
            if (this._donateBtn)
            {
                ObjectUtils.disposeObject(this._donateBtn);
            };
            this._donateBtn = null;
            if (this._mydonateTxt)
            {
                ObjectUtils.disposeObject(this._mydonateTxt);
            };
            this._mydonateTxt = null;
            if (this._extBtn)
            {
                ObjectUtils.disposeObject(this._extBtn);
            };
            this._extBtn = null;
            if (this.parent)
            {
                this.parent.removeChild(this);
            };
        }


    }
}//package consortion.view.selfConsortia

