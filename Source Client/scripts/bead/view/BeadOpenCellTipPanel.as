package bead.view
{
   import bagAndInfo.BagAndGiftFrame;
   import bagAndInfo.BagAndInfoManager;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.ShowTipManager;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.image.Scale9CornerImage;
   import com.pickgliss.ui.vo.AlertInfo;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.ItemManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import ddt.view.bossbox.BoxAwardsCell;
   import flash.events.MouseEvent;
   
   public class BeadOpenCellTipPanel extends BaseAlerFrame
   {
       
      
      private var _cellBg:Scale9CornerImage;
      
      private var _cell:BoxAwardsCell;
      
      public function BeadOpenCellTipPanel()
      {
         super();
         info = new AlertInfo();
         info.title = LanguageMgr.GetTranslation("AlertDialog.Info");
         info.showCancel = false;
         info.submitLabel = LanguageMgr.GetTranslation("beadSystem.bead.openBeadCellPanel.btnTxt");
         info.autoDispose = true;
         addEventListener(FrameEvent.RESPONSE,this.__responseHandler);
      }
      
      private function __responseHandler(param1:FrameEvent) : void
      {
         if(param1.responseCode == FrameEvent.CLOSE_CLICK || param1.responseCode == FrameEvent.ESC_CLICK)
         {
            SoundManager.instance.play("008");
            this.dispose();
         }
      }
      
      override protected function init() : void
      {
         super.init();
         this._cellBg = ComponentFactory.Instance.creatComponentByStylename("trainer.view.GetGoodsTipView.cellBg");
         addToContent(this._cellBg);
         this._cell = new BoxAwardsCell();
         this._cell.count = 0;
         ShowTipManager.Instance.removeTip(this._cell);
         PositionUtils.setPos(this._cell,"trainer.view.GetGoodsTipView.cellBg");
         addToContent(this._cell);
         this._cell.info = ItemManager.Instance.getTemplateById(313407);
         this._cell.itemName = LanguageMgr.GetTranslation("beadSystem.bead.openBeadCellPanel.tip");
      }
      
      override protected function __onSubmitClick(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         BagAndInfoManager.Instance.showBagAndInfo(BagAndGiftFrame.BEADVIEW);
         super.__onSubmitClick(param1);
      }
      
      public function show() : void
      {
         LayerManager.Instance.addToLayer(this,LayerManager.GAME_UI_LAYER,false,0,false);
      }
      
      override public function dispose() : void
      {
         removeEventListener(FrameEvent.RESPONSE,this.__responseHandler);
         super.dispose();
         ObjectUtils.disposeObject(this._cellBg);
         this._cellBg = null;
         ObjectUtils.disposeObject(this._cell);
         this._cell = null;
      }
   }
}
