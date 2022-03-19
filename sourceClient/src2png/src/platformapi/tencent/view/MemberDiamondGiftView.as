// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//platformapi.tencent.view.MemberDiamondGiftView

package platformapi.tencent.view
{
    import flash.display.Sprite;
    import com.pickgliss.ui.core.Disposeable;
    import flash.display.Bitmap;
    import platformapi.tencent.DiamondManager;
    import com.pickgliss.ui.ComponentFactory;
    import platformapi.tencent.DiamondType;
    import ddt.utils.PositionUtils;
    import com.pickgliss.ui.LayerManager;
    import com.pickgliss.utils.ObjectUtils;

    public class MemberDiamondGiftView extends Sprite implements Disposeable 
    {

        private var _viewTitle:Bitmap;
        private var _leftView:MemberDiamondGiftLeftView;
        private var _rightView:MemberDiamondGiftRightView;

        public function MemberDiamondGiftView()
        {
            this.init();
        }

        private function init():void
        {
            switch (DiamondManager.instance.model.pfdata.pfType)
            {
                case DiamondType.YELLOW_DIAMOND:
                    this._viewTitle = ComponentFactory.Instance.creatBitmap("asset.MemberDiamondGift.LeftTitle");
                    break;
                case DiamondType.BLUE_DIAMOND:
                    this._viewTitle = ComponentFactory.Instance.creatBitmap("asset.MemberDiamondGift.BlueLeftTitle");
                    break;
                case DiamondType.MEMBER_DIAMOND:
                    this._viewTitle = ComponentFactory.Instance.creatBitmap("asset.MemberDiamondGift.LeftTitle");
                    break;
            };
            addChild(this._viewTitle);
            this._leftView = new MemberDiamondGiftLeftView();
            PositionUtils.setPos(this._leftView, "memberDiamondGift.view.leftViewPos");
            addChild(this._leftView);
            this._rightView = new MemberDiamondGiftRightView();
            PositionUtils.setPos(this._rightView, "memberDiamondGift.view.RightViewPos");
            addChild(this._rightView);
        }

        public function show():void
        {
            LayerManager.Instance.addToLayer(this, LayerManager.GAME_DYNAMIC_LAYER, true, LayerManager.ALPHA_BLOCKGOUND);
        }

        public function dispose():void
        {
            ObjectUtils.disposeObject(this._leftView);
            this._leftView = null;
            ObjectUtils.disposeObject(this._rightView);
            this._rightView = null;
            ObjectUtils.disposeObject(this._viewTitle);
            this._viewTitle = null;
            if (parent)
            {
                parent.removeChild(this);
            };
        }


    }
}//package platformapi.tencent.view

