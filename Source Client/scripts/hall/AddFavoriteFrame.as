package hall
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.ui.controls.TextButton;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import ddt.manager.PageInterfaceManager;
   import ddt.manager.SharedManager;
   import ddt.manager.SoundManager;
   import flash.display.Bitmap;
   import flash.events.MouseEvent;
   
   public class AddFavoriteFrame extends Frame
   {
       
      
      private var _okBtn:TextButton;
      
      private var _txtBmp:Bitmap;
      
      private var _catoonBmp:Bitmap;
      
      public function AddFavoriteFrame()
      {
         super();
         this.initView();
         this.initEvents();
      }
      
      private function initView() : void
      {
         this._okBtn = ComponentFactory.Instance.creatComponentByStylename("saveFile.okBtn");
         this._okBtn.text = LanguageMgr.GetTranslation("consortion.takeIn.agreeBtn.text");
         this._okBtn.x = 185;
         this._okBtn.y = 165;
         addToContent(this._okBtn);
         this._txtBmp = ComponentFactory.Instance.creatBitmap("asset.addfavorite.txtbmp");
         this._catoonBmp = ComponentFactory.Instance.creatBitmap("asset.addfavorite.catoonbmp");
         addToContent(this._txtBmp);
         addToContent(this._catoonBmp);
      }
      
      private function initEvents() : void
      {
         addEventListener(FrameEvent.RESPONSE,this._response);
         this._okBtn.addEventListener(MouseEvent.CLICK,this._okClick);
      }
      
      private function removeEvents() : void
      {
         removeEventListener(FrameEvent.RESPONSE,this._response);
         this._okBtn.removeEventListener(MouseEvent.CLICK,this._okClick);
      }
      
      private function _response(param1:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         if(param1.responseCode == FrameEvent.CLOSE_CLICK || param1.responseCode == FrameEvent.ESC_CLICK)
         {
            SharedManager.Instance.isAddedToFavorite = true;
            SharedManager.Instance.save();
            this.dispose();
         }
      }
      
      private function _okClick(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         this.dispose();
         SharedManager.Instance.isAddedToFavorite = true;
         SharedManager.Instance.save();
         PageInterfaceManager.askForFavorite();
      }
      
      public function show() : void
      {
         LayerManager.Instance.addToLayer(this,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
      }
      
      override public function dispose() : void
      {
         this.removeEvents();
         if(this._okBtn)
         {
            ObjectUtils.disposeObject(this._okBtn);
         }
         this._okBtn = null;
         if(this._txtBmp)
         {
            ObjectUtils.disposeObject(this._txtBmp);
            this._txtBmp = null;
         }
         if(this._catoonBmp)
         {
            ObjectUtils.disposeObject(this._catoonBmp);
            this._catoonBmp = null;
         }
         if(parent)
         {
            parent.removeChild(this);
         }
      }
   }
}
