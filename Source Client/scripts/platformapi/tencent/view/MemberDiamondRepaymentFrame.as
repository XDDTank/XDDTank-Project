package platformapi.tencent.view
{
   import bagAndInfo.cell.BagCell;
   import bagAndInfo.cell.CellFactory;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.SimpleBitmapButton;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.MovieImage;
   import com.pickgliss.ui.image.Scale9CornerImage;
   import com.pickgliss.ui.image.ScaleBitmapImage;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.ItemManager;
   import ddt.manager.SoundManager;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import platformapi.tencent.TencentExternalInterfaceManager;
   
   public class MemberDiamondRepaymentFrame extends Sprite implements Disposeable
   {
       
      
      private var _repaymentTitle:Bitmap;
      
      private var _textMC:MovieImage;
      
      private var _boxIcon:Bitmap;
      
      private var _moneyIcon:Bitmap;
      
      private var _bg:Scale9CornerImage;
      
      private var _bgI:Scale9CornerImage;
      
      private var _bgII:Scale9CornerImage;
      
      private var _moreBtn:SimpleBitmapButton;
      
      private var _getBtn:SimpleBitmapButton;
      
      private var _openBtn:SimpleBitmapButton;
      
      private var _payBtn:SimpleBitmapButton;
      
      private var _cell:BagCell;
      
      private var _btnBg:ScaleBitmapImage;
      
      public function MemberDiamondRepaymentFrame()
      {
         super();
         this.init();
         this.initEvent();
      }
      
      private function init() : void
      {
         var _loc1_:Point = null;
         this._bg = ComponentFactory.Instance.creatComponentByStylename("memberDiamondGift.view.MemberDiamondRepaymentFrame.bg");
         addChild(this._bg);
         this._bgI = ComponentFactory.Instance.creatComponentByStylename("memberDiamondGift.view.MemberDiamondRepaymentFrame.bgI");
         addChild(this._bgI);
         this._bgII = ComponentFactory.Instance.creatComponentByStylename("memberDiamondGift.view.MemberDiamondRepaymentFrame.bgII");
         addChild(this._bgII);
         this._repaymentTitle = ComponentFactory.Instance.creat("asset.MemberDiamondGift.DiamondRepayment.title");
         addChild(this._repaymentTitle);
         this._textMC = ComponentFactory.Instance.creat("memberDiamondGift.view.MemberDiamondRepaymentFrame.textmc");
         addChild(this._textMC);
         this._moneyIcon = ComponentFactory.Instance.creat("asset.MemberDiamondGift.DiamondRepayment.600RMB");
         addChild(this._moneyIcon);
         this._btnBg = ComponentFactory.Instance.creatComponentByStylename("memberDiamondFrame.repaymentView.btnBg");
         addChild(this._btnBg);
         this._openBtn = ComponentFactory.Instance.creat("memberDiamondGift.view.MemberDiamondRepaymentFrame.openBtn");
         addChild(this._openBtn);
         this._payBtn = ComponentFactory.Instance.creat("memberDiamondGift.view.MemberDiamondRepaymentFrame.payBtn");
         addChild(this._payBtn);
         this._cell = CellFactory.instance.createPersonalInfoCell(-1,ItemManager.Instance.getTemplateById(16130),true) as BagCell;
         _loc1_ = ComponentFactory.Instance.creatCustomObject("memberDiamondGift.view.MemberDiamondRepaymentFrame.cellPos");
         this._cell.x = _loc1_.x;
         this._cell.y = _loc1_.y;
         this._cell.setContentSize(110,110);
         addChild(this._cell);
      }
      
      private function initEvent() : void
      {
         this._openBtn.addEventListener(MouseEvent.CLICK,this.__onClick);
         this._payBtn.addEventListener(MouseEvent.CLICK,this.__onClick);
      }
      
      private function removeEvent() : void
      {
         this._openBtn.removeEventListener(MouseEvent.CLICK,this.__onClick);
         this._payBtn.removeEventListener(MouseEvent.CLICK,this.__onClick);
      }
      
      protected function __onClick(param1:MouseEvent) : void
      {
         SoundManager.instance.playButtonSound();
         switch(param1.currentTarget)
         {
            case this._openBtn:
            case this._payBtn:
               TencentExternalInterfaceManager.openDiamond();
         }
      }
      
      public function show() : void
      {
         LayerManager.Instance.addToLayer(this,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.ALPHA_BLOCKGOUND);
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         ObjectUtils.disposeObject(this._repaymentTitle);
         this._repaymentTitle = null;
         ObjectUtils.disposeObject(this._textMC);
         this._textMC = null;
         ObjectUtils.disposeObject(this._bg);
         this._bg = null;
         ObjectUtils.disposeObject(this._bgI);
         this._bgI = null;
         ObjectUtils.disposeObject(this._bgII);
         this._bgII = null;
         ObjectUtils.disposeObject(this._btnBg);
         this._btnBg = null;
         ObjectUtils.disposeObject(this._openBtn);
         this._openBtn = null;
         ObjectUtils.disposeObject(this._payBtn);
         this._payBtn = null;
         if(parent)
         {
            parent.removeChild(this);
         }
      }
   }
}
