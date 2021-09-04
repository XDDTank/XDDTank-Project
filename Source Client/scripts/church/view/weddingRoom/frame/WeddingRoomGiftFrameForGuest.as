package church.view.weddingRoom.frame
{
   import church.controller.ChurchRoomController;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.image.Scale9CornerImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.ui.vo.AlertInfo;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import ddt.manager.PlayerManager;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import flash.display.Bitmap;
   import flash.events.Event;
   import flash.events.FocusEvent;
   import flash.events.KeyboardEvent;
   import flash.ui.Keyboard;
   
   public class WeddingRoomGiftFrameForGuest extends BaseAlerFrame
   {
      
      public static const RESTRICT:String = "0-9";
      
      public static const DEFAULT:String = "100";
      
      private static const LEAST_MONEY:int = 100;
       
      
      private var _controller:ChurchRoomController;
      
      private var _bg:Bitmap;
      
      private var _alertInfo:AlertInfo;
      
      private var _txtMoney:FilterFrameText;
      
      private var _alertConfirm:BaseAlerFrame;
      
      private var _contentText:FilterFrameText;
      
      private var _money:FilterFrameText;
      
      private var _noticeText:FilterFrameText;
      
      private var _inputBG:Scale9CornerImage;
      
      public function WeddingRoomGiftFrameForGuest()
      {
         super();
         this.initialize();
      }
      
      public function get controller() : ChurchRoomController
      {
         return this._controller;
      }
      
      public function set controller(param1:ChurchRoomController) : void
      {
         this._controller = param1;
      }
      
      protected function initialize() : void
      {
         this.setView();
         this.setEvent();
      }
      
      private function setView() : void
      {
         cancelButtonStyle = "core.simplebt";
         submitButtonStyle = "core.simplebt";
         this._alertInfo = new AlertInfo();
         this._alertInfo.moveEnable = false;
         this._alertInfo.title = LanguageMgr.GetTranslation("church.room.giftFrameBgAssetForGuest.titleText");
         info = this._alertInfo;
         this.escEnable = true;
         this._bg = ComponentFactory.Instance.creatBitmap("asset.church.room.giftFrameBgAssetForGuest");
         PositionUtils.setPos(this._bg,"asset.church.room.giftFrameBgAssetForGuest.pos");
         addToContent(this._bg);
         this._contentText = ComponentFactory.Instance.creat("church.room.frame.WeddingRoomGiftFrameForGuest.contentText");
         this._contentText.text = LanguageMgr.GetTranslation("church.room.frame.WeddingRoomGiftFrameForGuest.contentText");
         addToContent(this._contentText);
         this._inputBG = ComponentFactory.Instance.creatComponentByStylename("church.room.frame.WeddingRoomGiftFrameForGuest.moneyText.InputBG");
         addToContent(this._inputBG);
         this._money = ComponentFactory.Instance.creat("church.room.frame.WeddingRoomGiftFrameForGuest.moneyText");
         this._money.text = LanguageMgr.GetTranslation("money");
         addToContent(this._money);
         this._noticeText = ComponentFactory.Instance.creat("church.room.frame.WeddingRoomGiftFrameForGuest.noticeText");
         this._noticeText.text = LanguageMgr.GetTranslation("church.room.frame.WeddingRoomGiftFrameForGuest.noticeText",LEAST_MONEY);
         addToContent(this._noticeText);
         this._txtMoney = ComponentFactory.Instance.creat("church.weddingRoom.frame.WeddingRoomGiftFrameMoneyTextAssetForGuest");
         this._txtMoney.maxChars = 8;
         this._txtMoney.restrict = RESTRICT;
         this._txtMoney.text = DEFAULT;
         addToContent(this._txtMoney);
      }
      
      private function setEvent() : void
      {
         addEventListener(FrameEvent.RESPONSE,this.onFrameResponse);
         this._txtMoney.addEventListener(FocusEvent.MOUSE_FOCUS_CHANGE,this.__focusOut);
         this._txtMoney.addEventListener(KeyboardEvent.KEY_DOWN,this.__keyDown);
      }
      
      private function __keyDown(param1:KeyboardEvent) : void
      {
         if(param1.keyCode == Keyboard.ENTER)
         {
            param1.stopImmediatePropagation();
            SoundManager.instance.play("008");
            this.confirmSubmit();
         }
      }
      
      private function __focusOut(param1:FocusEvent) : void
      {
         this.checkMoney();
      }
      
      private function checkMoney() : void
      {
         var _loc1_:uint = Math.floor(PlayerManager.Instance.Self.Money / LEAST_MONEY);
         var _loc2_:uint = Math.ceil(Number(this._txtMoney.text) / LEAST_MONEY) == 0 ? uint(1) : uint(Math.ceil(Number(this._txtMoney.text) / LEAST_MONEY));
         if(_loc2_ >= _loc1_)
         {
            _loc2_ = _loc1_;
         }
         this._txtMoney.text = String(_loc2_ * LEAST_MONEY);
      }
      
      private function onFrameResponse(param1:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         switch(param1.responseCode)
         {
            case FrameEvent.CANCEL_CLICK:
            case FrameEvent.CLOSE_CLICK:
            case FrameEvent.ESC_CLICK:
               this.dispose();
               break;
            case FrameEvent.ENTER_CLICK:
            case FrameEvent.SUBMIT_CLICK:
               this.confirmSubmit();
         }
      }
      
      private function confirmSubmit() : void
      {
         this.checkMoney();
         this._alertConfirm = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("tank.consortia.myconsortia.frame.MyConsortiaTax.info"),LanguageMgr.GetTranslation("church.churchScene.frame.PresentFrame.confirm") + this._txtMoney.text + LanguageMgr.GetTranslation("tank.view.emailII.EmailIIDiamondView.money"),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),false,false,false,LayerManager.ALPHA_BLOCKGOUND);
         this._alertConfirm.addEventListener(FrameEvent.RESPONSE,this.confirm);
      }
      
      private function confirm(param1:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         switch(param1.responseCode)
         {
            case FrameEvent.CANCEL_CLICK:
            case FrameEvent.CLOSE_CLICK:
            case FrameEvent.ESC_CLICK:
               ObjectUtils.disposeObject(param1.target);
               break;
            case FrameEvent.ENTER_CLICK:
            case FrameEvent.SUBMIT_CLICK:
               this._controller.giftSubmit(uint(this._txtMoney.text));
               this.dispose();
         }
      }
      
      public function show() : void
      {
         LayerManager.Instance.addToLayer(this,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
      }
      
      private function removeView() : void
      {
         this._alertInfo = null;
         if(this._bg)
         {
            if(this._bg.parent)
            {
               this._bg.parent.removeChild(this._bg);
            }
            this._bg.bitmapData.dispose();
            this._bg.bitmapData = null;
         }
         this._bg = null;
         if(this._contentText)
         {
            if(this._contentText.parent)
            {
               this._contentText.parent.removeChild(this._contentText);
            }
            this._contentText.dispose();
         }
         this._contentText = null;
         if(this._inputBG)
         {
            if(this._inputBG.parent)
            {
               this._inputBG.parent.removeChild(this._inputBG);
            }
            this._inputBG.dispose();
         }
         this._inputBG = null;
         if(this._money)
         {
            if(this._money.parent)
            {
               this._money.parent.removeChild(this._money);
            }
            this._money.dispose();
         }
         this._money = null;
         if(this._noticeText)
         {
            if(this._noticeText.parent)
            {
               this._noticeText.parent.removeChild(this._noticeText);
            }
            this._noticeText.dispose();
         }
         this._noticeText = null;
         if(this._txtMoney)
         {
            if(this._txtMoney.parent)
            {
               this._txtMoney.parent.removeChild(this._txtMoney);
            }
            this._txtMoney.dispose();
         }
         this._txtMoney = null;
         if(this._alertConfirm)
         {
            if(this._alertConfirm.parent)
            {
               this._alertConfirm.parent.removeChild(this._alertConfirm);
            }
            this._alertConfirm.dispose();
         }
         this._alertConfirm = null;
         if(this.parent)
         {
            this.parent.removeChild(this);
         }
         dispatchEvent(new Event(Event.CLOSE));
      }
      
      private function removeEvent() : void
      {
         removeEventListener(FrameEvent.RESPONSE,this.onFrameResponse);
         if(this._txtMoney)
         {
            this._txtMoney.removeEventListener(FocusEvent.MOUSE_FOCUS_CHANGE,this.__focusOut);
         }
         if(this._alertConfirm)
         {
            this._alertConfirm.removeEventListener(FrameEvent.RESPONSE,this.confirm);
         }
      }
      
      override public function dispose() : void
      {
         super.dispose();
         this.removeEvent();
         this.removeView();
      }
   }
}
