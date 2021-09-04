package consortion.transportSence
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.TextButton;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.MutipleImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import consortion.ConsortionModelControl;
   import consortion.TransportCarTip;
   import ddt.manager.LanguageMgr;
   import ddt.manager.SocketManager;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   
   public class CarImgContent extends Sprite implements Disposeable
   {
       
      
      private var _type:int;
      
      private var _tipData:Object;
      
      private var _BG:MutipleImage;
      
      private var _bgShine:MutipleImage;
      
      private var _summomTxt:FilterFrameText;
      
      private var _summomHighClassBtn:TextButton;
      
      private var _isSeleted:Boolean;
      
      private var _tip:TransportCarTip;
      
      private var _hasBuy:Boolean;
      
      public function CarImgContent(param1:int)
      {
         super();
         this._type = param1;
         this.initView();
         this.initEvent();
      }
      
      private function initView() : void
      {
         this._bgShine = ComponentFactory.Instance.creatComponentByStylename("TransportConfirm.car.view.shine");
         switch(this._type)
         {
            case TransportCar.CARI:
               this._hasBuy = true;
               this._BG = ComponentFactory.Instance.creatComponentByStylename("TransportConfirm.car.view.normal");
               addChild(this._BG);
               this._summomTxt = ComponentFactory.Instance.creatComponentByStylename("asset.transportConfirm.summomTxt");
               this._summomTxt.text = LanguageMgr.GetTranslation("consortion.ConsortionComfirm.summom.text");
               break;
            case TransportCar.CARII:
               this._hasBuy = false;
               this._BG = ComponentFactory.Instance.creatComponentByStylename("TransportConfirm.car.view.highClass");
               addChild(this._BG);
               this._summomHighClassBtn = ComponentFactory.Instance.creatComponentByStylename("TransportConfirm.summomHighClassCarBtn");
               this._summomHighClassBtn.text = LanguageMgr.GetTranslation("consortion.ConsortionComfirm.summomHigClassCar.text");
               addChild(this._summomHighClassBtn);
               this._summomHighClassBtn.addEventListener(MouseEvent.CLICK,this.__bugCar);
               this._summomTxt = ComponentFactory.Instance.creatComponentByStylename("asset.transportConfirm.summomTxt");
               this._summomTxt.text = LanguageMgr.GetTranslation("consortion.ConsortionComfirm.hasSummom.text");
               this._summomTxt.x = 82;
               this._summomTxt.y = 256;
               this._summomTxt.visible = false;
         }
         addChild(this._summomTxt);
         this._bgShine.visible = false;
         addChild(this._bgShine);
         this._tip = new TransportCarTip();
         this._tip.visible = false;
         this._tip.tipData = ConsortionModelControl.Instance.model.getCarCostString(this._type);
      }
      
      private function initEvent() : void
      {
         addEventListener(MouseEvent.MOUSE_OVER,this.__mouseOver);
         addEventListener(MouseEvent.MOUSE_OUT,this.__mouseOut);
      }
      
      private function removeEvent() : void
      {
         removeEventListener(MouseEvent.MOUSE_OVER,this.__mouseOver);
         removeEventListener(MouseEvent.MOUSE_OUT,this.__mouseOut);
         if(this._summomHighClassBtn)
         {
            this._summomHighClassBtn.removeEventListener(MouseEvent.CLICK,this.__bugCar);
         }
      }
      
      private function __mouseOver(param1:MouseEvent) : void
      {
         var _loc2_:Point = null;
         if(this._tip)
         {
            this._tip.visible = true;
            LayerManager.Instance.addToLayer(this._tip,LayerManager.GAME_TOP_LAYER);
            _loc2_ = this.localToGlobal(new Point(170,this.height - 75));
            this._tip.x = _loc2_.x;
            this._tip.y = _loc2_.y;
         }
      }
      
      private function __mouseOut(param1:MouseEvent) : void
      {
         if(this._tip)
         {
            this._tip.visible = false;
         }
      }
      
      private function __bugCar(param1:MouseEvent) : void
      {
         var _loc2_:TransportCarInfo = new TransportCarInfo(TransportCar.CARII);
         var _loc3_:BaseAlerFrame = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("tips"),LanguageMgr.GetTranslation("consortion.ConsortionComfirm.costMoneyTips.text",_loc2_.cost),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),false,true,false,LayerManager.BLCAK_BLOCKGOUND);
         _loc3_.moveEnable = false;
         _loc3_.addEventListener(FrameEvent.RESPONSE,this.__confirmResponse);
      }
      
      private function __confirmResponse(param1:FrameEvent) : void
      {
         var _loc2_:BaseAlerFrame = param1.currentTarget as BaseAlerFrame;
         _loc2_.removeEventListener(FrameEvent.RESPONSE,this.__confirmResponse);
         if(param1.responseCode == FrameEvent.ENTER_CLICK || param1.responseCode == FrameEvent.SUBMIT_CLICK)
         {
            SocketManager.Instance.out.SendBuyCar(TransportCar.CARII);
         }
         ObjectUtils.disposeObject(_loc2_);
      }
      
      public function get isSeleted() : Boolean
      {
         return this._isSeleted;
      }
      
      public function set isSeleted(param1:Boolean) : void
      {
         this._isSeleted = param1;
         if(this._isSeleted)
         {
            this._bgShine.visible = true;
         }
         else
         {
            this._bgShine.visible = false;
         }
      }
      
      public function get hasBuy() : Boolean
      {
         return this._hasBuy;
      }
      
      public function set hasBuy(param1:Boolean) : void
      {
         this._hasBuy = param1;
         if(this._hasBuy)
         {
            if(this._summomHighClassBtn)
            {
               this._summomHighClassBtn.removeEventListener(MouseEvent.CLICK,this.__bugCar);
               removeChild(this._summomHighClassBtn);
               this._summomHighClassBtn = null;
               this._summomTxt.visible = true;
            }
         }
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         ObjectUtils.disposeObject(this._tipData);
         this._tipData = null;
         ObjectUtils.disposeObject(this._BG);
         this._BG = null;
         ObjectUtils.disposeObject(this._bgShine);
         this._bgShine = null;
         ObjectUtils.disposeObject(this._summomTxt);
         this._summomTxt = null;
         ObjectUtils.disposeObject(this._summomHighClassBtn);
         this._summomHighClassBtn = null;
         ObjectUtils.disposeObject(this._tip);
         this._tip = null;
      }
   }
}
