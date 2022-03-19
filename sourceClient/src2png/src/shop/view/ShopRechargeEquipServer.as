// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//shop.view.ShopRechargeEquipServer

package shop.view
{
    import flash.display.Sprite;
    import com.pickgliss.ui.core.Disposeable;
    import flash.display.Bitmap;
    import com.pickgliss.ui.text.FilterFrameText;
    import com.pickgliss.ui.controls.alert.BaseAlerFrame;
    import com.pickgliss.ui.ComponentFactory;
    import ddt.utils.PositionUtils;
    import ddt.manager.LanguageMgr;
    import com.pickgliss.ui.vo.AlertInfo;
    import com.pickgliss.events.FrameEvent;
    import ddt.manager.SoundManager;
    import com.pickgliss.ui.LayerManager;

    public class ShopRechargeEquipServer extends Sprite implements Disposeable 
    {

        private var _girl:Bitmap;
        private var _description:FilterFrameText;
        private var _frame:BaseAlerFrame;

        public function ShopRechargeEquipServer()
        {
            this._girl = ComponentFactory.Instance.creatBitmap("asset.trainer.welcome.girl2");
            this._girl.scaleX = (this._girl.scaleY = 0.6);
            PositionUtils.setPos(this._girl, "ddtcore.shop.rechargeViewAlert.girlPos");
            this._description = ComponentFactory.Instance.creatComponentByStylename("ddtcore.xufei.text");
            this._description.text = LanguageMgr.GetTranslation("ddt.shop.rechargeEquipAlert.xufei");
            this._frame = ComponentFactory.Instance.creatComponentByStylename("core.ddtshop.RechargeViewServer");
            var _local_1:AlertInfo = new AlertInfo(LanguageMgr.GetTranslation("AlertDialog.Info"), LanguageMgr.GetTranslation("ok"));
            _local_1.showCancel = false;
            this._frame.info = _local_1;
            this._frame.moveEnable = false;
            this._frame.addToContent(this._girl);
            this._frame.addToContent(this._description);
            this._frame.addEventListener(FrameEvent.RESPONSE, this.__frameEventHandler);
        }

        private function __frameEventHandler(_arg_1:FrameEvent):void
        {
            SoundManager.instance.play("008");
            switch (_arg_1.responseCode)
            {
                case FrameEvent.SUBMIT_CLICK:
                case FrameEvent.CLOSE_CLICK:
                case FrameEvent.CANCEL_CLICK:
                case FrameEvent.ESC_CLICK:
                    this.dispose();
                    return;
            };
        }

        public function show():void
        {
            LayerManager.Instance.addToLayer(this._frame, LayerManager.GAME_TOP_LAYER, true, LayerManager.BLCAK_BLOCKGOUND);
        }

        public function dispose():void
        {
            this._frame.dispose();
            this._girl = null;
            this._description = null;
            this._frame = null;
            if (parent)
            {
                parent.removeChild(this);
            };
        }


    }
}//package shop.view

