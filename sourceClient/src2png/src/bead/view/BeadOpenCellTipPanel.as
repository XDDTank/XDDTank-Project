// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//bead.view.BeadOpenCellTipPanel

package bead.view
{
    import com.pickgliss.ui.controls.alert.BaseAlerFrame;
    import com.pickgliss.ui.image.Scale9CornerImage;
    import ddt.view.bossbox.BoxAwardsCell;
    import com.pickgliss.ui.vo.AlertInfo;
    import ddt.manager.LanguageMgr;
    import com.pickgliss.events.FrameEvent;
    import ddt.manager.SoundManager;
    import com.pickgliss.ui.ComponentFactory;
    import com.pickgliss.ui.ShowTipManager;
    import ddt.utils.PositionUtils;
    import ddt.manager.ItemManager;
    import bagAndInfo.BagAndInfoManager;
    import bagAndInfo.BagAndGiftFrame;
    import flash.events.MouseEvent;
    import com.pickgliss.ui.LayerManager;
    import com.pickgliss.utils.ObjectUtils;

    public class BeadOpenCellTipPanel extends BaseAlerFrame 
    {

        private var _cellBg:Scale9CornerImage;
        private var _cell:BoxAwardsCell;

        public function BeadOpenCellTipPanel()
        {
            info = new AlertInfo();
            info.title = LanguageMgr.GetTranslation("AlertDialog.Info");
            info.showCancel = false;
            info.submitLabel = LanguageMgr.GetTranslation("beadSystem.bead.openBeadCellPanel.btnTxt");
            info.autoDispose = true;
            addEventListener(FrameEvent.RESPONSE, this.__responseHandler);
        }

        private function __responseHandler(_arg_1:FrameEvent):void
        {
            if (((_arg_1.responseCode == FrameEvent.CLOSE_CLICK) || (_arg_1.responseCode == FrameEvent.ESC_CLICK)))
            {
                SoundManager.instance.play("008");
                this.dispose();
            };
        }

        override protected function init():void
        {
            super.init();
            this._cellBg = ComponentFactory.Instance.creatComponentByStylename("trainer.view.GetGoodsTipView.cellBg");
            addToContent(this._cellBg);
            this._cell = new BoxAwardsCell();
            this._cell.count = 0;
            ShowTipManager.Instance.removeTip(this._cell);
            PositionUtils.setPos(this._cell, "trainer.view.GetGoodsTipView.cellBg");
            addToContent(this._cell);
            this._cell.info = ItemManager.Instance.getTemplateById(313407);
            this._cell.itemName = LanguageMgr.GetTranslation("beadSystem.bead.openBeadCellPanel.tip");
        }

        override protected function __onSubmitClick(_arg_1:MouseEvent):void
        {
            SoundManager.instance.play("008");
            BagAndInfoManager.Instance.showBagAndInfo(BagAndGiftFrame.BEADVIEW);
            super.__onSubmitClick(_arg_1);
        }

        public function show():void
        {
            LayerManager.Instance.addToLayer(this, LayerManager.GAME_UI_LAYER, false, 0, false);
        }

        override public function dispose():void
        {
            removeEventListener(FrameEvent.RESPONSE, this.__responseHandler);
            super.dispose();
            ObjectUtils.disposeObject(this._cellBg);
            this._cellBg = null;
            ObjectUtils.disposeObject(this._cell);
            this._cell = null;
        }


    }
}//package bead.view

