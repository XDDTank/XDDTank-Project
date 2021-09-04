package consortion.view.selfConsortia
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.controls.TextButton;
   import com.pickgliss.ui.core.Component;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import consortion.ConsortionModelControl;
   import consortion.event.ConsortionEvent;
   import ddt.data.ConsortiaDutyType;
   import ddt.events.PlayerPropertyEvent;
   import ddt.manager.ConsortiaDutyManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.PlayerManager;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import flash.display.Bitmap;
   import flash.events.MouseEvent;
   
   public class SelfDonateView extends Component implements Disposeable
   {
       
      
      private var _donateAsset:Bitmap;
      
      private var _donateBtn:BaseButton;
      
      private var _mydonateTxt:FilterFrameText;
      
      private var _extBtn:TextButton;
      
      public function SelfDonateView()
      {
         super();
         this.initView();
         this.initEvent();
      }
      
      private function initView() : void
      {
         this._donateAsset = ComponentFactory.Instance.creatBitmap("asset.consortion.Mydonate");
         this._donateBtn = ComponentFactory.Instance.creatComponentByStylename("ddtconsortion.donateBtn");
         this._mydonateTxt = ComponentFactory.Instance.creatComponentByStylename("ddtconsortion.donateText");
         this._mydonateTxt.text = String(PlayerManager.Instance.Self.RichesOffer);
         this._extBtn = ComponentFactory.Instance.creatComponentByStylename("buildingManager.exit");
         this._extBtn.text = LanguageMgr.GetTranslation("consortia.BuildingManager.BtnText4");
         PositionUtils.setPos(this._extBtn,"asset.extBtn.pos");
         addChild(this._donateAsset);
         addChild(this._donateBtn);
         addChild(this._mydonateTxt);
         addChild(this._extBtn);
         this.initRight();
      }
      
      private function initRight() : void
      {
         var _loc1_:int = PlayerManager.Instance.Self.Right;
         this._extBtn.visible = !ConsortiaDutyManager.GetRight(_loc1_,ConsortiaDutyType._13_Exit);
      }
      
      private function initEvent() : void
      {
         this._donateBtn.addEventListener(MouseEvent.CLICK,this.__mouseClickHandler);
         this._extBtn.addEventListener(MouseEvent.CLICK,this.__ext);
         PlayerManager.Instance.Self.addEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,this.__offerChangeHandler);
         ConsortionModelControl.Instance.addEventListener(ConsortionEvent.CHARMAN_CHANGE,this.__charmanChange);
      }
      
      private function __charmanChange(param1:ConsortionEvent) : void
      {
         this.initRight();
      }
      
      private function removeEvent() : void
      {
         this._donateBtn.removeEventListener(MouseEvent.CLICK,this.__mouseClickHandler);
         this._extBtn.removeEventListener(MouseEvent.CLICK,this.__ext);
         PlayerManager.Instance.Self.removeEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,this.__offerChangeHandler);
         ConsortionModelControl.Instance.removeEventListener(ConsortionEvent.CHARMAN_CHANGE,this.__charmanChange);
      }
      
      private function __offerChangeHandler(param1:PlayerPropertyEvent) : void
      {
         if(param1.changedProperties["RichesRob"] || param1.changedProperties["RichesOffer"])
         {
            this._mydonateTxt.text = String(PlayerManager.Instance.Self.RichesOffer);
         }
      }
      
      private function __mouseClickHandler(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         ConsortionModelControl.Instance.alertTaxFrame();
      }
      
      private function __ext(param1:MouseEvent) : void
      {
         ConsortionModelControl.Instance.alertQuitFrame();
      }
      
      override public function dispose() : void
      {
         this.removeEvent();
         if(this._donateAsset)
         {
            ObjectUtils.disposeObject(this._donateAsset);
         }
         this._donateAsset = null;
         if(this._donateBtn)
         {
            ObjectUtils.disposeObject(this._donateBtn);
         }
         this._donateBtn = null;
         if(this._mydonateTxt)
         {
            ObjectUtils.disposeObject(this._mydonateTxt);
         }
         this._mydonateTxt = null;
         if(this._extBtn)
         {
            ObjectUtils.disposeObject(this._extBtn);
         }
         this._extBtn = null;
         if(this.parent)
         {
            this.parent.removeChild(this);
         }
      }
   }
}
