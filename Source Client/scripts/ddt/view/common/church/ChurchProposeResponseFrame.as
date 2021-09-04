package ddt.view.common.church
{
   import bagAndInfo.info.PlayerInfoViewControl;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.TextButton;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.image.MutipleImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.ui.text.TextArea;
   import com.pickgliss.ui.vo.AlertInfo;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.ChatManager;
   import ddt.manager.ChurchManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.view.MainToolBar;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.text.TextField;
   import road7th.utils.StringHelper;
   import trainer.data.ArrowType;
   import trainer.view.NewHandContainer;
   
   public class ChurchProposeResponseFrame extends BaseAlerFrame
   {
       
      
      private var _spouseID:int;
      
      private var _spouseName:String;
      
      private var _love:String;
      
      private var _bg:MutipleImage;
      
      private var _loveTxt:TextArea;
      
      private var _answerId:int;
      
      private var _nameText:FilterFrameText;
      
      private var _btnLookEquip:TextButton;
      
      private var _alertInfo:AlertInfo;
      
      public function ChurchProposeResponseFrame()
      {
         super();
         this.initialize();
      }
      
      private function initialize() : void
      {
         this._alertInfo = new AlertInfo();
         this._alertInfo.title = LanguageMgr.GetTranslation("tank.view.common.church.ProposeResponseFrame.titleText");
         this._alertInfo.submitLabel = LanguageMgr.GetTranslation("accept");
         this._alertInfo.cancelLabel = LanguageMgr.GetTranslation("refuse");
         this._alertInfo.customPos = new Point(196,366);
         this._alertInfo.buttonGape = 80;
         this._alertInfo.moveEnable = false;
         info = this._alertInfo;
         this._bg = ComponentFactory.Instance.creatComponentByStylename("church.ProposeResponseAsset.bg");
         addToContent(this._bg);
         this._nameText = ComponentFactory.Instance.creat("common.church.txtChurchProposeResponseAsset.nameText");
         addToContent(this._nameText);
         this._btnLookEquip = ComponentFactory.Instance.creat("common.church.btnLookEquipAsset");
         this._btnLookEquip.text = LanguageMgr.GetTranslation("common.church.btnLookEquipAsset.text");
         this._btnLookEquip.addEventListener(MouseEvent.CLICK,this.__lookEquip);
         addToContent(this._btnLookEquip);
         this._loveTxt = ComponentFactory.Instance.creat("common.church.txtChurchProposeResponseMsgAsset");
         addToContent(this._loveTxt);
         addEventListener(FrameEvent.RESPONSE,this.onFrameResponse);
         NewHandContainer.Instance.clearArrowByID(ArrowType.CLICK_TASK);
         NewHandContainer.Instance.clearArrowByID(ArrowType.CLICK_BAG);
      }
      
      private function onFrameResponse(param1:FrameEvent) : void
      {
         switch(param1.responseCode)
         {
            case FrameEvent.CANCEL_CLICK:
            case FrameEvent.CLOSE_CLICK:
            case FrameEvent.ESC_CLICK:
               SoundManager.instance.play("008");
               ChurchManager.instance.resposeFrameCount -= 1;
               MainToolBar.Instance.tipTask();
               this.__cancel();
               break;
            case FrameEvent.ENTER_CLICK:
            case FrameEvent.SUBMIT_CLICK:
               SoundManager.instance.play("008");
               this.confirmSubmit();
         }
      }
      
      private function subNameString(param1:String) : String
      {
         var _loc2_:int = param1.length;
         var _loc3_:TextField = new TextField();
         _loc2_--;
         _loc3_.text = param1;
         while(_loc3_.textWidth > 90)
         {
            _loc2_--;
            _loc3_.text = param1.substring(0,_loc2_) + "..";
         }
         return _loc3_.text;
      }
      
      public function get answerId() : int
      {
         return this._answerId;
      }
      
      public function set answerId(param1:int) : void
      {
         this._answerId = param1;
      }
      
      public function get love() : String
      {
         return this._love;
      }
      
      public function set love(param1:String) : void
      {
         this._love = param1;
         this._loveTxt.text = Boolean(this._love) ? this._love : "";
      }
      
      public function get spouseName() : String
      {
         return this._spouseName;
      }
      
      public function set spouseName(param1:String) : void
      {
         this._spouseName = param1;
         this._nameText.text = this.subNameString(this._spouseName);
         var _loc2_:Point = ComponentFactory.Instance.creatCustomObject("ddt.churchProposeResponse.nameTxt.pos");
         this._nameText.x = _loc2_.x - this._nameText.textWidth;
         this._nameText.y = _loc2_.y;
      }
      
      public function get spouseID() : int
      {
         return this._spouseID;
      }
      
      public function set spouseID(param1:int) : void
      {
         this._spouseID = param1;
      }
      
      private function __lookEquip(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         PlayerInfoViewControl.viewByID(this.spouseID);
      }
      
      private function confirmSubmit() : void
      {
         SocketManager.Instance.out.sendProposeRespose(true,this.spouseID,this.answerId);
         this.dispose();
      }
      
      private function __cancel() : void
      {
         SocketManager.Instance.out.sendProposeRespose(false,this.spouseID,this.answerId);
         var _loc1_:String = StringHelper.rePlaceHtmlTextField(LanguageMgr.GetTranslation("tank.view.common.church.ProposeResponseFrame.msg",this.spouseName));
         ChatManager.Instance.sysChatRed(_loc1_);
         this.dispose();
      }
      
      public function show() : void
      {
         LayerManager.Instance.addToLayer(this,LayerManager.GAME_UI_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
      }
      
      override public function dispose() : void
      {
         super.dispose();
         removeEventListener(FrameEvent.RESPONSE,this.onFrameResponse);
         ObjectUtils.disposeObject(this._bg);
         this._bg = null;
         this._loveTxt = null;
         ObjectUtils.disposeObject(this._nameText);
         this._nameText = null;
         ObjectUtils.disposeObject(this._btnLookEquip);
         this._btnLookEquip = null;
         if(parent)
         {
            parent.removeChild(this);
         }
         dispatchEvent(new Event(Event.CLOSE));
      }
   }
}
