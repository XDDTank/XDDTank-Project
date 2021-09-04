package shop.view
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.ui.vo.AlertInfo;
   import ddt.manager.LanguageMgr;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   
   public class ShopRechargeEquipServer extends Sprite implements Disposeable
   {
       
      
      private var _girl:Bitmap;
      
      private var _description:FilterFrameText;
      
      private var _frame:BaseAlerFrame;
      
      public function ShopRechargeEquipServer()
      {
         super();
         this._girl = ComponentFactory.Instance.creatBitmap("asset.trainer.welcome.girl2");
         this._girl.scaleX = this._girl.scaleY = 0.6;
         PositionUtils.setPos(this._girl,"ddtcore.shop.rechargeViewAlert.girlPos");
         this._description = ComponentFactory.Instance.creatComponentByStylename("ddtcore.xufei.text");
         this._description.text = LanguageMgr.GetTranslation("ddt.shop.rechargeEquipAlert.xufei");
         this._frame = ComponentFactory.Instance.creatComponentByStylename("core.ddtshop.RechargeViewServer");
         var _loc1_:AlertInfo = new AlertInfo(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("ok"));
         _loc1_.showCancel = false;
         this._frame.info = _loc1_;
         this._frame.moveEnable = false;
         this._frame.addToContent(this._girl);
         this._frame.addToContent(this._description);
         this._frame.addEventListener(FrameEvent.RESPONSE,this.__frameEventHandler);
      }
      
      private function __frameEventHandler(param1:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         switch(param1.responseCode)
         {
            case FrameEvent.SUBMIT_CLICK:
            case FrameEvent.CLOSE_CLICK:
            case FrameEvent.CANCEL_CLICK:
            case FrameEvent.ESC_CLICK:
               this.dispose();
         }
      }
      
      public function show() : void
      {
         LayerManager.Instance.addToLayer(this._frame,LayerManager.GAME_TOP_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
      }
      
      public function dispose() : void
      {
         this._frame.dispose();
         this._girl = null;
         this._description = null;
         this._frame = null;
         if(parent)
         {
            parent.removeChild(this);
         }
      }
   }
}
