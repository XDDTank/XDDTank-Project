package ddt.view.common.church
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.ui.vo.AlertInfo;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import ddt.manager.SoundManager;
   import flash.display.Bitmap;
   import flash.events.Event;
   import flash.geom.Rectangle;
   
   public class ChurchDialogueRejectPropose extends BaseAlerFrame
   {
       
      
      private var _contentTxt:FilterFrameText;
      
      private var _cell:Bitmap;
      
      private var _alertInfo:AlertInfo;
      
      private var _name_txt:FilterFrameText;
      
      private var _cellPoint:Rectangle;
      
      private var _msgInfo:String;
      
      public function ChurchDialogueRejectPropose()
      {
         super();
         this.initialize();
      }
      
      public function get msgInfo() : String
      {
         return this._msgInfo;
      }
      
      public function set msgInfo(param1:String) : void
      {
         this._msgInfo = param1;
         this._name_txt.text = this._msgInfo;
      }
      
      private function initialize() : void
      {
         cancelButtonStyle = "core.simplebt";
         submitButtonStyle = "core.simplebt";
         this._alertInfo = new AlertInfo();
         this._alertInfo.title = "提示";
         this._alertInfo.showCancel = false;
         this._alertInfo.moveEnable = false;
         info = this._alertInfo;
         this.escEnable = true;
         this._contentTxt = ComponentFactory.Instance.creat("common.church.ChurchDialogueRejectPropose.contentText");
         this._contentTxt.text = LanguageMgr.GetTranslation("common.church.ChurchDialogueRejectPropose.contentText.text");
         addToContent(this._contentTxt);
         this._name_txt = ComponentFactory.Instance.creat("common.church.churchDialogueRejectProposeUserNameAsset");
         addToContent(this._name_txt);
         this._cellPoint = ComponentFactory.Instance.creat("common.church.churchDialogueRejectProposeUserNamePoint");
         this._cell = ComponentFactory.Instance.creatBitmap("asset.church.goodBoycell");
         this._cell.x = this._cellPoint.x;
         this._cell.y = this._cellPoint.y;
         addToContent(this._cell);
         addEventListener(FrameEvent.RESPONSE,this.onFrameResponse);
      }
      
      private function onFrameResponse(param1:FrameEvent) : void
      {
         switch(param1.responseCode)
         {
            case FrameEvent.CANCEL_CLICK:
            case FrameEvent.CLOSE_CLICK:
            case FrameEvent.ESC_CLICK:
            case FrameEvent.ENTER_CLICK:
            case FrameEvent.SUBMIT_CLICK:
               SoundManager.instance.play("008");
               this.confirmSubmit();
         }
      }
      
      private function confirmSubmit() : void
      {
         SoundManager.instance.play("008");
         this.dispose();
      }
      
      public function show() : void
      {
         SoundManager.instance.play("018");
         LayerManager.Instance.addToLayer(this,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
      }
      
      override public function dispose() : void
      {
         super.dispose();
         removeEventListener(FrameEvent.RESPONSE,this.onFrameResponse);
         this._alertInfo = null;
         this._cellPoint = null;
         this._cell = null;
         if(this._contentTxt)
         {
            ObjectUtils.disposeObject(this._contentTxt);
         }
         this._contentTxt = null;
         ObjectUtils.disposeObject(this._name_txt);
         this._name_txt = null;
         if(parent)
         {
            parent.removeChild(this);
         }
         dispatchEvent(new Event(Event.CLOSE));
      }
   }
}
