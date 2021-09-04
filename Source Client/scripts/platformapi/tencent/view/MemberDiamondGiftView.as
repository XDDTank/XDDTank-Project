package platformapi.tencent.view
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.utils.PositionUtils;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import platformapi.tencent.DiamondManager;
   import platformapi.tencent.DiamondType;
   
   public class MemberDiamondGiftView extends Sprite implements Disposeable
   {
       
      
      private var _viewTitle:Bitmap;
      
      private var _leftView:MemberDiamondGiftLeftView;
      
      private var _rightView:MemberDiamondGiftRightView;
      
      public function MemberDiamondGiftView()
      {
         super();
         this.init();
      }
      
      private function init() : void
      {
         switch(DiamondManager.instance.model.pfdata.pfType)
         {
            case DiamondType.YELLOW_DIAMOND:
               this._viewTitle = ComponentFactory.Instance.creatBitmap("asset.MemberDiamondGift.LeftTitle");
               break;
            case DiamondType.BLUE_DIAMOND:
               this._viewTitle = ComponentFactory.Instance.creatBitmap("asset.MemberDiamondGift.BlueLeftTitle");
               break;
            case DiamondType.MEMBER_DIAMOND:
               this._viewTitle = ComponentFactory.Instance.creatBitmap("asset.MemberDiamondGift.LeftTitle");
         }
         addChild(this._viewTitle);
         this._leftView = new MemberDiamondGiftLeftView();
         PositionUtils.setPos(this._leftView,"memberDiamondGift.view.leftViewPos");
         addChild(this._leftView);
         this._rightView = new MemberDiamondGiftRightView();
         PositionUtils.setPos(this._rightView,"memberDiamondGift.view.RightViewPos");
         addChild(this._rightView);
      }
      
      public function show() : void
      {
         LayerManager.Instance.addToLayer(this,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.ALPHA_BLOCKGOUND);
      }
      
      public function dispose() : void
      {
         ObjectUtils.disposeObject(this._leftView);
         this._leftView = null;
         ObjectUtils.disposeObject(this._rightView);
         this._rightView = null;
         ObjectUtils.disposeObject(this._viewTitle);
         this._viewTitle = null;
         if(parent)
         {
            parent.removeChild(this);
         }
      }
   }
}
