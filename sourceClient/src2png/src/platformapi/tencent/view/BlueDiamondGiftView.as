// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//platformapi.tencent.view.BlueDiamondGiftView

package platformapi.tencent.view
{
    import com.pickgliss.ui.controls.alert.BaseAlerFrame;
    import flash.display.Bitmap;
    import com.pickgliss.ui.vo.AlertInfo;
    import platformapi.tencent.DiamondManager;
    import platformapi.tencent.DiamondType;
    import com.pickgliss.ui.ComponentFactory;
    import ddt.utils.PositionUtils;
    import com.pickgliss.events.FrameEvent;
    import ddt.manager.SoundManager;
    import com.pickgliss.ui.LayerManager;
    import com.pickgliss.utils.ObjectUtils;

    public class BlueDiamondGiftView extends BaseAlerFrame 
    {

        private var _viewTitle:Bitmap;
        private var _leftView:MemberDiamondGiftLeftView;
        private var _rightView:MemberDiamondGiftRightView;


        override protected function init():void
        {
            super.init();
            var _local_1:AlertInfo = new AlertInfo("", "", "", false, false);
            if (DiamondManager.instance.pfType == DiamondType.BLUE_DIAMOND)
            {
                this._viewTitle = ComponentFactory.Instance.creatBitmap("asset.MemberDiamondGift.BlueLeftTitle");
            }
            else
            {
                this._viewTitle = ComponentFactory.Instance.creatBitmap("asset.MemberDiamondGift.memberQPlusLeftTitle");
            };
            info = _local_1;
            addToContent(this._viewTitle);
            this._leftView = new MemberDiamondGiftLeftView();
            PositionUtils.setPos(this._leftView, "memberDiamondGift.view.leftViewPos");
            addToContent(this._leftView);
            this._rightView = new MemberDiamondGiftRightView();
            PositionUtils.setPos(this._rightView, "memberDiamondGift.view.RightViewPos");
            addToContent(this._rightView);
            addEventListener(FrameEvent.RESPONSE, this.__onFrameEvent);
        }

        protected function __onFrameEvent(_arg_1:FrameEvent):void
        {
            SoundManager.instance.play("008");
            this.dispose();
            switch (_arg_1.responseCode)
            {
                case FrameEvent.CANCEL_CLICK:
                case FrameEvent.CLOSE_CLICK:
                case FrameEvent.ESC_CLICK:
                    return;
                case FrameEvent.SUBMIT_CLICK:
                    return;
            };
        }

        public function show():void
        {
            LayerManager.Instance.addToLayer(this, LayerManager.GAME_DYNAMIC_LAYER, true, LayerManager.ALPHA_BLOCKGOUND);
        }

        override public function dispose():void
        {
            removeEventListener(FrameEvent.RESPONSE, this.__onFrameEvent);
            ObjectUtils.disposeObject(this._leftView);
            this._leftView = null;
            ObjectUtils.disposeObject(this._rightView);
            this._rightView = null;
            ObjectUtils.disposeObject(this._viewTitle);
            this._viewTitle = null;
            super.dispose();
        }


    }
}//package platformapi.tencent.view

